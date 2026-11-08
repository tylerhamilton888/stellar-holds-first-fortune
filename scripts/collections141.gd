class_name HoldCollections141
extends RefCounted
# Optional, persistent collections. Never award campaign marks, seals or research.
const W=preload("res://scripts/work132.gd")
const BOOKS={
 "miner":{"title":"Miner’s collection","icon":"crystal","hint":"Process varied seams, dress stone and bring back a deep crystal discovery.","cost":{"iron_ore":6,"copper_ore":6,"coal":4,"dressed_stone":6,"crystal":2},"reward":"Surveyor’s stone recipe · turn 5 stone and 1 water into 3 dressed stone","reply":"Edda: ‘A good survey is more than a bright stone. You have brought back the mountain’s story.’"},
 "smith":{"title":"Smith’s collection","icon":"parts","hint":"Smelt both metals, forge useful fittings and prepare cartridges. Learn Precision forging and make your steel pick.","cost":{"iron":4,"copper":3,"parts":4,"ammo":12},"reward":"A tempered forge hammer · added to your equipment, ready to equip","reply":"Borin: ‘Clean ingots, sound fittings, work that lasts. This hammer belongs in hands that understand it.’"},
 "hearth":{"title":"Hearthkeeper’s collection","icon":"barley_bread","hint":"Choose garden or river supplies, cook provisions, and furnish a corner of your own.","cost":{"food":6},"reward":"Hearthkeeper’s supper-table plan · 6 timber and 2 stone for the first table","reply":"Maren: ‘Someone who can keep a table supplied and make a room welcoming will always have a place by my hearth.’"}}
const ROUTES={"garden":{"turnip":4,"barley":4},"river":{"river_fish":4,"pond_perch":4}}
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 if not active(s):return {}
 if not s.surface.has("collections141"):s.surface.collections141={"version":1,"paid":{},"claimed":[],"route":"garden"}
 return s.surface.collections141
static func claimed(s,id:String)->bool:return active(s) and id in data(s).claimed
static func unlocked(s)->bool:return active(s) and HoldFirstVisit99.data(s).get("rewarded",false)
static func costs(s,id:String)->Dictionary:
 if not BOOKS.has(id) or not active(s):return {}
 var result=BOOKS[id].cost.duplicate()
 if id=="hearth":result.merge(ROUTES.get(str(data(s).route),ROUTES.garden))
 return result
static func paid(s,id:String,item:String)->int:return int(data(s).get("paid",{}).get(id,{}).get(item,0))
static func remaining(s,id:String,item:String)->int:return maxi(0,int(costs(s,id).get(item,0))-paid(s,id,item))
static func choose(g,route:String)->bool:
 if not unlocked(g.state) or not ROUTES.has(route) or claimed(g.state,"hearth") or not data(g.state).paid.get("hearth",{}).is_empty():return false
 data(g.state).route=route;g.save_game();return true
static func requirements(s,id:String)->Array:
 match id:
  "miner":return [["Research Stoneworking",s.tech.has("stoneworking")],["Process 2 crystal from a deeper mine floor",W.proof(s,"deep_crystal")>=2]]
  "smith":return [["Relight the communal forge",s.opening>=2],["Research Precision forging",s.tech.has("metallurgy")],["Forge your steel pick",s.steel],["Complete Borin’s combat training",HoldOnboarding.combat_ready(s)]]
  "hearth":
   var meals=W.proof(s,"meals")
   return [["Make a field kit",s.surface.get("fieldwork",{}).get("kit",false)],["Cook 2 meals from crops or fish",meals>=2],["Furnish your room or register your own home",HoldFirstVisit99.data(s).get("home_made",false) or HoldFrontier103.data(s).get("home_reward",false)]]
 return []
static func ready(s,id:String)->bool:
 if not unlocked(s) or not BOOKS.has(id) or claimed(s,id):return false
 for item in costs(s,id):
  if remaining(s,id,item)>0:return false
 for requirement in requirements(s,id):
  if not requirement[1]:return false
 return true
static func contribute(g,id:String,item:String,amount:int)->bool:
 var s=g.state
 if not unlocked(s) or not BOOKS.has(id) or claimed(s,id) or not HoldGreatClaim102.near(g):return false
 if amount<=0 or not costs(s,id).has(item) or amount>remaining(s,id,item) or amount>W.available(s,item):return false
 if not s.pay({item:amount}):return false
 var d=data(s);var work=W.data(s)
 if not d.paid.has(id):d.paid[id]={}
 d.paid[id][item]=paid(s,id,item)+amount
 work.spent[item]=int(work.spent.get(item,0))+amount
 g.save_game();g.sound.effect("build");return true
static func claim(g,id:String)->bool:
 var s=g.state
 if not HoldGreatClaim102.near(g) or not ready(s,id):return false
 data(s).claimed.append(id)
 if id=="smith":
  var gear=HoldEquipment93.ensure(s.combat)
  gear.items.append({"id":"collection_smith141","kind":"hammer","grade":1})
  if not "hammer" in s.combat.owned:s.combat.owned.append("hammer")
 elif id=="hearth":s.add("wood",6);s.add("stone",2)
 g.save_game();g.notify(BOOKS[id].reply);g.sound.effect("build");return true
static func recipe_reason(s,id:String)->String:
 var recipe=HoldData.RECIPES[id]
 if recipe.get("collection","")!="" and not claimed(s,str(recipe.collection)):return "Complete the "+BOOKS[recipe.collection].title
 if recipe.tech!="" and not s.tech.has(recipe.tech):return "Research "+HoldData.RESEARCH[recipe.tech].name
 return ""
static func furnishing_unlocked(s,kind:String)->bool:return kind!="hearthkeeper_table" or claimed(s,"hearth")
static func panel(g):
 var s=g.state
 if not active(s):g.label(g.panel_body,"These collections belong to Stonebridge.",17);return
 g.label(g.panel_body,"Optional collections · saved deliveries · no deadlines · available after the contest",14)
 if not unlocked(s):g.label(g.panel_body,"Finish your first paid stone load to begin a collection.",16);return
 var id=str(g.get_meta("collection141","miner"))
 if not BOOKS.has(id):id="miner"
 var tabs=g.row(g.panel_body)
 g.small_button(tabs,"← Ledger",func():g.open_panel("great_claim102"))
 for key in BOOKS:
  var target=str(key);var b=g.small_button(tabs,BOOKS[key].title+(" ✓" if claimed(s,key) else ""),func():g.set_meta("collection141",target);g.refresh_panel());b.disabled=id==key
 var spec=BOOKS[id];var card=HoldMenuView.section(g.panel_body,spec.title)
 HoldMenuView.illustrated_text(card,spec.icon,"",spec.hint)
 g.label(card,"Reward: "+spec.reward,15,Color("a7dfcb"))
 if claimed(s,id):
  g.label(card,"COLLECTION COMPLETE",18,Color("a7dfcb"));g.label(card,spec.reply,16)
  if id=="miner":g.small_button(card,"View crafting recipes",func():g.recipe_selection="surveyors_stone";g.open_panel("recipes"))
  elif id=="smith":g.small_button(card,"Open equipment",func():g.gear_tab="weapon";g.open_panel("equipment"))
  else:g.label(card,"Open O in your own room or home to place your supper table. Its materials are in your pack.",15)
  return
 if id=="hearth":
  var routes=g.row(card)
  for route in ROUTES:
   var target=str(route);var b=g.small_button(routes,("Garden harvest" if route=="garden" else "River catch")+(" ✓" if data(s).route==route else ""),func():choose(g,target);g.refresh_panel());b.disabled=data(s).route==route or not data(s).paid.get("hearth",{}).is_empty()
  g.label(card,"Choose before your first delivery; that choice is then kept. Either path completes the same collection.",14)
 for requirement in requirements(s,id):g.label(card,("✓ " if requirement[1] else "○ ")+requirement[0],14)
 var done=0;var total=0
 for item in costs(s,id):done+=paid(s,id,item);total+=int(costs(s,id)[item])
 HoldWorkView132.meter(g,card,"Saved deliveries",done,total)
 for item in costs(s,id):
  var key=str(item);var left=remaining(s,id,item);var credit=W.available(s,item);var amount=mini(left,mini(s.count(item),credit));var line=g.row(card)
  HoldItemArt.icon(line,item)
  var label=g.label(line,"%s · %d / %d\nPack %d · own work available %d" % [HoldData.ITEMS[item].name,paid(s,id,item),costs(s,id)[item],s.count(item),credit],14);label.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  var b=g.small_button(line,"Delivered" if left==0 else ("Gather supplies" if amount==0 else "Contribute %d" % amount),func():contribute(g,id,key,amount);g.refresh_panel());b.disabled=amount<=0 or not HoldGreatClaim102.near(g)
 var b=g.button(card,"Collect reward",func():claim(g,id);g.refresh_panel());b.disabled=not ready(s,id) or not HoldGreatClaim102.near(g)
 g.label(card,"Deliver your own supplies at the great book outside, east of the bunkhouse. Goods already committed to seals or bridge orders cannot count twice. Town projects remain in the main Ledger.",14)
