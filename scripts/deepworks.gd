class_name Deepworks
extends RefCounted
# Additive save model. Legacy Geology remains intact for rollback and old structures.
const W=80
const H=64
const TILE=40
const DEPTHS=5
const ENTRY=Vector2i(8,8)
const DIRS=[Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]
const NAMES=["Lamplight Galleries","Copperfold","The Rootless Sea","King's Forgotten Works","The Aether Heart"]
var data:Dictionary
var state
var landmark_cache:Array=[]
const FEET=Vector2(10,8)
func _init(s):
 state=s
 if not s.deepworks.has(s.active_site):s.deepworks[s.active_site]=generate(s.seed_value+(7919 if s.active_site=="claim" else 0))
 data=s.deepworks[s.active_site]
 rebuild_landmarks()
static func key(c:Vector2i)->String:return "%d,%d" % [c.x,c.y]
static func cell(p:Vector2)->Vector2i:return Vector2i(floor(p.x/TILE),floor(p.y/TILE))
static func center(c:Vector2i)->Vector2:return (Vector2(c)+Vector2.ONE*.5)*TILE
static func generate(seed_number:int)->Dictionary:
 var rng=RandomNumberGenerator.new();rng.seed=seed_number
 var offset=rng.randf_range(-2,2)
 var layers:Array=[]
 for z in DEPTHS:
  var cells:Array=[];var strata:Array=[]
  for y in H:
   for x in W:
    var band=sin(y*.19+x*.045+z*.7+offset)
    var kind=1 if band>.65 and z<2 else (7 if band<-.65 and z>=2 else 2)
    strata.append(kind)
    # Continuous gently dipping seams: identical x/y coordinates link depths.
    for v in 5:
     var axis=13+v*13+sin(y*.12+v+offset)*3+z*1.2
     if absf(x-axis)<(1.4 if v%2==0 else .85):kind=[5,3,4,3,6][v]
    # Iron lenses swell around the same dipping seam on successive depths.
    var axis=26+sin(y*.12+1+offset)*3+z*1.2
    var lens=pow((y-(28+z*.6))/8.0,2)+pow((x-axis)/4.5,2)
    if lens<1.0:kind=3
    if x<1 or y<1 or x>=W-1 or y>=H-1:kind=8
    cells.append(kind)
  var features:Array=[]
  for j in 6:
   var c=Vector2i(20+j%3*21+int(sin(offset+j)*2)+z,14+j/3*29+z)
   var radius=4+j%3
   for y in range(c.y-radius-1,c.y+radius+2):
    for x in range(c.x-radius-1,c.x+radius+2):
     if x<1 or y<1 or x>=W-1 or y>=H-1:continue
     var d=Vector2(x-c.x,y-c.y).length()
     if d<radius+sin(x*1.7+y*.6)*.5:cells[y*W+x]=0
     elif j%3==1 and d<radius+1.5:cells[y*W+x]=6
     elif j%3==0 and d<radius+1.5:cells[y*W+x]=[5,3,4,3,6][z]
   var rare=j==5 and z>=3
   features.append({"x":c.x,"y":c.y,"type":j%3,"rare":rare,"name":("The First King's Survey Stone" if z==3 else "The Heart of the Mountain") if rare else ["The Hollow Bell","Prismatic Cathedral","Oathkeeper's Refuge"][j%3]+" · "+str(z+1),"found":false})
  if z==0:
   for y in range(3,12):
    for x in range(3,12):cells[y*W+x]=0
   # Coal and iron within the first few swings, with a cavern beyond.
   for y in range(7,11):cells[y*W+12]=5
   for x in range(6,10):cells[12*W+x]=3
  layers.append({"cells":cells,"strata":strata,"damage":{},"seen":{},"features":features,"fixtures":{}})
 return {"version":1,"seed":seed_number,"depth":0,"layers":layers,"links":{},"crew":{},"position":[center(ENTRY).x,center(ENTRY).y],"discoveries":[]}
func depth()->int:return int(data.depth)
func layer(z:int=-1)->Dictionary:return data.layers[depth() if z<0 else z]
func at(c:Vector2i,z:int=-1)->int:
 if c.x<0 or c.y<0 or c.x>=W or c.y>=H:return 8
 return int(layer(z).cells[c.y*W+c.x])
func set_cell(c:Vector2i,kind:int,z:int=-1):
 if c.x<1 or c.y<1 or c.x>=W-1 or c.y>=H-1:return
 layer(z).cells[c.y*W+c.x]=kind
# Landmark type, drawn anchor and physical base share one definition. JSON numbers
# are floats after loading; never use raw Variant membership to select artwork.
static func landmark_type(f:Dictionary)->int:return int(f.get("type",0))
func rebuild_landmarks():
 landmark_cache.clear()
 for z in data.layers.size():
  var parts:Array=[]
  for f in layer(z).features:
   f.type=landmark_type(f)
   var origin=center(Vector2i(int(f.x),int(f.y)))
   var anchors:Array=f.get("anchors",[])
   var count=3 if f.type==2 else 1
   for j in count:
    var p=origin+(Vector2((j-1)*55,(j%2)*25) if f.type==2 else Vector2(0,20))
    if anchors.size()==count:p=Vector2(anchors[j][0],anchors[j][1])
    var width=48.0 if f.type==2 else 110.0 if f.type==1 else 78.0
    var height=70.0 if f.type==2 else width*411.0/424.0
    parts.append({"kind":"landmark","p":p,"art":4 if f.type==2 else 3,"width":width,"height":height,"feature":f,
     "base":p-Vector2(0,height*.17),"radius":Vector2(width*.44,height*.16)})
  # Preserve construction in old saves: shift an overlapping landmark as a whole
  # to nearby open cavern floor, then save its anchors. Never move player property.
  var reserved:Array=[]
  for link in data.links.values():
   if z in [int(link.upper),int(link.lower)]:reserved.append({"p":center(Vector2i(int(link.x),int(link.y))),"half":Vector2(30,30)})
  for f in data.get("living",{}).get("furniture",{}).values():
   if int(f.depth)==z:reserved.append({"p":center(Vector2i(int(f.x),int(f.y))),"half":Vector2(23,23)})
  for f in state.hauling.get("hands",{}).get("facilities",[]):
   if f.get("area","")=="mine:"+state.active_site+":"+str(z):reserved.append({"p":Vector2(f.x,f.y),"half":Vector2(55,42)})
  for f in layer(z).features:
   var group:Array=[]
   for part in parts:
    if is_same(part.feature,f):group.append(part)
   if not landmark_conflict(group,Vector2.ZERO,reserved,z):continue
   var shift=Vector2.ZERO
   for radius in range(20,321,20):
    for i in 32:
     var offset=Vector2.from_angle(i*TAU/32.0)*radius
     if not landmark_conflict(group,offset,reserved,z):shift=offset;break
    if shift!=Vector2.ZERO:break
   if shift!=Vector2.ZERO:
    f.anchors=[]
    for part in group:
     part.p+=shift;part.base+=shift;f.anchors.append([part.p.x,part.p.y])
  landmark_cache.append(parts)
func landmark_conflict(parts:Array,offset:Vector2,reserved:Array,z:int)->bool:
 for part in parts:
  var moved=part.duplicate();moved.base+=offset
  for occupied in reserved:
   if base_overlaps(moved,occupied.p,occupied.half):return true
  # Check the base's extents, not the tall decorative silhouette.
  for direction in [Vector2.ZERO,Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:
   if at(cell(moved.base+direction*moved.radius),z)!=0:return true
 return false
func landmarks(z:int=-1)->Array:return landmark_cache[depth() if z<0 else z]
static func base_overlaps(part:Dictionary,p:Vector2,half:Vector2=FEET)->bool:
 # Rectangle/ellipse intersection, including edge contacts rather than just corners.
 var delta:Vector2=(part.base-p).abs()-half
 delta=Vector2(maxf(0,delta.x),maxf(0,delta.y))/part.radius
 return delta.length_squared()<1.0
func landmark_solid(p:Vector2,z:int=-1,half:Vector2=FEET)->bool:
 for part in landmarks(z):
  if base_overlaps(part,p,half):return true
 return false
func terrain_walkable(c:Vector2i,z:int=-1)->bool:
 if at(c,z)!=0:return false
 var f=data.get("living",{}).get("furniture",{}).get(link_key(c,depth() if z<0 else z),{})
 return not f.get("solid",false)
func walkable(c:Vector2i,z:int=-1)->bool:
 return terrain_walkable(c,z) and not landmark_solid(center(c),z) and not equipment_solid(center(c),z)
func terrain_solid(p:Vector2,z:int=-1)->bool:
 for d in [Vector2(-10,-8),Vector2(10,-8),Vector2(-10,8),Vector2(10,8)]:
  if not terrain_walkable(cell(p+d),z):return true
 return false
func equipment_solid(p:Vector2,z:int=-1)->bool:
 var context="mine:"+state.active_site+":"+str(depth() if z<0 else z)
 for f in state.hauling.get("hands",{}).get("facilities",[]):
  if f.get("area","")!=context or f.get("hitched",false):continue
  if Rect2(Vector2(f.x,f.y)-Vector2(30,12),Vector2(60,16)).grow(10).has_point(p):return true
 return false
func solid(p:Vector2,z:int=-1)->bool:return terrain_solid(p,z) or landmark_solid(p,z) or equipment_solid(p,z)
func clear_step(a:Vector2,b:Vector2,z:int=-1)->bool:
 for i in range(1,9):
  if solid(a.lerp(b,i/8.0),z):return false
 return true
func safe_position(p:Vector2,z:int=-1)->Vector2:
 if not solid(p,z):return p
 # Old saves could stand inside decorative landmarks. Resolve locally on the same
 # floor, without crossing rock walls or changing excavations, depth or equipment.
 for radius in range(4,165,4):
  for i in 32:
   var q=p+Vector2.from_angle(i*TAU/32.0)*radius
   if solid(q,z):continue
   var clear=true
   for step in range(1,17):
    if terrain_solid(p.lerp(q,step/16.0),z):clear=false;break
   if clear:return q
 return p
func visible(a:Vector2,b:Vector2,z:int=-1,block_landmarks:bool=true)->bool:
 var end=cell(b)
 for i in range(0,int(a.distance_to(b)),8):
  var sample=a.move_toward(b,i)
  var c=cell(sample)
  if c!=end and at(c,z)!=0:return false
  if block_landmarks and landmark_solid(sample,z,Vector2.ZERO):return false
 return true
func target(origin:Vector2,aim:Vector2,reach:float=88)->Vector2i:
 var delta=aim-origin
 if delta.length()<1:return Vector2i(-1,-1)
 for i in range(1,int(minf(reach,delta.length()))+1,2):
  var sample=origin+delta.normalized()*i
  if landmark_solid(sample,-1,Vector2.ZERO):return Vector2i(-1,-1)
  var c=cell(sample)
  if at(c)!=0:return c if at(c)!=8 else Vector2i(-1,-1)
 return Vector2i(-1,-1)
func resistance(kind:int)->float:return {1:1.0,2:3.6,3:4.8,4:4.2,5:2.8,6:6.0,7:8.0}.get(kind,1.0)
func exposed(c:Vector2i,z:int=-1)->int:
 var n=0
 for d in DIRS:
  if walkable(c+d,z):n+=1
 return n
func mastery()->int:
 var practice=int(state.hauling.get("hands",{}).get("skills",{}).get("miner",0))
 return 2 if practice>=40 else 1 if practice>=12 else 0
# Additive prospect notes follow the existing dipping geology, without regenerating saves.
func formation(c:Vector2i,z:int=-1,kind:int=-1)->Dictionary:
 var level=depth() if z<0 else z;var k=at(c,level) if kind<0 else kind
 if k not in [3,4,5,6]:return {}
 var rng=RandomNumberGenerator.new();rng.seed=int(data.seed);var offset=rng.randf_range(-2,2)
 var best=-1;var distance=7.0
 for v in 5:
  if [5,3,4,3,6][v]!=k:continue
  var delta=absf(c.x-(13+v*13+sin(c.y*.12+v+offset)*3+level*1.2))
  if delta<distance:distance=delta;best=v
 var id=str(k)+":"+("seam"+str(best) if best>=0 else "pocket"+str(c.x/8)+":"+str(c.y/8))
 return {"id":id,"name":{3:"Anvil iron",4:"Copperfold",5:"Blackribbon coal",6:"Prismatic root"}[k]+(" · seam "+str(best+1) if best>=0 else " · pocket"),"kind":k}
func record_lode(c:Vector2i,z:int,k:int,count:int):
 var f=formation(c,z,k)
 if f.is_empty():return
 if not data.has("prospects"):data.prospects={}
 if not data.prospects.has(f.id):data.prospects[f.id]={"name":f.name,"kind":k,"depths":[],"loads":0,"units":0}
 var note=data.prospects[f.id];var level=depth() if z<0 else z
 if level not in note.depths:note.depths.append(level)
 note.loads=int(note.loads)+1;note.units=int(note.units)+count
# Grade is derived from seed and position: old excavations are never regenerated.
func grade(c:Vector2i,z:int=-1)->int:
 var level=depth() if z<0 else z
 if at(c,level) not in [3,4,5]:return 1
 var phase=float(int(data.seed)%997)*.01
 var value=sin(c.y*.17+phase+level*.21)+cos(c.x*.22-level*.19)
 return 2 if value>.55 else (0 if value<-.65 else 1)
func yield_count(c:Vector2i,z:int=-1)->int:
 return [3,5,8][grade(c,z)] if at(c,z) in [3,4,5] else 4 if at(c,z) in [2,7] else 3 if at(c,z)==6 else 1
func grade_label(c:Vector2i,z:int=-1)->String:
 return ["LEAN", "BANDED", "RICH"][grade(c,z)] if at(c,z) in [3,4,5] else ""
func strike(c:Vector2i,z:int=-1,thermal:bool=false,deliver:bool=true,method:String="pick",work:Dictionary={})->Dictionary:
 var k=at(c,z)
 if k in [0,8]:return {}
 if k==7 and not state.steel and not thermal:return {"blocked":true}
 var l=layer(z);var id=key(c)
 var prior=float(l.damage.get(id,0))
 var power=12.0 if thermal else (1.65 if state.steel else 1.0)
 if method=="hammer" and not thermal:power=2.6 if prior>=resistance(k)*.4 else .65
 if not thermal and exposed(c,z)>=2:power+=.3
 if not thermal:power+=float(work.get("focus",0))
 l.damage[id]=prior+power
 if l.damage[id]<resistance(k):return {"kind":k,"broken":false}
 var count=yield_count(c,z)+(1+int(work.get("recovery",0)) if method=="careful" and k in [3,4,5,6] else 0)
 set_cell(c,0,z);l.damage.erase(id)
 # Joint stress is persistent. Only a later, exposed contact can release a section.
 for d in DIRS:
  var n=c+d;var nk=at(n,z)
  if nk in [2,3,4,7] and method!="careful":
   var nid=key(n);l.damage[nid]=minf(resistance(nk)*.8,float(l.damage.get(nid,0))+(.9 if method=="hammer" else .4)+float(work.get("fracture",0)))
 var item=HoldData.TILES[k].item
 if thermal:
  if k in [3,4]:item="iron_slag" if k==3 else "copper_slag"
  if k==5:count=0
 if deliver:state.add(item,count)
 state.mined+=1
 if not thermal:record_lode(c,z,k,count)
 if k==6 and not state.discovered:state.discovered=true;state.money+=40
 return {"kind":k,"broken":true,"item":item,"count":count}
func survey(p:Vector2)->Array:
 var c=cell(p);var found:Array=[];var l=layer()
 for y in range(c.y-9,c.y+10):
  for x in range(c.x-9,c.x+10):
   var t=Vector2i(x,y)
   if center(t).distance_to(p)<350 and visible(p,center(t),-1,false):l.seen[key(t)]=true
 for f in l.features:
  if f.found:continue
  var revealed=false
  for part in landmarks():
   if is_same(part.feature,f) and p.distance_to(part.base)<350 and visible(p,part.base,-1,false):revealed=true;break
  if revealed:
   f.found=true;data.discoveries.append(f.name);found.append(f.name)
   if f.get("rare",false):state.add("crystal",3);state.add("scrap",4)
 return found
func link_key(c:Vector2i,z:int)->String:return str(z)+":"+key(c)
func can_descend(c:Vector2i,z:int)->bool:return data.links.has(link_key(c,z))
func carve_stairs(c:Vector2i,kind:String="stair")->String:
 var z=depth()
 if kind not in ["stair","ladder"]:return "Choose stairs or a timber ladder."
 if z>=data.layers.size()-1:return "The surveyed frontier ends here. Future delvings will extend this depth."
 if not walkable(c):return "Stand on clear excavated ground."
 if at(c,z+1)==8:return "The lower landing lies beyond the surveyed boundary."
 if at(c,z+1)==0 and not walkable(c,z+1):return "A landmark or furnishing blocks the landing below. Choose clear ground."
 var previous=data.links.get(link_key(c,z),{})
 if not previous.is_empty() and (previous.get("kind","stair")==kind or kind=="ladder"):
  return "A passage already connects these levels. E down; Shift+E up."
 if at(c,z+1)==7 and not state.steel:return "Basalt below: forge a steel pick before opening this passage."
 if kind=="ladder" and not state.pay({"wood":2}):return "A timber ladder needs 2 delivered timber."
 # Ladder shafts clear one landing; stairs clear a wider crew/cart landing. No mining rewards.
 var clearance=[Vector2i.ZERO] if kind=="ladder" else [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]
 for d in clearance:
  if at(c+d,z+1)!=8:set_cell(c+d,0,z+1)
 var link=previous.duplicate(true)
 link.merge({"x":c.x,"y":c.y,"upper":z,"lower":z+1,"kind":kind},true)
 data.links[link_key(c,z)]=link
 return ("Timber ladder fitted" if kind=="ladder" else "Stair carved")+" to "+NAMES[z+1]+". E down; Shift+E up."
func traverse(c:Vector2i,up:bool)->bool:
 var z=depth();var upper=z-1 if up else z
 if upper<0 or upper>=data.layers.size()-1 or not can_descend(c,upper):return false
 var link=data.links[link_key(c,upper)]
 if not walkable(c,z-1 if up else z+1):return false
 if not up:link.descended=true
 elif link.get("descended",false) and not link.get("return_tested",false):
  link.return_tested=true;HoldOnboarding.fact(state,"route_tested")
 data.depth=z-1 if up else z+1;data.position=[center(c).x,center(c).y];return true
func entrance(p:Vector2)->bool:return depth()==0 and cell(p).distance_to(ENTRY)<2.2
# Flood-fill only excavated ground. Returns a physically walkable route to a face or stair.
func route(start:Vector2i,z:int,priority:String,destination:Vector2i=Vector2i(-1,-1))->Dictionary:
 var queue:Array[Vector2i]=[start];var prev={key(start):start};var head=0;var fallback={};var chosen={}
 while head<queue.size():
  var c=queue[head];head+=1
  if destination==c:chosen={"stand":c,"target":Vector2i(-1,-1)};break
  for d in DIRS:
   var n=c+d;var kind=at(n,z)
   if kind==0 and walkable(n,z) and not prev.has(key(n)) and clear_step(center(c),center(n),z):prev[key(n)]=c;queue.append(n)
   elif destination.x<0 and kind not in [0,8] and (kind!=7 or state.steel):
    var candidate={"stand":c,"target":n}
    if HoldData.TILES[kind].item==priority:chosen=candidate;break
    if fallback.is_empty():fallback=candidate
  if not chosen.is_empty():break
 if chosen.is_empty():chosen=fallback
 if chosen.is_empty():return {}
 var path:Array=[];var c:Vector2i=chosen.stand
 while c!=start:path.push_front(center(c));c=prev[key(c)]
 chosen.path=path;return chosen
