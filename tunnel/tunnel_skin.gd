extends RefCounted
## Four surveyed cell centres share one painted junction. Damage and floor
## occupancy come directly from Deepworks, including old saves and crew cuts.
const STEP=40.0
const PHASE=Vector2i(8,6)
const STAMP=64
const PITCH=66
const CORNERS=[Vector2i.ZERO,Vector2i.RIGHT,Vector2i.ONE,Vector2i.DOWN]
const SIDES=[Vector2i.UP,Vector2i.RIGHT,Vector2i.DOWN,Vector2i.LEFT]
var atlas:Texture2D
var mountain:Texture2D

func load_stone():
 if atlas!=null:return
 var image=Image.new()
 if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://tunnel/shale.webp"))==OK:
  atlas=ImageTexture.create_from_image(image)
 if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://tunnel/mountain.webp"))==OK:
  mountain=ImageTexture.create_from_image(image)

static func light_at(p:Vector2,player:Vector2,lamps:Array)->Color:
 var light=clampf(1.11-p.distance_to(player)/580,.29,1)
 for lamp in lamps:
  light=maxf(light,clampf(1.02-p.distance_to(lamp)/253,0,.95))
 return Color(light,light,light)

static func junction(open:Dictionary,c:Vector2i)->int:
 var mask=0
 for i in 4:
  if open.has(c+CORNERS[i]):mask|=1<<i
 return mask

const Slope=preload("res://quarry/quarry_slope.gd")
func ground(g,world,start:Vector2i,lamps:Array):
 var a=Slope.anchor(world)
 var shared=Slope.joined_view(g.player,a,world.depth())
 if shared>0:
  paint_level(g,world,start,lamps,0,a,shared,false)
  paint_level(g,world,start,lamps,1,a,shared,true)
 else:paint_level(g,world,start,lamps,world.depth(),a,0,false)

func paint_level(g,world,start:Vector2i,lamps:Array,level:int,a:Vector2,shared:float,overlay:bool):
 load_stone()
 if atlas==null or mountain==null:return
 var limit=Rect2i(0,0,world.W,world.H)
 var view=Rect2i(start-Vector2i.ONE,Vector2i(29,19))
 var seen=world.layer(level).seen
 var open={}
 var lighting={}
 for y in range(view.position.y,view.end.y+1):
  for x in range(view.position.x,view.end.x+1):
   var c=Vector2i(x,y)
   if limit.has_point(c) and seen.has(world.key(c)) and world.at(c,level)==0:open[c]=true
   var point=world.center(c)
   var lit=light_at(point,g.player,lamps)
   if level>=8:lit*=Deepworks.Strata.TINT[Deepworks.Strata.band(Deepworks.Strata.number(level))]
   if level==1:lit=lit*Color(.81,.86,.92,1.)
   if overlay:lit.a=Slope.lower_weight(point,a,shared,world.depth())
   lighting[c]=lit
 var texsize=atlas.get_size()
 for y in range(view.position.y,view.end.y):
  for x in range(view.position.x,view.end.x):
   var c=Vector2i(x,y)
   if shared>0 and not overlay and Slope.lower_weight(world.center(c),a,shared,world.depth())>=.999 and Slope.lower_weight(world.center(c+Vector2i.ONE),a,shared,world.depth())>=.999:continue
   if overlay and lighting[c].a<=0.001 and lighting[c+Vector2i.ONE].a<=0.001:continue
   var m=junction(open,c)
   var slot=Vector2(posmod(x,PHASE.x)*4+m%4,posmod(y,PHASE.y)*4+floori(m/4.0))
   var pos=PackedVector2Array()
   var uv=PackedVector2Array()
   var colors=PackedColorArray()
   for delta in CORNERS:
    pos.append(world.center(c+delta))
    uv.append((slot*PITCH+Vector2.ONE+Vector2(delta)*STAMP)/texsize)
    colors.append(lighting[c+delta])
   if m!=15:
    var cap_uv=PackedVector2Array()
    var corner=Vector2(posmod(x,24),posmod(y,24))
    for delta in CORNERS:cap_uv.append((corner+Vector2(delta))/24.0)
    g.draw_polygon(pos,colors,cap_uv,mountain)
   if m!=0:g.draw_polygon(pos,colors,uv,atlas)

static func face_direction(world,c:Vector2i,player:Vector2)->Vector2:
 var nearest=INF
 var best=Vector2.ZERO
 var seen=world.layer().seen
 for side in SIDES:
  var n=c+side
  if world.at(n)!=0 or not seen.has(world.key(n)):continue
  var d=world.center(n).distance_squared_to(player)
  if d<nearest:
   nearest=d
   best=Vector2(side)
 return best

static func marks(g,world,c:Vector2i,k:int,aim:Vector2i,ore:Color):
 if k==0:return
 var face=face_direction(world,c,g.player)
 if face==Vector2.ZERO:return
 var side=Vector2(-face.y,face.x)
 var p=world.center(c)
 var h=posmod(c.x*131+c.y*191+int(world.data.seed),997)
 var toe=p+face*18.7
 var amount=float(world.layer().damage.get(world.key(c),0))
 if amount>0:
  var ratio=clampf(amount/world.resistance(k),0,1)
  var shift=float(h%9-4)
  var tip=toe+side*shift-face*3
  var fork=tip-face*(4+ratio*3)+side*(2 if h%2 else -2)
  var elbow=fork-face*(3+ratio*4)-side*1.6
  var last=elbow-face*(2+ratio*8)+side*(2 if h%3 else -3)
  if amount>.60:
   var flake=PackedVector2Array([tip-side*(3+ratio*3),fork-face*2,tip+side*(2+ratio*4),tip+face*1.2])
   g.draw_colored_polygon(flake,Color("8da3a5"))
   g.draw_line(flake[0],flake[1],Color("c1c9ba"),1.15,true)
  var seam=PackedVector2Array([tip,fork,elbow,last])
  var glint=PackedVector2Array()
  for point in seam:glint.append(point+Vector2(.8,-.65))
  g.draw_polyline(glint,Color(.68,.74,.70,.64),1.15,true)
  g.draw_polyline(seam,Color("152328"),1.3+ratio*.8,true)
  if amount>.60:
   var handed=1.0 if h%2 else -1.0
   var n=c+Vector2i(side*handed)
   var branch=PackedVector2Array([fork,fork+side*(6*handed)-face*2,fork+side*(10*handed)-face*1.3])
   if world.at(n)>0 and world.layer().seen.has(world.key(n)):
    branch.append(p+side*(23*handed)+face*6)
   var split_light=PackedVector2Array()
   for point in branch:split_light.append(point+Vector2(.5,-.85))
   g.draw_polyline(split_light,Color(.60,.68,.68,.76),1.0,true)
   g.draw_polyline(branch,Color("16252d"),1.4,true)
 if k in [3,4,5,6]:
  var count=2+world.grade(c)
  for i in count:
   var a=p+face*(6+(h+i*11)%7)+side*(-12+i*7+(h+i*3)%4)
   var size=3.5 if k==6 else 2.6
   var gem=PackedVector2Array([a-side*size,a-face*(size+1)+side*.5,a+side*(size+1),a+face*1.7])
   g.draw_colored_polygon(gem,ore.darkened(.22))
   g.draw_line(gem[0],gem[1],ore.lightened(.22),1.2,true)
 if c==aim and g.panel_id=="" and k!=8:
  var rim=toe-face*(2 if face.y<=0 else 5)
  g.draw_polyline(PackedVector2Array([rim-side*9-face,rim-side*3,rim+side*4-face*1.2,rim+side*9-face]),Color("f0d294"),1.8,true)
