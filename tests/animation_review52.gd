extends "res://tests/input_surface49.gd"
class Board extends Node2D:
 var gender=0
 var phase=.1
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("23373d"))
  draw_string(ThemeDB.fallback_font,Vector2(20,25),"0.52 · DIRECTION / IDENTITY REVIEW · "+("FEMALE" if gender else "MALE"),HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("e2cf9e"))
  for row in 5:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=row;p.hair_color=7;p.beard_color=7;p.cloth_color=3;p=HoldAppearance.normalized(p)
   for col in 4:
    var at=Vector2(115+col*240,129+row*100)
    var direction=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col]
    HoldDirectional.draw(self,at,p,direction,true,phase,1.0)
    draw_string(ThemeDB.fallback_font,at+Vector2(-80,-82),str(row+1)+" / "+["front","side","back diagonal","back"][col],HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("ccd9cc"))
func run():
 output="res://docs/testing/animation-0.52.0/review";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.hotbar.set_process(false);g.hotbar.hide()
 var board=Board.new();root.add_child(board)
 for gender in 2:
  board.gender=gender;board.queue_redraw()
  for i in 10:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/identity-"+str(gender)+".png")
 for phase in [.0,.19,.29]:
  board.phase=phase;board.queue_redraw()
  for i in 4:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/walk-"+str(phase)+".png")
 board.queue_free();await process_frame;g.hotbar.set_process(true);g.hotbar.show()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("room:forge");settle();g.player=Vector2(480,530)
 for phase in [.0,.4,.8,1.2,4.0]:g.clock=phase;await snap("smith-"+str(phase))
 g.surface.enter("room:tavern");settle();g.player=Vector2(480,590)
 for phase in [0.0,13.0,15.0,17.0,19.0]:g.clock=phase;await snap("sip-"+str(phase))
 g.surface.enter("room:throne");settle();g.player=Vector2(480,530);await snap("seated-lord")
 print("ANIMATION52 VISUAL REVIEW COMPLETE");g.playing=false;g.queue_free();await process_frame;quit()
