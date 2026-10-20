class_name HoldIndustry
extends RefCounted
const STAGES=[
 {"name":"Powered workshop","tech":"automation","cost":{"iron":10,"copper":6,"parts":5},"money":75,"benefit":"Production runs 50% faster. Enables fabrication of the runic mining gun."},
 {"name":"Sealed engineering bay","tech":"voidcraft","cost":{"iron":14,"copper":8,"parts":8,"assembly":1},"money":120,"benefit":"Production runs twice as fast. New energy cells deliver 24 pulses instead of 16. Remaining ship stages use 20% fewer materials."}
]
const GUN_COST={"iron":8,"copper":6,"parts":6,"crystal":2}
static func tier(s,site:String="claim")->int:return clampi(int(s.outpost.get("industry_"+site,0)),0,2)
static func production(s)->float:return 1.0+.5*maxi(tier(s),tier(s,"hold"))
static func reason(s,site:String)->String:
 var t=tier(s,site)
 if t>=2:return "Fully commissioned"
 if site=="claim" and (s.claim_id=="" or s.camp_stage<2):return "Build your claim workshop first"
 if site=="hold" and s.opening<4:return "Complete Ivar's three restoration commissions"
 if not s.tech.has(STAGES[t].tech):return "Research "+HoldData.RESEARCH[STAGES[t].tech].name
 if t==1 and (s.camp_stage<3 or s.ship_stage<1):return "Commission a freight beacon and lay your first ship's keel"
 return ""
static func install(s,site:String)->bool:
 if site not in ["hold","claim"] or reason(s,site)!="":return false
 var t=tier(s,site);var stage=STAGES[t]
 if not s.pay(stage.cost,stage.money):return false
 s.outpost["industry_"+site]=t+1
 HoldOutpost.record(s,"industry_"+site+str(t),stage.name+" commissioned at "+("Keldrath" if site=="hold" else HoldOutpost.title(s))+". The old stonework carries a new generation of machinery.")
 return true
static func gun_reason(s)->String:
 if s.outpost.get("mining_gun",false):return "Already built • press 5 to equip"
 if maxi(tier(s),tier(s,"hold"))<1:return "Install a powered workshop"
 if not s.tech.has("thermal"):return "Research Runic thermal extraction"
 return ""
static func build_gun(s)->bool:
 if gun_reason(s)!="" or not s.pay(GUN_COST,120):return false
 s.outpost.mining_gun=true;s.outpost.gun_charge=0
 HoldOutpost.record(s,"mining_gun","The first slagcaster passed its pressure test. Brann requested that we keep the picks.")
 return true
static func ship_stage(s,index:int)->Dictionary:
 var stage=HoldData.SHIP[index].duplicate(true)
 if tier(s)>=2:
  for key in stage.cost:stage.cost[key]=maxi(1,int(ceil(stage.cost[key]*.8)))
 return stage
static func panel(g):
 var s=g.state;var site="claim" if s.active_site=="claim" else "hold"
 var t=tier(s,site)
 var local=g.room_id=="forge" or (g.zone=="claim" and g.room_id=="" and absf(g.player.x-1205)<120)
 if not local:g.label(g.panel_body,"Visit the local workshop to commission equipment. You can review its plans here.",16)
 g.label(g.panel_body,"INDUSTRY • "+("YOUR CLAIM" if site=="claim" else "KELDRATH"),20,Color("edc98a"))
 g.label(g.panel_body,"Installed: "+(["Founding forge","Powered workshop","Sealed engineering bay"][t])+"\nShared production speed: ×%.1f" % production(s),17)
 g.label(g.panel_body,"Research provides plans. Commission machinery at the local forge to change its appearance and capabilities. Shared production uses your best installed workshop; bonuses do not stack.",16)
 for i in 2:
  var stage=STAGES[i];var card=g.section(g.panel_body,stage.name+(" • INSTALLED" if t>i else ""))
  g.label(card,stage.benefit,16)
  if t>i:continue
  g.label(card,HoldData.cost_text(stage.cost)+" • %d crowns" % stage.money,16)
  var why=reason(s,site) if i==t else "Install the powered workshop first"
  g.label(card,why if why!="" else g.requirements(stage.cost,stage.money),16,Color("b5d9cf"))
  var b=g.button(card,"Commission "+stage.name,func():
   if install(s,site):g.save_game();g.sound.effect("build");g.refresh_panel())
  b.disabled=not local or i!=t or why!="" or not s.afford(stage.cost,stage.money)
 g.label(g.panel_body,"SLAGCASTER • RUNIC MINING GUN",19,Color("edc98a"))
 g.label(g.panel_body,"5 equips • Hold left click to cut. 180-pixel reach, 18-pixel cutting radius. Each pulse consumes one charge. Cells auto-load only on a valid rock contact. Each cell gives 16 pulses, or 24 with a sealed bay. No energy drain while idle.",16)
 g.label(g.panel_body,"Metal becomes recoverable slag: quench 2 slag with 1 water for an ingot. Heat destroys coal and roots, and yields half the crystals of a careful pick. Built timber and water block the beam. Keep a pick for valuable delicate seams and free excavation.",16)
 g.label(g.panel_body,"Gun: "+HoldData.cost_text(GUN_COST)+" • 120 crowns\nEnergy cells: craft 3 from 1 crystal, 1 copper, 2 coal.",16)
 var why=gun_reason(s)
 g.label(g.panel_body,why if why!="" else g.requirements(GUN_COST,120),16)
 var build=g.button(g.panel_body,"Fabricate slagcaster",func():
  if build_gun(s):g.save_game();g.sound.effect("build");g.refresh_panel())
 build.disabled=not local or why!="" or not s.afford(GUN_COST,120)
