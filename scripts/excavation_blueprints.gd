class_name HoldExcavationBlueprints
extends RefCounted
# Guides never own terrain, cargo, furnishings or mining rewards.
const PURPOSES=["Undesignated","Bedroom","Kitchen","Forge","Workshop","Storehouse","Great Hall","Corridor"]
var owner_ref:WeakRef
var owner:
 get:return owner_ref.get_ref()
var g:
 get:return owner.g
var w:
 get:return owner.w
var model:
 get:return owner.model
var selected=""
var purpose="Undesignated"
var zoom=2.5
var map_center=Vector2(500,400)
var message="Drag a chamber or corridor. Mine its rock with your normal tools."
func _init(play):owner_ref=weakref(play);map_center=play.g.player
func available()->bool:return g.zone=="mine" and g.deep.world==w and g.state.active_site==g.deep.site
func data()->Dictionary:
 if not w.data.has("blueprints154"):w.data.blueprints154={"next":1,"rooms":[],"stairs":[]}
 return w.data.blueprints154
func rooms()->Array:return data().rooms.filter(func(r):return int(r.depth)==w.depth()) if available() else []
func chosen()->Dictionary:
 for r in rooms():
  if str(r.id)==selected:return r
 return {}
func bounds(r:Dictionary)->Rect2i:return Rect2i(int(r.x),int(r.y),int(r.w),int(r.h))
func cells(r:Dictionary)->Array:return model.room_cells(r)
func started(r:Dictionary)->bool:
 if r.get("room","")!="":return true
 for k in r.original:
  var xy=k.split(",");var c=Vector2i(int(xy[0]),int(xy[1]))
  if w.at(c,int(r.depth))!=int(r.original[k]) or float(w.layer(int(r.depth)).damage.get(k,0))>float(r.damage.get(k,0)):return true
 return false
func validate(r:Dictionary,ignore:String="")->bool:
 if not available() or int(r.depth)!=w.depth():message="Visit this worksite and level to change its plans.";return false
 var b=bounds(r)
 if b.size.x<3 or b.size.y<3 or b.size.x>20 or b.size.y>20:message="Choose 3–20 tiles along each side.";return false
 if b.position.x<1 or b.position.y<1 or b.end.x>=Deepworks.W or b.end.y>=Deepworks.H:message="Keep the plan inside the surveyed boundary.";return false
 for other in rooms():
  if str(other.id)!=ignore and bounds(other).intersects(b):message="Join plans edge to edge; their floor spaces cannot overlap.";return false
 for other in model.data.rooms.values():
  if int(other.depth)==w.depth() and str(other.id)!=r.get("room","") and bounds(other).intersects(b):message="An established room already occupies this ground.";return false
 for c in cells(r):
  if w.at(c)==8 or HoldMineworks143.reserved(w,c,w.depth()):message="Keep faults, adits and protected landings clear.";return false
  if w.landmark_solid(Deepworks.center(c),-1,Vector2(20,20)):message="An existing landmark occupies this ground.";return false
 return true
func save_rectangle(a:Vector2i,b:Vector2i)->bool:
 if not available():return false
 var old=chosen()
 if not old.is_empty() and started(old):message="Mining has begun. Add another plan to extend this space.";return false
 if old.is_empty() and data().rooms.size()>=64:message="This mine already has 64 plans; existing plans are preserved.";return false
 var r={"id":selected if not old.is_empty() else str(data().next),"depth":w.depth(),"x":mini(a.x,b.x),"y":mini(a.y,b.y),"w":absi(a.x-b.x)+1,"h":absi(a.y-b.y)+1,"purpose":old.get("purpose",purpose),"room":"","floor":old.get("floor",""),"wall":old.get("wall",""),"original":{},"damage":{}}
 if not validate(r,selected):return false
 for c in cells(r):
  var k=Deepworks.key(c);r.original[k]=w.at(c);r.damage[k]=w.layer().damage.get(k,0)
 if old.is_empty():data().rooms.append(r);data().next+=1
 else:data().rooms[data().rooms.find(old)]=r
 selected=str(r.id);map_center=Vector2(bounds(r).get_center())*40;zoom=3
 message="Plan saved. Stone, ore and mining damage remain untouched.";g.save_game();return true
func configure(field:String,value:String,id:String)->bool:
 if not available() or id!=selected:return false
 if field=="purpose" and value not in PURPOSES:return false
 if field not in ["purpose","floor","wall"]:return false
 if field!="purpose" and value!="" and (not LivingWorks.FINISHES.has(value) or LivingWorks.FINISHES[value].surface!=field):return false
 var r=chosen()
 if r.is_empty():
  if field=="purpose":purpose=value;return true
  return false
 r[field]=value
 if field=="purpose" and model.data.rooms.has(r.room):model.data.rooms[r.room].name=value+" "+str(r.id)
 g.save_game();return true
func forget():
 var r=chosen()
 if r.is_empty():return
 data().rooms.erase(r);selected="";message="Guide removed. Excavations, rooms, finishes and possessions remain.";g.save_game()
func progress(r:Dictionary)->Dictionary:
 var open=0;var rock=0;var hard=0;var blocked=0;var damage=0.0
 for c in cells(r):
  var k=w.at(c,int(r.depth))
  if k==0:open+=1
  elif k==8:blocked+=1
  else:
   rock+=1
   if k==7 and not g.state.steel:hard+=1
   damage+=float(w.layer(int(r.depth)).damage.get(Deepworks.key(c),0))
 return {"open":open,"total":int(r.w)*int(r.h),"rock":rock,"hard":hard,"blocked":blocked,"damage":damage,"state":"Obstructed" if blocked else "Excavated" if rock==0 else "Excavating" if started(r) else "Planned"}
func prepare_room()->bool:
 var r=chosen()
 if r.is_empty():return false
 if model.data.rooms.has(r.room):return true
 if not validate(r,selected):return false
 if progress(r).rock>0:message="Excavate the planned floor before furnishing or finishing it.";return false
 var target=cells(r).filter(func(c):return w.walkable(c))
 if target.is_empty() or w.route(Deepworks.cell(g.player),w.depth(),"",target[0]).is_empty():message="Open a walkable route into the chamber first.";return false
 var id="blueprint154_"+str(r.id)
 var record={"id":id,"kind":"undesignated","depth":r.depth,"x":r.x,"y":r.y,"w":r.w,"h":r.h,"name":r.purpose+" "+str(r.id),"metrics":{}}
 model.data.rooms[id]=record;r.room=id;model.refresh();message="Chamber ready. Furnish it to suit; its label grants no equipment.";g.save_game();return true
func finish_parts(r:Dictionary)->Array:
 var out=[];var walls={};var z=int(r.depth)
 for c in cells(r):
  if r.floor!="" and model.data.surfaces.get(w.link_key(c,z),{}).get("kind","")!=r.floor:out.append({"cell":c,"kind":r.floor})
  if r.wall=="":continue
  for d in Deepworks.DIRS:
   var n=c+d;var k=Deepworks.key(n)
   if bounds(r).has_point(n) or w.at(n,z) in [0,8] or walls.has(k):continue
   walls[k]=true
   if model.data.surfaces.get(w.link_key(n,z),{}).get("kind","")!=r.wall:out.append({"cell":n,"kind":r.wall})
 return out
func cost(r:Dictionary)->Dictionary:
 var total={}
 for part in finish_parts(r):HoldBuildingPlans.add_cost(total,LivingWorks.FINISHES[part.kind].cost)
 return total
func finish_nearby()->int:
 if not prepare_room():return 0
 var r=chosen();var count=0;var reason=""
 for part in finish_parts(r):
  var p=Deepworks.center(part.cell)
  if p.distance_to(g.player)>105 or not w.visible(g.player,p):continue
  var result=model.finish(part.cell,part.kind)
  if result.ends_with("finished."):count+=1
  else:reason=result
  if count>=32:break
 message="Finished %d nearby surfaces." % count if count else (reason if reason!="" else "Approach an unfinished surface with its materials.")
 if count:g.save_game();g.sound.effect("stone")
 return count
func plan_stair(c:Vector2i)->bool:
 if not available():return false
 var z=w.depth()
 if z>=Deepworks.DEPTHS-1:message="These lateral worksites connect through existing adits; no lower level is supported here.";return false
 for level in [z,z+1]:
  for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var n=c+d
   if w.at(n,level)==8 or HoldMineworks143.reserved(w,n,level) or w.landmark_solid(Deepworks.center(n),level,Vector2(20,20)):
    message="Choose room for both landings, clear of faults, adits and landmarks.";return false
 for stair in data().stairs:
  if int(stair.depth)==z and Vector2i(stair.x,stair.y)==c:message="This stair connection is already planned.";return false
 data().stairs.append({"depth":z,"x":c.x,"y":c.y});message="Stair guide saved. Excavate both landings through existing access before fitting it.";g.save_game();return true
func stair_here()->Dictionary:
 var c=Deepworks.cell(g.player)
 for s in data().stairs:
  if int(s.depth)==w.depth() and Vector2i(s.x,s.y)==c:return s
 return {}
func fit_stair()->bool:
 if not available() or stair_here().is_empty():message="Stand on a planned upper landing.";return false
 var c=Deepworks.cell(g.player);var z=w.depth()
 if w.can_descend(c,z) and w.data.links[w.link_key(c,z)].get("kind","stair")=="stair":message="The stairs are already connected. E down; Shift+E up.";return false
 for level in [z,z+1]:
  for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var n=c+d
   if not w.walkable(n,level) or HoldMineworks143.reserved(w,n,level):message="Mine both five-tile landings and move obstructions before fitting stairs. Use existing access to reach below.";return false
 # Existing carver only touches already-excavated cells here: no lost rock/yields.
 message=w.carve_stairs(c,"stair");var done=w.can_descend(c,z)
 if done:g.save_game();g.sound.effect("stone")
 return done
func forget_stair():
 if not available():return
 var s=stair_here()
 if s.is_empty():message="Stand on the upper stair guide to remove it.";return
 data().stairs.erase(s);message="Stair guide removed; any physical connection remains.";g.save_game()
func draw():
 if not available():return
 for r in rooms():
  var rect=Rect2(bounds(r));rect.position*=40;rect.size*=40
  if not rect.grow(180).has_point(g.player):continue
  var col=Color("82b7bb") if r.room=="" else Color("82b68a")
  # Guide lines overlay surveyed floor/rock only; unexplored geology stays hidden.
  for c in cells(r):
   if not w.layer().seen.has(Deepworks.key(c)):continue
   var p=Vector2(c)*40
   if c.x==int(r.x):g.draw_line(p,p+Vector2(0,40),col,2)
   if c.y==int(r.y):g.draw_line(p,p+Vector2(40,0),col,2)
   if c.x==int(r.x+r.w)-1:g.draw_line(p+Vector2(40,0),p+Vector2(40,40),col,2)
   if c.y==int(r.y+r.h)-1:g.draw_line(p+Vector2(0,40),p+Vector2(40,40),col,2)
 for s in data().stairs:
  if int(s.depth)!=w.depth() or not w.layer().seen.has(Deepworks.key(Vector2i(s.x,s.y))):continue
  var p=Vector2(s.x,s.y)*40
  for i in 4:g.draw_line(p+Vector2(5+i*3,7+i*7),p+Vector2(35-i*3,7+i*7),Color("d3b576"),2)
