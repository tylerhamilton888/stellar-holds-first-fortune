class_name HoldTerrainView
extends RefCounted
# World-space material artwork. Cells control excavation, never texture phase.
const ATLAS=preload("res://assets/actors-v10/mine.png")
const SLATE=preload("res://assets/actors-v11/slate.png")
const COLORS={0:Color(0,0,0,0),1:Color("866348"),2:Color("687480"),3:Color("b7a08b"),4:Color("dd8844"),5:Color("303a4b"),6:Color("69cabc"),7:Color("414756"),8:Color("292e3b"),9:Color("647e53"),10:Color("456f88"),12:Color("529ab9"),13:Color("94704c")}
const PIXELS=4
const PERIOD=256
var image:Image
const CHUNK=32
var chunks:Dictionary={}
var chunk_images:Dictionary={}
var patched_cells=0
var rebuilt_chunks=0
var origin=Vector2i.ZERO
var style:Dictionary={}
var formation:FastNoiseLite
var active_seed=-1
var stone:Image
static func grain(x:int,y:int)->float:
 return float(posmod((x*374761393+y*668265263) ^ ((x*1274126177+y*42595009)>>13),1024))/1023.0
static func open_face(g:Geology,x:int,y:int)->bool:return g.at(x,y) in [0,12]
func paint_cell(g:Geology,index:int):
 var x=index%Geology.W;var y=index/Geology.W;var kind=int(g.cells[index])
 var top=open_face(g,x,y-1);var bottom=open_face(g,x,y+1)
 var left=open_face(g,x-1,y);var right=open_face(g,x+1,y)
 for dy in PIXELS:
  for dx in PIXELS:
   var px=x*PIXELS+dx;var py=y*PIXELS+dy
   var c=Color.TRANSPARENT
   if kind!=0:
    c=stone.get_pixel(posmod(px,PERIOD),posmod(py,PERIOD));c.a=1
    var fleck=grain(px/2,py/2)
    var bed=HoldWorldStyle.stratum(px,py,style)
    var layer=fposmod(bed,style.bed)
    var fold=formation.get_noise_2d(px,py)
    c=c.lerp(style.rock,.27)
    c=c.lightened(.08) if layer<style.bed*.48 else c.darkened(.13)
    c=c.lightened(fold*.15) if fold>0 else c.darkened(-fold*.15)
    if layer<1.1:c=c.darkened(.32)
    elif layer<2.2:c=c.lightened(.13)
    if kind==13:
     c=Color("8c6849") if dy%3 else Color("c29d69")
     if dx==0:c=c.darkened(.25)
    elif kind in [1,9]:
     var light=c.get_luminance()
     c=Color("49372d").lerp(Color("a2855f"),clampf((light-.18)*1.7,0,1))
     if kind==9:
      var root=sin(px*.16+sin(py*.09)*1.7)
      if root>.91:c=Color("8e9155") if dx%2==0 else Color("525d39")
      if fleck>.91:c=Color("99a267")
    elif kind in [7,8]:c=c.darkened(.3 if kind==7 else .55)
    elif kind in [10,12]:
     c=Color("1d5869").lerp(Color("327f8b"),fleck*.35)
     if top:c=Color("62bfbc") if dy==0 else Color("348e99")
     elif fleck>.94:c=c.lightened(.10)
     if kind==12:c.a=.87
    elif kind in [3,4,5,6]:
     # Irregular mineral inclusions instead of uniform colored blocks.
     var cluster=grain((px+int(sin(py*.08)*5))/3,py/3)
     if cluster>.32:
      c=COLORS[kind]
      if fleck>.77:c=c.lightened(.23)
      elif fleck<.30:c=c.darkened(.28)
      if kind==6 and dx==1 and fleck>.7:c=Color("b9eee0")
     elif kind==5:c=c.darkened(.38)
    if kind not in [10,12]:
     # Thin chipped lips follow every cut; interior grains have no bevel.
     if top and dy==0:c=c.lerp(Color("c0b69b"),.52 if fleck>.3 else .26)
     elif top and dy==1:c=c.lightened(.10)
     if left and dx==0:c=c.lightened(.15)
     if bottom and dy>=2:c=c.darkened(.24 if dy==2 else .48)
     if right and dx>=2:c=c.darkened(.12 if dx==2 else .31)
   image.set_pixel(px-origin.x*PIXELS,py-origin.y*PIXELS,c)
func draw(n:Node2D,g:Geology,time:float=0,camera:Vector2=Vector2.ZERO):
 if stone==null:
  stone=SLATE.get_image();stone.resize(PERIOD,PERIOD,Image.INTERPOLATE_NEAREST)
 if active_seed!=g.seed_value or g.redraw_all:
  chunks.clear();chunk_images.clear();active_seed=g.seed_value;style=HoldWorldStyle.profile(active_seed);formation=HoldWorldStyle.field(active_seed)
  g.redraw_all=false
 # Patch only changed grains and their exposed faces, then upload each touched texture once.
 var edits={};patched_cells=0;rebuilt_chunks=0
 for index in g.dirty:
  var cell=Vector2i(int(index)%Geology.W,int(index)/Geology.W)
  for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var q=cell+d
   if q.x<0 or q.y<0 or q.x>=Geology.W or q.y>=Geology.H:continue
   var key=Vector2i(q.x/CHUNK,q.y/CHUNK)
   if chunk_images.has(key):
    if not edits.has(key):edits[key]={}
    edits[key][q.y*Geology.W+q.x]=true
 for key in edits:
  origin=key*CHUNK;image=chunk_images[key]
  for index in edits[key]:paint_cell(g,index);patched_cells+=1
  chunks[key].update(image)
 g.dirty.clear()
 var span=CHUNK*Geology.TILE
 var first=Vector2i(maxi(0,int(camera.x/span)),maxi(0,int(camera.y/span)))
 var last=Vector2i(mini((Geology.W-1)/CHUNK,int((camera.x+960)/span)),mini((Geology.H-1)/CHUNK,int((camera.y+540)/span)))
 for cy in range(first.y,last.y+1):
  for cx in range(first.x,last.x+1):
   var key=Vector2i(cx,cy)
   if not chunks.has(key):
    origin=key*CHUNK
    image=Image.create(CHUNK*PIXELS,CHUNK*PIXELS,false,Image.FORMAT_RGBA8)
    for y in range(origin.y,mini(origin.y+CHUNK,Geology.H)):
     for x in range(origin.x,mini(origin.x+CHUNK,Geology.W)):paint_cell(g,y*Geology.W+x)
    chunks[key]=ImageTexture.create_from_image(image);chunk_images[key]=image;rebuilt_chunks+=1
   n.draw_texture_rect(chunks[key],Rect2(Vector2(key)*span,Vector2.ONE*span),false)
 # Bounded visual cache; distant terrain is recreated from saved cells + seed.
 if chunks.size()>48:
  for key in chunks.keys():
   if key.x<first.x-1 or key.x>last.x+1 or key.y<first.y-1 or key.y>last.y+1:chunks.erase(key);chunk_images.erase(key)
 draw_details(n,g,time,camera)
 # Moving reflections belong only to exposed water, never solid rock.
 for y in range(maxi(0,int(camera.y/7)),mini(Geology.H,int((camera.y+540)/7)+1)):
  for x in range(maxi(0,int(camera.x/7)),mini(Geology.W,int((camera.x+960)/7)+1)):
   if g.at(x,y) not in [10,12] or g.at(x,y-1)!=0:continue
   if sin(x*1.3+time*2.5)>.45:n.draw_line(Vector2(x*7,y*7+1),Vector2(x*7+5,y*7+1),Color("a4ddd0"),1)

func draw_details(n:Node2D,g:Geology,time:float,camera:Vector2):
 for y in range(maxi(1,int(camera.y/7)),mini(Geology.H-1,int((camera.y+540)/7)+1)):
  for x in range(maxi(1,int(camera.x/7)),mini(Geology.W-1,int((camera.x+960)/7)+1)):
   var kind=g.at(x,y)
   if kind==0:continue
   var chance=HoldWorldStyle.sample(g.seed_value,x,y,3)
   var p=Vector2(x*7,y*7)
   if kind==6 and chance>.45:
    var normal=Vector2.ZERO
    for d in [Vector2i.UP,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.DOWN]:
     if g.at(x+d.x,y+d.y)==0:normal=Vector2(d);break
    if normal!=Vector2.ZERO:
     var tangent=Vector2(-normal.y,normal.x);var base=p+Vector2(3.5,3.5)+normal*3
     var tip=base+normal*(3+chance*5)
     n.draw_colored_polygon(PackedVector2Array([base-tangent*3,tip-tangent,tip+normal*2,base+tangent*3]),Color("4b9f9c"))
     n.draw_colored_polygon(PackedVector2Array([base,tip+normal*2,base+tangent*3]),Color("b7efe0"))
     if sin(time*1.4+x+y)>.88:n.draw_circle(tip,1,Color("e9fff5"))
   elif kind in [1,9] and g.at(x,y+1)==0 and chance>.78:
    var length=8+chance*13
    n.draw_polyline(PackedVector2Array([p+Vector2(2,6),p+Vector2(3,12),p+Vector2(1,length),p+Vector2(4,length+4)]),Color("777652"),1)
   elif kind in [2,3,4,7] and g.at(x,y-1)==0 and chance>.88:
    n.draw_colored_polygon(PackedVector2Array([p+Vector2(0,1),p+Vector2(2,-2),p+Vector2(5,-3),p+Vector2(7,0)]),style.rock.lightened(.18))
