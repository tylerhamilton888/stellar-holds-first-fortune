extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface;var w=s.world
 for area in HoldWorldZones.WARDS:
  s.enter(area);settle()
  # Check the existing public walking loops, not only their waypoint endpoints.
  var clear=true
  for time in range(0,180,2):
   for c in w.people(time,area):
    if c.get("index",9)<6 and not w.navigation_clear(area,c.p):clear=false;print("PUBLIC BLOCK ",area," ",c.p)
  check(clear,"Public citizens keep clear routes in "+area)
  for b in w.buildings(area):
   var approach=b.p+Vector2(0,24)
   check(s.walkable(approach),"Door approach remains clear: "+area+str(b.p))
  for p in HoldWardDesign.points(area):
   at(p.p);check(s.walkable(p.p) and s.nearest().action==p.action,"Notices and overlook are physically accessible: "+p.action)
  var contents=w.street_furnishings(area)
  for kind in ["orrery","notice_board","oath_stone","pressure_manifold","training_rack"]:
   for o in contents.filter(func(item):return item.furnishing==kind):
    check(not s.walkable(HoldFurnishings.footprint(kind,o.p).get_center()),"Visible "+kind+" base is solid in "+area)
  at(Vector2(970,760));await snap(area+"-center")
  at(Vector2(690,650));await snap(area+"-frontage")
  at(Vector2(1650,720));await snap(area+"-services")
  at(Vector2(1120,1550));await snap(area+"-kin-gallery")
  at(Vector2(200,270));await snap(area+"-upper-depth")
  at(Vector2(1290,1580));await snap(area+"-lower-depth")
 for pair in [["hearthward","room:home"],["hearthward","room:tavern"],["crownward","room:throne"],["forgeward","room:forge"],["hearthward",HoldNeighborhood.home_id("hearthward",0)]]:
  s.enter(pair[0]);settle();s.enter(pair[1]);settle();at(s.spawn(pair[1]))
  var threshold=HoldCivicArt.exit_rect(s.area);threshold.position-=g.camera
  var bar=Rect2(224,g.hotbar.bar_y(),512,80)
  check(not threshold.intersects(bar) and threshold.end.y<498,"Whole exit threshold clears the hotbar on arrival: "+pair[1])
  await snap(pair[1].replace(":","-")+"-exit")
  var p=HoldRoomLayout.exit_point(s.area)
  at(p-Vector2(0,10));check(s.nearest().get("action","")=="leave","Exit cue corresponds to actual E interaction: "+pair[1])
  check(not s.walkable(p+Vector2(53,0)) and s.walkable(p),"Open door leaves block feet while central passage stays clear: "+pair[1])
  key(KEY_E);settle();check(s.area==pair[0],"Exit returns to the same ward: "+pair[1])
 s.enter(HoldNeighborhood.home_id("hearthward",0,1));settle()
 check(not HoldCivicArt.has_exit(s.area) and not s.points().any(func(p):return p.action=="leave"),"Upper household room retains its actual stair, with no fake exit")
 s.enter("crownward");settle();at(Vector2(750,826));key(KEY_E)
 check(w.speech.contains("STONE MUST BEAR") and g.panel_id=="","Public notice is readable without opening an obstructive menu")
 s.enter("forgeward");settle();at(Vector2(520,710));check(s.walkable(g.player),"Freight approach is clear before saving")
 s.selected_chest="keldrath:freight:forgeward:0";g.state.add("stone",5)
 check(s.transfer("stone",5,true)==5,"Freight lockbox accepts physical inventory through existing storage")
 var stored=g.state.surface.chests[s.selected_chest].items.get("stone",0)
 g.save_game();g.start_game(true);settle()
 check(g.state.surface.chests[s.selected_chest].items.get("stone",0)==stored,"Freight contents survive reload")
 check(s.transfer("stone",5,false)==5,"Freight materials can be recovered after reload")
 s.enter("crownward");settle();at(Vector2(750,826))
 var opening=g.state.opening;var money=g.state.money;g.state.add("stone",7);var stone=g.state.count("stone")
 g.save_game();g.start_game(true);settle()
 check(g.state.opening==opening and g.state.money==money and g.state.count("stone")==stone,"Reload retains quest, money and resources")
 check(s.area=="crownward" and g.player.distance_to(Vector2(750,826))<.1,"Reload retains ward and exact usable position")
 print("CIVIC68: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
