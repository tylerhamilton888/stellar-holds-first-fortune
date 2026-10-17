extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1120,650);view.disable_3d=true;view.transparent_bg=false;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 root.add_child(view);var canvas=Node2D.new();view.add_child(canvas)
 var current={"gender":0,"sculpt":0,"dark":false}
 canvas.draw.connect(func():
  var p=HoldAppearance.defaults();p.gender=current.gender;p.sculpt=current.sculpt;p=HoldAppearance.normalized(p)
  p.hair_color=5 if current.dark else 1;p.beard_color=p.hair_color;p.tattoo=0;p.jewelry=3
  canvas.draw_rect(Rect2(0,0,1120,650),Color("26313c"))
  var font=ThemeDB.fallback_font
  canvas.draw_string(font,Vector2(20,28),HoldCharacterDesigns.id(p)+" / "+(HoldAppearance.FEMALE_SCULPTS if p.gender else HoldAppearance.SCULPTS)[p.sculpt],HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("ecd3a0"))
  for row in 4:
   canvas.draw_string(font,Vector2(12,57+row*145),["WALK — 8 frames","WORK — 8 frames","AXE ATTACK — 8 frames","ARMED WALK — 4 frames             |             GUARD / BLOCK / PARRY / RECOVER"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("abc9c5"))
   for col in 8:
    var origin=Vector2(col*140+68,190+row*145)
    var frame=col
    if row<2:
     p.shield_pose=false;p.shield_guard=false
     HoldCharacterArt.draw_sprite(canvas,origin,(col+.1)/12.0,row==0,1,p,row==1,Vector2.ZERO,false)
    else:
     var mode="combat" if row==2 else ("walk" if col<4 else "guard")
     frame=col if row==2 else (col*2 if col<4 else col-4)
     HoldShieldActor.draw(canvas,origin,frame,1,p,Vector2.ZERO,mode)
    canvas.draw_line(origin-Vector2(40,0),origin+Vector2(40,0),Color("a38a5b"),1)
    canvas.draw_string(font,origin+Vector2(-45,18),str(col),HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("9fb0ba"))
 )
 for gender in 2:
  for design in 5:
   current.gender=gender;current.sculpt=design
   for dark in [false,true]:
    current.dark=dark;canvas.queue_redraw()
    await process_frame;await process_frame;await RenderingServer.frame_post_draw
    view.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("identity19-%d-%d-%s.png"%[gender,design,"dark" if dark else "gold"]))
 view.queue_free();await process_frame;print("IDENTITY19: all 320 unique poses captured in two palettes");quit()
