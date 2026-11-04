extends "res://tests/support/game_fixture.gd"
func bram_at(time:float)->Dictionary:
 for actor in g.surface.roads.people("trail",time):
  if actor.get("interaction","")=="road_folk:0":return actor
 return {}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.surface.enter("trail");settle()
 at(bram_at(g.state.elapsed).p+Vector2(0,45));g.surface.action("road_folk:0");g.close_panel()
 var p=g.state.npc("road_folk:0");var identity=p.duplicate(true)
 check(p.first_name=="Bram","Normal first interaction registers Bram under his authored name")
 check(HoldStoryWorld105.has_profile(p),"Bram uses reviewed world art in production")
 check(not HoldOutpost.CREW.has("bram") and not HoldOutpost.CREW.has("road_folk:0"),"Current Bram routes do not assign unpainted worker actions")
 var sheet="res://assets/story105/world/bram.webp"
 check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==20,"Production registers all 20 Bram poses")
 for id in ["dagr","odrin","osvik","tovan","kelvar"]:
  check(HoldStoryWorld105.has_profile(HoldStoryArt105.tag(p,id)),"Final named cast remains enabled "+id)
 for frame in HoldWholeFrames.metadata[sheet]:
  check(frame.has("source") and ResourceLoader.exists(frame.source),"Each Bram pose selects an existing authored atlas")
 for view in 4:
  var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
  var idle=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
  check(idle.sheet==sheet and idle.index==view,"Authored resting view "+str(view))
  check(is_equal_approx(idle.scale*float(HoldWholeFrames.metadata[sheet][view].height),62.0),"Bram retains his sturdy 62px stature")
  for key in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,key*.13+.001,"town_walk",0)
   check(a.sheet==sheet and a.index==4+view*4+key,"Production uses four distinct whole gait keys "+str(view)+":"+str(key))
 var generic=p.duplicate(true);generic.erase("cast_id")
 for action in ["drink","pick","hammer","carry_stone","combat_axe"]:
  check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Unsupported future action retains its functional renderer: "+action)
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player keeps existing character artwork")
 var duration=290.0/38.0;var cycle=2*(duration+7);var beginning=2*cycle
 var visited={}
 for step in 120:
  var time=beginning+step*.25;var actor=bram_at(time)
  check(not actor.is_empty() and actor.profile.cast_id=="bram","Route retains named identity "+str(step))
  var local=fposmod(time,cycle);var forward=local<=duration+7
  if not forward:local-=duration+7
  var expected=Vector2(730,650).lerp(Vector2(1020,650),minf(1,local/duration)) if forward else Vector2(1020,650).lerp(Vector2(730,650),minf(1,local/duration))
  check(actor.p.distance_to(expected)<.01 and actor.walking==(local<duration),"World art preserves route position and movement timing "+str(step))
  var pose=actor.get("pose","town_walk");visited[pose]=true
  var a=HoldWholeFrames.descriptor(actor.profile,actor.aim,actor.walking,actor.gait,pose,actor.get("phase",0.0))
  check(a.sheet==sheet,"Live route never swaps to generic art "+str(step))
 check(not visited.has("drink") and visited.has("town_walk"),"Route retains existing walking and rest without invented activities")
 for sample in [["walk",.8],["rest",duration+.5],["resume",duration+7.5]]:
  g.state.elapsed=beginning+sample[1];at(Vector2(900,760));await snap("bram-"+sample[0])
 at(bram_at(g.state.elapsed).p+Vector2(0,45));g.surface.action("road_folk:0")
 check(g.panel_id=="conversation" and g.talk_id=="road_folk:0","Bram conversation remains reachable with authored world art")
 await snap("bram-conversation");g.close_panel()
 var saved_actor=bram_at(g.state.elapsed);var saved_inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.state.npc("road_folk:0")==identity,"World art leaves saved appearance unchanged")
 var restored=bram_at(g.state.elapsed)
 check(restored.p==saved_actor.p and restored.get("pose","")==saved_actor.get("pose","") and restored.profile==saved_actor.profile,"Saved-clock activity and identity survive reload")
 check(g.state.inventory==saved_inventory,"World art does not consume or create inventory")
 check(not HoldCourtship101.ARCS.has("road_folk:0") and not HoldRoadCharacters.CAST["road_folk:0"].romance_candidate,"Bram remains the non-romance road keeper")
 HoldFrontier103.data(g.state).home_reward=true;HoldGreatClaim102.data(g.state).points=220
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(480,500))
 g.state.surface.erase("campaign138") # Legacy established-save fixture; campaign138 tests new eligibility.
 check(HoldMountain104.act(g,"rescue"),"Rescue can begin without displacing the road keeper")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state)
 check(not q.victims.has("road_folk:0"),"Bram remains outside the existing rescue victim selection")
 var keeper=bram_at(g.state.elapsed)
 check(not keeper.is_empty() and keeper.profile.cast_id=="bram","Bram stays on his road route during rescue")
 if not keeper.is_empty():
  check(HoldWholeFrames.descriptor(keeper.profile,keeper.aim,keeper.walking,keeper.gait,"town_walk",0).sheet==sheet,"Road keeper retains authored world art during rescue")
 print("STORYWORLD120: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
