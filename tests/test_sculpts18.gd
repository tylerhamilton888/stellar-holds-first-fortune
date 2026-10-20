extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1280,1200);view.disable_3d=true;view.transparent_bg=false;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 root.add_child(view);var canvas=Node2D.new();view.add_child(canvas)
 canvas.draw.connect(func():
  canvas.draw_rect(Rect2(0,0,1280,1200),Color("26313c"))
  for row in 10:
   var p=HoldAppearance.defaults();p.gender=row/5;p.sculpt=row%5;p.hair_color=[1,5,2,6,1,5,2,1,6,5][row];p.beard_color=p.hair_color;p.armor=row%3;p=HoldAppearance.normalized(p)
   for col in 8:
    p.shield_pose=col>=3;p.shield_guard=col>=6
    var origin=Vector2(col*160+80,row*120+110);var f=[0,2,3,0,4,2,1,2][col]
    HoldCharacterArt.draw_sprite(canvas,origin,(f+.1)/12.0,col in [1,4],-1 if row%2 else 1,p,col in [2,5,6,7],Vector2.ZERO,false)
    # Inspection overlay marks the actual standing collision body and feet.
    canvas.draw_rect(Rect2(origin-Vector2(22,76),Vector2(44,76)),Color(.4,.9,.7,.4),false,1)
    canvas.draw_line(origin-Vector2(28,0),origin+Vector2(28,0),Color(.9,.8,.4),1)
 )
 await process_frame;await RenderingServer.frame_post_draw
 view.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("sculpts18.png"))
 view.queue_free();await process_frame;print("SCULPTS17 SAVED");quit()
