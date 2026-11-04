class_name HoldInvasion131
extends RefCounted
# The invasion extends the same fortune. Combat wounds and defeats remain with Skirmish.
const PREP=[
 {"name":"Supper for the watch","area":"hearthward","p":Vector2(760,720),"cost":{"barley_bread":4},"line":"Orla sets aside bread for the night watch. Every gate has hungry people behind it."},
 {"name":"Spare gate fittings","area":"forgeward","p":Vector2(1050,720),"cost":{"iron":4},"line":"Borin checks your iron against the gate drawing. The spares go beside the emergency winch."},
 {"name":"Seats for the gathering","area":"crownward","p":Vector2(780,720),"cost":{"wood":6},"line":"Ivar helps fit the public benches. Your neighbors will stand close enough to hear the oath."}]
const FRONTS=[
 {"title":"Hold the Oath Court","area":"crownward","p":Vector2(780,720),"waves":[[0,0,2],[0,2]],"task":"escort","person":"eldric","instruction":"Clear both enemy groups, then escort Eldric and the archive seals to the marked refuge."},
 {"title":"The Copper Kettle refuge","area":"hearthward","p":Vector2(760,720),"waves":[[0,0,2],[2,0,0]],"task":"escort","person":"orla","instruction":"Protect the refuge, then guide Orla and the market families behind the guard line."},
 {"title":"Keep the forge pumps turning","area":"forgeward","p":Vector2(1050,720),"waves":[[2,0],[2,0,0]],"task":"work","person":"borin","instruction":"Defeat the raiders. Hold E at the emergency valve to restore pressure to the fire mains."},
 {"title":"The troll at the Great Stairs","area":"hearthward","p":Vector2(1190,720),"waves":[[3]],"task":"report","person":"ivar","instruction":"A giant blocks the stairs. Each amber circle marks one fist's landing. Move or Space-dodge clear, watch for the second fist, then punish its long recovery. A well-timed parry can interrupt it."},
 {"title":"Close the broken gate","area":"hearthward","p":Vector2(1510,610),"waves":[[2,0,0],[2,2]],"task":"work","person":"borin","instruction":"Clear the breach, then hold E at the emergency winch. The reserve fittings will hold the gate."},
 {"title":"Cut off the service passage","area":"crownward","p":Vector2(1120,720),"waves":[[0,2],[2,0]],"task":"escort","person":"ivar","instruction":"Clear the passage and bring Ivar to the guard line. Skarrin has nowhere left to run."},
 {"title":"Skarrin's last stand","area":"crownward","p":Vector2(780,720),"waves":[[2]],"task":"capture","person":"ivar","instruction":"Confront Skarrin at the Oath Court. Defeat him in combat, then place him in the guards' custody."}]
static func eligible(s)->bool:return HoldClaim127.eligible(s) and HoldClaim127.data(s).get("welcomed",false)
static func data(s)->Dictionary:
 if not eligible(s):return {}
 if not s.surface.has("invasion131"):
  s.surface.invasion131={"stage":0,"prep":{},"front":0,"wave":0,"scene":"","beat":0,"duel":"","trial":"","reputation":{},"escorting":false,"escort":[],"secured":[],"rests":{},"thane":false,"returned":false,"rescues":0}
 var d:Dictionary=s.surface.invasion131
 for k in ["stage","front","wave","beat","rescues"]:d[k]=int(d[k])
 return d
static func active(s)->bool:return eligible(s) and int(data(s).stage)==2
static func combat_here(g)->bool:
 return active(g.state) and not is_instance_valid(g.opening_scene) and g.surface.active() and g.surface.area==FRONTS[data(g.state).front].area
static func front(g)->Dictionary:return FRONTS[data(g.state).front]
static func point(g,p:Vector2,radius:float=14)->Vector2:
 for ring in range(0,13):
  for i in (1 if ring==0 else 16):
   var q=p+Vector2.from_angle(i*TAU/16)*ring*12
   if g.fight.body_open(q,radius):return q
 return p
static func anchor(g)->Vector2:return point(g,front(g).p,32)
static func task_point(g)->Vector2:return point(g,anchor(g)+Vector2(-125,0))
static func refuge(g)->Vector2:
 var a=task_point(g)
 for offset in [Vector2(-90,110),Vector2(0,140),Vector2(-140,0),Vector2(140,0),Vector2(0,-140)]:
  if g.fight.body_open(a+offset) and g.fight.clear(a,a+offset):return a+offset
 return a
static func near(g,p:Vector2)->bool:return g.player.distance_to(p)<70 and g.surface.clear_interaction(g.player,p)
static func enemy_id(s,slot:int)->String:
 var d=data(s);return "invasion131/"+str(d.front)+"/"+str(d.wave)+"/"+str(slot)
static func wave_clear(s)->bool:
 var d=data(s)
 for i in FRONTS[d.front].waves[d.wave].size():
  if not s.combat.cleared.has(enemy_id(s,i)):return false
 return true
static func final_wave(s)->bool:return data(s).wave==FRONTS[data(s).front].waves.size()-1 and wave_clear(s)
static func spawn(g):
 var d=data(g.state);var context="invasion131/"+str(d.front)+"/"+str(d.wave)
 if g.fight.key==context:return
 g.fight.key=context;g.fight.enemies.clear();g.fight.cancel_actions()
 var a=anchor(g);var kinds=front(g).waves[d.wave]
 for i in kinds.size():
  var id=enemy_id(g.state,i)
  if g.state.combat.cleared.has(id):continue
  var p=point(g,a+Vector2(110+i*65,-65+i*55),float(HoldEnemyRoster.spec(kinds[i]).body)+4)
  var e=g.fight.make_enemy(id,p,kinds[i])
  if d.front==6:
   e.profile=HoldRoadCharacters.appearance(g.state,"road_folk:8",HoldAppearance.random_profile(g.state.seed_value+7508,0))
   e.display_name="Skarrin · cornered";e.max=180.0;e.hp=float(g.state.combat.wounds.get(id,180.0))
  g.fight.enemies.append(e)
static func start(g,scene:String)->bool:
 if not eligible(g.state) or is_instance_valid(g.opening_scene) or g.handworks.busy_hands():return false
 var d=data(g.state);var valid=false
 match scene:
  "ceremony":valid=d.stage==0 and d.prep.size()==3 and HoldConversation.local(g,"eirik")
  "king":valid=d.stage==2 and d.front==3 and final_wave(g.state) and combat_here(g) and near(g,task_point(g))
  "return":valid=d.stage==3 and g.surface.area=="crownward" and near(g,point(g,Vector2(780,720)))
  "trial":valid=d.stage==4 and HoldConversation.local(g,"eirik")
  "investiture":valid=d.stage==5 and HoldConversation.local(g,"eirik")
  "home":valid=d.stage==6 and g.surface.area=="trail" and near(g,Vector2(760,905))
 if not valid:return false
 d.scene=scene;d.beat=0;g.save_game();HoldThaneScene131.start_scene(g);return true
static func choose(g,kind:String,value:String)->bool:
 var d=data(g.state)
 if d.is_empty() or not g.opening_scene is HoldThaneScene131:return false
 if kind=="duel" and d.scene=="ceremony" and d.beat==2 and d.duel=="" and value in ["accept","refuse"]:
  d.duel=value;d.reputation["courage" if value=="accept" else "restraint"]=1
 elif kind=="trial" and d.scene=="trial" and d.beat==1 and d.trial=="" and value in ["justice","mercy","lament"]:
  d.trial=value;d.reputation[{"justice":"duty","mercy":"compassion","lament":"discernment"}[value]]=1
 else:return false
 g.save_game();return true
static func complete_scene(g,scene:String)->bool:
 var d=data(g.state)
 if d.is_empty() or d.scene!=scene:return false
 match scene:
  "ceremony":
   if d.duel=="":return false
   d.stage=2
  "king":d.secured.append(3);d.front=4;d.wave=0;g.state.combat.health=minf(100,g.state.combat.health+20)
  "return":d.stage=4
  "trial":
   if d.trial=="":return false
   d.stage=5;HoldOutpost.record(g.state,"skarrin131_verdict","Skarrin was condemned for opening Keldrath to the invaders. The King carried out the sentence. Your testimony: "+d.trial+".")
  "investiture":
   d.stage=6;d.thane=true
   var old=HoldAncestralClaim.data(g.state);old.title="Thane"
   HoldOutpost.record(g.state,"thane131","High King Eirik invested "+g.state.appearance.name+" as Thane of Stonebridge. The same frontier, households and belongings remain. The rebuilding charter rests with its rightful Thane.")
   HoldDisciplines.award(g.state,"warrior",5,"thane131")
  "home":d.stage=7;d.returned=true;HoldOutpost.record(g.state,"thane131_home","You returned to Stonebridge as Thane. Your neighbors welcomed you to the hearth you helped build.")
 d.scene="";d.beat=0;g.fight.reset();g.save_game();return true
static func supply(g,i:int)->bool:
 var d=data(g.state)
 if d.is_empty() or d.stage!=0 or i<0 or i>=PREP.size() or d.prep.has(str(i)) or g.surface.area!=PREP[i].area or not near(g,point(g,PREP[i].p)) or g.handworks.busy_hands() or is_instance_valid(g.opening_scene):return false
 if not g.state.pay(PREP[i].cost):g.notify("Bring "+HoldData.cost_text(PREP[i].cost)+" in your pack.");return false
 d.prep[str(i)]=true;g.notify(PREP[i].line);g.sound.effect("build");g.save_game();return true
static func finish_front(g)->bool:
 var d=data(g.state)
 if not combat_here(g) or not final_wave(g.state) or not near(g,task_point(g)) or g.handworks.busy_hands():return false
 if d.front==3:return start(g,"king")
 if front(g).task=="escort" and not d.escorting:
  d.escorting=true;var p=task_point(g);d.escort=[p.x,p.y];g.close_panel();g.notify("Walk with "+g.state.npc(front(g).person).first_name+" to the marked refuge. Stay close; they follow your lead.");g.save_game();return true
 if front(g).task=="work":g.invasion_work131=true;g.invasion_time131=0;g.close_panel();g.notify("Hold E at the mechanism · moving away cancels");return true
 if front(g).task=="capture":secure(g);return true
 return false
static func secure(g):
 var d=data(g.state);var index=int(d.front)
 d.secured.append(index);d.escorting=false;d.escort=[]
 HoldOutpost.record(g.state,"invasion131_front_"+str(index),front(g).title+" secured.")
 g.state.combat.health=minf(100,g.state.combat.health+20)
 if index==6:d.stage=3
 else:d.front+=1;d.wave=0
 g.fight.reset();g.close_panel();g.sound.effect("quest");g.notify("Position secured. "+goal(g));g.save_game()
static func tick(g,dt:float,held:bool):
 if not active(g.state) or is_instance_valid(g.opening_scene):return
 var d=data(g.state)
 if not combat_here(g):g.invasion_work131=false;return
 if wave_clear(g.state) and not final_wave(g.state):
  d.wave+=1;g.fight.reset();g.notify("Reinforcements at "+front(g).title+". Watch your flanks.");g.save_game();return
 if g.invasion_work131:
  if not final_wave(g.state) or not near(g,task_point(g)) or g.handworks.busy_hands():g.invasion_work131=false;return
  if held:g.invasion_time131+=minf(dt,.1)
  if g.invasion_time131>=3.5:g.invasion_work131=false;secure(g);return
 if d.escorting and final_wave(g.state):
  var p=Vector2(d.escort[0],d.escort[1]);var destination=refuge(g)
  if p.distance_to(g.player)<150 and g.player.distance_to(destination)<p.distance_to(destination)+45:
   var next=p.move_toward(destination,minf(dt,.1)*55)
   if g.fight.body_open(next) and g.fight.clear(p,next):d.escort=[next.x,next.y]
  if Vector2(d.escort[0],d.escort[1]).distance_to(destination)<8 and g.player.distance_to(destination)<85:secure(g);return
 # Guards hold a line and create openings; the player must land the decisive blows.
 g.guard_clock131+=dt
 if g.guard_clock131>=2:
  g.guard_clock131=0
  for e in g.fight.enemies:
   if e.hp>1 and e.p.distance_to(task_point(g))<190 and g.fight.clear(task_point(g),e.p):
    e.hp=maxf(1,e.hp-6);g.state.combat.wounds[e.id]=e.hp;g.fight.stagger(e,.25);g.fight.impact(e.p,.02,Color("a8d6ca"),false);break
static func rescue(g)->bool:
 if not active(g.state) or not HoldWorldZones.ward(g.surface.area):return false
 var d=data(g.state);d.rescues+=1;d.escorting=false;d.escort=[]
 g.invasion_work131=false;g.fight.reset();g.close_panel();g.state.combat.health=85;g.velocity=Vector2.ZERO
 g.surface.enter("room:throne",Vector2(650,700));g.notify("The guard brought you to the royal infirmary. Your secured fronts, belongings and defeated enemies are safe. Return when ready.");g.save_game();return true
static func rest(g)->bool:
 if not active(g.state) or g.surface.area!="room:throne" or not near(g,Vector2(650,700)):return false
 var d=data(g.state);var key=str(d.front)
 if d.rests.has(key):g.notify("The infirmary ration for this front has been used. Meals and rest still help.");return false
 d.rests[key]=true;g.state.combat.health=100;g.state.add("barley_bread",2);g.save_game();g.notify("Patched up · two loaves for the road");return true
static func points(g)->Array:
 if not eligible(g.state):return []
 var d=data(g.state);var out=[]
 if d.stage==0:
  for i in PREP.size():
   if PREP[i].area==g.surface.area and not d.prep.has(str(i)):
    var p=point(g,PREP[i].p);out.append(g.surface.spot(p.x,p.y,PREP[i].name,"invasion131"))
 elif combat_here(g):
  var p=refuge(g) if d.escorting else task_point(g);out.append(g.surface.spot(p.x,p.y,"Refuge" if d.escorting else front(g).title,"invasion131"))
 elif d.stage==3 and g.surface.area=="crownward":
  var p=point(g,Vector2(780,720));out.append(g.surface.spot(p.x,p.y,"Gather the survivors","invasion131"))
 elif d.stage==6 and g.surface.area=="trail":out.append(g.surface.spot(760,905,"Homecoming · your neighbors await","invasion131"))
 if active(g.state) and g.surface.area=="room:throne":out.append(g.surface.spot(650,700,"Royal infirmary","invasion131"))
 return out
static func interact(g)->bool:
 if g.handworks.busy_hands():return false
 for p in points(g):
  if near(g,p.p):g.open_panel("invasion131");return true
 return false
static func goal(g)->String:
 if not eligible(g.state):return ""
 var d=data(g.state)
 match int(d.stage):
  0:return "Before the oath · preparations %d / 3 · J lists ward supplies" % d.prep.size()
  2:return front(g).title+" · "+front(g).area.capitalize()+" · "+("lead your friend to the refuge" if d.escorting else "secure the marked position")
  3:return "Gather the survivors at the Oath Court · Crownward"
  4:return "Skarrin's trial · speak with the King in the royal hall"
  5:return "Your earned title · speak with the King in the royal hall"
  6:return "Thane of Stonebridge · return through King's Gate to your neighbors at the trial yard"
  7:return "Opening chapter complete · Thane of Stonebridge · build, explore and enjoy your home"
 return ""
static func panel(g):
 if not eligible(g.state):return
 var d=data(g.state)
 g.label(g.panel_body,"BEFORE THE OATH" if d.stage==0 else "THE KING RETURNS" if d.stage<6 else "THANE OF STONEBRIDGE",23,Color("edc98a"));g.label(g.panel_body,goal(g),17)
 if d.stage==0:
  g.label(g.panel_body,"The ceremony waits for you. Help prepare the three wards, finish any personal business, and bring your preferred weapon and provisions. No calendar deadline.",16)
  for i in PREP.size():
   var spec=PREP[i];g.label(g.panel_body,("✓ " if d.prep.has(str(i)) else "○ ")+spec.name+" · "+spec.area.capitalize()+" · "+HoldData.cost_text(spec.cost),16)
   if not d.prep.has(str(i)) and g.surface.area==spec.area and near(g,point(g,spec.p)):g.button(g.panel_body,"Deliver · "+spec.name,func():
    if supply(g,i):g.refresh_panel())
  if d.prep.size()==3 and HoldConversation.local(g,"eirik"):g.button(g.panel_body,"I am ready for the investiture",func():start(g,"ceremony"))
 elif d.stage==2:
  g.label(g.panel_body,front(g).instruction,16)
  g.label(g.panel_body,"F ready weapon · LMB strike · RMB guard · Space dodge. The King’s hall is a safe infirmary. Defeat does not erase secured fronts or belongings.",15)
  g.label(g.panel_body,"Enemy group %d / %d · %d fronts secured" % [d.wave+1,front(g).waves.size(),d.secured.size()],16)
  if combat_here(g) and near(g,task_point(g)) and final_wave(g.state) and not d.escorting:g.button(g.panel_body,"Help at the position",func():finish_front(g))
  if g.surface.area=="room:throne" and near(g,Vector2(650,700)):g.button(g.panel_body,"Rest with the infirmary guard",func():
   if rest(g):g.refresh_panel())
 elif d.stage==3:g.button(g.panel_body,"Gather the survivors",func():start(g,"return"))
 elif d.stage==4 and HoldConversation.local(g,"eirik"):g.button(g.panel_body,"Attend Skarrin's trial",func():start(g,"trial"))
 elif d.stage==5 and HoldConversation.local(g,"eirik"):g.button(g.panel_body,"Take the Thane's oath",func():start(g,"investiture"))
 elif d.stage==6 and g.surface.area=="trail":g.button(g.panel_body,"Join the homecoming",func():start(g,"home"))
 elif d.stage==7:g.label(g.panel_body,"The First Fortune · opening chapter complete. Your home, workshops, discoveries and relationships continue here. The rebuilding charter promises a new chapter. For tonight, enjoy the hearth you helped make.",16)
 if d.duel!="":g.label(g.panel_body,"Remembered at court · "+("You accepted the challenge." if d.duel=="accept" else "You refused to turn the oath into a private quarrel."),15)
 if d.trial!="":g.label(g.panel_body,"Your testimony · "+{"justice":"Duty and justice","mercy":"Mercy without denying guilt","lament":"The gifts he squandered"}[d.trial],15)
static func objects(g)->Array:
 var out=[]
 if not combat_here(g):return out
 var a=task_point(g);var d=data(g.state)
 for i in 2:
  var p=point(g,a+Vector2(-35+i*70,70));out.append({"kind":"invasion_person131","p":p,"id":"invasion_guard_"+str(i),"guard":true,"moving":false})
 if front(g).task=="escort":
  var p=Vector2(d.escort[0],d.escort[1]) if d.escorting and d.escort.size()==2 else a
  out.append({"kind":"invasion_person131","p":p,"id":front(g).person,"guard":false,"moving":d.escorting and p.distance_to(g.player)<150})
 return out
static func draw_person(g,o:Dictionary):
 var cam=g.camera.round();var profile=g.state.npc(o.id)
 var action="hammer" if o.guard and g.guard_clock131<.5 else "hold_hammer" if o.guard else "town_walk" if o.moving else ""
 HoldDrawnAnimation.paint(g,o.p-cam,profile,Vector2.RIGHT if o.guard else (refuge(g)-o.p).normalized(),o.moving,g.clock*.3,.85,-cam,action,g.guard_clock131*2 if o.guard else 0)
static func draw_ground(g):
 if not eligible(g.state):return
 var d=data(g.state);var cam=g.camera.round();g.draw_set_transform(-cam)
 if d.stage>=2:
  for i in FRONTS.size():
   if FRONTS[i].area!=g.surface.area or (i>d.front and d.stage==2):continue
   var p=point(g,FRONTS[i].p+Vector2(0,120))
   g.draw_set_transform(p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,38,Color(.10,.08,.06,.3));g.draw_set_transform(-cam)
   # Scorched fallen timber is visual damage, never a new invisible collision wall.
   HoldRawArt135.draw(g,Rect2(p-Vector2(34,28),Vector2(68,34)),"wood",Color(.55,.50,.45))
 if is_instance_valid(g.opening_scene):return
 for marker in points(g):
  g.draw_arc(marker.p,23,0,TAU,24,Color("edc98a"),2,true)
  # The objective and interaction footer identify the marker without covering workers.
 if g.invasion_work131:
  g.draw_rect(Rect2(g.player+Vector2(-28,15),Vector2(56,5)),Color("172a30"));g.draw_rect(Rect2(g.player+Vector2(-28,15),Vector2(56*clampf(g.invasion_time131/3.5,0,1),5)),Color("edc98a"))
