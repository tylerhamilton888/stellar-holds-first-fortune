extends "res://tests/support/game_fixture.gd"
const BATCH=["dagr","odrin","osvik","tovan","kelvar"]
const WORKERS=["dagr","osvik","tovan","kelvar","yrsa"]
func verify_bundle(id:String,p:Dictionary):
 var sheet=HoldStoryWorld105.PREFIX+id+".webp"
 var count=24 if id=="odrin" else 40
 check(p.cast_id==id and HoldStoryWorld105.has_profile(p),"Named identity enabled "+id)
 check(HoldWholeFrames.metadata[sheet].size()==count,"All reachable poses exist "+id)
 for m in HoldWholeFrames.metadata[sheet]:
  check(m.has("source") and ResourceLoader.exists(m.source),"Authored source packaged "+id)
  check(m.height>0 and m.rect[2]>0 and m.rect[3]>0,"Valid extraction and body calibration "+id)
 for v in 4:
  var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][v]
  var rest=HoldWholeFrames.descriptor(p,d,false,0,"town_walk",0)
  check(rest.sheet==sheet and rest.index==v,"Resting view "+id+str(v))
  for k in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,k*.13+.001,"town_walk",0)
   check(a.sheet==sheet and a.index==4+v*4+k,"Ordered physical walking key "+id+str(v)+str(k))
   check(is_equal_approx(a.scale*HoldWholeFrames.metadata[sheet][a.index].height,float(HoldStoryWorld105.HEIGHTS.get(id,62))),"Existing character stature "+id)
 var start=20 if id=="odrin" else 24
 var heights={}
 for d in [Vector2.RIGHT,Vector2.LEFT]:
  for k in 4:
   var a=HoldWholeFrames.descriptor(p,d,true,0,"hammer",[0,.3,.6,.85][k])
   check(a.sheet==sheet and a.index==start+k and a.view==1 and not a.walking,"Whole hammer swing "+id+str(k))
   heights[HoldWholeFrames.metadata[sheet][a.index].height]=true
 check(heights.size()==1,"Raising hammer preserves body scale "+id)
 if id!="odrin":
  for k in range(-1,5):
   var a=HoldWholeFrames.descriptor(p,Vector2.LEFT,true,0,"drink",k)
   check(a.sheet==sheet and a.index==20+clampi(k,0,3) and a.view==0 and not a.walking,"Drinking retains named body and hand "+id)
  for spec in [[Vector2.DOWN,28,0],[Vector2.RIGHT,32,1],[Vector2.LEFT,32,1],[Vector2.UP,36,3]]:
   heights={}
   for k in 4:
    var a=HoldWholeFrames.descriptor(p,spec[0],true,0,"pick",[0,.3,.6,.85][k])
    check(a.sheet==sheet and a.index==spec[1]+k and a.view==spec[2] and not a.walking,"Directional mining retains identity "+id+str(k))
    heights[HoldWholeFrames.metadata[sheet][a.index].height]=true
   check(heights.size()==1,"Raised mining tool preserves body scale "+id+str(spec[0]))
 var generic=p.duplicate(true);generic.erase("cast_id")
 for action in ["axe","carry_stone","combat_axe","hold_rifle"]:
  check(HoldWholeFrames.descriptor(p,Vector2.RIGHT,false,0,action,.6)==HoldWholeFrames.descriptor(generic,Vector2.RIGHT,false,0,action,.6),"Unsupported future action retains functional fallback "+id+action)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var profiles={}
 for id in BATCH+["yrsa"]:
  profiles[id]=(HoldWorkplace98.profile() if id=="odrin" else g.state.npc(id)).duplicate(true)
  verify_bundle(id,profiles[id])
 check(HoldStoryWorld105.APPROVED.size()==26 and HoldStoryWorld105.CAST.size()==26,"Original twenty-four plus two ridge characters enabled")
 for id in HoldStoryArt105.CAST:
  check(id in HoldStoryWorld105.APPROVED,"Every portrait cast member has a world bundle "+id)
 check(not HoldStoryWorld105.has_profile(g.state.appearance),"Player art preserved")
 var unknown=g.state.appearance.duplicate(true);unknown.cast_id="unreviewed_future"
 for action in ["town_walk","drink","pick","hammer"]:
  check(not HoldStoryWorld105.has_profile(unknown,action),"Unknown future identity stays gated "+action)
  check(HoldWholeFrames.descriptor(unknown,Vector2.RIGHT,true,.3,action,.6)==HoldWholeFrames.descriptor(g.state.appearance,Vector2.RIGHT,true,.3,action,.6),"Unknown future identity retains working renderer "+action)
 # Rotate the actual hiring seats by recruiting their previous occupants.
 HoldFirstVisit99.begin(g);settle();HoldFrontier103.data(g.state).keldrath_open=true
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.money+=2000;g.state.add("food",500)
 check(HoldOutpost.recruit(g.state,"brann"),"Previous guest can leave the hiring bench")
 for id in WORKERS:
  g.surface.enter("room:tavern");settle();at(Vector2(520,610))
  check(HoldNpcPresence.tavern_guests(g.state).has(id),"Actual hiring seat reachable "+id)
  g.clock=14-posmod(hash(id),11);await snap(id+"-tavern")
  g.surface.action("talk:"+id)
  check(g.panel_id=="conversation" and g.talk_id==id,"Existing conversation reachable "+id);g.close_panel()
  check(HoldOutpost.recruit(g.state,id),"Existing recruitment transaction "+id)
  for role in HoldOutpost.ROLES:check(HoldOutpost.assign(g.state,id,role),"Existing role reassignment "+id+role)
  check(HoldOutpost.assign(g.state,id,"miner"),"Miner role permits physical work "+id)
 g.travel_claim();settle();g.change_zone("mine");settle();g.state.agents_enabled=true
 var walked={};var mined={}
 for i in 1200:
  g.deep.agents(.1)
  for a in g.agents:
   if a.id not in WORKERS:continue
   if not a.path.is_empty():walked[a.id]=true
   if a.work:
    mined[a.id]=true
    var phase=fposmod(1.5-float(a.cool)/maxf(.1,float(a.get("swing",.6))),1.0)
    var pose=HoldWholeFrames.descriptor(profiles[a.id],a.get("facing",Vector2.DOWN),false,0,"pick",phase)
    check(pose.sheet.ends_with("/"+a.id+".webp"),"Live miner uses own action art "+a.id)
  if walked.size()==WORKERS.size() and mined.size()==WORKERS.size():break
 for id in WORKERS:check(walked.has(id) and mined.has(id),"Reassigned crew member travels and mines "+id)
 for a in g.agents:
  if a.id in WORKERS:g.player=a.p+Vector2(0,65);await snap(a.id+"-mining")
 # Each dwarf takes a turn in the same functional workshop. Only one occupant
 # is assigned at once; ordinary work assignment and route finding are used.
 var world=g.deep.world;var works=g.deep.works.model
 for item in ["stone","wood","iron","coal"]:g.state.add(item,100)
 for y in range(6,13):
  for x in range(7,21):world.set_cell(Vector2i(x,y),0)
 works.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 works.place(Vector2i(15,7),"bench");works.place(Vector2i(17,7),"anvil");works.place(Vector2i(14,6),"lamp");works.refresh()
 var room={}
 for r in works.data.rooms.values():
  if r.kind=="workshop":room=r;break
 check(not room.is_empty() and room.metrics.active,"Existing workshop can receive crew")
 if not room.is_empty():
  var previous=""
  for id in WORKERS:
   if previous!="":works.data.assignments[previous].work=""
   check(works.assign(id,room.id).contains("assigned."),"Workshop accepts "+id)
   var reached=false
   for i in 1200:
    g.deep.agents(.1)
    for a in g.agents:
     if a.id==id and a.work and not works.destination(id).is_empty():
      reached=Deepworks.cell(a.p)==works.stand(room);g.player=a.p+Vector2(0,65)
    if reached:break
   check(reached,"Real workshop route and hammering "+id)
   for k in 4:g.clock=[0.0,.24,.48,.68][k];await snap(id+"-hammer-"+str(k))
   previous=id
 g.save_game();var inventory=g.state.inventory.duplicate(true);var crew=g.state.outpost.crew.duplicate(true);var assignments=works.data.assignments.duplicate(true)
 g.start_game(true);settle()
 check(g.state.inventory==inventory,"Reload preserves supplies")
 check(g.state.outpost.crew.size()==crew.size() and crew.keys().all(func(id):return g.state.outpost.crew.has(id)),"Reload preserves all recruited members")
 for id in WORKERS:
  check(g.state.npc(id)==profiles[id],"Reload preserves named identity "+id)
  check(g.state.outpost.crew[id].role==crew[id].role,"Reload preserves worker role "+id)
  check(g.deep.works.model.data.assignments[id].work==assignments[id].work,"Reload preserves workshop history "+id)
 check(HoldWorkplace98.profile()==profiles.odrin,"Odrin retains separate persistent workplace identity")
 print("STORYBATCH123: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
