extends "res://tests/support/game_fixture.gd"
func reachable(points:Array):
 var grid=AStarGrid2D.new();grid.region=Rect2i(0,0,70,55);grid.cell_size=Vector2(20,20);grid.offset=Vector2(100,100);grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_NEVER;grid.update()
 for y in 55:
  for x in 70:
   var id=Vector2i(x,y);grid.set_point_solid(id,not g.surface.walkable(grid.get_point_position(id)))
 var exit=HoldRoomLayout.exit_point(g.surface.area)
 var start=Vector2i(roundi((exit.x-100)/20),roundi((exit.y-100)/20))
 for p in points:
  var target=Vector2i(roundi((p.p.x-100)/20),roundi((p.p.y-100)/20))
  check(g.surface.walkable(p.p) and not grid.get_id_path(start,target).is_empty(),"Reachable from door: "+p.name)
func capture_pair(label:String):
 await snap(label)
 var overlay=Node2D.new();g.add_child(overlay)
 overlay.draw.connect(func():
  for r in g.surface.obstacles():overlay.draw_rect(Rect2(r.position-g.camera,r.size),Color(1,.25,.15,.65),false,1.5))
 overlay.queue_redraw();await snap(label+"-collision");overlay.queue_free();await process_frame
func add_workshop(id:String,rooms:Array)->String:
 var b={"id":id,"plan":"workshop","name":"Test workshop","area":"claim","x":1300,"y":750,"extend_x":0,"extend_y":0,"rooms":rooms,"construction":{},"shell_paid":{}}
 g.surface.architecture.data().instances.append(b);g.surface.architecture.seed_room(b,0,true)
 return HoldBuildingPlans.room_id(id)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();HoldFirstVisit99.data(g.state).rewarded=true
 var communal=HoldFrontier103.room(g.state,"forge");g.surface.enter(communal);settle()
 var shared=HoldRoomLayout.floor_rect(communal)
 check(shared.size==Vector2(820,520),"New communal forge has its own compact plan")
 reachable(HoldForge147.points(g));at(Vector2(480,490));g.clock=2.0
 check(HoldLivingForges148.sound_context(g)=="forge_cold","Unrestored forge is quiet")
 await capture_pair("communal-cold")
 g.state.opening=2;g.sound.set_context(HoldLivingForges148.sound_context(g));g.clock=.85
 check(HoldLivingForges148.sound_context(g)=="forge","Restoration enables forge ambience")
 await capture_pair("communal-restored")
 var legacy=add_workshop("legacy148",["room:forge"])
 var old_contents=g.state.surface.decor.duplicate(true)
 var id="test148:stock";g.state.surface.chests[id]={"area":legacy,"x":1090,"y":650,"z":0,"items":{"iron":7}}
 g.surface.enter(legacy);settle()
 check(HoldRoomLayout.floor_rect(legacy).size==Vector2(1020,650),"Saved workshop keeps its grand dimensions")
 check(g.state.surface.decor==old_contents,"Entering an old room never relocates furniture")
 var b=g.surface.architecture.inside();b.erase("rooms")
 check(HoldBuildingPlans.template(legacy)=="room:forge","Legacy missing-room record keeps its old template")
 b.rooms=["room:forge"]
 var small=add_workshop("new148",HoldBuildingPlans.plan("workshop").rooms.duplicate())
 g.surface.enter(small);settle();at(Vector2(500,443))
 check(HoldRoomLayout.floor_rect(small).size==Vector2(640,385),"Player starts with a modest workshop")
 check(g.surface.architecture.can_forge(),"Starter hearth and anvil form a working forge")
 var stations=HoldLivingForges148.points(g)
 check(stations.size()==3,"Furnace, anvil and bench expose separate services")
 reachable(stations)
 for p in stations:
  at(p.p);HoldLivingForges148.use(g,p.action)
  check(g.panel_id=="forge" and g.forge_tab=={"living148:smelt":0,"living148:tools":2,"living148:craft":1}[p.action],"Station opens its existing production tab")
  g.close_panel()
 at(Vector2(480,590));HoldLivingForges148.use(g,"living148:smelt")
 check(g.panel_id=="","A remote hearth prompt cannot open production")
 at(Vector2(480,450));await capture_pair("player-starter")
 g.state.tech.automation=true
 check(HoldLivingForges148.points(g).any(func(p):return p.action=="living148:industry"),"Research exposes the real industry controls")
 await capture_pair("player-industry")
 HoldFrontier103.data(g.state).keldrath_open=true # Visit the established forge through its normal story gate.
 g.surface.enter("room:forge");settle();at(Vector2(650,600));g.clock=.85
 check(HoldRoomLayout.floor_rect("room:forge").size.x>shared.size.x,"Borin retains an established grand forge")
 reachable(HoldLivingForges148.points(g))
 var extra={"area":"room:forge","kind":"anvil","x":350,"y":650,"z":0};g.state.surface.decor.append(extra)
 check(HoldLivingForges148.furniture(g).filter(func(f):return f.kind=="anvil").size()==2,"Authored and placed anvils both remain physical furnishings")
 await capture_pair("keldrath")
 at(Vector2(600,420));await capture_pair("keldrath-hearth")
 g.save_game();g.start_game(true);settle();g.surface.enter(legacy);settle()
 check(g.state.surface.chests[id].items.iron==7 and g.state.surface.chests[id].x==1090,"Legacy storage survives actual save and reload")
 check(HoldRoomLayout.floor_rect(legacy).size==Vector2(1020,650),"Saved old dimensions survive reload")
 check(HoldBuildingPlans.template(small)=="room:workshop148","New template persists independently")
 print("LIVING_FORGES148: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
