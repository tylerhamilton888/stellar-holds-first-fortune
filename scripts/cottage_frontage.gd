class_name HoldCottageFrontage
extends RefCounted
## Painted joinery for the editable stone house. All sockets use the saved door
## or roof tile as their anchor. The atlas outlines exclude the original house.
const BUILDINGS = preload("res://assets/world-v50/buildings.png")
const HOUSEHOLDS = preload("res://assets/hold77/households.png")
const DOOR_FOOT = Vector2(260, 425)
const PORTAL = [Vector2(190,253), Vector2(330,253), Vector2(335,293), Vector2(341,300), Vector2(341,372), Vector2(349,384), Vector2(349,420), Vector2(307,420), Vector2(305,429), Vector2(214,429), Vector2(213,420), Vector2(167,420), Vector2(167,387), Vector2(175,372), Vector2(175,300), Vector2(189,293)]
const HOOD = [Vector2(176,197), Vector2(250,134), Vector2(252,121), Vector2(263,116), Vector2(276,125), Vector2(277,136), Vector2(342,191), Vector2(346,208), Vector2(337,216), Vector2(326,211), Vector2(326,250), Vector2(195,250), Vector2(197,212), Vector2(183,218)]
const CHIMNEY = [Vector2(100,53), Vector2(105,33), Vector2(114,29), Vector2(155,30), Vector2(163,35), Vector2(162,74), Vector2(157,81), Vector2(160,139), Vector2(149,149), Vector2(105,164), Vector2(102,157), Vector2(105,82), Vector2(99,75)]
const RIDGE_CAP = Rect2(254,54,17,59)
const GALLERY = [Vector2(103,584), Vector2(269,584), Vector2(269,673), Vector2(279,686), Vector2(278,714), Vector2(289,726), Vector2(285,792), Vector2(267,796), Vector2(263,815), Vector2(241,818), Vector2(239,804), Vector2(133,804), Vector2(129,817), Vector2(108,816), Vector2(104,802), Vector2(88,798), Vector2(90,723), Vector2(101,715)]
const LEFT_PIER = [Vector2(48,304), Vector2(87,294), Vector2(94,305), Vector2(92,338), Vector2(100,345), Vector2(101,376), Vector2(105,383), Vector2(102,419), Vector2(55,420), Vector2(54,380), Vector2(42,378), Vector2(42,344), Vector2(50,334)]
const RIGHT_PIER = [Vector2(429,299), Vector2(468,305), Vector2(467,335), Vector2(474,347), Vector2(476,378), Vector2(468,381), Vector2(469,418), Vector2(424,421), Vector2(417,383), Vector2(421,376), Vector2(421,345), Vector2(428,339)]
const LAMP = [Vector2(123,667), Vector2(128,668), Vector2(128,678), Vector2(136,686), Vector2(132,690), Vector2(132,703), Vector2(134,707), Vector2(127,710), Vector2(125,714), Vector2(122,710), Vector2(116,708), Vector2(117,703), Vector2(117,690), Vector2(115,686), Vector2(122,678)]

static func atlas_piece(g, outline:Array, source_anchor:Vector2, foot:Vector2, scale:Vector2, tint:Color=Color.WHITE, texture:Texture2D=BUILDINGS):
 var vertices=PackedVector2Array()
 var uv=PackedVector2Array()
 for point in outline:
  vertices.append(foot+(point-source_anchor)*scale)
  uv.append(point/texture.get_size())
 g.draw_polygon(vertices,PackedColorArray([tint]),uv,texture)

static func entrance(g, foot:Vector2, scale:Vector2, hood:bool, guard:bool, roof_material:String):
 if guard:
  # An upper opening without an exterior landing reads from the street as
  # a recessed, guarded gallery. No fictitious walkable balcony is created.
  atlas_piece(g,GALLERY,Vector2(187,801),foot,Vector2(scale.x*.78,.44),Color.WHITE,HOUSEHOLDS)
  return
 atlas_piece(g,PORTAL,DOOR_FOOT,foot,scale)
 if hood:
  var roof_tint=Color.WHITE
  if roof_material=="iron":roof_tint=Color("b2a6a0")
  elif roof_material=="teal":roof_tint=Color("83c9b0")
  atlas_piece(g,HOOD,Vector2(260,250),foot-Vector2(0,170)*scale,scale,roof_tint)

static func ridge(h, bounds:Rect2, keys:Array, z:int):
 var mid=bounds.get_center().x
 var offset=88+(z-h.level())*HoldHouseArt189.STOREY_RISE
 var map=h.tiles(z)
 for k in keys:
  var cell=h.coords(k)
  if mid<cell.x*40 or mid>=(cell.x+1)*40 or not map.get(k,{}).get("roof",false):continue
  var foot=HoldHouseArt189.slope(Vector2(mid,(cell.y+1)*40),bounds,offset)
  var length=40*HoldHouseArt189.DEPTH_SCALE
  h.g.draw_texture_rect_region(BUILDINGS,Rect2(foot-Vector2(4,length),Vector2(8,length+1)),RIDGE_CAP)

static func frontage(h, group:Dictionary, keys:Array, z:int):
 var bounds:Rect2=group.bounds
 var map=h.tiles(z)
 var rise=(z-h.level())*HoldHouseArt189.STOREY_RISE
 for k in keys:
  var tile:Dictionary=map.get(k,{})
  var kind=tile.get("wall","")
  if kind=="":continue
  var cell=h.coords(k)
  var outside=h.key(cell+Vector2i.DOWN)
  var neighbor:Dictionary=map.get(outside,{})
  if group.cells.has(outside) and (neighbor.get("wall","")!="" or neighbor.get("roof",false)):continue
  var front_y=(cell.y+1)*40
  var foot=Vector2(cell.x*40+20,bounds.end.y-(bounds.end.y-front_y)*HoldHouseArt189.DEPTH_SCALE-rise+3)
  if kind!="door":
   if kind=="wall" and not group.cells.has(h.key(cell+Vector2i.LEFT)):
    atlas_piece(h.g,LEFT_PIER,Vector2(74,419),foot,Vector2(.64,.64))
   elif kind=="wall" and not group.cells.has(h.key(cell+Vector2i.RIGHT)):
    atlas_piece(h.g,RIGHT_PIER,Vector2(445,419),foot,Vector2(.64,.64))
   continue
  # A solitary front door borrows the flanking masonry bays. Keep neighboring
  # doors and windows individually visible in hand-built narrow frontages.
  var width=.80
  for side in [-1,1]:
   var flank:Dictionary=map.get(h.key(cell+Vector2i(side,0)),{})
   if flank.get("wall","")=="door":width=minf(width,.42)
   elif flank.get("wall","")!="wall":width=minf(width,.62)
   elif map.get(h.key(cell+Vector2i(side*2,0)),{}).get("wall","")=="door":width=minf(width,.48)
  var next_floor=h.data().get("levels",{}).get(str(z+1),{})
  var above=next_floor.get(k,{}).get("wall","")!=""
  var scale=Vector2(width,.56 if above else .65)
  var guard=z>0 and not neighbor.has("floor")
  var hood=tile.get("roof",false) and not above
  var style=HoldBlueprintFinishes.style(h,cell,z)
  entrance(h.g,foot,scale,hood,guard,style.roof)
  if width>.5 and not above and not guard:
   for sign_x in [-1,1]:
    var socket=foot+Vector2(sign_x*79,-65)
    atlas_piece(h.g,LAMP,Vector2(125,668),socket,Vector2(.64,.64),Color.WHITE,HOUSEHOLDS)

static func roof_stack(h,group:Dictionary,z:int):
 var bounds:Rect2=group.bounds
 if bounds.size.x<160 or bounds.size.y<120:return
 var cell=Vector2i((bounds.position+Vector2(bounds.size.x*.24,bounds.size.y*.28))/40)
 var key=h.key(cell)
 if not group.cells.has(key) or not h.tiles(z).get(key,{}).get("roof",false):return
 var foot=HoldHouseArt189.slope(h.center(cell),bounds,88+(z-h.level())*HoldHouseArt189.STOREY_RISE)
 atlas_piece(h.g,CHIMNEY,Vector2(132,155),foot,Vector2(.61,.61))
