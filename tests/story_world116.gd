extends "res://tests/support/game_fixture.gd"
func rurik_actor()->Dictionary:
 for actor in HoldWorkerLodge100.people(g):
  if actor.get("interaction","")=="lodge_folk:1":return actor
 return {}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.surface.enter(HoldFrontier103.lodge(g.state));settle()
 var p=HoldWorkerLodge100.profile(g,1);var identity=p.duplicate(true)
 var sheet="res://assets/story105/world/rurik.webp"
 check(p.cast_id=="rurik" and HoldStoryWorld105.has_profile(p),"Lodge stone hauler uses Rurik's reviewed world art")
 check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==20,"Production registers all twenty Rurik poses")
 for view in 4:
  var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][view]
  var idle=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
  check(idle.sheet==sheet and idle.index==view,"Rurik resting view "+str(view))
  check(is_equal_approx(idle.scale*float(HoldWholeFrames.metadata[sheet][view].height),62.0),"Rurik preserves 62px world stature")
  for key in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,key*.13+.001,"town_walk",0)
   check(a.sheet==sheet and a.index==4+view*4+key,"Rurik whole gait key "+str(view)+":"+str(key))
 var generic=p.duplicate(true);generic.erase("cast_id")
 for action in ["drink","pick","hammer","carry_stone","combat_axe"]:
  check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Future unsupported action retains its renderer: "+action)
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player artwork unchanged")
 for step in 113:
  var t=step*.25;g.state.elapsed=t;var actor=rurik_actor();var phase=fposmod(t,28.0)
  var x=lerpf(250,350,clampf((phase-4)/6,0,1)) if phase<14 else lerpf(350,250,clampf((phase-18)/6,0,1))
  var walking=(phase>=4 and phase<10) or (phase>=18 and phase<24)
  check(not actor.is_empty() and actor.profile.cast_id=="rurik","Lodge route retains identity "+str(step))
  check(actor.p.distance_to(Vector2(x,490))<.01 and actor.walking==walking,"Lodge route and pauses preserved "+str(step))
  check(HoldWholeFrames.descriptor(actor.profile,actor.aim,actor.walking,actor.gait,actor.get("pose","town_walk"),0).sheet==sheet,"Live lodge route keeps authored art "+str(step))
 for sample in [["walk",7.0],["rest",12.0],["return",21.0]]:
  g.state.elapsed=sample[1];at(Vector2(410,550));await snap("rurik-"+sample[0])
 HoldWorkerLodge100.speak(g,1)
 check(g.panel_id=="lodge_talk" and g.lodge_talker==1,"Rurik's existing conversation remains reachable")
 await snap("rurik-conversation");g.close_panel()
 var saved_actor=rurik_actor();var inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(HoldWorkerLodge100.profile(g,1)==identity,"Generated lodge identity survives reload")
 var restored=rurik_actor()
 check(restored.p==saved_actor.p and restored.walking==saved_actor.walking and restored.profile==saved_actor.profile,"Saved clock, route and artwork survive reload")
 check(g.state.inventory==inventory,"World art leaves inventory unchanged")
 g.surface.enter("trail");settle()
 check(rurik_actor().is_empty(),"Rurik does not appear outside his lodge")
 g.surface.enter("room:lodge");settle()
 if HoldFrontier103.lodge(g.state)!="room:lodge":check(rurik_actor().is_empty(),"Frontier lodge does not duplicate Rurik into the legacy room")
 print("STORYWORLD116: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
