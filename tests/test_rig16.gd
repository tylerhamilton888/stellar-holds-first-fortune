extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1280,1920);view.disable_3d=true;view.transparent_bg=false;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 root.add_child(view);var canvas=Node2D.new();view.add_child(canvas)
 canvas.draw.connect(func():
  canvas.draw_rect(Rect2(0,0,1280,1920),Color("26313c"))
  for row in 16:
   var p=HoldAppearance.defaults();p.gender=1 if row>=10 else 0;p.beard_style=row if row<10 else 5;p.hair_style=row%6;p.armor=row%3;p.shield_pose=true
   for col in 8:
    p.shield_guard=col>=4
    var origin=Vector2(col*160+80,row*120+110)
    var f=[0,4,2,4,0,1,2,3][col]
    HoldCharacterArt.draw_sprite(canvas,origin,(f+.1)/12.0,col==1,-1 if col==7 else 1,p,col>=2,Vector2.ZERO,false)
 )
 await process_frame;await RenderingServer.frame_post_draw
 view.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("rig16-all.png"))
 view.queue_free();await process_frame;print("RIG16 CONTACT SHEET SAVED");quit()
