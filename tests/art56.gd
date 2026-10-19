extends SceneTree
var board
var output="res://docs/testing/art-0.56.0"
class Review extends Node2D:
 var page=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263c3e"))
  HoldArt.text(self,Vector2(25,27),"FOLK · drawn pose registration / enlarged and gameplay scale",18,Color("ead2a1"))
  for row in 4:
   var p=HoldAppearance.defaults();p.gender=row%2;p.sculpt=2 if row<2 else 5;p.hair_color=4 if row%2==0 else 2;p=HoldAppearance.normalized(p)
   for col in 6:
    var at=Vector2(85+col*155,153+row*124)
    var action="";var phase=0.0;var walking=false;var d=Vector2.DOWN;var time=col*.52/6
    if page==0:walking=true;d=[Vector2.DOWN,Vector2(1,.5),Vector2(1,-.5),Vector2.UP][row]
    elif page==1:action="pick" if row<2 else "drink";phase=([.1,.32,.6,.9,.32,.6][col] if row<2 else [0,1,2,3,1,2][col]);d=Vector2.RIGHT
    elif page==2:action=["carry_stone","carry_log","double_stone","double_log","push","hammer"][col];phase=.6;walking=true;d=Vector2.RIGHT
    else:p.sculpt=col if page==3 else 6;d=Vector2.DOWN
    draw_line(at+Vector2(-57,2),at+Vector2(57,2),Color("4e6361"),1)
    HoldFolk.paint(self,at,p,d,walking,time,1.6,Vector2.ZERO,action,phase)
    HoldFolk.paint(self,at+Vector2(54,0),p,d,walking,time,.65,Vector2.ZERO,action,phase)
func _initialize():call_deferred("run")
func run():
 if OS.get_cmdline_user_args().size()>0:output=OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 board=Review.new();root.add_child(board)
 for page in 5:
  board.page=page;board.queue_redraw()
  for f in 3:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/poses-%d.png"%page)
 board.queue_free();await process_frame
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for id in ["tavern","forge","home","commission","throne"]:
  g.surface.enter("room:"+id)
  while HoldFolk.warming():HoldFolk.warm_step()
  g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
  g.player=Vector2(490,490);g.camera=g.surface.camera_target();g.update_hud();g.queue_redraw()
  for f in 5:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/room-"+id+".png")
 g.surface.enter("pinewood");g.state.road_trees[0]=0
 g.state.forestry.fell_at["0"]=g.state.elapsed-2;g.state.forestry.logs["0"]=3
 g.player=HoldSurface.TREES[0]+Vector2(24,45);g.surface.direction=Vector2.RIGHT
 g.handworks.data().carry.append({"kind":"log","units":2,"item":"wood","source":"visual-review"})
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
 for remaining in [3,1,0]:
  g.state.forestry.logs["0"]=remaining;g.camera=g.surface.camera_target();g.update_hud();g.queue_redraw()
  for f in 5:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/pinewood-trunk-%d.png"%remaining)
 print("ART REVIEW CAPTURE COMPLETE")
 quit()
