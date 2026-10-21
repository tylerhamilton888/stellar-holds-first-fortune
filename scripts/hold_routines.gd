class_name HoldRoutines
extends RefCounted
# Compiled journeys, sampled from the saved world clock. There is no simulation
# or pathfinding tick for an off-screen resident, and no random change on reload.
const SPEED=62.0
const CELL=20.0
var world_ref:WeakRef
var w:
 get:return world_ref.get_ref()
var seed_value=-1
var plans=[]
var grids={}
var path_cache={}
var build_ms=0
var compiled_paths=0
func _init(world):world_ref=weakref(world)
func grid(area:String)->AStarGrid2D:
 if grids.has(area):return grids[area]
 var bounds=HoldNeighborhood.BOUNDS if HoldWorldZones.ward(area) else HoldRoomLayout.bounds(area)
 var nav=AStarGrid2D.new()
 nav.region=Rect2i(Vector2i((bounds.position/CELL).ceil()),Vector2i((bounds.size/CELL).floor()))
 nav.cell_size=Vector2.ONE*CELL;nav.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES;nav.update()
 for y in range(nav.region.position.y,nav.region.end.y):
  for x in range(nav.region.position.x,nav.region.end.x):
   var id=Vector2i(x,y)
   nav.set_point_solid(id,not w.navigation_clear(area,Vector2(id)*CELL))
 grids[area]=nav;return nav
func path(area:String,a:Vector2,b:Vector2)->Array:
 if a==b:return [a]
 var key=area+str(a)+str(b)
 if path_cache.has(key):return path_cache[key]
 var nav=grid(area);var first=nearest_id(nav,area,a);var last=nearest_id(nav,area,b)
 var points:Array=[a]
 var raw=nav.get_point_path(first,last)
 if raw.is_empty():push_error("No resident route: "+key);return []
 for p in raw:
  if points.back().distance_to(p)>.1:points.append(p)
 if points.back().distance_to(b)>.1:points.append(b)
 # Collapse straight grid runs once. Retain each corner's safe clearance.
 var simple:Array=[points[0]]
 for i in range(1,points.size()-1):
  if (points[i]-points[i-1]).normalized().dot((points[i+1]-points[i]).normalized())<.999:simple.append(points[i])
 simple.append(points.back());path_cache[key]=simple;return simple
func nearest_id(nav:AStarGrid2D,area:String,p:Vector2)->Vector2i:
 var center=Vector2i((p/CELL).round());var best=center;var distance=INF
 for y in range(center.y-2,center.y+3):
  for x in range(center.x-2,center.x+3):
   var cell=Vector2i(x,y)
   if not nav.is_in_boundsv(cell) or nav.is_point_solid(cell):continue
   var point=Vector2(cell)*CELL;var clear=true
   for j in range(9):
    if not w.navigation_clear(area,p.lerp(point,j/8.0)):clear=false;break
   if clear and p.distance_to(point)<distance:best=cell;distance=p.distance_to(point)
 return best
func walk(plan:Dictionary,area:String,points:Array,activity:String):
 for i in range(points.size()-1):
  var distance=points[i].distance_to(points[i+1])
  if distance<.01:continue
  plan.steps.append({"area":area,"a":points[i],"b":points[i+1],"start":plan.duration,"duration":distance/SPEED,"distance":plan.distance,"activity":activity})
  plan.duration+=distance/SPEED;plan.distance+=distance
func go(plan:Dictionary,area:String,a:Vector2,b:Vector2,activity:String):walk(plan,area,path(area,a,b),activity)
func wait_at(plan:Dictionary,area:String,p:Vector2,seconds:float,activity:String,pose:String="",aim:Vector2=Vector2.DOWN):
 plan.steps.append({"area":area,"a":p,"b":p,"start":plan.duration,"duration":seconds,"distance":plan.distance,"activity":activity,"pose":pose,"aim":aim})
 plan.duration+=seconds
func household_stair(plan:Dictionary,from:String,to:String,activity:String):
 walk(plan,from,[Vector2(700,580),Vector2(700,496)],activity)
 walk(plan,to,[Vector2(700,496),Vector2(700,580)],activity)
func between(plan:Dictionary,from:String,to:String,a:Vector2,b:Vector2,activity:String):
 var area=from;var point=a
 while area!=to:
  var index=HoldWorldZones.WARDS.find(area);var down=index<HoldWorldZones.WARDS.find(to)
  var link=HoldTerraces.LINKS[index if down else index-1]
  var start=HoldTerraces.local_start(link,area)
  go(plan,area,point,start,activity)
  if down:
   walk(plan,area,[start,Vector2(link.x,HoldTerraces.STRIDE)],activity)
   area=link.lower;point=Vector2(link.x,HoldTerraces.TOP)
   walk(plan,area,[Vector2(link.x,0),point],activity)
  else:
   walk(plan,area,[start,Vector2(link.x,0)],activity)
   area=link.upper;point=Vector2(link.x,HoldTerraces.BOTTOM)
   walk(plan,area,[Vector2(link.x,HoldTerraces.STRIDE),point],activity)
 go(plan,area,point,b,activity)
func ensure():
 if seed_value==w.g.state.seed_value:return
 var began=Time.get_ticks_msec();seed_value=w.g.state.seed_value;plans.clear();grids.clear();path_cache.clear()
 for ward in HoldWorldZones.WARDS:
  for index in 3:
   var floor_index=HoldWorldZones.WARDS.find(ward)
   var person=HoldNeighborhood.resident(w,index,Vector2.ZERO,false,Vector2.DOWN,0,ward)
   var home=HoldNeighborhood.home_id(ward,index);var upstairs=HoldNeighborhood.home_id(ward,index,1)
   var door=HoldNeighborhood.home_door(index)
   var job=["forge","tavern","market"][index];var workward="forgeward" if index==0 else "hearthward"
   var workdoor=HoldWorldZones.door([15,8,9][index]);var workroom="room:"+job
   var workpoint=([Vector2(905,530),Vector2(905,735),Vector2(615,735)][floor_index] if index==0 else Vector2(365+floor_index*130,590) if index==1 else Vector2(350+floor_index*130,500))
   var plan={"person":person,"ward":ward,"index":index,"steps":[],"duration":0.0,"distance":0.0,"offset":floor_index*83+index*37}
   wait_at(plan,upstairs,Vector2(540,470),30+index*6,"At home")
   go(plan,upstairs,Vector2(540,470),Vector2(700,580),"Leaving for "+job)
   # The door and household stair are explicit portals, never random locations.
   household_stair(plan,upstairs,home,"Taking the household stair")
   go(plan,home,Vector2(700,580),HoldRoomLayout.exit_point(home),"Leaving for "+job)
   between(plan,ward,workward,door,workdoor,"Going to the "+job)
   go(plan,workroom,HoldRoomLayout.exit_point(workroom),workpoint,"Starting the shift")
   wait_at(plan,workroom,workpoint,130+floor_index*20,"On shift · "+job,"hammer" if index==0 else "",Vector2.RIGHT if index==0 else Vector2.DOWN)
   go(plan,workroom,workpoint,HoldRoomLayout.exit_point(workroom),"Off to the Copper Kettle")
   between(plan,workward,"hearthward",workdoor,HoldWorldZones.door(8),"Off to the Copper Kettle")
   var tea=Vector2(290+floor_index*120+index*20,590)
   go(plan,"room:tavern",HoldRoomLayout.exit_point("room:tavern"),tea,"Finding a warm corner")
   wait_at(plan,"room:tavern",tea,45,"At the Copper Kettle","drink")
   go(plan,"room:tavern",tea,HoldRoomLayout.exit_point("room:tavern"),"Heading home")
   between(plan,"hearthward",ward,HoldWorldZones.door(8),door,"Heading home")
   go(plan,home,HoldRoomLayout.exit_point(home),Vector2(450,560),"Home by the hearth")
   wait_at(plan,home,Vector2(450,560),75,"Home by the hearth")
   go(plan,home,Vector2(450,560),Vector2(700,580),"Turning in")
   household_stair(plan,home,upstairs,"Taking the household stair")
   go(plan,upstairs,Vector2(700,580),Vector2(540,470),"Turning in")
   plans.append(plan)
 build_ms=Time.get_ticks_msec()-began;compiled_paths=path_cache.size()
 # Only the small compiled itineraries survive. Navigation grids are build-time
 # data; faraway homes need neither navigation objects nor running scenes.
 grids.clear();path_cache.clear()
func sample(plan:Dictionary,time:float)->Dictionary:
 var phase=fposmod(time+plan.offset,plan.duration)
 # Binary search the compiled spans. Cost is independent of world size/depth.
 var low=0;var high=plan.steps.size()-1
 while low<high:
  var mid=(low+high+1)/2
  if plan.steps[mid].start<=phase:low=mid
  else:high=mid-1
 var step=plan.steps[low];var blend=clampf((phase-step.start)/step.duration,0,1)
 var c=plan.person.duplicate();c.p=step.a.lerp(step.b,blend);c.area=step.area;c.walking=step.a!=step.b
 c.aim=(step.b-step.a).normalized() if c.walking else step.get("aim",Vector2.DOWN)
 c.gait=HoldDrawnLocomotion.time_for_distance(step.distance+step.a.distance_to(c.p));c.time=time;c.role=step.activity
 c.pose=step.get("pose","") if not c.walking else "town_walk"
 c.phase=fposmod(time+plan.offset,.8)/.8 if c.pose=="hammer" else float([0,1,2,1][posmod(int(time*2),4)])
 c.interaction="resident:"+plan.ward+":"+str(plan.index)
 return c
func people(area:String,time:float)->Array:
 if not HoldWorldZones.ward(area) and not area.begins_with("room:"):return []
 ensure();var result=[]
 for plan in plans:
  var c=sample(plan,time)
  if c.area==area:result.append(c)
 return result
func all_profiles()->Array:
 ensure();var result=[]
 for plan in plans:result.append(plan.person.profile)
 return result
func speak(id:String):
 ensure()
 for plan in plans:
  var c=sample(plan,w.g.state.elapsed)
  if c.interaction!=id:continue
  w.speech=c.name+" · "+c.role+". "+("I take the Great Stair to my shift. You can walk with me." if c.walking else "You'll find our family hearth across the gallery bridge. A warm corner after honest work.")
  w.speech_until=w.g.clock+8;w.g.notify(c.name+" · "+c.role);return
