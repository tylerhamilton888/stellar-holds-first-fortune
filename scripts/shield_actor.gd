class_name HoldShieldActor
extends RefCounted
# Complete one-handed axe-and-shield drawings; the shield is part of the arm pose.
const SHEET=preload("res://assets/actors-v17/classic-combat.png")
const TOP=[0,276,516,776]
const HEIGHT=[276,240,260,248]
const FEET=[Vector2(202,263),Vector2(202,263),Vector2(202,263),Vector2(181,263),Vector2(202,229),Vector2(198,229),Vector2(195,229),Vector2(183,229),Vector2(200,244),Vector2(200,244),Vector2(200,244),Vector2(183,244),Vector2(200,223),Vector2(197,223),Vector2(195,223),Vector2(183,223)]
const EYES=[Vector2(246,81),Vector2(254,87),Vector2(216,90),Vector2(239,111),Vector2(257,64),Vector2(257,75),Vector2(209,65),Vector2(210,61),Vector2(237,69),Vector2(248,74),Vector2(215,75),Vector2(224,98),Vector2(253,64),Vector2(259,69),Vector2(211,64),Vector2(208,64)]
const PALMS=[Vector2(159,192),Vector2(120,168),Vector2(72,77),Vector2(199,66),Vector2(282,149),Vector2(264,166),Vector2(154,146),Vector2(125,162),Vector2(165,175),Vector2(123,154),Vector2(76,60),Vector2(193,52),Vector2(277,141),Vector2(275,154),Vector2(157,146),Vector2(128,158)]
const ELBOWS=[Vector2(156,158),Vector2(147,139),Vector2(91,108),Vector2(185,99),Vector2(243,136),Vector2(234,150),Vector2(131,128),Vector2(125,140),Vector2(161,151),Vector2(147,136),Vector2(96,88),Vector2(184,88),Vector2(239,127),Vector2(241,141),Vector2(137,125),Vector2(124,136)]
const WALK=preload("res://assets/actors-v17/classic-walk.png")
const GUARD=preload("res://assets/actors-v17/classic-guard.png")
# Explicit upper-lip roots, measured on each drawing (never inferred from eye).
const LIPS=[Vector2(258,97),Vector2(267,103),Vector2(228,107),Vector2(249,126),Vector2(267,80),Vector2(268,92),Vector2(221,81),Vector2(222,78)]
const WALK_FEET=[Vector2(213,425),Vector2(222,425),Vector2(206,425),Vector2(215,425),Vector2(217,406),Vector2(223,406),Vector2(218,406),Vector2(230,406)]
const WALK_EYES=[Vector2(280,120),Vector2(298,126),Vector2(250,119),Vector2(280,113),Vector2(282,104),Vector2(305,106),Vector2(272,100),Vector2(290,102)]
const WALK_LIPS=[Vector2(302,148),Vector2(323,154),Vector2(275,147),Vector2(305,140)]
const WALK_PALMS=[Vector2(144,293),Vector2(185,301),Vector2(146,294),Vector2(165,281),Vector2(157,273),Vector2(184,277),Vector2(152,276),Vector2(177,265)]
const WALK_ELBOWS=[Vector2(138,244),Vector2(166,245),Vector2(137,241),Vector2(147,229),Vector2(148,227),Vector2(169,225),Vector2(148,228),Vector2(159,221)]
const GUARD_FEET=[Vector2(210,413),Vector2(223,413),Vector2(207,413),Vector2(214,413),Vector2(215,389),Vector2(221,389),Vector2(212,389),Vector2(215,389)]
const GUARD_EYES=[Vector2(272,125),Vector2(312,153),Vector2(248,139),Vector2(270,125),Vector2(280,105),Vector2(306,127),Vector2(263,122),Vector2(289,101)]
const GUARD_LIPS=[Vector2(294,151),Vector2(332,178),Vector2(270,165),Vector2(292,151)]
const GUARD_PALMS=[Vector2(133,297),Vector2(183,299),Vector2(145,297),Vector2(153,297),Vector2(152,270),Vector2(182,272),Vector2(153,270),Vector2(174,266)]
const GUARD_ELBOWS=[Vector2(130,248),Vector2(163,254),Vector2(139,252),Vector2(141,247),Vector2(145,222),Vector2(165,231),Vector2(150,226),Vector2(161,221)]
const BRAIDED_SHEETS={"combat":preload("res://assets/actors-v17/braided-combat.png"),"walk":preload("res://assets/actors-v17/braided-walk.png"),"guard":preload("res://assets/actors-v17/braided-guard.png")}
static var textures:Dictionary={}
static var foregrounds:Dictionary={}
static func pose(p:Dictionary,frame:int,mode:String)->Dictionary:
 var gender=int(p.gender)
 if mode=="combat":
  var i=gender*8+frame;var row=i/4
  return {"id":mode+str(i),"sheet":SHEET,"region":Rect2i(i%4*384,TOP[row],384,HEIGHT[row]),"scale":.34,"feet":FEET[i],"eye":EYES[i],"lip":LIPS[frame] if not gender else EYES[i],"palm":PALMS[i],"elbow":ELBOWS[i],"angle":[0.0,.02,-.03,.04,.04,.07,-.02,0.0][frame],"lag":HoldAppearanceRig.WORK_LAG[frame]}
 var walk=mode=="walk";var f=(frame/2 if walk else frame)%4;var i=gender*4+f
 var info={"id":mode+str(i),"sheet":WALK if walk else GUARD,"region":Rect2i(int(f*443.5),gender*443,443,444),"scale":.20,"feet":WALK_FEET[i] if walk else GUARD_FEET[i],"eye":WALK_EYES[i] if walk else GUARD_EYES[i],"lip":WALK_LIPS[f] if walk else GUARD_LIPS[f],"palm":WALK_PALMS[i] if walk else GUARD_PALMS[i],"elbow":WALK_ELBOWS[i] if walk else GUARD_ELBOWS[i],"angle":0.0,"lag":HoldAppearanceRig.WALK_LAG[frame] if walk else 0.0}
 # The extended parry shield crosses the nominal third-cell edge. Use measured gutters.
 if not walk and f==2:info.region.size.x=465
 if not walk and f==3:
  info.region.position.x+=22;info.region.size.x-=22
  for landmark in ["feet","eye","lip","palm","elbow"]:info[landmark]-=Vector2(22,0)
 return info
static func texture(p:Dictionary,info:Dictionary)->Texture2D:
 var braided=not p.gender and p.get("sculpt",0)==1
 var key=str(HoldCharacterDesigns.REVISION)+"/"+info.id+str(p.get("sculpt",0))+str(p.gender)+str([p.hair_color,p.beard_color,p.skin,p.cloth_color,p.get("armor",0),p.outfit,p.tattoo,p.jewelry])
 key+="/cast"+str(p.get("cast_id",""))
 if textures.has(key):return textures[key]
 var mode="combat" if info.id.begins_with("combat") else ("walk" if info.id.begins_with("walk") else "guard")
 var img=load("res://assets/actors-v36/"+HoldCharacterDesigns.id(p)+"-"+info.id+".png").get_image()
 HoldCharacterArt.colorize(img,p,info.eye*info.scale*2,int(p.gender),info.elbow*info.scale*2,info.palm*info.scale*2,HoldCharacterDesigns.id(p)+"-"+info.id)
 if textures.size()>1200:textures.clear();foregrounds.clear()
 var tex=ImageTexture.create_from_image(img);textures[key]=tex;return tex
static func foreground(tex:Texture2D,info:Dictionary)->Texture2D:
 var key=str(tex.get_instance_id())
 if foregrounds.has(key):return foregrounds[key]
 var src=tex.get_image();var mask=Image.create(src.get_width(),src.get_height(),false,Image.FORMAT_RGBA8)
 var a=info.elbow*info.scale;var b=info.palm*info.scale
 for y in src.get_height():
  for x in src.get_width():
   var c=src.get_pixel(x,y)
   if Vector2(x,y).distance_to(Geometry2D.get_closest_point_to_segment(Vector2(x,y),a,b))<5.5 and c.a>.4 and c.h>.015 and c.h<.10 and c.s>.22:mask.set_pixel(x,y,c)
 var result=ImageTexture.create_from_image(mask);foregrounds[key]=result;return result
static func draw(n:Node2D,pos:Vector2,frame:int,facing:int,p:Dictionary,reset:Vector2,mode:String="combat",zoom:float=1.0,tint:Color=Color.WHITE):
 var info=pose(p,frame,mode);var scale=info.scale;var root=info.feet*scale
 var tex=texture(p,info);var eye=info.eye*scale-root
 n.draw_set_transform(pos,0,Vector2(facing,1)*zoom)
 if mode=="walk" or p.get("air_pose",0)>0:
  HoldPaintedWalk.draw(n,pos,float(p.get("gait_time",0)),facing,p,reset,zoom,tint,true);return
 n.draw_texture_rect(tex,Rect2(-root,Vector2(tex.get_size())*.5),false,tint)
 HoldEquipmentRig.draw(n,p,frame,mode)
 # Hair, beard, anatomy and equipment are painted into this one frame.
 n.draw_set_transform(reset)
