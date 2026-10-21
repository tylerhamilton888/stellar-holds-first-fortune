extends "res://tests/support/game_fixture.gd"
func walk_path(points:Array)->bool:
 if points.is_empty():return false
 for p in points:
  var attempts=0
  while g.player.distance_to(p)>1 and attempts<3000:
   var delta=(p-g.player).normalized();var distance=g.player.distance_to(p)
   for pair in [["right",delta.x],["left",-delta.x],["down",delta.y],["up",-delta.y]]:
    if pair[1]>.01:Input.action_press(pair[0],pair[1])
    else:Input.action_release(pair[0])
   g.surface.move(minf(1.0/60,distance/150.0));attempts+=1
  for action in ["right","left","down","up"]:Input.action_release(action)
  if attempts>=3000:return false
 return true
func measure_frames()->Dictionary:
 var times=[]
 for i in 80:
  var began=Time.get_ticks_usec();g.clock+=1.0/60;g.queue_redraw()
  await process_frame;await RenderingServer.frame_post_draw
  if i>=20:times.append((Time.get_ticks_usec()-began)/1000.0)
 times.sort()
 return {"p50_ms":times[30],"p95_ms":times[57],"renderer":"Linux llvmpipe native 1280x720; frame interval includes display scheduling"}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface;var routines=s.world.routines;routines.ensure()
 print("ROUTINE COMPILATION ms=",routines.build_ms," grids=",routines.grids.size()," routes=",routines.compiled_paths)
 check(routines.plans.size()==9,"Nine households have persistent daily journeys")
 check(routines.grids.is_empty() and routines.path_cache.is_empty(),"Navigation grids are released after compiling schedules")
 for plan in routines.plans:
  var clear=true;var visited={}
  for step in plan.steps:
   visited[step.area]=true
   for j in range(ceili(step.a.distance_to(step.b)/5.0)+1):
    var p=step.a.lerp(step.b,float(j)/maxi(1,ceili(step.a.distance_to(step.b)/5.0)))
    if not s.world.navigation_clear(step.area,p):clear=false;print("BAD ROUTE ",plan.person.name," ",step.area," ",p)
  check(clear,plan.person.name+" stays on actual floor and clears architecture")
  check(visited.has("room:tavern") and visited.has(HoldNeighborhood.home_id(plan.ward,plan.index,1)),plan.person.name+" visits home, work and tavern")
 for link in HoldTerraces.LINKS:
  s.enter(link.upper);settle();at(Vector2(link.x,1585))
  var before=g.gait_clock
  Input.action_press("down")
  for i in 240:s.move(1.0/60)
  Input.action_release("down")
  check(s.area==link.lower and g.player.y>260,"Walk continuously down to "+link.lower)
  check(g.transition_left==0 and s.stair_trip.is_empty() and g.gait_clock>before,"Great Stair preserves gait and never locks controls")
  at(Vector2(link.x,120));await snap(link.lower+"-stair")
  var saved=g.player;g.save_game();g.start_game(true);settle()
  check(s.area==link.lower and g.player.distance_to(saved)<.1,"Save restores the same stair position")
  Input.action_press("up")
  for i in 150:s.move(1.0/60)
  Input.action_release("up")
  check(s.area==link.upper and g.player.y<1590,"Walk continuously back to "+link.upper)
  at(Vector2(link.x,1700));Input.action_press("right");s.move(.6);Input.action_release("right")
  check(absf(g.player.x-link.x)<36,"Visible balustrade blocks lateral movement")
 # Test the actual camera seam and a loaded handcart, not just area identifiers.
 s.enter("hearthward");settle();at(Vector2(1700,HoldTerraces.STRIDE-1))
 var screen_before=g.player-g.camera
 var cart={"id":"living67-cart","kind":"cart","area":g.handworks.context(),"x":g.player.x,"y":g.player.y,"raw":[{"kind":"stone","units":7}],"cargo":{"iron_ore":3},"job":{},"hitched":true}
 g.handworks.data().facilities.append(cart)
 Input.action_press("down");s.move(.02);Input.action_release("down")
 check((g.player-g.camera-screen_before).distance_to(Vector2(0,2.7))<.5,"Camera preserves the exact screen-space crossing")
 check(cart.area==g.handworks.context() and cart.raw[0].units==7 and cart.cargo.iron_ore==3,"Loaded handcart and its contents cross with the player")
 check(not HoldFolk.warming(),"Continuous crossing never triggers character preparation")
 g.handworks.data().facilities.erase(cart)
 s.enter("hearthward");settle();at(HoldWorldZones.door(7)+Vector2(0,15));key(KEY_E);settle()
 check(s.area=="room:home","The painted quarters doorway enters the player's home")
 at(HoldRoomLayout.exit_point(s.area)-Vector2(0,10));key(KEY_E);settle()
 check(s.area=="hearthward","Starting quarters lead back into the living hold")
 check(walk_path(routines.path(s.area,g.player,Vector2(1700,1585))),"Actual player movement reaches the Great Stair across the gallery bridge")
 Input.action_press("down")
 for i in 190:s.move(1.0/60)
 Input.action_release("down")
 check(s.area=="forgeward" and walk_path(routines.path(s.area,g.player,HoldWorldZones.door(15))),"Actual movement continues to Borin's painted door")
 key(KEY_E);settle();check(s.area=="room:forge","The continuous route enters the expanded workshop")
 s.enter("forgeward");settle();s.enter("room:forge");settle();at(Vector2(925,650));await snap("forge-hall")
 check(s.size().x>1200 and s.walkable(Vector2(1100,840)),"Forge has a full-sized accessible workshop wing")
 at(HoldRoomLayout.exit_point(s.area)-Vector2(0,10));key(KEY_E);settle()
 check(s.area=="forgeward","Expanded forge exits at its own actual doorway")
 # Follow the exact same named resident across the street, stair and interior.
 var oskar=routines.plans.filter(func(p):return p.ward=="hearthward" and p.index==0)[0]
 var approach=oskar.steps.filter(func(step):return step.area=="hearthward" and step.a==Vector2(1700,1590) and step.b==Vector2(1700,1740))[0]
 g.state.elapsed=approach.start+approach.duration*.7-oskar.offset
 s.enter("forgeward");settle();at(Vector2(1700,100))
 var far=s.world.neighbor_stair_people().filter(func(c):return c.interaction=="resident:hearthward:0")
 check(far.size()==1 and far[0].p.distance_to(Vector2(1700,-45))<.01,"Far-half stair resident joins the active foreground at the same world coordinate")
 check(not s.world.people(g.state.elapsed).any(func(c):return c.get("interaction","")=="resident:hearthward:0"),"Far-half stair resident is drawn once without changing area ownership")
 await snap("resident-upper-stair")
 g.state.elapsed+=1.0
 var arrived=s.world.people(g.state.elapsed).filter(func(c):return c.get("interaction","")=="resident:hearthward:0")
 check(arrived.size()==1 and arrived[0].p.y>0 and not s.world.neighbor_stair_people().any(func(c):return c.interaction=="resident:hearthward:0"),"Resident crosses the seam without duplicate actors or a visibility gap")
 await snap("resident-lower-stair")
 var captured={}
 for step in oskar.steps:
  var key=step.area
  if key not in ["hearthward","forgeward","room:forge","room:tavern"] or captured.has(key):continue
  var time=step.start+step.duration*.5-oskar.offset
  if time<0:time+=oskar.duration
  var c=routines.sample(oskar,time);g.state.elapsed=time;s.enter(c.area);settle();at(c.p+Vector2(-45,30))
  await snap("oskar-"+key.replace(":","-"));captured[key]=true
  var here=routines.people(c.area,time).filter(func(n):return n.interaction==c.interaction)
  check(here.size()==1 and here[0].profile==oskar.person.profile,"One consistent Oskar in "+c.area)
 var time=g.state.elapsed;var old=routines.sample(oskar,time);g.save_game();g.start_game(true);settle()
 var restored=s.world.routines.sample(s.world.routines.plans.filter(func(p):return p.ward=="hearthward" and p.index==0)[0],g.state.elapsed)
 check(restored.area==old.area and restored.p.distance_to(old.p)<.01 and restored.profile==old.profile,"Reload preserves resident location, activity and appearance")
 # Native contact sequence: the hammer, gripping hands and material line up.
 var shift=oskar.steps.filter(func(step):return step.activity=="On shift · forge")[0]
 s.enter("room:forge");settle();at(Vector2(830,700));g.state.elapsed=shift.start+8-oskar.offset
 for i in 4:
  g.state.elapsed+=.2;await snap("work-contact-%d"%i)
 s.enter("forgeward");settle();at(Vector2(1700,80));await snap("painted-stair")
 var metrics=await measure_frames()
 metrics.route_compile_ms=routines.build_ms;metrics.compiled_paths=routines.compiled_paths
 var file=FileAccess.open(output+"/performance.json",FileAccess.WRITE);file.store_string(JSON.stringify(metrics,"  "));file.close()
 print("PERFORMANCE67 ",JSON.stringify(metrics))
 g.state.claim_id="old_delving";s.enter("claim");settle();at(Vector2(820,850))
 g.state.add("stone",12);g.state.add("dressed_stone",4);s.placing="stone_pillar"
 check(s.place(Vector2(820,780)),"The town's painted column is craftable and placeable with normal materials")
 check(not s.walkable(Vector2(820,770)),"Placed column's painted base blocks feet")
 g.save_game();g.start_game(true);settle()
 check(g.state.surface.decor.any(func(d):return d.kind=="stone_pillar" and d.x==820),"Shared architectural decoration persists on reload")
 await snap("crafted-pillar")
 print("LIVING67: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
