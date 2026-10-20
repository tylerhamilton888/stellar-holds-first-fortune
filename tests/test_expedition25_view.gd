extends SceneTree
var game
class Board extends Node2D:
 var time=0.0
 var page=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("142830"))
  if page in [0,3]:
   var colors=[0,1,2,3,4,5,6,7]
   for row in 5:
    for col in 8:
     var p=HoldAppearance.defaults();p.sculpt=row;p.hair_color=colors[col];p.beard_color=colors[col]
     if page==3:
      p.shield_pose=true;p.gait_time=time
      HoldShieldActor.draw(self,Vector2(55+col*118,105+row*102),0,1,p,Vector2.ZERO,"walk",.9)
     else:HoldCharacterArt.draw_sprite(self,Vector2(55+col*118,105+row*102),time,true,1,p,false,Vector2.ZERO,false,.9)
     if row==0:draw_string(ThemeDB.fallback_font,Vector2(12+col*118,15),str(HoldAppearance.HAIR_NAMES[colors[col]]),HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color.WHITE)
  else:
   for i in 10:
    var p=HoldAppearance.defaults();p.gender=i/5;p.sculpt=i%5;p.air_pose=1 if page==2 else 0;p.gait_time=time
    var pos=Vector2(95+(i%5)*183,230+(i/5)*240)
    draw_line(pos+Vector2(-70,1),pos+Vector2(70,1),Color("688476"),2)
    HoldCharacterArt.draw_sprite(self,pos,time,page==1,1,p,false,Vector2.ZERO,false,1.6)
func _initialize():call_deferred("run")
func settle():await process_frame;await process_frame;await RenderingServer.frame_post_draw
func snap(name):await settle();root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("exp25-"+name+".png"))
func run():
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.state.opening=1;game.grounded=true;game.open_panel("world_map");await snap("map")
 for child in game.panel_body.get_children():
  if child is HoldRegionMap:child.selected="workings";child.refresh_info();child.queue_redraw()
 await snap("map-workings")
 game.close_panel();game.zone="mine";game.player=Vector2(500,405);game.camera=Vector2(200,40);game.queue_redraw();await snap("mine")
 game.geo.set_cell(Vector2i(70,60),0);game.queue_redraw();await snap("patch")
 print("CACHE PATCH: cells=",game.terrain_view.patched_cells," rebuilt=",game.terrain_view.rebuilt_chunks)
 assert(game.terrain_view.patched_cells<=5 and game.terrain_view.rebuilt_chunks==0)
 game.visible=false;game.ui.visible=false
 var board=Board.new();root.add_child(board);await snap("colors")
 board.page=1
 for i in 8:board.time=(i+.1)/12;board.queue_redraw();await snap("walk-"+str(i))
 board.page=2;board.queue_redraw();await snap("jump")
 board.page=3;board.queue_redraw();await snap("armed-colors")
 game.visible=true;game.ui.visible=true;board.visible=false;game.show_title();game.open_panel("save_slots");await snap("save-slots")
 game.playing=false;game.sound.stop_all();game.queue_free();board.queue_free();await process_frame;quit()
