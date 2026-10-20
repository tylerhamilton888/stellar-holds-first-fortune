class_name HoldDistrictMap
extends Node2D
# The hold is an addressable graph of galleries, stairs and lift landings.
# Local rooms retain their existing state. This graph can later be generated
# from a hold plan without changing the navigation or save contract.
const GALLERIES=preload("res://assets/hold-v34/galleries.webp")
const XS=[85.0,205.0,325.0,455.0,585.0,715.0,865.0]
const YS=[155.0,285.0,415.0]
const NAMES=["CROWNWARD", "HEARTHWARD", "FORGEWARD"]
const DOORS={
 1:{"id":"throne","name":"King's hall","npc":"eirik","detail":"The high vault. A royal audience requires Ivar's reference."},
 4:{"id":"research","name":"Survey office","npc":"eldric","detail":"Eldric's charts, methods and mountain charters."},
 7:{"id":"home","name":"Your quarters","npc":"","detail":"A borrowed room among the hearths of Keldrath."},
 8:{"id":"tavern","name":"Copper Kettle","npc":"hedrik","detail":"Hedrik, hot supper and the hiring bench."},
 9:{"id":"market","name":"The exchange","npc":"orla","detail":"Orla's counter. Trade, freight and news from the road."},
 10:{"id":"concourse","name":"Main concourse","npc":"","detail":"Walk the familiar street, meet visitors and see the anniversary gifts."},
 12:{"id":"commission","name":"Foreman's office","npc":"ivar","detail":"Ivar keeps the shift book here. Introductions, wages and commissions."},
 13:{"id":"gate","name":"Expedition table","npc":"","detail":"Plan a journey through the basin to Pinewood or the Old Workings."},
 15:{"id":"forge","name":"Borin's forge","npc":"borin","detail":"Tools, armor, smelting and the hold's industrial upgrades."},
 17:{"id":"training","name":"Practice bay","npc":"","detail":"Ask Borin for Keep your feet before entering the practice bay."}}
var g
var paused=false
var survey=false
var overview=false
var at=10
var toward=-1
var progress=0.0
var clock=0.0
var gait=0.0
var face=1
var walking=false
var foot_clock=0.0
var autosave=0.0
var edges:Array=[]
var info:Label
var enter_button:Button
var pause_button:Button
var quit_button:Button
var marks:Dictionary={}
var destination=-1
var route:Array=[]
var floor_view=true
var level=1
var floor_pos=Vector2.ZERO
var floor_camera=Vector2.ZERO
var view_button:Button
var map_plaque:StyleBoxFlat
var heading:Label
var lift_choice:PanelContainer
func _init(game):g=game
static func point(index:int)->Vector2:return Vector2(XS[index%7],YS[index/7])
static func door_node(room:String)->int:
 for i in DOORS:
  if DOORS[i].id==room:return i
 return 10
static func overview_name(index:int)->String:
 return {7:"Quarters",9:"Exchange",10:"Concourse",12:"Foreman"}.get(index,DOORS[index].name)
func build_graph():
 edges.clear()
 for floor in 3:
  for x in 6:edges.append(Vector2i(floor*7+x,floor*7+x+1))
 edges.append(Vector2i(2,10));edges.append(Vector2i(11,19))
 edges.append(Vector2i(6,13));edges.append(Vector2i(13,20))
func _ready():
 map_plaque=StyleBoxFlat.new();map_plaque.bg_color=Color("13232e");map_plaque.border_color=Color("796b50");map_plaque.set_border_width_all(1);map_plaque.set_corner_radius_all(4)
 build_graph();survey=g.room_id!=""
 at=door_node(g.room_id) if survey else 10
 if not survey and absf(g.player.x-g.nearest_station().x)<75:at=door_node(g.nearest_station().panel)
 var saved=g.state.hold_travel
 if not survey and saved.get("active",false):
  at=clampi(int(saved.get("at",10)),0,20)
  toward=int(saved.get("toward",-1));progress=clampf(float(saved.get("progress",0)),0,1)
  if toward not in neighbors(at):toward=-1;progress=0
 elif not survey and saved.get("return",false):at=clampi(int(saved.get("at",10)),0,20)
 level=at/7;floor_pos=HoldFloorPlan.point(at)
 if int(saved.get("version",0))==3 and saved.has("floor_x") and not survey and (saved.get("active",false) or saved.get("return",false)):
  var restored=Vector2(float(saved.floor_x),float(saved.get("floor_y",floor_pos.y)))
  if HoldFloorPlan.walkable(restored,level):floor_pos=restored
 elif survey:floor_pos=HoldFloorPlan.door(at)+Vector2(0,22)
 floor_camera=(floor_pos-Vector2(480,300)).clamp(Vector2(0,-60),HoldFloorPlan.WORLD-Vector2(960,540))
 for npc in HoldNpcPresence.HOMES:
  var i=door_node(HoldNpcPresence.room_for(g.state,npc))
  marks[i]=HoldQuestMarkers.status(g.state,npc)
  if npc==g.state.tracked_npc:destination=i
 make_ui();remember();update_info()
 if not survey:g.sound.set_context("hub")
func neighbors(i:int)->Array:
 var result=[]
 for edge in edges:
  if edge.x==i:result.append(edge.y)
  elif edge.y==i:result.append(edge.x)
 return result
func position_on_map()->Vector2:
 return point(at).lerp(point(toward),progress) if toward>=0 else point(at)
func remember():
 if not survey:g.state.hold_travel={"active":true,"at":at,"toward":toward,"progress":progress,"floor_x":floor_pos.x,"floor_y":floor_pos.y,"version":3,"concourse_x":g.state.hold_travel.get("concourse_x",535)}
func make_ui():
 var top=Panel.new();top.position=Vector2(12,10);top.size=Vector2(936,55);top.add_theme_stylebox_override("panel",map_plaque);add_child(top)
 var title=Label.new();heading=title;title.text="KELDRATH  /  "+NAMES[level];title.position=Vector2(25,14);title.add_theme_font_size_override("font_size",21);title.modulate=Color("ead4a0");add_child(title)
 var sub=Label.new();sub.text="Survey only: leave your room to travel." if survey else "WASD / arrows: walk   E: doors, stairs & lift   G: whole hold   Esc: pause";sub.position=Vector2(25,42);sub.add_theme_font_size_override("font_size",13);add_child(sub)
 view_button=g.small_button(self,"Whole hold [G]",toggle_view);view_button.position=Vector2(685,20);view_button.size=Vector2(140,32)
 pause_button=g.small_button(self,"Close" if survey else "Pause",toggle_pause);pause_button.position=Vector2(835,20);pause_button.size=Vector2(100,32)
 var bottom=Panel.new();bottom.position=Vector2(12,460);bottom.size=Vector2(936,68);bottom.add_theme_stylebox_override("panel",map_plaque);add_child(bottom)
 info=Label.new();info.position=Vector2(25,467);info.size=Vector2(715,56);info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;info.add_theme_font_size_override("font_size",16);add_child(info)
 enter_button=g.small_button(self,"Enter [E]",enter_location);enter_button.position=Vector2(765,476);enter_button.size=Vector2(170,37)
 quit_button=g.small_button(self,"Save & title",func():remember();g.save_game();g.show_title());quit_button.position=Vector2(405,290);quit_button.size=Vector2(150,40);quit_button.visible=false
func toggle_view():
 floor_view=not floor_view;overview=false
 view_button.text="Floor plan [G]" if not floor_view else "Whole hold [G]"
 heading.text="KELDRATH  /  "+(NAMES[level] if floor_view else "THE LIVING MOUNTAIN")
 walking=false
 update_info()
func toggle_pause():
 if is_instance_valid(lift_choice):lift_choice.queue_free();lift_choice=null;return
 if survey:g.close_panel();return
 paused=not paused;pause_button.text="Resume" if paused else "Pause";quit_button.visible=paused
func handle_input(e:InputEvent):
 if not e is InputEventKey or not e.pressed or e.echo:return
 match e.keycode:
  KEY_ESCAPE:toggle_pause()
  KEY_G:toggle_view()
  KEY_E:enter_location()
  KEY_F5:remember();g.save_game()
func choose_edge(direction:Vector2)->int:
 var best=-1;var score=.2
 for next in neighbors(at):
  var delta=(point(next)-point(at)).normalized()
  # Vertical input chooses stairs or lift; horizontal input stays on a gallery.
  if absf(direction.y)>.5 and absf(delta.y)<.2:continue
  if absf(direction.x)>.5 and absf(direction.y)<.2 and absf(delta.y)>.2:continue
  var value=direction.dot(delta)
  if value>score:score=value;best=next
 return best
func nearby_node(radius:float=40)->int:
 if floor_view:
  for i in DOORS:
   if i/7==level and floor_pos.distance_to(HoldFloorPlan.door(i))<radius:return i
  return -1
 var best=-1;var distance=radius
 for i in 21:
  var d=position_on_map().distance_to(point(i))
  if d<distance:best=i;distance=d
 return best
func route_to(target:int)->Array:
 var queue=[at];var previous={at:-1}
 while not queue.is_empty():
  var here=queue.pop_front()
  if here==target:break
  for next in neighbors(here):
   if not previous.has(next):previous[next]=here;queue.append(next)
 if not previous.has(target):return []
 var result=[target];var current=target
 while previous[current]>=0:current=previous[current];result.push_front(current)
 return result
func _unhandled_input(e):
 if e is InputEventMouseButton and e.pressed and e.button_index==MOUSE_BUTTON_LEFT and not paused:
  var mouse=get_local_mouse_position()
  if not floor_view:
   for floor in 3:
    var x=224.0
    for i in DOORS:
     if i/7!=floor:continue
     var w=ThemeDB.fallback_font.get_string_size(overview_name(i),HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+18
     if Rect2(x,149+124*floor,w,28).has_point(mouse):
      destination=i;route=route_to(i);get_viewport().set_input_as_handled();return
     x+=w+5
   return
  for i in DOORS:
   if i/7==level and HoldFloorPlan.building(i).grow(20).has_point(mouse+floor_camera):
    destination=i;route=route_to(i);get_viewport().set_input_as_handled();return

func move(direction:Vector2,dt:float):
 walking=false
 if direction==Vector2.ZERO:return
 if absf(direction.y)>.5 and (toward<0 or absf(point(toward).y-point(at).y)<1):
  var near=nearby_node(18)
  if near>=0:
   for neighbor in neighbors(near):
    if absf(point(neighbor).y-point(near).y)>10 and direction.y*(point(neighbor).y-point(near).y)>0:
     at=near;toward=-1;progress=0;break
 if toward<0:toward=choose_edge(direction);progress=0
 if toward<0:return
 var delta=point(toward)-point(at)
 var along=direction.dot(delta.normalized())
 if absf(along)<.1:return
 var lift=at%7==6 and toward%7==6
 var speed=120.0 if not lift else (150.0 if HoldIndustry.tier(g.state,"hold")>0 else 80.0)
 progress+=signf(along)*speed*dt/delta.length()
 if absf(delta.x)>1:face=1 if delta.x*along>0 else -1
 walking=not lift;gait+=dt
 if progress>=1:at=toward;toward=-1;progress=0
 elif progress<=0:toward=-1;progress=0
func _process(dt):
 clock+=dt
 if not paused and not survey and floor_view and not is_instance_valid(lift_choice):
  move_floor(Input.get_vector("left","right","up","down"),minf(dt,.05))
  if walking:
   foot_clock+=dt
   if foot_clock>.38:g.sound.footstep("stone");foot_clock=0
  else:foot_clock=0
  autosave+=dt
  if autosave>30:remember();g.save_game();autosave=0
 floor_camera=floor_camera.lerp((floor_pos-Vector2(480,300)).clamp(Vector2(0,-60),HoldFloorPlan.WORLD-Vector2(960,540)),1-exp(-dt*8))
 remember();update_info();queue_redraw()
func move_floor(direction:Vector2,dt:float):
 var before=floor_pos;var delta=direction*185.0*dt
 var steps=maxi(1,int(ceil(delta.length()/4)));var step=delta/steps
 for i in steps:
  if HoldFloorPlan.walkable(floor_pos+Vector2(step.x,0),level):floor_pos.x+=step.x
  if HoldFloorPlan.walkable(floor_pos+Vector2(0,step.y),level):floor_pos.y+=step.y
 walking=floor_pos.distance_to(before)>.01
 if walking:
  gait+=floor_pos.distance_to(before)/(64.0*.8*1.25)
  if absf(direction.x)>.1:face=1 if direction.x>0 else -1
 var nearest=0;var distance=INF
 for i in 7:
  var d=floor_pos.distance_to(HoldFloorPlan.point(level*7+i))
  if d<distance:distance=d;nearest=i
 at=level*7+nearest;toward=-1;progress=0
func near_portal()->int:
 for i in ([2,5,6] if level==0 else [10,11,13] if level==1 else [16,19,20]):
  if floor_pos.distance_to(HoldFloorPlan.point(i))<38:return i
 return -1
func change_floor(index:int):
 if is_instance_valid(lift_choice):lift_choice.queue_free();lift_choice=null
 at=index;level=index/7;toward=-1;progress=0
 floor_pos=HoldFloorPlan.point(index);floor_camera=(floor_pos-Vector2(480,300)).clamp(Vector2(0,-60),HoldFloorPlan.WORLD-Vector2(960,540))
 heading.text="KELDRATH  /  "+NAMES[level];g.sound.effect("door_real",-20)
 remember();g.save_game();update_info()
func use_portal(index:int):
 if index in [2,5,10,11,16,19]:change_floor({2:10,5:10,10:2,11:19,16:11,19:11}[index]);return
 if is_instance_valid(lift_choice):return
 lift_choice=PanelContainer.new();lift_choice.position=Vector2(300,175);lift_choice.size=Vector2(360,210);add_child(lift_choice)
 var box=VBoxContainer.new();lift_choice.add_child(box)
 g.label(box,"THE HOLD LIFT",21)
 for tier in 3:
  var target=tier*7+6
  var b=g.button(box,NAMES[tier]+("  /  You are here" if tier==level else ""),func():change_floor(target));b.disabled=tier==level
 g.small_button(box,"Stay on this landing",func():lift_choice.queue_free();lift_choice=null)
func lock_reason(index:int)->String:
 if not DOORS.has(index):return ""
 match DOORS[index].id:
  "throne":
   if HoldOnboarding.ensure(g.state).fresh and HoldOnboarding.stage(g.state)<4:return "Ivar's reference required"
  "training":
   if not HoldOnboarding.ensure(g.state).accepted.has("training"):return "Ask Borin about training"
  "gate":
   if g.state.opening==0:return "Finish your introductions first"
 return ""
func near_wip()->bool:
 for p in HoldFloorPlan.WIP_DOORS.get(level,[]):
  if floor_pos.distance_to(p)<48:return true
 return false
func update_info():
 if not is_instance_valid(info):return
 if not floor_view:
  enter_button.disabled=true;enter_button.text="Survey overview"
  info.text="Click a doorway to mark it. G returns to your district. Stairs and the lift connect the levels.\nWIP wings have no playable interior in this build."
  return
 var near=nearby_node();var here=DOORS.has(near)
 var portal=near_portal()
 enter_button.disabled=paused or survey or not here or lock_reason(near)!=""
 enter_button.text="Use table [E]" if here and DOORS[near].id=="gate" else "Enter [E]"
 if portal>=0 and not here and not paused and not survey:
  enter_button.disabled=false;enter_button.text="Choose level [E]" if portal%7==6 else "Take stairs [E]"
  info.text=("Hold lift" if portal%7==6 else "Royal stair" if portal in [2,10] else "Forge stair")+"  /  "+NAMES[level]+"\nE travels between levels. WASD explores north, south, east and west on this floor."
  return
 if paused:info.text="Travel paused. Your place in the hold will be saved."
 elif survey:info.text="You are inside "+HoldInteriors.ROOMS.get(g.room_id,{"name":"a family hearth"}).name+". Leave by the door to explore the hold."
 elif near_wip():
  enter_button.disabled=true;enter_button.text="WIP · Unavailable"
  info.text="UNOPENED WING · WIP\nThis interior is not implemented. Quests and upgrades will not open it in this build."
 elif here:
  var d=DOORS[near];info.text=d.name+"  /  "+NAMES[near/7]+"\n"+(lock_reason(near) if lock_reason(near)!="" else d.detail)
 else:info.text=("Marked route: "+DOORS[destination].name if destination>=0 else NAMES[at/7]+"  /  Follow the lit gallery.")+"\nWASD explores the floor. E uses stairs and lifts. G shows the whole hold."
func enter_location():
 if paused or survey or not floor_view:return
 if near_wip():g.notify("WIP: this wing has no playable interior in the current build.");return
 var near=nearby_node()
 if near<0 and near_portal()>=0:use_portal(near_portal());return
 if not DOORS.has(near):return
 at=near;toward=-1;progress=0
 if lock_reason(at)!="":g.notify(lock_reason(at));return
 var id=DOORS[at].id
 remember();g.state.hold_travel.active=false;g.state.hold_travel["return"]=true
 if id=="gate":
  g.state.hold_travel["return"]=false;g.close_panel();g.open_panel("basin_map");return
 g.enter_hold_destination(id)
func text_at(p:Vector2,text:String,size:int=13,color:Color=Color("e8d7ad"),center:bool=false):
 var font=ThemeDB.fallback_font
 if center:p.x-=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,size).x/2
 draw_string(font,p,text,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)
func poly(points:Array,color:Color):draw_colored_polygon(PackedVector2Array(points),color)
func vault(x:float,y:float,w:float,color:Color):
 draw_rect(Rect2(x-w/2,y-70,w,70),Color("0d2029"))
 for j in 7:
  var a=PI+float(j)/7*PI;var b=PI+float(j+1)/7*PI
  var c=Vector2(x,y-40)
  poly([c+Vector2(cos(a),sin(a))*w*.51,c+Vector2(cos(b),sin(b))*w*.51,c+Vector2(cos(b),sin(b))*w*.39,c+Vector2(cos(a),sin(a))*w*.39],color.lightened(.04 if j%2 else .13))
 for side in [-1,1]:
  draw_rect(Rect2(x+side*w*.46-5,y-42,10,43),color)
  draw_line(Vector2(x+side*w*.46-5,y-42),Vector2(x+side*w*.46-5,y),color.lightened(.22),2)
  draw_line(Vector2(x+side*w*.46+5,y-42),Vector2(x+side*w*.46+5,y),color.darkened(.45),2)
  for yy in range(-40,0,10):draw_line(Vector2(x+side*w*.46-5,y+yy),Vector2(x+side*w*.46+5,y+yy),Color("1b2d36"))
func _draw():
 if floor_view:
  HoldFloorPlan.draw(self)
  if paused:
   draw_rect(Rect2(200,180,560,180),Color(.03,.08,.12,.95));text_at(Vector2(480,243),"THE HOLD CAN WAIT A MOMENT",23,Color("ead9af"),true)
  return
 HoldFloorPlan.overview(self)
 if paused:
  draw_rect(Rect2(200,180,560,180),Color(.03,.08,.12,.95));text_at(Vector2(480,243),"THE HOLD CAN WAIT A MOMENT",23,Color("ead9af"),true)
