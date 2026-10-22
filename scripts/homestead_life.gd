class_name HoldHomesteadLife
extends RefCounted
# Optional field work uses the same pack, clock, save, trade and production queue.
const PROPS=preload("res://assets/animation-v51/homestead-props.png")
const TOOLS=preload("res://assets/animation-v51/field-tools.png")
const BANK=Vector2(1130,550)
const GROW_TIME=180.0
var g
var placing=false
var action=""
var elapsed=0.0
var bed_id=-1
var origin=Vector2.ZERO
var cast_area=""
var completed_contact=false
var moving=false
var waypoints:Array=[]
func _init(game):g=game
func data()->Dictionary:
 g.surface.ensure()
 if not g.state.surface.has("fieldwork"):g.state.surface.fieldwork={"version":1,"kit":false,"beds":[],"next":1,"facts":{},"catches":0,"harvests":0}
 return g.state.surface.fieldwork
func local(b:Dictionary)->bool:return g.surface.active() and g.surface.area=="claim" and g.surface.house.level()==0 and b.claim==g.state.claim_id
func pos(b:Dictionary)->Vector2:return Vector2(b.x,b.y)
func bed()->Dictionary:
 for b in data().beds:
  if int(b.id)==bed_id and local(b):return b
 return {}
func near_bed()->Dictionary:
 var found={};var distance=80.0
 for b in data().beds:
  if local(b) and pos(b).distance_to(g.player)<distance and g.surface.clear_interaction(g.player,pos(b)):
   distance=pos(b).distance_to(g.player);found=b
 return found
func near_water()->bool:return g.surface.active() and g.surface.area=="trail" and g.player.distance_to(BANK)<65
func ripe(b:Dictionary)->bool:return bool(b.get("watered",false)) and g.state.elapsed-float(b.get("at",0))>=GROW_TIME
func craft_kit()->bool:
 if data().kit:return false
 if not g.state.pay({"wood":3,"iron":1}):g.notify("Bring 3 timber and 1 iron ingot for your field tools.");return false
 data().kit=true;data().facts.tools=true;g.state.add("turnip_seed",4);g.save_game();return true
func build(p:Vector2)->bool:
 if g.surface.area!="claim" or g.surface.house.level()!=0 or not data().kit:return false
 p=(p/20).round()*20
 if not g.handworks.can_place(p):g.notify("Choose clear claim ground within reach, away from paths and buildings.");return false
 for b in data().beds:
  if local(b) and pos(b).distance_to(p)<100:return false
 if not g.state.pay({"wood":3,"stone":1}):g.notify("Bring 3 timber and 1 stone for a garden bed.");return false
 data().beds.append({"id":int(data().next),"claim":g.state.claim_id,"x":p.x,"y":p.y,"planted":false,"watered":false,"at":0.0});data().next=int(data().next)+1
 data().facts.bed=true;placing=false;g.sound.effect("build");g.save_game();return true
func start(kind:String,b:Dictionary={}):
 action=kind;elapsed=0;origin=g.player;cast_area=g.surface.area;bed_id=int(b.get("id",-1));completed_contact=false
 waypoints.clear();moving=false
 if not b.is_empty():
  var side=-1 if g.player.x<=b.x else 1
  if g.player.y>b.y-5:waypoints.append(pos(b)+Vector2(side*65,40))
  waypoints.append(pos(b)+Vector2(side*65,-18))
 g.surface.direction=Vector2.RIGHT if b.is_empty() else (pos(b)-g.player).normalized()
func cancel():action="";elapsed=0;bed_id=-1;moving=false;waypoints.clear()
func input(e:InputEvent)->bool:
 if not g.playing or not g.surface.active() or g.panel_id!="":return false
 if e is InputEventMouseButton and e.pressed and placing:
  if e.button_index==MOUSE_BUTTON_RIGHT:placing=false;return true
  if e.button_index==MOUSE_BUTTON_LEFT and not g.hotbar.over():build(g.get_global_mouse_position()+g.camera);return true
 if not e is InputEventKey or not e.pressed or e.echo or e.keycode!=KEY_E or e.shift_pressed:return false
 if action!="":return true
 var b=near_bed()
 if b.is_empty() and not near_water():return false
 if not data().kit:g.open_panel("fieldwork");return true
 if g.handworks.busy_hands():g.notify("Set down your load or park the cart before field work.");return true
 if near_water():start("fish");g.sound.effect("water",-18);return true
 if ripe(b):start("harvest",b)
 elif not b.planted:
  if g.state.count("turnip_seed")<1:g.notify("No seed in your pack. Orla sells turnip seeds; harvests return seed.")
  else:start("hoe",b)
 elif not b.watered:
  if g.state.count("water")<1:g.notify("Bring one water from your pack to water this bed.")
  else:start("water",b)
 else:g.notify("Growing · %d seconds of world time to harvest. Go work; the crop needs no more tending." % ceili(maxf(0,GROW_TIME-(g.state.elapsed-float(b.at)))))
 return true
func update(dt:float):
 data()
 if action=="":return
 if not g.surface.active() or g.surface.area!=cast_area or Input.get_vector("left","right","up","down")!=Vector2.ZERO or g.panel_id!="" or g.handworks.busy_hands():cancel();return
 moving=false
 if not waypoints.is_empty():
  var target:Vector2=waypoints[0];var next=g.player.move_toward(target,185*dt)
  if not g.surface.walkable(next):cancel();g.notify("Keep a clear working space beside your garden bed.");return
  g.surface.direction=(target-g.player).normalized();HoldDrawnLocomotion.advance(g,g.player.distance_to(next),"stone");g.player=next;g.walking_pose=true;moving=true
  if g.player.distance_to(target)<2:waypoints.pop_front()
  return
 if bed_id>=0:
  var current=bed()
  if not current.is_empty():g.surface.direction=Vector2(1 if g.player.x<current.x else -1,0)
 elapsed+=dt
 if action=="fish":
  if elapsed<3.8:return
  if Input.is_action_pressed("interact"):
   if elapsed>=4.7:
    var count=2 if int(data().catches)%4==3 else 1
    if HoldDisciplines.has(g.state,"river_lore") and int(data().catches)%3==2:count+=1
    HoldDisciplines.award(g.state,"fishing")
    g.state.add("river_fish",count);data().catches=int(data().catches)+1;data().facts.fish=true
    g.sound.effect("water",-12);g.notify("River trout ×%d · sell at Orla's or cook provisions at the forge." % count);reward();g.save_game();cancel()
  else:elapsed=3.8
  return
 var b=bed()
 if b.is_empty():cancel();return
 if elapsed>=.4 and not completed_contact:
  completed_contact=true
  if action=="hoe" and not b.planted and g.state.pay({"turnip_seed":1}):b.planted=true;data().facts.plant=true;g.sound.effect("wood",-18)
  elif action=="water" and b.planted and not b.watered and g.state.pay({"water":1}):b.watered=true;b.at=g.state.elapsed;data().facts.water=true;g.sound.effect("water",-17)
  elif action=="harvest" and ripe(b):
   HoldDisciplines.award(g.state,"farming");g.state.add("turnip",(3 if int(data().harvests)>=8 else 2)+(1 if HoldDisciplines.has(g.state,"seed_selection") else 0));g.state.add("turnip_seed",1);data().harvests=int(data().harvests)+1;data().facts.harvest=true
   b.planted=false;b.watered=false;g.sound.effect("build",-20);g.notify("Turnips harvested · seed saved for the next crop. Eight harvests improve the yield.")
  reward();g.save_game()
 if elapsed>=.8:cancel()
func reward():
 var f=data().facts
 if f.get("harvest",false) and f.get("fish",false) and not f.get("reward",false):
  f.reward=true;g.state.add("food",3);g.notify("River & Root complete · three provisions for your Folk. Your first harvest and catch will feed the hold.")
func animation_phase()->float:
 if action!="fish":return clampf(elapsed/.8,0,1)
 if elapsed<.22:return 0
 if elapsed<.5:return 1
 return 2 if elapsed<3.8 else 3
func held_label()->String:
 if action=="":return ""
 return {"hoe":"Planting · Garden hoe","water":"Watering · Copper can","harvest":"Harvesting · Turnips","fish":"Fishing · Rod · "+("Hold E to reel" if elapsed>=3.8 else "Waiting for a bite")}.get(action,"")
func objects()->Array:
 var result=[]
 for b in data().beds:
  if local(b):result.append({"kind":"garden","p":pos(b),"bed":b})
 return result
func obstacles()->Array:
 var result=[]
 for b in data().beds:
  if local(b):result.append(Rect2(pos(b)-Vector2(35,25),Vector2(70,28)))
 return result
func sprite(index:int,p:Vector2,width:float,alpha:float=1):
 var r=HoldDrawnAnimation.bounds("homestead-props",index);var h=width*r.size.y/r.size.x
 g.draw_texture_rect_region(PROPS,Rect2(p-Vector2(width/2,h),Vector2(width,h)),Rect2(r),Color(1,1,1,alpha))
func draw_bed(b:Dictionary):
 var i=5 if ripe(b) else 4 if b.planted else 3
 sprite(i,pos(b),86)
 if b.watered and not ripe(b):g.draw_arc(pos(b)+Vector2(0,-8),4,-PI/2,TAU*clampf((g.state.elapsed-b.at)/GROW_TIME,0,1)-PI/2,16,Color("8dd5c2"),2)
func draw():
 if not g.surface.active():return
 var cam=g.camera.round();g.draw_set_transform(-cam)
 if placing:sprite(3,g.get_global_mouse_position()+g.camera,86,.5)
 if g.surface.area=="trail":
  # The float sits in the same river whose banks and bridge govern movement.
  var float_at=Vector2(1205,546)
  for i in 3:g.draw_arc(float_at,7+i*9+fmod(g.clock*5,9),0,TAU,24,Color(.6,.83,.83,.2-i*.04),1)
  if action=="fish":
   float_at.y+=sin(g.clock*6)*(3 if elapsed<3.8 else 7)
   var tip=HoldWholeFrames.tool_tip(g.state.appearance,g.surface.direction,"fish",animation_phase())
   g.draw_line(origin+tip*.85,float_at,Color(.86,.87,.72,.65),.8)
   g.draw_circle(float_at,3,Color("e9dab5"));g.draw_line(float_at+Vector2(0,-4),float_at,Color("cc6852"),2)
  if near_water():g.surface.plaque(BANK+Vector2(-38,-100),"Hold E · Fish" if data().kit else "E · River & Root")
 var b=near_bed()
 if not b.is_empty() and action=="":g.surface.plaque(pos(b)+Vector2(0,-62),"E · Harvest" if ripe(b) else "E · Plant" if not b.planted else "E · Water" if not b.watered else "Growing")
 g.draw_set_transform(Vector2.ZERO)
func panel():
 var d=data()
 g.label(g.panel_body,"A little honest work for a well-fed hold. No stamina cost, no missed-bite penalty.",16)
 if not d.kit:
  g.label(g.panel_body,"Make a rod, hoe and watering can · 3 timber + 1 iron ingot. Includes four turnip seeds.",16)
  g.button(g.panel_body,"Craft your field tools",func():craft_kit();g.open_panel("fieldwork",false))
 else:
  g.label(g.panel_body,"Field tools ready · E equips the right tool when you stand beside a garden bed or the river fishing spot.",15)
  g.button(g.panel_body,"Craft & place garden bed · 3 timber + 1 stone",func():
   if g.surface.area!="claim" or g.surface.house.level()!=0:g.notify("Build garden beds on the ground of your own claim.");return
   placing=true;g.close_panel();g.notify("Choose clear claim ground nearby. LMB places; right click cancels."))
 var tools_row=g.row(g.panel_body)
 for i in [1,2,3]:
  var icon=TextureRect.new();var tex=AtlasTexture.new();tex.atlas=TOOLS;tex.region=Rect2(HoldDrawnAnimation.bounds("field-tools",i));icon.texture=tex;icon.custom_minimum_size=Vector2(50,44);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tools_row.add_child(icon)
 g.label(g.panel_body,"Garden · E plants a seed. E waters with one carried water. Harvest after 3 minutes of world time; crops never wither and return seed.",14)
 g.label(g.panel_body,"River · Walk east from King's Gate to the bank north of the bridge. Hold E to cast, wait and reel; walk away to cancel.",14)
 g.label(g.panel_body,"For your Folk · Sell at Orla's or cook trout / turnip provisions in Borin's Crafting tab. Eight harvests improve crop yield.",14)
 var lesson=GridContainer.new();lesson.columns=2;lesson.add_theme_constant_override("h_separation",20);g.panel_body.add_child(lesson)
 for step in [["tools","Craft your field tools"],["bed","Build a garden bed at your claim"],["plant","Plant a turnip seed"],["water","Water the planted bed"],["harvest","Bring in your first harvest"],["fish","Catch a river trout"]]:g.label(lesson,("✓ " if d.facts.get(step[0],false) else "○ ")+step[1],15,Color("9bd6c0") if d.facts.get(step[0],false) else Color("d3c7ac"))
 g.label(g.panel_body,"First harvest + first catch: 3 provisions for your Folk, once.",14)
