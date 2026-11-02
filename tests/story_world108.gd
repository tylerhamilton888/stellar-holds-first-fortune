extends "res://tests/support/game_fixture.gd"
func dagna_at(time:float)->Dictionary:
 for actor in g.surface.roads.people("room:wayfarer",time):
  if actor.get("interaction","")=="road_folk:1":return actor
 return {}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.surface.enter("room:wayfarer");settle()
 var p=g.state.npc("road_folk:1");var identity=p.duplicate(true)
 check(HoldStoryWorld105.has_profile(p),"Dagna uses reviewed world art in production")
 check(not HoldOutpost.CREW.has("dagna") and not HoldOutpost.CREW.has("road_folk:1"),"Current Dagna routes do not assign unpainted worker actions")
 var sheet="res://assets/story105/world/dagna.webp"
 check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==24,"Production registers all 24 Dagna poses")
 for id in HoldStoryWorld105.CAST:
  if id not in ["dagna","ragnhild","brynja","edda","rurik"]:check(not HoldStoryWorld105.has_profile(HoldStoryArt105.tag(p,id)),"Unreviewed character remains inactive "+id)
 for view in 4:
  var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
  var idle=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
  check(idle.sheet==sheet and idle.index==view,"Authored resting view "+str(view))
  for key in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,key*.13+.001,"town_walk",0)
   check(a.sheet==sheet and a.index==4+view*4+key,"Production uses four distinct whole gait keys "+str(view)+":"+str(key))
 for phase in [-2,0,1,2,3,8]:
  var a=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,0,"drink",phase)
  check(a.sheet==sheet and a.index==20+clampi(phase,0,3) and a.view==0 and not a.walking,"Drink action selects and clamps whole pose "+str(phase))
 var generic=p.duplicate(true);generic.erase("cast_id")
 for action in ["pick","hammer","carry_stone","combat_axe"]:
  check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Unsupported future action retains its functional renderer: "+action)
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player keeps existing character artwork")
 var duration=120.0/38.0;var cycle=2*(duration+7);var beginning=cycle-9
 var visited={}
 for step in 82:
  var time=beginning+step*.25;var actor=dagna_at(time)
  check(not actor.is_empty() and actor.profile.cast_id=="dagna","Route retains named identity "+str(step))
  var local=fposmod(time+9,cycle);var forward=local<=duration+7
  if not forward:local-=duration+7
  var expected=Vector2(380,430).lerp(Vector2(500,430),minf(1,local/duration)) if forward else Vector2(500,430).lerp(Vector2(380,430),minf(1,local/duration))
  check(actor.p.distance_to(expected)<.01 and actor.walking==(local<duration),"Sip preserves route position and movement timing "+str(step))
  var pose=actor.get("pose","town_walk");visited[pose]=true
  var a=HoldWholeFrames.descriptor(actor.profile,actor.aim,actor.walking,actor.gait,pose,actor.get("phase",0.0))
  check(a.sheet==sheet,"Live route never swaps to generic art "+str(step))
  if pose=="drink":check(not actor.walking and actor.aim==Vector2.DOWN,"Sip is planted and front-facing")
 check(visited.has("drink") and visited.has("town_walk"),"Route exercises walking, rest and sip")
 for sample in [["walk",.8],["rest",duration+.5],["sip",duration+2.2],["resume",duration+5]]:
  g.state.elapsed=beginning+sample[1];at(Vector2(445,500));await snap("dagna-"+sample[0])
 var saved_actor=dagna_at(g.state.elapsed);var saved_inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.state.npc("road_folk:1")==identity,"World art leaves saved appearance unchanged")
 var restored=dagna_at(g.state.elapsed)
 check(restored.p==saved_actor.p and restored.get("pose","")==saved_actor.get("pose","") and restored.profile==saved_actor.profile,"Saved-clock activity and identity survive reload")
 check(g.state.inventory==saved_inventory,"Cosmetic sip does not consume or create inventory")
 HoldCourtship101.record(g.state,"road_folk:1").stage=1
 HoldFrontier103.data(g.state).home_reward=true;HoldGreatClaim102.data(g.state).points=220
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(480,500))
 check(HoldMountain104.act(g,"rescue"),"Partner rescue can begin with authored Dagna")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state);var index=q.victims.find("road_folk:1")
 check(index>=0,"Dagna is retained as the named partner victim")
 if index>=0:
  var survivor=HoldMountain104.profile(g,index)
  check(survivor.cast_id=="dagna" and HoldWholeFrames.descriptor(survivor,Vector2.UP,true,.26,"town_walk",0).sheet==sheet,"Rescue reuses the same whole-character bundle")
 check(dagna_at(g.state.elapsed).is_empty(),"Trapped Dagna is absent from the tavern route")
 print("STORYWORLD108: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
