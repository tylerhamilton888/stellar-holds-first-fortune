extends SceneTree
class Board extends Node2D:
 var gender=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  for row in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":row,"hair_color":6})
   for col in 8:
    var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col%4] if col<4 else Vector2.RIGHT
    var action="hold_rifle" if col<4 else "fish";var phase=0 if col<4 else col-4
    var at=Vector2(52+col*118,70+row*75)
    HoldWholeFrames.paint(self,at,p,d,false,0,.82,Vector2.ZERO,action,phase)
    var tip=at+HoldWholeFrames.tool_tip(p,d,action,phase)*.82
    draw_line(tip,tip+Vector2(10,-4),Color("a4ead5"),1)
    draw_circle(tip,1.1,Color("e5f3a2"))
func _initialize():call_deferred("run")
func run():
 var b=Board.new();root.add_child(b)
 for gender in 2:
  b.gender=gender;b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/testing/refinement58/sockets-%d.png"%gender)
 print("REFINEMENT58 SOCKET REVIEW COMPLETE");quit()
