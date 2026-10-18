extends "res://tests/input_surface49.gd"
func run():
 output="res://docs/testing/animation-0.51.0/final";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 at(Vector2(900,650));var h=g.handworks;h.spawn("stone",g.player,2);key(KEY_E);await frames(30);key(KEY_Q)
 check(h.data().carry.is_empty() and h.data().loose.size()==1 and not h.setting_down.is_empty(),"Set-down drawing has one persistent ground owner")
 await snap("set-down")
 await frames(30);check(h.setting_down.is_empty() and h.objects().size()==1,"Set-down completes without ghost or duplicate cargo")
 key(KEY_E);check(h.data().carry.size()==1 and h.setting_down.is_empty(),"Re-lifting clears the transient set-down pose")
 key(KEY_Q);await frames(30)
 for k in ["wood","iron","stone"]:g.state.add(k,100)
 h.data().skills.mason=8;at(Vector2(1080,850));h.build("wagon",Vector2(1060,810));var wagon=h.data().facilities[0]
 for i in 25:h.spawn("log" if i%2 else "stone",Vector2(1080,820),2)
 h.deposit(wagon)
 check(wagon.raw.size()==24 and h.data().loose.size()==2,"Wagon gathers exactly 24 loads and leaves overflow untouched")
 await snap("loaded-wagon")
 g.open_panel("handworks");await snap("workshop-catalog");g.close_panel()
 g.fieldwork.craft_kit();g.open_panel("fieldwork");await snap("river-root-menu");g.close_panel()
 print("FINAL51: ",passed," passed / ",failed," failed");g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
