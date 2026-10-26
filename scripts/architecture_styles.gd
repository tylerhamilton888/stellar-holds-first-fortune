class_name HoldArchitectureStyles
extends RefCounted
# Compatible dimensions, independent material choices. Original fronts are never
# recoloured or resized to impersonate a different building.
const FLOORS=preload("res://assets/architecture87/floors.png")
const ATLAS=preload("res://assets/architecture87/collections.png")
const FAMILIES={
 "hearth":{"title":"Hearthstone","mood":"A warm hearth, stout oak and welcoming windows.","roof":"slate","trim":"oak","floor":"oak","accent":Color("cda36a")},
 "forge":{"title":"Forgehold","mood":"Dark basalt, copper bindings and room for honest work.","roof":"iron","trim":"copper","floor":"slate","accent":Color("c98b5d")},
 "oath":{"title":"Oathhall","mood":"Pale carved stone, teal roofs and ancestral brass.","roof":"teal","trim":"brass","floor":"inlaid","accent":Color("77b5ae")}
}
const OPTIONS={"wall":{"hearth":"Hearthstone","forge":"Forgehold","oath":"Oathhall"},"roof":{"slate":"Blue slate","iron":"Iron slate","teal":"Teal slate"},"trim":{"oak":"Bound oak","copper":"Copper","brass":"Carved brass"},"floor":{"oak":"Warm oak","slate":"Hewn slate","inlaid":"Oathstone inlay"}}
const WALLS=[Rect2(80,23,305,299),Rect2(79,356,307,300),Rect2(79,689,308,308)]
const WINDOWS=[Rect2(449,24,307,298),Rect2(449,357,309,299),Rect2(449,689,308,308)]
const POSTS=[Rect2(879,11,110,317),Rect2(874,346,119,315),Rect2(879,680,118,326)]
const ROOFS=[Rect2(1117,22,336,300),Rect2(1117,357,337,299),Rect2(1116,690,338,306)]
static func family(id:String)->String:
 if id.begins_with("folk_forgeward") or id in ["workshop","hold_forge","hold_training"]:return "forge"
 if id.begins_with("folk_crownward") or id in ["hold_throne","hold_research","archive"]:return "oath"
 return "hearth"
static func preset(key:String)->Dictionary:
 var f=FAMILIES.get(key,FAMILIES.hearth)
 return {"wall":key if FAMILIES.has(key) else "hearth","roof":f.roof,"trim":f.trim,"floor":f.floor}
static func resolve(b:Dictionary)->Dictionary:
 var defaults=preset(family(str(b.get("plan",b.get("key","cottage")))))
 var saved=b.get("style87",{})
 if saved is not Dictionary:return defaults
 for key in defaults:
  if OPTIONS[key].has(saved.get(key,"")):defaults[key]=saved[key]
 return defaults
static func room(area:String)->Dictionary:
 if area=="claim":
  var owner=HoldArchitecture.current()
  if owner!=null:return resolve(owner.s.house.data())
 if HoldBuildingPlans.owned_room(area):
  var owner=HoldArchitecture.current()
  if owner!=null:return resolve(owner.record(HoldBuildingPlans.room_parts(area)[0]))
 var id=area.trim_prefix("room:")
 if area.begins_with("home:"):id="cottage"
 elif HoldNeighborhood.is_home(area):id=id.rsplit("_",true,1)[0]
 elif id=="greenhearth":id="farmhouse"
 elif id=="practice":id="hold_training"
 elif id not in ["wayfarer","archive"]:id="hold_"+id
 return preset(family(id))
static func index(key:String,part:String="wall")->int:return maxi(0,OPTIONS[part].keys().find(key))
static func texture(part:String,key:String)->AtlasTexture:
 var crop=AtlasTexture.new();crop.atlas=ATLAS
 crop.region=ROOFS[index(key,"roof")] if part=="roof" else POSTS[index(key,"trim")] if part=="trim" else WALLS[index(key)]
 return crop
static func patch(g,r:Rect2,source:Rect2,unit:Vector2,tint:Color=Color.WHITE):
 # Crop the last tile; never squash a window or enlarge blocks to fill a wing.
 var y=r.position.y
 while y<r.end.y-.1:
  var x=r.position.x;var h=minf(unit.y,r.end.y-y)
  while x<r.end.x-.1:
   var width=minf(unit.x,r.end.x-x)
   g.draw_texture_rect_region(ATLAS,Rect2(x,y,width,h),Rect2(source.position,source.size*Vector2(width,h)/unit),tint)
   x+=unit.x
  y+=unit.y
static func post(g,p:Vector2,height:float,trim:String,tint:Color=Color.WHITE):
 var source=POSTS[index(trim,"trim")];var size=source.size*height/source.size.y
 g.draw_texture_rect_region(ATLAS,Rect2(p-Vector2(size.x/2,height),size),source,tint)
static func wall(g,r:Rect2,style:Dictionary,windows:bool=true,tint:Color=Color.WHITE):
 patch(g,r,WALLS[index(style.wall)],Vector2(88,86),tint)
 if windows:
  var count=floori((r.size.x-16)/76.0)
  for i in count:
   var x=r.position.x+r.size.x*(i+.5)/count
   var side=minf(76,r.size.y-10)
   g.draw_texture_rect_region(ATLAS,Rect2(x-side*.5,r.end.y-side-6,side,side),WINDOWS[index(style.wall)],tint)
static func roof(g,r:Rect2,style:Dictionary,tint:Color=Color.WHITE):
 patch(g,r,ROOFS[index(style.roof,"roof")],Vector2(100,82),tint)
 var edge=FAMILIES[style.wall].accent*tint
 g.draw_rect(r,Color("27363a")*tint,false,5)
 g.draw_line(r.position,r.position+Vector2(r.size.x,0),edge,3)
 g.draw_line(r.position+Vector2(0,r.size.y),r.end,edge.darkened(.25),5)
static func floor_draw(g,r:Rect2,finish:String,tint:Color=Color.WHITE):
 var column=maxi(0,["oak","slate","inlaid"].find(finish));var unit=Vector2(176,352)
 var tint_floor=(Color("c6beb0") if finish=="oak" else Color("c1cbc7"))*tint
 # World-aligned sampling keeps hand-laid replacement tiles continuous.
 for y in range(floori(r.position.y/unit.y),ceili(r.end.y/unit.y)):
  for x in range(floori(r.position.x/unit.x),ceili(r.end.x/unit.x)):
   var whole=Rect2(Vector2(x,y)*unit,unit);var part=whole.intersection(r)
   var source=Rect2(Vector2(column*512,0)+(part.position-whole.position)/unit*Vector2(512,1024),part.size/unit*Vector2(512,1024))
   g.draw_texture_rect_region(FLOORS,part,source,tint_floor)
static func room_shell(w,area:String):
 var geom=HoldBuildingPlans.geometry(area);var r:Rect2=geom.floor;var g=w.g;var style=room(area)
 g.draw_rect(Rect2(Vector2.ZERO,geom.size),Color("14272d"))
 var wood=style.floor=="oak"
 floor_draw(g,r,style.floor)
 # Perimeter courses make even an unfurnished room an intentional room.
 var inner=r.grow(-22);var edge=Color("655038") if wood else Color("485a5e")
 for strip in [Rect2(r.position,Vector2(r.size.x,22)),Rect2(r.position+Vector2(0,22),Vector2(22,r.size.y-44)),Rect2(r.end-Vector2(22,r.size.y-22),Vector2(22,r.size.y-44)),Rect2(r.position+Vector2(0,r.size.y-22),Vector2(r.size.x,22))]:
  floor_draw(g,strip,style.floor,Color("9b9382") if wood else Color("839493"))
 g.draw_rect(inner,edge,false,2)
 if style.floor=="inlaid":
  g.draw_rect(inner.grow(-5),Color("ae9768"),false,1.5)
  for p in [inner.position,Vector2(inner.end.x,inner.position.y),inner.end,Vector2(inner.position.x,inner.end.y)]:
   var center=p+(r.get_center()-p).normalized()*16
   g.draw_polyline(PackedVector2Array([center+Vector2(0,-8),center+Vector2(8,0),center+Vector2(0,8),center+Vector2(-8,0),center+Vector2(0,-8)]),Color("b7a377"),2)
 # Painted north wall, matching side coping, and contact shadows. Everything
 # stays on the established wall line, outside the walkable bounds.
 var north=Rect2(r.position-Vector2(8,62),Vector2(r.size.x+16,82))
 wall(g,north,style,false)
 for x in range(int(r.position.x),int(r.end.x)+1,160):post(g,Vector2(x,r.position.y+20),84,style.trim)
 g.draw_rect(Rect2(r.position+Vector2(14,20),Vector2(r.size.x-28,7)),Color(0,0,0,.22))
 for x in [r.position.x-8,r.end.x-8]:
  patch(g,Rect2(x,r.position.y+20,16,r.size.y-20),WALLS[index(style.wall)],Vector2(88,86),Color("b9c2bd"))
  g.draw_line(Vector2(x+3,r.position.y+20),Vector2(x+3,r.end.y),FAMILIES[style.wall].accent,2)
 var exit_x=geom.exit.x
 for front in [Rect2(r.position.x,r.end.y-10,exit_x-r.position.x-40,18),Rect2(exit_x+40,r.end.y-10,r.end.x-exit_x-40,18)]:
  patch(g,front,WALLS[index(style.wall)],Vector2(88,86))
  g.draw_line(front.position,Vector2(front.end.x,front.position.y),FAMILIES[style.wall].accent,2)
