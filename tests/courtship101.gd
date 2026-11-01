extends "res://tests/support/game_fixture.gd"
func visit(id:String):
 var i=int(id.trim_prefix("road_folk:"));var spec=HoldRoads.FOLK[i]
 g.surface.enter(spec.area);settle()
 for actor in g.surface.roads.people(spec.area):
  if actor.interaction==id:at(actor.p+Vector2(0,22));break
 HoldConversation.start(g,id)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 check(HoldCourtship101.ARCS.size()==6,"Exactly six authored romance candidates")
 var genders=[0,0]
 for id in HoldCourtship101.ARCS:
  var cast=HoldRoadCharacters.CAST[id];genders[int(cast.gender)]+=1
  check(cast.adult and cast.relationship=="single","Candidate is an adult and single: "+id)
  for item in HoldCourtship101.ARCS[id].cost:check(HoldData.ITEMS.has(item),"Personal errand uses real item: "+item)
  visit(id)
  var index=int(id.trim_prefix("road_folk:"));var spec=HoldRoads.FOLK[index]
  for t in range(0,80,5):
   for actor in g.surface.roads.people(spec.area,t):
    if actor.interaction==id:check(g.surface.walkable(actor.p) and g.surface.walkable(actor.p+Vector2(0,22)),"Candidate route and approach clear: "+spec.name)
  check(HoldCourtship101.local(g,id),"Candidate reachable for conversation: "+spec.name)
  check(HoldCourtship101.partner(g.state)=="","Meeting does not start courtship")
  button("A personal word");button("Offer to help")
  check(HoldCourtship101.record(g.state,id).quest==1,"Personal errand accepted through UI")
  var arc=HoldCourtship101.ARCS[id]
  for item in arc.cost:g.state.inventory[item]=0
  check(not HoldCourtship101.deliver(g,id),"Missing materials block delivery")
  for item in arc.cost:g.state.add(item,int(arc.cost[item]))
  var before=g.state.inventory.duplicate(true)
  g.player+=Vector2(250,0)
  check(not HoldCourtship101.deliver(g,id) and g.state.inventory==before,"Remote delivery rejected without consuming anything")
  visit(id);button("A personal word");button("Deliver the materials")
  check(HoldCourtship101.record(g.state,id).quest==2,"Exactly one real delivery advances personal story")
  check(not HoldCourtship101.deliver(g,id),"Duplicate delivery rejected")
  for item in arc.cost:check(g.state.count(item)==0,"Delivery consumes only its real cost")
  g.save_game();g.start_game(true);settle();visit(id);button("A personal word")
  check(HoldCourtship101.record(g.state,id).quest==2,"Unresolved personal choice survives reload")
  button(arc.choices[0])
  check(HoldCourtship101.record(g.state,id).quest==3 and HoldCourtship101.record(g.state,id).approach==0,"Personal choice and keepsake recorded")
  var friendship=HoldPeople.records(g.state)[id].bond
  check(not HoldCourtship101.resolve(g,id,1) and HoldPeople.records(g.state)[id].bond==friendship,"Choice cannot pay friendship twice")
  HoldPeople.records(g.state)[id].bond=12
  g.state.appearance.gender=int(cast.gender)
  check(not HoldCourtship101.begin(g,id),"Ineligible romantic match retains friendship")
  g.state.appearance.gender=1-int(cast.gender)
  g.talk_line="";g.refresh_panel();button("Ask whether we might court")
  check(HoldCourtship101.record(g.state,id).stage==1 and g.talk_line==arc.yes,"Courtship begins with explicit reciprocal dialogue")
  check(not HoldCourtship101.share_date(g,id,0,0),"First date waits for another calendar day")
  for n in 3:
   HoldCalendar.advance(g.state,1440)
   g.talk_line="";g.refresh_panel()
   var scene=arc.dates[n]
   if n==0:await snap("courtship-"+spec.name.to_lower())
   button(scene[2][n%2])
   check(HoldCourtship101.record(g.state,id).dates.size()==n+1 and g.talk_line==scene[3][n%2],"Individual date choice resolves: "+spec.name+" "+str(n))
   check(not HoldCourtship101.share_date(g,id,n,n%2),"Stale choice cannot duplicate date")
   check(not HoldCourtship101.share_date(g,id,n+1,0),"Cannot chain several dates in one calendar day")
  check(not HoldCourtship101.promise(g,id),"Betrothal requires time after the final date")
  HoldCalendar.advance(g.state,1440);g.refresh_panel();button("Ask to become betrothed")
  check(HoldCourtship101.record(g.state,id).stage==2,"Reciprocal betrothal reached through UI")
  var saved=HoldCourtship101.record(g.state,id).duplicate(true)
  g.save_game();g.start_game(true);settle();visit(id)
  check(HoldCourtship101.record(g.state,id)==saved,"Courtship, choices, day limits and betrothal survive reload")
  g.open_panel("roster");await snap("betrothed-"+spec.name.to_lower());g.close_panel();visit(id)
  button("A personal word");button("Discuss ending");button("No · stay together")
  check(HoldCourtship101.partner(g.state)==id,"Cancelling breakup preserves relationship")
  button("Discuss ending");button("Yes · end")
  check(HoldCourtship101.partner(g.state)=="" and HoldCourtship101.record(g.state,id).quest==3,"Explicit breakup preserves personal story")
  check(not HoldCourtship101.begin(g,id),"Breakup cannot be immediately reversed for farming")
  HoldCalendar.advance(g.state,1440)
 check(genders==[3,3],"Three women and three men")
 # An existing commitment blocks a second partner, including stale callbacks.
 visit("road_folk:1");g.state.appearance.gender=0;check(HoldCourtship101.begin(g,"road_folk:1"),"May court again after time apart")
 visit("road_folk:3");check(not HoldCourtship101.begin(g,"road_folk:3"),"Cannot begin a second simultaneous commitment")
 check(HoldCourtship101.record(g.state,"orla").is_empty() and not HoldCourtship101.begin(g,"orla"),"Established married cast never enter relationship system")
 print("COURTSHIP101: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
