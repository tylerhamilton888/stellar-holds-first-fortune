extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_shade.visible=false;g.transition_left=0
 g.zone="hub";g.state.active_site="hold";g.state.opening=2;g.player=Vector2(625,410);g.camera=Vector2.ZERO;HoldOnboarding.ensure(g.state).stage=6
 for id in ["commission","lesson","social","conversation","anniversary"]:
  g.room_id="commission" if id in ["commission","lesson"] else "tavern" if id=="social" else "forge" if id=="conversation" else "market"
  g.lesson_id="route";g.anniversary_host="orla";g.talk_id="borin";g.state.appearance.gender=0
  g.open_panel(id);g.queue_redraw()
  await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality40/final-"+id+".png")
  var buttons=g.panel.find_child("Responses",true,false)
  assert(buttons!=null)
  for b in buttons.get_children():assert(b.get_global_rect().end.y<500,"Response outside usable screen")
  assert(g.menu_paused)
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("MENUS40: visible responses and paused dialogue verified");quit()
