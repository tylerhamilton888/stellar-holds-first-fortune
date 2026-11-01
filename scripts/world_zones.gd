class_name HoldWorldZones
extends RefCounted
# One authored world layout drives doors, footprints, routes, art and wayfinding.
const WARDS=["crownward","hearthward","forgeward"]
const ROYAL=Vector2(180,850)
const FORGE=Vector2(1700,850)
const LIFT=Vector2(1700,550)
const GATE=Vector2(1570,450)
const DOORS={1:Vector2(960,460),4:Vector2(1380,950),7:Vector2(350,450),8:Vector2(780,450),9:Vector2(1230,450),10:Vector2(970,790),12:Vector2(1450,950),13:GATE,15:Vector2(580,450),17:Vector2(1250,450)}
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
var view_area=""
var view_offset=Vector2.ZERO
var routines
func _init(surface):surface_ref=weakref(surface);g=surface.g;routines=HoldRoutines.new(self)
func current_area()->String:return s.area if view_area=="" else view_area
func view_camera()->Vector2:return g.camera-view_offset
static func ward(id:String)->bool:return id in WARDS
static func door(i:int)->Vector2:return DOORS[i]
func buildings(area_id:String="")->Array:
 if area_id=="":area_id=current_area()
 var ward_level=WARDS.find(area_id)
 var result=[]
 for i in HoldDistrictMap.DOORS:
  if int(i)/7!=ward_level or i in [10,13]:continue
  var kind={1:3,4:5,7:0,8:1,9:2,12:6,15:4,17:7}[i]
  result.append({"p":door(i),"kind":"building","art":kind,"width":400.0 if i==1 else 370.0 if i in [8,15] else 310.0,"id":i})
 # Enterable family galleries replace the closed houses which overlapped streets.
 if area_id=="crownward":result.append({"p":Vector2(350,450),"kind":"building","art":0,"width":310.0,"id":-1})
 result.append_array(HoldNeighborhood.buildings(area_id))
 for b in result:HoldBuildingPlans.bind(b,area_id)
 return result
static func building_footprint(b:Dictionary)->Rect2:return HoldBuildingArt.footprint(b)
static func facade_index(b:Dictionary)->int:return {0:0,1:1,2:2,3:3,4:4,5:5,6:5,7:3}[b.art]
static func building_rect(b:Dictionary)->Rect2:
 var i=facade_index(b);var source=FACADE_RECTS[i];var scale=b.width/source.size.x
 return Rect2(b.p-(FACADE_DOORS[i]-source.position)*scale,source.size*scale)
func obstacles(area_id:String="")->Array:
 if area_id=="":area_id=current_area()
 if collision_cache.has(area_id):return collision_cache[area_id].duplicate()
 var result=HoldNeighborhood.obstacles()
 if area_id=="hearthward":
  result.append_array([Rect2(GATE-Vector2(155,255),Vector2(310,195)),Rect2(GATE-Vector2(155,60),Vector2(55,80)),Rect2(GATE+Vector2(100,-60),Vector2(55,80))])
 for b in buildings(area_id):result.append(building_footprint(b))
 # Central memorial fountain has a tangible basin, with broad streets around it.
 if area_id=="hearthward":result.append(Rect2(895,595,150,70))
 for o in landmarks(area_id):
  if o.art in [1,2]:result.append_array(HoldNeighborhood.stair_rails(o.p))
  elif o.art in [0,4]:
   for side in [-1,1]:
    if o.art==0:result.append(Rect2(o.p+Vector2(side*o.width*.32-o.width*.14,-o.width*.34),Vector2(o.width*.28,o.width*.42)))
    else:result.append(Rect2(o.p+Vector2(side*o.width*.4-10,-o.width*.6),Vector2(20,o.width*.6)))
  elif o.art==5:result.append(Rect2(o.p-Vector2(50,20),Vector2(100,20)))
 for o in street_furnishings(area_id):result.append(furn_footprint(o))
 result.append_array(HoldTerraces.rails(area_id))
 collision_cache[area_id]=result
 return result.duplicate()
func points()->Array:
 var result=[]
 for i in HoldDistrictMap.DOORS:
  if int(i)/7!=s.level():continue
  var d=HoldDistrictMap.DOORS[i];var action="room:"+d.id
  if i==7 and HoldFirstVisit99.lodge_intro(g.state):action=HoldWorkerLodge100.ROOM
  elif i==10:action="anniversary"
  elif i==13:action="trail"
  elif i==17:action="room:practice"
  result.append({"p":door(i),"name":"King's Gate · High Trail" if i==13 else d.name,"action":action})
 result.append({"p":LIFT,"name":"Hold lift","action":"hold_lift"})
 if s.area=="hearthward":
  result.append({"p":ROYAL,"name":"Royal service stair · Crownward","action":"crownward"})
  result.append({"p":FORGE,"name":"Forge service stair · Forgeward","action":"forgeward"})
 else:result.append({"p":ROYAL if s.area=="crownward" else FORGE,"name":"Stairs · Hearthward","action":"hearthward"})
 for b in buildings():
  if b.has("home"):result.append({"p":b.p,"name":HoldNeighborhood.title(b.home),"action":b.home})
  elif b.id==-1:result.append({"p":b.p,"name":"Hall of Names · household archive","action":HoldHouseholds.ARCHIVE})
 result.append_array(HoldTerraces.points(s.area))
 result.append_array(HoldWardDesign.points(s.area))
 for c in people():result.append({"p":c.p,"name":c.name+" · "+c.role,"action":c.get("interaction","citizen:"+str(c.index))})
 return result
func arrival(old:String,id:String)->Vector2:
 if old=="room:home" and id==HoldWorkerLodge100.ROOM:return HoldWorkerLodge100.RETURN_FROM_ROOM
 if old in ["room:tavern",HoldHouseholds.LOFT] and id in ["room:tavern",HoldHouseholds.LOFT]:return HoldHouseholds.KETTLE_STAIR+Vector2(0,30)
 if HoldNeighborhood.is_home(old):
  var p=HoldNeighborhood.parts(old)
  if HoldNeighborhood.is_home(id):return HoldNeighborhood.STAIR+Vector2(0,30)
  if id==p[0]:return HoldNeighborhood.home_door(int(p[1]))+Vector2(0,35)
 if ward(old) and ward(id):
  if old=="crownward" or id=="crownward":return ROYAL+Vector2(0,30)
  return FORGE+Vector2(0,30)
 if old=="trail" and id=="hearthward":return GATE-Vector2(0,40)
 if id=="trail":
  return {"hearthward":Vector2(245,690),"claim":Vector2(1600,700),"pinewood":Vector2(470,885)}.get(old,Vector2(245,690))
 return Vector2.INF
func people(at_time:float=-1,area_id:String="")->Array:
 if area_id=="":area_id=current_area()
 if not ward(area_id):return []
 if at_time<0 and people_frame==Engine.get_process_frames() and people_area==area_id:return people_cache
 var floor_index=WARDS.find(area_id)
 var time=g.state.elapsed if at_time<0 else at_time
 var route=[Vector2(270,530),Vector2(780,530),Vector2(1140,530),Vector2(1140,570),Vector2(780,570),Vector2(780,680),Vector2(270,680)]
 var names=[["Yrsa","Hakon","Inga","Viggo","Tova","Arvid"],["Runa","Torsten","Sigrid","Dori","Edda","Brynjar"],["Kara","Tormund","Hilda","Odd","Alva","Gunnar"]][floor_index]
 var roles=HoldWardDesign.roles(area_id)
 var result=[]
 var cycle=3.0*route.size()
 for j in route.size():cycle+=route[j].distance_to(route[(j+1)%route.size()])/62.0
 for i in 6:
  var phase=fposmod(time+i*19+floor_index*11,cycle);var p=route[0];var aim=Vector2.DOWN;var walking=false;var distance=0.0
  for j in route.size():
   var a=route[j];var b=route[(j+1)%route.size()];var duration=a.distance_to(b)/62.0
   if phase<3:p=a;aim=(b-a).normalized();break
   phase-=3
   if phase<duration:p=a.lerp(b,phase/duration);aim=(b-a).normalized();walking=true;distance+=phase*62.0;break
   phase-=duration;distance+=a.distance_to(b);p=b
  var key=str(g.state.seed_value)+":"+str(floor_index)+":"+str(i)
  if not profiles.has(key):profiles[key]=HoldAppearance.random_profile(g.state.seed_value+5100+i+floor_index*101,1 if i%3==0 else 0)
  var profile=profiles[key]
  result.append({"p":p,"kind":"citizen","profile":profile,"aim":aim,"walking":walking,"name":names[i],"role":roles[i],"index":i,"time":time+i*.7,"gait":HoldDrawnLocomotion.time_for_distance(distance)+i*.13})
 result.append_array(routines.people(area_id,time))
 if at_time<0:people_cache=result;people_frame=Engine.get_process_frames();people_area=area_id
 return result
func speak(index:int):
 if index>=6:
  speech=HoldNeighborhood.resident(self,index-6,Vector2.ZERO).name+" · "+["Come warm your hands by our hearth. The upper rooms are just up the stair.","Three wards, one mountain. Follow the bridge south to our family gallery.","My family has kept this hearth for generations. The lower forges never quite fall silent."][index-6];speech_until=g.clock+8;return
 var lines=["A good hold is built one sound stone at a time. The royal stair is on the western terrace.","I keep these lamps lit. The eastern lift serves all three wards.","Ivar keeps the shift book southeast of the fountain. Orla trades on the north street.","The Copper Kettle is on the north street. Hedrik always has a warm hearth.","Borin works below in Forgeward. Cross the south gallery bridge, then take the Great Stair at its eastern end.","Through King's Gate: the Old Workings north, Pinewood south, your mountain claim east."]
 speech=people()[index].name+" · "+lines[index];speech_until=g.clock+8
 g.notify("A word from "+people()[index].name+". Keep walking whenever you like.")
func draw_citizen(c:Dictionary):
 if not Rect2(view_camera()-Vector2(80,0),Vector2(1120,650)).has_point(c.p):return
 var cam=view_camera().round()
 g.draw_set_transform(c.p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,17,Color(0,0,0,.25))
 HoldDrawnAnimation.paint(g,c.p-cam,c.profile,c.aim,c.walking,c.gait,.85,-cam,c.get("pose","town_walk"),c.get("phase",0.0))
 g.draw_set_transform(-cam)
func draw_ground():
 HoldWardDesign.mountain(self)
 tile(0,Rect2(80,180,1720,840),100,Color("aab5ae") if current_area()=="forgeward" else Color("d3d4bd"))
 if current_area()=="crownward":HoldGrounding.cover(g,VAULT,Rect2(45,-365,1790,597),Rect2(Vector2.ZERO,VAULT.get_size()))
 else:
  HoldMasonryArt.wall(g,Rect2(80,140,1720,65))
 # The inhabited wards sit beneath the ancestral mountain vault.
 # Broad shadow and coping follow the collision envelope, without thin repeated strips.
 for x in range(90,1780,170):
  # Northern boundary is the vault footing, aligned with the walkable limit.
  pass # The former southern coping is now the open gallery connection.
 for side in [80,1780]:
  g.draw_rect(Rect2(side-12,207,30,790),Color("28383b"))
  g.draw_line(Vector2(side,208),Vector2(side,995),Color("8a9384"),8)
  g.draw_line(Vector2(side+5,208),Vector2(side+5,995),Color("c0b793"),2)
  for y in [330,580,830]:detail(4,Vector2(side,y),58,90)
 for y in [520,740,980]:
  g.draw_line(Vector2(115,y),Vector2(1770,y),Color("6d786a"),3)
 HoldNeighborhood.draw_gallery(self)
 HoldWardDesign.ground(self);HoldWardDesign.light_pools(self)
 HoldWardDesign.boundary(self)
 HoldKeldrathArt.structure(self)
 HoldGrounding.gate_footing(self)
func draw_lower_gallery():
 # Clip the actual neighboring ward's architecture through the open floor.
 # No second simulation, viewport, texture readback, or off-floor actor updates.
 var below=WARDS.find(current_area())+1
 if below>=WARDS.size():return
 # Project one storey's drop into screen Y; world XY and stair links stay shared.
 var offset=Vector2(0,650)
 var tint=Color(.48,.54,.59,1)
 for opening in [Rect2(110,1028,760,94),Rect2(1050,1028,720,94)]:
  var floor_rect=Rect2(80,180,1720,840);floor_rect.position+=offset
  var visible=floor_rect.intersection(opening)
  if visible.has_area():tile(0,visible,100,Color("515e5c"))
  for b in buildings(WARDS[below]):
   var dest=HoldKeldrathArt.rect(b);dest.position+=offset
   var clip=dest.intersection(opening)
   if not clip.has_area():continue
   var art=HoldKeldrathArt.source(b);var source=art.rect
   var ratio=source.size/dest.size
   var crop=Rect2(source.position+(clip.position-dest.position)*ratio,clip.size*ratio)
   g.draw_texture_rect_region(art.texture,clip,crop,tint)
  g.draw_rect(opening,Color(.025,.055,.09,.22))
func street_furnishings(area_id:String="")->Array:
 return HoldWardDesign.furnishings(self,current_area() if area_id=="" else area_id)
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
 if not rect.intersects(Rect2(view_camera(),Vector2(960,540))):return
 var alpha=.35 if fade and current_area()==s.area and rect.has_point(g.player) and g.player.y<p.y-25 else 1.0
 g.draw_texture_rect_region(tex,rect,source,Color(1,1,1,alpha))
func draw_building(b:Dictionary):HoldBuildingArt.draw(self,b)
func landmarks(area_id:String="")->Array:
 if area_id=="":area_id=current_area()
 var result=[{"p":LIFT,"kind":"landmark","art":4,"width":125.0}]
 if area_id=="hearthward":result.append({"p":Vector2(970,665),"kind":"landmark","art":3,"width":180.0})
 if area_id in ["hearthward","crownward"]:result.append({"p":ROYAL,"kind":"landmark","art":1 if area_id=="hearthward" else 2,"width":150.0})
 if area_id in ["hearthward","forgeward"]:result.append({"p":FORGE,"kind":"landmark","art":2 if area_id=="hearthward" else 1,"width":150.0})
 if area_id=="hearthward":result.append({"p":GATE,"kind":"landmark","art":0,"width":240.0})
 return result
func draw_landmark(o:Dictionary):
 if o.art in [1,2]:HoldNeighborhood.draw_stairs(self,o.p,o.art==1);return
 image_at(LANDMARKS,LAND_RECTS[o.art],LAND_ANCHORS[o.art],o.p,o.width,o.art in [0,3,5])
 if o.art==3:
  var rect=Rect2(o.p-Vector2(o.width*.5,o.width*.82),Vector2(o.width,o.width*.85))
  if rect.intersects(Rect2(view_camera(),Vector2(960,540))):HoldAmbientProps.fountain(g,o.p,g.clock,o.width/180.0,.35 if current_area()==s.area and rect.has_point(g.player) and g.player.y<o.p.y-25 else 1.0)
func room_objects(area_id:String="")->Array:
 if area_id=="":area_id=s.area
 if HoldBuildingPlans.owned_room(area_id):return []
 return HoldBuildingPlans.contents(self,area_id).filter(func(o):return o.furnishing!="chest" or not g.state.surface.chests.values().any(func(c):return c.area==area_id and Vector2(c.x,c.y)==o.p))
func definition_objects(area_id:String="")->Array:
 if area_id=="":area_id=s.area
 if area_id=="room:throne":return [furn("desk",245,625),furn("bookcase",245,535),furn("chair",245,680),furn("orrery",1040,625),furn("tea_table",1040,840),furn("chair",1040,890)]
 if HoldNeighborhood.is_home(area_id):return HoldNeighborhood.room_objects(self,area_id)
 if area_id in [HoldHouseholds.LOFT,HoldHouseholds.ARCHIVE]:return HoldHouseholds.special_objects(self,area_id)
 var result=[];var id=area_id.trim_prefix("room:") if area_id.begins_with("room:") else "home"
 if id=="tavern":
  result=[furn("hearth",330,345),furn("counter",620,450),furn("bookcase",480,330)]
  for x in [270,440,610]:
   result.append(furn("table",x,525));result.append(furn("chair",x-47,540))
 elif id in ["forge","practice"]:result=[furn("hearth",330,360),furn("desk",700,355),furn("bookcase",450,335)]
 elif id=="market":result=[furn("counter",410,390),furn("bookcase",305,335),furn("bookcase",705,335)]
 elif id in ["commission","research"]:result=[furn("desk",620,365),furn("bookcase",270,345),furn("bookcase",345,345)]
 elif id=="training":result=[furn("desk",660,570)]
 elif id=="lodge":result=HoldWorkerLodge100.furnishings(self)
 elif id=="home":
  result=[furn("bed",290,420),furn("desk",735,515),furn("hearth",440,335)]
  if not HoldFirstVisit99.lodge_intro(g.state):result.append(furn("table",650,330))
 for x in [220,740]:result.append(furn("lamp",x,305))
 result.append_array(HoldRoomLayout.objects(self,area_id))
 result.append_array(s.roads.furnishings(area_id))
 return result
func furn(kind:String,x:float,y:float)->Dictionary:
 var result={"kind":"furnishing","furnishing":{"table":"tea_table","counter":"serving_counter"}.get(kind,kind),"p":Vector2(x,y)}
 if HoldFurnishings.ITEMS.get(kind,{}).has("sort_offset"):result.sort_y=y+HoldFurnishings.ITEMS[kind].sort_offset
 return result
func room_obstacles(area_id:String="")->Array:
 if area_id=="":area_id=s.area
 var result=[]
 if HoldCivicArt.has_exit(area_id):result.append_array(HoldCivicArt.exit_sides(area_id))
 for o in room_objects(area_id):
  var r=furn_footprint(o)
  if r.has_area():result.append(r)
 if HoldBuildingPlans.has_stairs(area_id):
  result.append_array(HoldNeighborhood.stair_rails(HoldBuildingPlans.stair_position(area_id),96))
  if HoldBuildingPlans.floor_number(area_id)>0:
   var r=HoldRoomLayout.floor_rect(area_id);result.append(Rect2(r.position.x,r.end.y-30,r.size.x,30))
 return result
func furn_footprint(o:Dictionary)->Rect2:return HoldFurnishings.footprint(o.furnishing,o.p)
func draw_furnishing(o:Dictionary):
 # Borin draws the shared anvil immediately after his hammer pose.
 if s.area=="room:forge" and o.furnishing=="anvil":return
 # Active public lockboxes are rendered by the persistent storage system once.
 if o.furnishing=="chest" and ward(current_area()) and current_area()==s.area and HoldWardDesign.STORES.get(s.area,[]).has(o.p):return
 HoldFurnishings.draw(g,o.p,o.furnishing)
 if s.area=="room:forge" and o.furnishing=="worktable":
  var index=[Vector2(970,550),Vector2(970,755),Vector2(680,755)].find(o.p)
  if index>=0:
   var plan=routines.plans[index*3];var stance=o.p-Vector2(65,20)
   var impact=HoldWholeFrames.tool_tip(plan.person.profile,Vector2.RIGHT,"hammer",.6)*.85
   g.handworks.raw_sprite({"kind":"stone"},stance+impact+Vector2(0,7),22)

func draw_room_floor():HoldBuildingArt.room_floor(self,s.area)
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
 if index in [0,1]:HoldFloorPattern.draw(g,rect,index==1,tint);return
 var origin=Vector2(index%3,index/3)*512
 var y=rect.position.y
 while y<rect.end.y:
  var x=rect.position.x
  while x<rect.end.x:
   var size=Vector2(minf(unit,rect.end.x-x),minf(unit,rect.end.y-y))
   if Rect2(Vector2(x,y),size).intersects(Rect2(view_camera(),Vector2(960,540))):g.draw_texture_rect_region(TERRAIN,Rect2(Vector2(x,y),size),Rect2(origin,size/unit*512),tint)
   x+=unit
  y+=unit

func exterior_objects()->Array:
 if HoldFrontier103.active(g.state):
  if s.area=="claim" or s.area=="trail":return [{"p":HoldMineEntrance.position(s.area),"kind":"mine_entrance"}]
 if s.area=="claim":return [HoldBuildingPlans.instance("cottage",Vector2(500,440)),HoldBuildingPlans.instance("workshop",Vector2(1370,760)),{"p":HoldMineEntrance.position("claim"),"kind":"mine_entrance"}]
 if s.area=="trail":return [{"p":Vector2(220,690),"kind":"landmark","art":0,"width":330.0},{"p":HoldMineEntrance.position("trail"),"kind":"mine_entrance"}]
 return []

func speech_overlay():
 if speech=="" or g.clock>speech_until or g.panel_id!="":return
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
 if index==4:
  HoldMasonryArt.pillar(g,p,height if height>0 else width*2.3);return
 var r=DETAIL_RECTS[index]
 if height<0:height=width*r.size.y/r.size.x
 g.draw_texture_rect_region(DETAILS,Rect2(p-Vector2(width/2,height),Vector2(width,height)),r)

func draw_neighbors():
 var active=s.area
 for id in ["forgeward","hearthward","crownward"]:
  if id==active or abs(WARDS.find(id)-WARDS.find(active))>1:continue
  var offset=HoldTerraces.origin(id)-HoldTerraces.origin(active)
  if not Rect2(offset+Vector2(0,-420),Vector2(1880,2100)).intersects(Rect2(g.camera,Vector2(960,540))):continue
  view_area=id;view_offset=offset;g.draw_set_transform(offset-g.camera.round())
  draw_ground()
  var neighbors=routines.people(id,g.state.elapsed).filter(func(c):return not HoldTerraces.on_stair(id,c.p))
  var objects=buildings()+landmarks()+street_furnishings()+neighbors
  objects.sort_custom(func(a,b):return (building_footprint(a).end.y if a.kind=="building" else a.p.y)<(building_footprint(b).end.y if b.kind=="building" else b.p.y))
  for o in objects:
   g.draw_set_transform(offset-g.camera.round())
   if o.kind=="building":draw_building(o)
   elif o.kind=="landmark":draw_landmark(o)
   elif o.kind=="furnishing":draw_furnishing(o)
   elif o.kind=="citizen":draw_citizen(o)
 view_area="";view_offset=Vector2.ZERO;g.draw_set_transform(-g.camera.round())
func neighbor_stair_people()->Array:
 # A shared flight is foreground floor. Its far-half residents must join the
 # active actor sort, after the treads, rather than be buried by the next plate.
 var result=[]
 for id in WARDS:
  if id==s.area or abs(WARDS.find(id)-WARDS.find(s.area))!=1:continue
  var offset=HoldTerraces.origin(id)-HoldTerraces.origin(s.area)
  for c in routines.people(id,g.state.elapsed):
   if not HoldTerraces.on_stair(id,c.p):continue
   c.p+=offset
   if Rect2(g.camera-Vector2(80,80),Vector2(1120,700)).has_point(c.p):result.append(c)
 return result
func navigation_clear(area_id:String,p:Vector2)->bool:
 if ward(area_id):
  if HoldTerraces.envelope(area_id,p):return HoldTerraces.on_stair(area_id,p)
  if not HoldNeighborhood.BOUNDS.has_point(p):return false
  for r in obstacles(area_id):
   if r.grow(11).has_point(p):return false
  return true
 if not HoldRoomLayout.bounds(area_id).has_point(p):return false
 for r in room_obstacles(area_id):
  if r.grow(11).has_point(p):return false
 return true

