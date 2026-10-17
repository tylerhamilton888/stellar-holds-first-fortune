extends SceneTree
var g
var serial=0
func _initialize():call_deferred("run")
func snap(name):
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join(name+".png"))
func tick_scene(s,seconds:float):
 for i in int(seconds*12):
  s.clock+=1.0/12;s.age+=1.0/12
  if s.has_method("update_staging"):s.update_staging(1.0/12)
  s.queue_redraw();await snap("film-%04d"%serial);serial+=1
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 var s=g.opening_scene;s.set_process(false)
 s.shot_age=2;s.update_staging(3);s.clock=3;s.age=3;s.queue_redraw();await snap("arrival")
 s.finish();await process_frame
 HoldOnboarding.ensure(g.state).stage=4;g.opening_scene=HoldOpeningScene.begin(g,"audience");s=g.opening_scene;s.set_process(false)
 s.step=1;s.show_line();s.shot_age=2;s.update_staging(2);s.clock=3;s.age=3;s.queue_redraw();await snap("audience")
 s.finish();await process_frame
 g.state.outpost.erase("onboarding");g.state.opening=2
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id);HoldAnniversary.prepare(g.state,id,2)
  for k in HoldAnniversary.cost(0,id):g.state.add(k,20)
  HoldAnniversary.deliver(g.state,id,true)
 g.anniversary_scene=HoldAnniversaryScene.begin(g);s=g.anniversary_scene;s.set_process(false);s.clock=2
 for beat in [2,3,9,10,11,14]:
  s.step=beat;s.show_line()
  if OS.get_environment("STELLAR_QUICK")=="1":
   s.age=3;s.clock=3;s.queue_redraw()
  else:await tick_scene(s,3 if beat!=14 else 8)
  await snap("beat-%02d"%beat)
 s.finish();await process_frame
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
