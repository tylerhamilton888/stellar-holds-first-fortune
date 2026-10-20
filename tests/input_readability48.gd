extends SceneTree
var g
var passed=0
var failed=0
var output="res://docs/testing/readability-0.48.0"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.physical_keycode=k;e.pressed=true;g._unhandled_input(e)
func snap(name:String):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud()
 for i in 10:g.queue_redraw();await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(g.hotbar.data().slots.size()==10,"Ten slots in the existing game's HUD")
 for i in 4:
  key(KEY_1+i);check(g.tool==i and g.hotbar.item=="","Number selects matching real tool "+str(i))
 key(KEY_5);check(not g.mining_gun.selected,"Locked slagcaster cannot equip")
 for i in range(5,10):
  key(KEY_6+i-5 if i<9 else KEY_0);check(g.hotbar.selected()==i and g.hotbar.item==g.hotbar.data().slots[i],"Supply slot selectable "+str(i))
 g.hotbar.assign("iron_ore",9);g.state.add("iron_ore",12);key(KEY_0)
 check(g.hotbar.item=="iron_ore" and g.state.count("iron_ore")==12,"Assignment references real pack without moving supplies")
 await snap("01-hotbar-held-ore")
 key(KEY_I);await snap("02-pack-pinning");key(KEY_1);check(g.hotbar.item=="iron_ore","Menus block hotkeys");g.close_panel()
 # Click slot 7; held clicks over the UI must never excavate/build behind it.
 root.warp_mouse(g.hotbar.slot_rect(6).get_center())
 for i in 4:await process_frame
 var click=InputEventMouseButton.new();click.button_index=MOUSE_BUTTON_LEFT;click.pressed=true;click.position=g.hotbar.slot_rect(6).get_center();g._unhandled_input(click)
 check(g.hotbar.selected()==6 and g.hotbar.blocked,"Click selects a slot and blocks world work")
 click.pressed=false;g._unhandled_input(click);key(KEY_0)
 g.save_game();g.start_game(true);settle()
 check(g.hotbar.item=="iron_ore" and g.hotbar.data().slots[9]=="iron_ore" and g.state.count("iron_ore")==12,"Assignments selection and counts survive actual save/reload")
 key(KEY_1);check(g.hotbar.item=="" and g.tool==0,"Tool selection clears carried supply mode")
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for direction in [Vector2.DOWN,Vector2.RIGHT,Vector2.UP,Vector2(-1,-1)]:
  g.surface.direction=direction;g.walking_pose=true;g.gait_clock=.19;await snap("direction-"+str(direction))
 g.surface.enter("pinewood",Vector2(370,460));settle();key(KEY_3)
 g.surface.cut_target=0;g.surface.cut_clock=.17;await snap("03-axe-contact")
 g.surface.enter("trail",Vector2(950,340));settle();g.surface.action("mine");settle();key(KEY_1)
 var c=Deepworks.ENTRY+Vector2i.RIGHT
 g.deep.world.set_cell(c,2);g.deep.contact=Deepworks.center(c);g.deep.target=c
 for phase in [.15,.53,.82]:
  g.deep.strike_left=g.deep.swing_duration*(1-phase);await snap("mine-"+str(phase))
 g.deep.strike_left=0
 g.deep.world.set_cell(c,2)
 var aim=Deepworks.center(c)-g.camera
 var held=InputEventMouseButton.new();held.button_index=MOUSE_BUTTON_LEFT;held.pressed=true;held.position=aim
 Input.parse_input_event(held);root.warp_mouse(aim)
 for i in 45:g._process(1.0/60);await process_frame
 held.pressed=false;Input.parse_input_event(held);await process_frame
 check(g.deep.world.at(c)==0,"Held mouse excavates the actual nearby rock without repeated clicks")
 check(g.deep.haul.in_field("stone")>0,"Mining still delivers real stone to field haulage")
 key(KEY_7);g.mining_buffer=.16;g.deep.mine(.016);check(g.deep.strike_left==0,"Holding supply cannot secretly swing old tool")
 key(KEY_1);check(g.hotbar.item=="","Pick restores mining mode")
 g.surface.enter("room:forge");settle();g.clock=.85;await snap("04-forge-contact")
 print("READABILITY48: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
