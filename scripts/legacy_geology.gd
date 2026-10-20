class_name HoldLegacyGeology
extends RefCounted
const W=96
const H=44
const TILE=28
var cells: Array=[]
var damage: Dictionary={}
var seed_value:int=0
func generate(value:int):
 seed_value=value
 cells.clear()
 damage.clear()
 var rng=RandomNumberGenerator.new()
 rng.seed=value
 var cave=FastNoiseLite.new()
 cave.seed=value
 cave.frequency=0.095
 for y in H:
  for x in W:
   var layer=10+int(sin(x*0.13)*2)
   var kind=0
   if y>=layer: kind=1 if y<layer+3 else (2 if y<28+int(sin(x*.1)*3) else 7)
   if kind!=0 and y>layer+3 and cave.get_noise_2d(x,y)>.27: kind=0
   if x==0 or x==W-1 or y==H-1: kind=8
   cells.append(kind)
 # Ore bodies follow folded strata. Correlated random walks form connected veins.
 for vein in 94:
  var x=rng.randi_range(3,W-4)
  var y=rng.randi_range(12,H-4)
  var kind=([3,4,5,5,3,4][vein%6] if y<24 else [3,4,3,5,6,6][vein%6])
  for segment in rng.randi_range(5,13):
   for dy in 2:
    if at(x,y+dy) not in [0,8]: cells[(y+dy)*W+x]=kind
   x=clampi(x+rng.randi_range(-1,2),2,W-3)
   y=clampi(y+rng.randi_range(-1,1),11,H-3)
 # Broad, seeded chambers punctuate the narrow natural fractures. Solid rock
 # between them remains diggable: following a vein can open a new room.
 for chamber in 12:
  var cx=25+(chamber%4)*19+rng.randi_range(-3,3)
  var cy=18+(chamber/4)*8+rng.randi_range(-2,2)
  var rx=rng.randi_range(4,7);var ry=rng.randi_range(2,4)
  for yy in range(cy-ry,cy+ry+1):
   for xx in range(cx-rx,cx+rx+1):
    if xx<20 or xx>=W-2 or yy<12 or yy>=H-2:continue
    var distance=pow(float(xx-cx)/rx,2)+pow(float(yy-cy)/ry,2)
    if distance<1.0:cells[yy*W+xx]=0
    elif distance<1.5 and at(xx,yy)!=8:
     cells[yy*W+xx]=[5,4,3,6][chamber%4]
  # Supplies grow or collect in chamber floors, giving exploration utility.
  for xx in range(cx-2,cx+3):
   for yy in range(cy,mini(cy+ry+2,H-2)):
    if at(xx,yy)!=0 and at(xx,yy-1)==0:
     cells[yy*W+xx]=9 if chamber%2==0 else 10
     break
 # The first chamber is reachable through a deliberately thin diggable wall.
 for yy in range(11,14):
  for xx in range(20,29):cells[yy*W+xx]=0
 for xx in range(21,28):cells[14*W+xx]=9 if xx%2==0 else 5
 cells[14*W+27]=10
 # Accessible starter gallery, with guaranteed starter deposits along its floor.
 for y in range(5,14):
  for x in range(1,19): cells[y*W+x]=0
 for x in range(2,19):
  cells[14*W+x]=[2,3,3,5,4,4,5,3,3,5,2,4,5,3,6,2,2][x-2]
  cells[15*W+x]=[3,3,5,4,5][x%5]
func at(x:int,y:int)->int:
 if x<0 or x>=W or y<0 or y>=H: return 8
 return int(cells[y*W+x])
func at_pos(p:Vector2)->int:
 return at(int(floor(p.x/TILE)),int(floor(p.y/TILE)))
func solid(p:Vector2)->bool:
 return at_pos(p)!=0
func key(c:Vector2i)->String: return "%d,%d" % [c.x,c.y]
func center(c:Vector2i)->Vector2: return Vector2(c)*TILE+Vector2.ONE*TILE/2
func strike(c:Vector2i,power:float)->Dictionary:
 var kind=at(c.x,c.y)
 if kind==0 or kind==8:return {}
 var k=key(c)
 damage[k]=float(damage.get(k,0))+power
 if damage[k]>=HoldData.TILES[kind].hp:
  cells[c.y*W+c.x]=0
  damage.erase(k)
  return {"item":HoldData.TILES[kind].item,"count":3 if kind in [9,10] else (2 if kind in [3,4,5] else 1),"kind":kind}
 return {}
func route(start:Vector2i, priority:String)->Dictionary:
 # Flood-fill only traversable air. Agents follow the returned route rather than
 # mining through sealed terrain or generating abstract passive income.
 start.x=clampi(start.x,1,W-2)
 start.y=clampi(start.y,1,H-2)
 if at(start.x,start.y)!=0:return {}
 var queue:Array[Vector2i]=[start]
 var prev:Dictionary={start:start}
 var best:Dictionary={}
 var n=0
 while n<queue.size() and n<2500:
  var c:Vector2i=queue[n]
  n+=1
  for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var q:Vector2i=c+d
   if q.x<1 or q.x>=W-1 or q.y<1 or q.y>=H-1:continue
   var kind=at(q.x,q.y)
   if kind!=0 and kind!=8 and kind!=7:
    if best.is_empty() or HoldData.TILES[kind].item==priority:
     best={"target":q,"stand":c}
     if HoldData.TILES[kind].item==priority:break
   elif kind==0 and not prev.has(q):
    prev[q]=c
    queue.append(q)
  if not best.is_empty() and HoldData.TILES[at(best.target.x,best.target.y)].item==priority:break
 if best.is_empty():return {}
 var path:Array[Vector2]=[]
 var c:Vector2i=best.stand
 while c!=start:
  path.push_front(center(c))
  c=prev[c]
 best.path=path
 return best
