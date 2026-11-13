extends "res://tests/support/game_fixture.gd"
const LANDING=Vector2i(54,34)
func normal(v):return JSON.parse_string(JSON.stringify(v))
func stand(c:Vector2i):g.player=Deepworks.center(c);g.transition_left=0
func build_room(p):
 for attempt in 8:
  for y in range(29,40,2):
   for x in range(49,60,2):stand(Vector2i(x,y));p.work()
 check(p.remaining(p.chosen()).is_empty(),"Build room through paid blueprint construction")
func worker()->Dictionary:return g.agents.filter(func(a):return a.id=="brann")[0]
func advance(count:int):
 for i in count:g.deep.agents(.1)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
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
 build_room(p);stand(Vector2i(54,36));g.surface.start_placement("bed")
 check(g.surface.place(Deepworks.center(Vector2i(52,36))),"Place actual upstairs bed")
 check(HoldOutpost.recruit(g.state,"brann") and HoldOutpost.assign(g.state,"brann","miner"),"Recruit an existing worker through normal crew owner")
 g.spawn_agents();g.state.agents_enabled=true
 var record={"x":2100.0,"y":1460.0,"z":1};var before=normal(g.state.inventory)
 check(HoldEstateWorkers.assign(g,"ivar",record).contains("Recruit"),"Reject borrowed or unrecruited people")
 g.surface.architecture.room_planning=true;g.open_panel("architecture");button("Bed (52, 36)")
 check(HoldEstateWorkers.homes(g).has("brann"),"Real book button assigns furnished upstairs berth")
 check(normal(g.state.inventory)==before,"Bed assignment does not move or spend supplies")
 for scroll in g.panel.find_children("*","ScrollContainer",true,false):scroll.scroll_vertical=10000
 await snap("01-crew-berth");g.close_panel()
 var a=worker();var saved=g.deep.crew_entry(a)
 check(not saved.has("estate_area160"),"Old crew record defaults to mine without migration or relocation")
 var assigned=saved.assigned;g.state.elapsed=95
 advance(20)
 check(saved.get("estate_area160","mine")=="mine" and Vector2(saved.x,saved.y)!=Deepworks.center(Deepworks.ENTRY),"Worker walks the actual excavated approach")
 check(float(g.deep.works.model.data.folk.brann.rested_until)==0,"No rest benefit during commute")
 var mid=Vector2(saved.x,saved.y);g.save_game();g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle()
 a=worker();saved=g.deep.crew_entry(a);w=g.deep.world;h=g.surface.house;p=g.surface.architecture.room_blueprints
 check(Vector2(saved.x,saved.y)==mid and HoldEstateWorkers.homes(g).has("brann"),"Cold reload preserves berth and exact mid-commute position")
 # Block the only underground approach after the route was calculated.
 var block=Vector2i(54,20);w.set_cell(block,1,0)
 advance(420)
 check(saved.get("estate_area160","mine")=="mine" and Vector2(saved.x,saved.y).y<Deepworks.center(block).y,"Worker cannot cross newly blocked mine passage")
 check(float(g.deep.works.model.data.folk.brann.rested_until)==0,"Blocked commute cannot grant remote rest")
 w.set_cell(block,0,0);advance(600)
 check(saved.get("estate_area160","")=="surface" and int(saved.get("estate_z160",-1))==1,"Worker crosses cellar and upstairs stairs without moving player")
 check(a.status=="Resting at home" and g.deep.works.model.data.folk.brann.rested_until>g.state.elapsed,"Actual bedside arrival grants rest")
 check(int(saved.assigned)==int(assigned),"Home commute preserves mine work assignment")
 check(HoldEstateWorkers.objects(g).size()==1,"Resident rendered once on its own floor")
 await snap("02-worker-at-home")
 var home_position=Vector2(saved.x,saved.y);g.save_game();g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle()
 a=worker();saved=g.deep.crew_entry(a);w=g.deep.world;h=g.surface.house;p=g.surface.architecture.room_blueprints
 check(saved.get("estate_area160","")=="surface" and int(saved.estate_z160)==1 and Vector2(saved.x,saved.y)==home_position,"Cold reload preserves upstairs resident, not a duplicate underground")
 # Old/externally changed landing obstruction: normal building already protects it.
 var t=h.tiles(1)["52,32"];t.wall="wall";g.state.elapsed=121
 advance(150)
 check(saved.get("estate_area160","")=="surface" and int(saved.estate_z160)==1,"Blocked upper landing prevents return travel")
 check(a.status.contains("blocked"),"Blocked route has truthful crew status")
 t.erase("wall");advance(150)
 check(saved.get("estate_area160","")=="mine","Removing obstruction permits physical return to mine")
 check(int(saved.assigned)==int(assigned),"Return keeps original worksite")
 # Removed bed while at home sends the same worker back instead of stranding it.
 g.state.elapsed=215;advance(700)
 check(saved.get("estate_area160","")=="surface","Next rest period reaches home again")
 var b=HoldEstateWorkers.bed(g,record);g.state.surface.decor.erase(b);advance(150)
 check(saved.get("estate_area160","")=="mine","Removed bed cancels rest and returns worker safely")
 check(HoldEstateWorkers.assign(g,"brann",record).contains("existing bed"),"Stale assignment cannot recreate removed bed")
 var terrain=normal(w.data.layers);var stocks=normal(g.state.surface.chests)
 g.surface.enter("hearthward",Vector2(400,500));settle()
 check(HoldEstateWorkers.assign(g,"brann",record).contains("Visit"),"Remote bed assignment is rejected")
 check(normal(w.data.layers)==terrain and normal(g.state.surface.chests)==stocks,"Routing does not excavate or remotely transfer storage")
 print("WORKERS160: ",passed," passed / ",failed," failed");quit(1 if failed else 0)
