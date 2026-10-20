extends "res://tests/input_readability48.gd"
func run():
 output="res://docs/testing/style-0.49.2";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("room:tavern");settle()
 for phase in [0.0,13.0,15.0,17.0,19.0]:
  g.clock=phase;await snap("tavern-"+str(int(phase)))
 check(HoldNpcActivity.sip_amount(0)==0 and HoldNpcActivity.sip_amount(15)==1 and HoldNpcActivity.sip_amount(19)==0,"Drinking has resting, raised sip and lowered states")
 check(is_equal_approx(HoldNpcActivity.sip_amount(13),HoldNpcActivity.sip_amount(17)),"Lift and lowering remain smooth and symmetric")
 var p=g.state.npc("hedrik");var right=HoldDirectional.hand(p,Vector2(1,.45),-1,1,2.4);var left=HoldDirectional.hand(p,Vector2(-1,.45),-1,1,2.4)
 check(is_equal_approx(right.x,-left.x) and is_equal_approx(right.y,left.y),"Tankard grip mirrors with the same directional character rig")
 g.surface.enter("trail",Vector2(950,340));settle();g.surface.action("mine");settle()
 g.deep.haul.bucket().clear();check(not g.deep.bucket_visible(),"Empty bucket is not rendered beside an empty-handed Dwarf")
 await snap("mine-empty-hands")
 g.deep.haul.bucket().stone=4;check(g.deep.bucket_visible(),"Actual cargo can show its container");await snap("mine-loaded-bucket")
 g.deep.strike_left=.2;check(not g.deep.bucket_visible(),"Mining pose has no floating secondary bucket")
 g.deep.strike_left=0;g.handworks.spawn("stone",g.player,1,"test");g.handworks.data().carry.append(g.handworks.data().loose.pop_back())
 check(not g.deep.bucket_visible() and g.deep.haul.bucket().stone==4,"Shoulder load hides conflicting bucket without losing cargo")
 print("TAVERN492: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
