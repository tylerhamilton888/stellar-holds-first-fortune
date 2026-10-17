extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var g
var output="user://pinewood-review"
func _initialize():call_deferred("run")
func snap(name:String):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 for arg in OS.get_cmdline_user_args():
  if arg.begins_with("--output="):output=arg.trim_prefix("--output=")
 DirAccess.make_dir_recursive_absolute(output)
 g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 g.transition_left=0;g.transition_shade.visible=false;g.state.opening=4;g.zone="road";g.room_id="";g.grounded=true;g.tool=2;g.notice_time=0;g.player=Vector2(265,410)
 g.camera=Vector2.ZERO;HoldForestry.ensure(g.state);await snap("arrival")
 g.player=Vector2(355,410);g.forest_target=HoldForestry.target(g,Vector2(420,375));g.hit_point=g.forest_target.p;g.face=1;g.swing_duration=.38;g.swing=.38*.45;g.swing_done=true
 await snap("axe-contact")
 for i in 8:HoldForestry.strike(g,g.forest_target)
 g.swing=0;g.particles.clear();g.popups.clear();g.shake_amount=0;g.notice_time=0
 var start=g.state.elapsed
 for frame in 12:
  g.state.elapsed=start+frame*.1;await snap("fall-%02d" % frame)
 g.state.elapsed=start+2;g.player.x=HoldForestry.log_x(g.state,0)-27
 g.forest_target=HoldForestry.target(g,Vector2(HoldForestry.log_x(g.state,0),399))
 g.hit_point=g.forest_target.p;g.face=g.forest_target.face;g.swing=.38*.45;await snap("log-contact")
 g.swing=0;g.player.x=1390;g.camera.x=1040;await snap("east-coupe")
 g.player.x=190;g.camera.x=0;g.interact();await snap("field-board")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
