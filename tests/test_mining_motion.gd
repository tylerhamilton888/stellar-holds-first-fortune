extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game)
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.change_zone("mine");game.set_process(false)
 game.transition_left=0;game.transition_shade.visible=false;game.sound.stop_all()
 game.player=Vector2(492,392);game.camera=Vector2(100,140);game.state.opening=1
 for y in range(44,56):
  for x in range(76,84):game.geo.set_cell(Vector2i(x,y),4 if x>77 else 2)
 game.geo.redraw_all=true
 game.face=1;game.tool=0;game.grounded=true
 var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 for frame in 120:
  var dt=.04;game.clock+=dt
  if game.impact_pause>0:game.impact_pause=maxf(0,game.impact_pause-dt)
  else:
   if game.swing<=0:
    var target=Vector2i(-1,-1)
    for x in range(76,84):
     if game.geo.at(x,52)!=0:target=Vector2i(x,52);break
    if target.x>=0:
     game.hit_cell=target;game.hit_point=game.geo.center(target)-Vector2(3.4,0)
     game.swing_duration=.38;game.swing=.38;game.swing_done=false
   game.handle_mining(dt)
  game.geo.tick_materials(dt,Rect2(game.player+Vector2(-11,-60),Vector2(22,60)));game.update_effects(dt);game.shake_amount=maxf(0,game.shake_amount-dt*14)
  game.update_hud();game.footer.text="PICK / CONTACT, CRACK, BREAK, COLLECT"
  game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(out.path_join("mining-%03d.png" % frame))
 print("MINING MOTION: %d blocks broken; %d drops remain" % [game.state.mined,game.drops.size()])
 var ok=game.state.mined>=16 and game.drops.is_empty()
 game.playing=false;game.sound.stop_all();await create_timer(.3).timeout;game.queue_free();await process_frame;quit(0 if ok else 1)
