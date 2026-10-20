extends SceneTree
var g
var passed=0
var failed=0
var output="res://docs/testing/masonry-0.45.0"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func key(k:int,shift:bool=false):
 var e=InputEventKey.new();e.keycode=k;e.pressed=true;e.shift_pressed=shift;g._unhandled_input(e)
func button(prefix:String):
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.begins_with(prefix):b.pressed.emit();return
 push_error("Missing button "+prefix);failed+=1
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func aim(c:Vector2i):
 var p=Deepworks.center(c)-g.camera
 root.warp_mouse(p*root.get_visible_rect().size/Vector2(960,540));await frames(2)
 var motion=InputEventMouseMotion.new();motion.position=p;motion.global_position=p;Input.parse_input_event(motion);await frames(1)
func mouse(down:bool):
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.position=g.get_global_mouse_position();e.pressed=down;Input.parse_input_event(e)
func work(c:Vector2i,n:int=80):
 await aim(c);mouse(true);await frames(n);mouse(false);await frames(3)
func snap(name:String):
 g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func board():
 g.deep.works.cancel();g.deep.works.page="Masonry";key(KEY_O)
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.opening=4;g.state.worker=true;g.state.add("food",100);g.travel_claim();settle();g.change_zone("mine");settle();g.state.agents_enabled=false
 for item in ["stone","wood","iron","coal"]:g.state.add(item,60)
 var w=g.deep.world;var m=g.deep.works.model;var q=g.deep.works.masonry
 for y in range(6,13):
  for x in range(7,21):w.set_cell(Vector2i(x,y),0)
 m.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 m.place(Vector2i(15,7),"bench");m.place(Vector2i(17,7),"anvil");m.place(Vector2i(14,6),"lamp")
 g.player=Deepworks.center(Vector2i(18,10));g.camera=g.deep.camera_target();w.survey(g.player)
 board();check(g.panel_id=="living" and g.deep.works.page=="Masonry","Masonry tutorial opens in existing O board");await snap("01-lesson")
 button("Place mason");await frames(3);await work(Vector2i(17,9),28)
 check(not q.bench(Vector2i(17,9)).is_empty(),"Actual placement UI installs masonry workstation")
 w.set_cell(Vector2i(20,9),2);g.player=Deepworks.center(Vector2i(19,9));g.camera=g.deep.camera_target();w.survey(g.player)
 board();button("Chisel sound");await frames(3);await aim(Vector2i(20,9));mouse(true);await frames(13);await snap("02-chisel-contact");await frames(60);mouse(false);await frames(3)
 check(q.has("extract") and w.at(Vector2i(20,9))==0,"Held input extracts physical block without repetitive clicks")
 g.deep.works.cancel();g.player=Deepworks.center(Vector2i(18,10));g.camera=g.deep.camera_target();await frames(3);await snap("03-carrying-block")
 board();button("Cache masonry");await frames(3);await snap("04-stockpile")
 check(q.has("stockpile") and g.deep.haul.bucket().get("rough_block",0)==0,"Cache action sets block down into persistent marked pile")
 g.player=Deepworks.center(Vector2i(17,10));g.camera=g.deep.camera_target();key(KEY_E)
 check(g.panel_id=="living" and g.deep.works.page=="Masonry","E at mason's bench opens contextual work choices")
 button("Dress blocks");await frames(3);await aim(Vector2i(17,9));mouse(true);await frames(13);await snap("05-bench-contact");await frames(60);mouse(false);await frames(3);g.deep.works.cancel()
 check(q.has("dress") and g.deep.haul.in_field("dressed_stone")==2,"Held bench work deposits finished output in the real pile")
 g.player=Deepworks.center(Vector2i(18,10));key(KEY_U,true)
 g.player=Deepworks.center(Deepworks.ENTRY);key(KEY_U);check(g.state.count("dressed_stone")==2,"Existing haul controls load and deliver dressed stone")
 g.player=Deepworks.center(Vector2i(16,10));g.camera=g.deep.camera_target();board();button("Lay dressed");await frames(3);await work(Vector2i(16,9),50);await snap("06a-floor-contact");g.deep.works.cancel()
 q.observe();check(q.has("build"),"Actual finishing contact satisfies useful construction lesson")
 board();button("Complete Brann");check(g.state.tech.has("masonry_apprentice"),"Tutorial completion unlocks worker handover")
 await frames(8);check(g.panel.size.y<=452,"Refreshed tutorial remains bounded with scroll and fixed tabs");await snap("06-complete-lesson");g.close_panel()
 # Supply fixture for delegated production; personal loop above uses only extracted stone.
 var pile=g.deep.haul.pile(Vector2i(18,10),true);pile.cargo.rough_block=2
 board();button("Assign Brann");g.close_panel();g.state.agents_enabled=true
 var saw_carry=false;var saw_work=false
 for i in 600:
  await frames(1)
  if q.data.jobs.has("brann"):
   var job=q.data.jobs.brann
   if job.phase=="dress" and not saw_carry:
    await snap("07-mason-hauling");saw_carry=true
   if float(job.time)>.5 and not saw_work:
    await snap("08-mason-dressing");saw_work=true
  if q.has("delegate"):break
 check(saw_carry and saw_work and q.has("delegate"),"Recruited Dwarf physically fetches, works and returns finished stone")
 await snap("09-finished-room")
 var data=q.data.duplicate(true);g.save_game();g.start_game(true);settle()
 check(JSON.parse_string(JSON.stringify(g.deep.works.masonry.data))==JSON.parse_string(JSON.stringify(data)),"Native session reload retains quest and worker material state")
 print("MASONRY INPUT: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
