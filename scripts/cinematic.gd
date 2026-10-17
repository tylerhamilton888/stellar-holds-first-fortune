class_name HoldCinematic
extends RefCounted
# Atmosphere stays behind the actors; captions and input remain untransformed.
static func atmosphere(n:Node2D,t:float,warm:bool=true):
 for i in 18:
  var x=fposmod(i*137.3+t*(2.0+i%3),960.0)
  var y=95+fposmod(i*43.7-t*(1+i%2),290.0)
  var alpha=(.025+.045*(.5+.5*sin(t*.7+i)))
  n.draw_circle(Vector2(x,y),.7 if i%3 else 1.2,Color(1,.78,.46,alpha) if warm else Color(.73,.86,.94,alpha))
 for i in 12:
  n.draw_rect(Rect2(i*3,74,3,340),Color(0,0,0,.10*(1-i/12.0)))
  n.draw_rect(Rect2(957-i*3,74,3,340),Color(0,0,0,.10*(1-i/12.0)))
static func shadow(n:Node2D,p:Vector2,width:float=31):
 n.draw_set_transform(p,0,Vector2(1,.17))
 n.draw_circle(Vector2.ZERO,width,Color(0,0,0,.20))
 n.draw_set_transform(Vector2.ZERO)
static func focus(n:Node2D,p:Vector2):
 # A quiet brass lozenge identifies the speaker without bouncing above their head.
 n.draw_colored_polygon(PackedVector2Array([p+Vector2(0,-3),p+Vector2(5,0),p+Vector2(0,3),p+Vector2(-5,0)]),Color("d8b477"))
static func progress(n:Node2D,index:int,total:int):
 for i in total:
  n.draw_rect(Rect2(28+i*14,69,9,2),Color("d8b477") if i<=index else Color("42505b"))
