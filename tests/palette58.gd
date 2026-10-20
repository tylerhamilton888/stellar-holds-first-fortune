extends SceneTree
class Board extends Node2D:
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  HoldArt.text(self,Vector2(30,33),"WHOLE CHARACTER · actual in-game hair colors",22,Color("f2dbac"))
  for gender in 2:
   for col in 4:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":[4,1,2,6][col]})
    var at=Vector2(125+col*235,270+gender*235)
    HoldWholeFrames.paint(self,at,p,Vector2.DOWN,false,0,2.8,Vector2.ZERO)
    HoldWholeFrames.paint(self,at+Vector2(70,0),p,Vector2.RIGHT,false,0,1,Vector2.ZERO,"pick",.6)
    HoldArt.text(self,at+Vector2(-40,20),["Oak","Honey","Copper","Iron grey"][col],14,Color("d8d9c0"))
func _initialize():call_deferred("run")
func run():
 var board=Board.new();board.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(board)
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 DirAccess.make_dir_recursive_absolute("res://docs/testing/whole-0.58.0")
 root.get_texture().get_image().save_png("res://docs/testing/whole-0.58.0/hair-palette.png")
 print("WHOLE PALETTE COMPLETE")
 quit()
