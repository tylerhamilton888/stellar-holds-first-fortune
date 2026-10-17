extends SceneTree
var failed=0
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game)
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false)
 game.state.opening=4;game.player=Vector2(960,410);game.camera=Vector2(480,0)
 game.state.appearance=HoldAppearance.defaults()
 var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 game.sound.stop_all()
 game.queue_redraw();await process_frame;await process_frame
 await RenderingServer.frame_post_draw
 for mode in 3:
  for frame in 8:
   game.clock=(frame+.1)/(4.0 if mode==2 else 12.0)
   game.velocity.x=100 if mode==0 else 0
   game.swing_duration=.38
   game.swing=.38*(1-(frame+.1)/8.0) if mode==1 else 0
   game.hit_point=game.player+Vector2(55,-20)
   game.update_hud();game.notice="ANIMATION / "+["WALK - EIGHT FRAMES","TOOL STRIKE - EIGHT FRAMES","IDLE - BREATHING AND BLINK"][mode];game.notice_time=3
   game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(out.path_join("motion-%02d.png" % (mode*8+frame)))
 var sheet=game.sprite_atlas.request(game.state.appearance)
 var sheet_image=sheet.get_texture().get_image()
 sheet_image.save_png(out.path_join("player-animation-sheet.png"))
 for row in 4:
  var hashes={}
  for frame in 8:
   var cell=sheet_image.get_region(Rect2i(frame*192,row*128,192,128))
   hashes[hash(cell.get_data())]=true
   # Complete alpha separation between frames guards against clipping/bleeding.
   for y in 128:
    if cell.get_pixel(0,y).a>.01 or cell.get_pixel(191,y).a>.01:failed+=1;break
   for x in 192:
    if cell.get_pixel(x,0).a>.01 or cell.get_pixel(x,127).a>.01:failed+=1;break
  var minimum=1 if row==0 else 6
  if hashes.size()<minimum or (row==0 and hashes.size()!=1):failed+=1
  print("ANIMATION ROW %d: %d distinct image frames" % [row,hashes.size()])
 # The creator can build a different personalized female sheet in the same cache.
 var female=HoldAppearance.random_profile(106,1)
 game.sprite_atlas.request(female);await process_frame;await RenderingServer.frame_post_draw
 var other=game.sprite_atlas.request(female)
 if other==sheet:failed+=1
 other.get_texture().get_image().save_png(out.path_join("female-animation-sheet.png"))
 print("VISUAL ANIMATION CHECK: "+("PASS" if failed==0 else "FAIL"))
 game.playing=false;game.sound.stop_all();await create_timer(.5).timeout;game.queue_free();await process_frame
 quit(1 if failed else 0)
