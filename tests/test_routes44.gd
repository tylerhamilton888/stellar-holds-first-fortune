extends SceneTree
var g
var passed=0
var failed=0
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func _initialize():call_deferred("run")
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.change_zone("mine");g.transition_left=0;g.close_panel()
 var w=g.deep.world;var c=Deepworks.ENTRY;g.player=Deepworks.center(c);g.state.add("wood",20);g.state.add("iron",5)
 var wood=g.state.count("wood");w.carve_stairs(c,"ladder")
 check(w.data.links[w.link_key(c,0)].kind=="ladder" and g.state.count("wood")==wood-2,"Timber creates a real paired ladder shaft")
 check(not HoldOnboarding.progress(g.state,"route").ready,"Construction alone does not prove a safe return")
 wood=g.state.count("wood");w.carve_stairs(c,"ladder");check(g.state.count("wood")==wood,"Duplicate ladder spends no materials")
 g.deep.haul.build_cart(g.player);g.deep.haul.toggle_cart(g.player);g.deep.use_stairs(false)
 check(w.depth()==0,"Wheelbarrow cannot traverse a ladder")
 g.deep.haul.toggle_cart(g.player);g.deep.use_stairs(false)
 check(w.depth()==1 and Deepworks.cell(g.player)==c,"Ladder descends at matching physical location")
 check(not HoldOnboarding.progress(g.state,"route").ready,"Descent alone does not satisfy return quest")
 g.deep.use_stairs(true)
 check(w.depth()==0 and HoldOnboarding.progress(g.state,"route").ready,"Returning through passage completes route proof")
 var facts=HoldOnboarding.ensure(g.state).facts.route_tested;g.deep.use_stairs(false);g.deep.use_stairs(true)
 check(HoldOnboarding.ensure(g.state).facts.route_tested==facts,"Repeated trips do not duplicate proof")
 w.carve_stairs(c)
 check(w.data.links[w.link_key(c,0)].kind=="stair" and w.data.links[w.link_key(c,0)].return_tested,"Widening ladder preserves route proof")
 g.deep.haul.toggle_cart(g.player);g.deep.use_stairs(false)
 check(w.depth()==1 and int(g.deep.haul.cart().depth)==1,"Widened stairs carry the wheelbarrow")
 g.deep.use_stairs(true);g.transition_left=0;g.close_panel()
 var e=InputEventKey.new();e.keycode=KEY_X;e.pressed=true;g.deep.input(e)
 check(HoldOnboarding.progress(g.state,"sample").ready,"Below-layer survey satisfies revised geology lesson")
 g.save_game();g.start_game(true);g.close_panel();w=g.deep.world
 check(w.data.links[w.link_key(c,0)].return_tested and HoldOnboarding.progress(g.state,"route").ready,"Passage type and proven route persist through actual save/load")
 var s=HoldState.new();s.reset(44);HoldOnboarding.fact(s,"built")
 check(HoldOnboarding.progress(s,"route").ready,"Legacy built-route credit remains valid")
 print("ROUTES44: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
