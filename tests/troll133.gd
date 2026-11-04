extends "res://tests/support/game_fixture.gd"
var f
var origin=Vector2.ZERO
func fresh(id:String="troll133/test")->Dictionary:
 f.cancel_actions();f.hurt_wait=0;f.dodge_wait=0;g.state.combat.health=100;g.combat.armed=false
 g.player=origin
 var e=f.make_enemy(id,origin-Vector2(120,0),3);f.enemies=[e]
 return e
func scene_shot(name:String):
 g.queue_redraw();g.opening_scene.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world;w.data.depth=2
 for y in range(10,40):
  for x in range(10,55):w.set_cell(Vector2i(x,y),0);w.layer().seen[Deepworks.key(Vector2i(x,y))]=true
 origin=Deepworks.center(Vector2i(25,25));g.player=origin;f=g.fight;f.key="";f.spawn();g.state.combat.armor="clothes"
 check(HoldEnemyRoster.spec(3).height==220 and HoldEnemyRoster.spec(3).body==50,"Giant art and physical footprint grow together")
 check(HoldEnemyRoster.spec(3).hp==220,"Threat comes from scale and attacks, without inflating health")
 for row in 3:
  var tex=HoldTroll133.ART[row];var bounds=Rect2(Vector2.ZERO,tex.get_size())
  for pose in 8:
   var b=HoldTroll133.BOXES[row][pose]
   check(bounds.encloses(Rect2(b[0],b[1],b[2],b[3])),"Whole troll pose stays in atlas %d/%d" % [row,pose])
  check(tex.get_image().get_pixel(0,0).a<.02,"Troll atlas retains transparent surroundings")
 for angle in 8:
  var e=fresh();e.p=origin-Vector2.from_angle(angle*TAU/8)*120;e.home=e.p
  check(HoldTroll133.begin(f,e),"A fist can target the player from direction "+str(angle))
  check(HoldTroll133.contact(e).distance_to(origin)<HoldTroll133.RADIUS,"Committed landing targets actual player ground position")
  var warning:Vector2=HoldTroll133.contact(e);var facing:Vector2=e.dir
  g.player=warning+Vector2(0,70);f.update(.7)
  check(HoldTroll133.contact(e)==warning and e.dir==facing,"Fist never tracks a dodging player after warning")
  check(e.p.distance_to(e.slam_to133)<.01 and f.body_open(e.p,50),"Preparation plants the enlarged body on valid ground")
  f.update(.8)
  check(g.state.combat.health==100 and e.state=="recover","Walking outside first fist circle avoids damage")
  check((e.p+HoldTroll133.fist_offset(e.dir,e.fist133)).distance_to(warning)<.01,"Painted knuckle contact matches damage-circle center")
 var e=fresh();HoldTroll133.begin(f,e);f.update(HoldTroll133.FIRST_WINDUP+.01)
 check(g.state.combat.health==66 and e.slam_follow133,"Standing at fist contact takes one heavy blow")
 check(HoldEnemyRoster.frame(e)==4,"First impact uses its own planted-fist drawing")
 f.hit_stop=0;f.update(.61)
 check(e.state=="windup" and e.fist133==1 and not e.slam_follow133,"Second fist starts a distinct visible warning")
 var second:Vector2=HoldTroll133.contact(e);g.player=second+Vector2(0,70);f.update(HoldTroll133.SECOND_WINDUP+.01)
 check(g.state.combat.health==66 and e.time==HoldTroll133.RECOVERY,"Second fist misses escaped target and exposes full recovery")
 check(HoldEnemyRoster.frame(e)==6,"Second impact uses the opposite fist drawing")
 f.hit_stop=0;f.update(.8);check(e.state=="recover" and e.time>.9,"Punish window lasts long enough for a counterattack")
 e=fresh();HoldTroll133.begin(f,e);g.player=HoldTroll133.contact(e)+Vector2(HoldTroll133.RADIUS+HoldSkirmish.PLAYER_BODY+.01,0);f.update(1.46)
 check(g.state.combat.health==100,"Contact excludes bodies wholly outside the visible circle")
 e=fresh();HoldTroll133.begin(f,e);g.player=HoldTroll133.contact(e)+Vector2(HoldTroll133.RADIUS+HoldSkirmish.PLAYER_BODY-.01,0);f.update(1.46)
 check(g.state.combat.health==66,"A body touching the circle edge receives contact")
 e=fresh();HoldTroll133.begin(f,e);f.update(1.32);g.combat.armed=true;f.aim=Vector2.DOWN;key(KEY_SPACE);f.update(.14)
 check(g.state.combat.health==100,"Actual Space input grants dodge protection at fist impact")
 e=fresh();HoldTroll133.begin(f,e);f.update(.4);f.stagger(e,1);f.update(1.5)
 check(g.state.combat.health==100 and not e.slam_follow133,"Interrupt cancels the committed blow and follow-up")
 e=fresh();HoldTroll133.begin(f,e);var remaining=e.time;g.open_panel("inventory");f.update(2)
 check(e.time==remaining and g.state.combat.health==100,"Menus pause giant attacks");g.close_panel()
 var blocker=Deepworks.cell(e.slam_to133);w.set_cell(blocker,2);f.update(.5)
 check(e.state=="recover" and not e.slam_follow133 and g.state.combat.health==100,"New solid terrain cancels the step without damage or tunnelling");w.set_cell(blocker,0)
 e=fresh();var center=Deepworks.cell(e.p);w.set_cell(center+Vector2i(1,1),2)
 check(not f.body_open(e.p,50),"Large body respects diagonal terrain corners");w.set_cell(center+Vector2i(1,1),0)
 w.set_cell(center+Vector2i(1,0),2)
 var fitted=HoldTroll133.fit_spawn(f,e.p)
 check(fitted!=null and fitted!=e.p and f.body_open(fitted,50),"Old small-body spawn relocates to connected clear floor")
 check(w.at(center+Vector2i(1,0))==2,"Spawn fitting never excavates saved terrain");w.set_cell(center+Vector2i(1,0),0)
 e=fresh();var old=e.hp;g.state.combat.wounds[e.id]=117;var loaded=f.make_enemy(e.id,e.p,3)
 check(loaded.hp==117 and loaded.max==old,"Saved troll wounds survive new size and move set")
 g.state.combat.wounds.erase(e.id)
 e=fresh();g.combat.armed=true;g.state.combat.weapon="axe";g.surface.direction=Vector2.LEFT
 await snap("01-dwarf-and-giant")
 HoldTroll133.begin(f,e);f.update(.7);await snap("02-first-fist-warning")
 g.player=origin+Vector2(0,70);f.update(.76);await snap("03-first-fist-contact")
 f.hit_stop=0;f.update(.61);f.update(.5);await snap("04-second-fist-warning")
 f.update(.61);await snap("05-second-fist-contact")
 e.state="idle";e.walk=true;e.p=origin+Vector2(80,70);f.hit_stop=0;f.impacts.clear();g.notice_time=0
 for row in 3:
  e.dir=[Vector2(1,1),Vector2.RIGHT,Vector2(1,-1)][row]
  for i in 8:e.gait=float(i)/20;await snap("walk-%d-%02d"%[row,i])
 # The optional perspective view uses the same new whole-body frames and landing circle.
 g.depth_nav.explore.enabled=true;g.depth_nav.explore.mouse_look=false;g.depth_nav.explore.sync(.1)
 check(g.depth_nav.explore.textures.keys().any(func(k):return "trolls133" in k),"Perspective view resolves the new troll atlas")
 var view=g.depth_nav.explore;var preference=view.distance
 for mode in 4:
  view.mouse_look=mode!=0;view.pitch=.38 if mode==1 else 1.18 if mode==2 else .62;view.distance=5 if mode>0 else preference
  HoldTroll133.begin(f,e);f.update(.7);view.sync(.1)
  var facing:Vector2=e.dir.rotated(view.heading());var pose=HoldTroll133.region(e,facing)
  var top=view.point(e.p)-view.camera.global_basis.y*(pose.source.position.y-pose.root.y)*pose.scale/40
  var head=view.camera.unproject_position(top);var feet=view.camera.unproject_position(view.point(g.player))
  check(head.y>77 and feet.y<374,"Perspective giant head and player feet clear the HUD at camera mode "+str(mode))
  check(view.distance==(5 if mode>0 else preference),"Encounter framing preserves the saved zoom preference")
  await snap("perspective-%d"%mode)
 view.distance=preference;view.pitch=.62
 g.depth_nav.explore.enabled=false;g.depth_nav.explore.sync(.1)
 # Stage the actual royal encounter, including reload and all five giant silhouettes.
 g.start_game(false);settle();HoldFirstVisit99.begin(g);settle();HoldFrontier103.data(g.state).home_reward=true;g.state.claim_id="copper_ridge";HoldGreatClaim102.data(g.state).points=220
 var q=HoldAncestralClaim.data(g.state);q.stage=4;q.family=true;q.archive=true
 g.surface.enter(HoldFrontier103.room(g.state,"survey"));settle();at(Vector2(480,500));HoldMountain104.act(g,"translate")
 var c=HoldClaim127.data(g.state);c.stage=3;c.arrived=true;c.welcomed=true;HoldFrontier103.data(g.state).keldrath_open=true
 var d=HoldInvasion131.data(g.state);d.stage=2;d.front=3;d.scene="king";d.beat=0
 HoldThaneScene131.start_scene(g);settle()
 var scene=g.opening_scene;check(scene.foes.size()==5,"King faces all five giant trolls")
 for troll in scene.foes:
  check(f.body_open(troll.p,50),"Royal giant's enlarged base fits its landing")
  var pose=HoldTroll133.region(troll,troll.dir);var rect=Rect2(troll.p-g.camera+(pose.source.position-pose.root)*pose.scale,pose.source.size*pose.scale)
  check(Rect2(0,46,960,352).encloses(rect),"Whole royal giant fits above the caption and below the title")
 scene.tick(1);await scene_shot("06-king-five-giants")
 scene.step=2;scene.show_line();scene.tick(.7);await scene_shot("07-king-meets-fist")
 scene.tick(.6);await scene_shot("08-king-counter")
 g.save_game();g.start_game(true);settle();check(g.opening_scene is HoldThaneScene131 and g.opening_scene.foes.size()==5,"Saved royal scene restores all five giant actors")
 g.opening_scene.finish();d=HoldInvasion131.data(g.state);d.scene="return";d.stage=3;d.beat=1;HoldThaneScene131.start_scene(g);settle();g.opening_scene.tick(1.4)
 await scene_shot("09-king-trophy")
 check(HoldThaneScene131.RETURN133.get_width()>0,"Larger royal trophy art resolves natively")
 g.opening_scene.finish()
 print("TROLL133: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
