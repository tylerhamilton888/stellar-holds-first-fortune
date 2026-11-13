class_name HoldUpperBlueprints
extends RefCounted
# Planning views never move the player or write physical floor levels.
static func stairs(p)->Array:return p.data().get("stairs158",[])
static func missing_supports(p,r:Dictionary)->int:
 var z=int(r.get("z",0));var count=0
 if z==0:return 0
 var b=p.bounds(r)
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   if not p.tile(Vector2i(x,y),z-1).has("floor"):count+=1
 return count
static func validate(p,r:Dictionary)->bool:
 var h=p.a.s.house;var b=p.bounds(r);var z=p.level()
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   var c=Vector2i(x,y)
   if not p.a.s.claim_ground(h.center(c)) or h.center(c).y<320:p.message="Keep the room above your building grounds.";return false
   if p.occupied(c) and (not p.tile(c).has("floor") or (p.edge(r,c) and p.tile(c).get("wall","")=="")):p.message="Clear furnishings from the unfinished floor or boundary.";return false
 return true
static func access(p,r:Dictionary)->bool:
 var z=int(r.get("z",0));var h=p.a.s.house
 if z==0:return true
 var floor={};var blocked={}
 for k in p.tiles(z):
  if p.tiles(z)[k].has("floor"):floor[k]=true
  if p.tiles(z)[k].get("wall","") in ["wall","window"]:blocked[k]=true
 for room in p.rooms(z):
  for part in p.parts(room):
   var k=h.key(part.cell)
   if part.kind.ends_with("floor"):floor[k]=true
   elif part.kind=="wall":blocked[k]=true
   elif part.kind=="door":blocked.erase(k)
 var todo=[];var seen={}
 for k in h.data().links:
  if int(k.get_slice("/",0))!=z-1:continue
  var c=h.coords(k.get_slice("/",1));var key=h.key(c)
  if floor.has(key) and not blocked.has(key):todo.append(c);seen[key]=true
 var index=0
 while index<todo.size():
  var c=todo[index];index+=1
  for d in Deepworks.DIRS:
   var n=c+d;var k=h.key(n)
   if floor.has(k) and not blocked.has(k) and not seen.has(k):seen[k]=true;todo.append(n)
 return seen.has(h.key(p.bounds(r).position+Vector2i.ONE))
static func plan(p)->bool:
 if not p.available():return false
 if stairs(p).size()>=32:p.message="This holding already has 32 stair guides; existing connections are preserved.";return false
 var c=p.a.s.house.cell(p.a.g.player);var z=p.level()
 for s in stairs(p):
  if int(s.z)==z and Vector2i(s.x,s.y)==c:p.message="This stair flight is already planned.";return false
 for level in [z,z+1]:
  if p.tile(c,level).get("wall","")!="":p.message="Keep both stair landings clear of walls.";return false
  for r in p.rooms(level):
   if p.bounds(r).has_point(c) and p.edge(r,c):p.message="Place stair guides inside the room, clear of its boundary.";return false
 if z==0 and HoldEstateCellar.protected(p.a.g,c):p.message="Keep the cellar landing separate from upstairs stairs.";return false
 if not p.a.s.claim_ground(Deepworks.center(c)) or Deepworks.center(c).y<320:p.message="Choose a stair location on your building grounds.";return false
 if not p.data().has("stairs158"):p.data().stairs158=[]
 p.data().stairs158.append({"z":z,"x":c.x,"y":c.y});p.message="Stair guide saved. Build at its lower landing with 4 timber and 2 stone.";p.a.g.save_game();return true
static func build(p)->bool:
 if not p.available() or p.level()!=p.a.s.house.level():p.message="Visit the lower floor before fitting this stair.";return false
 var h=p.a.s.house;var c=h.cell(p.a.g.player)
 for s in stairs(p):
  if int(s.z)!=p.level() or Vector2i(s.x,s.y)!=c:continue
  if h.link_at(c,p.level()):p.message="This flight is already built. E climbs; Shift+E descends.";return false
  if h.build(h.center(c),"stairs"):p.message="Stair flight built. E climbs; Shift+E descends.";return true
  p.message=h.reason;return false
 p.message="Stand on the lower landing of a saved stair guide.";return false
static func forget(p)->bool:
 if not p.available():return false
 var h=p.a.s.house;var c=h.cell(p.a.g.player)
 for s in stairs(p):
  if int(s.z)==p.level() and Vector2i(s.x,s.y)==c:
   if h.link_at(c,p.level()):p.message="Recover a built flight through fine construction, preserving upper access.";return false
   stairs(p).erase(s);p.a.g.save_game();p.message="Unbuilt stair guide removed.";return true
 return false
static func panel(p):
 var g=p.a.g;var h=p.a.s.house
 var row=g.row(g.panel_body)
 HoldArchitectureView.action(g,row,"Plan upward stair at my X/Y",func():plan(p);g.refresh_panel())
 HoldArchitectureView.action(g,row,"Build stair here · 4 timber / 2 stone",func():build(p);g.refresh_panel(),p.level()==h.level())
 HoldArchitectureView.action(g,row,"Remove unbuilt stair guide",func():forget(p);g.refresh_panel())
 g.label(g.panel_body,"Stairs connect matching X/Y positions. Plan on any displayed floor; build from its lower landing. E up; Shift+E down. Carts remain parked.",14)
 for s in stairs(p):
  if p.level() not in [int(s.z),int(s.z)+1]:continue
  g.label(g.panel_body,"(%d, %d) · Floor %d to %d · %s" % [s.x,s.y,s.z,int(s.z)+1,"Built" if h.link_at(Vector2i(s.x,s.y),int(s.z)) else "Planned"],14)
static func draw_map(canvas,p):
 for s in stairs(p):
  if p.level() not in [int(s.z),int(s.z)+1]:continue
  canvas.draw_rect(Rect2(Vector2(s.x,s.y)*40,Vector2(40,40)).grow(-3),Color("e9c982"),false,6)

static func crosses_stair(p,r:Dictionary)->bool:
 var h=p.a.s.house;var z=p.level();var b=p.bounds(r)
 for k in h.data().links:
  if int(k.get_slice("/",0)) not in [z-1,z]:continue
  var c=h.coords(k.get_slice("/",1))
  if b.has_point(c) and p.edge(r,c):return true
 for s in stairs(p):
  var c=Vector2i(s.x,s.y)
  if int(s.z) in [z-1,z] and b.has_point(c) and p.edge(r,c):return true
 return false
