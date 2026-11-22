extends SceneTree
var g
var failures=[]
var checks=0
func check(passed,label):
 checks+=1
 if not passed:failures.append(label)
func _initialize():call_deferred("run")
func stairs_to(target):
 var p=load("res://scripts/building_plans.gd").stair_position(g.surface.area)
 var up=load("res://scripts/building_plans.gd").floor_number(target)>load("res://scripts/building_plans.gd").floor_number(g.surface.area)
 g.player=p+Vector2(0,30 if up else -105);g.transition_left=0;g.close_panel()
 check(g.surface.walkable(g.player),"Accessible landing in "+g.surface.area)
 var axis="up" if up else "down"
 Input.action_press(axis)
 for i in 55:
  g.surface.move(.025)
  if g.surface.area==target:break
 Input.action_release(axis)
 check(g.surface.area==target and g.surface.walkable(g.player),"Reach "+target+" with usable landing")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host);g=host.get_child(0).get_child(0)
 g.set_process(false);g.transition_left=0;g.close_panel()
 var p=load("res://scripts/building_plans.gd");var room=load("res://settlement/rooms.gd")
 var civic=load("res://scripts/hold_civic_art.gd");var town=load("res://scripts/frontier103.gd")
 var a=g.surface.architecture;var world=g.surface.world
 town.data(g.state).keldrath_open=true;load("res://scripts/mountain104.gd").data(g.state).authenticated=true
 for pair in [[town.room(g.state,"lodge"),town.quarters(g.state)],["room:tavern","room:kettle_loft"],["room:folk_crownward_0_0","room:folk_crownward_0_1"]]:
  g.surface.enter(pair[0]);stairs_to(pair[1]);check(not civic.has_exit(g.surface.area),"No exterior door on "+pair[1]);stairs_to(pair[0])
 var template="room:folk_forgeward_0_1";var b={"id":"8741","plan":"folk_forgeward_0","area":"claim","x":2300,"y":1400,"name":"Interior test","rooms":["room:folk_forgeward_0_0",template],"extend_x":2,"extend_y":1}
 a.data().instances.append(b);var area=p.room_id(str(b.id),1)
 a.seed_room(b,1,false);g.surface.enter(area)
 check(room.supported_marks(world,template).is_empty(),"Unfurnished expanded family loft has zero rugs")
 var bed={"kind":"bed","area":area,"x":300,"y":425,"z":0};g.state.surface.decor.append(bed)
 var counterpart=bed.duplicate();counterpart.z=1;counterpart.x=455;g.state.surface.decor.append(counterpart)
 var marks=room.supported_marks(world,template)
 check(marks.size()==1 and marks[0][1].has_point(Vector2(300,425)),"Only the bed on the base floor receives a rug")
 bed.x=890;bed.y=605;marks=room.supported_marks(world,template)
 check(marks.size()==1 and marks[0][1].has_point(Vector2(890,605)),"Moving the bed into the extension moves its rug")
 bed.x=700;bed.y=550
 check(room.supported_marks(world,template).is_empty(),"Dressing leaves the stair opening clear")
 g.state.surface.decor.erase(bed);g.state.surface.decor.erase(counterpart)
 check(room.supported_marks(world,template).is_empty(),"Removing the furniture leaves bare flooring")
 print("INTERIORS ",checks," checks. Failures ",failures);quit(1 if not failures.is_empty() else 0)
