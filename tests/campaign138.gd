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
 ledger();check(L.unlocked(s,"storehouse") and not HoldFirstVisit99.data(s).rewarded,"Owned homestead allows civic deposits before the optional first shift")
 HoldFirstVisit99.data(s).rewarded=true;HoldFirstVisit99.data(s).ivar_spoken=true;HoldFirstVisit99.data(s).room_seen=true
 var inventory=s.inventory.duplicate(true)
 check(not C.inspect(g) and not C.assemble(g) and s.inventory==inventory,"Remote site actions cannot spend supplies")
 site();check(g.surface.walkable(g.player) and C.near_site(g),"Construction site has a clear physical approach")
 key(KEY_E);check(g.panel_id=="campaign138" and g.menu_paused,"Physical project point opens a paused restoration panel");await snap("01-project");g.close_panel()
 check(C.inspect(g) and not C.inspect(g),"Site investigation is local and once-only")
 ledger();var wood=s.count("wood")
 check(L.contribute(g,"storehouse","wood",7) and s.count("wood")==wood-7,"Structural materials accept partial deliveries")
 g.save_game();g.start_game(true);settle();s=g.state
 check(C.data(s).inspected and L.paid(s,"storehouse","wood")==7,"Investigation and partial structural supplies survive reload")
 ledger()
 for item in C.STRUCTURE:
  var amount=int(L.remaining(s,"storehouse").get(item,0))
  check(L.contribute(g,"storehouse",item,amount),"Complete structural slot: "+item)
 site();check(L.ready(s,"storehouse"),"Inspected site and delivered supplies suffice without compulsory production lessons")
 # Existing production hooks supply factual history; work132 verifies real bench/cart inputs.
 W.produced(s,"iron_ore",2,"cut");W.produced(s,"coal",1,"cut");W.produced(s,"wood",4,"cut")
 s.opening=2;desk("forge")
 for i in 2:check(HoldFrontier103.transact(g,"craft","iron"),"Queue real introductory smelting")
 s.tick(4);s.tick(4)
 check(C.learned(s,"smelt"),"Completed forge jobs provide the prerequisite")
 site();check(L.ready(s,"storehouse"),"Optional smelting and timber work do not add a hauling gate")
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
 site();check(L.ready(s,"winter"),"Bought provisions may open the stores without a food lesson")
 g.fieldwork.data().kit=true;W.produced(s,"turnip",4,"grown")
 desk("forge");s.add("turnip",2);s.add("water",1)
 check(HoldFrontier103.transact(g,"craft","turnip_stew"),"Crop route queues a real beginner meal")
 s.tick(4);check(C.learned(s,"cook"),"Turnip stew counts as cooking without a fishing detour")
 site();g.open_panel("campaign138");button("Open the provisioned Winter Stores")
 check(C.data(s).winter_ready and g.opening_scene is HoldQuestScene181,"Opening the supplied stores commits progress before its scene")
 await snap("scenes181-winter-stores")
 g.opening_scene.age=1;g.opening_scene.advance();await snap("scenes181-winter-counter")
 g.opening_scene.finish();await process_frame
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
 check(C.progress(s)==5 and C.eligible(s) and C.act(s)==3,"All practical foundations open Act III even without a score threshold")
 HoldFrontier103.data(s).home_reward=false
 check(C.eligible(s),"Registered home improvements are optional for the rescue")
 HoldFrontier103.data(s).home_reward=true
 var history=W.data(s).facts.duplicate(true)
 for spec in [["cut:iron_ore",0],["made:iron",0],["cart_distance",0],["meals",0]]:
  W.data(s).facts[spec[0]]=spec[1];check(C.eligible(s),"Optional profession history is not a campaign gate: "+spec[0]);W.data(s).facts=history.duplicate(true)
 # Food and trade routes are true alternatives, not cumulative profession requirements.
 W.data(s).facts.erase("grown:turnip");W.produced(s,"river_fish",4,"caught")
 check(C.eligible(s),"Fishing replaces farming for identical narrative eligibility")
 var projects=HoldGreatClaim102.data(s).projects.duplicate(true);HoldGreatClaim102.data(s).projects={};W.data(s).seals=[{"trade":"metal"},{"trade":"metal"},{"trade":"metal"}]
 check(C.eligible(s),"Three specialist seals satisfy the same community benchmark")
 W.data(s).seals=[{"trade":"quarry"},{"trade":"table"},{"trade":"metal"}];check(C.eligible(s),"Mixed trade seals have identical narrative eligibility")
 HoldGreatClaim102.data(s).projects=projects;W.data(s).seals=[]
 g.open_panel("campaign138");await snap("04-ready");g.close_panel()
 ledger();check(not HoldMountain104.act(g,"rescue"),"Ledger is not the foreman's local dispatch desk")
 desk("lodge");g.open_panel("frontier103");button("The missing survey crew")
 check(g.opening_scene is HoldQuestScene181 and int(HoldAncestralClaim.data(s).stage)==1,"Accepted rescue begins Ivar's briefing after its saved dispatch")
 check(not HoldMountain104.act(g,"rescue"),"Ivar cannot dispatch the rescue twice")
 await snap("scenes181-rescue-briefing")
 g.opening_scene.age=1;g.opening_scene.advance();await snap("scenes181-rescue-safety")
 g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldQuestScene181 and g.opening_scene.mode=="rescue" and g.opening_scene.step==1,"Rescue briefing resumes without changing the accepted quest")
 g.opening_scene.age=1;g.opening_scene.advance();await snap("scenes181-rescue-journal")
 g.opening_scene.finish();await process_frame
 check(HoldQuestScene181.record(s).seen.rescue and int(HoldAncestralClaim.data(s).stage)==1,"Finishing the briefing neither completes nor resets the rescue")
 var home=s.claim_id;g.save_game();g.start_game(true);settle();s=g.state
 check(C.eligible(s) and C.data(s).winter_ready and s.claim_id==home,"Story eligibility, stocked world and original household survive reload")
 # Migration never consumes items, awards work, resets a story, or withdraws an earned invitation.
 HoldAncestralClaim.data(s).stage=0;s.surface.erase("campaign138");HoldGreatClaim102.data(s).points=180
 inventory=s.inventory.duplicate(true);points=int(HoldGreatClaim102.data(s).points)
 check(C.data(s).legacy_rescue and C.data(s).winter_ready and C.eligible(s),"Established older save retains its rescue invitation and completed storehouse")
 check(s.inventory==inventory and int(HoldGreatClaim102.data(s).points)==points,"Migration does not pay or consume anything")
 await livelihood_path()
 print("CAMPAIGN138: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)

func buy_stock(stock:Dictionary):
 desk("watch")
 for item in stock:
  for i in int(stock[item]):check(HoldFrontier103.transact(g,"trade",item,true),"Purchase civic supply: "+item)
func livelihood_path():
 g.start_game(false);settle();HoldFirstVisit99.begin(g);settle()
 var s=g.state;s.money=10000
 var estate=JSON.parse_string(JSON.stringify(s.surface.homes[s.claim_id]))
 var wood_xp=HoldDisciplines.xp(s,"woodworking");var smith_xp=HoldDisciplines.xp(s,"smithing")
 buy_stock({"coal":8});ledger()
 check(L.contribute(g,"forge","coal",8) and not L.ready(s,"forge"),"Early full fuel deposit still requires a real hearth inspection")
 desk("forge");check(L.inspect(g) and L.ready(s,"forge"),"Inspection recognizes coal supplied before accepting any lesson")
 check(L.finish(g,"forge") and W.proof(s,"cut:coal")==0,"Purchased fuel opens actual smelting and commissions without fake mining credit")
 buy_stock({"stone":46,"wood":43,"iron":9,"food":12})
 ledger()
 for item in C.STRUCTURE:check(L.contribute(g,"storehouse",item,C.STRUCTURE[item]),"Pre-inspection delivery: "+item)
 check(not L.ready(s,"storehouse"),"Structural deposits retain the physical site-inspection requirement")
 site();check(C.inspect(g) and L.ready(s,"storehouse"),"Already delivered materials count immediately when site is inspected")
 check(C.assemble(g) and not C.assemble(g),"Purchased materials build exactly one working civic storehouse")
 ledger();check(L.contribute(g,"winter","food",12),"Purchased provisions count without farming or cooking")
 site();check(C.stock(g) and not C.stock(g),"Site action opens the provisioned stores exactly once")
 desk("stores");check(HoldFrontier103.transact(g,"trade","food",true),"Civic work unlocks its real community trading counter")
 ledger()
 for id in ["watch","rest"]:
  for item in L.remaining(s,id):check(L.contribute(g,id,item,L.remaining(s,id)[item]),"Supply third-livelihood civic project")
  check(L.finish(g,id),"Purchased civic supplies earn ordinary recognition")
 desk("lodge");check(HoldFrontier103.permit(g),"Three completed civic projects earn household recognition without trade lessons")
 check(C.act(s)==2 and not HoldFrontier103.data(s).home_reward,"Recognized household advances the act without home renovation")
 check(not C.eligible(s),"Civic success alone cannot skip rescue preparations")
 desk("forge");at(HoldForge147.BORIN_TALK)
 check(HoldToolCapabilities.commission(g,"steel") and not s.tech.has("extraction"),"Borin supplies the actual expedition capability without personal smithing research")
 desk("survey");check(HoldFrontier103.transact(g,"research","stoneworking"),"Actual support-construction knowledge remains required")
 var facts=HoldOnboarding.ensure(s).facts;facts.sample=1
 check(not C.eligible(s),"A survey still requires a demonstrated return route")
 facts.route_tested=1
 check(C.eligible(s) and C.progress(s)==5,"Supplier livelihood reaches rescue readiness without home improvement or compulsory professions")
 s.steel=false;check(not C.eligible(s),"Missing expedition pick still blocks the rescue");s.steel=true
 s.tech.erase("stoneworking");check(not C.eligible(s),"Missing rescue-support knowledge still blocks dispatch");s.tech.stoneworking=true
 facts.sample=0;check(not C.eligible(s),"Missing survey still blocks dispatch");facts.sample=1
 check(W.data(s).done.is_empty() and W.data(s).earned.is_empty() and W.data(s).facts.is_empty(),"Civic purchases do not invent lesson claims or manufacturing history")
 check(not g.fieldwork.data().kit and not HoldFirstVisit99.data(s).rewarded,"No compulsory field kit or first shift was slipped into the supplier route")
 check(HoldDisciplines.xp(s,"woodworking")==wood_xp and HoldDisciplines.xp(s,"smithing")==smith_xp,"Paid supplies and specialist work preserve personal crafting experience")
 check(JSON.parse_string(JSON.stringify(s.surface.homes[s.claim_id]))==estate,"Civic progression leaves the original cottage unchanged")
 HoldFirstVisit99.data(s).focus="forge";check(HoldFirstVisit99.goal(g).contains("Ivar"),"Ready player is directed to the rescue instead of an unclaimed craft lesson")
 g.open_panel("campaign138");await snap("livelihood177-ready");g.menu_scroll.scroll_vertical=10000;await snap("livelihood177-ready-scrolled");g.close_panel()
 var money=s.money;var inventory=s.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle();s=g.state
 check(C.eligible(s) and s.money==money and s.inventory==inventory,"Already completed civic work survives reload without repeated supplies or rewards")
 desk("lodge");check(HoldMountain104.act(g,"rescue") and not HoldMountain104.act(g,"rescue"),"Supplier route enters the same authored rescue exactly once")
 # Optional lessons retain factual history recorded before their rewards are claimed.
 W.produced(s,"wood",4,"cut");desk("lodge");var proof=W.proof(s,"cut:wood");money=s.money
 check(W.ready(s,"timber") and W.claim_lesson(g,"timber"),"Earlier personal production still earns its optional lesson reward")
 check(not W.claim_lesson(g,"timber") and W.proof(s,"cut:wood")==proof and s.money==money+10,"Optional credit pays once without repeating production")
