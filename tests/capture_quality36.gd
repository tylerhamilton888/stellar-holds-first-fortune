extends SceneTree
class Board extends Node2D:
 var frame=0
 var palette=5
 var all_designs=false
 var armed=false
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("20323d"))
  if all_designs:
   for gender in 2:
    for sculpt in 5:
     var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":palette});p.shield_pose=armed
     var at=Vector2(96+sculpt*192,230+gender*240)
     draw_line(at+Vector2(-80,1),at+Vector2(80,1),Color("587479"))
     HoldCharacterArt.draw_sprite(self,at,(frame+.1)/20,true,1,p,false,Vector2.ZERO,false,1.7)
     draw_string(ThemeDB.fallback_font,at+Vector2(-70,30),HoldCharacterDesigns.id(p),HORIZONTAL_ALIGNMENT_LEFT,-1,16)
   return
  draw_string(ThemeDB.fallback_font,Vector2(30,35),"WALK REVIEW / RAVEN PALETTE / ACTUAL GAME RENDER",HORIZONTAL_ALIGNMENT_LEFT,-1,19)
  for row in 2:
   var z=1.0 if row==0 else 2.0;var floor_y=175 if row==0 else 440
   draw_line(Vector2(30,floor_y),Vector2(930,floor_y),Color("587479"))
   for i in 30:
    var x=fposmod(i*40-frame*5*z,960)
    draw_line(Vector2(x,floor_y),Vector2(x+8,floor_y),Color("91aca6"),2)
   for gender in 2:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":palette});p.shield_pose=armed
    HoldCharacterArt.draw_sprite(self,Vector2(245+gender*450,floor_y),(frame+.1)/20,true,1,p,false,Vector2.ZERO,false,z)
  draw_string(ThemeDB.fallback_font,Vector2(35,205),"Gameplay scale",HORIZONTAL_ALIGNMENT_LEFT,-1,16)
  draw_string(ThemeDB.fallback_font,Vector2(35,480),"2x inspection / ground ticks move with the 80-unit stride",HORIZONTAL_ALIGNMENT_LEFT,-1,16)
func _initialize():call_deferred("run")
func snap(path):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality36/"+path+".png")
func run():
 var b=Board.new();root.add_child(b)
 for f in 16:b.frame=f;b.queue_redraw();await snap("walk"+str(f))
 b.all_designs=true
 for armed in [false,true]:
  b.armed=armed
  for f in [0,4,8,12]:b.frame=f;b.queue_redraw();await snap(("armed-all" if armed else "all")+str(f))
 b.queue_free();await process_frame
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 g.room_id="";g.zone="hub";g.state.active_site="hold";g.transition_left=0;g.transition_shade.visible=false;g.grounded=true;g.walking_pose=true
 for gender in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":5})
  for f in 32:
   g.player=Vector2(650+f*5,410);g.camera=Vector2(g.player.x-480,0);g.gait_clock=(f+.1)/20;g.clock=f/38.0;g.update_hud();g.queue_redraw();await snap("game"+str(gender*32+f))
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 quit()
