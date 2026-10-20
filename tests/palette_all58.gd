extends SceneTree
class Board extends Node2D:
 var gender=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  for col in 8:HoldArt.text(self,Vector2(15+col*120,22),HoldAppearance.HAIR_NAMES[col],12,Color("f2dbac"))
  for sculpt in 7:
   for hair in 8:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":hair})
    HoldWholeFrames.paint(self,Vector2(58+hair*120,95+sculpt*72),p,Vector2.DOWN,false,0,.95,Vector2.ZERO)
func _initialize():call_deferred("run")
func run():
 var board=Board.new();board.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(board)
 DirAccess.make_dir_recursive_absolute("res://docs/testing/palette-fix58")
 for gender in 2:
  board.gender=gender;board.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/testing/palette-fix58/all-colors-%d.png"%gender)
 print("ALL HAIR COLORS CAPTURE COMPLETE")
 quit()
