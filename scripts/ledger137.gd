class_name HoldLedger137
extends RefCounted
# Additive contributions; existing campaign owners remain authoritative for rewards.
const DEEDS="Stone · Flame · Hearth · Harvest · Road · Shield · Kin · Oath"
const PROJECTS={
 "forge":{"title":"The Cold Forge","deeds":"Stone · Flame","cost":{"coal":8},"reward":"Relight the communal forge · 65 crowns · smelting and crafting","hint":"Inspect the hearth at the communal forge. Process a coal load at the borrowed stonebreaker, contribute eight coal here, then return to the forge to relight it."},
 "watch":{"title":"Lights for the night watch","deeds":"Flame · Shield","cost":{"wood":6,"iron":2},"reward":"Two permanent road lamps · 40 marks","hint":"Supply finished timber and iron. The watch will light the bridge approaches."},
 "rest":{"title":"A table for the work crews","deeds":"Hearth · Kin","cost":{"wood":8,"stone":4},"reward":"A roadside table and seats · 45 marks","hint":"Supply processed timber and stone for a place to share supper."},
 "stores":{"title":"Dry stores for winter","deeds":"Harvest · Road","cost":{"wood":10,"stone":6},"reward":"Covered barrels and crates · 55 marks","hint":"Keep the town's provisions off the wet ground."}}
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 if not active(s):return {}
 if not s.surface.has("ledger137"):s.surface.ledger137={"version":1,"paid":{},"inspected":false,"gift":false}
 return s.surface.ledger137
static func complete(s,id:String)->bool:
 return s.opening>=2 if id=="forge" else HoldGreatClaim102.complete(s,id)
static func paid(s,id:String,item:String)->int:
 return int(data(s).get("paid",{}).get(id,{}).get(item,0))
static func remaining(s,id:String)->Dictionary:
 var cost={}
 if not PROJECTS.has(id) or complete(s,id):return cost
 for item in PROJECTS[id].cost:
  var n=maxi(0,int(PROJECTS[id].cost[item])-paid(s,id,item))
  if n>0:cost[item]=n
 return cost
static func unlocked(s,id:String)->bool:
 return active(s) and PROJECTS.has(id) and HoldFirstVisit99.data(s).get("rewarded",false)
static func contribute(g,id:String,item:String,amount:int)->bool:
 if not active(g.state) or not HoldGreatClaim102.near(g) or not unlocked(g.state,id) or complete(g.state,id) or amount<=0:return false
 if not PROJECTS[id].cost.has(item) or amount>int(remaining(g.state,id).get(item,0)):return false
 if not g.state.pay({item:amount}):return false
 var d=data(g.state)
 if not d.paid.has(id):d.paid[id]={}
 d.paid[id][item]=paid(g.state,id,item)+amount
 g.save_game();g.sound.effect("pickup",-18);return true
static func inspect(g)->bool:
 if not active(g.state) or not HoldFrontier103.near(g,"forge") or complete(g.state,"forge") or data(g.state).inspected:return false
 data(g.state).inspected=true;g.save_game()
 g.notify("The hearth is sound but cold. Process coal at the loan benches; eight coal will feed its first firing.");return true
static func ready(s,id:String)->bool:
 if not unlocked(s,id) or complete(s,id) or not remaining(s,id).is_empty():return false
 return id!="forge" or (data(s).inspected and HoldWork132.proof(s,"cut:coal")>=1)
static func finish(g,id:String)->bool:
 if not ready(g.state,id):return false
 if id=="forge":
  if not HoldFrontier103.near(g,"forge") or not g.state.finish_commission():return false
  g.sound.set_context("forge");g.notify("Borin kindles the first firing. The communal forge is open · 65 crowns earned.")
 else:
  if not HoldGreatClaim102.contribute(g,id):return false
 g.save_game();g.sound.effect("quest",-16);return true
static func phase(s)->int:
 if HoldMountain104.data(s).get("authenticated",false):return 4
 if int(HoldAncestralClaim.data(s).stage)>=3:return 3
 if HoldFrontier103.data(s).get("home_reward",false):return 2
 return 1 if HoldWork132.contributions(s)>=1 else 0
static func skarrin(s)->String:
 var lines=["A new pair of hands! Welcome to Stonebridge. The west rack is yours to use. Come to me if you need timber for that room; everyone needs a start.","A neat little contribution. I knew you would find your feet with the right example. Keep working beside us and you will do well.","They made quite a fuss over your house. A roof matters, certainly. So do the drainage cuts keeping every roof here above water.","Now every supper is a toast to your courage. My crews have kept this place standing for years. Apparently that is less interesting.","So an old seal weighs as much as living hands. You can see why some of us question whose fairness this contest serves."]
 var line=lines[phase(s)]
 if data(s).get("gift",false) and phase(s)>=1:line+=" Remember who put timber in your hands before anybody knew your name."
 return line
static func gift(g)->bool:
 if not active(g.state) or not HoldConversation.local(g,"road_folk:8") or phase(g.state)>0 or data(g.state).gift:return false
 data(g.state).gift=true;g.state.add("wood",4);g.save_game();return true
static func skarrin_options(g):
 if g.talk_id!="road_folk:8" or not active(g.state):return
 if phase(g.state)==0 and not data(g.state).gift:
  HoldConversation.choose(g,"Accept his offer of four timber for your room",func():
   if gift(g):g.talk_line="There you are. A chair, perhaps, or a proper shelf. We look after our own here."
   g.refresh_panel())
static func forge_panel(g):
 if not active(g.state) or complete(g.state,"forge"):return
 HoldMenuView.illustrated_text(g.panel_body,"coal","The Cold Forge","Inspect → process coal → contribute at the Hold’s Ledger → return for the first firing.")
 var b=g.button(g.panel_body,"Inspect the cold hearth",func():inspect(g);g.refresh_panel());b.disabled=data(g.state).inspected or not HoldFrontier103.near(g,"forge")
 g.label(g.panel_body,"Coal delivered: %d / 8 · Coal processing: %s" % [paid(g.state,"forge","coal"),"learned" if HoldWork132.proof(g.state,"cut:coal")>=1 else "process one load at the stonebreaker"],15)
 b=g.button(g.panel_body,"Relight the communal forge",func():finish(g,"forge");g.refresh_panel());b.disabled=not ready(g.state,"forge") or not HoldFrontier103.near(g,"forge")
 g.button(g.panel_body,"Review the Hold’s Ledger",func():g.open_panel("great_claim102"))
static func panel(g):
 var s=g.state
 HoldMenuView.illustrated_text(g.panel_body,"dressed_stone","THE HOLD’S LEDGER","Build a place in Stonebridge. Contributions stay recorded; there are no deadlines. M reviews this ledger anywhere. Deliver carried supplies at the bunkhouse ledger.")
 g.label(g.panel_body,DEEDS,13)
 var home=HoldMenuView.disclosure(g,g.panel_body,"Personal ambition · A place of your own","ledger137_home")
 if home!=null:
  for entry in [[HoldFirstVisit99.data(s).get("rewarded",false),"Learn the first shift and earn your wages"],[HoldFirstVisit99.data(s).get("home_made",false),"Furnish your upstairs room · O opens plans"],[HoldFrontier103.data(s).permit,"Complete two civic projects or trade seals; collect your plot at Ivar’s shift book"],[HoldFrontier103.data(s).home_reward,"Build a home on the eastern rise, with bed and light; register it with Ivar · 60 marks"]]:
   g.label(home,("✓ " if entry[0] else "○ ")+entry[1],15)
  g.button(home,"Town services and household plot",func():g.open_panel("frontier103"))
 for id in PROJECTS:
  var p=PROJECTS[id];var done=complete(s,id)
  var status="Complete" if done else "Locked · finish your first shift" if not unlocked(s,id) else "In progress" if not data(s).paid.get(id,{}).is_empty() else "Available"
  var box=HoldMenuView.section(g.panel_body,p.title+" · "+status)
  g.label(box,p.deeds+" — "+p.reward,14,Color("a7dfcb"));g.label(box,p.hint,15)
  if done:continue
  for item in p.cost:
   var row=g.row(box);HoldItemArt.icon(row,item)
   g.label(row,"%s · %d / %d" % [HoldData.ITEMS[item].name,paid(s,id,item),p.cost[item]],15)
   var amount=mini(s.count(item),int(remaining(s,id).get(item,0)))
   var b=g.small_button(row,"Contribute %d" % amount,func():contribute(g,id,item,amount);g.refresh_panel())
   b.disabled=amount<=0 or not unlocked(s,id) or not HoldGreatClaim102.near(g)
  if id!="forge":
   var b=g.button(box,"Complete project",func():finish(g,id);g.refresh_panel());b.disabled=not ready(s,id) or not HoldGreatClaim102.near(g)
  else:g.label(box,"First firing takes place at the communal forge after inspection, coal processing and delivery.",14)
 g.button(g.panel_body,"Optional work lessons and trade collections",func():HoldWorkView132.open(g,"contribute"))
 var recognition=HoldMenuView.disclosure(g,g.panel_body,"Contest recognition and story","ledger137_recognition")
 if recognition!=null:
  for entry in HoldGreatClaim102.standings(s):g.label(recognition,"%s · %d marks — %s" % [entry[0],entry[1],entry[2]],14)
  g.label(recognition,"A registered home and 180 contribution marks open Ivar’s rescue lead. Your home, belongings and relationships remain yours throughout the contest.",14)
 HoldClaim127.panel(g)
