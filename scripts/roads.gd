class_name HoldRoads
extends RefCounted
# Physical countryside connections and local livelihoods. Existing inventories,
# gardens, workstations and whole-character art remain their respective owners.
const OUTDOORS=["trail","pinewood","greenfields","claim"]
const ROOMS={"room:wayfarer":"The Wayfarer's Hearth","room:greenhearth":"Greenhearth farmhouse"}
const BED=Vector2(290,420)
const ORDERS={
 "trail":{"name":"Stone for the bridge crew","item":"stone","count":8,"pay":20,"p":Vector2(760,590)},
 "pinewood":{"name":"Timber for the mine supports","item":"wood","count":5,"pay":25,"p":Vector2(300,790)},
 "greenfields":{"name":"Roots for the Copper Kettle","item":"turnip","count":6,"pay":30,"p":Vector2(760,480)}}
const FOLK=[
 {"area":"trail","name":"Bram","role":"Road keeper","a":Vector2(730,650),"b":Vector2(1020,650),"gender":0,"line":"The bridge crew needs stone; the board has the terms. Dagna keeps the Wayfarer's Hearth west of here. Go inside if you need a kitchen, a bunk, or company."},
 {"area":"room:wayfarer","name":"Dagna","role":"Wayside host","a":Vector2(380,430),"b":Vector2(500,430),"gender":1,"line":"Welcome to the Wayfarer's Hearth. The bunk is free, and you may use the kitchen with your own ingredients. Or stay a while and talk. Not every visit needs to be an errand."},
 {"area":"pinewood","name":"Torvik","role":"Timber worker","a":Vector2(470,765),"b":Vector2(700,765),"gender":0,"line":"Fell your trees, shoulder the logs, then use the loan saw and rack. Our board pays for finished timber; it does not take raw logs."},
 {"area":"greenfields","name":"Ragnhild","role":"Smallholder","a":Vector2(630,500),"b":Vector2(820,500),"gender":1,"line":"Lease the four beds by the farmhouse once. Bring your own seeds and water. No rent timer, and no crop withers while you are away."},
 {"area":"greenfields","name":"Ketil","role":"Field hand","a":Vector2(1110,790),"b":Vector2(1530,790),"gender":0,"line":"These fields feed the hold. We keep the cart lane clear; you can carry your harvest all the way to the Kettle's order board."},
 {"area":"trail","name":"Sten","role":"Mine porter","a":Vector2(760,400),"b":Vector2(865,400),"gender":0,"line":"The northern arch leads straight into Old Workings. The rack and breaker outside are on loan. Bring your own stone; the crew's supplies remain theirs."}]
var g
var surface_ref:WeakRef
var s:
 get:return surface_ref.get_ref()
var profiles={}
var portal_cooldown=0.0
var return_hold={}
func _init(surface):surface_ref=weakref(surface);g=surface.g
func data()->Dictionary:
 if not g.state.surface.has("roads"):g.state.surface.roads={"version":1,"orders":{},"allotment":false,"visits":{}}
 return g.state.surface.roads
func ensure():
 if data().get("loans_initialized",false):return
 # Idempotent loans never replace player equipment or raw/cargo records.
 for spec in [["trail","breaker",720,355],["trail","stone_pile",610,355],["pinewood","saw",570,850],["pinewood","timber_pile",700,850]]:
  var id="roads75:"+spec[0]+":"+spec[1];var exists=false
  for f in g.handworks.data().facilities:
   if str(f.id)==id:exists=true;break
  if not exists:
   var f={"id":id,"kind":spec[1],"area":"surface:"+spec[0]+":0","x":float(spec[2]),"y":float(spec[3]),"raw":[],"cargo":{},"job":{},"hitched":false,"owner":"loan","fixed":true}
   # Existing placed equipment wins; find a nearby clear station position.
   var placed=false
   for offset in [0,100,-100,200,-200]:
    f.x=float(spec[2])+offset;var clear=true
    for other in g.handworks.data().facilities:
     if other.area==f.area and Vector2(other.x,other.y).distance_to(Vector2(f.x,f.y))<85:clear=false
    for other in g.state.surface.chests.values():
     if other.get("area","")==spec[0] and Vector2(other.x,other.y).distance_to(Vector2(f.x,f.y))<85:clear=false
    for other in g.state.surface.decor:
     if other.get("area","")==spec[0] and Vector2(other.x,other.y).distance_to(Vector2(f.x,f.y))<85:clear=false
    if clear:placed=true;break
   if placed:g.handworks.data().facilities.append(f)
 data().loans_initialized=true
 for area in ROOMS:
  var id="roads75:store:"+area
  if not g.state.surface.chests.has(id):g.state.surface.chests[id]={"area":area,"x":700.0,"y":550.0,"items":{},"fixed":true}
func connection(p:Vector2,normal:Vector2,target:String,landing:Vector2,title:String)->Dictionary:
 return {"p":p,"normal":normal,"target":target,"landing":landing,"title":title}
func links(area:String)->Array:
 if HoldBuildingPlans.owned_room(area):return s.architecture.connections(area)
 return authored_links(area)+s.architecture.connections(area)
func authored_links(area:String)->Array:
 if HoldWorldZones.ward(area):
  var result=[]
  for point in s.world.points():
   if point.action.begins_with("room:"):result.append(connection(point.p+Vector2(0,3),Vector2.UP,point.action,Vector2.INF,point.name))
  if area=="hearthward":result.append(connection(HoldWorldZones.GATE+Vector2(0,3),Vector2.UP,"trail",Vector2(220,735),"High Trail"))
  return result
 match area:
  "trail":return [connection(Vector2(220,690),Vector2.UP,"hearthward",HoldWorldZones.GATE+Vector2(0,45),"Keldrath"),connection(HoldMineEntrance.position("trail")+Vector2(0,5),Vector2.UP,"mine",Vector2.ZERO,"Old Workings"),connection(Vector2(470,925),Vector2.DOWN,"pinewood",Vector2(150,650),"Pinewood"),connection(Vector2(1780,700),Vector2.RIGHT,"claim",Vector2(150,790),"Your claim"),connection(Vector2(1540,925),Vector2.DOWN,"greenfields",Vector2(940,285),"Greenhearth"),connection(Vector2(510,520),Vector2.UP,"room:wayfarer",Vector2(480,565),"Wayfarer's Hearth")]
  "pinewood":return [connection(Vector2(100,650),Vector2.LEFT,"trail",Vector2(470,870),"High Trail")]
  "greenfields":return [connection(Vector2(940,235),Vector2.UP,"trail",Vector2(1540,870),"Stonebridge"),connection(Vector2(550,450),Vector2.UP,"room:greenhearth",Vector2(480,565),"Farmhouse")]
  "claim":return [connection(Vector2(100,790),Vector2.LEFT,"trail",Vector2(1730,700),"Stonebridge"),connection(HoldMineEntrance.position("claim")+Vector2(0,5),Vector2.UP,"mine",Vector2.ZERO,"Your Deepworks"),connection(Vector2(500,440),Vector2.UP,"home:"+g.state.claim_id,Vector2(480,565),"Your hearth")]
 if area in ROOMS:return [connection(Vector2(480,595),Vector2.DOWN,"trail" if area=="room:wayfarer" else "greenfields",Vector2(510,565) if area=="room:wayfarer" else Vector2(550,495),"Outside")]
 if (area.begins_with("room:") or area.begins_with("home:")) and HoldCivicArt.has_exit(area):
  var back=s.return_area;var landing=Vector2.INF
  if HoldNeighborhood.is_home(area):
   var parts=HoldNeighborhood.parts(area);back=parts[0];landing=HoldNeighborhood.home_door(int(parts[1]))+Vector2(0,45)
  else:
   var saved=g.state.surface.positions.get(back,[])
   if saved.size()==2:landing=Vector2(saved[0],saved[1])+Vector2(0,45)
  return [connection(HoldRoomLayout.exit_point(area)-Vector2(0,25),Vector2.DOWN,back,landing,"Outside")]
 return []
func is_link(action:String)->bool:
 for link in links(s.area):
  if link.target==action:return true
 return action=="leave" and s.room() and HoldCivicArt.has_exit(s.area)
func crossing(before:Vector2,after:Vector2)->Dictionary:
 for link in links(s.area):
  var a=(before-link.p).dot(link.normal);var b=(after-link.p).dot(link.normal)
  var sideways=absf((after-link.p).cross(link.normal))
  if a<0 and b>=0 and sideways<(HoldMineEntrance.CROSSING_HALF if link.target=="mine" else 38.0):return link
 return {}
func hold_return(target:String):
 return_hold={"area":s.area,"target":target,"heading":Input.get_vector("left","right","up","down"),"origin":g.player}
func poll_input():
 if not return_hold.is_empty() and Input.get_vector("left","right","up","down")!=return_hold.heading:return_hold.clear()
func moved(before:Vector2,dt:float)->bool:
 portal_cooldown=maxf(0,portal_cooldown-dt)
 poll_input()
 if not return_hold.is_empty() and (s.area!=return_hold.area or g.player.distance_to(return_hold.origin)>100):return_hold.clear()
 if g.player==before or (s.area=="claim" and s.house.level()>0):return false
 var link=crossing(before,g.player)
 # Opposing views can put the arrival's return door ahead of held movement.
 # Latch that doorway until the input changes, including with slower wagons.
 if not link.is_empty() and not return_hold.is_empty() and link.target==return_hold.target:
  g.player=before;g.velocity=Vector2.ZERO;g.walking_pose=false;return false
 if portal_cooldown>0:return false
 if link.is_empty():return false
 if link.target=="claim" and g.state.claim_id=="":
  g.player=before;g.notify("Unclaimed mountain. Ivar or the Survey Office can help you earn or buy a charter.");portal_cooldown=1;return false
 if link.target in OUTDOORS and g.state.opening==0:
  g.player=before;g.notify(g.region_travel_hint());portal_cooldown=1;return false
 var gait=g.gait_clock;var from=s.area
 if link.target=="mine":s.action("mine")
 else:
  s.enter(link.target,link.landing)
  if s.area!=link.target:
   g.player=before;portal_cooldown=.5;return false
  hold_return(from)
 g.gait_clock=gait
 # A short zone dissolve keeps one active scene; held movement resumes naturally.
 g.transition_left=.18;portal_cooldown=.35
 data().visits[link.target]=true
 return true
func roads(area:String)->Array:
 match area:
  "trail":return [[Vector2(220,690),Vector2(700,690),Vector2(1880,700)],[Vector2(700,690),Vector2(950,300)],[Vector2(700,690),Vector2(470,980)],[Vector2(1430,700),Vector2(1540,980)],[Vector2(510,690),Vector2(510,520)],[Vector2(790,520),Vector2(650,420),Vector2(610,400)]]
  "pinewood":return [[Vector2(0,650),Vector2(300,650),Vector2(550,730),Vector2(800,730),Vector2(1100,600),Vector2(1560,760)],[Vector2(300,650),Vector2(300,790),Vector2(570,790),Vector2(700,790)]]
  "greenfields":return [[Vector2(940,180),Vector2(940,650),Vector2(1540,650)],[Vector2(940,500),Vector2(550,500),Vector2(550,450)],[Vector2(940,650),Vector2(700,650),Vector2(700,870)],[Vector2(700,720),Vector2(350,720)]]
 return []
func buildings(area:String)->Array:
 if area=="trail":return [HoldBuildingPlans.instance("wayfarer",Vector2(510,520))]
 if area=="greenfields":return [HoldBuildingPlans.instance("farmhouse",Vector2(550,450))]
 return []
func furnishings(area:String)->Array:
 var result=settlement_furnishings(area)
 # Independent posts use the same depth sorting and small physical bases as
 # player furniture. Their feet stay outside the 38px portal walking lane.
 if area in OUTDOORS:
  for link in links(area):
   if link.target=="mine" or link.target.begins_with("room:") or link.target.begins_with("home:"):continue
   var p:Vector2=link.p+Vector2(-link.normal.y,link.normal.x)*62
   result.append(s.world.furn("signpost",p.x,p.y))
 return result
func settlement_furnishings(area:String)->Array:
 var w=s.world
 match area:
  "trail":return [w.furn("runestone",355,770),w.furn("barrel",420,585),w.furn("crate",465,600),w.furn("desk",760,568),w.furn("road_lantern",590,540),w.furn("tea_table",610,610),w.furn("chair",560,625),w.furn("chair",660,625),w.furn("lamp",840,330),w.furn("worktable",780,342)]
  "pinewood":return [w.furn("lamp",330,740),w.furn("worktable",400,850)]
  "greenfields":return [w.furn("desk",760,458),w.furn("lamp",690,465),w.furn("tea_table",450,520),w.furn("chair",400,535),w.furn("worktable",1440,510)]
  "room:wayfarer":return [w.furn("bed",BED.x,BED.y),w.furn("hearth",440,335),w.furn("tea_table",650,450),w.furn("chair",600,465),w.furn("chair",700,465),w.furn("bookcase",700,335),w.furn("bookcase",630,335),w.furn("lamp",350,395),w.furn("counter",400,500),w.furn("desk",245,550),w.furn("chair",245,585)]
  "room:greenhearth":return [w.furn("hearth",330,335),w.furn("tea_table",550,450),w.furn("chair",500,465),w.furn("chair",600,465),w.furn("worktable",700,350),w.furn("bookcase",250,335),w.furn("bookcase",630,335),w.furn("counter",350,450),w.furn("bed",250,550),w.furn("lamp",300,520),w.furn("chair",550,400)]
 return []
func obstacles(area:String)->Array:
 var result=[]
 for b in buildings(area):
  result.append(HoldBuildingArt.footprint(b))
 for f in furnishings(area):result.append(s.world.furn_footprint(f))
 if area=="greenfields":
  for y in [585,735]:
   for x in [1140,1320,1500]:result.append(Rect2(Vector2(x,y)-Vector2(35,25),Vector2(70,28)))
 return result
func people(area:String,time:float=-1)->Array:
 if time<0:time=g.state.elapsed
 var result=[]
 for i in FOLK.size():
  var f=FOLK[i]
  if area!=f.area:continue
  var key=str(g.state.seed_value)+":"+str(i)
  if not profiles.has(key):profiles[key]=HoldAppearance.random_profile(g.state.seed_value+7500+i,f.gender)
  var duration=f.a.distance_to(f.b)/38.0;var phase=fposmod(time+i*9,(duration+7)*2)
  var start:Vector2=f.a;var end:Vector2=f.b
  if phase>duration+7:phase-=duration+7;start=f.b;end=f.a
  var walking=phase<duration;var at=start.lerp(end,minf(1,phase/duration))
  result.append({"kind":"citizen","p":at,"profile":profiles[key],"aim":(end-start).normalized(),"walking":walking,"gait":HoldDrawnLocomotion.time_for_distance(phase*38),"name":f.name+" "+profiles[key].family_name,"role":f.role,"index":i,"interaction":"road_folk:"+str(i)})
 return result
func points()->Array:
 var result=[]
 if s.area in ORDERS:
  var order=ORDERS[s.area]
  result.append({"p":order.p,"name":"Local work board","action":"road_order"})
 if s.area=="trail":result.append(s.spot(510,545,"Wayfarer's Hearth","room:wayfarer"));result.append(s.spot(1540,920,"Greenhearth fields","greenfields"))
 if s.area=="greenfields":result.append(s.spot(940,250,"High Trail · Stonebridge","trail"));result.append(s.spot(550,475,"Greenhearth farmhouse","room:greenhearth"))
 if s.area=="room:wayfarer":result.append({"p":HoldFurnishings.bedside(BED),"name":"Wayfarer's bunk · rest and save","action":"rest","bed":BED})
 if s.area in ROOMS:result.append(s.spot(400 if s.area=="room:wayfarer" else 350,525 if s.area=="room:wayfarer" else 475,"Hearth kitchen · cook provisions","road_kitchen"))
 for person in people(s.area):result.append({"p":person.p,"name":person.name+" · "+person.role,"action":person.interaction})
 return result
func speak(index:int):
 for person in people(s.area):
  if person.index==index and g.player.distance_to(person.p)<85:
   HoldConversation.start(g,person.interaction);return
func board_near()->bool:return s.area in ORDERS and g.player.distance_to(ORDERS[s.area].p)<90 and s.clear_interaction(g.player,ORDERS[s.area].p)
func deliver()->bool:
 if not board_near():return false
 var order=ORDERS[s.area];var day=int(g.state.elapsed/600.0);var d=data()
 if int(d.orders.get(s.area,-1))==day:return false
 if not g.state.pay({order.item:order.count}):return false
 d.orders[s.area]=day;g.state.money+=order.pay;g.save_game();g.notify("Delivered · %d crowns paid. The next order arrives after the next workday." % order.pay);return true
func lease()->bool:
 if s.area!="greenfields" or not board_near() or data().allotment or g.state.money<12:return false
 g.state.money-=12;data().allotment=true
 var d=g.fieldwork.data()
 for p in [Vector2(400,650),Vector2(550,650),Vector2(400,800),Vector2(550,800)]:
  d.beds.append({"id":int(d.next),"claim":"","area":"greenfields","x":p.x,"y":p.y,"planted":false,"watered":false,"at":0.0});d.next=int(d.next)+1
 g.save_game();return true
func panel():
 if not board_near():g.label(g.panel_body,"Walk to the local board to arrange work.",16);return
 var order=ORDERS[s.area];var complete=int(data().orders.get(s.area,-1))==int(g.state.elapsed/600.0)
 g.label(g.panel_body,order.name,23)
 g.label(g.panel_body,"Deliver %d %s from your pack · %d crowns. One order per ten minutes of world time; no deadline." % [order.count,HoldData.ITEMS[order.item].name.to_lower(),order.pay],16)
 g.label(g.panel_body,"Fulfilled this workday." if complete else "In your pack: %d / %d" % [g.state.count(order.item),order.count],16)
 if not complete:g.button(g.panel_body,"Deliver the order",func():deliver();g.open_panel("road_order",false)).disabled=g.state.count(order.item)<order.count
 if s.area=="greenfields":
  g.label(g.panel_body,"The four plots beside the lane are available for your own crops. The eastern beds belong to the farm.",16)
  if not data().allotment:g.button(g.panel_body,"Lease four garden beds · 12 crowns once",func():lease();g.open_panel("road_order",false)).disabled=g.state.money<12
  else:g.label(g.panel_body,"Your allotment is yours permanently. Plant, water and harvest with E using your field tools.",16)
  g.button(g.panel_body,"Field tools & growing guide",func():g.open_panel("fieldwork"))
 elif s.area=="pinewood":g.label(g.panel_body,"The loan saw and timber rack stand in the southern yard. Use your own logs; fixed equipment stays here.",16)
 else:g.label(g.panel_body,"Old Workings and the loan breaker lie north. A bunk is inside the Wayfarer's Hearth. Fishing lies along the west riverbank.",16)
func cook(id:String)->bool:
 if id not in ["turnip_stew","trout_supper"]+HoldHearth.MEALS.keys() or s.area not in ROOMS:return false
 var at=Vector2(400,525) if s.area=="room:wayfarer" else Vector2(350,475)
 if g.player.distance_to(at)>75 or not s.clear_interaction(g.player,at):return false
 if not g.state.craft(id):return false
 g.save_game();return true
func kitchen_panel():
 g.hearth.cooking_panel()
func ground():
 if s.area=="greenfields":
  for y in [585,735]:
   for x in [1140,1320,1500]:g.fieldwork.sprite(4,Vector2(x,y),86)
  if not data().allotment:
   for p in [Vector2(400,650),Vector2(550,650),Vector2(400,800),Vector2(550,800)]:g.fieldwork.sprite(3,p,86)
