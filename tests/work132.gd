extends "res://tests/support/game_fixture.gd"
const W=preload("res://scripts/work132.gd")
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func ledger():
 desk("lodge");at(Vector2(670,425))
func process_load(item:String,amount:int,source:String="rock:0:test"):
 g.dev.arena(0);settle();g.combat.armed=false;g.depth_nav.explore.preferred=false
 var h=g.handworks;var kind="saw" if item=="wood" else "breaker";var station={}
 for f in h.data().facilities:
  if h.local(f) and f.kind==kind and f.get("owner","")=="":station=f;break
 if station.is_empty():
  g.state.add("wood",8);g.state.add("stone",6);g.player=Vector2(820 if kind=="breaker" else 1000,820)
  check(h.build(kind,Vector2(820 if kind=="breaker" else 1000,900)),"Normal station construction: "+kind)
  station=h.data().facilities.back()
 h.spawn("log" if item=="wood" else "stone",g.player,amount,source,item)
 var raw=h.data().loose.pop_back();h.data().carry.append(raw)
 g.player=Vector2(station.x,station.y)+Vector2(0,40);h.active_id=""
 var before=W.available(g.state,item)
 Input.action_press("interact")
 for i in 300:h.update(1.0/60)
 Input.action_release("interact")
 check(W.available(g.state,item)==before+int(raw.units),"Real bench work records fresh "+item)
 W.processed(g,raw)
 check(W.available(g.state,item)==before+int(raw.units),"Replayed raw record cannot duplicate proof")
func smelt(amount:int):
 desk("forge");g.state.add("iron_ore",amount*2);g.state.add("coal",amount)
 for i in amount:check(HoldFrontier103.transact(g,"craft","iron"),"Local forge queues real ingot")
 for i in amount:g.state.tick(4)
func report(id:String):
 desk(W.LESSONS[id].host)
 var money=g.state.money;var inventory=g.state.inventory.duplicate(true)
 check(W.claim_lesson(g,id),"Completed lesson reports locally: "+id)
 check(g.state.money==money+int(W.LESSONS[id].crowns),"Exact once-only lesson wage: "+id)
 var paid=g.state.inventory.duplicate(true)
 check(not W.claim_lesson(g,id) and g.state.inventory==paid,"Repeated report has no effect: "+id)
 for item in W.LESSONS[id].reward:check(g.state.count(item)==int(inventory.get(item,0))+int(W.LESSONS[id].reward[item]),"Exact supply reward: "+id+" / "+item)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 W.produced(g.state,"stone",99,"cut")
 check(not g.state.surface.has("work132"),"Legacy fortunes receive no new work ledger")
 HoldFirstVisit99.begin(g);settle();g.open_panel("commission")
 check(g.panel_body.get_child(0).get_child(0).get_child(0).text=="Your next step","Immediate instruction is first in the new journal")
 await snap("first-step");g.close_panel()
 var s=g.state;s.money=1000;s.add("stone",24)
 check(not W.can_deliver(s,"quarry","stone") and not W.unlocked(s,"ore"),"Tutorial completion gates new work without granting purchased-stock proof")
 HoldFirstVisit99.data(s).rewarded=true;HoldFirstVisit99.data(s).ivar_spoken=true;HoldFirstVisit99.data(s).room_seen=true
 s.trade("stone",true);HoldDisciplines.award(s,"masonry",30)
 check(W.available(s,"stone")==0,"Buying, gifts and discipline XP cannot fabricate production")
 process_load("iron_ore",2);process_load("coal",1)
 check(W.ready(s,"ore") and not W.claim_lesson(g,"ore"),"Actual extraction lesson ready, but remote reporting rejected")
 desk("forge");HoldWorkView132.open(g);await snap("ore-lesson");g.close_panel()
 report("ore")
 check(W.available(s,"iron_ore")==2 and W.available(s,"coal")==1,"Lesson supplies do not count as fresh work")
 desk("lodge");s.add("coal",8);check(s.finish_commission() and s.opening==2,"Coal commission opens the Stonebridge forge")
 smelt(2);check(W.ready(s,"smelt"),"Actual completed smelting satisfies lesson")
 report("smelt")
 check(W.available(s,"iron")==2,"Reward ingots earn no production credit")
 desk("forge");s.add("iron",20);s.add("wood",20)
 var stock=s.inventory.duplicate(true)
 check(not HoldFrontier103.transact(g,"tool","steel") and s.inventory==stock,"Steel pick cannot bypass research")
 desk("survey");check(HoldFrontier103.transact(g,"research","extraction"),"Local Stonebridge research unlocks the method")
 check(not HoldFrontier103.transact(g,"tool","steel"),"Remote tool transaction blocked")
 desk("forge");var iron=s.count("iron")
 check(HoldFrontier103.transact(g,"tool","steel") and s.steel and s.count("iron")==iron-5,"Stonebridge can forge the researched pick")
 check(not HoldFrontier103.transact(g,"tool","steel") and s.count("iron")==iron-5,"Stale tool purchase cannot charge twice")
 report("steel")
 process_load("wood",4,"pine:test");report("timber")
 g.dev.arena(0);settle();g.player=Vector2(1100,820);s.add("wood",6);s.add("iron",2)
 check(g.handworks.build("cart",Vector2(1100,900)),"Ordinary handcart can be built for lesson")
 var cart=g.handworks.data().facilities.back()
 g.handworks.spawn("stone",Vector2(1100,900),2,"rock:0:cart","stone")
 check(g.handworks.deposit(cart)>0,"Cart receives a real load")
 cart.hitched=true;g.player=Vector2(cart.x,cart.y);g.walking_pose=true
 for i in 20:g.player.x-=8;g.handworks.update(.05)
 g.walking_pose=false;cart.hitched=false
 check(W.ready(s,"cart"),"Loaded cart movement satisfies hauling lesson")
 report("cart")
 HoldFirstVisit99.data(s).home_made=true;report("room")
 g.dev.arena(0);settle();key(KEY_X);key(KEY_X)
 check(W.ready(s,"survey"),"Real survey input satisfies the survey lesson")
 report("survey")
 g.dev.arena(0);settle();var c=Vector2i(22,20);s.add("wood",2)
 g.deep.world.carve_stairs(c,"ladder")
 check(g.deep.world.traverse(c,false) and not W.ready(s,"route"),"Descending alone is not a safe-return lesson")
 check(g.deep.world.traverse(c,true) and W.ready(s,"route"),"Same-passage return proves the route")
 report("route");process_load("crystal",2,"rock:1:lower-seam");report("crystal")
 g.surface.enter("greenfields");settle();at(HoldRoads.ORDERS.greenfields.p);s.money=1000
 check(g.surface.roads.lease(),"Existing allotment is available before a household plot")
 s.add("wood",3);s.add("iron",1);s.add("water",4)
 check(g.fieldwork.craft_kit(),"Field kit uses its existing crafting transaction");report("kit")
 g.surface.enter("greenfields");settle()
 for b in g.fieldwork.data().beds.slice(0,2):
  at(Vector2(b.x-65,b.y-18))
  for step in 3:key(KEY_E);await frames(60)
  s.elapsed+=181;key(KEY_E);await frames(60)
 check(W.proof(s,"grown:turnip")>=4 and W.ready(s,"harvest"),"Real garden work supplies production and lesson progress")
 report("harvest");desk("forge");s.add("turnip",2);s.add("hearthcap",1);s.add("wood",1)
 check(HoldFrontier103.transact(g,"craft","root_hotpot"),"Actual meal can be queued")
 s.tick(8);check(W.ready(s,"cook"),"Cooked meal completes food path");report("cook")
 g.surface.enter("greenfields");settle();at(HoldHearth.SPOTS.greenfields.bank)
 var place=g.fieldwork.spot();var fish=place.fish[int(g.fieldwork.data().locations.get("greenfields",0))%place.fish.size()];var caught=W.available(s,fish)
 key(KEY_E);g.fieldwork.update(3.9);Input.action_press("interact");g.fieldwork.update(1);Input.action_release("interact")
 check(W.available(s,fish)>caught,"Real fishing catch contributes verified production")
 check(W.data(s).done.size()==12,"All twelve lesson rewards have a reachable completion")
 W.data(s).track="ore";HoldWorkView132.open(g);await snap("completed-lessons");g.close_panel()
 # Preserve real work, then exercise score alternatives from an isolated unscored ledger.
 var original=W.data(s).duplicate(true)
 var ledger_data=HoldGreatClaim102.data(s);ledger_data.points=0;ledger_data.projects={};ledger_data.work={"smithing":8,"masonry":8,"woodworking":8}
 s.surface.erase("work132");W.data(s)
 smelt(12)
 var before=s.count("iron")
 check(not W.deliver(g,"metal","iron"),"Forge cannot sign a ledger delivery")
 ledger();HoldWorkView132.open(g,"contribute");g.set_meta("work132_trade","metal");g.refresh_panel();await snap("metal-delivery")
 g.menu_scroll.scroll_vertical=300;await snap("metal-delivery-options")
 for i in 3:
  g.close_panel();check(W.deliver(g,"metal","iron"),"A specialist can earn seal "+str(i+1))
  if i==1:
   desk("lodge");check(HoldFrontier103.permit(g),"Two trade seals alone earn the household plot");ledger()
 check(s.count("iron")==before-12 and W.available(s,"iron")==0 and int(ledger_data.points)==120,"Three equal deliveries consume proof and goods for exactly 120 marks")
 s.add("iron",4);check(not W.deliver(g,"metal","iron"),"Spent proof and shared seal limit prevent a repeat payout")
 g.surface.enter("claim");settle();s.add("stone",200);s.add("wood",200);s.add("iron",200)
 g.surface.architecture.selected="cottage";g.surface.architecture.furnish_plan=true;at(Vector2(2480,820))
 check(g.surface.architecture.place(Vector2(2480,700)),"Specialist constructs an ordinary furnished home")
 desk("lodge");check(HoldFrontier103.finish_home(g) and not HoldMountain104.eligible(s),"Three same-trade seals earn recognition and a home; campaign foundations still gate rescue")
 check(int(ledger_data.points)==180,"Specialist awards remain 180 marks without bypassing campaign foundations")
 g.open_panel("commission");await snap("specialist-milestone");g.close_panel()
 # Mixed routes use the same budgets, not a new 120-mark pot for each profession.
 var specialist=W.data(s).duplicate(true);s.surface.erase("work132");ledger_data.points=0
 for spec in [["quarry","stone",24,"cut"],["timber","wood",12,"cut"],["metal","copper",3,"made"]]:
  W.produced(s,spec[1],spec[2],spec[3]);s.add(spec[1],spec[2]);ledger()
  check(W.deliver(g,spec[0],spec[1]),"Mixed route delivery: "+str(spec[0]))
 check(int(ledger_data.points)==120 and W.seals(s)==3,"Mixed and specialist routes award identical total marks")
 W.produced(s,"river_fish",8,"caught");s.add("river_fish",8)
 check(not W.deliver(g,"table","river_fish"),"Switching profession cannot reset the shared seal cap")
 for trade in W.TRADES:
  for item in W.TRADES[trade].items:
   var value=int(W.TRADES[trade].items[item])*int(HoldData.ITEMS[item].price)
   check(value>=48 and value<=60,"Comparable material value: "+item)
 # Mixed civic/trade eligibility and old-save migration retain the earlier awards.
 s.surface.erase("work132");ledger_data.projects={"watch":true};ledger_data.points=40
 W.produced(s,"wood",12,"cut");s.add("wood",12);ledger();check(W.deliver(g,"timber","wood") and W.contributions(s)==2,"One civic project plus one trade seal qualifies")
 var inventory=s.inventory.duplicate(true);var home=s.claim_id;var score=int(ledger_data.points)
 s.surface.erase("work132");W.data(s)
 check(s.inventory==inventory and s.claim_id==home and int(ledger_data.points)==score and W.available(s,"wood")==0,"Migration preserves history without inventing proof from inventory")
 s.surface.work132=specialist;s.surface.work132.done=original.done;ledger_data.points=180
 g.save_game();g.start_game(true);settle();s=g.state
 check(W.seals(s)==3 and W.data(s).done.size()==12 and HoldFrontier103.data(s).home_reward,"Seals, lessons and household survive JSON save/reload")
 var ancestry=HoldMountain104.data(s);ancestry.authenticated=true;ancestry.work_at_award=420;ancestry.rival_at_award=380;ancestry.allowance=0
 HoldAncestralClaim.data(s).stage=5;W.data(s).seals=[];W.produced(s,"wood",12,"cut");s.add("wood",12);ledger()
 check(not W.deliver(g,"timber","wood") and HoldClaim127.closed_score(s)==420,"Closed-round score cannot be rewritten by a new delivery")
 HoldWorkView132.open(g,"contribute");await snap("closed-contest");g.close_panel()
 check(HoldClaim127.start(g,"trial")==false,"Trial still requires Ivar's shift book, not the contribution desk")
 desk("lodge");check(HoldClaim127.start(g,"trial"),"Overqualified work score still enters the existing public challenge")
 check(g.opening_scene.lines[0][1].contains("exceeds"),"High-score trial does not falsely claim a tie")
 print("WORK132: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
