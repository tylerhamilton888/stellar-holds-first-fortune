extends RefCounted
## Only called on newly generated claim geology. All later mining edits belong to Deepworks.
const WIDTH=80
const DIRS=[Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]
static func put(layer:Dictionary,c:Vector2i,kind:int):
 layer.cells[c.y*WIDTH+c.x]=kind

static func plan(data:Dictionary)->Dictionary:
 if data.has("quarry"):return data.quarry
 var rng=RandomNumberGenerator.new();rng.seed=int(data.seed)^0x5a071
 var wide=rng.randi_range(7,9)
 var high=rng.randi_range(4,5)
 var first=rng.randi_range(0,15)
 var row=rng.randi_range(3,5)
 for i in 48:
  var x=17+posmod(first+i,16)
  var y=3+posmod(row-3+floori(i/16.0),3)
  var bounds=Rect2i(x-1,y-1,wide+2,high+2)
  if not intact(data,bounds):continue
  var q={"x":x,"y":y,"width":wide,"height":high,"bench_offset":rng.randi_range(1,2)}
  var room=data.layers[0]
  for py in range(y,y+high):
   for px in range(x,x+wide):
    if (px==x and py==y) or (px==x+wide-1 and py==y+high-1):continue
    put(room,Vector2i(px,py),0)
  for half in 2:put(room,slab(q)+Vector2i.RIGHT*half,2)
  var ry=road_y(q)
  for px in range(12,x-1):
   for lane in 2:put(room,Vector2i(px,ry+lane),0)
  for lane in 2:put(room,Vector2i(x-1,ry+lane),2)
  var crest=Vector2i(x+wide-1,ry)
  var seam=crest+Vector2i(3,1)
  q.ledge=true
  # The projected route spans six horizontal cells. Both levels contain the
  # crossing cell so pathfinding, collision and traversal use ordinary terrain.
  for step in range(0,9):
   var drop=clampf(step/6.,0,1)*120.
   var mid=ry*40.+12.+drop
   for cy in range(floori((mid-35)/40.),floori((mid+61)/40.)+1):
    if step<=4:put(room,Vector2i(crest.x+step,cy),0)
    if step>=2:put(data.layers[1],Vector2i(crest.x+step,cy),0)
  for dx in range(-wide+2,9):
   for dy in range(5,8):
    if (dx==-wide+2 or dx==8) and dy==7:continue
    put(data.layers[1],crest+Vector2i(dx,dy),0)
  for dx in range(5,8):put(data.layers[1],crest+Vector2i(dx,4),0)
  data.links["0:%d,%d"%[seam.x,seam.y]]={"x":seam.x,"y":seam.y,"upper":0,"lower":1,"kind":"ramp"}
  q.ramp=true
  q.hatch_version=1
  data.quarry=q
  return q
 return {}

# Previous quarry previews stamped a stair at this exact coordinate.
# Convert it once, so a subsequent player-built freight stair keeps its kind.
static func restore_passage(data:Dictionary):
 var q:Dictionary=data.get("quarry",{})
 if q.is_empty() or q.has("hatch_version"):return
 var c=shaft(q)
 var link:Dictionary=data.links.get("0:%d,%d"%[c.x,c.y],{})
 if not link.is_empty() and int(link.get("lower",-1))==1:
  link.kind="ladder"
 q.hatch_version=1

static func intact(data:Dictionary,r:Rect2i)->bool:
 for layer in [data.layers[0],data.layers[1]]:
  for y in range(r.position.y,r.end.y):
   for x in range(r.position.x,r.end.x):
    if int(layer.cells[y*WIDTH+x]) in [0,8]:return false
 return true
static func road_y(q:Dictionary)->int:return int(q.y)+int(q.height)-2
static func slab(q:Dictionary)->Vector2i:return Vector2i(int(q.x)+int(q.width)-2,int(q.y)+1)
static func bench(q:Dictionary)->Vector2i:return Vector2i(int(q.x)+int(q.bench_offset),int(q.y)+1)
static func shaft(q:Dictionary)->Vector2i:return slab(q)+Vector2i(-1,1)
static func is_slab(q:Dictionary,c:Vector2i)->bool:
 return not q.is_empty() and (c==slab(q) or c==slab(q)+Vector2i.RIGHT) and not q.get("taken_"+str(c.x-slab(q).x),false)
static func notice(w,c:Vector2i)->bool:
 var q=w.data.get("quarry",{})
 if q.is_empty() or q.get("found",false) or w.depth()!=0:return false
 if not Rect2i(q.x,q.y,q.width,q.height).has_point(c):return false
 q.found=true;w.data.discoveries.append("Old stone quarry");return true

static func furnish(g,w):
 var q=w.data.get("quarry",{})
 if q.is_empty() or q.get("bench_placed",false):return
 var p=w.center(bench(q))+Vector2(0,12)
 var d=g.handworks.data();var id=str(d.next);d.next=int(d.next)+1
 d.facilities.append({"id":id,"kind":"breaker","area":"mine:claim:0","x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false,"quarry_bench":true,"concealed":true})
 q.bench_placed=true

var slab_art:Texture2D
var bench_art:Texture2D
func art(name:String)->Texture2D:
 var im=Image.new()
 if im.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://quarry/"+name+".webp"))!=OK:return null
 return ImageTexture.create_from_image(im)
func add_slab(actors:Array,w,q:Dictionary,opacity:float=1.):
 if q.is_empty() or opacity<=0:return
 var a=slab(q)
 for i in 2:
  var c=a+Vector2i.RIGHT*i
  if is_slab(q,c) and w.at(c,0)!=0 and w.layer(0).seen.has(w.key(c)):
   actors.append({"kind":"quarry_slab","p":w.center(c)+Vector2(0,17),"half":i,"opacity":opacity})
func paint_slab(g,o):
 if slab_art==null:slab_art=art("slab")
 if slab_art==null:return
 var size=slab_art.get_size()
 var half=int(o.half)
 var p:Vector2=o.p
 # Each half has its own geological cell and can be taken out first.
 var dst=Rect2(p-Vector2(20,39),Vector2(40,39))
 g.draw_texture_rect_region(slab_art,dst,Rect2(Vector2(half*size.x/2,0),Vector2(size.x/2,size.y)),Color(Color("e4dfca"),o.get("opacity",1.)))
func paint_bench(g,p:Vector2,opacity:float=1.):
 if bench_art==null:bench_art=art("bench")
 if bench_art==null:return
 var shadow=PackedVector2Array()
 for step in 14:shadow.append(p+Vector2(3,0)+Vector2(cos(step*TAU/14)*34,sin(step*TAU/14)*7))
 g.draw_colored_polygon(shadow,Color(.12,.105,.08,.32*opacity))
 g.draw_texture_rect(bench_art,Rect2(p-Vector2(36,40),Vector2(72,45)),false,Color(Color("c5c2b5"),opacity))
func grooves(g,w,q:Dictionary,opacity:float=1.):
 if q.is_empty() or opacity<=.01:return
 var y=road_y(q)
 var seen=w.layer(0).seen
 # A bench leaves short tool chips. Extracted bedrock leaves straight tool marks.
 var work=bench(q)
 for c in [work,work+Vector2i.LEFT,work+Vector2i.RIGHT,slab(q)+Vector2i.LEFT,slab(q),slab(q)+Vector2i.RIGHT]:
  if w.at(c,0)!=0 or not seen.has(w.key(c)):continue
  var origin=Vector2(c)*40
  if origin.distance_to(g.player)>760:continue
  if c.x>=slab(q).x-1:
   var edge=origin+Vector2(3,8)
   g.draw_line(edge+Vector2(0,18),edge+Vector2(2,4),Color(.24,.25,.23,.43*opacity),2,true)
   g.draw_line(edge+Vector2(2,4),edge+Vector2(34,1),Color(.33,.32,.26,.44*opacity),2,true)
   for j in 8:
    var a=edge+Vector2(4+j*3.8,6+posmod(j*7,4))
    g.draw_line(a,a+Vector2(-1.5,8+posmod(j*3,5)),Color(.82,.78,.63,.29*opacity),1,true)
  for j in 12:
   var h=absi(hash(Vector3i(c.x,c.y,j)))
   var chip=origin+Vector2(4+posmod(h,31),8+posmod(h/47,27))
   var size=1.4+posmod(h/91,4)*.45
   g.draw_line(chip+Vector2(1,1),chip+Vector2(size+1,2),Color(.25,.23,.18,.48*opacity),2,true)
   g.draw_line(chip,chip+Vector2(size,-.7),Color(.84,.79,.65,.6*opacity),1.5,true)
 for x in range(11,slab(q).x+1):
  var c=Vector2i(x,y)
  if w.at(c,0)!=0 or not seen.has(w.key(c)):continue
  var start=Vector2(c)*40
  if start.distance_to(g.player)>760:continue
  for rail in [11.,29.]:
   var a=start+Vector2(0,rail+1.8*sin(x*.67))
   var b=start+Vector2(40,rail+1.8*sin((x+1)*.67))
   var t=.64 if x==11 or x==slab(q).x else 1.
   if x==11:a=b.lerp(a,t)
   if x==slab(q).x:b=a.lerp(b,t)
   g.draw_line(a,b,Color(.22,.19,.14,.46*opacity),3,true)
   g.draw_line(a+Vector2(0,1.8),b+Vector2(0,1.8),Color(.85,.79,.61,.4*opacity),1,true)
 # Three wedge sockets on the buried wall are visible before the breakthrough.
 var plug=Vector2i(int(q.x)-1,y)
 if w.at(plug,0)!=0 and seen.has(w.key(plug)):
  var p=Vector2(plug)*40
  g.draw_line(p+Vector2(5,5),p+Vector2(5,35),Color("a0a69c"),2,true)
  for ky in [10,20,30]:
   g.draw_line(p+Vector2(6,ky),p+Vector2(10,ky+1),Color("273237"),2,true)
