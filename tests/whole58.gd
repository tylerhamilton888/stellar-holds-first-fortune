extends SceneTree
# Native art review, not a game launcher or a shipped feature toggle.
var output="/workspace/scratch/a447fc5d46ab/folk58/review"
class Board extends Node2D:
 var clock=0.0
 var page=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  HoldArt.text(self,Vector2(28,32),"WHOLE FIGURES · first drawn frame study",21,Color("f2d9ad"))
  HoldArt.text(self,Vector2(28,55),"Complete paintings, with head, body, hands and boots in the same frame",14,Color("b6c7bf"))
  for gender in 2:
   for col in 4:
    var at=Vector2(132+col*232,268+gender*228)
    var direction=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col]
    var action="pick" if page==1 else ""
    var phase=[.1,.32,.6,.9][col]
    draw_line(at+Vector2(-93,2),at+Vector2(92,2),Color("5a6c65"),1)
    HoldWholeFolk.paint(self,at+Vector2(-15,0),gender,direction,page==0,clock,2.35,action,phase)
    HoldWholeFolk.paint(self,at+Vector2(68,0),gender,direction,page==0,clock,1,action,phase)
    HoldArt.text(self,at+Vector2(-75,21),(["Front","Side","Rear quarter","Back"] if page==0 else ["Ready","Anticipation","Contact","Recovery"])[col],13,Color("cbd2bd"))
func _initialize():call_deferred("run")
func run():
 if OS.get_cmdline_user_args().size()>0:output=OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 var board=Board.new();board.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(board)
 for gender in 2:
  for view in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]:
   for key in 4:
    var f=HoldWholeFolk.frame(gender,view,true,(key+.05)*HoldWholeFolk.CYCLE/4)
    assert(f.source.size.x>0 and f.source.size.y>0)
    assert(Rect2(Vector2.ZERO,HoldWholeFolk.atlas(f.sheet).get_size()).encloses(f.source))
 for key in 4:
  board.clock=(key+.05)*HoldWholeFolk.CYCLE/4;board.queue_redraw()
  await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/walk-%d.png"%key)
 board.page=1;board.queue_redraw()
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/pick.png")
 board.page=0
 for key in 48:
  board.clock=float(key)/16.0;board.queue_redraw()
  await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/motion-%03d.png"%key)
 print("WHOLE FIGURE STUDY COMPLETE: 32 walk frame registrations, 8 work keys, native captures; production renderer unchanged")
 quit()
