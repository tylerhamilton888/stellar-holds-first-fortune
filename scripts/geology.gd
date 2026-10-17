class_name Geology
extends RefCounted
const W=384
const H=176
const TILE=7
const SUBDIV=4
const GRAINS_PER_UNIT=16
var mountain:Dictionary={}
var structures:Array=[]
var timbers:Dictionary={}
var structure_dirty=true
var cells:Array=[]
var damage:Dictionary={}
var seed_value:int=0
var world_address:Dictionary={}
var grain_bank:Dictionary={}
var active_grains:Dictionary={}
var dirty:Dictionary={}
var redraw_all=true
var physics_clock=0.0
var physics_tick=0
func generate_region(galaxy_seed:int,planet_id:int,region:Vector2i):
 generate(HoldWorldStyle.address_seed(galaxy_seed,planet_id,region,0))
 world_address={"galaxy_seed":galaxy_seed,"planet_id":planet_id,"region_x":region.x,"region_y":region.y,"generator_version":HoldWorldStyle.VERSION}
func generate(value:int):
 HoldMountain.generate(self,value)
func at(x:int,y:int)->int:
 if x<0 or x>=W or y<0 or y>=H:return 8
 return int(cells[y*W+x])
func cell_at(p:Vector2)->Vector2i:return Vector2i(floor(p.x/TILE),floor(p.y/TILE))
func at_pos(p:Vector2)->int:
 var c=cell_at(p);return at(c.x,c.y)
func solid(p:Vector2)->bool:return at_pos(p) not in [0,12]
func key(c:Vector2i)->String:return "%d,%d" % [c.x,c.y]
func center(c:Vector2i)->Vector2:return Vector2(c)*TILE+Vector2.ONE*TILE/2.0
func hardness(kind:int)->float:return float(HoldData.TILES[kind].hp)*.5
func set_cell(c:Vector2i,kind:int):
 if c.x<0 or c.y<0 or c.x>=W or c.y>=H:return
 var index=c.y*W+c.x
 if int(cells[index])==kind:return
 cells[index]=kind;dirty[index]=true
 if not timbers.is_empty() or not structures.is_empty():structure_dirty=true
 if kind==13:timbers[index]=true
 else:timbers.erase(index)
func exposed(c:Vector2i)->bool:
 for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
  if at(c.x+d.x,c.y+d.y) in [0,12]:return true
 return false
func visible_from(origin:Vector2,c:Vector2i)->bool:
 var delta=center(c)-origin
 for step in range(1,int(delta.length()),3):
  var q=cell_at(origin+delta.normalized()*step)
  if q!=c and at(q.x,q.y) not in [0,12]:return false
 return true
func strike(c:Vector2i,power:float,careful:bool=false,thermal:bool=false)->Dictionary:
 var kind=at(c.x,c.y)
 if kind in [0,8]:return {}
 var k=key(c);damage[k]=float(damage.get(k,0))+power
 if damage[k]<hardness(kind):return {}
 set_cell(c,0);damage.erase(k)
 var item=HoldData.TILES[kind].item
 if thermal and kind in [3,4]:item="iron_slag" if kind==3 else "copper_slag"
 var mass=2 if kind==6 and careful else (3 if kind in [9,10,12] else (2 if kind in [3,4,5] else 1))
 if thermal and kind in [5,9]:mass=0
 grain_bank[item]=int(grain_bank.get(item,0))+mass
 var count=int(grain_bank[item])/GRAINS_PER_UNIT
 grain_bank[item]=int(grain_bank[item])%GRAINS_PER_UNIT
 activate_near(c)
 return {"item":item,"count":count,"kind":kind,"grains":mass,"cell":c}
func excavate(contact:Vector2,origin:Vector2,radius:float,power:float,steel:bool=false,protect_structures:bool=false,thermal:bool=false)->Array:
 var center_cell=cell_at(contact)
 var reach=int(ceil(radius/TILE))+1
 var candidates:Array[Vector2i]=[]
 # Snapshot exposed faces before removing anything: one stroke cannot tunnel
 # through a whole layer into an unseen seam.
 for y in range(center_cell.y-reach,center_cell.y+reach+1):
  for x in range(center_cell.x-reach,center_cell.x+reach+1):
   var c=Vector2i(x,y);var kind=at(x,y)
   if kind in [0,8] or (thermal and kind in [10,12,13]) or (kind==7 and not steel) or (kind==13 and (protect_structures or at(center_cell.x,center_cell.y)!=13)):continue
   if radius==0 and c!=center_cell:continue
   if radius>0 and center(c).distance_to(contact)>radius+TILE*.6:continue
   if exposed(c) and visible_from(origin,c):candidates.append(c)
 var results:Array=[]
 for c in candidates:
  var result=strike(c,power,radius==0 and not thermal,thermal)
  if not result.is_empty():results.append(result)
 return results
func activate_near(c:Vector2i):
 for y in range(c.y-2,c.y+3):
  for x in range(c.x-2,c.x+3):
   if x<=0 or x>=W-1 or y<=0 or y>=H-1:continue
   var kind=at(x,y)
   if kind==10 and (at(x-1,y) in [0,12] or at(x+1,y) in [0,12] or at(x,y+1) in [0,12]):
    set_cell(Vector2i(x,y),12);kind=12
   if kind in [1,12]:active_grains[y*W+x]=true
func move_grain(from:Vector2i,to:Vector2i):
 var a=at(from.x,from.y);var b=at(to.x,to.y)
 set_cell(from,b);set_cell(to,a)
 var old_damage=float(damage.get(key(from),0));var other_damage=float(damage.get(key(to),0))
 damage.erase(key(from));damage.erase(key(to))
 if old_damage>0:damage[key(to)]=old_damage
 if other_damage>0:damage[key(from)]=other_damage
 activate_near(from);activate_near(to)
func tick_materials(dt:float,occupied:Rect2=Rect2())->int:
 physics_clock+=dt
 if physics_clock<.05 or active_grains.is_empty():return 0
 physics_clock=fmod(physics_clock,.05);physics_tick+=1
 var pending=active_grains.keys()
 # Bounded FIFO work; new neighbors append for the next tick instead of sorting the entire avalanche.
 var started=Time.get_ticks_usec()
 var moved=0;var visited=0
 for raw_index in pending:
  if visited>=160 or (visited>24 and Time.get_ticks_usec()-started>1800):break
  visited+=1;var index=int(raw_index);active_grains.erase(raw_index)
  var c=Vector2i(index%W,index/W);var kind=at(c.x,c.y)
  if kind not in [1,12]:continue
  var candidates=[Vector2i(0,1)]
  var side=1 if (c.x+physics_tick)%2==0 else -1
  candidates.append(Vector2i(side,1));candidates.append(Vector2i(-side,1))
  if kind==12:candidates.append(Vector2i(side,0));candidates.append(Vector2i(-side,0))
  for d in candidates:
   var q=c+d;var target=at(q.x,q.y)
   if target!=0 and not (kind==1 and target==12):continue
   if d.x!=0 and at(c.x+d.x,c.y) not in [0,12]:continue
   if kind==1 and occupied.has_point(center(q)):continue
   move_grain(c,q);moved+=1;break
 return moved
func snapshot()->Dictionary:
 return {"mountain":mountain.duplicate(true),"structures":structures.duplicate(true),"grid":TILE,"cells":cells.duplicate(),"damage":damage.duplicate(true),"seed":seed_value,"world_address":world_address.duplicate(),"grain_bank":grain_bank.duplicate(),"active_grains":active_grains.keys()}
func restore(data:Dictionary)->bool:
 var source:Array=data.get("cells",[])
 if source.size() not in [W*H,96*44]:return false
 mountain=data.get("mountain",{}).duplicate(true);structures=data.get("structures",[]).duplicate(true);timbers={};structure_dirty=true
 seed_value=int(data.get("seed",data.get("geo_seed",0)))
 world_address=data.get("world_address",{}).duplicate()
 damage={};grain_bank=data.get("grain_bank",{}).duplicate();active_grains={};dirty={}
 if source.size()==W*H:
  cells=[]
  for value in source:cells.append(int(value))
  damage=data.get("damage",{}).duplicate(true)
  for index in data.get("active_grains",[]):active_grains[int(index)]=true
 else:
  cells.resize(W*H)
  for y in H:
   for x in W:cells[y*W+x]=int(source[(y/SUBDIV)*96+x/SUBDIV])
  for old_key in data.get("damage",{}):
   var pieces=str(old_key).split(",")
   if pieces.size()!=2:continue
   var base=Vector2i(int(pieces[0]),int(pieces[1]))*SUBDIV
   for dy in SUBDIV:
    for dx in SUBDIV:damage[key(base+Vector2i(dx,dy))]=float(data.damage[old_key])*.5
 for i in cells.size():
  if int(cells[i])==13:timbers[i]=true
 redraw_all=true;physics_clock=0;return true
func route(start:Vector2i,priority:String)->Dictionary:
 start.x=clampi(start.x,1,W-2);start.y=clampi(start.y,1,H-2)
 if at(start.x,start.y) not in [0,12]:return {}
 var queue:Array[Vector2i]=[start];var prev:Dictionary={start:start};var best:Dictionary={};var n=0
 while n<queue.size() and n<16000:
  var c=queue[n];n+=1
  for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var q=c+d
   if q.x<1 or q.x>=W-1 or q.y<1 or q.y>=H-1:continue
   var kind=at(q.x,q.y)
   if kind not in [0,8,7,12,13]:
    if best.is_empty() or HoldData.TILES[kind].item==priority:
     best={"target":q,"stand":c}
     if HoldData.TILES[kind].item==priority:break
   elif kind in [0,12] and not prev.has(q):prev[q]=c;queue.append(q)
  if not best.is_empty() and HoldData.TILES[at(best.target.x,best.target.y)].item==priority:break
 if best.is_empty():return {}
 var path:Array[Vector2]=[];var c:Vector2i=best.stand
 while c!=start:path.push_front(center(c));c=prev[c]
 best.path=path;return best

# Called only for dirt grains just removed by a sifting stroke. Consumed terrain
# prevents repeated sampling; the seed makes traces reproducible across saves.
func prospect(c:Vector2i)->Dictionary:
 var rng=RandomNumberGenerator.new();rng.seed=absi(seed_value+c.x*73856093+c.y*19349663)
 if rng.randf()>.22:return {}
 var nearest=Vector2i(-1,-1);var distance=1601;var kind=0
 for y in range(maxi(1,c.y-40),mini(H-2,c.y+41)):
  for x in range(maxi(1,c.x-40),mini(W-2,c.x+41)):
   var k=at(x,y)
   if k not in [3,4,5,6]:continue
   var d=(x-c.x)*(x-c.x)+(y-c.y)*(y-c.y)
   if d<distance:distance=d;nearest=Vector2i(x,y);kind=k
 if kind==0:return {}
 var item=HoldData.TILES[kind].item
 grain_bank[item]=int(grain_bank.get(item,0))+rng.randi_range(1,3)
 var count=int(grain_bank[item])/GRAINS_PER_UNIT
 grain_bank[item]=int(grain_bank[item])%GRAINS_PER_UNIT
 var direction="deeper" if nearest.y>c.y+5 else "higher" if nearest.y<c.y-5 else "along this level"
 if abs(nearest.x-c.x)>8:direction+=" and "+("east" if nearest.x>c.x else "west")
 return {"item":item,"count":count,"clue":HoldData.ITEMS[item].name+" traces — follow the seam "+direction+"."}
