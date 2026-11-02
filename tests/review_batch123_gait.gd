extends SceneTree
class Board:
 extends Node2D
 var profile={}
 var font=ThemeDB.fallback_font
 func _draw():
  draw_rect(Rect2(0,0,1100,900),Color("183138"))
  draw_string(font,Vector2(24,32),str(profile.cast_id).capitalize()+" · native 62px and enlarged whole poses",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
  for row in 5:
   draw_string(font,Vector2(15,145+row*170),["Rest","Front","Side","Rear quarter","Back"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,16)
   for col in 4:
    var view=col if row==0 else row-1
    var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
    var a=HoldStoryWorld105.descriptor(profile,d,row>0,col*.13+.001,"town_walk",0,HoldWholeFrames.metadata)
    for zoom in [1.0,2.0]:
     draw_set_transform(Vector2(165+col*240+(72 if zoom==2 else 0),205+row*170),0,Vector2.ONE*zoom)
     draw_texture_rect(HoldWholeFrames.texture(profile,a.sheet,a.index),a.destination,false)
    draw_set_transform(Vector2.ZERO)
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(out)
 HoldWholeFrames.cache_directory=out+"/cache-"+str(Time.get_ticks_usec());DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory)
 HoldWholeFrames.data()
 var board=Board.new();root.size=Vector2i(1100,900);root.content_scale_size=root.size;root.add_child(board)
 for id in ["dagr","odrin","osvik","tovan","kelvar"]:
  HoldWholeFrames.metadata[HoldStoryWorld105.PREFIX+id+".webp"]=JSON.parse_string(FileAccess.get_file_as_string(HoldStoryWorld105.PREFIX+id+".json"))
  board.profile=HoldStoryArt105.tag(HoldAppearance.random_profile(7313,0),id)
  board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/"+id+"-gait.png")
 board.queue_free();await process_frame;quit()
