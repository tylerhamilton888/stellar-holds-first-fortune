extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var checks=0
var failures=0
func check(ok:bool,message:String):
 checks+=1
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func select(g,point:Vector2)->Dictionary:
 var t=HoldForestry.target(g,point)
 g.forest_target=t
 if not t.is_empty():g.hit_point=t.p;g.face=t.face
 return t
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 g.transition_left=0;g.transition_shade.visible=false;g.state.opening=4;g.zone="road";g.room_id="";g.grounded=true;g.tool=2
 g.state.road_trees=[0,3,8,8,8];HoldForestry.ensure(g.state)
 check(g.state.road_trees.size()==7 and g.state.road_trees[0]==0 and g.state.road_trees[1]==3,"Migration preserves exhausted and partially cut trees, adds two new firs")
 check(HoldForestry.logs(g.state,0)==0,"Old stumps cannot grant timber again")
 g.state.road_trees[0]=8
 for sex in 2:
  for design in 5:
   g.state.appearance=HoldAppearance.normalized({"gender":sex,"sculpt":design})
   for direction in [-1,1]:
    g.player=Vector2(HoldForestry.X[0]-direction*65,410)
    var target=select(g,Vector2(HoldForestry.X[0],370))
    check(not target.is_empty() and g.contact_reachable(target.p,direction),"Every design reaches trunk from either side")
 g.player=Vector2(355,410);g.tool=0
 check(select(g,Vector2(420,370)).is_empty(),"Pickaxe cannot fell trees")
 g.tool=2;g.grounded=false
 check(select(g,Vector2(420,370)).is_empty(),"No chopping from midair")
 g.grounded=true;g.player.y=310
 check(select(g,Vector2(420,370)).is_empty(),"No harvesting from above the tree")
 g.player=Vector2(290,410)
 check(select(g,Vector2(420,370)).is_empty(),"Distant tree is out of range")
 g.player.x=355
 check(select(g,Vector2(900,370)).is_empty(),"Aiming elsewhere does not chop nearby tree")
 var selected=select(g,Vector2(420,370));var wood=g.state.count("wood")
 for strike in 8:check(HoldForestry.strike(g,selected),"Standing cut succeeds")
 check(g.state.road_trees[0]==0 and g.state.count("wood")==wood+16,"Eight cuts produce exactly 16 timber")
 check(not HoldForestry.strike(g,selected),"Stale standing target cannot duplicate reward")
 check(HoldForestry.logs(g.state,0)==3,"Felling creates three recoverable log cuts")
 g.player=Vector2(HoldForestry.log_x(g.state,0)-27,410)
 check(select(g,Vector2(HoldForestry.log_x(g.state,0),399)).is_empty(),"Cannot chop falling tree")
 g.state.elapsed+=2
 selected=select(g,Vector2(HoldForestry.log_x(g.state,0),399))
 check(not selected.is_empty() and selected.log,"Fallen log is reachable with lower swing")
 if not selected.is_empty():
  g.grounded=false;check(not HoldForestry.strike(g,selected),"Moving off ground cancels contact")
  g.grounded=true;g.player.x+=200;check(not HoldForestry.strike(g,selected),"Walking out of reach cancels contact")
  g.player.x-=200
  for strike in 3:check(HoldForestry.strike(g,selected),"Log cut succeeds")
  check(not HoldForestry.strike(g,selected),"Exhausted log cannot duplicate reward")
 check(g.state.count("wood")==wood+22,"Complete tree pays exactly 22 timber")
 check(select(g,Vector2(HoldForestry.log_x(g.state,0),399)).is_empty(),"Cleared stump is no longer targeted")
 # Save one partial log and restore it, including its fall direction and timestamp.
 g.state.forestry.logs["0"]=2;g.state.forestry.direction["0"]=-1
 check(g.state.save_world(g.geo,"road",g.player),"Forest save succeeds")
 var restored=HoldState.new();var geo=Geology.new();var saved=restored.load_world(geo);HoldForestry.ensure(restored)
 check(saved.zone=="road" and restored.road_trees[1]==3 and HoldForestry.logs(restored,0)==2 and HoldForestry.direction(restored,0)==-1,"Partial cuts, logs, direction and zone survive reload")
 g.state.forestry.logs["0"]=0;g.arrive_region("workings");g.arrive_region("forest")
 check(g.zone=="road" and g.state.road_trees[0]==0 and HoldForestry.logs(g.state,0)==0,"Map round trip preserves cleared coupe")
 g.player=Vector2(190,410);g.interact();check(g.panel_id=="pinewood","Field board opens timber instructions")
 g.close_panel();g.zone="hub"
 check(not HoldForestry.strike(g,selected),"No timber harvest inside hold")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("FORESTRY40: ",checks," checks, ",failures," failures");quit(1 if failures else 0)
