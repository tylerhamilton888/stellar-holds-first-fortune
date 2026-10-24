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
