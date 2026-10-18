class_name HoldDrawnAnimation
extends RefCounted
# Complete painted pose frames. No limb pivots, warps or rotating sprite strips.
const DRINKS=preload("res://assets/animation-v51/drinks.png")
const ACTIONS=[preload("res://assets/animation-v51/male-actions.png"),preload("res://assets/animation-v51/female-actions.png")]
const WALKS=[preload("res://assets/animation-v51/male-walk.png"),preload("res://assets/animation-v51/female-walk.png")]
const UTILITY=[preload("res://assets/animation-v51/male-utility.png"),preload("res://assets/animation-v51/female-utility.png")]
const MINING=[preload("res://assets/animation-v51/male-mining.png"),preload("res://assets/animation-v51/female-mining.png")]
const HANDLING=[preload("res://assets/animation-v51/male-handling.png"),preload("res://assets/animation-v51/female-handling.png")]
const GARDEN=[preload("res://assets/animation-v51/male-garden.png"),preload("res://assets/animation-v51/female-garden.png")]
const IDLE=preload("res://assets/animation-v51/idle.png")
const IDLE_NECKS=[Vector2(200,43),Vector2(598,40),Vector2(962,37),Vector2(1342,38),Vector2(203,536),Vector2(598,540),Vector2(952,535),Vector2(1342,538)]
const PUSHING=preload("res://assets/animation-v51/pushing.png")
const PUSH_NECKS=[Vector2(215,67),Vector2(586,65),Vector2(958,65),Vector2(1327,65),Vector2(214,557),Vector2(583,553),Vector2(959,556),Vector2(1322,557)]
const STRONG=preload("res://assets/animation-v51/strong-shoulders.png")
const MINING_NECKS=[
 [Vector2(225,102),Vector2(568,106),Vector2(920,105),Vector2(1325,117),Vector2(224,346),Vector2(567,352),Vector2(920,356),Vector2(1325,357),Vector2(222,596),Vector2(568,599),Vector2(920,599),Vector2(1325,606),Vector2(222,835),Vector2(568,841),Vector2(920,846),Vector2(1325,848)],
 [Vector2(211,98),Vector2(568,103),Vector2(925,99),Vector2(1330,105),Vector2(213,355),Vector2(568,360),Vector2(925,359),Vector2(1330,362),Vector2(212,594),Vector2(568,601),Vector2(925,597),Vector2(1330,602),Vector2(212,848),Vector2(568,852),Vector2(925,848),Vector2(1330,854)]]
const HANDLING_NECKS=[
 [Vector2(215,69),Vector2(548,45),Vector2(925,34),Vector2(1305,23),Vector2(203,279),Vector2(578,278),Vector2(954,278),Vector2(1331,277),Vector2(213,568),Vector2(548,542),Vector2(925,523),Vector2(1305,517),Vector2(199,769),Vector2(579,766),Vector2(955,765),Vector2(1333,766)],
 [Vector2(214,78),Vector2(535,58),Vector2(867,34),Vector2(1236,24),Vector2(215,273),Vector2(558,275),Vector2(908,277),Vector2(1282,273),Vector2(210,570),Vector2(543,540),Vector2(882,524),Vector2(1275,509),Vector2(214,758),Vector2(558,758),Vector2(913,758),Vector2(1299,757)]]
const GARDEN_NECKS=[
 [Vector2(211,92),Vector2(568,92),Vector2(921,91),Vector2(1318,101),Vector2(210,314),Vector2(599,321),Vector2(949,319),Vector2(1337,318),Vector2(198,601),Vector2(493,607),Vector2(922,605),Vector2(1276,611),Vector2(210,853),Vector2(584,820),Vector2(922,809),Vector2(1317,819)],
 [Vector2(257,73),Vector2(583,62),Vector2(891,76),Vector2(1326,98),Vector2(233,294),Vector2(585,295),Vector2(928,302),Vector2(1301,291),Vector2(240,584),Vector2(529,586),Vector2(912,576),Vector2(1273,577),Vector2(253,841),Vector2(602,833),Vector2(945,803),Vector2(1325,792)]]
const STRONG_NECKS=[Vector2(204,69),Vector2(596,69),Vector2(975,70),Vector2(1380,70),Vector2(204,317),Vector2(599,316),Vector2(980,318),Vector2(1380,318),Vector2(210,569),Vector2(604,567),Vector2(979,567),Vector2(1386,567),Vector2(155,779),Vector2(541,779),Vector2(903,778),Vector2(1295,781)]
const NECKS=[
 [Vector2(210,68),Vector2(548,65),Vector2(934,65),Vector2(1300,68),Vector2(210,324),Vector2(590,333),Vector2(960,334),Vector2(1340,334),Vector2(210,579),Vector2(590,584),Vector2(962,581),Vector2(1340,584),Vector2(210,829),Vector2(555,833),Vector2(954,833),Vector2(1330,833)],
 [Vector2(211,73),Vector2(536,73),Vector2(930,70),Vector2(1314,73),Vector2(195,319),Vector2(570,321),Vector2(950,315),Vector2(1325,318),Vector2(195,580),Vector2(570,580),Vector2(950,577),Vector2(1325,576),Vector2(190,820),Vector2(550,821),Vector2(940,816),Vector2(1320,817)]
]
const WALK_NECKS=[
 [Vector2(216,35),Vector2(548,30),Vector2(930,32),Vector2(1320,31),Vector2(230,280),Vector2(585,280),Vector2(950,280),Vector2(1345,280),Vector2(212,525),Vector2(565,525),Vector2(925,525),Vector2(1320,525),Vector2(212,774),Vector2(565,774),Vector2(930,774),Vector2(1320,774)],
 [Vector2(215,58),Vector2(510,58),Vector2(860,59),Vector2(1250,58),Vector2(220,282),Vector2(530,282),Vector2(880,284),Vector2(1270,284),Vector2(215,516),Vector2(530,516),Vector2(875,516),Vector2(1280,515),Vector2(215,758),Vector2(530,758),Vector2(870,758),Vector2(1275,758)]
]
const UTILITY_NECKS=[
 [Vector2(190,55),Vector2(570,61),Vector2(970,112),Vector2(1320,51),Vector2(195,377),Vector2(570,373),Vector2(962,375),Vector2(1320,375),Vector2(198,687),Vector2(590,685),Vector2(960,684),Vector2(1340,685)],
 [Vector2(180,81),Vector2(570,89),Vector2(950,117),Vector2(1310,70),Vector2(190,408),Vector2(560,407),Vector2(960,407),Vector2(1310,407),Vector2(190,720),Vector2(590,717),Vector2(970,717),Vector2(1340,709)]
]
static var metadata={}
static var textures={}
static var heads={}
static func bounds(sheet:String,index:int)->Rect2i:
 if metadata.is_empty():metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/animation-v51/bounds.json"))
 var a=metadata[sheet][index];return Rect2i(a[0],a[1],a[2],a[3])
static func head(profile:Dictionary,row:int)->Texture2D:
 var p=HoldAppearance.normalized(profile);var key=str(p)+str(row)
 if heads.has(key):return heads[key]
 var source=(HoldDirectional.FEMALE if p.gender else HoldDirectional.MALE).get_image().get_region(HoldDirectional.BOUNDS[p.gender][row*5+p.sculpt])
 var img=HoldDirectional.texture(p,row).get_image();var keep=PackedByteArray();keep.resize(img.get_width()*img.get_height())
 for y in img.get_height():
  for x in img.get_width():
   var uv=Vector2(float(x)/img.get_width(),float(y)/img.get_height());var c=source.get_pixel(x,y)
   var pigment=c.h>.085 and c.h<.20 and c.s>.25 and c.v>.26
   var face_center=Vector2(.51,.24) if row==0 else Vector2(.63,.25)
   var face=row<2 and ((uv-face_center)/Vector2(.18,.16)).length()<1
   var skin=c.h>.025 and c.h<.09 and c.v>.68 and c.s<.65 and uv.y<.34 and uv.x>.20 and uv.x<.85
   var crown=p.gender==1 and uv.y<(.36 if row>=2 else .34) and uv.x>.16 and uv.x<.87
   if crown or face or skin or (pigment and HoldDirectional.hair_region(p,row,uv)):keep[y*img.get_width()+x]=1
 # Retain ink, then fill enclosed hair-shadow islands. A pigment-only cutout
 # leaves holes in darker curls, especially on the female sculpts.
 var final_mask=keep.duplicate()
 for y in img.get_height():
  for x in img.get_width():
   if keep[y*img.get_width()+x]:continue
   var ink=source.get_pixel(x,y).v<.22;var neighbor=false
   if ink:
    for dy in range(-2,3):
     for dx in range(-2,3):
      var xx=clampi(x+dx,0,img.get_width()-1);var yy=clampi(y+dy,0,img.get_height()-1)
      if keep[yy*img.get_width()+xx]:neighbor=true
   if neighbor:final_mask[y*img.get_width()+x]=1
 var exterior=PackedByteArray();exterior.resize(final_mask.size());var todo:Array[Vector2i]=[]
 var width=img.get_width();var height=img.get_height()
 for x in width:todo.append(Vector2i(x,0));todo.append(Vector2i(x,height-1))
 for y in height:todo.append(Vector2i(0,y));todo.append(Vector2i(width-1,y))
 var cursor=0
 while cursor<todo.size():
  var q=todo[cursor];cursor+=1
  if q.x<0 or q.y<0 or q.x>=width or q.y>=height:continue
  var i=q.y*width+q.x
  if exterior[i] or final_mask[i]:continue
  exterior[i]=1
  for side in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:todo.append(q+side)
 for y in height:
  for x in width:
   if exterior[y*width+x]:img.set_pixel(x,y,Color.TRANSPARENT)
 var tex=ImageTexture.create_from_image(img);heads[key]=tex;return tex
static func cloth_pixel(c:Color,p:Dictionary,idle:bool=false)->Color:
 # Keep one costume palette across atlases with different painted base shades.
 var target=HoldAppearance.cloth(p)
 return Color.from_hsv(target.h,clampf(target.s*c.s/(.46 if idle else .82),0,1),clampf(target.v*c.v/(.39 if idle else .50),0,1),c.a)
static func frame_texture(p:Dictionary,sheet:String,index:int)->Texture2D:
 var key=sheet+str(index)+"/"+str(p.cloth_color)+"/"+str(p.skin)
 if textures.has(key):return textures[key]
 var atlas=DRINKS if sheet=="drinks" else IDLE if sheet=="idle" else PUSHING if sheet=="pushing" else STRONG if sheet=="strong-shoulders" else (MINING if sheet.ends_with("mining") else HANDLING if sheet.ends_with("handling") else GARDEN if sheet.ends_with("garden") else WALKS if sheet.ends_with("walk") else UTILITY if sheet.ends_with("utility") else ACTIONS)[p.gender]
 var img=atlas.get_image().get_region(bounds(sheet,index))
 # Only one live fishing line/float: the world endpoint follows the real river.
 if sheet.ends_with("garden") and index in [10,11]:
  var n:Vector2=GARDEN_NECKS[p.gender][index];var region=bounds(sheet,index)
  for y in img.get_height():
   for x in img.get_width():
    var q=Vector2(x,y)+Vector2(region.position)
    if q.x>n.x+150 and q.y>n.y-30:img.set_pixel(x,y,Color.TRANSPARENT)
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.05:continue
   if c.h>.43 and c.h<.62 and c.s>.2:c=cloth_pixel(c,p,sheet=="idle")
   elif c.h>.025 and c.h<.09 and c.v>.68 and c.s<.72:c=HoldCharacterArt.recolor(c,Color(HoldAppearance.SKIN_COLORS[p.skin]),Color("f3d6bc"))
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img);textures[key]=tex;return tex
static func action_frame(phase:float)->int:
 if phase<.15:return 0
 if phase<.32:return 1
 if phase<.50:return 2
 if phase<.76:return 3
 return 0
static func descriptor(p:Dictionary,d:Vector2,walking:bool,time:float,action:String,phase:float)->Dictionary:
 var view=HoldDirectional.view(d);var f=posmod(int(time*8),4) if walking else 1
 var sheet=("female" if p.gender else "male")+"-walk";var index=view*4+f;var necks=WALK_NECKS[p.gender];var row=view
 if action!="":
  view=1
  if action in ["shovel","saw","carry"]:
   sheet=("female" if p.gender else "male")+"-utility";necks=UTILITY_NECKS[p.gender];row=["shovel","saw","carry"].find(action)
   f=(posmod(int(phase*4),4) if action=="saw" else (f if action=="carry" else action_frame(phase)))
  else:
   sheet=("female" if p.gender else "male")+"-actions";necks=NECKS[p.gender];row=["drink","pick","hammer","axe"].find(action)
   f=clampi(int(phase),0,3) if action=="drink" else action_frame(phase)
  index=row*4+f
 if action=="drink":
  sheet="drinks";index=p.gender*4+f;row=p.gender;view=0
  necks=[Vector2(235,220),Vector2(620,220),Vector2(985,220),Vector2(1360,220),Vector2(235,595),Vector2(620,595),Vector2(985,595),Vector2(1360,595)]
 if action in ["pick","hammer"] and absf(d.y)>absf(d.x)*1.35:
  sheet=("female" if p.gender else "male")+"-mining";necks=MINING_NECKS[p.gender]
  row=(0 if d.y>=0 else 1)+(2 if action=="hammer" else 0);index=row*4+f;view=0 if d.y>=0 else 3
 if action in ["lift_stone","lift_log","carry_stone","carry_log"]:
  sheet=("female" if p.gender else "male")+"-handling";necks=HANDLING_NECKS[p.gender]
  row=(2 if action.ends_with("log") else 0)+(1 if action.begins_with("carry") else 0)
  f=clampi(int(phase*4),0,3) if action.begins_with("lift") else (posmod(int(time*8),4) if walking else 1)
  index=row*4+f;view=1
 if action.begins_with("double_") or action=="push":
  sheet="strong-shoulders";necks=STRONG_NECKS;row=["double_stone","double_log","double_mixed","push"].find(action)
  f=posmod(int(time*8),4) if walking else 1
  if action=="push":f=[0,1,2,1][f]
  index=row*4+f;view=1 if action=="push" else 0
 if action in ["hoe","water","fish","harvest"]:
  sheet=("female" if p.gender else "male")+"-garden";necks=GARDEN_NECKS[p.gender];row=["hoe","water","fish","harvest"].find(action)
  f=clampi(int(phase),0,3) if action=="fish" else action_frame(phase);index=row*4+f;view=1
 if action=="push":
  sheet="pushing";necks=PUSH_NECKS;row=p.gender;f=posmod(int(time*8),4) if walking else 1;index=row*4+f;view=1
 var reference=row*4+(3 if action.begins_with("lift") or action=="harvest" else 0)
 if action=="" and not walking:
  sheet="idle";index=p.gender*4+view;necks=IDLE_NECKS;reference=index
 var r=bounds(sheet,index);var rest=bounds(sheet,reference)
 var baseline=rest.end.y-2.0
 var rest_neck:Vector2=necks[reference];var neck:Vector2=necks[index]
 var sy=52.0/(baseline-rest_neck.y)
 var sx=sy
 if sheet.ends_with("walk"):sx*=1.15
 if sheet=="idle":sx*=1.20
 return {"sheet":sheet,"index":index,"rect":r,"neck":neck,"root":Vector2(neck.x,baseline),"scale":Vector2(sx,sy),"view":view,"frame":f,"head_y":(neck.y-baseline)*sy+52}
static func paint(n:Node2D,at:Vector2,profile:Dictionary,d:Vector2,walking:bool,time:float,zoom:float,reset:Vector2,action:String="",phase:float=0.0):
 var p=HoldAppearance.normalized(profile)
 if HoldDrawnLocomotion.paint(n,at,p,d,walking,time,zoom,reset,action):return
 var a=descriptor(p,d,walking,time,action,phase);var flip=-1 if d.x<-.3 else 1
 n.draw_set_transform(at,0,Vector2(flip,1)*zoom)
 var r:Rect2i=a.rect;var scale:Vector2=a.scale;var root:Vector2=a.root
 var rect=Rect2((Vector2(r.position)-root)*scale,Vector2(r.size)*scale)
 n.draw_texture_rect(frame_texture(p,a.sheet,a.index),rect,false)
 var h=head(p,a.view);var w=79.0*h.get_width()/h.get_height()
 var head_rect=Rect2(Vector2(-w/2,-79+a.head_y),Vector2(w,79))
 n.draw_texture_rect(h,head_rect,false)
 # The mug and bent forearm are drawn in front of the beard at sip contact.
 if action!="" and not a.sheet.ends_with("handling") and a.sheet!="strong-shoulders":
  var fg=foreground(p,a)
  n.draw_texture_rect(fg,rect,false)
 n.draw_set_transform(reset)
const PALMS=[
 [Vector2(305,135),Vector2(634,135),Vector2(1013,135),Vector2(1403,133),Vector2(300,376),Vector2(665,361),Vector2(1016,379),Vector2(1418,374),Vector2(314,622),Vector2(668,612),Vector2(1031,625),Vector2(1417,620),Vector2(307,862),Vector2(663,854),Vector2(1031,873),Vector2(1417,862)],
 [Vector2(288,148),Vector2(589,133),Vector2(979,132),Vector2(1335,138),Vector2(289,366),Vector2(601,353),Vector2(962,367),Vector2(1343,350),Vector2(298,603),Vector2(610,600),Vector2(973,602),Vector2(1346,602),Vector2(306,837),Vector2(615,831),Vector2(973,841),Vector2(1350,838)]]
static func grip(profile:Dictionary,d:Vector2,time:float,walking:bool,zoom:float=1)->Vector2:
 var p=HoldAppearance.normalized(profile)
 if walking:return HoldDrawnLocomotion.grip(p,d,time)*Vector2(-1 if d.x<-.3 else 1,1)*zoom
 var a=descriptor(p,d,false,time,"",0)
 var palm:Vector2=a.neck+Vector2(130,240)
 return (palm-a.root)*a.scale*Vector2(-1 if d.x<-.3 else 1,1)*zoom
static func grip_foreground(n:Node2D,at:Vector2,profile:Dictionary,d:Vector2,time:float,zoom:float,reset:Vector2,walking:bool=true):
 var p=HoldAppearance.normalized(profile)
 if walking:HoldDrawnLocomotion.grip_front(n,at,p,d,time,zoom,reset);return
 var a=descriptor(p,d,false,time,"",0);var palm:Vector2=a.neck+Vector2(130,240)
 var source=Rect2(palm-Vector2(a.rect.position)-Vector2(14,15),Vector2(28,30))
 var destination=Rect2((palm-Vector2(14,15)-a.root)*a.scale,Vector2(28,30)*a.scale)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(frame_texture(p,a.sheet,a.index),destination,source)
 n.draw_set_transform(reset)

static func foreground(p:Dictionary,a:Dictionary)->Texture2D:
 var key="foreground/"+str(p.cloth_color)+"/"+str(p.skin)+"/"+str(a.index)+"/"+a.sheet
 if textures.has(key):return textures[key]
 var img=frame_texture(p,a.sheet,a.index).get_image().duplicate();var r:Rect2i=a.rect;var neck:Vector2=a.neck
 for y in img.get_height():
  for x in img.get_width():
   var q=Vector2(x,y)+Vector2(r.position);var c=img.get_pixel(x,y)
   var region=q.y<neck.y-4
   if a.sheet=="drinks":region=q.x>neck.x-90 and q.x<neck.x+95 and q.y<neck.y+85 and c.h>.02 and c.h<.16 and c.s>.3
   if not region:img.set_pixel(x,y,Color.TRANSPARENT)
 var tex=ImageTexture.create_from_image(img);textures[key]=tex;return tex

static func work_foreground(n:Node2D,at:Vector2,profile:Dictionary,d:Vector2,zoom:float,reset:Vector2,action:String,phase:float):
 var p=HoldAppearance.normalized(profile);var a=descriptor(p,d,false,0,action,phase)
 var key="work-front/"+a.sheet+str(a.index)+str(p.cloth_color)+str(p.skin)
 if not textures.has(key):
  var img=frame_texture(p,a.sheet,a.index).get_image().duplicate();var r:Rect2i=a.rect
  for y in img.get_height():
   for x in img.get_width():
    var q=Vector2(x,y)+Vector2(r.position)
    if not (q.x>a.neck.x+85 or (q.x>a.neck.x+30 and q.y<a.root.y-55)):img.set_pixel(x,y,Color.TRANSPARENT)
  textures[key]=ImageTexture.create_from_image(img)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect(textures[key],Rect2((Vector2(a.rect.position)-a.root)*a.scale,Vector2(a.rect.size)*a.scale),false)
 n.draw_set_transform(reset)
