extends "res://tests/support/game_fixture.gd"
func scene_shot(name:String):
 g.queue_redraw();g.opening_scene.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 var f=g.fight
 # Stage the actual royal encounter, including reload and all five giant silhouettes.
 g.start_game(false);settle();HoldFirstVisit99.begin(g);settle();HoldFrontier103.data(g.state).home_reward=true;g.state.claim_id="copper_ridge";HoldGreatClaim102.data(g.state).points=220
 var q=HoldAncestralClaim.data(g.state);q.stage=4;q.family=true;q.archive=true
 g.surface.enter(HoldFrontier103.room(g.state,"survey"));settle();at(Vector2(480,500));HoldMountain104.act(g,"translate")
 var c=HoldClaim127.data(g.state);c.stage=3;c.arrived=true;c.welcomed=true;HoldFrontier103.data(g.state).keldrath_open=true
 var d=HoldInvasion131.data(g.state);d.stage=2;d.front=3;d.scene="king";d.beat=0
 HoldThaneScene131.start_scene(g);settle()
 var scene=g.opening_scene;scene.set_process(false);check(scene.foes.size()==5,"King faces all five giant trolls")
 for troll in scene.foes:
  check(f.body_open(troll.p,50),"Royal giant's enlarged base fits its landing")
  var pose=HoldTroll133.region(troll,troll.dir);var rect=Rect2(troll.p-g.camera+(pose.source.position-pose.root)*pose.scale,pose.source.size*pose.scale)
  check(Rect2(0,46,960,352).encloses(rect),"Whole royal giant fits above the caption and below the title")
 scene.tick(1);await scene_shot("06-king-five-giants")
 scene.step=2;scene.show_line();scene.tick(.7);await scene_shot("07-king-meets-fist")
 scene.tick(.6);await scene_shot("08-king-counter")
 for i in 4:
  scene.age=i*.45+.1;await scene_shot("battle-"+str(i))
 g.save_game();g.start_game(true);settle();check(g.opening_scene is HoldThaneScene131 and g.opening_scene.foes.size()==5,"Saved royal scene restores all five giant actors")
 g.opening_scene.finish();d=HoldInvasion131.data(g.state);d.scene="return";d.stage=3;d.beat=1;HoldThaneScene131.start_scene(g);settle();g.opening_scene.set_process(false);g.opening_scene.tick(1.4)
 await scene_shot("09-king-trophy")
 for i in 4:
  g.opening_scene.age=1.01+i*.25;await scene_shot("return-"+str(i))
 check(HoldThaneScene131.RETURN133.get_width()>0,"Larger royal trophy art resolves natively")
 g.opening_scene.finish()
 print("ROYAL134 REVIEW: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
