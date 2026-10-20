extends SceneTree
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1;g.grounded=true;g.open_panel("world_map")
 for child in g.panel_body.get_children():
  if child is HoldRegionMap:child.selected="workings";child.refresh_info();child.queue_redraw()
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("exp25-map-workings.png"))
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit()
