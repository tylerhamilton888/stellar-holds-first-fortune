extends SceneTree
var output="res://docs/testing/whole-0.58.0/grips"
class Review extends Node2D:
 var view=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263c3e"))
  HoldArt.text(self,Vector2(22,25),"EQUIPPED GRIPS · male/female · rest/walk · view "+str(view),17,Color("ead2a1"))
  for row in 4:
   var p=HoldAppearance.normalized({"gender":row%2,"sculpt":0,"hair_color":4 if row%2==0 else 2})
   for col in 6:
    var at=Vector2(70+col*155,145+row*125)
    var action="hold_"+["pick","shovel","axe","hammer","supply","rifle"][col]
    var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
    HoldFolk.paint(self,at,p,d,row>=2,col*.13,1.7,Vector2.ZERO,action)
    HoldFolk.paint(self,at+Vector2(61,0),p,d,row>=2,col*.13,.70,Vector2.ZERO,action)
func _initialize():call_deferred("run")
func run():
 if not OS.get_cmdline_user_args().is_empty():output=OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 var board=Review.new();root.add_child(board)
 for view in 4:
  board.view=view;board.queue_redraw()
  for f in 3:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/grips-%d.png"%view)
 board.queue_free();await process_frame
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim")
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
 for pair in [[0,"pick"],[1,"spade"],[2,"axe"],[3,"hammer"],[6,"stone"],[8,"water"]]:
  g.state.add("stone",5);g.state.add("water",5);g.hotbar.select(pair[0],false)
  g.player=Vector2(680,850);g.surface.direction=Vector2(1,.4);g.walking_pose=true;g.gait_clock=.18
  g.camera=g.surface.camera_target();g.update_hud();g.queue_redraw()
  for f in 4:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/world-"+pair[1]+".png")
 print("WHOLE58 GRIP REVIEW COMPLETE")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
