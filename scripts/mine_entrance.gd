class_name HoldMineEntrance
extends RefCounted
# The visible mouth, feet collision and crossing plane share these dimensions.
const HALF_OPENING=72.0
const CROSSING_HALF=58.0
const HILLSIDE = preload("res://assets/mine_thresholds/hillside.webp")
const DAYLIGHT = preload("res://assets/mine_thresholds/daylight.webp")
const DRIFT = preload("res://assets/mine_thresholds/drift.webp")
static func paint(n, p: Vector2, texture: Texture2D, width: float, threshold: Vector2):
 var size = texture.get_size() * (width / texture.get_width())
 n.draw_texture_rect(texture, Rect2(p - size * threshold, size), false)
static func connect_approach(paths: Array, p: Vector2) -> Array:
 var result = []
 for path in paths:
  if path.size() < 2 or Vector2(path[-1]).distance_to(p) > 1:
   result.append(path)
   continue
  var approach = PackedVector2Array(path)
  approach.resize(approach.size() - 1)
  approach.append(p + Vector2(0, 55))
  approach.append(p)
  result.append(approach)
 return result
static func position(area:String)->Vector2:
 return Vector2(950,300) if area=="trail" else Vector2(1280,345)
static func shoulder_span(p: Vector2, bounds: Rect2, exclusions: Array) -> Vector2:
 var reach = Vector2(minf(375, p.x - bounds.position.x), minf(385, bounds.end.x - p.x))
 for occupied: Rect2 in exclusions:
  if occupied.end.y < p.y - 130 or occupied.position.y > p.y + 12: continue
  if occupied.end.x < p.x: reach.x = minf(reach.x, p.x - occupied.end.x - 8)
  elif occupied.position.x > p.x: reach.y = minf(reach.y, occupied.position.x - p.x - 8)
 return reach.clamp(Vector2(105, 105), Vector2(375, 385))
static func site_span(area: String, p: Vector2, g = null) -> Vector2:
 var exclusions = [HoldWorldZones.TRAIL_RIVER_BANK] if area == "trail" else []
 if g != null:
  for item in g.state.surface.chests.values():
   if g.surface.house.local(item): exclusions.append(HoldFurnishings.footprint("chest", Vector2(item.x, item.y)))
  for item in g.state.surface.decor:
   if g.surface.house.local(item): exclusions.append(HoldFurnishings.footprint(item.kind, Vector2(item.x, item.y)))
  for item in g.state.hauling.get("hands", {}).get("facilities", []):
   if item.get("area", "") == "surface:" + area + ":0" and not item.get("hitched", false): exclusions.append(HoldHandworks.footprint(item))
 return shoulder_span(p, Rect2(Vector2.ZERO, HoldSurface.SIZE), exclusions)
static func obstacles(p: Vector2, area: String, g = null) -> Array:
 var span = site_span(area, p, g)
 return [Rect2(p + Vector2( - span.x * 0.78, -98), Vector2(span.x * 0.78 - HALF_OPENING, 100)),
  Rect2(p + Vector2(HALF_OPENING, -98), Vector2(span.y * 0.78 - HALF_OPENING, 100))]
static func draw(g,p:Vector2):
 # Painted hold masonry frames a deep, visibly open tunnel.
 var span = site_span(g.surface.area, p, g)
 var texture_size = HILLSIDE.get_size()
 var height = texture_size.y * 760 / texture_size.x
 var left = p.x - span.x
 var top = p.y - height * 0.925
 var start = 0.0
 for part in [[0.355, p.x - 105], [0.631, p.x + 105], [1.0, p.x + span.y]]:
  var destination = Rect2(left, top, part[1] - left, height)
  var source = Rect2(start * texture_size.x, 0, (part[0] - start) * texture_size.x, texture_size.y)
  g.draw_texture_rect_region(HILLSIDE, destination, source)
  start = part[0];left = part[1]

# Interior doors sit in the northern wall of the arrival bay, not the freight floor.
# The saved choice only moves a doorway; terrain, furniture and cargo stay untouched.
static func inside_position(w)->Vector2:
 if not w.data.has("entryway144"):
  var chosen=Vector2i(8,3)
  for x in [8,7,9,6,10,5,4]:
   var c=Vector2i(x,3);var clear=true
   for y in range(3,6):
    for xx in range(x-1,x+2):
     var q=Vector2i(xx,y)
     if not w.terrain_walkable(q,0) or w.equipment_solid(Deepworks.center(q),0) or w.layer(0).fixtures.has(Deepworks.key(q)) or w.data.links.has(w.link_key(q,0)):clear=false
   if clear:chosen=c;break
  w.data.entryway144=[chosen.x,chosen.y]
 return Deepworks.center(Vector2i(int(w.data.entryway144[0]),int(w.data.entryway144[1])))
static func inside_arrival(w)->Vector2:return inside_position(w)+Vector2(0,80)
static func inside_near(w,p:Vector2)->bool:
 if w.depth()!=0:return false
 var door=inside_position(w)
 return absf(p.x-door.x)<34 and p.y>=door.y-10 and p.y<door.y+65 and w.visible(p,door)
static func inside_crossed(w,a:Vector2,b:Vector2)->bool:
 if w.depth()!=0:return false
 var door=inside_position(w);var line=door.y+10
 return a.y>=line and b.y<line and absf(b.x-door.x)<34
static func reserved(w,c:Vector2i,z:int)->bool:
 return z==0 and Rect2(inside_position(w)-Vector2(80,20),Vector2(160,130)).has_point(Deepworks.center(c))
static func blocks(w,p:Vector2,z:int)->bool:
 var doors=[]
 if z==0:doors.append({"p":inside_position(w),"side":false})
 var q=w.data.get("mineworks143",{})
 if z == 0 and q.has("entrance") and w.at(Vector2i(int(q.entrance[0]), int(q.entrance[1])) + Vector2i.UP, 0) != 0:
  doors.append({"p":Deepworks.center(Vector2i(int(q.entrance[0]),int(q.entrance[1]))),"side":false})
 var back=q.get("returns144",{}).get(str(z),[])
 if back.size() == 2 and w.at(Vector2i(int(back[0]), int(back[1])) + Vector2i.UP, z) != 0: doors.append({"p": Deepworks.center(Vector2i(int(back[0]), int(back[1]))), "side": false})
 if z==5:doors.append({"p":Deepworks.center(Vector2i(23,10)),"side":true})
 if z==6:doors.append({"p":Deepworks.center(Vector2i(33,12)),"side":true})
 for door in doors:
  var edge=Vector2(.44,.9) if door.side else Vector2.RIGHT
  for sign in [-1,1]:
   var jamb=door.p+edge*sign*56
   if Rect2(jamb-Vector2(14,10),Vector2(28,26)).grow(8).has_point(p):return true
 return false
static func inside_prop(w)->Dictionary:
 return {"p":inside_position(w),"kind":"entryway144","open":true,"name":"SURFACE","side":false}
static func draw_inside(n,o:Dictionary):
 var p:Vector2=o.p
 # Side headings use an oblique wall face; the posts stay upright in both views.
 if not o.get("side", false) and o.open:
  if o.get("floor_stair", false):
   HoldMasonryArt.stairs(n, p - Vector2(0, 24), p + Vector2(0, 22))
  elif o.kind == "entryway144":
   paint(n, p, DAYLIGHT, 180, Vector2(0.5, 0.91))
  else:
   paint(n, p, DRIFT, 174, Vector2(0.51, 0.91))
  return
 var edge=Vector2(.44,.9) if o.get("side",false) else Vector2.RIGHT
 var inward=Vector2.LEFT if o.get("side",false) else Vector2.DOWN
 var left=p-edge*56;var right=p+edge*56;var height=Vector2(0,94)
 var approach=PackedVector2Array([left,right,right+inward*54,left+inward*54])
 if o.get("floor",true):
  n.draw_polygon(approach,PackedColorArray([Color(.72,.76,.71)]),PackedVector2Array([Vector2(.5,0),Vector2(1,0),Vector2(1,.5),Vector2(.5,.5)]),HoldMasonryArt.SURFACES)
  for i in range(3):
   var at=p+inward*(8+i*16)
   n.draw_line(at-edge*44,at+edge*44,Color(0,0,0,.18),1)
 # Depth in the throat, worn jambs, and a visible top plane tie it into the rock.
 n.draw_colored_polygon(PackedVector2Array([left,right,right-height,left-height]),Color("0b151b"))
 n.draw_colored_polygon(PackedVector2Array([left,left-height,left-height+Vector2(12,6),left+Vector2(12,0)]),Color("354445"))
 n.draw_colored_polygon(PackedVector2Array([left-height,right-height,right-height+Vector2(0,-16),left-height+Vector2(0,-16)]),Color("738078"))
 for at in [left,right]:
  HoldMasonryArt.pillar(n,at+Vector2(0,8),108,Color(.85,.88,.82))
  n.draw_circle(at-Vector2(0,43),22,Color(1,.68,.28,.07))
  n.draw_rect(Rect2(at-Vector2(4,52),Vector2(8,15)),Color("263437"))
  n.draw_rect(Rect2(at-Vector2(2,50),Vector2(4,10)),Color("f5c474"))
 n.draw_line(left-height+Vector2(0,-7),right-height+Vector2(0,-7),Color("b0a382"),6)
 if not o.open:
  for offset in [-26,0,26]:
   var at=p+edge*offset
   n.draw_line(at,at-height,Color("485157"),14)
 # A fixed lintel plaque, never floating over the dwarf or floor.
 if not o.get("side",false):
  HoldMasonryArt.wall(n,Rect2(p+Vector2(-77,-122),Vector2(154,28)))
  var plaque=Rect2(p+Vector2(-39,-111),Vector2(78,17))
  n.draw_rect(plaque,Color("243638"));n.draw_rect(plaque,Color("a58d61"),false,1)
  var font=ThemeDB.fallback_font;var title=str(o.get("name","PASSAGE"))
  n.draw_string(font,plaque.position+Vector2((78-font.get_string_size(title,HORIZONTAL_ALIGNMENT_LEFT,-1,10).x)/2,12),title,HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color("ead3a3"))
