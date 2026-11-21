extends RefCounted
# Choose coverage from the actual road graph. All branches share one world-space stone course.
const PERIOD=192
const STEP=8
static var textures={}
static var roads={}
static var courts={}
static func texture(id:String)->Texture2D:
 if not textures.has(id):
  var im=Image.new()
  if im.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://settlement/"+id+".webp"))!=OK:return null
  textures[id]=ImageTexture.create_from_image(im)
 return textures[id]

static func offset(p:Vector2)->float:
 return sin(p.x*.051+p.y*.027)*2.5+sin(p.y*.093-p.x*.065)*1.6

static func coverage(segments:Array)->Dictionary:
 var field={}
 for seg in segments:
  var a:Vector2=seg[0];var b:Vector2=seg[1];var width:float=seg[2]
  var lo=Vector2i(((a.min(b)-Vector2.ONE*(width+12))/STEP).floor())
  var hi=Vector2i(((a.max(b)+Vector2.ONE*(width+12))/STEP).ceil())
  for y in range(lo.y,hi.y+1):
   for x in range(lo.x,hi.x+1):
    var c=Vector2i(x,y);var p=Vector2(c)*STEP
    var dist=p.distance_to(Geometry2D.get_closest_point_to_segment(p,a,b))
    var alpha=1.-smoothstep(width-9,width+3,dist+offset(p))
    if alpha>field.get(c,0.):field[c]=alpha
 return field

static func road_mesh(paths:Array,doors:Array,book:Vector2)->ArrayMesh:
 var segments=[]
 for i in paths.size():
  var path=paths[i]
  for j in range(path.size()-1):
   if path[j]!=path[j+1]:segments.append([path[j],path[j+1],34. if i==0 else 27.])
 for door in doors:
  segments.append([door-Vector2(18,0),door+Vector2(18,0),22.])
 if book!=Vector2.INF:
  for walk in [HoldGreatClaim102.WEST_WALK,HoldGreatClaim102.EAST_WALK]:
   for j in range(walk.size()-1):segments.append([walk[j],walk[j+1],19.])
 var field=coverage(segments);var cells={}
 for c in field:
  for adjacent in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.UP,Vector2i(-1,-1)]:cells[c+adjacent]=true
 var v=PackedVector3Array();var uv=PackedVector2Array();var col=PackedColorArray();var idx=PackedInt32Array()
 for c in cells:
  var base=v.size();var start=Vector2(c)*STEP
  # The wooden crossing and water occupy their original opening through the street.
  if start.x>=1136 and start.x<1336:continue
  var origin=(start/PERIOD).floor()*PERIOD
  for delta in [Vector2i.ZERO,Vector2i.RIGHT,Vector2i.ONE,Vector2i.DOWN]:
   var p=Vector2(c+delta)*STEP
   v.append(Vector3(p.x,p.y,0));uv.append((p-origin)/PERIOD)
   col.append(Color(.89,.86,.77,field.get(c+delta,0.)))
  idx.append_array(PackedInt32Array([base,base+1,base+2,base,base+2,base+3]))
 var arrays=[];arrays.resize(Mesh.ARRAY_MAX);arrays[Mesh.ARRAY_VERTEX]=v;arrays[Mesh.ARRAY_COLOR]=col;arrays[Mesh.ARRAY_TEX_UV]=uv;arrays[Mesh.ARRAY_INDEX]=idx
 var mesh=ArrayMesh.new()
 if not idx.is_empty():mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
 return mesh

static func town(g):
 var paths=g.surface.roads.roads("trail");var doors=[]
 for b in g.surface.architecture.objects("trail"):
  if b.get("kind","")=="building":doors.append(b.p)
 doors.append(g.surface.roads.inn_door())
 var book=HoldGreatClaim102.TOWN_LEDGER if HoldGreatClaim102.active(g.state) else Vector2.INF
 var signature=hash([paths,doors,book])
 if not roads.has(signature):
  roads.clear();roads[signature]=road_mesh(paths,doors,book)
 g.draw_mesh(roads[signature],texture("stone"))
 if book!=Vector2.INF:
  # The public terrace ends at Stonebridge's existing walkable cliff lip.
  var revetment=Rect2(book.x-192,959,379,97)
  g.draw_texture_rect(texture("revetment"),revetment,false,Color("c9c9b6"))
  g.draw_texture_rect(texture("court"),HoldGreatClaim102.SHRINE_COURT,false,Color("ded9c8"))
  var foot=HoldGreatClaim102.SHRINE_BACK
  g.draw_set_transform(-g.camera.round()+foot+Vector2(2,0),0,Vector2(145,10))
  g.draw_circle(Vector2.ZERO,1.,Color(.12,.10,.08,.21),true,-1,true)
  var flanks=HoldGreatClaim102.SHRINE_BRAZIER
  for dx in [-flanks.x,0,flanks.x]:
   foot=book+Vector2(dx,-3 if dx==0 else flanks.y-1)
   var radius=Vector2(58,9) if dx==0 else Vector2(17,6)
   g.draw_set_transform(-g.camera.round()+foot,0,radius)
   g.draw_circle(Vector2.ZERO,1.,Color(.14,.12,.10,.22),true,-1,true)
  g.draw_set_transform(-g.camera.round())
# Each visible patch samples the same material across tile boundaries and clipped corners.
static func plaza(g,r:Rect2,tint:Color,trim:Color):
 var key=[r,tint,trim]
 if not courts.has(key):
  var a=r.position;var b=r.end;var cut=minf(21,r.size.y*.18)
  var outline=PackedVector2Array([a+Vector2(cut,0),Vector2(b.x-cut,a.y),Vector2(b.x,a.y+cut),b-Vector2(0,cut),b-Vector2(cut,0),Vector2(a.x+cut,b.y),Vector2(a.x,b.y-cut),a+Vector2(0,cut)])
  var pieces=[]
  for y in range(floori(a.y/PERIOD),ceili(b.y/PERIOD)):
   for x in range(floori(a.x/PERIOD),ceili(b.x/PERIOD)):
    var p=Vector2(x,y)*PERIOD
    var quad=PackedVector2Array([p,p+Vector2(PERIOD,0),p+Vector2.ONE*PERIOD,p+Vector2(0,PERIOD)])
    for poly in Geometry2D.intersect_polygons(outline,quad):
     var u=PackedVector2Array()
     for point in poly:u.append((point-p)/PERIOD)
     pieces.append([poly,u])
  outline.append(outline[0]);courts[key]=[pieces,outline]
 var data=courts[key]
 for piece in data[0]:
  g.draw_polygon(piece[0],PackedColorArray([tint.lightened(.33)]),piece[1],texture("dressed"))
 g.draw_polyline(data[1],trim.darkened(.25),3,true)
 g.draw_polyline(data[1],trim.lightened(.20),1,true)
