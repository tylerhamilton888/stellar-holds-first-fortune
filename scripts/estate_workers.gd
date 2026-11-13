class_name HoldEstateWorkers
extends RefCounted
# Existing recruited crew and mine positions remain authoritative. Only the
# optional bed and which side of the household stair a worker occupies are new.
static func building(g)->Dictionary:return HoldEstateCellar.home(g).get("building",{})
static func homes(g)->Dictionary:
 var b=building(g)
 if b.is_empty():return {}
 if not b.has("worker_homes160"):b.worker_homes160={}
 return b.worker_homes160
static func node(c:Vector2i,z:int,area:String="surface")->Dictionary:return {"x":c.x,"y":c.y,"z":z,"area":area}
static func cell(n:Dictionary)->Vector2i:return Vector2i(n.x,n.y)
static func key(n:Dictionary)->String:return str(n.z)+"/"+Deepworks.key(cell(n))
static func floor_tiles(g,z:int)->Dictionary:
 var b=building(g)
 return b.get("tiles",{}) if z==0 else b.get("levels",{}).get(str(z),{})
static func obstacles(g,z:int)->Array:
 var result=[]
 if z==0:
  var previous=g.surface.area;g.surface.area="claim"
  result.append_array(g.surface.base_obstacles());result.append_array(g.surface.architecture.obstacles("claim"));g.surface.area=previous
 for list in [g.state.surface.decor,g.state.surface.chests.values()]:
  for o in list:
   if o.area=="claim" and int(o.get("z",0))==z:result.append(HoldFurnishings.footprint(o.get("kind","chest"),Vector2(o.x,o.y)).grow(8))
 for f in g.handworks.data().facilities:
  if f.area=="surface:claim:"+str(z):result.append(Rect2(g.handworks.pos(f)-Vector2(30,30),Vector2(60,60)))
 for bed in g.state.surface.get("fieldwork",{}).get("beds",[]):
  if z==0 and bed.get("area","")!="greenfields" and bed.get("claim","")==g.state.claim_id:result.append(Rect2(Vector2(bed.x,bed.y)-Vector2(40,30),Vector2(80,40)))
 return result
static func clear(g,n:Dictionary,blocks:Array)->bool:
 var t=floor_tiles(g,int(n.z)).get(Deepworks.key(cell(n)),{})
 if not t.has("floor") or t.get("wall","") not in ["","door"]:return false
 var p=Deepworks.center(cell(n))
 return not blocks.any(func(rect):return rect.has_point(p))
static func surface_route(g,start:Dictionary,ends:Array)->Dictionary:
 # Bounded search through actual constructed floors, including existing stairs.
 var queue=[start];var visited={key(start):true};var parent={};var nodes={key(start):start};var index=0;var blocks={}
 for z in HoldHearthcraft.MAX_Z:blocks[z]=obstacles(g,z)
 while index<queue.size() and index<8192:
  var current=queue[index];index+=1
  if not clear(g,current,blocks[int(current.z)]):continue
  if ends.any(func(n):return key(n)==key(current)):
   var path=[];var k=key(current)
   while parent.has(k):path.push_front(nodes[k]);k=parent[k]
   return {"path":path,"end":current}
  var next=[]
  for d in Deepworks.DIRS:next.append(node(cell(current)+d,int(current.z)))
  for dz in [-1,1]:
   var dest=int(current.z)+dz
   if dest<0 or dest>=HoldHearthcraft.MAX_Z:continue
   var link=str(mini(dest,int(current.z)))+"/"+Deepworks.key(cell(current))
   if building(g).get("links",{}).has(link):next.append(node(cell(current),dest))
  for n in next:
   var k=key(n)
   if visited.has(k) or not clear(g,n,blocks[int(n.z)]):continue
   visited[k]=true;parent[k]=key(current);nodes[k]=n;queue.append(n)
 return {}
static func beds(g,z:int)->Array:
 return g.state.surface.decor.filter(func(o):return o.area=="claim" and int(o.get("z",0))==z and o.kind in ["bed","double_bed"])
static func bed(g,record:Dictionary)->Dictionary:
 if record.is_empty():return {}
 for b in beds(g,int(record.z)):
  if is_equal_approx(float(b.x),float(record.x)) and is_equal_approx(float(b.y),float(record.y)):return b
 return {}
static func approaches(b:Dictionary)->Array:
 var result=[]
 for side in [-1,1]:result.append(node(Deepworks.cell(HoldFurnishings.bedside(Vector2(b.x,b.y),side,b.kind)),int(b.get("z",0))))
 return result
static func stairs(g)->Array:
 var result=[]
 for r in HoldEstateCellar.plans(g):
  if r.get("built",false) and HoldEstateCellar.surface_problem(g,cell(r))=="" and HoldEstateCellar.mine_problem(g,cell(r))=="":result.append(r)
 return result
static func assign(g,id:String,record:Dictionary)->String:
 if not g.surface.active() or g.surface.area!="claim" or g.state.active_site!="claim":return "Visit your household grounds to assign a bed."
 if not g.state.outpost.get("crew",{}).has(id) or g.state.outpost.crew[id].role!="miner":return "Recruit this Dwarf as a miner first."
 var b=bed(g,record)
 if b.is_empty() or int(record.z)!=g.surface.architecture.room_blueprints.level():return "Choose an existing bed on the selected floor."
 for other in homes(g):
  if other!=id and homes(g)[other]==record:return "That bed already has a resident."
 g.deep.ensure();var reachable=false
 for stair in stairs(g):
  if not surface_route(g,node(cell(stair),0),approaches(b)).is_empty():reachable=true;break
 if not reachable:return "Build a clear floor-and-stair route from the cellar landing to this bed."
 homes(g)[id]=record.duplicate()
 return g.state.npc(id).first_name+" will walk home during the crew's rest period, then return to the assigned mine worksite."
static func mine_steps(path:Array,z:int)->Array:
 var result=[]
 for p in path:result.append(node(Deepworks.cell(p),z,"mine"))
 return result
static func route(g,saved:Dictionary,b:Dictionary,resting:bool)->Array:
 var w=g.deep.world;var c=Deepworks.cell(Vector2(saved.x,saved.y));var area=saved.get("estate_area160","mine")
 if area=="surface":
  var start=node(c,int(saved.get("estate_z160",0)))
  if resting:return surface_route(g,start,approaches(b)).get("path",[])
  var available=stairs(g);var ends=[]
  for stair in available:ends.append(node(cell(stair),0))
  var r=surface_route(g,start,ends)
  if r.is_empty():return []
  var path=r.path;path.append(node(cell(r.end),0,"mine"));return path
 var z=int(saved.depth)
 if z>0:
  var best={};var distance=w.zone_distance(z,0,true)
  for link in w.connections(z):
   if w.zone_distance(int(link.to),0,true)>=distance or not w.walkable(link.target,int(link.to)):continue
   var r=w.route(c,z,"",link.c)
   if not r.is_empty() and (best.is_empty() or r.path.size()<best.path.size()):best=r;best.link=link
  if best.is_empty():return []
  var path=mine_steps(best.path,z);path.append(node(best.link.target,int(best.link.to),"mine"));return path
 var best=[]
 for stair in stairs(g):
  var above=surface_route(g,node(cell(stair),0),approaches(b))
  if above.is_empty():continue
  var below=w.route(c,0,"",cell(stair))
  if below.is_empty():continue
  var path=mine_steps(below.path,0);path.append(node(cell(stair),0));path.append_array(above.path)
  if best.is_empty() or path.size()<best.size():best=path
 return best
static func valid_step(g,saved:Dictionary,n:Dictionary)->bool:
 var area=str(saved.get("estate_area160","mine"));var z=int(saved.get("estate_z160",0)) if area=="surface" else int(saved.depth)
 var c=Deepworks.cell(Vector2(saved.x,saved.y));var w=g.deep.world
 if area!=n.area:
  return z==0 and int(n.z)==0 and c==cell(n) and stairs(g).any(func(r):return cell(r)==c)
 if z!=int(n.z):
  if area=="surface":return c==cell(n) and building(g).get("links",{}).has(str(mini(z,int(n.z)))+"/"+Deepworks.key(c)) and clear(g,node(c,z),obstacles(g,z)) and clear(g,n,obstacles(g,int(n.z)))
  return w.connections(z).any(func(link):return link.c==c and int(link.to)==int(n.z) and link.target==cell(n) and w.walkable(c,z) and w.walkable(link.target,int(n.z)))
 if area=="surface":return clear(g,n,obstacles(g,z))
 return w.walkable(cell(n),z)
static func tick(g,a:Dictionary,saved:Dictionary,dt:float)->bool:
 if a.type!="worker":return false
 var record=homes(g).get(a.id,{});var b=bed(g,record);var above=saved.get("estate_area160","mine")=="surface"
 var cargo=g.deep.works.masonry.data.jobs.get(a.id,{}).get("cargo",{})
 var rest_period=fmod(g.state.elapsed,120.0)>=90.0
 if not b.is_empty() and rest_period and cargo.is_empty() and int(saved.get("estate_cycle160",-1))!=int(g.state.elapsed/120.0):
  saved.estate_cycle160=int(g.state.elapsed/120.0);saved.estate_rest160=true;saved.estate_rest_seconds160=0.0
 if b.is_empty() or (not rest_period and float(saved.get("estate_rest_seconds160",0))>=10):saved.estate_rest160=false
 var resting=not b.is_empty() and bool(saved.get("estate_rest160",false)) and cargo.is_empty()
 if not above and not resting:
  if a.get("estate_task160","")!="":a.erase("estate_task160");a.erase("estate_path160");a.path=[];a.target=Vector2i(-1,-1)
  a.estate_walking160=false
  return false
 a.p=Vector2(saved.x,saved.y);a.work=false;a.path=[];a.target=Vector2i(-1,-1);a.estate_walking160=false
 if g.deep.works.model.data.assignments.has(a.id):g.deep.works.model.data.assignments[a.id].present=""
 if g.panel_id!="" or g.transition_left>0:return true
 var task=JSON.stringify(record) if resting else "return"
 if a.get("estate_task160","")!=task:a.estate_task160=task;a.estate_path160=[];a.cool=0
 if above and resting:
  var here=node(Deepworks.cell(a.p),int(saved.get("estate_z160",0)))
  if approaches(b).any(func(n):return key(n)==key(here)) and clear(g,here,obstacles(g,int(here.z))):
   a.estate_path160=[]
   if a.fuel<=0:
    if not g.state.pay({"food":1}):a.status="Resting at home · needs food";return true
    a.fuel=12
   saved.estate_rest_seconds160=float(saved.get("estate_rest_seconds160",0))+dt
   a.status="Resting at home";a.facing=(Vector2(b.x,b.y)-a.p).normalized()
   var folk=g.deep.works.model.data.folk
   if not folk.has(a.id):folk[a.id]={"preference":{"style":"flags","interest":"A practical place to work and rest","drink":"malt"},"morale":0,"rested_until":0.0,"activity":""}
   folk[a.id].rested_until=g.state.elapsed+180;folk[a.id].activity=a.status
   saved.service_time=float(saved.get("service_time",0))+dt
   if saved.service_time>=30:saved.service_time=0;a.fuel=maxi(0,a.fuel-1)
   return true
 if a.get("estate_path160",[]).is_empty():
  if a.cool>0:return true
  a.cool=.75;a.estate_path160=route(g,saved,b,resting)
  if a.estate_path160.is_empty():a.status="Home route blocked" if resting else "Return route blocked";return true
 a.status="Walking home" if resting else "Returning to mine work"
 var next=a.estate_path160[0]
 if not valid_step(g,saved,next):a.estate_path160=[];a.cool=.75;a.status="Home route blocked" if resting else "Return route blocked";return true
 var area=saved.get("estate_area160","mine");var z=int(saved.get("estate_z160",0)) if area=="surface" else int(saved.depth)
 if area!=next.area or z!=int(next.z):
  saved.estate_area160=next.area
  if next.area=="mine":saved.depth=int(next.z)
  else:saved.estate_z160=int(next.z)
  a.p=Deepworks.center(cell(next));saved.x=a.p.x;saved.y=a.p.y;a.estate_path160.pop_front();return true
 var destination=Deepworks.center(cell(next));var step=a.p.move_toward(destination,100*minf(dt,.1))
 if area=="mine" and g.deep.world.solid(step,z):a.estate_path160=[];a.cool=.75;return true
 if area=="surface" and obstacles(g,z).any(func(rect):return rect.has_point(step)):a.estate_path160=[];a.cool=.75;return true
 a.facing=(step-a.p).normalized();a.gait=float(a.get("gait",0))+step.distance_to(a.p)/150.0;a.estate_walking160=step!=a.p
 a.p=step;saved.x=step.x;saved.y=step.y
 if step.distance_to(destination)<1:a.estate_path160.pop_front()
 return true
static func objects(g)->Array:
 if g.state.active_site!="claim" or g.surface.area!="claim":return []
 var result=[]
 for a in g.agents:
  var saved=g.deep.crew_entry(a)
  if saved.get("estate_area160","mine")!="surface" or int(saved.get("estate_z160",0))!=g.surface.house.level():continue
  result.append({"kind":"citizen","p":Vector2(saved.x,saved.y),"profile":g.state.npc(a.id),"aim":a.get("facing",Vector2.DOWN),"walking":a.get("estate_walking160",false),"time":g.clock,"gait":a.get("gait",0),"name":g.state.npc(a.id).name,"role":a.status})
 return result
static func panel(p):
 var g=p.a.g
 g.label(g.panel_body,"A bed for your crew",20)
 g.label(g.panel_body,"Assign a furnished bed on this floor. Miners walk home through clear cellar and household stairs during their rest period, then return to their assigned mine work. Keep a continuous built floor route. Carts and freight stay separate.",14)
 var available=beds(g,p.level())
 if available.is_empty():g.label(g.panel_body,"Place a bed on this floor to offer a berth.",14)
 for a in g.agents:
  if a.type!="worker":continue
  var id=str(a.id);var record=homes(g).get(id,{});var label=g.state.npc(id).first_name
  if not record.is_empty():label+=" · bed on floor %d (%d, %d)" % [record.z,int(record.x/40),int(record.y/40)]
  var status="Berth reserved for the next rest period" if not record.is_empty() and a.status=="Awaiting assignment" else str(a.status)
  g.label(g.panel_body,label+" · "+status,15)
  var row=g.row(g.panel_body);var selector=OptionButton.new();selector.custom_minimum_size=Vector2(190,34);row.add_child(selector)
  var targets=[]
  for b in available:
   targets.append({"x":b.x,"y":b.y,"z":int(b.get("z",0))});selector.add_item("Bed (%d, %d)" % [int(b.x/40),int(b.y/40)])
  selector.disabled=targets.is_empty()
  if not targets.is_empty():selector.select(maxi(0,targets.find(record)))
  g.small_button(row,"Assign selected bed",func():
   if selector.selected>=0 and selector.selected<targets.size():g.notify(assign(g,id,targets[selector.selected]));g.save_game();g.refresh_panel()).disabled=targets.is_empty()
  if not record.is_empty():g.small_button(row,"Release berth",func():
   if g.surface.active() and g.surface.area=="claim" and g.state.active_site=="claim":homes(g).erase(id);g.save_game();g.refresh_panel())
 if g.agents.is_empty():g.label(g.panel_body,"Recruit a miner for your own claim first.",14)
