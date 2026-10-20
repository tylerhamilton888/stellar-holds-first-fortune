class_name HoldAppearanceRig
extends RefCounted
# Source-space landmarks belong to complete drawings, not interchangeable limbs.
# Each rendered appearance is baked by SpriteAtlas into pose-specific frames.
const MOUTHS=[Vector2(282,85),Vector2(232,85),Vector2(220,94),Vector2(193,84),Vector2(288,82),Vector2(240,91),Vector2(225,92),Vector2(201,80),Vector2(279,109),Vector2(229,101),Vector2(248,116),Vector2(222,123),Vector2(288,105),Vector2(270,119),Vector2(233,105),Vector2(203,104)]
# Actual alpha bounds; the source artwork is not a uniform 3x3 atlas.
const BEARD_REGIONS=[Rect2i(71,23,321,330),Rect2i(499,23,287,335),Rect2i(885,23,298,324),Rect2i(64,411,320,279),Rect2i(477,396,309,363),Rect2i(897,376,308,437),Rect2i(71,785,336,445),Rect2i(471,772,380,457),Rect2i(911,807,303,413)]
# Top of the moustache beneath the nose, measured inside each actual crop.
const BEARD_ROOTS=[Vector2(229,52),Vector2(211,44),Vector2(249,59),Vector2(236,50),Vector2(239,67),Vector2(239,57),Vector2(224,43),Vector2(247,48),Vector2(221,40)]
# Per-pose angular lag: tips trail the head, while the moustache stays on its root.
const WALK_LAG=[0.0,-.045,-.025,.035,.055,.025,-.025,-.035]
const WORK_LAG=[-.025,-.06,-.10,-.08,.12,.16,.06,0.0]
# Foreground elbow positions in source cells. Wrist positions come from the grip rig.
const ELBOWS=[
 [Vector2(207,154),Vector2(142,148),Vector2(133,160),Vector2(98,151),Vector2(242,145),Vector2(199,150),Vector2(165,145),Vector2(102,150),Vector2(239,166),Vector2(185,151),Vector2(134,125),Vector2(145,58),Vector2(270,135),Vector2(242,165),Vector2(208,150),Vector2(159,157)],
 [Vector2(210,146),Vector2(156,142),Vector2(151,151),Vector2(113,150),Vector2(232,142),Vector2(209,142),Vector2(174,143),Vector2(120,142),Vector2(236,162),Vector2(191,151),Vector2(139,131),Vector2(120,66),Vector2(265,137),Vector2(244,159),Vector2(181,148),Vector2(153,156)],
 [Vector2(207,154),Vector2(142,148),Vector2(166,160),Vector2(122,151),Vector2(242,145),Vector2(199,150),Vector2(196,145),Vector2(134,150),Vector2(239,166),Vector2(185,151),Vector2(165,125),Vector2(175,58),Vector2(270,135),Vector2(242,165),Vector2(236,150),Vector2(191,157)],
 [Vector2(210,146),Vector2(156,142),Vector2(151,151),Vector2(113,150),Vector2(232,142),Vector2(209,142),Vector2(174,143),Vector2(120,142),Vector2(236,162),Vector2(191,151),Vector2(139,131),Vector2(120,66),Vector2(265,137),Vector2(244,159),Vector2(181,148),Vector2(153,156)]]
# Far fist: the shield is attached to this arm, independent of the axe hand.
const OFFHAND_WALK=[
 [Vector2(297,170),Vector2(257,159),Vector2(188,171),Vector2(174,170),Vector2(280,153),Vector2(236,157),Vector2(201,154),Vector2(187,166)],
 [Vector2(297,164),Vector2(268,153),Vector2(208,165),Vector2(191,168),Vector2(273,152),Vector2(249,155),Vector2(211,157),Vector2(195,164)],
 [Vector2(297,170),Vector2(257,159),Vector2(221,171),Vector2(204,170),Vector2(280,153),Vector2(236,157),Vector2(232,154),Vector2(219,166)],
 [Vector2(297,164),Vector2(268,153),Vector2(208,165),Vector2(191,168),Vector2(273,152),Vector2(249,155),Vector2(211,157),Vector2(195,164)]]
const OFFHAND_WORK=[Vector2(26,-34),Vector2(32,-43),Vector2(10,-39),Vector2(17,-70),Vector2(22,-34),Vector2(40,-22),Vector2(34,-33),Vector2(42,-34)]
static var occlusion:Dictionary={}
static func shield_hand(frame:int,p:Dictionary,working:bool)->Vector2:
 if working:return OFFHAND_WORK[frame]+(Vector2(-2,0) if p.gender else Vector2.ZERO)
 var kind=HoldCharacterArt.base_kind(p)
 return (OFFHAND_WALK[kind][frame]-HoldCharacterArt.root_for(kind,frame))*HoldCharacterArt.SCALE
static func mouth(frame:int)->Vector2:return MOUTHS[frame]
static func tilt(kind:int,frame:int)->float:
 if kind!=2:return [0.0,.015,.025,-.015,-.025,.02,.0,-.015,-.03,-.06,.06,.07,-.04,.10,-.02,.02][frame]
 return clampf((MOUTHS[frame]-HoldCharacterArt.EYES[kind][frame]).angle()-Vector2(17,26).angle(),-.16,.16)
static func draw_flexible(n:Node2D,tex:Texture2D,root:Vector2,anchor:Vector2,size:Vector2,angle:float,lag:float,locked_depth:float=0.0):
 # Six joined strips: upper attachment locked, lower length bends continuously.
 var rows=[0.0]
 for k in range(1,6):rows.append(k/6.0)
 if locked_depth>0:rows.append(clampf((anchor.y+locked_depth)/size.y,0,1))
 rows.append(1.0);rows.sort()
 for strip in range(rows.size()-1):
  var vertices=PackedVector2Array();var uv=PackedVector2Array()
  for point in [Vector2(0,rows[strip]),Vector2(1,rows[strip]),Vector2(1,rows[strip+1]),Vector2(0,rows[strip+1])]:
   var v=point*size-anchor
   var lower=maxf(0,v.y-locked_depth)/maxf(1,size.y-anchor.y-locked_depth)
   v=v.rotated(angle)+Vector2(sin(lag)*size.y*lower*lower,0)
   vertices.append(root+v);uv.append(point)
  n.draw_polygon(vertices,PackedColorArray([Color.WHITE]),uv,tex)
static func foreground(texture:Texture2D,kind:int,frame:int,p:Dictionary)->Texture2D:
 var key=str(texture.get_instance_id())+"/"+str(frame)
 if occlusion.has(key):return occlusion[key]
 var src=texture.get_image();var mask=Image.create(src.get_width(),src.get_height(),false,Image.FORMAT_RGBA8)
 var elbow=ELBOWS[kind][frame]*HoldCharacterArt.SCALE
 var wrist=(HoldCharacterArt.work_hand(frame-8,p)+HoldCharacterArt.root_for(kind,frame)*HoldCharacterArt.SCALE) if frame>=8 else HoldCharacterArt.CARRY_PALMS[kind][frame]*HoldCharacterArt.SCALE
 for y in src.get_height():
  for x in src.get_width():
   var point=Vector2(x,y);var near=Geometry2D.get_closest_point_to_segment(point,elbow,wrist)
   if point.distance_to(near)>5.0:continue
   var color=src.get_pixel(x,y)
   # Only existing skin pixels; never repaint a rectangle of chest over the beard.
   if color.a>.45 and color.h>.015 and color.h<.10 and color.s>.22:mask.set_pixel(x,y,color)
 var result=ImageTexture.create_from_image(mask)
 if occlusion.size()>1200:occlusion.clear()
 occlusion[key]=result;return result
