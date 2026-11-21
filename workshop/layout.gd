extends RefCounted
# A cell stores a single anchor. Wide pieces also occupy the next cell along their long axis.
const SIZE=40
const DIR=[Vector2i.DOWN,Vector2i.RIGHT,Vector2i.UP,Vector2i.LEFT]
const COST={"forge":{"stone":6,"iron":2},"table":{"wood":3},"chair":{"wood":2},"anvil":{"iron":3,"wood":1},"flags":{"stone":1}}
const TITLE={"forge":"Forge","table":"Oak table","chair":"Chair","anvil":"Anvil","flags":"Flagstones"}
static func key(c:Vector2i)->String:return "%d,%d"%[c.x,c.y]
static func coord(p:Vector2)->Vector2i:return Vector2i((p/40.).floor())
static func center(c:Vector2i)->Vector2:return Vector2(c)*40.+Vector2(20,20)
static func cell(f:Dictionary)->Vector2i:return Vector2i(f.x,f.y)
static func record(kind:String,c:Vector2i,rotation:int)->Dictionary:return {"kind":kind,"x":c.x,"y":c.y,"turn":posmod(rotation,4)}
static func size_for(f:Dictionary)->Vector2i:
 if f.kind not in ["forge","table"]:return Vector2i.ONE
 return Vector2i(2,1) if int(f.turn)%2==0 else Vector2i(1,2)
static func rect(f:Dictionary)->Rect2i:return Rect2i(cell(f),size_for(f))
static func foot(f:Dictionary)->Rect2:
 var bounds=rect(f)
 var pad=Vector2(8,6) if f.kind in ["anvil","chair"] else Vector2(3,4)
 return Rect2(Vector2(bounds.position)*40.+pad,Vector2(bounds.size)*40.-pad*2)
static func anchor(f:Dictionary)->Vector2:return foot(f).get_center()
static func blank()->Dictionary:return {"pieces":{},"flags":{},"facing":{},"wear":{}}
static func on_cell(room:Dictionary,c:Vector2i)->Dictionary:
 for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.UP]:
  var obj=room.get("pieces",{}).get(key(c+d),{})
  if not obj.is_empty() and rect(obj).has_point(c):return obj
 return {}
static func side(f:Dictionary,d:Vector2i)->Array:
 var b=rect(f);var result=[]
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   var n=Vector2i(x,y)+d
   if not b.has_point(n):result.append(n)
 return result
static func neighbors(f:Dictionary,room:Dictionary,wall:Callable)->Dictionary:
 var face=DIR[int(f.turn)]
 var result={"back":[],"joints":[],"seat":false}
 if f.kind=="forge":
  for n in side(f,-face):
   if wall.call(n):result.back.append(n)
 if f.kind=="chair":
  var neighbor=on_cell(room,cell(f)+face)
  result.seat=neighbor.get("kind","")=="table" and int(neighbor.turn)%2==int(f.turn)%2
 if f.kind not in ["table","forge"]:return result
 for d in [Vector2i(-face.y,face.x),Vector2i(face.y,-face.x)]:
  for n in side(f,d):
   var other=on_cell(room,n)
   if other.is_empty() or other.kind!="table" or int(other.turn)!=int(f.turn):continue
   if f.kind=="table" and (n.x<cell(f).x or n.y<cell(f).y):continue
   result.joints.append(center(n)-Vector2(d)*20.)
 return result
