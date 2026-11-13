class_name HoldEstateCellar
extends RefCounted
# A connection between existing owners, never a second inventory or mine.
const COST={"wood":4,"stone":2}
const CROSS=[Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]
static func home(g)->Dictionary:
 return g.state.surface.get("homes",{}).get(g.state.claim_id,{}) if g.state.claim_id!="" else {}
static func plans(g)->Array:return home(g).get("building",{}).get("cellars156",[])
static func here(g)->bool:
 return g.state.active_site=="claim" and g.state.claim_id!="" and ((g.surface.active() and g.surface.area=="claim" and g.surface.house.level()==0) or (g.zone=="mine" and g.deep.world.depth()==0))
static func cell(r:Dictionary)->Vector2i:return Vector2i(r.x,r.y)
static func at_cell(g,c:Vector2i)->Dictionary:
 for r in plans(g):
  if cell(r)==c:return r
 return {}
static func protected(g,c:Vector2i)->bool:
 for r in plans(g):
  if r.get("built",false) and c-cell(r) in CROSS:return true
 return false
static func surface_problem(g,c:Vector2i)->String:
 # A cold load inside the mine has no active surface scene. Query the claim,
 # then restore transient presentation state without saving or transitioning.
 var previous=g.surface.area;g.surface.area="claim"
 var result=claim_problem(g,c)
 g.surface.area=previous
 return result
static func claim_problem(g,c:Vector2i)->String:
 var h=g.surface.house
 for d in CROSS:
  var n=c+d;var p=Deepworks.center(n);var t=h.tiles(0).get(h.key(n),{})
  if not g.surface.claim_ground(p) or p.y<320:return "Keep the five-tile landing on your building grounds."
  if not t.has("floor") or t.get("wall","")!="":return "Build five clear floor tiles around the surface landing."
  if h.link_at(n,0):return "Keep cellar landings separate from upstairs stairwells."
  var rect=Rect2(Vector2(n)*40,Vector2(40,40)).grow(5)
  for obstacle in g.surface.base_obstacles()+g.surface.architecture.obstacles("claim"):
   if rect.intersects(obstacle):return "Clear the surface landing's structures and trees."
  for list in [g.state.surface.chests.values(),g.state.surface.decor]:
   for o in list:
    if o.area=="claim" and int(o.get("z",0))==0 and rect.intersects(HoldFurnishings.footprint(o.get("kind","chest"),Vector2(o.x,o.y))):return "Move furnishings and storage off the surface landing."
  for f in g.handworks.data().facilities:
   if f.area=="surface:claim:0" and p.distance_to(g.handworks.pos(f))<60:return "Move equipment off the surface landing."
  for bed in g.state.surface.get("fieldwork",{}).get("beds",[]):
   if bed.get("area","")!="greenfields" and bed.get("claim","")==g.state.claim_id and rect.intersects(Rect2(Vector2(bed.x,bed.y)-Vector2(35,25),Vector2(70,28))):return "Move the cellar plan clear of the garden bed."
 return ""
static func mine_problem(g,c:Vector2i)->String:
 var w=g.deep.world
 for d in CROSS:
  var n=c+d
  if w.at(n,0)!=0:return "Excavate all five lower landing tiles through the existing mine entrance."
  if not w.walkable(n,0) or HoldMineworks143.reserved(w,n,0):return "Clear the lower landing's obstructions."
  if w.can_descend(n,0):return "Keep cellar landings separate from deeper stairs."
 if w.route(Deepworks.ENTRY,0,"",c).is_empty():return "Connect the lower landing to the mine entrance."
 return ""
static func plan(g)->bool:
 if not here(g):return false
 var c=Deepworks.cell(g.player)
 if not at_cell(g,c).is_empty():g.notify("This cellar stair is already planned.");return false
 if plans(g).size()>=16:g.notify("This holding already has 16 cellar connections; existing stairs are preserved.");return false
 for r in plans(g):
  if cell(r).distance_to(c)<3:g.notify("Give each stairwell its own landing.");return false
 g.deep.ensure()
 for d in CROSS:
  var n=c+d
  if g.deep.world.at(n,0)==8 or HoldMineworks143.reserved(g.deep.world,n,0) or g.deep.world.landmark_solid(Deepworks.center(n),0):g.notify("Keep the landing inside the mine boundary, clear of faults, adits and landmarks.");return false
  if not g.surface.claim_ground(Deepworks.center(n)) or Deepworks.center(n).y<320:g.notify("Choose a landing beneath the household building grounds.");return false
 var b=home(g).get("building",{})
 if b.is_empty():b=g.surface.house.data()
 if not b.has("cellars156"):b.cellars156=[]
 b.cellars156.append({"x":c.x,"y":c.y,"built":false})
 g.save_game();g.notify("Cellar stair planned at the same X/Y on both levels. Excavate below through your existing mine entrance.");return true
static func fit(g)->bool:
 if not here(g) or g.zone=="mine":return false
 var r=at_cell(g,Deepworks.cell(g.player))
 if r.is_empty() or r.built:return false
 g.deep.ensure();var reason=surface_problem(g,cell(r))
 if reason=="":reason=mine_problem(g,cell(r))
 if reason!="":g.notify(reason);return false
 if not g.state.afford(COST):g.notify("Cellar stairs need "+HoldData.cost_text(COST)+" in your pack.");return false
 g.state.pay(COST);r.built=true;g.save_game();g.sound.effect("build");g.notify("Cellar stairs fitted. Shift+E descends from home; Shift+E returns from below.");return true
static func forget(g)->bool:
 if not here(g):return false
 var r=at_cell(g,Deepworks.cell(g.player))
 if r.is_empty():return false
 if r.built:g.notify("Built cellar stairs stay in place to preserve access. Their guide cannot be removed.");return false
 plans(g).erase(r);g.save_game();g.notify("Unbuilt stair guide removed; all excavation and possessions remain.");return true
static func travel(g)->bool:
 if not here(g):return false
 var r=at_cell(g,Deepworks.cell(g.player))
 if r.is_empty() or not r.built:return false
 g.deep.ensure()
 var cart=g.deep.haul.cart()
 if not g.handworks.attached().is_empty() or (g.zone=="mine" and not cart.is_empty() and cart.get("hitched",false)):
  g.notify("Park the cart [C] before using the cellar stair. Carried supplies can travel with you.");return true
 var reason=surface_problem(g,cell(r))
 if reason=="":reason=mine_problem(g,cell(r))
 if reason!="":g.notify(reason);return true
 var p=Deepworks.center(cell(r))
 if g.zone=="mine":
  g.deep.remember();g.surface.enter("claim",p)
 else:
  g.surface.remember();g.change_zone("mine");g.player=p;g.deep.world.data.depth=0;g.deep.remember();g.deep.world.survey(p);g.camera=g.deep.camera_target()
 g.velocity=Vector2.ZERO;g.walking_pose=false;g.save_game();g.notify("Home · ground floor" if g.zone!="mine" else "Your cellar · below the household grounds");return true
static func panel(g):
 if not here(g):return
 g.label(g.panel_body,"HOME & CELLAR · aligned stairwells",20)
 g.label(g.panel_body,"Ground floor above; your claim's Lamplight Galleries below. Coordinates line up tile for tile. Plan at your feet, mine the lower landing through existing access, then fit from the surface.",14)
 var row=g.row(g.panel_body)
 g.button(row,"Plan cellar stair here",func():plan(g);g.refresh_panel())
 g.button(row,"Fit cellar stair · "+HoldData.cost_text(COST),func():fit(g);g.refresh_panel()).disabled=g.zone=="mine"
 g.button(row,"Remove unbuilt guide",func():forget(g);g.refresh_panel())
 for r in plans(g):
  var label="Connected" if r.built else "Planned"
  g.label(g.panel_body,"(%d, %d) · Ground ↔ cellar · %s" % [r.x,r.y,label],15)
 g.label(g.panel_body,"Shift+E at either landing travels between home and cellar. Carried supplies retain their owner; storage stays where you place it. Assign crew beds in this book to connect household rest with mine work. Carts and automated freight do not cross this stair.",14)
static func draw(g):
 if not here(g):return
 for r in plans(g):
  var c=cell(r);var p=Deepworks.center(c)
  if g.zone=="mine" and not g.deep.world.layer(0).seen.has(Deepworks.key(c)):continue
  if r.built:g.surface.world.detail(5,p+Vector2(0,19),40,38)
  else:
   for d in CROSS:g.draw_rect(Rect2(Vector2(c+d)*40,Vector2(40,40)).grow(-3),Color("d4bd79"),false,2)
static func prompt(g)->String:
 if here(g) and at_cell(g,Deepworks.cell(g.player)).get("built",false):return "Cellar stair · Shift+E "+("return home" if g.zone=="mine" else "descend")
 return ""
static func draw_map(canvas,g):
 if not here(g):return
 for r in plans(g):
  if g.zone=="mine" and not g.deep.world.layer(0).seen.has(Deepworks.key(cell(r))):continue
  for d in CROSS:canvas.draw_rect(Rect2(Vector2(cell(r)+d)*40,Vector2(40,40)).grow(-3),Color("cde5bd") if r.built else Color("e9c982"),false,5)

static func reserved(state,c:Vector2i,z:int)->bool:
 if state.active_site!="claim" or z!=0 or state.claim_id=="":return false
 var records=state.surface.get("homes",{}).get(state.claim_id,{}).get("building",{}).get("cellars156",[])
 for r in records:
  if r.get("built",false) and c-cell(r) in CROSS:return true
 return false
static func overlaps(g,rect:Rect2)->bool:
 if not here(g):return false
 for r in plans(g):
  if not r.get("built",false):continue
  for d in CROSS:
   if rect.intersects(Rect2(Vector2(cell(r)+d)*40,Vector2(40,40))):return true
 return false
