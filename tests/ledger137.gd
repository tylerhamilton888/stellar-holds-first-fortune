extends "res://tests/support/game_fixture.gd"
const L=preload("res://scripts/ledger137.gd")
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func ledger():
 desk("lodge");at(Vector2(670,425))
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not L.active(g.state),"Legacy fortune unaffected")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 ledger();s.add("coal",12);s.add("wood",20);s.add("iron",10)
 check(not L.contribute(g,"forge","coal",1),"First shift required")
 HoldFirstVisit99.data(s).rewarded=true
 check(not L.contribute(g,"invalid","coal",1),"Unknown project rejected")
 check(not L.contribute(g,"forge","wood",1),"Wrong material rejected")
 check(not L.contribute(g,"forge","coal",0) and not L.contribute(g,"forge","coal",-1),"Nonpositive deliveries rejected")
 var before=s.count("coal")
 check(L.contribute(g,"forge","coal",3) and s.count("coal")==before-3,"Partial delivery spends exact pack amount")
 check(not L.contribute(g,"forge","coal",6),"Excess cannot overfill slot")
 desk("forge");check(not L.contribute(g,"forge","coal",1),"Delivery requires physical ledger")
 check(L.inspect(g) and not L.inspect(g),"Inspection recorded once at forge")
 ledger();g.save_game();g.start_game(true);settle();s=g.state
 check(L.paid(s,"forge","coal")==3 and L.data(s).inspected,"Partial delivery and investigation survive JSON reload")
 ledger();check(L.contribute(g,"forge","coal",5),"Remaining fuel accepted")
 check(not L.ready(s,"forge"),"Inventory cannot substitute for practical coal processing")
 HoldWork132.produced(s,"coal",2,"cut")
 check(L.ready(s,"forge") and not L.finish(g,"forge"),"Completed materials require return to hearth")
 desk("forge");g.open_panel("frontier103");await snap("forge-ready");g.close_panel()
 var money=s.money;before=s.count("coal")
 check(L.finish(g,"forge") and s.opening==2,"First firing opens authoritative forge")
 check(s.money==money+65 and s.count("coal")==before,"Escrow is not charged again; wage paid once")
 check(not L.finish(g,"forge") and s.money==money+65,"Repeated firing cannot duplicate wage")
 await snap("forge-open")
 ledger();g.open_panel("great_claim102");await snap("ledger");button("+ Personal ambition");await snap("home-milestone");g.close_panel()
 var points=int(HoldGreatClaim102.data(s).points)
 check(L.contribute(g,"watch","wood",2),"Civic partial delivery")
 before=s.count("wood")
 check(HoldGreatClaim102.contribute(g,"watch"),"Existing completion path pays only balance")
 check(s.count("wood")==before-4 and int(HoldGreatClaim102.data(s).points)==points+40,"No double charge or duplicate marks")
 check(not L.contribute(g,"watch","wood",1) and not L.finish(g,"watch"),"Completed civic project cannot be paid again")
 check(HoldGreatClaim102.furnishings(g.surface.world,"trail").size()>=2,"Completed lamps appear in world")
 # Authoritative old unlocks are recognized without inventing payments or rewards.
 s.surface.erase("ledger137");before=s.money
 check(L.complete(s,"forge") and L.complete(s,"watch") and L.data(s).paid.is_empty() and s.money==before,"Existing work migrates without replay or reward")
 # The welcome is story-based, not a friendship point redemption.
 HoldGreatClaim102.data(s).projects={};HoldWork132.data(s).seals=[]
 check(L.phase(s)==0 and L.skarrin(s).contains("Welcome"),"Newcomer receives welcome")
 check(not L.gift(g),"Remote gift rejected")
 g.surface.enter("trail");settle()
 var target={}
 for p in g.surface.roads.people("trail"):
  if p.get("interaction","")=="road_folk:8":target=p;break
 if target.is_empty():
  for p in g.surface.points():
   if p.get("action","")=="road_folk:8":target=p;break
 check(not target.is_empty(),"Skarrin has reachable local interaction")
 if not target.is_empty():
  at(target.p);HoldPeople.meet(g,"road_folk:8");before=s.count("wood")
  check(L.gift(g) and s.count("wood")==before+4 and not L.gift(g),"Welcome timber awarded once")
  g.talk_id="road_folk:8";g.talk_topic="";g.talk_line="";g.open_panel("conversation");await snap("skarrin-welcome");g.close_panel()
 HoldGreatClaim102.data(s).projects.watch=true
 check(L.phase(s)==1 and L.skarrin(s).contains("that timber"),"Public recognition changes tone and recalls actual favor")
 var saved=s.inventory.duplicate(true);g.save_game();g.start_game(true);settle();s=g.state
 check(s.inventory==saved and L.data(s).gift,"Gift and supplies persist")
 check(L.skarrin(s).contains("that timber"),"Milestone dialogue survives reload")
 print("LEDGER137: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
