extends RefCounted
## Each end shares the traversable cell. The lower ladder stands at the rear of
## the landing so the player can step in front of its feet.
var hatch:Texture2D
var ladder:Texture2D
func load_art(asset:String)->Texture2D:
 var im=Image.new()
 if im.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://quarry/"+asset+".webp"))!=OK:return null
 return ImageTexture.create_from_image(im)
func floor_hatch(g,p:Vector2):
 if hatch==null:hatch=load_art("hatch")
 if hatch==null:return
 var size=Vector2(78,62)
 g.draw_texture_rect(hatch,Rect2(p-Vector2(size.x*.5,size.y-15),size),false,Color("ded8c9"))
func lower_ladder(g,foot:Vector2):
 if ladder==null:ladder=load_art("ladder")
 if ladder==null:return
 var size=Vector2(55,78)
 g.draw_texture_rect(ladder,Rect2(foot-Vector2(size.x*.5,size.y-3),size),false,Color("dcd8c7"))
