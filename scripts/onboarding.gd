class_name HoldOnboarding
extends RefCounted

static func ensure(s)->Dictionary:
 HoldOutpost.ensure(s)
 if not s.outpost.has("onboarding"):
  s.outpost.onboarding={"fresh":false,"stage":7,"arrival_seen":true,"combat":true,"met":{},"facts":{},"accepted":{},"done":{}}
 return s.outpost.onboarding
static func begin_fortune(s):
 var q=ensure(s);q.fresh=true;q.stage=0;q.arrival_seen=false;q.combat=false
static func stage(s)->int:return int(ensure(s).stage)
static func side_stories(s)->bool:return s.opening>=2 and (not ensure(s).fresh or stage(s)>=6)
static func combat_ready(s)->bool:return bool(ensure(s).combat)
static func fact(s,id:String,amount:int=1):
 var q=ensure(s);q.facts[id]=int(q.facts.get(id,0))+amount
static func arrived(s):
 var q=ensure(s)
 if q.stage==0:q.stage=1
 q.arrival_seen=true;s.tracked_npc="ivar"
static func audience(s)->bool:
 var q=ensure(s)
 if q.stage!=4:return false
 q.stage=5;s.tracked_npc="ivar"
 HoldOutpost.record(s,"first_audience",s.appearance.name+" stood before Lord Eirik with a working dwarf's reference. A mountain charter became a possibility.")
 return true
static func commission_allowed(s)->bool:
 var q=ensure(s)
 return not q.fresh or (q.stage==3 and s.opening==1) or q.stage>=6
static func after_commission(s):
 var q=ensure(s)
 if not q.fresh:return
 if s.opening==2:q.stage=4;s.tracked_npc="eirik"
 elif s.opening>=4:q.stage=7
static func local(g,id:String)->bool:
 if g.state.active_site!="hold" or g.zone!="hub":return false
 return HoldNpcPresence.inside(g.state,id,g.room_id)
static func introduce(s,id:String)->bool:
 var q=ensure(s)
 if q.stage!=2 or id not in ["borin","orla","hedrik"] or q.met.has(id):return false
 q.met[id]=true
 if id=="borin":s.add("wood",4)
 if id=="hedrik":s.add("food",2)
 if q.met.size()==3:q.stage=3;s.opening=1;s.tracked_npc="ivar"
 else:
  for next in ["borin","orla","hedrik"]:
   if not q.met.has(next):s.tracked_npc=next;break
 return true
static func primary(s)->String:
 var q=ensure(s)
 if not q.fresh or q.stage>=7:return ""
 if q.stage==6 and s.opening<4:return "IVAR: "+HoldCampaign.JOBS[s.opening-1].name+" | J: requirements and lessons"
 return {0:"ARRIVAL: Your first morning in Keldrath.",1:"FIRST MORNING: Introduce yourself to Ivar. Follow the marker. J: journal",2:"FACES OF THE HOLD: Meet Borin, Orla and Hedrik. J: journal",3:"FIRST SHIFT: Bring 8 coal to Ivar. King’s Gate → High Trail → Old Workings. J: journal",4:"A ROYAL SUMMONS: King's hall, Crownward. Take the Royal stairs from Hearthward.",5:"USEFUL HANDS: Return to Ivar for your next commission.",6:"REPAIR THE HOLD: Ivar has paid work. J also lists lessons and local stories."}.get(int(q.stage),"")
static func intro_text(s,id:String)->String:
 if id=="borin":return "Borin weighs your pick in his palm. 'A sound edge. Keep the head close to the stone and let it bite. Here, four lengths of timber. V opens building plans. Carve stairs or fit a timber ladder to the next depth. E takes you down; Shift+E brings you back. Try both directions before you call the route safe.'"
 if id=="orla":return "Orla unfolds a route map. 'Once you have met all three of us, leave by the King’s Gate on Hearthward. Walk the High Trail with WASD or arrows; E enters doors and trail crossings. G lists directions. Old Workings for coal, Pinewood for timber, Keldrath to come home. Keep what Ivar hasn't commissioned. Sell the surplus when you know what you can spare.'"
 var map_line="My wife Orla will have shown you the map." if ensure(s).met.has("orla") else "My wife Orla keeps the route map at her exchange. Go and introduce yourself."
 return "Hedrik slides two wrapped meals across the counter. '" + map_line + " I attend to the more pressing business of lunch. Come back with all your fingers. I'll have something warm.'"

const LESSONS={
 "charter":{"name":"Ground to call your own","host":"eirik","goal":"Purchase one mountain charter after completing Ivar's three commissions.","text":"A charter names the ground you may work. Survey the three ridges with Eldric before buying. Old Delving has an inherited foundation; the other mountains offer different seams and obligations. Choose once, and build well.","female":"Your household will remember the woman who chose its first mountain. Choose for those who will live there.","male":"A founder's name belongs on more than a gate. Let it stand for a well-kept hold.","reward":{"food":4,"water":4},"money":20},
 "crew":{"name":"Another mug at the table","host":"hedrik","goal":"Hire your first crewmate at the Copper Kettle, then assign a job in M.","text":"A charter is lonely work for one pair of hands. Meet the folk at my hiring bench. Read their strengths, pay their fee, and assign a role through your outpost ledger. Miners work reachable ground and need provisions. Keep food in the stores.","female":"Orla says to ask what a dwarf wants to build, not merely how much he can carry. She is usually right.","male":"Give a brother fair work and a place at supper. You will learn the rest about him soon enough.","reward":{"food":8},"money":0},
 "workshop":{"name":"A forge under your own roof","host":"borin","goal":"Raise the workshop at your claim's founding stones. M lists the materials.","text":"First lay the foundation. Then raise a workshop. Your own benches give your crew somewhere to turn ore into useful things. Keldrath's forge stays open while you build, so there is no need to haul an unfinished furnace up a mountain.","female":"Build the roof soundly, sister. I refuse to inspect a forge while standing in rain.","male":"A good roof first, brother. Fire is particular about where it lives.","reward":{"parts":2},"money":15},
 "industry":{"name":"Put the mountain to work","host":"eldric","goal":"Research Clockwork industry and install a Powered workshop at the hold or your claim.","text":"Precision forging leads to Clockwork industry. The research unlocks machinery, but a powered installation needs its own materials. Visit the local forge's Industry bench to build it. Its drive raises production by half; a second installation does not multiply that bonus again.","female":"Keep the plans, sister. The next generation should know how their mother built it.","male":"Keep the plans, brother. Your descendants deserve more than a machine and a shrug.","reward":{"parts":3},"money":15},
 "slagcaster":{"name":"A furnace you can carry","host":"borin","goal":"Fabricate a runic mining gun after researching Runic thermal extraction.","text":"The slagcaster needs a powered workshop and the thermal method. It spends crafted energy cells, melts metal into slag, and ruins coal and roots. Use it for speed. Keep your pick for careful work, and quench the slag at a forge.","female":"A fine tool for a woman with a great deal of mountain to move. Mind the muzzle.","male":"A fine tool, brother. It does not excuse pointing it at the supports.","reward":{"energy_cell":3},"money":0},
 "keel":{"name":"The first piece of the sky","host":"eldric","goal":"Recruit an engineer, finish your camp, and lay the First Fortune's keel at your launchyard.","text":"A vessel begins on the ground. Your camp needs its freight beacon and an assigned engineer before shipwork can proceed. M shows the crew and the yard requirements. Lay a sound keel. Pressure engineering and sealed workshops come after that first proof.","female":"Let them remember the woman who set this keel. Make the calculations worth remembering too.","male":"You may name the ship after yourself, brother. I recommend waiting until it floats.","reward":{"iron":3,"copper":2},"money":20},
 "timber":{"name":"Timber has roots","host":"orla","goal":"Cut 6 timber in Pinewood with your axe [3].","text":"Those lift braces do not grow in the storeroom. Follow the High Trail south to Pinewood, choose a marked fir, and cut six good lengths. Leave room in your pack for whatever else you find.","female":"Sister, I'll mark the sound trees. A straight beam saves a great deal of arguing later.","male":"Brother, bring straight timber. A crooked beam does not improve with confidence.","reward":{"wood":4},"money":15},
 "route":{"name":"Leave yourself a way home","host":"ivar","goal":"Build a Z-level stair or ladder [V], descend [E], then return [Shift+E].","text":"A rich seam is no use if you cannot climb out with it. Build a stair or timber ladder on clear floor. It joins the same location on the next depth. Descend with E and climb back with Shift+E to prove the route. Stairs carry carts and machines; ladders carry Dwarfs and buckets.","female":"Your place on my shift is earned by sound work. That includes getting home under your own power.","male":"I expect my brothers to come home with their tools. Heroic holes in the ground impress nobody here.","reward":{"wood":4},"money":15},
 "smelt":{"name":"The grain remembers","host":"borin","goal":"Smelt 4 iron ingots at the forge. Two ore and one coal make each ingot.","text":"Stone hides the metal. Fire lets it out. Queue four iron ingots on my Smelting bench. The jobs keep running while you work elsewhere. Save the ingots for our conduits and your next tools.","female":"My mother taught me to judge a pour by its surface. She would make you look twice.","male":"No, brother, a brighter furnace is not always a better furnace. Watch the metal.","reward":{"iron":2},"money":15},
 "sample":{"name":"Read the mountain","host":"eldric","goal":"Survey the layer below while underground [X].","text":"Press X underground to preview the next layer. Read the connected veins before choosing a shaft location; E and Shift+E use actual passages. Follow mineral bands and watch for caverns. Surveying does not excavate the lower rock or spend resources.","female":"Yrsa will be pleased to have another woman bringing back notes as well as ore.","male":"Bring me the sample before your brothers have tested it with three different hammers.","reward":{"copper":2},"money":15},
 "research":{"name":"A better bite","host":"eldric","goal":"Research Tempered steel at the survey office.","text":"Hard basalt needs a better edge. Tempered steel costs four iron, three timber and thirty-five crowns. Research unlocks the method; Borin still has to forge the tool. Bring me the completed method and I will supply the pick's materials.","female":"Good notes outlast a strong swing. Keep yours where the rain cannot find them.","male":"Your shoulders are not a substitute for metallurgy, brother.","reward":{"iron":5,"wood":2},"money":0},
 "pick":{"name":"Through black stone","host":"borin","goal":"Forge the steel pick under Forge > Tools after researching Tempered steel.","text":"Eldric supplied the method. I supply the heat. Five iron and two timber will make the pick. It cuts ordinary stone faster and opens basalt. Keep a shovel beside it; there is no prize for making dirt difficult.","female":"An edge worthy of your work, sister. Bring it back for sharpening.","male":"A fine tool, brother. Try to make it old before you make it famous.","reward":{"food":2},"money":20},
 "freight":{"name":"A name on the manifest","host":"orla","goal":"Deliver one freight contract through Orla's Contracts tab.","text":"Wages buy your supper. Reliable deliveries buy a reputation. My first contract needs twenty stone and six timber. The next takes ore. These jobs repeat, so there is always paid work between larger plans.","female":"A woman with her own freight account will give the clerks something useful to discuss.","male":"Let the haulers learn your name from a sound shipment, brother.","reward":{"wood":3},"money":15},
 "training":{"name":"Keep your feet","host":"borin","goal":"In the practice bay: land 3 blows, block or parry 1 padded strike, dodge once.","text":"The lower caves have teeth. Before you meet them, borrow the holdguard axe and shield. F draws them, left mouse attacks, right mouse guards, and Q dodges. Press guard just before contact to parry. No stamina to count. We use a padded clockwork striker; it cannot injure you. After training, B opens weapons and armor. Forge mail here when you can spare five iron and two timber.","female":"Some will stare at a woman carrying a shield. Let them stare at your footwork instead.","male":"Keep your feet, brother. A grand beard will not stop a padded hammer.","reward":{"food":3},"money":20},
 "salvage":{"name":"What the deep gives back","host":"ivar","goal":"Clear one hostile encounter in the deeper workings, then return to Ivar.","text":"A goblin scrap camp or a shellback nest can close a passage. Take your shield, choose your ground and clear one. The salvage belongs to you. Borin can recover iron from scrap and shell. These encounters stay cleared; I am not paying you to fight the same nuisance every morning.","female":"You have the same right to that passage and the same duty to your crew. Come back safe.","male":"Take the passage carefully, brother. Bravery includes knowing where the exit is.","reward":{"iron":2},"money":30}
}
static func unlocked(s,id:String)->bool:
 var q=ensure(s)
 if not LESSONS.has(id) or not side_stories(s):return false
 if id=="charter":return s.opening>=4
 if id in ["crew","workshop"]:return s.claim_id!=""
 if id in ["industry","keel"]:return s.camp_stage>=2
 if id=="slagcaster":return HoldIndustry.tier(s,"hold")>0 or HoldIndustry.tier(s,"claim")>0
 if id=="training":return s.opening>=3 and q.done.get("route",false)
 if id=="salvage":return q.done.get("training",false)
 if id=="pick":return s.tech.has("extraction")
 return true
static func progress(s,id:String)->Dictionary:
 var f=ensure(s).facts;var amount=0;var need=1
 match id:
  "charter":amount=1 if s.claim_id!="" else 0
  "crew":amount=1 if not s.outpost.get("crew",{}).is_empty() and int(f.get("assigned",0))>0 else 0
  "workshop":amount=1 if s.camp_stage>=2 else 0
  "industry":amount=1 if HoldIndustry.tier(s,"hold")>0 or HoldIndustry.tier(s,"claim")>0 else 0
  "slagcaster":amount=1 if s.outpost.get("mining_gun",false) else 0
  "keel":amount=1 if s.ship_stage>=1 else 0
  "timber":amount=int(f.get("woodcut",0));need=6
  "route":amount=maxi(int(f.get("built",0)),int(f.get("route_tested",0)))
  "smelt":amount=int(f.get("smelt",0));need=4
  "sample":amount=int(f.get("sample",0))
  "research":amount=1 if s.tech.has("extraction") else 0
  "pick":amount=1 if s.steel else 0
  "freight":amount=s.contract
  "training":amount=mini(3,int(f.get("practice_hit",0)))+mini(1,int(f.get("practice_guard",0)))+mini(1,int(f.get("practice_dodge",0)));need=5
  "salvage":amount=s.combat.cleared.size()
 return {"amount":mini(amount,need),"need":need,"ready":amount>=need}
static func accept(s,id:String)->bool:
 var q=ensure(s)
 if not unlocked(s,id) or q.accepted.has(id) or q.done.has(id):return false
 q.accepted[id]=true
 return true
static func complete(s,id:String,is_local:bool)->bool:
 var q=ensure(s)
 if not is_local or not q.accepted.has(id) or q.done.has(id) or not progress(s,id).ready:return false
 q.done[id]=true;s.money+=int(LESSONS[id].money)
 for item in LESSONS[id].reward:s.add(item,LESSONS[id].reward[item])
 if id=="training":q.combat=true
 HoldOutpost.record(s,"lesson_"+id,s.appearance.name+" completed "+LESSONS[id].name.to_lower()+" with "+s.npc(LESSONS[id].host).first_name+".")
 return true
static func status(s,host:String)->String:
 var q=ensure(s)
 if q.fresh:
  if host=="ivar" and q.stage in [1,5]:return "offer"
  if q.stage==2 and host in ["borin","orla","hedrik"] and not q.met.has(host):return "offer"
  if q.stage==4 and host=="eirik":return "ready"
 var found=""
 for id in LESSONS:
  if LESSONS[id].host!=host or not unlocked(s,id) or q.done.has(id):continue
  if q.accepted.has(id) and progress(s,id).ready:return "ready"
  if not q.accepted.has(id):found="offer"
  elif found=="":found="active"
 return found
static func npc_menu(g,parent:Node,id:String):
 var s=g.state;var q=ensure(s)
 if q.fresh and q.stage==2 and id in ["borin","orla","hedrik"] and not q.met.has(id):
  g.label(parent,intro_text(s,id),16)
  var b=g.button(parent,"Introduce yourself to "+s.npc(id).first_name,func():
   if introduce(s,id):g.save_game();g.refresh_panel();g.notify("Introductions complete. The King’s Gate is open. Follow the High Trail to Old Workings." if q.stage==3 else "A familiar face for your first shift."))
  b.disabled=not local(g,id)
 for key in LESSONS:
  if LESSONS[key].host==id and unlocked(s,key) and not q.done.has(key):
   g.small_button(parent,"Work: "+LESSONS[key].name,func():g.lesson_id=key;g.open_panel("lesson"))
static func journal(g):
 if g.state.claim_id!="":
  g.surface.house.lesson()
  g.label(g.panel_body,"Return to your claim and press O → Build a house. Materials come from your carried pack; withdraw stored supplies first.",14)
  if g.surface.area=="claim" and g.surface.active():g.small_button(g.panel_body,"Open house building plans",func():g.open_panel("house_build"))
 if g.zone=="mine":
  g.label(g.panel_body,"BRANN’S STONEWORK · Turn a sound block into a lasting floor.",17)
  g.button(g.panel_body,"Masonry lesson · quarry → stockpile → bench → build",func():g.deep.works.page="Masonry";g.open_panel("living"))
 var s=g.state;var q=ensure(s)
 if primary(s)!="":g.label(g.panel_body,primary(s),17)
 if q.stage==2:
  for id in ["borin","orla","hedrik"]:
   g.button(g.panel_body,("Met " if q.met.has(id) else "Find ")+s.npc(id).name,func():s.tracked_npc=id;g.save_game();g.close_panel())
 if q.fresh and q.stage==3:
  g.label(g.panel_body,"FIRST TRIP: Step outside. Walk to the King’s Gate on eastern Hearthward and press E. Follow the High Trail northeast to Old Workings and press E at the entrance. WASD or arrows move; G lists directions. Old Delving is a separate claim that needs a charter.",16)
  g.label(g.panel_body,"At the mine, 1 equips your pick. Hold left mouse on nearby coal to mine it. V builds stairs or ladder shafts. E descends, Shift+E returns through the same passage. Carry 8 coal back through the mine mouth, then walk the High Trail back to Keldrath (G lists directions). Enter with E and return to Ivar.",16)
 elif q.fresh and q.stage==4:
  g.label(g.panel_body,"Your first wage is paid. Take the Royal stairs in central Hearthward to Crownward and enter the King's hall. Speak to Lord Eirik before taking the lift commission.",16)
 elif q.fresh and q.stage==5:
  g.label(g.panel_body,"Leave the throne room by its southern doorway, return to Ivar's desk and accept the lift commission. This opens the first-season lessons and local stories.",16)
 if side_stories(s):
  HoldAnniversary.journal(g)
  for id in LESSONS:
   if not unlocked(s,id):continue
   var p=progress(s,id)
   var status="Complete" if q.done.has(id) else "Ready to return" if q.accepted.has(id) and p.ready else "%d/%d" % [p.amount,p.need] if q.accepted.has(id) else "Available"
   g.button(g.panel_body,LESSONS[id].name+"  |  "+status+"  |  "+s.npc(LESSONS[id].host).first_name,func():g.lesson_id=id;g.open_panel("lesson"))
 else:g.label(g.panel_body,"More work opens as Ivar comes to trust you. You can explore, trade and build at your own pace.",16)
static func lesson_panel(g):
 var s=g.state;var id=g.lesson_id
 if not LESSONS.has(id) or not unlocked(s,id):g.label(g.panel_body,"This lesson opens later in your first season.");return
 var q=ensure(s);var task=LESSONS[id];var host=task.host
 var nearby=local(g,host)
 var speech=task.text
 if id in ["timber","research","training","charter","crew","industry"]:speech+=" "+(task.female if int(s.appearance.gender)==1 else task.male)
 if nearby:HoldConversation.header(g,g.panel_body,host,speech,true)
 else:g.label(g.panel_body,"QUEST JOURNAL · "+s.npc(host).name,17,Color("b6d8c9"))
 g.label(g.panel_body,task.name,22,Color("edc98a"))
 g.label(g.panel_body,task.goal,17,Color("edc98a"))
 var p=progress(s,id)
 g.label(g.panel_body,"Progress: %d / %d. Reward: %d crowns, %s." % [p.amount,p.need,task.money,HoldData.cost_text(task.reward)],15)
 if q.done.has(id):
  g.label(g.panel_body,"Finished. The tools and knowledge are yours to use.",16);HoldConversation.return_choice(g,host);return
 HoldConversation.responses(g)
 if not q.accepted.has(id):
  var b=HoldConversation.choose(g,"Take the work",func():
   if local(g,host) and accept(s,id):g.save_game();g.refresh_panel(),true)
  b.disabled=not local(g,host)
  if b.disabled:g.label(g.panel_body,"Speak to "+s.npc(host).first_name+" in person to begin.",15)
 else:
  if id=="training":
   g.label(g.panel_body,"Blows %d/3 | Guard %d/1 | Dodge %d/1. The practice bay is harmless." % [mini(3,int(q.facts.get("practice_hit",0))),mini(1,int(q.facts.get("practice_guard",0))),mini(1,int(q.facts.get("practice_dodge",0)))],15)
   var b=HoldConversation.choose(g,"Resume practice" if g.room_id=="training" else "Enter Borin's practice bay",func():
    if g.room_id=="training":g.close_panel()
    else:g.enter_room("training"))
   b.disabled=not local(g,"borin") and g.room_id!="training"
  var b=HoldConversation.choose(g,"Report back to "+s.npc(host).first_name,func():
   if complete(s,id,local(g,host)):g.save_game();g.sound.effect("quest",-10);g.notify("Work completed: "+task.name);g.refresh_panel(),true)
  b.disabled=not p.ready or not local(g,host)
 if not nearby:HoldConversation.choose(g,"Track "+s.npc(host).first_name,func():s.tracked_npc=host;g.save_game();g.close_panel())
 var destination={"charter":"charters","crew":"manage","workshop":"manage","industry":"forge","slagcaster":"forge","keel":"ship","timber":"wayfinding","route":"construction","smelt":"forge","sample":"field_notes","research":"research","pick":"forge","freight":"market","salvage":"equipment"}.get(id,"")
 if destination!="":HoldConversation.choose(g,"Review "+{"manage":"outpost","forge":"forge services","wayfinding":"trail directions","construction":"building plans","field_notes":"field notebook","equipment":"equipment"}.get(destination,destination.replace("_"," ")),func():
  if id=="pick":g.forge_tab=2
  if id in ["industry","slagcaster"]:g.forge_tab=3
  if id=="crew":g.outpost_tab=2
  if id=="freight":g.trade_tab="contracts"
  g.open_panel(destination))

 HoldConversation.return_choice(g,host)
