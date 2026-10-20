extends SceneTree
class Plate extends Node2D:
 var work=false
 func _draw():
  draw_rect(Rect2(0,0,1440,1280),Color("14272e"))
  draw_string(ThemeDB.fallback_font,Vector2(25,35),"COMPLETE DRAWN KEYS / "+("PICK CONTACT" if work else "WALK"),HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("e4c993"))
  for gender in 2:
   for view in 4:
    var d=[Vector2.DOWN,Vector2(1,1),Vector2(1,-1),Vector2.UP][view]
    if work:d=[Vector2.DOWN,Vector2.RIGHT,Vector2.LEFT,Vector2.UP][view]
    for frame in (4 if work else 6):
     var p=HoldAppearance.normalized({"gender":gender,"sculpt":3 if gender==0 else 0,"hair_color":2})
     var at=Vector2(100+frame*(350 if work else 236),190+(gender*4+view)*150)
     HoldFolk.paint(self,at,p,d,not work,float(frame)/6*HoldFolk.CYCLE,1.8,Vector2.ZERO,"pick" if work else "",[.05,.3,.6,.85][frame] if work else 0)
func _initialize():call_deferred("run")
func run():
 root.size=Vector2i(1440,1280);root.content_scale_size=root.size
 var p=Plate.new();root.add_child(p)
 for work in [false,true]:
  p.work=work;p.queue_redraw()
  for i in 3:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/testing/reference-0.54.0/"+("mining-keys" if work else "walk-keys")+".png")
 p.queue_free();await process_frame;quit()
