extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(tag):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("world26-"+tag+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1;g.grounded=true;g.open_panel("world_map")
 await snap("hold")
 var map=g.overworld;map.overview=true;map.queue_redraw();await snap("survey")
 # Mouse events must reach the real UI, rather than being swallowed by game input.
 var click=InputEventMouseButton.new();click.button_index=MOUSE_BUTTON_LEFT;click.position=map.pause_button.get_global_rect().get_center();click.pressed=true
 root.push_input(click,true);click=click.duplicate();click.pressed=false;root.push_input(click,true);await process_frame
 assert(map.paused,"Mouse activates the pause button")
 map.toggle_pause()
 map.overview=false;map.marker=Vector2(750,740);map.camera=(map.marker-Vector2(480,270)).clamp(Vector2.ZERO,map.WORLD-Vector2(960,540));map.queue_redraw();await snap("bridge")
 map.marker=map.nodes.workings.p+Vector2(0,35);map.camera=(map.marker-Vector2(480,270)).clamp(Vector2.ZERO,map.WORLD-Vector2(960,540));map.queue_redraw();await snap("workings")
 g.playing=false;g.sound.stop_all();g.close_panel();g.queue_free();await process_frame;quit()
