extends SceneTree
var g
func _initialize():call_deferred("run")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.save_slot=3;g.state.opening=4;g.state.outpost.onboarding.fresh=false
 var before=g.state.count("coal");g.state.add("coal",7)
 g.surface.enter("trail",Vector2(950,340));g.transition_left=0;g.change_zone("mine")
 var w=g.deep.world;var c=Deepworks.ENTRY+Vector2i.DOWN*2;w.set_cell(c,0);g.player=Deepworks.center(c);w.carve_stairs(c);g.deep.use_stairs(false)
 if w.depth()!=1:push_error("Descent failed");quit(1);return
 g.save_game();g.start_game(true)
 if g.deep.world.depth()!=1 or g.state.count("coal")!=before+7:push_error("Depth/cargo reload failed");quit(1);return
 g.deep.use_stairs(true)
 if g.deep.world.depth()!=0:push_error("Ascent failed");quit(1);return
 g.surface.enter("room:home",Vector2(290,450));g.transition_left=0;g.surface.action("rest");g.surface.move(1.2)
 if not g.state.surface.facts.get("rest",false):push_error("Rest failed");quit(1);return
 print("PACK531: new game, inventory, mine, matching stairs down/up, depth/resource save-reload, home/rest PASS")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;await process_frame;quit()
