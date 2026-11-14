class_name HoldToolCapabilities
extends RefCounted

# Existing steel ownership stays authoritative; the stronger pick is additive.
const COSTS={"steel":{"iron":5,"wood":2},"reinforced_pick":{"iron":8,"copper":2,"coal":3,"wood":2}}
static func reinforced(s)->bool:return s.steel and bool(s.outpost.get("reinforced_pick",false))
static func power(s)->float:return 2.1 if reinforced(s) else 1.65 if s.steel else 1.0
static func basalt_hint(s)->String:
 if s.steel:return "Your reinforced pick can cut basalt; careful contacts preserve blocks." if reinforced(s) else "Your steel pick can cut basalt."
 return "Basalt needs a steel pick. Forge one at Stonebridge's anvil: 5 iron + 2 timber." if s.tech.has("extraction") else "Basalt needs a steel pick. Research Tempered steel at the survey desk, then forge the pick: 5 iron + 2 timber."
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
