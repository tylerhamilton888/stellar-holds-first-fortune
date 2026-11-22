extends RefCounted
const Quarry=preload("res://quarry/buried_quarry.gd")
const RUN=240.
const DROP=120.
const FRONT=47.
var mountain:Texture2D
var face:Texture2D
var plain=false

static func anchor(w)->Vector2:
 var q=w.data.get("quarry",{})
 if not q.get("ledge",false) or w.depth()>1:return Vector2.INF
 return w.center(Vector2i(int(q.x)+int(q.width)+2,Quarry.road_y(q)+1))

static func joined_view(p:Vector2,a:Vector2,depth:int)->float:
 if a==Vector2.INF:return 0.
 var nearest=Vector2(clampf(p.x,a.x-255.,a.x+100.),a.y)
 var shared=1.-smoothstep(210.,355.,p.distance_to(nearest))
 if depth==1 and p.x<a.x+RUN*.5 and not (p.x>=a.x and on_grade(p,a)):
  var toe=road_y(a.x+RUN,a)+FRONT
  shared*=smoothstep(toe-48.,toe-4.,p.y)
 return shared

static func road_y(x:float,a:Vector2)->float:
 var t=clampf((x-a.x+RUN*.5)/RUN,0.,1.)
 return a.y-28.+DROP*t

static func lower_weight(p:Vector2,a:Vector2,shared:float,depth:int)->float:
 if shared<=0:return float(depth)
 var toe=road_y(a.x+RUN,a)+FRONT
 return lerpf(float(depth),maxf(smoothstep(a.x-24,a.x+24,p.x),smoothstep(toe-30,toe+7,p.y)),shared)

static func on_grade(p:Vector2,a:Vector2)->bool:
 return a!=Vector2.INF and absf(p.x-a.x)<=RUN*.5+4 and absf(p.y-road_y(p.x,a))<48

static func face_blocks(w,old:Vector2,p:Vector2,a:Vector2)->bool:
 # On the lower level the saved rock cells govern the opening and its jambs.
 # The player footprint is checked with world.solid before this upper lip rule.
 if w.depth()==1:return false
 if a==Vector2.INF or p.x<a.x-RUN*.5-120 or p.x>a.x+RUN*.5-5:return false
 var y=road_y(p.x,a)+FRONT
 var foot=road_y(a.x+RUN,a)+FRONT
 return p.y>=y-5 and p.y<foot-3 and (old.y<y or old.y>=foot-3)

static func crossing(before:Vector2,after:Vector2,a:Vector2,depth:int)->bool:
 if a==Vector2.INF or before.x==after.x:return false
 if not ((depth==0 and before.x<=a.x and after.x>a.x) or (depth==1 and before.x>a.x and after.x<=a.x)):return false
 return absf(before.lerp(after,(a.x-before.x)/(after.x-before.x)).y-road_y(a.x,a))<=48

static func peek(w,player:Vector2,a:Vector2):
 if a==Vector2.INF:return
 # From the apron a dwarf can see the rock front and the exposed upper rim.
 # The upper survey ray starts on that rim; wall cells still occlude the room.
 if w.depth()==1:
  var toe=road_y(a.x+RUN,a)+FRONT
  var q:Dictionary=w.data.quarry
  if player.y>=toe-6 and player.y<toe+135 and player.x>=q.x*40. and player.x<a.x:
   var apron=Vector2(player.x,toe+12)
   if w.visible(player,apron,1,false):
    var top=Vector2(player.x,road_y(player.x,a))
    var start=w.cell(top)
    for y in range(start.y-3,start.y+3):
     for x in range(start.x-8,start.x+9):
      var c=Vector2i(x,y)
      if w.visible(top,w.center(c),0,false):w.layer(0).seen[w.key(c)]=true
 if player.distance_to(a)>260:return
 if not w.visible(player,a,w.depth(),false) and not on_grade(player,a):return
 var q=w.data.quarry;var c=w.cell(a)
 # Both lips and the open space beneath the face are visible from the cut.
 for z in 2:
  for y in range(c.y-4,c.y+8):
   for x in range(int(q.x)-1,c.x+7):
    var cell=Vector2i(x,y)
    var p=w.center(cell)
    if z==0 and p.x>a.x+60:continue
    if z==1 and p.x<a.x-36 and p.y<a.y+120:continue
    if w.at(cell,z)==0:w.layer(z).seen[w.key(cell)]=true

static func rim(x:float,a:Vector2)->Vector2:
 return Vector2(x,road_y(x,a)+FRONT+2.*sin(x*.08)+1.1*sin(x*.19))

# The first row inside the cliff and its outside neighbor must connect. Mining a
# chamber behind a sealed face therefore cannot create a door to the gallery.
static func mouth_cell(w,col:int,a:Vector2)->Vector2i:
 return Vector2i(col,w.cell(Vector2(0,road_y(a.x+RUN,a)+FRONT-4)).y)

static func mouth_open(w,col:int,a:Vector2)->bool:
 var c=mouth_cell(w,col,a)
 return w.at(c,1)==0 and w.at(c+Vector2i.DOWN,1)==0 and w.layer(1).seen.has(w.key(c))

static func mouth_height(w,x:float,a:Vector2,col:int)->float:
 var local=x-col*40.
 var h=57.+2.*sin(x*.19)+1.7*sin(x*.077)
 if local<7. and not mouth_open(w,col-1,a):h-=15.*(1.-local/7.)
 if local>33. and not mouth_open(w,col+1,a):h-=13.*((local-33.)/7.)
 return h

func throat(g,w,a:Vector2,col:int,opening_left:Vector2,opening_right:Vector2,fl:Vector2,fr:Vector2,opacity:float):
 var depth=1 if w.at(mouth_cell(w,col,a)+Vector2i.UP,1)!=0 else 2
 var inset=minf(9. if depth==1 else 16.,minf(fl.y-opening_left.y,fr.y-opening_right.y)*.35)
 var sill_l=fl-Vector2(0,inset);var sill_r=fr-Vector2(0,inset)
 var left_wall=not mouth_open(w,col-1,a);var right_wall=not mouth_open(w,col+1,a)
 var l=opening_left.x-col*40.;var r=opening_right.x-col*40.
 var edge_l=(maxf(0.,1.-l/5.) if left_wall else 0.)+(maxf(0.,1.-(40.-l)/5.) if right_wall else 0.)
 var edge_r=(maxf(0.,1.-r/5.) if left_wall else 0.)+(maxf(0.,1.-(40.-r)/5.) if right_wall else 0.)
 var dark=Color("1d252c") if depth==1 else Color("10191f")
 var side=Color("565656")
 var cl=Color(dark.lerp(side,edge_l),opacity);var cr=Color(dark.lerp(side,edge_r),opacity)
 var back=PackedVector2Array([opening_left,opening_right,sill_r,sill_l])
 if face!=null and minf(sill_l.y-opening_left.y,sill_r.y-opening_right.y)>1.:
  var uv=PackedVector2Array()
  var origin=Vector2(floorf(opening_left.x/320.)*320.,fl.y-90)
  for point in back:uv.append((point-origin)/Vector2(320,120))
  var light=.45 if depth==1 else .25
  var tl=Color(light*.63+edge_l*.25,light*.69+edge_l*.24,light*.74+edge_l*.21,opacity)
  var tr=Color(light*.63+edge_r*.25,light*.69+edge_r*.24,light*.74+edge_r*.21,opacity)
  g.draw_polygon(back,PackedColorArray([tl.darkened(.38),tr.darkened(.38),tr,tl]),uv,face)
 else:g.draw_primitive(back,PackedColorArray([cl.darkened(.25),cr.darkened(.25),cr,cl]),PackedVector2Array())
 var floor_back=Color(.23,.24,.22,opacity);var floor_front=Color(.51,.47,.37,opacity*.78)
 g.draw_primitive(PackedVector2Array([sill_l,sill_r,fr,fl]),PackedColorArray([floor_back,floor_back,floor_front,floor_front]),PackedVector2Array())
 g.draw_line(opening_left,opening_right,Color(.085,.115,.14,.9*opacity),2.,true)
 if left_wall and l<.1:g.draw_line(opening_left+Vector2(1,2),fl+Vector2(2,-2),Color(.38,.39,.36,.66*opacity),2,true)
 if right_wall and r>39.9:g.draw_line(opening_right-Vector2(1,-2),fr-Vector2(2,2),Color(.14,.17,.18,.8*opacity),2,true)

func paint(g,w,a:Vector2):
 if a==Vector2.INF or joined_view(g.player,a,w.depth())<=0.:return
 var q=w.data.quarry
 var crest=a.x-RUN*.5;var end=a.x+RUN*.5
 var ramp_known=w.layer(0).seen.has(w.key(w.cell(Vector2(crest,road_y(crest,a))))) or w.layer(1).seen.has(w.key(w.cell(Vector2(end,road_y(end,a)))))
 var known=ramp_known
 if not known:
  for col in range(int(q.x),w.cell(Vector2(end,0)).x+1):
   var apron=mouth_cell(w,col,a)+Vector2i.DOWN
   if w.at(apron,1)==0 and w.layer(1).seen.has(w.key(apron)):
    known=true;break
 if not known:return
 if face==null:
  var im=Image.new()
  if im.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://quarry/face.webp"))!=OK:return
  face=ImageTexture.create_from_image(im)
  if im.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://tunnel/mountain.webp"))==OK:
   mountain=ImageTexture.create_from_image(im)
 var west=float(q.x)*40.+6
 var bottom=road_y(end,a)+FRONT+2
 var opacity=joined_view(g.player,a,w.depth())
 # Rejoin the far wall to the slope itself instead of outlining the cells
 # sampled for navigation. World-space UVs continue the surrounding mountain.
 if ramp_known and mountain!=null:
  for k in 36:
   var x0=crest-12+k*8.
   var x1=x0+8.
   var p0=Vector2(x0,road_y(x0,a)-39.+2.8*sin(x0*.073))
   var p1=Vector2(x1,road_y(x1,a)-39.+2.8*sin(x1*.073))
   var poly=PackedVector2Array([p0-Vector2(0,106),p1-Vector2(0,106),p1,p0])
   var uv=PackedVector2Array()
   var colors=PackedColorArray()
   for point in poly:
    uv.append((point-Vector2(20,20)-Vector2(floorf((x0-20)/960.)*960,0))/960.)
    var mask=smoothstep(crest-12,crest+20,point.x)*(1.-smoothstep(end-12,end+33,point.x))
    colors.append(Color(.88,.88,.88,opacity*mask*(1.-smoothstep(64.,106.,p0.y-point.y))))
   g.draw_polygon(poly,colors,uv,mountain)
   var strength=smoothstep(crest-10,crest+24,x0)*(1.-smoothstep(end-8,end+32,x0))*opacity
   g.draw_line(p0,p1,Color(.26,.32,.36,.80*strength),4.,true)
   g.draw_line(p0-Vector2(0,1),p1-Vector2(0,1),Color(.51,.56,.56,.58*strength),1.6,true)
 var x=west
 while x<end:
  var col=floori(x/40.)
  var nx=minf(minf(x+4.,(col+1)*40.),end)
  var left=rim(x,a);var right=rim(nx,a)
  var yl=maxf(left.y+.5,lerpf(left.y,bottom,smoothstep(west,west+37,x)))
  var yr=maxf(right.y+.5,lerpf(right.y,bottom,smoothstep(west,west+37,nx)))
  var hl=yl-left.y;var hr=yr-right.y
  var fl=Vector2(x,yl);var fr=Vector2(nx,yr)
  var cut=minf(hl,hr)>3. and mouth_open(w,col,a)
  var ol=fl;var oright=fr
  if cut:
   ol.y-=minf(hl*.87,mouth_height(w,x,a,col))
   oright.y-=minf(hr*.87,mouth_height(w,nx,a,col))
   throat(g,w,a,col,ol,oright,fl,fr,opacity)
  # A bed in the stone stays at a fixed elevation as the cut thins into it.
  var poly=PackedVector2Array([left,right,oright,ol])
  var uv=PackedVector2Array([Vector2((x-west)/650.,1.-hl/(DROP+8)),Vector2((nx-west)/650.,1.-hr/(DROP+8)),Vector2((nx-west)/650.,1.-(fr.y-oright.y)/(DROP+8)),Vector2((x-west)/650.,1.-(fl.y-ol.y)/(DROP+8))])
  var top=Color(.85,.88,.93,opacity);var low=Color(.48,.54,.63,opacity)
  if plain:g.draw_primitive(poly,PackedColorArray([Color(.27,.33,.37,opacity)]),PackedVector2Array())
  elif minf(hl,hr)>.52:g.draw_polygon(poly,PackedColorArray([top,top,low,low]),uv,face)
  var sl=minf(16,hl*.15);var sr=minf(16,hr*.15)
  if not cut and hl>1. and hr>1.:
   g.draw_primitive(PackedVector2Array([fl,fr,fr+Vector2(2,sr),fl+Vector2(2,sl)]),PackedColorArray([Color(0,0,0,.42*opacity),Color(0,0,0,.42*opacity),Color(0,0,0,0),Color(0,0,0,0)]),PackedVector2Array())
  g.draw_line(left,right,Color(.44,.45,.41,.86*opacity),3.4,true)
  var chip=.3+.25*sin(x*.063)
  g.draw_line(left-Vector2(0,1),right-Vector2(0,1),Color(.75,.77,.69,chip*opacity),1.5,true)
  x=nx
 if w.depth()==1:
  for col in range(int(q.x),w.cell(Vector2(end,0)).x+1):
   var c=mouth_cell(w,col,a);var k=w.at(c,1)
   var damage=float(w.layer(1).damage.get(w.key(c),0.))
   if k==0 or damage<=0 or not w.layer(1).seen.has(w.key(c)):continue
   var mid=Vector2(w.center(c).x,bottom-22)
   if rim(mid.x,a).y>mid.y-20:continue
   var t=clampf(damage/w.resistance(k),0.,1.)
   var seam=PackedVector2Array([mid+Vector2(-6,-6)*t,mid,mid+Vector2(-2,5),mid+Vector2(5,10+5*t)])
   g.draw_polyline(seam,Color(.08,.10,.12,opacity),1.6,true)
 if not ramp_known:return
 # The road is an inclined quadrilateral in projection. Its ends meet the
 # surveyed upper and lower landings, with no crosswise border at either toe.
 var back=Vector2(0,-40)
 for i in 30:
  var x0=crest+RUN*i/30.;var x1=crest+RUN*(i+1)/30.
  var b0=Vector2(x0,road_y(x0,a))+back;var b1=Vector2(x1,road_y(x1,a))+back
  var f0=rim(x0,a);var f1=rim(x1,a)
  var blend=smoothstep(0.,.10,i/30.)*smoothstep(0.,.10,1.-i/30.)
  var floor_color=Color(.60,.54,.41,(1. if plain else .42)*opacity*blend)
  g.draw_colored_polygon(PackedVector2Array([b0,b1,f1,f0]),floor_color)
  if not plain:
   for r in [-10.,12.]:
    var p0=Vector2(x0,road_y(x0,a)+r+sin(x0*.043)*1.2)
    var p1=Vector2(x1,road_y(x1,a)+r+sin(x1*.043)*1.2)
    g.draw_line(p0,p1,Color(.20,.18,.15,.46*opacity*blend),2.,true)
