extends SceneTree
class Board:
 extends Node2D
 var profiles=[]
 var key=0
 var font=ThemeDB.fallback_font
 func _draw():
  draw_rect(Rect2(0,0,1200,850),Color("183138"))
  draw_string(font,Vector2(24,30),"Named cast batch · native animation playback at 1.5×",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
  for row in 6:draw_string(font,Vector2(15,155+row*128),["Front","Side","Rear quarter","Back","Rest","Drink"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,15)
  for col in profiles.size():
   var p=profiles[col];var x=210+col*215
   draw_string(font,Vector2(x-35,62),str(p.cast_id).capitalize(),HORIZONTAL_ALIGNMENT_LEFT,-1,20)
   for row in 6:
    if row==5 and p.cast_id not in ["sigrid","orla","yrsa"]:continue
    var action="drink" if row==5 else "town_walk";var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][row%4]
    var a=HoldStoryWorld105.descriptor(p,d,row<4,key*.13+.001,action,float([0,1,2,3][key]),HoldWholeFrames.metadata)
    draw_set_transform(Vector2(x,180+row*128),0,Vector2.ONE*1.5)
    draw_texture_rect(HoldWholeFrames.texture(p,a.sheet,a.index),a.destination,false)
    draw_set_transform(Vector2.ZERO)
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(out)
 HoldWholeFrames.cache_directory=out+"/cache-"+str(Time.get_ticks_usec());DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory)
 HoldWholeFrames.data();HoldStoryWorld105.register(HoldWholeFrames.metadata,true)
 var board=Board.new()
 for id in ["sten","orla","sigrid","yrsa","skarrin"]:board.profiles.append(HoldStoryArt105.tag(HoldAppearance.random_profile(7313,0),id))
 root.size=Vector2i(1200,850);root.content_scale_size=root.size;root.add_child(board)
 for key in 4:
  board.key=key;board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/frame-"+str(key)+".png")
 board.queue_free();await process_frame;quit()
