class_name HoldRoomBlueprints
extends RefCounted
# Saved plans reuse Hearthcraft tiles, costs and transactions.
const MAX_PLANS=64
const PURPOSES=["Undesignated","Bedroom","Kitchen","Forge","Workshop","Storehouse","Great Hall","Corridor"]
var owner_ref:WeakRef
var a:
 get:return owner_ref.get_ref()
var selected=""
var purpose="Undesignated"
var floor_kind="stone_floor"
var style_family=""
var zoom=1.0
var map_center=Vector2(1800,1100)
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
 var out=[];var h=a.s.house;var b=bounds(r);var doors={}
 for other in rooms():
  for k in other.doors:doors[k]=true
 for k in r.doors:doors[k]=true
 for kind in [r.floor,"door","wall","roof"]:
  for y in range(b.position.y,b.end.y):
   for x in range(b.position.x,b.end.x):
    var c=Vector2i(x,y);var door=doors.has(h.key(c)) and edge(r,c)
    if kind=="door" and not door:continue
    if kind=="wall" and (not edge(r,c) or door):continue
    out.append({"cell":c,"kind":floor_for(c,r) if kind.ends_with("floor") else kind})
 return out
func floor_for(c:Vector2i,r:Dictionary)->String:
 for other in rooms():
  if str(other.id)==str(r.id):break
  if bounds(other).has_point(c):return other.floor
 return r.floor
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
func total_cost()->Dictionary:
 var unique={};var total={}
 for r in rooms():
  for p in remaining(r):
   var slot="floor" if p.kind.ends_with("floor") else "roof" if p.kind=="roof" else "wall"
   var k=a.s.house.key(p.cell)+":"+slot
   if not unique.has(k) or p.kind=="door":unique[k]=p
 for p in unique.values():HoldBuildingPlans.add_cost(total,a.s.house.COSTS[p.kind])
 for r in rooms():HoldBuildingPlans.add_cost(total,HoldBlueprintFinishes.cost(self,r))
 return total
func progress(r:Dictionary)->Dictionary:
 var count=parts(r).size();var left=remaining(r).size()
 var state="Complete" if left==0 else "Under construction" if left<count else "Planned"
 if left==0 and not HoldBlueprintFinishes.cost(self,r).is_empty():state="Finishing"
 return {"state":state,"built":count-left,"total":count}
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
   if h.occupied(c) and (not h.tile(c).has("floor") or (edge(r,c) and h.tile(c).get("wall","")=="")):message="Move equipment, furniture or garden beds from the unfinished foundation or boundary.";return false
 var draft=h.tiles().duplicate(true)
 for p in parts(r):
  var k=h.key(p.cell);var t=draft.get(k,{})
  if p.kind in ["wall","door"] and t.get("wall","")!="door":t.wall=p.kind;draft[k]=t
 if not h.routes_open(draft):message="Leave a route to the holding and existing services.";return false
 if not planned_access(r,ignore,solids):message="Every planned room needs a connected doorway to the holding.";return false
 return true
func save_rectangle(start:Vector2i,finish:Vector2i)->bool:
 var old=chosen()
 if old.is_empty() and rooms().size()>=MAX_PLANS:message="This holding supports 64 saved room plans. Existing construction is always retained.";return false
 if not old.is_empty() and old.get("started",false):message="Work has begun. Alter built structure in fine construction.";return false
 var low=Vector2i(mini(start.x,finish.x),mini(start.y,finish.y));var high=Vector2i(maxi(start.x,finish.x),maxi(start.y,finish.y))
 var r={"id":selected,"x":low.x,"y":low.y,"w":high.x-low.x+1,"h":high.y-low.y+1,"purpose":purpose,"floor":floor_kind,"doors":[a.s.house.key(Vector2i((low.x+high.x)/2,high.y))],"started":false,"style_family":style_family}
 if not validate(r,selected):return false
 if old.is_empty():r.id=str(int(data().next));data().next=int(data().next)+1;data().rooms.append(r)
 else:
  for k in r:old[k]=r[k]
 selected=r.id;map_center=Vector2(bounds(r).get_center())*40;zoom=3;a.g.save_game();message="Plan saved. Materials are spent only when work is built.";return true
func doorway(c:Vector2i,remove:bool=false)->bool:
 var r=chosen()
 if r.is_empty() or not edge(r,c) or not bounds(r).has_point(c):message="Choose a boundary of the selected room.";return false
 var b=bounds(r)
 if c.x in [b.position.x,b.end.x-1] and c.y in [b.position.y,b.end.y-1]:message="Keep doorways away from corners.";return false
 var k=a.s.house.key(c)
 if a.s.house.tile(c).get("wall","") in ["wall","window"]:message="Recover the existing wall before adding a doorway.";return false
 if remove and a.s.house.tile(c).get("wall","")=="door":message="Recover the built doorway in fine construction first.";return false
 var saved=[]
 for other in rooms():
  if not bounds(other).has_point(c) or not edge(other,c):continue
  saved.append({"room":other,"doors":other.doors.duplicate()})
  if remove:other.doors.erase(k)
  elif k not in other.doors:other.doors.append(k)
 if not validate(r,selected):
  for entry in saved:entry.room.doors=entry.doors
  return false
 a.g.save_game();message="Doorways updated. Add the new doorway before removing an old one.";return true
func work()->int:
 var r=chosen()
 if r.is_empty() or not validate(r,selected):return 0
 var count=0;var h=a.s.house
 for p in remaining(r):
  if count>=32:break
  if h.ready_to_build(p.cell,p.kind) and h.build(h.center(p.cell),p.kind,false):r.started=true;count+=1
 if count<32:count+=HoldBlueprintFinishes.work(self,r,32-count)
 message="Completed %d building steps within reach. Walk along the plan to continue." % count if count>0 else "No work in reach. Check supplies, approach the plan or clear an obstruction."
 if remaining(r).is_empty() and HoldBlueprintFinishes.cost(self,r).is_empty():r.complete=true;message="Room complete. Furnish it as you wish."
 a.g.save_game()
 return count
func forget():
 var r=chosen()
 if r.is_empty():return
 data().rooms.erase(r);selected="";a.g.save_game();message="Plan removed. Constructed pieces and furnishings remain."
func invalidate(c:Vector2i,reconcile:bool=false):
 for r in rooms():
  if bounds(r).has_point(c):r.complete=reconcile and remaining(r).is_empty() and HoldBlueprintFinishes.cost(self,r).is_empty()
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
func select_room(id:String):
 selected=id
 var r=chosen()
 if r.is_empty():return
 purpose=r.purpose;floor_kind=r.floor;style_family=r.get("style_family","");map_center=Vector2(bounds(r).get_center())*40;zoom=3
func assessment(r:Dictionary)->String:
 var furniture=a.g.hearth.furniture();var counts={};var comfort=0;var heritage=0;var usable=0
 var aliases={"double_bed":"bed","worktable":"bench","stone_pillar":"rune","royal_pillar":"rune"}
 for f in furniture:
  if not bounds(r).has_point(a.s.house.cell(f.p)):continue
  var approaches=[f.p+Vector2(0,40),f.p+Vector2(40,0),f.p-Vector2(40,0),f.p-Vector2(0,40)]
  if f.kind in ["bed","double_bed"]:approaches=[HoldFurnishings.bedside(f.p,1,f.kind),HoldFurnishings.bedside(f.p,-1,f.kind)]
  if approaches.any(func(position):return a.s.walkable(position) and a.s.clear_interaction(position,f.p+Vector2(0,25))):usable+=1
  var kind=aliases.get(f.kind,f.kind)
  if counts.has(kind) or not LivingWorks.FURNITURE.has(kind):continue
  counts[kind]=true;var def=LivingWorks.FURNITURE[kind];comfort+=int(def.comfort);heritage+=int(def.heritage)
 return "Comfort %d · heritage %d · %d furnishings with a clear approach. Equipment works independently of designation." % [mini(5,comfort),mini(3,heritage),usable]
func configure(field:String,value:String,room_id:String)->bool:
 if not available() or selected!=room_id:return false
 var r=chosen()
 if field=="purpose":
  if value not in PURPOSES:return false
  purpose=value
  if r.is_empty():floor_kind="wood_floor" if value=="Bedroom" else "stone_floor"
 elif field=="floor":
  if value not in ["stone_floor","wood_floor"] or r.get("started",false):return false
  floor_kind=value
 elif field=="style_family":
  if value!="" and not HoldBlueprintFinishes.RESEARCH.has(value):return false
  style_family=value
 else:return false
 if not r.is_empty():r[field]=value;r.complete=false;a.g.save_game()
 return true
