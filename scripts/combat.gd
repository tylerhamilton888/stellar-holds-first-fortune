class_name HoldCombat
extends RefCounted
const A=preload("res://scripts/art.gd")
const SIMPLE=preload("res://assets/actors-v15/axe-shield.png")
const EQUIPMENT=preload("res://assets/combat-v14/weapons.png")
const ENEMIES=preload("res://assets/combat-v14/enemies.png")
const WEAPONS={
 "axe":{"name":"Holdguard axe & shield","damage":24,"reach":76.0,"time":.48,"cost":{},"tech":"","desc":"Quick cuts; strong shield. Parry for a punishing reply."},
 "hammer":{"name":"Piston warhammer","damage":42,"reach":84.0,"time":.86,"cost":{"iron":5,"parts":2},"tech":"metallurgy","desc":"Slow, heavy impact. Breaks shell armor; stagger has recovery. Guard reduces damage."},
 "gun":{"name":"Brasslock carbine","damage":34,"reach":420.0,"time":.72,"cost":{"iron":4,"copper":3,"parts":2},"tech":"metallurgy","desc":"Aim with the mouse. One cartridge per shot; hits the nearest target. Guard reduces damage."}}
const ARMOR={
 "clothes":{"name":"Travelling clothes","reduction":0.0,"look":0,"cost":{},"tech":""},
 "mail":{"name":"Riveted holdguard mail","reduction":.25,"look":1,"cost":{"iron":5,"wood":2},"tech":""},
 "rune":{"name":"Rune-plated harness","reduction":.45,"look":2,"cost":{"iron":8,"copper":4,"crystal":2,"parts":3},"tech":"metallurgy"}}
var g
var enemies:Array=[]
var map_key=""
var armed=false
var attack_left=0.0
var attack_hit=false
var attack_direction=Vector2.RIGHT
var dodge_left=0.0
var dodge_cooldown=0.0
var dodge_direction=1
var guard=false
var guard_was=false
var guard_reaction=0.0
var guard_parried=false
var parry_left=0.0
var parry_cooldown=0.0
var invulnerable=0.0
var riposte=0.0
var peace=0.0
var traces:Array=[]
func _init(game):g=game
static func defaults()->Dictionary:
 return {"health":100.0,"weapon":"axe","armor":"clothes","owned":["axe","clothes"],"cleared":{},"wounds":{}}
static func normalize(raw:Dictionary)->Dictionary:
 var d=defaults()
 for k in d:if raw.has(k):d[k]=raw[k]
 d.health=clampf(float(d.health),1,100)
 if not d.owned is Array:d.owned=["axe","clothes"]
 for item in ["axe","clothes"]:if not item in d.owned:d.owned.append(item)
 if not WEAPONS.has(d.weapon) or not d.weapon in d.owned:d.weapon="axe"
 if not ARMOR.has(d.armor) or not d.armor in d.owned:d.armor="clothes"
 if not d.cleared is Dictionary:d.cleared={}
 if not d.wounds is Dictionary:d.wounds={}
 return d
func weapon()->Dictionary:return WEAPONS[g.state.combat.weapon]
func profile()->Dictionary:
 var p=g.state.appearance.duplicate();p["armor"]=ARMOR[g.state.combat.armor].look
 p["shield_pose"]=armed and g.state.combat.weapon=="axe"
 p["shield_guard"]=guard and p.shield_pose and (absf(g.velocity.x)<=10 or guard_reaction>0)
 return p
func active()->bool:return g.playing and g.panel_id=="" and not is_instance_valid(g.creator) and g.transition_left<=0
func reset_actions():
 if g.fight!=null:g.fight.cancel_actions()
 guard_reaction=0;guard_parried=false;attack_left=0;dodge_left=0;guard=false;guard_was=false;parry_left=0;traces.clear()
func toggle():
 if not HoldOnboarding.combat_ready(g.state) and not HoldPractice.allowed(g):g.notify("Borin will introduce weapons after your return-route lesson and the lift repairs.");return
 armed=not armed;g.swing=0;reset_actions()
 g.notify("WEAPON READY — LMB attack • RMB guard / timed parry • Q dodge • B equipment" if armed else "Tools ready — 1–4 select tools. F draws your weapon.")
func solid(p:Vector2)->bool:
 if g.room_id=="training":return p.y>=410 or p.x<65 or p.x>890
 return g.geo.at_pos(p) not in [0,12]
func clear_line(a:Vector2,b:Vector2)->bool:
 var length=a.distance_to(b)
 for i in range(1,int(length),4):
  if solid(a.move_toward(b,i)):return false
 return true
func spawn():
 if HoldPractice.allowed(g):
  if map_key!="practice":
   map_key="practice";enemies=[{"id":"practice","p":Vector2(615,410),"home":Vector2(615,410),"kind":0,"hp":999.0,"max":999.0,"state":"idle","timer":0.0,"face":-1,"walk":false,"flash":0.0,"strike":Vector2.ZERO}]
  return
 if not HoldOnboarding.combat_ready(g.state):enemies.clear();map_key="";return
 var key=str(g.geo.seed_value)+"/"+g.state.active_site
 if map_key==key:return
 map_key=key;enemies.clear()
 # Sparse, permanent encounters. Never in the safe gallery and never on timers.
 for slot in 3:
  var id=key+"/"+str(slot)
  if g.state.combat.cleared.has(id):continue
  var home=Vector2(-1,-1)
  for x in range(145+slot*72,mini(365,215+slot*72),3):
   for y in range(53,145):
    var p=Vector2(x*7,y*7)
    if not solid(p+Vector2(0,2)):continue
    var open=true
    for dx in [-24,0,24]:
     for dy in [-50,-25,-2]:
      if solid(p+Vector2(dx,dy)):open=false
    if open:home=p;break
   if home.x>=0:break
  if home.x<0:continue
  var kind=slot%2;var maximum=64.0 if kind==0 else 56.0
  enemies.append({"id":id,"p":home,"home":home,"kind":kind,"hp":float(g.state.combat.wounds.get(id,maximum)),"max":maximum,"state":"idle","timer":0.0,"face":-1,"walk":false,"flash":0.0,"strike":Vector2.ZERO})
func dodge():
 if not HoldOnboarding.combat_ready(g.state) and not HoldPractice.allowed(g):return
 if dodge_cooldown>0 or attack_left>weapon().time*.55:return
 if HoldPractice.allowed(g):HoldOnboarding.fact(g.state,"practice_dodge")
 dodge_left=.24;dodge_cooldown=.58 if HoldDisciplines.has(g.state,"sure_footing") else .72;dodge_direction=g.face;guard=false;parry_left=0
 g.sound.effect("swing",-13)
func attack():
 if attack_left>0 or dodge_left>0:return
 if g.state.combat.weapon=="gun" and g.state.count("ammo")<=0:
  g.notify("No cartridges. Forge a pack, or equip your axe with B.");return
 guard=false;attack_left=weapon().time;attack_hit=false
 var aim=g.get_global_mouse_position()+g.camera-(g.player+Vector2(0,-37))
 attack_direction=aim.normalized() if aim.length()>1 else Vector2(g.face,0)
 g.face=1 if attack_direction.x>=0 else -1
 g.sound.effect("swing",-9)
func update(dt:float):
 if not active():guard=false;guard_was=Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT);parry_left=0;return
 for key in ["guard_reaction","dodge_left","dodge_cooldown","parry_left","parry_cooldown","invulnerable","riposte"]:set(key,maxf(0,float(get(key))-dt))
 for i in range(traces.size()-1,-1,-1):
  traces[i].life-=dt
  if traces[i].life<=0:traces.remove_at(i)
 if (g.zone!="mine" or g.room_id!="") and not HoldPractice.allowed(g):
  reset_actions();peace+=dt
  if peace>2:g.state.combat.health=minf(100,g.state.combat.health+dt*7)
  return
 peace=0;spawn()
 var held=armed and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
 if held and not guard_was and parry_cooldown<=0 and attack_left<=0 and dodge_left<=0:parry_left=.18;parry_cooldown=.55
 guard_was=held;guard=held and attack_left<=0 and dodge_left<=0
 if armed and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not held:attack()
 if attack_left>0:
  attack_left=maxf(0,attack_left-dt)
  if not attack_hit and attack_left<=weapon().time*.45:attack_hit=true;resolve_attack()
 var engaged=0
 for e in enemies:
  e.flash=maxf(0,e.flash-dt);e.walk=false
  if e.hp<=0:continue
  if not solid(e.p+Vector2(0,2)):
   for step in maxi(1,int(140*dt)):
    if solid(e.p+Vector2(0,2)):break
    e.p.y+=1
  var delta=g.player-e.p
  var visible=absf(delta.y)<55 and clear_line(e.p+Vector2(0,-25),g.player+Vector2(0,-25))
  if e.state=="windup":
   e.timer-=dt
   if e.timer<=0:
    var result="miss"
    if delta.length()<82 and absf(delta.y)<45 and signf(delta.x)==e.face and visible:result=receive_hit(e,14 if e.kind==0 else 18)
    if result!="parry":e.state="recover";e.timer=.85
   continue
  if e.state in ["recover","stun"]:
   e.timer-=dt
   if e.timer<=0:e.state="idle"
   continue
  if delta.length()<175 and visible and g.player.distance_to(e.home)<230:
   engaged+=1;e.face=1 if delta.x>=0 else -1
   if absf(delta.x)<67:
    if engaged==1:e.state="windup";e.timer=.7 if e.kind==0 else .85
   else:move_enemy(e,e.face*dt*46)
  elif e.p.distance_to(e.home)>5:move_enemy(e,signf(e.home.x-e.p.x)*dt*35)
func move_enemy(e:Dictionary,dx:float):
 if e.id=="practice":return
 var next=e.p+Vector2(dx,0)
 if not solid(next+Vector2(signf(dx)*22,-24)) and not solid(next+Vector2(0,-45)) and solid(next+Vector2(signf(dx)*18,5)):
  e.p=next;e.walk=true;e.face=1 if dx>0 else -1
func resolve_attack():
 var origin=g.player+Vector2(0,-37)
 var ranged=g.state.combat.weapon=="gun"
 var end=origin+attack_direction*weapon().reach
 if ranged:
  g.state.pay({"ammo":1})
  for i in range(1,int(weapon().reach),3):
   var sample=origin+attack_direction*i
   if solid(sample):end=sample;break
  traces.append({"a":origin.move_toward(end,minf(42,origin.distance_to(end))),"b":end,"life":.12});g.sound.effect("carbine",-5)
 var candidates=[]
 for e in enemies:
  if e.hp<=0:continue
  var target=e.p+Vector2(0,-25);var delta=target-origin
  if ranged:
   if Geometry2D.get_closest_point_to_segment(target,origin,end).distance_to(target)>25:continue
  elif absf(delta.x)>weapon().reach or absf(delta.y)>54 or delta.x*g.face< -10:continue
  if not clear_line(origin,target):continue
  candidates.append(e)
 candidates.sort_custom(func(a,b):return a.p.distance_squared_to(g.player)<b.p.distance_squared_to(g.player))
 for e in candidates:
  var damage=float(weapon().damage)*(1.75 if riposte>0 else 1.0)
  if e.kind==1 and g.state.combat.weapon!="hammer":damage*=.8
  hurt_enemy(e,damage)
  if ranged:break
 if not candidates.is_empty():riposte=0
func hurt_enemy(e:Dictionary,damage:float):
 if e.id=="practice":
  HoldOnboarding.fact(g.state,"practice_hit");g.sound.effect("wood",-18);e.flash=.15;return
 if e.hp<=0:return
 e.hp=maxf(0,e.hp-damage);e.flash=.15
 if g.state.combat.weapon=="hammer" or riposte>0 or e.state!="windup":
  var stagger=.65 if g.state.combat.weapon=="hammer" else .22
  if e.state=="stun":stagger=maxf(stagger,e.timer)
  e.state="stun";e.timer=stagger
 g.state.combat.wounds[e.id]=e.hp
 g.sound.effect("metal" if e.kind else "stone",-7);g.impact_pause=.045
 g.burst(e.p+Vector2(0,-25),Color("d0a46b"),7)
 g.popups.append({"p":e.p+Vector2(0,-65),"text":str(int(damage)),"life":.7})
 if e.hp<=0:
  HoldDisciplines.award(g.state,"warrior",1,g.state.active_site+":"+str(e.id))
  g.state.combat.cleared[e.id]=true;g.state.combat.wounds.erase(e.id)
  var loot={"scrap":3,"copper_ore":2} if e.kind==0 else {"shell":2,"iron_ore":2}
  # Credit immediately and persist defeat atomically: reloads cannot duplicate loot.
  for item in loot:g.state.add(item,loot[item])
  g.notify("Salvage recovered: "+HoldData.cost_text(loot)+". This chamber is now safe.")
  g.save_game()
func receive_hit(e:Dictionary,damage:float)->String:
 if e.id=="practice":
  damage=0
  if guard and (e.p.x-g.player.x)*g.face>=-4:HoldOnboarding.fact(g.state,"practice_guard")
 if dodge_left>.04 or invulnerable>0:return "dodge"
 var front=(e.p.x-g.player.x)*g.face>=-4
 if guard and front:
  if parry_left>0:
   guard_reaction=.25;guard_parried=true;parry_left=0;riposte=1.4;e.state="stun";e.timer=1.1
   g.sound.effect("parry",-16 if e.id=="practice" else -4);g.burst(g.player+Vector2(g.face*24,-40),Color("a4f0da"),10);g.notify("PARRY — strike back for bonus damage!")
   return "parry"
  guard_reaction=.20;guard_parried=false
  damage*=.18 if g.state.combat.weapon=="axe" else .4
  g.sound.effect("metal",-18 if e.id=="practice" else -7)
 damage*=1-float(ARMOR[g.state.combat.armor].reduction)
 g.state.combat.health=maxf(0,g.state.combat.health-damage);invulnerable=.5
 g.burst(g.player+Vector2(0,-35),Color("e5b175"),4)
 if g.state.combat.health<=0:
  g.perform_rescue("Defeated — crew rescue")
 return "block" if guard and front else "hit"
func draw_enemies():
 if (g.zone!="mine" or g.room_id!="") and not HoldPractice.allowed(g):return
 spawn()
 for e in enemies:
  if e.id=="practice":HoldPractice.draw_target(g,e);continue
  if e.hp<=0:continue
  var frame=2 if e.state=="windup" else (3 if e.state=="recover" else (int(g.clock*7)%2 if e.walk else 0))
  var source=Rect2(frame*443.5,0 if e.kind==0 else 500,443.5,500 if e.kind==0 else 387)
  var root=Vector2([205,210,180,115][frame],480) if e.kind==0 else Vector2([220,220,220,250][frame],350)
  var scale=.18 if e.kind==0 else .15
  g.draw_set_transform(e.p+g.A.draw_offset,0,Vector2(e.face,1))
  g.draw_texture_rect_region(ENEMIES,Rect2(-root*scale,source.size*scale),source,Color("ffd4a0") if e.flash>0 else Color.WHITE)
  g.draw_set_transform(g.A.draw_offset)
  A.rect(g,e.p.x-24,e.p.y-80,48,4,"14222e");A.rect(g,e.p.x-24,e.p.y-80,48*e.hp/e.max,4,"cf9867")
  if e.state=="windup":
   A.text(g,e.p+Vector2(-5,-91),"!",23,Color("ffd267"))
   g.draw_arc(e.p+Vector2(e.face*25,-24),34,-1.3,1.3,12,Color(1,.65,.3,.6),2)
  # Warning remains visible before aggro; finite encounters do not respawn.
  if e.state=="idle":A.text(g,e.home+Vector2(-40,-105),"SCRAP CAMP" if e.kind==0 else "SHELL NEST",11,Color("cbb88d"))
 for t in traces:g.draw_line(t.a,t.b,Color(1,.83,.45,t.life/.12),3)
func draw_weapon():
 if not armed:return
 if profile().get("shield_pose",false):
  if guard and parry_left>0:g.draw_arc(g.player+Vector2(g.face*32,-37),18,0,TAU,16,Color("99ffe1"),2)
  return
 var carrying=attack_left<=0
 var frame=posmod(int(g.gait_clock*12),8) if g.walking_pose else 0
 if not carrying and g.state.combat.weapon=="gun":frame=4
 if attack_left>0 and g.state.combat.weapon!="gun":frame=clampi(int((1-attack_left/weapon().time)*8),0,7)
 var hand=HoldCharacterArt.carry_hand(frame,g.state.appearance) if carrying else HoldCharacterArt.work_hand(frame,g.state.appearance)
 var painted=carrying and (g.walking_pose or (not g.grounded and not g.winch))
 var walk_frame=HoldPaintedWalk.frame_index(g.gait_clock,0 if g.grounded or g.winch else (1 if g.velocity.y<0 else 2))
 if painted:hand=HoldPaintedWalk.sockets(g.state.appearance,walk_frame,false).hand
 var p=g.player+hand*Vector2(g.face,1)
 var end=p+Vector2(g.face*32,-8)
 if attack_left>0:end=g.player+HoldCharacterArt.work_end(frame,g.state.appearance,3)*Vector2(g.face,1)
 if g.state.combat.weapon=="gun":
  var direction=attack_direction if attack_left>0 else Vector2(g.face,0)
  var angle=direction.angle()-(PI if g.face<0 else 0)
  g.draw_set_transform(p+g.A.draw_offset,angle,Vector2(g.face,1)*.082)
  g.draw_texture_rect_region(EQUIPMENT,Rect2(-Vector2(240,195),Vector2(700,260)),Rect2(10,810,700,260))
  g.draw_set_transform(g.A.draw_offset)
 else:
  var region=Rect2(710,10,440,625)
  var grip=Vector2(220,470)
  var contact=Vector2(420,130)
  var local=(contact-grip)*Vector2(g.face,1);var delta=end-p
  g.draw_set_transform_matrix(Transform2D(delta.angle()-local.angle(),Vector2(g.face,1)*delta.length()/local.length(),0,p+g.A.draw_offset))
  g.draw_texture_rect_region(EQUIPMENT,Rect2(-grip,region.size),region)
  g.draw_set_transform(g.A.draw_offset)
 if painted:HoldPaintedWalk.draw_grip(g,g.player+g.A.draw_offset,walk_frame,g.state.appearance,g.face,g.A.draw_offset)
 else:HoldCharacterArt.draw_grip(g,g.player+g.A.draw_offset,frame,g.state.appearance,g.face,g.A.draw_offset,Color.WHITE,carrying)
 if dodge_left>0:g.draw_line(g.player+Vector2(-g.face*33,-12),g.player+Vector2(-g.face*13,-12),Color(.6,.9,.9,.6),3)
func panel():
 if not HoldOnboarding.combat_ready(g.state) and not HoldPractice.allowed(g):
  g.label(g.panel_body,"Borin will issue an axe and shield during Keep your feet. First complete the lift commission and Ivar's return-route lesson.",17)
  g.button(g.panel_body,"First-season journal",func():g.open_panel("guidance"));return
 var heading=g.row(g.panel_body)
 var preview=HoldSpritePreview.new();preview.profile=profile();preview.motion="idle";preview.custom_minimum_size=Vector2(80,80);heading.add_child(preview)
 var summary=VBoxContainer.new();summary.size_flags_horizontal=Control.SIZE_EXPAND_FILL;heading.add_child(summary)
 g.label(summary,"%s  •  %s" % [WEAPONS[g.state.combat.weapon].name,ARMOR[g.state.combat.armor].name],18,Color("edc98a"))
 g.label(summary,"Health %d / 100  •  Cartridges %d" % [g.state.combat.health,g.state.count("ammo")],16)
 g.label(summary,"F draw / stow  •  Left click attack  •  Right click guard / parry  •  Q dodge",16)
 var tabs=g.row(g.panel_body)
 for slot in ["weapon","armor"]:
  var tab=g.small_button(tabs,"Weapons" if slot=="weapon" else "Armor",func():g.gear_tab=slot;g.open_panel("equipment",false));tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  if g.gear_tab==slot:tab.modulate=Color("a7e2ce")
 var slot=g.gear_tab
 var items=WEAPONS if slot=="weapon" else ARMOR
 for id in items:
  var item=items[id];var owned=id in g.state.combat.owned;var equipped=g.state.combat[slot]==id
  var body=g.section(g.panel_body,item.name+("  •  Equipped" if equipped else ("  •  Owned" if owned else "")))
  g.label(body,item.get("desc","Damage reduction: %d%%" % int(item.get("reduction",0)*100)),16)
  if owned and not equipped:
   var b=g.button(body,"Equipped" if equipped else "Equip "+item.name,func():g.state.combat[slot]=id;reset_actions();g.save_game();g.refresh_panel());b.disabled=equipped
  elif not owned:
   var reason=g.requirements(item.cost)
   if item.tech!="" and not g.state.tech.has(item.tech):reason="Research "+HoldData.RESEARCH[item.tech].name
   elif g.state.active_site=="hold" and g.state.opening<2:reason="Deliver the first coal commission to relight the forge"
   elif g.room_id!="forge":reason="Visit Borin's workbench to forge this"
   g.label(body,"Materials: "+HoldData.cost_text(item.cost)+"\n"+reason,16,Color("b4c9c4"))
   var b=g.button(body,"Forge & equip "+item.name,func():
    if g.room_id!="forge" or (g.state.active_site=="hold" and g.state.opening<2) or (item.tech!="" and not g.state.tech.has(item.tech)):return
    if g.state.pay(item.cost):g.state.combat.owned.append(id);g.state.combat[slot]=id;reset_actions();g.sound.effect("build");g.save_game();g.refresh_panel())
   b.disabled=reason!="Ready"
