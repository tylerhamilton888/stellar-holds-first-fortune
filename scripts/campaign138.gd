class_name HoldCampaign138
extends RefCounted
# Milestones derive from existing work and story owners; no rival clock or score gate.
const SITE=Vector2(1020,940)
const STRUCTURE={"stone":30,"wood":24,"iron":2}
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 if not active(s):return {}
 if not s.surface.has("campaign138"):
  s.surface.campaign138={"version":1,"inspected":false,"winter_ready":bool(HoldFrontier103.data(s).get("storehouse",false)),"legacy_rescue":bool(HoldFrontier103.data(s).get("home_reward",false)) and int(HoldGreatClaim102.data(s).get("points",0))>=180}
 return s.surface.campaign138
static func begin(s):
 s.surface.campaign138={"version":1,"inspected":false,"winter_ready":false,"legacy_rescue":false}
static func learned(s,id:String)->bool:
 for p in HoldWork132.progress(s,id):
  if p[1]<p[2]:return false
 return not HoldWork132.progress(s,id).is_empty()
static func structure_ready(s)->bool:
 return bool(data(s).get("inspected",false))
static func recognized(s)->bool:
 return bool(HoldFrontier103.data(s).get("permit",false)) or bool(HoldFrontier103.data(s).get("home_reward",false))
static func foundations(s)->Array:
 return [
  ["A recognized household",recognized(s),"Record your household with Ivar after two civic projects or trade seals. Improving your home is optional; your existing recognition counts.",""],
  ["A sound expedition pick",s.steel,"Own a steel pick: forge it yourself or commission Borin. His work needs no smithing research from you.","forge"],
  ["A safe way below",learned(s,"survey") and learned(s,"route") and s.tech.has("stoneworking"),"Survey underground, descend and return through a passage, and research Stoneworking for the rescue's supports. Earlier completed work counts.","survey"],
  ["The Winter Stores",bool(data(s).get("winter_ready",false)),"Inspect the eastern site, supply its structure, raise the building, then contribute twelve provisions and open the stores. Gather, make or buy the supplies.",""],
  ["Town contributions",HoldWork132.contributions(s)>=3,"Complete three civic projects or trade seals in any combination. Specializing in one trade counts equally.",""]]
static func eligible(s)->bool:
 if not active(s):return false
 if int(HoldAncestralClaim.data(s).stage)>0 or data(s).get("legacy_rescue",false):return true
 if not HoldFrontier103.opportunities(s):return false
 for row in foundations(s):
  if not row[1]:return false
 return true
static func act(s)->int:
 var q=HoldAncestralClaim.data(s)
 if HoldClaim127.stage(s)>0:return 5
 if int(q.stage)>=3:return 4
 if int(q.stage)>0 or eligible(s):return 3
 return 2 if recognized(s) else 1
static func title(s)->String:
 return ["","I · A place of your own","II · Hands of the hold","III · Beneath the mountain","IV · The weight of an oath","V · The Thane’s trial"][act(s)]
static func progress(s)->int:
 var n=0
 for row in foundations(s):
  if row[1]:n+=1
 return n
static func near_site(g)->bool:
 return active(g.state) and g.zone!="mine" and g.surface.area=="trail" and g.surface.walkable(g.player) and g.player.distance_to(SITE)<110 and g.surface.clear_interaction(g.player,SITE)
static func inspect(g)->bool:
 if not near_site(g) or data(g.state).inspected or HoldFrontier103.data(g.state).get("storehouse",false):return false
 data(g.state).inspected=true;g.save_game();g.notify("The eastern foundations are sound. Ivar needs dressed stone, timber and iron fittings, then a hand raising the shell. Gather, make or buy the supplies.");return true
static func assemble(g)->bool:
 if not near_site(g) or not HoldLedger137.ready(g.state,"storehouse"):return false
 return HoldFrontier103.build_storehouse(g)
static func stock(g)->bool:
 if not near_site(g) or not HoldLedger137.ready(g.state,"winter"):return false
 data(g.state).winter_ready=true
 var room=HoldFrontier103.room(g.state,"stores")
 # Ordinary fixed furniture uses the same rendering/collision/save path as town rooms.
 for spec in [["barrel",270,370],["crate",320,370],["barrel",670,370]]:
  g.state.surface.decor.append({"area":room,"kind":spec[0],"x":spec[1],"y":spec[2],"z":0,"fixed":true})
 HoldOutpost.record(g.state,"winter_stores","The eastern storehouse is built, supplied and open to Stonebridge. The first winter provisions came through the Hold’s Ledger.")
 g.save_game();g.sound.effect("quest",-16);g.notify("The Winter Stores are open. Supplies fill the shelves; the community counter is ready.");return true
static func points(g)->Array:
 if not active(g.state) or g.surface.area!="trail":return []
 return [g.surface.spot(SITE.x,SITE.y,"The Winter Stores · restoration site","campaign138")]
static func summary(g):
 var s=g.state
 if not active(s) or not HoldFrontier103.opportunities(s):return
 g.label(g.panel_body,"CAMPAIGN · "+title(s),18)
 if eligible(s):g.label(g.panel_body,"Ivar’s rescue lead is available." if int(HoldAncestralClaim.data(s).stage)==0 else "Your accepted story continues. Earlier milestones remain recorded.",15)
 else:g.label(g.panel_body,"Foundations · %d / %d · No deadline. Recognition follows deeds, not a target score." % [progress(s),foundations(s).size()],15)
 if int(HoldAncestralClaim.data(s).stage)>=3:
  g.label(g.panel_body,HoldRestoration139.goal(s),15)
  g.small_button(g.panel_body,"The North Crossing · stages and work orders",func():g.open_panel("restoration139"))
 g.small_button(g.panel_body,"View campaign milestones & Winter Stores",func():g.open_panel("campaign138"))
static func panel(g):
 var s=g.state
 if not active(s):return
 HoldMenuView.illustrated_text(g.panel_body,"wood",title(s),"Build a life in Stonebridge and help your neighbours prepare. Your recorded work already counts. Home improvements and profession lessons are optional; the rescue still needs safe underground preparation.")
 if data(s).get("legacy_rescue",false):g.label(g.panel_body,"Your previously earned rescue invitation is preserved. New projects remain optional for this established fortune.",15)
 var box=HoldMenuView.section(g.panel_body,"The Winter Stores · "+("Open" if data(s).winter_ready else "Stock the shelves" if HoldFrontier103.data(s).get("storehouse",false) else "Raise the shell" if HoldLedger137.remaining(s,"storehouse").is_empty() else "Inspect and supply"))
 g.label(box,"Eastern site: south of the bridge, in front of the storehouse foundations. Inspect here, deliver materials at the Ledger Shrine off the Pinewood path, then return to raise the shell. Twelve provisions finish the stores. Gather, make or buy what the crews need; no profession lesson is required.",15)
 if not data(s).inspected and not HoldFrontier103.data(s).get("storehouse",false):
  var b=g.button(box,"Inspect the eastern foundations",func():inspect(g);g.refresh_panel());b.disabled=not near_site(g)
 elif not HoldFrontier103.data(s).get("storehouse",false):
  g.label(box,"Materials still needed: "+("all delivered" if HoldLedger137.remaining(s,"storehouse").is_empty() else HoldData.cost_text(HoldLedger137.remaining(s,"storehouse"))),15)
  g.label(box,("✓ " if data(s).inspected else "○ ")+"Eastern foundations inspected",15)
  var b=g.button(box,"Raise the community storehouse · 70 marks",func():assemble(g);g.refresh_panel());b.disabled=not near_site(g) or not HoldLedger137.ready(s,"storehouse")
 elif not data(s).winter_ready:
  g.label(box,"Provisions delivered · %d / 12" % HoldLedger137.paid(s,"winter","food"),15)
  var b=g.button(box,"Open the provisioned Winter Stores",func():
   if stock(g):HoldQuestScene181.play(g,"winter")
   else:g.refresh_panel());b.disabled=not near_site(g) or not HoldLedger137.ready(s,"winter")
 else:g.label(box,"The supplied storehouse is open. Its community counter trades supplies inside.",16)
 g.button(box,"Review material slots in the Hold’s Ledger",func():g.open_panel("great_claim102"))
 for row in foundations(s):
  var card=HoldMenuView.section(g.panel_body,("✓ " if row[1] else "○ ")+row[0]);g.label(card,row[2],15)
  if row[3]!="":
   var chain=str(row[3]);g.small_button(card,"Optional practical lessons",func():g.set_meta("work132_chain",chain);HoldWorkView132.open(g))
 if eligible(s) and int(HoldAncestralClaim.data(s).stage)==0:g.label(g.panel_body,"Ready: visit Ivar’s shift book in the bunkhouse to accept the rescue.",17)
