class_name HoldClaimYard
extends RefCounted

const CartBank = preload("res://scripts/claim_cart_bank.gd")
const ROOT="res://assets/claim_yard/"
const ROWAN=preload(ROOT+"rowan.png")
const SLATE=preload(ROOT+"slate.png")
const BANK=preload(ROOT+"bank.png")
const FLOWERS = preload("res://assets/cottage_timber/flowers.png")
const GRASS=preload(ROOT+"grass.png")
const WEAR=preload(ROOT+"wear.png")
const CURLS=preload(ROOT+"curls.png")
const PATH_ART = preload("res://scripts/yard_slate.gd")
const APPROACH = preload("res://assets/timber_wing/claim_path.gd")
const RAIL=preload(ROOT+"toolrail.png")
const LAWN=[
 preload(ROOT+"lawn-0-0.webp"),preload(ROOT+"lawn-0-1.webp"),preload(ROOT+"lawn-0-2.webp"),preload(ROOT+"lawn-0-3.webp"),
 preload(ROOT+"lawn-1-0.webp"),preload(ROOT+"lawn-1-1.webp"),preload(ROOT+"lawn-1-2.webp"),preload(ROOT+"lawn-1-3.webp")]
const TREE=Vector2(2778,1035)
const RIDGE=Vector2(2590,934)
const TRUNK=Rect2(2765,1019,26,19)
const ROCK=Rect2(2516,910,148,24)
const PLOT=Rect2(1900,790,1020,580)
const VERGE = [Vector2(1950, 866), Vector2(2024, 854), Vector2(2113, 859), Vector2(2536, 859), Vector2(2645, 876), Vector2(2704, 901), Vector2(2830, 950), Vector2(2835, 1000), Vector2(2820, 1072), Vector2(1946, 1248), Vector2(2008, 1270), Vector2(2112, 1300), Vector2(2380, 1308), Vector2(2485, 1322), Vector2(2800, 1315), Vector2(2074, 1142), Vector2(2512, 1144), Vector2(2764, 1148)]
const FLOWERING_VERGE = [Vector2(2024, 854), Vector2(2645, 876), Vector2(2830, 950), Vector2(1946, 1248), Vector2(2112, 1300), Vector2(2485, 1322), Vector2(2074, 1142), Vector2(2512, 1144), Vector2(2764, 1148)]
const SHORE=[Vector2(1883,997),Vector2(1892,1048),Vector2(1901,1096)]
const LIFE=600.0
const LABELS={"cut":"Cut tall grass","pave":"Lay stone path","lift":"Lift path stone","fell":"Fell rowan","sweep":"Rake work patch"}

static func here(g)->bool:
 return g.zone!="mine" and HoldTimberWing.seeded(g) and g.surface.house.level()==0

static func data(g)->Dictionary:
 var home:Dictionary=g.state.surface.homes[g.state.claim_id]
 if not home.has("yard"):
  var yard={"rowan":true,"ridge":true,"cuts":{},"paths":{},"wear":{}}
  # A returning player may already have built in one of the new landmark positions.
  for feature in ["rowan","ridge"]:
   var area:Rect2=TRUNK if feature=="rowan" else ROCK
   for point in g.surface.house.tiles():
    if area.intersects(Rect2(Vector2(g.surface.house.coords(point))*40,Vector2(40,40))):yard[feature]=false
   for solid in g.surface.architecture.obstacles("claim"):
    if area.intersects(solid):yard[feature]=false
   var placed=g.state.surface.decor+g.state.surface.chests.values()
   for thing in placed:
    if g.surface.house.local(thing) and area.grow(46).has_point(Vector2(thing.x,thing.y)):yard[feature]=false
   for f in g.handworks.data().facilities:
    if g.handworks.local(f) and area.grow(55).has_point(g.handworks.pos(f)):yard[feature]=false
   for bed in g.fieldwork.data().beds:
    if g.fieldwork.local(bed) and area.grow(46).has_point(g.fieldwork.pos(bed)):yard[feature]=false
  home.yard=yard
 return home.yard

static func key(p:Vector2)->String:return "%d,%d"%[roundi(p.x),roundi(p.y)]
static func location(k:String)->Vector2:
 var pair=k.split(",")
 return Vector2(int(pair[0]),int(pair[1]))

static func obstacles(g)->Array:
 if not here(g):return []
 var d=data(g)
 var solids=[]
 if d.rowan:solids.append(TRUNK)
 if d.ridge:solids.append(ROCK)
 return solids

static func sprites(g)->Array:
 if not here(g):return []
 var d=data(g)
 var objects=[]
 if d.rowan:objects.append({"kind":"yard_landmark","p":TREE,"texture":ROWAN,"width":225.0})
 if d.ridge:objects.append({"kind":"yard_landmark","p":RIDGE,"texture":SLATE,"width":187.0})
 return objects

static func sprite(g,t:Texture2D,p:Vector2,width:float,modulate:Color=Color.WHITE):
 var size=Vector2(width,width*t.get_height()/t.get_width())
 g.draw_texture_rect(t,Rect2(p-Vector2(width*.5,size.y),size),false,modulate)

static func clear_wear(g,p:Vector2):
 if not here(g):return
 var wear:Dictionary=data(g).wear
 for k in wear.keys():
  if location(k).distance_to(p)<60:wear.erase(k)

static func prepare_bed(g,p:Vector2):
 if not here(g):return
 clear_wear(g,p)
 var d=data(g)
 for grass in VERGE:
  if absf(grass.x-p.x)<57 and absf(grass.y-p.y)<38:d.cuts[key(grass)]=true

static func sawed(g,p:Vector2):
 if not here(g) or not PLOT.has_point(p):return
 var wear:Dictionary=data(g).wear
 for k in wear.keys():
  if g.state.elapsed-float(wear[k])>=LIFE:wear.erase(k)
 wear[key(p)]=g.state.elapsed

static func clipped(d,p:Vector2)->bool:return d.cuts.has(key(p)) or d.paths.has(key(p.snapped(Vector2(40,40))))

static func action_target(g,mode:String,p:Vector2)->Vector2:
 if mode=="fell":return TREE if TREE.distance_to(p)<85 else Vector2.INF
 var radius=67.0
 var best=Vector2.INF
 if mode=="cut":
  for grass in VERGE:
   var distance=p.distance_to(grass)
   if distance<radius and not clipped(data(g),grass):best=grass;radius=distance
  return best
 if mode=="sweep":
  for k in data(g).wear:
   var point=location(k);var distance=p.distance_to(point)
   if distance<radius and g.state.elapsed-float(data(g).wear[k])<LIFE:best=point;radius=distance
  return best
 return p.snapped(Vector2(40,40))

static func valid(g,mode:String,p:Vector2)->bool:
 if not here(g) or g.surface.house.view.inside() or not PLOT.has_point(p) or g.player.distance_to(p)>145:return false
 var d=data(g)
 match mode:
  "fell":return p==TREE and d.rowan
  "sweep":return d.wear.has(key(p))
  "cut":return VERGE.has(p) and not clipped(d,p)
  "lift":return d.paths.has(key(p))
  "pave":
   if d.paths.has(key(p)) or not g.state.afford({"stone": 1}) or APPROACH.on_cart_lane(p) or p.distance_to(APPROACH.porch_point(p)) < 30 or p.distance_to(HoldTimberWing.THRESHOLD) < 52: return false
   var rect=Rect2(p-Vector2(19,19),Vector2(38,38))
   for q in [rect.position,rect.end,Vector2(rect.position.x,rect.end.y),Vector2(rect.end.x,rect.position.y)]:
    if not g.surface.claim_ground(q):return false
   for solid in g.surface.obstacles():
    if solid.grow(7).has_point(p): return false
   for tile in g.surface.house.tiles():
    if rect.intersects(Rect2(Vector2(g.surface.house.coords(tile))*40,Vector2(40,40))):return false
   return true
 return false

static func apply(g,mode:String,click:Vector2)->bool:
 if not here(g) or not LABELS.has(mode):return false
 var p=action_target(g,mode,click)
 if not valid(g,mode,p):g.notify("Stand near a clear target on your cottage grounds.");return false
 var d=data(g)
 match mode:
  "fell":
   d.rowan=false;g.state.add("wood",4);g.notify("Rowan felled. Recovered 4 wood.")
  "cut":d.cuts[key(p)]=true
  "sweep":clear_wear(g,p)
  "pave":
   if not g.state.pay({"stone":1}):return false
   d.paths[key(p)]=true;clear_wear(g,p)
  "lift":d.paths.erase(key(p));g.state.add("stone",1)
 g.save_game()
 return true

static func begin(g,mode:String):
 g.surface.cancel_placement();g.handworks.placing="";g.fieldwork.placing=false
 g.surface.placing="yard:"+mode;g.close_panel()
 g.notify(LABELS[mode]+" · Click nearby ground. Right click to finish.")

static func menu(g):
 g.label(g.panel_body,"Cottage grounds",22)
 g.label(g.panel_body,"Choose a job, then click a spot within reach. Right click to finish.",15)
 g.small_button(g.panel_body,"Garden beds and seeds",func():g.open_panel("fieldwork"))
 CartBank.menu(g)
 for mode in LABELS:
  var title:String=LABELS[mode]
  if mode=="pave":title+=" · 1 stone per tile"
  if mode=="lift":title+=" · recover 1 stone"
  if mode=="fell":title+=" · 4 wood"
  if mode!="fell" or data(g).rowan:g.small_button(g.panel_body,title,func():begin(g,mode))

static func preview(g,mode:String):
 if not here(g):return
 var aim:Vector2=g.world_mouse();var p=action_target(g,mode,aim)
 if p==Vector2.INF:p=aim
 var ok=valid(g,mode,p)
 if mode in ["pave","lift"]:HoldBuildPreview.world_grid(g.surface,40,p)
 if mode == "pave" and ok: PATH_ART.draw(g, p, data(g).paths, 0.78)
 HoldBuildPreview.outline(g,Rect2(p-Vector2(20,20),Vector2(40,40)),ok)

static func ground(g,cam:Vector2):
 if not here(g):return
 var view=Rect2(cam,Vector2(960,540))
 if not view.intersects(PLOT.grow(200)):return
 for i in LAWN.size():
  var start=Vector2(1865+(i%4)*308,714+floori(i/4.0)*396)
  if view.intersects(Rect2(start,Vector2(308,396))):g.draw_texture(LAWN[i],start)
 var d=data(g)
 for facility in g.handworks.data().facilities:
  if facility.kind not in ["saw", "timber_pile"] or not g.handworks.local(facility):
   continue
  var foot: Vector2 = g.handworks.pos(facility)
  if view.grow(65).has_point(foot):
   var size = Vector2(100, 28) if facility.kind == "saw" else Vector2(89, 23)
   g.draw_texture_rect(WEAR, Rect2(foot - Vector2(size.x / 2, size.y * 0.75), size), false, Color(0.37, 0.33, 0.23, 0.61))
 for k in d.paths:
  var tile = location(k)
  if view.grow(65).has_point(tile): PATH_ART.draw(g, tile, d.paths)
 for i in VERGE.size():
  var grass:Vector2=VERGE[i]
  if not clipped(d,grass):
   var sway=sin(g.clock*1.1+i*1.7)*1.4
   if FLOWERING_VERGE.has(grass):
    sprite(g, FLOWERS, grass + Vector2(sway, 0), 31 + (i % 3) * 6)
   else:
    sprite(g, GRASS, grass + Vector2(sway, 0), 49 + (i % 3) * 11, Color(0.91, 0.96, 0.8))
 for k in d.wear:
  var p=location(k)
  var alpha=clampf(1.0-(g.state.elapsed-float(d.wear[k]))/LIFE,0,1)
  if alpha>0:
   if not d.paths.has(key(p.snapped(Vector2(40,40)))):sprite(g,WEAR,p+Vector2(0,22),115,Color(1,1,1,alpha*.8))
   sprite(g,CURLS,p+Vector2(-20,7),26,Color(1,1,1,alpha))
 if d.rowan:
  g.draw_set_transform(TREE-cam,.12,Vector2(1,.28))
  g.draw_texture_rect(ROWAN,Rect2(-65,0,190,195),false,Color(.12,.14,.15,.23))
  g.draw_set_transform(-cam)

static func shore(g):
 if not here(g):return
 for i in SHORE.size():sprite(g,BANK,SHORE[i],48+i*6)
