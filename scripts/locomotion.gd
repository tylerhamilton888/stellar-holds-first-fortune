class_name HoldLocomotion
extends RefCounted
# Torso and equipment retain their painted poses; two boot/leg pieces articulate
# below the hip. No head/body rescaling is used for walking or jumping.
static func draw(n:Node2D,tex:Texture2D,root:Vector2,base:Texture2D,base_root:Vector2,t:float,air:int,pos:Vector2,facing:int,zoom:float,tint:Color):
 var hip=-22.0
 var phase=t*TAU*1.5
 for side in [-1,1]:
  var swing=sin(phase+(PI if side<0 else 0))
  var angle=swing*.36 if air==0 else (-.48 if side<0 else .34)
  var lift=maxf(0,cos(phase+(PI if side<0 else 0)))*4 if air==0 else (5.0 if air==1 else 2.0)
  var pivot=Vector2(side*9,hip)
  var source=Rect2(base_root+Vector2(-34 if side<0 else 0,hip),Vector2(34,-hip+2))
  var offset=Vector2(-34 if side<0 else 0,hip)-pivot
  var sole=maxf((offset+Vector2(0,source.size.y-2)).rotated(angle).y,(offset+source.size-Vector2(0,2)).rotated(angle).y)+pivot.y
  var planted=-sole if air==0 else 0.0
  var transform=Transform2D(0,Vector2(facing,1)*zoom,0,pos.round())*Transform2D(angle,pivot+Vector2(0,planted-lift))
  n.draw_set_transform_matrix(transform)
  n.draw_texture_rect_region(base,Rect2(offset,source.size),source,tint)
 n.draw_set_transform(pos.round(),0,Vector2(facing,1)*zoom)
 var height=maxf(1,root.y+hip+7)
 n.draw_texture_rect_region(tex,Rect2(-root,Vector2(tex.get_width(),height)),Rect2(0,0,tex.get_width(),height),tint)
