class_name HoldTroll133
extends RefCounted
# Whole painted poses and their measured foot/fist anchors share one contact model.
const ART=[preload("res://assets/trolls133/front.png"),preload("res://assets/trolls133/side.png"),preload("res://assets/trolls133/back.png")]
const FRONT_OPPOSITE=preload("res://assets/trolls133/front-opposite.png")
const BACK_OPPOSITE=preload("res://assets/trolls133/back-opposite.png")
const BOXES=[
 [[45,96,319,338],[428,91,319,346],[799,92,339,345],[1192,35,315,403],[31,617,353,314],[424,529,331,405],[776,619,327,309],[1130,694,396,191]],
 [[53,103,272,353],[421,100,289,353],[792,103,296,350],[1172,49,318,407],[28,640,353,305],[412,532,280,413],[739,655,338,289],[1105,753,414,182]],
 [[44,101,310,331],[426,101,315,333],[808,101,310,335],[1184,35,321,398],[20,629,338,295],[415,532,320,396],[770,622,326,310],[1131,697,393,191]]]
const ROOTS=[
 [Vector2(198,417),Vector2(568,418),Vector2(973,417),Vector2(1354,417),Vector2(159,909),Vector2(564,916),Vector2(919,904),Vector2(1310,870)],
 [Vector2(174,439),Vector2(558,435),Vector2(936,435),Vector2(1301,438),Vector2(158,928),Vector2(537,928),Vector2(854,928),Vector2(1307,921)],
 [Vector2(182,414),Vector2(578,417),Vector2(977,418),Vector2(1350,417),Vector2(151,903),Vector2(560,910),Vector2(915,913),Vector2(1310,874)]]
const FISTS=[[Vector2(333,914),Vector2(957,914)],[Vector2(330,922),Vector2(1028,923)],[Vector2(315,910),Vector2(954,917)]]
const HEIGHTS=[318.0,333.0,310.0]
const RADIUS=32.0
const FIRST_WINDUP=1.45
const SECOND_WINDUP=1.1
const STEP_TIME=.45
const BETWEEN=.6
const RECOVERY=1.8
static func room(f,p:Vector2)->bool:
 if not f.body_open(p,float(HoldEnemyRoster.spec(3).body)):return false
 var exits=0
 for i in 8:
  var q=p+Vector2.from_angle(i*TAU/8)*120
  if f.body_open(q,f.PLAYER_BODY) and f.clear(p,q):exits+=1
 return exits>=4
static func fit_spawn(f,p:Vector2):
 # Old encounter anchors may fit the former body but not the enlarged one.
 # Preserve identity and wounds; never excavate terrain or move player property.
 if f.body_open(p,float(HoldEnemyRoster.spec(3).body)):return p
 for radius in range(20,321,20):
  for i in 16:
   var q=p+Vector2.from_angle(i*TAU/16)*radius
   if f.body_open(q,float(HoldEnemyRoster.spec(3).body)) and f.clear(p,q):return q
 return null
static func scale_for(row:int)->float:return float(HoldEnemyRoster.spec(3).height)/HEIGHTS[row]
static func frame(e:Dictionary)->int:
 if e.hp<=0:return 7
 if e.state=="windup":
  if e.has("slam_total133") and float(e.slam_total133)-e.time<STEP_TIME:return [1,0,2,0][int(e.gait*10)%4]
  return 3 if int(e.get("fist133",0))==0 else 5
 if e.state=="recover" and float(e.get("slam_contact133",0))>0:return 4 if int(e.get("fist133",0))==0 else 6
 if e.walk:return [1,0,2,0][int(e.gait*10)%4]
 return 0
static func region(e:Dictionary,direction:Vector2)->Dictionary:
 var row=HoldEnemyRoster.row(direction);var f=frame(e);var b=BOXES[row][f]
 if f==2 and row!=1:
  var texture=FRONT_OPPOSITE if row==0 else BACK_OPPOSITE
  return {"texture":texture,"source":Rect2(Vector2.ZERO,texture.get_size()),"root":Vector2(615,1108) if row==0 else Vector2(630,1015),"scale":float(HoldEnemyRoster.spec(3).height)/(1022.0 if row==0 else 965.0)}
 return {"texture":ART[row],"source":Rect2(b[0],b[1],b[2],b[3]),"root":ROOTS[row][f],"scale":scale_for(row)}
static func fist_offset(direction:Vector2,hand:int)->Vector2:
 var row=HoldEnemyRoster.row(direction);var f=4 if hand==0 else 6
 var offset=(FISTS[row][hand]-ROOTS[row][f])*scale_for(row)
 offset.x*=(-1 if direction.x<0 else 1)
 return offset
static func begin(f,e:Dictionary,follow:bool=false)->bool:
 var g=f.g;var direction:Vector2=(g.player-e.p).normalized()
 if direction==Vector2.ZERO:direction=e.dir
 var hand=1 if follow else 0
 var offset=fist_offset(direction,hand)
 var travel:Vector2=(g.player-offset-e.p).limit_length(160)
 var to:Vector2=f.push_body(e.p,travel,travel.length(),float(HoldEnemyRoster.spec(3).body))
 for other in f.enemies:
  if other!=e and other.hp>0 and to.distance_to(other.p)<float(HoldEnemyRoster.spec(3).body)+float(HoldEnemyRoster.spec(other.kind).body)+8:return false
 var target=to+offset
 if target.distance_to(g.player)>RADIUS+f.PLAYER_BODY or not f.clear(to,target):return false
 e.dir=direction;e.fist133=hand;e.slam_from133=e.p;e.slam_to133=to;e.slam_target133=target
 e.slam_total133=SECOND_WINDUP if follow else FIRST_WINDUP
 e.state="windup";e.time=e.slam_total133;e.slam_follow133=not follow;e.slam_contact133=0.0;e.walk=false
 return true
static func contact(e:Dictionary)->Vector2:return e.get("slam_target133",e.p+fist_offset(e.dir,int(e.get("fist133",0))))
static func hits(f,e:Dictionary)->bool:
 return f.g.player.distance_to(contact(e))<=RADIUS+f.PLAYER_BODY and f.clear(e.p,contact(e)) and f.clear(contact(e),f.g.player)
static func tick(f,e:Dictionary,dt:float)->bool:
 e.slam_contact133=maxf(0,float(e.get("slam_contact133",0))-dt)
 if e.state=="windup":
  # Legacy transient poses have no committed target. Start a fresh visible warning.
  if not e.has("slam_target133"):
   if not begin(f,e):e.state="idle"
   return true
  e.time-=dt
  var t=clampf((float(e.slam_total133)-e.time)/STEP_TIME,0,1)
  var next:Vector2=e.slam_from133.lerp(e.slam_to133,smoothstep(0,1,t))
  if not f.body_open(next,float(HoldEnemyRoster.spec(3).body)) or not f.clear(e.p,next):
   e.state="recover";e.time=RECOVERY;e.slam_follow133=false;return true
  e.gait+=e.p.distance_to(next)/185;e.p=next
  if e.time<=0:
   e.p=e.slam_to133;e.state="recover";e.time=BETWEEN if e.slam_follow133 else RECOVERY;e.slam_contact133=.3
   f.impact(contact(e),.065,Color("dec09a"),true);f.g.sound.effect("stone",-12)
   if hits(f,e):f.receive(e)
  return true
 if e.state=="recover":
  e.time-=dt
  if e.time<=0:
   if bool(e.get("slam_follow133",false)) and e.p.distance_to(f.g.player)<240 and begin(f,e,true):return true
   e.slam_follow133=false;e.state="idle"
  return true
 return false
static func draw_warning(g,e:Dictionary):
 if e.hp<=0:return
 var at=contact(e)
 if e.state=="windup":
  var total=float(e.get("slam_total133",FIRST_WINDUP));var phase=clampf(1-e.time/total,0,1)
  g.draw_circle(at,RADIUS,Color(1,.55,.12,.20))
  g.draw_arc(at,RADIUS,0,TAU,40,Color("ffd184"),2.5,true)
  g.draw_arc(at,RADIUS+7,-PI/2,-PI/2+TAU*phase,40,Color("fff0c0"),3,true)
  for x in [-1,1]:g.draw_line(at+Vector2(x*9,-6),at+Vector2(x*9,6),Color("ffd184"),2)
 elif e.state=="recover" and float(e.get("slam_contact133",0))>0:
  var age=1-float(e.slam_contact133)/.3
  g.draw_arc(at,RADIUS+age*22,0,TAU,40,Color(.8,.66,.45,1-age),3,true)
