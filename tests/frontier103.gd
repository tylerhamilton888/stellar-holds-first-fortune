extends "res://tests/support/game_fixture.gd"
func desk(key:String):
 g.surface.enter(HoldFrontier103.room(g.state,key));settle();at(Vector2(480,500));g.open_panel("frontier103")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not HoldFrontier103.active(g.state),"Legacy fortune retains existing geography")
 HoldFirstVisit99.begin(g);settle()
 var s=g.state;var d=HoldFrontier103.data(s)
 check(g.surface.area==HoldFrontier103.lodge(s) and s.claim_id=="copper_ridge" and d.home169.seeded,"New fortune starts with the family-purchased Rise")
 check(g.surface.walkable(g.player),"Bunkhouse arrival is clear")
 var enclosed_map={}
 for y in 5:
  for x in 5:
   enclosed_map[str(x)+","+str(y)]={"floor":"stone_floor","roof":true,"wall":"wall" if x==0 or y==0 or x==4 or y==4 else ""}
 enclosed_map["2,4"].wall="door"
 check(HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"Piece-built home needs an enclosed room with a door")
 enclosed_map["2,2"].roof=false
 check(not HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"Missing roof cannot earn finished-home marks")
 enclosed_map["2,2"].roof=true;enclosed_map.erase("0,2")
 check(not HoldFrontier103.enclosed(enclosed_map,{},Vector2i(2,2)),"An open wall cannot earn finished-home marks")
 check(HoldWorkerLodge100.people(g).size()==3,"Foreman and miners inhabit the shared bunkhouse")
 await snap("bunkhouse")
 var a=g.surface.architecture
 for key in HoldFrontier103.BUILDINGS:
  var b=a.record(str(d.buildings[key]));check(HoldBuildingPlans.catalogue().has(b.plan),"Town uses player-buildable plan: "+key)
  g.surface.enter("trail");settle();at(Vector2(b.x,b.y+45))
  check(g.surface.walkable(g.player),"Public building doorway clear: "+key)
  g.surface.enter(HoldFrontier103.room(s,key));settle()
  check(g.surface.walkable(g.player),"Public building interior entry clear: "+key)
  if b.rooms.size()>1:
   var stairs=HoldBuildingPlans.stair_position(g.surface.area)
   check(g.surface.walkable(stairs+Vector2(0,35)),"Lower stair landing clear: "+key)
   a.stairs(true);settle()
   check(a.current_floor()==1 and g.surface.walkable(g.player),"Real upper floor reachable: "+key)
   a.stairs(false);settle();check(a.current_floor()==0,"Same stair returns to ground floor")
  check(not g.surface.recover_decor() and not g.surface.can_furnish(),"Public furniture is protected")
  check(not a.add_floor() and not a.expand("extend_x") and not a.recover(),"Shared town shell protected from free recovery")
 desk("lodge");check(not HoldFrontier103.permit(g),"Civic recognition still requires contributions")
 check(HoldFrontier103.opportunities(s) and not HoldFirstVisit99.data(s).rewarded,"Work and civic opportunities do not require the optional first shift")
 s.add("coal",8)
 HoldFirstVisit99.data(s).rewarded=true
 desk("forge");button("Inspect the cold hearth")
 HoldWork132.produced(s,"coal",1,"cut")
 desk("lodge");at(Vector2(670,425));check(HoldLedger137.contribute(g,"forge","coal",8),"Ledger accepts forge fuel")
 desk("forge");button("Relight the communal forge")
 check(s.opening==2,"Local foreman accepts real coal and relights communal forge")
 check(g.opening_scene is HoldQuestScene181,"First firing opens its narrative scene")
 if g.opening_scene is HoldQuestScene181:g.opening_scene.finish()
 desk("forge");s.add("iron_ore",4);s.add("coal",2)
 check(HoldFrontier103.transact(g,"craft","iron") and s.queue.size()>0,"Local forge starts real smelting")
 g.player=Vector2(230,560);check(not HoldFrontier103.transact(g,"craft","iron"),"Remote forge callback blocked")
 desk("watch");s.money=1000
 var before=s.count("food");check(HoldFrontier103.transact(g,"trade","food",true) and s.count("food")==before+1,"Watch stores sell real supplies")
 desk("survey");await snap("survey-office")
 g.surface.architecture.stairs(true);settle();await snap("upper-archive")
 at(Vector2(690,575));key(KEY_E);check(g.panel_id=="frontier_archive103" and g.menu_paused,"Upper archive has readable town records and charter law");await snap("archive-text");g.close_panel()
 g.surface.enter("trail");settle();at(Vector2(520,680));await snap("town-west")
 at(Vector2(1480,680));await snap("town-east")
 for day in 15:
  s.elapsed=day*600
  for actor in g.surface.roads.people("trail"):
   if actor.interaction=="road_folk:8":
    at(actor.p+Vector2(0,22));HoldPeople.chat(g,"road_folk:8")
 check(int(HoldPeople.records(s)["road_folk:8"].bond)==10,"Skarrin accepts help but never reaches genuine trusted friendship")
 for t in range(0,80,5):
  for actor in g.surface.roads.people("trail",t):check(g.surface.walkable(actor.p),"Town route stays clear: "+actor.name)
 g.surface.enter("hearthward");check(g.surface.area=="trail","Keldrath remains a later journey")
 desk("lodge");HoldFirstVisit99.data(s).rewarded=true
 g.refresh_panel();await snap("rise-offer")
 g.menu_scroll.scroll_vertical=10000;await snap("rise-offer-scrolled")
 at(Vector2(230,560));check(not HoldFrontier103.offer_rise(g),"Remote provisional offer rejected")
 at(Vector2(480,500));var coins=s.money
 check(HoldFrontier103.offer_rise(g),"Owner can ask Ivar to show the Rise")
 check(not HoldFrontier103.provisional(s) and not d.permit and s.money==coins,"Ownership is distinct from civic recognition")
 check(not HoldFrontier103.offer_rise(g),"Property introduction cannot repeat")
 check(g.opening_scene is HoldClaimScene127 and g.opening_scene.mode=="rise","Ivar stages property introduction in the world")
 if g.opening_scene is HoldClaimScene127:
  g.opening_scene.set_process(false)
  for actor in g.opening_scene.cast:
   for t in [0.0,.25,.5,.75,1.0]:check(g.surface.walkable(actor.from.lerp(actor.to,t)),"Ivar's introduction route stays clear")
  g.opening_scene.tick(3.0);await snap("rise-introduction")
  g.opening_scene.advance()
 g.save_game();g.start_game(true);settle();s=g.state;d=HoldFrontier103.data(s);a=g.surface.architecture
 check(g.opening_scene is HoldClaimScene127 and g.opening_scene.mode=="rise" and g.opening_scene.step==1,"Reload resumes property scene at saved beat")
 if g.opening_scene is HoldClaimScene127:
  g.opening_scene.set_process(false);g.opening_scene.tick(3.0);await snap("rise-tenure")
  g.opening_scene.finish()
 check(not HoldFrontier103.rise_pending(s) and not d.permit,"Skipping scene neither repeats nor awards permanent charter")
 check(not HoldClaim127.eligible(s),"Property introduction does not advance campaign authentication")
 desk("lodge");check(not HoldFrontier103.permit(g),"Provisional holder still needs two contributions")
 check("Two civic projects" in HoldFrontier103.tenure_text(s),"Provisional dialogue states outstanding requirement")
 await snap("rise-provisional-book")
 g.menu_scroll.scroll_vertical=10000;await snap("rise-provisional-scrolled")
 g.surface.enter("claim");settle()
 s.surface.chests["rise165-proof"]={"area":"claim","x":1900,"y":1100,"z":0,"items":{"stone":7}}
 s.surface.homes[s.claim_id].building.tiles["50,20"]={"floor":"stone_floor","wall":"","roof":false}
 s.surface.decor.append({"area":"claim","kind":"chair","x":2100,"y":700,"z":0})
 s.camp_stage=1
 var property_before=JSON.stringify(s.surface.homes[s.claim_id]);var chest_before=JSON.stringify(s.surface.chests["rise165-proof"]);var decor_before=JSON.stringify(s.surface.decor)
 desk("lodge")
 for id in ["watch","rest"]:
  for item in HoldGreatClaim102.PROJECTS[id].cost:s.add(item,HoldGreatClaim102.PROJECTS[id].cost[item])
  at(Vector2(670,440));check(HoldGreatClaim102.contribute(g,id),"Real civic delivery earns settlement progress")
 check("contributions are entered" in HoldFrontier103.tenure_text(s),"Ready charter dialogue recognizes completed contributions")
 at(Vector2(480,500));check(HoldFrontier103.permit(g) and s.claim_id!="","Two projects earn civic recognition on the same holding")
 check(not HoldFrontier103.permit(g),"Residential permit cannot repeat")
 check(not HoldFrontier103.provisional(s) and s.camp_stage==1,"Charter upgrades tenure without resetting development")
 check(JSON.stringify(s.surface.homes[s.claim_id])==property_before and JSON.stringify(s.surface.chests["rise165-proof"])==chest_before and JSON.stringify(s.surface.decor)==decor_before,"Permanent charter preserves exact property and stocked chest")
 check("household is recorded" in HoldFrontier103.tenure_text(s),"Owner dialogue no longer offers provisional or unearned land")
 s.add("food",2);check(HoldOutpost.recruit(s,"brann"),"Recruit a real worker before the migration check")
 # Simulate each prior tenure state, then use the real load migration.
 for permanent in [false,true]:
  d.erase("home169");d.permit=permanent;d.rise165={"accepted":true,"scene":false,"beat":0}
  s.outpost.name="My saved household"
  var estate=JSON.parse_string(JSON.stringify(s.surface.homes));var stock=JSON.parse_string(JSON.stringify(s.surface.chests));var furnishings=JSON.parse_string(JSON.stringify(s.surface.decor));var workers=JSON.parse_string(JSON.stringify(s.outpost))
  g.save_game();g.start_game(true);settle();s=g.state;d=HoldFrontier103.data(s);a=g.surface.architecture
  check(HoldFrontier103.family(s) and not HoldFrontier103.provisional(s) and d.permit==permanent,"Legacy tenure migrates without revoking recognition")
  check(not d.home169.seeded and s.outpost.name=="My saved household","Migration never seeds a cottage over an existing household")
  check(JSON.parse_string(JSON.stringify(s.surface.homes))==estate and JSON.parse_string(JSON.stringify(s.surface.chests))==stock and JSON.parse_string(JSON.stringify(s.surface.decor))==furnishings and JSON.parse_string(JSON.stringify(s.outpost))==workers,"Migration preserves exact buildings, stocked chests, furnishings and workers")
 g.refresh_panel();await snap("rise-permanent-book")
 g.menu_scroll.scroll_vertical=10000;await snap("rise-permanent-scrolled")
 for item in {"stone":30,"wood":24,"iron":2}:s.add(item,{"stone":30,"wood":24,"iron":2}[item])
 HoldWork132.produced(s,"iron",2,"made");HoldWork132.produced(s,"wood",4,"cut");HoldWork132.data(s).facts.cart_distance=160
 for item in HoldCampaign138.STRUCTURE:
  at(Vector2(670,440));check(HoldLedger137.contribute(g,"storehouse",item,int(HoldCampaign138.STRUCTURE[item])),"Deliver storehouse supplies through Ledger")
 g.surface.enter("trail");settle();at(HoldCampaign138.SITE);check(HoldCampaign138.inspect(g),"Inspect the real construction site")
 check(HoldCampaign138.assemble(g) and not HoldCampaign138.assemble(g),"Construction site becomes one actual storehouse exactly once")
 g.fieldwork.data().kit=true;HoldWork132.produced(s,"river_fish",4,"caught");HoldWork132.cooked(s,"trout_supper");s.add("food",12)
 desk("lodge");at(Vector2(670,440));check(HoldLedger137.contribute(g,"winter","food",12),"Deliver the storehouse provisions")
 g.surface.enter("trail");settle();at(HoldCampaign138.SITE);check(HoldCampaign138.stock(g),"Open the stocked public building")
 g.surface.enter("trail");settle();at(Vector2(1020,940));await snap("completed-storehouse")
 for t in range(0,80,5):
  for actor in g.surface.roads.people("trail",t):check(g.surface.walkable(actor.p),"Completed storehouse preserves patrol: "+actor.name)
 town_routes()
 desk("stores");check(g.surface.walkable(g.player) and HoldFrontier103.transact(g,"trade","food",true),"Completed public building is enterable and functional")
 g.surface.enter("claim");settle()
 check(s.surface.homes[s.claim_id].building.tiles.has("57,27"),"Starter cottage uses editable construction pieces")
 check(not HoldFrontier103.home_ready(g),"The unlit starter cottage does not award improvement credit")
 at(Vector2(2300,1050));check(g.surface.walkable(g.player),"Starter cottage interior has a clear approach")
 check(not g.surface.walkable(Vector2(2300,1100)) and g.surface.walkable(Vector2(2300,1140)),"Starter threshold requires deliberate entry and retains a clear yard landing")
 key(KEY_E)
 check(g.player==Vector2(2300,1140) and not g.surface.house.view.inside(),"E leaves the starter cottage into its yard")
 settle();g.surface.house.view.cooldown=0;key(KEY_E);settle()
 check(g.player==Vector2(2300,1060) and g.surface.house.view.inside(),"E re-enters the same saved starter cottage")
 await snap("home169-cottage")
 for item in ["stone","wood","iron"]:s.add(item,10)
 g.surface.placing="lamp";check(g.surface.place(Vector2(2380,1020)),"Player adds a real paid lamp to the starter cottage")
 check(HoldFrontier103.home_ready(g),"Improving the original cottage satisfies the home milestone without rebuilding")
 s.surface.decor=s.surface.decor.filter(func(f):return not (f.area=="claim" and f.kind=="lamp" and f.x==2380))
 key(KEY_O);check(g.panel_id=="homestead","Plot O opens the actual home design menu");await snap("home-design-menu");g.close_panel()
 for item in ["stone","wood","iron"]:s.add(item,1000)
 a.selected="cottage";a.furnish_plan=true;at(Vector2(3000,1200))
 check(a.place(Vector2(3000,1100)),"Player chooses and builds home with normal construction transaction: "+a.reason)
 var home=a.data().instances[-1];check(not home.get("public103",false),"Player home is privately editable")
 g.surface.enter(HoldBuildingPlans.room_id(str(home.id)));settle();await snap("player-home")
 check(HoldFrontier103.home_ready(g),"Completed shell, bed and hearth satisfy home milestone")
 check(a.add_floor(),"Player can add a real upper storey")
 a.stairs(true);settle();check(a.current_floor()==1 and g.surface.walkable(g.player),"Player's new upper floor is walkable")
 desk("lodge");var marks=int(HoldGreatClaim102.data(s).points)
 check(HoldFrontier103.finish_home(g) and not HoldFrontier103.finish_home(g),"Home milestone pays once")
 check(int(HoldGreatClaim102.data(s).points)==marks+60,"Home earns stated contribution marks")
 g.save_game();g.start_game(true);settle()
 check(HoldFrontier103.data(g.state).home_reward and HoldFrontier103.data(g.state).storehouse,"Home and town construction persist after reload")
 check(g.surface.architecture.record(str(home.id)).rooms.size()==2,"Player design and upper floor survive reload")
 await tool_capabilities()
 await specialist_commissions()
 print("FRONTIER103: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)

func town_routes():
 var grid=AStarGrid2D.new();grid.region=Rect2i(0,0,86,38);grid.cell_size=Vector2(20,20);grid.offset=Vector2(90,210);grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_NEVER;grid.update()
 for y in 38:
  for x in 86:
   var id=Vector2i(x,y);grid.set_point_solid(id,not g.surface.walkable(grid.get_point_position(id)))
 var start=Vector2i(30,24)
 for b in g.surface.architecture.data().instances:
  if b.area!="trail":continue
  var finish=Vector2i(roundi((b.x-90)/20),roundi((b.y+45-210)/20))
  check(not grid.get_id_path(start,finish).is_empty(),"Town street has a continuous walkable route to "+b.name)

func tool_capabilities():
 var s=g.state
 s.steel=false;s.outpost.erase("reinforced_pick");s.tech.erase("extraction");s.tech.erase("reinforced_tools")
 for item in ["iron","copper","coal","wood","water"]:s.add(item,100)
 s.money=1000;desk("forge")
 var before=s.count("iron")
 check(not HoldFrontier103.transact(g,"tool","steel") and s.count("iron")==before,"Unresearched pick cannot spend materials")
 desk("survey");check(HoldFrontier103.transact(g,"research","extraction"),"Research existing steel method at survey desk")
 check(not s.steel and HoldToolCapabilities.basalt_hint(s).contains("Forge one"),"Research does not grant a pick and feedback names remaining forging step")
 check(not HoldFrontier103.transact(g,"tool","steel"),"Stale remote forge callback rejected")
 desk("forge");before=s.count("iron")
 check(HoldFrontier103.transact(g,"tool","steel") and s.steel and s.count("iron")==before-5,"Steel pick uses existing five-iron cost")
 check(not HoldFrontier103.transact(g,"tool","steel") and s.count("iron")==before-5,"Duplicate steel forging cannot charge again")
 check(HoldToolCapabilities.basalt_hint(s)=="Your steel pick can cut basalt.","Owned tool guidance no longer asks for research or forging")
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick"),"Reinforcement requires its own technique")
 desk("survey");check(HoldFrontier103.transact(g,"research","reinforced_tools"),"Reinforcement uses ordinary reachable ingredients")
 desk("forge");s.queue=[]
 for item in HoldForge147.COMPONENTS:s.inventory[item]=0
 var raw_before={}
 for item in ["iron","copper","coal","wood"]:raw_before[item]=s.count(item)
 var wood_xp=HoldDisciplines.xp(s,"woodworking");var smith_xp=HoldDisciplines.xp(s,"smithing")
 s.tech.erase("reinforced_tools")
 check(not HoldFrontier103.transact(g,"craft","forged_pickhead") and s.count("iron")==raw_before.iron,"Unknown head technique cannot spend ingredients")
 s.tech.reinforced_tools=true
 s.opening=1
 check(not HoldFrontier103.transact(g,"craft","shaped_haft"),"Cold workshop cannot start component production")
 s.opening=2
 at(Vector2(230,560))
 check(not HoldFrontier103.transact(g,"craft","shaped_haft"),"Stale remote component callback cannot start work")
 desk("forge")
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick") and s.count("iron")==raw_before.iron,"Raw resources alone do not bypass component assembly")
 g.set_meta("forge147_station","components");g.refresh_panel();await snap("components173-ready")
 check(g.menu_scroll.get_v_scroll_bar().max_value<=g.menu_scroll.size.y+1,"All three component recipes fit without scrolling")
 for item in HoldForge147.COMPONENTS:
  var queued=s.queue.size();button(HoldData.RECIPES[item].name)
  check(s.queue.size()==queued+1 and s.queue.back().id==item,"Workshop button queues component: "+item)
 check(HoldDisciplines.xp(s,"woodworking")==wood_xp and HoldDisciplines.xp(s,"smithing")==smith_xp,"Queued work earns no early craft credit")
 check(s.count("iron")==raw_before.iron-8 and s.count("copper")==raw_before.copper-2 and s.count("coal")==raw_before.coal-3 and s.count("wood")==raw_before.wood-2,"Three components retain the former upgrade's total raw material cost")
 g.set_meta("forge147_station","components");g.refresh_panel();await snap("components173-queue")
 s.tick(1);var queue_before=JSON.stringify(s.queue)
 g.save_game();g.start_game(true);settle();s=g.state
 check(JSON.stringify(s.queue)==queue_before,"Partly completed component queue survives real save reload")
 for item in HoldForge147.COMPONENTS:s.tick(30)
 check(s.count("shaped_haft")==1 and s.count("forged_pickhead")==1 and s.count("tool_fittings")==1,"Queue completes exactly one of each component")
 check(HoldDisciplines.xp(s,"woodworking")==wood_xp+1 and HoldDisciplines.xp(s,"smithing")==smith_xp+2,"Completed components credit their actual professions")
 s.tick(30)
 check(s.count("shaped_haft")==1 and HoldDisciplines.xp(s,"woodworking")==wood_xp+1,"Finished queue cannot duplicate output or craft credit")
 desk("forge");s.inventory.tool_fittings=0
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick") and s.count("shaped_haft")==1 and s.count("forged_pickhead")==1,"Missing fittings preserve the other components atomically")
 desk("watch");var money=s.money;var quote=s.price("tool_fittings",true);smith_xp=HoldDisciplines.xp(s,"smithing")
 check(HoldFrontier103.transact(g,"trade","tool_fittings",true) and s.money==money-quote,"Market supplies missing fittings at the quoted price")
 check(HoldDisciplines.xp(s,"smithing")==smith_xp,"Buying fittings does not claim smithing work")
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick") and s.count("tool_fittings")==1,"Remote assembly preserves bought components")
 desk("forge");before=s.count("iron")
 check(HoldFrontier103.transact(g,"tool","reinforced_pick") and HoldToolCapabilities.reinforced(s),"Assemble a reinforced pick from crafted and purchased components")
 for item in HoldForge147.COMPONENTS:check(s.count(item)==0,"Assembly spends exactly one "+item)
 check(s.count("iron")==before,"Assembly does not charge raw materials a second time")
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick"),"Duplicate reinforced assembly rejected")
 # A player can buy every part without learning each manufacturing technique.
 s.outpost.reinforced_pick=false;s.tech.erase("reinforced_tools");desk("watch");s.money=1000
 wood_xp=HoldDisciplines.xp(s,"woodworking");smith_xp=HoldDisciplines.xp(s,"smithing")
 for item in HoldForge147.COMPONENTS:check(HoldFrontier103.transact(g,"trade",item,true),"Every component has a reliable buying route: "+item)
 desk("forge")
 check(not HoldFrontier103.transact(g,"tool","reinforced_pick"),"Bought parts do not bypass assembly knowledge")
 s.tech.reinforced_tools=true
 check(HoldFrontier103.transact(g,"tool","reinforced_pick"),"A fully purchased component set assembles normally")
 check(HoldDisciplines.xp(s,"woodworking")==wood_xp and HoldDisciplines.xp(s,"smithing")==smith_xp,"Purchase and assembly do not fabricate manufacturing credit")
 g.set_meta("forge147_station","anvil")
 g.refresh_panel();await snap("tools171-forge")
 g.save_game();g.start_game(true);settle();s=g.state
 check(s.steel and HoldToolCapabilities.reinforced(s),"Both pick capabilities survive real save reload")
 g.change_zone("mine");settle();var w=g.deep.world;var c=Vector2i(12,12)
 for d in Deepworks.DIRS:w.set_cell(c+d,0)
 w.set_cell(c,7);s.steel=false
 var damage=JSON.stringify(w.layer().damage);before=s.mined
 check(w.strike(c).get("blocked",false) and JSON.stringify(w.layer().damage)==damage and s.mined==before,"Basalt blocks execution without damage or reward when pick is absent")
 s.steel=true;s.outpost.reinforced_pick=false
 var result={}
 for i in 20:
  result=w.strike(c,-1,false,false,"careful")
  if result.get("broken",false):break
 check(result.get("item","")=="stone","Existing steel careful mining retains ordinary stone")
 w.set_cell(c,7);s.outpost.reinforced_pick=true
 for i in 20:
  result=w.strike(c,-1,false,false,"careful")
  if result.get("broken",false):break
 check(result.get("item","")=="basalt_block" and result.get("count",0)==2,"Careful reinforced contacts recover two basalt blocks")
 check(g.handworks.rock(result,c),"Basalt blocks enter existing physical raw-load system")
 var raw=g.handworks.data().loose.back()
 check(g.handworks.raw_item(raw)=="basalt_block" and int(raw.units)==2,"Raw load preserves basalt identity and quantity")
 w.set_cell(c,7)
 for i in 20:
  result=w.strike(c,-1,false,false,"pick")
  if result.get("broken",false):break
 check(result.get("item","")=="stone","Ordinary reinforced strikes still supply everyday stone")
 s.add("basalt_block",2);s.tech.erase("fine_masonry");s.queue=[]
 check(not s.craft("dressed_basalt"),"Advanced masonry recipe respects knowledge gate")
 s.tech.fine_masonry=true;before=s.count("basalt_block")
 check(s.craft("dressed_basalt") and s.count("basalt_block")==before-2,"Dressing recipe spends exactly two blocks")
 before=s.count("dressed_basalt");s.tick(30)
 check(s.count("dressed_basalt")==before+2,"Completed dressing produces the quoted basalt finish material")
 var cargo_before=int(g.deep.haul.bucket().get("basalt_block",0));g.deep.haul.collect("basalt_block",2,g.player)
 check(int(g.deep.haul.bucket().get("basalt_block",0))==cargo_before+2,"Recovered basalt uses physical bulk haulage")

func specialist_commissions():
 var s=g.state
 desk("forge");at(HoldForge147.BORIN_TALK)
 s.steel=false;s.outpost.reinforced_pick=false;s.tech.erase("extraction");s.tech.erase("reinforced_tools");s.money=1000
 for item in ["iron","copper","coal","wood"]:s.inventory[item]=100
 for item in HoldForge147.COMPONENTS:s.inventory[item]=0
 var smith_xp=HoldDisciplines.xp(s,"smithing");var wood_xp=HoldDisciplines.xp(s,"woodworking")
 HoldPeople.meet(g,"borin")
 var record=JSON.stringify(HoldPeople.records(s).get("borin",{}))
 var original=JSON.stringify(s.inventory);var money=s.money
 check(not HoldToolCapabilities.commission(g,"unknown") and s.money==money and JSON.stringify(s.inventory)==original,"Unknown commission leaves payment untouched")
 s.opening=1
 check(not HoldToolCapabilities.commission(g,"steel"),"Cold forge rejects specialist work")
 s.opening=2
 check(not HoldToolCapabilities.commission(g,"reinforced_pick"),"Reinforced assembly cannot skip the base pick")
 at(Vector2(230,560))
 check(not HoldToolCapabilities.commission(g,"steel") and s.money==money,"Remote smith callback cannot charge the player")
 at(HoldForge147.BORIN_TALK);s.money=34
 check(not HoldToolCapabilities.commission(g,"steel") and s.money==34 and JSON.stringify(s.inventory)==original,"Missing fee preserves all materials")
 s.money=1000;s.inventory.iron=4;original=JSON.stringify(s.inventory)
 check(not HoldToolCapabilities.commission(g,"steel") and s.money==1000 and JSON.stringify(s.inventory)==original,"Missing materials preserve fee and remaining pack")
 s.inventory.iron=100
 HoldConversation.start(g,"borin");button("Could you make a pick")
 check(g.talk_topic=="tool_commission","Borin exposes the service in his actual conversation")
 await snap("commissions175-picks")
 button("Steel pick ·")
 check(s.steel and s.money==965 and s.count("iron")==95 and s.count("wood")==98,"Conversation orders a steel pick for exact materials and fee without research")
 check(not HoldToolCapabilities.commission(g,"steel") and s.money==965,"Already-owned steel pick cannot charge again")
 button("Ask for individual components")
 await snap("commissions175-parts")
 for id in HoldForge147.COMPONENTS:button(HoldToolCapabilities.commission_name(id)+" ·")
 check(s.count("shaped_haft")==1 and s.count("forged_pickhead")==1 and s.count("tool_fittings")==1,"Borin makes each component without player research")
 check(s.money==917 and s.count("iron")==87 and s.count("copper")==98 and s.count("coal")==97 and s.count("wood")==96,"All component commissions consume exact recipe materials and quoted fees")
 check(JSON.stringify(HoldPeople.records(s).get("borin",{}))==record,"Paid work neither requires nor fabricates relationship progress")
 check(HoldDisciplines.xp(s,"smithing")==smith_xp and HoldDisciplines.xp(s,"woodworking")==wood_xp,"Specialist work grants no personal manufacturing experience")
 g.save_game();g.start_game(true);settle();s=g.state
 check(s.steel and s.count("forged_pickhead")==1 and s.money==917,"Commissioned tool, components and payment survive reload")
 desk("forge");at(HoldForge147.BORIN_TALK);s.inventory.tool_fittings=0
 var before=JSON.stringify(s.inventory)
 check(not HoldToolCapabilities.commission(g,"reinforced_pick") and s.money==917 and JSON.stringify(s.inventory)==before,"Incomplete assembly leaves fee and other parts untouched")
 s.inventory.tool_fittings=1
 HoldConversation.start(g,"borin");button("Could you make a pick");button("Reinforced pick assembly ·")
 check(HoldToolCapabilities.reinforced(s) and s.money==872,"Borin assembles the reinforced pick without compulsory research")
 for id in HoldForge147.COMPONENTS:check(s.count(id)==0,"Specialist assembly uses exactly one "+id)
 check(not s.tech.has("extraction") and not s.tech.has("reinforced_tools"),"Commissioning does not pretend the player learned manufacturing techniques")
 check(not HoldToolCapabilities.commission(g,"reinforced_pick") and s.money==872,"Completed specialist upgrade cannot charge twice")
 await snap("commissions175-complete")
 g.menu_scroll.scroll_vertical=10000;await snap("commissions175-scrolled")
 g.save_game();g.start_game(true);settle();s=g.state
 check(HoldToolCapabilities.reinforced(s) and s.money==872,"Completed specialist capability persists without replaying payment")
 check(HoldDisciplines.xp(s,"smithing")==smith_xp and HoldDisciplines.xp(s,"woodworking")==wood_xp,"Assembly and reload preserve personal craft experience")
