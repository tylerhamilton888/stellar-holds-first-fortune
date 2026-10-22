extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=1;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("room:home");settle();at(Vector2(320,550))
 g.state.add("wood",30);g.state.add("stone",30)
 g.open_panel("home");await snap("01-quarters-plans");g.close_panel()
 var p=Vector2(240,540)
 check(g.surface.furniture_valid(p,"chair"),"Quarters have usable clear floor for personal furnishings")
 check(not g.surface.furniture_valid(Vector2(480,560),"chair"),"Entrance aisle cannot be furnished over")
 var wood=g.state.count("wood");g.surface.start_placement("chair")
 check(g.surface.place(p),"Craft and place a chair in the starting quarters")
 check(g.state.count("wood")<wood and g.state.surface.facts.get("quarters_build",false),"Placement spends real materials and records the comfort")
 check(not g.surface.walkable(p),"Placed chair has a physical base")
 await snap("02-furnished-quarters")
 at(p+Vector2(55,0));check(g.surface.move_nearby_furnishing(),"Player-owned furnishing can be moved")
 g.surface.cancel_placement()
 at(Vector2(650,460));key(KEY_E)
 check(g.panel_id=="storage","Original quarters chest remains accessible")
 var stored=g.surface.transfer("stone",5,true)
 check(stored==5 and g.state.surface.facts.get("quarters_storage",false),"Original chest stores materials and records use")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(g.state.surface.facts.get("quarters_build",false) and not g.surface.walkable(p),"Furnishing and its collision survive reload")
 at(Vector2(328,388));key(KEY_E);await frames(110)
 check(g.state.surface.facts.get("quarters_rest",false),"Resting at the bedside records a useful comfort")
 g.close_panel();at(Vector2(735,547));key(KEY_E)
 check(g.panel_id=="letter" and HoldLetters.post(g),"Desk completes the promised letter home")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(HoldLetters.sent(g.state),"Letter remains sent after reload")
 g.surface.enter("pinewood");settle()
 # Surface equipment must block its visible base, but remain usable from the front.
 var h=g.handworks;var site=Vector2.ZERO
 for x in range(300,1000,40):
  for y in range(300,650,40):
   at(Vector2(x,y+70))
   if h.can_place(Vector2(x,y)):site=Vector2(x,y);break
  if site!=Vector2.ZERO:break
 check(site!=Vector2.ZERO,"Pinewood offers a clear worksite")
 at(site+Vector2(0,70));check(h.build("saw",site),"Craft a real saw station outdoors")
 check(not g.surface.walkable(site),"Outdoor station base blocks passage")
 check(h.clear_line(g.player,site),"Solid equipment can still be reached from its working side")
 check(not h.can_place(g.player),"Equipment cannot be built through the Dwarf")
 await snap("03-outdoor-worksite")
 g.save_game();g.start_game(true);settle()
 check(not g.surface.walkable(site),"Outdoor equipment collision survives reload")
 print("FIRSTHOUR73: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
