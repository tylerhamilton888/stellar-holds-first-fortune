class_name HoldWholeFrames
extends RefCounted
# A single whole painted figure per key, including head, limbs and gripping hands.
const HEIGHT=62.0
const CYCLE=.52
# Bump only when whole-frame artwork, crops or palette conversion change.
const CACHE_REVISION="whole58-motion59-town74-combat88-palette3"
static var metadata:Dictionary={}
static var pigment:Dictionary={}
static var sources:Dictionary={}
static var cache:Dictionary={}
static var order:Array=[]
static var warm_jobs:Array=[]
static var warm_total=0
static var disk_hits=0
static var cache_directory=""
# Derived textures are not save data. Bump CACHE_REVISION for changed artwork,
# crop metadata or palette logic; ordinary releases retain compatible frames.
static func disk_path(key:String)->String:
 if cache_directory=="":
  cache_directory="user://animation-cache/"+CACHE_REVISION
  DirAccess.make_dir_recursive_absolute(cache_directory)
 return cache_directory+"/"+key.sha256_text()+".png"
static func progress()->float:
 return 1.0-float(warm_jobs.size())/maxi(1,warm_total)
static func contact_frame(phase:float)->int:
 if phase<.18:return 0
 if phase<.52:return 1
 if phase<.76:return 2
 return 3
static func data():
 if metadata.is_empty():
  metadata=JSON.parse_string(FileAccess.get_file_as_string("res://assets/whole-v58/frames.json"))
  var motion_path="res://assets/whole-motion59/runtime.json"
  if FileAccess.file_exists(motion_path):metadata.merge(JSON.parse_string(FileAccess.get_file_as_string(motion_path)))
  metadata.merge(JSON.parse_string(FileAccess.get_file_as_string("res://assets/town-walk66/frames.json")))
  # Historical town metadata captured old PNG paths, bypassing corrected beard
  # and hair drawings. Contact keys inherit the current canonical core frames.
  for gender in ["male","female"]:
   for sculpt in 7:
    var id=gender+str(sculpt)
    for index in [8,10]:
     var current:Dictionary=metadata[id+"-core"][index].duplicate(true)
     if not current.has("source"):current.source=id+"-core"
     metadata[id+"-town"][index]=current
  metadata.merge(JSON.parse_string(FileAccess.get_file_as_string("res://assets/appearance74/frames.json")),true)
  pigment=JSON.parse_string(FileAccess.get_file_as_string("res://assets/appearance74/palette.json"))
  metadata.merge(JSON.parse_string(FileAccess.get_file_as_string("res://assets/combat88/frames.json")))
  pigment.merge(JSON.parse_string(FileAccess.get_file_as_string("res://assets/combat88/palette.json")))
  var corrections:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/combat88/corrections.json"))
  for key in corrections:
   var parts=key.split(":");metadata[parts[0]][int(parts[1])]=corrections[key]
  var scales:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/appearance74/scale.json"))
  for key in scales:
   var parts=key.split(":")
   metadata[parts[0]][int(parts[1])].height=scales[key]
  HoldStoryWorld105.register(metadata)
static func identity(p:Dictionary)->String:return ("female" if p.gender else "male")+str(int(p.sculpt))
static func descriptor(p:Dictionary,d:Vector2,walking:bool,time:float,action:String,phase:float)->Dictionary:
 data()
 if HoldStoryWorld105.has_profile(p,action):return HoldStoryWorld105.descriptor(p,d,walking,time,action,phase,metadata)
 var view=HoldDirectional.view(d);var key=posmod(int(time/CYCLE*4),4)
 var sheet=identity(p)+"-core";var index=view
 if walking:index=4+view*4+([0,1,2,1][key] if view==2 else key)
 if walking and action in ["","town_walk"] and view==1:sheet=identity(p)+"-town"
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
 var motion_sheet=identity(p)+"-motion"
 var motion_row={"hold_pick":0,"hold_axe":1,"hold_hammer":2,"hold_shovel":3,"hold_supply":4,"hold_rifle":5,"carry_stone":6,"carry_log":7,"double_stone":8,"double_log":9,"double_mixed":10}.get(action,-1)
 if motion_row>=0 and metadata.has(motion_sheet):
  sheet=motion_sheet;view=HoldDirectional.view(d);index=motion_row*16+view*4+(key if walking else 0)
 # The old male rest/recovery keys contain an axe-like adze head. Reuse
 # the approved complete equipped pick pose, including both gripping hands.
 # Raised and contact keys retain their original authored anticipation/impact.
 if action=="pick" and int(p.gender)==0 and contact_frame(phase) in [0,3]:
  sheet=identity(p)+"-motion";index=view*4
 # Combat axes are one-handed. These complete drawings retain the same axe,
 # gripping hand and strapped shield through movement, strikes and guard.
 # Work-tool poses remain independent of combat equipment.
 if action in ["hold_combat_axe","combat_axe","guard_axe","parry_axe"]:
  sheet=identity(p)+"-shield88";view=HoldDirectional.view(d)
  index=view*8+(key if walking else 0)
  if action=="combat_axe":
   var attack=contact_frame(phase)
   index=[[0,5,6,7],[8,13,14,15],[16,28,22,23],[24,28,30,31]][view][attack]
   # The crown-braid and loose-wave sheets place their rear raised key in
   # column six. Use that whole drawing rather than the resting neighbour.
   if int(p.gender)==1 and int(p.sculpt) in [0,2] and view>=2 and attack==1:index=29
  elif action=="guard_axe":index=[32,33,38,39][view]
  elif action=="parry_axe":index=36+view
  if int(p.gender)==0 and int(p.sculpt) in [3,4] and view==2 and action in ["guard_axe","parry_axe"]:index=39
 var m=metadata[sheet][index];var r=m.rect
 var rect=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1]);var scale=HEIGHT/maxf(1,float(m.height))
 return {"sheet":sheet,"index":index,"view":view,"frame":key,"rect":rect,"root":root,"scale":scale,"shape":Vector2.ONE*scale,"action":action,"phase":phase,"walking":walking,"destination":Rect2((rect.position-root)*scale,rect.size*scale)}
static func source(sheet:String)->Image:
 if not sources.has(sheet):
  var path=sheet if sheet.begins_with("res://") else "res://assets/whole-v58/"+sheet+".png"
  var img=(load(path) as Texture2D).get_image()
  if img.is_compressed():img.decompress()
  sources[sheet]=img
 return sources[sheet]
static func cache_key(p:Dictionary,sheet:String,index:int,full:bool=false)->String:
 if sheet.begins_with(HoldStoryWorld105.PREFIX):return "story105-world10:"+sheet+":"+str(index)+":"+str(full)
 return sheet+":"+str(index)+":"+str(p.skin)+":"+HoldAppearance.hair(p).to_html()+":"+str(p.cloth_color)+":"+str(p.jewelry)+":"+str(full)
static func texture(p:Dictionary,sheet:String,index:int,full:bool=false)->Texture2D:
 data();var key=cache_key(p,sheet,index,full)
 if cache.has(key):return cache[key]
 if not full:
  var path=disk_path(key)
  var cached_path=path
  if CACHE_REVISION=="whole58-motion59-town66-palette1" and not FileAccess.file_exists(cached_path):cached_path="user://animation-cache/0.66.0/"+key.sha256_text()+".png"
  if FileAccess.file_exists(cached_path):
   var ready=Image.new()
   if ready.load(cached_path)==OK and not ready.is_empty():
    if cached_path!=path:DirAccess.copy_absolute(cached_path,path)
    var saved=ImageTexture.create_from_image(ready);remember(key,saved);disk_hits+=1;return saved
 var m=metadata[sheet][index];var r=m.rect;var img=source(m.get("source",sheet)).get_region(Rect2i(r[0],r[1],r[2],r[3]))
 # Atlas extraction removes neighboring figures' disconnected fragments, never
 # constructs the character from separate body parts.
 for span in m.get("omit",[]):img.fill_rect(Rect2i(span[0],span[1],span[2],1),Color.TRANSPARENT)
 var ratio=1.0 if full else minf(1,HEIGHT/maxf(1,float(m.height))*2.6)
 var hair=HoldAppearance.hair(p);var cloth=HoldAppearance.cloth(p);var skin=HoldAppearance.skin(p)
 # Preserve shading inside each painting, but use the same hair material when
 # changing source sheets. Calibration is measured from reserved hair pigment.
 var fixed_colors=sheet.begins_with(HoldStoryWorld105.PREFIX)
 var calibration=[1,1] if fixed_colors else pigment[sheet][index]
 for y in (0 if fixed_colors else img.get_height()):
  for x in img.get_width():
   var c=img.get_pixel(x,y)
   if c.a<=0:img.set_pixel(x,y,Color.TRANSPARENT);continue
   # Purple includes red-violet shadows and nearly neutral highlights. HSV
   # cutoffs excluded both. Resolve the source pigment before resampling so
   # filtering cannot blend unconverted purple into skin or transparent edges.
   if c.r>c.g and c.b>c.g:
    var pigment=minf(c.r-c.g,c.b-c.g)
    var coverage=clampf(2.0*(c.b-c.g)/maxf(c.r-c.g,1.0/255.0),0,1)*clampf(pigment*64.0,0,1)
    var clean=Color(c.r,c.g,minf(c.b,c.g),c.a)
    var dyed=Color.from_hsv(hair.h,hair.s*clampf(c.s/(.32*float(calibration[1])),.65,1.15),clampf(hair.v*c.v/(.58*float(calibration[0])),0,1),c.a)
    c=clean.lerp(dyed,coverage)
    # Blending a warm fringe with cool grey can itself make mauve. Preserve
    # the shaded value while keeping this hair-only blend free of magenta.
    c.g=maxf(c.g,minf(c.r,c.b))
   elif c.h>.46 and c.h<.67 and c.s>.20:c=HoldCharacterArt.recolor(c,cloth,Color("356477"))
   elif c.h>.015 and c.h<.10 and c.v>.62 and c.s>.15 and c.s<.64:c=HoldCharacterArt.recolor(c,skin,Color("f3d6bc"))
   elif p.jewelry>0 and c.h>.105 and c.h<.17 and c.s>.45 and c.v>.4:c=HoldCharacterArt.recolor(c,Color(["d8a651","c3cfd2","d59742","746f60"][p.jewelry]),Color("d8a651"))
   img.set_pixel(x,y,c)
 # Keep palette resolution ahead of the filter for both portrait and game sizes.
 if ratio<1:img.resize(maxi(1,int(img.get_width()*ratio)),maxi(1,int(img.get_height()*ratio)),Image.INTERPOLATE_LANCZOS)
 if not full:img.save_png(disk_path(key))
 var tex=ImageTexture.create_from_image(img);remember(key,tex)
 return tex
static func remember(key:String,tex:Texture2D):
 cache[key]=tex;order.append(key)
 while order.size()>3072:cache.erase(order.pop_front())
static func paint(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,walking:bool,time:float,zoom:float,reset:Vector2,action:String="",phase:float=0):
 var a=descriptor(p,d,walking,time,action,phase)
 n.draw_set_transform(at,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 var figure=texture(p,a.sheet,a.index,zoom>2)
 n.draw_texture_rect(figure,a.destination,false)
 if action=="hold_supply" and a.view<2:
  var bar=n.get("hotbar")
  if bar!=null and bar.item!="" and n.state.count(bar.item)>0:
   # Contents sit inside the painted tray. Repaint its existing front rim and
   # gripping hands over the contents; never attach a new arm or loose tool.
   var contents=Rect2(-7,-36,14,12) if a.view==0 else Rect2(13,-35,14,12)
   HoldItemArt.draw(n,contents,HoldItemArt.item_index(bar.item),HoldItemArt.tint(bar.item))
   var dest:Rect2=a.destination;var rim=-28.0
   var fraction=clampf((rim-dest.position.y)/dest.size.y,0,1)
   n.draw_texture_rect_region(figure,Rect2(dest.position.x,rim,dest.size.x,dest.end.y-rim),Rect2(0,figure.get_height()*fraction,figure.get_width(),figure.get_height()*(1-fraction)))
 n.draw_set_transform(reset)
static func grip(_p:Dictionary,d:Vector2,_time:float,_walking:bool)->Vector2:return Vector2(17,-23)*Vector2(-1 if d.x<-.3 else 1,1)
static func muzzle(p:Dictionary,d:Vector2)->Vector2:
 return tool_tip(p,d,"hold_rifle",0)
static func tool_tip(p:Dictionary,d:Vector2,action:String,phase:float)->Vector2:
 var a=descriptor(p,d,false,0,action,phase);var m=metadata[a.sheet][a.index]
 var tip=m.right_tip
 if action=="hold_rifle" and a.sheet.ends_with("-motion") and a.view==3:tip=m.get("left_tip",tip)
 return (Vector2(tip[0],tip[1])-a.root)*a.scale*Vector2(-1 if d.x<-.3 else 1,1)
static func work_front(n:Node2D,at:Vector2,p:Dictionary,d:Vector2,zoom:float,reset:Vector2,action:String,phase:float):
 var a=descriptor(p,d,false,0,action,phase);var dest:Rect2=a.destination;var tex=texture(p,a.sheet,a.index)
 var x=maxf(4,dest.position.x);var fraction=clampf((x-dest.position.x)/dest.size.x,0,1)
 n.draw_set_transform(at+reset,0,Vector2(-1 if d.x<-.3 else 1,1)*zoom)
 n.draw_texture_rect_region(tex,Rect2(Vector2(x,dest.position.y),Vector2(dest.size.x*(1-fraction),dest.size.y)),Rect2(tex.get_width()*fraction,0,tex.get_width()*(1-fraction),tex.get_height()));n.draw_set_transform(reset)
static func prepare(g:Node):
 data();warm_jobs.clear();var people=[{"profile":g.state.appearance,"player":true}]
 if g.opening_scene is HoldArrivalEscort:people.append({"profile":g.state.npc("ivar"),"player":false})
 if g.surface.active() and HoldWorldZones.ward(g.surface.area):
  for ward in HoldWorldZones.WARDS:
   for c in g.surface.world.people(-1,ward):
    if not c.has("interaction"):people.append({"profile":c.profile,"player":false,"walk_only":true})
 elif g.surface.room():
  var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
  if host!="":people.append({"profile":g.state.npc(host),"player":false})
  if g.room_id=="tavern":
   for id in HoldNpcPresence.tavern_guests(g.state):people.append({"profile":g.state.npc(id),"player":false})
 if g.surface.active() and (HoldWorldZones.ward(g.surface.area) or g.surface.room()):
  g.surface.world.routines.ensure()
  if g.surface.room():
   for person in g.surface.world.routines.people(g.surface.area,g.state.elapsed):people.append({"profile":person.profile,"player":false,"walk_only":true,"drink":true})
  else:
   for plan in g.surface.world.routines.plans:people.append({"profile":plan.person.profile,"player":false,"walk_only":plan.index!=0})
 if g.surface.active():
  for person in g.surface.roads.people(g.surface.area):people.append({"profile":person.profile,"player":false,"walk_only":true})
  for person in HoldWorkerLodge100.people(g):people.append({"profile":person.profile,"player":false,"walk_only":true,"drink":person.get("pose","")=="drink"})
 for a in g.agents:
  if a.type=="worker":people.append({"profile":g.state.npc(a.id),"player":false})
 var queued={}
 for entry in people:
  var p=HoldAppearance.normalized(entry.profile)
  if HoldStoryWorld105.has_profile(p):
   queue_story_profile(p,queued)
   continue
  for kind in (["core","town","utility","handling","equipped","motion","shield88"] if entry.player else ["core","utility","town"]):
   var sheet=identity(p)+"-"+kind
   if not metadata.has(sheet):continue
   if kind=="equipped" and metadata.has(identity(p)+"-motion"):continue
   for index in metadata[sheet].size():
    if kind=="town" and index not in range(8,12):continue
    if entry.get("walk_only",false) and kind=="core" and index>=20:continue
    if kind=="handling" and metadata.has(identity(p)+"-motion") and index<40 and index not in range(8,16):continue
    if not entry.player and kind=="utility" and ((entry.get("walk_only",false) and not entry.get("drink",false)) or index not in range(8,12)):continue
    var key=cache_key(p,sheet,index)
    if not cache.has(key) and not queued.has(key):warm_jobs.append([p,sheet,index]);queued[key]=true
 warm_total=warm_jobs.size()
static func prepare_profile(profile:Dictionary):
 # Add scene-only actors without replacing the area's existing warm-up queue.
 data();var p=HoldAppearance.normalized(profile)
 var queued={}
 for job in warm_jobs:queued[cache_key(job[0],job[1],job[2])]=true
 if HoldStoryWorld105.has_profile(p):
  queue_story_profile(p,queued);warm_total=warm_jobs.size();return
 for kind in ["core","town"]:
  var sheet=identity(p)+"-"+kind
  for index in (range(20) if kind=="core" else range(8,12)):
   var key=cache_key(p,sheet,index)
   if not cache.has(key) and not queued.has(key):warm_jobs.append([p,sheet,index])
 warm_total=warm_jobs.size()
static func queue_story_profile(p:Dictionary,queued:Dictionary):
 var sheet=HoldStoryWorld105.PREFIX+str(p.cast_id)+".webp"
 for index in metadata[sheet].size():
  var key=cache_key(p,sheet,index)
  if not cache.has(key) and not queued.has(key):warm_jobs.append([p,sheet,index]);queued[key]=true
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

