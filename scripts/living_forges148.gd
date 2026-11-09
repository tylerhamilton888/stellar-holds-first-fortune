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
 # Leather folds move only during the smith's working beats; the feet stay fixed.
 var working=g.state.opening>=2 and fposmod(g.clock,12)<3.2
 var lift=3+3*sin(g.clock*TAU/1.6) if working else 2.0
 var top=p+Vector2(0,-24-lift)
 var outline=PackedVector2Array([p+Vector2(-24,-5),p+Vector2(24,-5),top+Vector2(21,0),top+Vector2(-21,0)])
 g.draw_colored_polygon(outline,Color("584233"))
 for i in 4:
  var y=lerpf(-7,-24-lift,float(i)/4)
  g.draw_line(p+Vector2(-22,y),p+Vector2(22,y),Color("30271f"),2)
 g.draw_line(top+Vector2(-23,0),top+Vector2(23,0),Color("a27a48"),5)
 g.draw_line(p+Vector2(-25,-3),p+Vector2(25,-3),Color("8a623b"),5)
 g.draw_line(p+Vector2(23,-12),p+Vector2(42,-12),Color("ad8b55"),5)
 for x in [-19,19]:g.draw_line(p+Vector2(x,-4),p+Vector2(x,0),Color("393632"),5)

static func sound_context(g)->String:
 if not workshop(g):return g.room_id if g.surface.room() else g.zone
 if g.state.opening<2:return "forge_cold"
 return "forge" if g.surface.area=="room:forge" or HoldForge147.active(g) or not g.state.queue.is_empty() else "forge_cold"
