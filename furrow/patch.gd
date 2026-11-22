extends RefCounted
# A mask describes the four cultivated centres around one ground junction.
const ORIGIN=Vector2(2290,1325)
const STEP=Vector2(36,30)
const SIZE=Vector2i(8,4)
const OFFSETS=[Vector2i.ZERO,Vector2i.RIGHT,Vector2i.ONE,Vector2i.DOWN]
const STAMP=80
var masks={}
var snapshot:Dictionary={}
var atlas:Texture2D

func load_art(path:String):
 var im=Image.new()
 if im.load_png_from_buffer(FileAccess.get_file_as_bytes(path))==OK:atlas=ImageTexture.create_from_image(im)

static func key(c:Vector2i)->String:return "%d,%d"%[c.x,c.y]
static func contains(c:Vector2i)->bool:return Rect2i(Vector2i.ZERO,SIZE).has_point(c)
static func cell(p:Vector2)->Vector2i:return Vector2i(((p-ORIGIN)/STEP).floor())
static func centre(c:Vector2i)->Vector2:return ORIGIN+(Vector2(c)+Vector2(.5,.5))*STEP

func rebuild_one(soil:Dictionary,j:Vector2i):
 var m=0
 for i in 4:
  if soil.has(key(j+OFFSETS[i])):m|=1<<i
 if m:masks[j]=m
 else:masks.erase(j)

func sync(soil:Dictionary):
 if snapshot==soil:return
 masks.clear()
 for y in range(-1,SIZE.y):
  for x in range(-1,SIZE.x):rebuild_one(soil,Vector2i(x,y))
 snapshot=soil.duplicate()

func edit(soil:Dictionary,c:Vector2i,hoe:bool)->bool:
 if not contains(c) or soil.has(key(c))==hoe:return false
 sync(soil)
 if hoe:soil[key(c)]=true
 else:soil.erase(key(c))
 for offset in OFFSETS:rebuild_one(soil,c-offset)
 snapshot=soil.duplicate()
 return true

func paint(canvas,soil:Dictionary):
 sync(soil)
 if atlas==null:return
 for j in masks:
  var m:int=masks[j]
  var index=Vector2i(posmod(j.x,4)*4+m%4,posmod(j.y,3)*4+floori(m/4.0))
  canvas.draw_texture_rect_region(atlas,Rect2(centre(j),STEP),Rect2(Vector2(index)*STAMP,Vector2.ONE*STAMP))
