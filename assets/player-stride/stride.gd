extends RefCounted

# These eight painted lower-body keys are registered to the same foot origin as
# the existing costumes. Compose once during warm-up, including the gripping
# hands and any tool tips that extend past the trouser seam.
const GROUPS={"":0,"town_walk":0,"hold_pick":1,"hold_axe":2,"hold_hammer":3,"hold_shovel":4,"hold_supply":5,"hold_rifle":6}
const EMPTY_KEYS=[0,0,1,3,3,3,2,0]
const SWAY=[-1,-1,-1,0,1,1,1,0]
const BOB=[0,1,0,-1,0,1,0,-1]
const CELL=Vector2i(96,72)
const BOOT_ORIGIN=Vector2i(48,58)
const BOOTS=preload("res://assets/player-stride/boots.png")
static var boots:Image
static var tool_edges:Dictionary

static func register(frames:Dictionary,palette:Dictionary):
 tool_edges=JSON.parse_string(FileAccess.get_file_as_string("res://assets/player-stride/tool-edges.json"))
 for gender in ["male","female"]:
  for sculpt in 7:
   var id=gender+str(sculpt)
   var cells=[];var colors=[]
   for group in 7:
    for view in 4:
     var sheet=id+("-motion" if group>0 else "-town" if view==1 else "-core")
     for key in 8:
      var index=(group-1)*16+view*4+int(key/2) if group else 4+view*4+EMPTY_KEYS[key]
      var upper:Dictionary=frames[sheet][index]
      var scale=124.0/float(upper.height)
      var pos=Vector2i((Vector2(upper.rect[0]-upper.root[0],upper.rect[1]-upper.root[1])*scale).round())
      var size=Vector2i((Vector2(upper.rect[2],upper.rect[3])*scale).round())
      var sway=Vector2i(0 if view==1 else SWAY[key],BOB[key])
      var bounds=Rect2i(pos+sway,size).merge(Rect2i(-BOOT_ORIGIN,CELL))
      cells.append({"rect":[0,0,bounds.size.x,bounds.size.y],"root":[-bounds.position.x,-bounds.position.y],"height":124,"sheet":sheet,"index":index,"pos":pos,"size":size,"offset":sway,"view":view,"key":key})
      colors.append(palette[sheet][index])
   frames[id+"-stride"]=cells;palette[id+"-stride"]=colors

static func compose(cell:Dictionary,upper:Image)->Image:
 if boots==null:boots=BOOTS.get_image()
 var pos:Vector2i=cell.pos
 upper.resize(cell.size.x,cell.size.y,Image.INTERPOLATE_LANCZOS)
 var keep:Array=tool_edges.get(cell.sheet+":"+str(cell.index),[])
 # The seam is in registered pixels (two per world pixel), independent of
 # beard length, costume dimensions and the atlas position of the tool.
 var first=clampi(-42-pos.y,0,upper.get_height())
 var masks=[]
 for r in keep:masks.append(Rect2i(r[0],r[1],r[2],r[3]))
 var lower=upper.get_region(Rect2i(0,first,upper.get_width(),upper.get_height()-first))
 upper.fill_rect(Rect2i(0,first,upper.get_width(),upper.get_height()-first),Color.TRANSPARENT)
 for y in range(first,mini(first+6,upper.get_height())):
  var alpha=clampf((-39.4-(pos.y+y))/4.6+.55,0,1)
  for x in upper.get_width():
   var color=lower.get_pixel(x,y-first);color.a*=alpha;upper.set_pixel(x,y,color)
 for rect in masks:
  var area:Rect2i=rect.intersection(Rect2i(pos+Vector2i(0,first),lower.get_size()))
  if area.has_area():upper.blit_rect(lower,Rect2i(area.position-pos-Vector2i(0,first),area.size),area.position-pos)
 var root=Vector2i(cell.root[0],cell.root[1])
 var result=Image.create(cell.rect[2],cell.rect[3],false,Image.FORMAT_RGBA8)
 result.blit_rect(boots,Rect2i(Vector2i(cell.key,cell.view)*CELL,CELL),root-BOOT_ORIGIN)
 result.blend_rect(upper,Rect2i(Vector2i.ZERO,upper.get_size()),root+pos+cell.offset)
 return result
