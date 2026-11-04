class_name HoldRestoration139
extends RefCounted
# The bridge owns its world change; the Ledger owns material escrow and Work132 owns production.
const SITE=Vector2(1080,510)
const CENTER=Vector2(1235,500)
const ORDERS={
 "smith":{"title":"Fittings for the crossing","tech":"metallurgy","items":{"parts":4},"hint":"Research Precision forging at the survey desk. Forge four machine parts at the communal forge; the bridge crew fits your ironwork."},
 "builder":{"title":"Stone and timber for the crews","tech":"fine_masonry","items":{"wood":20,"stone":36},"hint":"Research Fine masonry. Process twenty timber OR thirty-six stone yourself at the loan benches; the masons exchange your stock for dressed seats and seasoned beams."},
 "provisioner":{"title":"Meals for the bridge shift","tech":"hearthkeeping","items":{"barley_bread":6,"root_hotpot":6,"fish_chowder":5},"hint":"Research Hearthkeeping. Cook six breads, six hotpots OR five chowders. Feeding the hired crew covers one share of their work; farming and fishing are alternatives."}}
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 if not active(s):return {}
 if not s.surface.has("restoration139"):
  s.surface.restoration139={"version":1,"inspected":false,"orders":[],"built":false,"dedicated":false,"scene":false,"beat":0,"legacy":int(HoldAncestralClaim.data(s).stage)>=4}
 return s.surface.restoration139
static func begin(s):
 data(s);s.surface.restoration139.legacy=false
static func unlocked(s)->bool:
 return active(s) and int(HoldAncestralClaim.data(s).stage)>=3 and HoldCampaign138.data(s).get("winter_ready",false)
static func complete(s)->bool:return active(s) and bool(data(s).get("built",false))
static func witnessed(s)->bool:
 return active(s) and (data(s).get("legacy",false) or data(s).get("dedicated",false))
static func near(g)->bool:
 return active(g.state) and g.zone!="mine" and g.surface.area=="trail" and g.player.distance_to(SITE)<85 and g.surface.walkable(g.player) and g.surface.clear_interaction(g.player,SITE)
static func inspect(g)->bool:
 if not unlocked(g.state) or not near(g) or data(g.state).inspected:return false
 data(g.state).inspected=true;g.save_game();g.notify("The old north abutments can carry a new span. Supply its stone seats and beams, then support three shifts through the Ledger.");return true
static func can_order(s,id:String,item:String,amount:int)->bool:
 if not unlocked(s) or not data(s).inspected or complete(s) or data(s).orders.size()>=3 or not ORDERS.has(id):return false
 var spec=ORDERS[id]
 if not spec.items.has(item) or not s.tech.has(spec.tech) or amount<=0:return false
 var progress=data(s).get("order_paid",{})
 # A partly supplied shift keeps its recipe; completed shifts may freely change specialty.
 if not progress.is_empty() and (progress.trade!=id or progress.item!=item):return false
 return amount<=int(spec.items[item])-int(progress.get("amount",0)) and HoldWork132.available(s,item)>=amount and s.count(item)>=amount
static func order(g,id:String,item:String,amount:int)->bool:
 if not HoldGreatClaim102.near(g) or not can_order(g.state,id,item,amount):return false
 if not g.state.pay({item:amount}):return false
 var d=data(g.state);var w=HoldWork132.data(g.state)
 w.spent[item]=int(w.spent.get(item,0))+amount
 var paid=int(d.get("order_paid",{}).get("amount",0))+amount
 d.order_paid={"trade":id,"item":item,"amount":paid}
 if paid==int(ORDERS[id].items[item]):
  d.orders.append(d.order_paid.duplicate());d.order_paid={}
  g.notify("Bridge shift supplied · %d / 3. Your contribution is recorded beside the crew's work." % d.orders.size())
 g.save_game();g.sound.effect("pickup",-18);return true
static func ready(s)->bool:
 return unlocked(s) and data(s).inspected and not complete(s) and data(s).orders.size()==3 and s.tech.has("stoneworking") and HoldLedger137.remaining(s,"north_bridge").is_empty()
static func assemble(g)->bool:
 if not near(g) or not ready(g.state) or g.handworks.busy_hands():return false
 var d=data(g.state);d.built=true
 # Recognition stays closed for older authenticated saves.
 if not HoldWork132.closed(g.state):
  var ledger=HoldGreatClaim102.data(g.state);ledger.points=int(ledger.points)+100;ledger.projects.north_bridge=true
 HoldOutpost.record(g.state,"north_bridge139","The North Crossing joins Old Workings to the survey hall. Three work shifts were supplied through the Hold's Ledger; every contributor is named.")
 g.save_game();g.sound.effect("build");g.notify("The North Crossing is open. Walk across to the survey hall; return to the west abutment to gather the crew.");return true
static func gather(g)->bool:
 if not near(g) or not complete(g.state) or data(g.state).dedicated or is_instance_valid(g.opening_scene) or g.handworks.busy_hands():return false
 data(g.state).scene=true;data(g.state).beat=0;g.save_game();HoldBridgeScene139.start_bridge(g);return true
static func points(g)->Array:
 if not active(g.state) or g.surface.area!="trail":return []
 return [g.surface.spot(SITE.x,SITE.y,"The North Crossing · restoration","restoration139")]
static func crossing(s,p:Vector2)->bool:
 return complete(s) and p.y>=465 and p.y<=535
static func rails(s)->Array:
 return [Rect2(1134,443,202,12),Rect2(1134,545,202,12)] if complete(s) else []
static func goal(s)->String:
 if not unlocked(s):return "Return the survey crew safely and open the Winter Stores."
 if not data(s).inspected:return "Inspect the west abutment, north of the existing bridge."
 if not HoldLedger137.remaining(s,"north_bridge").is_empty():return "Supply the stone seats, timber and iron through the Hold’s Ledger."
 if data(s).orders.size()<3:return "Supply bridge shifts · %d / 3 · any specialty or mixture." % data(s).orders.size()
 if not s.tech.has("stoneworking") and not complete(s):return "Research Stoneworking at the survey desk, then fit the span."
 if not complete(s):return "Return to the west abutment and fit the finished span."
 if not data(s).dedicated:return "Gather the bridge crew at the west abutment."
 return "The North Crossing serves Stonebridge. Your completed work remains recorded." if HoldMountain104.data(s).authenticated else "The crossing is witnessed. Complete the family and archive evidence, then return to Edda."
static func panel(g):
 var s=g.state
 if not active(s):return
 HoldMenuView.illustrated_text(g.panel_body,"dressed_stone","THE NORTH CROSSING","Restore the old northern span. Open a direct route between Old Workings and the survey hall; let your preferred craft support the crews.")
 g.label(g.panel_body,goal(s),17,Color("edc98a"))
 if data(s).legacy:g.label(g.panel_body,"Your established ancestral claim is preserved. This restoration is optional for your fortune.",15)
 if not unlocked(s):return
 var stages=HoldMenuView.section(g.panel_body,"A crossing worth keeping")
 for row in [[data(s).inspected,"Inspect the west bank"],[HoldLedger137.remaining(s,"north_bridge").is_empty(),"Supply the structural materials"],[data(s).orders.size()==3,"Support three bridge shifts"],[complete(s),"Fit the span on site"],[data(s).dedicated,"Gather the crew and witness the work"]]:g.label(stages,("✓ " if row[0] else "○ ")+row[1],15)
 g.label(stages,"Structure remaining: "+("all delivered" if HoldLedger137.remaining(s,"north_bridge").is_empty() else HoldData.cost_text(HoldLedger137.remaining(s,"north_bridge"))),15)
 g.button(stages,"Review structural slots in the Hold’s Ledger",func():g.open_panel("great_claim102"))
 if not data(s).inspected:
  var b=g.button(stages,"Inspect the old abutments",func():inspect(g);g.refresh_panel());b.disabled=not near(g)
 elif not complete(s):
  var b=g.button(stages,"Fit the North Crossing",func():assemble(g);g.refresh_panel());b.disabled=not near(g) or not ready(s) or g.handworks.busy_hands()
 else:
  var b=g.button(stages,"Gather the bridge crew",func():gather(g));b.disabled=not near(g) or data(s).dedicated or g.handworks.busy_hands()
 if complete(s):return
 g.label(g.panel_body,"THREE SHIFTS · Repeat a specialty or mix them. Deposits are saved. Once a shift has a deposit, finish that supply before choosing the next. Only your own production counts; earlier trade deliveries cannot count twice.",15)
 var paid=data(s).get("order_paid",{})
 for id in ORDERS:
  var spec=ORDERS[id];var box=HoldMenuView.section(g.panel_body,spec.title)
  g.label(box,spec.hint,15)
  if not s.tech.has(spec.tech):g.label(box,"Required research: "+HoldData.RESEARCH[spec.tech].name,14,Color("edc98a"))
  for item in spec.items:
   var n=int(paid.get("amount",0)) if paid.get("item","")==item and paid.get("trade","")==id else 0
   var row=g.row(box);HoldItemArt.icon(row,item)
   g.label(row,"%s · %d / %d · own output available %d" % [HoldData.ITEMS[item].name,n,spec.items[item],HoldWork132.available(s,item)],14)
   var amount=mini(int(spec.items[item])-n,mini(s.count(item),HoldWork132.available(s,item)))
   var b=g.small_button(row,"Deliver %d" % amount,func():order(g,id,item,amount);g.refresh_panel())
   b.disabled=not HoldGreatClaim102.near(g) or not can_order(s,id,item,amount)
static func draw(g):
 if not active(g.state) or g.surface.area!="trail":return
 if complete(g.state):g.surface.world.draw_bridge(-200)
 else:
  # Original painted stone seats make the missing span visible without floating labels.
  for x in [1140,1330]:
   for y in [459,541]:HoldFurnishings.draw(g,Vector2(x,y),"plinth")
