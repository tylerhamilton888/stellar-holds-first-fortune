extends SceneTree
var g
var passed=0
var failed=0
var output="/workspace/scratch/a447fc5d46ab/review431"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.pressed=true;g._unhandled_input(e)
func button(prefix:String):
 var page=""
 if prefix.begins_with("Designate") or prefix.begins_with("Assign"):page="Rooms"
 elif prefix.begins_with("Invite"):page="Folk"
 elif prefix.begins_with("Flagstone"):page="Finishes"
 elif prefix.begins_with("Joiner") or prefix.begins_with("Forge hearth") or prefix.begins_with("Warm lantern"):page="Furnish"
 if page!="" and g.deep.works.page!=page:
  for tab in g.panel.find_children("*","Button",true,false):
   if tab.text.begins_with(page):tab.pressed.emit();break
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.begins_with(prefix):b.pressed.emit();return
 push_error("Missing button "+prefix);failed+=1
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func click(c:Vector2i):
 var p=Deepworks.center(c)-g.camera
 root.warp_mouse(p*root.get_visible_rect().size/Vector2(960,540));await frames(2)
 var motion=InputEventMouseMotion.new();motion.position=p;motion.global_position=p;Input.parse_input_event(motion);await frames(1)
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.position=p;e.pressed=true;Input.parse_input_event(e)
 await frames(28)
 e.pressed=false;Input.parse_input_event(e);await frames(3)
func snap(name:String):
 g.notice_time=0;g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.opening=4;g.state.worker=true;g.state.add("food",100);g.travel_claim();settle();g.change_zone("mine");settle()
 g.state.money=400
 for item in ["stone","wood","iron","copper","coal"]:g.state.add(item,100)
 var w=g.deep.world;var m=g.deep.works.model
 # Cleared chamber fixture isolates placement input; test_living43 excavates it through real yields.
 for y in range(7,13):
  for x in range(10,16):w.set_cell(Vector2i(x,y),0)
 g.player=Deepworks.center(Vector2i(12,10));g.camera=g.deep.camera_target();w.survey(g.player)
 key(KEY_O);check(g.panel_id=="living","O opens integrated Living Works board")
 button("Designate Workshop");await frames(3);await click(Vector2i(10,7));await click(Vector2i(15,12))
 check(m.data.rooms.size()==1,"Two actual mouse corners designate physical chamber")
 if m.data.rooms.is_empty():g.sound.stop_all();quit(1);return
 g.player=Deepworks.center(Vector2i(12,9));g.camera=g.deep.camera_target()
 key(KEY_O);button("Joiner's bench");await frames(3);await click(Vector2i(11,8));g.deep.works.cancel()
 check(m.data.furniture.has(m.id_at(Vector2i(11,8))),"Furniture UI and timed hammer impact install bench")
 key(KEY_O);button("Forge hearth");await frames(3);await click(Vector2i(13,8));g.deep.works.cancel()
 check(not w.walkable(Vector2i(13,8)),"Placed forge has collision in actual game")
 g.player=Deepworks.center(Vector2i(11,9));g.camera=g.deep.camera_target()
 key(KEY_O);button("Warm lantern");await frames(3);await click(Vector2i(10,7));g.deep.works.cancel()
 check(m.data.rooms["1"].metrics.active,"Three placed furnishings activate workshop")
 g.player=Deepworks.center(Vector2i(12,8));key(KEY_E)
 check(g.panel_id=="forge","E beside underground workbench opens existing crafting interface");g.close_panel()
 g.state.research("stoneworking");key(KEY_O);button("Flagstone floor");await frames(3);await click(Vector2i(12,8));g.deep.works.cancel()
 check(m.data.surfaces.has(m.id_at(Vector2i(12,8))),"Held mouse finishing updates real floor at hammer contact")
 g.state.research("fine_masonry");g.state.research("furnishings")
 for y in range(7,13):
  for x in range(10,16):m.finish(Vector2i(x,y),"flags")
 for x in range(10,16):m.finish(Vector2i(x,6),"runic")
 m.place(Vector2i(13,10),"rune");m.place(Vector2i(11,10),"shelf");m.place(Vector2i(12,11),"chair")
 g.player=Deepworks.center(Vector2i(15,11));w.survey(g.player);g.camera=g.player-Vector2(540,330)
 key(KEY_O);button("Assign ");g.close_panel();await frames(600)
 check(m.data.assignments.get("brann",{}).get("present","")=="1","Assigned existing Dwarf walks to furnished workbench")
 g.camera=Vector2(520,400)-Vector2(520,330)
 await snap("01-working-chamber")
 key(KEY_O);await frames(3);await snap("02-room-board")
 for tab_name in ["Furnish","Finishes","Folk"]:
  button(tab_name);await frames(3);await snap("menu-"+tab_name.to_lower())
  check(g.panel.size.x<=740 and g.panel.get_global_rect().end.y<=510,"%s menu stays within compact viewport" % tab_name)
 g.close_panel()
 check(m.data.opportunity=="offered","Room improvement produces Brann's optional opportunity")
 key(KEY_O);button("Invite Brann");g.close_panel()
 check(g.state.tech.has("ancestor_marks"),"Existing NPC opportunity button grants earned architectural capability")
 m.finish(Vector2i(14,6),"ancestor");await snap("03-masterwork-wall")
 key(KEY_L);await snap("04-construction-ledger");g.close_panel()
 var saved=m.data.duplicate(true);g.save_game();g.start_game(true);settle()
 check(JSON.stringify(JSON.parse_string(JSON.stringify(saved)))==JSON.stringify(JSON.parse_string(JSON.stringify(g.deep.works.model.data))),"Native construction and NPC session restores through actual save/load")
 # A second furnished space exercises bedroom rendering in the same running world.
 w=g.deep.world;m=g.deep.works.model
 for y in range(16,22):
  for x in range(14,20):w.set_cell(Vector2i(x,y),0)
 m.designate(Vector2i(14,16),Vector2i(19,21),"bedroom")
 for y in range(16,22):
  for x in range(14,20):m.finish(Vector2i(x,y),"timber")
 m.place(Vector2i(15,17),"bed");m.place(Vector2i(14,16),"lamp");m.place(Vector2i(17,17),"table");m.place(Vector2i(17,18),"chair");m.place(Vector2i(18,19),"shelf")
 for x in range(14,20):m.finish(Vector2i(x,15),"masonry")
 g.player=Deepworks.center(Vector2i(16,20));w.survey(g.player);g.camera=Vector2(680,760)-Vector2(500,350)
 await snap("05-bedroom")
 print("POLISH INPUT: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
