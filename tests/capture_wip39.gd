extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var passed=0
var failed=0
func check(ok:bool,label:String):
 if ok:passed+=1
 else:failed+=1;push_error(label)
func snap(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/stellar-holds/tools/quality39/"+name+".png")
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="hub";g.room_id="";g.state.active_site="hold";g.state.hold_travel={};g.state.region_travel={};g.state.opening=2
 g.open_panel("world_map");var m=g.overworld;m.set_process(false)
 for level in [0,2]:
  m.change_floor(level*7+3)
  for p in HoldFloorPlan.WIP_DOORS[level]:
   m.floor_pos=p;m.update_info()
   check(m.enter_button.disabled and m.enter_button.text.contains("WIP"),"Unfinished door marked unavailable")
   check(m.info.text.contains("not implemented"),"Unfinished door explanation")
   m.enter_location();check(g.room_id=="" and g.overworld==m,"WIP door cannot enter another room")
  m.floor_pos=Vector2(216,345);m.floor_camera=Vector2(0,85);m.update_info();m.queue_redraw();await snap("wip-floor"+str(level))
 m.toggle_view();m.queue_redraw();await snap("wip-overview")
 m.toggle_view();m.change_floor(1);m.floor_pos=HoldFloorPlan.door(1);HoldOnboarding.ensure(g.state).stage=1;m.update_info()
 check(m.lock_reason(1).contains("reference") and not m.info.text.contains("WIP"),"Playable royal hall retains quest requirement")
 HoldOnboarding.ensure(g.state).stage=4;m.update_info();check(not m.enter_button.disabled,"Royal hall still unlocks")
 g.open_panel("build_status");check(g.menu_paused,"Build status pauses the game");await snap("wip-status")
 g.open_panel("ship");await snap("wip-ship")
 g.open_panel("pause");await snap("wip-pause")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("WIP39: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
