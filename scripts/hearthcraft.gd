class_name HoldHearthcraft
extends RefCounted
# Surface construction uses the same physical claim and pack. No hidden room teleport.
const CELL=40.0
const MAX_Z=5 # Ground + four upper storeys + accessible roof deck.
const MATERIALS=preload("res://assets/directional-v47/building-materials.png")
const COSTS={"stone_floor":{"stone":1},"wood_floor":{"wood":1},"wall":{"stone":2,"wood":1},"window":{"stone":2,"wood":1},"door":{"wood":3},"roof":{"wood":1},"stairs":{"wood":4,"stone":2},"ladder":{"wood":3}}
const TITLES={"stone_floor":"Stone floor","wood_floor":"Oak floor","wall":"Stone wall","window":"Window wall","door":"Oak door","roof":"Slate roof","stairs":"Stair flight upward","ladder":"Ladder upward","remove":"Recover top piece"}
var surface_ref:WeakRef
var s:
 get:return surface_ref.get_ref()
var g
var timer=0.0
var impact=0.0
var contact=Vector2.ZERO
var reason=""
func _init(surface):surface_ref=weakref(surface);g=surface.g
func data()->Dictionary:
 s.ensure()
 if g.state.claim_id=="":return {}
 var h=g.state.surface.homes[g.state.claim_id]
 if not h.has("building"):h.building={"tiles":{},"facts":{}}
 if not h.building.has("levels"):h.building.levels={}
 if not h.building.has("links"):h.building.links={}
 if not h.building.has("z"):h.building.z=0
 return h.building
func level()->int:return int(data().get("z",0)) if s.area=="claim" else 0
func tiles(z:int=-1)->Dictionary:
 var d=data()
 if d.is_empty():return {}
 if z<0:z=level()
 if z==0:return d.tiles
 if not d.levels.has(str(z)):d.levels[str(z)]={}
 return d.levels[str(z)]
func local(o:Dictionary)->bool:return o.area==s.area and int(o.get("z",0))==level()
func link_key(c:Vector2i,z:int)->String:return str(z)+"/"+key(c)
func link_at(c:Vector2i,z:int)->bool:return data().get("links",{}).has(link_key(c,z))
func on_floor(p:Vector2,z:int)->bool:return tiles(z).has(key(cell(p)))
func occupied_at(c:Vector2i,z:int)->bool:
 if g.handworks:
  for f in g.handworks.data().facilities:
   if f.area=="surface:claim:"+str(z) and center(c).distance_to(g.handworks.pos(f))<55:return true
 for list in [g.state.surface.chests.values(),g.state.surface.decor]:
  for o in list:
   if o.area=="claim" and int(o.get("z",0))==z and HoldFurnishings.footprint(o.get("kind","chest"),Vector2(o.x,o.y)).intersects(Rect2(Vector2(c)*CELL,Vector2.ONE*CELL).grow(5)):return true
 return s.area=="claim" and level()==z and center(c).distance_to(g.player)<30
func use_stairs(up:bool)->bool:
 var z=level();var lower=z if up else z-1
 if s.area!="claim" or lower<0:return false
 var found=Vector2i(-1,-1);var best=55.0
 for k in data().links:
  if not k.begins_with(str(lower)+"/"):continue
  var c=coords(k.get_slice("/",1));var distance=g.player.distance_to(center(c))
  if distance<best:best=distance;found=c
 if found.x<0:g.notify("Stand at a stair or ladder landing. E up; Shift+E down.");return false
 var dest=z+1 if up else z-1
 var t=tiles(dest).get(key(found),{})
 if t.is_empty() or t.get("wall","")!="" or occupied_at(found,dest):g.notify("Clear the landing before climbing.");return false
 var travelling_cart=g.handworks.attached()
 if not travelling_cart.is_empty():g.notify("Park the cart [C] before using a house stair. Outdoor and mine freight routes stay available.");return false
 data().z=dest;g.player=center(found);s.cancel_placement();impact=0;g.velocity=Vector2.ZERO;g.walking_pose=false
 data().facts["ascend" if up else "descend"]=true
 g.camera=s.camera_target();g.sound.effect("wood",-17);g.save_game();g.notify("Homestead Z+%d · E up / Shift+E down at landings" % dest);return true

func cell(p:Vector2)->Vector2i:return Vector2i((p/CELL).floor())
func center(c:Vector2i)->Vector2:return Vector2(c)*CELL+Vector2.ONE*CELL/2
func key(c:Vector2i)->String:return str(c.x)+","+str(c.y)
func coords(k:String)->Vector2i:
 var v=k.split(",");return Vector2i(int(v[0]),int(v[1]))
func tile(c:Vector2i)->Dictionary:return tiles().get(key(c),{})
func walls(map:Dictionary)->Array:
 var result=[]
 for k in map:
  if map[k].get("wall","")!="" and not (map[k].wall=="door" and map[k].get("open",false)):
   result.append(Rect2(Vector2(coords(k))*CELL,Vector2.ONE*CELL))
 return result
func obstacles()->Array:return walls(tiles()) if s.area=="claim" else []
func occupied(c:Vector2i)->bool:
 if g.fieldwork:
  for b in g.fieldwork.data().beds:
   if g.fieldwork.local(b) and center(c).distance_to(g.fieldwork.pos(b))<55:return true
 if g.handworks:
  for f in g.handworks.data().facilities:
   if g.handworks.local(f) and center(c).distance_to(g.handworks.pos(f))<55:return true
 var rect=Rect2(Vector2(c)*CELL,Vector2.ONE*CELL).grow(8)
 for o in g.state.surface.chests.values():
  if local(o) and rect.intersects(HoldFurnishings.footprint("chest",Vector2(o.x,o.y))):return true
 for o in g.state.surface.decor:
  if local(o) and rect.intersects(HoldFurnishings.footprint(o.kind,Vector2(o.x,o.y))):return true
 return false
func routes_open(map:Dictionary)->bool:
 # Doors count as operable passages; walls may never seal a player or landmark away.
 var blocked={}
 for r in (s.base_obstacles() if level()==0 else []):
  for y in range(5,24):
   for x in range(2,45):
    if r.grow(10).has_point(center(Vector2i(x,y))):blocked[key(Vector2i(x,y))]=true
 for k in map:
  if map[k].get("wall","") in ["wall","window"]:blocked[k]=true
 var todo=[cell(g.player)];var seen={key(todo[0]):true};var head=0
 while head<todo.size():
  var c=todo[head];head+=1
  for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var n=c+d;var k=key(n)
   if n.x<3 or n.x>43 or n.y<6 or n.y>23 or blocked.has(k) or seen.has(k):continue
   if level()>0 and not map.has(k):continue
   seen[k]=true;todo.append(n)
 for p in s.points():
  if p.action.begins_with("house:"):continue
  var found=false
  for c in todo:
   if center(c).distance_to(p.p)<75:found=true;break
  if not found:return false
 return seen.has(key(cell(Vector2(300,760)))) if level()==0 else seen.size()>0
func valid(c:Vector2i,kind:String,check_routes:bool=true)->bool:
 reason=""
 if s.area!="claim":reason="Build houses in your claim yard.";return false
 var p=center(c)
 if g.player.distance_to(p)>170:reason="Move within reach of your work.";return false
 if not Rect2(260,320,1300,600).has_point(p):reason="Keep to the clear homestead building grounds.";return false
 var t=tile(c)
 if kind=="remove":
  if t.is_empty():reason="No construction here.";return false
  if link_at(c,level()):
   if tiles(level()+1).size()>1 or occupied_at(c,level()+1) or tiles(level()+2).has(key(c)):reason="Recover the upper storey before removing its only construction access.";return false
   return true
  if t.get("roof",false):
   var above=tiles(level()+1).get(key(c),{})
   if occupied_at(c,level()+1) or above.get("floor","")!="roof_floor" or above.get("wall","")!="" or above.get("roof",false) or link_at(c,level()) or link_at(c,level()+1):reason="Clear the upper floor, furniture and passage first.";return false
  elif t.get("wall","")=="":
   if occupied(c) or occupied_at(c,level()) or tiles(level()+1).has(key(c)) or link_at(c,level()) or link_at(c,level()-1):reason="This floor supports a Dwarf, furnishing, upper level or passage.";return false
   if level()>0:
    var draft=tiles().duplicate(true);draft.erase(key(c))
    if not routes_open(draft):reason="Keep a continuous floor route to the stairs.";return false
  return true
 for r in (s.base_obstacles() if level()==0 else []):
  if r.grow(18).intersects(Rect2(Vector2(c)*CELL,Vector2.ONE*CELL)):reason="Existing buildings need clear foundations.";return false
 for point in s.points():
  if point.action.begins_with("house:") or point.action.begins_with("chest:") or point.action=="house_rest" or point.action=="house_up" or point.action=="house_down":continue
  if p.distance_to(point.p)<85:reason="Keep entrances and workstations clear.";return false
 if kind!="roof" and occupied(c):reason="Move the furnishing before building here.";return false
 if kind in ["wall","window","door","roof","stairs","ladder"] and level()>=MAX_Z:reason="This is the highest roof deck; expand floors here or build below.";return false
 if kind in ["stairs","ladder"]:
  if not t.has("floor") or t.get("wall","")!="" or occupied(c):reason="Choose a clear floor for both landings.";return false
  if link_at(c,level()):reason="A passage already joins these levels.";return false
  var upper=tiles(level()+1).get(key(c),{})
  if upper.get("wall","")!="" or occupied_at(c,level()+1):reason="The upper landing is occupied.";return false
  return true
 if kind.ends_with("floor"):
  if level()>0 and not tiles(level()-1).has(key(c)):reason="Upper floors need a foundation directly beneath them.";return false
  if not t.is_empty():reason="A foundation is already laid here.";return false
 else:
  if not t.has("floor"):reason="Lay a floor foundation first.";return false
  if kind=="roof":
   if t.get("roof",false):reason="This tile already has a roof.";return false
  elif t.get("wall","")!="":reason="Recover the current wall before replacing it.";return false
 if kind in ["wall","window","door"]:
  if link_at(c,level()) or link_at(c,level()-1):reason="Keep stair landings clear.";return false
  if Rect2(Vector2(c)*CELL,Vector2.ONE*CELL).grow(15).has_point(g.player):reason="Step aside before raising a wall.";return false
  if check_routes:
   var draft=tiles().duplicate(true);var item=t.duplicate();item.wall=kind;draft[key(c)]=item
   if not routes_open(draft):reason="Leave a door or gap: keep every destination reachable.";return false
 return true
func ready_to_build(c:Vector2i,kind:String)->bool:
 if not valid(c,kind):return false
 if kind!="remove" and (not COSTS.has(kind) or not g.state.afford(COSTS[kind])):
  reason="Bring "+cost_text(COSTS.get(kind,{}))+" in your pack.";return false
 return true
func build(p:Vector2,kind:String)->bool:
 var c=cell(p)
 if not ready_to_build(c,kind):g.notify(reason);return false
 var map=tiles();var k=key(c);var t=map.get(k,{});var cost={}
 if kind=="remove":
  var old=""
  if link_at(c,level()):
   old=data().links[link_key(c,level())].kind;data().links.erase(link_key(c,level()))
   if tiles(level()+1).get(k,{}).get("floor","")=="landing_floor":tiles(level()+1).erase(k)
  elif t.get("roof",false):old="roof";t.erase("roof");tiles(level()+1).erase(k)
  elif t.get("wall","")!="":old=t.wall;t.erase("wall");t.erase("open")
  else:
   old=t.floor;map.erase(k)
   if old=="roof_floor":old="roof";tiles(level()-1)[k].erase("roof")
   elif old=="landing_floor":old="stone_floor"
  for item in COSTS[old]:g.state.add(item,COSTS[old][item])
 else:
  cost=COSTS.get(kind,{})
  if cost.is_empty() or not g.state.afford(cost):g.notify("Bring "+cost_text(cost)+" in your pack.");return false
  for item in cost:g.state.add(item,-cost[item])
  if kind in ["stairs","ladder"]:
   data().links[link_key(c,level())]={"kind":kind}
   if not tiles(level()+1).has(k):tiles(level()+1)[k]={"floor":"landing_floor"}
  elif kind.ends_with("floor"):t.floor=kind
  elif kind=="roof":
   t.roof=true
   if not tiles(level()+1).has(k):tiles(level()+1)[k]={"floor":"roof_floor"}
  else:t.wall=kind;t.open=kind=="door"
  map[k]=t;data().facts[kind]=true
 contact=center(c);impact=.24;g.face=1 if contact.x>g.player.x else -1
 g.sound.effect("wood" if kind in ["door","wood_floor","roof"] else "stone",-14);g.save_game();return true
func cost_text(cost:Dictionary)->String:
 var list=[]
 for k in cost:list.append(str(cost[k])+" "+("timber" if k=="wood" else "stone"))
 return " + ".join(list)
func update(dt:float):
 impact=maxf(0,impact-dt);timer=maxf(0,timer-dt)
 if s.placing.begins_with("house:") and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and timer<=0 and not g.hotbar.over() and not g.hotbar.blocked:
  timer=.18;build(g.get_global_mouse_position()+g.camera,s.placing.trim_prefix("house:"))
func points()->Array:
 var list=[]
 if s.area!="claim":return list
 for k in tiles():
  var t=tiles()[k]
  if t.get("wall","")=="door":list.append({"p":center(coords(k)),"name":"Close door" if t.get("open",false) else "Open door","action":"house:"+k})
 for k in data().links:
  var z=int(k.get_slice("/",0));var c=coords(k.get_slice("/",1))
  if z==level():list.append({"p":center(c),"name":"Climb to Z+%d · E" % (z+1),"action":"house_up"})
  elif z+1==level():list.append({"p":center(c),"name":"Descend to Z+%d · Shift+E" % z,"action":"house_down"})
 list.sort_custom(func(a,b):return a.action=="house_up" and b.action!="house_up")
 return list
func toggle(k:String)->bool:
 if not tiles().has(k) or tiles()[k].get("wall","")!="door" or g.player.distance_to(center(coords(k)))>80:return false
 var t=tiles()[k]
 if t.get("open",false) and Rect2(Vector2(coords(k))*CELL,Vector2.ONE*CELL).grow(14).has_point(g.player):g.notify("Step out of the doorway first.");return false
 t.open=not t.get("open",false);g.sound.effect("door",-16);g.save_game();return true
func shelter(p:Vector2)->Dictionary:
 var map=tiles();var start=cell(p);var seen={};var todo=[start];var roofed=true;var enclosed=true;var doors=0;var head=0
 while head<todo.size() and head<1200:
  var c=todo[head];head+=1;var k=key(c)
  if seen.has(k):continue
  seen[k]=true
  var t=map.get(k,{})
  if t.is_empty():enclosed=false;continue
  if t.get("wall","")!="":
   if t.wall=="door":doors+=1
   continue
  if not t.get("roof",false) and not tiles(level()+1).has(k):roofed=false
  for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:todo.append(c+d)
 var floors=0
 for k in seen:
  if map.has(k) and map[k].get("wall","")=="":floors+=1
 return {"enclosed":enclosed and doors>0 and floors>=4,"roofed":roofed,"floor_count":floors,"cells":seen}
func rest(p:Vector2)->bool:
 var room=shelter(p+Vector2(0,25))
 if not room.enclosed or not room.roofed:g.notify("A home needs walls, a door and a roof over the floor around its bed.");return false
 data().facts.home=true;g.save_game();g.notify("Under a roof you raised yourself. Rested; fortune saved.");return true
func panel():
 g.label(g.panel_body,"BUILD YOUR OWN HEARTH",22,Color("edc98a"))
 g.label(g.panel_body,"Lay any footprint, add walls and a door, then roof it. Roofs are walkable one level above. Stairs and ladders join matching locations.",15)
 g.label(g.panel_body,"Hold LMB: build · Right click: cancel · E: climb · Shift+E: descend",14)
 var buttons=g.row(g.panel_body);var count=0
 for kind in TITLES:
  if count>0 and count%2==0:buttons=g.row(g.panel_body)
  count+=1;var id=str(kind)
  var b=g.small_button(buttons,TITLES[id]+(" · "+cost_text(COSTS[id]) if COSTS.has(id) else " · refund"),func():s.cancel_placement();s.placing="house:"+id;g.handworks.placing="";g.close_panel())
  b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 g.button(g.panel_body,"Place bed · 5 timber + 2 stone",func():s.start_placement("bed"))
 g.label(g.panel_body,"Working on Z+%d. Five storeys plus their accessible roof deck. Upper floors, furniture and chests stay on their actual level." % level(),15)
 g.label(g.panel_body,"Roof tiles fade while you stand beneath them. Doors open with E. Furniture and chests fit inside your own buildings. Recover roof → wall → floor in that order; contents must be moved first.",14)
 lesson()
func lesson():
 g.label(g.panel_body,"A HEARTH YOU RAISED · Practical building lesson",17,Color("edc98a"))
 var f=data().get("facts",{})
 for step in [["stone_floor","Lay a foundation (oak also counts)."],["wall","Raise walls and add a door."],["roof","Roof the space you made."],["home","Place a bed and rest inside your enclosed, roofed home."],["ascend","Build a stair or ladder and climb onto your roof."],["descend","Return down the same passage to prove your way home."]]:
  var done=f.get(step[0],false) or (step[0]=="stone_floor" and f.get("wood_floor",false))
  if step[0]=="wall":done=done and f.get("door",false)
  g.label(g.panel_body,("✓ " if done else "○ ")+step[1],14)
func material(index:int,rect:Rect2,tint:Color=Color.WHITE):
 var size=Vector2(MATERIALS.get_width()/3.0,MATERIALS.get_height()/2.0)
 g.draw_texture_rect_region(MATERIALS,rect,Rect2(Vector2(index%3,index/3)*size,size),tint)
func floor_draw():
 if s.area!="claim":return
 for z in range(level()):
  for k in tiles(z):
   var t=tiles(z)[k];var p=Vector2(coords(k))*CELL
   material(2 if t.get("roof",false) or t.floor=="roof_floor" else 1 if t.floor=="wood_floor" else 0,Rect2(p,Vector2.ONE*CELL),Color(.55,.62,.66,.45))
 for k in tiles():
  var t=tiles()[k];var p=Vector2(coords(k))*CELL
  material(2 if t.floor=="roof_floor" else 1 if t.floor=="wood_floor" else 0,Rect2(p,Vector2.ONE*CELL))
 for k in data().links:
  var z=int(k.get_slice("/",0));var c=coords(k.get_slice("/",1))
  if z!=level() and z+1!=level():continue
  var p=center(c);g.draw_rect(Rect2(p-Vector2(15,18),Vector2(30,36)),Color("20383a"))
  var ladder=data().links[k].kind=="ladder"
  for i in 5:
   var y=p.y-14+i*7;g.draw_line(Vector2(p.x-12,y),Vector2(p.x+12,y),Color("b99864") if ladder else Color("b4b3a0"),3 if ladder else 5)
  if ladder:
   for x in [-14,14]:g.draw_line(p+Vector2(x,-20),p+Vector2(x,20),Color("735735"),3)

func wall_draw(c:Vector2i):
 var t=tile(c);var p=center(c);var kind=t.get("wall","")
 if kind=="":return
 var r=Rect2(p-Vector2(20,46),Vector2(40,64))
 g.draw_rect(Rect2(r.position+Vector2(4,5),r.size),Color(0,0,0,.22))
 material(4 if kind=="window" else 5 if kind=="door" and not t.get("open",false) else 3,r)
 if kind=="window" or (kind=="door" and not t.get("open",false)):return
 if kind in ["door","window"]:
  var hole=Rect2(p+Vector2(-14,-37),Vector2(28,51 if kind=="door" else 26))
  g.draw_rect(hole.grow(3),Color("b69a65"));g.draw_rect(hole,Color("223b40"))
  if kind=="door":
   if t.get("open",false):g.draw_rect(Rect2(p+Vector2(11,-36),Vector2(6,49)),Color("976b3c"))
   else:
    g.draw_rect(hole,Color("805937"))
    for x in [-8,0,8]:g.draw_line(p+Vector2(x,-35),p+Vector2(x,13),Color("523e2d"),1)
    for y in [-28,5]:g.draw_line(p+Vector2(-14,y),p+Vector2(14,y),Color("343d3a"),3)
    g.draw_circle(p+Vector2(8,-9),2,Color("e0be70"))
  else:
   g.draw_rect(hole.grow(-2),Color("d5b66f"));g.draw_line(p+Vector2(0,-37),p+Vector2(0,-11),Color("6a5838"),3)
func roof_draw():
 if s.area!="claim":return
 var inside=shelter(g.player).cells if tile(cell(g.player)).has("floor") else {}
 var expanded=inside.duplicate()
 for k in inside:
  for dy in range(-1,2):
   for dx in range(-1,2):expanded[key(coords(k)+Vector2i(dx,dy))]=true
 inside=expanded
 for k in tiles():
  if not tiles()[k].get("roof",false):continue
  var p=Vector2(coords(k))*CELL;var alpha=.13 if inside.has(k) or center(coords(k)).distance_to(g.player)<75 else .95
  material(2,Rect2(p-Vector2(0,46),Vector2(40,40)),Color(1,1,1,alpha))
  if not tiles().get(key(coords(k)+Vector2i.DOWN),{}).get("roof",false):g.draw_line(p+Vector2(0,-6),p+Vector2(40,-6),Color(.7,.52,.27,alpha),3)
func preview():
 if not s.placing.begins_with("house:"):return
 var c=cell(g.get_global_mouse_position()+g.camera);var kind=s.placing.trim_prefix("house:");var ok=ready_to_build(c,kind)
 if s.area=="claim":HoldBuildPreview.grid(g,g.camera,CELL,Rect2(260,320,1300,600))
 var base=Rect2(Vector2(c)*CELL,Vector2.ONE*CELL)
 if kind in ["stone_floor","wood_floor","roof"]:material(1 if kind=="wood_floor" else 2 if kind=="roof" else 0,base,Color(HoldBuildPreview.color(ok),.55))
 HoldBuildPreview.outline(g,base,ok)
