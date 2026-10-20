extends SceneTree
var failed=0
func check(ok:bool,s:String):
 if not ok:failed+=1;push_error(s)
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.state.opening=1
 for crossing in [["hub",2000.0,190.0,"approach",0.0],["approach",2000.0,190.0,"mine",0.0],["mine",-0.5,-190.0,"approach",1999.5],["approach",0.0,-190.0,"hub",2000.0]]:
  game.zone=crossing[0];game.player=Vector2(crossing[1],392);game.velocity=Vector2(crossing[2],0);game.camera=Vector2(game.player.x-480,0)
  var screen=game.player-game.camera
  game.advance_journey()
  check(game.zone==crossing[3] and is_equal_approx(game.player.x,crossing[4]),"Bidirectional crossing "+crossing[0])
  check(screen.is_equal_approx(game.player-game.camera),"Camera continuity")
  check(game.transition_left==0,"No transition card")
 game.zone="mine";game.ensure_mine_mouth()
 check(not game.body_solid(Vector2(0,392)),"Mine mouth is physically traversable")
 game.zone="hub";game.player=Vector2(1980,410);game.velocity=Vector2.ZERO;game.grounded=true
 Input.action_press("right")
 for i in 850:game.move_player(1.0/60)
 Input.action_release("right")
 check(game.zone=="mine" and game.player.x>200,"Walk from hold through trail into mine with collision enabled")
 Input.action_press("left")
 for i in 850:game.move_player(1.0/60)
 Input.action_release("left")
 check(game.zone=="hub","Walk all the way home with collision enabled")
 game.zone="approach";game.player=Vector2(1990,330);game.velocity=Vector2(190,-100);game.grounded=false
 Input.action_press("right")
 for i in 45:game.move_player(1.0/60)
 Input.action_release("right")
 check(game.zone=="mine" and game.player.x>90,"Jump across mine seam without an invisible border")
 game.zone="approach";game.player=Vector2(1150,410);game.save_game()
 var restored=HoldState.new();var g=Geology.new();var saved=restored.load_world(g)
 check(saved.zone=="approach" and saved.pos==game.player,"Trail save round-trip")
 for i in 3:
  game.clock=-i*7+2
  check(not game.visitor_motion(i).walking,"NPC stands between walking bouts")
  game.clock=-i*7+9;var first=game.visitor_position(i);game.clock+=.1
  check(is_equal_approx(game.visitor_position(i).x-first.x,3),"NPC walks at intentional speed")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame
 print("JOURNEY / NPC: %d FAILED" % failed);quit(1 if failed else 0)
