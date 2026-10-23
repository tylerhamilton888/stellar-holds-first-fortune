class_name HoldKeldrathArt
extends RefCounted
# Original frontages share the old door anchors and solid architectural masses.
# Sources are measured silhouettes, not assumed equal generated atlas cells.
const HOMES=preload("res://assets/hold77/households.png")
const CIVIC=preload("res://assets/hold77/civic-fronts.png")
const HOME_RECTS=[Rect2(23,20,320,477),Rect2(383,18,258,480),Rect2(674,42,327,455),Rect2(27,538,318,450),Rect2(365,536,292,453),Rect2(674,536,328,454),Rect2(24,1026,320,470),Rect2(366,1026,295,470),Rect2(675,1023,328,473)]
const HOME_DOORS=[Vector2(183,490),Vector2(512,490),Vector2(837,490),Vector2(183,982),Vector2(512,982),Vector2(837,983),Vector2(183,1490),Vector2(512,1490),Vector2(837,1488)]
const CIVIC_RECTS=[Rect2(82,43,675,633),Rect2(775,161,632,516),Rect2(1450,111,645,566)]
const CIVIC_DOORS=[Vector2(421,665),Vector2(1091,665),Vector2(1771,664)]
static func source(b:Dictionary)->Dictionary:
 if b.has("home"):
  var p=HoldNeighborhood.parts(b.home);var i=HoldWorldZones.WARDS.find(p[0])*3+int(p[1])
  return {"texture":HOMES,"rect":HOME_RECTS[i],"anchor":HOME_DOORS[i]}
 var i=[4,12,17].find(int(b.get("id",-1)))
 if i>=0:return {"texture":CIVIC,"rect":CIVIC_RECTS[i],"anchor":CIVIC_DOORS[i]}
 var old=5 if b.get("id",0)==-1 else HoldWorldZones.facade_index(b)
 return {"texture":HoldWorldZones.FACADES,"rect":HoldWorldZones.FACADE_RECTS[old],"anchor":HoldWorldZones.FACADE_DOORS[old]}
static func rect(b:Dictionary)->Rect2:
 var art=source(b);var scale=float(b.width)/art.rect.size.x
 # Keep tall new fronts within the established roof envelope, with no stretching.
 scale=minf(scale,HoldWorldZones.building_rect(b).size.y/art.rect.size.y)
 return Rect2(b.p-(art.anchor-art.rect.position)*scale,art.rect.size*scale)
static func draw(w,b:Dictionary):
 var r=rect(b)
 if not r.intersects(Rect2(w.view_camera(),Vector2(960,540))):return
 var art=source(b);w.g.draw_texture_rect_region(art.texture,r,art.rect)
static func structure(w):
 # Great structural piers stand beyond the walkable wall, carrying the galleries.
 # Their bases never occupy a public route or disguise an invisible obstacle.
 var g=w.g;var area=w.current_area()
 var shade=Color("c4c3aa") if area=="crownward" else Color("b9ab91") if area=="hearthward" else Color("a09c91")
 for x in [42,1840]:
  for y in [490,990,1600]:HoldMasonryArt.pillar(g,Vector2(x,y),300,shade)
 # North-wall buttresses visibly carry a continuous stone entablature.
 for x in [100,550,1370,1770]:HoldMasonryArt.pillar(g,Vector2(x,204),320,shade)
 HoldMasonryArt.wall(g,Rect2(60,-133,1760,74))
 # Service channels are flush with paving and follow the north street.
 for y in [510,574]:
  g.draw_line(Vector2(160,y),Vector2(1640,y),Color("354949"),5)
  g.draw_line(Vector2(160,y+3),Vector2(1640,y+3),Color("9b957d"),1)
 for x in [530,1050,1530]:
  for i in 5:g.draw_line(Vector2(x+i*4,507),Vector2(x+i*4,514),Color("8b8f7f"),1)
