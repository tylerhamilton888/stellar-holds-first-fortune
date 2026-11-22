extends RefCounted
const L=preload("res://workshop/layout.gd")
const Court=preload("res://court/first_court.gd")
static var cache={}
static func tex(id:String)->Texture2D:
 if not cache.has(id):
  var img=Image.new()
  if img.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://workshop/"+id+".webp"))!=OK:return null
  cache[id]=ImageTexture.create_from_image(img)
 return cache[id]
static func stamp(g,t:Texture2D,p:Vector2,size:Vector2,tint:Color,flip=false):
 var r=Rect2(p-Vector2(size.x*.5,size.y),size)
 if flip:r.position.x+=size.x;r.size.x=-size.x
 g.draw_texture_rect(t,r,false,tint)
static func grade(play,c:Vector2i)->Color:
 if play.g.zone!="mine":return Color.WHITE
 var strength=clampf(1.06-L.center(c).distance_to(play.g.player)/850.,.52,1.)
 return Color(strength,strength*.98,strength*.96)
static func stone(g,c:Vector2i,edges:Dictionary,tint:Color):
 var p=Vector2(c)*40.
 var verts=PackedVector2Array()
 var corner=[Vector2(0,0),Vector2(40,0),Vector2(40,40),Vector2(0,40)]
 var dirs=[Vector2i.UP,Vector2i.RIGHT,Vector2i.DOWN,Vector2i.LEFT]
 for i in 4:
  var before=not edges.has(L.key(c+dirs[posmod(i-1,4)]));var after=not edges.has(L.key(c+dirs[i]))
  var a=corner[i]
  var chamfer=4+posmod(c.x*5+c.y*7+i*3,5)
  if before and after:
   verts.append(a.move_toward(corner[posmod(i-1,4)],chamfer))
   verts.append(a.move_toward(corner[(i+1)%4],chamfer+2))
  else:verts.append(a)
 var terrain=Court.image_art("pavement");var uv=PackedVector2Array();var pts=PackedVector2Array()
 var source=Vector2(14+posmod(c.x*3+c.y,4)*14,20+posmod(c.y*5+c.x,10)*76)
 for v in verts:pts.append(p+v);uv.append((source+v*2.95)/terrain.get_size())
 g.draw_polygon(pts,PackedColorArray([tint*Color(.91,.99,1)]),uv,terrain)
 for i in 4:
  var a=p+corner[i].lerp(corner[(i+1)%4],.16);var b=p+corner[i].lerp(corner[(i+1)%4],.84)
  if not edges.has(L.key(c+dirs[i])):
   g.draw_line(a,b,Color(.26,.23,.19,.65),2.8,true)
   g.draw_line(a-Vector2(0,1),b-Vector2(0,1),Color(.67,.64,.53,.52),1.1,true)
  elif i in [0,3]:
   g.draw_line(p+corner[i],p+corner[(i+1)%4],Color(.16,.19,.19,.55),1.3)
static func ground(play,r:Dictionary):
 if r.is_empty():return
 var g=play.g;var flags=r.flags
 var upper=L.coord(g.camera)-Vector2i(2,2);var lower=upper+Vector2i(29,19)
 for y in range(upper.y,lower.y):
  for x in range(upper.x,lower.x):
   var c=Vector2i(x,y);var k=L.key(c)
   if not play.visible(c):continue
   var p=L.center(c)
   if g.zone!="mine":
    var mask=0
    var around=[Vector2i.ZERO,Vector2i.RIGHT,Vector2i.ONE,Vector2i.DOWN]
    for bit in 4:
     if flags.has(L.key(c+around[bit])):mask|=1<<bit
    if mask:
     var uv=Vector2(posmod(c.x,6)*4+mask%4,posmod(c.y,6)*4+floori(mask/4.))*64.
     g.draw_texture_rect_region(tex("meadow_flags"),Rect2(p,Vector2(40,40)),Rect2(uv,Vector2(64,64)))
   elif flags.has(k) and not play.wall(c):stone(g,c,flags,grade(play,c))
   if r.get("facing",{}).has(k) and play.wall(c):facing(play,c,grade(play,c))
   var marks=r.wear.get(k,{})
   if marks.is_empty():continue
   if marks.has("soot") and play.wall(c):
    for j in range(mini(10,int(marks.soot))):
     var q=p+Vector2(sin(x*2+j*3)*10,8-j*1.2);g.draw_circle(q,7+j%4,Color(.065,.068,.073,.13),true,-1,true)
   if play.wall(c):continue
   for j in int(marks.get("traffic",0)):
    var q=p+Vector2(posmod(x*5+j*13,25)-12,posmod(y*7+j*5,29)-14)
    g.draw_line(q,q+Vector2(2,4),Color(.30,.24,.17,.21),3,true)
   for j in int(marks.get("scale",0))*2:
    var q=p+Vector2(posmod(x*7+j*13,31)-15,posmod(y*3+j*9,23)-11)
    g.draw_line(q,q+Vector2(2+j%2,-1),Color("4e443a"),1.6,true)
 if g.zone=="mine":hearth_light(play,r)
static func hearth_light(play,r):
 var g=play.g;var w=g.deep.world;var glow=preload("res://settlement/ground.gd").texture("warm")
 for f in r.pieces.values():
  if f.kind!="forge" or not play.visible(L.cell(f)) or L.anchor(f).distance_to(g.player)>560:continue
  var mouth=L.anchor(f)+Vector2(L.DIR[int(f.turn)])*23.
  var pool=Rect2(mouth-Vector2(164,113),Vector2(328,226))
  var lo=L.coord(pool.position);var hi=L.coord(pool.end)
  for y in range(lo.y,hi.y+1):
   for x in range(lo.x,hi.x+1):
    var c=Vector2i(x,y);var center=L.center(c)
    if not play.visible(c) or not w.visible(mouth,center,-1,false):continue
    var part=Rect2(Vector2(c)*40.,Vector2(40,40)).intersection(pool)
    if not part.has_area():continue
    var uv=Rect2((part.position-pool.position)/pool.size*glow.get_size(),part.size/pool.size*glow.get_size())
    g.draw_texture_rect_region(glow,part,uv,Color(1,.85,.69,.54+.035*sin(g.clock*4.4)))
static func facing(play,c:Vector2i,tint:Color):
 var p=Vector2(c)*40.;var g=play.g
 if not play.wall(c+Vector2i.DOWN):
  var t=tex("wall");var w=t.get_width()/4.
  var rect=Rect2(p+Vector2(0,1),Vector2(40,39))
  g.draw_texture_rect_region(t,rect,Rect2(posmod(c.x,4)*w,0,w,t.get_height()),tint)
  var r=play.room()
  for d in [Vector2i.LEFT,Vector2i.RIGHT]:
   if not r.get("facing",{}).has(L.key(c+d)):
    stamp(g,tex("pier"),p+Vector2(6 if d.x<0 else 34,40),Vector2(13,40),tint)
 elif not play.wall(c+Vector2i.LEFT) or not play.wall(c+Vector2i.RIGHT):
  var edge=0 if not play.wall(c+Vector2i.LEFT) else 32
  g.draw_texture_rect_region(tex("wall"),Rect2(p+Vector2(edge,0),Vector2(8,40)),Rect2(20,7,26,117),tint.darkened(.14))
 elif not play.wall(c+Vector2i.UP):
  g.draw_texture_rect_region(tex("wall"),Rect2(p,Vector2(40,8)),Rect2(50,5,115,27),tint)
static func joint(g,seam:Vector2,sideways:bool):
 var at=seam+Vector2(0,-14 if not sideways else -2)
 var size=Vector2(14,6) if not sideways else Vector2(7,12)
 var r=Rect2(at-size*.5,size)
 g.draw_rect(r,Color("423d35"));g.draw_line(r.position,r.position+Vector2(size.x,0),Color("bfac8b"),1.7)
 for end in [-1,1]:g.draw_circle(at+(Vector2(4,0) if not sideways else Vector2(0,3))*end,1.15,Color("d5b67b"))
static func piece(play,f,r,alpha=1.):
 var g=play.g;var c=L.cell(f);var face=L.DIR[int(f.turn)];var pivot=L.anchor(f)
 var touch=L.neighbors(f,r,play.wall);var tint=grade(play,c);tint.a=alpha
 if f.kind=="flags":
  if play.g.zone=="mine" and play.wall(c):facing(play,c,Color(tint,.62))
  else:stone(g,c,r.get("flags",{}),Color(tint,.6))
  return
 var side=int(f.turn)%2==1
 var base=pivot+Vector2(0,14 if not side else 22)
 if f.kind=="chair" and touch.seat:base+=Vector2(face)*6
 var width={"table":41 if side else 79,"forge":45 if side else 79,"anvil":41,"chair":27}[f.kind]
 var height={"table":49 if side else 47,"forge":89 if side else 83,"anvil":39,"chair":39}[f.kind]
 g.draw_set_transform(-g.camera.round()+base,0,Vector2(1,.26))
 g.draw_circle(Vector2(0,-4),width*.48,Color(0,0,0,.27*alpha),true,-1,true)
 g.draw_set_transform(-g.camera.round())
 if f.kind=="forge":
  var lit=pivot+Vector2(face)*28.
  if alpha>=1:
   g.draw_texture_rect(HoldAmbientProps.glow_texture(),Rect2(lit-Vector2(57,26),Vector2(114,52)),false,Color(1,.70,.40,.38 if g.zone=="mine" else .15))
  var zone=L.rect(f);var pos=Vector2(zone.position)*40.;var size=Vector2(zone.size)*40.
  var a=Rect2(pos+Vector2(1,1),size-Vector2(2,2))
  g.draw_style_box(plinth(),a)
  var backing=not touch.back.is_empty()
  if backing and int(f.turn)==0:
   var socket=L.center(touch.back[0])+Vector2(18,2)
   stamp(g,tex("hood"),socket,Vector2(39,29),tint)
  if backing:
   for n in touch.back:
    var at=L.center(n)+Vector2(face)*13
    g.draw_texture_rect(HoldAmbientProps.glow_texture(),Rect2(at-Vector2(36,32),Vector2(72,64)),false,Color(1,.68,.4,alpha))
  for n in L.side(f,face):
   if r.get("flags",{}).has(L.key(n)):
    var q=L.center(n)-Vector2(face)*19;var tangent=Vector2(face.y,-face.x)
    g.draw_line(q-tangent*19,q+tangent*19,Color("ad9d80"),2.5,true)
 var visual=Rect2(base-Vector2(width*.5,height),Vector2(width,height))
 if g.player.y<pivot.y and visual.intersects(Rect2(g.player-Vector2(11,42),Vector2(22,42))):tint.a*=.67
 if f.kind=="anvil":
  HoldFurnishings.draw_anvil(g,visual,tint)
 else:
  var idx=int(f.turn);var art=tex(f.kind+str(1 if idx==3 else idx))
  stamp(g,art,base,Vector2(width,height),tint,idx==3)
 if f.kind=="forge" and int(f.turn)!=2:
  var flame=base+Vector2((10 if int(f.turn)==1 else -10) if side else 0,-31)
  var pulse=.78+.18*sin(g.clock*5.+c.x)
  g.draw_texture_rect(HoldAmbientProps.glow_texture(),Rect2(flame-Vector2(38,27),Vector2(76,54)),false,Color(1,.75,.54,pulse*alpha))
  for i in 3:
   var t=fposmod(g.clock*.65+i*.37,1.);g.draw_circle(flame+Vector2(sin(t*3+i)*6,-t*24),1,Color(1,.65,.27,sin(t*PI)*alpha))
 if f.kind=="table" and f.get("served",false):
  for idx in 2:
   var off=(idx-.5)*.50
   stamp(g,tex("supper"),base+Vector2(0 if side else off*width,-height*.53+(off*20 if side else -3)),Vector2(23,15),tint)
static var foot_style:StyleBoxFlat
static func plinth()->StyleBoxFlat:
 if not foot_style:
  foot_style=StyleBoxFlat.new();foot_style.bg_color=Color("686762");foot_style.border_color=Color("45423c");foot_style.set_corner_radius_all(5);foot_style.set_border_width_all(2)
 return foot_style
