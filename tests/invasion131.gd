extends "res://tests/support/game_fixture.gd"
func shot(name:String):
 g.update_hud();g.sync_hud_controls();g.queue_redraw()
 for i in 30:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func hall():
 g.surface.enter("room:throne",Vector2(650,600));settle();g.player=HoldRoyalStage.current(g).p+Vector2(0,45);HoldConversation.start(g,"eirik")
func watch(kind:String,choice:String=""):
 var limit=0
 while g.opening_scene is HoldThaneScene131 and limit<20:
  limit+=1;var scene=g.opening_scene
  check(scene.mode==kind,"Correct scene "+kind)
  for a in scene.cast:
   for t in [0.0,.5,1.0]:check(g.surface.walkable(a.from.lerp(a.to,t)),"Clear cast route "+kind+" "+a.id)
  if not scene.royal.is_empty():
   for t in [0.0,.5,1.0]:check(g.surface.walkable(scene.royal.from.lerp(scene.royal.to,t)),"Royal route stays clear")
  if scene.needs_choice():
   var beat=scene.step;scene.finish();check(scene.step==beat and g.opening_scene==scene,"Skip stops at explicit "+kind+" choice")
   check(HoldInvasion131.choose(g,"duel" if kind=="ceremony" else "trial",choice),"Explicit response accepted")
   check(not HoldInvasion131.choose(g,"duel" if kind=="ceremony" else "trial",choice),"Response cannot repeat")
   scene.step+=1;scene.show_line();continue
  if scene.step==1:
   g.save_game();g.start_game(true);settle();scene=g.opening_scene
   check(scene is HoldThaneScene131 and scene.step==1,"Scene resumes saved beat "+kind)
   check(not g.calendar_button.visible,"Scene hides interactive HUD after reload")
  scene.tick(.1);var step=scene.step;scene.advance();check(scene.step==step,"Advance waits for motion")
  if kind in ["king","return","trial"] and scene.step in [1,2,3]:scene.tick(1.1);await shot(kind+"-"+str(scene.step))
  if kind=="ceremony" and scene.step==5:scene.tick(1.2);await shot("gate-breach")
  scene.tick(4);scene.tick(.01)
  if scene.step==0 or scene.step==scene.lines.size()-1:await shot(kind+"-"+str(scene.step))
  scene.advance();settle()
 check(limit<20 and g.opening_scene==null and g.hud.visible,"Scene ends and restores play "+kind)
func win_wave():
 g.close_panel();g.combat.armed=true;g.fight.spawn()
 check(not g.fight.enemies.is_empty(),"Encounter contains real enemies")
 for e in g.fight.enemies:
  check(g.fight.body_open(e.p,float(HoldEnemyRoster.spec(e.kind).body)),"Enemy body clears geometry")
  if e.hp<=0:continue # A real cleaving swing may defeat a nearby companion too.
  var hp=e.hp;var before=g.state.combat.cleared.size();var hits=0
  while e.hp>0 and hits<80:
   hits+=1;g.player=HoldInvasion131.point(g,e.p+Vector2(-36,0));g.fight.locked_aim=(e.p-g.player).normalized();g.fight.resolve()
  check(e.hp<=0 and g.state.combat.cleared.size()>before,"Player attack geometry earns defeat")
  check(hits>0 and hp>0,"A living foe requires a player contact")
 check(HoldInvasion131.wave_clear(g.state),"Recorded wave clears only after all defeats")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not HoldInvasion131.eligible(g.state),"Legacy fortunes do not receive the frontier invasion")
 HoldFirstVisit99.begin(g);settle();HoldFrontier103.data(g.state).home_reward=true;g.state.claim_id="copper_ridge";HoldGreatClaim102.data(g.state).points=220
 var q=HoldAncestralClaim.data(g.state);q.stage=4;q.family=true;q.archive=true
 g.surface.enter(HoldFrontier103.room(g.state,"survey"));settle();at(Vector2(480,500));HoldMountain104.act(g,"translate")
 var c=HoldClaim127.data(g.state);c.stage=3;c.arrived=true;c.wards={"crownward":true,"hearthward":true,"forgeward":true};HoldFrontier103.data(g.state).keldrath_open=true
 check(not HoldInvasion131.eligible(g.state),"Reception is required before chapter")
 c.welcomed=true
 check(HoldInvasion131.data(g.state).stage==0,"Existing welcomed save receives preparations additively")
 for area in ["crownward","hearthward","forgeward","room:throne"]:g.surface.enter(area);settle()
 g.surface.enter("claim");settle()
 for item in ["stone","wood","iron"]:g.state.add(item,1000)
 var architecture=g.surface.architecture;architecture.selected="cottage";architecture.furnish_plan=true;at(Vector2(2480,820))
 check(architecture.place(Vector2(2480,700)),"Player-built house exists before invasion")
 var house=architecture.data().instances[-1].duplicate(true)
 g.surface.enter(HoldBuildingPlans.room_id(str(house.id)));settle();g.surface.house.data()
 house=architecture.record(str(house.id)).duplicate(true)
 var old_claim=g.state.claim_id
 g.state.surface.chests["keldrath:quarters"].items={"coal":7};var chests=g.state.surface.chests.duplicate(true)
 var decor=g.state.surface.decor.duplicate(true);var romances=HoldCourtship101.all(g.state).duplicate(true)
 for i in 3:
  var spec=HoldInvasion131.PREP[i]
  check(not HoldInvasion131.supply(g,i),"Remote supplies rejected")
  g.surface.enter(spec.area);settle();at(HoldInvasion131.point(g,spec.p))
  for item in spec.cost:g.state.inventory[item]=0
  check(not HoldInvasion131.supply(g,i),"Missing supplies not paid")
  for item in spec.cost:g.state.add(item,spec.cost[item])
  key(KEY_E);check(g.panel_id=="invasion131","Real E opens preparation")
  button("Deliver");check(HoldInvasion131.data(g.state).prep.has(str(i)),"Supply delivered once")
  check(not HoldInvasion131.supply(g,i),"Duplicate supply rejected")
 hall();check(HoldInvasion131.start(g,"ceremony"),"Local prepared player starts ceremony")
 await watch("ceremony","accept")
 check(HoldInvasion131.active(g.state) and not HoldInvasion131.data(g.state).thane,"Betrayal starts playable invasion without early title")
 var prepared=HoldInvasion131.data(g.state).duplicate(true)
 for front_index in 7:
  var d=HoldInvasion131.data(g.state);check(d.front==front_index,"Fronts are sequential")
  var spec=HoldInvasion131.FRONTS[front_index];g.surface.enter(spec.area);settle();at(HoldInvasion131.task_point(g));g.fight.spawn()
  check(g.fight.enabled(),"Surface uses existing combat controller")
  check(not HoldInvasion131.finish_front(g),"Enemy fight cannot be bypassed by task")
  if front_index==0:
   var enemy=g.fight.enemies[0];enemy.hp-=7;g.state.combat.wounds[enemy.id]=enemy.hp;var expected=enemy.hp
   g.save_game();g.start_game(true);settle();g.fight.spawn();check(g.fight.enemies[0].hp==expected,"Enemy wounds persist through reload")
   var money=g.state.money;g.perform_rescue("test defeat");settle()
   check(g.surface.area=="room:throne" and g.state.money==money and HoldInvasion131.data(g.state).front==0,"Infirmary rescue preserves wealth and front")
   at(Vector2(650,700));check(HoldInvasion131.rest(g) and not HoldInvasion131.rest(g),"Infirmary ration once per front")
   g.surface.enter(spec.area);settle();g.fight.spawn()
  for wave in spec.waves.size():
   win_wave();at(HoldInvasion131.task_point(g))
   if wave<spec.waves.size()-1:HoldInvasion131.tick(g,.1,false);check(HoldInvasion131.data(g.state).wave==wave+1,"Next group arrives")
  at(HoldInvasion131.task_point(g));await shot("secured-front-"+str(front_index))
  check(HoldInvasion131.finish_front(g),"Cleared front unlocks local practical task")
  if front_index==3:await watch("king")
  elif spec.task=="escort":
   if front_index==0:
    var escort=HoldInvasion131.data(g.state).escort.duplicate();g.save_game();g.start_game(true);settle()
    check(HoldInvasion131.data(g.state).escorting and HoldInvasion131.data(g.state).escort==escort,"Citizen escort survives reload")
   var destination=HoldInvasion131.refuge(g);at(destination)
   for i in 70:HoldInvasion131.tick(g,.1,false)
   check(not HoldInvasion131.data(g.state).escorting,"Citizen reaches refuge physically")
  elif spec.task=="work":
   for i in 10:HoldInvasion131.tick(g,.1,false)
   check(g.invasion_time131==0,"Mechanism needs held E")
   for i in 36:HoldInvasion131.tick(g,.1,true)
  check(JSON.parse_string(JSON.stringify(g.state.surface.chests))==JSON.parse_string(JSON.stringify(chests)) and JSON.parse_string(JSON.stringify(g.state.surface.decor))==JSON.parse_string(JSON.stringify(decor)),"Real possessions unchanged at front "+str(front_index))
 check(HoldInvasion131.data(g.state).stage==3 and HoldInvasion131.data(g.state).secured.size()==7,"All seven fronts earned")
 g.surface.enter("crownward");settle();at(HoldInvasion131.point(g,Vector2(780,720)))
 check(HoldInvasion131.start(g,"return"),"King returns after securing city")
 await watch("return")
 hall();check(HoldInvasion131.start(g,"trial"),"Captured Skarrin receives trial")
 await watch("trial","justice")
 check(HoldInvasion131.data(g.state).stage==5 and not HoldInvasion131.data(g.state).thane,"Verdict does not silently grant title")
 hall();check(HoldInvasion131.start(g,"investiture"),"Earned investiture begins")
 await watch("investiture")
 check(HoldInvasion131.data(g.state).thane and HoldAncestralClaim.data(g.state).title=="Thane","Actual saved Thaneship")
 check(not HoldInvasion131.complete_scene(g,"investiture"),"Investiture cannot repeat XP or title award")
 g.surface.enter("trail",Vector2(760,905));settle();check(HoldInvasion131.start(g,"home"),"Return to original trial yard")
 await watch("home")
 check(JSON.parse_string(JSON.stringify(g.surface.architecture.record(str(house.id))))==JSON.parse_string(JSON.stringify(house)),"Original player house and rooms survive the chapter")
 check(HoldInvasion131.data(g.state).stage==7 and g.state.claim_id==old_claim,"Same frontier remains at chapter endpoint")
 check(JSON.parse_string(JSON.stringify(g.state.surface.chests))==JSON.parse_string(JSON.stringify(chests)) and JSON.parse_string(JSON.stringify(g.state.surface.decor))==JSON.parse_string(JSON.stringify(decor)) and HoldCourtship101.all(g.state)==romances,"Homecoming preserves possessions and relationships")
 var saved=HoldInvasion131.data(g.state).duplicate(true);g.save_game();g.start_game(true);settle();check(HoldInvasion131.data(g.state)==saved,"Completed chapter survives reload")
 # Both duel choices and all trial opinions remain explicit, fixed-verdict branches.
 for opinion in ["mercy","lament"]:
  var d=HoldInvasion131.data(g.state);d.stage=4;d.trial="";hall();HoldInvasion131.start(g,"trial");g.opening_scene.finish()
  check(g.opening_scene.needs_choice(),"Skip cannot choose trial opinion")
  check(HoldInvasion131.choose(g,"trial",opinion),"Alternative testimony "+opinion)
  g.opening_scene.finish();check(d.stage==5,"Alternative testimony preserves fixed verdict")
 var d=HoldInvasion131.data(g.state);d.stage=0;d.duel="";hall();HoldInvasion131.start(g,"ceremony");g.opening_scene.finish()
 check(HoldInvasion131.choose(g,"duel","refuse"),"Refuse duel branch available")
 g.opening_scene.finish();check(d.stage==2 and d.duel=="refuse","Refusal still leads coherently to defense")
 hall();d.stage=5;HoldInvasion131.start(g,"investiture");g.show_title();await process_frame
 check(g.opening_scene==null,"Title removes staged actors")
 g.start_game(true);settle();check(g.opening_scene is HoldThaneScene131,"Title continue resumes scene")
 g.start_game(false);settle();check(g.opening_scene==null and g.ui.visible and not HoldInvasion131.eligible(g.state),"Different fortune clears staged chapter")
 print("INVASION131: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
