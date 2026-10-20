extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://motion59-film"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var count=0
 for sample in 6:
  g.state.appearance=HoldAppearance.normalized({"gender":sample%2,"sculpt":0,"hair_color":4 if sample%2==0 else 2})
  g.handworks.data().carry.clear();g.handworks.data().loose.clear();g.handworks.setting_down={};g.handworks.lift=0
  g.state.add("stone",4);g.hotbar.select([0,2,6,0,0,0][sample],false)
  g.player=Vector2(650,850);g.surface.direction=Vector2.RIGHT;HoldFolk.prepare(g);settle()
  g.handworks.data().skills.mason=8
  if sample>=3:
   var kinds=["stone"] if sample==3 else ["stone","log"] if sample==4 else ["log","log"]
   for kind in kinds:g.handworks.spawn(kind,g.player,3,"film59");key(KEY_E);await frames(24)
  for f in 60:
   for dir in ["right","left","up","down"]:Input.action_release(dir)
   if f<24:Input.action_press("right")
   elif f<30:pass
   elif f<54:Input.action_press("left")
   for i in 2:g._process(1.0/60);await process_frame
   g.camera=g.surface.camera_target();g.update_hud();g.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/frame-%04d.png"%count);count+=1
  for dir in ["right","left","up","down"]:Input.action_release(dir)
 print("MOTION59 FILM COMPLETE: ",count," native frames, held pick/axe/tray/single/mixed/two-log movement and stops")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
