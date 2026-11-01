class_name HoldFrontier103
extends RefCounted
# Town shells use the ordinary player building catalogue and room instances.
const BUILDINGS={"lodge":["frontier_lodge",190,430],"forge":["workshop",880,570],"survey":["frontier_office",1480,450],"watch":["frontier_watch",1660,870]}
static func active(s)->bool:return s.surface.has("frontier103")
static func data(s)->Dictionary:return s.surface.get("frontier103",{})
static func room(s,key:String,z:int=0)->String:
 return HoldBuildingPlans.room_id(str(data(s).get("buildings",{}).get(key,"missing")),z)
static func lodge(s)->String:return room(s,"lodge") if active(s) else HoldWorkerLodge100.ROOM
static func quarters(s)->String:return room(s,"lodge",1) if active(s) else "room:home"
static func public_building(b:Dictionary)->bool:return bool(b.get("public103",false))
static func private_room(g)->bool:return active(g.state) and g.surface.area==quarters(g.state)
static func begin(g):
 if active(g.state):return
 var s=g.state;s.surface.frontier103={"version":1,"buildings":{},"permit":false,"home_reward":false,"storehouse":false,"keldrath_open":false}
 var a=g.surface.architecture;var d=a.data()
 for key in BUILDINGS:
  var spec=BUILDINGS[key];var id=str(int(d.next));d.next=int(d.next)+1
  var plan=HoldBuildingPlans.plan(spec[0])
  var b={"id":id,"plan":spec[0],"name":plan.name,"area":"trail","x":spec[1],"y":spec[2],"extend_x":0,"extend_y":0,"rooms":plan.rooms.duplicate(),"construction":{},"shell_paid":{},"public103":true}
  if key=="forge":b.name="Stonebridge communal forge"
  d.instances.append(b);data(s).buildings[key]=id
  for z in b.rooms.size():a.seed_room(b,z,true)
 # A shared ledger is a real furnishing with the same collision as a player desk.
 s.surface.decor.append({"area":lodge(s),"kind":"desk","x":670,"y":400,"z":0})
 for f in s.surface.decor:
  if str(f.area).begins_with("room:built86_"):f.fixed=true
 for key in s.surface.chests.keys():
  var c=s.surface.chests[key]
  if c.area==quarters(s):s.surface.chests.erase(key)
  elif str(c.area).begins_with("room:built86_"):c.fixed=true
 # Move the starter chest; no inventory replacement or second private stash.
 s.surface.chests["keldrath:quarters"].area=quarters(s)
static func near(g,key:String)->bool:
 return active(g.state) and g.zone!="mine" and g.surface.area==room(g.state,key) and g.player.distance_to(Vector2(480,500))<110
static func points(g)->Array:
 if not active(g.state):return []
 var s=g.state;var out=[]
 if g.surface.area==room(s,"survey",1):out.append(g.surface.spot(690,575,"Archive · charter law and town records","frontier_archive103"))
 if g.surface.area==lodge(s):
  out.append(g.surface.spot(670,425,"Great Claim ledger","great_claim102"))
  out.append(g.surface.spot(480,500,"Ivar's shift book · work and home plot","frontier103"))
  for p in HoldWorkerLodge100.people(g):out.append({"p":p.p,"name":p.name,"action":p.interaction})
 elif g.surface.area==quarters(s):
  out.append({"p":HoldFurnishings.bedside(Vector2(290,420)),"name":"Your bed · rest and save","action":"rest","bed":Vector2(290,420)})
 for key in (["forge","survey","watch","stores"] if data(s).get("storehouse",false) else ["forge","survey","watch"]):
  if g.surface.area==room(s,key):out.append(g.surface.spot(480,500,{"forge":"Communal forge · smelt and craft","survey":"Survey desk · research and town plan","watch":"Watch stores · buy and sell","stores":"Community stores · buy and sell"}[key],"frontier103"))
 return out
static func permit(g)->bool:
 var s=g.state
 if not near(g,"lodge") or data(s).permit or not HoldFirstVisit99.data(s).get("rewarded",false) or HoldGreatClaim102.data(s).projects.size()<2:return false
 if s.claim_id!="":return false
 s.claim_id="copper_ridge";s.camp_stage=0;data(s).permit=true
 HoldOutpost.ensure(s);s.outpost.name="Stonebridge household grounds"
 g.surface.ensure();s.surface.chests.erase("claim:copper_ridge:starter")
 g.save_game();g.notify("A residential plot on Stonebridge's eastern rise is yours to build. The lodge room remains yours while you work.");return true
static func home_ready(g)->bool:
 if not active(g.state) or not data(g.state).permit:return false
 for b in g.surface.architecture.data().instances:
  if b.area!="claim" or public_building(b):continue
  for z in b.rooms.size():
   var area=HoldBuildingPlans.room_id(str(b.id),z)
   var kinds=[]
   for f in g.state.surface.decor:
    if f.area==area:kinds.append(f.kind)
   if "bed" in kinds and ("hearth" in kinds or "lamp" in kinds):return true
 # Piece-built homes retain their real floors, walls, roof and vertical links.
 var h=g.surface.house.data() if g.surface.area=="claim" else g.state.surface.homes.get(g.state.claim_id,{}).get("building",{})
 for bed in g.state.surface.decor:
  if bed.area!="claim" or bed.kind!="bed":continue
  var z=int(bed.get("z",0));var map=h.get("tiles",{}) if z==0 else h.get("levels",{}).get(str(z),{})
  var above=h.get("levels",{}).get(str(z+1),{})
  var lit=false
  for lamp in g.state.surface.decor:
   if lamp.area=="claim" and int(lamp.get("z",0))==z and lamp.kind in ["hearth","lamp"] and Vector2(lamp.x,lamp.y).distance_to(Vector2(bed.x,bed.y))<350:lit=true
  if lit and enclosed(map,above,Vector2i(floori(bed.x/40),floori(bed.y/40))):return true
 return false
static func enclosed(map:Dictionary,above:Dictionary,start:Vector2i)->bool:
 var seen={};var todo=[start];var count=0;var doors=0
 while not todo.is_empty():
  var c=todo.pop_back();var k=str(c.x)+","+str(c.y)
  if seen.has(k):continue
  seen[k]=true
  var t=map.get(k,{})
  if t.is_empty():return false
  if t.get("wall","")!="":
   if t.wall=="door":doors+=1
   continue
  if t.get("floor","")=="" or (not t.get("roof",false) and not above.has(k)):return false
  count+=1
  for delta in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:todo.append(c+delta)
 return count>=4 and doors>0

static func finish_home(g)->bool:
 if not near(g,"lodge") or data(g.state).home_reward or not home_ready(g):return false
 data(g.state).home_reward=true
 var d=HoldGreatClaim102.data(g.state);d.points=int(d.points)+60
 g.save_game();g.notify("A hearth of your own · 60 Claim marks. Keep designing and extending your home.");return true
static func transact(g,kind:String,id:String,buy:bool=true)->bool:
 if kind=="trade" and HoldData.ITEMS.has(id) and (near(g,"watch") or (data(g.state).get("storehouse",false) and near(g,"stores"))):return g.state.trade(id,buy)
 if kind=="craft" and HoldData.RECIPES.has(id) and near(g,"forge") and g.state.opening>=2:return g.state.craft(id)
 if kind=="research" and HoldData.RESEARCH.has(id) and near(g,"survey"):return g.state.research(id)
 return false
static func panel(g):
 if not active(g.state):return
 var s=g.state
 g.label(g.panel_body,"STONEBRIDGE · A TOWN TAKING ROOT",22,Color("edc98a"))
 g.button(g.panel_body,"Field kit · fishing and farming",func():g.open_panel("fieldwork"))
 g.label(g.panel_body,"West: bunkhouse and Wayfarer's Hearth. North: Old Workings and the communal forge. Across the bridge: survey hall and watch stores. South: Pinewood and Greenhearth. The eastern rise is reserved for households.",16)
 g.label(g.panel_body,"Your home: "+("registered · keep building" if data(s).home_reward else "plot granted · build and furnish your home" if data(s).permit else "earn a paid first shift and two civic projects"),17,Color("edc98a"))
 if near(g,"lodge"):
  g.label(g.panel_body,"Ivar: 'The upstairs room is yours while you find your feet. Two civic projects and a paid first shift earn a home plot. A roof you chose yourself is worth working toward.'",16)
  if s.opening in [1,2,3]:
   var job=HoldCampaign.JOBS[s.opening-1]
   g.label(g.panel_body,job.name+" · "+HoldData.cost_text(job.cost)+" · "+str(job.pay)+" crowns",16)
   var b=g.button(g.panel_body,"Deliver shift commission",func():
    if near(g,"lodge") and s.finish_commission():g.save_game();g.refresh_panel())
   b.disabled=not s.afford(job.cost)
  if not data(s).get("storehouse",false):
   g.label(g.panel_body,"Town project: complete the eastern storehouse · 30 stone, 24 timber, 2 iron. A real building replaces the marked works yard.",16)
   var build=g.button(g.panel_body,"Complete the storehouse · 70 marks",func():build_storehouse(g);g.refresh_panel())
   build.disabled=not s.afford({"stone":30,"wood":24,"iron":2})
  g.button(g.panel_body,"Read contribution ledger",func():g.open_panel("great_claim102"))
  if not data(s).permit:
   var b=g.button(g.panel_body,"Accept a household plot",func():permit(g);g.refresh_panel())
   b.disabled=not HoldFirstVisit99.data(s).get("rewarded",false) or HoldGreatClaim102.data(s).projects.size()<2
  else:
   g.label(g.panel_body,"Your home milestone: walk east through town to the household grounds. O opens the same building plans used here, or build floors, walls, roofs and stairs piece by piece. Choose your layout, materials, furniture and upper floors. Add a bed and hearth or lamp, then report to Ivar. Your belongings stay where you put them.",16)
   var b=g.button(g.panel_body,"Register my finished home · 60 marks",func():finish_home(g);g.refresh_panel())
   b.disabled=data(s).home_reward or not home_ready(g)
 elif near(g,"forge"):
  g.label(g.panel_body,"Bring ore and coal. Ivar's first coal commission relights this communal hearth. The toolwright's methods and fittings are shared with the whole town.",16)
  g.button(g.panel_body,"Forge weapons and armor",func():g.gear_tab="forge";g.open_panel("equipment"))
  for id in HoldData.RECIPES:
   var r=HoldData.RECIPES[id]
   var b=g.button(g.panel_body,r.name+" · "+HoldData.cost_text(r.cost),func():
    if transact(g,"craft",id):g.save_game();g.refresh_panel())
   b.disabled=s.opening<2 or not s.afford(r.cost) or (r.tech!="" and not s.tech.has(r.tech)) or s.queue.size()>=12
 elif near(g,"survey"):
  g.label(g.panel_body,"Edda keeps the surveys here. The upper archive is reached by the hall's stairs; its floor and rooms use the same construction plans available to you. Ancestral privileges require authenticated evidence, not a surname.",16)
  for id in HoldData.RESEARCH:
   var r=HoldData.RESEARCH[id]
   if s.tech.has(id):continue
   var b=g.button(g.panel_body,r.name+" · "+HoldData.cost_text(r.cost)+" · "+str(r.money)+" crowns",func():
    if transact(g,"research",id):g.save_game();g.refresh_panel())
   b.disabled=not s.afford(r.cost,r.money) or (r.requires!="" and not s.tech.has(r.requires))
 elif (near(g,"watch") or (data(g.state).get("storehouse",false) and near(g,"stores"))):
  g.label(g.panel_body,"The watch's provision counter buys surplus and sells supplies. Trade uses the same stock, prices and purse as other exchanges.",16)
  var goods=HoldData.ITEMS.keys()
  for id in goods:
   var line=g.row(g.panel_body)
   g.label(line,HoldData.ITEMS[id].name+" · in pack "+str(s.count(id)),16)
   g.small_button(line,"Buy · "+str(s.price(id,true)),func():if transact(g,"trade",id,true):g.save_game();g.refresh_panel())
   g.small_button(line,"Sell · "+str(s.price(id,false)),func():if transact(g,"trade",id,false):g.save_game();g.refresh_panel())
 else:g.label(g.panel_body,"Visit a town service desk to work, trade or register your home. Keldrath is a later journey; your daily life and services are here.",16)

static func build_storehouse(g)->bool:
 if not near(g,"lodge") or data(g.state).get("storehouse",false) or not g.state.pay({"stone":30,"wood":24,"iron":2}):return false
 var a=g.surface.architecture;var d=a.data();var id=str(int(d.next));d.next=int(d.next)+1
 var b={"id":id,"plan":"frontier_watch","name":"Stonebridge community storehouse","area":"trail","x":1020,"y":900,"extend_x":0,"extend_y":0,"rooms":["room:market"],"construction":{},"shell_paid":{},"public103":true}
 d.instances.append(b);a.seed_room(b,0,true)
 for f in g.state.surface.decor:
  if f.area==HoldBuildingPlans.room_id(id):f.fixed=true
 data(g.state).storehouse=true;data(g.state).buildings.stores=id
 var ledger=HoldGreatClaim102.data(g.state);ledger.points=int(ledger.points)+70;ledger.projects.storehouse=true
 g.save_game();g.notify("The community storehouse is open. Its plan is also in your building book.");return true
static func works(g,area:String)->Array:
 if not active(g.state) or area!="trail" or data(g.state).get("storehouse",false):return []
 var w=g.surface.world
 return [w.furn("worktable",1020,850),w.furn("crate",940,850),w.furn("signpost",1100,850)]

static func draw_ground(g):
 if not active(g.state) or g.surface.area!="trail" or data(g.state).get("storehouse",false):return
 for y in range(750,870,40):
  for x in range(920,1120,40):HoldArchitectureStyles.floor_draw(g,Rect2(x,y,40,40),"slate")

static func home_panel(g):
 g.label(g.panel_body,"YOUR HOUSEHOLD GROUNDS",22,Color("edc98a"))
 g.label(g.panel_body,"Choose where and how to build. Use the same building plans as Stonebridge, or lay floors, walls, doors, roofs and stairs yourself. Connected upper levels remain usable space. Your bunkhouse room and its stored belongings remain available while you work.",16)
 g.button(g.panel_body,"Choose a building plan",func():g.surface.architecture.browse_only=true;g.open_panel("architecture"))
 g.button(g.panel_body,"Build piece by piece · including stairs and upper floors",func():g.open_panel("house_build"))
 g.button(g.panel_body,"Furniture, beds, lighting and storage",func():g.open_panel("architecture_details"))
 g.button(g.panel_body,"Renovate the nearest building",func():g.surface.architecture.browse_only=false;g.open_panel("architecture"))
 g.button(g.panel_body,"Workstations and hauling equipment",func():g.open_panel("handworks"))
 g.button(g.panel_body,"Gardens and fishing",func():g.open_panel("fieldwork"))
 g.label(g.panel_body,"Home milestone: build a roofed shell or enclosed piece-built room, then place a bed and nearby lamp or hearth. Return to Ivar's shift book to register it for 60 marks. The design stays yours to change.",16)

static func archive_panel(g):
 if not active(g.state) or g.surface.area!=room(g.state,"survey",1) or g.player.distance_to(Vector2(690,575))>90:return
 g.label(g.panel_body,"THE STONEBRIDGE REGISTER",22,Color("edc98a"))
 g.label(g.panel_body,"The first leaves record the bridge survey, retaining walls and drainage cut. Skarrin's name appears often, alongside Bram's road crew and Sten's haulers. Ivar has kept the workers' names beside their foreman's.",16)
 g.label(g.panel_body,"The charter reserves hereditary allowances for authenticated ancestral rights. No claimant may certify their own evidence. Work marks remain separately recorded; equal totals require a public test of skill.",16)
 g.label(g.panel_body,"Household permits grant lasting space within the settlement. They do not confer the Thane's title. Homes, workshops and belongings remain attached to their households when the settlement's leadership changes.",16)
 g.button(g.panel_body,"Read the contribution ledger",func():g.open_panel("great_claim102"))
