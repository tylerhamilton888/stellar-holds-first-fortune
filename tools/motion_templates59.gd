extends SceneTree
class Atlas extends Node2D:
 var frames=[]
 var textures=[]
 func _draw():
  for i in frames.size():
   var m=frames[i];var r=m.rect;var scale=205.0/m.height
   var at=Vector2((i%4)*320+160,(i/4)*256+244)
   draw_texture_rect(textures[i],Rect2(at+(Vector2(r[0],r[1])-Vector2(m.root[0],m.root[1]))*scale,Vector2(r[2],r[3])*scale),false)
func _initialize():call_deferred("run")
func run():
 const BASE="res://assets/whole-motion59/"
 var data=JSON.parse_string(FileAccess.get_file_as_string(BASE+"frames.json"))
 for view in ["front","side","quarter","back"]:
  for kind in ["tools","cargo"]:
   var rows=6 if kind=="tools" else 5;var offset=0 if kind=="tools" else 24
   var v=SubViewport.new();v.size=Vector2i(1280,256*rows);v.transparent_bg=true;v.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(v)
   var b=Atlas.new();v.add_child(b);var img=Image.load_from_file(BASE+"male0-"+view+".png")
   for i in rows*4:
    var m=data["male0-"+view][offset+i];var r=m.rect
    var part=img.get_region(Rect2i(r[0],r[1],r[2],r[3]))
    for span in m.get("omit",[]):part.fill_rect(Rect2i(span[0],span[1],span[2],1),Color.TRANSPARENT)
    b.frames.append(m);b.textures.append(ImageTexture.create_from_image(part))
   b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
   v.get_texture().get_image().save_png(BASE+"template-"+view+"-"+kind+".png")
   v.queue_free();await process_frame
 print("MOTION59 TEMPLATES COMPLETE: eight whole-figure layout references")
 quit()
