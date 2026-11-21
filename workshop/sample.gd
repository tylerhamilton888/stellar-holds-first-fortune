extends RefCounted
const L=preload("res://workshop/layout.gd")
const BASE=Vector2i(33,28)
static func build(g,route):
 var h=g.handworks.workshop
 g.state.tech["furnishings"]=true
 for item in {"stone":150,"iron":20,"food":18,"wood":80,"coal":16,"iron_ore":20}:g.state.add(item,{"stone":150,"iron":20,"food":18,"wood":80,"coal":16,"iron_ore":20}[item])
 if route=="yard":
  g.surface.enter("claim",Vector2(2300,1260))
  var origin=yard_origin(g)
  if origin.x<0:push_error("No sufficient ground for a yard.");return
  furnish(g,h,origin,false)
  var r=h.room(true)
  # Follow the existing road to its edge. Each stone can be lifted separately.
  var lane=preload("res://assets/timber_wing/claim_path.gd")
  for step in range(5,18):
   var c=origin+Vector2i(step,2)
   var point=L.center(c)
   if lane.on_lane(point) or not g.surface.walkable(point):break
   r.flags[L.key(c)]=true
  g.player=L.center(origin+Vector2i(1,2));g.camera=g.surface.camera_target()
 else:
  var w=g.deep.world;w.data.depth=2
  # Two excavated rooms with a shared northern party wall and an eastern passage.
  # Extend this preview excavation to an existing shaft for ordinary travel.
  for y in range(-7,5):
   for x in range(-4,8):
    var c=BASE+Vector2i(x,y)
    var wall=(x in [-4,7] or y in [-7,4] or (y==-1 and x<5))
    w.set_cell(c,2 if wall else 0)
  for x in range(9,BASE.x+7):w.set_cell(Vector2i(x,9),0)
  for y in range(9,BASE.y+3):w.set_cell(Vector2i(BASE.x+6,y),0)
  for z in 2:
   w.data.depth=z;w.set_cell(Vector2i(9,9),0,z);w.carve_stairs(Vector2i(9,9))
  w.data.depth=2
  furnish(g,h,BASE,true)
  var r=h.room(true)
  for x in range(-2,4):
   for y in range(-6,-1):
    if not (x==-2 and y==-6):r.flags[L.key(BASE+Vector2i(x,y))]=true
  put(r,"table",BASE+Vector2i(0,-4),0);put(r,"table",BASE+Vector2i(2,-4),0)
  for x in [0,2]:
   put(r,"chair",BASE+Vector2i(x,-5),0);put(r,"chair",BASE+Vector2i(x,-3),2)
  for x in range(-4,8):
   for y in range(-7,5):
    var c=BASE+Vector2i(x,y)
    if w.at(c)!=0:r.facing[L.key(c)]=true
  for y in range(-5,3,2):
   w.survey(L.center(BASE+Vector2i(6,y)))
   w.survey(L.center(BASE+Vector2i(1,y)))
  # These rooms open mid-shift. Record the same actions a player can take here.
  for j in 3:h.use(L.on_cell(r,BASE))
  h.use(L.on_cell(r,BASE+Vector2i(0,2)))
  h.use(L.on_cell(r,BASE+Vector2i(2,-4)))
  g.player=L.center(BASE+Vector2i(1,-2 if route=="mess" else 2))
  w.data.position=[g.player.x,g.player.y];w.survey(g.player);g.camera=g.deep.camera_target()
 g.surface.direction=Vector2.UP;g.hotbar.stow(false);g.save_game()
static func put(r,kind,c,turn):
 var f=L.record(kind,c,turn);r.pieces[L.key(c)]=f
static func furnish(g,h,o,inside):
 var r=h.room(true)
 for y in range(0,3):
  for x in range(-1,5):
   if inside and x==-1 and y!=1:continue
   if not inside and x==-1 and y==0:continue
   r.flags[L.key(o+Vector2i(x,y))]=true
 put(r,"forge",o,0)
 put(r,"table",o+Vector2i(2,0) if inside else o+Vector2i(3,1),0)
 put(r,"anvil",o+Vector2i(0,2) if inside else o+Vector2i(-1,2),1)
 if not inside:put(r,"chair",o+Vector2i(4,2),2)
static func yard_origin(g)->Vector2i:
 for oy in [33,32,31,30,37,38,28,29,25,23,36,21]:
  for ox in [55,54,53,52,51,50,49,56,58,46,61,43,65,40]:
   var valid=true
   for y in range(0,4):
    for x in range(-1,6):
     var p=L.center(Vector2i(ox+x,oy+y))
     if Rect2(2280,1315,308,140).has_point(p) or not g.surface.walkable(p) or preload("res://assets/timber_wing/claim_path.gd").on_lane(p):valid=false;break
    if not valid:break
   if valid:return Vector2i(ox,oy)
 return Vector2i(-1,-1)
