class_name HoldHouseView189
extends RefCounted
# Presentation over the existing claim tiles, never a second house/inventory.
const DIRS=[Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]
var owner:WeakRef
var h:
 get:return owner.get_ref()
var g:
 get:return h.g
var signature=0
var cached:Array=[]
var cooldown=0.0
func _init(house):owner=weakref(house)
func groups()->Array:
 if h.s.area!="claim":return []
 var map=h.tiles();var stamp=hash([map,h.level()])
 if stamp==signature:return cached
 signature=stamp;cached=[]
 var seen={};var rooms=[];var membership={}
 # First find enclosed floor regions with all doors treated as boundaries.
 # Outdoor paving must not turn a front door into an internal partition.
 for start in map:
  if seen.has(start) or not map[start].has("floor") or map[start].get("wall","")!="":continue
  var todo=[start];var head=0;var body={};var rim={};var enclosed=true
  seen[start]=true
  while head<todo.size():
   var k=todo[head];head+=1;body[k]=true
   for d in DIRS:
    var next=h.key(h.coords(k)+d);var t=map.get(next,{})
    if t.get("wall","")!="":rim[next]=true;continue
    if not t.has("floor"):enclosed=false;continue
    if not seen.has(next):seen[next]=true;todo.append(next)
  if not enclosed or body.size()<2:continue
  var id=rooms.size();rooms.append({"body":body,"rim":rim})
  for k in body:membership[k]=id
 var joined={}
 for first in rooms.size():
  if joined.has(first):continue
  var queue=[first];var head=0;var body={};var cells={};var doors={}
  joined[first]=true
  while head<queue.size():
   var id=queue[head];head+=1
   body.merge(rooms[id].body);cells.merge(rooms[id].body);cells.merge(rooms[id].rim)
   for k in rooms[id].rim:
    if map[k].get("wall","")!="door":continue
    doors[k]=true
    for d in DIRS:
     var n=h.key(h.coords(k)+d)
     if membership.has(n) and not joined.has(membership[n]):joined[membership[n]]=true;queue.append(membership[n])
  var portals={}
  for k in doors:
   var c=h.coords(k);var internal=false
   for d in [Vector2i.RIGHT,Vector2i.DOWN]:
    if body.has(h.key(c+d)) and body.has(h.key(c-d)):internal=true
   if internal:body[k]=true;continue
   for d in DIRS:
    if body.has(h.key(c-d)) and not cells.has(h.key(c+d)) and map.get(h.key(c+d),{}).get("wall","")=="":portals[k]=d;break
  # Include masonry corner cells, which do not touch the room floor by an edge.
  var corners={}
  for k in cells:
   for d in DIRS:
    var c=h.coords(k)+d;var candidate=h.key(c)
    if cells.has(candidate) or map.get(candidate,{}).get("wall","")=="":continue
    var adjacent=0
    for side in DIRS:
     if cells.has(h.key(c+side)):adjacent+=1
    if adjacent>=2:corners[candidate]=true
  cells.merge(corners)
  var bounds=Rect2()
  for k in cells:
   var r=Rect2(Vector2(h.coords(k))*40,Vector2(40,40));bounds=r if not bounds.has_area() else bounds.merge(r)
  cached.append({"body":body,"cells":cells,"portals":portals,"bounds":bounds})
 return cached
func at(p:Vector2)->Dictionary:
 var k=h.key(h.cell(p))
 for group in groups():
  if group.body.has(k):return group
 return {}
func current()->Dictionary:return at(g.player)
func inside()->bool:return not current().is_empty()
func portal(k:String)->Dictionary:
 for group in groups():
  if group.portals.has(k):return group
 return {}
func boundary_obstacles()->Array:
 var result=[]
 for group in groups():
  for k in group.portals:result.append(Rect2(Vector2(h.coords(k))*40,Vector2(40,40)))
 return result
func use(k:String)->bool:
 var group=portal(k)
 if group.is_empty():return false
 if cooldown>0 or g.transition_left>0 or g.panel_id!="":return true
 if g.player.distance_to(h.center(h.coords(k)))>80:return true
 if not g.handworks.attached().is_empty():g.notify("Park the cart before entering the house.");return true
 var leaving=group.body.has(h.key(h.cell(g.player)))
 var d:Vector2i=group.portals[k]
 var target=h.center(h.coords(k)+(d if leaving else -d))
 if not h.s.walkable(target):g.notify("Clear the doorway landing before passing through.");return true
 g.player=target;g.velocity=Vector2.ZERO;g.walking_pose=false;h.s.cancel_placement()
 cooldown=.6;g.camera=h.s.camera_target();g.sound.effect("door",-16)
 g.begin_transition("YOUR HOUSEHOLD GROUNDS" if leaving else "UNDER YOUR OWN ROOF")
 h.s.remember();g.save_game();return true
func visible(p:Vector2)->bool:
 if h.s.area!="claim":return true
 var room=current()
 if not room.is_empty():return room.cells.has(h.key(h.cell(p)))
 return at(p).is_empty()
func visible_cell(c:Vector2i)->bool:
 var room=current();return room.is_empty() or room.cells.has(h.key(c))
func wall_visible(c:Vector2i)->bool:
 if h.s.area!="claim":return true
 var room=current()
 if not room.is_empty():return room.cells.has(h.key(c))
 for group in groups():
  if group.cells.has(h.key(c)):return false
 return true
func camera()->Vector2:
 var b:Rect2=current().bounds;var focus=b.get_center()
 if b.size.x>800:focus.x=clampf(g.player.x,b.position.x+400,b.end.x-400)
 if b.size.y>300:focus.y=clampf(g.player.y,b.position.y+150,b.end.y-150)
 return focus-Vector2(480,300)
func exterior_objects()->Array:
 if h.s.area!="claim" or inside():return []
 var result=[]
 for group in groups():
  var item={"kind":"house_exterior189","p":group.bounds.end,"group":group}
  if HoldTimberWing.SIDES.has(HoldTimberWing.side(g)) and HoldTimberWing.matches_shell(g,group):
   item.sort_y=HoldTimberWing.THRESHOLD.y-52
  result.append(item)
 return result
func outdoor_focus(p:Vector2)->Vector2:
 for group in groups():
  for k in group.portals:
   var distance=p.distance_to(h.center(h.coords(k)))
   if distance<180:
    var weight=clampf((180-distance)/140.0,0,1)
    var focus:Vector2=group.bounds.get_center()-Vector2(0,40)
    focus.y=maxf(focus.y,p.y-112)
    return p.lerp(focus,weight)
 return p
