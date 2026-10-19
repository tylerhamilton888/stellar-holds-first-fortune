class_name HoldFolk
extends RefCounted
# Reference-led complete drawn bodies, with registered identity heads.
# Source images are read once; small pose textures are cached, never recolored per frame.
const HEIGHT=62.0
const BODY=43.0
const CYCLE=.52
const MAP=[[0,3,2,6,1,4,5],[1,3,0,5,4,2,6]]
static var metadata:Dictionary={}
static var sources:Dictionary={}
static var cache:Dictionary={}
static var order:Array=[]
static var raw_cache:Dictionary={}
static func info(sheet:String,index:int)->Dictionary:
 if metadata.is_empty():metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/folk-v54/frames.json"))
 return metadata[sheet][index]
static func source(sheet:String)->Image:
 if not sources.has(sheet):
  var img=(load("res://assets/folk-v54/"+sheet+".png") as Texture2D).get_image()
  if img.is_compressed():img.decompress()
  sources[sheet]=img
 return sources[sheet]
static func rect_of(m:Dictionary)->Rect2i:
 var r=m.rect;return Rect2i(r[0],r[1],r[2],r[3])
static func vec(a:Array)->Vector2:return Vector2(a[0],a[1])
static func frame(time:float)->int:return posmod(int(time/CYCLE*6),6)
static func contact_frame(phase:float)->int:
 if phase<.18:return 0
 if phase<.52:return 1
 if phase<.76:return 2
 return 3
static func descriptor(p:Dictionary,d:Vector2,walking:bool,time:float,action:String,phase:float)->Dictionary:
 var gender="female" if int(p.gender) else "male"
 var view=HoldDirectional.view(d);var f=frame(time);var sheet=gender+"-walk";var index=view*6+f
 if not walking:sheet=gender+"-handling";index=20+view
 if action in ["pick","axe","hammer"]:
  sheet=gender+"-work";f=contact_frame(phase)
  var row=0 if action=="pick" else 3 if action=="axe" else 4
  if action=="pick" and absf(d.y)>absf(d.x)*1.35:row=1 if d.y>0 else 2;view=0 if d.y>0 else 3
  else:view=1
  if action=="hammer" and d.y>absf(d.x)*1.35:row=5;view=0
  index=row*4+f
  if action in ["pick","hammer"] and -d.y>absf(d.x)*1.35:
   sheet="rear-work";index=(int(p.gender)+(2 if action=="hammer" else 0))*4+f;view=3
 elif action in ["drink","saw","shovel","hoe","water","fish","harvest"]:
  sheet=gender+"-utility";view=0 if action=="drink" else 1
  var row={"drink":0,"saw":1,"shovel":2,"hoe":2,"water":3,"fish":4,"harvest":5}[action]
  f=clampi(int(phase),0,3) if action in ["drink","fish"] else contact_frame(phase)
  index=row*4+f
 elif action.begins_with("lift_"):
  sheet=gender+"-handling";index=12+clampi(int(phase*4),0,3);view=1
 elif action.begins_with("carry_") or action.begins_with("double_"):
  sheet=gender+"-handling";index=(8 if action.begins_with("double_") else 4 if action.ends_with("log") else 0)+view
 elif action=="push":sheet=gender+"-handling";index=16+([0,1,2,1][posmod(int(time/CYCLE*4),4)] if walking else 0);view=1
 var m=info(sheet,index);var neck=vec(m.neck);var root=vec(m.root)
 var scale=float(m.get("scale",BODY/float(m.get("body_height",root.y-neck.y))))
 return {"sheet":sheet,"index":index,"view":view,"frame":f,"neck":neck,"root":root,"scale":scale,"rect":rect_of(m),"walking":walking,"action":action,"phase":phase}
static func texture(p:Dictionary,sheet:String,index:int,head:bool=false,foreground:bool=false,full:bool=false)->Texture2D:
 var key=sheet+":"+str(index)+":"+str(p.skin)+":"+(HoldAppearance.hair(p).to_html() if head else str(p.cloth_color))+":"+str(foreground)+":"+str(p.jewelry)+(":full" if full else "")
 if cache.has(key):return cache[key]
 var m=info(sheet,index);var r=rect_of(m);var img=source(sheet).get_region(r)
 for trim in m.get("trim",[]):img.fill_rect(Rect2i(trim[0],trim[1],trim[2],trim[3]),Color.TRANSPARENT)
 var scale=float(m.get("scale",BODY/float(m.get("body_height",m.root[1]-m.neck[1])))) if not head else .115
 var ratio=1.0 if full else minf(1.0,scale*(2.5 if head else 2.0))
 img.resize(maxi(1,int(img.get_width()*ratio)),maxi(1,int(img.get_height()*ratio)),Image.INTERPOLATE_LANCZOS)
 var hair=HoldAppearance.hair(p);var cloth=HoldAppearance.cloth(p);var skin=HoldAppearance.skin(p)
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.12:img.set_pixel(x,y,Color.TRANSPARENT);continue
   var q=Vector2(x,y)/ratio+Vector2(r.position)
   if foreground:
    var neck=vec(m.neck)
    # Closed fingers and tool edges occlude the face at raised/sip contacts.
    if q.y>neck.y-3 or absf(q.x-neck.x)<7:img.set_pixel(x,y,Color.TRANSPARENT);continue
   if int(p.jewelry)>0 and c.h>.105 and c.h<.165 and c.s>.45 and c.v>.4:
    c=HoldCharacterArt.recolor(c,Color(["d8a651","c3cfd2","d59742","746f60"][p.jewelry]),Color("d8a651"))
   if head:
    # Warm high-saturation copper is hair; skin highlights and dark ink stay intact.
    if c.h>.025 and c.h<.115 and c.s>.51 and c.v>.18:
     c=HoldCharacterArt.recolor(c,hair,Color("ae592f"))
    elif c.h>.02 and c.h<.105 and c.s<.52 and c.v>.48:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   elif c.h>.48 and c.h<.66 and c.s>.20:c=HoldCharacterArt.recolor(c,cloth,Color("356477"))
   elif c.h>.025 and c.h<.10 and c.v>.68 and c.s<.50:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img)
 cache[key]=tex;order.append(key)
 while order.size()>2048:cache.erase(order.pop_front())
 return tex
static func body_rect(a:Dictionary)->Rect2:return Rect2((Vector2(a.rect.position)-a.root)*a.scale,Vector2(a.rect.size)*a.scale)
static func head_rect(p:Dictionary,a:Dictionary)->Dictionary:
 var sheet=("female" if p.gender else "male")+"-heads";var i=int(a.view)*7+MAP[p.gender][p.sculpt]
 var m=info(sheet,i);var r=rect_of(m)
 var at=(a.neck-a.root)*a.scale
 if p.gender==1 and a.action=="drink" and a.index==2:at+=Vector2(-4,3)
 return {"sheet":sheet,"index":i,"rect":Rect2(at+(Vector2(r.position)-vec(m.neck))*.115,Vector2(r.size)*.115)}
static func raw_texture(log:bool)->Texture2D:
 var key="log" if log else "stone"
 if not raw_cache.has(key):
  var image=preload("res://assets/animation-v51/homestead-props.png").get_image()
  if image.is_compressed():image.decompress()
  image=image.get_region(HoldDrawnAnimation.bounds("homestead-props",1 if log else 0))
  image=image.get_region(image.get_used_rect());raw_cache[key]=ImageTexture.create_from_image(image)
 return raw_cache[key]
static func cargo(n:Node2D,a:Dictionary,action:String):
 if not (action.begins_with("carry_") or action.begins_with("double_") or action.begins_with("lift_")):return
 var double=action.begins_with("double_");var view=int(a.view)
 var at=(a.neck-a.root)*a.scale
 var side=-1 if view in [0,1] else 1
 for i in (2 if double else 1):
  var log=action.ends_with("log") or (action=="double_mixed" and i==1)
  var tex=raw_texture(log);var width=31.0 if log else 24.0;var height=width*tex.get_height()/tex.get_width()
  var hand=at+Vector2((14 if i==0 else -14)*side,2)
  if action.begins_with("lift_"):
   hand=Vector2(21,lerpf(-4,-43,clampf(a.phase,0,1)))
  n.draw_texture_rect(tex,Rect2(hand-Vector2(width/2,height*.8),Vector2(width,height)),false)
static func paint(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,walking:bool,time:float,zoom:float,reset:Vector2,action:String="",phase:float=0):
 var a=descriptor(p,d,walking,time,action,phase);var flip=-1 if d.x<-.3 else 1
 var bob=0.0
 if walking and (action.begins_with("carry_") or action.begins_with("double_")):bob=-absf(sin(time/CYCLE*TAU))*.6
 n.draw_set_transform(at+Vector2(0,bob)*zoom,0,Vector2(flip,1)*zoom)
 cargo(n,a,action)
 var dest=body_rect(a)
 # Carry torso uses the same six drawn leg keys, registered at the belt.
 if walking and (action.begins_with("carry_") or action.begins_with("double_")):
  var legs=descriptor(p,d,true,time,"",0);var lr=body_rect(legs);var lt=texture(p,legs.sheet,legs.index,false,false,zoom>2.0)
  var cut=clampf((-16-lr.position.y)/lr.size.y,0,1)
  n.draw_texture_rect_region(lt,Rect2(lr.position+Vector2(0,lr.size.y*cut),Vector2(lr.size.x,lr.size.y*(1-cut))),Rect2(0,lt.get_height()*cut,lt.get_width(),lt.get_height()*(1-cut)))
  var tex=texture(p,a.sheet,a.index,false,false,zoom>2.0);var limit=clampf((-16-dest.position.y)/dest.size.y,0,1)
  n.draw_texture_rect_region(tex,Rect2(dest.position,Vector2(dest.size.x,dest.size.y*limit)),Rect2(0,0,tex.get_width(),tex.get_height()*limit))
 else:n.draw_texture_rect(texture(p,a.sheet,a.index,false,false,zoom>2.0),dest,false)
 if p.jewelry in [0,1,2] and a.view in [0,1]:
  var center=(a.neck-a.root)*a.scale+Vector2(1,9)
  if p.jewelry==2:
   n.draw_polyline(PackedVector2Array([center+Vector2(-3,-4),center+Vector2(0,2),center+Vector2(3,-4)]),Color("d9b265"),.6,true)
   n.draw_colored_polygon(PackedVector2Array([center+Vector2(0,-1),center+Vector2(1.6,1.5),center+Vector2(0,4),center+Vector2(-1.6,1.5)]),Color("d48b33"))
  else:
   n.draw_circle(center,1.7,Color("423b31"));n.draw_circle(center,1.2,Color("c4d0d4") if p.jewelry==1 else Color("be9857"));n.draw_line(center+Vector2(-.6,.6),center+Vector2(.6,-.6),Color("f5e1b4"),.4,true)
 var h=head_rect(p,a);n.draw_texture_rect(texture(p,h.sheet,h.index,true,false,zoom>2.0),h.rect,false)
 if p.tattoo>0:
  var meta=info(h.sheet,h.index)
  if meta.has("brow"):
   var center=(a.neck-a.root)*a.scale+(vec(meta.brow)+Vector2(0,7)-vec(meta.neck))*.115
   var line=PackedVector2Array()
   if p.tattoo==1:line=PackedVector2Array([Vector2(0,1),Vector2(0,-1.2),Vector2(1,.1),Vector2(0,.1)])
   elif p.tattoo==2:line=PackedVector2Array([Vector2(-1.5,0),Vector2(1.5,0)])
   else:line=PackedVector2Array([Vector2(-1,0),Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)])
   for i in line.size():line[i]=line[i]*.5+center
   n.draw_polyline(line,Color("386675"),.22,true)
 if action!="" and a.rect.position.y<a.neck.y-3:n.draw_texture_rect(texture(p,a.sheet,a.index,false,true,zoom>2.0),dest,false)
 n.draw_set_transform(reset)
static func grip(p:Dictionary,d:Vector2,time:float,walking:bool)->Vector2:
 var a=descriptor(p,d,walking,time,"",0);var m=info(a.sheet,a.index)
 return (vec(m.get("palm",[a.neck.x+80,a.root.y-90]))-a.root)*a.scale*Vector2(-1 if d.x<-.3 else 1,1)
static func grip_front(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,time:float,zoom:float,reset:Vector2,walking:bool):
 var a=descriptor(p,d,walking,time,"",0);var m=info(a.sheet,a.index);var palm=vec(m.get("palm",[a.neck.x+80,a.root.y-90]));var tex=texture(p,a.sheet,a.index)
 var region=Rect2(palm-Vector2(a.rect.position)-Vector2(8,9),Vector2(16,18))
 var ratio=Vector2(tex.get_size())/Vector2(a.rect.size)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(tex,Rect2((palm-Vector2(8,9)-a.root)*a.scale,Vector2(16,18)*a.scale),Rect2(region.position*ratio,region.size*ratio));n.draw_set_transform(reset)
static func work_front(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,zoom:float,reset:Vector2,action:String,phase:float):
 var a=descriptor(p,d,false,0,action,phase)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 # Draw only the work-facing hand/tool region above the station's front edge.
 var tex=texture(p,a.sheet,a.index);var dest=body_rect(a);var x=maxf(3,dest.position.x)
 var fraction=clampf((x-dest.position.x)/dest.size.x,0,1)
 n.draw_texture_rect_region(tex,Rect2(Vector2(x,dest.position.y),Vector2(dest.size.x*(1-fraction),dest.size.y)),Rect2(tex.get_width()*fraction,0,tex.get_width()*(1-fraction),tex.get_height()));n.draw_set_transform(reset)

static var warm_jobs:Array=[]
static var warm_total=0
static func warming()->bool:return not warm_jobs.is_empty()
static func key_for(p:Dictionary,sheet:String,index:int,head:bool,foreground:bool)->String:
 return sheet+":"+str(index)+":"+str(p.skin)+":"+(HoldAppearance.hair(p).to_html() if head else str(p.cloth_color))+":"+str(foreground)+":"+str(p.jewelry)
static func prepare(g:Node):
 warm_jobs.clear()
 var people=[{"profile":g.state.appearance,"player":true}]
 if g.surface.active() and HoldWorldZones.ward(g.surface.area):
  for c in g.surface.world.people():people.append({"profile":c.profile,"player":false})
 elif g.surface.room():
  var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
  if host!="":people.append({"profile":g.state.npc(host),"player":false})
  if g.room_id=="tavern":
   for id in HoldNpcPresence.tavern_guests(g.state):people.append({"profile":g.state.npc(id),"player":false})
 for a in g.agents:
  if a.type=="worker":people.append({"profile":g.state.npc(a.id),"player":false})
 var queued={}
 for entry in people:
  var p=HoldAppearance.normalized(entry.profile);var gender="female" if p.gender else "male"
  var tasks=[]
  for view in 4:tasks.append([gender+"-heads",view*7+MAP[p.gender][p.sculpt],true,false])
  for i in 24:tasks.append([gender+"-walk",i,false,false])
  for i in range(20,24):tasks.append([gender+"-handling",i,false,false])
  if entry.player:
   for row in [int(p.gender),int(p.gender)+2]:
    for col in 4:
     for fg in [false,true]:tasks.append(["rear-work",row*4+col,false,fg])
   for kind in ["work","utility","handling"]:
    for i in 24:
     tasks.append([gender+"-"+kind,i,false,false])
     var meta=info(gender+"-"+kind,i)
     if meta.rect[1]<meta.neck[1]-3:tasks.append([gender+"-"+kind,i,false,true])
  elif g.surface.room() and g.room_id in ["tavern","forge"]:
   for i in (range(4) if g.room_id=="tavern" else range(16,20)):
    for fg in [false,true]:tasks.append([gender+("-utility" if g.room_id=="tavern" else "-work"),i,false,fg])
  for task in tasks:
   var key=key_for(p,task[0],task[1],task[2],task[3])
   if not cache.has(key) and not queued.has(key):warm_jobs.append([p]+task);queued[key]=true
 warm_total=warm_jobs.size()
static func warm_step():
 var started=Time.get_ticks_usec()
 while not warm_jobs.is_empty():
  var job=warm_jobs.pop_back();texture(job[0],job[1],job[2],job[3],job[4])
  if Time.get_ticks_usec()-started>=5000:break
static func warm_draw(n:Node2D):
 n.draw_set_transform(Vector2.ZERO)
 n.draw_rect(Rect2(0,0,960,540),Color("10232a"))
 HoldArt.text(n,Vector2(313,250),"Preparing the next stretch…",20,Color("ead3a6"))
 n.draw_rect(Rect2(300,278,360,4),Color("2d454b"))
 n.draw_rect(Rect2(300,278,360*(1.0-float(warm_jobs.size())/maxi(1,warm_total)),4),Color("c3a364"))
