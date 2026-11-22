extends RefCounted

static var texture:Texture2D

static func treads()->Texture2D:
 if texture==null:
  var image=Image.new()
  if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://stair/treads.webp"))==OK:
   texture=ImageTexture.create_from_image(image)
 return texture

# The same seam works from either landing, including an immediate reversal.
static func crossed(before:Vector2,after:Vector2,seam:Vector2,half_width:float)->bool:
 if before.y==after.y or (before.y-seam.y)*(after.y-seam.y)>0 or after.y==seam.y:return false
 var x=lerpf(before.x,after.x,(seam.y-before.y)/(after.y-before.y))
 return absf(x-seam.x)<=half_width

static func draw(g,box:Rect2,depth:float):
 var top=box.position
 var size=box.size
 var landing=Rect2(top+size*Vector2(.12,0),size*Vector2(.76,.13))
 g.draw_rect(landing,Color("897c66"))
 g.draw_texture_rect(treads(),Rect2(top+Vector2(0,landing.size.y*.75),size-Vector2(0,landing.size.y*.75)),false)
 # At the upper landing the flight falls away under the near floor edge.
 if depth>0:
  var points=PackedVector2Array([top+size*Vector2(.22,.13),top+size*Vector2(.76,.13),top+size*Vector2(.92,.96),top+size*Vector2(.08,.96)])
  var shade=Color(.065,.076,.078,.82*depth)
  g.draw_polygon(points,PackedColorArray([Color.TRANSPARENT,Color.TRANSPARENT,shade,shade]))
  var lip=Rect2(top+size*Vector2(.04,.94),size*Vector2(.92,.06))
  g.draw_rect(lip,Color(.42,.38,.31,depth))
  g.draw_line(lip.position,Vector2(lip.end.x,lip.position.y),Color(.72,.65,.49,depth),maxf(1,size.y*.017))
