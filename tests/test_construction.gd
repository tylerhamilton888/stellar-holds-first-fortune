extends SceneTree
var failed=0
var checks=0
func check(ok:bool,s:String):
 checks+=1
 if not ok:failed+=1;push_error(s)
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.zone="mine";game.transition_left=0
 for y in range(30,70):
  for x in range(100,180):game.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 game.player=Vector2(800,392);game.grounded=true;game.velocity=Vector2.ZERO
 var b=game.construction;game.state.inventory.wood=40;game.state.inventory.stone=20
 b.selected="stairs_right"
 var wood=game.state.count("wood")
 check(b.place(Vector2i(119,55)),"Stairs place on ground")
 check(game.state.count("wood")==wood-2 and game.geo.at(126,52)==13,"Stairs cost resources and create solid steps")
 check(not b.place(Vector2i(119,55)),"Occupied footprint cannot be rebuilt")
 Input.action_press("right")
 for i in 24:game.move_player(1.0/60)
 Input.action_release("right")
 check(game.player.y<385 and game.player.x>830,"Player physically walks up stairs")
 game.player=Vector2(1000,392);game.velocity=Vector2.ZERO;b.selected="ladder"
 check(b.place(Vector2i(142,44)),"Ladder anchors to floor")
 var y=game.player.y;Input.action_press("up")
 for i in 20:game.move_player(1.0/60)
 Input.action_release("up")
 check(game.player.y<y-35,"Built ladder allows climbing")
 game.player=Vector2(1100,350);game.velocity=Vector2.ZERO;y=game.player.y;Input.action_press("up")
 for i in 10:game.move_player(1.0/60)
 Input.action_release("up")
 check(game.player.y>=y,"No unrestricted winch flight away from ladders")
 game.player=Vector2(1020,392);b.selected="support"
 check(b.place(Vector2i(151,55)),"Roof support attaches to floor")
 check(game.geo.at(156,43)==13,"Support beam is physical timber")
 game.geo.set_cell(Vector2i(156,42),1);game.geo.activate_near(Vector2i(156,42));game.geo.tick_materials(.1)
 check(game.geo.at(156,42)==1,"Roof beam catches loose earth")
 game.state.money=10;game.state.rescue_debt=0;var pack=game.state.inventory.duplicate(true)
 game.perform_rescue("test")
 check(game.state.money==0 and game.state.rescue_debt==15,"Emergency extraction charges minimum 25, carrying unpaid debt")
 check(game.state.inventory==pack and game.player.x==150,"Rescue preserves kit and returns to entrance")
 game.state.money=20;game.state.tick(.1)
 check(game.state.money==5 and game.state.rescue_debt==0,"Future earnings settle rescue debt")
 game.state.tracked_npc="ivar";game.save_game();var loaded=HoldState.new();var geo=Geology.new();loaded.load_world(geo)
 check(not loaded.ladders.is_empty() and geo.at(156,43)==13,"Structures and ladders survive save/load")
 game.geo.set_cell(Vector2i(151,56),0);b.maintain()
 check(game.geo.at(156,43)==0,"Removing a footing removes the unsupported roof frame")
 for y0 in range(19,22):
  for x0 in range(159,162):game.geo.set_cell(Vector2i(x0,y0),0)
 game.geo.set_cell(Vector2i(160,20),13);b.maintain()
 check(game.geo.at(160,20)==0,"Disconnected timber cannot float")
 for x in range(141,146):game.geo.set_cell(Vector2i(x,56),0)
 b.maintain();check(b.ladders().is_empty(),"Unsupported ladder chain is recovered")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame
 print("CONSTRUCTION: %d checks, %d failures" % [checks,failed]);quit(1 if failed else 0)
