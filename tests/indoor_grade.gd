extends SceneTree

var g
var plans
var grade
var town
var checks=0
var failures=[]

func _initialize():call_deferred("run")

func check(value,label):
 checks+=1
 if not value:failures.append(label);print("FAIL ",label)

func step(action,dt=.025):
 Input.action_press(action)
 g.surface.move(dt)
 Input.action_release(action)

func trip(from:String,to:String,up:bool,x=0.):
 var a=plans.stair_position(from);var b=plans.stair_position(to)
 var start=a+Vector2(x,34 if up else -110)
 g.surface.enter(from,start);g.transition_left=0;g.transition_shade.hide();g.close_panel()
 check(g.player.distance_to(start)<1,"Entrance clearance "+from)
 var direction="up" if up else "down"
 var flips=0;var landed=false
 for i in 85:
  var before=g.player;var previous=g.surface.area;var gait=g.gait_clock
  var camera_x=g.surface.camera_target().x
  step(direction)
  if g.surface.area!=previous:
   flips+=1;landed=true
   check(absf(g.surface.camera_target().x-camera_x-(b.x-a.x))<1,"Ramp stays aligned on screen "+from)
   check((g.player-before-(b-a)).length()<11,"Stride continuity "+from)
   check(g.transition_left<=0 and g.gait_clock>=gait,"Continuous floor change "+from)
  if landed and ((up and g.player.y<b.y-106) or (not up and g.player.y>b.y+30)):break
  if before==g.player and previous==g.surface.area:break
 check(flips==1 and g.surface.area==to and g.surface.walkable(g.player),"Cross once to "+to+" at "+str(g.player))
 check((up and g.player.y<=b.y-92) or (not up and g.player.y>=b.y+20),"Clear far end of ramp "+to)

func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host);g=host.get_child(0).get_child(0)
 plans=load("res://scripts/building_plans.gd");grade=load("res://settlement/indoor_grade.gd");town=load("res://scripts/frontier103.gd")
 g.set_process(false);town.data(g.state).keldrath_open=true
 load("res://scripts/mountain104.gd").data(g.state).authenticated=true
 var office=town.room(g.state,"survey");var records=town.room(g.state,"survey",1)
 var anchor=plans.stair_position(office)
 g.surface.enter(office,anchor+Vector2(0,19));g.transition_left=0;g.close_panel();step("up");var stopped=g.player
 for i in 6:g.surface.move(.03)
 var key=InputEventKey.new();key.keycode=KEY_E;key.pressed=true
 g.surface.input(key);key.shift_pressed=true;g.surface.input(key)
 check(g.surface.area==office and g.player==stopped,"E and Shift+E leave the player on the stair")
 check(g.player==stopped and g.surface.area==office,"Release stops on incline")
 step("down");check(g.player.y>stopped.y and g.surface.area==office,"Reverse before crossing")
 trip(office,records,true);trip(records,office,false)
 # Reverse immediately after the seam, without releasing on a landing.
 g.surface.enter(office,anchor+Vector2(0,grade.SEAM+1));g.transition_left=0
 step("up");step("down")
 check(g.surface.area==office,"Reverse at seam without input lock")
 g.surface.enter(office,anchor+Vector2(0,grade.SEAM+1))
 var fixture={"kind":"crate","area":records,"z":0,"x":plans.stair_position(records).x,"y":plans.stair_position(records).y+grade.SEAM+5}
 g.state.surface.decor.append(fixture);step("up")
 check(g.surface.area==office and g.surface.walkable(g.player),"Occupied destination blocks crossing")
 g.state.surface.decor.erase(fixture)
 trip(town.lodge(g.state),town.quarters(g.state),true)
 trip(town.quarters(g.state),town.lodge(g.state),false)
 trip("room:tavern","room:kettle_loft",true);trip("room:kettle_loft","room:tavern",false)
 for ward in ["crownward","hearthward","forgeward"]:
  for i in 3:
   var base="room:folk_%s_%d_"%[ward,i]
   trip(base+"0",base+"1",true);trip(base+"1",base+"0",false)
 var private_house={"id":"9912","plan":"folk_crownward_0","area":"claim","x":2200,"y":1400,"name":"Three floors","rooms":["room:folk_crownward_0_0","room:folk_crownward_0_1","room:folk_crownward_0_1"],"stair":[650,545],"fitted_rooms":true}
 g.surface.architecture.data().instances.append(private_house)
 var middle=plans.room_id("9912",1);var top=plans.room_id("9912",2)
 trip(middle,top,true);trip(top,middle,false)
 trip(office,records,true);g.save_game();var position=g.player;g.start_game(true)
 check(g.surface.area==records and g.player.distance_to(position)<1,"Reload on records landing")
 print("INDOOR GRADES ",checks," checks. Failures ",failures)
 quit(0 if failures.is_empty() else 1)
