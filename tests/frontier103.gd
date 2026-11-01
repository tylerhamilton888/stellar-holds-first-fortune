extends "res://tests/support/game_fixture.gd"
func desk(key:String):
 g.surface.enter(HoldFrontier103.room(g.state,key));settle();at(Vector2(480,500));g.open_panel("frontier103")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not HoldFrontier103.active(g.state),"Legacy fortune retains existing geography")
 HoldFirstVisit99.begin(g);settle()
 var s=g.state;var d=HoldFrontier103.data(s)
 check(g.surface.area==HoldFrontier103.lodge(s) and s.claim_id=="","New fortune starts in frontier bunkhouse without free land")
 check(g.surface.walkable(g.player),"Bunkhouse arrival is clear")
 var enclosed_map={}
 for y in 5:
  for x in 5:
   enclosed_map[str(x)+","+str(y)]={"floor":"stone_floor","roof":true,"wall":"wall" if x==0 or y==0 or x==4 or y==4 else ""}
 enclosed_map["2,4"].wall="door"
 check(HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"Piece-built home needs an enclosed room with a door")
 enclosed_map["2,2"].roof=false
 check(not HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"Missing roof cannot earn finished-home marks")
 enclosed_map["2,2"].roof=true;enclosed_map.erase("0,2")
 check(not HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"An open wall cannot earn finished-home marks")
 check(HoldWorkerLodge100.people(g).size()==3,"Foreman and miners inhabit the shared bunkhouse")
 await snap("bunkhouse")
 var a=g.surface.architecture
 for key in HoldFrontier103.BUILDINGS:
  var b=a.record(str(d.buildings[key]));check(HoldBuildingPlans.catalogue().has(b.plan),"Town uses player-buildable plan: "+key)
  g.surface.enter("trail");settle();at(Vector2(b.x,b.y+45))
  check(g.surface.walkable(g.player),"Public building doorway clear: "+key)
  g.surface.enter(HoldFrontier103.room(s,key));settle()
  check(g.surface.walkable(g.player),"Public building interior entry clear: "+key)
  if b.rooms.size()>1:
   var stairs=HoldBuildingPlans.stair_position(g.surface.area)
   check(g.surface.walkable(stairs+Vector2(0,35)),"Lower stair landing clear: "+key)
   a.stairs(true);settle()
   check(a.current_floor()==1 and g.surface.walkable(g.player),"Real upper floor reachable: "+key)
   a.stairs(false);settle();check(a.current_floor()==0,"Same stair returns to ground floor")
  check(not g.surface.recover_decor() and not g.surface.can_furnish(),"Public furniture is protected")
  check(not a.add_floor() and not a.expand("extend_x") and not a.recover(),"Shared town shell protected from free recovery")
 desk("lodge");check(not HoldFrontier103.permit(g),"Home plot must be earned")
 s.add("coal",8);button("Deliver shift commission")
 check(s.opening==2,"Local foreman accepts real coal and relights communal forge")
 desk("forge");s.add("iron_ore",4);s.add("coal",2)
 check(HoldFrontier103.transact(g,"craft","iron") and s.queue.size()>0,"Local forge starts real smelting")
 g.player=Vector2(230,560);check(not HoldFrontier103.transact(g,"craft","iron"),"Remote forge callback blocked")
 desk("watch");s.money=1000
 var before=s.count("food");check(HoldFrontier103.transact(g,"trade","food",true) and s.count("food")==before+1,"Watch stores sell real supplies")
 desk("survey");await snap("survey-office")
 g.surface.architecture.stairs(true);settle();await snap("upper-archive")
 at(Vector2(690,575));key(KEY_E);check(g.panel_id=="frontier_archive103" and g.menu_paused,"Upper archive has readable town records and charter law");await snap("archive-text");g.close_panel()
 g.surface.enter("trail");settle();at(Vector2(520,680));await snap("town-west")
 at(Vector2(1480,680));await snap("town-east")
 for day in 15:
  s.elapsed=day*600
  for actor in g.surface.roads.people("trail"):
   if actor.interaction=="road_folk:8":
    at(actor.p+Vector2(0,22));HoldPeople.chat(g,"road_folk:8")
 check(int(HoldPeople.records(s)["road_folk:8"].bond)==10,"Skarrin accepts help but never reaches genuine trusted friendship")
 for t in range(0,80,5):
  for actor in g.surface.roads.people("trail",t):check(g.surface.walkable(actor.p),"Town route stays clear: "+actor.name)
 g.surface.enter("hearthward");check(g.surface.area=="trail","Keldrath remains a later journey")
 desk("lodge");HoldFirstVisit99.data(s).rewarded=true
 for id in ["watch","rest"]:
  for item in HoldGreatClaim102.PROJECTS[id].cost:s.add(item,HoldGreatClaim102.PROJECTS[id].cost[item])
  at(Vector2(670,440));check(HoldGreatClaim102.contribute(g,id),"Real civic delivery earns settlement progress")
 at(Vector2(480,500));check(HoldFrontier103.permit(g) and s.claim_id!="","First shift and two projects earn permanent residential plot")
 check(not HoldFrontier103.permit(g),"Residential permit cannot repeat")
 for item in {"stone":30,"wood":24,"iron":2}:s.add(item,{"stone":30,"wood":24,"iron":2}[item])
 check(HoldFrontier103.build_storehouse(g) and not HoldFrontier103.build_storehouse(g),"Construction site becomes one actual storehouse exactly once")
 g.surface.enter("trail");settle();at(Vector2(1020,940));await snap("completed-storehouse")
 for t in range(0,80,5):
  for actor in g.surface.roads.people("trail",t):check(g.surface.walkable(actor.p),"Completed storehouse preserves patrol: "+actor.name)
 town_routes()
 desk("stores");check(g.surface.walkable(g.player) and HoldFrontier103.transact(g,"trade","food",true),"Completed public building is enterable and functional")
 g.surface.enter("claim");settle()
 check(not g.surface.world.exterior_objects().any(func(o):return o.kind=="building"),"Plot has no prebuilt player cottage")
 check(not HoldFrontier103.home_ready(g),"Empty ground is not a finished home")
 key(KEY_O);check(g.panel_id=="homestead","Plot O opens the actual home design menu");await snap("home-design-menu");g.close_panel()
 for item in ["stone","wood","iron"]:s.add(item,1000)
 a.selected="cottage";a.furnish_plan=true;at(Vector2(2480,820))
 check(a.place(Vector2(2480,700)),"Player chooses and builds home with normal construction transaction")
 var home=a.data().instances[-1];check(not home.get("public103",false),"Player home is privately editable")
 g.surface.enter(HoldBuildingPlans.room_id(str(home.id)));settle();await snap("player-home")
 check(HoldFrontier103.home_ready(g),"Completed shell, bed and hearth satisfy home milestone")
 check(a.add_floor(),"Player can add a real upper storey")
 a.stairs(true);settle();check(a.current_floor()==1 and g.surface.walkable(g.player),"Player's new upper floor is walkable")
 desk("lodge");var marks=int(HoldGreatClaim102.data(s).points)
 check(HoldFrontier103.finish_home(g) and not HoldFrontier103.finish_home(g),"Home milestone pays once")
 check(int(HoldGreatClaim102.data(s).points)==marks+60,"Home earns stated contribution marks")
 g.save_game();g.start_game(true);settle()
 check(HoldFrontier103.data(g.state).home_reward and HoldFrontier103.data(g.state).storehouse,"Home and town construction persist after reload")
 check(g.surface.architecture.record(str(home.id)).rooms.size()==2,"Player design and upper floor survive reload")
 print("FRONTIER103: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)

func town_routes():
 var grid=AStarGrid2D.new();grid.region=Rect2i(0,0,86,38);grid.cell_size=Vector2(20,20);grid.offset=Vector2(90,210);grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_NEVER;grid.update()
 for y in 38:
  for x in 86:
   var id=Vector2i(x,y);grid.set_point_solid(id,not g.surface.walkable(grid.get_point_position(id)))
 var start=Vector2i(30,24)
 for b in g.surface.architecture.data().instances:
  if b.area!="trail":continue
  var finish=Vector2i(roundi((b.x-90)/20),roundi((b.y+45-210)/20))
  check(not grid.get_id_path(start,finish).is_empty(),"Town street has a continuous walkable route to "+b.name)
