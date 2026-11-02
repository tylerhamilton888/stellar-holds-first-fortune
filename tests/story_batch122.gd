extends "res://tests/support/game_fixture.gd"
const BATCH=["ivar","hedrik","borin","eldric","brann"]
const COUNTS={"ivar":20,"hedrik":24,"borin":24,"eldric":20,"brann":40}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var profiles={}
 for id in BATCH:
  var p=g.state.npc(id).duplicate(true);profiles[id]=p
  var sheet=HoldStoryWorld105.PREFIX+id+".webp"
  check(p.cast_id==id and HoldStoryWorld105.has_profile(p),"Normal named accessor enables "+id)
  check(HoldWholeFrames.metadata[sheet].size()==COUNTS[id],"All reachable activity frames exist "+id)
  for m in HoldWholeFrames.metadata[sheet]:
   check(m.has("source") and ResourceLoader.exists(m.source),"Packed whole source exists "+id)
   check(m.height>0 and m.rect[2]>0 and m.rect[3]>0,"Valid body calibration "+id)
  for v in 4:
   var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][v]
   var rest=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
   check(rest.sheet==sheet and rest.index==v,"Rest keeps view "+id+str(v))
   var keys={}
   for k in 4:
    var a=HoldWholeFrames.descriptor(p,d,true,k*.13+.001,"town_walk",0)
    check(a.sheet==sheet and a.index==4+v*4+k,"Four ordered walking keys "+id+str(v)+str(k))
    check(is_equal_approx(a.scale*HoldWholeFrames.metadata[sheet][a.index].height,62),"Established world height "+id)
    keys[a.index]=true
   check(keys.size()==4,"Opposite contact and passing keys remain distinct "+id+str(v))
  var generic=p.duplicate(true);generic.erase("cast_id")
  for action in ["axe","carry_stone","combat_axe","hold_rifle"]:
   check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Future unsupported activity keeps functional fallback "+id+action)
 for id in ["hedrik","brann"]:
  for k in range(-1,5):
   var a=HoldWholeFrames.descriptor(profiles[id],Vector2.LEFT,true,0,"drink",k)
   check(a.index==20+clampi(k,0,3) and a.view==0 and not a.walking,"Whole drink clamping "+id+str(k))
 for id in ["borin","brann"]:
  var start=20 if id=="borin" else 24
  var heights={}
  for d in [Vector2.RIGHT,Vector2.LEFT]:
   for k in 4:
    var a=HoldWholeFrames.descriptor(profiles[id],d,false,0,"hammer",[0,.3,.6,.85][k])
    check(a.index==start+k and a.view==1 and not a.walking,"Hammer contact timing "+id+str(k))
    check(a.sheet.ends_with("/"+id+".webp"),"Working body retains identity "+id)
    heights[HoldWholeFrames.metadata[a.sheet][a.index].height]=true
  check(heights.size()==1,"Raised hammer cannot rescale body "+id)
 for spec in [[Vector2.DOWN,28,0],[Vector2.RIGHT,32,1],[Vector2.LEFT,32,1],[Vector2.UP,36,3]]:
  for k in 4:
   var a=HoldWholeFrames.descriptor(profiles.brann,spec[0],true,0,"pick",[0,.3,.6,.85][k])
   check(a.index==spec[1]+k and a.view==spec[2] and a.sheet.ends_with("/brann.webp") and not a.walking,"Brann mining direction/contact "+str(spec[0])+str(k))
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player art preserved")
 check(not HoldStoryWorld105.has_profile(g.state.npc("dagr")),"Remaining cast stays quarantined")
 # New saves meet the same Ivar in the actual worker lodge.
 HoldFirstVisit99.begin(g);settle();g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(510,470))
 check(HoldWorkerLodge100.profile(g,0)==profiles.ivar,"Lodge keeps Ivar's saved identity")
 HoldWorkerLodge100.speak(g,0);check(g.panel_id=="lodge_talk","Ivar lodge conversation reachable");await snap("ivar-lodge-talk");g.close_panel()
 HoldFrontier103.data(g.state).keldrath_open=true
 for spec in [["hedrik","tavern"],["borin","forge"],["eldric","research"]]:
  g.surface.enter("room:"+spec[1]);settle();at(Vector2(620,480));g.surface.action("talk:"+spec[0])
  check(g.panel_id=="conversation" and g.talk_id==spec[0],"Existing service conversation "+spec[0]);await snap(spec[0]+"-conversation");g.close_panel()
 g.surface.enter("room:tavern");settle();at(Vector2(500,530))
 check(HoldNpcPresence.tavern_guests(g.state).has("brann"),"Brann remains available at the hiring bench")
 for k in 4:g.clock=[0.0,12.5,14.0,17.5][k];await snap("tavern-drink-"+str(k))
 g.surface.enter("room:forge");settle();at(Vector2(640,510));g.state.opening=4
 for k in 4:g.clock=[0.0,.4,.8,1.4][k];await snap("borin-hammer-"+str(k))
 check(HoldNpcActivity.smith_frame(.8)==4 and HoldNpcActivity.struck_between(.79,.81),"Borin's existing strike and sound timing remain intact")
 # The legacy escort traverses the real collision-checked route with Ivar.
 g.opening_scene=HoldArrivalEscort.start(g);var scene=g.opening_scene;scene.set_process(false);scene.age=1;scene.advance();settle()
 var start=scene.guide;var keys={}
 for i in 90:
  scene.tick(1.0/60)
  var a=HoldWholeFrames.descriptor(profiles.ivar,scene.guide_direction,scene.ivar_walking,scene.guide_gait,"town_walk",0)
  check(a.sheet.ends_with("/ivar.webp"),"Escort uses Ivar whole art");keys[a.index]=true
 check(scene.guide.distance_to(start)>80 and keys.size()>=4 and not scene.failed_route,"Ivar walks with the collision-checked escort")
 await snap("ivar-escort");scene.finish();await process_frame;settle()
 # Recruitment and the real worker simulation retain Brann through mining,
 # travel and workshop assignment, rather than exercising only a preview.
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.money+=1000;g.state.add("food",100)
 check(HoldOutpost.recruit(g.state,"brann"),"Brann recruitment remains available")
 g.travel_claim();settle();g.change_zone("mine");settle();g.state.agents_enabled=true
 var saw_walk=false;var saw_pick=false
 for i in 600:
  g.deep.agents(.1)
  for a in g.agents:
   if a.id!="brann":continue
   saw_walk=saw_walk or not a.path.is_empty();saw_pick=saw_pick or a.work
  if saw_walk and saw_pick:break
 check(saw_walk and saw_pick,"Brann's real miner travels and starts work")
 for a in g.agents:
  if a.id=="brann":g.player=a.p+Vector2(0,70)
 await snap("brann-mining")
 var world=g.deep.world;var works=g.deep.works.model
 for item in ["stone","wood","iron","coal"]:g.state.add(item,80)
 for y in range(6,13):
  for x in range(7,21):world.set_cell(Vector2i(x,y),0)
 works.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 works.place(Vector2i(15,7),"bench");works.place(Vector2i(17,7),"anvil");works.place(Vector2i(14,6),"lamp");works.refresh()
 var room={}
 for r in works.data.rooms.values():
  if r.kind=="workshop":room=r;break
 check(not room.is_empty() and room.metrics.active,"Existing workshop can receive Brann")
 if not room.is_empty():
  works.assign("brann",room.id)
  var reached=false
  for i in 600:
   g.deep.agents(.1)
   for a in g.agents:
    if a.id=="brann" and a.work:reached=true;g.player=a.p+Vector2(0,65)
   if reached:break
  check(reached and not works.destination("brann").is_empty(),"Brann reaches his assigned workshop")
  for k in 4:g.clock=[0.0,.24,.48,.68][k];await snap("brann-workshop-"+str(k))
 g.save_game();var inventory=g.state.inventory.duplicate(true);var crew=g.state.outpost.crew.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==inventory,"Reload preserves player supplies")
 check(g.state.outpost.crew.keys()==crew.keys() and g.state.outpost.crew.brann.role==crew.brann.role,"Reload preserves recruited crew and role")
 for id in BATCH:check(g.state.npc(id)==profiles[id],"Reload preserves named identity "+id)
 check(g.deep.works.model.data.assignments.has("brann"),"Reload preserves Brann's workplace assignment")
 print("STORYBATCH122: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
