class_name HoldRoomBlueprints
extends RefCounted
# Saved plans reuse Hearthcraft tiles, costs and transactions.
const PURPOSES=["Undesignated","Bedroom","Kitchen","Forge","Workshop","Storehouse","Great Hall","Corridor"]
var owner_ref:WeakRef
var a:
 get:return owner_ref.get_ref()
var selected=""
var purpose="Undesignated"
var floor_kind="stone_floor"
var message="Drag a rectangle. Adjacent rooms can share a boundary."
func _init(owner):owner_ref=weakref(owner)
func available()->bool:return a.s.area=="claim" and a.g.state.claim_id!="" and a.s.house.level()==0
func data()->Dictionary:
 var d=a.s.house.data()
 if not d.has("blueprints152"):d.blueprints152={"next":1,"rooms":[]}
 return d.blueprints152
func rooms()->Array:return data().rooms if available() else []
func chosen()->Dictionary:
 for r in rooms():
  if str(r.id)==selected:return r
 return {}
func bounds(r:Dictionary)->Rect2i:return Rect2i(int(r.x),int(r.y),int(r.w),int(r.h))
func edge(r:Dictionary,c:Vector2i)->bool:
 var b=bounds(r)
 return c.x==b.position.x or c.y==b.position.y or c.x==b.end.x-1 or c.y==b.end.y-1
func parts(r:Dictionary)->Array:
 var out=[];var h=a.s.house;var b=bounds(r)
 for kind in [r.floor,"door","wall","roof"]:
  for y in range(b.position.y,b.end.y):
   for x in range(b.position.x,b.end.x):
    var c=Vector2i(x,y);var door=h.key(c) in r.doors
    if kind=="door" and not door:continue
    if kind=="wall" and (not edge(r,c) or door):continue
    out.append({"cell":c,"kind":kind})
 return out
func fulfilled(p:Dictionary)->bool:
 var t=a.s.house.tile(p.cell)
 if p.kind.ends_with("floor"):return t.has("floor")
 if p.kind=="roof":return t.get("roof",false)
 if p.kind=="wall":return t.get("wall","") in ["wall","window","door"]
 return t.get("wall","")==p.kind
func remaining(r:Dictionary)->Array:return parts(r).filter(func(p):return not fulfilled(p))
func cost(r:Dictionary)->Dictionary:
 var total={}
 for p in remaining(r):HoldBuildingPlans.add_cost(total,a.s.house.COSTS[p.kind])
 return total
func validate(r:Dictionary,ignore:String="")->bool:
 if not available():message="Plan on your chartered surface holding at ground level.";return false
 var b=bounds(r);var h=a.s.house
 if b.size.x<3 or b.size.y<3 or b.size.x>20 or b.size.y>20:message="Choose between 3 and 20 tiles along each side.";return false
 for other in rooms():
  if str(other.id)==ignore:continue
  var overlap=b.intersection(bounds(other))
  for y in range(overlap.position.y,overlap.end.y):
   for x in range(overlap.position.x,overlap.end.x):
    if not edge(r,Vector2i(x,y)) or not edge(other,Vector2i(x,y)):message="Rooms may share walls, but their usable spaces cannot overlap.";return false
 var solids=a.s.base_obstacles()+a.obstacles("claim")
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   var c=Vector2i(x,y);var p=h.center(c)
   if not a.s.claim_ground(p) or p.y<320:message="Keep the entire plan on usable building ground.";return false
   for solid in solids:
    if solid.grow(18).intersects(Rect2(Vector2(c)*40,Vector2(40,40))):message="The plan overlaps an existing building.";return false
   if h.occupied(c) and not h.tile(c).has("floor"):message="Clear equipment, furniture or garden beds from the foundation.";return false
 var draft=h.tiles().duplicate(true)
 for p in parts(r):
  var k=h.key(p.cell);var t=draft.get(k,{})
  if p.kind in ["wall","door"] and t.get("wall","")!="door":t.wall=p.kind;draft[k]=t
 if not h.routes_open(draft):message="Leave a route to the holding and existing services.";return false
 if not planned_access(r,ignore,solids):message="Every planned room needs a connected doorway to the holding.";return false
 return true
func save_rectangle(start:Vector2i,finish:Vector2i)->bool:
 var old=chosen()
 if not old.is_empty() and old.get("started",false):message="Work has begun. Alter built structure in fine construction.";return false
 var low=Vector2i(mini(start.x,finish.x),mini(start.y,finish.y));var high=Vector2i(maxi(start.x,finish.x),maxi(start.y,finish.y))
 var r={"id":selected,"x":low.x,"y":low.y,"w":high.x-low.x+1,"h":high.y-low.y+1,"purpose":purpose,"floor":floor_kind,"doors":[a.s.house.key(Vector2i((low.x+high.x)/2,high.y))],"started":false}
 if not validate(r,selected):return false
 if old.is_empty():r.id=str(int(data().next));data().next=int(data().next)+1;data().rooms.append(r)
 else:
  for k in r:old[k]=r[k]
 selected=r.id;a.g.save_game();message="Plan saved. Materials are spent only when work is built.";return true
func doorway(c:Vector2i)->bool:
 var r=chosen()
 if r.is_empty() or not edge(r,c) or not bounds(r).has_point(c):message="Choose a boundary of the selected room.";return false
 var b=bounds(r)
 if c.x in [b.position.x,b.end.x-1] and c.y in [b.position.y,b.end.y-1]:message="Keep doorways away from corners.";return false
 var k=a.s.house.key(c)
 if a.s.house.tile(c).get("wall","") in ["wall","window"]:message="Recover the existing wall before adding a doorway.";return false
 for other in rooms():
  if bounds(other).has_point(c) and edge(other,c) and k not in other.doors:other.doors.append(k)
 a.g.save_game();message="Doorway saved on both sides of the partition.";return true
func work()->int:
 var r=chosen()
 if r.is_empty() or not validate(r,selected):return 0
 var count=0;var h=a.s.house
 for p in remaining(r):
  if count>=32:break
  if h.ready_to_build(p.cell,p.kind) and h.build(h.center(p.cell),p.kind,false):r.started=true;count+=1
 a.g.save_game()
 message="Built %d pieces within reach. Walk along the plan to continue." % count if count>0 else "No work in reach. Check supplies, approach the plan or clear an obstruction."
 if remaining(r).is_empty():r.complete=true;message="Room complete. Furnish it as you wish."
 a.g.save_game()
 return count
func forget():
 var r=chosen()
 if r.is_empty():return
 data().rooms.erase(r);selected="";a.g.save_game();message="Plan removed. Constructed pieces and furnishings remain."
func draw_guides():
 if not available():return
 for r in rooms():
  if r.get("complete",false):continue
  var rect=Rect2(bounds(r));rect.position*=40;rect.size*=40
  var color=Color("9bb9b0") if r.get("started",false) else Color("72b9c1")
  a.g.draw_rect(rect,color,false,2)
  for k in r.doors:
   var c=a.s.house.coords(k)
   a.g.draw_rect(Rect2(Vector2(c)*40+Vector2(5,5),Vector2(30,30)),Color("87ce94"),false,2)
func planned_access(candidate:Dictionary,ignore:String,solids:Array)->bool:
 var h=a.s.house;var all=rooms().filter(func(r):return str(r.id)!=ignore)+[candidate]
 var blocked={};var doors={}
 for k in h.tiles():
  if h.tiles()[k].get("wall","") in ["wall","window"]:blocked[k]=true
 for r in all:
  for p in parts(r):
   if p.kind=="wall":blocked[h.key(p.cell)]=true
   elif p.kind=="door":doors[h.key(p.cell)]=true
 for k in doors:blocked.erase(k)
 for solid in solids:
  for y in range(maxi(5,floori(solid.position.y/40)),mini(52,ceili(solid.end.y/40))):
   for x in range(maxi(2,floori(solid.position.x/40)),mini(88,ceili(solid.end.x/40))):
    if solid.grow(10).has_point(h.center(Vector2i(x,y))):blocked[h.key(Vector2i(x,y))]=true
 var todo=[Vector2i(7,19)];var seen={h.key(todo[0]):true};var index=0
 while index<todo.size():
  var c=todo[index];index+=1
  for direction in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var next=c+direction;var k=h.key(next)
   if seen.has(k) or blocked.has(k) or not a.s.claim_ground(h.center(next)):continue
   seen[k]=true;todo.append(next)
 for r in all:
  if not seen.has(h.key(bounds(r).position+Vector2i.ONE)):return false
 return true
