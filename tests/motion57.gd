extends "res://tests/input_reference54.gd"
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://motion57"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var count=0
 for sample in 4:
  g.state.appearance=HoldAppearance.normalized({"gender":sample%2,"sculpt":0,"hair_color":4 if sample%2==0 else 2})
  g.handworks.data().carry.clear();g.state.add("stone",4);g.hotbar.select([0,2,6,0][sample],false)
  if sample==3:g.handworks.data().carry.append({"kind":"stone","units":2,"item":"stone","source":"art-review"})
  g.player=Vector2(650,850);g.surface.direction=Vector2.RIGHT;HoldFolk.prepare(g);settle()
  for f in 45:
   var dir="right" if f<23 else "left"
   Input.action_release("left" if dir=="right" else "right");Input.action_press(dir)
   for i in 4:g._process(1.0/60);await process_frame
   g.camera=g.surface.camera_target();g.update_hud();g.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/frame-%04d.png"%count);count+=1
  Input.action_release("left");Input.action_release("right")
 print("MOTION57 COMPLETE: ",count," native frames; pick/axe/supply/physical load, both horizontal directions")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
