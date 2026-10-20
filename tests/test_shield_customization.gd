extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.state.opening=4;game.zone="mine";game.transition_left=0;game.transition_shade.visible=false
 for y in range(34,57):
  for x in range(100,220):game.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 game.player=Vector2(960,392);game.camera=Vector2(510,110);game.combat.enemies=[];game.agents=[]
 var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 for row in 16:
  var p=HoldAppearance.defaults();p.gender=1 if row>=10 else 0;p.hair_style=row%6;p.beard_style=5 if p.gender else row%10
  game.state.appearance=p;game.state.combat.armor=["clothes","mail","rune"][row%3];game.state.combat.weapon="axe";game.combat.armed=true;game.face=1 if row%2==0 else -1
  game.combat.attack_left=game.combat.weapon().time;game.sprite_atlas.request(game.combat.profile());await create_timer(.2).timeout
  for f in 8:
   game.clock=(f+.1)/12.0;game.velocity=Vector2(40,0);game.combat.attack_direction=Vector2(game.face,0)
   game.combat.attack_left=game.combat.weapon().time*(1-(f+.1)/8)
   game.swing=0;game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().get_region(Rect2i(480,230,240,160)).save_png(out.path_join("shield-custom-%02d-%d.png"%[row,f]))
 game.playing=false;game.sound.stop_all();game.queue_free();await create_timer(.5).timeout;print("ALIGNMENT FRAMES SAVED");quit()
