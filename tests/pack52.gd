extends SceneTree
var g
func _initialize():call_deferred("run")
func capture(name:String):
 g.queue_redraw()
 for i in 5:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR")+"/"+name+".png")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 g.opening_scene.finish();await process_frame
 var tour=g.opening_scene;tour.set_process(false);tour.age=1;tour.advance()
 for i in 120:
  tour.tick(1.0/60)
  if i%20==0:await process_frame
 await capture("escort")
 tour.finish();await process_frame;g.state.opening=4;g.state.outpost.onboarding.fresh=false
 g.surface.enter("trail");g.transition_left=0;g.transition_shade.visible=false;g.player=Vector2(700,700);g.camera=g.surface.camera_target();g.walking_pose=true;g.gait_clock=.23;g.surface.direction=Vector2.RIGHT
 g.handworks.data().skills.mason=8;g.handworks.data().carry=[{"kind":"stone","units":2},{"kind":"log","units":2}]
 await capture("carrying")
 print("PACK52: exported intro, new walking metadata and mixed cargo rendered")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;await process_frame;quit()
