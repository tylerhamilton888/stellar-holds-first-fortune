extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 g.depth_nav.update(0);await snap("title")
 var entry=false
 for b in g.title_ui.find_children("*","Button",true,false):
  if b.text=="First visit to the hold":b.pressed.emit();entry=true;break
 check(entry and g.first_visit_pending and g.panel_id=="save_slots","Title offers the first visit through protected normal save slots")
 g.depth_nav.update(0);await snap("choose-fortune")
 g.state.save_slot=2;g.start_game(false);settle()
 check(HoldFirstVisit99.active(g.state) and not g.state.test_session and g.state.save_slot==2,"First visit creates a normal resumable fortune in the chosen slot")
 check(g.surface.area==HoldFrontier103.lodge(g.state) and g.state.opening==1 and g.state.claim_id=="","First visit starts in the miners' lodge without granting a charter")
 g.surface.enter(HoldFrontier103.quarters(g.state));settle()
 check(HoldFirstVisit99.data(g.state).room_seen,"Visiting the existing private quarters records the first morning")
 g.surface.enter("trail",Vector2(950,345));settle();g.surface.action("mine");settle()
 check(not g.depth_nav.explore.enabled and not g.deep.world.solid(g.player),"First shift enters clear mine floor in overhead view")
 check(HoldOnboarding.side_stories(g.state),"Optional local lessons are available without finishing the orientation")
 key(KEY_J);check(g.menu_paused,"Opening journal pauses active play");g.depth_nav.update(0);await snap("first-task");g.close_panel()
 var origin=g.player;g.player+=Vector2(85,0);HoldFirstVisit99.tick(g)
 check(HoldFirstVisit99.step(g.state)==1,"Walking advances the first small task")
 key(KEY_I);g.close_panel();HoldFirstVisit99.tick(g)
 check(HoldFirstVisit99.step(g.state)==2,"Actual pack input advances the inventory task")
 var w=g.deep.world
 # Real excavation, E lifting/stocking and held work, as in the shared worksite acceptance.
 for c in [Vector2i(12,11),Vector2i(13,11)]:
  w.set_cell(c,2)
  for i in 8:
   if w.at(c)!=0:g.deep.hit(c)
 g.player=Vector2(500,460);key(KEY_E);HoldFirstVisit99.tick(g)
 check(HoldFirstVisit99.step(g.state)==3,"Lifting excavated stone completes the first material task")
 g.player=Vector2(260,420);key(KEY_E);HoldFirstVisit99.tick(g)
 check(HoldFirstVisit99.step(g.state)==4,"Actual rack deposit completes stocking")
 var iron=g.state.count("iron");var coal=g.state.count("coal")
 g.player=Vector2(220,345);Input.action_press("interact");await frames(300);Input.action_release("interact")
 check(HoldFirstVisit99.step(g.state)==5 and HoldFirstVisit99.data(g.state).rewarded,"Held work completes basic orientation through real output")
 check(g.state.count("iron")==iron+3 and g.state.count("coal")==coal+2,"Repair allowance arrives only once after the basics")
 check(not HoldFirstShift.guided(g) and HoldFirstVisit99.data(g.state).focus=="home","Completed basics lead to the personal room without demanding extra bench construction")
 key(KEY_J);g.depth_nav.update(0);await snap("restoration-lead")
 button("Take a break");g.close_panel()
 check(g.goal().begins_with("Explore at your own pace") and not HoldFirstShift.guided(g),"Pausing guidance removes task pressure and markers")
 g.save_game();g.start_game(true);settle()
 check(HoldFirstVisit99.step(g.state)==5 and not HoldFirstVisit99.data(g.state).guided,"Completed basics and paused guidance survive a normal save reload")
 HoldFirstVisit99.tick(g)
 check(g.state.count("iron")==iron+3 and g.state.count("coal")==coal+2,"Reload cannot duplicate the repair allowance")
 key(KEY_J);button("Town services");check(g.panel_id=="frontier103" and g.menu_paused,"Longer home milestone remains accessible through the journal")
 g.depth_nav.update(0);await snap("town-plan");g.close_panel()
 var remote=g.state.opening
 check(not HoldFrontier103.near(g,"lodge"),"Remote journal does not imply local delivery permission")
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(480,500));g.state.add("coal",8);g.open_panel("frontier103")
 button("Deliver shift commission");g.close_panel()
 check(g.state.opening==remote+1,"Actual frontier commission advances first-shift progression")
 g.state.save_slot=3;g.start_game(false);settle()
 check(not HoldFirstVisit99.active(g.state) and g.state.opening==0,"Standard new fortunes retain their original arrival")
 g.state.save_slot=2;g.start_game(true);settle()
 check(HoldFirstVisit99.active(g.state) and g.state.opening==2,"A separate normal fortune cannot overwrite first-visit progress")
 print("FIRSTVISIT99: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
