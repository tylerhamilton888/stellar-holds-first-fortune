class_name HoldWholeFolk
extends RefCounted
# Art-development backend. Deliberately not active in the released game yet:
# all saved identities/actions must have coherent complete drawings first.
# Every frame is one painted figure; no independent head, torso or leg layers.
const HEIGHT=62.0
const CYCLE=.60
static var metadata:Dictionary={}
static var atlases:Dictionary={}
static func frame(gender:int,direction:Vector2,walking:bool,time:float,action:String="",phase:float=0.0)->Dictionary:
 if metadata.is_empty():metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/folk-v58/frames.json"))
 var sheet=("female" if gender else "male")+"-core"
 var view=HoldDirectional.view(direction)
 var index=view
 if walking:index=4+view*4+posmod(int(time/CYCLE*4),4)
 if action=="pick":index=20+HoldFolk.contact_frame(phase)
 var m=metadata[sheet][index]
 var r=m.rect
 var scale=HEIGHT/float(m.height)
 var root=Vector2(m.root[0],m.root[1])
 var source=Rect2(r[0],r[1],r[2],r[3])
 return {"sheet":sheet,"index":index,"source":source,"destination":Rect2((source.position-root)*scale,source.size*scale)}
static func atlas(sheet:String)->Texture2D:
 if not atlases.has(sheet):atlases[sheet]=load("res://assets/folk-v58/"+sheet+".png")
 return atlases[sheet]
static func paint(n:Node2D,at:Vector2,gender:int,direction:Vector2,walking:bool,time:float,zoom:float=1.0,action:String="",phase:float=0.0):
 var f=frame(gender,direction,walking,time,action,phase)
 n.draw_set_transform(at,0,Vector2(-1 if direction.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(atlas(f.sheet),f.destination,f.source)
 n.draw_set_transform(Vector2.ZERO)
