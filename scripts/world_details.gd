class_name HoldWorldDetails
extends RefCounted
const SHEET=preload("res://assets/world-v27/details.png")
const BRIDGE_SHEET=preload("res://assets/world-v28/bridge.png")
const BRIDGE=Rect2(0,95,2048,485)
const WAYSTONE=Rect2(1090,0,446,510)
const CACHE=Rect2(0,515,830,485)
static func prop(n:Node2D,p:Vector2,kind:String,width:float):
 if kind=="waystone":
  var source:Rect2=HoldLooseProps.CROPS.runestone
  HoldLooseProps.draw(n,Rect2(p-Vector2(width*.5,width*source.size.y/source.size.x),Vector2(width,width*source.size.y/source.size.x)),"runestone")
 else:
  # Legacy cache scenes also use separated objects, with clear space between.
  for piece in [["barrel",-.34],["crate",.05],["road_lantern",.40]]:
   var w=width*(.22 if piece[0]=="road_lantern" else .29)
   var source:Rect2=HoldLooseProps.CROPS[piece[0]]
   HoldLooseProps.draw(n,Rect2(p+Vector2(width*piece[1]-w*.5,-w*source.size.y/source.size.x),Vector2(w,w*source.size.y/source.size.x)),piece[0])
static func bridge(n:Node2D,x:float,front:bool=false):
 var destination=Rect2(x-90,711,180,70)
 var source=BRIDGE
 if front:
  source=Rect2(0,330,2048,250)
  destination.position.y+=70*235.0/485;destination.size.y=70*250.0/485
 n.draw_texture_rect_region(BRIDGE_SHEET,destination,source)
