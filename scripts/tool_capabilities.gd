class_name HoldToolCapabilities
extends RefCounted

# Existing steel ownership stays authoritative; the stronger pick is additive.
const COSTS={"steel":{"iron":5,"wood":2},"reinforced_pick":{"shaped_haft":1,"forged_pickhead":1,"tool_fittings":1}}
static func reinforced(s)->bool:return s.steel and bool(s.outpost.get("reinforced_pick",false))
static func power(s)->float:return 2.1 if reinforced(s) else 1.65 if s.steel else 1.0
static func basalt_hint(s)->String:
 if s.steel:return "Your reinforced pick can cut basalt; careful contacts preserve blocks." if reinforced(s) else "Your steel pick can cut basalt."
 return "Basalt needs a steel pick. Forge one at Stonebridge's anvil: 5 iron + 2 timber. Or commission Borin for those materials + 35 crowns." if s.tech.has("extraction") else "Basalt needs a steel pick. Research Tempered steel at the survey desk, then forge the pick: 5 iron + 2 timber. Or commission Borin for those materials + 35 crowns."
static func reason(s,id:String)->String:
 if not COSTS.has(id):return "Unknown tool."
 if (id=="steel" and s.steel) or (id=="reinforced_pick" and reinforced(s)):return "Already owned."
 if s.opening<2:return "Relight the communal forge first."
 if id=="reinforced_pick" and not s.steel:return "Forge the steel pick first."
 var tech="extraction" if id=="steel" else "reinforced_tools"
 if not s.tech.has(tech):return "Research "+HoldData.RESEARCH[tech].name+" at the survey desk first."
 if not s.afford(COSTS[id]):return "Bring "+HoldData.cost_text(COSTS[id])+"."
 return ""
static func forge(g,id:String)->bool:
 if not HoldFrontier103.near(g,"forge") or reason(g.state,id)!="":return false
 if not g.state.pay(COSTS[id]):return false
 if id=="steel":g.state.steel=true
 else:g.state.outpost.reinforced_pick=true
 return true

# Borin supplies expertise, not the player's manufacturing credit or research.
const COMMISSIONS={"steel":35,"reinforced_pick":45,"shaped_haft":6,"forged_pickhead":24,"tool_fittings":18}
static func commission_cost(id:String)->Dictionary:
 if COSTS.has(id):return COSTS[id]
 return HoldData.RECIPES[id].cost if COMMISSIONS.has(id) else {}
static func commission_name(id:String)->String:
 return {"steel":"Steel pick","reinforced_pick":"Reinforced pick assembly"}.get(id,HoldData.ITEMS.get(id,{}).get("name",id))
static func commission_reason(g,id:String)->String:
 if not COMMISSIONS.has(id):return "Unknown commission."
 if not HoldConversation.local(g,"borin"):return "Speak to Borin in person."
 var s=g.state
 if s.opening<2:return "Relight the communal forge first."
 if (id=="steel" and s.steel) or (id=="reinforced_pick" and reinforced(s)):return "Already owned."
 if id=="reinforced_pick" and not s.steel:return "Bring a steel pick first; I can make you one."
 if not s.afford(commission_cost(id),COMMISSIONS[id]):return "Bring "+HoldData.cost_text(commission_cost(id))+" and "+str(COMMISSIONS[id])+" crowns."
 return ""
static func commission(g,id:String)->bool:
 if commission_reason(g,id)!="":return false
 if not g.state.pay(commission_cost(id),COMMISSIONS[id]):return false
 if id=="steel":g.state.steel=true
 elif id=="reinforced_pick":g.state.outpost.reinforced_pick=true
 else:g.state.add(id,1)
 return true
static func commissions_panel(g):
 var parts=g.talk_topic=="tool_parts"
 var speech="Straight grain for the haft, sound iron for the head. Bring the stock and I'll make whichever piece you're short of." if parts else "A sound pick is honest work. Bring the materials and pay for my time; I'll supply the know-how."
 HoldConversation.header(g,g.panel_body,"borin",g.talk_line if g.talk_line!="" else speech)
 g.label(g.panel_body,"One order at a time · ready immediately · materials and fee shown below.",16)
 for id in (["shaped_haft","forged_pickhead","tool_fittings"] if parts else ["steel","reinforced_pick"]):
  var why=commission_reason(g,id)
  var title=commission_name(id)+" · "+HoldData.cost_text(commission_cost(id))+" + "+str(COMMISSIONS[id])+" crowns"
  var b=HoldConversation.choose(g,title+("\n"+why if why!="" else ""),func():
   if commission(g,id):
    g.save_game();g.talk_line="There. "+("The component is finished. It is yours." if not COSTS.has(id) else "A sound pick, ready for the stone.")
   else:g.talk_line=commission_reason(g,id)
   g.refresh_panel())
  b.disabled=why!=""
 HoldConversation.choose(g,"Ask for individual components" if not parts else "Ask about finished picks",func():g.talk_topic="tool_commission" if parts else "tool_parts";g.talk_line="";g.refresh_panel())
 HoldConversation.return_choice(g,"borin")
