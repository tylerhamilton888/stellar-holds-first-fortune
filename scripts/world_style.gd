class_name HoldWorldStyle
extends RefCounted
# Versioned, deterministic address space: no global RNG or visit-order state.
const VERSION=2
const ROCK=preload("res://assets/actors-v11/slate.png")
static func address_seed(galaxy:int,planet:int,region:Vector2i,channel:int=0)->int:
 var h=posmod(galaxy,2147483647)
 for v in [planet,region.x,region.y,channel,VERSION]:h=posmod(h*48271+posmod(v,2147483647)*69621+1,2147483647)
 return h
static func profile(seed_value:int)->Dictionary:
 var family=posmod(seed_value,3)
 return {"family":family,"rock":[Color("73818b"),Color("847d77"),Color("637e7c")][family],"mist":[Color("294456"),Color("3b3c50"),Color("254c4b")][family],"slope":.12+float(posmod(seed_value,19))*.017,"phase":float(posmod(seed_value,997)),"bed":70+posmod(seed_value,43)}
static func field(seed_value:int)->FastNoiseLite:
 var noise=FastNoiseLite.new();noise.seed=seed_value;noise.frequency=.007;noise.fractal_octaves=3
 return noise
static func stratum(x:float,y:float,p:Dictionary)->float:
 return y+x*p.slope+sin(x*.011+p.phase)*17+sin(x*.003-p.phase)*31
static func sample(seed_value:int,x:int,y:int,channel:int=0)->float:
 return float(address_seed(seed_value,channel,Vector2i(x,y))%10000)/9999.0
static func background(n:Node2D,camera:Vector2,seed_value:int,time:float):
 var p=profile(seed_value)
 # Three world-anchored layers move at distinct parallax speeds.
 for layer in 3:
  var speed=.08+layer*.10
  var spacing=230-layer*32
  var offset=camera.x*speed
  var first=int(floor(offset/spacing))-1
  for i in range(first,first+8):
   var x=i*spacing-offset
   var h=130+sample(seed_value,i,layer,1)*240
   var width=45+sample(seed_value,i,layer,2)*80
   var floor_y=580-camera.y*speed*.25
   var points=PackedVector2Array([Vector2(x-width,floor_y),Vector2(x-width*.7,floor_y-h*.35),Vector2(x-width*.5,floor_y-h*.38),Vector2(x-width*.46,floor_y-h*.76),Vector2(x-width*.20,floor_y-h*.79),Vector2(x-width*.18,floor_y-h*.97),Vector2(x+width*.12,floor_y-h),Vector2(x+width*.15,floor_y-h*.83),Vector2(x+width*.30,floor_y-h*.81),Vector2(x+width*.35,floor_y-h*.55),Vector2(x+width*.6,floor_y-h*.52),Vector2(x+width,floor_y)])
   var uv=PackedVector2Array()
   for point in points:uv.append(Vector2((point.x-x+width)/(width*2),(point.y-floor_y+h)/h))
   var tint=Color(.25+layer*.075,.35+layer*.07,.43+layer*.06)
   n.draw_polygon(points,PackedColorArray([tint]),uv,ROCK)
   n.draw_polyline(PackedVector2Array([points[1],points[2],points[3],points[4],points[5],points[6]]),Color(.25,.40,.46,.15),1)
 # Low-opacity light shafts and motes: atmosphere, not collision geometry.
 for i in 3:
  var x=posmod(seed_value+i*317,1100)-camera.x*.12
  n.draw_colored_polygon(PackedVector2Array([Vector2(x,-50),Vector2(x+16,-50),Vector2(x+230,540),Vector2(x+90,540)]),Color(.35,.58,.64,.025))
 for i in 24:
  var x=fposmod(i*131.7+seed_value%131-camera.x*.3+sin(time*.13+i)*9,960)
  var y=fposmod(i*71.3+time*(1+i%3)-camera.y*.2,540)
  n.draw_rect(Rect2(x,y,1.3,1.3),Color(.65,.78,.69,.12))
