extends SceneTree
var g
var passed=0
var failed=0
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func same(a,b)->bool:return JSON.stringify(JSON.parse_string(JSON.stringify(a)))==JSON.stringify(JSON.parse_string(JSON.stringify(b)))
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
func _initialize():call_deferred("run")
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=1;g.grounded=true;g.arrive_region("workings");settle()
 var w=g.deep.world;var h=g.deep.haul;var entry=Deepworks.center(Deepworks.ENTRY)
 check(g.zone=="mine" and h.bucket().is_empty(),"Settlement route enters mine with free empty bucket")
 var old_inventory=g.state.inventory.duplicate();var ore=Vector2i(8,12);g.player=Deepworks.center(Vector2i(8,11))
 var expected=w.yield_count(ore);g.deep.contact=Deepworks.center(ore)
 g.deep.hit(ore);check(w.at(ore)==3 and w.layer().damage.has(Deepworks.key(ore)),"First iron contact leaves visible persistent damage")
 g.deep.hit(ore)
 check(w.at(ore)==0 and int(h.bucket().get("iron_ore",0))==expected,"Broken ore enters bucket using existing resource ID")
 check(g.state.inventory==old_inventory,"Field extraction does not duplicate centrally stored materials")
 check(not g.deep.rubble.is_empty() and not g.deep.sparks.is_empty(),"Destruction creates timed substantial fragments and impact particles")
 check(w.layer().damage.has("7,12") and w.at(Vector2i(7,12))==3,"Neighbor fracture does not destroy or remotely yield ore")
 g.deep.hit(ore);check(h.in_field("iron_ore")==expected,"Repeated contact on empty ground cannot create resources")
 h.collect("stone",200,g.player)
 check(DeepHaul.amount(h.bucket())==64 and h.in_field("stone")==200,"Bucket capacity overflows into persistent local cargo without loss")
 var old=g.player;Input.action_press("right");g.deep.move(.15);Input.action_release("right")
 check(g.player.distance_to(old)>25,"Full bucket does not slow or block free movement")
 var before=h.in_field("stone");h.scavenge(g.player);check(h.in_field("stone")==before,"Automatic pickup cannot duplicate full-container overflow")
 g.player=entry;g.deep.unload()
 check(h.bucket().is_empty() and g.state.count("iron_ore")==expected,"Entrance unload transfers field ore to existing inventory")
 var stored=g.state.inventory.duplicate();g.deep.unload();check(stored==g.state.inventory,"Repeated unloading is idempotent")
 h.collect("coal",3,g.player);h.unload(g.player)
 # This goal consumes delivered ore through the original queue, with no special recipe.
 if expected==1:h.collect("iron_ore",1,g.player);h.unload(g.player)
 check(g.state.craft("iron"),"Delivered ore feeds unchanged forge recipe")
 g.state.tick(5);var coins=g.state.money
 check(g.state.trade("iron",false) and g.state.money>coins,"Delivered material can be smelted and sold through existing trade")
 g.state.add("iron",2);g.state.add("wood",6);stored=g.state.inventory.duplicate()
 check(h.build_cart(g.player) and g.state.count("iron")==int(stored.get("iron",0))-2,"Wheelbarrow construction pays exact existing cost")
 check(not h.build_cart(g.player),"Duplicate cart construction rejected without spending twice")
 h.collect("stone",300,g.player);check(DeepHaul.amount(h.cart().cargo)==300,"Parked wheelbarrow automatically accepts nearby bulk material")
 h.collect("copper_ore",50,g.player)
 check(DeepHaul.amount(h.cart().cargo)==320 and DeepHaul.amount(h.bucket())==30,"Cart fills before bucket and respects both capacities")
 h.toggle_cart(g.player);w.carve_stairs(Deepworks.ENTRY);g.deep.use_stairs(false);settle()
 check(w.depth()==1 and int(h.cart().depth)==1 and h.cart().hitched,"In-hand cart follows an actual same-XY stair connection")
 var p=g.player;h.follow(p+Vector2(5,0));check(h.cart_pos()==p+Vector2(5,0),"Wheelbarrow moves physically with its handler")
 h.toggle_cart(p);g.deep.use_stairs(true);settle()
 check(int(h.cart().depth)==1 and not h.near_cart(g.player),"Parked cart remains on its proper depth")
 h.unload(g.player);check(h.bucket().is_empty() and DeepHaul.amount(h.cart().cargo)==320,"Distant cart cannot be unloaded through another layer")
 g.deep.use_stairs(false);settle();h.toggle_cart(g.player)
 var field_before=h.in_field("stone");var cached=h.cache_cart(g.player)
 check(cached==320 and h.in_field("stone")==field_before,"Tipping wheelbarrow creates conserved marked stockpile")
 h.scavenge(g.player);check(h.cart().cargo.is_empty(),"Marked stockpile stays put instead of immediately reloading")
 check(h.load_pile(g.player)==320 and DeepHaul.amount(h.cart().cargo)==320,"One action reloads stockpile into nearby equipment")
 var cargo=h.cart().cargo.duplicate();var terrain=w.layer().cells.duplicate();g.state.hauling.project="steel";g.save_game();g.start_game(true);settle();w=g.deep.world;h=g.deep.haul
 check(same(h.cart().cargo,cargo) and int(h.cart().depth)==1,"Actual reload preserves cart cargo and location")
 check(same(w.layer().cells,terrain) and w.depth()==1,"Hauling save preserves independent depth terrain")
 check(g.state.hauling.project=="steel" and h.project().cost==HoldData.RESEARCH.extraction.cost,"Persistent ledger reads actual research costs")
 g.deep.use_stairs(true);settle();g.deep.unload()
 check(h.cart().cargo.is_empty() and h.bucket().is_empty(),"Returned cart delivers through entrance storage")
 # Distribution is coherent and valuable at multiple depths, without touching loaded cells.
 var lean=0;var rich=0;var across=0
 for y in range(16,40):
  for x in range(20,36):
   var c=Vector2i(x,y)
   if w.at(c,0)!=3:continue
   if w.grade(c,0)==0:lean+=1
   if w.grade(c,0)==2:rich+=1
   if w.at(c,1)==3:across+=1
 check(across>30,"Substantial iron lens continues at corresponding locations below")
 var grades={}
 for y in range(1,63):
  for x in range(1,79):
   var c=Vector2i(x,y)
   if w.at(c) in [3,4,5]:grades[w.yield_count(c)]=true
 check(grades.has(1) and grades.has(2) and grades.has(4),"Lean, banded and rich ores provide distinct extraction values")
 # Additive upgrade loads actual prior-save-shaped data without regenerating terrain.
 g.save_game();var path=g.state.save_path();var legacy=JSON.parse_string(FileAccess.get_file_as_string(path));legacy.erase("hauling")
 for site in legacy.deepworks.values():site.erase("haulage")
 var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(JSON.stringify(legacy));f.close();var old_cells=legacy.deepworks[g.state.active_site].layers[0].cells
 g.start_game(true);settle();h=g.deep.haul;w=g.deep.world
 check(h.bucket().is_empty() and same(w.layer(0).cells,old_cells) and same(g.state.inventory,legacy.inventory),"0.41 saves gain empty containers without changing inventory or terrain")
 # A separate site shares only the player's bucket, not parked equipment or caches.
 h.collect("coal",7,g.player);var first_world=w;g.state.active_site="claim";g.deep.ensure();var second=g.deep.haul
 check(second.in_field("coal")==7 and second.cart().is_empty(),"Personal cargo crosses sites; equipment is site-local")
 check(first_world.data!=g.deep.world.data,"Separate mine persistence remains independent")
 print("HAUL42: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
