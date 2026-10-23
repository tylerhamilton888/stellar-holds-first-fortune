extends "res://tests/support/game_fixture.gd"
func same(a,b)->bool:return JSON.stringify(JSON.parse_string(JSON.stringify(a)))==JSON.stringify(JSON.parse_string(JSON.stringify(b)))
func aim_at(p:Vector2):
 g.camera=g.deep.camera_target();root.warp_mouse((p-g.camera)*root.get_visible_rect().size/Vector2(960,540));await frames(2)
func mouse(pressed:bool):
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=pressed;Input.parse_input_event(e);await process_frame
func shift(pressed:bool):
 var e=InputEventKey.new();e.keycode=KEY_SHIFT;e.physical_keycode=KEY_SHIFT;e.pressed=pressed;Input.parse_input_event(e);await process_frame
func cut(c:Vector2i,method:String="pick"):
 g.deep.mining_method=method;g.deep.contact=Deepworks.center(c)
 for i in 12:
  if g.deep.world.at(c)==0:break
  g.deep.hit(c)
 g.deep.strike_left=0;g.deep.contact_hold=0
func run():
 var args=OS.get_cmdline_user_args()
 output=args[0] if not args.is_empty() else "res://docs/testing/mining-0.55.0";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 if args.size()>1:g.state.appearance=HoldAppearance.normalized({"sculpt":int(args[1]),"hair_color":3})
 g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle()
 check(g.zone=="mine","Existing trail doorway enters integrated Deepworks")
 var w=g.deep.world;var h=g.handworks;var c=Vector2i(12,8);w.set_cell(c,2);w.layer().damage.erase(Deepworks.key(c));g.player=Deepworks.center(Vector2i(11,8));g.hotbar.select(0);var origin=g.player
 await aim_at(Deepworks.center(c));await mouse(true);await frames(16)
 check(w.at(c)==2 and not w.layer().damage.has(Deepworks.key(c)),"Authored anticipation precedes rock contact")
 await snap("01-anticipation");await frames(12)
 check(w.at(c)==2 and float(w.layer().damage.get(Deepworks.key(c),0))>0,"First planted contact scores solid rock")
 await snap("02-score");await frames(76)
 check(w.at(c)==2 and float(w.layer().damage.get(Deepworks.key(c),0))>=2,"Solid face survives multiple deliberate contacts")
 await snap("03-fracture");await frames(60)
 check(w.at(c)==0 and g.player==origin,"Held work frees a substantial face without dragging the player")
 check(h.data().loose.size()==1 and int(h.data().loose[0].units)==4,"Ordinary face produces one four-unit physical load")
 check(g.deep.haul.bucket().is_empty(),"Unworked chunks are not vacuumed into a bucket")
 var mined=g.state.mined;await frames(100);await mouse(false)
 check(g.state.mined==mined and g.player==origin,"Held input cannot tunnel beyond tool reach")
 await snap("04-released-load")
 # Responsive movement interrupts anticipation without an off-target impact.
 var north=Vector2i(11,7);w.set_cell(north,2);w.layer().damage.erase(Deepworks.key(north));g.deep.strike_left=0
 await aim_at(Deepworks.center(north));await mouse(true);await frames(8);Input.action_press("left");await frames(12);Input.action_release("left");await mouse(false)
 check(g.player.x<origin.x-20 and not w.layer().damage.has(Deepworks.key(north)),"WASD immediately cancels anticipation and moves at normal speed")
 g.player=origin;g.deep.strike_left=0
 await shift(true);Input.action_press("interact");await frames(54);Input.action_release("interact");await shift(false)
 check(not h.data().loose.is_empty() and float(h.data().loose[0].get("dressing",0))>0,"Field-dressing progress lives on the existing raw load")
 var oldprogress=float(h.data().loose[0].get("dressing",0));g.save_game();g.start_game(true);settle();w=g.deep.world;h=g.handworks
 check(is_equal_approx(float(h.data().loose[0].get("dressing",0)),oldprogress),"Interrupted field work survives save/reload")
 await shift(true);Input.action_press("interact");await frames(90);Input.action_release("interact");await shift(false)
 check(h.data().loose.is_empty() and int(g.deep.haul.bucket().get("stone",0))==4,"Three field blows preserve the full yield without a workstation")
 # Physical mineral identity follows the same existing ownership pipeline.
 c=Vector2i(12,9);w.set_cell(c,3);w.layer().damage.erase(Deepworks.key(c));g.player=Deepworks.center(Vector2i(11,9));var expected=w.yield_count(c);cut(c)
 var raw=h.data().loose.back();var raw_id=raw.id
 check(raw.kind=="stone" and HoldHandworks.raw_item(raw)=="iron_ore" and int(raw.units)==expected,"Ore is a typed rock load, with original recipe item and exact yield")
 g.player=Deepworks.center(c);key(KEY_E);await frames(24);await snap("05-carry-ore")
 check(h.data().carry.size()==1 and h.data().carry[0].id==raw_id,"E lifts the actual ore record")
 for y in range(7,15):
  for x in range(14,24):w.set_cell(Vector2i(x,y),0)
 for item in ["wood","stone","iron","coal"]:g.state.add(item,100)
 g.player=Vector2(660,460);check(h.build("stone_pile",Vector2(660,400)),"Player crafts and places an underground raw stockpile")
 g.player=Vector2(760,460);check(h.build("breaker",Vector2(760,400)),"Player crafts a nearby integrated stonebreaker")
 g.player=Vector2(840,500);check(h.build("store",Vector2(840,440)),"Player adds an output pallet")
 g.player=Vector2(660,560);check(h.build("cart",Vector2(660,500)),"Player crafts raw-load hauling equipment")
 g.player=Vector2(660,450);key(KEY_E)
 var rack=h.facility();check(rack.raw.size()==1 and rack.raw[0].id==raw_id and h.data().carry.is_empty(),"Rack transfer retains mineral identity and unique ownership")
 await snap("06-stockpile-ore")
 var iron=g.state.count("iron_ore")
 g.player=Vector2(728,355);Input.action_press("interact");await frames(34);await snap("07-stonebreaker-ore");await frames(72);Input.action_release("interact")
 var pallet=h.data().facilities.filter(func(f):return f.kind=="store")[0]
 check(rack.raw.is_empty() and pallet.cargo.is_empty(),"Stonebreaker consumes the nearby raw input without stranding output")
 check(g.state.count("iron_ore")==iron+expected,"Finished mineral enters existing crafting inventory once without Shift+E")
 check(g.state.craft("iron"),"Recovered material enters unchanged forge recipe");g.state.tick(6)
 # E is a useful batch gather, not eight individual pickup trips.
 var cart=h.data().facilities.filter(func(f):return f.kind=="cart")[0];g.player=h.pos(cart)+Vector2(0,50)
 for i in 3:h.spawn("stone",h.pos(cart)+Vector2(45+i*12,30),4,"test", "copper_ore")
 key(KEY_E);check(cart.raw.size()==3 and h.data().loose.is_empty(),"Parked cart gathers nearby loose loads with one deliberate interaction")
 await snap("08-loaded-cart")
 # Skill and equipment change handling and fracture control, not walking speed.
 h.data().skills.miner=12;check(h.capacity()==2 and w.mastery()==1,"Meaningful mining practice unlocks two supported shoulder loads")
 h.data().skills.miner=40;check(h.load_capacity(cart)==12 and w.mastery()==2,"Master Miner packs four additional cart loads")
 check(h.travel_speed()==150,"Mining mastery leaves unladen movement responsive")
 var face=Vector2i(23,10);w.set_cell(face,3);g.player=Deepworks.center(Vector2i(22,10))
 var ordinary=w.yield_count(face);var dark=g.deep.worksite(face)
 w.layer().fixtures[Deepworks.key(Vector2i(21,10))]="lamp"
 var lit=g.deep.worksite(face);check(lit.lit and lit.recovery>dark.recovery,"Local lamp improves careful recovery without an upkeep cost")
 g.deep.works.model.data.furniture[w.link_key(Vector2i(21,11),0)]={"x":21,"y":11,"depth":0,"kind":"pillar","solid":true}
 var supported=g.deep.worksite(face);check(supported.braced and supported.section and supported.fracture>lit.fracture,"Existing masonry supports enable controlled section work")
 cut(face,"careful");var ore=h.data().loose.back()
 check(int(ore.units)==ordinary+3,"Careful lit master work preserves three additional mineral units")
 # A supported hammer releases at most one adjacent weakened exposed face.
 c=Vector2i(23,11);var adjacent=c+Vector2i.UP;w.set_cell(c,2);w.set_cell(adjacent,2);w.layer().damage[Deepworks.key(c)]=2.0;w.layer().damage[Deepworks.key(adjacent)]=2.6
 g.player=Deepworks.center(Vector2i(22,11))+Vector2(8,-8);var count=g.state.mined;g.deep.mining_method="hammer";g.deep.hit(c)
 check(w.at(c)==0 and w.at(adjacent)==0 and g.state.mined==count+2,"Supported hammer frees a controlled two-face section with exact rewards")
 await snap("09-established-site")
 # Formation identity uses the original deterministic dipping seam across Z levels.
 var first={};var second={}
 for y in range(18,38):
  for x in range(20,35):
   if w.at(Vector2i(x,y),0)==3 and w.at(Vector2i(x+1,y),1)==3:
    var a=w.formation(Vector2i(x,y),0);var b=w.formation(Vector2i(x+1,y),1)
    if a.id==b.id:first={"c":Vector2i(x,y),"note":a};second={"c":Vector2i(x+1,y),"note":b};break
  if not first.is_empty():break
 check(not first.is_empty(),"Natural iron formation continues through actual lower-level geology")
 if not first.is_empty():
  w.record_lode(first.c,0,3,5);w.record_lode(second.c,1,3,5)
  check(w.data.prospects[first.note.id].depths.size()==2,"Prospect ledger recognizes the same lode developed at two depths")
 var save_hands=h.data().duplicate(true);var prospects=w.data.prospects.duplicate(true);var cells=w.layer().cells.duplicate();g.save_game();g.start_game(true);settle();w=g.deep.world;h=g.handworks
 check(same(h.data(),save_hands),"All raw loads, facilities, outputs, mastery and ownership survive reload")
 check(same(w.layer().cells,cells) and same(w.data.prospects,prospects),"Excavations and multi-depth prospect notes persist")
 g.open_panel("deepworks");await snap("10-mining-guide");g.close_panel()
 # Exact pre-.55 save copy, including all unrelated progress.
 g.save_game();var path=g.state.save_path();var old=JSON.parse_string(FileAccess.get_file_as_string(path));old.hauling.erase("mining_revision");var bytes=JSON.stringify(old);var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(bytes);f.close();g.start_game(true);settle()
 var exact=false
 for name in DirAccess.open("user://").get_files():
  if ".pre-mining-55-" in name and FileAccess.get_file_as_string("user://"+name)==bytes:exact=true
 check(exact and same(g.state.inventory,old.inventory),"Upgrade preserves exact prior save bytes and non-mining inventory")
 # A loose chunk on a real landing must not steal passage interaction.
 g.player=Deepworks.center(Deepworks.ENTRY+Vector2i.DOWN*2);w=g.deep.world;h=g.handworks;w.carve_stairs(Deepworks.cell(g.player));h.spawn("stone",g.player,4,"landing")
 key(KEY_E);settle();check(w.depth()==1,"Real E uses stairs even when a loose load occupies the upper landing")
 var up=InputEventKey.new();up.keycode=KEY_E;up.pressed=true;up.shift_pressed=true;g._unhandled_input(up);settle()
 check(w.depth()==0,"Real Shift+E returns through the exact passage")
 check(h.closest(h.data().loose,20).get("source","")=="landing","Passage priority leaves the uncollected load safely on its original level")
 print("MINING55: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
