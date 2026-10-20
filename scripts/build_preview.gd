class_name HoldBuildPreview
extends RefCounted
# Draw in world coordinates so preview, grid and committed placement agree.
static func color(valid:bool)->Color:return Color("68e6a0") if valid else Color("ff7b70")
static func grid(n:Node2D,camera:Vector2,step:float,bounds:Rect2):
 var visible=Rect2(camera,Vector2(960,540)).intersection(bounds)
 if not visible.has_area():return
 for x in range(int(ceil(visible.position.x/step)*step),int(visible.end.x)+1,int(step)):
  n.draw_line(Vector2(x,visible.position.y),Vector2(x,visible.end.y),Color(.63,.85,.79,.16 if x%40==0 else .065),1)
 for y in range(int(ceil(visible.position.y/step)*step),int(visible.end.y)+1,int(step)):
  n.draw_line(Vector2(visible.position.x,y),Vector2(visible.end.x,y),Color(.63,.85,.79,.16 if y%40==0 else .065),1)
static func outline(n:Node2D,base:Rect2,valid:bool):
 var tint=color(valid)
 n.draw_rect(base,Color(tint,.12))
 n.draw_rect(base,Color("10262c"),false,4)
 n.draw_rect(base,tint,false,2)
 # Shape and wording also distinguish states without relying on color alone.
 var at=base.position+Vector2(0,-8)
 HoldArt.text(n,at,"PLACE" if valid else "BLOCKED",11,tint)
