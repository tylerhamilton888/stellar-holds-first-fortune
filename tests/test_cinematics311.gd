extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 var s=g.opening_scene;s.set_process(false)
 s.update_staging(1);check(s.player_x==672 and s.walking,"Arrival walks at fixed world speed")
 var x=s.player_x;s.step=2;s.show_line();check(s.player_x==x,"Entering hold does not teleport actor")
 s.update_staging(20);check(s.player_x==470,"Arrival stops at staging mark")
 s.update_staging(.1);check(not s.walking,"Arrival settles into idle")
 s.finish();await process_frame
 HoldOnboarding.ensure(g.state).stage=4
 g.opening_scene=HoldOpeningScene.begin(g,"audience");s=g.opening_scene;s.set_process(false)
 s.update_staging(2);check(s.player_x==435 and s.ivar_x==295,"Audience entrance settles at marks")
 s.step=1;s.show_line();check(s.player_x==435,"Invitation does not teleport player")
 s.update_staging(.5);check(s.player_x==459,"Player approaches dais with walk")
 s.update_staging(10);check(s.player_x==495,"Player remains clear of throne")
 s.finish();await process_frame
 g.state.outpost.erase("onboarding");g.state.opening=2
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id);HoldAnniversary.prepare(g.state,id,0)
  for k in HoldAnniversary.cost(0,id):g.state.add(k,20)
  HoldAnniversary.deliver(g.state,id,true)
 g.anniversary_scene=HoldAnniversaryScene.begin(g);s=g.anniversary_scene;s.set_process(false)
 check(s.shot_for_beat(0).id=="kettle" and s.shot_for_beat(3).id=="table","Each gift has its own reveal")
 s.step=11;s.show_line();check(s.portrait.profile.gender==1,"Speaking portrait switches to Orla")
 check(s.portrait.viewport.render_target_update_mode==SubViewport.UPDATE_ONCE,"Speaking portrait requests actual texture refresh")
 check(s.shot_for_beat(8).id=="secrets","Player-facing gesture accompanies both secrets line")
 check(s.shot_for_beat(11).id=="steam","Beard reaction accompanies steam line")
 s.step=13;s.show_line();check("from the hall" in s.speaker.text,"Offscreen guest is identified")
 check(s.shot_for_beat(14).id=="toast","Cup invitation shows both mugs")
 var money=g.state.money;s.finish();await process_frame
 check(g.state.money==money+50,"Presentation preserves anniversary reward")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("CINEMATICS311: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
