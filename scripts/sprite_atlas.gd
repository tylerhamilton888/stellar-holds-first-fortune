class_name HoldSpriteAtlas
extends Node
# Each appearance is composed once into 32 actual sprite frames. Playback selects
# image regions, preserving all the player's modular clothing/hair choices.
static var current:HoldSpriteAtlas
const CELL=Vector2i(192,128)
const FEET=Vector2(88,108)
var sheets:Dictionary={}
var waiting:Dictionary={}
var order:Array=[]
func _ready():current=self
func _exit_tree():
 if current==self:current=null
func key_for(profile:Dictionary)->String:
 var values=[]
 for k in ["gender","skin","hair_style","hair_color","beard_style","beard_color","cloth_color","outfit","tattoo","jewelry"]:values.append(int(profile[k]))
 values.append(int(profile.get("sculpt",0)))
 values.append(int(profile.get("armor",0)))
 values.append(int(profile.get("shield_pose",false)))
 values.append(int(profile.get("shield_guard",false)))
 return str(HoldCharacterDesigns.REVISION)+"/"+str(profile.get("cast_id",""))+"/"+str(values)+str([profile.get("visual_head",""),profile.get("visual_chest",""),profile.get("visual_shoulder",""),HoldEquipmentRig.revision])
func request(profile:Dictionary)->SubViewport:
 var key=key_for(profile)
 if sheets.has(key):return sheets[key]
 if not waiting.has(key):
  waiting[key]=true;build.call_deferred(key,profile.duplicate(true))
 return null
func build(key:String,profile:Dictionary):
 if sheets.has(key):return
 # Bounded cache: wardrobe randomization cannot accumulate render targets forever.
 while order.size()>=32:
  var old=order.pop_front()
  if sheets.has(old):sheets[old].queue_free();sheets.erase(old)
 var view=SubViewport.new();view.size=Vector2i(CELL.x*8,CELL.y*4)*2
 view.transparent_bg=true;view.disable_3d=true
 view.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
 view.render_target_update_mode=SubViewport.UPDATE_ONCE;add_child(view)
 var painter=Node2D.new();painter.scale=Vector2(2,2);view.add_child(painter)
 painter.draw.connect(func():
  for row in 4:
   for frame in 8:
    var origin=Vector2(frame*CELL.x,row*CELL.y)+FEET
    var time=(frame+.1)/12.0 if row!=0 else 0.0
    HoldCharacterArt.draw_sprite(painter,origin,time,row==1,1,profile,row>=2,Vector2.ZERO,row!=3))
 await RenderingServer.frame_post_draw
 if not is_instance_valid(view):return
 sheets[key]=view;order.append(key);waiting.erase(key)
static func paint(n:Node2D,pos:Vector2,t:float,walking:bool,facing:int,profile:Dictionary,working:bool=false,reset:Vector2=Vector2.ZERO,action:float=-1,tint:Color=Color.WHITE,zoom:float=1.0):
 # Full-resolution pose textures are already cached by the character renderer.
 # A second low-resolution viewport bake only discarded detail and multiplied memory.
 var animated=profile.duplicate();animated["gait_time"]=t
 HoldCharacterArt.draw_sprite(n,pos,(int(action*8)+.1)/12.0 if action>=0 else t,walking,facing,animated,working or action>=0,reset,action<0,zoom,tint)
