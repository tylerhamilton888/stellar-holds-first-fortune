extends "res://tests/support/game_fixture.gd"
func desk(id:String):
 g.surface.enter(HoldFrontier103.room(g.state,id));settle();at(Vector2(480,500))
func reload():
 g.save_game();g.start_game(true);settle()
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();HoldFirstVisit99.begin(g);settle()
 var s=g.state
 desk("lodge");check(not HoldMountain104.act(g,"rescue"),"Rescue waits for established home and contribution")
 HoldFrontier103.data(s).home_reward=true;HoldGreatClaim102.data(s).points=220;s.claim_id="copper_ridge"
 check(HoldMountain104.act(g,"rescue"),"Local foreman dispatches established contributor")
 check(not HoldMountain104.act(g,"rescue"),"Dispatch once only")
 g.open_panel("commission");check(g.panel.find_children("*","Label",true,false).any(func(label):return label.text=="THE MOUNTAIN REMEMBERS"),"J journal presents current rescue chapter");g.close_panel()
 reload();check(HoldAncestralClaim.data(g.state).stage==1,"Dispatch survives reload")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state);var w=g.deep.world;var c=Vector2i(q.site[0],q.site[1])
 check(q.crew.size()==3,"Three named persistent townsfolk trapped")
 check(HoldMountain104.missing(g.state,"road_folk:5"),"Trapped Sten absent from town")
 check(HoldAncestralClaim.route(w,c,Deepworks.ENTRY).is_empty(),"Physical excavation required")
 var terrain=w.layer().cells.duplicate();HoldAncestralClaim.enter(g);check(terrain==w.layer().cells,"Re-entry preserves terrain")
 for x in range(Deepworks.ENTRY.x,c.x+1):
  for i in 30:
   if w.at(Vector2i(x,Deepworks.ENTRY.y)) not in [0,8]:g.deep.hit(Vector2i(x,Deepworks.ENTRY.y))
 for y in range(Deepworks.ENTRY.y,c.y+1):
  for i in 30:
   if w.at(Vector2i(c.x,y)) not in [0,8]:g.deep.hit(Vector2i(c.x,y))
 at(Deepworks.center(c));w.survey(g.player)
 check(HoldAncestralClaim.interact(g) and q.stage==1,"Unbraced refuge cannot evacuate wounded")
 # Build a real workshop and pillar with ordinary payment and collision.
 for y in range(c.y-2,c.y+3):
  for x in range(c.x-2,c.x+3):
   for i in 30:
    if w.at(Vector2i(x,y)) not in [0,8]:g.deep.hit(Vector2i(x,y))
 var model=g.deep.works.model;g.state.add("stone",20);g.state.add("wood",10);g.state.add("coal",10);g.state.tech["stoneworking"]=true
 model.designate(c-Vector2i(2,2),c+Vector2i(2,2),"workshop")
 var placed=false
 for delta in [Vector2i(1,1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(-1,-1)]:
  if model.place(c+delta,"pillar").contains("installed"):placed=true;break
 check(placed,"Real paid masonry support installed")
 check(model.place(c,"lamp").contains("installed"),"Real paid lamp installed")
 check(HoldAncestralClaim.interact(g) and q.stage==2,"Lit braced refuge with route begins evacuation")
 await snap("rescue")
 for i in 30:HoldAncestralClaim.tick(g,.05)
 reload();q=HoldAncestralClaim.data(g.state)
 check(q.stage==2 and q.crew.size()==3,"All named evacuation positions persist")
 var closed={}
 for delta in Deepworks.DIRS:
  var tile=Deepworks.ENTRY+delta;closed[Deepworks.key(tile)]=g.deep.world.at(tile);g.deep.world.set_cell(tile,2)
 for i in 120:HoldAncestralClaim.tick(g,.05)
 check(q.stage==2,"Blocked exit halts physical evacuation")
 reload();q=HoldAncestralClaim.data(g.state)
 check(q.stage==2,"Blocked evacuation persists without teleporting survivors")
 for delta in Deepworks.DIRS:
  var tile=Deepworks.ENTRY+delta;g.deep.world.set_cell(tile,closed[Deepworks.key(tile)])
 for i in 3500:HoldAncestralClaim.tick(g,.05)
 check(q.stage==3 and q.crew.all(func(a):return a.home),"All survivors physically reach exit")
 check(not HoldMountain104.missing(g.state,"road_folk:5"),"Sten returns to town after rescue")
 check(not HoldMountain104.act(g,"translate"),"No remote self-authentication")
 desk("lodge");check(g.surface.roads.people(g.surface.area).size()==3,"Survivors physically gather at the shared hearth")
 for guest in g.surface.roads.people(g.surface.area):check(g.surface.walkable(guest.p),"Gathered survivor stands on clear floor")
 await snap("gathered-survivors")
 check(HoldMountain104.act(g,"celebrate"),"Communal celebration recognizes crew")
 check(not HoldMountain104.act(g,"celebrate"),"Celebration does not repeat")
 g.open_panel("frontier103");await snap("celebration");g.close_panel();reload()
 desk("survey");check(HoldMountain104.act(g,"examine"),"Edda begins authentication")
 check(not HoldMountain104.act(g,"translate"),"Two independent records required")
 desk("lodge");check(HoldMountain104.act(g,"family"),"Family registration can come first")
 reload();g.surface.enter(HoldFrontier103.room(g.state,"survey",1));settle();at(Vector2(690,575))
 check(HoldMountain104.act(g,"archive"),"Real upstairs archive verifies seal")
 check(not HoldMountain104.act(g,"archive"),"Archive evidence cannot repeat")
 desk("survey");var points=int(HoldGreatClaim102.data(g.state).points)
 check(HoldMountain104.act(g,"translate"),"Independent evidence authenticates local mountain ancestry")
 check(int(HoldGreatClaim102.data(g.state).points)==int(HoldGreatClaim102.standings(g.state)[0][1]),"Separate hereditary allowance exactly ties contest")
 check(HoldMountain104.data(g.state).allowance==300-points,"Allowance arithmetic is transparent")
 check(not HoldMountain104.act(g,"translate"),"Noble points cannot repeat")
 check(not HoldAncestralClaim.act(g,"appoint"),"No premature appointment bypass")
 check(g.state.claim_id=="copper_ridge","Existing household plot retained")
 g.open_panel("frontier103");await snap("authentication");g.close_panel();reload()
 check(HoldMountain104.data(g.state).authenticated and HoldAncestralClaim.data(g.state).stage==5,"Authentication persists")
 g.surface.enter("trail");settle()
 for actor in g.surface.roads.people("trail"):
  if actor.interaction=="road_folk:8":at(actor.p+Vector2(0,20))
 HoldPeople.meet(g,"road_folk:8");HoldPeople.records(g.state)["road_folk:8"].bond=8
 g.talk_id="road_folk:8";g.talk_topic="people";g.open_panel("conversation")
 HoldMountain104.reaction(g,"road_folk:8");button("Who were you meeting")
 check(HoldMountain104.data(g.state).insights.get("contacts",false),"Invested friendship unlocks saved evidence of contacts")
 g.close_panel()
 HoldCourtship101.record(g.state,"road_folk:1").stage=1
 q=HoldAncestralClaim.data(g.state);q.erase("victims");q.stage=1
 g.surface.enter("trail");g.surface.action("mine");settle();HoldMountain104.setup(g)
 check("road_folk:1" in q.victims,"Current partner joins named rescue cast")
 check(q.crew[2].profile==g.state.npc_appearances["road_folk:1"],"Partner portrait and world identity preserved")
 print("MOUNTAIN104: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
