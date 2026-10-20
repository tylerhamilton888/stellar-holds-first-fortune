extends SceneTree
var game
func _initialize():call_deferred("run")
func snap(label:String):
 if game.playing:game.update_hud()
 game.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("review20-"+label+".png"))
func run():
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false)
 await snap("title")
 game.open_creator(true);await snap("creator")
 game.creator.queue_free();await process_frame
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");await snap("opening")
 game.close_panel();game.state.opening=1;game.player=Vector2(1100,410);game.camera=Vector2(620,0);await snap("hold")
 game.open_panel("commission");await snap("quest")
 game.open_panel("equipment");await snap("equipment")
 game.open_panel("research");await snap("research")
 game.close_panel();game.zone="approach";game.player=Vector2(1850,400);game.camera=Vector2(1370,0);await snap("approach")
 game.zone="mine";game.player=Vector2(190,392);game.camera=Vector2(-290,0);await snap("mine-mouth")
 game.player=Vector2(700,550);game.camera=Vector2(220,230);await snap("mine")
 game.zone="hub";game.enter_room("forge");game.transition_left=0;game.transition_shade.visible=false;game.close_panel();await snap("forge")
 game.open_panel("inventory");game.get_window().focus_exited.emit();var clock_before=game.clock;var pos=game.player;var money=game.state.money
 game._process(30)
 assert(game.panel_id=="pause" and game.clock==clock_before and game.player==pos and game.state.money==money,"Focus pause freezes simulation")
 game.get_window().focus_entered.emit();assert(game.panel_id=="pause","Returning focus does not silently resume")
 await snap("pause")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame;print("REVIEW: 12 screens captured; focus pause freezes simulation");quit()
