class_name HoldCharacterArt
extends RefCounted
# Complete original animation drawings. Anatomy is never assembled from limbs.
const BODY=preload("res://assets/character-parts/body.png")
const PARTS=[Rect2(109,36,328,394),Rect2(592,40,323,392),Rect2(1006,30,474,463),Rect2(137,480,222,514),Rect2(620,510,322,470),Rect2(1047,566,383,366)]
static func part(n:Node2D,index:int,rect:Rect2,texture:Texture2D,tint:Color=Color.WHITE):n.draw_texture_rect_region(texture,rect,PARTS[index],tint)
const RIG=preload("res://assets/actors-v10/rig.png")
const MALE=preload("res://assets/actors-v11/male.png")
const BRAIDED=preload("res://assets/actors-v17/braided-normal.png")
const FEMALE=preload("res://assets/actors-v11/female.png")
const MALE_BASE=preload("res://assets/actors-v11/male-base.png")
const FEMALE_BASE=preload("res://assets/actors-v11/female-base.png")
const BEARDS=preload("res://assets/actors-v13/beards.png")
const HAIR=preload("res://assets/actors-v11/hair.png")
const INK=Color("202332")
const SCALE=.34
const ROOT_X=[
 [243,188,137,112,239,190,149,130,228,183,170,138,226,200,176,118],
 [238,195,150,125,238,198,152,135,228,186,171,146,225,202,170,121],
 [243,188,168,140,240,190,181,162,228,182,200,169,226,202,207,150],
 [238,194,152,126,239,198,153,136,226,186,172,146,224,201,170,120]]
const ROOT_Y=[242,242,242,242,240,240,240,240,258,256,258,258,242,242,242,242]
const EYES=[
 [Vector2(264,58),Vector2(215,59),Vector2(171,70),Vector2(152,59),Vector2(275,56),Vector2(222,70),Vector2(174,64),Vector2(152,54),Vector2(261,89),Vector2(208,79),Vector2(209,93),Vector2(168,102),Vector2(276,83),Vector2(260,100),Vector2(182,80),Vector2(152,77)],
 [Vector2(272,64),Vector2(227,65),Vector2(192,65),Vector2(165,65),Vector2(265,58),Vector2(233,62),Vector2(188,64),Vector2(165,63),Vector2(256,95),Vector2(208,93),Vector2(210,100),Vector2(182,108),Vector2(269,87),Vector2(260,99),Vector2(194,86),Vector2(162,86)],
 [Vector2(265,59),Vector2(215,59),Vector2(204,66),Vector2(177,59),Vector2(275,56),Vector2(224,63),Vector2(208,64),Vector2(185,55),Vector2(261,85),Vector2(210,79),Vector2(229,88),Vector2(201,98),Vector2(271,80),Vector2(257,92),Vector2(216,80),Vector2(185,80)],
 [Vector2(268,58),Vector2(228,61),Vector2(196,63),Vector2(167,63),Vector2(260,56),Vector2(230,60),Vector2(189,60),Vector2(164,61),Vector2(251,90),Vector2(208,88),Vector2(209,95),Vector2(183,108),Vector2(264,81),Vector2(253,93),Vector2(191,80),Vector2(163,83)]]
const HANDS=[Vector2(21,-31),Vector2(23,-42),Vector2(-7,-49),Vector2(-6,-74),Vector2(32,-36),Vector2(33,-22),Vector2(19,-32),Vector2(28,-29)]
const FEMALE_HANDS=[Vector2(15,-28),Vector2(23,-44),Vector2(-7,-49),Vector2(-5,-73),Vector2(32,-35),Vector2(33,-22),Vector2(15,-30),Vector2(32,-33)]
const TOOL_ENDS=[Vector2(51,-42),Vector2(36,-66),Vector2(-22,-71),Vector2(-31,-85),Vector2(67,-53),Vector2(59,-17),Vector2(43,-47),Vector2(51,-45)]
static var design_sources:Dictionary={}
static var sources:Array[Image]=[]
static var frames:Dictionary={}
static var layers:Dictionary={}
static var grips:Dictionary={}
# Foreground palm landmarks in each complete walking drawing, before root offset.
const CARRY_PALMS=[
 [Vector2(216,178),Vector2(146,171),Vector2(155,174),Vector2(118,167),Vector2(271,153),Vector2(224,158),Vector2(191,154),Vector2(104,172)],
 [Vector2(216,170),Vector2(157,166),Vector2(176,170),Vector2(131,167),Vector2(262,152),Vector2(237,152),Vector2(201,155),Vector2(122,164)],
 [Vector2(216,178),Vector2(146,171),Vector2(188,174),Vector2(142,168),Vector2(271,153),Vector2(224,158),Vector2(222,154),Vector2(136,172)],
 [Vector2(214,169),Vector2(157,165),Vector2(176,170),Vector2(135,167),Vector2(262,151),Vector2(238,152),Vector2(202,155),Vector2(122,164)]]
static func carry_hand(frame:int,p:Dictionary)->Vector2:
 var kind=base_kind(p);var f=clampi(frame,0,7)
 return carry_palm(p,f)*SCALE-root_for(kind,f,p)*SCALE
static func work_hand(f:int,p:Dictionary={})->Vector2:
 return FEMALE_HANDS[clampi(f,0,7)] if p.get("gender",0)==1 else HANDS[clampi(f,0,7)]
static func work_end(f:int,p:Dictionary={},kind:int=0)->Vector2:
 f=clampi(f,0,7)
 return work_hand(f,p)+(TOOL_ENDS[f]-HANDS[f]).normalized()*[36.0,40.0,35.0,33.0][clampi(kind,0,3)]
static func base_kind(p:Dictionary)->int:
 return int(p.gender)
static func root_for(kind:int,f:int,p:Dictionary={})->Vector2:
 var y=ROOT_Y[f]+(2 if kind%2==1 and f<8 else 0)
 if kind==1 and p.get("sculpt",0)==1 and f>=8:y=234 if f<12 else 232
 if kind==1 and p.get("sculpt",0)==2 and f>=8:y=247 if f<12 else 212
 return Vector2(ROOT_X[kind][f],y)
static func carry_palm(p:Dictionary,f:int)->Vector2:
 if p.gender==1 and p.get("sculpt",0)==1:return [Vector2(195,167),Vector2(154,165),Vector2(178,169),Vector2(130,166),Vector2(257,151),Vector2(235,150),Vector2(203,151),Vector2(125,166)][f]
 return CARRY_PALMS[int(p.gender)][f]
static func eye_for(p:Dictionary,f:int)->Vector2:
 var kind=int(p.gender)
 if kind==1 and p.get("sculpt",0)==1 and f>=8:return [Vector2(265,66),Vector2(222,64),Vector2(218,73),Vector2(185,80),Vector2(269,72),Vector2(260,86),Vector2(194,73),Vector2(162,73)][f-8]
 if kind==1 and p.get("sculpt",0)==2 and f>=8:return [Vector2(265,78),Vector2(219,77),Vector2(219,85),Vector2(186,93),Vector2(270,54),Vector2(260,68),Vector2(194,55),Vector2(162,55)][f-8]
 return EYES[kind][f]
static func recolor(c:Color,target:Color,source:Color)->Color:
 var result=Color.from_hsv(fposmod(c.h+target.h-source.h,1),clampf(c.s*target.s/maxf(.1,source.s),0,1),clampf(c.v*target.v/maxf(.1,source.v),0,1),c.a)
 return result
static func recolor_hair(c:Color,target:Color)->Color:
 # Neutral shading avoids retaining the source gold hue in grey or dark palettes.
 var shade=clampf(c.v/.82,0.0,1.22)
 var value=clampf(target.v*shade,0.0,1.0)
 return Color.from_hsv(target.h,target.s,value,c.a)
static func frame_texture(kind:int,f:int,p:Dictionary)->Texture2D:
 var key="%d/%d/%d/%d/%d/%d/%d/%d/%d" % [kind,f,p.cloth_color,p.hair_color,p.beard_color if not p.gender else 0,p.skin,p.outfit,p.tattoo,p.jewelry]
 key+="/revision"+str(HoldCharacterDesigns.REVISION)
 key+="/sculpt"+str(p.get("sculpt",0))
 key+="/cast"+str(p.get("cast_id",""))
 key+="/armor"+str(p.get("armor",0))
 if frames.has(key):return frames[key]
 var image=load("res://assets/actors-v36/"+HoldCharacterDesigns.id(p)+"-normal-"+str(f)+".png").get_image()
 var eye=eye_for(p,f)*SCALE*2
 var wrist=(carry_palm(p,f)*SCALE if f<8 else work_hand(f-8,p)+root_for(kind,f,p)*SCALE)*2
 var elbow=HoldAppearanceRig.ELBOWS[kind][f]*SCALE*2
 colorize(image,p,eye,kind,elbow,wrist,HoldCharacterDesigns.id(p)+"-normal-"+str(f))
 var result=ImageTexture.create_from_image(image)
 if frames.size()>1200:frames.clear()
 frames[key]=result;return result
static func colorize(image:Image,p:Dictionary,eye:Vector2,kind:int,elbow:Vector2=Vector2(-100,-100),wrist:Vector2=Vector2(-100,-100),mask_id:String=""):
 var skin_points:Array[Vector2i]=[]
 var materials=HoldCharacterMaterials.mask_for(mask_id,image.get_width(),image.get_height())
 for y in image.get_height():
  for x in image.get_width():
   var c=image.get_pixel(x,y)
   if c.a<.015:image.set_pixel(x,y,Color.TRANSPARENT);continue
   var material=materials[y*image.get_width()+x]
   if material==4:
    if p.get("armor",0)>0:
     var base_color=Color("98a8b4") if p.armor==1 else Color("657f91")
     c=recolor(c,base_color,Color("407e83"))
     # Metal segments follow the painted garment mask, preserving anatomy and hands.
     if y%7==0:c=c.darkened(.4)
     elif y%7==1:c=c.lightened(.18)
     if p.armor==2:
      # An angular forked rune engraved into the shoulder plate. The source
      # garment mask clips it away from skin, beard and equipment occluders.
      var plate_center=elbow.lerp(eye+Vector2(-12,12),.6)
      var rune=Vector2i(roundi(x-plate_center.x),roundi(y-plate_center.y))
      var ink=rune in [Vector2i(0,-4),Vector2i(0,-3),Vector2i(0,-2),Vector2i(0,-1),Vector2i(0,0),Vector2i(0,1),Vector2i(0,2),Vector2i(0,3),Vector2i(-1,-3),Vector2i(-2,-4),Vector2i(1,-1),Vector2i(2,-2)]
      if ink:c=Color("9ce3cf")
      elif rune+Vector2i(1,0) in [Vector2i(0,-3),Vector2i(0,-2),Vector2i(0,-1),Vector2i(0,0),Vector2i(0,1),Vector2i(0,2)]:c=c.darkened(.5)
    elif p.cloth_color!=0:c=recolor(c,HoldAppearance.cloth(p),Color("407e83"))
   elif material==1:
    c=recolor_hair(c,HoldAppearance.hair(p))
   elif material==3:
    if p.skin!=0:c=recolor(c,HoldAppearance.skin(p),Color(HoldAppearance.SKIN_COLORS[0]))
    if y>eye.y+20:skin_points.append(Vector2i(x,y))
   if p.jewelry==1 and material==5:c=Color(c.v*.87,c.v*.95,c.v,c.a)
   image.set_pixel(x,y,c)
 if p.tattoo>0 and not skin_points.is_empty():
  var q=skin_points[skin_points.size()/2]
  for d in [Vector2i.ZERO,Vector2i(0,1),Vector2i(1,0)]:
   var v=q+d
   if v.x<image.get_width() and v.y<image.get_height():image.set_pixelv(v,Color("427c89"))
static func overlay(index:int,color:Color)->Texture2D:
 var key=str(index)+color.to_html()
 if layers.has(key):return layers[key]
 if sources.is_empty():return null
 var row=index/6;var col=index%6
 var image=sources[4].get_region(Rect2i(int(col*295.667),row*296,295,295 if row<2 else 295))
 image.resize(59,59,Image.INTERPOLATE_NEAREST)
 for y in image.get_height():
  for x in image.get_width():
   var c=image.get_pixel(x,y)
   if c.a<.45:image.set_pixel(x,y,Color.TRANSPARENT)
   elif color!=Color("bd8a4c"):image.set_pixel(x,y,recolor(c,color,Color("bd8a4c")))
 var texture=ImageTexture.create_from_image(image);layers[key]=texture;return texture
static func beard_texture(index:int,color:Color)->Texture2D:
 var key="beard16/"+str(index)+color.to_html()
 if layers.has(key):return layers[key]
 var img=BEARDS.get_image().get_region(HoldAppearanceRig.BEARD_REGIONS[index])
 img.resize(int(round(img.get_width()*.2)),int(round(img.get_height()*.2)),Image.INTERPOLATE_NEAREST)
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.45:img.set_pixel(x,y,Color.TRANSPARENT)
   elif c.s>.2:img.set_pixel(x,y,recolor(c,color,Color("bd8a4c")))
 var tex=ImageTexture.create_from_image(img);layers[key]=tex;return tex
static func draw_sprite(n:Node2D,pos:Vector2,t:float,walking:bool,facing:int,p:Dictionary,working:bool=false,reset:Vector2=Vector2.ZERO,show_tool:bool=true,zoom:float=1.0,tint:Color=Color.WHITE):
 if (walking and not working and not p.get("shield_guard",false)) or (p.get("air_pose",0)>0 and not working):
  HoldPaintedWalk.draw(n,pos,t,facing,p,reset,zoom,tint,p.get("shield_pose",false));return
 var f=posmod(int(t*12),8)
 if p.get("shield_pose",false):
  var mode="guard" if p.get("shield_guard",false) else ("walk" if walking and not working else "combat")
  HoldShieldActor.draw(n,pos,f if working or walking else 0,facing,p,reset,mode,zoom,tint);return
 var frame=f+8 if working else (f if walking else 0)
 var kind=base_kind(p)
 var root=root_for(kind,frame,p)*SCALE
 var breathe=1.0
 var base=pos
 n.draw_set_transform(pos,0,Vector2.ONE*zoom);n.draw_rect(Rect2(-23,-1,46,3),Color(.02,.025,.045,.25))
 n.draw_set_transform(base,0,Vector2(facing,breathe)*zoom)
 var texture=frame_texture(kind,frame,p)
 n.draw_texture_rect(texture,Rect2(-root,Vector2(texture.get_size())*.5),false,tint)
 HoldEquipmentRig.draw(n,p,frame)
 if kind>=2:
  var eye=(EYES[kind][frame]*SCALE-root)
  var head_angle=HoldAppearanceRig.tilt(kind,frame)
  var lag=HoldAppearanceRig.WORK_LAG[f] if working else (HoldAppearanceRig.WALK_LAG[f] if walking else 0.0)
  if p.gender or p.hair_style!=5:
   var hair_index=int(p.hair_style)+(6 if p.gender else 0)
   var hair_texture=overlay(hair_index,HoldAppearance.hair(p))
   # Ear landmarks place each hairstyle on the existing, fully drawn head.
   var ears=[Vector2(135,195),Vector2(112,204),Vector2(120,194),Vector2(120,214),Vector2(118,204),Vector2(135,195),Vector2(120,145),Vector2(125,148),Vector2(126,152),Vector2(134,160),Vector2(125,152),Vector2(117,157)]
   var scale=([.13,.13,.13,.14,.14,.13][p.hair_style]) if not p.gender else .13
   var hair_pos=eye+Vector2(-11,-1)-ears[hair_index]*scale
   if p.gender:hair_pos.x+=3
   HoldAppearanceRig.draw_flexible(n,hair_texture,eye,eye-hair_pos,Vector2.ONE*295*scale,head_angle,lag*.4)
  if not p.gender and p.beard_style!=5:
   var bs=int(p.beard_style);var index=bs if bs<5 else bs-1
   var tex=beard_texture(index,HoldAppearance.beard(p))
   var scale=.080
   var mouth=HoldAppearanceRig.mouth(frame)*SCALE-root-Vector2(0,1.5)
   HoldAppearanceRig.draw_flexible(n,tex,mouth,HoldAppearanceRig.BEARD_ROOTS[index]*scale,Vector2(HoldAppearanceRig.BEARD_REGIONS[index].size)*scale,head_angle,lag,8.0)
  # Foreground forearm and fingers occlude facial hair during both walk and work.
  var foreground=HoldAppearanceRig.foreground(texture,kind,frame,p)
  n.draw_texture_rect(foreground,Rect2(-root,Vector2(texture.get_size())*.5),false)
 n.draw_set_transform(reset)
 if working and show_tool:
  draw_tool(n,pos+work_hand(f,p)*Vector2(facing,1)*zoom,pos+work_end(f,p,3 if p.outfit==2 else 0)*Vector2(facing,1)*zoom,3 if p.outfit==2 else 0,reset,facing,-1,zoom)
  draw_grip(n,pos,f,p,facing,reset,tint,false,zoom)
# Source-space landmarks: grip center and the actual cutting/striking surface.
const TOOL_GRIPS=[Vector2(65,185),Vector2(90,389),Vector2(55,315),Vector2(120,315)]
const TOOL_CONTACTS=[Vector2(293,200),Vector2(90,9),Vector2(220,90),Vector2(230,70)]
static func action_frame(progress:float,kind:int)->int:
 var f=clampi(int(progress*8),0,7)
 return [0,0,1,1,4,5,6,7][f] if kind==1 else f
static func tool_grip(kind:int,reach:float=-1)->Vector2:
 kind=clampi(kind,0,3)
 # Fixed source-space grip. A nearby target must never move the handle out of the fist.
 return TOOL_GRIPS[kind]
static func tool_transform(origin:Vector2,end:Vector2,kind:int,facing:int=1,zoom:float=1.0)->Transform2D:
 kind=clampi(kind,0,3)
 var local=(TOOL_CONTACTS[kind]-TOOL_GRIPS[kind])*Vector2(facing,1)
 var delta=end-origin
 return Transform2D(delta.angle()-local.angle(),Vector2(facing,1)*zoom*[36.0,40.0,35.0,33.0][kind]/local.length(),0,origin)
static func draw_tool(n:Node2D,origin:Vector2,end:Vector2,kind:int,reset:Vector2=Vector2.ZERO,facing:int=1,reach:float=-1,zoom:float=1.0):
 kind=clampi(kind,0,3)
 var grip=tool_grip(kind,reach)
 n.draw_set_transform_matrix(tool_transform(origin,end,kind,facing,zoom))
 if kind==0:n.draw_texture_rect_region(RIG,Rect2(-grip,Vector2(310,239)),Rect2(667,973,310,239))
 else:n.draw_texture_rect_region(HoldItemArt.SHEET,Rect2(-grip,HoldItemArt.REGIONS[kind].size),HoldItemArt.REGIONS[kind])
 n.draw_set_transform(reset)
static func draw_grip(n:Node2D,pos:Vector2,frame:int,p:Dictionary,facing:int,reset:Vector2=Vector2.ZERO,tint:Color=Color.WHITE,carrying:bool=false,zoom:float=1.0):
 # Repaint the original foreground fingers over the handle. This is a tiny
 # region of the complete character drawing, not a floating replacement hand.
 var kind=base_kind(p);var f=clampi(frame,0,7)+(0 if carrying else 8)
 var texture=frame_texture(kind,f,p);var root=root_for(kind,f,p)*SCALE
 var hand=carry_hand(frame,p) if carrying else work_hand(frame,p)
 var key=str(texture.get_instance_id())+":"+str(f)
 if not grips.has(key):
  var original=texture.get_image();var materials=HoldCharacterMaterials.mask_for(HoldCharacterDesigns.id(p)+"-normal-"+str(f),original.get_width(),original.get_height());var fingers=Image.create(24,24,false,Image.FORMAT_RGBA8)
  for y in 24:
   for x in 24:
    var source=Vector2i(((root+hand-Vector2(6,6))*2).round())+Vector2i(x,y)
    if source.x<0 or source.y<0 or source.x>=original.get_width() or source.y>=original.get_height():continue
    var pixel=original.get_pixelv(source)
    # Repaint the complete visible fist, not a small disc of palm. The shaft
    # passes behind the fingers and emerges from the opposite side of the grip.
    if pixel.a>.015 and materials[source.y*original.get_width()+source.x]==3:
     fingers.set_pixel(x,y,pixel)
  if grips.size()>1200:grips.clear()
  grips[key]=ImageTexture.create_from_image(fingers)
 n.draw_set_transform(pos,0,Vector2(facing,1)*zoom)
 n.draw_texture_rect(grips[key],Rect2(hand-Vector2(6,6),Vector2(12,12)),false,tint)
 n.draw_set_transform(reset)
