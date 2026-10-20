extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("opening31-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 var scene=g.opening_scene;scene.set_process(false);scene.clock=3;scene.age=3;scene.queue_redraw();await snap("arrival-road")
 scene.step=3;scene.show_line();scene.clock=7;scene.queue_redraw();await snap("arrival-hold")
 scene.finish();await process_frame
 g.player=Vector2(1205,410);g.room_id="commission";g.camera=Vector2.ZERO;g.open_panel("commission");await snap("first-foreman")
 var q=HoldOnboarding.ensure(g.state);q.stage=2
 g.room_id="forge";g.open_panel("forge");await snap("meet-borin")
 q.stage=4;g.state.opening=2;g.close_panel();g.room_id="throne";g.player=Vector2(435,410);g.camera=Vector2.ZERO
 await snap("throne-room")
 g.opening_scene=HoldOpeningScene.begin(g,"audience");scene=g.opening_scene;scene.set_process(false);scene.step=3;scene.show_line();scene.queue_redraw();await snap("audience")
 scene.finish();await process_frame
 q.stage=6;g.state.opening=3;g.room_id="commission";g.open_panel("guidance");await snap("journal")
 g.lesson_id="research";g.open_panel("lesson");await snap("research-quest")
 q.done.route=true;HoldOnboarding.accept(g.state,"training");g.room_id="forge";g.enter_room("training");g.close_panel();g.transition_left=0;g.transition_shade.visible=false;g.player=Vector2(550,410);g.grounded=true;g.clock=2;g.combat.spawn();g.combat.enemies[0].state="windup";g.combat.enemies[0].timer=.2
 await snap("practice")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
