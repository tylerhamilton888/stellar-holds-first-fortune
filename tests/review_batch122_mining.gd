extends SceneTree
class Board:
 extends Node2D
 var profile={}
 var font=ThemeDB.fallback_font
 func _draw():
  draw_rect(Rect2(0,0,1000,850),Color("183138"))
  draw_string(font,Vector2(25,32),"Brann · corrected mining swing · actual game renderer",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
  for k in 4:draw_string(font,Vector2(170+k*220,65),["Ready","Raised","Impact","Recover"][k],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
  for v in 3:
   draw_string(font,Vector2(12,160+v*250),["Front","Side","Back"][v],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
   for k in 4:
    var a=HoldWholeFrames.descriptor(profile,[Vector2.DOWN,Vector2.RIGHT,Vector2.UP][v],false,0,"pick",[0.0,.3,.6,.85][k])
    var tex=HoldWholeFrames.texture(profile,a.sheet,a.index)
    draw_set_transform(Vector2(195+k*220,270+v*250),0,Vector2.ONE*2.5)
    draw_texture_rect(tex,a.destination,false)
    draw_set_transform(Vector2(125+k*220,270+v*250))
    draw_texture_rect(tex,a.destination,false)
    draw_set_transform(Vector2.ZERO)
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(out)
 HoldWholeFrames.cache_directory=out+"/cache-"+str(Time.get_ticks_usec());DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory)
 HoldWholeFrames.data()
 var board=Board.new();board.profile=HoldStoryArt105.tag(HoldAppearance.random_profile(7313,0),"brann")
 root.size=Vector2i(1000,850);root.content_scale_size=root.size;root.add_child(board)
 await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/mining.png")
 board.queue_free();await process_frame;quit()
