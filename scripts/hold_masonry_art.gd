class_name HoldMasonryArt
extends RefCounted
# Painted modules: the same pillar is placeable furniture and town structure.
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
