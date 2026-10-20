extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.state.opening=4;game.transition_left=0;game.transition_shade.visible=false;game.agents=[]
 for i in 6:
  game.zone=["hub","hub","hub","approach","mine","mine"][i];game.player=[Vector2(450,410),Vector2(1100,410),Vector2(1800,410),Vector2(1920,393),Vector2(180,392),Vector2(700,550)][i]
  game.camera=game.player-Vector2(480,320);game.camera.y=maxf(0,game.camera.y);game.queue_redraw()
  await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("world17-%d.png"%i))
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame;quit()
