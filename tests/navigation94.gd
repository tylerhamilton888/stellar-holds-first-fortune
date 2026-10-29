extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world;var nav=g.depth_nav;nav.explore.mouse_look=false
 for z in [0,1]:
  w.layer(z).features=[];w.layer(z).seen.clear();w.layer(z).encounters=[];w.layer(z).encounter_companions={}
  for y in range(14,27):
   for x in range(14,29):w.set_cell(Vector2i(x,y),0,z);w.layer(z).seen[Deepworks.key(Vector2i(x,y))]=true
 w.rebuild_landmarks();w.data.depth=0;g.player=Deepworks.center(Vector2i(20,23));w.survey(g.player)
 w.carve_stairs(Vector2i(23,20));w.layer(0).fixtures["19,20"]="lamp"
 var original=g.player;var items=g.state.inventory.duplicate(true);var save_before=w.data.duplicate(true)
 key(KEY_Z);check(g.panel_id=="depth_map" and g.menu_paused,"Z opens paused mine navigation")
 key(KEY_PAGEDOWN);check(nav.viewed==1 and w.depth()==0 and g.player==original,"Browsing another floor never moves the dwarf")
 await snap("depth-map")
 check(g.panel.get_global_rect().end.y<=540 and g.menu_scroll.get_v_scroll_bar().max_value<=g.menu_scroll.size.y+1,"Floor selector, map and controls fit the book")
 nav.route_to(Vector2i(25,18),1);g.refresh_panel();await snap("route-map")
 check(not nav.path.is_empty() and nav.path.any(func(p):return p.z==1) and nav.hint().contains("E down"),"Cross-floor route follows actual stair connections")
 check(w.data==save_before and g.state.inventory==items,"Map and route inspection do not alter exploration, supplies or stair state")
 nav.route_to(Vector2i(60,50),1);check(nav.path.is_empty(),"Unexplored destination cannot reveal a route")
 nav.route_to(Vector2i(25,18),1);key(KEY_Z)
 nav.update(0);await snap("overhead-route")
 key(KEY_F6);nav.update(0);await snap("exploration")
 check(nav.explore.active() and is_instance_valid(nav.explore.camera),"F6 enables real 3D camera presentation")
 check(g.player==original and w.depth()==0 and g.state.inventory==items,"Changing presentation preserves position, floor and inventory")
 var p=nav.explore.camera.unproject_position(nav.explore.point(g.player))
 var hit=Plane(Vector3.UP,0).intersects_ray(nav.explore.camera.project_ray_origin(p),nav.explore.camera.project_ray_normal(p))
 check(Vector2(hit.x,hit.z).distance_to(g.player/40)<.01,"Camera ray maps the displayed dwarf back to authoritative ground coordinates")
 key(KEY_BRACKETRIGHT);nav.update(0);await snap("exploration-turn")
 check(nav.explore.movement(Vector2.UP).distance_to(Vector2.LEFT)<.01,"Movement follows the rotated camera")
 g.combat.armed=true;HoldWorkEnergy.data(g.state).energy=0;g.fight.dodge=0;g.fight.dodge_wait=0
 Input.action_press("up");key(KEY_SPACE);Input.action_release("up")
 check(g.fight.dodge>0 and g.fight.dodge_vector.distance_to(Vector2.LEFT)<.01,"Zero-energy dodge follows camera-relative movement")
 g.fight.cancel_actions();g.combat.armed=false
 # Actual mouse projection selects and strikes the same saved rock face.
 nav.explore.yaw=0;nav.explore.invalidate();g.hotbar.select(0);HoldWorkEnergy.rest(g.state)
 var face=Vector2i(21,23);w.set_cell(face,2);w.layer().damage.erase(Deepworks.key(face));nav.update(0)
 var cursor=nav.explore.camera.unproject_position(nav.explore.point(Deepworks.center(face)))
 root.warp_mouse(cursor*root.get_visible_rect().size/Vector2(960,540));await process_frame;await process_frame
 check(Deepworks.cell(g.world_mouse())==face,"Exploration cursor selects the intended world tile")
 g.mining_buffer=.1;g.deep.mine(.01)
 check(g.deep.target==face and g.deep.strike_left>0,"Real mining input begins a planted strike in exploration")
 g.deep.mine(.4)
 check(float(w.layer().damage.get(Deepworks.key(face),0))>0 and g.player==original,"Projected mining reaches actual contact without moving the dwarf")
 nav.update(0);await snap("exploration-mining")
 g.deep.strike_left=0;g.deep.contact_hold=0;w.set_cell(face,0);nav.explore.invalidate()
 # The original survey and construction workflows remain visible.
 key(KEY_X);nav.update(0);await snap("exploration-survey");check(g.deep.survey_open,"X retains the geological survey in exploration");key(KEY_X)
 g.handworks.placing="stone_pile";nav.update(0)
 check(not nav.explore.active() and nav.explore.enabled,"Precise construction temporarily uses overhead without losing preference")
 g.handworks.placing="";nav.update(0);check(nav.explore.active(),"Ending placement restores the chosen exploration view")
 var enemy=g.fight.make_enemy("navigation94/goblin",g.player+Vector2(70,-20),0);enemy.state="windup";enemy.dir=(g.player-enemy.p).normalized();enemy.time=.5;g.fight.enemies=[enemy];g.fight.key=g.handworks.context()
 g.combat.armed=true;g.fight.aim=(enemy.p-g.player).normalized();HoldWorkEnergy.data(g.state).energy=0;nav.update(0);await snap("exploration-combat")
 check(nav.explore.effects.get_child_count()>=2 and nav.explore.sprite_pool["enemy:"+str(enemy.id)].visible,"Live enemy and committed attack cone are rendered in exploration")
 var enemy_cursor=nav.explore.camera.unproject_position(nav.explore.point(enemy.p)+Vector3.UP*.8)
 root.warp_mouse(enemy_cursor*root.get_visible_rect().size/Vector2(960,540));await process_frame;await process_frame;g.fight.update(0)
 check(g.fight.aim.dot((enemy.p-g.player).normalized())>.99,"Mouse combat aim follows the visible enemy at body height")
 var hp=enemy.hp;g.fight.strike();g.fight.update(.4)
 check(enemy.hp<hp and HoldWorkEnergy.data(g.state).energy==0,"Actual exploration combat damages enemies at zero work energy")
 g.fight.cancel_actions();g.fight.enemies.clear();g.combat.armed=false
 # Planned routes respect the same cart/ladder constraint as traversal.
 var stair=w.data.links[w.link_key(Vector2i(23,20),0)];stair.kind="ladder"
 g.state.add("wood",6);g.state.add("iron",2);g.deep.haul.build_cart(g.player);g.deep.haul.cart().hitched=true
 nav.route_to(Vector2i(25,18),1);check(nav.path.is_empty() and nav.message.contains("cart"),"Routes do not send a hitched cart down a ladder")
 g.deep.haul.cart().hitched=false;stair.kind="stair";nav.route_to(Vector2i(25,18),1)
 g.player=Deepworks.center(Vector2i(23,20));g.deep.use_stairs(false);settle();nav.update(0);await snap("exploration-lower")
 check(w.depth()==1 and nav.explore.active(),"Real stair traversal keeps exploration mode active")
 g.deep.use_stairs(true);settle();nav.update(0)
 check(w.depth()==0,"Same connected stair returns to upper floor")
 var at=g.player;Input.action_press("right");g.deep.move(.1);Input.action_release("right");nav.update(.1)
 check(g.player.distance_to(at)>1 and not w.solid(g.player),"Exploration movement uses existing collision and position")
 key(KEY_F6);nav.update(0);check(not nav.explore.active() and not nav.explore.screen.visible,"F6 immediately restores traditional overhead")
 key(KEY_F6);g.save_game();var expected=g.player;g.start_game(true);settle();nav.update(0)
 check(g.player.distance_to(expected)<1 and g.deep.world.depth()==0 and nav.explore.active(),"Reload preserves location and the user's camera preference")
 g.open_panel("inventory");var before=g.player;g._process(1);check(g.player==before,"Inventory pauses gameplay in exploration mode")
 g.close_panel();g.surface.enter("trail");settle();nav.update(0)
 check(not nav.explore.active() and not nav.explore.screen.visible,"Leaving the mine restores normal town rendering")
 g.save_game();var fortune=FileAccess.get_file_as_string(g.state.save_path())
 g.show_title();g.dev.start("exploration");settle();nav.update(0);await snap("exploration-preset")
 check(g.dev.active() and g.dev.mode()=="exploration" and not nav.path.is_empty(),"Separate developer preset prepares a connected two-floor route")
 check(nav.explore.prop_pool.size()>0,"Original workstations and mineral loads appear in exploration")
 check(FileAccess.get_file_as_string(HoldState.SAVE)==fortune,"Developer exploration leaves the normal fortune unchanged")
 print("NAVIGATION94: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
