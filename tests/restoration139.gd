extends "res://tests/support/game_fixture.gd"
const R=preload("res://scripts/restoration139.gd")
const L=preload("res://scripts/ledger137.gd")
const W=preload("res://scripts/work132.gd")
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func ledger():
 desk("lodge");at(Vector2(670,440))
func site():
 g.surface.enter("trail");settle();at(R.SITE)
func produce(recipe:String,count:int):
 desk("forge")
 for i in count:
  check(HoldFrontier103.transact(g,"craft",recipe),"Real production queued: "+recipe)
  g.state.tick(30)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not R.active(g.state) and not R.complete(g.state),"Unrelated fortunes retain their river")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 check(not R.witnessed(s) and not R.data(s).legacy,"Fresh fortunes cannot acquire the legacy exemption")
 s.money=5000;s.opening=2
 for item in HoldData.ITEMS:s.add(item,300)
 site();check(not R.inspect(g) and not g.surface.walkable(R.CENTER),"Northern river remains closed before rescue")
 var q=HoldAncestralClaim.data(s);q.stage=3
 check(not R.unlocked(s),"Rescue alone cannot skip the Winter Stores")
 HoldCampaign138.data(s).winter_ready=true;HoldFirstVisit99.data(s).rewarded=true;HoldFirstVisit99.data(s).ivar_spoken=true;HoldFirstVisit99.data(s).room_seen=true;HoldFirstVisit99.data(s).home_made=true;HoldFrontier103.data(s).permit=true
 check(R.unlocked(s) and g.surface.walkable(g.player) and R.near(g),"Restoration unlocks at a reachable west-bank site")
 key(KEY_E);check(g.panel_id=="restoration139" and g.menu_paused,"Physical E opens the paused project book");await snap("01-ruins-panel");g.close_panel()
 at(Vector2(1140,500));Input.action_press("right")
 for i in 80:g.surface.move(1.0/60)
 Input.action_release("right")
 check(g.player.x<=1170,"Movement stops at the missing span")
 at(R.SITE)
 check(not L.contribute(g,"north_bridge","wood",1),"Remote material deposits rejected")
 check(R.inspect(g) and not R.inspect(g),"Inspection is local and once-only")
 await snap("02-old-abutments")
 ledger();var wood=s.count("wood")
 check(L.contribute(g,"north_bridge","wood",7) and s.count("wood")==wood-7,"Partial bridge structure paid exactly once")
 check(not L.contribute(g,"north_bridge","wood",18) and not L.contribute(g,"north_bridge","food",1),"Overfill and wrong structural materials rejected")
 check(not R.order(g,"smith","parts",1),"Research and production protect specialist deliveries")
 desk("survey")
 for tech in ["stoneworking","fine_masonry","metallurgy","hearthkeeping"]:check(HoldFrontier103.transact(g,"research",tech),"Use real research: "+tech)
 ledger();check(not R.order(g,"smith","parts",4),"Bought parts cannot stand in for own production")
 produce("parts",2);ledger()
 var parts=s.count("parts")
 check(R.order(g,"smith","parts",1) and s.count("parts")==parts-1,"Specialist orders accept partial supply")
 check(not R.order(g,"builder","wood",1),"Cannot switch a partly supplied order")
 g.save_game();g.start_game(true);settle();s=g.state;ledger()
 check(R.data(s).inspected and L.paid(s,"north_bridge","wood")==7 and R.data(s).order_paid.amount==1,"Both escrow systems and investigation survive real reload")
 check(R.order(g,"smith","parts",3) and R.data(s).orders.size()==1,"Exact remaining parts complete one shift")
 check(W.available(s,"parts")==0 and not R.order(g,"smith","parts",1),"Production proof cannot be reused after delivery")
 check(not R.order(g,"unknown","parts",1) and not R.order(g,"smith","food",1) and not R.order(g,"smith","parts",-1),"Invalid order inputs are harmless")
 # The production owner has separate real bench/cart coverage; test its credited stock here.
 W.produced(s,"wood",20,"cut");ledger()
 check(R.order(g,"builder","wood",8),"Builder can supply a portion of the next shift")
 check(not R.order(g,"builder","wood",13),"Partial order cannot overfill")
 check(R.order(g,"builder","wood",12),"Builder completes second shift")
 produce("barley_bread",6);ledger()
 check(R.order(g,"provisioner","barley_bread",6) and R.data(s).orders.size()==3,"Crop-only cooked supplies complete mixed specialist route")
 check(not R.order(g,"provisioner","barley_bread",1),"Fourth required shift cannot consume supplies")
 g.open_panel("restoration139");await process_frame;await process_frame;g.menu_scroll.scroll_vertical=950;await snap("02b-specialist-orders");g.close_panel()
 check(not R.assemble(g),"Project cannot assemble remotely")
 for item in L.remaining(s,"north_bridge"):
  check(L.contribute(g,"north_bridge",item,int(L.remaining(s,"north_bridge")[item])),"Complete bridge structure: "+item)
 # Ancestry research can proceed alongside restoration; recognition must wait for its witness.
 q=HoldAncestralClaim.data(s);q.stage=4;q.family=true;q.archive=true
 desk("survey");check(not HoldMountain104.act(g,"translate"),"Fresh ancestry cannot bypass the major project")
 site();var points=int(HoldGreatClaim102.data(s).points);var inventory=s.inventory.duplicate(true)
 check(R.assemble(g) and s.inventory==inventory,"Fitting the bridge does not charge escrow twice")
 check(int(HoldGreatClaim102.data(s).points)==points+100 and not R.assemble(g),"Bridge recognition is once-only")
 for x in range(1100,1400,10):check(g.surface.walkable(Vector2(x,500)),"Continuous playable crossing at x="+str(x))
 check(not g.surface.walkable(Vector2(1235,440)) and not g.surface.walkable(Vector2(1235,550)),"Bridge cannot open adjacent river or railings")
 check(g.surface.walkable(Vector2(1235,700)),"Original bridge remains usable")
 at(Vector2(1130,600));check(not g.hearth.fishing_spot().is_empty() and g.fieldwork.near_water(),"River fishing remains available away from the new deck")
 at(Vector2(1100,500));Input.action_press("right")
 for i in 100:g.surface.move(1.0/60)
 Input.action_release("right")
 check(g.player.x>1300,"Ordinary movement crosses continuously after restoration")
 check(g.hearth.fishing_spot().is_empty(),"Fishing cannot cast through the restored crossing")
 at(R.CENTER);await snap("03-restored-crossing");at(R.SITE)
 check(R.gather(g) and not R.gather(g),"Local dedication starts exactly one authored scene")
 settle();var scene=g.opening_scene;scene.tick(3);await snap("04-crew-gathering")
 scene.advance();scene.tick(3);await snap("05-skarrin-credit")
 check(scene.step==1 and scene.lines[1][0]=="SKARRIN","Skarrin tries to claim the public credit")
 g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldBridgeScene139 and g.opening_scene.step==1,"Saved scene resumes its own beat without replaying rewards")
 g.opening_scene.finish();await process_frame
 check(R.witnessed(s) and g.hud.visible and g.opening_scene==null,"Skipping scene records witness and restores controls")
 site();check(not R.gather(g),"Witness cannot replay or duplicate rewards")
 desk("survey");check(HoldMountain104.act(g,"translate"),"Witnessed work and independent evidence unlock existing authentication")
 check(HoldClaim127.eligible(s),"Existing public trial follows without replacing its state")
 var tally=HoldClaim127.closed_score(s)
 g.save_game();g.start_game(true);settle();s=g.state;site()
 check(g.surface.walkable(R.CENTER) and R.witnessed(s) and HoldClaim127.closed_score(s)==tally,"Crossing, witness and closed score survive reload")
 # Exercise all three pure-specialist routes as well as the mixed route above.
 var saved=s.surface.restoration139.duplicate(true);var work=s.surface.work132.duplicate(true)
 for spec in [["smith","parts",4],["builder","stone",36],["provisioner","root_hotpot",6],["provisioner","fish_chowder",5]]:
  s.surface.restoration139=saved.duplicate(true);s.surface.restoration139.orders=[];s.surface.restoration139.built=false;s.surface.restoration139.dedicated=false
  s.surface.work132=work.duplicate(true);W.produced(s,spec[1],spec[2]*3,"cut" if spec[0]=="builder" else "made")
  ledger()
  for i in 3:check(R.order(g,spec[0],spec[1],spec[2]),"Repeatable specialist shift: "+spec[0]+" / "+spec[1])
  check(R.ready(s),"Specialization and mixed service yield the same project eligibility")
 s.surface.restoration139=saved;s.surface.work132=work
 # Migration keeps earned ancestry, and doesn't magically build an optional crossing.
 s.surface.erase("restoration139");inventory=s.inventory.duplicate(true)
 check(R.witnessed(s) and not R.complete(s) and s.inventory==inventory,"Established ancestry migration preserves eligibility without world/reward grants")
 ledger();g.open_panel("restoration139");await snap("06-optional-legacy-project");g.close_panel()
 # Late restoration uses the same real completion without changing an authenticated tally.
 s.surface.restoration139=saved.duplicate(true);s.surface.restoration139.built=false;s.surface.restoration139.dedicated=false
 site();points=int(HoldGreatClaim102.data(s).points)
 check(R.assemble(g) and int(HoldGreatClaim102.data(s).points)==points,"Optional late assembly cannot reopen a closed contest")
 HoldClaim127.data(s).stage=3
 check(R.gather(g),"Late optional dedication remains available")
 settle();check(g.opening_scene.lines.size()==2 and not g.opening_scene.cast.any(func(a):return a.id=="road_folk:8"),"Departed Skarrin is not resurrected for optional work")
 while is_instance_valid(g.opening_scene):
  var current=g.opening_scene;current.tick(3);current.advance()
 check(R.witnessed(s) and g.hud.visible,"Normal scene completion records the same witness as skip")
 print("RESTORATION139: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
