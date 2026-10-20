extends SceneTree
var failures=0
func _initialize():call_deferred("run")
func run():
 var atlas=HoldSpriteAtlas.new();root.add_child(atlas)
 var view=SubViewport.new();view.size=Vector2i(640,240);view.transparent_bg=true;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(view)
 var painter=Node2D.new();view.add_child(painter)
 var current={"profile":{},"face":1}
 painter.draw.connect(func():
  var p=current.profile
  if p.is_empty():return
  HoldCharacterArt.draw_sprite(painter,Vector2(160,205),0,false,current.face,p,false,Vector2.ZERO,false,1.5,Color("c4c9d3"))
  HoldSpriteAtlas.paint(painter,Vector2(480,205),0,false,current.face,p,false,Vector2.ZERO,-1,Color("c4c9d3"),1.5)
 )
 for gender in 2:
  for armed in [false,true]:
   for face in [-1,1]:
    var p=HoldAppearance.defaults();p.gender=gender;p=HoldAppearance.normalized(p);p.shield_pose=armed;p.shield_guard=false
    current.profile=p;current.face=face;atlas.request(p)
    for i in 4:await process_frame
    painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
    var image=view.get_texture().get_image()
    # Nearest-neighbor 1.5x sampling can differ by one edge pixel after atlas baking.
    var a=image.get_region(Rect2i(0,0,320,240)).get_used_rect()
    var b=image.get_region(Rect2i(320,0,320,240)).get_used_rect()
    if (Vector2(a.position-b.position).abs().x>1 or Vector2(a.position-b.position).abs().y>1 or Vector2(a.size-b.size).abs().x>1 or Vector2(a.size-b.size).abs().y>1):failures+=1;push_error("Cache scale mismatch %s / %s"%[a,b])
    image.save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("scale20-%d-%d-%d.png"%[gender,int(armed),face]))
 print("SCALE20: 8 cached/direct bounds comparisons, %d failures"%failures)
 view.queue_free();atlas.queue_free();await process_frame;quit(1 if failures else 0)
