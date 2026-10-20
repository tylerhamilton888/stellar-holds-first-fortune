extends SceneTree
class Board extends Node2D:
 var gender=0
 var kind="pick"
 var direction=Vector2.RIGHT
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("24393f"))
  draw_string(ThemeDB.fallback_font,Vector2(20,30),"DRAWN CONTACT REVIEW · "+kind+" · "+str(direction),HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("ecd3a0"))
  for row in 2:
   for i in 4:
    var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=row*2;p.hair_color=7;p.beard_color=7;p=HoldAppearance.normalized(p)
    var at=Vector2(100+i*240,245+row*240)
    draw_line(at+Vector2(-60,1),at+Vector2(105,1),Color("527175"),1)
    HoldDrawnAnimation.paint(self,at,p,direction,kind in ["carry_stone","double_mixed","push"],i*.125,1.7,Vector2.ZERO,kind,i/4.0+.01 if kind!="fish" else i)
    draw_circle(at,2,Color("e2c480"))
func _initialize():call_deferred("run")
func run():
 var out="res://docs/testing/animation-0.51.0/poses";DirAccess.make_dir_recursive_absolute(out)
 var board=Board.new();root.add_child(board)
 for gender in 2:
  board.gender=gender
  for kind in ["pick","hammer","lift_stone","carry_stone","double_mixed","push","hoe","water","fish","harvest"]:
   board.kind=kind;board.direction=Vector2.RIGHT;board.queue_redraw()
   for i in 4:await process_frame
   await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/"+str(gender)+"-"+kind+".png")
  for dir in [Vector2.UP,Vector2.DOWN]:
   board.kind="pick";board.direction=dir;board.queue_redraw()
   for i in 4:await process_frame
   await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/"+str(gender)+"-pick-"+str(dir.y)+".png")
 print("POSE REVIEW COMPLETE");board.queue_free();await process_frame;quit()
