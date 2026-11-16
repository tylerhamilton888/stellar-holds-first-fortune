extends "res://tests/support/game_fixture.gd"

func has_label(fragment:String)->bool:
 for label in g.panel_body.find_children("*","Label",true,false):
  if fragment in label.text:return true
 return false

func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 g.state.save_slot=2;g.first_visit_pending=true;g.start_game(false)
 while HoldFolk.warming():HoldFolk.warm_step()
 var q=HoldFirstVisit99.data(g.state)
 check(g.opening_scene is HoldOpeningScene and g.opening_scene.mode=="frontier_arrival","New Game begins with the Stonebridge scene")
 check(q.intro_pending and g.surface.area==HoldFrontier103.lodge(g.state),"Scene starts in the real lodge and records pending state")
 await snap("01-arrival")
 g.opening_scene.age=1.0;g.opening_scene.advance()
 check(int(q.intro_beat)==1,"Advancing saves the current beat")
 g.start_game(true)
 while HoldFolk.warming():HoldFolk.warm_step()
 check(is_instance_valid(g.opening_scene) and g.opening_scene.mode=="frontier_arrival" and g.opening_scene.step==1,"Reload resumes an unfinished introduction")
 g.opening_scene.age=1.0;g.opening_scene.advance();g.opening_scene.age=1.0;g.opening_scene.advance()
 await snap("01b-ivar-welcome")
 for who in ["IVAR DEEPMEASURE","RURIK STONEHAND","SIGRID EMBERBRAID"]:
  g.opening_scene.age=1;g.opening_scene.advance()
  check(g.opening_scene.speaker.text==who,"Opening names the person currently speaking: "+who)
  await snap("scenes181-intro-"+str(g.opening_scene.step))
 check(g.opening_scene.foreman_portrait.profile.name.contains("Sigrid"),"Sigrid's introduction uses her own portrait")
 g.opening_scene.finish();await process_frame
 check(not is_instance_valid(g.opening_scene) and not HoldFirstVisit99.data(g.state).intro_pending and g.surface.area==HoldFrontier103.lodge(g.state),"Skipping returns control in the lodge")
 g.open_panel("commission")
 check(has_label("Old Stonewright's Rise") and not has_label("campaign foundations"),"First journal leads with one immediate task")
 await snap("02-first-journal");g.close_panel()
 g.open_panel("great_claim102")
 check(has_label("where Stonebridge records work") and not has_label("The North Crossing"),"The ledger begins with a short explanation")
 await snap("03-ledger-introduction");button("Browse the projects")
 check(has_label("The Cold Forge") and not has_label("The North Crossing"),"The first project is introduced before later work")
 button("+ Other town projects");check(has_label("The North Crossing"),"The full ledger remains available on request")
 g.close_panel();at(Vector2(480,500));g.open_panel("frontier103")
 check(has_label("Ivar’s shift book") and not has_label("Winter Stores"),"The first shift book introduces the worksite")
 button("Look through the rest");check(has_label("A town taking root"),"The rest of the shift book remains available")
 button("Show me Old Stonewright")
 check(g.opening_scene is HoldClaimScene127 and not HoldFirstVisit99.data(g.state).rewarded,"Ivar introduces the owned property before any mining shift")
 g.opening_scene.age=4;g.opening_scene.advance()
 await snap("home169-introduction")
 g.save_game();g.start_game(true);settle()
 check(g.opening_scene is HoldClaimScene127 and g.opening_scene.step==1,"Property introduction resumes its saved beat")
 g.opening_scene.age=4;g.opening_scene.advance();await snap("polish179-introduction-farewell")
 g.opening_scene.finish();await process_frame;settle()
 check(g.surface.area=="claim" and g.surface.walkable(g.player) and not HoldFirstVisit99.data(g.state).rewarded,"Skipping leaves the player at their usable holding without mining credit")
 at(HoldFurnishings.bedside(HoldFrontier103.HOME_BED))
 check(g.surface.walkable(g.player) and g.surface.nearest().get("action","")=="house_rest","The starter bed has a clear usable bedside")
 key(KEY_E)
 check(g.surface.rest_time>0,"The first-night bed works through normal interaction")
 await snap("home169-bedroom")
 g.surface.rest_time=0;g.surface.rest_approach=Vector2.INF
 at(HoldFrontier103.HOME_CHEST+Vector2(0,35));key(KEY_E)
 check(g.panel_id=="storage","The starter chest opens through normal interaction");g.close_panel()
 check(g.state.surface.chests["home169:chest"].items.is_empty(),"The cottage does not provide free industrial stock")
 g.open_panel("commission");button("+ Read your parents");await snap("home169-parent-letter")
 check(has_label("paid in full") and has_label("Mum and Dad"),"The warm initial letter remains readable in the journal")
 g.menu_scroll.scroll_vertical=10000;await snap("home169-parent-letter-scrolled")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene),"A completed introduction does not replay on reload")
 var s=g.state;HoldFirstVisit99.data(s).erase("intro_pending");g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene),"Older saves without intro state do not replay the scene")
 HoldAncestralClaim.data(g.state).stage=1;g.open_panel("commission")
 check(has_label("THE MOUNTAIN REMEMBERS") and not has_label("A word with Ivar"),"An established rescue remains visible without a stale first-morning prompt")
 HoldAncestralClaim.data(g.state).stage=0
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(670,425))
 for project in ["watch","rest"]:
  var costs=HoldLedger137.remaining(g.state,project)
  for item in costs:
   g.state.add(item,int(costs[item]))
   check(HoldLedger137.contribute(g,project,item,int(costs[item])),"Civic materials can be delivered before the first shift")
  check(HoldLedger137.finish(g,project),"A non-mining civic project can be completed before the first shift")
 at(Vector2(480,500));var property=JSON.parse_string(JSON.stringify(g.state.surface.homes))
 check(HoldFrontier103.permit(g) and not HoldFirstVisit99.data(g.state).rewarded,"Two real civic projects earn recognition without requiring paid mining")
 check(JSON.parse_string(JSON.stringify(g.state.surface.homes))==property and not HoldFrontier103.home_ready(g),"Recognition preserves the cottage and does not pay its improvement milestone")
 await polish179()
 print("OPENING146: %d passed / %d failed" % [passed,failed]);g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)

func polish179():
 var s=g.state;var d=HoldFrontier103.data(s)
 var money=s.money;var inventory=s.inventory.duplicate(true);var estate=JSON.parse_string(JSON.stringify(s.surface.homes))
 check(HoldFrontier103.home_letters(s).size()==1,"Civic registration unlocks only its own family letter")
 HoldWorkerLodge100.speak(g,0)
 check(has_label("Your household is entered") and not has_label("first completed load"),"Recognized Ivar greeting replaces first-shift instructions without requiring mining")
 await snap("polish179-ivar-recognition");g.close_panel()
 for i in [1,2]:
  HoldWorkerLodge100.speak(g,i)
  check(not has_label("new hand") and not has_label("upstairs room"),"Miners recognize the registered household")
  g.close_panel()
 HoldWorkerLodge100.speak(g,2);button("Whose names")
 check(has_label("Our departed") and not has_label("household in the records"),"Memorial reply retains priority over household chatter");g.close_panel()
 HoldFirstVisit99.data(s).focus="homestead";g.open_panel("commission")
 check(not has_label("Your next step · Ore"),"Registered household journal does not override a non-work ambition with the default ore lesson")
 g.close_panel();HoldFirstVisit99.data(s).focus="work";g.open_panel("commission")
 check(has_label("Your next step · Ore"),"Explicitly chosen work guidance retains the practical lesson")
 g.close_panel();HoldFirstVisit99.data(s).focus="homestead";g.open_panel("commission");button("+ A letter from home · A name")
 check(has_label("He has kept the envelope") and not has_label("The notice of your home"),"Only earned correspondence appears in the journal")
 await snap("polish179-recognition-letter");await letter_end();await snap("polish179-recognition-scrolled");g.close_panel()
 check(s.money==money and s.inventory==inventory and JSON.parse_string(JSON.stringify(s.surface.homes))==estate,"Reading and revisiting letters/greetings never pays rewards or changes the estate")
 g.surface.enter("claim");settle();at(HoldFrontier103.HOME_DOOR)
 for p in [Vector2(2300,1140),Vector2(2300,1180),Vector2(2400,1180),Vector2(2520,1180)]:check(g.surface.walkable(p),"Cottage approach remains physically clear: "+str(p))
 await snap("polish179-cottage-approach")
 for item in ["wood","stone","iron"]:s.add(item,10)
 at(Vector2(2300,1050));g.surface.placing="lamp"
 check(g.surface.place(Vector2(2380,1020)),"Home polish follows an actual paid cottage improvement")
 g.surface.enter(HoldFrontier103.lodge(s));settle();at(Vector2(480,500))
 check(HoldFrontier103.finish_home(g),"Improved-home registration uses its existing once-only owner")
 check(HoldFrontier103.home_letters(s).size()==2,"Home registration adds its family note while keeping earlier correspondence")
 HoldWorkerLodge100.speak(g,0);check(has_label("give it a life of its own"),"Ivar acknowledges the registered improvement");await snap("polish179-ivar-home");g.close_panel()
 g.open_panel("commission");button("+ A letter from home · Making")
 check(has_label("We were before the papers, too"),"Home note is warm correspondence rather than a new chore")
 await letter_end();await snap("polish179-home-letter-scrolled");g.close_panel()
 var rescue=HoldAncestralClaim.data(s);rescue.stage=1
 HoldWorkerLodge100.speak(g,0);check(has_label("survey crew is still below") and not has_label("home registration"),"Active rescue takes precedence over domestic congratulations");g.close_panel()
 rescue.stage=3;HoldWorkerLodge100.speak(g,0);check(has_label("brought our people home"),"Successful rescue has its own greeting");g.close_panel();rescue.stage=0
 var prior=s.surface.get("invasion131",{}).duplicate(true);s.surface.invasion131={"returned":true}
 HoldWorkerLodge100.speak(g,0);check(has_label("Welcome home, Thane"),"Recorded final homecoming takes precedence over early milestones");g.close_panel()
 if prior.is_empty():s.surface.erase("invasion131")
 else:s.surface.invasion131=prior
 money=s.money;inventory=s.inventory.duplicate(true);estate=JSON.parse_string(JSON.stringify(s.surface.homes))
 g.save_game();g.start_game(true);settle();s=g.state
 check(HoldFrontier103.home_letters(s).size()==2 and s.money==money and s.inventory==inventory and JSON.parse_string(JSON.stringify(s.surface.homes))==estate,"Correspondence survives reload without duplicate rewards or property changes")
 var saved=HoldFrontier103.data(s).duplicate(true);HoldFrontier103.data(s).erase("home169")
 check(HoldFrontier103.home_letters(s).is_empty() and HoldWorkerLodge100.household_greeting(g,0)=="","Legacy non-family fortunes do not acquire invented family history")
 s.surface.frontier103=saved

func letter_end():
 for i in 10:await process_frame
 var focused=root.gui_get_focus_owner()
 if focused!=null:focused.release_focus()
 g.menu_scroll.scroll_vertical=10000
