extends SceneTree
func _initialize():call_deferred("run")
func mouse(pressed:bool):
 var event=InputEventMouseButton.new();event.button_index=MOUSE_BUTTON_RIGHT;event.pressed=pressed;Input.parse_input_event(event);Input.flush_buffered_events()
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.zone="mine";game.transition_left=0;game.transition_shade.visible=false;game.state.opening=4
 for y in range(30,60):
  for x in range(100,220):game.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 game.player=Vector2(960,392);game.camera=Vector2(510,110);game.face=1;game.combat.armed=true;game.state.combat.armor="mail";game.state.combat.owned.append("mail")
 var c=game.combat;c.map_key=str(game.geo.seed_value)+"/"+game.state.active_site
 var e={"id":"motion","p":Vector2(1022,392),"home":Vector2(1022,392),"kind":0,"hp":64.0,"max":64.0,"state":"windup","timer":.7,"face":-1,"walk":false,"flash":0.0};c.enemies=[e]
 var parried=false;var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 await create_timer(.4).timeout
 for frame in 64:
  var dt=.05;game.clock+=dt
  if not parried and e.state=="windup" and e.timer<.16:mouse(true)
  if c.riposte>0:parried=true;mouse(false)
  if parried and e.hp>0 and c.attack_left<=0:
   c.attack_left=c.weapon().time;c.attack_hit=false;c.attack_direction=Vector2.RIGHT
  c.update(dt);game.update_effects(dt);game.update_hud();game.footer.text="PARRY → COUNTER → RECOVER SALVAGE";game.queue_redraw()
  await process_frame;await RenderingServer.frame_post_draw
  if frame%2==0:root.get_texture().get_image().save_png(out.path_join("combat-motion-%02d.png" % (frame/2)))
 mouse(false)
 var passed=parried and e.hp<=0 and game.state.combat.health==100 and game.state.count("scrap")==3
 print("Parried: ",parried," Enemy HP: ",e.hp," Player HP: ",game.state.combat.health," Scrap: ",game.state.count("scrap"))
 print("LIVE COMBAT MOTION: ","PASS" if passed else "FAIL")
 # Visible construction audit, all three build types placed through real validation.
 c.enemies=[];c.armed=false;game.state.inventory.wood=40;game.state.inventory.stone=20
 game.player=Vector2(800,392);game.camera=Vector2(650,100);game.construction.selected="stairs_right";game.construction.place(Vector2i(119,55))
 game.player=Vector2(980,392);game.construction.selected="ladder";game.construction.place(Vector2i(139,44))
 game.player=Vector2(1060,392);game.construction.selected="support";game.construction.place(Vector2i(158,55));game.construction.selected=""
 game.update_hud();game.footer.text="V BUILD • STAIRS / PLATFORMS / LADDERS / ROOF BRACES • W/S CLIMB";game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(out.path_join("construction.png"))
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame;quit(0 if passed else 1)
