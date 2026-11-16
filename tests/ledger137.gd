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
 HoldQuestScene181.resume(g)
 check(not is_instance_valid(g.opening_scene) and not g.state.surface.has("quest_scene181"),"Older saves do not acquire or replay quest scenes on load")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 ledger();s.add("coal",12);s.add("wood",20);s.add("iron",10)
 check(not HoldQuestScene181.play(g,"borin"),"Borin introduction cannot be launched remotely")
 check(L.unlocked(s,"forge") and not HoldFirstVisit99.data(s).rewarded,"Owners can contribute without the optional first shift")
 HoldFirstVisit99.data(s).rewarded=true
 HoldFirstVisit99.data(s).home_made=true;HoldFirstVisit99.data(s).focus="forge"
 check(L.forge_lead(s).title=="A hearth gone cold","First forge lead begins with a local inspection")
 check(not L.contribute(g,"invalid","coal",1),"Unknown project rejected")
 check(not L.contribute(g,"forge","wood",1),"Wrong material rejected")
 check(not L.contribute(g,"forge","coal",0) and not L.contribute(g,"forge","coal",-1),"Nonpositive deliveries rejected")
 var before=s.count("coal")
 check(L.contribute(g,"forge","coal",3) and s.count("coal")==before-3,"Partial delivery spends exact pack amount")
 check(not L.contribute(g,"forge","coal",6),"Excess cannot overfill slot")
 desk("forge");check(not L.contribute(g,"forge","coal",1),"Delivery requires physical ledger")
 await introduction181();s=g.state
 check(L.inspect(g) and not L.inspect(g),"Inspection recorded once at forge")
 check(L.forge_lead(s).title=="An entry in the Ledger","Purchased fuel points straight to the remaining delivery")
 g.open_panel("commission");await snap("forge-processing-lead");g.close_panel()
 ledger();g.save_game();g.start_game(true);settle();s=g.state
 check(L.paid(s,"forge","coal")==3 and L.data(s).inspected,"Partial delivery and investigation survive JSON reload")
 HoldWork132.produced(s,"coal",2,"cut")
 check(L.forge_lead(s).title=="An entry in the Ledger" and L.forge_lead(s).hint.contains("remaining 5 coal"),"Delivery guidance subtracts the saved partial payment")
 var held_coal=s.count("coal");s.inventory.coal=0
 check(L.forge_lead(s).title=="Fuel for the first firing" and L.forge_lead(s).hint.contains("still needs 5"),"Spent or missing pack coal changes the next action without losing deposits")
 s.inventory.coal=held_coal;HoldWork132.data(s).facts.erase("cut:coal")
 ledger();check(L.contribute(g,"forge","coal",5),"Remaining fuel accepted")
 check(L.ready(s,"forge"),"Delivered fuel is sufficient without a compulsory processing lesson")
 HoldWork132.produced(s,"coal",2,"cut")
 check(L.forge_lead(s).title=="The first firing" and HoldFirstVisit99.goal(g).contains("relight the hearth"),"Fully paid and learned forge points back to the hearth in journal and HUD")
 check(L.ready(s,"forge") and not L.finish(g,"forge"),"Completed materials require return to hearth")
 desk("forge");g.open_panel("frontier103");await snap("forge-ready");g.close_panel()
 var money=s.money;before=s.count("coal")
 g.open_panel("frontier103");button("Relight the communal forge")
 check(s.opening==2 and g.opening_scene is HoldQuestScene181,"First firing commits the actual forge before its scene")
 await snap("scenes181-first-fire")
 g.opening_scene.age=1;g.opening_scene.advance();g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldQuestScene181 and g.opening_scene.mode=="forge" and g.opening_scene.step==1 and s.money==money+65,"Reload resumes the firing without paying again")
 await snap("scenes181-forge-open")
 g.opening_scene.finish();await process_frame
 check(not HoldQuestScene181.play(g,"forge"),"Finished firing scene is not replayed")
 check(not HoldFirstVisit99.opening_route(g) and L.forge_lead(s).title=="The forge is alight","Completed forge leaves opening guidance without asking for fuel again")
 check(s.money==money+65 and s.count("coal")==before,"Escrow is not charged again; wage paid once")
 check(not L.finish(g,"forge") and s.money==money+65,"Repeated firing cannot duplicate wage")
 await snap("forge-open")
 ledger();g.open_panel("great_claim102");await snap("ledger")
 check(not g.panel.find_children("*","Label",true,false).any(func(l):return l.text==L.PROJECTS.forge.hint),"Completed forge no longer tells the player to contribute coal and relight it")
 button("+ Personal ambition");await snap("home-milestone");g.close_panel()
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
 var prior_money=s.money;HoldQuestScene181.record(s).active="forge";HoldQuestScene181.record(s).beat=1
 g.save_game();g.start_game(true);settle();s=g.state
 check(not is_instance_valid(g.opening_scene) and HoldQuestScene181.record(s).active=="" and s.money==prior_money,"Stale scene at an incompatible location is cleared without rewards or teleporting")
 await story183()
 print("LEDGER137: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)

func introduction181():
 var s=g.state;var money=s.money;var inventory=s.inventory.duplicate(true)
 check(not HoldQuestScene181.play(g,"forge") and not HoldQuestScene181.play(g,"invalid"),"Scenes reject unearned milestones and unknown IDs")
 g.open_panel("frontier103");button("Meet Borin")
 check(g.opening_scene is HoldQuestScene181 and not L.data(s).inspected,"Borin's introduction does not inspect or pay for the hearth")
 check(not HoldQuestScene181.play(g,"borin"),"An active scene cannot stack another scene")
 await snap("scenes181-borin-introduction")
 g.opening_scene.age=1;g.opening_scene.advance();g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldQuestScene181 and g.opening_scene.step==1,"Character introduction resumes its saved beat")
 await snap("scenes181-borin-purpose")
 var event=InputEventKey.new();event.pressed=true;event.keycode=KEY_ESCAPE
 g.opening_scene._input(event);await process_frame
 check(not is_instance_valid(g.opening_scene) and s.money==money and s.inventory==inventory,"Escape returns control without spending supplies or granting rewards")
 check(HoldQuestScene181.record(s).seen.borin and not HoldQuestScene181.play(g,"borin"),"Skipped introduction is remembered without automatic replay")
 g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene),"Completed introduction stays complete after reload")

func story183():
 check(not HoldStory183.accept(g) and not HoldStory183.deliver(g),"Borin's personal work rejects remote transactions")
 desk("forge");at(HoldForge147.BORIN_TALK)
 var s=g.state;var money=s.money;var inv=s.inventory.duplicate(true);var decor=JSON.parse_string(JSON.stringify(s.surface.decor))
 HoldConversation.start(g,"borin");button("That split handle");await snap("story183-offer-panel")
 button("I'll bring the haft")
 check(HoldStory183.stage(s)==1 and g.opening_scene is HoldQuestScene181,"Accepting optional work saves its stage before Borin's scene")
 check(s.money==money and s.inventory==inv and not HoldStory183.accept(g),"Accepting work neither spends nor pays and cannot repeat")
 await snap("story183-inspection")
 g.opening_scene.age=1;g.opening_scene.advance();await snap("story183-standard")
 g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldQuestScene181 and g.opening_scene.step==1 and HoldStory183.stage(s)==1,"Borin's accepted work and scene beat resume together")
 g.opening_scene.finish();await process_frame
 s.inventory.shaped_haft=0;s.inventory.iron=0
 check(not HoldStory183.deliver(g) and HoldStory183.stage(s)==1,"Missing materials cannot complete the repair")
 g.open_panel("commission");check(g.panel.find_children("*","Label",true,false).any(func(l):return l.text.contains("Borin's training pick")),"Optional repair remains in the work journal");g.close_panel()
 s.add("shaped_haft",1);s.add("iron",1);money=s.money
 HoldConversation.start(g,"borin");button("About the apprentice");button("Deliver the haft")
 check(HoldStory183.stage(s)==2 and s.count("shaped_haft")==0 and s.count("iron")==0 and s.money==money+HoldStory183.pay(s),"Delivery consumes exact materials and reimburses once before the scene")
 check(not HoldStory183.deliver(g),"Repeated delivery cannot award extra money")
 await snap("story183-restoration")
 g.opening_scene.age=1;g.opening_scene.advance();await snap("story183-approval")
 var paid=s.money;g.save_game();g.start_game(true);settle();s=g.state
 check(g.opening_scene is HoldQuestScene181 and g.opening_scene.step==1 and s.money==paid,"Completed repair resumes without paying twice")
 g.opening_scene.finish();await process_frame
 var display=HoldForge147.display_position(g)
 check(display!=Vector2.INF and JSON.parse_string(JSON.stringify(s.surface.decor))==decor,"Restored tool display appears without rewriting saved furniture")
 if display!=Vector2.INF:
  for offset in [Vector2(0,55),Vector2(0,-55),Vector2(-55,0),Vector2(55,0)]:
   if g.surface.walkable(display+offset):at(display+offset);break
  await snap("story183-tool-display")
 at(HoldForge147.BORIN_TALK);HoldConversation.start(g,"borin");await snap("story183-followup")
 check(HoldConversation.greeting(g,"borin").contains("back in service"),"Borin remembers work completed to the forge's standard")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene) and HoldStory183.stage(g.state)==2 and not HoldStory183.deliver(g),"Completed story persists without replay or reward duplication")
