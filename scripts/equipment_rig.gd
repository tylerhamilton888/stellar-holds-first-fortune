class_name HoldEquipmentRig
extends RefCounted
# Equipment uses pose-local sockets. Entire pose is mirrored at draw time, so
# helmets, armor and hands cannot disagree about facing. Art may supply one
# texture/rect per pose, allowing chest plates to wrap the actual anatomy.
static var items:Dictionary={}
static var revision=0
static func register_item(id:String,frames:Dictionary):
 # frames keys: normal0..15, combat0..7, walk0..7, guard0..7.
 # Each value: {texture: Texture2D, socket: String, rect: Rect2}.
 items[id]=frames;revision+=1
static func sockets(profile:Dictionary,frame:int,mode:String="normal")->Dictionary:
 var eye:Vector2;var palm:Vector2;var elbow:Vector2
 if mode=="normal":
  var kind=HoldCharacterArt.base_kind(profile);var root=HoldCharacterArt.root_for(kind,frame,profile)*HoldCharacterArt.SCALE
  eye=HoldCharacterArt.eye_for(profile,frame)*HoldCharacterArt.SCALE-root
  palm=HoldCharacterArt.carry_hand(frame,profile) if frame<8 else HoldCharacterArt.work_hand(frame-8,profile)
  elbow=HoldAppearanceRig.ELBOWS[kind][frame]*HoldCharacterArt.SCALE-root
 else:
  var pose=HoldShieldActor.pose(profile,frame,mode)
  eye=(pose.eye-pose.feet)*pose.scale;palm=(pose.palm-pose.feet)*pose.scale;elbow=(pose.elbow-pose.feet)*pose.scale
 return {"head":eye+Vector2(-7,-8),"neck":eye+Vector2(-8,13),"chest":eye+Vector2(-14,24),"shoulder":elbow+Vector2(-2,-8),"hand":palm,"boots":Vector2.ZERO}
static func draw(n:Node2D,profile:Dictionary,frame:int,mode:String="normal"):
 var anchors=sockets(profile,frame,mode)
 for slot in ["chest","shoulder","head"]:
  var id=str(profile.get("visual_"+slot,""))
  if not items.has(id):continue
  var entry=items[id].get(mode+str(frame),{})
  if entry.is_empty():continue
  var rect:Rect2=entry.rect;rect.position+=anchors[entry.get("socket",slot)]
  n.draw_texture_rect(entry.texture,rect,false)

static func draw_painted(n:Node2D,profile:Dictionary,frame:int,armed:bool):
 var anchors=HoldPaintedWalk.sockets(profile,frame,armed)
 var old=[1,0,2,4,5,6,3,7][frame/2] if not armed else frame/4*2
 var mode="normal" if not armed else "walk"
 for slot in ["chest","shoulder","head"]:
  var id=str(profile.get("visual_"+slot,""))
  if not items.has(id):continue
  var entry=items[id].get(mode+str(old),{})
  if entry.is_empty():continue
  var rect:Rect2=entry.rect;rect.position+=anchors[entry.get("socket",slot)]
  n.draw_texture_rect(entry.texture,rect,false)
