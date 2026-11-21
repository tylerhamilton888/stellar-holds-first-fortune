extends RefCounted
# Positions are the feet of each object. Shelves face south in the furnishing atlas.
static var layouts={}
static func shelving(kind:String)->bool:return kind in ["bookcase","pantry"]
static func mounted_bays(floor_area:Rect2,industrial:bool)->Array:
 var bays=floori(floor_area.size.x/160.)
 var slots=[1,maxi(2,bays-2)] if industrial else [0,maxi(1,bays-2)]
 return slots.map(func(slot):return floor_area.position.x+80+slot*160)

static func arrange(source:String,objects:Array,floor_area:Rect2):
 var shelves=[]
 for item in objects:
  if shelving(item.furnishing) and item.get("autoplace",true):shelves.append(item)
 if shelves.is_empty():return
 var signature=hash([source,floor_area,objects])
 if layouts.has(signature):
  var positions=layouts[signature]
  for i in shelves.size():shelves[i].p=positions[i]
  return
 var blocked=[]
 var desks=[]
 for item in objects:
  if shelving(item.furnishing) and item.get("autoplace",true):continue
  blocked.append(HoldFurnishings.silhouette(item.furnishing,item.p).grow(3))
  if item.furnishing=="desk":desks.append(item.p)
 # Reserve the approach to the door in the back wall and the royal dais.
 if source in ["room:lodge","room:home"]:
  var x=720 if source=="room:lodge" else 560
  blocked.append(Rect2(x-54,floor_area.position.y-65,108,158))
 if source=="room:throne":blocked.append(Rect2(425,150,450,320))
 if source=="room:communal148":blocked.append(Rect2(floor_area.position+Vector2(167,-60),Vector2(135,155)))
 var positions=[]
 var industrial=source in ["room:communal148","room:forge","room:practice","room:training"]
 var mounts=mounted_bays(floor_area,industrial)
 var y=floor_area.position.y+34
 for item in shelves:
  var preferred_x=item.p.x
  if item.p.y>y+100 and not desks.is_empty():
   var nearest=Vector2(desks[0])
   for desk in desks:
    if item.p.distance_squared_to(desk)<item.p.distance_squared_to(nearest):nearest=desk
   preferred_x=nearest.x-58
  var chosen=Vector2.INF;var best=INF
  for x in range(int(floor_area.position.x)+44,int(floor_area.end.x)-40,6):
   var point=Vector2(x,y)
   var body=HoldFurnishings.silhouette(item.furnishing,point)
   if blocked.any(func(r):return r.intersects(body)):continue
   var score=absf(x-preferred_x)
   # Prefer a clear bay between the masonry piers.
   var pier_distance=absf(fposmod(x-floor_area.position.x+80.,160.)-80.)
   score+=maxf(0,35.-pier_distance)*2.
   for mount in mounts:score+=maxf(0,74.-absf(x-mount))*8.
   for neighbor in positions:
    if absf(neighbor.x-x)<=60.:score-=32.;break
   if score<best:chosen=point;best=score
  if chosen!=Vector2.INF:item.p=chosen
  blocked.append(HoldFurnishings.silhouette(item.furnishing,item.p).grow(4))
  positions.append(item.p)
 if layouts.size()>256:layouts.clear()
 layouts[signature]=positions

# Only civic fixtures in a saved public building belong to this upgrade.
# Free-standing pieces placed by a player still participate as obstructions.
static func upgrade_public(state,buildings:Array):
 if not HoldFrontier103.active(state):return
 var town=HoldFrontier103.data(state)
 if town.get("shelf_layout",0)>=1:return
 town.shelf_layout=1
 for b in buildings:
  if not HoldFrontier103.public_building(b):continue
  for z in b.rooms.size():
   var area=HoldBuildingPlans.room_id(str(b.id),z);var items=[];var targets=[]
   for f in state.surface.decor:
    if f.area!=area or int(f.get("z",0))!=0:continue
    var item={"furnishing":f.kind,"p":Vector2(f.x,f.y),"autoplace":bool(f.get("fixed",false))}
    items.append(item)
    if item.autoplace and shelving(f.kind):targets.append([f,item])
   if targets.is_empty():continue
   for chest in state.surface.chests.values():
    if chest.area==area and int(chest.get("z",0))==0:
     items.append({"furnishing":"chest","p":Vector2(chest.x,chest.y)})
   arrange(b.rooms[z],items,HoldBuildingPlans.geometry(b.rooms[z]).floor)
   for pair in targets:
    pair[0].x=pair[1].p.x;pair[0].y=pair[1].p.y
