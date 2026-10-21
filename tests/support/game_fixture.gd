extends SceneTree
var g
var passed=0
var failed=0
var output="user://test-results"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():
 while not g.surface.stair_trip.is_empty():g.surface.tick_stair(.05)
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.physical_keycode=k;e.pressed=true;g._unhandled_input(e)
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func snap(name:String):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud();g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func at(p:Vector2):g.player=p;g.camera=g.surface.camera_target();g.notice_time=0
func button(prefix:String):
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.begins_with(prefix) or b.text.trim_prefix("◆  ").trim_prefix("›  ").begins_with(prefix):b.pressed.emit();return
 failed+=1;push_error("Missing button "+prefix)
