extends SceneTree
var passed=0
var failed=0
func check(v:bool,msg:String):
 if v:passed+=1
 else:failed+=1;push_error(msg)
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=2
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id);HoldAnniversary.prepare(g.state,id,0)
  for k in HoldAnniversary.cost(0,id):g.state.add(k,20)
  HoldAnniversary.deliver(g.state,id,true)
 var money=g.state.money
 g.anniversary_scene=HoldAnniversaryScene.begin(g)
 check(is_instance_valid(g.anniversary_scene),"Scene starts")
 var time=g.state.elapsed;g._process(10)
 check(g.state.elapsed==time,"World pauses throughout exchange")
 var scene=g.anniversary_scene
 scene.age=1
 var next=InputEventKey.new();next.keycode=KEY_SPACE;next.pressed=true;scene._input(next)
 check(scene.step==1,"Space advances one authored beat")
 scene.age=1;scene._input(next)
 check(scene.step==2,"Pacing is player controlled")
 var skip=InputEventKey.new();skip.keycode=KEY_ESCAPE;skip.pressed=true;scene._input(skip)
 check(g.anniversary_scene==null and HoldAnniversary.ensure(g.state).complete,"Escape resolves rather than abandons rewards")
 check(g.state.money==money+50,"Skip grants reward once")
 check(g.room_id=="" and g.zone=="hub" and g.player.y==410,"Return safely to terrace")
 check(g.velocity==Vector2.ZERO and g.jump_buffer==0,"No carried movement or jump")
 await process_frame
 g.anniversary_scene=HoldAnniversaryScene.begin(g);scene=g.anniversary_scene
 scene.step=14;scene.show_line();scene.age=1;scene.advance()
 check(g.state.money==money+50,"Replay ending cannot duplicate payout")
 await process_frame
 g.player=Vector2(535,410);g.interact()
 check(g.panel_id=="anniversary","Tea table interact opens reward page")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("ANNIVERSARY SCENE: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
