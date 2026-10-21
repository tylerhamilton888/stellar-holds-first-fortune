extends "res://tests/support/game_fixture.gd"
func scene_tick(scene,seconds:float):
 for i in int(seconds*60):
  if not is_instance_valid(scene) or scene.finished:break
  while HoldFolk.warming():HoldFolk.warm_step()
  scene.tick(1.0/60)
  if i%12==0:await process_frame
func next(scene):scene.age=1;scene.advance()
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://intro53";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 check(g.opening_scene!=null and g.opening_scene.mode=="arrival","New game retains the illustrated arrival")
 g.opening_scene.age=1;g.opening_scene.finish();await process_frame
 var scene=g.opening_scene;scene.set_process(false);settle()
 check(scene is HoldArrivalEscort and g.surface.area=="hearthward","Arrival hands off to Ivar in the actual hold")
 await snap("01-welcome")
 var inventory=g.state.inventory.duplicate(true)
 next(scene);await scene_tick(scene,4);await snap("02-walk")
 check(g.player!=HoldArrivalEscort.STREET[0] and g.walking_pose and scene.ivar_walking,"Ivar leads and the player walks with the drawn gait")
 # Resume the real persisted pending state as though the application closed mid-scene.
 g.save_game();scene.layer.queue_free();g.opening_scene=null;await process_frame;g.start_game(true)
 scene=g.opening_scene;scene.set_process(false)
 check(scene is HoldArrivalEscort and g.surface.walkable(g.player),"Interrupted welcome resumes safely on load")
 next(scene);await scene_tick(scene,15)
 check(scene.step==2 and not scene.failed_route,"Full escort route is clear of buildings, gateposts, fountain and benches")
 check(g.player.distance_to(scene.guide)>40,"Guide keeps a comfortable lead at the doorway")
 await snap("03-quarters-door")
 next(scene);await scene_tick(scene,4)
 check(scene.step==4 and g.surface.area=="room:home","Both actors use the matching quarters doorway and walk into the room")
 await snap("04-your-room")
 next(scene);await snap("05-settle-first");next(scene);await scene_tick(scene,4);await process_frame
 check(g.opening_scene==null and HoldOnboarding.settling(g.state),"Ivar walks out and returns control with a settle-in objective")
 check(g.state.inventory==inventory,"Orientation does not spend or invent pack resources")
 g.surface.enter("room:commission");settle();at(Vector2(620,400));key(KEY_E)
 var can_skip=false
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.contains("I am ready to work"):can_skip=true
 check(not can_skip,"Ivar reminds the player to settle before introductions")
 g.close_panel();g.surface.enter("room:home");settle()
 at(Vector2(328,388));key(KEY_E);await frames(100)
 check(HoldOnboarding.ensure(g.state).get("settle_bed",false),"E at the visible bed records resting")
 at(Vector2(650,460));key(KEY_E)
 check(g.panel_id=="storage" and HoldOnboarding.stage(g.state)==2 and not HoldOnboarding.settling(g.state),"Checking the real chest unlocks introductions after resting")
 var n=g.state.count("water");check(g.surface.transfer("water",1,true)==1 and g.state.count("water")==n-1,"Borrowed chest stores real carried supplies")
 check(not g.surface.recover_chest(),"Borrowed room furniture cannot be dismantled for free materials")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(g.opening_scene==null and g.surface.area=="room:home" and g.state.surface.chests["keldrath:quarters"].items.water==1,"Reload keeps settled progress and chest contents without replaying intro")
 at(Vector2(480,590));key(KEY_E);settle()
 check(g.surface.area=="hearthward" and g.player.distance_to(HoldWorldZones.door(7))<100 and g.surface.walkable(g.player),"Quarters exit returns to its own visible door")
 for entry in [["forge","borin"],["market","orla"],["tavern","hedrik"]]:
  g.surface.enter("room:"+entry[0]);settle();at(Vector2(620,400));key(KEY_E);button("Introduce myself");button("Thank you. I will");g.close_panel()
 check(g.state.opening==1,"New settling quest joins the existing three introductions and first coal commission")
 # Old progress without the additive intro flags must keep its stage and pack.
 var q=HoldOnboarding.ensure(g.state);q.erase("escort_pending");q.erase("settle_required");q.erase("settled");q.stage=5;var pack=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.opening_scene==null and HoldOnboarding.stage(g.state)==5 and g.state.inventory==pack,"Existing fortunes are not pulled backwards into the new tutorial")
 g.start_game(false);g.opening_scene.finish();await process_frame;scene=g.opening_scene;scene.set_process(false);scene.finish();await process_frame
 check(g.opening_scene==null and g.surface.area=="room:home" and HoldOnboarding.settling(g.state),"Skip walk arrives safely in quarters and retains usable objectives")
 at(Vector2(650,460));key(KEY_E);g.close_panel();at(Vector2(328,388));key(KEY_E);await frames(100)
 check(HoldOnboarding.stage(g.state)==2,"Bed and chest objectives work in either order after skipping")
 await snap("06-ready-to-meet")
 print("INTRO53: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;await process_frame;quit(1 if failed else 0)
