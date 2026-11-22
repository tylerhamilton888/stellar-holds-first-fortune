extends SceneTree

var Layout
var Plans
var Fixtures
var Rooms
var Town
var Forge

var g
var checks=0
var failures=[]
var grid=AStarGrid2D.new()
var solids=[]
var bounds=Rect2()
const STEP=10

func _initialize():call_deferred("run")

func check(condition,label):
 checks+=1
 if not condition:failures.append(label)

func clear_point(p:Vector2)->bool:
 if not bounds.has_point(p):return false
 for r in solids:
  if r.has_point(p):return false
 return true

func build_grid():
 var surface=g.surface
 bounds=Plans.geometry(surface.area).bounds
 solids=surface.obstacles().map(func(r):return r.grow(surface.FOOT_RADIUS))
 grid.region=Rect2i(Vector2i((bounds.position/STEP).floor()),Vector2i((bounds.size/STEP).ceil())+Vector2i(2,2))
 grid.cell_size=Vector2.ONE*STEP
 grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_NEVER
 grid.update()
 for y in range(grid.region.position.y,grid.region.end.y):
  for x in range(grid.region.position.x,grid.region.end.x):
   grid.set_point_solid(Vector2i(x,y),not clear_point(Vector2(x,y)*STEP))

func closest(p:Vector2)->Vector2i:
 var center=Vector2i((p/STEP).round())
 var best=Vector2i(-1,-1);var distance=INF
 for y in range(center.y-1,center.y+2):
  for x in range(center.x-1,center.x+2):
   var id=Vector2i(x,y)
   if not grid.is_in_boundsv(id) or grid.is_point_solid(id):continue
   var q=Vector2(id)*STEP
   if p.distance_to(q)>=distance:continue
   var clear=true
   for i in 7:
    if not clear_point(p.lerp(q,i/6.0)):clear=false;break
   if clear:best=id;distance=p.distance_to(q)
 return best

func reachable(a:Vector2,b:Vector2)->bool:
 var start=closest(a);var end=closest(b)
 return start.x!=-1 and end.x!=-1 and not grid.get_id_path(start,end).is_empty()

func test_homes():
 for ward in ["crownward","hearthward","forgeward"]:
  for i in 3:
   var home="room:folk_%s_%d_0"%[ward,i]
   var loft="room:folk_%s_%d_1"%[ward,i]
   g.surface.enter(loft);build_grid()
   var landing=Plans.stair_position(loft)+Vector2(0,30)
   for item in Rooms.floor_items(g.surface.world,loft):
    var p=Vector2(item.x,item.y)
    if item.kind in ["bed","double_bed"]:
     check(reachable(landing,Fixtures.bedside(p,1,item.kind)) or reachable(landing,Fixtures.bedside(p,-1,item.kind)),"Bedside "+loft)
    if item.kind=="desk":check(reachable(landing,Fixtures.desk_access(p)),"Writing desk "+loft)
   for chest in g.state.surface.chests.values():
    if chest.area==loft:check(reachable(landing,Vector2(chest.x,chest.y+22)),"Chest "+loft)
   check(reachable(landing,Vector2(540,470)),"Resident's return from stair "+loft)
   var steps=g.surface.world.routines.path(loft,Vector2(540,470),landing)
   check(steps.size()>1,"Scheduled journey "+loft)
   g.surface.enter(home);build_grid()
   check(reachable(Plans.geometry(home).exit,Plans.stair_position(home)+Vector2(0,30)),"Door to staircase "+home)
   check(Plans.geometry(home).floor.get_area()>Plans.geometry(loft).floor.get_area(),"Hearth floor larger than sleeping loft "+home)

func test_workrooms():
 var office=Town.room(g.state,"survey")
 var records=Town.room(g.state,"survey",1)
 g.surface.enter(office);build_grid()
 var landing=Plans.stair_position(office)+Vector2(0,30)
 check(reachable(Plans.geometry(office).exit,landing),"Survey entry to archive stair")
 g.player=landing;g.transition_left=0;g.close_panel();g.surface.use()
 for i in 32:
  if not g.surface.stair_trip.is_empty():g.surface.tick_stair(.05)
 check(g.surface.area==records and g.surface.walkable(g.player),"Arrive at records landing")
 build_grid()
 var desk=Town.archive_access(g)
 check(reachable(g.player,desk),"Walk to the charter desk")
 g.player=desk;g.surface.use()
 check(g.panel_id=="frontier_archive103","Read town register with E at desk")
 g.close_panel()
 g.surface.enter(Town.room(g.state,"forge"));build_grid()
 var exit=Plans.geometry(g.surface.area).exit
 for point in Forge.points(g):
  check(reachable(exit,point.p),"Forge entrance to "+point.name)
 var stock=Forge.props(g).filter(func(o):return o.get("forge_stock","")=="iron")
 check(stock.size()==1 and reachable(exit,stock[0].p+Vector2(0,22)),"Approach iron stock")
 var private_room={"id":"555501","plan":"folk_crownward_0","rooms":["room:folk_crownward_0_0","room:folk_crownward_0_1"],"extend_x":1,"extend_y":2}
 g.surface.architecture.data().instances.append(private_room)
 var area=Plans.room_id(str(private_room.id),1)
 check(Plans.geometry(area).floor.size==Layout.ORDINARY.size+Vector2(80,160),"Existing private floor and expansion")
 private_room.fitted_rooms=true
 check(Plans.geometry(area).floor.size==Layout.floor_rect(private_room.rooms[1],true).size+Vector2(80,160),"Expansion on new family plan")

func test_upgrade():
 var test_state={"surface":{"frontier103":{},"decor":[],"chests":{}}}
 var records=[]
 for i in 3:
  var id=str(7000+i)
  var b={"id":id,"plan":"frontier_office","public103":i!=1,"rooms":["room:research","room:research"]}
  records.append(b)
  for k in ["desk","desk","lamp","lamp","lamp","orrery","bookcase","bookcase","bookcase","bookcase","bookcase"]:
   test_state.surface.decor.append({"area":Plans.room_id(id,1),"kind":k,"x":400,"y":380,"fixed":true})
 var custom={"area":Plans.room_id("7002",1),"kind":"chair","x":215,"y":610,"fixed":false}
 test_state.surface.decor.append(custom)
 Layout.upgrade_public(test_state,records)
 check(records[0].rooms[1]==Layout.RECORDS,"Standard public survey upgrade")
 check(records[1].rooms[1]=="room:research" and not records[1].has("fitted_rooms"),"Existing private survey preserved")
 check(records[2].rooms[1]=="room:research" and test_state.surface.decor.has(custom),"Custom public contents preserved")
 var snapshot=JSON.stringify(test_state)
 Layout.upgrade_public(test_state,records)
 check(JSON.stringify(test_state)==snapshot,"Upgrade is idempotent")

func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host);g=host.get_child(0).get_child(0)
 Layout=load("res://settlement/room_proportions.gd")
 Plans=load("res://scripts/building_plans.gd")
 Fixtures=load("res://scripts/furnishings.gd")
 Rooms=load("res://settlement/rooms.gd")
 Town=load("res://scripts/frontier103.gd")
 Forge=load("res://scripts/forge147.gd")
 g.set_process(false);g.close_panel();g.transition_left=0
 Town.data(g.state).keldrath_open=true
 load("res://scripts/mountain104.gd").data(g.state).authenticated=true
 test_homes();test_workrooms();test_upgrade()
 print("ROOM PROPORTIONS ",checks," checks. Failures ",failures)
 quit(0 if failures.is_empty() else 1)
