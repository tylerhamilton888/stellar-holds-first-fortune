class_name HoldFirstShift
extends RefCounted
# The teaching bay uses ordinary Handworks records; no second inventory or crafting system.
const STEPS=["Excavate stone, then lift a load · E", "Carry it to the stockpile · E", "Work at the stonebreaker · hold E", "Collect the finished stone · Shift+E", "Craft and place a stockpile · Shift+B", "Build your own stonebreaker · Shift+B", "Your first worksite is ready · follow the coal seam"]
const HELP=["Work an exposed stone face with held pickaxe strokes. E lifts the freed load onto your shoulder. The western loan benches are available for your own material; the eastern crew stock belongs to the hold.","Walk beside the western stone rack and press E. Its visible contents come from the loads you actually deposit.","Stand beside the western stonebreaker and hold E. It draws a load from a rack within reach. Your Dwarf steps into a working stance and breaks it into useful stone.","Stand beside that stonebreaker and press Shift+E. Finished stone moves into your pack, ready for construction. Raw loads and usable materials are different stages of the same workflow.","Open Shift+B, choose Stone stockpile, then Craft & place. Move the preview to clear floor near the seam: green is valid, red is blocked. Left click builds; right click cancels without spending.","Open Shift+B and craft a Stonebreaker beside your new stockpile. Leave space for your boots and keep the entrance clear. Racks feed benches within 150 units; expanding your operation now uses the same tools.","You have made a working production line. Follow the nearby coal seam for Ivar's commission. The hold crew processes its own loads at the eastern benches. Its stock and finished output belong to the hold, not your pack. Later, your hired Folk and carts can take over familiar work."]
static func data(g)->Dictionary:
 var h=g.handworks.data()
 if not h.has("first_shift"):h.first_shift={"version":1,"started":false,"kit":false,"facts":{}}
 return h.first_shift
static func active(g)->bool:return g.zone=="mine" and g.state.active_site=="hold" and g.deep.world.depth()==0
static func step(g)->int:
 var f=data(g).facts
 for i in 6:
  if not f.get(["lift","stock","process","collect","rack","bench"][i],false):return i
 return 6
static func event(g,id:String):
 if active(g) and data(g).started:
  var previous=step(g);data(g).facts[id]=true
  if step(g)>previous:
   g.sound.effect("quest",-22)
   g.notify("First shift · "+STEPS[step(g)])
static func station(g,id:String)->Dictionary:
 for f in g.handworks.data().facilities:
  if str(f.id)=="firstshift:"+id:return f
 return {}
static func clear(g,p:Vector2)->bool:
 for d in [Vector2.ZERO,Vector2(-38,-20),Vector2(38,12)]:
  if g.deep.world.solid(p+d):return false
 if g.deep.world.entrance(p):return false
 for f in g.handworks.data().facilities:
  if g.handworks.local(f) and g.handworks.pos(f).distance_to(p)<80:return false
 return true
static func enter(g):
 if not active(g):return
 var q=data(g)
 if q.started:return
 q.started=true
 HoldWholeFrames.prepare_profile(profile_for(true));HoldWholeFrames.prepare_profile(profile_for(false))
 var h=g.handworks;var created=[]
 for spec in [["bench","breaker",Vector2(220,280)],["rack","stone_pile",Vector2(220,420)],["crewbench","breaker",Vector2(420,280)],["crewrack","stone_pile",Vector2(420,440)]]:
  var p:Vector2=spec[2]
  if not clear(g,p):continue # Never replace existing equipment or excavations.
  created.append(spec[0])
  h.data().facilities.append({"id":"firstshift:"+spec[0],"kind":spec[1],"area":h.context(),"x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false,"fixed":true,"owner":"hold" if str(spec[0]).begins_with("crew") else "loan"})
 var rack=station(g,"crewrack")
 if "crewrack" in created:
  for i in 4:
   var id=int(h.data().next);h.data().next=id+1
   rack.raw.append({"id":id,"kind":"stone","units":2,"source":"hold:crew-supplies","item":"stone"})
 q.crew={"p":[360.0,400.0],"phase":"fetch","carry":{},"gait":0.0}
 g.notify("A place on the first shift. J opens your practical worksite lesson.")
 g.save_game()
static func kit(g):
 var q=data(g)
 if q.kit:return
 if not HoldConversation.local(g,"ivar") or HoldOnboarding.stage(g.state)<2:return
 q.kit=true;g.state.add("wood",6)
 # Older developed mines may already occupy the loan-bench positions.
 if q.started and station(g,"bench").is_empty():g.state.add("wood",3);g.state.add("stone",4)
 g.save_game();g.notify("Ivar issues six lengths of timber for your first equipment. The crew stock remains hold property.")
static func journal(g):
 if not data(g).started:return
 var n=step(g)
 g.label(g.panel_body,"YOUR FIRST WORKSITE",18)
 g.label(g.panel_body,STEPS[n],16,Color("edc98a"));g.label(g.panel_body,HELP[n],15)
 if station(g,"bench").is_empty():g.label(g.panel_body,"Your existing mine layout occupies the loan bay. Keep your equipment; use an existing stonebreaker or build one through Shift+B. Ivar can issue a small construction allowance at his office.",14)
 if not data(g).kit:
  g.label(g.panel_body,"Use your own timber, or ask Ivar at his office for a small worksite allowance. Hold crew stock is not yours to take.",14)
  g.small_button(g.panel_body,"Track Ivar for timber",func():g.state.tracked_npc="ivar";g.save_game();g.close_panel();g.notify("Ivar’s office · Hearthward, southeast of the commons."))
 if active(g):g.button(g.panel_body,"Open equipment plans",func():g.open_panel("handworks"))
static func goal(g)->String:
 return "First shift · %d/6 · " % (step(g)+1)+STEPS[step(g)] if active(g) and data(g).started and step(g)<6 else ""
static func context_hint(g)->String:
 if not active(g) or not data(g).started or step(g)>=6:return ""
 var n=step(g);var h=g.handworks
 if n==0:return "Hold LMB at an exposed rock face · stop moving to plant the pick"
 if n==1:return "Carry the freed stone to the western rack · E stocks it"
 if n==2:
  var rack=station(g,"rack")
  if not rack.is_empty() and rack.raw.is_empty():return "The rack is empty · bring another chunk, or carry one to the stonebreaker"
  return "Western stonebreaker · hold E to work · release whenever you like"
 if n==3:return "Your useful stone is on the bench · Shift+E collects it"
 var kind="stone_pile" if n==4 else "breaker"
 if not g.state.afford(h.SPECS[kind].cost):
  if g.state.count("wood")<int(h.SPECS[kind].cost.get("wood",0)) and not data(g).kit:return "Short of timber? Ask Ivar for your worksite allowance · J keeps the lesson"
  return "Process another load for construction supplies · Shift+E collects the output"
 return "Shift+B · craft your "+h.SPECS[kind].name.to_lower()+" · green fits, right click cancels"
static func crew_ready(g)->bool:
 return active(g) and not station(g,"crewbench").is_empty() and not station(g,"crewrack").is_empty()
static func tick(g,dt:float):
 if not crew_ready(g) or g.panel_id!="":return
 var q=data(g);var c=q.crew;var bench=station(g,"crewbench");var rack=station(g,"crewrack")
 var p=Vector2(c.p[0],c.p[1]);var target=Vector2(360,420) if c.phase=="fetch" else Vector2(364,280)
 # The clear central aisle stays west of the station bases.
 var next=p.move_toward(target,65*dt)
 if not g.deep.world.solid(next):c.gait+=HoldDrawnLocomotion.time_for_distance(p.distance_to(next));p=next
 c.p=[p.x,p.y]
 if p.distance_to(target)<2:
  if c.phase=="fetch" and not rack.raw.is_empty() and bench.job.is_empty() and DeepHaul.amount(bench.cargo)<180:
   c.carry=rack.raw.pop_front();c.phase="deliver"
  elif c.phase=="deliver" and bench.job.is_empty():bench.job={"raw":c.carry,"progress":0.0};c.carry={};c.phase="fetch"
 if not bench.job.is_empty() and not (g.handworks.working and g.handworks.active_id==bench.id):
  bench.job.progress=float(bench.job.progress)+dt*.22
  if float(bench.job.progress)>=1.26:
   var raw=bench.job.raw;var item=HoldHandworks.raw_item(raw)
   bench.cargo[item]=int(bench.cargo.get(item,0))+int(raw.units);bench.job={};g.save_game()
static func actors(g)->Array:
 if not crew_ready(g):return []
 var c=data(g).crew
 return [{"p":Vector2(c.p[0],c.p[1]),"kind":"firstshift","role":"hauler"},{"p":Vector2(364,225),"kind":"firstshift","role":"mason"}]
static func profile_for(mason:bool)->Dictionary:
 var p=HoldAppearance.defaults();p.sculpt=4 if mason else 1;p.hair_color=6 if mason else 3;p.beard_color=p.hair_color;p.cloth_color=5 if mason else 4
 return p
static func draw(g,o:Dictionary,offset:Vector2):
 var c=data(g).crew;var bench=station(g,"crewbench");var mason=o.role=="mason"
 var profile=profile_for(mason)
 var working=mason and not bench.job.is_empty()
 var carrying=not mason and not c.carry.is_empty()
 var target=Vector2(360,420) if c.phase=="fetch" else Vector2(364,280)
 var walking=not mason and o.p.distance_to(target)>2
 var aim=Vector2(1,.45) if mason else (target-o.p).normalized() if walking else Vector2.DOWN
 var phase=fmod(float(bench.job.get("progress",0)),.42)/.42
 HoldDrawnAnimation.paint(g,o.p+offset,profile,aim,walking,float(c.gait),.85,offset,"hammer" if working else "carry_stone" if carrying else "town_walk",phase if working else 1.0)
 g.draw_set_transform(offset)
 if working:HoldDrawnAnimation.work_foreground(g,o.p,profile,aim,.85,offset,"hammer",phase)

static func panel(g):
 var s=g.state;var q=HoldOnboarding.ensure(s)
 g.label(g.panel_body,"IVAR DEEPMEASURE",22,Color("edc98a"))
 var local=HoldOnboarding.local(g,"ivar")
 if HoldOnboarding.settling(s):
  g.label(g.panel_body,"'Put your feet up first. Your bed and storage chest are in the workers’ quarters on the northwestern street. Then introduce yourself to Borin, Orla and Hedrik.'",17)
  g.button(g.panel_body,"Review settling in",func():g.open_panel("guidance"));return
 match int(q.stage):
  0,1:
   g.label(g.panel_body,"Ivar looks up from a ledger thick with coal dust. 'Newly of age, are you? Give me your name. You need a shift, and I need someone who listens before swinging a pick.'",17)
   g.label(g.panel_body,"'Borin checks the tools. Orla knows the routes. Hedrik will feed you. Meet all three, then take eight coal from the Old Workings. Sixty-five crowns when you bring it back. The surplus is yours.'",17)
   g.label(g.panel_body,"'A woman for the lower shift? We do not see that often. Sound work earns sound wages here, sister.'" if int(s.appearance.gender)==1 else "'Welcome to the shift, brother. Work carefully and keep your word. That will do for a beginning.'",16,Color("b6d8c9"))
   var b=g.button(g.panel_body,"My name is "+s.appearance.first_name+" "+s.appearance.family_name+". I am ready to work.",func():
    q.stage=2;s.tracked_npc="borin";g.save_game();g.refresh_panel();g.notify("Meet Borin, Orla and Hedrik. G lists their locations."))
   b.disabled=not local
   if not local:g.label(g.panel_body,"Visit Ivar's office beside the pithead. G lists his location; press E at the door.",15)
  2:
   g.label(g.panel_body,"'Meet the people you will be relying on. Borin's forge is below us in Forgeward. Cross the southern gallery bridge and take the eastern Great Stair; the enclosed service stair is a quicker route. Orla's exchange and the Copper Kettle are on Hearthward's north street. Introduce yourself properly.'",17)
   for id in ["borin","orla","hedrik"]:
    g.button(g.panel_body,("Met: " if q.met.has(id) else "Find: ")+s.npc(id).name,func():s.tracked_npc=id;g.save_game();g.close_panel())
   g.label(g.panel_body,"After all three introductions, your coal commission begins. Step outside and press G for regional travel. Walk northeast to Old Workings, then press E to enter. J keeps the route and mining controls.",16)
  4:
   g.label(g.panel_body,"Ivar weighs the coal and signs a short note. 'The hearth can burn again. Your wage is paid. The Lord takes an interest in new hands who do what they promise. The King's hall is on Crownward. The gallery stairs and hold lift will take you there.'",17)
   g.button(g.panel_body,"Track the audience",func():s.tracked_npc="eirik";g.save_game();g.close_panel())
  5:
   g.label(g.panel_body,"'A fine room, isn't it? I prefer ceilings I can inspect without a telescope. Now, the lift needs sixteen stone and eight timber. The firs in Pinewood will serve. Bring straight lengths.'",17)
   g.label(g.panel_body,"'While you are out, practice building a return route. Borin can teach you to smelt. Eldric will show you what a sample tells us. There is other work about the hold, too. Ask the folk you meet.'",17)
   var b=g.button(g.panel_body,"Take the lift commission and ask about work around the hold",func():
    q.stage=6;s.tracked_npc="ivar";g.save_game();g.refresh_panel();g.notify("New work is marked around the hold. J lists the first-season lessons and local stories."))
   b.disabled=not local
  _:
   g.label(g.panel_body,"'Begin with a sound day's work. The rest follows.'",17)
   if s.opening==0:g.button(g.panel_body,"Begin the first shift",g.accept_employment)
 if not local:g.button(g.panel_body,"Track Ivar",func():s.tracked_npc="ivar";g.save_game();g.close_panel())
