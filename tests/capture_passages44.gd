extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw()
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/testing/routes-0.44.0/"+name+".png")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.change_zone("mine");g.close_panel();g.transition_left=0;g.transition_shade.visible=false;g.state.add("wood",10)
 var w=g.deep.world;var c=Deepworks.ENTRY;g.player=Deepworks.center(c);g.camera=g.player-Vector2(480,270);w.survey(g.player)
 g.open_panel("deepworks");await snap("passage-menu");g.close_panel()
 w.carve_stairs(c,"ladder");await snap("ladder-upper")
 g.deep.use_stairs(false);g.transition_left=0;g.transition_shade.visible=false;w.survey(g.player);await snap("ladder-lower")
 g.deep.use_stairs(true);g.transition_left=0;g.transition_shade.visible=false;w.carve_stairs(c);await snap("stair-upgrade")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
