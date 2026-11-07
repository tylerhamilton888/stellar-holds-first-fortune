class_name HoldMineEntrance
extends RefCounted
# The visible mouth, feet collision and crossing plane share these dimensions.
const HALF_OPENING=72.0
const CROSSING_HALF=58.0
static func position(area:String)->Vector2:
 return Vector2(950,300) if area=="trail" else Vector2(1280,345)
static func obstacles(p:Vector2)->Array:
 return [Rect2(p+Vector2(-130,-110),Vector2(58,120)),Rect2(p+Vector2(72,-110),Vector2(58,120))]
static func ground(g,p:Vector2):
 # Worn track bed leads through the threshold, rather than into the piers.
 g.draw_colored_polygon(PackedVector2Array([p+Vector2(-69,-25),p+Vector2(69,-25),p+Vector2(89,90),p+Vector2(-89,90)]),Color("776f57"))
 for y in range(-12,83,15):
  g.draw_line(p+Vector2(-45,y),p+Vector2(45,y),Color("4a4c43"),6)
 for x in [-30,30]:
  g.draw_line(p+Vector2(x,-30),p+Vector2(x,92),Color("293e40"),5)
  g.draw_line(p+Vector2(x-1,-30),p+Vector2(x-1,92),Color("b2aaa0"),2)
 g.draw_line(p+Vector2(-68,7),p+Vector2(68,7),Color("c6ad74"),3)
static func draw(g,p:Vector2):
 # Painted hold masonry frames a deep, visibly open tunnel.
 var fade=.35 if g.player.y<p.y-8 and absf(g.player.x-p.x)<140 else 1.0
 g.draw_colored_polygon(PackedVector2Array([p+Vector2(-72,0),p+Vector2(-72,-100),p+Vector2(-48,-126),p+Vector2(48,-126),p+Vector2(72,-100),p+Vector2(72,0)]),Color(.035,.065,.07,fade))
 for side in [-1,1]:
  HoldMasonryArt.pillar(g,p+Vector2(side*98,10),132,Color(1,1,1,fade))
  g.draw_line(p+Vector2(side*64,-18),p+Vector2(side*64,-93),Color(.28,.32,.29,fade),8)
 HoldMasonryArt.wall(g,Rect2(p+Vector2(-126,-153),Vector2(252,40)))
 var sign=Rect2(p+Vector2(-65,-151),Vector2(130,24))
 g.draw_rect(sign,Color("273f40"));g.draw_rect(sign,Color("c1a575"),false,1)
 HoldSurface.A.text(g,p+Vector2(-53,-134),"OLD WORKINGS" if g.surface.area=="trail" else "DEEPWORKS",12,Color("eed5a0"))
 for side in [-1,1]:
  var lamp=p+Vector2(side*97,-73)
  g.draw_circle(lamp,12,Color(1,.67,.25,.09));g.draw_rect(Rect2(lamp-Vector2(4,7),Vector2(8,14)),Color("e8bb69"))
 if g.player.distance_to(p)<170:
  HoldSurface.A.text(g,p+Vector2(-64,111),"WALK IN  /  E ENTER",12,Color("edd4a2"))

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
 if z==0 and q.has("entrance"):
  doors.append({"p":Deepworks.center(Vector2i(int(q.entrance[0]),int(q.entrance[1]))),"side":false})
 var back=q.get("returns144",{}).get(str(z),[])
 if back.size()==2:doors.append({"p":Deepworks.center(Vector2i(int(back[0]),int(back[1]))),"side":false})
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
