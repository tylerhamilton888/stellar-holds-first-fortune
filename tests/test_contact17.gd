extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.set_process(false);g.zone="mine";g.state.opening=4
 for y in range(25,65):
  for x in range(90,160):g.geo.set_cell(Vector2i(x,y),0 if y<56 and x<150 else 2)
 for rate in [30,60,120]:
  g.player=Vector2(900,300);g.velocity=Vector2(0,650);g.grounded=false
  for i in 60:g.move_player(1.0/rate)
  check(absf(g.player.y-392)<.02,"Boot contact at %dfps"%rate)
  check(not g.body_solid(g.player),"Body remains outside floor")
  g.player=Vector2(1000,392);g.velocity=Vector2.ZERO;Input.action_press("right")
  for i in 30:g.move_player(1.0/rate)
  Input.action_release("right")
  check(absf(g.body_bounds(g.player).end.x-1050)<.02,"Wall contact at %dfps"%rate)
 g.player=Vector2(900,392)
 for x in range(120,140):g.geo.set_cell(Vector2i(x,44),2)
 check(not g.body_solid(g.player),"77px tunnel fits standing dwarf")
 for x in range(120,140):g.geo.set_cell(Vector2i(x,45),2)
 check(g.body_solid(g.player),"70px tunnel blocks head")
 # Shared bounds also govern construction and falling grains.
 check(g.body_bounds(Vector2.ZERO).size==Vector2(44,76),"One shared physical body")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("CONTACT17: %d failures"%failures);quit(1 if failures else 0)
