extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.state.camp_stage=3
 g.surface.enter("room:wayfarer",Vector2(400,525));settle()
 g.state.add("turnip",2);g.state.add("water",1)
 key(KEY_E);check(g.panel_id=="road_kitchen","E opens the wayside kitchen at its counter")
 await snap("07-kitchen")
 var food=g.state.count("food");var roots=g.state.count("turnip");var water=g.state.count("water")
 button("Cook Turnip");check(g.state.queue.size()==1 and g.state.count("turnip")==roots-2 and g.state.count("water")==water-1,"Kitchen button pays the actual recipe cost")
 g.close_panel();g.state.tick(4);check(g.state.count("food")==food+3,"Kitchen button produces the existing provisions output")
 g.surface.enter("greenfields",HoldRoads.ORDERS.greenfields.p);settle();g.state.money=100
 key(KEY_E);check(g.panel_id=="road_order","E opens the farm's lease and delivery board")
 await snap("08-farm-work")
 button("Lease four");check(g.surface.roads.data().allotment and g.state.money==88,"Lease button grants four permanent beds for its displayed price")
 g.close_panel()
 g.surface.enter("trail",Vector2(1730,700));settle();var h=g.handworks
 var cart={"id":"service-probe-cart","kind":"cart","area":h.context(),"x":1730.0,"y":700.0,"raw":[{"id":977,"kind":"stone","units":3}],"cargo":{"wood":4},"job":{},"hitched":true}
 h.data().facilities.append(cart);h.data().carry.append({"id":978,"kind":"log","units":2})
 g.surface.roads.portal_cooldown=0;Input.action_press("right");await frames(52);Input.action_release("right");settle()
 check(g.surface.area=="claim" and g.state.active_site=="claim" and h.local(cart),"Walking into the claim takes the cart across the site boundary")
 check(cart.raw.size()==1 and cart.raw[0].id==977 and cart.cargo.wood==4 and h.data().carry.size()==1 and h.data().carry[0].id==978,"Site switch preserves both cargo records exactly once")
 g.surface.roads.portal_cooldown=0;Input.action_press("left");await frames(52);Input.action_release("left");settle()
 check(g.surface.area=="trail" and g.state.active_site=="hold" and h.local(cart),"Walking back to Stonebridge returns the same loaded cart")
 check(cart.raw.size()==1 and cart.cargo.wood==4 and h.data().carry.size()==1,"Round trip conserves finished, raw and shoulder cargo")
 print("SERVICE75: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
