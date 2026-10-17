extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("bridge28-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1;g.grounded=true
 g.open_panel("world_map");g.overworld.marker=Vector2(g.overworld.river_x(740),740);g.overworld.camera=g.overworld.marker-Vector2(480,270);await snap("bridge")
 g.overworld.marker=g.overworld.nodes.forest.p+Vector2(0,35);g.overworld.camera=(g.overworld.marker-Vector2(480,270)).clamp(Vector2.ZERO,g.overworld.WORLD-Vector2(960,540));await snap("woodland")
 g.close_panel();g.zone="mine";g.player=Vector2(140,392);g.camera=Vector2(-160,20)
 HoldFieldSurvey.sample(g.geo,Vector2i(30,55));g.open_panel("field_notes");await snap("notebook")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
