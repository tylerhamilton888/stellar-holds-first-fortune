class_name HoldLedger137
extends RefCounted
# Additive contributions; existing campaign owners remain authoritative for rewards.
const DEEDS="Stone · Flame · Hearth · Harvest · Road · Shield · Kin · Oath"
const PROJECTS={
 "north_bridge":{"title":"The North Crossing","deeds":"Stone · Road · Kin · Oath","cost":{"dressed_stone":12,"wood":24,"iron":4},"reward":"Permanent northern river crossing · 100 marks before the contest closes","hint":"After the rescue and Winter Stores, inspect the west abutment north of the old bridge. Supply the structure and three specialist bridge shifts, then fit the span and gather the crew."},
 "storehouse":{"title":"Winter Stores · the building","deeds":"Stone · Flame · Road","cost":{"stone":30,"wood":24,"iron":2},"reward":"Permanent community storehouse · 70 marks","hint":"Inspect the eastern site south of the bridge. Supply the shell here; learn smelting, timber processing and loaded-cart hauling, then return to raise it."},
 "winter":{"title":"Winter Stores · the provisions","deeds":"Harvest · Hearth · Kin","cost":{"food":12},"reward":"Stocked storehouse and community trading counter","hint":"After raising the storehouse, contribute twelve provisions. Learn fishing OR farming and cook a meal, then return to the site to open the stores."},
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
 if id=="north_bridge":return HoldRestoration139.complete(s)
 if id=="winter":return bool(HoldCampaign138.data(s).get("winter_ready",false))
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
 if id=="north_bridge":return HoldRestoration139.unlocked(s) and HoldRestoration139.data(s).inspected
 return active(s) and PROJECTS.has(id) and HoldFirstVisit99.data(s).get("rewarded",false) and (id!="winter" or HoldFrontier103.data(s).get("storehouse",false))
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
 g.notify("The hearth is sound. Borin needs coal for the first firing · J: next step.");return true
static func ready(s,id:String)->bool:
 if not unlocked(s,id) or complete(s,id) or not remaining(s,id).is_empty():return false
 if id=="north_bridge":return HoldRestoration139.ready(s)
 if id=="storehouse":return HoldCampaign138.structure_ready(s)
 if id=="winter":return HoldCampaign138.learned(s,"kit") and HoldCampaign138.learned(s,"harvest") and HoldCampaign138.learned(s,"cook")
 return id!="forge" or (data(s).inspected and HoldWork132.proof(s,"cut:coal")>=1)
static func finish(g,id:String)->bool:
 if not ready(g.state,id):return false
 if id=="north_bridge":return HoldRestoration139.assemble(g)
 if id=="storehouse":return HoldCampaign138.assemble(g)
 if id=="winter":return HoldCampaign138.stock(g)
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
 var lines=["A new face! Skarrin. Welcome to Stonebridge. I've some spare timber if that room of yours needs a chair.","I saw your name in the ledger. Not bad for a first entry. My crew brought in a load this morning too; the ink was barely dry when Ivar found more work for us.","I hear the house is finished. Good. You'll want a drainage trench before the spring thaw; ask my crew how they learned that one.","They're still talking about the rescue at supper. Quite right, too. My crew had the supports ready by dawn; I don't suppose anyone mentioned that part.","Ivar showed me the seal. If it proves what they say, the old families may yet have their say in all this. I wonder what the crews will make of it."]
 var line=lines[phase(s)]
 if HoldRestoration139.complete(s) and phase(s)<4:line="An excellent crossing. I am pleased my old abutments could give your achievement somewhere to stand. Ivar seems determined to read your name at every gathering."
 if data(s).get("gift",false) and phase(s)>=1:line+=" How did that timber work out, by the way?"
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
static func forge_lead(s)->Dictionary:
 if complete(s,"forge"):return {"title":"The forge is alight","art":"coal","hint":"Borin's hearth is working again. Smelting and crafting are available at the communal forge.","goal":"The forge is alight · visit Borin for smelting and crafting"}
 if not data(s).inspected:return {"title":"A hearth gone cold","art":"coal","hint":"Borin's forge stands north of the town square. Visit the communal forge and inspect the cold hearth before gathering its fuel.","goal":"Visit the communal forge · inspect the cold hearth · J"}
 if not HoldFirstVisit99.data(s).get("rewarded",false):return {"title":"A first shift to finish","art":"stone","hint":"Ivar has a place for you at the western rack and stonebreaker in Old Workings. Finish your first shift before contributing to the forge.","goal":"Finish your first shift at Old Workings · J"}
 if HoldWork132.proof(s,"cut:coal")<1:return {"title":"Coal for Borin","art":"coal","hint":"At Old Workings, mine a coal seam and carry a freed load to the western rack. Hold E at the borrowed stonebreaker to process it. Coal already delivered stays recorded; you still need to learn this step yourself.","goal":"Old Workings · process a coal load at the western stonebreaker · J"}
 var need=int(remaining(s,"forge").get("coal",0))
 if need>0:
  if s.count("coal")<need:return {"title":"Fuel for the first firing","art":"coal","hint":"The Ledger still needs %d coal; you carry %d. Process more coal at the borrowed stonebreaker in Old Workings. You can deliver what you have now and bring the rest later." % [need,s.count("coal")],"goal":"Coal for the forge · %d still needed, %d in your pack · J" % [need,s.count("coal")]}
  return {"title":"An entry in the Ledger","art":"coal","hint":"You have the remaining %d coal. Take it to the great open book between the braziers, east of the bunkhouse. Press E and contribute to The Cold Forge. M lets you review the page, but supplies must be delivered at the book or indoor records desk." % need,"goal":"Bring %d coal to the great Ledger east of the bunkhouse · J" % need}
 return {"title":"The first firing","art":"coal","hint":"The coal is recorded and the hearth is ready. Return to the communal forge and relight it. Borin will pay 65 crowns, and the forge will open for smelting and crafting.","goal":"Return to the communal forge · relight the hearth · J"}
static func forge_panel(g):
 if not active(g.state) or complete(g.state,"forge"):return
 var lead=forge_lead(g.state)
 HoldMenuView.illustrated_text(g.panel_body,"coal","The Cold Forge","Borin brushes the ash from the hearth. 'Sound stonework. It only wants a good fire in it.'" if not data(g.state).inspected else "Borin has set the bellows in order. The hearth is ready for its first fire.")
 g.label(g.panel_body,lead.title,18,Color("edc98a"));g.label(g.panel_body,lead.hint,16)
 var b=g.button(g.panel_body,"Inspect the cold hearth",func():inspect(g);g.refresh_panel());b.disabled=data(g.state).inspected or not HoldFrontier103.near(g,"forge")
 g.label(g.panel_body,"Coal delivered: %d / 8 · Coal processing: %s" % [paid(g.state,"forge","coal"),"learned" if HoldWork132.proof(g.state,"cut:coal")>=1 else "process one load at the stonebreaker"],15)
 g.label(g.panel_body,"First firing: 65 crowns · opens smelting and crafting. Partial deliveries are kept.",14,Color("a7dfcb"))
 b=g.button(g.panel_body,"Relight the communal forge",func():finish(g,"forge");g.refresh_panel());b.disabled=not ready(g.state,"forge") or not HoldFrontier103.near(g,"forge")
 g.button(g.panel_body,"Review the Hold’s Ledger",func():g.open_panel("great_claim102"))
static func panel(g):
 var s=g.state
 if HoldFirstVisit99.first_morning(s) and not bool(g.get_meta("early_ledger_open",false)):
  HoldMenuView.illustrated_text(g.panel_body,"dressed_stone","THE HOLD’S LEDGER","Names and careful columns fill the pages: stone for a wall, lamps for the road, meals for the crews. This is where Stonebridge records work done for the town.")
  g.label(g.panel_body,"Ivar can tell you more after your first shift. Contributions are made here at the great book outside or at the records desk in the bunkhouse. Press M to read it from anywhere.",16)
  g.small_button(g.panel_body,"Browse the projects",func():g.set_meta("early_ledger_open",true);g.refresh_panel())
  return
 HoldMenuView.illustrated_text(g.panel_body,"dressed_stone","THE HOLD’S LEDGER","Build a place in Stonebridge. Contributions stay recorded; there are no deadlines. M reviews this ledger anywhere. Deliver carried supplies at the great book outside, east of the bunkhouse.")
 var first_project=not complete(s,"forge")
 if first_project:g.label(g.panel_body,forge_lead(s).hint,16)
 else:
  g.label(g.panel_body,DEEDS,13)
  HoldCampaign138.summary(g)
 var home=HoldMenuView.disclosure(g,g.panel_body,"Personal ambition · A place of your own","ledger137_home")
 if home!=null:
  for entry in [[HoldFirstVisit99.data(s).get("rewarded",false),"Learn the first shift and earn your wages"],[HoldFirstVisit99.data(s).get("home_made",false),"Furnish your upstairs room · O opens plans"],[HoldFrontier103.data(s).permit,"Complete two civic projects or trade seals; collect your plot at Ivar’s shift book"],[HoldFrontier103.data(s).home_reward,"Build a home on the eastern rise, with bed and light; register it with Ivar · 60 marks"]]:
   g.label(home,("✓ " if entry[0] else "○ ")+entry[1],15)
  g.button(home,"Town services and household plot",func():g.open_panel("frontier103"))
 var other_projects=null
 for id in ["forge","watch","rest","stores","storehouse","winter","north_bridge"]:
  var parent=g.panel_body
  if first_project and id!="forge":
   if id=="watch":other_projects=HoldMenuView.disclosure(g,g.panel_body,"Other town projects","ledger146_more_projects")
   if other_projects==null:continue
   parent=other_projects
  var p=PROJECTS[id];var done=complete(s,id)
  var status="Complete" if done else ("Locked · raise the storehouse" if id=="winter" else "Locked · finish your first shift") if not unlocked(s,id) else "In progress" if not data(s).paid.get(id,{}).is_empty() else "Available"
  if id=="north_bridge" and not unlocked(s,id):status="Locked · rescue, Winter Stores and site inspection"
  var box=HoldMenuView.section(parent,p.title+" · "+status)
  g.label(box,p.deeds+" — "+p.reward,14,Color("a7dfcb"))
  if done:continue
  g.label(box,p.hint,15)
  for item in p.cost:
   var row=g.row(box);HoldItemArt.icon(row,item)
   g.label(row,"%s · %d / %d" % [HoldData.ITEMS[item].name,paid(s,id,item),p.cost[item]],15)
   var amount=mini(s.count(item),int(remaining(s,id).get(item,0)))
   var b=g.small_button(row,"Contribute %d" % amount,func():contribute(g,id,item,amount);g.refresh_panel())
   b.disabled=amount<=0 or not unlocked(s,id) or not HoldGreatClaim102.near(g)
  if id=="north_bridge":
   g.button(box,"Bridge stages and specialist work orders",func():g.open_panel("restoration139"))
  elif id in ["storehouse","winter"]:
   g.button(box,"Review restoration stages",func():g.open_panel("campaign138"))
  elif id!="forge":
   var b=g.button(box,"Complete project",func():finish(g,id);g.refresh_panel());b.disabled=not ready(s,id) or not HoldGreatClaim102.near(g)
  else:g.label(box,"First firing takes place at the communal forge after inspection, coal processing and delivery.",14)
 g.button(g.panel_body,"Optional collections · miner, smith & hearthkeeper",func():g.open_panel("collections141"))
 g.button(g.panel_body,"Work lessons and contest trade seals",func():HoldWorkView132.open(g,"contribute"))
 var recognition=HoldMenuView.disclosure(g,g.panel_body,"Contest recognition and story","ledger137_recognition")
 if recognition!=null:
  for entry in HoldGreatClaim102.standings(s):g.label(recognition,"%s · %d marks — %s" % [entry[0],entry[1],entry[2]],14)
  g.label(recognition,"Complete the campaign foundations to open Ivar’s rescue lead. Marks record your recognition. Your home, belongings and relationships remain yours throughout the contest.",14)
 HoldClaim127.panel(g)
