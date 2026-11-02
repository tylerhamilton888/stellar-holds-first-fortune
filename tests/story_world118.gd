extends "res://tests/support/game_fixture.gd"
func ketil_at(time:float)->Dictionary:
 for actor in g.surface.roads.people("greenfields",time):
  if actor.get("interaction","")=="road_folk:4":return actor
 return {}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.surface.enter("greenfields");settle()
 at(ketil_at(g.state.elapsed).p+Vector2(0,45));g.surface.action("road_folk:4");g.close_panel()
 var p=g.state.npc("road_folk:4");var identity=p.duplicate(true)
 check(p.first_name=="Ketil","Normal first interaction registers Ketil under his authored name")
 check(HoldStoryWorld105.has_profile(p),"Ketil uses reviewed world art in production")
 check(not HoldOutpost.CREW.has("ketil") and not HoldOutpost.CREW.has("road_folk:4"),"Current Ketil routes do not assign unpainted worker actions")
 var sheet="res://assets/story105/world/ketil.webp"
 check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==20,"Production registers all 20 Ketil poses")
 for id in HoldStoryWorld105.CAST:
  if id not in ["dagna","ragnhild","brynja","edda","rurik","torvik","ketil","hakon","bram","sten","orla","sigrid","yrsa","skarrin"]:check(not HoldStoryWorld105.has_profile(HoldStoryArt105.tag(p,id)),"Unreviewed character remains inactive "+id)
 for view in 4:
  var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
  var idle=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
  check(idle.sheet==sheet and idle.index==view,"Authored resting view "+str(view))
  check(is_equal_approx(idle.scale*float(HoldWholeFrames.metadata[sheet][view].height),62.0),"Ketil retains his sturdy 62px stature")
  for key in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,key*.13+.001,"town_walk",0)
   check(a.sheet==sheet and a.index==4+view*4+key,"Production uses four distinct whole gait keys "+str(view)+":"+str(key))
 var generic=p.duplicate(true);generic.erase("cast_id")
 for action in ["drink","pick","hammer","carry_stone","combat_axe"]:
  check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Unsupported future action retains its functional renderer: "+action)
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player keeps existing character artwork")
 var duration=420.0/38.0;var cycle=2*(duration+7);var beginning=2*cycle-36
 var visited={}
 for step in 148:
  var time=beginning+step*.25;var actor=ketil_at(time)
  check(not actor.is_empty() and actor.profile.cast_id=="ketil","Route retains named identity "+str(step))
  var local=fposmod(time+36,cycle);var forward=local<=duration+7
  if not forward:local-=duration+7
  var expected=Vector2(1110,790).lerp(Vector2(1530,790),minf(1,local/duration)) if forward else Vector2(1530,790).lerp(Vector2(1110,790),minf(1,local/duration))
  check(actor.p.distance_to(expected)<.01 and actor.walking==(local<duration),"World art preserves route position and movement timing "+str(step))
  var pose=actor.get("pose","town_walk");visited[pose]=true
  var a=HoldWholeFrames.descriptor(actor.profile,actor.aim,actor.walking,actor.gait,pose,actor.get("phase",0.0))
  check(a.sheet==sheet,"Live route never swaps to generic art "+str(step))
 check(not visited.has("drink") and visited.has("town_walk"),"Route retains existing walking and rest without invented activities")
 for sample in [["walk",.8],["rest",duration+.5],["resume",duration+7.5]]:
  g.state.elapsed=beginning+sample[1];at(Vector2(1250,850));await snap("ketil-"+sample[0])
 at(ketil_at(g.state.elapsed).p+Vector2(0,45));g.surface.action("road_folk:4")
 check(g.panel_id=="conversation" and g.talk_id=="road_folk:4","Ketil conversation remains reachable with authored world art")
 await snap("ketil-conversation");g.close_panel()
 var saved_actor=ketil_at(g.state.elapsed);var saved_inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.state.npc("road_folk:4")==identity,"World art leaves saved appearance unchanged")
 var restored=ketil_at(g.state.elapsed)
 check(restored.p==saved_actor.p and restored.get("pose","")==saved_actor.get("pose","") and restored.profile==saved_actor.profile,"Saved-clock activity and identity survive reload")
 check(g.state.inventory==saved_inventory,"World art does not consume or create inventory")
 HoldCourtship101.record(g.state,"road_folk:4").stage=1
 HoldFrontier103.data(g.state).home_reward=true;HoldGreatClaim102.data(g.state).points=220
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(480,500))
 check(HoldMountain104.act(g,"rescue"),"Mountain rescue can begin with authored Ketil")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state);var index=q.victims.find("road_folk:4")
 check(index>=0,"Ketil is retained as the named partner victim")
 if index>=0:
  var survivor=HoldMountain104.profile(g,index)
  check(survivor.cast_id=="ketil" and HoldWholeFrames.descriptor(survivor,Vector2.UP,true,.26,"town_walk",0).sheet==sheet,"Rescue reuses the same whole-character bundle")
 check(ketil_at(g.state.elapsed).is_empty(),"Trapped Ketil is absent from the greenfields route")
 print("STORYWORLD118: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
