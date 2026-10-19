class_name HoldHotbar
extends Control
# Slots reference the carried pack; they never own or duplicate resources.
const DEFAULTS=["tool:0","tool:1","tool:2","tool:3","slagcaster","wood","stone","food","water","crystal"]
var g
var item=""
var blocked=false
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE
func data()->Dictionary:
 g.surface.ensure()
 if not g.state.surface.has("hotbar"):g.state.surface.hotbar={"slots":DEFAULTS.duplicate(),"selected":0}
 var d=g.state.surface.hotbar
 if not d.get("slots",[]) is Array or d.slots.size()!=10:d.slots=DEFAULTS.duplicate()
 return d
func restore():select(clampi(int(data().get("selected",0)),0,9),false)
func available()->bool:return g.playing and g.panel_id=="" and not is_instance_valid(g.creator) and not is_instance_valid(g.opening_scene) and not is_instance_valid(g.anniversary_scene)
func bar_y()->float:return 80.0 if (g.player-g.camera).y>430 else 414.0
func slot_rect(i:int)->Rect2:return Rect2(230+i*50,bar_y()+24,46,51)
func over()->bool:return available() and Rect2(224,bar_y(),512,80).has_point(g.get_global_mouse_position())
func blocked_work()->bool:return item!="" or blocked or over() or not g.handworks.data().carry.is_empty() or g.handworks.working or g.handworks.placing!="" or g.fieldwork.placing or g.fieldwork.action!="" or not g.handworks.setting_down.is_empty()
func title(id:String)->String:
 if id.begins_with("tool:"):return g.TOOL_NAMES[clampi(int(id.get_slice(":",1)),0,3)]
 if id=="slagcaster":return "Slagcaster"
 return str(HoldData.ITEMS.get(id,{"name":"Empty"}).name)
func selected()->int:
 if item!="":return int(data().selected)
 return 4 if g.mining_gun.selected else clampi(g.tool,0,3)
func select(i:int,announce:bool=true):
 var id=str(data().slots[i])
 if id=="slagcaster" and not g.state.outpost.get("mining_gun",false):
  if announce:g.notify("Slagcaster locked · fabricate one at a powered forge.")
  return
 item="";g.mining_gun.selected=false;g.combat.armed=false;g.combat.reset_actions();g.construction.selected="";g.surface.placing="";g.surface.cut_target=-1;g.surface.cut_clock=0
 g.swing=0;g.mining_buffer=0;g.impact_pause=0
 if g.deep.world!=null:g.deep.strike_left=0;g.deep.works.cancel()
 if id.begins_with("tool:"):g.tool=clampi(int(id.get_slice(":",1)),0,3)
 elif id=="slagcaster":g.mining_gun.selected=true
 else:item=id
 data().selected=i
 queue_redraw()
func handle(e:InputEvent)->bool:
 if not available():return false
 if e is InputEventKey and e.pressed and not e.echo:
  var keys=[KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0]
  var k=e.physical_keycode if e.physical_keycode!=0 else e.keycode
  if k in keys:select(keys.find(k));return true
 if e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_LEFT:
  if not e.pressed:blocked=false;return false
  if over():
   blocked=true
   for i in 10:
    if slot_rect(i).has_point(g.get_global_mouse_position()):select(i)
   return true
  if item!="":
   g.notify(title(item)+" · "+("Pack empty. Gather or withdraw this item." if g.state.count(item)==0 else "Carried supply · use at a workstation, chest or trade counter. Select 1–4 to work."));return true
 return false
func assign(id:String,i:int):
 data().slots[i]=id
 if int(data().selected)==i:select(i,false)
 g.save_game();g.notify(title(id)+" assigned to "+str((i+1)%10)+".")
func _process(_dt):
 if not is_instance_valid(g):return
 visible=available();queue_redraw()
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):blocked=false
func _draw():
 if not visible:return
 var d=data();var current=selected();var id=str(d.slots[current])
 var box=StyleBoxFlat.new();box.bg_color=Color(.04,.09,.12,.95);box.border_color=Color("8c7953");box.set_border_width_all(1);box.set_corner_radius_all(7)
 draw_style_box(box,Rect2(224,bar_y(),512,80))
 var text=("Weapon · "+g.combat.weapon().name) if g.combat.armed else "Holding · "+title(id)
 if g.combat.armed and g.state.combat.weapon=="gun":text+=" · %d cartridges" % g.state.count("ammo")
 elif not g.combat.armed and id=="slagcaster":text+=" · %d charge" % int(g.state.outpost.get("gun_charge",0))
 elif not g.combat.armed and not id.begins_with("tool:"):text+=" · %d in pack" % g.state.count(id)
 var held=g.handworks.held_label()
 if held!="":text=held
 if g.fieldwork.action!="":text=g.fieldwork.held_label()
 draw_string(ThemeDB.fallback_font,Vector2(238,bar_y()+17),text,HORIZONTAL_ALIGNMENT_LEFT,480,13,Color("ead6ab"))
 for i in 10:
  var r=slot_rect(i);var key=str(d.slots[i]);var chosen=i==current and not g.combat.armed
  var locked=key=="slagcaster" and not g.state.outpost.get("mining_gun",false)
  var resource=not key.begins_with("tool:") and key!="slagcaster"
  var empty=resource and g.state.count(key)==0
  box.bg_color=Color("3c615e") if chosen else Color("172e38");box.border_color=Color("f1cb7d") if chosen else Color("54645e");box.set_border_width_all(2 if chosen else 1);box.set_corner_radius_all(4);draw_style_box(box,r)
  var index=int(key.get_slice(":",1)) if key.begins_with("tool:") else (9 if key=="slagcaster" else HoldItemArt.item_index(key))
  var color=HoldItemArt.tint(key);color.a=.28 if locked or empty else 1.0
  HoldItemArt.draw(self,Rect2(r.position+Vector2(9,8),Vector2(29,31)),index,color)
  draw_string(ThemeDB.fallback_font,r.position+Vector2(4,13),str((i+1)%10),HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("f0deba"))
  var count="LOCK" if locked else (str(g.state.count(key)) if resource else "")
  draw_string(ThemeDB.fallback_font,r.position+Vector2(3,46),count,HORIZONTAL_ALIGNMENT_RIGHT,39,11,Color("cdded4"))
func held(n:Node2D,p:Vector2,reset:Vector2):
 if g.handworks.busy_hands() or g.fieldwork.action!="":return
 if item=="":
  if g.mining_gun.selected:return
  var direction=g.surface.direction
  var scale=g.character_scale()
  var hand=p+HoldDrawnAnimation.grip(g.state.appearance,direction,g.gait_clock,g.walking_pose,scale)
  HoldCharacterArt.draw_tool(n,hand+reset,hand+reset+Vector2((-10 if direction.x<-.3 else 10),-23)*scale,g.tool,reset,(-1 if direction.x<-.3 else 1),-1,scale*.8)
  n.draw_set_transform(reset)
  HoldDrawnAnimation.grip_foreground(n,p,g.state.appearance,direction,g.gait_clock,scale,reset,g.walking_pose)
  return
 if g.state.count(item)<=0:return
 HoldItemArt.draw(n,Rect2(p+Vector2(-10,-40),Vector2(20,20)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
 n.draw_set_transform(reset)
