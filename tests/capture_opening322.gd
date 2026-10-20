extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join(name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 HoldOnboarding.begin_fortune(g.state);HoldOnboarding.ensure(g.state).stage=3;g.state.opening=1
 g.open_panel("guidance");await snap("first-trip-journal")
 g.close_panel();g.room_id="market";g.open_panel("world_map");await snap("indoor-survey")
 g.close_panel();g.room_id="";g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
