class_name HoldDirectional
extends RefCounted
# One directional rig for locomotion, work and carrying. No legacy side-view fallback.
const MALE=preload("res://assets/directional-v47/male.png")
const FEMALE=preload("res://assets/directional-v47/female.png")
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
 var size=Vector2i(source.get_width()/5,source.get_height()/4)
 var img=source.get_region(Rect2i(Vector2i(p.sculpt,row)*size,size))
 var low=size;var high=Vector2i.ZERO
 for y in img.get_height():
  for x in img.get_width():
   if img.get_pixel(x,y).a>.3:
    low=low.min(Vector2i(x,y));high=high.max(Vector2i(x,y))
 img=img.get_region(Rect2i(low,high-low+Vector2i.ONE))
 var hair=HoldAppearance.hair(p);var cloth=HoldAppearance.cloth(p);var skin=Color(HoldAppearance.SKIN_COLORS[p.skin])
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.05:continue
   # Teal pigment is cloth, gold in upper half is hair; never recolor leather/metal below belt.
   if c.h>.43 and c.h<.62 and c.s>.22:c=HoldCharacterArt.recolor(c,cloth,Color("407e83"))
   elif float(y)/img.get_height()<.65 and c.h>.09 and c.h<.18 and c.s>.3:c=HoldCharacterArt.recolor_hair(c,hair)
   elif c.h>.025 and c.h<.09 and c.v>.68 and c.s<.65:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img);cache[k]=tex;return tex
static func arm_angle(action:float)->float:
 if action<0:return 0.0
 # Anticipation, decisive contact, then a short recovery; contacts follow gameplay clocks.
 if action<.5:return lerpf(-1.65,-.65,action/.5)
 return lerpf(-.65,0.0,(action-.5)/.5)
static func hand(profile:Dictionary,direction:Vector2,action:float=-1,scale:float=1.0)->Vector2:
 var tex=texture(profile,view(direction));var w=79.0*tex.get_width()/tex.get_height()
 var shoulder=Vector2(w*.25,-79*.58)
 var palm=Vector2(w*.14,79*.27).rotated(arm_angle(action))
 return (shoulder+palm)*Vector2(-1 if direction.x<-.3 else 1,1)*scale
static func piece(n:Node2D,tex:Texture2D,points:Array,h:float,w:float):
 var vertices=PackedVector2Array();var uv=PackedVector2Array()
 for v in points:vertices.append(Vector2((v.x-.5)*w,(v.y-1)*h));uv.append(v)
 n.draw_polygon(vertices,PackedColorArray([Color.WHITE]),uv,tex)
static func draw(n:Node2D,p:Vector2,profile:Dictionary,direction:Vector2,walking:bool,time:float,scale:float=1.0,reset:Vector2=Vector2.ZERO,action:float=-1):
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
  var transform=Transform2D(0,Vector2(flip,1),0,root)*Transform2D(0,pivot)*Transform2D(angle,Vector2.ZERO)*Transform2D(0,-pivot)
  n.draw_set_transform_matrix(transform)
  var x0=0.0 if side==0 else .73;var x1=.27 if side==0 else 1.0
  piece(n,tex,[Vector2(x0,.30),Vector2(x1,.30),Vector2(x1,.79),Vector2(x0,.79)],h,w)
 n.draw_set_transform(root,0,Vector2(flip,1))
 piece(n,tex,[Vector2(0,0),Vector2(1,0),Vector2(1,.30),Vector2(.73,.30),Vector2(.73,.70),Vector2(1,.79),Vector2(0,.79),Vector2(.27,.70),Vector2(.27,.30),Vector2(0,.30)],h,w)
 n.draw_set_transform(reset)
