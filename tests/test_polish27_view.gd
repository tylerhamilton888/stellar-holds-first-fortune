extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("polish27-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1;g.grounded=true
 g.open_panel("world_map");g.overworld.marker=Vector2(g.overworld.river_x(740),740);g.overworld.camera=g.overworld.marker-Vector2(480,270);await snap("bridge")
 g.overworld.marker=g.overworld.nodes.forest.p+Vector2(0,35);g.overworld.camera=(g.overworld.marker-Vector2(480,270)).clamp(Vector2.ZERO,g.overworld.WORLD-Vector2(960,540));await snap("woodland")
 g.close_panel();g.zone="hub";g.player=Vector2(1000,410);g.camera=Vector2(520,0);g.update_hud();await snap("hold")
 g.zone="mine";g.player=Vector2(140,392);g.camera=Vector2(-160,20);g.update_hud();await snap("entrance")
 g.player=Vector2(440,392);g.camera=Vector2(100,115);g.tool=0;g.face=1;g.grounded=true
 g.geo.cells.fill(0);g.geo.damage={};g.geo.structures=[];g.geo.timbers={};g.geo.mountain={};g.geo.redraw_all=true
 for y in range(56,120):
  for x in range(0,180):g.geo.set_cell(Vector2i(x,y),2)
 for x in range(72,100):
  for y in range(24,56):g.geo.set_cell(Vector2i(x,y),4 if x>76 else 2)
 g.hit_cell=Vector2i(72,51);g.hit_point=g.contact_point(g.hit_cell);g.swing_duration=.38
 for frame in 8:
  g.swing=.38*(1-(frame+.1)/8.0);g.swing_done=frame>=4
  if frame==4:g.hit_terrain()
  g.update_hud();await snap("strike-"+str(frame))
 g.swing=0;g.geo.generate(7342);g.geo.redraw_all=true
 var deposit=g.geo.mountain.geodes[0];var center=Vector2(deposit.x,deposit.y)*7
 for x in range(int(deposit.x)-25,int(deposit.x)-3):
  for y in range(int(deposit.y)-5,int(deposit.y)+7):g.geo.set_cell(Vector2i(x,y),0)
 g.player=center+Vector2(-75,42);g.camera=center-Vector2(430,270);g.reveal_discoveries();g.grounded=false
 for i in 160:g.move_player_step(1.0/120)
 g.update_hud();await snap("geode")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
