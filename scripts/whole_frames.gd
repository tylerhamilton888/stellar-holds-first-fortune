class_name HoldWholeFrames
extends RefCounted
# A single whole painted figure per key, including head, limbs and gripping hands.
const HEIGHT=62.0
const CYCLE=.52
static var metadata:Dictionary={}
static var sources:Dictionary={}
static var cache:Dictionary={}
static var order:Array=[]
static var warm_jobs:Array=[]
static var warm_total=0
static func contact_frame(phase:float)->int:
 if phase<.18:return 0
 if phase<.52:return 1
 if phase<.76:return 2
 return 3
static func data():
 if metadata.is_empty():metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/whole-v58/frames.json"))
static func identity(p:Dictionary)->String:return ("female" if p.gender else "male")+str(int(p.sculpt))
static func descriptor(p:Dictionary,d:Vector2,walking:bool,time:float,action:String,phase:float)->Dictionary:
 data()
 var view=HoldDirectional.view(d);var key=posmod(int(time/CYCLE*4),4)
 var sheet=identity(p)+"-core";var index=view
 if walking:index=4+view*4+([0,1,2,1][key] if view==2 else key)
 if action in ["pick","axe","hammer"]:
  index={"pick":20,"axe":24,"hammer":28}[action]+contact_frame(phase);view=1
  if action=="pick" and absf(d.y)>absf(d.x)*1.35:
   sheet=identity(p)+"-utility";index=(0 if d.y>0 else 4)+contact_frame(phase);view=0 if d.y>0 else 3
 elif action in ["drink","saw","shovel","hoe","water","fish","harvest"]:
  sheet=identity(p)+"-utility";view=0 if action=="drink" else 1
  var row={"drink":2,"saw":3,"shovel":4,"hoe":4,"water":5,"fish":6,"harvest":7}[action]
  index=row*4+(clampi(int(phase),0,3) if action in ["drink","fish"] else contact_frame(phase))
 elif action.begins_with("carry_") or action.begins_with("double_") or action.begins_with("lift_"):
  sheet=identity(p)+"-handling"
  var row=4 if action=="double_mixed" else 3 if action=="double_log" else 2 if action=="double_stone" else 1 if action.ends_with("log") else 0
  index=row*8+view*2+(int(key/2) if walking else 0)
  if action=="lift_stone":index=44+clampi(int(phase*4),0,3);view=1
 elif action=="push":sheet=identity(p)+"-handling";index=40+(key if walking else 0);view=1
 elif action.begins_with("hold_"):
  var tool=action.trim_prefix("hold_");sheet=identity(p)+"-handling"
  if tool=="supply":index=56+view
  elif tool=="rifle":index=60+view
  elif view in [1,2] and tool in ["pick","axe","hammer"]:
   sheet=identity(p)+"-core";index={"pick":20,"axe":24,"hammer":28}[tool];view=1
  elif view in [1,2] and tool=="shovel":sheet=identity(p)+"-utility";index=16;view=1
  else:index=48+{"pick":0,"axe":2,"hammer":4,"shovel":6}.get(tool,0)+(1 if view>=2 else 0)
  var walk_sheet=identity(p)+"-equipped"
  if walking and metadata.has(walk_sheet):
   sheet=walk_sheet;view=HoldDirectional.view(d)
   index={"pick":0,"axe":8,"hammer":16,"shovel":24,"supply":32,"rifle":40}.get(tool,0)+view*2+int(key/2)
 var m=metadata[sheet][index];var r=m.rect
 var rect=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1]);var scale=HEIGHT/maxf(1,float(m.height))
 return {"sheet":sheet,"index":index,"view":view,"frame":key,"rect":rect,"root":root,"scale":scale,"shape":Vector2.ONE*scale,"action":action,"phase":phase,"walking":walking,"destination":Rect2((rect.position-root)*scale,rect.size*scale)}
static func source(sheet:String)->Image:
 if not sources.has(sheet):
  var img=(load("res://assets/whole-v58/"+sheet+".png") as Texture2D).get_image()
  if img.is_compressed():img.decompress()
  sources[sheet]=img
 return sources[sheet]
static func cache_key(p:Dictionary,sheet:String,index:int,full:bool=false)->String:
 return sheet+":"+str(index)+":"+str(p.skin)+":"+HoldAppearance.hair(p).to_html()+":"+str(p.cloth_color)+":"+str(p.jewelry)+":"+str(full)
static func texture(p:Dictionary,sheet:String,index:int,full:bool=false)->Texture2D:
 data();var key=cache_key(p,sheet,index,full)
 if cache.has(key):return cache[key]
 var m=metadata[sheet][index];var r=m.rect;var img=source(m.get("source",sheet)).get_region(Rect2i(r[0],r[1],r[2],r[3]))
 # Atlas extraction removes neighboring figures' disconnected fragments, never
 # constructs the character from separate body parts.
 for span in m.get("omit",[]):img.fill_rect(Rect2i(span[0],span[1],span[2],1),Color.TRANSPARENT)
 var ratio=1.0 if full else minf(1,HEIGHT/maxf(1,float(m.height))*2.6)
 img.resize(maxi(1,int(img.get_width()*ratio)),maxi(1,int(img.get_height()*ratio)),Image.INTERPOLATE_LANCZOS)
 var hair=HoldAppearance.hair(p);var cloth=HoldAppearance.cloth(p);var skin=HoldAppearance.skin(p)
 for y in img.get_height():
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<.09:img.set_pixel(x,y,Color.TRANSPARENT);continue
   # Reserved hair pigment covers every hair shadow without a face-shaped mask.
   if c.h>.67 and c.h<.95 and c.s>.10:
    c=Color.from_hsv(hair.h,hair.s*clampf(c.s/.32,.65,1.15),clampf(hair.v*c.v/.58,0,1),c.a)
   elif c.h>.46 and c.h<.67 and c.s>.20:c=HoldCharacterArt.recolor(c,cloth,Color("356477"))
   elif c.h>.015 and c.h<.10 and c.v>.62 and c.s>.15 and c.s<.64:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   elif p.jewelry>0 and c.h>.105 and c.h<.17 and c.s>.45 and c.v>.4:c=HoldCharacterArt.recolor(c,Color(["d8a651","c3cfd2","d59742","746f60"][p.jewelry]),Color("d8a651"))
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img);cache[key]=tex;order.append(key)
 while order.size()>3072:cache.erase(order.pop_front())
 return tex
static func paint(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,walking:bool,time:float,zoom:float,reset:Vector2,action:String="",phase:float=0):
 var a=descriptor(p,d,walking,time,action,phase)
 n.draw_set_transform(at,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect(texture(p,a.sheet,a.index,zoom>2),a.destination,false)
 if action=="hold_supply" and a.view<3:
  var bar=n.get("hotbar")
  if bar!=null and bar.item!="" and n.state.count(bar.item)>0:HoldItemArt.draw(n,Rect2(-7,-29,18,12),HoldItemArt.item_index(bar.item),HoldItemArt.tint(bar.item))
 n.draw_set_transform(reset)
static func grip(_p:Dictionary,d:Vector2,_time:float,_walking:bool)->Vector2:return Vector2(17,-23)*Vector2(-1 if d.x<-.3 else 1,1)
static func muzzle(p:Dictionary,d:Vector2)->Vector2:
 var a=descriptor(p,d,false,0,"hold_rifle",0);return Vector2(a.destination.end.x-3,-32)*Vector2(-1 if d.x<-.3 else 1,1)
static func work_front(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,zoom:float,reset:Vector2,action:String,phase:float):
 var a=descriptor(p,d,false,0,action,phase);var dest:Rect2=a.destination;var tex=texture(p,a.sheet,a.index)
 var x=maxf(4,dest.position.x);var fraction=clampf((x-dest.position.x)/dest.size.x,0,1)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(tex,Rect2(Vector2(x,dest.position.y),Vector2(dest.size.x*(1-fraction),dest.size.y)),Rect2(tex.get_width()*fraction,0,tex.get_width()*(1-fraction),tex.get_height()));n.draw_set_transform(reset)
static func prepare(g:Node):
 data();warm_jobs.clear();var people=[{"profile":g.state.appearance,"player":true}]
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
  var p=HoldAppearance.normalized(entry.profile)
  for kind in (["core","utility","handling","equipped"] if entry.player else ["core","utility"]):
   var sheet=identity(p)+"-"+kind
   if not metadata.has(sheet):continue
   for index in metadata[sheet].size():
    if not entry.player and kind=="utility" and index not in range(8,12):continue
    var key=cache_key(p,sheet,index)
    if not cache.has(key) and not queued.has(key):warm_jobs.append([p,sheet,index]);queued[key]=true
 warm_total=warm_jobs.size()
static func warming()->bool:return not warm_jobs.is_empty()
static func warm_step():
 var started=Time.get_ticks_usec()
 while not warm_jobs.is_empty():
  var job=warm_jobs.pop_back();texture(job[0],job[1],job[2])
  if Time.get_ticks_usec()-started>=5000:break
 if warm_jobs.is_empty():sources.clear()
static func warm_draw(n:Node2D):
 n.draw_set_transform(Vector2.ZERO);n.draw_rect(Rect2(0,0,960,540),Color("10232a"))
 HoldArt.text(n,Vector2(313,250),"Preparing the next stretch…",20,Color("ead3a6"))
 n.draw_rect(Rect2(300,278,360,4),Color("2d454b"));n.draw_rect(Rect2(300,278,360*(1.0-float(warm_jobs.size())/maxi(1,warm_total)),4),Color("c3a364"))
