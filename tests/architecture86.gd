extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 for id in HoldData.RESEARCH:g.state.tech[id]=true
 g.surface.enter("claim",Vector2(2200,1060));settle()
 check(not g.surface.walkable(Vector2(1840,1000)),"Expanded grounds keep the visible tributary unwalkable")
 check(g.surface.walkable(Vector2(1840,700)) and g.surface.walkable(Vector2(1920,1100)),"Eastern plots connect over dry ground beyond the old boundary")
 var a=g.surface.architecture
 check(HoldBuildingPlans.catalogue().size()==22,"All 22 existing building designs are exposed through shared plans")
 for ward in HoldWorldZones.WARDS:
  for b in g.surface.world.buildings(ward):
   check(HoldBuildingPlans.catalogue().has(b.plan),"Authored building resolves to player-buildable plan "+b.plan)
 a.selected="cottage";var before=g.state.count("stone");var fee=a.cost("cottage")
 check(a.place(Vector2(2200,1000)),"Cottage blueprint builds on real owned ground: "+a.reason)
 check(g.state.count("stone")==before-int(fee.stone),"Blueprint spends its shell and component costs exactly once")
 var b=a.data().instances[0];var id=str(b.id);var room=HoldBuildingPlans.room_id(id)
 check(not g.surface.walkable(Vector2(2200,900)) and g.surface.walkable(Vector2(2200,1045)),"Shared footprint blocks the building and keeps its doorway approach clear")
 await snap("01-player-cottage")
 g.surface.enter(room);settle()
 check(a.interior() and g.zone=="claim" and g.surface.can_furnish(),"Player building opens an owned, editable interior")
 check(HoldRoomLayout.floor_rect(room)==HoldRoomLayout.floor_rect("home:blueprint"),"Player cottage and prepared cottage use the same room dimensions")
 check(g.state.surface.chests.values().any(func(c):return c.area==room),"Blueprint storage is an actual private chest")
 at(Vector2(440,375));check(g.hearth.cook("root_hotpot"),"Copied hearth supports real cooking")
 at(Vector2(480,550));check(g.surface.house.build(Vector2(580,500),"wall"),"Shared structure tools add a real interior partition")
 check(not g.surface.walkable(Vector2(580,500)),"Interior partition uses real collision")
 await snap("02-player-cottage-room")
 check(g.surface.house.build(Vector2(580,500),"remove"),"Player can recover the partition")
 g.save_game();g.start_game(true);settle();a=g.surface.architecture;b=a.record(id)
 check(g.surface.area==room and a.interior(),"Saving inside a constructed building restores that same interior")
 a.leave();settle();at(Vector2(b.x,b.y+60));check(a.expand("extend_x"),"The same plan supports a side-bay extension: "+a.reason)
 check(HoldRoomLayout.floor_rect(room).size.x==720,"Side bay expands actual usable interior space")
 check(a.expand("extend_y") and HoldRoomLayout.floor_rect(room).size.y==465,"Rear bay expands actual floor depth and moves the exit")
 check(a.add_floor(),"Player can add a complete upper floor with aligned stairs")
 g.surface.enter(room);settle();a.stairs(true);settle()
 check(a.current_floor()==1 and g.surface.area==HoldBuildingPlans.room_id(id,1),"New staircase reaches the saved upper floor")
 check(HoldRoomLayout.floor_rect(g.surface.area)==HoldRoomLayout.floor_rect(room),"Additional storeys retain the complete expanded foundation")
 a.stairs(false);settle();a.leave();settle();at(Vector2(b.x,b.y+60))
 check(not a.recover(),"Recovery refuses to destroy furnished buildings or their contents")
 a.move_building();at(Vector2(2750,1060));check(a.place(Vector2(2750,1000)),"Whole-building relocation preserves its interior instance")
 check(a.record(id).x==2760 and g.state.surface.chests.values().any(func(c):return c.area==room),"Moving a building preserves storage and stable room IDs")
 g.surface.enter(room);settle();await snap("03-extended-cottage-room")
 a.leave();settle();at(Vector2(2750,1080));await snap("04-extended-cottage")
 g.open_panel("architecture");await snap("05-building-book");check(g.panel.get_global_rect().end.y<=540,"Renovation controls fit the viewport and scroll");g.close_panel()
 g.open_panel("architecture_details");await snap("06-details");check(g.panel.get_global_rect().end.y<=540,"Furniture catalogue fits the viewport and scrolls");g.close_panel()
 # The workstation rule must be based on ownership, including new interiors.
 g.surface.enter(room);settle();at(Vector2(450,500))
 check(g.handworks.build("stone_pile",Vector2(380,500)),"Real equipment can be installed inside a player building")
 var chest=g.state.surface.chests.values().filter(func(c):return c.area==room)[0];chest.items={"crystal":7}
 g.save_game();g.start_game(true);settle();a=g.surface.architecture
 check(g.state.surface.chests.values().any(func(c):return c.area==room and c.items.get("crystal",0)==7),"Occupied chest and workshop survive reloading their building")
 # Build each real plan, enter through the real doorway and compare every floor.
 var retained=g.state.surface.duplicate(true)
 for plan_id in HoldBuildingPlans.catalogue():
  g.state.surface=retained.duplicate(true);g.surface.enter("claim",Vector2(2300,1760));settle()
  var plan=HoldBuildingPlans.plan(plan_id);a.selected=plan_id;a.moving=""
  var measured=Time.get_ticks_usec();a.valid(HoldBuildingPlans.instance(plan_id,Vector2(2300,1700)));print("VALID_US ",plan_id," ",Time.get_ticks_usec()-measured)
  var started=Time.get_ticks_usec();var built=a.place(Vector2(2300,1700))
  print("PLACEMENT_US ",plan_id," ",Time.get_ticks_usec()-started)
  check(built,"Player can construct shared plan "+plan_id+": "+a.reason)
  if not built:continue
  var instance=a.data().instances.back();var owned=HoldBuildingPlans.room_id(str(instance.id))
  var crossing=g.surface.roads.crossing(Vector2(2300,1705),Vector2(2300,1699))
  check(crossing.get("target","")==owned,"Physical front door leads to its own interior: "+plan_id)
  if plan_id in ["hold_tavern","hold_forge","hold_throne","folk_hearthward_1","wayfarer"]:await snap("plan-"+plan_id+"-outside")
  for z in plan.rooms.size():
   var owned_floor=HoldBuildingPlans.room_id(str(instance.id),z)
   g.surface.enter(owned_floor);settle()
   check(HoldRoomLayout.floor_rect(owned_floor)==HoldRoomLayout.floor_rect(plan.rooms[z]),"Authored/player floor geometry parity: "+plan_id+"/"+str(z))
   var source=HoldBuildingPlans.contents(g.surface.world,plan.rooms[z]);var actual=g.state.surface.decor.filter(func(d):return d.area==owned_floor)
   var expected=source.filter(func(f):return f.furnishing!="chest")
   var stores=g.state.surface.chests.values().filter(func(c):return c.area==owned_floor)
   var source_stores=source.filter(func(f):return f.furnishing=="chest")
   check(stores.size()==source_stores.size() and source_stores.all(func(f):return stores.any(func(c):return Vector2(c.x,c.y)==f.p)),"Every original storage component becomes a private chest: "+plan_id+"/"+str(z))
   check(actual.size()==expected.size() and expected.all(func(f):return actual.any(func(d):return d.kind==f.furnishing and Vector2(d.x,d.y)==f.p)),"Authored/player editable component parity: "+plan_id+"/"+str(z))
   check(g.surface.walkable(g.player),"Arrival and stair landing are clear: "+plan_id+"/"+str(z))
   check(g.surface.world.routines.people(owned_floor,g.state.elapsed).is_empty(),"A building plan does not clone its original residents: "+plan_id+"/"+str(z))
   if plan_id in ["hold_tavern","hold_forge","hold_throne","folk_hearthward_1","wayfarer"]:await snap("plan-"+plan_id+"-floor-"+str(z))
   if expected.any(func(f):return f.furnishing in ["bed","double_bed"]):
    check(g.surface.points().any(func(p):return p.action=="house_rest"),"Copied beds have a usable resting approach: "+plan_id+"/"+str(z))
   if plan_id=="hold_forge":
    at(Vector2(970,590));check(a.can_forge(),"Copied worktable and hearth provide a real crafting station")
    g.open_panel("forge");check(g.panel_id=="forge" and g.state.craft("iron"),"Player workshop uses the existing smelting recipes");g.close_panel()
   if plan_id=="hold_throne":
    at(Vector2(650,580));await snap("plan-hold_throne-dais")
   if z==0 and plan.rooms.size()>1:
    a.stairs(true);settle();check(a.current_floor()==1,"Template staircase connects the player floors: "+plan_id)
   if z==0:check(not a.connections(owned_floor).is_empty(),"Exit connects to the saved outside address: "+plan_id)
 g.state.surface=retained;g.surface.enter("claim",Vector2(2450,850));settle();g.open_panel("architecture");await snap("07-catalogue");g.close_panel()
 # An unfurnished shell uses the same architecture and can be recovered safely.
 at(Vector2(2300,1760));a.selected="cottage";a.furnish_plan=false
 var shell=HoldBuildingPlans.shell_cost("cottage");var stone=g.state.count("stone")
 check(a.place(Vector2(2300,1700)) and g.state.count("stone")==stone-int(shell.stone),"Empty shell charges only architectural components")
 var empty=a.data().instances.back();var empty_room=HoldBuildingPlans.room_id(str(empty.id))
 check(not g.state.surface.decor.any(func(d):return d.area==empty_room) and not g.state.surface.chests.values().any(func(d):return d.area==empty_room),"Empty shell leaves the layout in the player's hands")
 check(a.recover() and g.state.count("stone")==stone,"Empty-shell recovery returns paid structural materials")
 a.furnish_plan=true
 # Reject obstructed foundations without consuming resources.
 a.selected="cottage";var material=g.state.count("wood");at(Vector2(500,490))
 check(not a.place(Vector2(500,440)) and g.state.count("wood")==material,"Blocked placement never consumes materials or overwrites the charter home")
 print("ARCHITECTURE86: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
