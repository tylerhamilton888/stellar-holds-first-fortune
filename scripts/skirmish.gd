class_name HoldSkirmish
extends RefCounted
# One top-down combat controller for the practice room and persistent deep encounters.
const PLAYER_BODY=10.0
const SHOT_RADIUS=3.0
const CONTACT_PHASE=.52
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
var shield_recoil=0.0
var bash_wait=0.0
var bash_left=0.0
var bash_hit=false
var bash_aim=Vector2.RIGHT
var dodge=0.0
var dodge_wait=0.0
var dodge_vector=Vector2.RIGHT
var hurt_wait=0.0
var feedback=""
var feedback_time=0.0
var lesson_announced=false
var hit_stop=0.0
var impacts=[]
var show_hitboxes=false
func _init(game):g=game
func practice()->bool:return g.room_id=="training"
func enabled()->bool:return practice() or (g.zone=="mine" and HoldOnboarding.combat_ready(g.state))
func cancel_actions():
 hit_stop=0;impacts.clear();shield_recoil=0;bash_wait=0;bash_left=0;bash_hit=false
 swing=0;buffered=0;guard=false;guard_was=false;parry=0;dodge=0;g.combat.riposte=0
func reset():
 hit_stop=0;impacts.clear();shield_recoil=0;bash_wait=0;bash_left=0;bash_hit=false
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
 key=context;enemies.clear();hit_stop=0;impacts.clear();shield_recoil=0;bash_wait=0;bash_left=0;bash_hit=false;swing=0;buffered=0;guard=false;guard_was=false;dodge=0;g.combat.riposte=0
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
    if roomy and w.depth()>=2 and sites.size()==1:
     for off in [Vector2(80,0),Vector2(-80,0),Vector2(0,80),Vector2(0,-80)]:
      if not body_open(p+off,26):roomy=false
    if roomy:sites.append([p.x,p.y])
    if sites.size()==2:break
   if sites.size()==2:break
  w.layer().encounters=sites
  # Only new encounter records gain companions; old cleared passages stay cleared.
  w.layer().encounter_companions={}
  w.layer().encounter_roster={}
  for i in sites.size():
   var home=Vector2(sites[i][0],sites[i][1])
   var lead=0 if i==0 and w.depth()==1 else 3 if i==1 and w.depth()>=2 else 2
   if lead==3:
    for off in [Vector2(80,0),Vector2(-80,0),Vector2(0,80),Vector2(0,-80)]:
     if not body_open(home+off,26):lead=2
   w.layer().encounter_roster[str(i)]={"lead":lead,"companion":2 if lead==0 else 0}
   for off in [Vector2(64,0),Vector2(-64,0),Vector2(0,64),Vector2(0,-64)]:
    if body_open(home+off) and clear(home,home+off):
     w.layer().encounter_companions[str(i)]=[home.x+off.x,home.y+off.y];break
 for i in w.layer().encounters.size():
  var id="deep53/"+str(g.state.seed_value)+"/"+context+"/"+str(i)
  var p=w.layer().encounters[i];var home=Vector2(p[0],p[1])
  var roster=w.layer().get("encounter_roster",{}).get(str(i),{"lead":i%2,"companion":1-i%2})
  if not g.state.combat.cleared.has(id):enemies.append(make_enemy(id,home,int(roster.lead)))
  var companions=w.layer().get("encounter_companions",{})
  if companions.has(str(i)):
   var companion=id+"/companion";var pos=companions[str(i)]
   if not g.state.combat.cleared.has(companion):enemies.append(make_enemy(companion,Vector2(pos[0],pos[1]),int(roster.companion)))
func make_enemy(id:String,p:Vector2,kind:int)->Dictionary:
 var hp=float(HoldEnemyRoster.spec(kind).hp)
 return {"id":id,"p":p,"home":p,"kind":kind,"hp":float(g.state.combat.wounds.get(id,hp)),"max":hp,"state":"idle","time":0.0,"dir":Vector2.LEFT,"walk":false,"gait":0.0,"flash":0.0,"stagger_wait":0.0,"dead_time":0.0,"alert":0.0}
func input(e:InputEvent)->bool:
 if not enabled() or g.panel_id!="":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_F8:show_hitboxes=not show_hitboxes;return true
  if e.keycode==KEY_F:
   if g.handworks.busy_hands():say("Park the cart or set down your load first.");return true
   g.combat.armed=not g.combat.armed;g.mining_gun.selected=false;cancel_actions();return true
  if e.is_action_pressed("dodge") and g.combat.armed:evade();return true
 if e is InputEventMouseButton and g.combat.armed and not g.hotbar.over():
  if e.button_index==MOUSE_BUTTON_LEFT and e.pressed:
   if guard and g.state.combat.weapon=="axe":shield_bash()
   else:buffered=.20
   return true
 return false
func shield_bash():
 if bash_wait>0 or swing>0 or dodge>0:return
 bash_wait=.8;bash_left=.36;bash_hit=false;bash_aim=aim;parry=0;buffered=0
func resolve_bash():
 for enemy in enemies:
  if enemy.hp<=0 or not sector_hits(g.player,bash_aim,48,.8,enemy.p,float(HoldEnemyRoster.spec(enemy.kind).body)) or not clear(g.player,enemy.p):continue
  impact(enemy.p,.035,Color("b8ddd8"),false)
  if practice():continue
  var radius=float(HoldEnemyRoster.spec(enemy.kind).body)
  var before:Vector2=enemy.p
  var distance=9.0 if enemy.kind==3 else 30.0
  enemy.p=push_body(before,bash_aim,distance,radius)
  enemy.alert=6.0
  if enemy.p.distance_to(before)<distance*.5:pressure(enemy,45)
  stagger(enemy,.35)
 say("Shield shove")
func pressure(enemy:Dictionary,amount:float):
 if enemy.get("stagger_wait",0.0)>0:return
 var limit=120.0 if enemy.kind==3 else 75.0 if enemy.kind==2 else 50.0
 enemy.poise=float(enemy.get("poise",0.0))+amount
 if enemy.poise>=limit:
  enemy.poise=0.0;stagger(enemy,.85);say("Off balance · strike now")
func say(text:String):feedback=text;feedback_time=2.2;g.notify(text)
func evade():
 if dodge_wait>0 or dodge>0:return
 bash_left=0
 # Movement selects the dodge; standing still uses the mouse-facing direction.
 dodge_vector=Input.get_vector("left","right","up","down")
 if dodge_vector==Vector2.ZERO:dodge_vector=aim
 for e in enemies:
  if e.state=="windup" and e.time<.4 and e.p.distance_to(g.player)<110:e.evaded=true
 dodge=.20;dodge_wait=.58 if HoldDisciplines.has(g.state,"sure_footing") else .72;swing=0;guard=false;buffered=0
 g.sound.effect("swing",-18)
func movement(axis:Vector2)->Vector2:
 if enabled() and hit_stop>0:return Vector2.ZERO
 if not enabled() or not g.combat.armed:return axis*g.handworks.travel_speed()
 if dodge>0:return dodge_vector*420
 if bash_left>0:return Vector2.ZERO
 return axis*(100 if guard else 135 if swing>0 else 185)
func strike():
 if bash_left>0:return
 var weapon=g.combat.weapon()
 if g.state.combat.weapon=="gun" and g.state.count("ammo")<=0:say("No cartridges · B changes equipment");buffered=0;return
 swing=weapon.time;struck=false;locked_aim=aim;buffered=0;g.sound.effect("swing",-13)
func update(dt:float):
 feedback_time=maxf(0,feedback_time-dt)
 if not enabled():return
 if g.panel_id!="" or g.transition_left>0:return
 spawn()
 if hit_stop>0:
  var frozen=minf(dt,hit_stop);hit_stop=maxf(0,hit_stop-dt);dt-=frozen
  if dt<=0:return
 for effect in impacts:effect.life-=dt
 impacts=impacts.filter(func(effect):return effect.life>0)
 shield_recoil=maxf(0,shield_recoil-dt);bash_wait=maxf(0,bash_wait-dt)
 if bash_left>0:
  bash_left=maxf(0,bash_left-dt)
  if not bash_hit and bash_left<=.20:
   bash_hit=true;resolve_bash()
 buffered=maxf(0,buffered-dt);parry=maxf(0,parry-dt);parry_wait=maxf(0,parry_wait-dt);dodge=maxf(0,dodge-dt);dodge_wait=maxf(0,dodge_wait-dt);hurt_wait=maxf(0,hurt_wait-dt);g.combat.riposte=maxf(0,g.combat.riposte-dt)
 var delta=g.get_global_mouse_position()+g.camera-(g.player-Vector2(0,25))
 if delta.length()>10:aim=delta.normalized()
 if g.combat.armed:
  # Aim remains adjustable through early preparation, then commits before contact.
  if swing>g.combat.weapon().time*.72:locked_aim=aim
  g.surface.direction=bash_aim if bash_left>0 else locked_aim if swing>0 else aim
  var held=Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
  # A completed contact may flow into guard; preparation cannot be canceled by guard.
  if held and struck and swing>0 and swing<g.combat.weapon().time*.24:swing=0
  if held and not guard_was and swing<=0 and dodge<=0 and parry_wait<=0:parry=.19;parry_wait=.55
  guard_was=held;guard=held and swing<=0 and dodge<=0
  if not held and not g.hotbar.over() and (buffered>0 or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and swing<=0 and dodge<=0:strike()
 else:guard=false;guard_was=false;swing=0;buffered=0
 if swing>0:
  swing=maxf(0,swing-dt)
  if not struck and swing<=g.combat.weapon().time*(1-CONTACT_PHASE):
   swing=g.combat.weapon().time*(1-CONTACT_PHASE);struck=true;resolve()
   if hit_stop>0:return
 for e in enemies:
  if e.hp<=0:e.dead_time=maxf(0,e.get("dead_time",0.0)-dt);continue
  var spec=HoldEnemyRoster.spec(e.kind)
  e.alert=maxf(0,e.get("alert",0.0)-dt)
  e.poise=maxf(0,float(e.get("poise",0.0))-dt*12)
  e.flash=maxf(0,e.flash-dt);e.stagger_wait=maxf(0,e.get("stagger_wait",0.0)-dt);e.walk=false
  var toward=g.player-e.p
  if e.state=="windup":
   e.time-=dt
   if e.time<=0:
    e.state="recover";e.time=.75 if practice() else float(spec.recover)
    if sector_hits(e.p,e.dir,float(spec.reach),float(spec.angle),g.player,PLAYER_BODY) and clear(e.p,g.player):receive(e)
    elif practice() and e.get("evaded",false):HoldOnboarding.fact(g.state,"practice_dodge");say("Clean dodge")
    e.evaded=false
    if hit_stop>0:return
   continue
  if e.state in ["recover","stun"]:
   e.time-=dt
   if e.time<=0:e.state="idle"
   continue
  if toward.length()>(480 if e.alert>0 else 290) or not clear(e.p,g.player) or g.player.distance_to(e.home)>(520 if e.alert>0 else 360):continue
  if practice() and not g.combat.armed:continue
  e.dir=toward.normalized()
  if toward.length()<float(spec.reach)-10:
   if attack_slot(e):
    e.state="windup";e.time=.72 if practice() else float(spec.windup);e.evaded=false
    continue
   if practice() or e.kind!=0:continue
  var destination:Vector2=g.player
  # Goblins flank while another fighter commits; heavy fighters hold their approach.
  if not practice() and e.kind==0 and not attack_slot(e):
   var side=1.0 if posmod(hash(e.id),2)==0 else -1.0
   destination=g.player+toward.normalized().rotated(side*1.2)*95
  var next=e.p.move_toward(destination,(90.0 if practice() else float(spec.speed))*dt)
  var spaced=true
  for other in enemies:
   if other!=e and other.hp>0 and next.distance_to(other.p)<float(spec.body)+float(HoldEnemyRoster.spec(other.kind).body)+10:spaced=false
  if spaced and body_open(next,float(spec.body)):e.gait+=e.p.distance_to(next)/185;e.p=next;e.walk=true
 if practice() and not lesson_announced and HoldOnboarding.progress(g.state,"training").ready:
  lesson_announced=true;g.save_game();say("Good footwork. E at the south bench reports your training.")
func body_open(p:Vector2,radius:float=12)->bool:
 for offset in [Vector2.ZERO,Vector2(radius,0),Vector2(-radius,0),Vector2(0,radius),Vector2(0,-radius)]:
  if not open_at(p+offset):return false
 return true
func attack_slot(candidate:Dictionary)->bool:
 # One nearby committed attack at a time, including its recovery window.
 for other in enemies:
  if other!=candidate and other.hp>0 and other.state in ["windup","recover"] and other.p.distance_to(candidate.p)<220:return false
 return true
func stagger(e:Dictionary,duration:float):
 if e.get("stagger_wait",0.0)>0:return
 e.state="stun";e.time=duration*(.5 if e.kind==3 else 1.0);e.stagger_wait=duration+(2.0 if e.kind==3 else 1.0)
func resolve():
 var weapon=g.combat.weapon();var ranged=g.state.combat.weapon=="gun"
 if ranged:g.state.pay({"ammo":1});g.sound.effect("carbine",-14)
 var hit=false
 var targets=enemies.duplicate()
 if ranged:targets.sort_custom(func(a,b):return shot_entry(a.p,float(HoldEnemyRoster.spec(a.kind).body))<shot_entry(b.p,float(HoldEnemyRoster.spec(b.kind).body)))
 for e in targets:
  if e.hp<=0:continue
  var body=float(HoldEnemyRoster.spec(e.kind).body)
  var in_arc=sector_hits(g.player,locked_aim,weapon.reach,weapon_half_angle(),e.p,body)
  if ranged:in_arc=shot_entry(e.p,body)<=weapon.reach
  if not in_arc or not clear(g.player,e.p):continue
  hit=true;e.flash=.18
  var heavy=g.state.combat.weapon=="hammer"
  impact(e.p-locked_aim*body,.065 if heavy else .035,Color("ffe0a0"),heavy)
  if not practice():
   var before:Vector2=e.p
   var shove=(22.0 if heavy else 8.0)*(.3 if e.kind==3 else 1.0)
   e.p=push_body(e.p,locked_aim,shove,body)
   if heavy and e.p.distance_to(before)<shove*.5:
    impact(e.p,.07,Color("e5b86c"),true);pressure(e,45)
  if practice():
   HoldOnboarding.fact(g.state,"practice_hit");g.sound.effect("wood",-18)
  else:
   var damage=float(weapon.damage)*(1.65 if g.combat.riposte>0 else 1.0)
   if g.state.combat.weapon!="hammer":damage*=1-float(HoldEnemyRoster.spec(e.kind).armor)
   e.alert=6.0
   e.hp=maxf(0,e.hp-damage);g.state.combat.wounds[e.id]=e.hp;g.sound.effect("metal",-16)
   if e.hp<=0:
    HoldDisciplines.data(g.state) # Initialize legacy credit before recording this new defeat.
    HoldDisciplines.award(g.state,"warrior",1,e.id)
    e.dead_time=0.0 if e.kind==1 else 2.2;e.walk=false
    g.state.combat.cleared[e.id]=true;g.state.combat.wounds.erase(e.id)
    var loot=HoldEnemyRoster.spec(e.kind).loot
    for item in loot:g.state.add(item,int(loot[item]))
    HoldOnboarding.fact(g.state,"deep_combat");g.save_game();say("Foe defeated · salvage recovered")
   elif g.state.combat.weapon=="hammer" or g.combat.riposte>0:stagger(e,.65)
   else:pressure(e,24 if not ranged else 15)
  if ranged:break
 if hit:g.combat.riposte=0
func receive(e:Dictionary):
 if dodge>0 or hurt_wait>0:
  if practice() and dodge>0:HoldOnboarding.fact(g.state,"practice_dodge");say("Clean dodge")
  return
 var damage=float(HoldEnemyRoster.spec(e.kind).damage)
 var front=aim.dot((e.p-g.player).normalized())>.15
 if guard and front:
  shield_recoil=.18
  if practice():HoldOnboarding.fact(g.state,"practice_guard")
  if parry>0:impact(g.player,.05,Color("8fffe5"),false);stagger(e,1.0);g.combat.riposte=1.25;g.sound.effect("parry",-15);say("Parried · opening for a counter")
  elif (g.state.combat.weapon=="axe" and e.kind!=3) or practice():impact(g.player,.025,Color("b8ddd8"),false);g.sound.effect("metal",-18);say("Shield held" if g.state.combat.weapon=="axe" else "Practice guard")
  else:
   impact(g.player,.055,Color("f7b27c"),e.kind==3)
   g.player=push_body(g.player,e.dir,6,PLAYER_BODY)
   g.state.combat.health-=damage*(.25 if g.state.combat.weapon=="axe" else .375)*(1-float(HoldCombat.ARMOR[g.state.combat.armor].reduction));say("Heavy blow · dodge or parry" if e.kind==3 else "Braced · reduced damage")
   if g.state.combat.health<=0:g.perform_rescue("Defeated · crew rescue")
  hurt_wait=.25;return
 if practice():say("Watch the amber arc. Face Borin to guard, or dodge sideways.");return
 impact(g.player,.07 if e.kind==3 else .04,Color("ff997c"),e.kind==3)
 g.player=push_body(g.player,e.dir,18 if e.kind==3 else 8,PLAYER_BODY)
 g.state.combat.health-=damage*(1-float(HoldCombat.ARMOR[g.state.combat.armor].reduction));hurt_wait=.65;g.sound.effect("stone",-15);say("Hit · %d health remaining" % maxi(0,int(g.state.combat.health)))
 if g.state.combat.health<=0:g.perform_rescue("Defeated · crew rescue")
func objects()->Array:
 if not enabled():return []
 var result=[]
 for e in enemies:
  if e.hp>0 or e.get("dead_time",0.0)>0:result.append({"p":e.p,"kind":"fighter","enemy":e})
 return result
func draw_enemy(e:Dictionary):
 var cam=g.camera.round();var p=e.p;var spec=HoldEnemyRoster.spec(e.kind)
 g.draw_set_transform(-cam)
 if e.hp>0 and e.state=="windup":
  var radius=float(spec.reach);var half=float(spec.angle)
  var points=PackedVector2Array([p]);var angle=e.dir.angle()
  for i in 17:points.append(p+Vector2.from_angle(angle-half+2*half*i/16)*radius)
  g.draw_colored_polygon(points,Color(1,.64,.2,.18));g.draw_arc(p,radius,angle-half,angle+half,24,Color("e5b86c"),2)
 g.draw_set_transform(p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,float(spec.body)+7,Color(0,0,0,.25));g.draw_set_transform(-cam)
 if practice():
  var phase=.18+.33*(1-e.time/.72) if e.state=="windup" else CONTACT_PHASE+(1-e.time/.75)*(1-CONTACT_PHASE) if e.state=="recover" else 0.0
  HoldDrawnAnimation.paint(g,p-cam,g.state.npc("borin"),e.dir,e.walk,e.gait,.85,-cam,"combat_axe" if e.state in ["windup","recover"] else "hold_combat_axe",phase)
 elif e.kind!=1:
  HoldEnemyRoster.draw(g,e)
 else:
  var frame=2 if e.state=="windup" else 3 if e.state=="recover" else int(e.gait*8)%2
  # Measured silhouettes, not equal cells: attack poses extend across old atlas divisions.
  var regions=[Rect2(40,135,390,355),Rect2(485,145,345,345),Rect2(880,5,340,485),Rect2(1240,165,534,325)] if e.kind==0 else [Rect2(35,585,375,275),Rect2(465,585,400,275),Rect2(880,540,375,320),Rect2(1270,625,504,235)]
  var roots=[Vector2(230,480),Vector2(650,480),Vector2(1050,480),Vector2(1425,480)] if e.kind==0 else [Vector2(220,845),Vector2(650,845),Vector2(1060,845),Vector2(1480,845)]
  var source:Rect2=regions[frame];var scale=.16
  g.draw_set_transform(p-cam,0,Vector2(-1 if e.dir.x<0 else 1,1))
  g.draw_texture_rect_region(HoldCombat.ENEMIES,Rect2((source.position-roots[frame])*scale,source.size*scale),source,Color(1.3,1.2,1.1) if e.flash>0 else Color.WHITE);g.draw_set_transform(-cam)
 if not practice() and e.hp>0:
  var top=-float(spec.height)-18
  var poise=float(e.get("poise",0.0))
  if poise>0:
   var limit=120.0 if e.kind==3 else 75.0 if e.kind==2 else 50.0
   g.draw_rect(Rect2(p+Vector2(-22,top+6),Vector2(44*minf(1,poise/limit),2)),Color("8fe3d1"))
  if e.state=="stun":HoldArt.text(g,p+Vector2(-30,22),"Off balance",11,Color("8fe3d1"))
  g.draw_rect(Rect2(p+Vector2(-22,top),Vector2(44,4)),Color("312b2a"));g.draw_rect(Rect2(p+Vector2(-22,top),Vector2(44*e.hp/e.max,4)),Color("cf956c"))
  HoldArt.text(g,p+Vector2(-44,top-5),spec.name,11,Color("ead6ac"))
  if e.kind==3 and e.state=="windup":HoldArt.text(g,p+Vector2(-64,22),"Heavy · dodge / parry",12,Color("f0b97a"))
func player_pose()->String:
 if g.state.combat.weapon=="axe":
  if bash_left>0:return "guard_axe" if bash_left>.20 or bash_left<.08 else "parry_axe"
  if swing>0:return "combat_axe"
  if shield_recoil>0:return "parry_axe"
  if guard:return "guard_axe"
  return "hold_combat_axe"
 if g.state.combat.weapon=="gun":return "hold_rifle"
 return "hammer" if swing>0 else "hold_hammer"
func draw_player(p:Vector2,zoom:float,offset:Vector2):
 var pose_action=player_pose()
 HoldDrawnAnimation.paint(g,p+offset,g.combat.profile(),bash_aim if bash_left>0 else locked_aim if swing>0 else aim,g.walking_pose,g.gait_clock,zoom,offset,pose_action,1-swing/g.combat.weapon().time if swing>0 else 0)
 g.draw_set_transform(offset)
 if guard:
  var center=p+aim*26-Vector2(0,24)
  g.draw_arc(center,22,aim.angle()-1.3,aim.angle()+1.3,20,Color("a7e0d6") if parry>0 else Color("c6b68d"),4)
 if dodge>0:g.draw_arc(p+Vector2(0,4),20,0,TAU,24,Color(.6,.9,.85,.5),2)
func overlay():
 if not enabled():return
 draw_impacts()
 if not g.combat.armed:return
 g.draw_set_transform(Vector2.ZERO)
 var text="LMB strike · RMB guard · RMB + LMB shove · Space dodge"
 if practice():
  var f=HoldOnboarding.ensure(g.state).facts
  text="Practice · Blows %d/3   Guard %d/1   Evade a strike %d/1" % [mini(3,int(f.get("practice_hit",0))),mini(1,int(f.get("practice_guard",0))),mini(1,int(f.get("practice_dodge",0)))]
 var y=178.0 if g.hotbar.bar_y()<100 else 82.0
 g.draw_rect(Rect2(18,y,620,49 if practice() else 28),Color(.03,.08,.10,.93))
 HoldArt.text(g,Vector2(28,y+19),text,14,Color("ead6ac"))
 if practice():HoldArt.text(g,Vector2(28,y+39),"Mouse faces · hold LMB strike · RMB guard · Space dodge · F tools",13,Color("afd2c5"))
 else:
  g.draw_rect(Rect2(720,y,220,28),Color(.03,.08,.10,.93))
  HoldArt.text(g,Vector2(730,y+19),"%d HP · B gear" % g.state.combat.health,14,Color("afd2c5"))

# All collision geometry lives on the ground plane at the character's feet.
static func sector_hits(origin:Vector2,direction:Vector2,reach:float,half:float,center:Vector2,radius:float)->bool:
 var delta=center-origin
 if delta.length()<=radius:return true
 if delta.length()>reach+radius:return false
 if absf(direction.angle_to(delta))<=half:return true
 for side in [-1,1]:
  var end=origin+direction.rotated(half*side).normalized()*reach
  if Geometry2D.get_closest_point_to_segment(center,origin,end).distance_to(center)<=radius:return true
 return false
func weapon_half_angle()->float:return acos(.65 if g.state.combat.weapon=="hammer" else .35)
func shot_entry(center:Vector2,radius:float)->float:
 var delta=center-g.player;var along=delta.dot(locked_aim);var across=absf(delta.cross(locked_aim));var width=radius+SHOT_RADIUS
 if across>width:return INF
 var extent=sqrt(maxf(0,width*width-across*across))
 if along+extent<0:return INF
 return maxf(0,along-extent)
func push_body(origin:Vector2,direction:Vector2,distance:float,radius:float)->Vector2:
 var result=origin;var steps=maxi(1,ceili(distance/2.0))
 for i in steps:
  var next=result+direction.normalized()*distance/steps
  if not body_open(next,radius):break
  result=next
 return result
func impact(at:Vector2,pause:float,color:Color,heavy:bool):
 hit_stop=maxf(hit_stop,pause)
 impacts.append({"p":at,"life":.20,"color":color,"heavy":heavy})
 if impacts.size()>12:impacts.pop_front()
func draw_sector(at:Vector2,direction:Vector2,reach:float,half:float,color:Color):
 var angle=direction.angle()
 g.draw_arc(at,reach,angle-half,angle+half,32,color,2)
 for side in [-1,1]:g.draw_line(at,at+direction.rotated(half*side)*reach,color,1)
func draw_impacts():
 g.draw_set_transform(-g.camera.round())
 for effect in impacts:
  var phase=1-effect.life/.20;var color:Color=effect.color;color.a=1-phase
  var radius=(12 if effect.heavy else 7)+phase*15
  var at:Vector2=effect.p-Vector2(0,12)
  for i in 6:
   var direction=Vector2.from_angle(i*TAU/6+.3)
   g.draw_line(at+direction*radius*.4,at+direction*radius,color,2)
  if effect.heavy:g.draw_arc(effect.p,radius,0,TAU,24,color,1.5)
 if swing>g.combat.weapon().time*(1-CONTACT_PHASE)-.10 and struck and g.state.combat.weapon!="gun":
  draw_sector(g.player,locked_aim,g.combat.weapon().reach,weapon_half_angle(),Color(1,.84,.53,.25))
 if not show_hitboxes:
  g.draw_set_transform(Vector2.ZERO)
  return
 g.draw_arc(g.player,PLAYER_BODY,0,TAU,32,Color("7ce8ef"),2)
 for e in enemies:
  if e.hp<=0:continue
  var spec=HoldEnemyRoster.spec(e.kind)
  g.draw_arc(e.p,float(spec.body),0,TAU,32,Color("ef9690"),2)
  if e.state=="windup":draw_sector(e.p,e.dir,float(spec.reach),float(spec.angle),Color("ffbe62"))
 if g.combat.armed:
  var direction=locked_aim if swing>0 else aim
  if g.state.combat.weapon=="gun":g.draw_line(g.player,g.player+direction*g.combat.weapon().reach,Color(.5,.9,1,.4),SHOT_RADIUS*2)
  else:draw_sector(g.player,direction,g.combat.weapon().reach,weapon_half_angle(),Color(.5,.9,1,.5))
 g.draw_set_transform(Vector2.ZERO)
 HoldArt.text(g,Vector2(28,150),"F8 hitboxes · cyan player / attack · red bodies · amber enemy attack",13,Color("aee6df"))
