extends SceneTree
class Board:
 extends Node2D
 var key=0
 var font=ThemeDB.fallback_font
 func _draw():
  draw_rect(Rect2(0,0,900,1080),Color("183138"))
  draw_string(font,Vector2(24,32),"Alden Pineward & Maren Hearthwell",HORIZONTAL_ALIGNMENT_LEFT,-1,26)
  for col in 2:
   var id=["alden","maren"][col];var p=HoldStoryArt105.tag(HoldAppearance.random_profile(7313,col),id);var x=300+col*360
   draw_texture_rect(HoldStoryArt105.texture(p),Rect2(x-90,58,180,180),false)
   draw_string(font,Vector2(x-100,270),["Huntsman & ridge ranger","Trail cook & seamstress"][col],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
   for row in 6:
    var direction=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][row%4]
    var action="drink" if row==5 else "town_walk"
    var frame=HoldWholeFrames.descriptor(p,direction,row<4,key*.13+.001,action,float(key))
    draw_set_transform(Vector2(x,400+row*128),0,Vector2.ONE*1.65)
    draw_texture_rect(HoldWholeFrames.texture(p,frame.sheet,frame.index),frame.destination,false)
    draw_set_transform(Vector2.ZERO)
  for row in 6:draw_string(font,Vector2(25,370+row*128),["Front","Side","Rear quarter","Back","Rest","Hearth sip"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(out)
 HoldWholeFrames.cache_directory=out+"/cache-"+str(Time.get_ticks_usec());DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory);HoldWholeFrames.data()
 var board=Board.new();root.size=Vector2i(900,1080);root.content_scale_size=root.size;root.add_child(board)
 for k in 4:
  board.key=k;board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/frame-"+str(k)+".png")
 board.queue_free();await process_frame;quit()
