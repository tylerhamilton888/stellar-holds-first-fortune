class_name HoldWork132
extends RefCounted
# Proof comes from completed production, never inventory changes or discipline XP.
const SEAL_MARKS=40
const SEAL_LIMIT=3
const TARGET=180
const TRADES={
 "quarry":{"title":"Stone for the next foundations","kind":"Mining","items":{"stone":24,"iron_ore":10,"copper_ore":8,"coal":12},"hint":"Mine and process stone, ore or coal in Old Workings. Choose one supply below for each delivery."},
 "timber":{"title":"Timber for the town","kind":"Woodworking","items":{"wood":12},"hint":"Follow the southern path to Pinewood. Fell and section trees, carry logs to the loan rack, then hold E at the sawbench."},
 "metal":{"title":"Fittings for the work crews","kind":"Smithing","items":{"iron":4,"copper":3},"hint":"Smelt at the communal forge. Ore may be bought or gathered; the ingots must be made by you. Ivar's eight-coal commission relights the forge."},
 "table":{"title":"Food for a full shift","kind":"Farming, fishing or cooking","items":{"turnip":12,"carrot":12,"barley":12,"hearthcap":10,"river_fish":8,"pond_perch":10,"silver_char":6,"barley_bread":4,"root_hotpot":4,"fish_chowder":3,"char_plate":3},"hint":"Grow crops, catch fish or cook meals. Choose one supply per delivery. The field kit and local kitchens have the instructions."}
}
const CHAINS={"forge":"From seam to steel","haul":"Timber, wheels and home","survey":"Read the mountain","food":"Feed your Folk"}
const LESSONS={
 "ore":{"chain":"forge","title":"Ore for the hearth","host":"forge","after":"","reward":{"iron_ore":2,"coal":1},"crowns":10,"hint":"North of Stonebridge, enter Old Workings. Mine iron and coal, lift the loads with E, stock the western rack, then hold E at the stonebreaker. Process 2 iron ore and 1 coal. First bring 8 coal to Ivar's shift book to relight the communal forge.","reply":"Borin: 'You brought the mountain's part. Now we give it the fire's.'"},
 "smelt":{"chain":"forge","title":"Fire makes it useful","host":"forge","after":"ore","reward":{"wood":6,"iron":2},"crowns":10,"hint":"If the forge is cold, deliver 8 coal at Ivar's shift book. At Stonebridge's communal forge, queue Smelt iron twice: each ingot takes 2 iron ore and 1 coal. Collecting or buying finished ingots does not count. The jobs finish while you work elsewhere. Your reward supplies a handcart.","reply":"Borin: 'Sound metal. Put these fittings under a cart and save your shoulders.'"},
 "steel":{"chain":"forge","title":"A better bite","host":"forge","after":"smelt","reward":{"food":3},"crowns":25,"hint":"At the survey desk across the bridge, research Tempered steel (4 iron, 3 timber, 35 crowns). Return to the communal forge and forge a steel pick (5 iron, 2 timber). It opens basalt and improves your mining.","reply":"Borin: 'An edge worth keeping. Take it below and bring it home again.'"},
 "timber":{"chain":"haul","title":"Timber has roots","host":"lodge","after":"","reward":{"wood":2},"crowns":10,"hint":"Walk south to Pinewood. Use axe [3] to fell and section a tree. E lifts logs and stocks the loan timber rack; hold E at its sawbench. Saw 4 timber. Bought timber does not teach the work.","reply":"Ivar: 'Straight timber. There is a place for that in every sound home.'"},
 "cart":{"chain":"haul","title":"More than two shoulders","host":"lodge","after":"timber","reward":{"food":3},"crowns":15,"hint":"In Old Workings or Pinewood, Shift+B opens worksite plans. Place a Handcart on clear ground (6 timber, 2 iron). E puts a raw load into it; C takes the handles. Walk with the loaded cart, then C parks it. Stairs carry carts; ladders do not.","reply":"Ivar: 'A cart earns its keep on the walk home. Park it clear of the next dwarf's bench.'"},
 "room":{"chain":"haul","title":"A corner that is yours","host":"lodge","after":"cart","reward":{"stone":4,"wood":2},"crowns":15,"hint":"Upstairs in the lodge, O opens furnishing plans. Place a chair, lamp or table within reach. Your own completed household also counts. Building is useful work; two town projects or trade seals earn a permanent plot.","reply":"Ivar: 'Keep making it yours. A town begins with people who mean to stay.'"},
 "survey":{"chain":"survey","title":"Read before you dig","host":"survey","after":"","reward":{"wood":4},"crowns":10,"hint":"Enter Old Workings and press X to survey below. Read the mineral bands before choosing a descent. Z opens the explored-floor map and return routes. Surveying costs no materials.","reply":"Edda: 'A line on a survey can save an afternoon of blind digging.'"},
 "route":{"chain":"survey","title":"Leave yourself a way home","host":"survey","after":"survey","reward":{"iron":2},"crowns":15,"hint":"Underground, V opens passage plans. Place a timber ladder or carve stairs on clear floor; basalt below needs a steel pick. At that passage, E descends and Shift+E returns. Make the round trip. V also places lamps; O opens excavated rooms and stone pillars after Stoneworking research.","reply":"Edda: 'Down and back. That second half is the part I wanted recorded.'"},
 "crystal":{"chain":"survey","title":"Light from below","host":"survey","after":"route","reward":{"wood":4,"iron":2},"crowns":25,"hint":"Survey and follow crystal seams on a lower floor. Mine and process 2 crystal from depth 1 or deeper. Bring light, use your explored map, and keep the return passage clear. Crystal feeds later runic crafting.","reply":"Edda: 'A useful find, and a route another worker can trust.'"},
 "kit":{"chain":"food","title":"River and root","host":"lodge","after":"","reward":{"turnip_seed":2,"wood":2},"crowns":10,"hint":"Open Field kit from the town services. Craft the fishing and gardening tools. The guide explains river fishing and garden beds; Greenhearth lies south of Stonebridge.","reply":"Ivar: 'There is honest work above the stone as well as below it.'"},
 "harvest":{"chain":"food","title":"Something for supper","host":"lodge","after":"kit","reward":{"wood":3,"carrot":2,"hearthcap":1},"crowns":10,"hint":"Catch fish OR harvest crops: gather 4 items yourself. Fishing spots and gardens are listed in the Field kit. Pick the work you enjoy; crops do not wither and tending is optional.","reply":"Ivar: 'Good. A full shift needs more than a full ore rack.'"},
 "cook":{"chain":"food","title":"A warm meal travels well","host":"lodge","after":"harvest","reward":{"food":3},"crowns":15,"hint":"Use a home hearth, public kitchen or the communal forge's recipes. Cook a trout supper, bread, hotpot, chowder or char plate. Your meal is yours to eat, share or contribute.","reply":"Ivar: 'Save a portion for the walk back. That is when you will thank yourself.'"}
}
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 if not active(s):return {}
 if not s.surface.has("work132"):s.surface.work132={"version":1,"earned":{},"spent":{},"facts":{},"done":{},"seals":[],"track":"ore","raw":{}}
 return s.surface.work132
static func closed(s)->bool:return active(s) and HoldMountain104.data(s).get("authenticated",false)
static func seals(s)->int:return data(s).get("seals",[]).size() if active(s) else 0
static func contributions(s)->int:return HoldGreatClaim102.data(s).get("projects",{}).size()+seals(s)
static func produced(s,item:String,amount:int,kind:String):
 if not active(s) or amount<=0 or kind not in ["cut","made","grown","caught"]:return
 var d=data(s);d.earned[item]=int(d.earned.get(item,0))+amount
 var key=kind+":"+item;d.facts[key]=int(d.facts.get(key,0))+amount
static func processed(g,raw:Dictionary):
 if not active(g.state) or not raw.has("id"):return
 var source=str(raw.get("source",""))
 if not source.begins_with("rock:") and not source.begins_with("pine:"):return
 var d=data(g.state);var id=str(int(raw.id))
 if d.raw.has(id):return
 d.raw[id]=true
 var item=HoldHandworks.raw_item(raw);var amount=int(raw.units)
 produced(g.state,item,amount,"cut")
 if item=="crystal" and source.begins_with("rock:") and int(source.get_slice(":",1))>=1:d.facts.deep_crystal=int(d.facts.get("deep_crystal",0))+amount
static func cooked(s,id:String):
 if not active(s):return
 for item in HoldData.RECIPES[id].out:produced(s,item,int(HoldData.RECIPES[id].out[item]),"made")
 if id in ["trout_supper","root_hotpot","barley_bread","fish_chowder","char_plate"]:
  var f=data(s).facts;f.meals=int(f.get("meals",0))+1
static func cart_moved(g,f:Dictionary,distance:float):
 if not active(g.state) or not g.walking_pose or (f.raw.is_empty() and f.cargo.is_empty()) or f.get("fixed",false):return
 var facts=data(g.state).facts;facts.cart_distance=minf(160,float(facts.get("cart_distance",0))+minf(distance,10))
static func proof(s,key:String)->int:return int(data(s).get("facts",{}).get(key,0))
static func unlocked(s,id:String)->bool:
 if not active(s) or not LESSONS.has(id) or not HoldFirstVisit99.data(s).get("rewarded",false):return false
 return LESSONS[id].after=="" or data(s).done.has(LESSONS[id].after)
static func progress(s,id:String)->Array:
 match id:
  "ore":return [["Iron ore processed",proof(s,"cut:iron_ore"),2],["Coal processed",proof(s,"cut:coal"),1]]
  "smelt":return [["Forge relit · deliver 8 coal to Ivar",int(s.opening>=2),1],["Iron ingots smelted",proof(s,"made:iron"),2]]
  "steel":return [["Tempered steel researched",int(s.tech.has("extraction")),1],["Steel pick owned",int(s.steel),1]]
  "timber":return [["Timber sawn",proof(s,"cut:wood"),4]]
  "cart":return [["Loaded cart travelled",proof(s,"cart_distance"),160]]
  "room":return [["Your room furnished",int(HoldFirstVisit99.data(s).get("home_made",false) or HoldFrontier103.data(s).get("home_reward",false)),1]]
  "survey":return [["Underground survey read",int(HoldOnboarding.ensure(s).facts.get("sample",0)),1]]
  "route":return [["Descent and return completed",int(HoldOnboarding.ensure(s).facts.get("route_tested",0)),1]]
  "crystal":return [["Lower-floor crystal processed",proof(s,"deep_crystal"),2]]
  "kit":return [["Field tools crafted",int(s.surface.get("fieldwork",{}).get("kit",false)),1]]
  "harvest":
   var amount=0
   for key in data(s).facts:
    if str(key).begins_with("grown:") or str(key).begins_with("caught:"):amount+=int(data(s).facts[key])
   return [["Fish caught or crops harvested",amount,4]]
  "cook":return [["Meals cooked",proof(s,"meals"),1]]
 return []
static func ready(s,id:String)->bool:
 if not unlocked(s,id) or data(s).done.has(id):return false
 for p in progress(s,id):
  if p[1]<p[2]:return false
 return true
static func claim_lesson(g,id:String)->bool:
 if not ready(g.state,id) or not HoldFrontier103.near(g,LESSONS[id].host):return false
 var d=data(g.state);var task=LESSONS[id];d.done[id]=true
 for item in task.reward:g.state.add(item,int(task.reward[item]))
 g.state.money+=int(task.crowns)
 if d.track==id:
  d.track=""
  for next in LESSONS:
   if LESSONS[next].after==id:d.track=next;break
 g.save_game();g.notify(task.reply);return true
static func available(s,item:String)->int:return maxi(0,int(data(s).earned.get(item,0))-int(data(s).spent.get(item,0)))
static func can_deliver(s,trade:String,item:String)->bool:
 if not active(s) or closed(s) or seals(s)>=SEAL_LIMIT or not HoldFirstVisit99.data(s).get("rewarded",false):return false
 if not TRADES.has(trade) or not TRADES[trade].items.has(item):return false
 var amount=int(TRADES[trade].items[item])
 return available(s,item)>=amount and s.count(item)>=amount
static func deliver(g,trade:String,item:String)->bool:
 if not HoldGreatClaim102.near(g) or not can_deliver(g.state,trade,item):return false
 var amount=int(TRADES[trade].items[item]);var d=data(g.state)
 if not g.state.pay({item:amount}):return false
 d.spent[item]=int(d.spent.get(item,0))+amount;d.seals.append({"trade":trade,"item":item,"amount":amount})
 var ledger=HoldGreatClaim102.data(g.state);ledger.points=int(ledger.points)+SEAL_MARKS
 g.save_game();g.notify("Ivar records your "+TRADES[trade].kind.to_lower()+" delivery · 40 Claim marks."+(" Your household plot is ready at Ivar's shift book." if contributions(g.state)>=2 and not HoldFrontier103.data(g.state).permit else " Your supplies are committed to Stonebridge."));return true
static func tracked(s)->String:
 if not active(s):return ""
 var id=str(data(s).track)
 return id if unlocked(s,id) and not data(s).done.has(id) else ""
static func goal(s)->String:
 if active(s) and contributions(s)>=2 and not HoldFrontier103.data(s).permit:return "Household plot earned · collect it at Ivar's shift book · J"
 var id=tracked(s)
 if id=="":return ""
 if ready(s,id):return "Report: "+LESSONS[id].title+" · Stonebridge "+LESSONS[id].host+" · J"
 var parts=[]
 for p in progress(s,id):parts.append("%d/%d" % [mini(p[1],p[2]),p[2]])
 return LESSONS[id].title+" · "+", ".join(parts)+" · J: steps"
