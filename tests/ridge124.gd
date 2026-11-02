extends "res://tests/support/game_fixture.gd"
const IDS=["road_folk:10","road_folk:11"]
func visit(id:String):
 var area="room:wayfarer" if id==IDS[1] or HoldRidgePair124.paired(g.state) else "pinewood"
 g.surface.enter(area);settle()
 for actor in g.surface.roads.people(area):
  if actor.interaction==id:at(actor.p+Vector2(0,22));break
 HoldConversation.start(g,id)
func reset_story():
 g.state.surface.erase("ridge_pair124");g.state.surface.erase("courtship101")
func meet_both():
 visit(IDS[0]);visit(IDS[1])
func reload():g.save_game();g.start_game(true);settle()
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 HoldCalendar.advance(g.state,1440*400)
 check(not g.state.surface.has("ridge_pair124"),"Old saves receive no invented relationship history")
 visit(IDS[0]);HoldCalendar.advance(g.state,1440*100)
 check(not HoldRidgePair124.paired(g.state) and HoldRidgePair124.data(g.state).start==-1,"Meeting only one starts no deadline")
 visit(IDS[1]);var start=HoldCourtship101.day(g.state)
 check(HoldRidgePair124.data(g.state).start==start,"Shared story starts only after both introductions")
 for index in 2:
  var id=IDS[index];var name=["alden","maren"][index];visit(id)
  check(g.state.npc(id).first_name==name.capitalize(),"Authored first name "+name)
  check(g.state.npc(id).family_name==["Pineward","Hearthwell"][index],"Authored family name "+name)
  var profile=HoldStoryArt105.tag(g.state.npc(id),id)
  check(profile.cast_id==name and HoldStoryArt105.texture(profile)!=null,"Distinct portrait binding "+name)
  check(HoldStoryWorld105.has_profile(profile),"Approved whole-painted world identity "+name)
  var path="res://assets/story105/world/"+name+".webp";HoldWholeFrames.descriptor(profile,Vector2.DOWN,false,0,"town_walk",0)
  check(HoldWholeFrames.metadata[path].size()==24,"Twenty-four whole poses "+name)
  for direction in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]:
   var keys={}
   for k in 4:
    var frame=HoldWholeFrames.descriptor(profile,direction,true,k*.13+.001,"town_walk",0)
    keys[frame.index]=true
    check(is_equal_approx(float(frame.scale)*float(HoldWholeFrames.metadata[path][frame.index].height),[64.0,60.0][index]),"Stable native stature "+name)
   check(keys.size()==4,"Four distinct gait keys "+name)
  for k in 4:
   var frame=HoldWholeFrames.descriptor(profile,Vector2.DOWN,false,0,"drink",float(k))
   check(frame.index==20+k,"Social sip selects intact figure "+name)
  g.state.appearance.gender=index
  check(not HoldRidgePair124.express_interest(g,id),"Ineligible interest preserves friendship "+name)
  g.state.appearance.gender=1-index;g.player+=Vector2(250,0)
  check(not HoldRidgePair124.express_interest(g,id),"Remote interest callback rejected "+name)
  visit(id);button("A personal word");button("I'd like time")
  check(HoldRidgePair124.data(g.state).interest==id and HoldCourtship101.partner(g.state)=="","Explicit interest gives time without forcing commitment "+name)
  HoldCalendar.advance(g.state,1440*100);reload()
  check(not HoldRidgePair124.paired(g.state) and HoldRidgePair124.data(g.state).free_days==0,"Interest survives reload and long absences "+name)
  visit(id);button("A personal word");button("Tell them you would prefer friendship")
  check(HoldRidgePair124.data(g.state).interest=="","Player can release early interest "+name)
  var court=HoldCourtship101.record(g.state,id);court.quest=3;HoldPeople.records(g.state)[id].bond=12
  check(HoldCourtship101.begin(g,id),"New candidate can begin actual courtship "+name)
  HoldCalendar.advance(g.state,1440*100)
  check(not HoldRidgePair124.paired(g.state),"Active courtship prevents NPC pairing "+name)
  HoldCourtship101.record(g.state,id).stage=2;reload();HoldCalendar.advance(g.state,1440*100)
  check(HoldCourtship101.partner(g.state)==id and not HoldRidgePair124.paired(g.state),"Saved betrothal protects player choice "+name)
  visit(id);check(HoldCourtship101.end(g,id),"Kind breakup remains available "+name)
  await snap(name+"-conversation")
 reset_story();meet_both();HoldCalendar.advance(g.state,1440*55)
 check(HoldRidgePair124.data(g.state).stage==1 and HoldRidgePair124.available(g.state,IDS[0]),"Growing friendship gives a long visible courtship window")
 visit(IDS[0]);g.state.appearance.gender=1;HoldCourtship101.record(g.state,IDS[0]).quest=3;HoldPeople.records(g.state)[IDS[0]].bond=12
 check(HoldCourtship101.begin(g,IDS[0]),"Player may court during their growing friendship")
 HoldCalendar.advance(g.state,1440*100);visit(IDS[0]);HoldCourtship101.end(g,IDS[0])
 HoldCalendar.advance(g.state,1440*13)
 check(not HoldRidgePair124.paired(g.state),"Breakup allows at least fourteen free days before NPC commitment")
 HoldCalendar.advance(g.state,1440)
 check(HoldRidgePair124.paired(g.state) and HoldRidgePair124.data(g.state).stage==2,"Unpursued pair choose each other after the grace period")
 visit(IDS[0]);check(not HoldCourtship101.begin(g,IDS[0]),"Stale courtship callback cannot interrupt NPC commitment")
 for id in IDS:
  visit(id);check(HoldCourtship101.local(g,id),"Coupled NPC remains reachable "+id)
  check(not HoldCourtship101.eligible(g.state,id),"Established couple is no longer romantically available "+id)
  check(HoldCourtship101.status(g.state,id).contains("Courting"),"Couple status appears in personal story "+id)
  check(HoldRidgePair124.greeting(g.state,id)!="","Couple has shared-life dialogue "+id)
  for t in range(0,80,2):
   for actor in g.surface.roads.people("room:wayfarer",t):
    if actor.interaction==id:check(g.surface.walkable(actor.p) and g.surface.walkable(actor.p+Vector2(0,22)),"Couple route and approach stay clear "+id)
 check(not g.surface.roads.people("pinewood").any(func(a):return a.interaction==IDS[0]),"Alden has exactly one location after moving")
 check(g.surface.roads.people("room:wayfarer").filter(func(a):return a.interaction in IDS).size()==2,"Both share the Hearth with no duplicated actors")
 check(HoldRoadCharacters.whereabouts(IDS[0],g.state).contains("with Maren"),"Notebook directions follow Alden")
 visit(IDS[1]);check(HoldCourtship101.accept(g,IDS[1]),"NPC commitment leaves personal friendship story available")
 await snap("together-conversation");g.close_panel();at(Vector2(480,550));await snap("together-at-hearth")
 HoldCalendar.advance(g.state,1440*28);var saved=HoldRidgePair124.data(g.state).duplicate(true);reload()
 check(HoldRidgePair124.data(g.state)==saved and int(saved.stage)==3,"NPC betrothal and history survive reload")
 check(HoldCourtship101.status(g.state,IDS[1])=="Betrothed to Alden","NPC betrothal is readable")
 HoldRidgePair124.advance(g.state);HoldRidgePair124.meet(g.state,IDS[0])
 check(HoldRidgePair124.data(g.state).events.size()==3,"Repeated checks and meetings do not duplicate shared events")
 reset_story();meet_both();var inventory=g.state.inventory.duplicate(true);HoldCalendar.advance(g.state,1440*84)
 check(HoldRidgePair124.data(g.state).stage==3 and HoldRidgePair124.data(g.state).events.size()==3,"Large time skip advances each shared event exactly once")
 check(inventory==g.state.inventory,"NPC relationship never spends player possessions")
 reset_story();meet_both();visit(IDS[1]);g.state.appearance.gender=0;HoldRidgePair124.express_interest(g,IDS[1])
 HoldCourtship101.record(g.state,"road_folk:1").stage=1;HoldCalendar.advance(g.state,1440*84)
 check(HoldRidgePair124.data(g.state).interest=="" and HoldRidgePair124.paired(g.state),"Choosing somebody else releases early interest")
 print("RIDGE124: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
