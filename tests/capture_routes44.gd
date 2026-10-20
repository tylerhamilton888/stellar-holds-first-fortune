extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/testing/routes-0.44.0".path_join(""+name+".png"))
func run():
 DirAccess.make_dir_recursive_absolute("res://docs/testing/routes-0.44.0")
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=2;g.grounded=true
 g.room_id="";g.player=Vector2(190,410);g.camera=Vector2.ZERO;g.clock=6
 for k in HoldData.ITEMS:g.state.add(k,50)
 await snap("offers")
 for gender in 2:
  g.state.appearance.gender=gender;g.state.outpost.erase("anniversary")
  g.open_panel("anniversary");await snap("offer-"+str(gender));g.close_panel()
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id,true);HoldAnniversary.prepare(g.state,id,2,true);HoldAnniversary.deliver(g.state,id,true)
 g.room_id="forge";g.player=Vector2(790,410);g.clock=.85
 await snap("forge-contact")
 g.clock=.25;await snap("forge-lift")
 g.clock=6;await snap("forge-rest")
 g.room_id="";g.player=Vector2(1100,410);g.camera=Vector2(650,0);g.clock=.85;await snap("forge-exterior")
 g.camera=Vector2.ZERO
 g.room_id="tavern";g.clock=14;g.player=Vector2(810,410)
 await snap("tavern-drinks")
 g.close_panel();g.room_id="market";g.player=Vector2(480,410);g.anniversary_scene=HoldAnniversaryScene.begin(g)
 var scene=g.anniversary_scene;scene.set_process(false)
 for i in [0,2,3,5,8,10,11,14]:
  scene.step=i;scene.show_line();scene.age=2;scene.clock=2;scene.queue_redraw();await snap("scene-"+str(i))
 scene.finish();await process_frame
 g.clock=14;await snap("tea-table")
 g.open_panel("anniversary");await snap("completed")
 g.close_panel();g.room_id="throne";g.player=Vector2(420,410);g.camera=Vector2.ZERO;g.transition_left=0
 await snap("lord-enthroned")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
