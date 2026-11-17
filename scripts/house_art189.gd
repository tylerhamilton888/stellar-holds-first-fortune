class_name HoldHouseArt189
extends RefCounted
# Assemble the shared architectural materials over the player's real footprint.
static func patch(g,r:Rect2,source:Rect2,unit:Vector2,tint:Color=Color.WHITE):
 for y in range(floori(r.position.y/unit.y),ceili(r.end.y/unit.y)):
  for x in range(floori(r.position.x/unit.x),ceili(r.end.x/unit.x)):
   var whole=Rect2(Vector2(x,y)*unit,unit);var part=whole.intersection(r)
   g.draw_texture_rect_region(HoldArchitectureStyles.ATLAS,part,Rect2(source.position+(part.position-whole.position)/unit*source.size,part.size/unit*source.size),tint)
static func wall(h,c:Vector2i,interior:bool=false,z:int=-1,bounds:Rect2=Rect2()):
 var map=h.tiles(z);var t=map[h.key(c)];var rise=maxi(0,z-h.level())*64
 var p=h.center(c)+Vector2(0,20-rise)
 if bounds.has_area():p.y=bounds.end.y-(bounds.end.y-(p.y+rise))*.6-rise
 var style=HoldBlueprintFinishes.style(h,c,z)
 var room=h.view.current() if interior else {}
 var south=interior and (room.body.has(h.key(c+Vector2i.UP)) or c.y==floori(room.bounds.end.y/40)-1)
 var side=interior and not south and not room.body.has(h.key(c+Vector2i.DOWN)) and c.y>floori(room.bounds.position.y/40)
 var height=24.0 if south else 44.0 if side else 88.0
 var r=Rect2(p-Vector2(20,height),Vector2(40,height));var g=h.g
 patch(g,r,HoldArchitectureStyles.WALLS[HoldArchitectureStyles.index(style.wall)],Vector2(112,110))
 g.draw_rect(Rect2(r.position,Vector2(40,6)),Color("9a927a"))
 g.draw_rect(Rect2(p-Vector2(20,8),Vector2(40,8)),Color("344143"))
 if t.wall=="window" and not south:
  g.draw_texture_rect_region(HoldArchitectureStyles.ATLAS,Rect2(p-Vector2(20,minf(75,height-4)),Vector2(40,minf(55,height-8))),HoldArchitectureStyles.WINDOWS[HoldArchitectureStyles.index(style.wall)])
 elif t.wall=="door":
  var door=Rect2(p-Vector2(16,height-7),Vector2(32,height-7))
  g.draw_rect(door,Color("242c2b"))
  if not interior or not t.get("open",false):
   h.material(5,door.grow(-2))
   for y in [height*.3,height*.75]:g.draw_line(p+Vector2(-13,-y),p+Vector2(13,-y),Color("303839"),3)
  g.draw_line(door.position,door.position+Vector2(door.size.x,0),Color("c2ae81"),5)
 var horizontal=map.get(h.key(c+Vector2i.LEFT),{}).get("wall","")!="" or map.get(h.key(c+Vector2i.RIGHT),{}).get("wall","")!=""
 var vertical=map.get(h.key(c+Vector2i.UP),{}).get("wall","")!="" or map.get(h.key(c+Vector2i.DOWN),{}).get("wall","")!=""
 if t.wall=="door":
  for x in [-18,18]:HoldArchitectureStyles.post(g,p+Vector2(x,0),height,style.trim)
 elif horizontal and vertical:HoldArchitectureStyles.post(g,p,height,style.trim)
static func slope(p:Vector2,b:Rect2,offset:float)->Vector2:
 var pitch=0.0 if not b.has_area() else maxf(0,1-absf(p.x-b.get_center().x)/(b.size.x*.5))*48
 if b.has_area():p.y=b.end.y-(b.end.y-p.y)*.6
 return p-Vector2(0,offset+pitch)
static func roof(h,c:Vector2i,cells:Dictionary,offset:float=88.0,z:int=-1,bounds:Rect2=Rect2()):
 var g=h.g;var style=HoldBlueprintFinishes.style(h,c,z);var p=Vector2(c)*40
 var r=Rect2(p,Vector2(40,40));var source=HoldArchitectureStyles.ROOFS[HoldArchitectureStyles.index(style.roof,"roof")]
 var unit=Vector2(136,120);var mid=bounds.get_center().x
 # Split at the ridge as well as texture repeats: each roof slope remains planar.
 var parts=[r]
 if bounds.has_area() and r.position.x<mid and r.end.x>mid:parts=[Rect2(r.position,Vector2(mid-r.position.x,40)),Rect2(Vector2(mid,p.y),Vector2(r.end.x-mid,40))]
 for part in parts:
  for y in range(floori(part.position.y/unit.y),ceili(part.end.y/unit.y)):
   for x in range(floori(part.position.x/unit.x),ceili(part.end.x/unit.x)):
    var whole=Rect2(Vector2(x,y)*unit,unit);var piece=whole.intersection(part)
    var vertices=PackedVector2Array();var uv=PackedVector2Array()
    for point in [piece.position,Vector2(piece.end.x,piece.position.y),piece.end,Vector2(piece.position.x,piece.end.y)]:
     vertices.append(slope(point,bounds,offset));uv.append((source.position+(point-whole.position)/unit*source.size)/HoldArchitectureStyles.ATLAS.get_size())
    var tint=Color.WHITE if not bounds.has_area() or piece.get_center().x<mid else Color("b8c6c7")
    g.draw_polygon(vertices,PackedColorArray([tint]),uv,HoldArchitectureStyles.ATLAS)
 for d in HoldHouseView189.DIRS:
  var k=h.key(c+d)
  if cells.has(k) and h.tiles(z).get(k,{}).get("roof",false):continue
  var a=p;var b=p
  if d==Vector2i.UP:b+=Vector2(40,0)
  elif d==Vector2i.DOWN:a+=Vector2(0,40);b+=Vector2(40,40)
  elif d==Vector2i.LEFT:b+=Vector2(0,40)
  else:a+=Vector2(40,0);b+=Vector2(40,40)
  var ridge=[a,b]
  if d in [Vector2i.UP,Vector2i.DOWN] and bounds.has_area() and a.x<mid and b.x>mid:ridge=[a,Vector2(mid,a.y),b]
  var line=PackedVector2Array()
  for point in ridge:line.append(slope(point,bounds,offset))
  if d==Vector2i.DOWN and bounds.has_area():
   var base=bounds.end.y-(bounds.end.y-a.y)*.6-offset
   var cuts=[a.x,b.x]
   if a.x<mid and b.x>mid:cuts.append(mid)
   for x in range(floori(a.x/112)+1,ceili(b.x/112)):cuts.append(x*112.0)
   cuts.sort()
   var stone=HoldArchitectureStyles.WALLS[HoldArchitectureStyles.index(style.wall)]
   for i in cuts.size()-1:
    var left=cuts[i];var right=cuts[i+1];var origin=floorf(left/112)*112
    var face=PackedVector2Array([slope(Vector2(left,a.y),bounds,offset),slope(Vector2(right,a.y),bounds,offset),Vector2(right,base),Vector2(left,base)])
    var uv=PackedVector2Array()
    for point in face:uv.append((stone.position+Vector2((point.x-origin)/112,(point.y-base+88)/110)*stone.size)/HoldArchitectureStyles.ATLAS.get_size())
    g.draw_polygon(face,PackedColorArray([Color("d5c6a8")]),uv,HoldArchitectureStyles.ATLAS)
   if a.x<=mid and b.x>mid:g.draw_line(Vector2(mid,bounds.end.y-(bounds.end.y-a.y)*.6-offset),slope(Vector2(mid,a.y),bounds,offset),Color("574632"),7)
  g.draw_polyline(line,Color("273437"),7)
  g.draw_polyline(line,Color("ac9877"),3)
static func exterior(h,group:Dictionary):
 var g=h.g;var bounds:Rect2=group.bounds
 g.draw_rect(Rect2(bounds.position+Vector2(12,0),bounds.size+Vector2(8,10)),Color(0,0,0,.24))
 for k in group.cells:
  var c=h.coords(k);var p=Vector2(c)*40
  p.y=bounds.end.y-(bounds.end.y-p.y)*.6
  HoldArchitectureStyles.floor_draw(g,Rect2(p,Vector2(40,24)),HoldBlueprintFinishes.style(h,c).floor)
 var keys=group.cells.keys();keys.sort_custom(func(a,b):return h.coords(a).y<h.coords(b).y)
 for k in keys:
  if h.tiles()[k].get("wall","")!="":wall(h,h.coords(k),false,-1,bounds)
 for k in keys:
  if h.tiles()[k].get("roof",false):roof(h,h.coords(k),group.cells,88,-1,bounds)
 # A continuous raised ridge gives the modular footprint one pitched silhouette.
 var mid=bounds.get_center().x
 for k in keys:
  var c=h.coords(k);var r=Rect2(Vector2(c)*40,Vector2(40,40))
  if r.position.x<=mid and r.end.x>mid and h.tiles()[k].get("roof",false):
   var a=slope(Vector2(mid,r.position.y),bounds,88);var b=slope(Vector2(mid,r.end.y),bounds,88)
   g.draw_line(a,b,Color("384548"),7);g.draw_line(a-Vector2(2,0),b-Vector2(2,0),Color("b4a382"),2)
 # Bare supporting roof decks are not extra storeys. Render built upper walls
 # and their roofs at their own height, using the same footprint and paid finishes.
 for z in range(h.level()+1,h.MAX_Z+1):
  var upper=h.data().get("levels",{}).get(str(z),{});var built=false
  for k in keys:
   if upper.get(k,{}).get("wall","")!="":built=true;break
  if not built:continue
  for k in keys:
   if upper.get(k,{}).get("wall","")!="":wall(h,h.coords(k),false,z,bounds)
  for k in keys:
   if upper.get(k,{}).get("roof",false):roof(h,h.coords(k),group.cells,88+(z-h.level())*64,z,bounds)
