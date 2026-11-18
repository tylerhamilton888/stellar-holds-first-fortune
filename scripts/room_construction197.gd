class_name HoldRoomConstruction197
extends RefCounted
# Presentation reads actual construction. Preview snapshots never become save data.
class Paint extends RefCounted:
 var target
 var tint=Color.WHITE
 func _init(canvas,color:Color):target=canvas;tint=color
 func draw_rect(r,color,filled=true,width=-1.0):target.draw_rect(r,color*tint,filled,width)
 func draw_line(a,b,color,width=-1.0):target.draw_line(a,b,color*tint,width)
 func draw_polyline(points,color,width=-1.0):target.draw_polyline(points,color*tint,width)
 func draw_texture_rect_region(texture,r,source,color=Color.WHITE):target.draw_texture_rect_region(texture,r,source,color*tint)
 func draw_polygon(points,colors,uv,texture):
  var tinted=PackedColorArray()
  for color in colors:tinted.append(color*tint)
  target.draw_polygon(points,tinted,uv,texture)
class RoomView extends RefCounted:
 var room={}
 func current():return room
class House extends RefCounted:
 var g
 var s
 var map={}
 var z=0
 var MAX_Z=0
 var view=RoomView.new()
 func tiles(_z=-1):return map
 func tile(c):return map.get(key(c),{})
 func key(c):return "%d,%d" % [c.x,c.y]
 func coords(k):var bits=k.split(",");return Vector2i(int(bits[0]),int(bits[1]))
 func center(c):return Vector2(c)*40+Vector2(20,20)
 func level():return z
 func data():return {"tiles":map,"levels":{str(z):map}}
 func material(index,r,color=Color.WHITE):
  var texture=HoldHearthcraft.MATERIALS;var size=Vector2(texture.get_width()/3.0,texture.get_height()/2.0)
  g.draw_texture_rect_region(texture,r,Rect2(Vector2(index%3,index/3)*size,size),color)
static func phase(p,r:Dictionary)->String:
 var left=p.remaining(r)
 if left.is_empty():return "Complete" if HoldBlueprintFinishes.cost(p,r).is_empty() else "Finishing"
 if left.size()==p.parts(r).size():return "Marked out"
 if left.any(func(part):return part.kind.ends_with("floor")):return "Foundation"
 if left.any(func(part):return part.kind in ["wall","door"]):return "Walls"
 return "Roof & finishing"
static func snapshot(p,r:Dictionary,finished:bool)->Dictionary:
 var map={};var h=p.a.s.house
 for part in p.parts(r):
  var k=h.key(part.cell)
  if not map.has(k):map[k]=p.tile(part.cell,int(r.get("z",0))).duplicate(true)
  if not finished:continue
  if part.kind.ends_with("floor"):map[k].floor=part.kind
  elif part.kind=="roof":map[k].roof=true
  elif map[k].get("wall","")!="window":map[k].wall=part.kind
  if r.get("style_family","")!="":map[k].style87=HoldArchitectureStyles.preset(r.style_family)
 return map
static func draw_room(canvas,p,r:Dictionary,finished:bool=false,roof:bool=true,valid:bool=true):
 var h=House.new();h.s=p.a.s;h.z=int(r.get("z",0));h.MAX_Z=h.z;h.map=snapshot(p,r,finished)
 h.g=Paint.new(canvas,Color(1.05,1.65,1.05,.64) if finished and valid else Color(1,.35,.3,.65) if finished else Color.WHITE)
 var bounds=Rect2(Vector2(r.x,r.y)*40,Vector2(r.w,r.h)*40)
 var cells={}
 for k in h.map:cells[k]=true
 if roof:
  HoldHouseArt189.exterior(h,{"bounds":bounds,"cells":cells},func():
   if not finished:site(canvas,p,r,true))
 else:
  var body={}
  for k in h.map:
   if h.map[k].get("wall","")=="":body[k]=true
  h.view.room={"bounds":bounds,"body":body}
  for k in h.map:
   if h.map[k].has("floor"):HoldArchitectureStyles.floor_draw(h.g,Rect2(Vector2(h.coords(k))*40,Vector2(40,40)),HoldBlueprintFinishes.style(h,h.coords(k)).floor)
  var keys=h.map.keys();keys.sort_custom(func(a,b):return h.coords(a).y<h.coords(b).y)
  for k in keys:
   if h.map[k].get("wall","")!="":HoldHouseArt189.wall(h,h.coords(k),true)
 if not finished and not roof:site(canvas,p,r,false)
static func site(canvas,p,r:Dictionary,projected:bool=false):
 var stage=phase(p,r)
 if stage=="Complete":return
 var bounds=Rect2(Vector2(r.x,r.y)*40,Vector2(r.w,r.h)*40)
 var floor_box=bounds
 if projected:floor_box=Rect2(Vector2(bounds.position.x,bounds.end.y-bounds.size.y*.6),Vector2(bounds.size.x,bounds.size.y*.6))
 if stage=="Marked out":
  canvas.draw_rect(floor_box,Color(.28,.23,.14,.24))
  canvas.draw_rect(floor_box.grow(-5),Color("b6a27b"),false,2)
  for point in [floor_box.position,Vector2(floor_box.end.x,floor_box.position.y),floor_box.end,Vector2(floor_box.position.x,floor_box.end.y)]:
   HoldArchitectureStyles.post(canvas,point,20,"oak")
  return
 if stage=="Foundation":return
 # Temporary supports stand outside the footprint; they have no collision or cost.
 for x in [bounds.position.x-12,bounds.end.x+12]:
  var bottom=Vector2(x,floor_box.end.y-20);var top=Vector2(x,floor_box.position.y+20)
  for point in [top,bottom]:HoldArchitectureStyles.post(canvas,point,94,"oak")
  for height in [32,70]:canvas.draw_line(top-Vector2(0,height),bottom-Vector2(0,height),Color("9e8152"),5)
  canvas.draw_line(top-Vector2(0,15),bottom-Vector2(0,87),Color("766343"),4)
 if stage in ["Roof & finishing","Finishing"] and projected:
  var mid=bounds.get_center().x
  for y in range(int(bounds.position.y),int(bounds.end.y)+1,80):
   var a=HoldHouseArt189.slope(Vector2(bounds.position.x,y),bounds,88)
   var b=HoldHouseArt189.slope(Vector2(mid,y),bounds,88)
   var c=HoldHouseArt189.slope(Vector2(bounds.end.x,y),bounds,88)
   canvas.draw_polyline(PackedVector2Array([a,b,c]),Color("ad8b55"),5)
