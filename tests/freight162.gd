extends "res://tests/support/game_fixture.gd"
const LANDING=Vector2i(54,34)
func normal(v):return JSON.parse_string(JSON.stringify(v))
func stand(c:Vector2i):g.player=Deepworks.center(c);g.transition_left=0
func build_room(p):
 var bounds=p.bounds(p.chosen())
 for attempt in 8:
  for c in [bounds.get_center(),bounds.position+Vector2i.ONE,Vector2i(bounds.end.x-2,bounds.position.y+1),bounds.end-Vector2i(2,2),Vector2i(bounds.position.x+1,bounds.end.y-2)]:
   stand(c);p.work()
  if p.remaining(p.chosen()).is_empty():break
 check(p.remaining(p.chosen()).is_empty(),"Build room through paid blueprint construction")
func worker()->Dictionary:return g.agents.filter(func(a):return a.id=="brann")[0]
func advance(count:int):
 for i in count:g.deep.agents(.1)
func advance_until_home(count:int):
 for i in count:
  g.state.elapsed+=.1;g.deep.agents(.1)
  if worker().status=="Resting at home":break
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 print("FREIGHT162 setup: loading scene")
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 print("FREIGHT162 setup: starting game")
 g.start_game(false)
 print("FREIGHT162 setup: warming characters")
 settle()
 print("FREIGHT162 setup: ready")
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 g.state.money=10000
 for tech in HoldData.RESEARCH:g.state.tech[tech]=true
 g.surface.enter("claim",Deepworks.center(LANDING));settle();g.deep.ensure()
 var p=g.surface.architecture.room_blueprints;var h=g.surface.house;var w=g.deep.world
 check(p.save_rectangle(Vector2i(50,30),Vector2i(58,38)),"Plan household around cellar")
 build_room(p)
 # Old-save fixture: excavated mine approach, not free excavation by the feature.
 for x in range(8,55):w.set_cell(Vector2i(x,8),0,0)
 for y in range(8,38):w.set_cell(Vector2i(54,y),0,0)
 for y in range(31,38):
  for x in range(51,58):w.set_cell(Vector2i(x,y),0,0)
 stand(LANDING);check(HoldEstateCellar.plan(g) and HoldEstateCellar.fit(g),"Fit existing cellar stairs normally")
 stand(Vector2i(52,32));check(HoldUpperBlueprints.plan(p) and HoldUpperBlueprints.build(p),"Fit paid upper-floor stairs")
 key(KEY_E);settle();p.choose_level(1)
 check(h.level()==1 and p.save_rectangle(Vector2i(50,30),Vector2i(58,38)),"Plan upstairs bedroom")
 build_room(p);stand(Vector2i(54,36));g.surface.start_placement("chest")
 check(g.surface.place(Deepworks.center(Vector2i(52,36))),"Place actual upstairs chest")
 check(HoldOutpost.recruit(g.state,"brann") and HoldOutpost.assign(g.state,"brann","miner"),"Recruit an existing worker through normal crew owner")
 g.spawn_agents();g.state.agents_enabled=true
 var chest_id="chest:"+str(int(g.state.surface.next_chest)-1)
 var chest=g.state.surface.chests[chest_id]
 var pile_cell=Vector2i(54,28);var a=worker();var saved=g.deep.crew_entry(a)
 g.deep.haul.bucket().stone=64
 g.deep.haul.unload(Deepworks.center(pile_cell))
 var pile_id=g.deep.haul.pile_id(pile_cell);var pile=g.deep.haul.data.piles[pile_id]
 var before=normal(g.state.inventory);var original_assignment=saved.assigned
 check(pile.marked and int(pile.cargo.stone)==64,"Create actual marked stockpile through existing unload action")
 check(HoldEstateFreight.assign(g,"ivar",pile_id,chest_id,"stone",true).contains("Recruit"),"Reject borrowed crew")
 check(HoldEstateFreight.assign(g,"brann",pile_id,"keldrath:quarters","stone",true).contains("Choose"),"Reject non-household stores")
 g.surface.architecture.room_planning=true;g.open_panel("architecture");button("Arrange freight route")
 check(HoldEstateFreight.orders(g).has("brann"),"Real book control creates the freight route")
 for frame in 4:await process_frame
 for scroll in g.panel.find_children("*","ScrollContainer",true,false):scroll.scroll_vertical=10000
 if DisplayServer.get_name()!="headless":await snap("01-freight-controls")
 g.close_panel();g.state.elapsed=30
 var r=HoldEstateFreight.orders(g).brann
 check(normal(g.state.inventory)==before and chest.items.is_empty(),"Arrangement neither spends nor transfers remote stock")
 for i in 1000:
  g.deep.agents(.1)
  if not r.cargo.is_empty():break
 check(int(r.cargo.get("stone",0))==32 and int(pile.cargo.get("stone",0))==32,"Worker reaches the mine pile and lifts one bounded load")
 check(chest.items.is_empty(),"Pickup does not deliver remotely")
 check(g.deep.haul.in_field("stone")==64,"Field accounting includes carried freight exactly once")
 check(HoldEstateFreight.assign(g,"brann",pile_id,chest_id,"wood",false).contains("Finish"),"Cannot replace an order that owns cargo")
 advance(3);var mid=Vector2(saved.x,saved.y)
 g.save_game();g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle()
 a=worker();saved=g.deep.crew_entry(a);w=g.deep.world;h=g.surface.house;p=g.surface.architecture.room_blueprints
 r=HoldEstateFreight.orders(g).brann;pile=g.deep.haul.data.piles[pile_id];chest=g.state.surface.chests[chest_id]
 check(Vector2(saved.x,saved.y)==mid and int(r.cargo.get("stone",0))==32,"Cold reload preserves exact position and the single carried load")
 w.set_cell(Vector2i(54,30),1,0);advance(120)
 check(saved.get("estate_area160","mine")=="mine" and float(saved.y)<1220,"A new mine obstruction stops loaded travel")
 check(int(r.cargo.get("stone",0))==32 and chest.items.is_empty(),"Blocked freight remains with its carrier")
 w.set_cell(Vector2i(54,30),0,0)
 HoldEstateFreight.stop(g,"brann")
 for i in 400:
  g.deep.agents(.1)
  if saved.get("estate_area160","")=="surface" and int(saved.get("estate_z160",0))==1:break
 check(saved.get("estate_area160","")=="surface" and int(saved.get("estate_z160",0))==1 and not r.cargo.is_empty(),"Loaded worker physically crosses cellar and upper stairs")
 check(HoldEstateWorkers.objects(g).size()==1,"Freight worker renders once on the household floor")
 var upper_position=Vector2(saved.x,saved.y);g.save_game();g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle()
 a=worker();saved=g.deep.crew_entry(a);w=g.deep.world;h=g.surface.house;p=g.surface.architecture.room_blueprints
 r=HoldEstateFreight.orders(g).brann;pile=g.deep.haul.data.piles[pile_id];chest=g.state.surface.chests[chest_id]
 check(saved.get("estate_area160","")=="surface" and int(saved.estate_z160)==1 and Vector2(saved.x,saved.y)==upper_position and int(r.cargo.get("stone",0))==32,"Upstairs cold reload preserves floor, location and cargo")
 if DisplayServer.get_name()!="headless":await snap("02-upstairs-carrier")
 advance(120)
 check(r.cargo.is_empty() and int(chest.items.get("stone",0))==32 and int(pile.cargo.get("stone",0))==32,"Stop finishes the current delivery without taking another load")
 var after=normal(g.state.inventory)
 for item in before:
  if before[item]!=after.get(item,0):print("FREIGHT162 pack delta ",item,": ",before[item]," -> ",after.get(item,0))
 var food_spent=int(before.food)-int(after.food);after.food=before.food
 check(after==before and food_spent>=0 and food_spent<=2,"Delivery preserves pack materials and only uses ordinary crew provisions")
 check(int(saved.assigned)==int(original_assignment),"Freight preserves the existing mine assignment")
 # Reverse route, then return a picked-up load to its source.
 HoldEstateFreight.assign(g,"brann",pile_id,chest_id,"stone",false);r=HoldEstateFreight.orders(g).brann
 for i in 400:
  g.deep.agents(.1)
  if not r.cargo.is_empty():break
 check(int(r.cargo.get("stone",0))==32 and chest.items.is_empty(),"Reverse freight picks up from the actual chest")
 advance(4);HoldEstateFreight.stop(g,"brann",true);advance(200)
 check(r.cargo.is_empty() and int(chest.items.get("stone",0))==32,"Returning a load restores its original source exactly once")
 # Empty/dismantle the destination through existing local storage controls.
 g.surface.selected_chest=chest_id;g.player=Vector2(chest.x,chest.y)+Vector2(0,60)
 check(g.surface.transfer("stone",32,false)==32,"Existing chest withdrawal still owns the transaction")
 HoldEstateFreight.assign(g,"brann",pile_id,chest_id,"stone",true);r=HoldEstateFreight.orders(g).brann
 for i in 400:
  g.deep.agents(.1)
  if not r.cargo.is_empty():break
 check(int(r.cargo.get("stone",0))==32,"Second trip picks up only the remaining stock")
 check(g.surface.recover_chest(),"Dismantle the now-empty destination normally")
 advance(50)
 check(int(r.cargo.get("stone",0))==32 and a.status.contains("missing"),"Missing destination holds cargo with a truthful status")
 HoldEstateFreight.stop(g,"brann",true);advance(300)
 check(r.cargo.is_empty() and int(pile.cargo.get("stone",0))==32,"Missing-chest cargo can return physically to the mine source")

 # A second route spans an existing deeper mine ladder as well as both home stairs.
 stand(Vector2i(54,36));g.surface.start_placement("chest")
 check(g.surface.place(Deepworks.center(Vector2i(52,36))),"Build replacement chest through ordinary furnishing")
 chest_id="chest:"+str(int(g.state.surface.next_chest)-1);chest=g.state.surface.chests[chest_id]
 for y in range(23,28):
  for x in range(53,56):w.set_cell(Vector2i(x,y),0,1)
 check(w.carve_stairs(Vector2i(54,24),"ladder").begins_with("Timber ladder fitted"),"Fit a real deeper-mine ladder with paid materials")
 w.data.depth=1;DeepHaul.transfer(pile.cargo,g.deep.haul.bucket(),7);g.deep.haul.unload(Deepworks.center(Vector2i(54,26)))
 var deep_id=g.deep.haul.pile_id(Vector2i(54,26));var deep_pile=g.deep.haul.data.piles[deep_id];w.data.depth=0
 HoldEstateFreight.assign(g,"brann",deep_id,chest_id,"stone",true);r=HoldEstateFreight.orders(g).brann
 g.state.elapsed=95;var untouched=normal(deep_pile.cargo)
 check(not HoldEstateFreight.tick(g,a,saved,.1) and normal(deep_pile.cargo)==untouched,"Unladen freight yields to the crew rest period")
 g.state.elapsed=30
 for i in 500:
  g.deep.agents(.1)
  if not r.cargo.is_empty():break
 check(int(saved.depth)==1 and int(r.cargo.get("stone",0))==7,"Carrier physically descends to a deeper stockpile and takes the final partial load")
 HoldEstateFreight.stop(g,"brann");w.set_cell(Vector2i(54,24),1,0);advance(150)
 check(int(saved.depth)==1 and int(r.cargo.get("stone",0))==7 and chest.items.is_empty(),"Blocked upper end of a mine ladder holds the load below")
 w.set_cell(Vector2i(54,24),0,0);advance(400)
 check(r.cargo.is_empty() and int(chest.items.get("stone",0))==7 and deep_pile.cargo.is_empty(),"Deeper-mine freight reaches the upstairs chest with exact conservation")
 var other_before=normal(saved);g.state.active_site="hold"
 check(not HoldEstateFreight.tick(g,a,saved,.1) and normal(saved)==other_before,"Other worksites are untouched")
 g.state.active_site="claim"
 print("FREIGHT162: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
