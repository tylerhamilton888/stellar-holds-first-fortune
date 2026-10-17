extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
func _initialize():call_deferred("run")
func snap(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/stellar-holds/tools/quality39/"+name+".png")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="hub";g.state.opening=2;g.state.active_site="hold";g.room_id="throne";g.player=Vector2(500,410);g.grounded=true;g.camera=Vector2.ZERO
 HoldOnboarding.ensure(g.state).stage=4;g.opening_scene=HoldOpeningScene.begin(g,"audience");var scene=g.opening_scene;scene.set_process(false);scene.step=1;scene.show_line();scene.shot_age=2;scene.player_x=495;scene.queue_redraw();await snap("royal-audience")
 scene.finish();await process_frame
 HoldOnboarding.ensure(g.state).stage=6;g.room_id="market";g.player=Vector2(625,410);g.update_hud()
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id,true);HoldAnniversary.prepare(g.state,id,1,true)
  for k in HoldAnniversary.cost(0,id):g.state.add(k,HoldAnniversary.cost(0,id)[k])
  HoldAnniversary.deliver(g.state,id,true)
 g.anniversary_host="orla";g.open_panel("anniversary");g.queue_redraw();await snap("orla-invites")
 g.anniversary_scene=HoldAnniversaryScene.begin(g);var exchange=g.anniversary_scene;exchange.set_process(false);exchange.step=3;exchange.show_line();exchange.age=1;exchange.queue_redraw();await snap("gift-exchange");exchange.finish();await process_frame
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
