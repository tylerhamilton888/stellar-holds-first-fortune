extends "res://tests/support/game_fixture.gd"
func motion(delta:Vector2):
 var e=InputEventMouseMotion.new();e.screen_relative=delta;e.relative=delta*.5
 Input.parse_input_event(e);await process_frame
func mouse(button_id:int,pressed:bool):
 var e=InputEventMouseButton.new();e.button_index=button_id;e.pressed=pressed;e.position=Vector2(480,270)
 Input.parse_input_event(e);await process_frame
func alt(pressed:bool):
 var e=InputEventKey.new();e.keycode=KEY_ALT;e.physical_keycode=KEY_ALT;e.pressed=pressed
 Input.parse_input_event(e);await process_frame
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 g.dev.start("exploration");settle();var nav=g.depth_nav;var view=nav.explore;var w=g.deep.world
 view.enabled=true;view.mouse_look=true;nav.update(0)
 # Let the native window finish its initial pointer capture before injecting motion.
 await process_frame;await process_frame;view.yaw=0;view.sync(0)
 var original=g.player;var data=w.data.duplicate(true);var inventory=g.state.inventory.duplicate(true)
 check(view.captured and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED,"Exploration captures the mouse for uninterrupted look")
 var before=view.yaw;await motion(Vector2(100,0))
 check(absf(view.yaw-(before-.3))<.001,"Native mouse motion turns right using unscaled screen pixels")
 check(view.movement(Vector2.UP).x>0,"W moves toward the new camera heading")
 before=view.pitch;await motion(Vector2(0,30));check(view.pitch>before,"Mouse down looks down")
 view.invert_y=true;await motion(Vector2(0,30));check(absf(view.pitch-before)<.001,"Invert look reverses vertical motion")
 view.invert_y=false;await motion(Vector2(0,10000));check(view.pitch<=1.18,"Looking down cannot flip the camera")
 await motion(Vector2(0,-10000));check(view.pitch>=.38,"Looking up keeps the ground and dwarf readable")
 view.sensitivity=.5;before=view.yaw;await motion(Vector2(100,0));check(absf(view.yaw-before+.15)<.001,"Sensitivity controls angular travel")
 view.sensitivity=1;view.pitch=.62;view.yaw=0;view.sync(0)
 before=view.distance;await mouse(MOUSE_BUTTON_WHEEL_UP,true);await mouse(MOUSE_BUTTON_WHEEL_UP,false)
 check(view.distance<before and g.mining_buffer==0,"Wheel zooms without beginning work")
 view.distance=5;await mouse(MOUSE_BUTTON_WHEEL_UP,true);await mouse(MOUSE_BUTTON_WHEEL_UP,false)
 check(view.distance==5,"Zoom stops before the camera enters the dwarf")
 view.pitch=.38;view.sync(0);await snap("close-low")
 var feet=view.camera.unproject_position(view.point(g.player))
 check(feet.y<374 and feet.x<450,"Close low view keeps the dwarf clear of the hotbar and reticle")
 view.pitch=1.18;view.sync(0);await snap("close-high")
 feet=view.camera.unproject_position(view.point(g.player))
 check(feet.y<374 and feet.x<450,"Close steep view keeps the dwarf visible above the hotbar")
 view.distance=12;await mouse(MOUSE_BUTTON_WHEEL_DOWN,true);await mouse(MOUSE_BUTTON_WHEEL_DOWN,false)
 check(view.distance==12,"Zoom out stays within the rendered mine")
 view.distance=9.5;view.pitch=.62;view.sync(0);await snap("mouse-look")
 check(w.data==data and g.player==original and g.state.inventory==inventory,"Looking, tilting and zooming preserve the actual world")
 var batch=view.terrain.get_child(0);await motion(Vector2(160,0));view.sync(.01)
 check(view.terrain.get_child(0)==batch,"Continuous look updates cutaways without rebuilding terrain batches")
 await snap("mouse-orbit")
 await alt(true);check(not view.captured and Input.mouse_mode==Input.MOUSE_MODE_VISIBLE,"Holding Alt immediately frees the pointer")
 before=view.yaw;await motion(Vector2(100,50));check(view.yaw==before,"Cursor movement does not turn the camera")
 g.hotbar.select(0);g.mining_buffer=.16;g.deep.mine(.1);check(g.deep.strike_left==0,"Freeing the cursor does not start excavation")
 g.combat.armed=true;await mouse(MOUSE_BUTTON_LEFT,true);g.fight.update(.01)
 check(g.fight.swing==0,"Pointer clicks cannot attack while Alt is held")
 await alt(false);view.sync(0);check(view.captured and not view.actions_allowed(),"Recapture waits for held mouse buttons to be released")
 g.fight.update(.01);check(g.fight.swing==0,"Held UI click cannot leak into a combat strike")
 await mouse(MOUSE_BUTTON_LEFT,false);view.sync(0);check(view.actions_allowed(),"Releasing the button restores normal actions")
 g.combat.armed=false;g.fight.cancel_actions();g.mining_buffer=0
 key(KEY_I);check(g.panel_id=="inventory" and not view.captured,"Opening a book releases the cursor immediately")
 before=view.yaw;await motion(Vector2(60,0));check(view.yaw==before,"Inventory cannot rotate the world behind it")
 g.close_panel();view.sync(0);check(view.captured,"Closing the book resumes mouse look")
 key(KEY_Z);check(g.panel_id=="depth_map" and not view.captured,"Depth planning gets a free cursor")
 key(KEY_Z);view.sync(0);check(view.captured,"Returning from the depth map restores look")
 key(KEY_X);view.sync(0);check(g.deep.survey_open and not view.captured,"Survey keeps its pointer controls")
 key(KEY_X);view.sync(0)
 g.handworks.placing="stone_pile";view.sync(0);check(not view.active() and not view.captured,"Construction returns overhead with a visible pointer")
 g.handworks.placing="";view.sync(0);check(view.active() and view.captured,"Finishing placement restores mouse look")
 g.pause_for_focus_loss();check(g.panel_id=="pause" and not view.captured,"Window focus loss pauses and releases the mouse")
 g.close_panel();view.sync(0)
 key(KEY_F7);await snap("camera-controls")
 check(g.panel_id=="camera_controls" and g.menu_paused and not view.captured,"F7 opens paused camera options")
 check(g.panel.get_global_rect().end.y<=540 and g.menu_scroll.get_v_scroll_bar().max_value<=g.menu_scroll.size.y+1,"Camera controls fit without scrolling")
 button("Free cursor");check(not view.mouse_look,"Original cursor aiming remains an explicit option")
 button("Mouse look");button("Reset camera");g.close_panel();view.sync(0)
 view.sensitivity=1.35;view.invert_y=true;view.distance=8.2;view.save_preference()
 var config=ConfigFile.new();config.load("user://view_settings94.cfg")
 check(config.get_value("view","mouse_look") and config.get_value("view","sensitivity")==1.35 and config.get_value("view","invert_y") and config.get_value("view","distance")==8.2,"Look comfort settings persist outside fortune data")
 view.invert_y=false;view.sensitivity=1;view.distance=9.5
 # Mining aims straight into the actual reachable face, at several camera headings.
 g.hotbar.select(0);HoldWorkEnergy.rest(g.state);g.player=Deepworks.center(Vector2i(23,24));view.yaw=0;view.sync(0)
 check(w.target(g.player,g.world_mouse(),52)==Vector2i(23,23),"Central reticle selects the reachable iron face")
 await mouse(MOUSE_BUTTON_LEFT,true);g.deep.mine(.01);await mouse(MOUSE_BUTTON_LEFT,false)
 check(g.deep.target==Vector2i(23,23) and g.deep.strike_left>0,"LMB begins a real mining stroke from the reticle")
 g.deep.mine(.4);check(float(w.layer().damage.get("23,23",0))>0,"Reticle mining reaches the original rock contact")
 view.sync(0);await snap("reticle-mining");g.deep.strike_left=0;g.deep.contact_hold=0
 # The same camera-relative attack, guard and dodge remain usable with zero energy.
 g.player=Deepworks.center(Vector2i(22,22));view.yaw=-PI/2;view.sync(0)
 var enemy=g.fight.make_enemy("mouse95/goblin",g.player+Vector2(38,0),0)
 enemy.state="windup";enemy.dir=Vector2.LEFT;enemy.time=2
 g.fight.enemies=[enemy];g.fight.key=g.handworks.context();g.combat.armed=true;HoldWorkEnergy.data(g.state).energy=0
 g.fight.update(0);check(g.fight.aim.dot(Vector2.RIGHT)>.99,"Combat faces the reticle after a mouse turn")
 var hp=enemy.hp;await mouse(MOUSE_BUTTON_LEFT,true);g.fight.update(.01);await mouse(MOUSE_BUTTON_LEFT,false);g.fight.update(.4)
 check(enemy.hp<hp and HoldWorkEnergy.data(g.state).energy==0,"Mouse-look combat hits at zero work energy")
 g.fight.cancel_actions();g.fight.hit_stop=0;await mouse(MOUSE_BUTTON_RIGHT,true);g.fight.update(.01)
 check(g.fight.guard and g.fight.parry>0,"RMB remains guard and parry, without a camera-button conflict")
 await mouse(MOUSE_BUTTON_RIGHT,false);g.fight.update(.01)
 Input.action_press("up");key(KEY_SPACE);Input.action_release("up")
 check(g.fight.dodge>0 and g.fight.dodge_vector.dot(Vector2.RIGHT)>.99,"W plus Space dodges along the camera heading at zero energy")
 g.fight.cancel_actions();view.sync(0);await snap("reticle-combat")
 g.combat.armed=false;g.fight.enemies.clear();var at=g.player
 Input.action_press("up");g.deep.move(.1);Input.action_release("up")
 check(g.player.x>at.x and absf(g.player.y-at.y)<.01 and not w.solid(g.player),"W follows mouse heading through original movement and collision")
 key(KEY_F6);check(not view.active() and not view.captured and Input.mouse_mode==Input.MOUSE_MODE_VISIBLE,"F6 restores overhead and the ordinary pointer")
 key(KEY_F6);view.sync(0);g.surface.enter("trail");settle();view.sync(0)
 check(not view.active() and not view.captured,"Leaving the mine releases mouse capture")
 g.show_title();check(Input.mouse_mode==Input.MOUSE_MODE_VISIBLE,"Title never retains mouse capture")
 print("MOUSELOOK95: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
