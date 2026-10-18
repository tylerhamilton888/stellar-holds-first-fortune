extends SceneTree
var g
var passed=0
var failed=0
func check(ok:bool,s:String):
 if ok:passed+=1;print("PASS ",s)
 else:failed+=1;push_error(s)
func _initialize():call_deferred("run")
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.state.opening=1;g.grounded=true;g.arrive_region("workings")
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
 g.player=Deepworks.center(Vector2i(11,8));g.camera=g.deep.camera_target();g.tool=0
 root.warp_mouse((Vector2(490,340)-g.camera)*root.get_visible_rect().size/Vector2(960,540))
 await process_frame;await process_frame
 var motion=InputEventMouseMotion.new();motion.position=Vector2(490,340)-g.camera;motion.global_position=motion.position;Input.parse_input_event(motion)
 await process_frame
 print("AIM ",g.get_global_mouse_position()+g.camera)
 var mb=InputEventMouseButton.new();mb.button_index=MOUSE_BUTTON_LEFT;mb.position=motion.position;mb.pressed=true;Input.parse_input_event(mb)
 await process_frame
 var before=g.deep.haul.in_field("coal")
 for i in 120:
  g._process(1.0/60);await process_frame
 mb.pressed=false;Input.parse_input_event(mb);await process_frame
 check(g.deep.haul.in_field("coal")>before,"Real held mouse input excavates and collects coal in main game loop")
 var count=g.state.mined
 for i in 60:g._process(1.0/60)
 check(g.state.mined==count,"Releasing button stops continuous mining")
 var old=g.player;Input.action_press("up");Input.action_press("left")
 for i in 15:g._process(1.0/60)
 Input.action_release("up");Input.action_release("left")
 check(g.player.x<old.x and g.player.y<old.y,"Main gameplay loop moves diagonally under input")
 var e=InputEventKey.new();e.keycode=KEY_V;e.pressed=true;g._unhandled_input(e)
 check(g.panel_id=="deepworks","Build key opens integrated mine board")
 # Activate the actual UI button, rather than calling the model's stair operation.
 var buttons=g.panel_body.find_children("*","Button",true,false)
 for b in buttons:
  if b.text.begins_with("Carve descending"):b.pressed.emit();break
 for i in 90:g._process(1.0/60)
 var c=Deepworks.cell(g.player)
 check(g.deep.world.can_descend(c,0),"Build-board button carves functional stairs through timed gameplay")
 e.keycode=KEY_E;g._unhandled_input(e)
 check(g.deep.world.depth()==1,"Interact key follows newly carved passage")
 g.transition_left=0;g.transition_shade.visible=false;e.shift_pressed=true;g._unhandled_input(e)
 check(g.deep.world.depth()==0,"Shift-interact key returns to connected upper landing")
 g.transition_left=0;g.transition_shade.visible=false;g.save_game();var position=g.player;g.start_game(true);g.close_panel()
 check(g.player.distance_to(position)<.001,"Live-input session restores its exact position")
 g.transition_left=0;g.transition_shade.visible=false
 g.state.add("iron",2);g.state.add("wood",6)
 e.keycode=KEY_H;e.shift_pressed=false;g._unhandled_input(e)
 check(g.panel_id=="haulage","Haulage key opens equipment board in existing game")
 buttons=g.panel_body.find_children("*","Button",true,false)
 for b in buttons:
  if b.text.begins_with("Build wheelbarrow"):b.pressed.emit();break
 check(not g.deep.haul.cart().is_empty(),"Actual construction button creates positioned wheelbarrow")
 g.close_panel();e.keycode=KEY_C;g._unhandled_input(e)
 old=g.player;Input.action_press("left")
 for i in 8:g._process(1.0/60)
 Input.action_release("left")
 check(g.deep.haul.cart().hitched and g.deep.haul.cart_pos().distance_to(g.player)<1 and g.player!=old,"Cart key and movement carry actual equipment with the dwarf")
 e.keycode=KEY_U;g._unhandled_input(e)
 check(g.deep.haul.bucket().is_empty() and g.state.count("coal")>0,"Unload key delivers mined bucket to existing stores")
 e.keycode=KEY_L;g._unhandled_input(e)
 check(g.panel_id=="projects","Project ledger opens from mining controls")
 buttons=g.panel_body.find_children("*","Button",true,false)
 for b in buttons:
  if b.text=="Track · Steel":b.pressed.emit();break
 check(g.state.hauling.project=="steel","Ledger button selects the intended existing goal")
 g.close_panel();g.save_game();g.start_game(true);g.close_panel()
 check(g.deep.haul.cart().hitched and g.state.hauling.project=="steel","Live hauling and goal selection persist after reload")
 print("DEEPWORKS INPUT: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
