class_name HoldEstateFreight
extends RefCounted
# Orders reference existing stores. Only the load physically carried by the
# existing crew member is new; neither the pack nor the cart is a remote source.
const LOAD=32
static func orders(g)->Dictionary:
 var b=HoldEstateWorkers.building(g)
 if b.is_empty():return {}
 if not b.has("freight162"):b.freight162={}
 return b.freight162
static func local(g)->bool:return g.state.active_site=="claim" and g.surface.active() and g.surface.area=="claim"
static func endpoint(g,r:Dictionary,above:bool)->Dictionary:
 if above:
  var c=g.state.surface.chests.get(r.get("chest",""),{})
  return c if c.get("area","")=="claim" and not c.get("fixed",false) else {}
 var p=g.deep.haul.data.piles.get(r.get("pile",""),{})
 return p if p.get("marked",false) else {}
static func cargo(e:Dictionary,above:bool)->Dictionary:return e.get("items",{}) if above else e.get("cargo",{})
static func approaches(e:Dictionary,above:bool)->Array:
 if e.is_empty():return []
 if not above:return [HoldEstateWorkers.node(Vector2i(e.x,e.y),int(e.depth),"mine")]
 var result=[];var p=Vector2(e.x,e.y);var c=Deepworks.cell(p)
 for y in range(-2,3):
  for x in range(-2,3):
   var n=c+Vector2i(x,y)
   if Deepworks.center(n).distance_to(p)<=85:result.append(HoldEstateWorkers.node(n,int(e.get("z",0))))
 return result
static func at_target(g,saved:Dictionary,targets:Array)->bool:
 var area=str(saved.get("estate_area160","mine"));var z=int(saved.get("estate_z160",0)) if area=="surface" else int(saved.depth)
 for n in targets:
  if n.area==area and int(n.z)==z and Vector2(saved.x,saved.y).distance_to(Deepworks.center(HoldEstateWorkers.cell(n)))<1 and HoldEstateWorkers.valid_step(g,saved,n):return true
 return false
static func path_to(g,saved:Dictionary,targets:Array)->Array:
 if targets.is_empty():return []
 if targets[0].area=="surface":return HoldEstateWorkers.route(g,saved,{},true,targets)
 if saved.get("estate_area160","mine")=="surface":return HoldEstateWorkers.route(g,saved,{},false)
 var w=g.deep.world;var z=int(saved.depth);var goal=targets[0];var c=Deepworks.cell(Vector2(saved.x,saved.y))
 if z==int(goal.z):return HoldEstateWorkers.mine_steps(w.route(c,z,"",HoldEstateWorkers.cell(goal)).get("path",[]),z)
 var best={};var distance=w.zone_distance(z,int(goal.z),true)
 for link in w.connections(z):
  if w.zone_distance(int(link.to),int(goal.z),true)>=distance or not w.walkable(link.target,int(link.to)):continue
  var r=w.route(c,z,"",link.c)
  if not r.is_empty() and (best.is_empty() or r.path.size()<best.path.size()):best=r;best.link=link
 if best.is_empty():return []
 var path=HoldEstateWorkers.mine_steps(best.path,z);path.append(HoldEstateWorkers.node(best.link.target,int(best.link.to),"mine"));return path
static func assign(g,id:String,pile:String,chest:String,item:String,to_home:bool)->String:
 if not local(g):return "Visit your household grounds to arrange freight."
 if g.state.outpost.get("crew",{}).get(id,{}).get("role","")!="miner":return "Recruit this Dwarf as a miner first."
 if not orders(g).get(id,{}).get("cargo",{}).is_empty():return "Finish or return the carried load before changing this route."
 if not HoldData.ITEMS.has(item):return "Choose a known material."
 g.deep.ensure()
 var r={"pile":pile,"chest":chest,"item":item,"to_home":to_home,"enabled":true,"cargo":{},"returning":false}
 if endpoint(g,r,true).is_empty() or endpoint(g,r,false).is_empty():return "Choose your marked mine stockpile and a household chest."
 if HoldEstateWorkers.stairs(g).is_empty():return "Fit a clear cellar stair before arranging freight."
 orders(g)[id]=r
 for a in g.agents:
  if a.id==id:a.erase("freight_path162");a.erase("estate_path160");a.path=[];a.cool=0
 return "Freight arranged: up to 32 units per trip. Crew use provisions and take their usual rest."
static func stop(g,id:String,return_load:bool=false):
 if not local(g) or not orders(g).has(id):return
 var r=orders(g)[id];r.enabled=false;r.returning=return_load
 for a in g.agents:
  if a.id==id:a.freight_path162=[];a.cool=0
static func walk(g,a:Dictionary,saved:Dictionary,targets:Array,dt:float):
 if a.get("freight_path162",[]).is_empty():
  if a.cool>0:a.status="Freight route blocked";return
  a.cool=.75;a.freight_path162=path_to(g,saved,targets)
  if a.freight_path162.is_empty():a.status="Freight route blocked";return
 var next=a.freight_path162[0]
 if not HoldEstateWorkers.valid_step(g,saved,next):a.freight_path162=[];a.cool=.75;a.status="Freight route blocked";return
 var area=str(saved.get("estate_area160","mine"));var z=int(saved.get("estate_z160",0)) if area=="surface" else int(saved.depth)
 if area!=next.area or z!=int(next.z):
  saved.estate_area160=next.area
  if next.area=="mine":saved.depth=int(next.z)
  else:saved.estate_z160=int(next.z)
  a.p=Deepworks.center(HoldEstateWorkers.cell(next));saved.x=a.p.x;saved.y=a.p.y;a.freight_path162.pop_front();return
 var destination=Deepworks.center(HoldEstateWorkers.cell(next));var step=a.p.move_toward(destination,100*minf(dt,.1))
 if (area=="mine" and g.deep.world.solid(step,z)) or (area=="surface" and HoldEstateWorkers.obstacles(g,z).any(func(rect):return rect.has_point(step))):a.freight_path162=[];a.cool=.75;a.status="Freight route blocked";return
 a.facing=(step-a.p).normalized();a.gait=float(a.get("gait",0))+step.distance_to(a.p)/150.0;a.estate_walking160=step!=a.p
 a.p=step;saved.x=step.x;saved.y=step.y
 if step.distance_to(destination)<1:a.freight_path162.pop_front()
static func tick(g,a:Dictionary,saved:Dictionary,dt:float)->bool:
 if a.type!="worker" or g.state.active_site!="claim":return false
 var r=orders(g).get(a.id,{})
 if r.is_empty():return false
 var loaded=not r.cargo.is_empty()
 if not loaded and (not r.enabled or bool(saved.get("estate_rest160",false)) or fmod(g.state.elapsed,120.0)>=90):a.freight_path162=[];return false
 if not g.deep.works.masonry.data.jobs.get(a.id,{}).get("cargo",{}).is_empty():return false
 a.p=Vector2(saved.x,saved.y);a.work=false;a.path=[];a.target=Vector2i(-1,-1);a.estate_walking160=false;a.erase("estate_path160")
 if g.deep.works.model.data.assignments.has(a.id):g.deep.works.model.data.assignments[a.id].present=""
 if g.panel_id!="" or g.transition_left>0:return true
 var above=bool(r.to_home) if loaded and not r.returning else not bool(r.to_home)
 var e=endpoint(g,r,above)
 if e.is_empty():
  a.status="Freight store missing · return the carried load" if loaded else "Freight store missing · choose a new route"
  a.freight_path162=[];return true
 if a.fuel<=0:
  if not g.state.pay({"food":1}):a.status="Freight waiting for provisions";return true
  a.fuel=12
 var targets=approaches(e,above)
 if not at_target(g,saved,targets):
  a.status="Carrying freight · "+DeepHaul.contents(r.cargo) if loaded else "Walking to freight stock"
  walk(g,a,saved,targets,dt);return true
 a.freight_path162=[]
 if loaded:
  DeepHaul.transfer(r.cargo,cargo(e,above));a.fuel=maxi(0,a.fuel-1);r.returning=false;a.status="Freight delivered";return true
 # Validate both stores again before removing anything from the source.
 if endpoint(g,r,not above).is_empty():a.status="Freight destination missing";return true
 var stock=cargo(e,above);var n=mini(LOAD,maxi(0,int(stock.get(r.item,0))))
 if n==0:a.status="Waiting for "+HoldData.ITEMS[r.item].name;return true
 stock[r.item]=int(stock[r.item])-n
 if int(stock[r.item])==0:stock.erase(r.item)
 r.cargo[r.item]=n;a.status="Freight loaded";return true
static func panel(p):
 var g=p.a.g
 g.label(g.panel_body,"Freight for the household",20)
 g.label(g.panel_body,"Send a miner between a marked mine stockpile and a chest on this floor. Loads travel by foot through clear stairs, up to 32 units per trip. Provisions come from the usual crew supply. Stored goods must still be withdrawn before crafting. Wheelbarrows remain in the mine.",14)
 g.deep.ensure()
 var piles=[];var chests=[];var workers=[]
 for id in g.deep.haul.data.piles:
  if g.deep.haul.data.piles[id].get("marked",false):piles.append(id)
 for id in g.state.surface.chests:
  var c=g.state.surface.chests[id]
  if c.area=="claim" and not c.get("fixed",false) and int(c.get("z",0))==p.level():chests.append(id)
 for a in g.agents:
  if a.type=="worker":workers.append(a.id)
 if piles.is_empty() or chests.is_empty() or workers.is_empty():g.label(g.panel_body,"Recruit a miner, mark a mine stockpile with U away from the entrance/cart, and place a chest on this floor.",14)
 else:
  var row=g.row(g.panel_body);var who=OptionButton.new();row.add_child(who)
  for id in workers:who.add_item(g.state.npc(id).first_name)
  var direction=OptionButton.new();row.add_child(direction);direction.add_item("Mine → home");direction.add_item("Home → mine")
  var material=OptionButton.new();row.add_child(material);var items=HoldData.ITEMS.keys()
  for id in items:material.add_item(HoldData.ITEMS[id].name)
  material.select(maxi(0,items.find("stone")))
  row=g.row(g.panel_body);var source=OptionButton.new();row.add_child(source)
  for id in piles:
   var e=g.deep.haul.data.piles[id];source.add_item("Stockpile · depth %d (%d, %d)" % [int(e.depth)+1,e.x,e.y])
  var dest=OptionButton.new();row.add_child(dest)
  for id in chests:
   var e=g.state.surface.chests[id];dest.add_item("Chest (%d, %d)" % [int(e.x/40),int(e.y/40)])
  g.small_button(g.panel_body,"Arrange freight route",func():
   g.notify(assign(g,workers[who.selected],piles[source.selected],chests[dest.selected],items[material.selected],direction.selected==0));g.save_game();g.refresh_panel())
 for id in orders(g):
  var r=orders(g)[id];var title=g.state.npc(id).first_name+" · "+("mine → home" if r.to_home else "home → mine")+" · "+HoldData.ITEMS.get(r.item,{"name":r.item}).name
  var status="Stopped · regular duties resumed" if not r.enabled and r.cargo.is_empty() else "Waiting for assigned miner"
  for a in g.agents:
   if a.id==id and (r.enabled or not r.cargo.is_empty()):status="Route ready · starts when the book closes" if a.status=="Awaiting assignment" else a.status
  g.label(g.panel_body,title+"\n"+status+" · carrying "+DeepHaul.contents(r.cargo),14)
  var row=g.row(g.panel_body)
  if r.enabled:g.small_button(row,"Finish load & stop",func():stop(g,id);g.save_game();g.refresh_panel())
  elif r.cargo.is_empty():g.small_button(row,"Resume route",func():g.notify(assign(g,id,r.pile,r.chest,r.item,r.to_home));g.save_game();g.refresh_panel())
  if not r.cargo.is_empty():
   if r.returning:g.small_button(row,"Deliver carried load & stop",func():stop(g,id);g.save_game();g.refresh_panel())
   else:g.small_button(row,"Return carried load & stop",func():stop(g,id,true);g.save_game();g.refresh_panel())
static func draw_load(g,p:Vector2):
 HoldFurnishings.draw(g,p+Vector2(0,4),"crate")
 for side in [-1,1]:
  g.draw_line(p+Vector2(side*15,-19),p+Vector2(side*12,-4),Color("497674"),5)
  g.draw_circle(p+Vector2(side*12,-4),3,Color("e5b87e"))
