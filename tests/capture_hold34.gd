extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name:String):
 g.transition_left=0;g.transition_shade.visible=false
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/hold34/"+name+".png")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 g.skip_arrival=true;g.start_game(false);g.close_panel();g.state.tracked_npc="ivar"
 g.player=Vector2(535,410);g.grounded=true;g.open_panel("world_map")
 await snap("hold-map")
 g.overworld.change_floor(15);g.overworld.floor_pos=HoldFloorPlan.door(15);g.overworld.enter_location();await snap("forge-arrival")
 g.player.x=115;g.leave_room();await snap("forge-return")
 g.overworld.change_floor(20);g.overworld.use_portal(20);await snap("lift")
 g.overworld.lift_choice.queue_free();g.overworld.lift_choice=null;g.overworld.toggle_view();await snap("hold-overview")
 g.close_panel();g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
