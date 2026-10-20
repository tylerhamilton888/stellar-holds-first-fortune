extends SceneTree
var passed=0
var failed=0
func check(ok:bool,msg:String):
 if ok:passed+=1
 else:failed+=1;push_error(msg)
func grant(s,cost:Dictionary):
 for k in cost:s.add(k,int(cost[k]))
func _initialize():call_deferred("run")
func run():
 var s=HoldState.new();s.reset(74429);var geo=Geology.new();geo.generate(s.seed_value)
 check(not HoldOutpost.recruit(s,"brann"),"No recruitment without claim")
 s.opening=1
 for j in HoldCampaign.JOBS:grant(s,j.cost);check(s.finish_commission(),"Commission advances")
 check(s.opening==4 and s.money==340,"Wages fund first charter")
 check(s.buy_charter("old_delving"),"Buy first claim")
 check(HoldOutpost.capacity(s)==2,"Foundation provides two berths")
 check(HoldOutpost.recruit(s,"brann"),"Recruit mentor with remaining wages")
 var money=s.money;var food=s.count("food")
 check(not HoldOutpost.recruit(s,"brann") and money==s.money and food==s.count("food"),"Duplicate hire consumes nothing")
 check(not HoldOutpost.assign(s,"brann","engineer"),"Workshop prerequisite enforced")
 s.money+=500;grant(s,{"food":20})
 check(HoldOutpost.recruit(s,"dagr"),"Recruit second miner")
 check(not HoldOutpost.recruit(s,"osvik"),"Berth limit enforced")
 grant(s,HoldCampaign.CAMP[1].cost);check(s.build_camp(),"Workshop construction")
 check(HoldOutpost.capacity(s)==4,"Workshop adds berths")
 grant(s,HoldData.RESEARCH.metallurgy.cost);check(s.research("metallurgy"),"Parts technology obtainable")
 check(HoldOutpost.recruit(s,"osvik"),"Recruit smith")
 check(HoldOutpost.recruit(s,"kelvar"),"Recruit engineer")
 check(HoldOutpost.assign(s,"osvik","smith"),"Assign smith")
 grant(s,HoldData.RECIPES.parts.cost);check(s.craft("parts"),"Parts can be queued")
 var before=float(s.queue[0].left);s.tick(1)
 check(s.queue[0].left<before-1,"Staff accelerates real production")
 check(s.outpost.support_fuel==119,"One provision starts a productive shift")
 var fuel=s.outpost.support_fuel;s.agents_enabled=false;before=s.queue[0].left;s.tick(.5)
 check(is_equal_approx(s.queue[0].left,before-.5) and s.outpost.support_fuel==fuel,"Pausing staff removes bonus and supply drain, preserves public crafting")
 s.agents_enabled=true
 for i in 20:s.tick(1)
 check(s.count("parts")>=2,"Craft outputs delivered")
 grant(s,HoldCampaign.CAMP[2].cost);check(s.build_camp(),"Beacon construction")
 check(s.dynasty.founded and HoldOutpost.capacity(s)==6,"Founding recorded and full crew capacity unlocked")
 check(HoldOutpost.recruit(s,"tovan") and HoldOutpost.recruit(s,"yrsa"),"Full six-member crew")
 var first=HoldOutpost.line(s,"kelvar",true);check(HoldOutpost.line(s,"kelvar")!=first,"Conversation advances")
 grant(s,HoldOutpost.project(s,"osvik").cost)
 check(HoldOutpost.favor(s,"osvik"),"Personal project accepts exact resources")
 money=s.money;check(not HoldOutpost.favor(s,"osvik"),"Personal project cannot be farmed")
 check(HoldOutpost.bonus(s,"smith")>.35,"Settled craftsman contributes more")
 check(HoldOutpost.assign(s,"kelvar","engineer"),"Engineer assigned")
 s.money=2000
 for stage in HoldData.SHIP:grant(s,stage.cost);check(HoldOutpost.build_ship(s),"Ship stage can be constructed")
 money=s.money;check(not HoldOutpost.build_ship(s) and s.money==money,"Completed ship cannot charge again")
 s.outpost.name="Fellcopper Anchorage";s.outpost.crew.brann.fuel=7;s.outpost.crew.brann.grain_work=9
 s.switch_site("claim",geo);geo.set_cell(Vector2i(110,60),0)
 check(s.save_world(geo,"claim",Vector2(900,410)),"Save outpost")
 var loaded=HoldState.new();var restored=Geology.new();loaded.load_world(restored)
 check(loaded.outpost.crew.size()==6 and loaded.outpost.name=="Fellcopper Anchorage","Crew and outpost name persist")
 check(loaded.outpost.crew.brann.fuel==7 and loaded.outpost.crew.brann.grain_work==9,"Mining shift reserves persist")
 check(loaded.outpost.favors.osvik and loaded.outpost.talk.kelvar==1,"Projects and conversation cursor persist")
 check(restored.at(110,60)==0 and loaded.ship_stage==3,"Excavation and ship persist")
 check(loaded.switch_site("hold",restored) and loaded.switch_site("claim",restored) and restored.at(110,60)==0,"Travel preserves claim terrain")
 for id in s.outpost.personalities:
  check(loaded.outpost.personalities[id].quirk==s.outpost.personalities[id].quirk and int(loaded.outpost.personalities[id].project)==int(s.outpost.personalities[id].project),"Seeded identity persists: "+id)
 check(loaded.outpost.chronicle.size()>6,"Chronicle records actual milestones")
 var alternate=HoldState.new();alternate.reset(11893)
 var changed=false
 for id in HoldOutpost.CREW:
  if HoldOutpost.personality(s,id)!=HoldOutpost.personality(alternate,id):changed=true
 check(changed,"Different fortunes vary secondary traits and projects")
 var old=HoldState.new();old.worker=true;old.outpost={};HoldOutpost.ensure(old)
 check(old.outpost.crew.has("brann"),"Legacy worker becomes Brann")
 var p=HoldAppearance.normalized({"first_name":"Test","family_name":"Oakenshield"})
 check(p.family_name=="Fellcopper","Retired surname migrates")
 old.appearance=p;old.dynasty={"family_name":"Oakenshield"};old.ensure_dynasty()
 check(old.dynasty.family_name=="Fellcopper" and old.appearance.family_name=="Fellcopper","Dynasty and player migrate together")
 var male=0;var lines=0
 for id in HoldOutpost.CREW:
  var profile=s.npc(id);check(profile.name==HoldOutpost.CREW[id].name,"Crew name consistent")
  if profile.gender==0:male+=1
  else:check(profile.beard_style==5,"Female dwarf has no facial hair")
  lines+=HoldOutpost.CREW[id].lines.size()
 for id in HoldOutpost.TOWN:lines+=HoldOutpost.TOWN[id].size()
 check(male==5 and lines>=84,"Cast ratio and authored dialogue coverage")
 # Exercise actual game agent spawning, resource consumption, UI, and location tracking.
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel()
 g.state=loaded;g.geo=restored;g.zone="claim";g.spawn_agents()
 check(g.agents.size()==2,"Two individually assigned miners spawned")
 check(g.agents[0].id!=g.agents[1].id,"Miners retain identities")
 g.geo.cells.fill(0);g.geo.damage={};g.geo.grain_bank={}
 for x in range(30,34):
  for y in range(50,54):g.geo.set_cell(Vector2i(x,y),3)
 var worker=g.agents[0];worker.p=g.geo.center(Vector2i(29,51));worker.target=Vector2i(30,51);worker.path=[];worker.cool=0
 var mined=g.state.mined
 for i in 16:g.update_agents(.1)
 check(g.state.mined>mined,"Named crew physically excavate terrain")
 check(g.state.outpost.crew[worker.id].fuel==worker.fuel,"Active shift fuel persisted")
 var pos=worker.p;g.spawn_agents();check(g.agents[0].p==pos,"Assignment refresh preserves current miner position")
 g.outpost_tab=0;g.open_panel("manage");g.outpost_tab=1;g.open_panel("manage");g.outpost_tab=2;g.open_panel("manage")
 check(g.npc_where("kelvar").zone=="claim","Engineer location tracking")
 g.close_panel();g.state.active_site="hold";g.spawn_agents();check(g.agents.is_empty(),"No crew shown or mining in employer's workings")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("OUTPOST29: ",passed," passed; ",failed," failed")
 quit(1 if failed else 0)
