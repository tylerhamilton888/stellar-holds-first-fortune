class_name HoldPaintedWalk
extends RefCounted
const ROOT=Vector2(56,104)
static var frames={}
static var anchors={}
static func key(p:Dictionary,f:int,armed:bool)->String:return HoldCharacterDesigns.id(p)+("-armed" if armed else "-normal")+str(posmod(f,16))
static func texture(p:Dictionary,f:int,armed:bool)->Texture2D:
 var id=key(p,f,armed);var cache_key=id+str([p.hair_color,p.skin,p.cloth_color,p.get("armor",0),p.jewelry,p.get("cast_id","")])
 if frames.has(cache_key):return frames[cache_key]
 var img=load("res://assets/walk-v37/"+id+".png").get_image()
 HoldCharacterArt.colorize(img,p,Vector2(64,42)*3,int(p.gender),Vector2(-100,-100),Vector2(-100,-100),"walk37/"+id)
 var result=ImageTexture.create_from_image(img)
 if frames.size()>384:frames.clear()
 frames[cache_key]=result;return result
static func warm(profile:Dictionary):
 # Pay the first-coloring cost while entering the fortune, before movement starts.
 for armed in [false,true]:
  for f in 16:texture(profile,f,armed)
static func sockets(p:Dictionary,f:int,armed:bool)->Dictionary:
 if anchors.is_empty():anchors=JSON.parse_string(FileAccess.get_file_as_string("res://assets/walk-v37/sockets.json"))
 var result={}
 for socket in anchors[key(p,f,armed)]:
  var a=anchors[key(p,f,armed)][socket];result[socket]=Vector2(a[0],a[1])
 return result
static func draw(n:Node2D,pos:Vector2,t:float,facing:int,p:Dictionary,reset:Vector2,zoom:float,tint:Color,armed:bool):
 var f=posmod(int(t*20),16)
 if p.get("air_pose",0)>0:f=5 if p.air_pose==1 else 13
 n.draw_set_transform(pos,0,Vector2(facing,1)*zoom)
 n.draw_texture_rect(texture(p,f,armed),Rect2(-ROOT,Vector2(112,112)),false,tint)
 HoldEquipmentRig.draw_painted(n,p,f,armed)
 n.draw_set_transform(reset)
static var grips={}
static func frame_index(t:float,air:int=0)->int:
 return (5 if air==1 else 13) if air>0 else posmod(int(t*20),16)
static func draw_grip(n:Node2D,pos:Vector2,f:int,p:Dictionary,facing:int,reset:Vector2,tint:Color=Color.WHITE):
 var tex=texture(p,f,false);var hand=sockets(p,f,false).hand
 var id=str(tex.get_instance_id())
 if not grips.has(id):
  var src=tex.get_image();var part=Image.create(36,36,false,Image.FORMAT_RGBA8)
  var materials=HoldCharacterMaterials.mask_for("walk37/"+key(p,f,false),336,336)
  var corner=Vector2i(((ROOT+hand-Vector2(6,6))*3).round())
  for y in 36:
   for x in 36:
    var q=corner+Vector2i(x,y)
    if q.x>=0 and q.x<336 and q.y>=0 and q.y<336 and materials[q.y*336+q.x]==3:part.set_pixel(x,y,src.get_pixelv(q))
  if grips.size()>96:grips.clear()
  grips[id]=ImageTexture.create_from_image(part)
 n.draw_set_transform(pos,0,Vector2(facing,1))
 n.draw_texture_rect(grips[id],Rect2(hand-Vector2(6,6),Vector2(12,12)),false,tint)
 n.draw_set_transform(reset)
