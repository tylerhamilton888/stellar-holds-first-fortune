class_name HoldOutpost
extends RefCounted
const ROLES={"miner":"Mining","smith":"Workshop","engineer":"Ship engineering","surveyor":"Survey support","rest":"Off duty"}
const CREW={
 "brann":{"name":"Brann Rivethand","gender":0,"sculpt":0,"color":3,"trait":"Patient mentor","specialty":"miner","fee":25,"wish":{"wood":6},"reason":"A proper tool rack for the bunkhouse","lines":["A good tunnel leaves room for the dwarf who comes after you.","I kept my first bent pick. Reminds me that stubbornness is not a technique.","I'll take the rough face. You learn more watching the stone than watching me.","Your own mountain, then. Remember to come out of it occasionally.","My father counted shifts. I count the people who come home from them.","I told Ivar: give {player:object} a sound ladder before you give {player:object} advice. A new miner needs a way home.","A ship is a tunnel with the mountain on the outside. That's my theory.","I'm not slow. I'm leaving us less repair work."]},
 "dagr":{"name":"Dagr Flintrivet","gender":0,"sculpt":3,"color":2,"trait":"Boisterous competitor","specialty":"miner","fee":35,"wish":{"iron":2},"reason":"A matched pair of climbing spikes","lines":["First to the seam buys the second a drink. Generosity improves my odds.","That's a fine mountain. Needs a few doors.","I once raced a freight cage down six levels. The cage cheated.","Put me on hard rock. Soft dirt doesn't appreciate a proper swing.","I like your plan. Tell it again, with a larger workshop.","If we name every tunnel after a victory, we'll run out of signboards.","I can work quietly. I simply charge extra in disappointed looks.","When we launch, I want the window seat. All of them."]},
 "osvik":{"name":"Osvik Coilward","gender":0,"sculpt":4,"color":6,"trait":"Exacting craftsman","specialty":"smith","fee":45,"wish":{"copper":2},"reason":"A calibrated gauge for the workshop","lines":["A rivet is a promise made in metal. Make it properly.","Leave the measurements on my bench. The guesses can stay outside.","I polish the underside as well. I know it's there.","We can make it faster after we make it repeatable.","That little hum? The coil is seated correctly. Listen before you tighten.","My finest work is a pump nobody has thought about in eighty years.","If the hull leaks, I shall be personally offended by every molecule.","Keep the old parts. A repair teaches more than a replacement."]},
 "tovan":{"name":"Tovan Cairnbolt","gender":0,"sculpt":1,"color":1,"trait":"Warmhearted organizer","specialty":"smith","fee":35,"wish":{"food":4},"reason":"A shared supper for the founding crew","lines":["A full shelf and an empty worry. That's a productive day.","I put the spare bolts where the bolts ought to be. Revolutionary, I know.","Who's joining us? I'll find another mug.","My ledgers have crumbs in them. The sums still work.","We should name the outpost before the freight clerks name it for us.","There's room for ambition and a decent lunch.","Shared stores mean shared responsibility. Tell me when you take the last one.","I packed provisions for the launch. And provisions for Dagr when {dagr:subject} forgets {dagr:own}."]},
 "kelvar":{"name":"Kelvar Ventwright","gender":0,"sculpt":2,"color":4,"trait":"Dry-witted engineer","specialty":"engineer","fee":55,"wish":{"parts":2},"reason":"A redundant pressure valve for the launchyard","lines":["Yes, it can fly. My next question is whether it can stop.","Redundant valves are cheaper than heroic speeches.","A rune carries a command. Copper carries the current. Both need checking.","I trust instruments. I trust two instruments more.","The engine isn't angry. It is reporting a maintenance opinion.","Small ships are honest. There is nowhere to hide a bad weld.","We build the landing gear first. Returning is part of the specification.","If someone calls it experimental, stand behind the wall."]},
 "yrsa":{"name":"Yrsa Cinderlace","gender":1,"sculpt":1,"color":5,"trait":"Curious field naturalist","specialty":"surveyor","fee":45,"wish":{"crystal":1},"reason":"A clear crystal lens for the sample cabinet","lines":["That pale seam is a sentence. We have only read its first word.","I brought specimen boxes. No, the lunch box is not a spare specimen box.","Stone has a history. Most of it is very patient.","The cave roots turn toward water. They are better surveyors than they look.","I prefer a useful question to a magnificent assumption.","If we find something alive, give me a moment before you swing.","A new world means new minerals, new maps, and entirely new ways to get mud in my boots.","I want a window beside the sample bench. For strictly scientific reasons."]}
}
const TOWN={
 "ivar":["Mark your way back while you still know which way back is.","Bring me useful stone and an honest count. We'll build on both.","A foreman who cannot remember his crew's names should find other work.","Your charter will be yours. The habits you learn here will go with it.","Keep some timber before selling the surplus. Mountains do not provide ladders.","A profitable shift ends with everyone accounted for."],
 "borin":["Coal first, then ore. A cold furnace accepts neither persuasion nor pride.","Precision forging opens the way to proper machine parts.","Your first workshop will smell of mortar and hot iron. You'll remember it.","The grain of the metal matters as much as the grain of the mountain.","Bring the broken tool back. I want to see where it failed.","A little ship still needs a very good hull."],
 "orla":["My freight contracts keep paying after your lord's commissions end.","Sell surplus, not tomorrow's supports. I can sell them back, but you'll dislike the price.","A beacon gives the haulers an address. An address gives a workshop customers.","Name your outpost clearly. I once delivered six barrels to a poetic misunderstanding.","Copper travels well. Reputation travels faster.","Keep your launch fund separate from your enthusiasm."],
 "hedrik":["The hiring bench is by the warm wall. Good hands have choices.","Ask Brann what {brann:subject} wants to build, not merely what {brann:subject} can lift.","Brann will teach. Dagr will race. Give them different ends of the tunnel.","Tovan has already counted the mugs. I think he intends to organize us.","A crew needs more than a list of orders. Sit with them sometimes.","The first toast is for founding. The second is for still liking one another."],
 "eldric":["Three samples tell a story. One sample starts an argument.","Ask Yrsa to support your surveys. {yrsa:Possessive} lens reads traces farther into the rock.","The first ship need not be grand. It must be sound.","Aether does not exempt us from engineering. It adds another chapter.","An emptied seam is still useful knowledge. Refresh your notes.","We begin with one valley because we intend to understand the next."],
 "eirik":["An independent hold strengthens all our people when it keeps its word.","A family name is an inheritance. A dynasty is work still to be done.","Your reference will record what you completed, not what you promised.","The charter grants stone. What you make of it must be earned.","Build a place your crew can be proud to return to.","When your ship rises, remember the hands that laid its keel."]
}
const QUIRKS={
 "historian":{"name":"Keeper of old stories","lines":["I write down who made things. Dates alone are poor company.","Our elders left us methods, not a prohibition on improving them."]},
 "gardener":{"name":"Lover of growing things","lines":["A little green beside the doorway would make this place feel lived in.","I keep a seed pouch in my tool roll. One day we'll find somewhere worth planting it."]},
 "stargazer":{"name":"Quietly star-struck","lines":["I've picked a star to look for when we leave. I know that isn't navigation.","Imagine coming home with stone nobody here has ever held."]},
 "tinkerer":{"name":"Incorrigible tinkerer","lines":["I made the latch quieter. Then I had to make it open again.","Before you throw that away, may I see the mechanism?"]},
 "skeptic":{"name":"Careful skeptic","lines":["Show me the reading twice. Then we'll celebrate it.","I can admire an idea and still ask where the spare fuse goes."]},
 "host":{"name":"Maker of small traditions","lines":["First meal after a new building goes up should be shared. We can make that a custom.","I'm saving the least dented mug for our next arrival."]},
 "competitive":{"name":"Friendly scorekeeper","lines":["I kept score. I also rounded your result up, because I'm gracious.","A contest improves a dull task. It does not improve a safety inspection."]}
}
const QUIRK_CHOICES={"brann":["historian","gardener","stargazer"],"dagr":["competitive","tinkerer","stargazer"],"osvik":["historian","tinkerer","skeptic"],"tovan":["gardener","historian","host"],"kelvar":["skeptic","tinkerer","historian"],"yrsa":["gardener","stargazer","historian"]}
const PROJECTS={
 "miner":[{"cost":{"iron":2},"reason":"Climbing rings for the common tool chest"},{"cost":{"wood":5},"reason":"A dry shelf for boots and spare gloves"}],
 "smith":[{"cost":{"copper":2},"reason":"A dedicated set of workshop gauges"},{"cost":{"parts":1},"reason":"A small bench vise for delicate repairs"}],
 "engineer":[{"cost":{"copper":3},"reason":"A spare relay for the ship's power circuit"},{"cost":{"water":6},"reason":"A coolant-flow test before engine trials"}],
 "surveyor":[{"cost":{"wood":4},"reason":"Divided drawers for the specimen collection"},{"cost":{"copper":2},"reason":"A balanced housing for the survey compass"}]
}
static func member(s,id:String)->Dictionary:
 if CREW.has(id):return CREW[id]
 return HoldFrontier.candidates(s).get(id,{})
static func has_member(s,id:String)->bool:
 return CREW.has(id) or HoldFrontier.candidates(s).has(id)
static func candidate_ids(s)->Array:
 return CREW.keys()+HoldFrontier.candidates(s).keys()
static func personality(s,id:String)->Dictionary:
 ensure(s)
 if not s.outpost.personalities.has(id):
  var rng=RandomNumberGenerator.new();rng.seed=absi(s.seed_value+id.hash()*31)
  var choices=QUIRK_CHOICES.get(id,QUIRKS.keys())
  s.outpost.personalities[id]={"quirk":choices[rng.randi_range(0,choices.size()-1)],"project":rng.randi_range(0,2)}
 return s.outpost.personalities[id]
static func project(s,id:String)->Dictionary:
 var index=int(personality(s,id).project)
 return {"cost":member(s,id).wish,"reason":member(s,id).reason} if index==0 else PROJECTS[member(s,id).specialty][index-1]
static func describe(s,id:String)->String:
 return member(s,id).trait+" • "+QUIRKS[personality(s,id).quirk].name
static func record(s,key:String,message:String):
 ensure(s)
 if s.outpost.events.has(key):return
 s.outpost.events[key]=true
 s.outpost.chronicle.append({"minute":int(s.elapsed/60),"text":message})
 if s.outpost.chronicle.size()>256:s.outpost.chronicle.pop_front()
static func context(s,id:String)->String:
 if not s.outpost.crew.has(id):return member(s,id).lines[0]+" Find me a proper berth and we can discuss your charter."
 if id=="kelvar" and HoldIndustry.tier(s)>=2:return "Pressure seals tested. The workshop is ready to make things that must survive the sky."
 if id=="brann" and s.outpost.get("mining_gun",false):return "That gun cuts a fine tunnel. Keep it away from coal, and keep your pick. Fast is useful; careful is profitable."
 if s.outpost.favors.get(id,false):return {
  "brann":"You remembered the small things. That's how a crew learns to trust a foreman.",
  "dagr":"My project, paid for? Now I'll have to do something impressive to keep up.",
  "osvik":"You supplied exactly what I asked for. A surprisingly rare kindness.",
  "tovan":"That's one more reason to call this place home. I'll make room for it in the ledger.",
  "kelvar":"You funded the sensible precaution. I may have chosen my employer rather well.",
  "yrsa":"Thank you. A proper place for small discoveries makes the large ones possible."}.get(id,"You remembered my tools. I will remember that when the next hard shift comes.")
 var role=s.outpost.crew[id].role
 if role=="miner" and s.count("food")==0:return "The stores are out of provisions. I'll keep my tools ready until we can resume."
 if s.ship_stage>=3:return {
  "brann":"Count everyone aboard before you close the hatch. Then we can look at the stars.",
  "dagr":"Look at her! I solemnly promise not to race the first vessel we meet. Immediately.",
  "osvik":"The hull is finished. Yes, including the underside.",
  "tovan":"Ship stores checked. Spare mugs packed. We appear to be doing this.",
  "kelvar":"Pressure holds. Cooling holds. I am running out of reasons to delay being excited.",
  "yrsa":"I left room in the sample drawers. More room than is strictly reasonable."}.get(id,"The ship is ready. I have packed my tools and left room for whatever we find.")
 if role=="engineer" and s.ship_stage>0:return "The keel is sound. Now we make sure the rest of the ship deserves it."
 if role=="smith" and not s.queue.is_empty():return "There's work on the bench. Keep the orders coming; I'll mind the finish."
 if role=="surveyor":return "I've adjusted the lens. Your next field sample should read farther into the rock."
 if s.camp_stage>=3:return "That beacon makes us an address on somebody else's map. We're a real outpost now."
 return "We've a workshop to finish and people willing to finish it. That's a good beginning."
static func ensure(s):
 if s.outpost.is_empty():s.outpost={"name":"","crew":{},"talk":{},"favors":{},"support_work":0.0,"support_fuel":0.0}
 for key in ["crew","talk","favors","personalities","events"]:
  if not s.outpost.has(key):s.outpost[key]={}
 if s.worker and not s.outpost.crew.has("brann"):s.outpost.crew.brann={"role":"miner","priority":"iron_ore","fuel":0,"grain_work":0}
 if not s.outpost.has("chronicle"):s.outpost.chronicle=[]
 s.worker=s.outpost.crew.has("brann")
static func capacity(s)->int:return [0,2,4,6][clampi(s.camp_stage,0,3)]+(1 if s.camp_stage>0 and HoldDisciplines.has(s,"crew_planning") else 0)
static func title(s)->String:
 ensure(s)
 return str(s.outpost.get("name","")) if str(s.outpost.get("name",""))!="" else HoldCampaign.claim(s.claim_id).name
static func recruit(s,id:String)->bool:
 ensure(s)
 if not has_member(s,id) or s.claim_id=="" or s.outpost.crew.has(id) or s.outpost.crew.size()>=capacity(s):return false
 if not s.pay({"food":2},member(s,id).fee):return false
 s.outpost.crew[id]={"role":member(s,id).specialty if s.camp_stage>=2 else "miner","priority":"iron_ore","fuel":0,"grain_work":0}
 s.worker=s.outpost.crew.has("brann")
 HoldDisciplines.award(s,"overseer",1,id)
 personality(s,id)
 record(s,"joined_"+id,member(s,id).name+" joined the founding crew: "+describe(s,id).to_lower()+".")
 return true
static func assign(s,id:String,role:String)->bool:
 ensure(s)
 if not s.outpost.crew.has(id) or not ROLES.has(role):return false
 if role in ["smith","engineer","surveyor"] and s.camp_stage<2:return false
 var previous=s.outpost.crew[id].role
 s.outpost.crew[id].role=role
 HoldOnboarding.fact(s,"assigned")
 if previous!=role:record(s,"assigned_"+id+"_"+role,member(s,id).name+" took responsibility for "+ROLES[role].to_lower()+".")
 return true
static func role_count(s,role:String)->int:
 ensure(s)
 if not s.agents_enabled:return 0
 var count=0
 for id in s.outpost.crew:
  if s.outpost.crew[id].role==role:count+=1
 return count
static func bonus(s,role:String)->float:
 ensure(s)
 if not s.agents_enabled:return 0
 var value=0.0
 for id in s.outpost.crew:
  if s.outpost.crew[id].role==role:value+=(.35 if member(s,id).specialty==role else .15)+(.05 if s.outpost.favors.get(id,false) else 0)+HoldClaimStories.trust(s,id)
 return minf(value,.8)
static func workshop_speed(s,dt:float)->float:
 if s.camp_stage<2 or s.queue.is_empty() or bonus(s,"smith")<=0:return 1.0
 var fuel=float(s.outpost.get("support_fuel",0))
 if fuel<=0:
  if not s.pay({"food":1}):return 1.0
  fuel=120.0
 var used=minf(dt,fuel)
 s.outpost.support_fuel=maxf(0,fuel-dt)
 return (1+bonus(s,"smith")*(used/maxf(dt,.001)))*(1.05 if HoldClaimStories.ensure(s).features.get("calibrate",false) else 1.0)
static func favor(s,id:String)->bool:
 ensure(s)
 if not s.outpost.crew.has(id) or s.outpost.favors.get(id,false):return false
 if not s.pay(project(s,id).cost):return false
 s.outpost.favors[id]=true
 record(s,"project_"+id,member(s,id).name+" completed a personal project: "+project(s,id).reason.to_lower()+".")
 return true
static func line(s,id:String,advance:bool=false)->String:
 ensure(s)
 var index=int(s.outpost.talk.get(id,0))
 if advance:
  s.outpost.talk[id]=index+1;HoldCulture.advance(s,id,index+1)
 var aside=HoldCulture.aside(s,id,index)
 if aside!="":return HoldCulture.render(s,aside)
 if has_member(s,id):
  var p=personality(s,id)
  if index%4==3:return HoldCulture.render(s,context(s,id))
  var lines=member(s,id).lines.duplicate()
  lines.append_array(QUIRKS[p.quirk].lines)
  # A seeded rotation varies each world's introductions without changing voice.
  return HoldCulture.render(s,lines[posmod(index+absi(s.seed_value+id.hash()),lines.size())])
 if HoldAnniversary.ensure(s).complete and id in ["hedrik","orla"] and index%3==2:
  return "Orla says fifty years is too soon to upgrade the kettle. I have drawn up plans anyway." if id=="hedrik" else "My husband checks the regulator before every cup. I check whether he has remembered to drink it."
 var lines=TOWN.get(id,["Every hold begins with a few people willing to build it."])
 return HoldCulture.render(s,lines[index%lines.size()])
static func next_step(s)->String:
 ensure(s)
 if s.opening==0:return "Find Ivar and introduce yourself to the people of Keldrath."
 if s.opening<4:return "Complete Ivar's commission: "+HoldCampaign.JOBS[s.opening-1].name+". Keep surplus for your charter."
 if s.claim_id=="":return "Choose a charter at the survey office. Freight contracts at Orla's provide repeatable income."
 if s.camp_stage<2:return "Build "+HoldCampaign.CAMP[s.camp_stage].name.to_lower()+" at your founding stones with hammer [4]."
 if s.outpost.crew.is_empty():return "Recruit your first dwarf at the Copper Kettle. M opens assignments."
 if not s.tech.has("metallurgy"):return "Research Precision forging, then forge machine parts for your freight beacon."
 if s.camp_stage<3:return "Commission your freight beacon. It opens the launchyard and remote recruitment."
 if s.ship_stage==0:return "Save materials for the ship's keel. An engineer must supervise construction."
 if s.ship_stage<3:return "Build the next ship stage. Clockwork industry unlocks drive assemblies."
 return "Inspect the completed ship at the launchyard and make your maiden launch."
static func build_ship(s)->bool:
 if s.claim_id=="" or s.camp_stage<3 or s.ship_stage>=3 or role_count(s,"engineer")==0:return false
 var stage=HoldIndustry.ship_stage(s,s.ship_stage)
 if not s.pay(stage.cost,stage.money):return false
 s.ship_stage+=1
 var foreman="The crew"
 for id in s.outpost.crew:
  if s.outpost.crew[id].role=="engineer":foreman=member(s,id).name;break
 record(s,"ship_"+str(s.ship_stage),foreman+" signed off ship stage "+str(s.ship_stage)+": "+stage.name.to_lower()+".")
 return true
