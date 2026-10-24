class_name HoldSkirmish
extends RefCounted
# One top-down combat controller for the practice room and persistent deep encounters.
const ATTACK_RADIUS=88.0
const ATTACK_HALF_ANGLE=.9
var g
var enemies=[]
var key=""
var aim=Vector2.RIGHT
var locked_aim=Vector2.RIGHT
var swing=0.0
var struck=false
var buffered=0.0
var guard=false
var guard_was=false
var parry=0.0
var parry_wait=0.0
var dodge=0.0
var dodge_wait=0.0
var dodge_vector=Vector2.RIGHT
var hurt_wait=0.0
var feedback=""
var feedback_time=0.0
var lesson_announced=false
func _init(game):g=game
func practice()->bool:return g.room_id=="training"
func enabled()->bool:return practice() or (g.zone=="mine" and HoldOnboarding.combat_ready(g.state))
func cancel_actions():
 swing=0;buffered=0;guard=false;guard_was=false;parry=0;dodge=0;g.combat.riposte=0
func reset():
 swing=0;buffered=0;guard=false;guard_was=false;parry=0;parry_wait=0;dodge=0;dodge_wait=0;hurt_wait=0;key="";enemies.clear();lesson_announced=false
func open_at(p:Vector2)->bool:
 return not g.deep.world.solid(p) if g.zone=="mine" else g.surface.walkable(p)
func clear(a:Vector2,b:Vector2)->bool:
 for i in range(1,maxi(2,int(a.distance_to(b)/5))):
  if not open_at(a.lerp(b,float(i)/maxi(2,int(a.distance_to(b)/5)))):return false
 return true
func spawn():
 var context="practice" if practice() else g.handworks.context()
 if key==context:return
 key=context;enemies.clear();swing=0;buffered=0;guard=false;guard_was=false;dodge=0;g.combat.riposte=0
 if practice():
  enemies.append(make_enemy("practice",Vector2(580,430),0));return
 var w=g.deep.world
 if w.depth()==0:return
 if not w.layer().has("encounters"):
  var sites=[]
  for y in range(5,Deepworks.H-5,3):
   for x in range(5,Deepworks.W-5,3):
    var c=Vector2i(x,y);var p=Deepworks.center(c)
    if w.at(c)!=0 or p.distance_to(Deepworks.center(Deepworks.ENTRY))<440:continue
    var roomy=true
    for off in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
     if w.at(c+off)!=0:roomy=false
    for site in sites:
     if p.distance_to(Vector2(site[0],site[1]))<450:roomy=false
    if roomy:sites.append([p.x,p.y])
    if sites.size()==2:break
   if sites.size()==2:break
  w.layer().encounters=sites
  # Only new encounter records gain companions; old cleared passages stay cleared.
  w.layer().encounter_companions={}
  for i in sites.size():
   var home=Vector2(sites[i][0],sites[i][1])
   for off in [Vector2(64,0),Vector2(-64,0),Vector2(0,64),Vector2(0,-64)]:
    if body_open(home+off) and clear(home,home+off):
     w.layer().encounter_companions[str(i)]=[home.x+off.x,home.y+off.y];break
 for i in w.layer().encounters.size():
  var id="deep53/"+str(g.state.seed_value)+"/"+context+"/"+str(i)
  var p=w.layer().encounters[i];var home=Vector2(p[0],p[1])
  if not g.state.combat.cleared.has(id):enemies.append(make_enemy(id,home,i%2))
  var companions=w.layer().get("encounter_companions",{})
  if companions.has(str(i)):
   var companion=id+"/companion";var pos=companions[str(i)]
   if not g.state.combat.cleared.has(companion):enemies.append(make_enemy(companion,Vector2(pos[0],pos[1]),1-i%2))
func make_enemy(id:String,p:Vector2,kind:int)->Dictionary:
 var hp=64.0 if kind==0 else 84.0
 return {"id":id,"p":p,"home":p,"kind":kind,"hp":float(g.state.combat.wounds.get(id,hp)),"max":hp,"state":"idle","time":0.0,"dir":Vector2.LEFT,"walk":false,"gait":0.0,"flash":0.0,"stagger_wait":0.0}
func input(e:InputEvent)->bool:
 if not enabled() or g.panel_id!="":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_F:
   if g.handworks.busy_hands():say("Park the cart or set down your load first.");return true
   g.combat.armed=not g.combat.armed;g.mining_gun.selected=false;swing=0;guard=false;buffered=0;g.combat.riposte=0;return true
  if e.keycode==KEY_Q and g.combat.armed:evade();return true
 if e is InputEventMouseButton and g.combat.armed and not g.hotbar.over():
  if e.button_index==MOUSE_BUTTON_LEFT and e.pressed:buffered=.16;return true
 return false
func say(text:String):feedback=text;feedback_time=2.2;g.notify(text)
func evade():
 if dodge_wait>0 or dodge>0:return
 # Movement selects the dodge; standing still uses the mouse-facing direction.
 dodge_vector=Input.get_vector("left","right","up","down")
 if dodge_vector==Vector2.ZERO:dodge_vector=aim
 for e in enemies:
  if e.state=="windup" and e.time<.4 and e.p.distance_to(g.player)<110:e.evaded=true
 dodge=.20;dodge_wait=.58 if HoldDisciplines.has(g.state,"sure_footing") else .72;swing=0;guard=false;buffered=0
 g.sound.effect("swing",-18)
func movement(axis:Vector2)->Vector2:
 if not enabled() or not g.combat.armed:return axis*g.handworks.travel_speed()
 if dodge>0:return dodge_vector*420
 return axis*(100 if guard else 135 if swing>0 else 185)
func strike():
 var weapon=g.combat.weapon()
 if g.state.combat.weapon=="gun" and g.state.count("ammo")<=0:say("No cartridges · B changes equipment");buffered=0;return
 swing=weapon.time;struck=false;locked_aim=aim;buffered=0;g.sound.effect("swing",-13)
func update(dt:float):
 feedback_time=maxf(0,feedback_time-dt)
 if not enabled():return
 if g.panel_id!="" or g.transition_left>0:return
 spawn();buffered=maxf(0,buffered-dt);parry=maxf(0,parry-dt);parry_wait=maxf(0,parry_wait-dt);dodge=maxf(0,dodge-dt);dodge_wait=maxf(0,dodge_wait-dt);hurt_wait=maxf(0,hurt_wait-dt);g.combat.riposte=maxf(0,g.combat.riposte-dt)
 var delta=g.get_global_mouse_position()+g.camera-(g.player-Vector2(0,25))
 if delta.length()>10:aim=delta.normalized()
 if g.combat.armed:
  g.surface.direction=locked_aim if swing>0 else aim
  var held=Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
  if held and not guard_was and swing<=0 and dodge<=0 and parry_wait<=0:parry=.19;parry_wait=.55
  guard_was=held;guard=held and swing<=0 and dodge<=0
  if not held and not g.hotbar.over() and (buffered>0 or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and swing<=0 and dodge<=0:strike()
 else:guard=false;guard_was=false;swing=0;buffered=0
 if swing>0:
  swing=maxf(0,swing-dt)
  if not struck and swing<=g.combat.weapon().time*.60:struck=true;resolve()
 for e in enemies:
  if e.hp<=0:continue
  e.flash=maxf(0,e.flash-dt);e.stagger_wait=maxf(0,e.get("stagger_wait",0.0)-dt);e.walk=false
  var toward=g.player-e.p
  if e.state=="windup":
   e.time-=dt
   if e.time<=0:
    if toward.length()<ATTACK_RADIUS and toward.normalized().dot(e.dir)>cos(ATTACK_HALF_ANGLE) and clear(e.p,g.player):receive(e)
    elif practice() and e.get("evaded",false):HoldOnboarding.fact(g.state,"practice_dodge");say("Clean dodge")
    e.evaded=false
    if e.state=="windup":e.state="recover";e.time=.75 if e.kind==0 else 1.0
   continue
  if e.state in ["recover","stun"]:
   e.time-=dt
   if e.time<=0:e.state="idle"
   continue
  if toward.length()>290 or not clear(e.p,g.player) or g.player.distance_to(e.home)>360:continue
  if practice() and not g.combat.armed:continue
  e.dir=toward.normalized()
  if toward.length()<78:
   if attack_slot(e):e.state="windup";e.time=.72 if e.kind==0 else 1.05;e.evaded=false
   continue
  var next=e.p.move_toward(g.player,(90 if e.kind==0 else 60)*dt)
  var spaced=true
  for other in enemies:
   if other!=e and other.hp>0 and next.distance_to(other.p)<38:spaced=false
  if spaced and body_open(next):e.gait+=e.p.distance_to(next)/185;e.p=next;e.walk=true
 if practice() and not lesson_announced and HoldOnboarding.progress(g.state,"training").ready:
  lesson_announced=true;g.save_game();say("Good footwork. E at the south bench reports your training.")
func body_open(p:Vector2)->bool:
 for offset in [Vector2.ZERO,Vector2(12,0),Vector2(-12,0),Vector2(0,12),Vector2(0,-12)]:
  if not open_at(p+offset):return false
 return true
func attack_slot(candidate:Dictionary)->bool:
 # One nearby committed attack at a time, including its recovery window.
 for other in enemies:
  if other!=candidate and other.hp>0 and other.state in ["windup","recover"] and other.p.distance_to(candidate.p)<220:return false
 return true
func stagger(e:Dictionary,duration:float):
 if e.get("stagger_wait",0.0)>0:return
 e.state="stun";e.time=duration;e.stagger_wait=duration+1.0
func resolve():
 var weapon=g.combat.weapon();var ranged=g.state.combat.weapon=="gun"
 if ranged:g.state.pay({"ammo":1});g.sound.effect("carbine",-14)
 var hit=false
 var targets=enemies.duplicate()
 if ranged:targets.sort_custom(func(a,b):return g.player.distance_squared_to(a.p)<g.player.distance_squared_to(b.p))
 for e in targets:
  if e.hp<=0:continue
  var delta=e.p-g.player
  var in_arc=delta.length()<=weapon.reach+18 and (delta.length()<20 or delta.normalized().dot(locked_aim)>(.65 if g.state.combat.weapon=="hammer" else .35))
  if ranged:in_arc=delta.dot(locked_aim)>0 and delta.dot(locked_aim)<=weapon.reach and Geometry2D.get_closest_point_to_segment(e.p,g.player,g.player+locked_aim*weapon.reach).distance_to(e.p)<22
  if not in_arc or not clear(g.player,e.p):continue
  hit=true;e.flash=.18
  if practice():
   HoldOnboarding.fact(g.state,"practice_hit");g.sound.effect("wood",-18)
  else:
   var damage=float(weapon.damage)*(1.65 if g.combat.riposte>0 else 1.0)
   if e.kind==1 and g.state.combat.weapon!="hammer":damage*=.8
   e.hp=maxf(0,e.hp-damage);g.state.combat.wounds[e.id]=e.hp;g.sound.effect("metal",-16)
   if e.hp<=0:
    HoldDisciplines.data(g.state) # Initialize legacy credit before recording this new defeat.
    HoldDisciplines.award(g.state,"warrior",1,e.id)
    g.state.combat.cleared[e.id]=true;g.state.combat.wounds.erase(e.id)
    for item in ({"scrap":3,"copper_ore":2} if e.kind==0 else {"shell":2,"iron_ore":2}):g.state.add(item,3 if item=="scrap" else 2)
    HoldOnboarding.fact(g.state,"deep_combat");g.save_game();say("Foe defeated · salvage recovered")
   elif g.state.combat.weapon=="hammer" or g.combat.riposte>0:stagger(e,.65)
  if ranged:break
 if hit:g.combat.riposte=0
func receive(e:Dictionary):
 if dodge>0 or hurt_wait>0:
  if practice() and dodge>0:HoldOnboarding.fact(g.state,"practice_dodge");say("Clean dodge")
  return
 var front=aim.dot((e.p-g.player).normalized())>.15
 if guard and front:
  if practice():HoldOnboarding.fact(g.state,"practice_guard")
  if parry>0:stagger(e,1.0);g.combat.riposte=1.25;g.sound.effect("parry",-15);say("Parried · opening for a counter")
  elif g.state.combat.weapon=="axe" or practice():g.sound.effect("metal",-18);say("Shield held" if g.state.combat.weapon=="axe" else "Practice guard")
  else:
   g.state.combat.health-=6*(1-float(HoldCombat.ARMOR[g.state.combat.armor].reduction));say("Braced · reduced damage")
   if g.state.combat.health<=0:g.perform_rescue("Defeated · crew rescue")
  hurt_wait=.25;return
 if practice():say("Watch the amber arc. Face Borin to guard, or dodge sideways.");return
 g.state.combat.health-=16*(1-float(HoldCombat.ARMOR[g.state.combat.armor].reduction));hurt_wait=.65;g.sound.effect("stone",-15);say("Hit · %d health remaining" % maxi(0,int(g.state.combat.health)))
 if g.state.combat.health<=0:g.perform_rescue("Defeated · crew rescue")
func objects()->Array:
 if not enabled():return []
 var result=[]
 for e in enemies:
  if e.hp>0:result.append({"p":e.p,"kind":"fighter","enemy":e})
 return result
func draw_enemy(e:Dictionary):
 var cam=g.camera.round();var p=e.p
 g.draw_set_transform(-cam)
 if e.state=="windup":
  var points=PackedVector2Array([p]);var angle=e.dir.angle()
  for i in 17:points.append(p+Vector2.from_angle(angle-ATTACK_HALF_ANGLE+2*ATTACK_HALF_ANGLE*i/16)*ATTACK_RADIUS)
  g.draw_colored_polygon(points,Color(1,.64,.2,.18));g.draw_arc(p,ATTACK_RADIUS,angle-ATTACK_HALF_ANGLE,angle+ATTACK_HALF_ANGLE,24,Color("e5b86c"),2)
 g.draw_set_transform(p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,19,Color(0,0,0,.25));g.draw_set_transform(-cam)
 if practice():
  var phase=.15*(1-e.time/.72) if e.state=="windup" else .38+(1-e.time/.75)*.6 if e.state=="recover" else 0.0
  HoldDrawnAnimation.paint(g,p-cam,g.state.npc("borin"),e.dir,e.walk,e.gait,.85,-cam,"axe" if e.state in ["windup","recover"] else "",phase)
 else:
  var frame=2 if e.state=="windup" else 3 if e.state=="recover" else int(e.gait*8)%2
  # Measured silhouettes, not equal cells: attack poses extend across old atlas divisions.
  var regions=[Rect2(40,135,390,355),Rect2(485,145,345,345),Rect2(880,5,340,485),Rect2(1240,165,534,325)] if e.kind==0 else [Rect2(35,585,375,275),Rect2(465,585,400,275),Rect2(880,540,375,320),Rect2(1270,625,504,235)]
  var roots=[Vector2(230,480),Vector2(650,480),Vector2(1050,480),Vector2(1425,480)] if e.kind==0 else [Vector2(220,845),Vector2(650,845),Vector2(1060,845),Vector2(1480,845)]
  var source:Rect2=regions[frame];var scale=.16
  g.draw_set_transform(p-cam,0,Vector2(-1 if e.dir.x<0 else 1,1))
  g.draw_texture_rect_region(HoldCombat.ENEMIES,Rect2((source.position-roots[frame])*scale,source.size*scale),source,Color(1.3,1.2,1.1) if e.flash>0 else Color.WHITE);g.draw_set_transform(-cam)
  g.draw_rect(Rect2(p+Vector2(-22,-76),Vector2(44,4)),Color("312b2a"));g.draw_rect(Rect2(p+Vector2(-22,-76),Vector2(44*e.hp/e.max,4)),Color("cf956c"))
func draw_player(p:Vector2,zoom:float,offset:Vector2):
 var action="hammer" if g.state.combat.weapon=="hammer" else "axe"
 var pose_action=action if swing>0 and g.state.combat.weapon!="gun" else "hold_rifle" if g.state.combat.weapon=="gun" else "hold_"+action
 HoldDrawnAnimation.paint(g,p+offset,g.combat.profile(),locked_aim if swing>0 else aim,g.walking_pose,g.gait_clock,zoom,offset,pose_action,1-swing/g.combat.weapon().time if swing>0 else 0)
 g.draw_set_transform(offset)
 if g.state.combat.weapon=="axe":
  var shield=p+(aim*23+Vector2(0,-27) if guard else Vector2(16 if aim.x<-.3 else -16,-31))*zoom
  g.draw_texture_rect_region(HoldCombat.EQUIPMENT,Rect2(shield-Vector2(15,16)*zoom,Vector2(30,32)*zoom),Rect2(720,665,515,515))
 if guard:
  var center=p+aim*26-Vector2(0,24)
  g.draw_arc(center,22,aim.angle()-1.3,aim.angle()+1.3,20,Color("a7e0d6") if parry>0 else Color("c6b68d"),4)
 if dodge>0:g.draw_arc(p+Vector2(0,4),20,0,TAU,24,Color(.6,.9,.85,.5),2)
func overlay():
 if not enabled() or not g.combat.armed:return
 g.draw_set_transform(Vector2.ZERO)
 var text="LMB strike · RMB guard / parry · Q directional dodge · F tools"
 if practice():
  var f=HoldOnboarding.ensure(g.state).facts
  text="Practice · Blows %d/3   Guard %d/1   Evade a strike %d/1" % [mini(3,int(f.get("practice_hit",0))),mini(1,int(f.get("practice_guard",0))),mini(1,int(f.get("practice_dodge",0)))]
 var y=178.0 if g.hotbar.bar_y()<100 else 82.0
 g.draw_rect(Rect2(18,y,620,49 if practice() else 28),Color(.03,.08,.10,.93))
 HoldArt.text(g,Vector2(28,y+19),text,14,Color("ead6ac"))
 if practice():HoldArt.text(g,Vector2(28,y+39),"Mouse faces · hold LMB strike · RMB guard · Q dodge · F tools",13,Color("afd2c5"))
 else:
  g.draw_rect(Rect2(720,y,220,28),Color(.03,.08,.10,.93))
  HoldArt.text(g,Vector2(730,y+19),"%d HP · B gear" % g.state.combat.health,14,Color("afd2c5"))
