class_name HoldWorldDetails
extends RefCounted
const SHEET=preload("res://assets/world-v27/details.png")
const BRIDGE_SHEET=preload("res://assets/world-v28/bridge.png")
const BRIDGE=Rect2(0,95,2048,485)
const WAYSTONE=Rect2(1090,0,446,510)
const CACHE=Rect2(0,515,830,485)
static func prop(n:Node2D,p:Vector2,kind:String,width:float):
 var source=WAYSTONE if kind=="waystone" else CACHE
 var height=width*source.size.y/source.size.x
 n.draw_texture_rect_region(SHEET,Rect2(p-Vector2(width*.5,height),Vector2(width,height)),source)
static func bridge(n:Node2D,x:float,front:bool=false):
 var destination=Rect2(x-90,711,180,70)
 var source=BRIDGE
 if front:
  source=Rect2(0,330,2048,250)
  destination.position.y+=70*235.0/485;destination.size.y=70*250.0/485
 n.draw_texture_rect_region(BRIDGE_SHEET,destination,source)
