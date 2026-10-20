extends SceneTree
var g
var passed=0
var failed=0
const OUT="res://docs/testing/reference-0.54.0/handworks"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func at(p:Vector2):g.player=p;g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target()
func key(k:int,shift:bool=false):
 var e=InputEventKey.new();e.keycode=k;e.physical_keycode=k;e.shift_pressed=shift;e.pressed=true;g._unhandled_input(e)
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func snap(name:String):
 g.update_hud()
 for i in 10:g.queue_redraw();await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OUT+"/"+name+".png")
func run():
 DirAccess.make_dir_recursive_absolute(OUT)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var h=g.handworks;g.state.add("wood",100);g.state.add("stone",100);g.state.add("iron",10)
 at(Vector2(940,660));var before=g.state.count("wood")
 check(h.build("breaker",Vector2(940,600)),"Player crafts stonebreaker on valid claim ground")
 check(g.state.count("wood")==before-3,"Station material cost paid exactly once")
 check(not h.build("saw",Vector2(940,600)) and g.state.count("wood")==before-3,"Overlapping placement rejected without spending")
 check(h.build("stone_pile",Vector2(840,600)),"Player establishes typed stone stockpile")
 check(h.build("store",Vector2(1040,600)),"Processed-material pallet is craftable")
 at(Vector2(1160,660));check(h.build("saw",Vector2(1160,600)),"Player crafts sawbench")
 at(Vector2(1160,530));check(h.build("timber_pile",Vector2(1160,480)),"Player establishes timber rack")
 at(Vector2(1060,840));check(h.build("cart",Vector2(1060,820)),"Player crafts working handcart")
 at(Vector2(760,730));h.spawn("stone",g.player,1,"test-seam");key(KEY_E)
 check(h.data().carry.size()==1 and h.data().loose.is_empty(),"E moves raw chunk from ground to shoulder exactly once")
 await snap("01-shoulder")
 key(KEY_Q);check(h.data().carry.is_empty() and h.data().loose.size()==1,"Q places persistent chunk on ground")
 key(KEY_E);at(Vector2(840,650));key(KEY_E)
 var pile=h.data().facilities[1];check(pile.raw.size()==1 and h.data().carry.is_empty(),"E deposits only into compatible local stockpile")
 at(Vector2(760,730));h.spawn("log",g.player,2,"test-tree");key(KEY_E);at(Vector2(840,650));key(KEY_E)
 check(h.data().carry.size()==1 and pile.raw.size()==1,"Stone stockpile refuses logs without loss")
 at(Vector2(1160,530));key(KEY_E);check(h.data().carry.is_empty(),"Timber rack accepts log")
 at(Vector2(940,650));key(KEY_E);Input.action_press("interact");await frames(65);Input.action_release("interact")
 var breaker=h.data().facilities[0];check(not breaker.job.is_empty() and pile.raw.is_empty(),"Station reserves exactly one nearby raw input")
 await snap("02-stonebreaking")
 g.save_game();g.start_game(true);settle();h=g.handworks;breaker=h.data().facilities[0]
 check(not breaker.job.is_empty() and float(breaker.job.progress)>.4,"Partial work and input ownership survive actual reload")
 at(Vector2(940,650));Input.action_press("interact");await frames(100);Input.action_release("interact")
 var output=h.data().facilities[2]
 check(breaker.job.is_empty() and int(output.cargo.get("stone",0))==1,"Completed stone goes once to nearby output pallet")
 var stone=g.state.count("stone");at(Vector2(1040,650));key(KEY_E,true)
 check(g.state.count("stone")==stone+1 and output.cargo.is_empty(),"Shift+E returns actual output to existing inventory")
 check(g.surface.house.build(Vector2(1040,700),"stone_floor") and g.state.count("stone")==stone,"Processed stone builds a real house floor at its normal cost")
 at(Vector2(1160,650));Input.action_press("interact");await frames(55);await snap("03-sawing");await frames(55);Input.action_release("interact")
 var saw=h.data().facilities[3];check(int(output.cargo.get("wood",0))==2,"Timber workflow preserves explicit two-unit yield")
 at(Vector2(760,730));h.spawn("stone",g.player,1,"cart-load");key(KEY_E);at(Vector2(1060,860));key(KEY_E)
 var cart=h.data().facilities[5];check(cart.raw.size()==1 and h.data().carry.is_empty(),"Cart receives raw material without duplication")
 key(KEY_C);Input.action_press("right");await frames(25);Input.action_release("right");await snap("04-handcart")
 check(cart.hitched and h.pos(cart).distance_to(g.player)<40,"Pushed cart visibly follows player's clear path")
 key(KEY_C);key(KEY_E,true);check(cart.raw.is_empty() and h.data().carry.size()==1,"Cart unloads back to shoulders")
 key(KEY_Q)
 key(KEY_B,true);check(g.panel_id=="handworks","Shift+B opens craft/placement board");await snap("05-workshop-board");g.close_panel()
 var skill=int(h.data().skills.mason)+int(h.data().skills.forester)
 key(KEY_E);key(KEY_Q);check(int(h.data().skills.mason)+int(h.data().skills.forester)==skill,"Handling loops give no mastery experience")
 # Eight completed jobs unlock second shoulder; no artificial keypress XP.
 h.data().skills.mason=7;h.data().skills.forester=1
 check(h.capacity()==2,"Strong shoulders unlocks at eight productive work credits")
 g.save_game();g.start_game(true);settle();h=g.handworks
 check(h.data().facilities.size()==6 and h.capacity()==2 and not h.data().loose.is_empty(),"Equipment ground cargo and handling upgrade persist")
 # Fell a real Pinewood tree with held input; preserve the existing regrowth data.
 g.surface.enter("pinewood",Vector2(370,460));settle();g.hotbar.select(2)
 g.state.road_trees[0]=1;var timber=g.state.count("wood");var ground_before=h.data().loose.size()
 var aim=HoldSurface.TREES[0]-Vector2(0,25)-g.camera
 var mouse=InputEventMouseButton.new();mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=true;mouse.position=aim
 Input.parse_input_event(mouse);root.warp_mouse(aim*root.get_visible_rect().size/Vector2(960,540));await frames(60)
 mouse.pressed=false;Input.parse_input_event(mouse);await frames(2)
 check(g.state.road_trees[0]==0 and h.data().loose.size()==ground_before+1,"Actual held axe stroke fells tree and releases one persistent log")
 check(g.state.count("wood")==timber and HoldForestry.logs(g.state,0)==3,"Felling avoids duplicate timber and retains fallen trunk cuts/regrowth")
 at(HoldSurface.TREES[0]+Vector2(24,45));key(KEY_E);await snap("06-pinewood-log")
 check(not h.data().carry.is_empty() and h.data().carry.back().kind=="log","Newly felled log is physically liftable with E")
 key(KEY_Q)
 # Existing mine works with additive hauling fields initialized from surface play.
 g.surface.enter("trail",Vector2(950,340));settle();g.surface.action("mine");settle()
 var c=Deepworks.ENTRY+Vector2i(1,0)
 while posmod(c.x*7+c.y*11+g.state.seed_value,4)!=0:c.x+=1
 g.deep.world.set_cell(c,2);var pack=g.state.count("stone");var cargo=g.deep.haul.in_field("stone")
 g.deep.hit(c);g.deep.hit(c);var loose=h.data().loose.back()
 check(loose.kind=="stone" and loose.area==h.context() and g.deep.world.at(c)==0,"Suitable actual mine seam produces a persistent raw object")
 check(g.state.count("stone")==pack and g.deep.haul.in_field("stone")==cargo,"Raw extraction does not also award inventory/bucket stone")
 # Surface and underground cargo cannot interact across contexts.
 check(h.facility().is_empty(),"Claim equipment cannot be used remotely from underground")
 print("HANDWORKS54: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
