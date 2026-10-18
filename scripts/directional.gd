class_name HoldDirectional
extends RefCounted
# Original view drawings plus grounded procedural gait; retain original side/contact frames.
const MALE=preload("res://assets/directional-v47/male.png")
const FEMALE=preload("res://assets/directional-v47/female.png")
static var cache={}
static func view(d:Vector2)->int:
 if absf(d.y)<.3:return -1
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
static func draw(n:Node2D,p:Vector2,profile:Dictionary,direction:Vector2,walking:bool,time:float,scale:float=1.0,reset:Vector2=Vector2.ZERO):
 var row=view(direction)
 if row<0:
  HoldCharacterArt.draw_sprite(n,p,time,walking,1 if direction.x>=0 else -1,profile,false,reset,false,scale,Color("eff0dc"));return
 var tex=texture(profile,row);var size=Vector2(tex.get_size());var h=79.0*scale;var w=h*size.x/size.y
 var phase=time*TAU*2.6;var step=sin(phase) if walking else 0.0
 var bob=absf(step)*1.25*scale if walking else sin(time*2)*.3*scale
 var flip=-1 if direction.x<-.3 else 1
 n.draw_set_transform(p,0,Vector2(flip,1))
 var split=size.y*.79;var upper=h*.79
 # Lower boot sections alternate lift and length, overlapped under the tunic to avoid seams.
 for side in 2:
  var lift=maxf(0,step*(1 if side==0 else -1))*2.8*scale
  var width=w/2
  n.draw_texture_rect_region(tex,Rect2(Vector2(-w/2+side*width,-h+upper-1-lift),Vector2(width,h-upper+1+lift*.3)),Rect2(Vector2(side*size.x/2,split-2),Vector2(size.x/2,size.y-split+2)))
 n.draw_texture_rect_region(tex,Rect2(Vector2(-w/2+step*.45*scale,-h-bob),Vector2(w,upper+1)),Rect2(Vector2.ZERO,Vector2(size.x,split+1)))
 n.draw_set_transform(reset)
