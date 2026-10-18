extends SceneTree
var passed=0
var failed=0
var g
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func same(a,b)->bool:return JSON.stringify(JSON.parse_string(JSON.stringify(a)))==JSON.stringify(JSON.parse_string(JSON.stringify(b)))
func keypress(k:int,shift:bool=false):
 var e=InputEventKey.new();e.keycode=k;e.physical_keycode=k;e.pressed=true;e.shift_pressed=shift;g._unhandled_input(e)
func _initialize():call_deferred("run")
func reset_transition():g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
func tunnel(to:Vector2i):
 var w=g.deep.world;var c=Deepworks.cell(g.player)
 while c!=to:
  c+=Vector2i(signi(to.x-c.x),0) if c.x!=to.x else Vector2i(0,signi(to.y-c.y))
  for j in 5:
   if w.at(c)==0:break
   g.deep.contact=Deepworks.center(c);g.deep.hit(c)
  g.player=Deepworks.center(c);w.survey(g.player)
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);reset_transition()
 check(g.playing and g.zone=="hub","Existing title/new game initializes settlement")
 g.state.opening=1;g.grounded=true;g.arrive_region("workings");reset_transition()
 check(g.zone=="mine" and g.deep.world.depth()==0,"Settlement basin arrival enters integrated Deepworks")
 var w=g.deep.world
 check(w.data.layers.size()==5,"Five independent geological layers")
 check(w.data==Deepworks.generate(g.state.seed_value) or w.data.layers[1]==Deepworks.generate(g.state.seed_value).layers[1],"Seed generation reproducible before excavation")
 var old=g.player;Input.action_press("up");Input.action_press("right");g.deep.move(.2);Input.action_release("up");Input.action_release("right")
 check(g.player.x>old.x and g.player.y<old.y and absf(g.player.distance_to(old)-37)<.1,"Normalized eight-direction movement without gravity")
 var p=g.player;g.deep.move(.3);check(g.player==p,"Standing dwarf does not fall")
 g.player=Deepworks.center(Deepworks.ENTRY)
 Input.action_press("left");g.deep.move(2);Input.action_release("left")
 check(not w.solid(g.player) and g.player.x>=170,"Substepped collision prevents wall tunnelling")
 g.player=Deepworks.center(Vector2i(11,8));var ore=Vector2i(12,8);var coal=g.deep.haul.in_field("coal");var coal_yield=w.yield_count(ore)
 check(w.target(g.player,Deepworks.center(ore))==ore,"Accurate first exposed face targeting")
 g.deep.contact=Vector2(480,g.player.y);g.deep.hit(ore)
 check(w.at(ore)==0 and g.deep.haul.in_field("coal")==coal+coal_yield,"Mining contact removes coal and loads the ore container")
 g.deep.hit(ore);check(g.deep.haul.in_field("coal")==coal+coal_yield,"Exhausted terrain cannot duplicate rewards")
 check(w.target(g.player,Deepworks.center(Vector2i(16,8)))!=Vector2i(16,8),"Target ray never mines through a blocking wall")
 tunnel(Vector2i(8,11));var iron=g.deep.haul.in_field("iron_ore");var ic=Vector2i(8,12);var iron_yield=w.yield_count(ic)
 g.deep.hit(ic);check(w.at(ic)==3,"Iron resists the first basic pick contact")
 g.deep.hit(ic);check(w.at(ic)==0 and g.deep.haul.in_field("iron_ore")==iron+iron_yield,"Iron yields on second contact")
 # Lean ore yields one unit; harvest a second real face for the unchanged two-ore recipe.
 g.player=Deepworks.center(Vector2i(7,11));g.deep.contact=Deepworks.center(Vector2i(7,12))
 for i in 2:g.deep.hit(Vector2i(7,12))
 g.player=Deepworks.center(Vector2i(8,10));var c=Deepworks.cell(g.player)
 var before=g.state.inventory.duplicate();var stairs=w.carve_stairs(c)
 check(w.can_descend(c,0) and before==g.state.inventory,"Carved stairs persist without granting clearance resources")
 keypress(KEY_E);reset_transition();check(w.depth()==1 and Deepworks.cell(g.player)==c,"E descends at matching XY coordinates")
 keypress(KEY_E,true);reset_transition();check(w.depth()==0 and Deepworks.cell(g.player)==c,"Shift E returns by the same stair")
 check(not w.traverse(c+Vector2i(3,3),false),"No traversal through unrelated or absent passages")
 g.state.steel=true
 keypress(KEY_E);reset_transition();w.carve_stairs(c);keypress(KEY_E);reset_transition()
 check(w.depth()==2,"Player-created chain reaches third depth")
 g.state.steel=false
 w.set_cell(c+Vector2i.RIGHT,7);var stone=g.state.count("stone")
 check(w.strike(c+Vector2i.RIGHT).get("blocked",false) and g.state.count("stone")==stone,"Basalt retains steel research requirement")
 g.state.steel=true;w.strike(c+Vector2i.RIGHT);w.strike(c+Vector2i.RIGHT)
 check(w.at(c+Vector2i.RIGHT)==0,"Steel pick opens basalt")
 w.carve_stairs(c);keypress(KEY_E);reset_transition();w.carve_stairs(c);keypress(KEY_E);reset_transition()
 check(w.depth()==4 and not w.can_descend(c,4),"Fifth depth reachable; frontier has no invalid sixth map")
 var rare=w.layer().features[5];var crystals=g.state.count("crystal")
 w.survey(Deepworks.center(Vector2i(rare.x,rare.y)))
 check(rare.found and g.state.count("crystal")==crystals+3,"Rare deep formation grants a one-time geological discovery reward")
 w.survey(Deepworks.center(Vector2i(rare.x,rare.y)))
 check(g.state.count("crystal")==crystals+3,"Rediscovering a landmark cannot duplicate its reward")
 for i in 4:keypress(KEY_E,true);reset_transition()
 check(w.depth()==0,"Entire stair chain returns to surface level")
 # Follow a naturally generated seam into a real cavern, without replacing its terrain.
 var feature=w.layer().features[0];tunnel(Vector2i(feature.x,feature.y));w.survey(g.player)
 check(feature.found and not w.data.discoveries.is_empty(),"Breaking through natural geology discovers named cavern")
 w.layer().fixtures[Deepworks.key(Deepworks.cell(g.player))]="lamp"
 w.layer().damage["20,20"]=1.0
 var changed=w.layer().cells.duplicate();var deepcells=w.layer(2).cells.duplicate();var links=w.data.links.duplicate(true)
 g.save_game();g.start_game(true);reset_transition();w=g.deep.world
 check(same(w.layer().cells,changed) and same(w.layer(2).cells,deepcells),"Actual save/load preserves separate excavated layers")
 check(same(w.data.links,links) and w.data.discoveries.size()>0,"Connections and discoveries survive actual reload")
 check(Deepworks.cell(g.player)==Vector2i(feature.x,feature.y),"Reload restores underground position")
 check(w.layer().fixtures.get(Deepworks.key(Deepworks.cell(g.player)),"")=="lamp" and float(w.layer().damage.get("20,20",0))==1.0,"Built fixtures and partial mining damage survive reload")
 tunnel(Deepworks.ENTRY);g.deep.use_stairs(false)
 check(g.panel_id=="basin_map","Entrance interaction opens existing return travel")
 g.close_panel();g.grounded=true;g.arrive_region("hold");reset_transition()
 check(g.zone=="hub","Return to existing settlement via basin")
 check(g.state.craft("iron"),"Collected ore/coal use existing smelting recipe")
 g.state.tick(5);check(g.state.count("iron")>=1,"Existing forge production completes")
 var money=g.state.money;check(g.state.trade("iron",false) and g.state.money>money,"Collected resources enter existing market economy")
 g.arrive_region("forest");reset_transition();check(g.zone=="road","Pinewood remains independently reachable")
 HoldForestry.ensure(g.state);var trees=g.state.road_trees.duplicate();g.save_game();g.start_game(true);reset_transition()
 check(g.zone=="road" and same(g.state.road_trees,trees),"Pinewood state survives Deepworks save/load")
 # Migration uses an actual legacy-shaped on-disk save, and retains its bytes.
 g.save_game();var path=g.state.save_path();var legacy=JSON.parse_string(FileAccess.get_file_as_string(path));legacy.erase("deepworks")
 var text=JSON.stringify(legacy);var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(text);f.close()
 var before_inventory=g.state.inventory.duplicate();g.start_game(true);reset_transition()
 check(g.state.deepworks_migrated and g.state.inventory==before_inventory,"Legacy migration preserves inventory/progression")
 var dir=DirAccess.open("user://");var exact=false
 for name in dir.get_files():
  if ".pre-deepworks-" in name and FileAccess.get_file_as_string("user://"+name)==text:exact=true
 check(exact,"Migration creates byte-exact recoverable old save")
 check(same(g.geo.cells,legacy.cells) and same(g.geo.structures,legacy.structures),"Legacy terrain and structures remain archived, unmodified")
 # Existing recruitment system, physical worker pathfinding and multi-depth assignment.
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.opening=4;g.state.worker=true;g.state.automaton=true;g.state.add("food",100);g.state.add("coal",100)
 g.travel_claim();reset_transition();g.change_zone("mine");reset_transition();w=g.deep.world;g.state.steel=true
 check(g.agents.size()>=2,"Existing worker and automaton populate claim mine")
 var minerals=g.state.mined
 for i in 600:g.deep.agents(.1)
 check(g.state.mined>minerals,"Crew physically navigate and excavate layered terrain")
 g.player=Deepworks.center(Deepworks.ENTRY);w.carve_stairs(Deepworks.ENTRY);g.deep.use_stairs(false);reset_transition();g.deep.assign_crew()
 for i in 1200:g.deep.agents(.1)
 var all_down=true
 for a in g.agents:all_down=all_down and int(g.deep.crew_entry(a).depth)==1
 check(all_down,"Worker and automaton follow real stair route to assigned depth")
 var saved_crew=w.data.crew.duplicate(true);g.save_game();g.start_game(true);reset_transition();w=g.deep.world
 check(same(w.data.crew,saved_crew) and w.depth()==1,"Crew depth, positions and assignments survive reload")
 # Existing powered tool consumes energy and converts metal to slag.
 var tc=Deepworks.cell(g.player)+Vector2i.RIGHT;w.set_cell(tc,3);g.state.outpost.mining_gun=true;g.state.outpost.gun_charge=0;g.state.add("energy_cell",1)
 var cells=g.state.count("energy_cell");var slag=g.deep.haul.in_field("iron_slag");var slag_yield=w.yield_count(tc);g.deep.contact=Deepworks.center(tc);g.deep.hit(tc,true)
 check(g.state.count("energy_cell")==cells-1 and g.deep.haul.in_field("iron_slag")==slag+slag_yield,"Slagcaster uses existing cells and slag economy")
 check(HoldState.slot_summary(g.state.save_slot).valid,"New saves remain compatible with existing slot selector")
 print("DEEPWORKS41: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
