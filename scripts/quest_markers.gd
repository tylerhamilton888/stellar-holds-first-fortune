class_name HoldQuestMarkers
extends RefCounted
const A=preload("res://scripts/art.gd")
static func status(s,id:String)->String:
 var anniversary=HoldAnniversary.status(s,id)
 var states=[anniversary,HoldOnboarding.status(s,id)]
 var matter=HoldClaimStories.ensure(s).active
 if not matter.is_empty() and matter.actor==id:states.append("offer" if matter.phase=="offer" else "active")
 HoldOutpost.ensure(s)
 if s.outpost.crew.has(id) and not s.outpost.favors.get(id,false):
  states.append("ready" if s.afford(HoldOutpost.project(s,id).cost) else "offer")
 if id=="ivar":
  if s.opening==0 and (not HoldOnboarding.ensure(s).fresh or HoldOnboarding.stage(s)==1):states.append("offer")
  elif s.opening in [1,2,3] and HoldOnboarding.commission_allowed(s):states.append("ready" if s.afford(HoldCampaign.JOBS[s.opening-1].cost) else "active")
 var c=HoldCulture.ensure(s)
 if HoldOnboarding.side_stories(s) and not c.done:
  var q=HoldCulture.ERRANDS[c.errand.get("id",HoldCulture.offer(s))]
  if q.host==id:states.append("offer" if c.errand.is_empty() else "ready" if s.afford(q.cost) else "active")
 if id=="orla" and s.opening>=2:
  var freight={"stone":20,"wood":6} if s.contract%2==0 else {"iron_ore":12,"copper_ore":8}
  states.append("ready" if s.afford(freight) else "repeat")
 for kind in ["ready","offer","active","repeat"]:
  if kind in states:return kind
 return ""
static func caption(kind:String)->String:
 return {"offer":"!  Quest available","ready":"✓  Ready to return","active":"…  Quest in progress","repeat":"↻  Repeatable freight work"}.get(kind,"")
static func draw(n:Node2D,p:Vector2,s,id:String):
 var kind=status(s,id)
 if kind=="":return
 var color=Color("9ce0bb") if kind=="ready" else Color("f1ca79") if kind=="offer" else Color("a1b7c2")
 var q=p+Vector2(0,-145 if n.has_method("character_scale") and n.character_scale()>1 else -99)
 A.poly(n,[q+Vector2(-11,-12),q+Vector2(11,-12),q+Vector2(11,10),q+Vector2(0,16),q+Vector2(-11,10)],"12232e")
 n.draw_rect(Rect2(q-Vector2(10,11),Vector2(20,21)),color,false,1)
 if kind=="ready":
  A.line(n,q+Vector2(-6,0),q+Vector2(-1,5),color,2);A.line(n,q+Vector2(-1,5),q+Vector2(7,-5),color,2)
 elif kind=="offer":A.rect(n,q.x-1,q.y-7,3,9,color);A.rect(n,q.x-1,q.y+5,3,3,color)
 elif kind=="repeat":
  n.draw_arc(q,6,.2,TAU-.6,16,color,1.5);A.line(n,q+Vector2(4,-6),q+Vector2(6,-2),color,2)
 else:
  for dx in [-5,0,5]:n.draw_circle(q+Vector2(dx,0),1.4,color)
static func menu(g,parent:Node,id:String):
 HoldOnboarding.npc_menu(g,parent,id)
 var matter=HoldClaimStories.ensure(g.state).active
 if not matter.is_empty() and matter.actor==id:g.small_button(parent,"Claim business • "+HoldClaimStories.TITLES[matter.kind],func():g.open_panel("claim_stories"))
 var kind=status(g.state,id)
 if kind!="":g.label(parent,caption(kind),14,Color("a7d4c3") if kind=="ready" else Color("edc98a"))
 if HoldAnniversary.status(g.state,id)!="" or (id in ["hedrik","orla"] and HoldAnniversary.ensure(g.state).complete):
  g.small_button(parent,HoldAnniversary.NAMES[id],func():g.anniversary_host=id;g.open_panel("anniversary"))
 var c=HoldCulture.ensure(g.state)
 var quest=HoldCulture.ERRANDS[c.errand.get("id",HoldCulture.offer(g.state))]
 if HoldOnboarding.side_stories(g.state) and not c.done and quest.host==id:g.small_button(parent,"Around the hold • "+quest.name,func():g.open_panel("social"))
 if id=="ivar" and g.panel_id!="commission":g.small_button(parent,"View commissions",func():g.open_panel("commission"))

 if id=="orla" and g.state.opening>=2:g.small_button(parent,"View freight contracts",func():g.trade_tab="contracts";g.open_panel("market"))
 if g.state.outpost.crew.has(id) and not g.state.outpost.favors.get(id,false):g.small_button(parent,"Personal project • "+g.state.npc(id).first_name,func():g.outpost_tab=1;g.open_panel("manage"))
