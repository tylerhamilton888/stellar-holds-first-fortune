class_name HoldLivingForges148
extends RefCounted
# Templates affect new buildings only. Saved instance rooms and furniture own their geometry.
static func contents(w,source:String)->Array:
 var communal=source=="room:communal148"
 var specs=[
  ["anvil",580.475,445.7],["worktable",800,450],["worktable",800,620],
  ["chest",910,520],["chest",910,620],["training_rack",865,345],
  ["barrel",240,510],["crate",245,640],["crate",310,640],
  ["lamp",200,310],["lamp",940,310],["bookcase",690,335]] if communal else [
  ["hearth",350,365],["anvil",500,405],["worktable",610,500],
  ["chest",700,365],["training_rack",230,560],["barrel",360,450],
  ["crate",230,450],["lamp",200,310],["lamp",760,310]]
 var out=[]
 for spec in specs:out.append(w.furn(spec[0],spec[1],spec[2]))
 return out

static func workshop(g)->bool:
 if g==null or g.surface==null:return false
 return HoldBuildingPlans.template(g.surface.area) in ["room:forge","room:workshop148","room:communal148"]

static func furniture(g)->Array:
 var out=[]
 for o in g.surface.world.room_objects(g.surface.area):
  if o.kind=="furnishing":out.append({"kind":o.furnishing,"p":o.p})
 for d in g.state.surface.decor:
  if g.surface.house.local(d):out.append({"kind":d.kind,"p":Vector2(d.x,d.y)})
 return out

static func points(g)->Array:
 if not workshop(g) or HoldForge147.active(g):return []
 var owned=HoldBuildingPlans.owned_room(g.surface.area)
 if owned and not g.hearth.own_home():return []
 var out=[];var things=furniture(g)
 for f in things:
  var station={"hearth":"smelt","anvil":"tools","worktable":"craft","pressure_manifold":"industry"}.get(f.kind,"")
  if station=="":continue
  if owned and station!="industry":
   var paired=false
   for other in things:
    if ((f.kind=="hearth" and other.kind in ["anvil","worktable"]) or (f.kind in ["anvil","worktable"] and other.kind=="hearth")) and f.p.distance_to(other.p)<=300:paired=true;break
   if not paired:continue
  out.append(g.surface.spot(f.p.x,f.p.y+38,{"smelt":"Furnace · smelt ore","tools":"Anvil · tools and equipment","craft":"Workbench · fittings and parts","industry":"Industry · production"}[station],"living148:"+station))
  if station=="craft" and g.state.tech.has("automation"):
   out.append(g.surface.spot(f.p.x+48,f.p.y+38,"Industry plans · production","living148:industry"))
 return out

static func use(g,id:String):
 # A stale prompt cannot operate a workshop from elsewhere.
 for p in points(g):
  if p.action==id and g.player.distance_to(p.p)<110 and g.surface.clear_interaction(g.player,p.p):
   g.forge_tab={"smelt":0,"craft":1,"tools":2,"industry":3}[id.trim_prefix("living148:")]
   g.open_panel("forge");return

static func stock(g,p:Vector2,kind:String):
 if not workshop(g):return
 if kind=="crate":
  var item="coal" if p.x<290 else "iron_ore"
  HoldItemArt.draw(g,Rect2(p+Vector2(-14,-40),Vector2(28,22)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
 if kind=="worktable":
  HoldItemArt.draw(g,Rect2(p+Vector2(-24,-35),Vector2(22,16)),HoldItemArt.item_index("iron"))
  HoldItemArt.draw(g,Rect2(p+Vector2(4,-34),Vector2(20,16)),HoldItemArt.item_index("parts"))
  if g.state.tech.has("automation"):
   HoldItemArt.draw(g,Rect2(p+Vector2(30,-36),Vector2(18,18)),HoldItemArt.item_index("copper"))

static func bellows(g,p:Vector2):
 # A tapered leather bag under a wooden paddle, viewed from above like the hearth.
 # The nozzle and feet stay fixed while the rear of the bag compresses.
 var working=g.state.opening>=2 and fposmod(g.clock,12)<3.2
 var lift=3+3*sin(g.clock*TAU/1.6) if working else 2.0
 var left=p+Vector2(-23,-17-lift);var tip=p+Vector2(23,-14)
 g.draw_line(p+Vector2(21,-12),p+Vector2(42,-12),Color("302c28"),7)
 g.draw_line(p+Vector2(22,-14),p+Vector2(42,-14),Color("b4935a"),3)
 for x in [-19,16]:
  g.draw_line(p+Vector2(x,-7),p+Vector2(x,0),Color("342d26"),5)
  g.draw_line(p+Vector2(x-1,-6),p+Vector2(x-1,-1),Color("80603e"),1)
 var bag=PackedVector2Array([left+Vector2(-2,1),left+Vector2(4,-7),tip+Vector2(1,0),tip+Vector2(0,8),p+Vector2(-19,-3),p+Vector2(-25,-9)])
 g.draw_colored_polygon(bag,Color("30231d"));g.draw_polyline(bag+PackedVector2Array([bag[0]]),Color("201b18"),1.5,true)
 for i in 4:
  var t=float(i)/4
  var rear=left.lerp(p+Vector2(-23,-5),t)
  var front=tip.lerp(p+Vector2(22,-7),t)
  g.draw_polyline(PackedVector2Array([rear+Vector2(0,-2),rear+Vector2(4,2),front]),Color("795139") if i%2==0 else Color("493125"),2,true)
 var top=PackedVector2Array([left+Vector2(-2,-2),left+Vector2(3,-11),left+Vector2(19,-13),tip+Vector2(0,-3),tip+Vector2(-2,1),left+Vector2(5,2)])
 g.draw_colored_polygon(top,Color("765333"));g.draw_polyline(top+PackedVector2Array([top[0]]),Color("2a211a"),1.5,true)
 g.draw_polyline(PackedVector2Array([top[0]+Vector2(1,0),top[1]+Vector2(1,1),top[2]+Vector2(0,1),top[3]]),Color("b18a54"),1,true)
 for i in 3:
  var start=left+Vector2(5+i*5,-8)
  g.draw_line(start,tip+Vector2(-5,-3+i),Color("5d4028"),.7,true)
 g.draw_line(left+Vector2(8,-2),left+Vector2(10,-10),Color("39352c"),3,true)
 for q in [left+Vector2(8,-2),left+Vector2(10,-10),tip+Vector2(-4,-2)]:
  g.draw_circle(q,1.5,Color("c19a58"));g.draw_circle(q+Vector2(-.3,-.4),.6,Color("e0bf7e"))

static func sound_context(g)->String:
 if not workshop(g):return g.room_id if g.surface.room() else g.zone
 if g.state.opening<2:return "forge_cold"
 return "forge" if g.surface.area=="room:forge" or HoldForge147.active(g) or not g.state.queue.is_empty() else "forge_cold"
