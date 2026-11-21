extends RefCounted
const Ground=preload("res://settlement/ground.gd")
static func light(g,center:Vector2,size:Vector2,tint:Color):
 g.draw_texture_rect(Ground.texture("warm"),Rect2(center-size*.5,size),false,tint)
static func mounted(g,id:String,center:Vector2,width:float,height:float):
 var rect=Rect2(center-Vector2(width,height)*.5,Vector2(width,height))
 g.draw_texture_rect(Ground.texture(id),Rect2(rect.position+Vector2(1,2),rect.size),false,Color(.07,.06,.05,.62))
 g.draw_texture_rect(Ground.texture(id),rect,false,Color("e9e1cf"))
static func shell(g,area:String,geom:Dictionary):
 var r:Rect2=geom.floor;var source=geom.template
 var industrial=source in ["room:communal148","room:forge","room:practice","room:training"]
 var civic=source in ["room:research","room:commission","room:market","room:clan_archive","room:records_loft"]
 var practice=source in ["room:practice","room:training"]
 var opening="watch" if practice else "flue" if industrial else "archive" if civic else "amber"
 var mounts=preload("res://settlement/wall_storage.gd").mounted_bays(r,industrial)
 for slot in mounts.size():
  var x=mounts[slot]
  if x>r.end.x-55:continue
  if source=="room:home" and not HoldFirstVisit99.lodge_intro(g.state) and absf(x-560)<100:continue
  var id=opening if slot==0 or not industrial else "archive"
  if practice and slot==1:id="peg"
  if slot==1:
   if source=="room:research":id="map"
   elif source=="room:market":id="watch" if area==HoldFrontier103.room(g.state,"watch") else "archive"
   elif source=="room:home":id="peg"
  var width=83 if id=="map" else 85 if practice and id=="watch" else 58 if id in ["watch","peg"] else 98 if industrial else 87
  mounted(g,id,Vector2(x,r.position.y-22),width,58 if id in ["watch","peg","map"] else 55 if industrial else 51)
  if id in ["amber","archive","peg"]:
   light(g,Vector2(x+6,r.position.y+52),Vector2(148,103),Color(.66,.83,.87,.19) if civic or industrial else Color(1,.82,.61,.35))
 if industrial and HoldForge147.active(g):
  var hearth=HoldForge147.forge_position(g)
  if hearth!=Vector2.INF:
   # The iron hearth sits on its own fitted fireproof course and a recessed ash grate.
   if source=="room:communal148":
    # The hood sits between two wall piers. An elbow brings the uptake back to the furnace.
    var vent_x=r.position.x+240
    var duct=PackedVector2Array([Vector2(vent_x,r.position.y+9),Vector2(vent_x,r.position.y+28),Vector2(hearth.x+6,r.position.y+53),hearth+Vector2(6,-90)])
    g.draw_polyline(duct,Color("322c29"),17,true);g.draw_polyline(duct,Color("78543b"),12,true)
    g.draw_polyline(duct,Color("ab7a51"),4,true)
    for y in [r.position.y+57,r.position.y+69]:
     g.draw_line(Vector2(hearth.x-2,y),Vector2(hearth.x+14,y),Color("483c33"),4)
   var apron=Rect2(hearth+Vector2(-105,-47),Vector2(213,85))
   Ground.plaza(g,apron,Color("544f46"),Color("837054"))
   var grate=Rect2(hearth+Vector2(-43,16),Vector2(86,13))
   g.draw_rect(grate,Color("494540"));g.draw_rect(grate,Color("282a2b"),false,2)
   for i in range(4,83,7):g.draw_line(grate.position+Vector2(i,2),grate.position+Vector2(i-2,11),Color("26292a"),2)
   if g.state.opening>=2:light(g,hearth+Vector2(0,12),Vector2(234,127),Color(1,.76,.58,.51))
 # Highlight the inside edge of the actual landing. The portal remains full width.
 var door:Vector2=geom.exit
 var sill=Rect2(door.x-40,r.end.y-12,80,12)
 if not HoldCivicArt.has_exit(area):return
 HoldArchitectureStyles.floor_draw(g,sill,"slate",Color("d2c5aa"))
 g.draw_line(sill.position,sill.position+Vector2(80,0),Color("ab9475"),1.6)
static func home_objects(g)->Array:
 var list=[]
 if g.zone!="claim" or g.surface.area!="claim" or g.surface.house.level()!=0:return list
 var h=g.surface.house
 if not h.view.inside():
  # The exterior cottage owns its apron. Attach to its actual paid doorway.
  for group in h.view.groups():
   for k in group.portals:
    var d:Vector2i=group.portals[k]
    var p=h.center(h.coords(k))
    if d==Vector2i.DOWN and p.distance_to(g.player)<640:
     list.append({"kind":"handwork","p":p,"sort_y":-100001.,"porch_sill":p})
  return list
 var room=h.view.current()
 for f in g.state.surface.decor:
  if f.kind not in ["bed","double_bed"] or not h.local(f):continue
  var p=Vector2(f.x,f.y)
  if not room.body.has(h.key(h.cell(p))):continue
  var bedmat=Rect2(p+Vector2(-24,-57),Vector2(69,77))
  var wc=h.cell(p)
  for j in 4:
   wc+=Vector2i.UP
   var wk=h.key(wc)
   if room.body.has(wk):continue
   if room.cells.has(wk) and h.tiles().get(wk,{}).get("wall","")=="wall":
    var mount=h.center(wc)+Vector2(7,20)
    list.append({"kind":"handwork","p":h.center(wc),"sort_y":mount.y+1.,"bedrail":mount})
   break
  var valid=true
  for vertex in [bedmat.position,bedmat.end,Vector2(bedmat.position.x,bedmat.end.y),Vector2(bedmat.end.x,bedmat.position.y)]:
   if not room.body.has(h.key(h.cell(vertex))):valid=false
  if valid:list.append({"kind":"handwork","p":p,"sort_y":-100001.,"bedmat":bedmat})
 for k in room.cells:
  var c=h.coords(k);var tile=h.tiles().get(k,{})
  if tile.get("wall","")!="window":continue
  var p=h.center(c);var inner=Vector2i.ZERO
  for d in [Vector2i.DOWN,Vector2i.RIGHT,Vector2i.LEFT,Vector2i.UP]:
   if room.body.has(h.key(c+d)):inner=d;break
  if inner!=Vector2i.ZERO:list.append({"kind":"handwork","p":p,"sort_y":-100000.,"sun":p+Vector2(inner)*36.})
 return list
static func home_paint(g,o):
 if o.has("bedrail"):
  mounted(g,"peg",o.bedrail-Vector2(0,38),53,55)
  light(g,o.bedrail+Vector2(15,-24),Vector2(76,55),Color(1,.79,.50,.35))
 elif o.has("bedmat"):HoldRoomLayout.rug(g.surface.world,o.bedmat,Color("69583f"))
 elif o.has("sun"):light(g,o.sun,Vector2(80,57),Color(1,.82,.64,.33))
 elif o.has("porch_sill"):
  var p:Vector2=o.porch_sill
  var r=Rect2(p+Vector2(-34,19),Vector2(68,18))
  Ground.plaza(g,r,Color("9d9279"),Color("807158"))

# Return rugs and flush stone bases only where there is furniture to use them.
# Adjacent bunks and counters share one run; moving a piece breaks the run.
static func work_areas(items:Array,source:String)->Array:
 var result=[]
 var rows={}
 for item in items:
  var p=Vector2(item.x,item.y);var kind=str(item.kind)
  var family=""
  var piece=Rect2()
  if kind in ["bed","double_bed"]:
   family="bed"
   var width=116 if kind=="double_bed" else 76
   piece=Rect2(p-Vector2(width*.5,70),Vector2(width,94))
  elif kind in ["serving_counter","counter"] and source!="room:tavern":
   family="counter";piece=Rect2(p-Vector2(52,27),Vector2(104,62))
  elif kind=="tea_table" and source=="room:tavern":
   family="dining";piece=Rect2(p-Vector2(65,45),Vector2(130,84))
  if family!="":
   var key=family+":"+str(roundi(p.y/12.))
   if not rows.has(key):rows[key]=[]
   rows[key].append(piece)
  elif kind=="orrery":
   result.append(["instrument",Rect2(p-Vector2(58,34),Vector2(116,56))])
  elif kind=="tea_table":
   result.append(["table",Rect2(p-Vector2(77,48),Vector2(154,90))])
  elif kind=="desk" and (source in ["room:home","room:research","room:commission","room:clan_archive","room:records_loft","room:throne"] or source.begins_with("home:")):
   result.append(["desk",Rect2(p-Vector2(46,36),Vector2(92,67))])
  elif kind=="hearth" and source!="room:communal148":result.append(["fire",Rect2(p-Vector2(95,51),Vector2(190,126))])
 for key in rows:
  var pieces=rows[key];pieces.sort_custom(func(a,b):return a.position.x<b.position.x)
  var family=key.get_slice(":",0);var band=Rect2()
  var gap=42 if family=="dining" else 10
  for piece in pieces:
   if band.has_area() and band.end.x+gap<piece.position.x:
    result.append([family,band]);band=Rect2()
   band=band.merge(piece) if band.has_area() else piece
  result.append([family,band])
 return result
static func indoor_stairs(g,p:Vector2,up:bool):
 preload("res://settlement/indoor_grade.gd").draw(g,p,up)

static func floor_items(w,area:String)->Array:
 var items=[]
 for obj in w.room_objects(area):
  items.append({"kind":obj.furnishing,"x":obj.p.x,"y":obj.p.y})
 for obj in w.g.state.surface.decor:
  if obj.get("area","")==area and int(obj.get("z",0))==0:items.append(obj)
 return items

static func supported_marks(w,source:String)->Array:
 var area=w.g.surface.area
 var floor_area=HoldRoomLayout.floor_rect(area).grow(-15)
 var reserved=[]
 if HoldBuildingPlans.has_stairs(area):
  reserved.append(Rect2(HoldBuildingPlans.stair_position(area)-Vector2(50,80),Vector2(100,128)))
 if HoldCivicArt.has_exit(area):
  reserved.append(Rect2(HoldRoomLayout.exit_point(area)-Vector2(40,14),Vector2(80,52)))
 var marks=[]
 for mark in work_areas(floor_items(w,area),source):
  var rect:Rect2=floor_area.intersection(mark[1])
  if not rect.has_area():continue
  if reserved.any(func(r):return r.intersects(rect)):continue
  marks.append([mark[0],rect])
 return marks

static func furnish_floor(w,source:String):
 var g=w.g
 for mark in supported_marks(w,source):
  var rect:Rect2=mark[1]
  match mark[0]:
   "instrument":Ground.plaza(g,rect,Color("65716a"),Color("8d7951"))
   "fire":light(g,rect.get_center(),rect.size,Color(1,.78,.56,.32))
   "bed","desk":HoldRoomLayout.rug(w,rect,Color("476b69"))
   "table","counter","dining":HoldRoomLayout.rug(w,rect,Color("765a48"))

static func practice_floor(w,source:String):
 var g=w.g
 var rect=Rect2(305,345,330,185) if source=="room:training" else Rect2(320,405,296,156)
 var furnishings=floor_items(w,g.surface.area)
 if furnishings.is_empty() and HoldBuildingPlans.owned_room(g.surface.area):return
 for obj in furnishings:
  if rect.intersects(HoldFurnishings.footprint(obj.kind,Vector2(obj.x,obj.y))):return
 g.draw_texture_rect(Ground.texture("sparring_mat"),rect,false)
