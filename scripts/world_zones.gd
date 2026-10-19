class_name HoldWorldZones
extends RefCounted
# One authored world layout drives doors, footprints, routes, art and wayfinding.
const WARDS=["crownward","hearthward","forgeward"]
const ROYAL=Vector2(180,850)
const FORGE=Vector2(1700,850)
const LIFT=Vector2(1700,550)
const GATE=Vector2(1270,950)
const DOORS={1:Vector2(960,460),4:Vector2(1380,800),7:Vector2(350,450),8:Vector2(780,450),9:Vector2(1230,450),10:Vector2(970,790),12:Vector2(1450,800),13:GATE,15:Vector2(580,450),17:Vector2(1250,450)}
var surface_ref:WeakRef
var s:
 get:return surface_ref.get_ref()
var g
var bounds={}
var citizens=[]
var styles={}
var profiles={}
var people_frame=-1
var people_area=""
var people_cache=[]
var collision_cache={}
var speech=""
var speech_until=0.0
func _init(surface):surface_ref=weakref(surface);g=surface.g
static func ward(id:String)->bool:return id in WARDS
static func door(i:int)->Vector2:return DOORS[i]
func buildings()->Array:
 var result=[]
 for i in HoldDistrictMap.DOORS:
  if int(i)/7!=s.level() or i in [10,13]:continue
  var kind={1:3,4:5,7:0,8:1,9:2,12:6,15:4,17:7}[i]
  result.append({"p":door(i),"kind":"building","art":kind,"width":400.0 if i==1 else 370.0 if i in [8,15] else 310.0,"id":i})
 # Homes belong to the streets; their occupants are represented by the citizens.
 if s.area=="hearthward":result.append({"p":Vector2(460,830),"kind":"building","art":0,"width":310.0,"id":-1})
 else:
  for p in [Vector2(350,450),Vector2(450,820)]:
   if s.area=="forgeward" and p.y<500:continue
   result.append({"p":p,"kind":"building","art":0,"width":310.0,"id":-1})
 return result
func obstacles()->Array:
 if collision_cache.has(s.area):return collision_cache[s.area].duplicate()
 var result=[]
 for b in buildings():result.append(Rect2(b.p-Vector2(b.width*.44,b.width*.5),Vector2(b.width*.88,b.width*.5-20)))
 # Central memorial fountain has a tangible basin, with broad streets around it.
 result.append(Rect2(895,595,150,70))
 for o in landmarks():
  if o.art in [0,1,2,4]:
   for side in [-1,1]:
    if o.art==0:result.append(Rect2(o.p+Vector2(side*o.width*.32-o.width*.14,-o.width*.34),Vector2(o.width*.28,o.width*.42)))
    else:result.append(Rect2(o.p+Vector2(side*o.width*.4-10,-o.width*.6),Vector2(20,o.width*.6)))
  elif o.art==5:result.append(Rect2(o.p-Vector2(50,20),Vector2(100,20)))
 collision_cache[s.area]=result
 return result.duplicate()
func points()->Array:
 var result=[]
 for i in HoldDistrictMap.DOORS:
  if int(i)/7!=s.level():continue
  var d=HoldDistrictMap.DOORS[i];var action="room:"+d.id
  if i==10:action="anniversary"
  elif i==13:action="trail"
  elif i==17:action="room:practice"
  result.append({"p":door(i),"name":"King's Gate · High Trail" if i==13 else d.name,"action":action})
 result.append({"p":LIFT,"name":"Hold lift","action":"hold_lift"})
 if s.area=="hearthward":
  result.append({"p":ROYAL,"name":"Royal stairs · Crownward","action":"crownward"})
  result.append({"p":FORGE,"name":"Forge stairs · Forgeward","action":"forgeward"})
 else:result.append({"p":ROYAL if s.area=="crownward" else FORGE,"name":"Stairs · Hearthward","action":"hearthward"})
 for b in buildings():
  if b.id==-1:result.append({"p":b.p,"name":"Folk homes · private quarters","action":"private"})
 for c in people():result.append({"p":c.p,"name":c.name+" · "+c.role,"action":"citizen:"+str(c.index)})
 return result
func arrival(old:String,id:String)->Vector2:
 if ward(old) and ward(id):
  if old=="crownward" or id=="crownward":return ROYAL+Vector2(0,30)
  return FORGE+Vector2(0,30)
 if old=="trail" and id=="hearthward":return GATE-Vector2(0,40)
 if id=="trail":
  return {"hearthward":Vector2(245,690),"claim":Vector2(1600,700),"pinewood":Vector2(470,885)}.get(old,Vector2(245,690))
 return Vector2.INF
func people(at_time:float=-1)->Array:
 if not ward(s.area):return []
 if at_time<0 and people_frame==Engine.get_process_frames() and people_area==s.area:return people_cache
 var time=g.state.elapsed if at_time<0 else at_time
 var route=[Vector2(270,550),Vector2(780,550),Vector2(1450,550),Vector2(1450,580),Vector2(780,580),Vector2(780,650),Vector2(270,650)]
 var names=[["Yrsa","Hakon","Inga","Viggo","Tova","Arvid"],["Runa","Torsten","Sigrid","Dori","Edda","Brynjar"],["Kara","Tormund","Hilda","Odd","Alva","Gunnar"]][s.level()]
 var roles=["Stonecarver","Lamplighter","Courier","Baker","Apprentice","Shift worker"]
 var result=[]
 var cycle=3.0*route.size()
 for j in route.size():cycle+=route[j].distance_to(route[(j+1)%route.size()])/62.0
 for i in 6:
  var phase=fposmod(time+i*19+s.level()*11,cycle);var p=route[0];var aim=Vector2.DOWN;var walking=false
  for j in route.size():
   var a=route[j];var b=route[(j+1)%route.size()];var duration=a.distance_to(b)/62.0
   if phase<3:p=a;break
   phase-=3
   if phase<duration:p=a.lerp(b,phase/duration);aim=(b-a).normalized();walking=true;break
   phase-=duration;p=b
  var key=str(g.state.seed_value)+":"+str(s.level())+":"+str(i)
  if not profiles.has(key):profiles[key]=HoldAppearance.random_profile(g.state.seed_value+5100+i+s.level()*101,1 if i%3==0 else 0)
  var profile=profiles[key]
  result.append({"p":p,"kind":"citizen","profile":profile,"aim":aim,"walking":walking,"name":names[i],"role":roles[i],"index":i,"time":time+i*.7})
 if at_time<0:people_cache=result;people_frame=Engine.get_process_frames();people_area=s.area
 return result
func speak(index:int):
 var lines=["A good hold is built one sound stone at a time. The royal stair is on the western terrace.","I keep these lamps lit. The eastern lift serves all three wards.","Ivar keeps the shift book southeast of the fountain. Orla trades on the north street.","The Copper Kettle is on the north street. Hedrik always has a warm hearth.","Borin works below in Forgeward. Take the eastern stairs beside the gate.","Through King's Gate: the Old Workings north, Pinewood south, your mountain claim east."]
 speech=people()[index].name+" · "+lines[index];speech_until=g.clock+8
 g.notify("A word from "+people()[index].name+". Keep walking whenever you like.")
func draw_citizen(c:Dictionary):
 if not Rect2(g.camera-Vector2(80,0),Vector2(1120,650)).has_point(c.p):return
 var cam=g.camera.round()
 g.draw_set_transform(c.p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,17,Color(0,0,0,.25))
 HoldDirectional.draw(g,c.p-cam,c.profile,c.aim,c.walking,c.time*62.0/150.0,.85,-cam)
 g.draw_set_transform(-cam)
func draw_ground():
 g.draw_rect(Rect2(0,0,1880,1080),Color("28393b"))
 tile(0,Rect2(80,180,1720,840),100,Color("aab5ae") if s.area=="forgeward" else Color("d3d4bd"))
 g.draw_texture_rect(VAULT,Rect2(45,-365,1790,597),false)
 # The inhabited wards sit beneath the ancestral mountain vault.
 # Broad shadow and coping follow the collision envelope, without thin repeated strips.
 for x in range(90,1780,170):
  # Northern boundary is the vault footing, aligned with the walkable limit.
  detail(2,Vector2(x+85,1040),176,70)
 for side in [80,1780]:
  g.draw_rect(Rect2(side-12,207,30,790),Color("28383b"))
  g.draw_line(Vector2(side,208),Vector2(side,995),Color("8a9384"),8)
  g.draw_line(Vector2(side+5,208),Vector2(side+5,995),Color("c0b793"),2)
  for y in [330,580,830]:detail(4,Vector2(side,y),58,90)
 for y in [520,740,980]:
  g.draw_line(Vector2(115,y),Vector2(1770,y),Color("6d786a"),3)
 g.draw_arc(Vector2(970,635),125,0,TAU,64,Color("a39170"),4)
 for p in [Vector2(180,450),Vector2(1700,450),Vector2(680,800),Vector2(1130,820)]:s.furniture(p,"lamp")
func stone_style(color:Color)->StyleBoxFlat:
 if styles.has(color):return styles[color]
 var style=StyleBoxFlat.new();styles[color]=style;style.bg_color=color;style.border_color=color.darkened(.35);style.set_border_width_all(2);style.set_corner_radius_all(5);return style
const VAULT=preload("res://assets/folk-v54/hold-vault.png")
const FACADES=preload("res://assets/folk-v54/hold-facades.png")
const FACADE_RECTS=[Rect2(19,10,383,572),Rect2(428,26,426,558),Rect2(845,43,401,544),Rect2(16,615,410,607),Rect2(427,607,416,608),Rect2(841,655,403,560)]
const FACADE_DOORS=[Vector2(210,575),Vector2(627,578),Vector2(1046,580),Vector2(211,1212),Vector2(626,1202),Vector2(1046,1208)]
const WORKPLACES=preload("res://assets/world-v50/workplaces.png")
const BUILDINGS=preload("res://assets/world-v50/buildings.png")
const LANDMARKS=preload("res://assets/world-v50/landmarks.png")
const FURNISHINGS=preload("res://assets/world-v50/furnishings.png")
# Measured atlas slices and threshold anchors. Never assume equal generated cells.
const BUILD_RECTS=[Rect2(32,20,450,415),Rect2(495,0,525,440),Rect2(1030,40,500,410),Rect2(5,440,505,545),Rect2(525,500,500,490),Rect2(1030,475,500,510)]
const BUILD_ANCHORS=[Vector2(260,425),Vector2(772,432),Vector2(1280,441),Vector2(254,975),Vector2(770,975),Vector2(1240,973)]
const LAND_RECTS=[Rect2(15,0,560,490),Rect2(610,40,410,445),Rect2(1065,40,440,445),Rect2(10,510,565,475),Rect2(615,490,400,480),Rect2(1040,690,490,275)]
const LAND_ANCHORS=[Vector2(292,444),Vector2(815,463),Vector2(1285,465),Vector2(290,970),Vector2(815,951),Vector2(1280,950)]
const FURN_RECTS=[Rect2(10,120,500,340),Rect2(530,40,550,420),Rect2(1110,115,415,350),Rect2(25,495,405,450),Rect2(450,590,530,355),Rect2(995,570,530,365)]
func image_at(tex:Texture2D,source:Rect2,anchor:Vector2,p:Vector2,width:float,fade:bool=false):
 var scale=width/source.size.x;var rect=Rect2(p-(anchor-source.position)*scale,source.size*scale)
 if not rect.intersects(Rect2(g.camera,Vector2(960,540))):return
 var alpha=.35 if fade and rect.has_point(g.player) and g.player.y<p.y-25 else 1.0
 g.draw_texture_rect_region(tex,rect,source,Color(1,1,1,alpha))
func draw_building(b:Dictionary):
 if ward(s.area):
  var i={0:0,1:1,2:2,3:3,4:4,5:5,6:5,7:3}[b.art]
  image_at(FACADES,FACADE_RECTS[i],FACADE_DOORS[i],b.p,b.width,true);return
 if b.art>=6:
  var r=Rect2(0,110,710,710) if b.art==6 else Rect2(735,140,795,675)
  var anchor=Vector2(365,800) if b.art==6 else Vector2(1130,800)
  image_at(WORKPLACES,r,anchor,b.p,b.width,true);return
 image_at(BUILDINGS,BUILD_RECTS[b.art],BUILD_ANCHORS[b.art],b.p,b.width,true)
func landmarks()->Array:
 var result=[{"p":Vector2(970,665),"kind":"landmark","art":3,"width":180.0},{"p":LIFT,"kind":"landmark","art":4,"width":125.0}]
 if s.area in ["hearthward","crownward"]:result.append({"p":ROYAL,"kind":"landmark","art":1 if s.area=="hearthward" else 2,"width":150.0})
 if s.area in ["hearthward","forgeward"]:result.append({"p":FORGE,"kind":"landmark","art":2 if s.area=="hearthward" else 1,"width":150.0})
 if s.area=="hearthward":result.append({"p":GATE,"kind":"landmark","art":0,"width":240.0})
 for p in [Vector2(680,800),Vector2(1130,820)]:result.append({"p":p+Vector2(0,15),"kind":"landmark","art":5,"width":110.0})
 return result
func draw_landmark(o:Dictionary):image_at(LANDMARKS,LAND_RECTS[o.art],LAND_ANCHORS[o.art],o.p,o.width,o.art in [0,3,5])
func room_objects()->Array:
 var result=[];var id=g.room_id
 if id=="tavern":
  result.append(furn(0,400,350,190))
  for x in [270,440,610]:result.append(furn(4,x,495,94))
 elif id in ["forge","practice"]:result=[furn(1,330,390,245),furn(2,685,350,130)]
 elif id=="market":result=[furn(5,400,385,280),furn(3,710,340,100)]
 elif id in ["commission","research"]:result=[furn(2,620,365,175),furn(3,270,365,130),furn(3,420,365,130)]
 elif id=="training":result=[furn(2,660,570,100)]
 elif id=="home":result=[furn(4,650,330,140)]
 return result
func furn(art:int,x:float,y:float,width:float)->Dictionary:return {"kind":"furnishing","art":art,"p":Vector2(x,y),"width":width}
func room_obstacles()->Array:
 var result=[]
 for o in room_objects():result.append(furn_footprint(o))
 if g.room_id=="home":result.append(Rect2(264,343,52,82))
 if g.room_id=="forge":
  result.append(Rect2(558,425,48,28))
 if g.room_id=="throne":
  result.append(Rect2(586,350,68,32))
  for x in [350,710]:result.append(Rect2(x-5,435,42,18))
 return result
func furn_footprint(o:Dictionary)->Rect2:
 # Lower solid volume, not transparent sprite gutters or its projecting top.
 var depth=o.width*(.22 if o.art==3 else .35)
 return Rect2(o.p-Vector2(o.width*.46,depth),Vector2(o.width*.92,depth-5))
func draw_furnishing(o:Dictionary):
 if o.art==0:
  detail(0,o.p,o.width,o.width*.47);return
 if o.art==4:
  detail(1,o.p,o.width,o.width*.60);return
 var r=FURN_RECTS[o.art]
 image_at(FURNISHINGS,r,Vector2(r.get_center().x,r.end.y),o.p,o.width)
func draw_room_floor():
 g.draw_rect(Rect2(Vector2.ZERO,s.ROOM_SIZE),Color("182a30"))
 var warm=g.room_id in ["home","tavern","commission"]
 tile(1 if warm else 0,Rect2(160,260,640,385),110,Color("ddd4bb") if warm else Color("cbd1c5"))
 # Load-bearing walls and a single south doorway share the collision envelope.
 for x in range(150,810,55):
  s.house.material(3,Rect2(x,210,54,70))
  g.draw_style_box(stone_style(Color("a1a38b")),Rect2(x,204,54,15))
 for x in [150,790]:g.draw_style_box(stone_style(Color("68766f")),Rect2(x,260,20,380))
 for r in [Rect2(160,635,280,18),Rect2(520,635,280,18)]:g.draw_style_box(stone_style(Color("9ca18c")),r)
 g.draw_style_box(stone_style(Color("baac8b")),Rect2(440,615,80,30))
 for x in [220,740]:s.furniture(Vector2(x,295),"lamp")
 if g.room_id=="throne":
  g.draw_style_box(stone_style(Color("3b696d")),Rect2(440,285,210,330))
  for x in [446,642]:g.draw_line(Vector2(x,290),Vector2(x,610),Color("bd9e57"),4)
  for x in [350,710]:
   s.house.material(3,Rect2(x,270,32,180))
   g.draw_style_box(stone_style(Color("b5b397")),Rect2(x-5,435,42,18))
 if g.room_id=="training":
  s.house.material(0,Rect2(305,345,330,185))
  g.draw_rect(Rect2(315,355,310,165),Color("bda673"),false,3)
 if g.room_id=="home":
  if s.area.begins_with("home:") and int(g.state.surface.homes[g.state.claim_id].level)>0:
   g.draw_style_box(stone_style(Color("3f777a")),Rect2(365,420,230,115))
   g.draw_rect(Rect2(373,428,214,99),Color("c9ac6e"),false,3)
   for x in range(390,580,35):g.draw_polyline(PackedVector2Array([Vector2(x,439),Vector2(x+9,448),Vector2(x,457),Vector2(x-9,448),Vector2(x,439)]),Color("cab785"),2)
  s.furniture(Vector2(290,420),"bed")
 if g.room_id in ["tavern","forge"]:
  var fire=Vector2(460,330) if g.room_id=="tavern" else Vector2(330,330)
  for r in [35,65,95]:g.draw_circle(fire,r,Color(1,.66,.26,.025+.004*sin(g.clock*4)))
func draw_river():
 g.draw_rect(Rect2(1155,200,160,800),Color("465950"))
 tile(4,Rect2(1170,200,130,800),160)
 for y in range(220,990,34):
  var phase=sin(g.clock*.8+y)*8
  g.draw_line(Vector2(1185+phase,y),Vector2(1275+phase,y+4),Color("609195"),2)
func draw_bridge():
 g.draw_rect(Rect2(1140,648,190,108),Color("302d2b"))
 g.draw_set_transform(Vector2(1140,750)-g.camera.round(),-PI/2)
 tile(1,Rect2(0,0,100,190),190,Color("d6be98"))
 g.draw_set_transform(-g.camera.round())
 for x in range(1144,1330,18):g.draw_line(Vector2(x,650),Vector2(x,750),Color("674c36"),1)
 for y in [649,751]:
  g.draw_line(Vector2(1138,y),Vector2(1332,y),Color("47392e"),9)
  g.draw_line(Vector2(1138,y-3),Vector2(1332,y-3),Color("c3a471"),3)
  for x in [1140,1190,1280,1330]:g.draw_style_box(stone_style(Color("937650")),Rect2(x-6,y-15,12,25))

const TERRAIN=preload("res://assets/world-v50/terrain.png")
func tile(index:int,rect:Rect2,unit:float=160,tint:Color=Color.WHITE):
 var origin=Vector2(index%3,index/3)*512
 var y=rect.position.y
 while y<rect.end.y:
  var x=rect.position.x
  while x<rect.end.x:
   var size=Vector2(minf(unit,rect.end.x-x),minf(unit,rect.end.y-y))
   if Rect2(Vector2(x,y),size).intersects(Rect2(g.camera,Vector2(960,540))):g.draw_texture_rect_region(TERRAIN,Rect2(Vector2(x,y),size),Rect2(origin,size/unit*512),tint)
   x+=unit
  y+=unit

func exterior_objects()->Array:
 if s.area=="claim":return [{"p":Vector2(500,440),"kind":"building","art":0,"width":350.0},{"p":Vector2(1370,760),"kind":"building","art":4,"width":260.0},{"p":Vector2(1280,345),"kind":"landmark","art":0,"width":260.0}]
 if s.area=="trail":return [{"p":Vector2(220,690),"kind":"landmark","art":0,"width":330.0},{"p":Vector2(950,300),"kind":"landmark","art":0,"width":240.0}]
 return []

func speech_overlay():
 if speech=="" or g.clock>speech_until or not ward(s.area) or g.panel_id!="":return
 var lines=PackedStringArray();var line=""
 for word in speech.split(" "):
  if (line+word).length()>52:lines.append(line);line=""
  line+=word+" "
 if line!="":lines.append(line)
 var r=Rect2(28,87,410,26+lines.size()*20)
 g.draw_style_box(stone_style(Color("18373c")),r)
 for i in lines.size():HoldSurface.A.text(g,r.position+Vector2(13,24+i*20),lines[i],14,Color("e4d4b0"))

const DETAILS=preload("res://assets/animation-v51/environment.png")
const DETAIL_RECTS=[Rect2(46,170,468,249),Rect2(562,95,349,331),Rect2(968,156,528,255),Rect2(46,524,424,411),Rect2(530,488,406,460),Rect2(996,596,509,319)]
func detail(index:int,p:Vector2,width:float,height:float=-1):
 var r=DETAIL_RECTS[index]
 if height<0:height=width*r.size.y/r.size.x
 g.draw_texture_rect_region(DETAILS,Rect2(p-Vector2(width/2,height),Vector2(width,height)),r)
