extends "res://tests/support/game_fixture.gd"
const BATCH=["sten","orla","sigrid","yrsa","skarrin"]
func road(id:String,t:float)->Dictionary:
 for actor in g.surface.roads.people("trail",t):
  if actor.interaction==id:return actor
 return {}
func approach_road(id:String):
 var p=road(id,g.state.elapsed).p
 for offset in [Vector2(45,0),Vector2(-45,0),Vector2(0,-45),Vector2(0,45)]:
  var target=p+offset;var clear=true
  for obstacle in g.surface.obstacles():
   if obstacle.has_point(target):clear=false
  if clear and g.surface.clear_interaction(target,p):at(target);return
 check(false,"Accessible conversation approach "+id)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.surface.enter("trail");settle()
 var profiles={}
 for spec in [["sten",5],["skarrin",8]]:
  var id="road_folk:"+str(spec[1]);approach_road(id);g.surface.action(id);g.close_panel();profiles[spec[0]]=g.state.npc(id).duplicate(true)
  check(profiles[spec[0]].first_name.to_lower()==spec[0],"Normal first interaction keeps authored name "+spec[0])
 profiles.orla=g.state.npc("orla").duplicate(true);profiles.yrsa=g.state.npc("yrsa").duplicate(true);profiles.sigrid=HoldWorkerLodge100.profile(g,2).duplicate(true)
 for id in BATCH:
  var p=profiles[id];var sheet=HoldStoryWorld105.PREFIX+id+".webp";var drinks=id in ["sigrid","orla","yrsa"]
  check(HoldStoryWorld105.has_profile(p),"Batch identity enabled "+id)
  check(HoldWholeFrames.metadata[sheet].size()==(40 if id=="yrsa" else 24 if drinks else 20),"Complete reachable pose coverage "+id)
  for f in HoldWholeFrames.metadata[sheet]:check(f.has("source") and ResourceLoader.exists(f.source),"Existing explicit atlas source "+id)
  for v in 4:
   var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][v];var a=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
   check(a.sheet==sheet and a.index==v,"Idle view "+id+str(v))
   check(is_equal_approx(a.scale*float(HoldWholeFrames.metadata[sheet][v].height),float(HoldStoryWorld105.HEIGHTS.get(id,62))),"Preserved individual height "+id)
   for k in 4:
    a=HoldWholeFrames.descriptor(p,d,true,k*.13+.001,"town_walk",0)
    check(a.sheet==sheet and a.index==4+v*4+k,"Ordered whole walking key "+id+str(v)+str(k))
  var generic=p.duplicate(true);generic.erase("cast_id")
  for action in ["pick","hammer","carry_stone","combat_axe"]:
   if id=="yrsa" and action in ["pick","hammer"]:continue
   check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Unsupported action retains functional renderer "+id+action)
  for k in 4:
   var a=HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,"drink",k)
   if drinks:check(a.sheet==sheet and a.index==20+k,"Authored whole drinking key "+id+str(k))
   else:check(a==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,"drink",k),"No invented drinking assignment "+id)
 check(HoldStoryWorld105.has_profile(g.state.npc("dagr")),"Dagr now has complete named art")
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player renderer unchanged")
 for idx in [5,8]:
  var id="road_folk:"+str(idx);var f=HoldRoads.FOLK[idx];var duration=f.a.distance_to(f.b)/38.;var cycle=2*(duration+7)
  for step in 80:
   var t=step*.5;var a=road(id,t);var local=fposmod(t+idx*9,cycle);var forward=local<=duration+7
   if not forward:local-=duration+7
   var expected=f.a.lerp(f.b,minf(1,local/duration)) if forward else f.b.lerp(f.a,minf(1,local/duration))
   check(a.p.distance_to(expected)<.01 and a.walking==(local<duration),"Route position/pause unchanged "+id+str(step))
   var pose=HoldWholeFrames.descriptor(a.profile,a.aim,a.walking,a.gait,"town_walk",0)
   check(pose.sheet.ends_with("/"+profiles["sten" if idx==5 else "skarrin"].cast_id+".webp"),"Live route keeps identity "+id)
  g.state.elapsed=cycle*4-idx*9+.8;at(f.a+Vector2(0,95));await snap(f.name.to_lower()+"-walk")
  g.state.elapsed=cycle*4-idx*9+duration+.5;await snap(f.name.to_lower()+"-rest")
  approach_road(id);g.surface.action(id);check(g.panel_id=="conversation" and g.talk_id==id,"Normal road conversation "+id);await snap(f.name.to_lower()+"-conversation");g.close_panel()
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(570,555))
 for k in 4:
  g.state.elapsed=k*.5
  var actors=HoldWorkerLodge100.people(g);var found=false
  for a in actors:
   if a.get("interaction","")=="lodge_folk:2":
    found=true;check(a.p==Vector2(620,480) and not a.walking and a.pose=="drink","Sigrid retains stationary lodge drinking schedule")
    var pose=HoldWholeFrames.descriptor(a.profile,a.aim,a.walking,a.gait,a.pose,a.phase)
    check(pose.sheet.ends_with("/sigrid.webp") and pose.index==20+[0,1,2,1][k],"Sigrid live drinking stays authored")
  check(found,"Sigrid remains in lodge");await snap("sigrid-drink-"+str(k))
 HoldWorkerLodge100.speak(g,2);check(g.panel_id=="lodge_talk","Sigrid conversation reachable");await snap("sigrid-conversation");g.close_panel()
 HoldFrontier103.data(g.state).keldrath_open=true;g.surface.enter("room:market");settle();at(Vector2(620,480));g.surface.action("talk:orla")
 check(g.panel_id=="conversation" and g.talk_id=="orla","Orla exchange conversation reachable");await snap("orla-conversation");g.close_panel();await snap("orla-market")
 check(HoldConversation.SERVICES.orla[1]=="market","Orla trade service preserved")
 # Free tavern seats through actual recruitment state; Yrsa becomes a visible guest.
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.money+=1000;g.state.inventory.food=30
 for id in ["brann","dagr","osvik"]:
  if not g.state.outpost.crew.has(id):check(HoldOutpost.recruit(g.state,id),"Earlier guests can join crew "+id)
 g.surface.enter("room:tavern");settle();at(Vector2(520,615));g.clock=14-posmod(hash("yrsa"),11)
 check(HoldNpcPresence.tavern_guests(g.state).has("yrsa"),"Yrsa is reachable at hiring bench")
 await snap("yrsa-tavern-drink")
 check(HoldOutpost.recruit(g.state,"yrsa"),"Yrsa recruitment preserved")
 for role in HoldOutpost.ROLES:
  check(HoldOutpost.assign(g.state,"yrsa",role),"Yrsa assignment preserved "+role)
  check(HoldStoryWorld105.has_profile(g.state.npc("yrsa")),"Crew assignment retains named body "+role)
 g.surface.enter("claim");settle();at(Vector2(1260,930));await snap("yrsa-claim")
 g.save_game()
 var inv=g.state.inventory.duplicate(true);var crew=g.state.outpost.crew.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==inv,"Save/load preserves inventory")
 check(g.state.outpost.crew.keys()==crew.keys(),"Save/load preserves recruited crew")
 for id in crew:
  var restored=g.state.outpost.crew[id]
  check(restored.role==crew[id].role and restored.priority==crew[id].priority,"Save/load preserves assignment "+id)
  check(is_equal_approx(float(restored.fuel),float(crew[id].fuel)) and is_equal_approx(float(restored.grain_work),float(crew[id].grain_work)),"Save/load preserves worker progress "+id)
 for spec in [["sten","road_folk:5"],["skarrin","road_folk:8"],["orla","orla"],["yrsa","yrsa"]]:check(g.state.npc(spec[1])==profiles[spec[0]],"Save/load preserves identity "+spec[0])
 check(HoldWorkerLodge100.profile(g,2)==profiles.sigrid,"Save/load preserves Sigrid")
 HoldFrontier103.data(g.state).home_reward=true;HoldGreatClaim102.data(g.state).points=220;g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(480,500))
 check(HoldMountain104.act(g,"rescue"),"Rescue starts with batch art")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state)
 check(q.victims.has("road_folk:5") and not q.victims.has("road_folk:8"),"Sten remains rescue victim; Skarrin remains outside it")
 check(road("road_folk:5",g.state.elapsed).is_empty() and not road("road_folk:8",g.state.elapsed).is_empty(),"Missing Sten leaves route; Skarrin remains")
 check(HoldWholeFrames.descriptor(g.state.npc("road_folk:5"),Vector2.UP,true,.26,"town_walk",0).sheet.ends_with("/sten.webp"),"Rescue retains Sten art")
 print("STORYBATCH121: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
