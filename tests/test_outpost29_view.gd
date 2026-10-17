extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("outpost29-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=4;g.grounded=true
 g.state.money=4000;g.state.buy_charter("old_delving");g.state.camp_stage=3
 for k in HoldData.ITEMS:g.state.add(k,100)
 for id in HoldOutpost.CREW:HoldOutpost.recruit(g.state,id)
 g.state.outpost.name="Fellcopper Anchorage";g.travel_claim();g.transition_left=0;g.transition_shade.visible=false
 g.state.tech={"metallurgy":true,"automation":true};g.state.ship_stage=1;g.tool=3;g.player=Vector2(1020,410);g.camera=Vector2(540,0)
 g.outpost_tab=0;g.open_panel("manage");await snap("overview")
 g.outpost_tab=1;g.open_panel("manage");await snap("crew")
 g.outpost_tab=2;g.open_panel("manage");await snap("cast")
 g.outpost_tab=3;g.open_panel("manage");await snap("chronicle")
 g.visitor_key="kelvar";g.open_panel("visitor");await snap("kelvar")
 g.close_panel();g.player=Vector2(1740,410);g.camera=Vector2(1040,0);g.open_panel("ship");await snap("ship-plan")
 g.close_panel();g.player=Vector2(1020,410);g.camera=Vector2(540,0);await snap("outpost")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
