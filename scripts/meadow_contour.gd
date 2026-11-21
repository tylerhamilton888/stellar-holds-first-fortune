extends RefCounted

# The editable strip is a unit of work. The painted contours continue over its edges.
const TURF=preload("res://assets/cart_bank/meadow.webp")
const SOIL=preload("res://assets/cart_bank/cut_loam.webp")
const Slate=preload("res://scripts/yard_slate.gd")
const SPOIL=preload("res://assets/cart_bank/spoil.webp")
const LEFT=2020.0
const SPAN=584.0
const HEIGHT=220.0
const FRONT=.64
# Height of the turf lip in the painting, sampled from left to right.
const LIP=[.743,.775,.763,.733,.683,.672,.704,.701,.676,.675,.674]
const STRIP=32.0
const FIRST=2072.0
const Y=1296.0

static var previous_depth:Array=[]
static var turf_ground:ArrayMesh
static var turf_face:ArrayMesh

static func lip(x:float)->float:
 var u=clampf((x-LEFT)/SPAN,0,1)*(LIP.size()-1)
 var a=mini(floori(u),LIP.size()-2)
 return lerpf(LIP[a],LIP[a+1],u-a)

static func line_y(x:float)->float:
 var shift=(lip(x)-.726)*HEIGHT+9*sin((x-2216)/83.0)
 return Y+14*tanh(shift/14)

static func exposure(depth:Array,x:float,v:float)->float:
 # The downhill mouth splays. Loose earth and roots break up the upper rim.
 var foot=smoothstep(.45,.9,v)
 var drift=4*sin(v*13+x*.023)+3*sin(v*23+x*.042)
 var sample_x=x+drift
 var near=floori((sample_x-FIRST)/STRIP)
 var cut=0.0
 for i in range(maxi(0,near-2),mini(depth.size(),near+3)):
  var step=int(depth[i])
  if step==0:continue
  var distance=absf(sample_x-(FIRST+(i+.5)*STRIP))-STRIP*.5
  var adjacent=i-1 if sample_x<FIRST+(i+.5)*STRIP else i+1
  if distance<=0 and adjacent>=0 and adjacent<depth.size() and int(depth[adjacent])>=step:distance=minf(-6,distance)
  var spread=lerpf(12,29,foot)*(1.1 if sample_x<FIRST+(i+.5)*STRIP else .88)
  var influence=1-smoothstep(-6,spread,distance)
  cut=maxf(cut,influence*float(step)/3.0)
 return cut

static func terrain_mesh(depth:Array,top:float,bottom:float,rows:int)->ArrayMesh:
 var pts=PackedVector2Array();var uv=PackedVector2Array();var colors=PackedColorArray();var indices=PackedInt32Array()
 const COLS=100
 for r in rows+1:
  var v=lerpf(top,bottom,float(r)/rows)
  for c in COLS+1:
   var u=float(c)/COLS
   var x=LEFT+SPAN*u
   var cut=exposure(depth,x,v)
   var crest=lip(x)
   var band=1-smoothstep(.055,.31,absf(v-crest))
   var y=line_y(x)+(v-crest)*HEIGHT+cut*band*12
   var relief=smoothstep(.045,.21,u)*(1-smoothstep(.83,.96,u))
   y+=(smoothstep(crest-.04,crest+.04,v)-.50)*22*relief*(1-cut)
   var alpha=(1-smoothstep(.03,.91,cut)*band)
   # Let the cut blend into the unbroken grass at the head and toe.
   var light=1-.10*cut*band-.13*relief*(1-cut)*(1-smoothstep(.008,.055,absf(v-crest-.015)))
   pts.append(Vector2(x,y));uv.append(Vector2(u,v));colors.append(Color(light*.95,light*.97,light*.91,alpha))
   if c<COLS and r<rows:
    var k=r*(COLS+1)+c
    indices.append_array(PackedInt32Array([k,k+1,k+COLS+1,k+1,k+COLS+2,k+COLS+1]))
 var arrays=[];arrays.resize(Mesh.ARRAY_MAX)
 arrays[Mesh.ARRAY_VERTEX]=pts;arrays[Mesh.ARRAY_TEX_UV]=uv;arrays[Mesh.ARRAY_COLOR]=colors;arrays[Mesh.ARRAY_INDEX]=indices
 var mesh=ArrayMesh.new();mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
 return mesh

static func prepare(depth:Array):
 if turf_ground!=null and previous_depth==depth:return
 previous_depth=depth.duplicate()
 turf_ground=terrain_mesh(depth,0,FRONT,11)
 turf_face=terrain_mesh(depth,FRONT,1,21)

static func draw_loam(g,x:float,span:float):
 # Widen the uphill end of the painted scoop and feather the two approaches.
 # Its source is a three-quarter painting with substantial transparent margins.
 var bands=[0.0,.18,.38,.60,.79,1.0]
 for j in bands.size()-1:
  var corners=PackedVector2Array();var uv=PackedVector2Array();var shades=PackedColorArray()
  for corner in [Vector2(0,bands[j]),Vector2(1,bands[j]),Vector2(1,bands[j+1]),Vector2(0,bands[j+1])]:
   var t=corner.y
   var width=(span+46)*lerpf(1.67,1.08,t)
   var offset=(1-t)*4*sin(x*.08)
   corners.append(Vector2(x+offset+(corner.x-.5)*width,line_y(x)+lerpf(-56,47,t)))
   uv.append(corner)
   var opacity=.45+.46*sin(t*PI)
   shades.append(Color(.96,.96,.88,opacity))
  g.draw_polygon(corners,shades,uv,SOIL)

static func earth(g,d:Dictionary):
 prepare(d.depth)
 g.draw_mesh(turf_ground,TURF)
 var i=0
 while i<d.depth.size():
  if int(d.depth[i])==0:i+=1;continue
  var first=i
  while i<d.depth.size() and int(d.depth[i])>0:i+=1
  var length=(i-first)*STRIP
  var panels=ceili(length/98)
  var span=length/panels
  for n in panels:
   var x=FIRST+first*STRIP+(n+.5)*span
   draw_loam(g,x,span)
  if int(d.spoil)>0:
   var left=FIRST+first*STRIP
   var heap_width=clampf(17+(i-first)*3,20,40)
   g.draw_texture_rect(SPOIL,Rect2(left-heap_width*.73,line_y(left)+20,heap_width,heap_width*.36),false,Color(.79,.77,.63,.87))

 if g.fieldwork.has_method("draw_kitchen"):g.fieldwork.draw_kitchen()

static func face(g,d:Dictionary):
 prepare(d.depth);g.draw_mesh(turf_face,TURF)
 for i in d.depth.size():
  var x=FIRST+(i+.5)*STRIP
  if int(d.depth[i])==2:
   g.draw_texture_rect(SPOIL,Rect2(x-12,line_y(x)+2,21,6),false,Color(.73,.74,.61,.83))
  if d.stone.has(str(i)):
   # The approach and the ramp use the same local slate. The small last stones
   # sit nearly flush with the earth so the paving peters out at either end.
   for row in 6:
    var seed_value=i*37+row*13
    var middle=sin(PI*float(row)/5)
    var stone_x=x+(-2 if i%2==0 else 2)+2.3*sin(i+row*1.4)
    var stone_y=line_y(x)-30+row*11+2.4*sin(i*2+row*.5)
    var size=Vector2(12+8*middle,7+5*middle)
    Slate.flag(g,Vector2(stone_x,stone_y),size,seed_value,.58+.40*middle)
