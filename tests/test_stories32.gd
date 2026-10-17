extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func setup(g,seed_number:int):
 g.state.reset(seed_number);g.state.opening=4;g.state.money=1000
 g.state.buy_charter("old_delving");g.state.camp_stage=3;g.state.switch_site("claim",g.geo);g.zone="claim";g.room_id=""
 for key in HoldData.ITEMS:g.state.inventory[key]=50
func ready(s):
 s.elapsed+=60;HoldClaimStories.ensure(s).next_at=0
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 setup(g,27419)
 var s=g.state
 for id in HoldAppearance.CAST:
  check(HoldAppearance.npc_profile(id,1)==HoldAppearance.npc_profile(id,98765),"Canonical identity across worlds: "+id)
 s.npc_appearances.orla=HoldAppearance.random_profile(123,0)
 check(s.npc("orla").gender==1 and s.npc("orla").sculpt==0,"Legacy Orla migrates to fixed feminine identity")
 check(s.npc("hedrik").hair_color==3 and s.npc("hedrik").beard_color==3,"Younger Hedrik retains chestnut hair and beard")
 var catalog=HoldFrontier.candidates(s).duplicate(true)
 check(catalog.size()==4,"Four generated candidates")
 for id in catalog:
  check(HoldOutpost.recruit(s,id),"Generated recruit signs on: "+id)
  check(s.npc(id).name==catalog[id].name,"Recruit portrait and identity agree")
  for i in 5:check(not HoldOutpost.line(s,id,true).is_empty(),"Generated voice has authored dialogue")
  check(HoldOutpost.favor(s,id),"Generated personal project works")
  check(not HoldOutpost.context(s,id).is_empty(),"Generated favor context is safe")
 var second=HoldState.new();second.reset(91518)
 check(HoldFrontier.candidates(second)!=catalog,"Another world has a different generated crew")
 check(HoldFrontier.candidates(s)==catalog,"Reopening hiring does not reroll people")
 check(HoldClaimStories.poll(s)=="A place at the table","First crew opens shared supper")
 var q=HoldClaimStories.ensure(s);var who=q.active.actor;var wood=s.count("wood")
 s.active_site="hold";check(not HoldClaimStories.choose(g,"table"),"No remote delivery from employer hold")
 check(s.count("wood")==wood,"Rejected remote choice consumes nothing")
 s.active_site="claim";check(HoldClaimStories.choose(g,"later"),"Can defer without punishment")
 check(HoldClaimStories.poll(s)=="" and q.active.deferred,"Deferred request does not repeat notifications")
 check(HoldClaimStories.choose(g,"table"),"Common table uses actual stores")
 check(s.count("wood")==wood-4 and q.features.table,"Table cost and lasting furnishing")
 check(HoldClaimStories.trust(s,who)==.02,"Shared work earns bounded trust")
 wood=s.count("wood");check(not HoldClaimStories.choose(g,"table") and s.count("wood")==wood,"Completed choice cannot pay twice")
 # Discovery follows an actual strike, with a surviving exposed neighbor.
 var c=Vector2i(79,50);g.geo.set_cell(c,3);g.geo.set_cell(c+Vector2i.RIGHT,3);g.geo.set_cell(c+Vector2i.LEFT,0)
 var result=g.geo.strike(c,100);HoldClaimStories.notice_ore(s,g.geo,result)
 check(not q.discovery.is_empty() and g.geo.at(int(q.discovery.x),int(q.discovery.y))==3,"Discovery binds to real remaining ore")
 ready(s);check(HoldClaimStories.poll(s)=="A seam worth keeping","Worked seam opens a matching story")
 g.zone="mine";check(HoldClaimStories.choose(g,"brace"),"Can choose a physical reinforcement task")
 check(not HoldClaimStories.choose(g,"report"),"Cannot report without an anchored frame")
 var foot=Vector2i(78,55)
 for x in range(foot.x,foot.x+12):g.geo.set_cell(Vector2i(x,foot.y-12),0)
 for x in [foot.x,foot.x+11]:
  for y in range(foot.y-11,foot.y+1):g.geo.set_cell(Vector2i(x,y),0)
  g.geo.set_cell(Vector2i(x,foot.y+1),2)
 g.player=g.geo.center(foot)+Vector2(30,0);g.construction.selected="support"
 check(g.construction.place(foot),"Normal construction places an anchored support")
 check(HoldClaimStories.braced(g,q.active),"Story recognizes actual nearby frame")
 g.geo.set_cell(Vector2i(foot.x,foot.y-12),0)
 check(not HoldClaimStories.braced(g,q.active),"Destroyed frame cannot be reported")
 g.geo.set_cell(Vector2i(foot.x,foot.y-12),13)
 check(HoldClaimStories.choose(g,"report"),"Physical work closes story")
 ready(s);s.queue=[{"id":"iron","left":10.0}]
 check(HoldClaimStories.poll(s)=="The sound of a good workshop","Staff and queued work unlock workshop story")
 var parts=s.count("parts");check(HoldClaimStories.choose(g,"calibrate"),"Workshop choice applies")
 check(q.features.calibrate and s.count("parts")==parts-2,"Calibration pays real materials")
 check(HoldOutpost.workshop_speed(s,.1)>1,"Calibration and staff contribute to production")
 ready(s);check(HoldClaimStories.poll(s)=="An address worth remembering","Beacon opens visiting freight")
 var money=s.money;check(HoldClaimStories.choose(g,"trade") and s.money==money+110,"Freight exchanges actual goods for payment")
 ready(s);check(HoldClaimStories.poll(s)=="","Resolved templates do not repeat forever")
 s.save_slot=3;check(s.save_world(g.geo,"claim",Vector2(150,410)),"Story state saves")
 var restored=HoldState.new();restored.save_slot=3;restored.load_world(Geology.new())
 for kind in q.done:
  var loaded=HoldClaimStories.ensure(restored).done[kind]
  check(loaded.choice==q.done[kind].choice and loaded.actor==q.done[kind].actor and loaded.text==q.done[kind].text,"Decision survives reload: "+kind)
 for id in catalog:
  var loaded=HoldFrontier.candidates(restored)[id]
  check(loaded.name==catalog[id].name and loaded.voice==catalog[id].voice and HoldAppearance.normalized(loaded.profile)==HoldAppearance.normalized(catalog[id].profile),"Generated identity survives reload: "+id)
 check(HoldClaimStories.ensure(restored).features==q.features,"Furnishings and workshop changes persist")
 # Contrasting fortune chooses a quiet meal, then surveys instead of reinforcing.
 setup(g,91518);s=g.state
 HoldOutpost.recruit(s,"settler_0");HoldClaimStories.poll(s);q=HoldClaimStories.ensure(s)
 check(HoldClaimStories.choose(g,"meal") and not q.features.get("table",false),"Other fortune can establish a meal without table")
 c=Vector2i(92,48);g.geo.set_cell(c,4);g.geo.set_cell(c+Vector2i.RIGHT,4);g.geo.set_cell(c+Vector2i.LEFT,0)
 HoldClaimStories.notice_ore(s,g.geo,g.geo.strike(c,100));ready(s);HoldClaimStories.poll(s);g.zone="mine"
 check(q.active.target.kind==4,"Other fortune binds to its copper face")
 check(HoldClaimStories.choose(g,"survey") and q.markers.size()==1,"Survey branch marks actual seam")
 check(q.done.seam.choice=="survey" and HoldClaimStories.ensure(restored).done.seam.choice=="report","Different decisions make distinct claim histories")
 for panel in ["manage","claim_stories","roster","visitor"]:
  g.visitor_key="settler_0";g.open_panel(panel);check(g.panel.visible,"UI supports generated crew: "+panel)
 g.close_panel();g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("STORIES32: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
