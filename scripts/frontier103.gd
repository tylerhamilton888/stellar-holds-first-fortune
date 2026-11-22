class_name HoldFrontier103
extends RefCounted
# Town shells use the ordinary player building catalogue and room instances.
const HOME_DOOR=Vector2(2300,1180)
const HOME_BED=Vector2(2230,1020)
const HOME_CHEST=Vector2(2380,940)
const Proportions=preload("res://settlement/room_proportions.gd")
const Site=preload("res://settlement/building_site.gd")
const LODGE_DOOR=Vector2(264,484)
const INN_DOOR=Vector2(581,589)
const STORES_DOOR=Vector2(1020,900)
const BUILDINGS={"lodge":["frontier_lodge",LODGE_DOOR.x,LODGE_DOOR.y],"forge":["frontier_forge",880,570],"survey":["frontier_office",1480,450],"watch":["frontier_watch",1660,870]}
static func active(s)->bool:return s.surface.has("frontier103")
static func data(s)->Dictionary:return s.surface.get("frontier103",{})
static func room(s,key:String,z:int=0)->String:
 return HoldBuildingPlans.room_id(str(data(s).get("buildings",{}).get(key,"missing")),z)
static func lodge(s)->String:return room(s,"lodge") if active(s) else HoldWorkerLodge100.ROOM
static func quarters(s)->String:return room(s,"lodge",1) if active(s) else "room:home"
static func public_building(b:Dictionary)->bool:return bool(b.get("public103",false))
static func private_room(g)->bool:return active(g.state) and g.surface.area==quarters(g.state)
static func migrate_frontage(s,instances:Array):
 if not active(s):return
 var town=data(s)
 if town.get("frontage_revision",0)>=1:return
 var id=str(town.buildings.get("lodge",""))
 for building in instances:
  if str(building.id)!=id or building.plan!="frontier_lodge" or not public_building(building):continue
  if Vector2(building.x,building.y)==Vector2(190,430):
   building.x=LODGE_DOOR.x;building.y=LODGE_DOOR.y
  town.frontage_revision=1
  return

static func begin(g):
 if active(g.state):return
 for spec in BUILDINGS.values():
  if not Site.town(spec[0],Vector2(spec[1],spec[2])):push_error("Unsupported Stonebridge site: "+spec[0]);return
 if not Site.town("wayfarer",INN_DOOR):push_error("Unsupported Stonebridge inn site");return
 var s=g.state;s.surface.frontier103={"version":1,"frontage_revision":1,"buildings":{},"permit":false,"home_reward":false,"storehouse":false,"keldrath_open":false}
 var a=g.surface.architecture;var d=a.data()
 for key in BUILDINGS:
  var spec=BUILDINGS[key];var id=str(int(d.next));d.next=int(d.next)+1
  var plan=HoldBuildingPlans.plan(spec[0])
  var b={"fitted_rooms":true,"id":id,"plan":spec[0],"name":plan.name,"area":"trail","x":spec[1],"y":spec[2],"extend_x":0,"extend_y":0,"rooms":plan.rooms.duplicate(),"construction":{},"shell_paid":{},"public103":true}
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
 if key=="forge":return HoldForge147.near(g)
 return active(g.state) and g.zone!="mine" and g.surface.area==room(g.state,key) and g.player.distance_to(Vector2(480,500))<110
static func archive_access(g)->Vector2:
 if HoldBuildingPlans.template(g.surface.area)==Proportions.RECORDS:return HoldFurnishings.desk_access(Proportions.RECORD_DESK)
 return Vector2(690,575)
static func points(g)->Array:
 if not active(g.state):return []
 var s=g.state;var out=[]
 if g.surface.area=="trail" and HoldGreatClaim102.active(s):
  var p=HoldGreatClaim102.TOWN_ACCESS
  out.append(g.surface.spot(p.x,p.y,"Ledger Shrine · contributions and town projects","great_claim102"))
 if g.surface.area==room(s,"survey",1):out.append({"p":archive_access(g),"name":"Archive · charter law and town records","action":"frontier_archive103"})
 if g.surface.area==lodge(s):
  out.append(g.surface.spot(670,425,"Hold’s Ledger","great_claim102"))
  out.append(g.surface.spot(480,500,"Ivar's shift book · work and household records","frontier103"))
  for p in HoldWorkerLodge100.people(g):out.append({"p":p.p,"name":p.name,"action":p.interaction})
 elif g.surface.area==quarters(s):
  out.append({"p":HoldFurnishings.bedside(Vector2(290,420)),"name":"Your bed · rest and save","action":"rest","bed":Vector2(290,420)})
 for key in (["forge","survey","watch","stores"] if data(s).get("storehouse",false) else ["forge","survey","watch"]):
  if g.surface.area!=room(s,key):continue
  if key=="forge":out.append_array(HoldForge147.points(g))
  else:out.append(g.surface.spot(480,500,{"survey":"Survey desk · research and town plan","watch":"Watch stores · buy and sell","stores":"Community stores · buy and sell"}[key],"frontier103"))
 return out
# Ownership is separate from the existing civic-recognition flag (permit).
static func family(s)->bool:return active(s) and data(s).has("home169")
static func opportunities(s)->bool:return family(s) or bool(HoldFirstVisit99.data(s).get("rewarded",false))
static func settle_home(g,fresh:bool=false):
 var s=g.state
 if not active(s) or family(s):return
 var empty=s.claim_id==""
 data(s).home169={"version":1,"visited":not empty,"introduced":not empty,"seeded":false}
 if not empty:return # Existing homes, names, workers and belongings are never reseeded.
 s.claim_id="copper_ridge"
 HoldOutpost.ensure(s);s.outpost.name="Old Stonewright's Rise"
 g.surface.ensure()
 var h=s.surface.homes[s.claim_id]
 if h.has("building") or s.surface.decor.any(func(f):return f.area=="claim") or s.surface.chests.values().any(func(c):return c.area=="claim") or g.surface.architecture.data().instances.any(func(b):return b.area=="claim"):return
 var tiles={};var roof={}
 for y in range(22,28):
  for x in range(54,61):
   var k=str(x)+","+str(y);var edge=x in [54,60] or y in [22,27]
   tiles[k]={"floor":"stone_floor","roof":true,"wall":"wall" if edge else ""}
   roof[k]={"floor":"roof_floor"}
 tiles["57,27"].wall="door";tiles["57,27"].open=true
 tiles["54,24"].wall="window";tiles["60,24"].wall="window"
 h.building={"tiles":tiles,"levels":{"1":roof},"links":{},"facts":{},"z":0}
 s.surface.decor.append({"area":"claim","kind":"bed","x":HOME_BED.x,"y":HOME_BED.y,"z":0})
 s.surface.chests["home169:chest"]={"area":"claim","x":HOME_CHEST.x,"y":HOME_CHEST.y,"z":0,"items":{}}
 data(s).home169.seeded=true
 if fresh:
  data(s).home169.homeward="first_visit"
  HoldFirstVisit99.data(s).focus="forge"

static func cross_home_road(g,from:String,to:String):
 if not family(g.state):return
 var home=data(g.state).home169
 if from=="claim" and to=="trail" and home.get("homeward","")=="first_visit":
  home.homeward="away"
 elif from=="trail" and to=="claim" and home.get("homeward","")=="away":
  home.homeward="returned"
  var line="Your feet find the turn at the old loading stones. Beyond the yard is your own front door."
  if HoldLedger137.complete(g.state,"forge"):line="There’s coal dust on your cuffs from Borin’s forge. You turn in at the loading stones. Home."
  elif HoldLedger137.data(g.state).get("gift",false):line="At the loading stones you remember Skarrin’s offcuts. There’s room for a bench here."
  g.notify(line)
 else:return
 g.save_game()
static func letter(g):
 if not family(g.state) or g.state.claim_id!="copper_ridge":return
 var box=HoldMenuView.disclosure(g,g.panel_body,"Read your parents' letter","home169_letter")
 if box!=null:
  g.label(box,"Our dear one,",18,Color("edc98a"))
  g.label(box,"The papers are in the inner pocket. Old Stonewright's Rise is yours, paid in full. We have put a little aside for years; this is what it was for.",16)
  g.label(box,"Your father went up on the roof while the agent was trying to sell me the view. He came down with a split slate in his pocket and made the fellow replace it before we signed. You can sleep dry at the Rise.",16)
  g.label(box,"We hope they choose you. We wanted you to have a home there whatever the book says in the end. Write when you arrive. Your father would like to know what you make in the old yard first. — Mum",16)
 for note in home_letters(g.state):
  var page=HoldMenuView.disclosure(g,g.panel_body,note.title,note.id)
  if page!=null:g.label(page,note.body,16)
static func home_letters(s)->Array:
 var notes=[]
 if not family(s):return notes
 if data(s).permit:
  notes.append({"id":"home179_recognition","title":"A letter from home · A name in the book","body":"Our dear one,\n\nIvar sent word that your household is in the town book. Your father read that bit twice, then said of course they would see your worth. He has kept the envelope.\n\nWe hoped the Rise would give you somewhere to begin. It is good to hear you are finding people to begin with. There is room at our table whenever you want it.\n\nAll our love,\nMum and Dad"})
 if data(s).home_reward:
  notes.append({"id":"home179_improvement","title":"A letter from home · Making it yours","body":"Our dear one,\n\nThe notice of your home registration arrived. Your father laid it beside the old agent's description and said yours was the better piece of writing. I think he meant the house.\n\nWe will leave the furnishing to you. Though if you ever want that old table, your father has already measured the wagon. Twice.\n\nWe are proud of you. We were before the papers, too.\nMum and Dad"})
 return notes
static func provisional(s)->bool:
 return not family(s) and active(s) and s.claim_id=="copper_ridge" and bool(data(s).get("rise165",{}).get("accepted",false)) and not data(s).permit
static func rise_pending(s)->bool:
 return active(s) and bool(data(s).get("rise165",{}).get("scene",false))
static func near_ivar(g)->bool:
 return near(g,"lodge") or (g.zone!="mine" and g.surface.area==lodge(g.state) and HoldWorkerLodge100.people(g).any(func(p):return p.interaction=="lodge_folk:0" and g.player.distance_to(p.p)<110))
static func offer_rise(g)->bool:
 var s=g.state
 if not family(s) or not near_ivar(g) or data(s).home169.introduced or s.claim_id!="copper_ridge":return false
 HoldFirstVisit99.meet_ivar(g)
 data(s).home169.introduced=true
 data(s).rise165={"accepted":true,"scene":true,"beat":0}
 g.save_game();HoldClaimScene127.start_scene(g);return true
static func rise_card(g):
 var s=g.state
 if family(s) and near_ivar(g) and not data(s).home169.introduced:g.button(g.panel_body,"Show me Old Stonewright’s Rise",func():offer_rise(g))
static func tenure_text(s)->String:
 if data(s).permit:return "Ivar: 'Your household is recorded. Your home and ground remain yours, whatever comes of the contest.'"
 if HoldWork132.contributions(s)>=2:return "Ivar: 'Your contributions are entered. We can record your household whenever you are ready. The land was already yours.'"
 return "Ivar: 'The holding is yours. Two civic projects or trade seals, and we enter your household in Stonebridge’s book. There is no hurry.'"
static func permit(g)->bool:
 var s=g.state
 if not family(s) or not near(g,"lodge") or data(s).permit or s.claim_id=="" or HoldWork132.contributions(s)<2:return false
 data(s).permit=true
 g.save_game();g.notify("Your household is recognized in Stonebridge. The same home, ground and belongings remain yours.");return true
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
 if kind=="tool":return HoldToolCapabilities.forge(g,id)
 if kind=="trade" and HoldData.ITEMS.has(id) and (near(g,"watch") or (HoldCampaign138.data(g.state).get("winter_ready",false) and near(g,"stores"))):return g.state.trade(id,buy)
 if kind=="craft" and HoldData.RECIPES.has(id) and near(g,"forge") and g.state.opening>=2:return g.state.craft(id)
 if kind=="research" and HoldData.RESEARCH.has(id) and near(g,"survey"):return g.state.research(id)
 return false
static func panel(g):
 if not active(g.state):return
 var s=g.state
 if near(g,"forge") and s.opening<2:
  HoldLedger137.forge_panel(g);return
 if near(g,"forge"):
  HoldForge147.panel(g);return
 if near(g,"lodge") and HoldFirstVisit99.opening_route(g) and not bool(g.get_meta("early_shift_book_open",false)):
  g.label(g.panel_body,"Ivar’s shift book",21,Color("edc98a"))
  HoldFirstVisit99.opening_card(g)
  if not family(s):rise_card(g)
  g.small_button(g.panel_body,"Look through the rest of the book",func():g.set_meta("early_shift_book_open",true);g.refresh_panel())
  return
 var welcome=HoldMenuView.section(g.panel_body,"")
 HoldMenuView.illustrated_text(welcome,"wood","A town taking root","Work, trade and make a place of your own. Visit each desk in town to use its services.")
 g.button(g.panel_body,"Useful hands · lessons & contest contributions",func():HoldWorkView132.open(g))
 g.button(g.panel_body,"Field kit · fishing and farming",func():g.open_panel("fieldwork"))
 var directions=HoldMenuView.disclosure(g,g.panel_body,"Around Stonebridge","town135_directions")
 if directions!=null:
  var grid=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",20);directions.add_child(grid)
  for place in [["West","Bunkhouse & Wayfarer’s Hearth"],["North","Old Workings & communal forge"],["Across the bridge","Survey hall & watch stores"],["South","Pinewood & Greenhearth"]]:
   g.label(grid,place[0],15,Color("edc98a"));g.label(grid,place[1],15)
 if opportunities(s):
  g.label(g.panel_body,"Your home · "+("improved home registered" if data(s).home_reward else "recognized household" if data(s).permit else "%d / 2 contributions toward household recognition" % mini(2,HoldWork132.contributions(s))),16,Color("a7dfcb"))
 HoldClaim127.panel(g)
 if HoldMountain104.eligible(s):HoldMountain104.panel(g)
 if near(g,"lodge"):
  g.label(g.panel_body,tenure_text(s),16)
  rise_card(g)
  if s.opening==1:
   g.button(g.panel_body,"The Cold Forge · staged restoration",func():g.open_panel("great_claim102"))
  if s.opening in [2,3]:
   var job=HoldCampaign.JOBS[s.opening-1]
   g.label(g.panel_body,job.name+" · "+HoldData.cost_text(job.cost)+" · "+str(job.pay)+" crowns",16)
   var b=g.button(g.panel_body,"Deliver shift commission",func():
    if near(g,"lodge") and s.finish_commission():g.save_game();g.refresh_panel())
   b.disabled=not s.afford(job.cost)
  g.button(g.panel_body,"The Winter Stores · restoration stages",func():g.open_panel("campaign138"))
  g.button(g.panel_body,"Read contribution ledger",func():g.open_panel("great_claim102"))
  if not data(s).permit:
   var b=g.button(g.panel_body,"Record my household · two contributions",func():permit(g);g.refresh_panel())
   b.disabled=not family(s) or s.claim_id=="" or HoldWork132.contributions(s)<2
  else:
   HoldMenuView.illustrated_text(g.panel_body,"wood","Your household","Follow the east road. O opens building plans. Improve your home with a bed and a nearby lamp or hearth, then register it here. The starter cottage needs a light; you do not need to rebuild it.")
   var b=g.button(g.panel_body,"Register my finished home · 60 marks",func():finish_home(g);g.refresh_panel())
   b.disabled=data(s).home_reward or not home_ready(g)
 elif near(g,"survey"):
  g.label(g.panel_body,"Edda keeps the surveys here. The upper archive is reached by the hall's stairs; its floor and rooms use the same construction plans available to you. Ancestral privileges require authenticated evidence, not a surname.",16)
  for id in HoldData.RESEARCH:
   var r=HoldData.RESEARCH[id]
   if s.tech.has(id):continue
   var b=g.button(g.panel_body,r.name+" · "+HoldData.cost_text(r.cost)+" · "+str(r.money)+" crowns",func():
    if transact(g,"research",id):g.save_game();g.refresh_panel())
   b.disabled=not s.afford(r.cost,r.money) or (r.requires!="" and not s.tech.has(r.requires))
 elif (near(g,"watch") or (HoldCampaign138.data(g.state).get("winter_ready",false) and near(g,"stores"))):
  g.label(g.panel_body,"The watch's provision counter buys surplus and sells supplies. Trade uses the same stock, prices and purse as other exchanges.",16)
  var goods=HoldData.ITEMS.keys()
  for id in goods:
   if not HoldData.ITEMS[id].get("trade",true):continue
   var line=g.row(g.panel_body)
   HoldItemArt.icon(line,id)
   g.label(line,HoldData.ITEMS[id].name+" · in pack "+str(s.count(id)),16)
   g.small_button(line,"Buy · "+str(s.price(id,true)),func():if transact(g,"trade",id,true):g.save_game();g.refresh_panel())
   g.small_button(line,"Sell · "+str(s.price(id,false)),func():if transact(g,"trade",id,false):g.save_game();g.refresh_panel())
 else:g.label(g.panel_body,"Visit a town service desk to work, trade or register your home. Keldrath is a later journey; your daily life and services are here.",16)

static func build_storehouse(g)->bool:
 if not HoldCampaign138.near_site(g) or not HoldLedger137.ready(g.state,"storehouse") or data(g.state).get("storehouse",false):return false
 if not Site.town("frontier_watch",STORES_DOOR):return false
 if not g.state.pay(HoldLedger137.remaining(g.state,"storehouse")):return false
 var a=g.surface.architecture;var d=a.data();var id=str(int(d.next));d.next=int(d.next)+1
 var b={"fitted_rooms":true,"id":id,"plan":"frontier_watch","name":"Stonebridge community storehouse","area":"trail","x":STORES_DOOR.x,"y":STORES_DOOR.y,"extend_x":0,"extend_y":0,"rooms":["room:market"],"construction":{},"shell_paid":{},"public103":true}
 d.instances.append(b);a.seed_room(b,0,true)
 for f in g.state.surface.decor:
  if f.area==HoldBuildingPlans.room_id(id):f.fixed=true
 data(g.state).storehouse=true;data(g.state).buildings.stores=id
 var ledger=HoldGreatClaim102.data(g.state);ledger.points=int(ledger.points)+70;ledger.projects.storehouse=true
 g.save_game();g.notify("The storehouse shell is complete. Provision it through the Hold’s Ledger, then return to open the community counter.");return true
static func works(g,area:String)->Array:
 if not active(g.state) or area!="trail" or data(g.state).get("storehouse",false):return []
 var w=g.surface.world
 return [w.furn("worktable",1020,850),w.furn("crate",940,850),w.furn("signpost",1100,850)]

static func draw_ground(g):
 if not active(g.state) or g.surface.area!="trail":return
 preload("res://settlement/ground.gd").town(g)
 if data(g.state).get("storehouse",false):return
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
 g.label(g.panel_body,"Home milestone: a roofed, enclosed home with a bed and nearby lamp or hearth. Existing construction counts; the starter cottage only needs a light. After two civic contributions, record your household with Ivar and register the improved home for 60 marks. The design stays yours to change.",16)

static func archive_panel(g):
 if not active(g.state) or g.surface.area!=room(g.state,"survey",1) or g.player.distance_to(archive_access(g))>90:return
 HoldMountain104.panel(g)
 g.label(g.panel_body,"THE STONEBRIDGE REGISTER",22,Color("edc98a"))
 g.label(g.panel_body,"The first leaves record the bridge survey, retaining walls and drainage cut. Skarrin's name appears often, alongside Bram's road crew and Sten's haulers. Ivar has kept the workers' names beside their foreman's.",16)
 g.label(g.panel_body,"The charter reserves hereditary allowances for authenticated ancestral rights. No claimant may certify their own evidence. Work marks remain separately recorded; equal totals require a public test of skill.",16)
 g.label(g.panel_body,"Household recognition records service to the settlement. Your own property is already yours; recognition does not confer the Thane's title. Homes, workshops and belongings remain attached to their households when the settlement's leadership changes.",16)
 g.button(g.panel_body,"Read the contribution ledger",func():g.open_panel("great_claim102"))
