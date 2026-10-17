extends SceneTree
class Board extends Node2D:
 var t=0.0
 var armed=false
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("172833"))
  for gender in 2:
   for sculpt in 5:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":5})
    p.shield_pose=armed;p.gait_time=t
    var pos=Vector2(96+sculpt*192,240+gender*240)
    draw_line(pos+Vector2(-72,1),pos+Vector2(72,1),Color("47606a"))
    HoldCharacterArt.draw_sprite(self,pos,t,true,1,p,false,Vector2.ZERO,false,1.7)
    draw_string(ThemeDB.fallback_font,pos+Vector2(-65,35),HoldCharacterDesigns.id(p),HORIZONTAL_ALIGNMENT_LEFT,-1,16)
func _initialize():call_deferred("run")
func snap(path:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality35/"+path+".png")
func run():
 var b=Board.new();root.add_child(b)
 for armed in [false,true]:
  b.armed=armed
  for f in 8:
   b.t=(f+.1)/10;b.queue_redraw();await snap(("armed" if armed else "walk")+str(f))
 b.queue_free();await process_frame
 var cast=load("res://tests/capture_cast32.gd").Board.new();root.add_child(cast);await snap("cast");cast.queue_free();await process_frame
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 var opener=HoldOpeningScene.begin(g,"arrival");g.opening_scene=opener
 for step in [0,2,3,4]:
  opener.step=step;opener.show_line();opener.shot_age=2;opener.queue_redraw();await snap("opening"+str(step))
 opener.finish();await process_frame
 g.enter_room("market");g.player.x=420;g.transition_left=0;g.transition_shade.visible=false;g.queue_redraw();await snap("orla-interior")
 g.room_id="";g.zone="hub";g.player=Vector2(100,410);g.camera=Vector2.ZERO;g.update_hud();g.queue_redraw();await snap("west-edge")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
