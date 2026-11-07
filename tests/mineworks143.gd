extends "res://tests/support/game_fixture.gd"
func same(a,b)->bool:return JSON.stringify(JSON.parse_string(JSON.stringify(a)))==JSON.stringify(JSON.parse_string(JSON.stringify(b)))
func stand(c:Vector2i):
 g.player=Deepworks.center(c);g.deep.world.survey(g.player);g.camera=g.deep.camera_target();g.transition_left=0
func dig(c:Vector2i):
 for i in 16:
  if g.deep.world.at(c)==0:break
  g.deep.world.strike(c)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world
 var old_layers=w.data.layers.duplicate(true);var old_living=w.data.living.duplicate(true);var original=g.state.inventory.duplicate(true)
 var entry=HoldMineworks143.entrance(w)
 check(entry.x>=0 and w.walkable(entry,0),"Old Workings offers a reachable adit without excavating existing property")
 check(w.data.layers.size()==5,"Original five depths remain intact until annex entry")
 stand(entry);old_layers=w.data.layers.duplicate(true);key(KEY_E);settle()
 check(w.depth()==5 and w.data.layers.size()==8,"Physical E entry opens a separate Stonewright map")
 check(w.data.layers.slice(0,5)==old_layers and w.data.living==old_living,"Annex creation preserves every original layer and existing room")
 check(g.state.inventory==original,"Opening the works grants no inventory or excavation rewards")
 var empty=0
 for cell in w.layer().cells:
  if int(cell)==0:empty+=1
 check(empty<300,"Large district worksite leaves over 4,800 cells for player excavation")
 check(w.carve_stairs(Deepworks.cell(g.player)).contains("adits"),"Lateral worksite cannot be reached or escaped with a vertical shortcut")
 w.data.depth=4
 check(w.carve_stairs(Vector2i(8,8)).contains("frontier"),"Original deepest level cannot carve into an annex")
 w.data.depth=5
 var cells=w.layer().cells.duplicate();var inv=g.state.inventory.duplicate(true)
 check(HoldMineworks143.designate(w,Vector2i(14,18),Vector2i(25,29),"Hammer Row","craft").begins_with("District planned"),"Player can reserve unexcavated rock as a named craft district")
 check(w.layer().cells==cells and g.state.inventory==inv,"District plans neither excavate nor spend material")
 check(HoldMineworks143.designate(w,Vector2i(20,23),Vector2i(28,31),"Overlap","stores").contains("overlap"),"Districts cannot overlap")
 check(not HoldMineworks143.designate(w,Vector2i(-2,8),Vector2i(8,18),"Outside","craft").begins_with("District planned"),"Plans reject outside-map coordinates")
 check(not HoldMineworks143.designate(w,Vector2i(5,6),Vector2i(12,13),"Landing","hearth").begins_with("District planned"),"Plans preserve freight landings")
 stand(Vector2i(23,10));g.state.steel=false;var count=g.state.mined
 g.deep.contact=Deepworks.center(HoldMineworks143.SEAL);g.deep.hit(HoldMineworks143.SEAL)
 check(not HoldMineworks143.data(w).seal and g.state.mined==count,"Basic pick cannot open the basalt gate")
 key(KEY_E);settle();check(w.depth()==5,"E cannot bypass an unmined seal")
 g.state.steel=true
 for i in 8:g.deep.hit(HoldMineworks143.SEAL)
 check(HoldMineworks143.data(w).seal and w.at(HoldMineworks143.SEAL)==0,"Actual mining contacts remove the seal and open its adit")
 await snap("01-open-seal")
 # Existing personal and physical cart owners cross with the player.
 g.state.add("wood",30);g.state.add("iron",10);g.deep.haul.build_cart(g.player)
 var cart=g.deep.haul.cart();cart.hitched=true;cart.cargo.stone=7
 g.handworks.data().facilities.append({"id":"mineworks-test-cart","kind":"cart","area":g.handworks.context(),"x":g.player.x,"y":g.player.y,"hitched":true,"raw":[],"cargo":{"coal":3},"job":{}})
 key(KEY_E);settle()
 check(w.depth()==6 and int(cart.depth)==6 and cart.cargo.stone==7,"Field wheelbarrow and cargo cross the opened adit")
 var handcart=g.handworks.data().facilities.back()
 check(handcart.area=="mine:hold:6" and handcart.cargo.coal==3,"Physical Handworks cart retains its own cargo across maps")
 handcart.hitched=false;cart.hitched=false
 check(w.zone_distance(0,6)==2 and w.zone_distance(0,7)==999,"Navigation graph includes opened adits and excludes the broken crossing")
 stand(Vector2i(23,12));key(KEY_E)
 check(g.panel_id=="living" and g.deep.works.page=="Districts","Broken bridge opens its local project through real E input")
 await snap("02-bridge-project")
 var before=g.state.inventory.duplicate(true)
 g.state.tech.erase("stoneworking");button("Rebuild fault bridge")
 check(not HoldMineworks143.data(w).bridge and g.state.inventory==before,"Bridge requires Stoneworking without spending supplies")
 g.state.tech.stoneworking=true;g.state.inventory.stone=0;button("Rebuild fault bridge")
 check(not HoldMineworks143.data(w).bridge,"Missing materials cannot partly open the crossing")
 g.state.add("stone",30);before=g.state.inventory.duplicate(true)
 g.player=Deepworks.center(Vector2i(8,10));button("Rebuild fault bridge")
 check(not HoldMineworks143.data(w).bridge and g.state.inventory==before,"Stale remote bridge callback cannot spend or build")
 g.close_panel();stand(Vector2i(23,12))
 check(w.route(Vector2i(23,12),6,"",Vector2i(33,12)).is_empty(),"Fault has no walkable crossing before repair")
 var wall_intact=true
 for y in range(1,Deepworks.H-1):wall_intact=wall_intact and w.at(Vector2i(27,y))==8
 check(wall_intact,"Continuous fault blocks side digging along its entire length")
 await snap("03-broken-bridge")
 key(KEY_E);button("Rebuild fault bridge");g.close_panel()
 check(HoldMineworks143.data(w).bridge and g.state.count("wood")==int(before.wood)-12 and g.state.count("iron")==int(before.iron)-4 and g.state.count("stone")==int(before.stone)-8,"Repair spends exact construction materials once")
 before=g.state.inventory.duplicate(true);HoldMineworks143.repair(g)
 check(g.state.inventory==before,"Completed bridge cannot charge twice")
 check(not w.route(Vector2i(23,12),6,"",Vector2i(33,12)).is_empty(),"Rebuilt bridge creates a genuine walkable route")
 Input.action_press("right");g.deep.move(2.7);Input.action_release("right")
 check(g.player.x>Deepworks.center(Vector2i(30,12)).x and not w.solid(g.player),"Real movement crosses the restored fault")
 stand(Vector2i(33,12));await snap("04-restored-bridge");key(KEY_E);settle()
 check(w.depth()==7,"Farbank is a separate map reached through the rebuilt crossing")
 var linked=w.connections(7);check(linked.size()==1 and int(linked[0].to)==6,"Farbank retains a permanent return adit")
 stand(HoldMineworks143.return_landing(w,7));key(KEY_E);settle();stand(HoldMineworks143.return_landing(w,6));key(KEY_E);settle()
 check(w.depth()==5,"Player can return through the connected mineworks")
 # Build a real workshop in the planned district; excavation counters follow terrain.
 for y in range(19,25):
  for x in range(15,21):dig(Vector2i(x,y))
 check(g.deep.works.model.designate(Vector2i(15,19),Vector2i(20,24),"workshop").begins_with("Designated"),"Excavated district contains an ordinary functional room")
 for item in ["wood","stone","iron","coal"]:g.state.add(item,40)
 check(g.deep.works.model.place(Vector2i(16,20),"bench").ends_with("installed."),"District workshop accepts existing furnishings")
 g.deep.works.model.place(Vector2i(18,20),"anvil");g.deep.works.model.place(Vector2i(19,22),"lamp")
 var district=HoldMineworks143.district_at(w,Vector2i(16,20))
 check(HoldMineworks143.progress(w,district).contains("1 rooms"),"District summary counts real excavations and rooms")
 check(not g.deep.works.model.place(HoldMineworks143.return_landing(w,5),"lamp").ends_with("installed."),"Furniture cannot obstruct a portal landing")
 stand(Vector2i(17,23));g.deep.works.page="Districts";g.open_panel("living")
 await snap("05-district-board");g.close_panel();await snap("06-workshop-district")
 var original_name=district.name;district.name="WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
 await snap("08-long-district-name");district.name=original_name
 # The district board's real button enters the existing two-corner placement mode.
 g.deep.works.page="Districts";g.open_panel("living");button("Store district")
 check(g.panel_id=="" and g.deep.works.mode=="district" and g.deep.works.selected=="stores","District button enters the player placement workflow")
 g.deep.works.cancel()
 # Hired actors use the same opened graph, not numerical depth increments.
 var original_claim=g.state.claim_id;g.state.claim_id="legacy";g.state.agents_enabled=true
 var actor={"id":"mineworks-worker","type":"worker","p":Deepworks.center(entry),"path":[],"target":Vector2i(-1,-1),"cool":0.0,"fuel":100.0,"work":false,"status":""}
 g.agents=[actor];w.data.crew[actor.id]={"depth":0,"assigned":5,"x":Deepworks.center(entry).x,"y":Deepworks.center(entry).y}
 g.deep.agents(.1)
 check(int(g.deep.crew_entry(actor).depth)==5 and actor.p.distance_to(Deepworks.center(HoldMineworks143.return_landing(w,5)+Vector2i.DOWN*2))<1,"A hired worker crosses the physical adit to its assigned zone")
 g.agents=[];w.data.crew.erase(actor.id);g.state.claim_id=original_claim
 var saved=w.data.duplicate(true);var expected_position=g.player;g.save_game();g.start_game(true);settle();w=g.deep.world
 check(w.depth()==5 and g.player.distance_to(expected_position)<1 and same(w.data.mineworks143,saved.mineworks143),"Reload retains zone, district names and both opened gates")
 check(same(w.data.layers,saved.layers) and same(w.data.living,saved.living),"Reload preserves excavated terrain and real furnishings")
 g.deep.works.page="Districts";g.open_panel("living");button("Remove plan: Hammer Row");g.close_panel()
 check(w.data.mineworks143.districts.is_empty() and same(w.data.living,saved.living) and same(w.data.layers,saved.layers),"Removing a district plan preserves all player work")
 # Original depth access, original rooms and site ownership remain independent.
 stand(HoldMineworks143.return_landing(w,5));key(KEY_E);settle();check(w.depth()==0,"Old Workings remains the entrance and return location")
 check(same(w.data.layers[1],old_layers[1]) and same(w.data.layers[4],old_layers[4]),"Original untouched depths survive annex travel and saves")
 g.depth_nav.explore.enabled=true;g.depth_nav.explore.mouse_look=false;g.depth_nav.update(0)
 await snap("07-adit-perspective")
 g.depth_nav.explore.enabled=false
 print("MINEWORKS143: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
