extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface
 for ward in HoldWorldZones.WARDS:
  s.enter(ward);settle()
  check(s.size()==HoldNeighborhood.SIZE,ward+" includes the residential gallery")
  check(s.walkable(Vector2(960,1075)) and not s.walkable(Vector2(650,1075)),ward+" bridge deck supports feet and open shaft blocks travel")
  check(not s.walkable(Vector2(875,1075)) and not s.walkable(Vector2(1045,1075)),ward+" visible bridge rails are solid")
  var all_clear=true
  for b in s.world.buildings():
   if not s.walkable(b.p+Vector2(0,35)):all_clear=false;print("BLOCKED DOOR ",ward," ",b)
  var walls_hold=true
  for b in s.world.buildings():
   var base=HoldWorldZones.building_footprint(b)
   for side in [-1,1]:
    at(Vector2(base.get_center().x+side*(base.size.x/2+15),base.get_center().y))
    if not s.walkable(g.player):continue
    Input.action_press("left" if side==1 else "right");s.move(.5);Input.action_release("left" if side==1 else "right")
    if base.grow(9).has_point(g.player):walls_hold=false
   at(base.position-Vector2(15,15))
   if s.walkable(g.player):
    Input.action_press("right");Input.action_press("down");s.move(.5);Input.action_release("right");Input.action_release("down")
    if base.grow(9).has_point(g.player):walls_hold=false
  check(walls_hold,ward+" lateral movement cannot wiggle inside building footprints")
  check(all_clear,ward+" every building threshold has a clear approach")
  var folk_clear=true
  for t in range(0,180,3):
   for c in s.world.people(t):
    if not s.walkable(c.p):folk_clear=false;print("BLOCKED CITIZEN ",ward," ",c.p)
  check(folk_clear,ward+" citizen routes stay on walkable floor")
  for i in 3:
   var door=HoldNeighborhood.home_door(i);at(door+Vector2(0,15));key(KEY_E);settle()
   check(s.area==HoldNeighborhood.home_id(ward,i),ward+" home "+str(i)+" enters through its painted threshold")
   at(HoldNeighborhood.STAIR+Vector2(0,30));key(KEY_E);settle()
   check(not s.walkable(Vector2(480,625)) and not s.points().any(func(p):return p.action=="leave"),"Upper room has no phantom exit to the street")
   check(s.area==HoldNeighborhood.home_id(ward,i,1) and g.player==HoldNeighborhood.STAIR+Vector2(0,30),"Upper room shares the real stair landing")
   g.save_game();g.start_game(true);settle()
   check(s.area==HoldNeighborhood.home_id(ward,i,1),"Upper room and Z persist on reload")
   at(HoldNeighborhood.STAIR+Vector2(0,30));key(KEY_E);settle()
   check(s.area==HoldNeighborhood.home_id(ward,i),"Same stair descends to family room")
   at(Vector2(480,610));key(KEY_E);settle()
   check(s.area==ward and g.player.distance_to(door+Vector2(0,35))<1,"Home exit returns to its own doorstep")
 s.enter("room:home");settle();await snap("starter-home")
 s.enter("hearthward");settle();at(Vector2(960,980));await snap("bridge")
 Input.action_press("down");s.move(1.2);Input.action_release("down")
 check(g.player.y>1135 and s.walkable(g.player),"Real movement crosses the bridge onto the gallery")
 at(Vector2(650,980));Input.action_press("down");s.move(1.2);Input.action_release("down")
 check(g.player.y<1012,"Real movement stops at the visible shaft railing")
 at(Vector2(700,1550));await snap("gallery")
 s.enter(HoldNeighborhood.home_id("hearthward",0));settle();g.state.elapsed=150;await snap("family-hearth")
 at(HoldNeighborhood.STAIR+Vector2(0,30));key(KEY_E);settle();await snap("upper-room")
 s.enter("hearthward");settle();at(HoldWorldZones.ROYAL+Vector2(0,30));key(KEY_E);settle()
 check(s.area=="crownward","Royal stair climbs at the actual landing")
 key(KEY_E);settle();check(s.area=="hearthward","Royal stair returns to the same horizontal coordinate")
 at(HoldWorldZones.FORGE+Vector2(0,30));key(KEY_E);settle();check(s.area=="forgeward","Forge stair descends to lower ward")
 await snap("forge-stair")
 for link in HoldTerraces.LINKS:
  s.enter(link.upper);settle();at(Vector2(link.x,1585));Input.action_press("down")
  for i in 200:s.move(1.0/60)
  Input.action_release("down")
  check(s.area==link.lower,"Residential Great Stair walks down to "+link.lower)
  Input.action_press("up")
  for i in 200:s.move(1.0/60)
  Input.action_release("up")
  check(s.area==link.upper,"Same physical Great Stair returns to "+link.upper)
 print("HOLD65: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
