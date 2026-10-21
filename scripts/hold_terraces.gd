class_name HoldTerraces
extends RefCounted
# A common projected space for the three wards. Stored positions stay ward-local.
# Only the two neighboring plates can enter the camera; no extra Viewports.
const STRIDE=1740.0
const TOP=260.0
const BOTTOM=1590.0
const LINKS=[{"upper":"crownward","lower":"hearthward","x":150.0}, {"upper":"hearthward","lower":"forgeward","x":1700.0}]
static func origin(area:String)->Vector2:return Vector2(0,HoldWorldZones.WARDS.find(area)*STRIDE)
static func links(area:String)->Array:return LINKS.filter(func(l):return area in [l.upper,l.lower])
static func local_start(link:Dictionary,area:String)->Vector2:return Vector2(link.x,BOTTOM if area==link.upper else TOP)
static func passage(link:Dictionary,area:String)->Rect2:
 return Rect2(link.x-35,BOTTOM-(STRIDE if area==link.lower else 0),70,STRIDE+TOP-BOTTOM)
static func on_stair(area:String,p:Vector2)->bool:
 for link in links(area):
  if passage(link,area).has_point(p):return true
 return false
static func envelope(area:String,p:Vector2)->bool:
 for link in links(area):
  var r=passage(link,area)
  if Rect2(r.position-Vector2(24,0),r.size+Vector2(48,0)).has_point(p):return true
 return false
static func crossing(area:String,p:Vector2)->Dictionary:
 for link in links(area):
  if not on_stair(area,p):continue
  if area==link.upper and p.y>=STRIDE:return {"area":link.lower,"p":p-Vector2(0,STRIDE)}
  if area==link.lower and p.y<0:return {"area":link.upper,"p":p+Vector2(0,STRIDE)}
 return {}
static func points(area:String)->Array:
 var result=[]
 for link in links(area):
  result.append({"p":local_start(link,area),"name":"Great Stair · "+("down to " if area==link.upper else "up to ")+str(link.lower if area==link.upper else link.upper).capitalize(),"action":"terrace:"+link.upper,"link":link})
 return result
static func waypoint(from:String,to:String)->Vector2:
 var index=HoldWorldZones.WARDS.find(from);var down=index<HoldWorldZones.WARDS.find(to)
 return local_start(LINKS[index if down else index-1],from)
static func rails(area:String)->Array:
 var result=[]
 for link in links(area):
  var r=passage(link,area)
  result.append(Rect2(r.position-Vector2(18,0),Vector2(14,r.size.y)))
  result.append(Rect2(Vector2(r.end.x+4,r.position.y),Vector2(14,r.size.y)))
 return result
static func camera(area:String,p:Vector2)->Vector2:
 var min_y=-65.0;var max_y=1200.0
 for link in links(area):
  if link.lower==area:min_y=-450.0
  else:max_y=1580.0
 return (p-Vector2(480,300)).clamp(Vector2(0,min_y),Vector2(920,max_y))
static func draw_connection(w,link:Dictionary,area:String):
 var offset=origin(link.upper)-origin(area)
 var start=Vector2(link.x,BOTTOM)+offset
 var finish=Vector2(link.x,STRIDE+TOP)+offset
 var view=Rect2(w.g.camera-Vector2(100,100),Vector2(1160,740))
 var g=w.g
 # A substantial masonry drop beneath the upper terrace. The lower ward's
 # rooflines remain visible beyond it, instead of being a painted backdrop.
 var wall=Rect2(80,1640+offset.y,1720,144)
 if wall.intersects(view):HoldMasonryArt.wall(g,wall)
 if Rect2(start-Vector2(70,30),Vector2(140,finish.y-start.y+60)).intersects(view):HoldMasonryArt.stairs(g,start,finish)
