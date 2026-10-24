class_name HoldGrounding
extends RefCounted
const ROCK=preload("res://assets/royal79/bedrock.png")
# Texture crops keep their natural aspect instead of stretching a painted scene.
static func cover(g,texture:Texture2D,dest:Rect2,source:Rect2,tint:Color=Color.WHITE):
 var scale=maxf(dest.size.x/source.size.x,dest.size.y/source.size.y)
 var size=dest.size/scale
 var crop=Rect2(source.get_center()-size*.5,size)
 g.draw_texture_rect_region(texture,dest,crop,tint)
static func pattern(g,texture:Texture2D,dest:Rect2,source:Rect2,width:float=160.0):
 var unit=source.size*(width/source.size.x)
 for y in range(int(floor(dest.position.y/unit.y)),int(ceil(dest.end.y/unit.y))):
  for x in range(int(floor(dest.position.x/unit.x)),int(ceil(dest.end.x/unit.x))):
   var whole=Rect2(Vector2(x,y)*unit,unit);var clip=whole.intersection(dest)
   var crop=Rect2(source.position+(clip.position-whole.position)*(source.size/unit),clip.size*(source.size/unit))
   g.draw_texture_rect_region(texture,clip,crop)
static func backdrop(g,area:String):
 g.draw_set_transform(Vector2.ZERO)
 var drift=Vector2(g.camera.x*.12,fposmod((g.camera.y+HoldTerraces.origin(area).y)*.08,200))
 g.draw_texture_rect_region(ROCK,Rect2(0,0,960,540),Rect2(Vector2(100,80)+drift,Vector2(960,540)),Color("899697"))
 g.draw_set_transform(-g.camera.round())
static func mountain(w):
 # The wards are excavated ledges. Solid rock continues behind their retaining walls.
 var source=Rect2(Vector2.ZERO,ROCK.get_size())
 for rect in [Rect2(-400,-300,480,2250),Rect2(1800,-300,480,2250),Rect2(80,-300,1720,500)]:
  var clip=rect.intersection(Rect2(w.view_camera(),Vector2(960,540)))
  if clip.has_area():
   var pos=Vector2(fposmod(clip.position.x,400),fposmod(clip.position.y,250))
   w.g.draw_texture_rect_region(ROCK,clip,Rect2(pos,clip.size),Color("a0a9a6"))
 HoldMasonryArt.wall(w.g,Rect2(80,145,1720,65))
static func gate_footing(w):
 if w.current_area()!="hearthward":return
 var p=HoldWorldZones.GATE
 # Bedrock lintel and abutments meet the north wall; the opening stays unobstructed.
 cover(w.g,ROCK,Rect2(p-Vector2(155,255),Vector2(310,195)),Rect2(Vector2.ZERO,ROCK.get_size()))
 HoldMasonryArt.wall(w.g,Rect2(p-Vector2(155,60),Vector2(55,80)))
 HoldMasonryArt.wall(w.g,Rect2(p+Vector2(100,-60),Vector2(55,80)))
 HoldWardDesign.plaza(w.g,Rect2(p+Vector2(-65,5),Vector2(130,115)),Color("7c8073"),Color("b19b72"))
static func sign(w,b:Dictionary):
 var id=int(b.get("id",-1));var p=b.p
 if b.has("home"):
  # A small stone household seal is fixed to the doorjamb; names remain in interaction text.
  var r=Rect2(p+Vector2(38,-43),Vector2(19,21))
  w.g.draw_style_box(w.stone_style(Color("897d65")),r)
  var c=r.get_center();var points=PackedVector2Array([c+Vector2(0,-6),c+Vector2(5,0),c+Vector2(0,6),c+Vector2(-5,0),c+Vector2(0,-6)])
  w.g.draw_polyline(points,Color("dbc18b"),1.5);return
 if id not in [7,8,9,12,15,17]:return
 # Wrought bracket, two short chains and a timber signboard attached beside the door.
 var left=p+Vector2(-76,-84)
 w.g.draw_line(left+Vector2(48,-13),left+Vector2(48,12),Color("343e3d"),4)
 w.g.draw_line(left+Vector2(48,-13),left+Vector2(0,-13),Color("343e3d"),4)
 for x in [7,36]:w.g.draw_line(left+Vector2(x,-13),left+Vector2(x,0),Color("bd985c"),2)
 w.g.draw_style_box(w.stone_style(Color("70573b")),Rect2(left,Vector2(44,29)))
 var c=left+Vector2(22,14);var ink=Color("eed39a")
 if id==8:
  w.g.draw_circle(c+Vector2(0,2),8,ink);w.g.draw_arc(c+Vector2(0,-4),7,PI,TAU,12,ink,2);w.g.draw_line(c+Vector2(6,0),c+Vector2(12,-5),ink,4)
 elif id==15:
  w.g.draw_line(c+Vector2(-9,-5),c+Vector2(9,-5),ink,5);w.g.draw_line(c+Vector2(0,-3),c+Vector2(0,7),ink,5);w.g.draw_line(c+Vector2(-7,8),c+Vector2(7,8),ink,3)
 elif id==17:
  w.g.draw_arc(c,9,0,TAU,20,ink,1.5);w.g.draw_line(c-Vector2(0,11),c+Vector2(0,11),ink,1.5);w.g.draw_line(c-Vector2(11,0),c+Vector2(11,0),ink,1.5)
 else:
  w.g.draw_rect(Rect2(c-Vector2(8,8),Vector2(16,16)),ink,false,2)
  for y in [-4,1,6]:w.g.draw_line(c+Vector2(-4,y),c+Vector2(4,y),ink,1.5)
