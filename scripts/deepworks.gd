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
func _init(s):
 state=s
 if not s.deepworks.has(s.active_site):s.deepworks[s.active_site]=generate(s.seed_value+(7919 if s.active_site=="claim" else 0))
 data=s.deepworks[s.active_site]
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
   for y in range(5,12):
    for x in range(4,12):cells[y*W+x]=0
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
func solid(p:Vector2,z:int=-1)->bool:
 for d in [Vector2(-10,-8),Vector2(10,-8),Vector2(-10,8),Vector2(10,8)]:
  if at(cell(p+d),z)!=0:return true
 return false
func visible(a:Vector2,b:Vector2,z:int=-1)->bool:
 var end=cell(b)
 for i in range(0,int(a.distance_to(b)),8):
  var c=cell(a.move_toward(b,i))
  if c!=end and at(c,z)!=0:return false
 return true
func target(origin:Vector2,aim:Vector2,reach:float=88)->Vector2i:
 var delta=aim-origin
 if delta.length()<1:return Vector2i(-1,-1)
 for i in range(1,int(minf(reach,delta.length()))+1,2):
  var c=cell(origin+delta.normalized()*i)
  if at(c)!=0:return c if at(c)!=8 else Vector2i(-1,-1)
 return Vector2i(-1,-1)
func resistance(kind:int)->float:return {1:1.0,2:1.0,3:2.0,4:1.5,5:1.0,6:3.0,7:4.0}.get(kind,1.0)
# Grade is derived from seed and position: old excavations are never regenerated.
func grade(c:Vector2i,z:int=-1)->int:
 var level=depth() if z<0 else z
 if at(c,level) not in [3,4,5]:return 1
 var phase=float(int(data.seed)%997)*.01
 var value=sin(c.y*.17+phase+level*.21)+cos(c.x*.22-level*.19)
 return 2 if value>.55 else (0 if value<-.65 else 1)
func yield_count(c:Vector2i,z:int=-1)->int:
 return [1,2,4][grade(c,z)] if at(c,z) in [3,4,5] else 1
func grade_label(c:Vector2i,z:int=-1)->String:
 return ["LEAN", "BANDED", "RICH"][grade(c,z)] if at(c,z) in [3,4,5] else ""
func strike(c:Vector2i,z:int=-1,thermal:bool=false,deliver:bool=true)->Dictionary:
 var k=at(c,z)
 if k in [0,8]:return {}
 if k==7 and not state.steel and not thermal:return {"blocked":true}
 var l=layer(z);var id=key(c)
 l.damage[id]=float(l.damage.get(id,0))+(10.0 if thermal else (2.0 if state.steel else 1.0))
 if l.damage[id]<resistance(k):return {"kind":k,"broken":false}
 var count=yield_count(c,z)
 set_cell(c,0,z);l.damage.erase(id)
 # A contact opens hairline fractures; neighbors never break or yield remotely.
 for d in DIRS:
  var n=c+d;var nk=at(n,z)
  if nk in [2,3,4,7]:
   var nid=key(n);l.damage[nid]=minf(resistance(nk)*.65,float(l.damage.get(nid,0))+.25)
 var item=HoldData.TILES[k].item
 if thermal:
  if k in [3,4]:item="iron_slag" if k==3 else "copper_slag"
  if k==5:count=0
 if deliver:state.add(item,count)
 state.mined+=1
 if k==6 and not state.discovered:state.discovered=true;state.money+=40
 return {"kind":k,"broken":true,"item":item,"count":count}
func survey(p:Vector2)->Array:
 var c=cell(p);var found:Array=[];var l=layer()
 for y in range(c.y-9,c.y+10):
  for x in range(c.x-9,c.x+10):
   var t=Vector2i(x,y)
   if center(t).distance_to(p)<350 and visible(p,center(t)):l.seen[key(t)]=true
 for f in l.features:
  if not f.found and l.seen.has(key(Vector2i(f.x,f.y))):
   f.found=true;data.discoveries.append(f.name);found.append(f.name)
   if f.get("rare",false):state.add("crystal",3);state.add("scrap",4)
 return found
func link_key(c:Vector2i,z:int)->String:return str(z)+":"+key(c)
func can_descend(c:Vector2i,z:int)->bool:return data.links.has(link_key(c,z))
func carve_stairs(c:Vector2i)->String:
 var z=depth()
 if z>=data.layers.size()-1:return "The surveyed frontier ends here. Future delvings will extend this depth."
 if at(c)!=0:return "Stand on excavated ground."
 if can_descend(c,z):return "Stairs already connect these two layers. E descends; Shift+E ascends."
 if at(c,z+1)==7 and not state.steel:return "Basalt below: research Tempered steel before carving this stair."
 # No resource reward from stair clearance; prevents shaft farming.
 for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:set_cell(c+d,0,z+1)
 data.links[link_key(c,z)]={"x":c.x,"y":c.y,"upper":z,"lower":z+1,"kind":"stair"}
 return "Stair carved to "+NAMES[z+1]+". E descends; Shift+E ascends."
func traverse(c:Vector2i,up:bool)->bool:
 var z=depth();var upper=z-1 if up else z
 if upper<0 or upper>=data.layers.size()-1 or not can_descend(c,upper):return false
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
   if kind==0 and not prev.has(key(n)):prev[key(n)]=c;queue.append(n)
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
