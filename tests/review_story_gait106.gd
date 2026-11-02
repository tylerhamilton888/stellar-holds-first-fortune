extends SceneTree
# Developer-only visual proof. Arguments: manifest.json output-directory.
# The manifest supplies whole-frame source rectangles and a fixed origin/scale
# for each view. This captures evidence; it never approves runtime animation.
class Board:
 extends Node2D
 var views:Array=[]
 var key=0
 var font=ThemeDB.fallback_font
 func sprite(view:Dictionary,index:int,at:Vector2,height:float):
  var r=view.frames[index]
  var source_rect=Rect2(r[0],r[1],r[2],r[3])
  var s=height/float(view.height)
  # All four frames share registration, including the original vertical bob.
  var registration=view.origins[index] if view.has("origins") else view.origin
  var origin=Vector2(registration[0],registration[1])
  var target=Rect2(at-origin*s,source_rect.size*s)
  draw_texture_rect_region(view.texture,target,source_rect)
 func _draw():
  draw_rect(get_viewport_rect(),Color("183138"))
  draw_string(font,Vector2(24,28),"Dagna gait review — diagnostic colours; NOT runtime-approved",HORIZONTAL_ALIGNMENT_LEFT,-1,20)
  for row in views.size():
   var v=views[row];var y=210+row*195
   draw_string(font,Vector2(20,y-150),v.label,HORIZONTAL_ALIGNMENT_LEFT,-1,18)
   for i in 4:
    sprite(v,i,Vector2(140+i*210,y),155)
    draw_string(font,Vector2(95+i*210,y+22),["Red contact","Blue passing","Blue contact","Red passing"][i],HORIZONTAL_ALIGNMENT_LEFT,-1,14)
   sprite(v,key,Vector2(1010,y),62)
   draw_string(font,Vector2(950,y+22),"62px loop",HORIZONTAL_ALIGNMENT_LEFT,-1,14)
func _initialize():call_deferred("run")
func run():
 var args=OS.get_cmdline_user_args()
 if args.size()!=2:push_error("Expected manifest and output directory");quit(1);return
 var manifest=JSON.parse_string(FileAccess.get_file_as_string(args[0]))
 var board=Board.new()
 for entry in manifest.views:
  var img=Image.load_from_file(entry.source)
  if img==null or img.is_empty():push_error("Missing gait source");quit(1);return
  entry.texture=ImageTexture.create_from_image(img);board.views.append(entry)
 root.content_scale_size=Vector2i(1200,60+195*board.views.size())
 root.size=root.content_scale_size;root.add_child(board)
 DirAccess.make_dir_recursive_absolute(args[1])
 for i in 4:
  board.key=i;board.queue_redraw()
  await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(args[1]+"/frame-"+str(i)+".png")
 print("GAIT106: four native frames captured; visual acceptance is separate")
 board.queue_free();await process_frame;quit()
