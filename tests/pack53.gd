extends SceneTree
var g
func _initialize():call_deferred("run")
func capture(name:String):
 g.queue_redraw()
 for i in 5:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR")+"/"+name+".png")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;g.state.outpost.onboarding.fresh=false;g.state.outpost.onboarding.accepted.training=true
 g.surface.enter("room:practice");g.enter_room("training");g.transition_left=0;g.transition_shade.visible=false;g.fight.spawn();g.player=Vector2(500,450);g.camera=g.surface.camera_target()
 var e=g.fight.enemies[0];e.p=Vector2(570,450);e.state="windup";e.dir=Vector2.LEFT;e.time=.4
 g.fight.aim=Vector2.RIGHT;g.fight.guard=true;g.fight.parry=.12
 await capture("practice")
 g.fight.guard=false;g.fight.swing=.27;g.fight.locked_aim=Vector2.RIGHT
 await capture("strike")
 g.surface.enter("room:home",Vector2(290,450));g.transition_left=0;g.transition_shade.visible=false;g.surface.action("rest");g.surface.move(.5)
 await capture("rest")
 g.surface.move(.7)
 if not g.state.surface.facts.get("rest",false):push_error("Exported rest failed");quit(1);return
 print("PACK53: exported top-down practice, held equipment, strike and completed rest rendered")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;await process_frame;quit()
