extends SceneTree
class Board extends Node2D:
 var gender=0
 var page=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  for row in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":row,"hair_color":[4,1,2,6,0,3,5][row]})
   for col in 12:
    var d=Vector2.RIGHT;var walking=false;var time=0.0;var action="";var phase=0.0
    if page==0:
     if col<4:d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col]
     else:
      walking=true;time=(col%4+.05)*HoldWholeFrames.CYCLE/4
      d=Vector2.RIGHT if col<8 else Vector2.UP
    else:action=["pick","axe","hammer"][col/4];phase=[.05,.3,.6,.9][col%4]
    HoldWholeFrames.paint(self,Vector2(40+col*80,70+row*75),p,d,walking,time,.88,Vector2.ZERO,action,phase)
func _initialize():call_deferred("run")
func run():
 var board=Board.new();board.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(board)
 DirAccess.make_dir_recursive_absolute("res://docs/testing/whole-0.58.0")
 for gender in 2:
  for page in 2:
   board.gender=gender;board.page=page;board.queue_redraw()
   await process_frame;await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png("res://docs/testing/whole-0.58.0/core-%d-%d.png"%[gender,page])
 print("WHOLE CORE ART COMPLETE")
 quit()
