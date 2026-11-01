class_name HoldArchitecture
extends RefCounted
# Player ownership, construction transactions and room instances. Plans and art
# are shared with authored buildings; NPC identities never belong to a blueprint.
static var active_owner:WeakRef
var surface_ref:WeakRef
var s:
 get:return surface_ref.get_ref()
var g
var category="Hearths"
var selected="cottage"
var furnish_plan=true
var moving=""
var reason=""
var preview_key=""
var preview_fits=false
var preview_reason=""
var preview_until=0
var browse_only=false
var collection="all"
var details_group="Hearth"
var draft_style={}
var style_owner=""
var plan_style={}
func _init(surface):
 surface_ref=weakref(surface);g=surface.g;active_owner=weakref(self)
static func current():return active_owner.get_ref() if active_owner!=null else null
func data()->Dictionary:
 if not g.state.surface.has("architecture86"):g.state.surface.architecture86={"version":1,"next":1,"instances":[]}
 return g.state.surface.architecture86
func record(id:String)->Dictionary:
 for b in data().instances:
  if str(b.id)==id:return b
 return {}
func interior()->bool:return HoldBuildingPlans.owned_room(s.area)
func inside()->Dictionary:return record(HoldBuildingPlans.room_parts(s.area)[0]) if interior() else {}
func current_floor()->int:return HoldBuildingPlans.floor_number(s.area)
func building_object(b:Dictionary)->Dictionary:
 var o=HoldBuildingPlans.instance(b.plan,Vector2(b.x,b.y))
 o.style87=HoldArchitectureStyles.resolve(b)
 o.owner_id=str(b.id);o.extend_x=b.get("extend_x",0);o.extend_y=b.get("extend_y",0)
 o.extra_storeys=maxi(0,b.get("rooms",HoldBuildingPlans.plan(b.plan).rooms).size()-HoldBuildingPlans.plan(b.plan).rooms.size())
 return o
func objects(area:String)->Array:
 var result=[]
 for b in data().instances:
  if b.area==area:result.append(building_object(b))
 return result
func obstacles(area:String,ignore:String="")->Array:
 var out=[]
 for b in data().instances:
  if b.area==area and str(b.id)!=ignore:out.append(HoldBuildingArt.footprint(building_object(b)))
 return out
func points()->Array:
 var result=[]
 if interior():
  var b=inside();var z=current_floor();var r=HoldRoomLayout.exit_point(s.area)
  if z==0:result.append(s.spot(r.x,r.y,"Leave · "+b.name,"architecture_leave"))
  var stair=HoldBuildingPlans.stair_position(s.area)
  if z+1<b.rooms.size():result.append(s.spot(stair.x,stair.y,"Stairs · upper floor","architecture_up"))
  if z>0:result.append(s.spot(stair.x,stair.y,"Stairs · lower floor","architecture_down"))
 else:
  for b in data().instances:
   if b.area==s.area:result.append(s.spot(b.x,b.y,b.name,HoldBuildingPlans.room_id(str(b.id))))
 return result
func can_forge()->bool:
 if not g.hearth.own_home():return false
 var things=g.hearth.furniture()
 for bench in things:
  if bench.kind not in ["worktable","anvil"] or not g.hearth.accessible(bench):continue
  for hearth in things:
   if hearth.kind=="hearth" and hearth.p.distance_to(bench.p)<=300:return true
 return false
func service_points()->Array:
 var result=[]
 if not g.hearth.own_home():return result
 var things=g.hearth.furniture()
 for bench in things:
  if bench.kind not in ["worktable","anvil"]:continue
  for hearth in things:
   if hearth.kind=="hearth" and hearth.p.distance_to(bench.p)<=300:
    result.append(s.spot(bench.p.x,bench.p.y+35,"Workshop · smelt and craft","player_forge"));break
 return result
func connections(area:String)->Array:
 var result=[]
 if HoldBuildingPlans.owned_room(area):
  var b=record(HoldBuildingPlans.room_parts(area)[0])
  if not b.is_empty() and HoldBuildingPlans.floor_number(area)==0:result.append(s.roads.connection(HoldRoomLayout.exit_point(area),Vector2.DOWN,b.area,Vector2(b.x,b.y+45),"Outside"))
 else:
  for b in data().instances:
   if b.area==area:result.append(s.roads.connection(Vector2(b.x,b.y),Vector2.UP,HoldBuildingPlans.room_id(str(b.id)),HoldRoomLayout.exit_point(HoldBuildingPlans.room_id(str(b.id)))-Vector2(0,60),b.name))
 return result
func leave():
 var b=inside()
 if not b.is_empty():s.enter(b.area,Vector2(b.x,b.y+45))
func stairs(up:bool):
 var b=inside();var z=current_floor()+(1 if up else -1)
 if b.is_empty() or z<0 or z>=b.rooms.size():return
 var target=HoldBuildingPlans.room_id(str(b.id),z)
 s.enter(target,HoldBuildingPlans.stair_position(target)+Vector2(0,35))
func construction()->Dictionary:
 var b=inside();var key=str(current_floor())
 if not b.has("construction"):b.construction={}
 if not b.construction.has(key):b.construction[key]={"tiles":{},"facts":{},"levels":{},"links":{},"z":0}
 return b.construction[key]
func cost(id:String)->Dictionary:
 var total=HoldBuildingPlans.shell_cost(id)
 if not furnish_plan:return total
 for area in HoldBuildingPlans.plan(id).rooms:
  for f in HoldBuildingPlans.contents(s.world,area):HoldBuildingPlans.add_cost(total,HoldFurnishings.ITEMS[f.furnishing].cost)
 return total
func valid(o:Dictionary,ignore:String="")->bool:
 reason=""
 if s.area!="claim" or s.house.level()!=0 or g.state.claim_id=="":reason="Build on your chartered ground at ground level.";return false
 var r=HoldBuildingArt.footprint(o)
 if g.player.distance_to(o.p)>230:reason="Walk near the intended doorway.";return false
 for p in [r.position,r.end,Vector2(r.end.x,r.position.y),Vector2(r.position.x,r.end.y),o.p+Vector2(0,45)]:
  if not s.claim_ground(p):reason="Keep the complete building on usable ground.";return false
 if r.grow(18).has_point(g.player):reason="Stand outside the foundation.";return false
 # Existing world buildings and player buildings use the same ground footprints.
 var solids=s.base_obstacles()+obstacles(s.area,ignore)+s.house.obstacles()+g.handworks.surface_obstacles()+g.fieldwork.obstacles()
 for d in g.state.surface.decor:
  if s.house.local(d):solids.append(HoldFurnishings.footprint(d.kind,Vector2(d.x,d.y)))
 for d in g.state.surface.chests.values():
  if s.house.local(d):solids.append(HoldFurnishings.footprint("chest",Vector2(d.x,d.y)))
 for k in s.house.tiles():
  if r.grow(12).intersects(Rect2(Vector2(s.house.coords(k))*40,Vector2(40,40))):reason="Recover existing construction before laying this foundation.";return false
 for solid in solids:
  if r.grow(20).intersects(solid):reason="Leave space around buildings, furniture and working equipment.";return false
 for p in s.points():
  if p.action==HoldBuildingPlans.room_id(ignore):continue
  if r.grow(58).has_point(p.p):reason="Keep existing doorways and services accessible.";return false
 if not access_open(r,ignore,o.p):reason="Keep a walking route from every doorway to the homestead.";return false
 return true
func access_open(candidate:Rect2,ignore:String,door:Vector2)->bool:
 # Rasterize once per candidate. Integer cells keep cursor checks inexpensive.
 const WIDTH=90
 const HEIGHT=55
 var solid=PackedByteArray();solid.resize(WIDTH*HEIGHT);solid.fill(1)
 for y in range(5,52):
  for x in range(2,88):
   if s.claim_ground(Vector2(x*40+20,y*40+20)):solid[y*WIDTH+x]=0
 var blockers=s.base_obstacles()+obstacles("claim",ignore)+s.house.obstacles()+g.handworks.surface_obstacles()+g.fieldwork.obstacles()+[candidate]
 for d in g.state.surface.decor+g.state.surface.chests.values():
  if s.house.local(d):
   var r=HoldFurnishings.footprint(d.get("kind","chest"),Vector2(d.x,d.y))
   if r.has_area():blockers.append(r)
 for rect in blockers:
  var r=rect.grow(12)
  for y in range(maxi(0,floori(r.position.y/40)),mini(HEIGHT,ceili(r.end.y/40))):
   for x in range(maxi(0,floori(r.position.x/40)),mini(WIDTH,ceili(r.end.x/40))):
    if r.has_point(Vector2(x*40+20,y*40+20)):solid[y*WIDTH+x]=1
 var seen=PackedByteArray();seen.resize(WIDTH*HEIGHT)
 var todo=PackedInt32Array([19*WIDTH+7]);seen[todo[0]]=1;var head=0
 while head<todo.size():
  var c=todo[head];head+=1
  for n in [c-1,c+1,c-WIDTH,c+WIDTH]:
   if n<0 or n>=solid.size() or solid[n]!=0 or seen[n]!=0:continue
   seen[n]=1;todo.append(n)
 var targets=[door+Vector2(0,45)]
 for p in s.points():
  if p.action!=HoldBuildingPlans.room_id(ignore) and not p.action.begins_with("house:"):targets.append(p.p+Vector2(0,40))
 for target in targets:
  var found=false;var cell=Vector2i((target/40).floor())
  for y in range(maxi(0,cell.y-2),mini(HEIGHT,cell.y+3)):
   for x in range(maxi(0,cell.x-2),mini(WIDTH,cell.x+3)):
    if seen[y*WIDTH+x]!=0 and Vector2(x*40+20,y*40+20).distance_to(target)<85:found=true
  if not found:return false
 return true
func start(id:String):
 preview_key="";selected=id;moving="";s.cancel_placement();g.handworks.placing="";s.placing="blueprint:"+id;g.close_panel()
 g.notify("Place the doorway near you. Green fits; right click cancels. Walk inside after building. Choose furnishings in the Building Book.")
func place(p:Vector2)->bool:
 p=(p/20).round()*20
 var b=record(moving)
 if HoldFrontier103.public_building(b):return false
 var o=building_object(b) if not b.is_empty() else HoldBuildingPlans.instance(selected,p)
 o.p=p
 if b.is_empty() and not plan_style.is_empty():o.style87=plan_style.duplicate()
 if not valid(o,moving):g.notify(reason);return false
 if not b.is_empty():
  b.x=p.x;b.y=p.y;moving="";s.cancel_placement();g.save_game();return true
 if not g.state.pay(cost(selected)):g.notify("Bring "+HoldData.cost_text(cost(selected))+" in your pack.");return false
 var d=data();var id=str(int(d.next));d.next=int(d.next)+1
 b={"id":id,"plan":selected,"name":HoldBuildingPlans.plan(selected).name,"area":s.area,"x":p.x,"y":p.y,"extend_x":0,"extend_y":0,"rooms":HoldBuildingPlans.plan(selected).rooms.duplicate(),"construction":{},"shell_paid":HoldBuildingPlans.shell_cost(selected)}
 b.style87=HoldArchitectureStyles.resolve(o)
 d.instances.append(b)
 for z in b.rooms.size():seed_room(b,z,furnish_plan)
 s.cancel_placement();g.sound.effect("build");g.save_game();g.notify(b.name+" built. Walk through its door; O opens renovation and furnishing plans.");return true
func seed_room(b:Dictionary,z:int,furnished:bool=true):
 var area=HoldBuildingPlans.room_id(str(b.id),z)
 var list=HoldBuildingPlans.contents(s.world,b.rooms[z]) if furnished else []
 for f in list:
  if f.furnishing=="chest":
   var id="architecture86:"+str(b.id)+":"+str(z)+":"+str(g.state.surface.chests.size())
   g.state.surface.chests[id]={"area":area,"x":f.p.x,"y":f.p.y,"z":0,"items":{}}
  else:
   var item={"area":area,"kind":f.furnishing,"x":f.p.x,"y":f.p.y,"z":0}
   if f.has("sort_y"):item.sort_y=f.sort_y
   g.state.surface.decor.append(item)
func nearby()->Dictionary:
 if interior():return inside()
 var best={};var distance=130.0
 for b in data().instances:
  if b.area!=s.area:continue
  var d=g.player.distance_to(Vector2(b.x,b.y))
  if d<distance:distance=d;best=b
 return best
func expand(axis:String)->bool:
 var b=nearby()
 if HoldFrontier103.public_building(b):return false
 if b.is_empty():return false
 if int(b.get(axis,0))>=6:g.notify("This wing has reached its six-bay span. Build another hall beside it.");return false
 if interior():g.notify("Step outside to extend the foundation.");return false
 var o=building_object(b);o[axis]=int(o.get(axis,0))+1
 if not valid(o,str(b.id)):g.notify(reason);return false
 var fee={"stone":24*b.rooms.size(),"wood":16*b.rooms.size()}
 if not g.state.pay(fee):g.notify("Bring "+HoldData.cost_text(fee));return false
 b[axis]=o[axis];HoldBuildingPlans.add_cost(b.shell_paid,fee);g.save_game();g.refresh_panel();return true
func floor_cost(b:Dictionary)->Dictionary:
 var r=HoldBuildingPlans.geometry(HoldBuildingPlans.room_id(str(b.id))).floor
 var scale=r.size.x*r.size.y/(640.0*385.0)
 return {"stone":ceili(80*scale),"wood":ceili(60*scale),"iron":4}
func add_floor()->bool:
 var b=nearby()
 if HoldFrontier103.public_building(b):return false
 if b.is_empty() or b.rooms.size()>=5:return false
 # Additional storeys use a clear, aligned staircase shared by every floor.
 var candidates=[HoldBuildingPlans.stair_position(HoldBuildingPlans.room_id(str(b.id)))] if b.rooms.size()>1 else [Vector2(700,550),Vector2(600,550),Vector2(600,600),Vector2(350,550)]
 var landing=Vector2.INF
 for candidate in candidates:
  var clear=true;var rails=HoldNeighborhood.stair_rails(candidate,96)+[Rect2(candidate-Vector2(30,20),Vector2(60,80))]
  for z in b.rooms.size():
   var area=HoldBuildingPlans.room_id(str(b.id),z)
   for d in g.state.surface.decor+g.state.surface.chests.values():
    if d.area!=area:continue
    var footprint=HoldFurnishings.footprint(d.get("kind","chest"),Vector2(d.x,d.y))
    if footprint.has_area() and rails.any(func(r):return r.grow(8).intersects(footprint)):clear=false
   for f in g.handworks.data().facilities:
    if f.area=="surface:"+area+":0" and rails.any(func(r):return r.grow(8).intersects(HoldHandworks.footprint(f))):clear=false
   for k in b.get("construction",{}).get(str(z),{}).get("tiles",{}):
    var tile=b.construction[str(z)].tiles[k]
    if tile.get("wall","")!="" and rails.any(func(r):return r.intersects(Rect2(Vector2(s.house.coords(k))*40,Vector2(40,40)))):clear=false
  if clear:landing=candidate;break
 if landing==Vector2.INF:g.notify("Clear a stair landing on each floor before adding another storey.");return false
 var fee=floor_cost(b)
 if not g.state.pay(fee):g.notify("Bring "+HoldData.cost_text(fee));return false
 b.stair=[landing.x,landing.y];b.rooms.append(b.rooms[0]);HoldBuildingPlans.add_cost(b.shell_paid,fee);seed_room(b,b.rooms.size()-1,false);g.save_game();g.refresh_panel();return true
func move_building():
 var b=nearby()
 if HoldFrontier103.public_building(b):return
 if b.is_empty() or interior():return
 preview_key="";moving=str(b.id);selected=b.plan;s.cancel_placement();s.placing="blueprint:"+selected;g.close_panel()
 g.notify("Relocate this building. Its rooms, furnishings and stored goods stay together.")
func empty_for_recovery(b:Dictionary)->bool:
 for z in b.rooms.size():
  var area=HoldBuildingPlans.room_id(str(b.id),z)
  if g.state.surface.decor.any(func(d):return d.area==area):return false
  if g.state.surface.chests.values().any(func(d):return d.area==area):return false
  if g.handworks.data().facilities.any(func(f):return f.area=="surface:"+area+":0"):return false
  if g.handworks.data().loose.any(func(f):return f.area=="surface:"+area+":0"):return false
  if not b.get("construction",{}).get(str(z),{}).get("tiles",{}).is_empty():return false
 return true
func recover()->bool:
 var b=nearby()
 if HoldFrontier103.public_building(b):return false
 if b.is_empty() or interior():return false
 if not empty_for_recovery(b):g.notify("Empty every room, including furniture, storage, partitions and equipment, before recovering the shell.");return false
 for key in b.shell_paid:g.state.add(key,int(b.shell_paid[key]))
 data().instances.erase(b);g.save_game();g.refresh_panel();return true
func panel():HoldArchitectureView.book(self)
func details_panel():HoldArchitectureView.furniture(self)
func plan_panel():HoldArchitectureView.plan_page(self)
func style_panel():HoldArchitectureView.style_page(self)
func select_plan(id:String):
 selected=id;plan_style=HoldArchitectureStyles.preset(HoldArchitectureStyles.family(id));g.open_panel("architecture_plan")
func open_style():
 var b=nearby()
 if b.is_empty():return
 style_owner=str(b.id);draft_style=HoldArchitectureStyles.resolve(b);g.open_panel("architecture_style")
func style_cost(b:Dictionary)->Dictionary:
 var old=HoldArchitectureStyles.resolve(b);var total={}
 if old.wall!=draft_style.get("wall",old.wall):total.stone=12*b.rooms.size()
 if old.roof!=draft_style.get("roof",old.roof):total.wood=8
 if old.trim!=draft_style.get("trim",old.trim):total.iron=2*b.rooms.size()
 if old.floor!=draft_style.get("floor",old.floor):
  var r=HoldBuildingPlans.geometry(HoldBuildingPlans.room_id(str(b.id))).floor
  var key="wood" if draft_style.floor=="oak" else "stone"
  total[key]=int(total.get(key,0))+ceili(r.get_area()/6400.0)*b.rooms.size()
 return total
func apply_style()->bool:
 if HoldFrontier103.public_building(nearby()):return false
 var b=nearby()
 if b.is_empty() or str(b.id)!=style_owner:return false
 for key in HoldArchitectureStyles.OPTIONS:
  if not HoldArchitectureStyles.OPTIONS[key].has(draft_style.get(key,"")):return false
 var fee=style_cost(b)
 if fee.is_empty():return false
 if not g.state.pay(fee):g.notify("Bring "+HoldData.cost_text(fee)+" to refinish this building.");return false
 b.style87=draft_style.duplicate();HoldBuildingPlans.add_cost(b.shell_paid,fee)
 g.sound.effect("build");g.save_game();g.refresh_panel();g.notify("Finishes applied. Your original frontage and room contents are preserved.");return true
func preview():
 if not s.placing.begins_with("blueprint:"):return
 var p=((g.get_global_mouse_position()+g.camera)/20).round()*20
 var old=record(moving);var o=building_object(old) if not old.is_empty() else HoldBuildingPlans.instance(selected,p);o.p=p
 if old.is_empty() and not plan_style.is_empty():o.style87=plan_style
 var key=selected+":"+str(p)+":"+str((g.player/10).floor())+":"+moving
 if key!=preview_key or Time.get_ticks_msec()>preview_until:
  preview_fits=valid(o,moving);preview_reason=reason;preview_key=key;preview_until=Time.get_ticks_msec()+500
 var fits=preview_fits;reason=preview_reason;var tint=HoldBuildPreview.color(fits)
 HoldBuildingArt.draw(s.world,o,.62)
 HoldBuildPreview.outline(g,HoldBuildingArt.footprint(o),fits)
 g.draw_circle(p,5,tint);g.draw_line(p,p+Vector2(0,45),tint,3)
 HoldSurface.A.text(g,p+Vector2(-120,65),"Doorway · "+("LMB build" if fits else reason),13,tint)
