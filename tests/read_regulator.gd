extends SceneTree
func _initialize():call_deferred("run")
func run():
 root.size=Vector2i(960,540);root.content_scale_size=root.size
 var scene=load("res://furrow/start.tscn").instantiate();root.add_child(scene)
 var g=scene.get_child(0).get_child(0);var w=g.deep.world
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.set_process(false);g.transition_left=0;g.transition_shade.hide();g.loading_view._process(1);g.loading_view._process(1);g.ui.hide();g.fight.cancel_actions()
 var f=w.layer().features[0];var origin=w.center(Vector2i(f.x,f.y))
 print("Regulator ",w.depth()," props ",w.landmarks().map(func(p):return p.prop))
 if not f.has("regulator_plan") or not "pressure" in w.landmarks().map(func(p):return p.prop):quit(1);return
 Input.action_press("up")
 for i in 192:
  g.clock+=1./48;g.deep.move(1./48)
  if g.player.y-origin.y<1:break
 Input.action_release("up");g.walking_pose=false;g.deep.use_stairs(false)
 print("Inspect at ",g.player-origin,": ",g.notice)
 if g.notice!=w.Strata.Court.note("pressure"):quit(1);return
 g.camera=g.deep.camera_target();g.queue_redraw()
 for i in 3:
  await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_user_data_dir().path_join("regulator.png"))
 quit()
