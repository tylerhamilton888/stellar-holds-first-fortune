class_name HoldExpedition97
extends RefCounted
const ORDERS=[{"name":"Fuel for the next shift","cost":{"iron_ore":12,"coal":8},"reward":{"wood":6,"iron":2},"crowns":80},{"name":"Light below the workings","cost":{"crystal":4},"reward":{"iron":4,"wood":8},"crowns":120}]
static func data(s)->Dictionary:
 if not s.surface.has("expedition97"):s.surface.expedition97={"stage":0,"active":false,"credit":{},"first_raw":0}
 return s.surface.expedition97
static func available(s)->bool:return s.opening>=4 and int(data(s).stage)<ORDERS.size()
static func ready(s)->bool:
 var q=data(s)
 if not available(s) or not q.active:return false
 for item in ORDERS[int(q.stage)].cost:
  if int(q.credit.get(item,0))<int(ORDERS[int(q.stage)].cost[item]):return false
 return s.afford(ORDERS[int(q.stage)].cost)
static func accept(g)->bool:
 var q=data(g.state)
 if not available(g.state) or q.active or not HoldConversation.local(g,"ivar"):return false
 q.active=true;q.credit={};q.first_raw=int(g.handworks.data().next)
 g.save_game();g.notify("Expedition accepted · J tracks your fresh ore and return delivery.");return true
static func processed(g,raw:Dictionary):
 var q=data(g.state)
 if not available(g.state) or not q.active or int(raw.get("id",-1))<int(q.first_raw) or not str(raw.get("source","")).begins_with("rock:"):return
 var item=HoldHandworks.raw_item(raw);var cost=ORDERS[int(q.stage)].cost
 if cost.has(item):q.credit[item]=mini(int(cost[item]),int(q.credit.get(item,0))+int(raw.units))
static func deliver(g)->bool:
 if not ready(g.state) or not HoldConversation.local(g,"ivar"):return false
 var q=data(g.state);var order=ORDERS[int(q.stage)]
 if not g.state.pay(order.cost):return false
 for item in order.reward:g.state.add(item,int(order.reward[item]))
 g.state.money+=int(order.crowns);q.stage=int(q.stage)+1;q.active=false;q.credit={}
 g.save_game();g.notify("Delivery complete · "+("Handcart materials earned. Ivar has a crystal lead for your next trip." if q.stage==1 else "The next shift has its supplies. Expedition series complete."));return true
static func journal(g):
 if g.state.opening<4:return
 var q=data(g.state)
 g.label(g.panel_body,"IVAR'S EXPEDITIONS",18,Color("edc98a"))
 if not available(g.state):g.label(g.panel_body,"Both expeditions delivered · the hold's next shift is supplied.",16);return
 var order=ORDERS[int(q.stage)]
 g.label(g.panel_body,order.name,17)
 g.label(g.panel_body,"Bring back fresh ore for the next shift. Mine new chunks after accepting, carry or rack them, then hold E at a stonebreaker. Return to Ivar with the finished materials. Existing supplies do not count as new expedition work.",16)
 g.label(g.panel_body,"Delivery · "+HoldData.cost_text(order.cost)+"\nReward · %d crowns · " % int(order.crowns)+HoldData.cost_text(order.reward),15)
 if q.stage==0:g.label(g.panel_body,"The reward supplies a handcart: Shift+B → Handcart. Haul more on your next trip. Take a smaller load home whenever you need; there is no deadline.",15)
 else:g.label(g.panel_body,"Look for crystal seams in the workings. Use X to survey and Z to plan your return; only explored ground appears on your map.",15)
 if q.active:
  for item in order.cost:g.label(g.panel_body,"%s · processed %d / %d · in pack %d" % [HoldData.ITEMS[item].name,int(q.credit.get(item,0)),int(order.cost[item]),g.state.count(item)],15)
 if HoldConversation.local(g,"ivar"):
  if not q.active:g.button(g.panel_body,"Accept expedition",func():accept(g);g.refresh_panel())
  elif ready(g.state):g.button(g.panel_body,"Deliver supplies & collect reward",func():deliver(g);g.refresh_panel())
  else:g.label(g.panel_body,"Keep your delivery materials in your pack for the return to Ivar.",15)
 else:g.small_button(g.panel_body,"Find Ivar · "+("return delivery" if q.active else "accept expedition"),func():g.state.tracked_npc="ivar";g.save_game();g.close_panel())
