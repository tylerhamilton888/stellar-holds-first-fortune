extends "res://tests/support/game_fixture.gd"
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func reload_scene():
 g.save_game();g.start_game(true);settle()
 if g.opening_scene is HoldClaimScene127:g.opening_scene.set_process(false)
func shot(name:String):
 g.queue_redraw()
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func watch(kind:String):
 settle()
 check(g.opening_scene is HoldClaimScene127,"In-world "+kind+" scene starts")
 if not g.opening_scene is HoldClaimScene127:return
 g.opening_scene.set_process(false)
 while g.opening_scene is HoldClaimScene127:
  var scene=g.opening_scene;var beat=scene.step
  if beat==1:
   reload_scene();scene=g.opening_scene
   check(scene is HoldClaimScene127 and scene.step==beat,"Reload resumes saved beat: "+kind)
  if not scene is HoldClaimScene127:return
  for a in scene.cast:
   for t in [0.0,.25,.5,.75,1.0]:check(g.surface.walkable(a.from.lerp(a.to,t)),"Clear cast route: "+kind+" "+str(beat)+" "+a.id+" "+str(t))
  scene.tick(.3)
  scene.advance();check(scene.step==beat and scene.next_button.disabled,"Motion is not skipped by immediate advance")
  if (kind=="verdict" and beat in [1,5]) or (kind=="reception" and beat==1):
   for frame in 8:
    scene.tick(.4);await shot(kind+"-motion-"+str(beat)+"-"+str(frame))
  scene.tick(4.0);scene.tick(.01)
  if beat in [0,2,lines_end(scene)]:await shot(kind+"-"+str(beat))
  scene.advance();settle()
 check(g.hud.visible and g.opening_scene==null,"Scene restores controls and HUD: "+kind)
func lines_end(scene)->int:return scene.lines.size()-1
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not HoldClaim127.eligible(g.state),"Legacy fortune cannot enter frontier chapter")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 check(not HoldClaim127.start(g,"trial"),"No trial before authenticated ancestry")
 HoldFrontier103.data(s).home_reward=true;s.claim_id="copper_ridge";HoldGreatClaim102.data(s).points=220
 var q=HoldAncestralClaim.data(s);q.stage=4;q.family=true;q.archive=true
 desk("survey");check(HoldMountain104.act(g,"translate"),"Existing archive/family authentication unlocks chapter")
 var closed=HoldClaim127.closed_score(s)
 HoldGreatClaim102.credit(s,"mining",3)
 check(HoldGreatClaim102.standings(s)[2][1]==closed,"Later work cannot reopen or tilt the tied round")
 # Existing post-authentication saves retain both their historical work and their closed tally.
 s.surface.erase("claim127");check(HoldClaim127.data(s).stage==0 and HoldClaim127.closed_score(s)==closed,"Additive old-save entry uses the recorded authentication award")
 g.surface.enter("claim");settle()
 for item in ["stone","wood","iron"]:s.add(item,1000)
 var architecture=g.surface.architecture;architecture.selected="cottage";architecture.furnish_plan=true;at(Vector2(2480,820))
 check(architecture.place(Vector2(2480,700)),"Existing building system supplies the preserved household")
 var home=architecture.data().instances[-1].duplicate(true)
 g.surface.enter(HoldBuildingPlans.room_id(str(home.id)));settle()
 g.surface.house.data();home=architecture.record(str(home.id)).duplicate(true)
 desk("lodge");check(HoldFrontier103.build_storehouse(g),"Post-round civic construction remains available")
 check(HoldGreatClaim102.standings(s)[2][1]==closed,"Post-round town project cannot alter contest result")
 s.surface.chests["keldrath:quarters"].items={"coal":7};var chest=s.surface.chests["keldrath:quarters"].duplicate(true)
 HoldCourtship101.record(s,"road_folk:11").stage=1;var romance=HoldCourtship101.record(s,"road_folk:11").duplicate(true)
 var money=s.money
 desk("survey");check(not HoldClaim127.start(g,"trial"),"Public hearing cannot start remotely")
 desk("lodge");g.open_panel("frontier103");button("Gather for the public trial");await watch("trial")
 check(HoldClaim127.stage(s)==1,"Announcement leaves the trial playable")
 check(not HoldClaim127.start(g,"verdict"),"Skip cannot bypass physical construction")
 for i in 3:
  var p=HoldClaim127.STATIONS[i];check(g.surface.walkable(p),"Station is physically reachable: "+str(i));at(p)
  var item=HoldClaim127.PARTS[i].cost.keys()[0];var before=s.count(item)
  check(not HoldClaim127.begin_work(g,i,1-int(HoldClaim127.PARTS[i].answer)),"Wrong engineering choice rejected without payment: "+str(i))
  check(s.count(item)==before,"Wrong fitting does not consume materials")
  var supply=s.count(item);s.add(item,-supply)
  check(not HoldClaim127.begin_work(g,i,HoldClaim127.PARTS[i].answer),"Insufficient resources cannot start fitting")
  s.add(item,supply)
  check(HoldClaim127.begin_work(g,i,HoldClaim127.PARTS[i].answer),"Correct local fitting starts physical work")
  for tick in 12:HoldClaim127.tick(g,.1,true)
  check(HoldClaim127.data(s).built==i,"Half-complete work has no premature payout")
  reload_scene();s=g.state;check(g.claim_work127==-1 and s.count(item)==before,"Interrupted work restarts without resource loss")
  at(p);check(HoldClaim127.begin_work(g,i,HoldClaim127.PARTS[i].answer),"Resume unfinished fitting")
  at(p+Vector2(0,100));HoldClaim127.tick(g,.1,true);check(g.claim_work127==-1,"Walking away cancels manual work")
  at(p);HoldClaim127.begin_work(g,i,HoldClaim127.PARTS[i].answer)
  key(KEY_E);Input.action_press("interact");await frames(150);Input.action_release("interact")
  check(HoldClaim127.data(s).built==i+1 and s.count(item)==before-int(HoldClaim127.PARTS[i].cost[item]),"One finished fitting consumes exactly its materials")
  check(not HoldClaim127.begin_work(g,i,HoldClaim127.PARTS[i].answer),"Completed fitting cannot charge twice")
 await snap("assembled-lift")
 check(HoldClaim127.start(g,"verdict"),"Complete physical lift permits public proof test");await watch("verdict");s=g.state
 check(HoldClaim127.stage(s)==3 and HoldFrontier103.data(s).keldrath_open,"Victory opens royal journey")
 check(not g.surface.roads.people("trail").any(func(a):return a.interaction=="road_folk:8"),"Skarrin stays departed after refusal")
 check(not HoldClaim127.start(g,"verdict") and s.money==money,"No repeat verdict or repeat cash award")
 g.surface.enter("hearthward");await watch("journey");s=g.state
 check(HoldClaim127.data(s).arrived and HoldClaim127.data(s).wards.has("hearthward"),"Journey ends in playable Hearthward")
 g.surface.enter("room:throne",Vector2(650,600));settle();check(not HoldClaim127.start(g,"reception"),"Time to visit the wards before reception")
 g.surface.enter("hearthward");settle();at(Vector2(1700,HoldTerraces.STRIDE-1))
 Input.action_press("down");g.surface.move(.02);Input.action_release("down")
 check(g.surface.area=="forgeward" and HoldClaim127.data(s).wards.has("forgeward"),"Walking the seamless Great Stair records Forgeward")
 at(Vector2(1700,1));Input.action_press("up");g.surface.move(.02);Input.action_release("up")
 at(Vector2(150,1));Input.action_press("up");g.surface.move(.02);Input.action_release("up")
 check(g.surface.area=="crownward" and HoldClaim127.data(s).wards.has("crownward"),"Walking the seamless Great Stair records Crownward")
 g.surface.enter("room:throne",Vector2(650,600));settle();at(HoldRoyalStage.current(g).p+Vector2(0,60))
 check(HoldClaim127.start(g,"reception"),"Three wards and royal locality enable reception");await watch("reception");s=g.state
 check(HoldClaim127.data(s).welcomed and HoldAncestralClaim.data(s).stage==5,"Royal reception does not prematurely confer Thaneship")
 check(s.claim_id=="copper_ridge" and JSON.parse_string(JSON.stringify(g.surface.architecture.record(str(home.id))))==JSON.parse_string(JSON.stringify(home)),"Household and home layouts survive the journey")
 check(JSON.parse_string(JSON.stringify(s.surface.chests["keldrath:quarters"]))==JSON.parse_string(JSON.stringify(chest)),"Home chest and its contents remain intact")
 check(HoldCourtship101.record(s,"road_folk:11")==romance,"Romance remains intact")
 g.surface.enter("trail");settle();check(g.surface.area=="trail","Road home remains freely usable")
 # Skip and resume are separate from gameplay rewards; every staged kind is covered.
 for kind in ["trial","verdict","journey","reception"]:
  var d=HoldClaim127.data(s);d.scene=kind;d.beat=1
  HoldClaimScene127.start_scene(g);g.opening_scene.set_process(false);g.opening_scene.finish();await process_frame
  check(g.opening_scene==null and d.scene=="" and g.hud.visible,"Skip restores a playable saved state: "+kind)
 reload_scene();check(HoldClaim127.data(g.state).welcomed,"Chapter completion persists")
 print("CLAIM127: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
