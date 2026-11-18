class_name HoldBuildingPlans
extends RefCounted
# The same plans describe authored addresses and player-owned buildings.
# Artwork remains an architectural component, never a second building type.
static var catalogue_cache:Dictionary={}
static func catalogue()->Dictionary:
 if not catalogue_cache.is_empty():return catalogue_cache
 var out={}
 var kinds={1:3,4:5,7:0,8:1,9:2,12:6,15:4,17:7}
 for i in kinds:
  var d=HoldDistrictMap.DOORS[i];var id="hold_"+d.id
  var rooms=["room:"+("practice" if i==17 else d.id)]
  if i==8:rooms.append(HoldHouseholds.LOFT)
  out[id]={"name":d.name,"category":"Industry" if i in [15,17] else "Hearths" if i in [7,8] else "Civic","rooms":rooms,"ward":true,"art":kinds[i],"id":i,"width":400.0 if i==1 else 370.0 if i in [8,15] else 310.0}
 out.archive={"name":"Hall of Names","category":"Civic","rooms":[HoldHouseholds.ARCHIVE],"ward":true,"art":0,"id":-1,"width":310.0}
 for ward in HoldWorldZones.WARDS:
  for i in 3:
   var id="folk_"+ward+"_"+str(i)
   out[id]={"name":"Two-storey house · "+ward.capitalize()+" "+str(i+1),"category":"Hearths","rooms":[HoldNeighborhood.home_id(ward,i),HoldNeighborhood.home_id(ward,i,1)],"ward":true,"art":0,"id":-2,"home":HoldNeighborhood.home_id(ward,i),"width":[260.0,240.0,280.0][i]}
 for item in [["cottage","Cottage","Hearths","home:blueprint",0,350.0],["wayfarer","Travel lodge","Hearths","room:wayfarer",1,290.0],["farmhouse","Farmhouse","Hearths","room:greenhearth",0,320.0],["workshop","Workshop","Industry","room:forge",4,260.0]]:
  out[item[0]]={"name":item[1],"category":item[2],"rooms":[item[3]],"ward":false,"art":item[4],"id":-3,"width":item[5]}
 out.frontier_lodge={"name":"Stonebridge bunkhouse","category":"Hearths","rooms":["room:lodge","room:home"],"ward":false,"art":0,"id":-3,"width":300.0}
 out.frontier_office={"name":"Survey hall and archive","category":"Civic","rooms":["room:research","room:research"],"stair":[550,550],"ward":false,"art":2,"id":-3,"width":260.0}
 out.frontier_watch={"name":"Watch house and stores","category":"Civic","rooms":["room:market"],"ward":false,"art":0,"id":-3,"width":240.0}
 for id in out:out[id].key=id
 out.workshop.rooms=["room:workshop148"]
 out.frontier_forge=out.workshop.duplicate(true)
 out.frontier_forge.name="Stonebridge communal forge";out.frontier_forge.rooms=["room:communal148"];out.frontier_forge.key="frontier_forge"
 var generic_names={"hold_throne":"Great hall","hold_research":"Research office","hold_home":"Lodge","hold_tavern":"Tavern","hold_market":"Market hall","hold_commission":"Office","hold_forge":"Large forge","hold_training":"Training hall","archive":"Archive","frontier_lodge":"Bunkhouse","frontier_office":"Two-storey office","frontier_watch":"Storehouse","frontier_forge":"Large workshop"}
 for key in generic_names:
  if out.has(key):out[key].name=generic_names[key]
 catalogue_cache=out;return out
static func plan(id:String)->Dictionary:return catalogue().get(id,{})
# Construction research is checked in the catalogue and again before spending.
static func required_technology(id:String)->String:
 var p=plan(id)
 if p.is_empty():return ""
 if p.category=="Civic":return "fine_masonry"
 if p.category=="Industry":return "metallurgy"
 if p.rooms.size()>1:return "stoneworking"
 return ""
static func unlocked(s,id:String)->bool:
 return not plan(id).is_empty() and (required_technology(id)=="" or s.tech.has(required_technology(id)))
static func category_label(id:String)->String:
 return {"Hearths":"Homes","Industry":"Workshops","Civic":"Halls"}.get(plan(id).get("category",""),"Building")
static func purpose(id:String)->String:
 var p=plan(id)
 if p.is_empty():return ""
 if p.category=="Hearths":return "Living space for beds, meals and storage. Choose the included furniture or furnish it yourself."
 if p.category=="Industry":return "Workspace for equipment and storage. The equipment you place determines what you can make here."
 return "A large interior for your own furnishings. Building a copy does not add town services or recruit staff."
static func contents_summary(w,id:String)->String:
 var counts={}
 for room in plan(id).get("rooms",[]):
  for f in contents(w,room):
   var key=str(f.get("furnishing",""))
   if not HoldFurnishings.ITEMS.has(key):continue
   counts[key]=int(counts.get(key,0))+1
 var lines:PackedStringArray=[]
 for key in counts:lines.append("%d × %s" % [counts[key],HoldFurnishings.ITEMS[key].title])
 return ", ".join(lines) if not lines.is_empty() else "No furniture included."
static func identify(b:Dictionary,area:String)->String:
 if b.has("plan"):return b.plan
 if b.has("home"):return b.home.trim_prefix("room:").rsplit("_",true,1)[0]
 if HoldWorldZones.ward(area):
  var i=int(b.get("id",-1))
  return "hold_"+HoldDistrictMap.DOORS[i].id if HoldDistrictMap.DOORS.has(i) else "archive"
 if area=="trail":return "wayfarer"
 if area=="greenfields":return "farmhouse"
 return "cottage" if int(b.art)==0 else "workshop"
static func instance(id:String,p:Vector2)->Dictionary:
 var b=plan(id).duplicate(true)
 b.p=p;b.kind="building";b.plan=id;b.extend_x=0;b.extend_y=0
 return b
static func bind(b:Dictionary,area:String)->Dictionary:
 b.plan=identify(b,area);return b
static func owned_room(area:String)->bool:return area.begins_with("room:built86_")
static func room_id(id:String,z:int=0)->String:return "room:built86_"+id+"_"+str(z)
static func room_parts(area:String)->PackedStringArray:return area.trim_prefix("room:built86_").split("_")
static func template(area:String)->String:
 if not owned_room(area):return area
 var owner=HoldArchitecture.current()
 if owner==null:return "room:home"
 var parts=room_parts(area);var b=owner.record(parts[0])
 if b.is_empty():return "room:home"
 # Pre-layout saves without explicit rooms retain the old workshop footprint.
 var rooms=b.get("rooms",["room:forge"] if b.plan=="workshop" else plan(b.plan).rooms)
 return rooms[clampi(int(parts[1]),0,rooms.size()-1)]
static func geometry(area:String)->Dictionary:
 var source=template(area)
 var floor_area=HoldRoyalStage.FLOOR if source=="room:throne" else Rect2(160,260,1020,650) if source=="room:forge" else Rect2(160,260,640,385)
 var size=Vector2(1300,1180) if source=="room:throne" else Vector2(1340,1010) if source=="room:forge" else Vector2(960,720)
 if source=="room:communal148":floor_area=Rect2(160,260,820,520);size=Vector2(1140,880)
 if owned_room(area):
  var owner=HoldArchitecture.current();var b=owner.record(room_parts(area)[0]) if owner!=null else {}
  var extra=Vector2(float(b.get("extend_x",0))*80,float(b.get("extend_y",0))*80)
  floor_area.size+=extra;size+=extra
 var exit_point=Vector2(650,floor_area.end.y-25) if source=="room:throne" else Vector2(480,floor_area.end.y-25)
 return {"template":source,"floor":floor_area,"size":size,"exit":exit_point,"bounds":Rect2(floor_area.position+Vector2(15,30),floor_area.size-Vector2(30,40))}
static func floor_number(area:String)->int:
 if owned_room(area):return int(room_parts(area)[1])
 if area==HoldHouseholds.LOFT:return 1
 return int(HoldNeighborhood.parts(area)[2]) if HoldNeighborhood.is_home(area) else 0
static func stair_position(area:String)->Vector2:
 if owned_room(area):
  var b=HoldArchitecture.current().record(room_parts(area)[0]);var p=b.get("stair",plan(b.get("plan","")).get("stair",[]))
  if p.size()==2:return Vector2(p[0],p[1])
 return HoldHouseholds.KETTLE_STAIR if template(area) in ["room:tavern",HoldHouseholds.LOFT] else HoldNeighborhood.STAIR
static func has_stairs(area:String)->bool:
 if owned_room(area):
  var b=HoldArchitecture.current().record(room_parts(area)[0]);return not b.is_empty() and b.get("rooms",plan(b.plan).rooms).size()>1
 return HoldNeighborhood.is_home(area) or area in ["room:tavern",HoldHouseholds.LOFT]
static func shell_cost(id:String)->Dictionary:
 var p=plan(id);var floor_count=0;var perimeter=0
 for room in p.rooms:
  var r=geometry(room).floor;floor_count+=ceili(r.size.x*r.size.y/6400.0);perimeter+=ceili((r.size.x+r.size.y)/80)
 return {"stone":floor_count+perimeter*2,"wood":floor_count+perimeter,"iron":8 if p.category=="Industry" else 2}
static func add_cost(total:Dictionary,cost:Dictionary):
 for key in cost:total[key]=int(total.get(key,0))+int(cost[key])
static func contents(w,area:String)->Array:
 # Authored placement data is compiled once through the same furnishing catalogue.
 var source=template(area);var list=w.definition_objects(source)
 if source in ["room:communal148","room:workshop148"]:return HoldLivingForges148.contents(w,source)
 if source in ["room:home","home:blueprint","room:wayfarer","room:greenhearth"] or source.begins_with("home:"):
  var storage=Vector2(700,550) if source in ["room:wayfarer","room:greenhearth"] else Vector2(650,420 if source=="room:home" else 380)
  list.append(w.furn("chest",storage.x,storage.y))
 if source=="room:forge":
  list.append(w.furn("anvil",580.475,445.7))
  for p in [Vector2(800,578),Vector2(800,823)]:list.append(w.furn("stone_pillar",p.x,p.y))
 if source=="room:throne":
  for o in HoldRoyalStage.objects():
   var kind=["royal_throne","royal_pillar","royal_arch","royal_brazier"][o.art]
   var f=w.furn(kind,o.p.x,o.p.y)
   if o.has("sort_y"):f.sort_y=o.sort_y
   list.append(f)
 return list
