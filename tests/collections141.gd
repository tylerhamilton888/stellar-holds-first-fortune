extends "res://tests/support/game_fixture.gd"
const C=preload("res://scripts/collections141.gd")
const W=preload("res://scripts/work132.gd")
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func ledger():desk("lodge");at(Vector2(670,440))
func craft(id:String,n:int):
 desk("forge")
 for i in n:
  check(HoldFrontier103.transact(g,"craft",id),"Real crafting: "+id);g.state.tick(30)
 ledger()
func deliver(id:String):
 for item in C.costs(g.state,id):
  var left=C.remaining(g.state,id,item)
  if left>0:check(C.contribute(g,id,item,left),"Collection delivery: "+id+" / "+item)
func reward(id:String)->bool:
 var points=int(HoldGreatClaim102.data(g.state).points);var seals=W.seals(g.state)
 var campaign=HoldCampaign138.data(g.state).duplicate(true)
 var result=C.claim(g,id)
 check(int(HoldGreatClaim102.data(g.state).points)==points and W.seals(g.state)==seals and HoldCampaign138.data(g.state)==campaign,"Reward leaves campaign marks, seals and milestones unchanged: "+id)
 return result
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not C.unlocked(g.state) and C.data(g.state).is_empty(),"Other fortunes get no collection records or rewards")
 HoldFirstVisit99.begin(g);settle();var s=g.state;ledger()
 check(not C.unlocked(s) and not C.contribute(g,"miner","coal",1),"First paid shift remains required")
 HoldFirstVisit99.data(s).rewarded=true
 for item in HoldData.ITEMS:s.add(item,300)
 s.money=5000;s.opening=2
 var seals=W.seals(s)
 check(not s.craft("surveyors_stone") and not C.furnishing_unlocked(s,"hearthkeeper_table"),"Reward recipe and furnishing start locked")
 g.surface.start_placement("hearthkeeper_table");check(g.surface.placing=="","Direct placement cannot bypass collection unlock")
 check(not C.claim(g,"miner") and not C.contribute(g,"miner","iron_ore",1),"Pack inventory alone supplies no work credit")
 W.produced(s,"iron_ore",6,"cut");var before=s.count("iron_ore")
 at(Vector2(480,500));check(not C.contribute(g,"miner","iron_ore",1),"Deliveries require physical Ledger locality");ledger()
 check(not C.contribute(g,"bad","iron_ore",1) and not C.contribute(g,"miner","food",1) and not C.contribute(g,"miner","iron_ore",-1) and not C.contribute(g,"miner","iron_ore",7),"Invalid, negative and excess deliveries are harmless")
 check(C.contribute(g,"miner","iron_ore",2) and s.count("iron_ore")==before-2 and W.available(s,"iron_ore")==4,"Partial delivery spends inventory and shared work credit exactly")
 g.open_panel("collections141");check(g.menu_paused,"Collection book pauses gameplay");await snap("01-miner-partial");g.menu_scroll.scroll_vertical=600;await snap("01b-delivery-controls");g.close_panel()
 g.save_game();g.start_game(true);settle();s=g.state;ledger()
 check(C.paid(s,"miner","iron_ore")==2 and W.available(s,"iron_ore")==4,"Partial contribution and credit survive real save reload")
 check(not C.contribute(g,"miner","iron_ore",5),"Reload cannot overfill a partially delivered slot")
 for item in ["copper_ore","coal","dressed_stone","crystal"]:W.produced(s,item,C.costs(s,"miner")[item],"cut")
 deliver("miner");check(not C.ready(s,"miner"),"Finished deliveries do not replace discovery and research")
 desk("survey");check(HoldFrontier103.transact(g,"research","stoneworking"),"Research Stoneworking normally")
 W.data(s).facts.deep_crystal=2;ledger()
 check(reward("miner") and not C.claim(g,"miner"),"Miner reward is once-only")
 check(C.recipe_reason(s,"surveyors_stone")=="","Collection unlocks reusable recipe")
 var stone=s.count("stone");var dressed=s.count("dressed_stone")
 craft("surveyors_stone",1)
 check(s.count("stone")==stone-5 and s.count("dressed_stone")==dressed+3 and W.available(s,"dressed_stone")==3,"Reward recipe consumes real resources and credits actual output")
 check(not C.contribute(g,"miner","coal",1),"Claimed collections reject further payments")
 # Smith stock is made through the same live forge transaction as ordinary play.
 desk("survey");check(HoldFrontier103.transact(g,"research","metallurgy"),"Research Precision forging normally")
 craft("iron",4);craft("copper",3);craft("parts",2);craft("ammo",1)
 deliver("smith");check(not C.ready(s,"smith"),"Smith cannot skip steel tool or combat introduction")
 desk("survey");check(HoldFrontier103.transact(g,"research","extraction"),"Research steel normally")
 desk("forge");check(HoldFrontier103.transact(g,"tool","steel"),"Forge the real steel pick")
 HoldOnboarding.ensure(s).combat=true;ledger();var equipped=s.combat.weapon
 check(reward("smith") and not C.claim(g,"smith"),"Smith equipment reward only once")
 var gear=HoldEquipment93.find(s.combat,"collection_smith141")
 check(gear.kind=="hammer" and gear.grade==1 and s.combat.weapon==equipped,"Tempered hammer uses real equipment without changing current loadout")
 check(HoldEquipment93.equip(g,"collection_smith141") and HoldEquipment93.stats(HoldEquipment93.equipped(s.combat,"weapon")).damage>HoldCombat.WEAPONS.hammer.damage,"Reward equips with effective tempered stats")
 # Both food paths complete independently with no crop requirement for fishers.
 var clean=s.surface.duplicate(true);var stock=s.inventory.duplicate(true)
 for route in ["garden","river"]:
  s.surface=clean.duplicate(true);s.inventory=stock.duplicate(true);ledger()
  check(C.choose(g,route),"Choose "+route+" before contributing")
  check(not C.choose(g,"unknown"),"Invalid route rejected")
  for item in C.ROUTES[route]:W.produced(s,item,4,"grown" if route=="garden" else "caught")
  craft("turnip_stew" if route=="garden" else "trout_supper",2)
  var first=C.ROUTES[route].keys()[0]
  check(C.contribute(g,"hearth",first,1),"Partial "+route+" deposit")
  check(not C.choose(g,"river" if route=="garden" else "garden"),"Paid route cannot be replaced or erased")
  g.set_meta("collection141","hearth");g.open_panel("collections141");await snap("hearth-"+route);g.close_panel()
  deliver("hearth");check(not C.ready(s,"hearth"),"Supplies do not skip field kit and home furnishing")
  s.surface.fieldwork.kit=true;HoldFirstVisit99.data(s).home_made=true
  var wood=s.count("wood");stone=s.count("stone")
  check(reward("hearth") and C.furnishing_unlocked(s,"hearthkeeper_table"),route+" earns same supper-table plan")
  check(s.count("wood")==wood+6 and s.count("stone")==stone+2 and not C.claim(g,"hearth"),"First-table material gift once only")
  check(s.count("wood")==wood+6 and s.count("stone")==stone+2,"Repeat claim cannot duplicate materials")
 g.set_meta("collection141","smith");g.open_panel("collections141");await snap("02a-smith-reward");g.close_panel()
 # Place the reward with the real furnishing transaction; geometry and payment apply.
 # Use the original private home for an unobstructed, deterministic furnishing check.
 g.surface.enter("room:home");settle()
 at(Vector2(630,420));g.surface.start_placement("hearthkeeper_table")
 var built=false
 for x in range(540,740,20):
  for y in range(340,500,20):
   if not built and g.surface.furniture_valid(Vector2(x,y),"hearthkeeper_table"):built=g.surface.place(Vector2(x,y))
 check(built,"Reward table uses real collision-aware construction")
 var table=s.surface.decor.back();at(Vector2(table.x,table.y)+Vector2(0,65))
 check(g.hearth.table_near(),"Reward table serves shared meals through the existing hearth system")
 await snap("02-hearthkeeper-table")
 ledger();g.set_meta("collection141","hearth");g.open_panel("collections141");await snap("03-completed-hearth");g.close_panel()
 g.save_game();g.start_game(true);settle();s=g.state;ledger()
 check(C.claimed(s,"miner") and C.claimed(s,"smith") and C.claimed(s,"hearth"),"All rewards and unlocks survive real reload")
 check(HoldEquipment93.ensure(s.combat).items.filter(func(e):return e.id=="collection_smith141").size()==1,"Equipment reward remains one stable saved instance")
 check(W.seals(s)==seals,"Collections grant no trade seals")
 check(not HoldCampaign138.eligible(s) and not HoldCampaign138.data(s).winter_ready,"All three collections still cannot bypass the campaign foundations")
 # A legacy/closed fortune initializes optional progress without fabricating rewards.
 s.surface.erase("collections141");HoldMountain104.data(s).authenticated=true
 var inventory=s.inventory.duplicate(true);ledger()
 check(C.data(s).claimed.is_empty() and s.inventory==inventory,"Existing saves initialize without rewards or inventory changes")
 W.produced(s,"coal",4,"cut")
 check(C.contribute(g,"miner","coal",4),"Collections remain available after contest authentication")
 check(not C.contribute(g,"miner","coal",1),"Completed slot cannot consume more inventory")
 g.open_panel("collections141");await snap("04-closed-contest-optional");g.close_panel()
 print("COLLECTIONS141: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
