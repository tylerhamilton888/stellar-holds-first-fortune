extends RefCounted

const PREFIX = "hands-rest1/"
const FIXED = "res://assets/story105/world/hands-rest1/"
const KEYS = 12
static var poses: Dictionary = {}
static var atlas_images: Dictionary = {}
static var recent: Array = []
static var royal_atlas: Texture2D
static var fixed_views: Dictionary = {}
static var used_views: Array = []

static func register(frames: Dictionary, palettes: Dictionary):
 poses = JSON.parse_string(FileAccess.get_file_as_string("res://hands/poses/frames.json"))
 for id in poses:
  if id == "eirik":continue
  var custom = id.begins_with("male") or id.begins_with("female")
  var sheet = (PREFIX if custom else FIXED) + id
  frames[sheet] = poses[id]
  if custom:
   var original = palettes[id + "-core"]
   var colors = []
   for view in 4:
    for key in KEYS:colors.append(original[view])
   palettes[sheet] = colors

static func raw(path:String)->Image:
 if not atlas_images.has(path):
  var source=Image.new()
  var error=source.load_webp_from_buffer(FileAccess.get_file_as_bytes(path))
  if error!=OK:push_error("Cannot read empty-handed poses from "+path)
  atlas_images[path]=source
 recent.erase(path);recent.append(path)
 if recent.size()>4:atlas_images.erase(recent.pop_front())
 return atlas_images[path]

# Each fixed-color cast member shares one GPU texture across the twelve keys
# of a facing. A town full of idle dwarves should never decode a sheet per tick.
static func fixed_frame(id:String,index:int)->Texture2D:
 var view=int(index/KEYS);var cache_id=id+str(view)
 if not fixed_views.has(cache_id):
  var keys=poses[id];var first=keys[view*KEYS]
  var band=Rect2i()
  for i in KEYS:
   var r=keys[view*KEYS+i].rect
   var rect=Rect2i(r[0],r[1],r[2],r[3])
   band=rect if i==0 else band.merge(rect)
  var atlas=ImageTexture.create_from_image(raw(first.source).get_region(band))
  var regions=[]
  for i in KEYS:
   var r=keys[view*KEYS+i].rect;var region=AtlasTexture.new()
   region.atlas=atlas;region.region=Rect2(r[0]-band.position.x,r[1]-band.position.y,r[2],r[3])
   regions.append(region)
  fixed_views[cache_id]=regions
 used_views.erase(cache_id);used_views.append(cache_id)
 if used_views.size()>52:fixed_views.erase(used_views.pop_front())
 return fixed_views[cache_id][index%KEYS]

static func key_at(clock:float,seed_value:int)->int:
 # Different starting phases and cadences keep a gathering from moving in unison.
 var period=3.6+float(posmod(seed_value,9))*.14
 return posmod(floori((clock/period+float(posmod(seed_value,37))/37.)*KEYS),KEYS)

static func descriptor(p:Dictionary,d:Vector2,clock:float,action:String,phase:float)->Dictionary:
 var cast=str(p.get("cast_id",""))
 var named=cast!="" and cast!="eirik" and poses.has(cast)
 var id=cast if named else ("female" if p.gender else "male")+str(int(p.sculpt))
 var view=HoldDirectional.view(d)
 var key=key_at(clock,(id+str(p.get("name",""))).hash())
 var index=view*KEYS+key
 var m=poses[id][index];var r=m.rect
 var rect=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1])
 var scale=float(HoldStoryWorld105.HEIGHTS.get(cast,62.))/float(m.height)
 return {"sheet":(FIXED if named else PREFIX)+id,"index":index,"view":view,"frame":key,
  "rect":rect,"root":root,"scale":scale,"shape":Vector2.ONE*scale,"action":action,
  "phase":phase,"walking":false,"destination":Rect2((rect.position-root)*scale,rect.size*scale)}

static func royal(g,at:Vector2,index:int,height:float):
 if not royal_atlas:royal_atlas=ImageTexture.create_from_image(raw("res://hands/poses/eirik.webp"))
 var key=key_at(g.clock,41)
 var m=poses.eirik[index*KEYS+key];var r=m.rect
 var src=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1]);var scale=height/m.height
 g.draw_texture_rect_region(royal_atlas,Rect2(at+(src.position-root)*scale,src.size*scale),src)
