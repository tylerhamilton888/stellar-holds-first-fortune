extends SceneTree
# Visual evidence uses the same descriptor, extraction and scaling as gameplay.
# Usage: godot --path . --script res://tests/review_story_gait113.gd -- OUTPUT
class Board:
 extends Node2D
 var profile:Dictionary
 var key=0
 var compact=false
 var font=ThemeDB.fallback_font
 func sprite(direction:Vector2,walking:bool,time:float,at:Vector2,zoom:float,action:String="town_walk",phase:float=0):
  var a=HoldStoryWorld105.descriptor(profile,direction,walking,time,action,phase,HoldWholeFrames.metadata)
  draw_set_transform(at,0,Vector2.ONE*zoom)
  draw_texture_rect(HoldWholeFrames.texture(profile,a.sheet,a.index,zoom>2),a.destination,false)
  draw_set_transform(Vector2.ZERO)
 func _draw():
  draw_rect(get_viewport_rect(),Color("183138"))
  if compact:
   draw_string(font,Vector2(24,28),"Edda — four-direction walk · 2×",HORIZONTAL_ALIGNMENT_LEFT,-1,20)
   for view in 4:
    var at=Vector2(160+(view%2)*320,210+int(view/2)*205)
    draw_string(font,at+Vector2(-65,-135),["Front","Side","Rear quarter","Back"][view],HORIZONTAL_ALIGNMENT_LEFT,-1,17)
    sprite([Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view],true,key*.13+.001,at,2)
   return
  draw_string(font,Vector2(24,28),"Edda — whole-frame locomotion review",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
  var directions=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]
  for row in 4:
   var y=180+row*165
   draw_string(font,Vector2(24,y-132),["Front","Side","Rear quarter","Back"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,17)
   for i in 4:
    sprite(directions[row],true,i*.13+.001,Vector2(160+i*210,y),2)
    draw_string(font,Vector2(115+i*210,y+22),["Right forward","Left passing","Left forward","Right passing"][i],HORIZONTAL_ALIGNMENT_LEFT,-1,14)
   sprite(directions[row],false,0,Vector2(970,y),2)
   sprite(directions[row],true,key*.13+.001,Vector2(1130,y),1)
   draw_string(font,Vector2(1075,y+22),"63px",HORIZONTAL_ALIGNMENT_LEFT,-1,14)
func _initialize():call_deferred("run")
func run():
 var args=OS.get_cmdline_user_args()
 if args.size() not in [1,2] or (args.size()==2 and args[1]!="preview"):push_error("Expected output directory and optional preview");quit(1);return
 # Keep art iterations independent of previously cached runtime textures.
 HoldWholeFrames.cache_directory=args[0]+"/cache-"+str(Time.get_ticks_usec())
 DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory)
 HoldWholeFrames.data();HoldStoryWorld105.register(HoldWholeFrames.metadata,true)
 var s=HoldState.new();s.reset(7108)
 var board=Board.new();board.profile=s.npc("road_folk:9")
 board.compact=args.size()==2
 root.content_scale_size=Vector2i(640,440) if board.compact else Vector2i(1200,740)
 root.size=root.content_scale_size;root.add_child(board)
 DirAccess.make_dir_recursive_absolute(args[0])
 for i in 4:
  board.key=i;board.queue_redraw()
  await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(args[0]+"/frame-"+str(i)+".png")
 print("GAIT113: four native captures; visual acceptance is separate")
 board.queue_free();await process_frame;quit()
