extends SceneTree
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.state.opening=4;game.zone="mine";game.transition_left=0;game.transition_shade.visible=false;game.clock=4
 # Controlled chamber for readable contact, equipment and facing audits.
 for y in range(34,57):
  for x in range(100,220):game.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 game.player=Vector2(960,392);game.camera=Vector2(510,110);game.face=1;game.combat.armed=true
 game.combat.map_key=str(game.geo.seed_value)+"/"+game.state.active_site
 game.combat.enemies=[{"id":"visual","p":Vector2(1024,392),"home":Vector2(1024,392),"kind":0,"hp":64.0,"max":64.0,"state":"windup","timer":.5,"face":-1,"walk":false,"flash":0.0},{"id":"visual2","p":Vector2(1270,392),"home":Vector2(1270,392),"kind":1,"hp":56.0,"max":56.0,"state":"idle","timer":0.0,"face":-1,"walk":false,"flash":0.0}]
 game.state.combat.owned=["axe","hammer","gun","clothes","mail","rune"]
 var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 for i in 6:
  game.state.appearance.gender=i/3;game.state.appearance.beard_style=0 if i<3 else 5;game.state.appearance.hair_style=0 if i<3 else 1
  game.state.combat.weapon=["axe","hammer","gun"][i%3];game.state.combat.armor=["clothes","mail","rune"][i%3]
  game.combat.attack_direction=Vector2.RIGHT;game.combat.guard=i%3==0;game.combat.parry_left=.1 if i%3==0 else 0
  game.combat.attack_left=game.combat.weapon().time*.48 if i%3==1 else 0
  game.sprite_atlas.request(game.combat.profile());await create_timer(.4).timeout
  game.update_hud();game.footer.text="COMBAT EQUIPMENT AUDIT — "+game.combat.weapon().name;game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(out.path_join("combat-%d.png" % i))
 game.open_panel("equipment");await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(out.path_join("equipment.png"))
 game.close_panel();game.zone="hub";game.state.tracked_npc="ivar";game.player=Vector2(970,410);game.camera=Vector2(490,0);game.update_hud();game.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(out.path_join("tracking.png"))
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame;print("COMBAT VISUALS SAVED");quit()
