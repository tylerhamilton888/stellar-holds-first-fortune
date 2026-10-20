class_name HoldDrawnLocomotion
extends RefCounted
# Drawn lower-body keys share a registered hip with the drawn working torso.
# No joint rotation, limb warping or runtime pose interpolation.
const CYCLE=.52
const WALK=[preload("res://assets/animation-v52/male-walk.png"),preload("res://assets/animation-v52/female-walk.png")]
const CARRY=[preload("res://assets/animation-v52/male-carry.png"),preload("res://assets/animation-v52/female-carry.png")]
const LEGS=preload("res://assets/animation-v52/legs.png")
const WALK_NECKS=[
 [Vector2(277,80),Vector2(706,77),Vector2(1129,80),Vector2(1568,79),Vector2(269,484),Vector2(703,480),Vector2(1122,483),Vector2(1573,480)],
 [Vector2(279,75),Vector2(713,76),Vector2(1132,78),Vector2(1586,77),Vector2(275,480),Vector2(704,480),Vector2(1126,480),Vector2(1580,480)]]
const PALMS=[
 [Vector2(143,264),Vector2(624,232),Vector2(1121,247),Vector2(1508,243),Vector2(119,651),Vector2(586,650),Vector2(979,660),Vector2(1465,650)],
 [Vector2(133,272),Vector2(596,265),Vector2(1119,252),Vector2(1486,267),Vector2(120,659),Vector2(584,661),Vector2(985,658),Vector2(1467,658)]]
const CARRY_NECKS=[
 [Vector2(205,16),Vector2(523,20),Vector2(878,19),Vector2(1178,20),Vector2(207,239),Vector2(522,242),Vector2(873,243),Vector2(1183,243),Vector2(203,491),Vector2(522,496),Vector2(858,496),Vector2(1182,499),Vector2(205,719),Vector2(531,721),Vector2(862,723),Vector2(1185,724),Vector2(205,942),Vector2(539,948),Vector2(862,950),Vector2(1181,950)],
 [Vector2(205,17),Vector2(524,22),Vector2(882,22),Vector2(1197,21),Vector2(208,239),Vector2(524,242),Vector2(882,247),Vector2(1198,246),Vector2(205,489),Vector2(532,498),Vector2(868,497),Vector2(1194,501),Vector2(207,716),Vector2(538,722),Vector2(872,729),Vector2(1196,728),Vector2(207,944),Vector2(543,953),Vector2(874,955),Vector2(1198,955)]]
static var metadata={}
static var cache={}
static func bounds(sheet:String,index:int)->Rect2i:
 if metadata.is_empty():metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/animation-v52/bounds.json"))
 var r=metadata[sheet][index];return Rect2i(r[0],r[1],r[2],r[3])
static func phase(time:float)->float:return fposmod(time/CYCLE,1)
static func frame(time:float)->int:return mini(3,int(phase(time)*4))
static func advance(g:Node,distance:float,material:String):
 if distance<=.01:return
 var before=int(g.gait_clock/(CYCLE*.5));g.gait_clock+=distance/150.0
 if int(g.gait_clock/(CYCLE*.5))!=before:g.sound.footstep(material)
static func is_carry(action:String)->bool:return action in ["carry_stone","carry_log","double_stone","double_log","double_mixed"]
static func descriptor(p:Dictionary,d:Vector2,time:float,action:String)->Dictionary:
 var view=HoldDirectional.view(d);var f=frame(time);var gender=int(p.gender)
 var a=HoldDrawnAnimation.descriptor(p,d,true,float(f)/8,"",0)
 if view in [1,2] and action=="":
  var index=(view-1)*4+f;var sheet=("female" if gender else "male")+"-walk"
  var r=bounds(sheet,index);var neck:Vector2=WALK_NECKS[gender][index]
  var baseline=bounds(sheet,(view-1)*4).end.y
  a={"sheet":sheet,"index":index,"rect":r,"neck":neck,"root":Vector2(neck.x,baseline),"scale":Vector2.ONE*(52.0/(baseline-WALK_NECKS[gender][(view-1)*4].y)),"view":view,"frame":f,"new":true}
 elif is_carry(action):
  var row=["carry_stone","carry_log","double_stone","double_log","double_mixed"].find(action)
  var index=row*4+view
  # Rear mixed-load female cell was rejected: use the same clothed rear torso.
  if gender==1 and index==19:gender=0
  var sheet=("female" if gender else "male")+"-carry";var r=bounds(sheet,index);var neck:Vector2=CARRY_NECKS[gender][index]
  a={"sheet":sheet,"index":index,"rect":r,"neck":neck,"root":Vector2(neck.x,r.end.y),"scale":Vector2.ONE*(52.0/(r.end.y-neck.y)),"view":view,"frame":f,"new":true,"gender":gender}
 else:
  # The original front/rear drawings retain their profile and head registration.
  a.scale.x=a.scale.y
 return a
static func texture(p:Dictionary,a:Dictionary)->Texture2D:
 if not a.get("new",false):return HoldDrawnAnimation.frame_texture(p,a.sheet,a.index)
 var key=str(p.cloth_color)+"/"+str(p.skin)+"/"+a.sheet+str(a.index)
 if cache.has(key):return cache[key]
 var gender=int(a.get("gender",p.gender));var source=CARRY[gender] if a.sheet.ends_with("carry") else WALK[gender]
 var img=source.get_image().get_region(a.rect)
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.05:continue
   if c.h>.43 and c.h<.62 and c.s>.2:c=HoldDrawnAnimation.cloth_pixel(c,p)
   elif c.h>.025 and c.h<.09 and c.v>.68 and c.s<.72:c=HoldCharacterArt.recolor(c,Color(HoldAppearance.SKIN_COLORS[p.skin]),Color("f3d6bc"))
   img.set_pixel(x,y,c)
 cache[key]=ImageTexture.create_from_image(img);return cache[key]
static func legs(view:int,time:float)->Dictionary:
 var f=mini(5,int(phase(time)*6));var index=f
 if view==1:index=[6,7,8,10,10,11][f]
 elif view>=2:index=[12,17,13,15,16,17][f]
 var r=bounds("legs",index);var key="legs"+str(index)
 if not cache.has(key):
  var img=LEGS.get_image().get_region(r)
  for y in img.get_height():
   for x in img.get_width():
    var c=img.get_pixel(x,y)
    # Atlas leg identity colors are animation guides, never the game palette.
    if c.a>.05 and c.s>.20 and ((c.h>.18 and c.h<.45) or (c.h>.68 and c.h<.91)):
     c=Color.from_hsv(.635,.32,c.v*.57,c.a);img.set_pixel(x,y,c)
  cache[key]=ImageTexture.create_from_image(img)
 var widths=[.18,.14,.18,.18];var sx=widths[view]
 # Hip sits on the center of the waistband, rather than each moving silhouette.
 var hips=[148,403,652,904,1157,1403,164,417,662,909,1170,1407,151,407,655,905,1159,1407]
 return {"texture":cache[key],"rect":Rect2((r.position.x-hips[index])*sx,-29,r.size.x*sx,29),"index":index}
static func paint(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,walking:bool,time:float,zoom:float,reset:Vector2,action:String)->bool:
 if action!="" and not is_carry(action) and action!="push":return false
 if not walking and action=="":return false
 var a=descriptor(p,d,time,action);var view=int(a.view);var flip=-1 if d.x<-.3 else 1
 if action=="push":
  a=HoldDrawnAnimation.descriptor(p,d,false,0,"push",0);view=1
 var bob=-absf(sin(phase(time)*TAU))*(.65 if is_carry(action) else 1.25) if walking else 0.0
 n.draw_set_transform(at,0,Vector2(flip,1)*zoom)
 if walking:
  var leg=legs(view,time);n.draw_texture_rect(leg.texture,leg.rect,false)
 var r:Rect2i=a.rect;var scale:Vector2=a.scale;var rect=Rect2((Vector2(r.position)-a.root)*scale,Vector2(r.size)*scale)
 rect.position.y+=bob
 var tex=texture(p,a)
 if walking:
  var h=clampf((-21.0-rect.position.y)/scale.y,1,r.size.y)
  n.draw_texture_rect_region(tex,Rect2(rect.position,Vector2(rect.size.x,h*scale.y)),Rect2(0,0,r.size.x,h))
 else:n.draw_texture_rect(tex,rect,false)
 var head=HoldDrawnAnimation.head(p,view);var w=79.0*head.get_width()/head.get_height()
 n.draw_texture_rect(head,Rect2(-w/2,-79+bob,w,79),false)
 n.draw_set_transform(reset);return true
static func grip(p:Dictionary,d:Vector2,time:float)->Vector2:
 var a=descriptor(p,d,time,"");var palm:Vector2=PALMS[p.gender][a.index] if a.get("new",false) else HoldDrawnAnimation.PALMS[p.gender][a.index]
 return (palm-a.root)*a.scale+Vector2(0,-absf(sin(phase(time)*TAU))*1.25)
static func grip_front(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,time:float,zoom:float,reset:Vector2):
 var a=descriptor(p,d,time,"");var palm:Vector2=PALMS[p.gender][a.index] if a.get("new",false) else HoldDrawnAnimation.PALMS[p.gender][a.index]
 var size=Vector2(28,30);var source=Rect2(palm-Vector2(a.rect.position)-size/2,size)
 var pos=(palm-size/2-a.root)*a.scale+Vector2(0,-absf(sin(phase(time)*TAU))*1.25)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(texture(p,a),Rect2(pos,size*a.scale),source);n.draw_set_transform(reset)
