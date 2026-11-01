extends "res://tests/support/game_fixture.gd"

func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 for b in g.title_ui.find_children("*","Button",true,false):
  if b.text=="Continue / choose a fortune":b.pressed.emit();break
 button("New fortune")
 check(is_instance_valid(g.creator) and g.first_visit_pending,"An ordinary new save selects the lodge opening")
 g.creator.cancelled.emit();await process_frame
 g.state.save_slot=2;g.start_game(false);settle()
 var q=HoldFirstVisit99.data(g.state)
 check(g.surface.area==HoldFrontier103.lodge(g.state) and q.get("lodge_intro",false),"A new first visit starts at the miners' lodge")
 check(g.surface.walkable(g.player) and g.surface.room(),"The starting position is clear and inside the lodge")
 HoldFirstVisit99.tick(g);check(HoldFirstVisit99.step(g.state)==0,"The mining lesson does not advance before reaching the mine")
 g.update_hud();check(g.objectives.visible and g.objectives.text.contains("Ivar"),"The first objective remains visible in the lodge")
 var furniture=g.hearth.furniture()
 check(furniture.filter(func(o):return o.kind=="bed").size()==3,"The lodge has three real shared bunks")
 var people=HoldWorkerLodge100.people(g)
 check(people.size()==3 and people[0].name=="Ivar Deepmeasure","Ivar and two named miners inhabit the lodge")
 for t in [0.0,4.0,7.0,10.0,18.0,21.0,24.0]:
  g.state.elapsed=t
  for person in HoldWorkerLodge100.people(g):check(g.surface.walkable(person.p),person.name+" remains on clear floor at "+str(t))
 g.state.elapsed=0;await snap("01-lodge")
 at(Vector2(560,380));key(KEY_E)
 check(g.panel_id=="lodge_talk" and q.ivar_spoken,"Ivar is reachable and explains the first morning")
 await snap("02-ivar");g.close_panel()
 check(HoldFirstVisit99.goal(g).contains("your room"),"The next goal points to the private room")
 at(HoldBuildingPlans.stair_position(g.surface.area)+Vector2(0,30));key(KEY_E);settle()
 check(g.surface.area==HoldFrontier103.quarters(g.state) and q.room_seen and g.surface.architecture.current_floor()==1,"The lodge door enters the existing private quarters")
 check(g.state.surface.chests.has("keldrath:quarters") and g.hearth.furniture().any(func(o):return o.kind=="bed"),"The real starting chest and bed remain available")
 await snap("03-private-room")
 at(HoldBuildingPlans.stair_position(g.surface.area)+Vector2(0,30));key(KEY_E);settle()
 check(g.surface.area==HoldFrontier103.lodge(g.state) and g.surface.walkable(g.player),"Leaving the room returns to a clear lodge doorway")
 at(HoldRoomLayout.exit_point(HoldFrontier103.lodge(g.state))-Vector2(0,10));key(KEY_E);settle()
 check(g.surface.area=="trail","The bunkhouse exits directly into the frontier town")
 check(g.surface.points().any(func(p):return p.action==HoldFrontier103.lodge(g.state)),"Exterior town doorway leads back into the shared bunkhouse")
 g.surface.enter("trail",Vector2(950,355));settle();g.surface.roads.portal_cooldown=0
 Input.action_press("up");await frames(180);Input.action_release("up");settle()
 check(g.zone=="mine" and q.work_started and q.focus=="basics","Reaching Old Workings begins the existing practical shift")
 var origin=g.player;g.player+=Vector2(85,0);HoldFirstVisit99.tick(g);key(KEY_I);g.close_panel();HoldFirstVisit99.tick(g)
 var w=g.deep.world
 for c in [Vector2i(12,11),Vector2i(13,11)]:
  w.set_cell(c,2)
  for i in 8:
   if w.at(c)!=0:g.deep.hit(c)
 g.player=Vector2(500,460);key(KEY_E);HoldFirstVisit99.tick(g)
 g.player=Vector2(260,420);key(KEY_E);HoldFirstVisit99.tick(g)
 var money=g.state.money;var timber=g.state.count("wood")
 g.player=Vector2(220,345);Input.action_press("interact");await frames(300);Input.action_release("interact")
 check(q.rewarded and q.focus=="home" and g.state.money==money+20 and g.state.count("wood")==timber+4,"Real bench work pays wages and unlocks the room project")
 HoldFirstVisit99.tick(g);check(g.state.money==money+20,"The first-shift wage is granted once")
 g.surface.enter("trail",Vector2(190,460));settle();key(KEY_E);settle()
 check(g.surface.area==HoldFrontier103.lodge(g.state),"The marked lodge entrance is usable after the shift")
 at(HoldBuildingPlans.stair_position(g.surface.area)+Vector2(0,30));key(KEY_E);settle()
 var before=g.state.count("wood");g.player=Vector2(535,520);g.surface.placing="chair"
 check(g.surface.furniture_valid(Vector2(600,520),"chair") and g.surface.place(Vector2(600,520)),"A player can build a real chair in the private room")
 check(q.home_made and q.focus=="bay" and g.state.count("wood")==before-2,"The room project consumes real materials and offers the old bay next")
 await snap("04-furnished-room");g.save_game();g.start_game(true);settle();q=HoldFirstVisit99.data(g.state)
 check(q.home_made and g.state.surface.decor.any(func(d):return d.area==HoldFrontier103.quarters(g.state) and d.kind=="chair"),"The completed room and placed furnishing survive save and reload")
 var paid=g.state.money;HoldFirstVisit99.tick(g);check(g.state.money==paid,"Reload does not repeat the wage")
 at(HoldBuildingPlans.stair_position(g.surface.area)+Vector2(0,30));key(KEY_E);settle()
 check(g.surface.area==HoldFrontier103.lodge(g.state),"Private room returns down the real stair to the lodge")
 # Old fortunes retain their original fixed furniture and existing decorations.
 g.state.save_slot=3;g.start_game(false);settle();g.surface.enter("room:home");settle()
 var legacy_objects=g.surface.world.room_objects()
 check(not HoldFirstVisit99.lodge_intro(g.state) and legacy_objects.any(func(o):return o.furnishing=="tea_table"),"A pre-lodge fortune keeps the original quarters furnishings")
 g.state.surface.decor.append({"area":"room:home","z":0,"x":600.0,"y":520.0,"kind":"chair"});g.save_game();g.start_game(true);settle()
 check(g.state.surface.decor.any(func(d):return d.area=="room:home" and d.kind=="chair"),"Existing player furnishings survive loading without a lodge migration")
 g.state.surface.first_visit99={"done":{},"guided":true,"focus":"basics","rewarded":false,"bay_found":false,"bay_warm":false,"bay_worked":false,"origin":[0.0,0.0]}
 check(not HoldFirstVisit99.lodge_intro(g.state) and g.surface.world.room_objects().any(func(o):return o.furnishing=="tea_table"),"Older first-visit saves also retain their original room")
 print("LODGE100: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
