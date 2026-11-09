class_name HoldForge147
extends RefCounted
# Stonebridge's public forge keeps its existing saved room, furnishings and stores.
# These additions are town fixtures; they never create inventory or replace a save.
const FORGE=preload("res://assets/forge147/cold-forge.png")
const FORGE_CROP=Rect2(170,115,1194,810)
const FORGE_SIZE=Vector2(174,118)
const FORGE_BASE=Rect2(-68,-27,136,27)
const ANVIL=Vector2(580.475,445.7)
const BORIN=Vector2(620,410)
const BORIN_TALK=Vector2(650,455)
const SMELTING=["iron","copper","iron_slag","copper_slag","scrap_iron","shell_iron"]
const DECOR=[
 ["barrel",Vector2(250,470),""],["barrel",Vector2(250,525),""],
 ["crate",Vector2(260,615),"coal"],["crate",Vector2(315,615),"iron_ore"],
 ["training_rack",Vector2(875,370),""],["crate",Vector2(870,445),"parts"],
 ["barrel",Vector2(1110,420),""],
 ["crate",Vector2(1105,590),"iron"],["barrel",Vector2(1105,645),""],
 ["crate",Vector2(900,840),"parts"],["training_rack",Vector2(1080,835),""]]
static func active(g)->bool:
 return g!=null and g.surface!=null and HoldFrontier103.active(g.state) and g.surface.area==HoldFrontier103.room(g.state,"forge")
static func occupied(g)->Array:
 var solids=[]
 for d in g.state.surface.decor:
  if d.area==g.surface.area and int(d.get("z",0))==0:solids.append(HoldFurnishings.footprint(d.kind,Vector2(d.x,d.y)))
 for c in g.state.surface.chests.values():
  if c.area==g.surface.area and int(c.get("z",0))==0:solids.append(HoldFurnishings.footprint("chest",Vector2(c.x,c.y)))
 return solids
static func forge_base(p:Vector2)->Rect2:return Rect2(p+FORGE_BASE.position,FORGE_BASE.size)
static func forge_position(g)->Vector2:
 var solids=occupied(g)
 for p in [Vector2(480,465),Vector2(380,510),Vector2(520,610)]:
  var r=forge_base(p).grow(8);var free=true
  for other in solids:
   if r.intersects(other):free=false;break
  if free:return p
 return Vector2.INF
static func props(g)->Array:
 if not active(g):return []
 var props=[];var solids=occupied(g);var forge=forge_position(g)
 if forge!=Vector2.INF:
  props.append({"kind":"forge147_furnace","p":forge});solids.append(forge_base(forge))
 var exit=HoldRoomLayout.exit_point(g.surface.area)
 for spec in DECOR:
  var p:Vector2=spec[1];var rect=HoldFurnishings.footprint(spec[0],p);var free=not rect.grow(32).has_point(exit)
  for other in solids:
   if rect.grow(8).intersects(other):free=false;break
  if not free:continue
  var o=g.surface.world.furn(spec[0],p.x,p.y)
  if spec[2]!="":o["forge_stock"]=spec[2]
  props.append(o);solids.append(rect)
 return props
static func obstacles(g)->Array:
 var result=[]
 for o in props(g):
  var r=forge_base(o.p) if o.kind=="forge147_furnace" else HoldFurnishings.footprint(o.furnishing,o.p)
  if r.has_area():result.append(r)
 return result
static func has_anvil(g)->bool:
 for d in g.state.surface.decor:
  if d.area==g.surface.area and d.kind=="anvil" and Vector2(d.x,d.y).distance_to(ANVIL)<2:return true
 return false
static func points(g)->Array:
 if not active(g):return []
 var out=[];var p=forge_position(g)
 if p!=Vector2.INF:out.append(g.surface.spot(p.x,p.y+35,"Forge hearth · inspect and smelt","forge147:smelt"))
 if has_anvil(g):
  out.append(g.surface.spot(ANVIL.x,ANVIL.y+38,"Anvil · tools and equipment","forge147:anvil"))
  out.append(g.surface.spot(BORIN_TALK.x,BORIN_TALK.y,"Borin · smith","talk:borin"))
 for d in g.state.surface.decor:
  if d.area==g.surface.area and d.kind=="worktable":
   out.append(g.surface.spot(d.x,d.y+35,"Metalwork bench · fittings and parts","forge147:bench"))
 return out
static func near(g)->bool:
 if not active(g):return false
 for point in points(g):
  if str(point.action).begins_with("forge147:") and g.player.distance_to(point.p)<110 and g.surface.clear_interaction(g.player,point.p):return true
 return false
static func talking(g)->bool:
 return active(g) and has_anvil(g) and g.player.distance_to(BORIN_TALK)<90 and g.surface.clear_interaction(g.player,BORIN_TALK)
static func draw_furnace(g,p:Vector2):
 var rect=Rect2(p-Vector2(FORGE_SIZE.x/2,FORGE_SIZE.y),FORGE_SIZE)
 g.draw_texture_rect_region(FORGE,rect,FORGE_CROP)
 if g.state.opening<2:return
 # The painted coal bed catches a soft, shifting heat instead of flat flames.
 var pulse=.8+.2*sin(g.clock*3.1)
 for i in 3:
  var center=p+Vector2(-30+i*30,-73)
  for layer in 4:
   g.draw_texture_rect(HoldAmbientProps.glow_texture(),Rect2(center-Vector2(25,10),Vector2(50,20)),false,Color(1,.8,.55,pulse))
static func draw_stock(g,o:Dictionary):
 if o.has("forge_stock"):
  HoldItemArt.draw(g,Rect2(o.p+Vector2(-15,-43),Vector2(30,25)),HoldItemArt.item_index(o.forge_stock),HoldItemArt.tint(o.forge_stock))
 elif active(g) and o.furnishing=="worktable":
  HoldItemArt.draw(g,Rect2(o.p+Vector2(-24,-35),Vector2(21,16)),HoldItemArt.item_index("iron"))
  HoldItemArt.draw(g,Rect2(o.p+Vector2(3,-34),Vector2(20,16)),HoldItemArt.item_index("parts"))
static func panel(g):
 var s=g.state;var station=str(g.get_meta("forge147_station","all"))
 var header="Smelting hearth" if station=="smelt" else "Anvil & metalwork" if station in ["anvil","bench"] else "The communal forge"
 g.label(g.panel_body,header,21,Color("edc98a"))
 g.label(g.panel_body,"Use ore and coal here to make ingots." if station=="smelt" else "Shape metal into tools, equipment and useful fittings." if station in ["anvil","bench"] else "Smelt ore at the hearth, then use the anvil or workbenches for tools and fittings.",16)
 var nav=g.row(g.panel_body)
 g.small_button(nav,"Smelting",func():g.set_meta("forge147_station","smelt");g.refresh_panel())
 g.small_button(nav,"Metalwork",func():g.set_meta("forge147_station","anvil");g.refresh_panel())
 g.small_button(nav,"All workshop recipes",func():g.set_meta("forge147_station","all");g.refresh_panel())
 if station!="smelt":
  var tool=g.button(g.panel_body,"Forge steel pick · 5 iron + 2 timber",func():
   if HoldFrontier103.transact(g,"tool","steel"):g.save_game();g.notify("Steel pick forged · stronger contacts and basalt access.");g.refresh_panel())
  tool.disabled=s.opening<2 or s.steel or not s.tech.has("extraction") or not s.afford({"iron":5,"wood":2})
  if not s.steel:g.label(g.panel_body,"First research Tempered steel at Stonebridge's survey desk.",14)
  g.button(g.panel_body,"Forge weapons and armor",func():g.gear_tab="forge";g.open_panel("equipment"))
 for id in HoldData.RECIPES:
  if station=="smelt" and id not in SMELTING:continue
  if station in ["anvil","bench"] and id in SMELTING:continue
  var r=HoldData.RECIPES[id]
  var b=g.button(g.panel_body,r.name+" · "+HoldData.cost_text(r.cost),func():
   if HoldFrontier103.transact(g,"craft",id):g.save_game();g.refresh_panel())
  b.disabled=s.opening<2 or not s.afford(r.cost) or HoldCollections141.recipe_reason(s,id)!="" or s.queue.size()>=12
  if HoldCollections141.recipe_reason(s,id)!="":b.tooltip_text=HoldCollections141.recipe_reason(s,id)
