extends "res://tests/support/game_fixture.gd"
const C=preload("res://scripts/campaign138.gd")
const L=preload("res://scripts/ledger137.gd")
const W=preload("res://scripts/work132.gd")
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func ledger():
 desk("lodge");at(Vector2(670,440))
func site():
 g.surface.enter("trail");settle();at(C.SITE+Vector2(-20,0))
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not C.active(g.state) and not C.eligible(g.state),"Unrelated legacy fortune is untouched")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 check(C.act(s)==1 and not C.data(s).legacy_rescue,"New fortune starts authored Act I without historical eligibility")
 s.money=1000
 for item in ["stone","wood","iron","iron_ore","coal","food"]:s.add(item,200)
 HoldGreatClaim102.data(s).points=9999
 check(not C.eligible(s),"Arbitrary recognition cannot skip foundations")
 ledger();check(not L.contribute(g,"storehouse","wood",1),"First shift gates new material deposits")
 HoldFirstVisit99.data(s).rewarded=true;HoldFirstVisit99.data(s).ivar_spoken=true;HoldFirstVisit99.data(s).room_seen=true
 var inventory=s.inventory.duplicate(true)
 check(not C.inspect(g) and not C.assemble(g) and s.inventory==inventory,"Remote site actions cannot spend supplies")
 site();check(g.surface.walkable(g.player) and C.near_site(g),"Construction site has a clear physical approach")
 g.surface.action("campaign138");check(g.panel_id=="campaign138" and g.menu_paused,"Physical project point opens a paused restoration panel");await snap("01-project");g.close_panel()
 check(C.inspect(g) and not C.inspect(g),"Site investigation is local and once-only")
 ledger();var wood=s.count("wood")
 check(L.contribute(g,"storehouse","wood",7) and s.count("wood")==wood-7,"Structural materials accept partial deliveries")
 g.save_game();g.start_game(true);settle();s=g.state
 check(C.data(s).inspected and L.paid(s,"storehouse","wood")==7,"Investigation and partial structural supplies survive reload")
 ledger()
 for item in C.STRUCTURE:
  var amount=int(L.remaining(s,"storehouse").get(item,0))
  check(L.contribute(g,"storehouse",item,amount),"Complete structural slot: "+item)
 site();check(not C.assemble(g),"Buying supplies cannot replace practical production and hauling")
 # Existing production hooks supply factual history; work132 verifies real bench/cart inputs.
 W.produced(s,"iron_ore",2,"cut");W.produced(s,"coal",1,"cut");W.produced(s,"wood",4,"cut")
 s.opening=2;desk("forge")
 for i in 2:check(HoldFrontier103.transact(g,"craft","iron"),"Queue real introductory smelting")
 s.tick(4);s.tick(4)
 check(C.learned(s,"smelt"),"Completed forge jobs provide the prerequisite")
 site();check(not C.assemble(g),"Smelting and timber alone cannot replace loaded hauling")
 g.walking_pose=true
 for i in 16:W.cart_moved(g,{"raw":[{"kind":"log"}],"cargo":[]},10)
 var money=s.money;inventory=s.inventory.duplicate(true);var points=int(HoldGreatClaim102.data(s).points)
 check(C.assemble(g),"On-site reconstruction raises the real community building")
 check(s.inventory==inventory and s.money==money and int(HoldGreatClaim102.data(s).points)==points+70,"Previously delivered supplies are not charged twice; only the original reward is paid")
 check(not C.assemble(g),"Completed building cannot repeat its reward")
 await snap("02-building")
 desk("stores");check(not HoldFrontier103.transact(g,"trade","food",true),"Empty storehouse does not prematurely open its counter")
 ledger();check(L.contribute(g,"winter","food",5),"Provisions accept a saved partial delivery")
 check(not L.contribute(g,"winter","food",8),"Excess provisions cannot overfill the project")
 g.save_game();g.start_game(true);settle();s=g.state;ledger()
 check(L.paid(s,"winter","food")==5 and L.contribute(g,"winter","food",7),"Remaining provisions survive reload and finish exactly")
 site();check(not C.stock(g),"Bought provisions do not replace the food introduction")
 g.fieldwork.data().kit=true;W.produced(s,"turnip",4,"grown")
 desk("forge");s.add("turnip",2);s.add("water",1)
 check(HoldFrontier103.transact(g,"craft","turnip_stew"),"Crop route queues a real beginner meal")
 s.tick(4);check(C.learned(s,"cook"),"Turnip stew counts as cooking without a fishing detour")
 site();check(C.stock(g),"Finished food introduction opens the supplied stores")
 var decor=s.surface.decor.size();points=int(HoldGreatClaim102.data(s).points)
 check(not C.stock(g) and decor==s.surface.decor.size() and points==int(HoldGreatClaim102.data(s).points),"Opening cannot duplicate furniture or recognition")
 desk("stores");check(HoldFrontier103.transact(g,"trade","food",true),"Opened storehouse provides actual trading service")
 check(s.surface.decor.filter(func(f):return f.area==HoldFrontier103.room(s,"stores") and f.kind=="barrel").size()>=2,"Provisioned storehouse has persistent physical supplies")
 await snap("03-stocked-interior")
 # Complete the same real household path; the new campaign does not grant or replace a home.
 ledger()
 for id in ["watch","rest"]:
  for item in L.remaining(s,id):check(L.contribute(g,id,item,int(L.remaining(s,id)[item])),"Supply civic project: "+id+" / "+item)
  check(L.finish(g,id),"Finish civic project: "+id)
 desk("lodge");check(HoldFrontier103.permit(g),"Community service earns the existing household plot")
 g.surface.enter("claim");settle();g.surface.architecture.selected="cottage";g.surface.architecture.furnish_plan=true;at(Vector2(2480,820))
 check(g.surface.architecture.place(Vector2(2480,700)),"Build an ordinary furnished player home")
 desk("lodge");check(HoldFrontier103.finish_home(g) and C.act(s)==2,"Home registration advances to Hands of the hold")
 check(not C.eligible(s),"House and stores still require expedition preparation")
 desk("survey");check(HoldFrontier103.transact(g,"research","extraction"),"Research the actual steel method")
 check(HoldFrontier103.transact(g,"research","stoneworking"),"Research actual support construction")
 desk("forge");check(HoldFrontier103.transact(g,"tool","steel"),"Forge the real expedition pick")
 var facts=HoldOnboarding.ensure(s).facts;facts.sample=1
 check(not C.eligible(s),"Survey without a descent and return is insufficient")
 facts.route_tested=1;HoldGreatClaim102.data(s).points=0
 check(C.progress(s)==7 and C.eligible(s) and C.act(s)==3,"All practical foundations open Act III even without a score threshold")
 var history=W.data(s).facts.duplicate(true)
 for spec in [["cut:iron_ore",0],["made:iron",0],["cart_distance",0],["meals",0]]:
  W.data(s).facts[spec[0]]=spec[1];check(not C.eligible(s),"Missing practical requirement cannot be bypassed: "+spec[0]);W.data(s).facts=history.duplicate(true)
 # Food and trade routes are true alternatives, not cumulative profession requirements.
 W.data(s).facts.erase("grown:turnip");W.produced(s,"river_fish",4,"caught")
 check(C.eligible(s),"Fishing replaces farming for identical narrative eligibility")
 var projects=HoldGreatClaim102.data(s).projects.duplicate(true);HoldGreatClaim102.data(s).projects={};W.data(s).seals=[{"trade":"metal"},{"trade":"metal"},{"trade":"metal"}]
 check(C.eligible(s),"Three specialist seals satisfy the same community benchmark")
 W.data(s).seals=[{"trade":"quarry"},{"trade":"table"},{"trade":"metal"}];check(C.eligible(s),"Mixed trade seals have identical narrative eligibility")
 HoldGreatClaim102.data(s).projects=projects;W.data(s).seals=[]
 g.open_panel("campaign138");await snap("04-ready");g.close_panel()
 ledger();check(not HoldMountain104.act(g,"rescue"),"Ledger is not the foreman's local dispatch desk")
 desk("lodge");check(HoldMountain104.act(g,"rescue") and not HoldMountain104.act(g,"rescue"),"Ivar dispatches the prepared player exactly once")
 var home=s.claim_id;g.save_game();g.start_game(true);settle();s=g.state
 check(C.eligible(s) and C.data(s).winter_ready and s.claim_id==home,"Story eligibility, stocked world and original household survive reload")
 # Migration never consumes items, awards work, resets a story, or withdraws an earned invitation.
 HoldAncestralClaim.data(s).stage=0;s.surface.erase("campaign138");HoldGreatClaim102.data(s).points=180
 inventory=s.inventory.duplicate(true);points=int(HoldGreatClaim102.data(s).points)
 check(C.data(s).legacy_rescue and C.data(s).winter_ready and C.eligible(s),"Established older save retains its rescue invitation and completed storehouse")
 check(s.inventory==inventory and int(HoldGreatClaim102.data(s).points)==points,"Migration does not pay or consume anything")
 print("CAMPAIGN138: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
