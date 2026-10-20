extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="hub";g.state.active_site="hold";g.state.opening=2;g.player=Vector2(490,410);g.camera=Vector2.ZERO;g.grounded=true
 for id in HoldInteriors.ROOMS:
  g.room_id=id;g.update_hud();g.queue_redraw()
  await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality41/"+id+".png")
 g.room_id="forge";g.state.opening=1;g.queue_redraw()
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality41/forge-cold.png")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("INTERIORS41: rendered eight rooms and cold forge");quit()
