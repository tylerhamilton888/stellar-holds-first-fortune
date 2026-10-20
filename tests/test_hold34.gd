extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
class SavedState extends HoldState:
 func save_path()->String:return "user://hold34-test-only.json"
var passed=0
var failed=0
func check(ok:bool,message:String):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 g.grounded=true;g.open_panel("world_map");var m=g.overworld;m.set_process(false)
 check(m is HoldDistrictMap,"G in Keldrath opens district travel")
 for i in 21:
  check(not m.route_to(i).is_empty(),"All galleries and lift landings connected: "+str(i))
 for tier in 3:
  var seen={};var queue=[Vector2i(58,43)];seen[queue[0]]=true;var cursor=0
  while cursor<queue.size():
   var cell=queue[cursor];cursor+=1
   for offset in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
    var next=cell+offset
    if not seen.has(next) and HoldFloorPlan.walkable(Vector2(next)*16,tier):seen[next]=true;queue.append(next)
  for node in HoldDistrictMap.DOORS:
   if node/7==tier:
    var cell=Vector2i((HoldFloorPlan.door(node)/16).round())
    var reachable=false
    for offset in [Vector2i.ZERO,Vector2i.DOWN,Vector2i.UP,Vector2i.LEFT,Vector2i.RIGHT]:
     if seen.has(cell+offset) and (Vector2(cell+offset)*16).distance_to(HoldFloorPlan.door(node))<22:reachable=true
    check(reachable,"Connected walking route to doorway: "+str(node))
 m.change_floor(10);var start=m.floor_pos
 m.move_floor(Vector2.RIGHT,.1);check(m.floor_pos.x>start.x,"East/west travel is free on the floor")
 m.move_floor(Vector2.DOWN,.1);check(m.floor_pos.y>start.y,"North/south travel adds depth")
 m.floor_pos=HoldFloorPlan.point(10);m.enter_location();check(m.level==0,"Royal stair reaches Crownward")
 m.enter_location();check(m.level==1,"Royal stair returns to Hearthward")
 m.change_floor(13);m.use_portal(13);check(is_instance_valid(m.lift_choice),"Lift offers tier selection")
 m.change_floor(20);check(m.level==2 and not is_instance_valid(m.lift_choice),"Lift selection reaches Forgeward")
 for floor in 3:
  for node in HoldDistrictMap.DOORS:
   if node/7==floor:
    check(HoldFloorPlan.walkable(HoldFloorPlan.door(node),floor),"Door footing is accessible: "+str(node))
    check(not HoldFloorPlan.walkable(HoldFloorPlan.building(node).get_center(),floor),"Building walls are solid: "+str(node))
 m.change_floor(8);m.floor_pos=HoldFloorPlan.door(8)+Vector2(0,8)
 check(m.nearby_node()==8,"Door entry accepts nearby positions")
 m.enter_location();check(g.room_id=="tavern" and g.hold_room_return,"Door enters actual Copper Kettle")
 g.leave_room();m=g.overworld;m.set_process(false)
 check(m is HoldDistrictMap and m.floor_pos.distance_to(HoldFloorPlan.door(8))<23,"Room exit restores its doorway")
 m.change_floor(1);m.floor_pos=HoldFloorPlan.door(1)
 check(m.lock_reason(1)!="","Royal audience remains gated")
 m.enter_location();check(g.room_id=="","Cannot bypass royal reference")
 check(m.lock_reason(17)!="","Combat training remains gated")
 m.change_floor(13);m.floor_pos=HoldFloorPlan.door(13);check(m.lock_reason(13)!="","Introductions gate first expedition")
 g.state.opening=1;m.enter_location();check(g.overworld is HoldRegionMap,"King's Gate connects basin travel")
 g.close_panel();g.zone="hub";g.state.region_travel={};g.state.hold_travel={"active":true,"at":10,"floor_x":950,"floor_y":690,"version":3};g.open_panel("world_map")
 m=g.overworld;m.set_process(false)
 check(m.floor_pos==Vector2(950,690),"Floor coordinates resume exactly")
 m.toggle_view();m.enter_location();check(g.room_id=="","Overview cannot teleport into rooms");m.toggle_view()
 var s=SavedState.new();s.reset(34);s.hold_travel=g.state.hold_travel.duplicate(true)
 check(s.save_world(g.geo,"hub",Vector2(535,410)),"Hold travel saves")
 var restored=SavedState.new();restored.load_world(Geology.new())
 check(is_equal_approx(float(restored.hold_travel.get("floor_x",0)),950),"Floor coordinates survive disk serialization")
 DirAccess.remove_absolute(s.save_path())
 g.close_panel();g.state.hold_travel={};g.enter_room("home");g.open_panel("world_map")
 check(g.overworld.survey,"Indoor map is a survey, not an escape route")
 g.close_panel();g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("HOLD34: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
