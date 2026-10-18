class_name HoldDirectional
extends RefCounted
# One directional rig for locomotion, work and carrying. No legacy side-view fallback.
const MALE=preload("res://assets/directional-v47/male.png")
const FEMALE=preload("res://assets/directional-v47/female.png")
# Alpha-component bounds measured on the original drawings, with a 1px margin.
# The source artists did not align every head/foot to an equal grid cell.
const BOUNDS=[
 [Rect2i(105,14,205,232),Rect2i(388,14,203,232),Rect2i(660,8,217,238),Rect2i(951,1,198,245),Rect2i(1233,19,202,227),
  Rect2i(104,267,202,230),Rect2i(388,267,202,232),Rect2i(670,259,209,238),Rect2i(960,254,199,245),Rect2i(1244,270,202,229),
  Rect2i(102,516,201,235),Rect2i(388,519,208,231),Rect2i(669,513,211,237),Rect2i(955,515,196,236),Rect2i(1240,525,209,225),
  Rect2i(94,767,216,239),Rect2i(382,770,213,237),Rect2i(661,763,219,244),Rect2i(943,758,211,248),Rect2i(1229,770,214,236)],
 [Rect2i(105,8,172,242),Rect2i(400,8,162,243),Rect2i(679,18,170,233),Rect2i(982,17,166,234),Rect2i(1269,17,163,233),
  Rect2i(109,263,159,235),Rect2i(400,258,160,241),Rect2i(680,268,170,231),Rect2i(985,268,164,232),Rect2i(1270,268,162,231),
  Rect2i(107,506,156,230),Rect2i(401,508,164,229),Rect2i(687,512,168,226),Rect2i(985,511,163,227),Rect2i(1280,512,161,225),
  Rect2i(100,746,175,237),Rect2i(389,744,175,240),Rect2i(679,746,171,238),Rect2i(974,750,176,234),Rect2i(1266,749,176,235)]
]
static var cache={}
static func view(d:Vector2)->int:
 if absf(d.y)<.3:return 1
 if absf(d.x)<.3:return 0 if d.y>0 else 3
 return 1 if d.y>0 else 2
static func texture(profile:Dictionary,row:int)->Texture2D:
 var p=HoldAppearance.normalized(profile)
 var k="%d/%d/%d/%d/%d/%d" % [p.gender,p.sculpt,p.hair_color,p.cloth_color,p.skin,row]
 if cache.has(k):return cache[k]
 var source=(FEMALE if p.gender else MALE).get_image()
 var img=source.get_region(BOUNDS[p.gender][row*5+p.sculpt])
 var hair=HoldAppearance.hair(p);var cloth=HoldAppearance.cloth(p);var skin=Color(HoldAppearance.SKIN_COLORS[p.skin])
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.05:continue
   # Teal pigment is cloth, gold in upper half is hair; never recolor leather/metal below belt.
   if c.h>.43 and c.h<.62 and c.s>.22:c=HoldCharacterArt.recolor(c,cloth,Color("407e83"))
   elif hair_region(p,row,Vector2(float(x)/img.get_width(),float(y)/img.get_height())) and ((c.h>.085 and c.h<.19 and c.s>.22) or (c.h>.015 and c.h<=.085 and c.s>.65 and c.v<.94 and (row>=2 or float(y)/img.get_height()<.23 or float(y)/img.get_height()>.40 or float(x)/img.get_width()<.27 or float(x)/img.get_width()>.80))):c=HoldCharacterArt.recolor_hair(c,hair)
   elif c.h>.025 and c.h<.09 and c.v>.68 and c.s<.65:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img);cache[k]=tex;return tex
static func hair_region(p:Dictionary,row:int,uv:Vector2)->bool:
 # Anatomical masks keep warm hair shadows out of skin, leather and brass.
 var x=uv.x;var y=uv.y;var sculpt=int(p.sculpt)
 if y<.30:return true
 if int(p.gender)==0:
  if row<2:
   var end=[.55,.76,.66,.70,.76][sculpt]
   var half=lerpf(.32,.12,clampf((y-.4)/.3,0,1))
   var center=.52 if row==0 else .57
   return y<end and absf(x-center)<half
  var end=[.38,.63,.50,.40,.65][sculpt]
  var half=.15 if sculpt in [1,4] and y>.4 else .37
  return y<end and absf(x-.5)<half
 if row==0:
  if sculpt==0:return y<.54 and x>.26 and x<.65
  if sculpt==1:return y<.50 and x>.28 and x<.65
  if sculpt==2:return y<.63 and (x<.32 or x>.71)
  if sculpt==3:return y<.74 and x>.23 and x<.43
  return y<.43 and (x<.3 or x>.72)
 if row==1:
  if sculpt==0:return y<.54 and x<.47
  if sculpt==1:return y<.50 and x<.48
  if sculpt==2:return y<.68 and x<.48
  if sculpt==3:return y<.74 and x>.38 and x<.62
  return y<.45 and x<.43
 if sculpt==2 and row==2 and y>.42 and y<.60 and x>.02 and x<.25:return true
 if sculpt==2:return y<.61 and x>(.06 if y<.46 else .16) and x<(.94 if y<.46 else .80)
 if sculpt==3:return y<.70 and x>(.25 if y<.43 else (.43 if row==2 else .58)) and x<.77
 return y<[.36,.38,.61,.64,.42][sculpt]
static func arm_angle(action:float)->float:
 if action<0:return 0.0
 # Anticipation, decisive contact, then a short recovery; contacts follow gameplay clocks.
 if action<.5:return lerpf(-1.65,-.65,action/.5)
 return lerpf(-.65,0.0,(action-.5)/.5)
static func hand(profile:Dictionary,direction:Vector2,action:float=-1,scale:float=1.0,arm_override:float=NAN)->Vector2:
 var tex=texture(profile,view(direction));var w=79.0*tex.get_width()/tex.get_height()
 var shoulder=Vector2(w*.25,-79*.58)
 var palm=Vector2(w*.14,79*.27).rotated(arm_angle(action) if is_nan(arm_override) else arm_override)
 return (shoulder+palm)*Vector2(-1 if direction.x<-.3 else 1,1)*scale
static func piece(n:Node2D,tex:Texture2D,points:Array,h:float,w:float):
 var vertices=PackedVector2Array();var uv=PackedVector2Array()
 for v in points:vertices.append(Vector2((v.x-.5)*w,(v.y-1)*h));uv.append(v)
 n.draw_polygon(vertices,PackedColorArray([Color.WHITE]),uv,tex)
static func draw(n:Node2D,p:Vector2,profile:Dictionary,direction:Vector2,walking:bool,time:float,scale:float=1.0,reset:Vector2=Vector2.ZERO,action:float=-1,arm_override:float=NAN):
 var tex=texture(profile,view(direction));var size=Vector2(tex.get_size());var h=79.0*scale;var w=h*size.x/size.y
 var phase=time*TAU*2.6;var step=sin(phase) if walking else 0.0
 var bob=absf(step)*1.1*scale if walking else 0.0
 var flip=-1 if direction.x<-.3 else 1
 var lean=sin(action*PI)*1.7*scale if action>=0 else 0.0
 var root=p+Vector2(flip*lean,-bob)
 n.draw_set_transform(root,0,Vector2(flip,1))
 # Feet remain planted on the contact beat, with opposite lift and short fore/aft travel.
 for side in 2:
  var beat=step*(1 if side==0 else -1);var lift=maxf(0,beat)*2.2*scale
  n.draw_texture_rect_region(tex,Rect2(Vector2(-w/2+side*w/2+beat*.6*scale,-h*.22-lift+bob),Vector2(w/2,h*.22)),Rect2(Vector2(side*size.x/2,size.y*.78),Vector2(size.x/2,size.y*.22)))
 # Shoulder/arm pieces overlap the tunic seam rather than stretching the whole body.
 for side in 2:
  var pivot=Vector2((.25 if side==0 else .75)*w-w/2,-h*.58)
  var angle=arm_angle(action)*(1 if side==1 else -.35) if action>=0 else step*.075*(1 if side==0 else -1)
  if not is_nan(arm_override):angle=arm_override if side==1 else 0.0
  var transform=Transform2D(0,Vector2(flip,1),0,root)*Transform2D(0,pivot)*Transform2D(angle,Vector2.ZERO)*Transform2D(0,-pivot)
  n.draw_set_transform_matrix(transform)
  var x0=0.0 if side==0 else .73;var x1=.27 if side==0 else 1.0
  piece(n,tex,[Vector2(x0,.30),Vector2(x1,.30),Vector2(x1,.79),Vector2(x0,.79)],h,w)
 n.draw_set_transform(root,0,Vector2(flip,1))
 piece(n,tex,[Vector2(0,0),Vector2(1,0),Vector2(1,.30),Vector2(.73,.30),Vector2(.73,.70),Vector2(1,.79),Vector2(0,.79),Vector2(.27,.70),Vector2(.27,.30),Vector2(0,.30)],h,w)
 # A lifted drinking forearm must pass in front of the beard/tunic, not vanish behind it.
 if not is_nan(arm_override) and arm_override>.1:
  var pivot=Vector2(w*.25,-h*.58)
  n.draw_set_transform_matrix(Transform2D(0,Vector2(flip,1),0,root)*Transform2D(0,pivot)*Transform2D(arm_override,Vector2.ZERO)*Transform2D(0,-pivot))
  piece(n,tex,[Vector2(.79,.48),Vector2(1,.48),Vector2(1,.79),Vector2(.79,.79)],h,w)
 n.draw_set_transform(reset)
