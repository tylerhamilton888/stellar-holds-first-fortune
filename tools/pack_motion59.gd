extends SceneTree
# Pack complete, reviewed paintings into uniform animation atlases. No body
# parts are assembled; each draw is one original complete painted figure.
const BASE="res://assets/whole-motion59/"
class Atlas extends Node2D:
 var frames=[]
 var textures={}
 func _draw():
  for i in frames.size():
   var m=frames[i];var r=m.rect;var scale=205.0/m.height
   var at=Vector2((i%4)*320+160,(i/4)*256+244)
   draw_texture_rect(textures[str(i)],Rect2(at+(Vector2(r[0],r[1])-Vector2(m.root[0],m.root[1]))*scale,Vector2(r[2],r[3])*scale),false)
func _initialize():call_deferred("run")
func run():
 var data=JSON.parse_string(FileAccess.get_file_as_string(BASE+"frames.json"))
 for view in ["front","side","quarter","back"]:
  var v=SubViewport.new();v.size=Vector2i(1280,2816);v.transparent_bg=true;v.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(v)
  var b=Atlas.new();v.add_child(b)
  for row in 11:
   for key in 4:
    var source="male0-"+view+"-source";var index=row*4+key
    if view=="back" and row==5 and key==0:index=row*4+2
    if view=="back" and key==3:source="male0-back-right-pass";index=row
    if view=="front" and row>=8:source="male0-front-doubles";index=(row-8)*4+key
    if view=="side" and row in [8,10]:source="male0-side-doubles";index=(0 if row==8 else 8)+key
    if view=="side" and row==9:source="male0-side-double-log";index=key
    if view=="quarter":source="male0-quarter-"+("tools" if row<6 else "carry");index=(row if row<6 else row-6)*4+key
    var m=data[source][index].duplicate(true);var r=m.rect
    if source=="male0-back-right-pass":m.height*=1.10
    var img=Image.load_from_file(BASE+source+".png").get_region(Rect2i(r[0],r[1],r[2],r[3]))
    for span in m.get("omit",[]):img.fill_rect(Rect2i(span[0],span[1],span[2],1),Color.TRANSPARENT)
    b.textures[str(b.frames.size())]=ImageTexture.create_from_image(img);b.frames.append(m)
  b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
  v.get_texture().get_image().save_png(BASE+"male0-"+view+".png")
  v.queue_free();await process_frame
 print("MOTION59 CANONICAL PACK COMPLETE: four views, eleven four-key complete-figure cycles each")
 quit()
