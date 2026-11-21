extends SceneTree
var failures=[]
var checks=0
func check(ok:bool,label:String):
 checks+=1
 if not ok:failures.append(label)
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host)
 var g=host.get_child(0).get_child(0);g.set_process(false)
 var layout=load("res://settlement/wall_storage.gd")
 var plans=load("res://scripts/building_plans.gd")
 var furniture=load("res://scripts/furnishings.gd")
 var town=load("res://scripts/frontier103.gd")
 var areas={}
 for plan in plans.catalogue().values():
  for area in plan.rooms:areas[area]=true
 for area in areas:
  var items=plans.contents(g.surface.world,area)
  var wall_y=plans.geometry(area).floor.position.y+20
  for item in items:
   if not layout.shelving(item.furnishing):continue
   var back=furniture.footprint(item.furnishing,item.p)
   check(absf(back.position.y-wall_y)<.5,"Wall contact in "+area)
   var clear=true
   for other in items:
    if is_same(item,other):continue
    if back.grow(1).intersects(furniture.footprint(other.furnishing,other.p)):clear=false
   check(clear,"Unobstructed shelf footprint in "+area)
 var area=town.room(g.state,"survey")
 var fixed={"area":area,"kind":"bookcase","x":300,"y":555,"z":0,"fixed":true}
 var hand_placed={"area":area,"kind":"bookcase","x":548,"y":422,"z":0}
 var private_piece={"area":plans.room_id("custom"),"kind":"pantry","x":410,"y":490,"z":0}
 var upper_piece={"area":area,"kind":"bookcase","x":300,"y":555,"z":1,"fixed":true}
 var records=g.state.surface.decor
 records.append_array([fixed,hand_placed,private_piece,upper_piece])
 var instances=g.surface.architecture.data().instances
 town.data(g.state).erase("shelf_layout");layout.upgrade_public(g.state,instances)
 check(fixed.y==294,"Old fixed civic bookcase moves to the wall")
 check(hand_placed.x==548 and hand_placed.y==422,"Player furniture keeps its chosen position")
 check(private_piece.x==410 and private_piece.y==490,"Private plans keep their saved layout")
 check(upper_piece.y==555,"Other construction levels keep their own furniture")
 var previous=records.duplicate(true);layout.upgrade_public(g.state,instances)
 check(previous==records,"Second upgrade preserves all saved records")
 print("WALL STORAGE ",checks," checks. Failures ",failures);quit(0 if failures.is_empty() else 1)
