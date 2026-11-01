class_name HoldGreatClaim102
extends RefCounted
# Additive foundation. Only newly begun fortunes join the civic ledger.
const DESK=Vector2(670,400)
const PROJECTS={
 "watch":{"title":"Lights for the night watch","cost":{"wood":6,"iron":2},"points":40,"detail":"Hakon can see the bridge approaches after dusk. Two lamps are erected on the High Trail."},
 "rest":{"title":"A table for the work crews","cost":{"wood":8,"stone":4},"points":45,"detail":"A shared table and seats give the crews a place to eat beside the eastern road."},
 "stores":{"title":"Dry stores for winter","cost":{"wood":10,"stone":6},"points":55,"detail":"Covered barrels and crates keep the settlement's provisions off the wet ground."}
}
static func active(s)->bool:return s.surface.has("great_claim102")
static func data(s)->Dictionary:return s.surface.get("great_claim102",{})
static func begin(s):
 if not active(s):s.surface.great_claim102={"version":1,"work":{},"projects":{},"points":0}
static func credit(s,path:String,amount:int):
 if not active(s) or amount<=0:return
 var d=data(s);var old=int(d.work.get(path,0));var earned=mini(amount,maxi(0,8-old))
 d.work[path]=old+earned;d.points=int(d.points)+earned
static func near(g)->bool:
 return active(g.state) and g.zone!="mine" and g.surface.area==HoldFrontier103.lodge(g.state) and g.player.distance_to(DESK)<85 and g.surface.clear_interaction(g.player,DESK)
static func complete(s,id:String)->bool:return active(s) and bool(data(s).projects.get(id,false))
static func contribute(g,id:String)->bool:
 if not near(g) or not PROJECTS.has(id) or complete(g.state,id):return false
 var p=PROJECTS[id]
 if not g.state.pay(p.cost):return false
 var d=data(g.state);d.projects[id]=true;d.points=int(d.points)+int(p.points)
 g.save_game();g.notify(p.title+" completed · "+str(p.points)+" Claim marks recorded.");return true
static func standings(s)->Array:
 var count=data(s).get("projects",{}).size()
 if HoldMountain104.active(s) and HoldMountain104.data(s).get("authenticated",false):return [["Skarrin",int(HoldMountain104.data(s).rival_at_award),"Verified works at authentication; public contest pending"],["Rurik Stonehand",150,"Haulage and settlement deliveries"],["You",int(data(s).points),"Work plus separately recorded hereditary allowance"]]
 # Named deliveries at civic milestones; no elapsed-time or player-score chasing.
 return [["Skarrin",300+([0,35,35,80][mini(count,3)]),"Prior survey, retaining wall; later a brace delivery and drainage cut"],["Rurik Stonehand",110+20*mini(count,2),"Prior haulage; timber and stone deliveries"],["You",int(data(s).get("points",0)),"Verified work and completed civic projects"]]
static func furnishings(w,area:String)->Array:
 var result=[];var s=w.g.state
 if not active(s):return result
 if area==HoldWorkerLodge100.ROOM and not HoldFrontier103.active(s):result.append(w.furn("desk",DESK.x,DESK.y))
 if area=="trail":
  if complete(s,"watch"):
   result.append(w.furn("road_lantern",1110,610));result.append(w.furn("road_lantern",1370,610))
  if complete(s,"rest"):
   result.append(w.furn("tea_table",1500,800));result.append(w.furn("chair",1450,815));result.append(w.furn("chair",1550,815))
  if complete(s,"stores"):
   result.append(w.furn("barrel",870,520));result.append(w.furn("crate",920,520));result.append(w.furn("crate",970,520))
 return result
static func panel(g):
 if not active(g.state):g.label(g.panel_body,"This fortune is not entered in the Great Claim.",18);return
 if HoldFrontier103.active(g.state):g.button(g.panel_body,"Town plan and player-home milestone",func():g.open_panel("frontier103"))
 g.label(g.panel_body,"THE GREAT CLAIM LEDGER",22,Color("edc98a"))
 g.label(g.panel_body,"Ivar records useful work and supplies freely committed to the settlement. The first eight completed work units in each discipline earn a mark apiece; civic projects earn their stated marks once. Nothing is awarded for waiting.",16)
 g.label(g.panel_body,"Charter law: authenticated ancestral rights carry a separate hereditary allowance. Until authenticated, no claimant receives that allowance. A tie must be settled by a public test of skill.",15)
 var list=standings(g.state);list.sort_custom(func(a,b):return a[1]>b[1])
 for entry in list:g.label(g.panel_body,"%s · %d marks — %s" % [entry[0],entry[1],entry[2]],16)
 g.label(g.panel_body,"Deliver materials at the ledger in the miners' lodge." if not near(g) else "Materials come from your pack. Each completed project remains in the settlement.",14)
 for id in PROJECTS:
  var p=PROJECTS[id];var box=HoldMenuView.section(g.panel_body,("✓ " if complete(g.state,id) else "○ ")+p.title)
  g.label(box,p.detail,15)
  if not complete(g.state,id):
   g.label(box,HoldData.cost_text(p.cost)+" · "+str(p.points)+" marks",14)
   var b=g.button(box,"Contribute · "+p.title,func():contribute(g,id);g.refresh_panel())
   b.disabled=not near(g) or not g.state.afford(p.cost)
