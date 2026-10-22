class_name HoldMasonryArt
extends RefCounted
# Painted modules: the same pillar is placeable furniture and town structure.
const SURFACES=preload("res://assets/hold-kit72/surfaces.png")
const ATLAS=preload("res://assets/hold-kit67/masonry.png")
const PILLAR=Rect2(211,72,294,675)
const STAIR=Rect2(790,62,291,693)
const WALL=Rect2(21,859,586,322)
const WING=Rect2(634,862,606,320)
static func pillar(g,p:Vector2,height:float=124,tint:Color=Color.WHITE):
 var width=height*PILLAR.size.x/PILLAR.size.y
 g.draw_texture_rect_region(ATLAS,Rect2(p-Vector2(width/2,height),Vector2(width,height)),PILLAR,tint)
static func wall(g,rect:Rect2):
 var count=maxi(1,roundi(rect.size.x/(rect.size.y*WALL.size.x/WALL.size.y)))
 for i in count:g.draw_texture_rect_region(ATLAS,Rect2(rect.position+Vector2(i*rect.size.x/count,0),Vector2(rect.size.x/count,rect.size.y)),WALL)
static func stairs(g,start:Vector2,finish:Vector2):
 # Measured inner tread edges / first and final treads map to the walkable lane.
 var scale=Vector2(70.0/135.0,(finish.y-start.y)/616.0)
 var origin=start-Vector2(934-STAIR.position.x,109-STAIR.position.y)*scale
 g.draw_texture_rect_region(ATLAS,Rect2(origin,STAIR.size*scale),STAIR)
static func wing(g,rect:Rect2):g.draw_texture_rect_region(ATLAS,rect,WING)

static func building_volume(w,b:Dictionary):
 # The entire collision mass is visible architecture, including the rear corners.
 # Roof, side masonry and foundation use the same surveyed footprint as navigation.
 var r=HoldWorldZones.building_footprint(b);var g=w.g
 if not r.grow(70).intersects(Rect2(w.view_camera(),Vector2(960,540))):return
 var roof=Rect2(r.position,r.size-Vector2(0,60))
 g.draw_style_box(w.stone_style(Color("4d6260")),r)
 wall(g,Rect2(r.position+Vector2(0,r.size.y-62),Vector2(r.size.x,62)))
 g.draw_texture_rect_region(SURFACES,roof,surface_region(1))
 for x in [r.position.x+7,r.end.x-7]:
  g.draw_line(Vector2(x,r.position.y+8),Vector2(x,r.end.y-8),Color("273d40"),12)
  g.draw_line(Vector2(x-2,r.position.y+8),Vector2(x-2,r.end.y-8),Color("a39b79"),3)
 # Heavy rear coping ties the roof into the mountain, rather than a paper frontage.
 wall(g,Rect2(r.position-Vector2(0,22),Vector2(r.size.x,32)))

static func surface_region(index:int)->Rect2:
 var half=SURFACES.get_size()/2.0
 return Rect2(Vector2(index%2,int(index/2))*half,half)
