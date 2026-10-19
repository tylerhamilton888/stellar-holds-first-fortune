class_name DeepworksPlay
extends RefCounted
const BUCKET_ART=preload("res://assets/tavern-v492/mining-bucket.png")
var bucket_texture:AtlasTexture
const STONE=preload("res://assets/animation-v51/geology.png")
const A=preload("res://scripts/art.gd")
var g
var world:Deepworks
var haul:DeepHaul
var works:LivingPlay
var mining_method="pick"
var swing_duration=SWING
var rubble:Array=[]
var unload_flash=0.0
const SWING=.32
const IMPACT=.15
var site=""
var survey_open=false
var pulse=0.0
var contact=Vector2.ZERO
var target=Vector2i(-1,-1)
var strike_left=0.0
var struck=false
var contact_hold=0.0
var reveal_clock=0.0
var sparks:Array=[]
var messages:Array=[]
var stair_work=0.0
var passage_kind="stair"
func _init(game):g=game
func ensure():
 if world==null or site!=g.state.active_site or world.data!=g.state.deepworks.get(g.state.active_site,{}):
  site=g.state.active_site;world=Deepworks.new(g.state);haul=DeepHaul.new(g.state,world);works=LivingPlay.new(g,world)
func enter(resume:bool=false):
 ensure()
 if not resume:haul.park();world.data.depth=0;world.data.position=[Deepworks.center(Deepworks.ENTRY).x,Deepworks.center(Deepworks.ENTRY).y]
 works.cancel()
 g.player=Vector2(world.data.position[0],world.data.position[1]);g.grounded=true
 if world.solid(g.player):g.player=Deepworks.center(Deepworks.ENTRY);world.data.depth=0
 g.velocity=Vector2.ZERO;g.camera=camera_target();g.combat.armed=false;g.combat.reset_actions();g.construction.selected="";strike_left=0;contact_hold=0;rubble.clear();sparks.clear();messages.clear()
 world.survey(g.player)
func remember():
 ensure()
 if g.zone=="mine":world.data.position=[g.player.x,g.player.y]
func input(e:InputEvent)->bool:
 if g.zone=="mine" and g.panel_id=="" and works and works.input(e):return true
 if g.zone!="mine" or g.panel_id!="" or not e is InputEventKey or not e.pressed or e.echo:return false
 match e.keycode:
  KEY_E:
   use_stairs(e.shift_pressed);return true
  KEY_V:
   g.open_panel("deepworks");return true
  KEY_X,KEY_TAB,KEY_K:
   survey_open=not survey_open
   if survey_open and world.depth()<world.data.layers.size()-1 and not world.data.get("survey_recorded",false):
    world.data.survey_recorded=true;HoldOnboarding.fact(g.state,"sample");g.save_game()
   return true
  KEY_O:
   g.open_panel("living");return true
  KEY_H:
   g.open_panel("haulage");return true
  KEY_L:
   g.open_panel("projects");return true
  KEY_C:
   g.notify(haul.toggle_cart(g.player));g.sound.effect("wood");g.save_game();return true
  KEY_U:
   if e.shift_pressed:
    var n=haul.load_pile(g.player);g.notify("Loaded %d units." % n);g.sound.effect("wood")
    if n>0:works.masonry.transfer_from=g.player+Vector2(0,10);works.masonry.transfer_to=g.player+Vector2(0,-24);works.masonry.transfer_time=.45
    g.save_game()
   else:unload()
   return true
  KEY_T:
   assign_crew();return true
  KEY_F,KEY_Q,KEY_P:
   g.notify("Deepworks: WASD move · Hold LMB excavate · V stairs / lamps · X survey below");return true
  KEY_R:
   g.open_panel("rescue");return true
 return false
func use_stairs(up:bool):
 ensure();var c=Deepworks.cell(g.player);var old_depth=world.depth()
 if not up and not world.can_descend(c,world.depth()) and works.interact():return
 var travelling_cart=g.handworks.attached()
 var link=world.data.links.get(world.link_key(c,old_depth-1 if up else old_depth),{})
 if link.get("kind","stair")=="ladder" and (not travelling_cart.is_empty() or (not haul.cart().is_empty() and haul.cart().get("hitched",false))):
  g.notify("Park the wheelbarrow [C], or widen this ladder into stairs from its upper landing [V].");return
 if world.traverse(c,up):
  works.cancel()
  haul.stairs(Deepworks.center(c),old_depth)
  g.player=Deepworks.center(c);g.handworks.arrive(travelling_cart);g.velocity=Vector2.ZERO;strike_left=0;contact_hold=0;rubble.clear();sparks.clear();messages.clear();pulse=0
  g.begin_transition("DEPTH %d · %s" % [world.depth()+1,Deepworks.NAMES[world.depth()].to_upper()]);g.sound.effect("door",-16)
  world.survey(g.player);g.save_game();return
 if world.entrance(g.player):
  unload();haul.park()
  if g.state.active_site=="hold":g.surface.enter("trail",Vector2(950,345))
  else:g.change_zone("claim")
 else:g.notify("Stand on stairs: E down / Shift+E up. V carves stairs beneath your feet.")
func panel():
 ensure();g.label(g.panel_body,"THE DEEPWORKS · DEPTH %d / %s" % [world.depth()+1,Deepworks.NAMES[world.depth()]],20)
 g.label(g.panel_body,"WASD moves freely. Hold LMB against an exposed face to excavate. Ordinary rock breaks in one contact; metal and crystal resist. Pick [1], shovel [2], or your powered slagcaster [5].",16)
 g.label(g.panel_body,"Survey [X] shows the ground immediately beneath your feet. Stairs connect the exact same location on both levels and stay open permanently. E goes down, Shift+E goes up.",16)
 g.button(g.panel_body,"Carve descending stair · free · hold still for 1.2 seconds",func():
  g.close_panel();passage_kind="stair";stair_work=1.2;g.notify("Carving a safe stair landing… stay still."))
 g.button(g.panel_body,"Fit timber ladder shaft · 2 timber · bucket and Dwarfs only",func():
  g.close_panel();passage_kind="ladder";stair_work=1.2;g.notify("Fitting an anchored ladder… stay still."))
 g.label(g.panel_body,"Ladders make a compact one-tile shaft. Stairs open a wider landing for carts and MOTE-1. Carve stairs at a ladder’s upper landing to upgrade it. Descend and return to prove a safe route for Ivar.",16)
 g.button(g.panel_body,"Place warm work lamp · 1 timber + 1 coal",func():
  var k=Deepworks.key(Deepworks.cell(g.player))
  if world.layer().fixtures.has(k):g.notify("A lamp already stands here.")
  elif g.state.pay({"wood":1,"coal":1}):world.layer().fixtures[k]="lamp";g.sound.effect("build");g.save_game()
  else:g.notify("A lamp needs 1 timber and 1 coal.")
  g.close_panel())
 g.button(g.panel_body,"Assign mining crew to this depth [T]",func():assign_crew();g.close_panel())
 g.label(g.panel_body,"Crew walk excavated tunnels and use connected stairs. Their existing mineral priorities, provisions, coal and industrial unlocks still apply. M manages recruitment and priorities. Basalt needs Tempered steel. Lamps illuminate work areas.",16)
 g.button(g.panel_body,"Haulage [H] · bucket / wheelbarrow / stockpiles",func():g.open_panel("haulage"))
 g.button(g.panel_body,"Living Works [O] · rooms / finishing / furnishings",func():g.open_panel("living"))
 g.button(g.panel_body,"Project ledger [L]",func():g.open_panel("projects"))
 g.label(g.panel_body,"Discoveries: "+(", ".join(world.data.discoveries) if not world.data.discoveries.is_empty() else "Follow seams into untouched rock."),16)
func assign_crew():
 ensure()
 if g.agents.is_empty():g.notify("Recruit and assign miners at your claimed mountain first. M opens your crew ledger.");return
 for agent in g.agents:
  var entry=crew_entry(agent);entry.assigned=world.depth();agent.path=[];agent.target=Vector2i(-1,-1)
 g.notify("Crew assigned to depth %d. They will follow your excavated tunnels and stairs." % (world.depth()+1));g.save_game()
func crew_entry(agent:Dictionary)->Dictionary:
 ensure()
 if not world.data.crew.has(agent.id):world.data.crew[agent.id]={"depth":0,"assigned":0,"x":Deepworks.center(Deepworks.ENTRY).x,"y":Deepworks.center(Deepworks.ENTRY).y}
 return world.data.crew[agent.id]
func move(dt:float):
 if g.handworks.approaching:return
 ensure();var axis=Input.get_vector("left","right","up","down")
 if axis!=Vector2.ZERO and not g.combat.armed:g.surface.direction=axis
 g.velocity=g.fight.movement(axis);var old=g.player
 for i in maxi(1,int(ceil(dt*120))):
  var step=g.velocity*dt/maxi(1,int(ceil(dt*120)))
  var next=g.player+Vector2(step.x,0)
  if not world.solid(next):g.player=next
  next=g.player+Vector2(0,step.y)
  if not world.solid(next):g.player=next
 g.grounded=true;g.walking_pose=g.player.distance_to(old)>.01
 if absf(axis.x)>.05:g.face=1 if axis.x>0 else -1
 if g.walking_pose:
  HoldDrawnLocomotion.advance(g,g.player.distance_to(old),"stone")
 if stair_work>0:
  if g.walking_pose:stair_work=0;g.notify("Passage work cancelled. Stand still to finish.")
  else:
   stair_work-=dt
   if stair_work<=0:g.notify(world.carve_stairs(Deepworks.cell(g.player),passage_kind));g.sound.effect("build");g.save_game()
 reveal_clock-=dt
 if reveal_clock<=0:
  reveal_clock=.13
  for name in world.survey(g.player):g.notify("DISCOVERY · "+name);g.sound.effect("crystal",-12)
 haul.follow(g.player)
 haul.scavenge(g.player)
 remember()
func mine(dt:float):
 if g.combat.armed:strike_left=0;return
 ensure();works.masonry.tick(dt);pulse=maxf(0,pulse-dt);unload_flash=maxf(0,unload_flash-dt)
 for i in range(rubble.size()-1,-1,-1):
  rubble[i].life-=dt
  if rubble[i].life<=0:rubble.remove_at(i)
 for i in range(sparks.size()-1,-1,-1):
  sparks[i].life-=dt;sparks[i].p+=sparks[i].v*dt;sparks[i].v*=exp(-dt*4)
  if sparks[i].life<=0:sparks.remove_at(i)
 for i in range(messages.size()-1,-1,-1):
  messages[i].life-=dt;messages[i].p.y-=dt*20
  if messages[i].life<=0:messages.remove_at(i)
 if contact_hold>0:contact_hold=maxf(0,contact_hold-dt);return
 if strike_left>0:
  strike_left=maxf(0,strike_left-dt)
  if strike_left<=IMPACT and not struck:
   struck=true
   if not works.pending.is_empty():works.impact()
   elif target.x>=0 and contact.distance_to(g.player)<(200 if g.mining_gun.selected else 112) and world.visible(g.player,contact):hit(target,g.mining_gun.selected)
  return
 if g.hotbar.blocked_work():return
 if works.mode!="":works.begin();return
 if stair_work>0:return
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and g.mining_buffer<=0:return
 g.mining_buffer=0
 if g.tool not in [0,1,3] and not g.mining_gun.selected:g.notify("Equip pick [1], shovel [2], or fracture hammer [4].");return
 var aim=g.get_global_mouse_position()+g.camera
 target=world.target(g.player,aim,180 if g.mining_gun.selected else 78)
 if target.x<0:return
 # The collision surface is authoritative; short automatic approach closes tool reach.
 contact=g.player
 for i in range(1,190):
  contact=g.player+(Deepworks.center(target)-g.player).normalized()*i
  if Deepworks.cell(contact)==target:break
 var reach=15.0 if contact.y>g.player.y and absf(contact.y-g.player.y)>absf(contact.x-g.player.x)*1.35 else 40.0
 if not g.mining_gun.selected and contact.distance_to(g.player)>reach+2 and Input.get_vector("left","right","up","down")==Vector2.ZERO:
  var approach=(contact-g.player).normalized();var next=g.player+approach*minf(185*dt,contact.distance_to(g.player)-reach)
  if not world.solid(next):HoldDrawnLocomotion.advance(g,g.player.distance_to(next),"stone");g.player=next;g.surface.direction=approach;g.walking_pose=true;return
 g.face=1 if contact.x>=g.player.x else -1
 mining_method="hammer" if g.tool==3 else ("careful" if Input.is_key_pressed(KEY_SHIFT) else "pick")
 swing_duration=.44 if mining_method=="careful" else SWING
 strike_left=swing_duration;struck=false;g.sound.effect("swing",-20)
func hit(c:Vector2i,thermal:bool=false):
 if thermal:
  if not g.state.outpost.get("mining_gun",false):return
  var charge=int(g.state.outpost.get("gun_charge",0))
  if charge<=0:
   if not g.state.pay({"energy_cell":1}):g.notify("No energy cells. Craft cells at a powered forge.");return
   charge=24 if maxi(HoldIndustry.tier(g.state),HoldIndustry.tier(g.state,"hold"))>=2 else 16
  g.state.outpost.gun_charge=charge-1;g.sound.effect("thermal_pulse",-12)
 var result=world.strike(c,-1,thermal,false,mining_method)
 if result.is_empty():return
 if result.has("blocked"):g.notify("Hard basalt: research Tempered steel at the survey office.");return
 g.sound.impact(result.kind,result.broken);pulse=.14;contact_hold=.035
 var color=ore_color(result.kind) if result.kind in [3,4,5,6] else color(result.kind,world.depth()).lightened(.25)
 for i in (15 if result.broken else 7):sparks.append({"p":contact,"v":Vector2.from_angle(randf()*TAU)*randf_range(30,140),"life":randf_range(.15,.5),"color":color,"kind":result.kind,"size":randf_range(2,5)})
 if result.broken:
  var destination="raw chunk · E to lift" if g.handworks.rock(result,c) else haul.collect(result.item,result.count,g.player)
  works.model.refresh()
  rubble.append({"p":Vector2(c)*40,"kind":result.kind,"life":.42})
  messages.append({"p":Deepworks.center(c),"text":"+%d %s · %s" % [result.count,HoldData.ITEMS[result.item].name,destination],"life":1.25})
  for name in world.survey(g.player):g.notify("DISCOVERY · "+name);g.sound.effect("crystal",-12)
func agents(dt:float):
 ensure()
 if not g.state.agents_enabled or (g.state.claim_id!="legacy" and g.state.active_site!="claim"):return
 var budget=1
 for a in g.agents:
  var saved=crew_entry(a);var z=int(saved.depth)
  var room=works.model.destination(a.id) if a.type=="worker" else {}
  var task=str(room.get("id",""))
  if str(saved.get("room_task",""))!=task:
   saved.room_task=task;a.path=[];a.target=Vector2i(-1,-1)
  if not room.is_empty():saved.assigned=int(room.depth)
  if works.model.data.assignments.has(a.id):works.model.data.assignments[a.id].present=""
  a.p=Vector2(saved.x,saved.y);a.cool-=dt;a.work=false
  if a.fuel<=0:
   var item="food" if a.type=="worker" else "coal"
   if not g.state.pay({item:1}):a.status="Needs "+item;continue
   a.fuel=12 if a.type=="worker" else 18
  if not a.path.is_empty():
   # Recheck terrain so saved/reassigned paths cannot cross a wall.
   var next:Vector2=a.p.move_toward(a.path[0],100*dt)
   if world.solid(next,z):a.path=[];a.target=Vector2i(-1,-1)
   else:
    a.facing=(next-a.p).normalized();a.gait=float(a.get("gait",0))+next.distance_to(a.p)/185.0
    a.p=next;saved.x=next.x;saved.y=next.y;a.status="Walking depth "+str(z+1)
    if next.distance_to(a.path[0])<1:a.path.pop_front()
   continue
  var c=Deepworks.cell(a.p)
  if int(saved.assigned)!=z:
   if a.cool>0 or budget<=0:continue
   budget-=1;a.cool=.4
   var down=int(saved.assigned)>z;var upper=z if down else z-1;var best={}
   for link in world.data.links.values():
    if int(link.upper)!=upper or (a.type=="bot" and link.get("kind","stair")=="ladder"):continue
    var dest=Vector2i(link.x,link.y);var route=world.route(c,z,"",dest)
    if route.is_empty():continue
    if best.is_empty() or route.path.size()<best.path.size():best=route;best.dest=dest
   if best.is_empty():a.status="No stair route to assigned depth";continue
   if best.path.is_empty():saved.depth=z+1 if down else z-1;a.target=Vector2i(-1,-1)
   else:a.path=best.path
   continue
  if a.type=="worker" and works.masonry.worker(a,dt):continue
  if not room.is_empty():
   var stand=works.model.stand(room)
   if c==stand:
    a.work=room.kind=="workshop";a.status="At "+room.name
    works.model.arrived(a.id,room)
    if a.work and a.cool<=0:
     a.cool=1.2
     if z==world.depth() and g.zone=="mine" and a.p.distance_to(g.player)<280:g.sound.effect("metal_0",-28)
    saved.service_time=float(saved.get("service_time",0))+dt
    if saved.service_time>=30:saved.service_time=0;a.fuel=maxi(0,a.fuel-1)
   elif a.cool<=0 and budget>0:
    budget-=1;a.cool=.5
    var room_route=world.route(c,z,"",stand)
    if room_route.is_empty():a.status="No clear route to "+room.name
    else:a.path=room_route.path
   continue
  if a.target.x<0 or world.at(a.target,z)==0:
   if a.cool>0 or budget<=0:continue
   budget-=1;a.cool=.3
   var priority=g.state.outpost.crew[a.id].priority if a.type=="worker" else g.state.priority
   var route=world.route(c,z,priority)
   if route.is_empty():a.status="Open a tunnel to more deposits";a.cool=1.5;continue
   a.target=route.target;a.path=route.path;continue
  if a.p.distance_to(Deepworks.center(a.target))>65:a.target=Vector2i(-1,-1);continue
  a.work=true;a.facing=(Deepworks.center(a.target)-a.p).normalized();a.status="Mining depth %d" % (z+1)
  if a.cool<=0:
   a.cool=.6 if a.type=="worker" else .4
   if a.type=="worker":a.cool/=1.0+HoldClaimStories.trust(g.state,a.id)+works.model.morale_bonus(a.id)
   a.swing=a.cool
   var result=world.strike(a.target,z)
   if result.get("broken",false):
    a.fuel-=1
    if z==world.depth() and g.zone=="mine":messages.append({"p":Deepworks.center(a.target),"text":"Crew +%d %s" % [result.count,result.item],"life":1.2})
 g.remember_agents()
static func ore_color(k:int)->Color:return {3:Color("d9aa7e"),4:Color("f2a566"),5:Color("8b9ba9"),6:Color("79efdb")}.get(k,Color("9aa9ac"))
func color(k:int,z:int)->Color:
 if k==0:return [Color("343e40"),Color("413d3c"),Color("293d43"),Color("393c4c"),Color("303e49")][z%5]
 return {1:Color("807059"),2:Color("64777e"),7:Color("424e65"),3:Color("65737b"),4:Color("756c64"),5:Color("475663"),6:Color("456c75"),8:Color("27313b")}.get(k,Color("63767a"))
# The grid remains authoritative; only the exposed rock silhouette changes.
# Shape and fracture paths are derived from the world seed, never from frame RNG.
func rock_outline(c:Vector2i,damage:float=0.0)->PackedVector2Array:
 var h=posmod(c.x*731+c.y*337+int(world.data.seed),997)
 var a=3+h%7;var b=4+(h/7)%6
 var points=PackedVector2Array([Vector2(a,1),Vector2(28+h%7,0),Vector2(39,b),Vector2(40,25+h%7),Vector2(32,38),Vector2(b,39),Vector2(0,30-h%6),Vector2(1,9+h%5)])
 match h%4:
  1:points=PackedVector2Array([Vector2(2,6),Vector2(27,1),Vector2(39,11),Vector2(37,32),Vector2(25,39),Vector2(4,36),Vector2(0,24),Vector2(1,15)])
  2:points=PackedVector2Array([Vector2(10,0),Vector2(35,3),Vector2(40,15),Vector2(35,28),Vector2(28,40),Vector2(9,37),Vector2(1,26),Vector2(3,9)])
  3:points=PackedVector2Array([Vector2(4,3),Vector2(24,0),Vector2(38,7),Vector2(40,29),Vector2(34,36),Vector2(13,40),Vector2(0,32),Vector2(2,16)])
 if damage>=.3:points[2]+=Vector2(-3,3);points.insert(3,Vector2(35,17+h%5))
 if damage>=.65:points[0]+=Vector2(3,4);points[points.size()-2]+=Vector2(4,-3)
 return points
func rock_face(c:Vector2i,k:int,base:Color,damage:float):
 var p=Vector2(c)*Deepworks.TILE;var h=posmod(c.x*731+c.y*337+int(world.data.seed),997)
 var points=rock_outline(c,damage);var uv=PackedVector2Array();var poly=PackedVector2Array()
 for v in points:
  poly.append(p+v);uv.append(Vector2(.16,.12)+v/40.0*Vector2(.68,.72))
 g.draw_colored_polygon(poly,base)
 g.draw_polygon(poly,PackedColorArray([Color(base.r*1.65,base.g*1.65,base.b*1.65,1)]),uv,g.handworks.texture(6))
 var center=p+Vector2(16+h%9,15+h%7)
 # Broad lit facets and an undercut edge make each face read as a substantial lump.
 for j in [0,3,5]:
  var a=poly[j];var b=poly[(j+1)%poly.size()]
  g.draw_colored_polygon(PackedVector2Array([a,b,center]),Color(1,1,1,.07) if j==0 else Color(0,0,0,.10 if j==3 else .05))
  g.draw_line(a,b,base.lightened(.23) if j==0 else base.darkened(.35),1.5)
 if damage<=0:return
 var stage=1 if damage<.3 else (2 if damage<.65 else 3)
 var joints=[Vector2(-14,-9),Vector2(15,-5),Vector2(-5,19),Vector2(14,14)]
 for j in stage+1:
  var end=center+joints[(j+h)%4];var bend=center.lerp(end,.53)+Vector2(3 if h%2 else -3,2)
  var path=PackedVector2Array([center,end.lerp(bend,.85),end])
  g.draw_polyline(path,base.darkened(.72),1.2+stage*.55)
  g.draw_line(bend+Vector2(1,-1),end+Vector2(1,-1),base.lightened(.22),.8)
 if stage>=2:
  for j in stage:
   var q=p+Vector2(5+j*12,36+(j%2)*2)
   g.draw_colored_polygon(PackedVector2Array([q,q+Vector2(3,-4),q+Vector2(6,0),q+Vector2(2,3)]),base.lightened(.18))
func draw():
 ensure();g.backdrop.visible=false
 g.draw_set_transform(Vector2.ZERO);g.draw_rect(Rect2(0,0,960,540),Color("101b24"))
 var offset=-g.camera.round()
 if g.state.shake and pulse>0:offset+=Vector2(sin(g.clock*85),cos(g.clock*63))*pulse*12
 A.draw_offset=offset;g.draw_set_transform(offset)
 var room_lamps=works.lamps()
 var z=world.depth();var l=world.layer();var start=Deepworks.cell(g.camera)-Vector2i.ONE
 var aim=world.target(g.player,g.get_global_mouse_position()+g.camera,180 if g.mining_gun.selected else 78)
 for y in range(maxi(0,start.y),mini(Deepworks.H,start.y+17)):
  for x in range(maxi(0,start.x),mini(Deepworks.W,start.x+27)):
   var c=Vector2i(x,y);var id=Deepworks.key(c)
   var explored=l.seen.has(id)
   var k=world.at(c) if explored else int(l.strata[c.y*Deepworks.W+c.x]);var p=Vector2(c)*Deepworks.TILE;var r=Rect2(p,Vector2.ONE*Deepworks.TILE)
   var h=posmod(x*731+y*337+int(world.data.seed),997)
   var light=clampf(1.14-Deepworks.center(c).distance_to(g.player)/500,.35,1.0)
   for lamp_key in l.fixtures:
    var xy=lamp_key.split(",");var lp=Deepworks.center(Vector2i(int(xy[0]),int(xy[1])))
    light=maxf(light,clampf(1.0-lp.distance_to(Deepworks.center(c))/250,.0,.9))
   for lp in room_lamps:light=maxf(light,clampf(1.05-lp.distance_to(Deepworks.center(c))/290,0,.95))
   if not explored:light=.22
   var base=color(k,z).lightened((sin(x*.4+y*.2)*.035+.035) if k==0 else float(h%5)/100).darkened(1-light)
   g.draw_rect(r,base)
   var texture_rect=Rect2(posmod(x*40,600),posmod(y*40,600),40,40)
   if not explored:
    g.draw_texture_rect_region(STONE,r,texture_rect,Color(.16,.20,.24,1))
    continue
   if k==0:
    g.draw_texture_rect_region(STONE,r,Rect2(texture_rect.position+Vector2(0,627),texture_rect.size),Color(.48,.54,.56,1).darkened(1-light))
    if world.at(c+Vector2i.UP)!=0:g.draw_rect(Rect2(p,Vector2(40,8)),Color(0,0,0,.22))
    if world.at(c+Vector2i.LEFT)!=0:g.draw_rect(Rect2(p,Vector2(5,40)),Color(0,0,0,.15))
   else:
    var damage=clampf(float(l.damage.get(id,0))/world.resistance(k),0,.99)
    # World-space strata are contiguous across solid cells. Only exposed boundaries
    # receive a cut edge; an unexcavated mountain never becomes a field of boulders.
    var source=texture_rect
    if z>=3:source.position+=Vector2(627,627)
    g.draw_texture_rect_region(STONE,r,source,Color(.64,.74,.79,1).darkened(1-light))
    if world.at(c+Vector2i.DOWN)==0:
     var edge=Rect2(p+Vector2(0,22),Vector2(40,18))
     g.draw_texture_rect_region(STONE,edge,Rect2(Vector2(627+posmod(x*40,600),posmod(y*18,600)),Vector2(40,18)),Color(.59,.65,.68,1).darkened(1-light))
     g.draw_line(p+Vector2(0,22),p+Vector2(40,22),base.lightened(.27),1.5)
     g.draw_line(p+Vector2(0,40),p+Vector2(40,40),Color("131e25"),2)
    for side in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP]:
     if world.at(c+side)==0:
      var a=p+Vector2(40 if side==Vector2i.RIGHT else 0,0)
      var b=a+(Vector2(40,0) if side==Vector2i.UP else Vector2(0,40))
      g.draw_line(a,b,base.lightened(.22),2)
    if damage>0:
     var crack=PackedVector2Array([p+Vector2(9,3),p+Vector2(20,14),p+Vector2(15,22),p+Vector2(28,35)])
     g.draw_polyline(crack,Color("17242c"),1+damage*3)
     if damage>.4:g.draw_polyline(PackedVector2Array([p+Vector2(20,14),p+Vector2(30,13),p+Vector2(38,6)]),Color("17242c"),1+damage*2)
    if k in [3,4,5,6]:
     var oc=ore_color(k).darkened(1-light)
     for j in [2,4,7][world.grade(c)]:
      var q=p+Vector2(9+(h+j*7)%24,9+(h/9+j*7)%20)
      var points=PackedVector2Array([q+Vector2(-3,1),q+Vector2(0,-7 if k==6 else -3),q+Vector2(4,0),q+Vector2(2,5)])
      g.draw_colored_polygon(points,oc);g.draw_line(q+Vector2(0,-4),q+Vector2(0,3),oc.lightened(.3),1)
    if c==aim and g.panel_id=="":
     # Target uses the actual collision footprint, not an unrelated round prop.
     g.draw_rect(r.grow(-2),Color("efd395"),false,1.5)
 # Large angular fragments briefly keep the broken face's volume before settling.
 for rock in rubble:
  var progress=1.0-rock.life/.42
  for j in 6:
   var q=rock.p+Vector2(8+j%3*12,8+j/3*18)+Vector2(j%3-1,j/3)*progress*14
   var size=(9.0+j%2*3)*(1-progress*.8)
   var tint=ore_color(rock.kind) if rock.kind in [3,4,5,6] and j%2==0 else color(rock.kind,z)
   g.draw_colored_polygon(PackedVector2Array([q+Vector2(-size,-size*.5),q+Vector2(size*.1,-size),q+Vector2(size,size*.2),q+Vector2(size*.2,size*.7)]),Color(tint,minf(1,rock.life*5)))
 # Geological landmarks are discovered through line of sight, never through solid rock.
 for f in l.features:
  if not f.found:continue
  var p=Deepworks.center(Vector2i(f.x,f.y))
  if f.type in [0,1]:
   g.surface.world.detail(3,p+Vector2(0,20),110 if f.type==1 else 78)
  else:
   for j in 3:
    var q=p+Vector2((j-1)*55,(j%2)*25)
    g.surface.world.detail(4,q,48,70)
   A.text(g,p+Vector2(-60,55),"THE OATH STILL HOLDS",10,Color("b9b4a0"))
 for link in world.data.links.values():
  if z not in [int(link.upper),int(link.lower)]:continue
  var c=Vector2i(link.x,link.y)
  if not l.seen.has(Deepworks.key(c)):continue
  var p=Vector2(c)*40
  g.surface.world.detail(5,p+Vector2(20,39),40,38)
  A.text(g,p+Vector2(-4,-70),"E ↓" if z==int(link.upper) else "⇧ E ↑",12,Color("efd395"))
 for id in l.fixtures:
  var xy=id.split(",");lamp(Deepworks.center(Vector2i(int(xy[0]),int(xy[1]))))
 if z==0:
  var entry=Deepworks.center(Deepworks.ENTRY)
  g.draw_rect(Rect2(entry-Vector2(46,32),Vector2(92,64)),Color("1d292e"))
  for j in 5:
   var tread=Rect2(entry+Vector2(-42,-29+j*12),Vector2(84,9))
   g.surface.house.material(0,tread,Color(.72+j*.04,.74+j*.04,.72+j*.04))
   g.draw_line(tread.position+Vector2(0,9),tread.end,Color("b2b5a6"),1)
  lamp(entry+Vector2(-58,0));lamp(entry+Vector2(58,0))
  draw_worksite(entry)
  A.text(g,entry+Vector2(-64,-93),"KELDRATH ↑",15,Color("edcd8a"));A.text(g,entry+Vector2(-65,53),"E · RETURN HOME",12,Color("b9cbc0"))
 works.draw()
 draw_haulage()
 var actors:Array=[]
 for a in g.agents:
  if int(crew_entry(a).depth)==z:actors.append({"p":a.p,"agent":a})
 actors.append_array(g.fight.objects())
 actors.append_array(g.handworks.objects())
 actors.append({"p":g.player,"player":true});actors.sort_custom(func(a,b):return a.p.y<b.p.y)
 for actor in actors:
  var p:Vector2=actor.p
  g.draw_set_transform(offset)
  g.draw_circle(p+Vector2(0,3),17,Color(0,0,0,.23))
  if actor.get("kind","")=="fighter":g.fight.draw_enemy(actor.enemy)
  elif actor.get("kind","")=="handwork":g.handworks.draw_object(actor)
  elif actor.has("player"):
   if g.combat.armed:g.fight.draw_player(p+Vector2(0,12),1.0,offset);continue
   var profile=g.state.appearance.duplicate();profile.air_pose=0;profile.gait_time=g.gait_clock
   var pose=g.handworks.work_pose()+Vector2(0,12)
   var facing_dir=(contact-p).normalized() if strike_left>0 else g.surface.direction
   var action=1-strike_left/swing_duration if strike_left>0 else 0.0
   var animation=["pick","shovel","axe","hammer"][g.tool] if strike_left>0 else ""
   if g.handworks.working:
    var station=g.handworks.facility()
    if not station.is_empty() and not station.job.is_empty():
     facing_dir=(g.handworks.pos(station)-p).normalized();action=fmod(float(station.job.progress),.42)/.42
     animation="saw" if station.kind=="saw" else "hammer"
   elif g.handworks.carry_action()!="":animation=g.handworks.carry_action();action=g.handworks.carry_phase()
   elif g.handworks.pushing():animation="push"
   HoldDrawnAnimation.paint(g,pose+offset,profile,facing_dir,g.walking_pose and strike_left<=0,g.gait_clock,1.0,offset,animation,action)
   g.draw_set_transform(offset)
   if strike_left<=0:works.masonry.carry(p,g.face,haul.bucket())
   if animation=="":g.hotbar.held(g,pose,offset)
   g.handworks.carried(pose)
   if bucket_visible():draw_bucket(p+Vector2(-g.face*22,5),haul.bucket(),DeepHaul.BUCKET)
   if strike_left>0 and g.mining_gun.selected:g.draw_line(pose+Vector2(24,-30),contact,Color("c4f4e2"),3)
  else:
   var a=actor.agent
   if a.type=="bot":A.bot(g,p+Vector2(0,10),g.clock,a.work)
   else:
    var profile=g.state.npc(a.id);var assigned=works.model.destination(a.id)
    if a.work and not assigned.is_empty() and assigned.kind=="workshop":
     var phase=fposmod(g.clock,.8)/.8
     HoldDrawnAnimation.paint(g,p+Vector2(0,12)+offset,profile,Vector2(1,.45),false,g.clock,1.0,offset,"hammer",phase)
    else:
     var phase=fposmod(1.5-float(a.cool)/maxf(.1,float(a.get("swing",.6))),1.0)
     HoldDrawnAnimation.paint(g,p+Vector2(0,12)+offset,profile,a.get("facing",Vector2.DOWN),not a.path.is_empty(),float(a.get("gait",0)),1.0,offset,"pick" if a.work else "",phase)
    if works.masonry.data.jobs.has(a.id) and not a.work:works.masonry.carry(p,1,works.masonry.data.jobs[a.id].cargo)
    if works.model.data.assignments.has(a.id):A.text(g,p+Vector2(-35,-81),g.state.npc(a.id).first_name+" · "+works.model.data.folk[a.id].activity,10,Color("dfc695"))
 g.draw_set_transform(offset)
 works.masonry.foreground()
 for s in sparks:
  var tint=Color(s.color,clampf(s.life*4,0,1))
  if int(s.get("kind",2))==6:g.draw_line(s.p,s.p+s.v.normalized()*s.size*2,tint,2)
  elif int(s.get("kind",2))==1:g.draw_circle(s.p,s.size*1.8,Color(tint,.24*clampf(s.life*4,0,1)))
  else:g.draw_rect(Rect2(s.p,Vector2.ONE*s.size),tint)
 for m in messages:A.text(g,m.p,m.text,13,Color(1,.88,.62,minf(1,m.life)))
 if pulse>0:g.draw_arc(contact,4+(1-pulse/.14)*17,0,TAU,12,Color(1,.9,.7,pulse*5),2)
 g.draw_set_transform(Vector2.ZERO);A.draw_offset=Vector2.ZERO
 g.draw_rect(Rect2(0,0,960,74),Color("0e202c"));g.draw_line(Vector2(24,73),Vector2(936,73),Color("63756c"))
 g.draw_rect(Rect2(0,462,960,36),Color(.04,.09,.12,.9));g.draw_rect(Rect2(0,498,960,42),Color("0e202c"))
 A.text(g,Vector2(24,485),"DEPTH %d / %d · %s" % [z+1,world.data.layers.size(),Deepworks.NAMES[z]],14,Color("eac98b"))
 var tool_name="Slagcaster" if g.mining_gun.selected else ["Pick","Shovel","Axe","Hammer"][clampi(g.tool,0,3)]
 if aim.x>=0 and g.panel_id=="" and not g.combat.armed:
  var k=world.at(aim);var d=float(l.damage.get(Deepworks.key(aim),0));var name=world.grade_label(aim)+" "+HoldData.TILES[k].name
  A.text(g,Vector2(680,480),tool_name+" · "+name,12,ore_color(k));g.draw_rect(Rect2(680,487,250,3),Color("2b414a"));g.draw_rect(Rect2(680,487,250*d/world.resistance(k),3),Color("cbb57e"))
 elif g.panel_id=="" and not g.combat.armed:A.text(g,Vector2(680,485),tool_name+" · 1–4 change tool",12,Color("b9d0c8"))
 if g.panel_id=="":
  g.draw_style_box(works.chip(),Rect2(20,82,470 if not haul.cart().is_empty() else 235,25))
  A.text(g,Vector2(30,99),"H · Bucket %d / %d%s" % [DeepHaul.amount(haul.bucket()),DeepHaul.BUCKET,"   Cart %d / %d · %s" % [DeepHaul.amount(haul.cart().cargo),DeepHaul.CART,"in hand" if haul.cart().hitched else "parked D%d" % (int(haul.cart().depth)+1)] if not haul.cart().is_empty() else ""],12,Color("e3c993"))
 if stair_work>0:A.text(g,Vector2(360,400),"CARVING STAIRS… %d%%" % int((1-stair_work/1.2)*100),16,Color("ebcd8e"))
 if survey_open and g.panel_id=="":draw_survey()
 works.hud()
 g.handworks.overlay();g.fight.overlay()
 if g.panel_id!="":g.draw_rect(Rect2(0,0,960,540),Color(.02,.045,.06,.55))
func lamp(p:Vector2):
 for r in [68,48,32,18]:g.draw_circle(p-Vector2(0,15),r,Color(1,.72,.35,.025))
 g.surface.prop(p+Vector2(0,12),3,42)
func draw_survey():
 var z=world.depth();var c=Deepworks.cell(g.player)
 g.draw_rect(Rect2(708,112,228,270),Color("142934"));g.draw_rect(Rect2(708,112,228,270),Color("a58c5e"),false,1)
 A.text(g,Vector2(720,135),"SURVEY · LAYER BELOW",13,Color("edcc8c"))
 if z>=world.data.layers.size()-1:A.text(g,Vector2(720,162),"UNSURVEYED FRONTIER",12);return
 for y in range(-5,6):
  for x in range(-6,7):
   var k=world.at(c+Vector2i(x,y),z+1)
   g.draw_rect(Rect2(720+(x+6)*16,150+(y+5)*16,15,15),ore_color(k) if k in [3,4,5,6] else color(k,z+1))
 g.draw_rect(Rect2(720+6*16,150+5*16,15,15),Color("ffffff"),false,2)
 A.text(g,Vector2(720,347),"WHITE: YOUR X / Y",11,Color("c3d5c9"))
 A.text(g,Vector2(720,365),"V: CARVE   X: CLOSE",11,Color("c3d5c9"))

func draw_worksite(entry:Vector2):
 # Original construction details: timber portal, freight track, crates and tools.
 for side in [-1,1]:
  var p=entry+Vector2(side*76,-65)
  g.draw_rect(Rect2(p,Vector2(12,55)),Color("3c3027"))
  g.surface.house.material(1,Rect2(p+Vector2(1,1),Vector2(10,53)))
  for yy in [4,41]:
   g.draw_rect(Rect2(p+Vector2(0,yy),Vector2(12,7)),Color("495252"));g.draw_circle(p+Vector2(6,yy+3),1.5,Color("d4b779"))
  for j in 3:g.draw_line(p+Vector2(4,6+j*15),p+Vector2(8,16+j*15),Color("5a4836"),1)
  g.draw_circle(p+Vector2(6,7),2,Color("b8aba0"))
 g.draw_rect(Rect2(entry+Vector2(-78,-78),Vector2(166,15)),Color("45382c"))
 g.surface.house.material(1,Rect2(entry+Vector2(-76,-76),Vector2(162,11)))
 for xx in [-70,70]:
  g.draw_rect(Rect2(entry+Vector2(xx,-77),Vector2(8,14)),Color("495252"));g.draw_circle(entry+Vector2(xx+4,-70),2,Color("d4b779"))
 for j in 8:
  var y=entry.y+75+j*12
  var c=Deepworks.cell(Vector2(entry.x,y))
  if world.at(c)==0:
   g.draw_line(Vector2(entry.x-19,y),Vector2(entry.x+19,y),Color("736348"),4)
   for side in [-1,1]:g.draw_line(Vector2(entry.x+side*13,y-6),Vector2(entry.x+side*13,y+6),Color("9ca9a6"),2)
 for j in 3:
  var p=entry+Vector2(-126+j%2*27,28+j/2*27)
  g.surface.prop(p+Vector2(14,23),0,36)


func camera_target()->Vector2:return Vector2(clampf(g.player.x-480,0,Deepworks.W*40-960),clampf(g.player.y-290,0,Deepworks.H*40-540))

func unload():
 if g.zone!="mine":g.notify("Deliver cargo at the mine entrance.");return
 ensure();g.notify(haul.unload(g.player));unload_flash=.8;g.sound.effect("build");g.save_game()
func depart():
 ensure()
 if world.entrance(g.player):haul.unload(g.player)
 haul.park()
func haulage_panel():
 ensure()
 if g.zone!="mine":
  g.label(g.panel_body,"Enter the Deepworks to handle containers. Your bucket retains: "+DeepHaul.contents(haul.bucket()),16)
  return
 g.label(g.panel_body,"BUCKET · %d / %d units" % [DeepHaul.amount(haul.bucket()),DeepHaul.BUCKET],20)
 g.label(g.panel_body,DeepHaul.contents(haul.bucket()),16)
 g.label(g.panel_body,"U: unload / cache · Shift+U: load piles · C: take / park cart. Overflow stays safe.",14)
 g.button(g.panel_body,"Unload [U]",func():unload();g.open_panel("haulage",false))
 if haul.cart().is_empty():
  g.button(g.panel_body,"Build wheelbarrow here · 6 timber + 2 iron · 320 units",func():
   if g.zone!="mine":g.notify("Build your wheelbarrow inside the mine.")
   elif haul.build_cart(g.player):g.notify("Wheelbarrow ready. C takes or parks it; nearby mining loads it.");g.sound.effect("build");g.save_game()
   else:g.notify("Needs 6 timber and 2 iron ingots in stores.")
   g.open_panel("haulage",false))
 else:
  var cart=haul.cart()
  g.label(g.panel_body,"WHEELBARROW · %d / %d · depth %d · (%d, %d)" % [DeepHaul.amount(cart.cargo),DeepHaul.CART,int(cart.depth)+1,cart.x/40,cart.y/40],20)
  g.label(g.panel_body,DeepHaul.contents(cart.cargo),16)
  g.button(g.panel_body,"Take / park wheelbarrow [C]",func():g.notify(haul.toggle_cart(g.player));g.save_game();g.close_panel())
  g.button(g.panel_body,"Tip nearby wheelbarrow into local stockpile",func():g.notify("Cached %d units." % haul.cache_cart(g.player));g.save_game();g.open_panel("haulage",false))
 g.button(g.panel_body,"Load nearby stockpiles into cart / bucket",func():g.notify("Loaded %d units." % haul.load_pile(g.player));g.save_game();g.open_panel("haulage",false))
 for a in haul.data.piles.values():
  if DeepHaul.amount(a.cargo)>0:g.label(g.panel_body,"Pile · D%d (%d, %d) · %s" % [int(a.depth)+1,a.x,a.y,DeepHaul.contents(a.cargo)],14)
 g.label(g.panel_body,"Stores use the existing inventory and recipes. Entrance deliveries are available to forge, construction and trade. Returning home unloads your bucket and a nearby cart. Crews retain their provisioned delivery service. Parked equipment stays at its recorded location.",16)
 g.button(g.panel_body,"Living Works [O] · rooms / finishing / furnishings",func():g.open_panel("living"))
 g.button(g.panel_body,"Project ledger [L]",func():g.open_panel("projects"))
func project_panel():
 ensure();var project=haul.project()
 g.label(g.panel_body,"TRACKING · "+project.name,20)
 for item in project.cost:
  var need=int(project.cost[item]);var have=g.state.count(item)
  g.label(g.panel_body,"%s · %d / %d stored · %d in field · %d shortage" % [HoldData.ITEMS[item].name,have,need,haul.in_field(item),maxi(0,need-have)],16)
 if project.money>0:g.label(g.panel_body,"Crowns · %d / %d" % [g.state.money,project.money],16)
 g.label(g.panel_body,"Field cargo becomes usable on delivery. Tracking does not reserve or spend supplies. Existing research and workshop prerequisites still apply.",16)
 var choices=g.row(g.panel_body)
 for goal in [["cart","Wheelbarrow"],["iron","Iron"],["steel","Steel"],["assembly","Drive assembly"]]:
  g.small_button(choices,"Track · "+goal[1],func():g.state.hauling.project=goal[0];g.save_game();g.open_panel("projects",false))
 var building_choices=g.row(g.panel_body)
 for goal in [["bench","Workbench"],["anvil","Forge"],["rune","Ancestral pillar"],["stoneworking","Stoneworking"]]:
  g.small_button(building_choices,"Track · "+goal[1],func():g.state.hauling.project=goal[0];g.save_game();g.open_panel("projects",false))
 g.button(g.panel_body,"Open existing workshop / project",func():g.open_panel(project.panel))
func bucket_visible()->bool:
 return DeepHaul.amount(haul.bucket())>0 and strike_left<=0 and not g.handworks.busy_hands()
func draw_bucket(p:Vector2,cargo:Dictionary,capacity:int):
 if bucket_texture==null:
  bucket_texture=AtlasTexture.new();bucket_texture.atlas=BUCKET_ART;bucket_texture.region=BUCKET_ART.get_image().get_used_rect()
 g.draw_texture_rect(bucket_texture,Rect2(p-Vector2(11,24),Vector2(22,32)),false)
 if DeepHaul.amount(cargo)>0:
  var item=str(cargo.keys()[0]);var width=8.0+clampf(float(DeepHaul.amount(cargo))/capacity,0,1)*5
  if item in ["stone","rough_block","dressed_stone"]:g.handworks.sprite(6 if item=="rough_block" else 8,p+Vector2(0,-7),width)
  else:HoldItemArt.draw(g,Rect2(p-Vector2(width/2,15),Vector2(width,8)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
func cargo_art(cargo:Dictionary,p:Vector2,limit:int=8):
 var slot=0
 for item in cargo:
  for j in mini(limit-slot,ceili(float(cargo[item])/20.0)):
   var at=p+Vector2((slot%3-1)*13,-int(slot/3)*8)
   if item in ["stone","dressed_stone"]:g.handworks.sprite(8,at,25)
   elif item=="rough_block":g.handworks.sprite(6,at,27)
   else:HoldItemArt.draw(g,Rect2(at-Vector2(12,22),Vector2(24,22)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
   slot+=1
  if slot>=limit:break
func draw_haulage():
 for a in haul.data.piles.values():
  if int(a.depth)!=world.depth() or DeepHaul.amount(a.cargo)==0:continue
  var p=Deepworks.center(Vector2i(a.x,a.y))+Vector2(0,18)
  if not world.layer().seen.has(Deepworks.key(Vector2i(a.x,a.y))):continue
  g.handworks.sprite(2,p,58);cargo_art(a.cargo,p+Vector2(0,-10))
  A.text(g,p+Vector2(-18,18),str(DeepHaul.amount(a.cargo))+" units",10,Color("e1c997"))
 if not haul.cart().is_empty() and int(haul.cart().depth)==world.depth():
  var cart=haul.cart();var p=haul.cart_pos()+Vector2(28,10) if cart.hitched else haul.cart_pos()
  if not cart.hitched:
   g.handworks.sprite(5,p,90);cargo_art(cart.cargo,p+Vector2(15,-28))
  A.text(g,p+Vector2(-24,23),"%d / 320" % DeepHaul.amount(cart.cargo),10,Color("ecd39e"))
 if world.depth()==0:
  var p=Deepworks.center(Deepworks.ENTRY)+Vector2(-112,-18)
  g.handworks.sprite(2,p,82)
  var cargo={}
  for item in DeepHaul.BULK:
   if g.state.count(item)>0:cargo[item]=g.state.count(item)
  cargo_art(cargo,p+Vector2(0,-10))
  A.text(g,p+Vector2(-40,25),"U · HOLD STORES",10,Color("e3c58f"))
  if unload_flash>0:
   for j in 10:g.draw_circle(p+Vector2(sin(j)*28,-(1-unload_flash)*35-j%3*7),2,Color(1,.85,.55,unload_flash))
