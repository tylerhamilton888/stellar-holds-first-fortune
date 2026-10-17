class_name HoldJourney
extends RefCounted
# Local simulation spaces share a continuous world-space journey. No fade or
# camera reset is used at their borders. Mine cells remain seven-pixel grains.
const A=preload("res://scripts/art.gd")
static func offset(zone:String)->float:
 return 2000.0 if zone=="approach" else (4000.0 if zone=="mine" else 0.0)
static func floor_y(x:float)->float:return 410.0-18.0*smoothstep(1500.0,2000.0,x)
static func backdrop(n:Node2D,tex:Texture2D,start:float,end:float,camera:Vector2,region:Rect2=Rect2(),fade_out:bool=false):
 if region.size==Vector2.ZERO:region=Rect2(Vector2.ZERO,tex.get_size())
 var left=maxf(0,start-camera.x);var right=minf(960,end-camera.x)
 if right<=left:return
 var width=1728.0;var height=576.0
 # Repeat a broad panorama with continuous parallax instead of stretching its final column.
 for x in range(int(left),int(right),8):
  var w=minf(8,right-x)
  var u=fposmod(x+(camera.x-start)*.35,width)/width
  var source=Rect2(region.position+Vector2(u*region.size.x,0),Vector2(minf(w/width,1-u)*region.size.x,region.size.y))
  var alpha=1.0-smoothstep(1820.0,2120.0,x+camera.x) if fade_out else 1.0
  n.draw_texture_rect_region(tex,Rect2(x,-75-camera.y*.12,w,height),source,Color(1,1,1,alpha))

static func approach(n:Node2D,t:float):
 # Mountain-facing retaining trail, with a gentle descent into the rock mouth.
 for i in 50:
  var x=float(i*40);var y=floor_y(x);var next=floor_y(x+40)
  n.draw_texture_rect_region(HoldTerrainView.ATLAS,Rect2(x,y,40,150),Rect2(28+posmod(i*40,400),240,40,150),Color("798e91"))
  A.poly(n,[Vector2(x,y),Vector2(x+40,next),Vector2(x+40,next+10),Vector2(x,y+10)],"898a79")
  A.line(n,Vector2(x,y+2),Vector2(x+40,next+2),"b2ad92",2)
  if i%3==0:A.line(n,Vector2(x+6,y+18),Vector2(x+33,y+24),"53646a",2)
 for x in [210,730,1310]:
  var y=floor_y(x)
  A.rect(n,x,y-42,5,42,"667a7b");A.rect(n,x-4,y-44,13,6,"ae956c")
  A.rune(n,Vector2(x+2,y-28),.48,Color("9cd5cb"))
 for i in 28:
  var x=90+i*61;var y=floor_y(x)
  if i%3==0:A.poly(n,[Vector2(x,y),Vector2(x+2,y-6),Vector2(x+4,y-1),Vector2(x+9,y-4),Vector2(x+7,y)],"7e8b72")
 # Small windblown motes move across the exposed ledge, never over menus.
 for i in 18:
  var x=fposmod(i*127+t*(26+i%4*8),2000)
  var y=170+posmod(i*71,205)+sin(t+i)*3
  A.line(n,Vector2(x,y),Vector2(x+5,y-1),Color(.8,.9,.9,.2))
 # A simple trail marker belongs to the approach; the adit is cut into actual terrain.
 var lamp_base=floor_y(1915)
 A.rect(n,1913,369,4,lamp_base-369,"667a7b")
 A.rect(n,1908,lamp_base-4,14,4,"8d8d7b")
 A.lamp(n,Vector2(1915,365),t)
 A.text(n,Vector2(1700,345),"OLD WORKINGS  →   [G] MAP",16,Color("d6c39a"))
