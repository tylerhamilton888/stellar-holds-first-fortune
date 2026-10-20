extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("culture30-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=2;g.grounded=true
 for k in HoldData.ITEMS:g.state.add(k,50)
 for gender in 2:
  g.state.appearance.gender=gender;g.state.appearance=HoldAppearance.normalized(g.state.appearance)
  g.state.outpost.erase("culture")
  g.room_id="market" if gender else "tavern";g.player=Vector2(625,410);g.camera=Vector2.ZERO
  g.open_panel("social");await snap("female-offer" if gender else "male-offer")
  HoldCulture.accept(g.state);g.refresh_panel();await snap("female-deliver" if gender else "male-deliver")
  HoldCulture.complete(g.state,"orla" if gender else "hedrik");g.refresh_panel();await snap("female-complete" if gender else "male-complete")
 g.visitor_key="yrsa";g.open_panel("visitor");await snap("yrsa")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
