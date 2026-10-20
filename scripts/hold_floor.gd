class_name HoldFloorPlan
extends RefCounted
# Painted districts share measured floor landmarks. Collision and interactions use
# these coordinates rather than an unrelated diagram laid over the artwork.
const WORLD=Vector2(1880,1080)
const PLATES=[preload("res://assets/hold-v39/crownward.png"),preload("res://assets/hold-v39/hearthward.png"),preload("res://assets/hold-v39/forgeward.png")]
const POS=[Vector2(216,345),Vector2(564,345),Vector2(724,637),Vector2(1020,775),Vector2(1259,345),Vector2(331,906),Vector2(1636,878)]
const DOOR_POINTS={1:Vector2(564,345),4:Vector2(1259,345),7:Vector2(216,345),8:Vector2(564,345),9:Vector2(897,345),10:Vector2(1259,345),12:Vector2(1630,345),13:Vector2(1690,645),15:Vector2(564,345),17:Vector2(1259,345)}
const OBSTACLES=[Rect2(618,416,218,205),Rect2(208,715,245,175),Rect2(1600,420,160,194)]
# Painted doors without a room behind them must never look like quest locks.
const WIP_DOORS={0:[Vector2(216,345),Vector2(897,345),Vector2(1630,345)],2:[Vector2(216,345),Vector2(897,345),Vector2(1630,345)]}
static func point(i:int)->Vector2:
 if i==10:return Vector2(724,637)
 if i in [11,19]:return Vector2(331,906)
 if i%7==6:return Vector2(1636,878)
 return DOOR_POINTS.get(i,POS[i%7])
static func door(i:int)->Vector2:return DOOR_POINTS.get(i,point(i))
static func building(i:int)->Rect2:return Rect2(door(i)-Vector2(100,130),Vector2(200,145))
static func walkable(p:Vector2,_floor:int)->bool:
 if not Rect2(183,326,1550,595).has_point(p):return false
 for obstacle in OBSTACLES:
  if obstacle.grow(9).has_point(p):return false
 # Stone plinth, actual lift pillars, and stair rails cannot be walked through.
 if ((p-Vector2(1190,585))/Vector2(139,71)).length()<1:return false
 if Rect2(1450,673,58,190).has_point(p) or Rect2(1750,665,55,210).has_point(p):return false
 return true
static func plaque(m,p:Vector2,title:String,color:Color=Color("ecd6a5")):
 var w=ThemeDB.fallback_font.get_string_size(title,HORIZONTAL_ALIGNMENT_LEFT,-1,16).x+24
 m.draw_style_box(m.map_plaque,Rect2(p-Vector2(w/2,23),Vector2(w,32)))
 m.text_at(p,title,16,color,true)
static func draw(m):
 var cam=m.floor_camera;var level=m.level
 m.draw_rect(Rect2(0,0,960,540),Color("0b1922"));m.draw_set_transform(-cam)
 m.draw_texture_rect(PLATES[level],Rect2(Vector2.ZERO,WORLD),false)
 # Very slight light animation belongs to the painted machinery, never the actor.
 if level==1:
  m.draw_circle(Vector2(1190,551),22,Color(1,.55,.2,.045+.018*sin(m.clock*4)))
 elif level==2:
  m.draw_circle(Vector2(1206,513),18,Color(.3,1,1,.025+.012*sin(m.clock*2)))
 for p in WIP_DOORS.get(level,[]):
  plaque(m,p+Vector2(0,-93),"WIP · Unopened wing",Color("dfb994"))
 for i in HoldDistrictMap.DOORS:
  if i/7!=level:continue
  var p=door(i);var d=HoldDistrictMap.DOORS[i]
  plaque(m,p+Vector2(0,-93),d.name)
  m.draw_line(p+Vector2(-24,10),p+Vector2(24,10),Color("baa376"),2)
  if m.marks.get(i,"")!="":
   var ready=m.marks[i]=="ready"
   plaque(m,p+Vector2(0,-57),"✓" if ready else "!" if m.marks[i]=="offer" else "…",Color("a9e4c4") if ready else Color("f1ce80"))
 var portals=[2,5] if level==0 else [10,11] if level==1 else [16,19]
 for i in portals:
  var name="Royal stair" if i in [2,10] else "Forge stair" if i in [11,19] else "Gallery stair"
  plaque(m,point(i)+Vector2(0,35),name)
 plaque(m,point(level*7+6)+Vector2(0,27),"Hold lift")
 if m.destination>=0:
  var target=door(m.destination) if m.destination/7==level else point(10 if level==1 and m.destination/7==0 else 11 if level==1 else 2 if level==0 else 19)
  m.draw_arc(target,27,0,TAU,32,Color("a4dcc4"),2)
 var profile=m.g.state.appearance.duplicate();profile.gait_time=m.gait
 var p=m.floor_pos
 m.draw_set_transform(p-cam,0,Vector2(1,.26));m.draw_circle(Vector2.ZERO,16,Color(0,0,0,.3))
 HoldCharacterArt.draw_sprite(m,p-cam,m.gait,m.walking and not m.paused,m.face,profile,false,Vector2.ZERO,false,.8)
 m.draw_set_transform(Vector2.ZERO)
 if m.destination>=0:
  var label=HoldDistrictMap.DOORS[m.destination].name
  var target=door(m.destination) if m.destination/7==level else point(10 if level==1 and m.destination/7==0 else 11 if level==1 else 2 if level==0 else 19)
  if not Rect2(cam+Vector2(25,92),Vector2(910,338)).has_point(target):
   var screen=(target-cam).clamp(Vector2(80,103),Vector2(880,425))
   plaque(m,screen,"◆ "+label,Color("a4dcc4"))
static func overview(m):
 m.draw_rect(Rect2(0,0,960,540),Color("0b1822"))
 for floor in 3:
  var r=Rect2(22,79+124*floor,916,112)
  m.draw_style_box(m.map_plaque,r)
  m.draw_texture_rect(PLATES[floor],Rect2(r.position+Vector2(6,6),Vector2(178,100)),false)
  m.text_at(r.position+Vector2(202,28),HoldDistrictMap.NAMES[floor],20,Color("ecd6a5"))
  m.text_at(r.position+Vector2(202,51),["Oaths, archives and the royal hall","Hearths, trade and the expedition table","Tools, training and the great drive"][floor],14,Color("acc8c8"))
  if WIP_DOORS.has(floor):m.text_at(r.position+Vector2(780,51),"3 wings · WIP",13,Color("dfb994"))
  var x=224.0
  for i in HoldDistrictMap.DOORS:
   if i/7!=floor:continue
   var d=HoldDistrictMap.DOORS[i]
   var label=HoldDistrictMap.overview_name(i)
   var width=ThemeDB.fallback_font.get_string_size(label,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+18
   var chip=Rect2(x,r.position.y+70,width,28)
   m.draw_style_box(m.map_plaque,chip)
   m.text_at(chip.position+Vector2(8,19),label,13,Color("a9e4c4") if m.destination==i else Color("dfd4b9"))
   x+=width+5
  if m.level==floor:m.text_at(r.position+Vector2(780,28),"YOU ARE HERE",12,Color("a9e4c4"))
