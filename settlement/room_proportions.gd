extends RefCounted
const RECORDS="room:records_loft"
const RECORD_DESK=Vector2(610,415)
const OFFICE_STAIR=Vector2(550,495)
const ORDINARY=Rect2(160,260,640,385)

static func floor_rect(source:String,fitted:bool)->Rect2:
 if source=="room:throne":return HoldRoyalStage.FLOOR
 if source=="room:forge":return Rect2(160,260,1020,650)
 if source=="room:communal148":return Rect2(160,260,820,452 if fitted else 520)
 if not fitted:return ORDINARY
 if HoldNeighborhood.is_home(source):
  return Rect2(270,350,500,295) if HoldNeighborhood.parts(source)[2]=="1" else Rect2(190,260,590,360)
 match source:
  RECORDS:return Rect2(288,298,412,290)
  "room:research","room:commission","room:clan_archive":return Rect2(180,260,600,342)
  "room:practice","room:training":return Rect2(188,260,588,342)
  "room:kettle_loft":return Rect2(234,282,546,363)
 return ORDINARY

static func fit_loft(items:Array):
 # Keep the saved family chest in the same place. Beds flank its open approach.
 for item in items:
  match item.furnishing:
   "bed":item.p=Vector2(478,468)
   "double_bed":item.p=Vector2(337,476)
   "desk":item.p=Vector2(610,430)
   "chair":item.p=Vector2(656,451)
   "lamp":item.p=Vector2(305,398) if item.p.x<500 else Vector2(730,390)

static func records()->Array:
 var result=[]
 for entry in [["bookcase",360,332],["bookcase",410,332],["bookcase",465,332],["desk",RECORD_DESK.x,RECORD_DESK.y],["chair",650,445],["lamp",659,365]]:
  result.append({"kind":"furnishing","furnishing":entry[0],"p":Vector2(entry[1],entry[2])})
 return result

static func upgrade_public(s,instances:Array):
 if not HoldFrontier103.active(s):return
 var town=HoldFrontier103.data(s)
 if town.get("room_proportions",0)>=1:return
 town.room_proportions=1
 for b in instances:
  if not HoldFrontier103.public_building(b) or b.plan not in ["frontier_office","frontier_forge"]:continue
  if b.get("fitted_rooms",false) or b.get("extend_x",0)!=0 or b.get("extend_y",0)!=0:continue
  var ground=HoldBuildingPlans.room_id(str(b.id));var upper=HoldBuildingPlans.room_id(str(b.id),1)
  var protected_items=s.surface.decor.any(func(f):return f.area in [ground,upper] and (not f.get("fixed",false) or int(f.get("z",0))!=0))
  if protected_items or b.has("stair"):continue
  if b.get("rooms",[]).is_empty():continue
  var footprint=floor_rect(b.rooms[0],true)
  var stock_outside=s.surface.chests.values().any(func(c):return c.area==ground and not footprint.encloses(HoldFurnishings.footprint("chest",Vector2(c.x,c.y))))
  var prop_outside=s.surface.decor.any(func(f):return f.area==ground and not footprint.encloses(HoldFurnishings.footprint(f.kind,Vector2(f.x,f.y))))
  if stock_outside or prop_outside:continue
  if s.surface.chests.values().any(func(c):return c.area==upper or (c.area==ground and not c.get("fixed",false))):continue
  var edited=false
  for level in b.get("construction",{}).values():
   if not level.get("tiles",{}).is_empty() or not level.get("levels",{}).is_empty() or not level.get("links",{}).is_empty():edited=true
  if edited:continue
  if b.plan=="frontier_office":
   if b.get("rooms",[])!=["room:research","room:research"]:continue
   var old=s.surface.decor.filter(func(f):return f.area==upper)
   var counts={}
   for f in old:counts[f.kind]=int(counts.get(f.kind,0))+1
   if counts!={"bookcase":5,"desk":2,"lamp":3,"orrery":1}:continue
   for item in old:s.surface.decor.erase(item)
   b.rooms[1]=RECORDS
   var furnishings=records()
   preload("res://settlement/wall_storage.gd").arrange(RECORDS,furnishings,floor_rect(RECORDS,true))
   for item in furnishings:
    s.surface.decor.append({"area":upper,"kind":item.furnishing,"x":item.p.x,"y":item.p.y,"z":0,"fixed":true})
  b.fitted_rooms=true
