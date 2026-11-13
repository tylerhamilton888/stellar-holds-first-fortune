class_name HoldBlueprintFinishes
extends RefCounted
# Room finishes live on physical Hearthcraft tiles, so deleting a plan never
# erases paid appearance and shared partitions have one finish owner.
const RESEARCH={"hearth":"","forge":"stoneworking","oath":"fine_masonry"}
static func cells(p,r:Dictionary)->Array:
 var result=[];var b=p.bounds(r)
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   var c=Vector2i(x,y);var owner=true
   for other in p.rooms(int(r.get("z",0))):
    if str(other.id)==str(r.id):break
    if p.bounds(other).has_point(c):owner=false;break
   if owner:result.append(c)
 return result
static func style(h,c:Vector2i,z:int=-1)->Dictionary:
 var t=h.tile(c) if z<0 else (h.data().get("tiles",{}) if z==0 else h.data().get("levels",{}).get(str(z),{})).get(h.key(c),{});var result=HoldArchitectureStyles.room(h.s.area).duplicate()
 result.floor="oak" if t.get("floor","")=="wood_floor" else "slate"
 if t.has("style87"):return HoldArchitectureStyles.resolve(t)
 return result
static func fee(old:Dictionary,target:Dictionary,wall:bool)->Dictionary:
 var result={}
 if old.floor!=target.floor:
  result["wood" if target.floor=="oak" else "stone"]=1
  if target.floor=="inlaid":result.copper=1
 if old.wall!=target.wall and wall:result.stone=int(result.get("stone",0))+1
 if old.roof!=target.roof:result.wood=int(result.get("wood",0))+1
 if old.trim!=target.trim and wall:result.iron=1
 return result
static func cost(p,r:Dictionary)->Dictionary:
 var family=r.get("style_family","")
 if family=="" or not RESEARCH.has(family):return {}
 var target=HoldArchitectureStyles.preset(family);var total={};var h=p.a.s.house
 for c in cells(p,r):
  var old=style(h,c,int(r.get("z",0)))
  if not p.tile(c,int(r.get("z",0))).has("floor"):old.floor="oak" if r.floor=="wood_floor" else "slate"
  HoldBuildingPlans.add_cost(total,fee(old,target,p.edge(r,c)))
 return total
static func work(p,r:Dictionary,limit:int)->int:
 if not p.available() or p.level()!=p.a.s.house.level() or r not in p.rooms():return 0
 var family=r.get("style_family","")
 if not RESEARCH.has(family):return 0
 var tech=RESEARCH[family]
 if tech!="" and not p.a.g.state.tech.get(tech,false):return 0
 var h=p.a.s.house;var target=HoldArchitectureStyles.preset(family);var count=0
 for c in cells(p,r):
  if count>=limit:break
  var t=h.tile(c)
  if not t.has("floor") or not t.get("roof",false) or (p.edge(r,c) and t.get("wall","")==""):continue
  if h.center(c).distance_to(p.a.g.player)>170:continue
  var charge=fee(style(h,c),target,p.edge(r,c))
  if charge.is_empty():continue
  if not p.a.g.state.pay(charge):continue
  r.started=true;t.style87=target.duplicate()
  if not t.has("finish_paid152"):t.finish_paid152={}
  HoldBuildingPlans.add_cost(t.finish_paid152,charge);count+=1
 return count
