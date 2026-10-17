class_name DeepworksPlay
extends RefCounted
const STONE=preload("res://assets/actors-v11/slate.png")
const A=preload("res://scripts/art.gd")
var g
var world:Deepworks
var site=""
var survey_open=false
var pulse=0.0
var contact=Vector2.ZERO
var target=Vector2i(-1,-1)
var strike_left=0.0
var struck=false
var reveal_clock=0.0
var sparks:Array=[]
var messages:Array=[]
var stair_work=0.0
func _init(game):g=game
func ensure():
 if world==null or site!=g.state.active_site or world.data!=g.state.deepworks.get(g.state.active_site,{}):
  site=g.state.active_site;world=Deepworks.new(g.state)
func enter(resume:bool=false):
 ensure()
 if not resume:world.data.depth=0;world.data.position=[Deepworks.center(Deepworks.ENTRY).x,Deepworks.center(Deepworks.ENTRY).y]
 g.player=Vector2(world.data.position[0],world.data.position[1]);g.grounded=true
 if world.solid(g.player):g.player=Deepworks.center(Deepworks.ENTRY);world.data.depth=0
 g.velocity=Vector2.ZERO;g.camera=camera_target();g.combat.armed=false;g.combat.reset_actions();g.construction.selected="";strike_left=0
 world.survey(g.player)
func remember():
 ensure()
 if g.zone=="mine":world.data.position=[g.player.x,g.player.y]
func input(e:InputEvent)->bool:
 if g.zone!="mine" or g.panel_id!="" or not e is InputEventKey or not e.pressed or e.echo:return false
 match e.keycode:
  KEY_E:
   use_stairs(e.shift_pressed);return true
  KEY_V,KEY_F1:
   g.open_panel("deepworks");return true
  KEY_X,KEY_TAB,KEY_K:
   survey_open=not survey_open;return true
  KEY_T:
   assign_crew();return true
  KEY_F,KEY_Q,KEY_P:
   g.notify("Deepworks: WASD move · Hold LMB excavate · V stairs / lamps · X survey below");return true
  KEY_R:
   g.open_panel("rescue");return true
 return false
func use_stairs(up:bool):
 ensure();var c=Deepworks.cell(g.player)
 if world.traverse(c,up):
  g.player=Deepworks.center(c);g.velocity=Vector2.ZERO;strike_left=0;sparks.clear();messages.clear();pulse=0
  g.begin_transition("DEPTH %d · %s" % [world.depth()+1,Deepworks.NAMES[world.depth()].to_upper()]);g.sound.effect("door",-16)
  world.survey(g.player);g.save_game();return
 if world.entrance(g.player):
  if g.state.active_site=="hold":g.open_panel("basin_map")
  else:g.change_zone("claim")
 else:g.notify("Stand on stairs: E down / Shift+E up. V carves stairs beneath your feet.")
func panel():
 ensure();g.label(g.panel_body,"THE DEEPWORKS · DEPTH %d / %s" % [world.depth()+1,Deepworks.NAMES[world.depth()]],20)
 g.label(g.panel_body,"WASD moves freely. Hold LMB against an exposed face to excavate. Ordinary rock breaks in one contact; metal and crystal resist. Pick [1], shovel [2], or your powered slagcaster [5].",16)
 g.label(g.panel_body,"Survey [X] shows the ground immediately beneath your feet. Stairs connect the exact same location on both levels and stay open permanently. E goes down, Shift+E goes up.",16)
 g.button(g.panel_body,"Carve descending stair · free · hold still for 1.2 seconds",func():
  g.close_panel();stair_work=1.2;g.notify("Carving a safe stair landing… stay still."))
 g.button(g.panel_body,"Place warm work lamp · 1 timber + 1 coal",func():
  var k=Deepworks.key(Deepworks.cell(g.player))
  if world.layer().fixtures.has(k):g.notify("A lamp already stands here.")
  elif g.state.pay({"wood":1,"coal":1}):world.layer().fixtures[k]="lamp";g.sound.effect("build");g.save_game()
  else:g.notify("A lamp needs 1 timber and 1 coal.")
  g.close_panel())
 g.button(g.panel_body,"Assign mining crew to this depth [T]",func():assign_crew();g.close_panel())
 g.label(g.panel_body,"Crew walk excavated tunnels and use connected stairs. Their existing mineral priorities, provisions, coal and industrial unlocks still apply. M manages recruitment and priorities. Basalt needs Tempered steel. Lamps illuminate work areas.",16)
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
 ensure();var axis=Input.get_vector("left","right","up","down")
 var speed=185.0
 g.velocity=axis*speed;var old=g.player
 for i in maxi(1,int(ceil(dt*120))):
  var step=g.velocity*dt/maxi(1,int(ceil(dt*120)))
  var next=g.player+Vector2(step.x,0)
  if not world.solid(next):g.player=next
  next=g.player+Vector2(0,step.y)
  if not world.solid(next):g.player=next
 g.grounded=true;g.walking_pose=g.player.distance_to(old)>.01
 if absf(axis.x)>.05:g.face=1 if axis.x>0 else -1
 if g.walking_pose:
  var before=int(g.gait_clock*20);g.gait_clock+=g.player.distance_to(old)/80.0
  if int(g.gait_clock*20)!=before and posmod(int(g.gait_clock*20),16) in [0,8]:g.sound.footstep("stone")
 else:g.gait_clock=0
 if stair_work>0:
  if g.walking_pose:stair_work=0;g.notify("Stair carving cancelled. Stand still to carve.")
  else:
   stair_work-=dt
   if stair_work<=0:g.notify(world.carve_stairs(Deepworks.cell(g.player)));g.sound.effect("build");g.save_game()
 reveal_clock-=dt
 if reveal_clock<=0:
  reveal_clock=.13
  for name in world.survey(g.player):g.notify("DISCOVERY · "+name);g.sound.effect("crystal",-12)
 remember()
func mine(dt:float):
 ensure();pulse=maxf(0,pulse-dt)
 for i in range(sparks.size()-1,-1,-1):
  sparks[i].life-=dt;sparks[i].p+=sparks[i].v*dt;sparks[i].v*=exp(-dt*4)
  if sparks[i].life<=0:sparks.remove_at(i)
 for i in range(messages.size()-1,-1,-1):
  messages[i].life-=dt;messages[i].p.y-=dt*20
  if messages[i].life<=0:messages.remove_at(i)
 if strike_left>0:
  strike_left=maxf(0,strike_left-dt)
  if strike_left<=.14 and not struck:
   struck=true
   if target.x>=0 and contact.distance_to(g.player)<(200 if g.mining_gun.selected else 112) and world.visible(g.player,contact):hit(target,g.mining_gun.selected)
  return
 if stair_work>0:return
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and g.mining_buffer<=0:return
 g.mining_buffer=0
 if g.tool not in [0,1] and not g.mining_gun.selected:g.notify("Equip pick [1] or shovel [2] to excavate.");return
 var aim=g.get_global_mouse_position()+g.camera
 target=world.target(g.player,aim,180 if g.mining_gun.selected else 78)
 if target.x<0:return
 # Contact is the first actual wall surface; pick head ends here at impact.
 contact=g.player
 for i in range(1,190):
  contact=g.player+(Deepworks.center(target)-g.player).normalized()*i
  if Deepworks.cell(contact)==target:break
 g.face=1 if contact.x>=g.player.x else -1
 strike_left=.28;struck=false;g.sound.effect("swing",-20)
func hit(c:Vector2i,thermal:bool=false):
 if thermal:
  if not g.state.outpost.get("mining_gun",false):return
  var charge=int(g.state.outpost.get("gun_charge",0))
  if charge<=0:
   if not g.state.pay({"energy_cell":1}):g.notify("No energy cells. Craft cells at a powered forge.");return
   charge=24 if maxi(HoldIndustry.tier(g.state),HoldIndustry.tier(g.state,"hold"))>=2 else 16
  g.state.outpost.gun_charge=charge-1;g.sound.effect("thermal_pulse",-12)
 var result=world.strike(c,-1,thermal)
 if result.is_empty():return
 if result.has("blocked"):g.notify("Hard basalt: research Tempered steel at the survey office.");return
 g.sound.impact(result.kind,result.broken);pulse=.14
 var color=ore_color(result.kind) if result.kind in [3,4,5,6] else Color("adada3")
 for i in (15 if result.broken else 7):sparks.append({"p":contact,"v":Vector2.from_angle(randf()*TAU)*randf_range(30,140),"life":randf_range(.15,.5),"color":color,"size":randf_range(2,5)})
 if result.broken:
  messages.append({"p":Deepworks.center(c),"text":"+%d %s" % [result.count,HoldData.ITEMS[result.item].name],"life":1.25})
  for name in world.survey(g.player):g.notify("DISCOVERY · "+name);g.sound.effect("crystal",-12)
func agents(dt:float):
 ensure()
 if not g.state.agents_enabled or (g.state.claim_id!="legacy" and g.state.active_site!="claim"):return
 var budget=1
 for a in g.agents:
  var saved=crew_entry(a);var z=int(saved.depth)
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
    a.p=next;saved.x=next.x;saved.y=next.y;a.status="Walking depth "+str(z+1)
    if next.distance_to(a.path[0])<1:a.path.pop_front()
   continue
  var c=Deepworks.cell(a.p)
  if int(saved.assigned)!=z:
   if a.cool>0 or budget<=0:continue
   budget-=1;a.cool=.4
   var down=int(saved.assigned)>z;var upper=z if down else z-1;var best={}
   for link in world.data.links.values():
    if int(link.upper)!=upper:continue
    var dest=Vector2i(link.x,link.y);var route=world.route(c,z,"",dest)
    if route.is_empty():continue
    if best.is_empty() or route.path.size()<best.path.size():best=route;best.dest=dest
   if best.is_empty():a.status="No stair route to assigned depth";continue
   if best.path.is_empty():saved.depth=z+1 if down else z-1;a.target=Vector2i(-1,-1)
   else:a.path=best.path
   continue
  if a.target.x<0 or world.at(a.target,z)==0:
   if a.cool>0 or budget<=0:continue
   budget-=1;a.cool=.3
   var priority=g.state.outpost.crew[a.id].priority if a.type=="worker" else g.state.priority
   var route=world.route(c,z,priority)
   if route.is_empty():a.status="Open a tunnel to more deposits";a.cool=1.5;continue
   a.target=route.target;a.path=route.path;continue
  if a.p.distance_to(Deepworks.center(a.target))>65:a.target=Vector2i(-1,-1);continue
  a.work=true;a.status="Mining depth %d" % (z+1)
  if a.cool<=0:
   a.cool=.6 if a.type=="worker" else .4
   if a.type=="worker":a.cool/=1.0+HoldClaimStories.trust(g.state,a.id)
   var result=world.strike(a.target,z)
   if result.get("broken",false):
    a.fuel-=1
    if z==world.depth() and g.zone=="mine":messages.append({"p":Deepworks.center(a.target),"text":"Crew +%d %s" % [result.count,result.item],"life":1.2})
 g.remember_agents()
static func ore_color(k:int)->Color:return {3:Color("d9aa7e"),4:Color("f2a566"),5:Color("8b9ba9"),6:Color("79efdb")}.get(k,Color("9aa9ac"))
func color(k:int,z:int)->Color:
 if k==0:return [Color("343e40"),Color("413d3c"),Color("293d43"),Color("393c4c"),Color("303e49")][z%5]
 return {1:Color("807059"),2:Color("64777e"),7:Color("424e65"),3:Color("65737b"),4:Color("756c64"),5:Color("475663"),6:Color("456c75"),8:Color("27313b")}.get(k,Color("63767a"))
func draw():
 ensure();g.backdrop.visible=false
 g.draw_set_transform(Vector2.ZERO);g.draw_rect(Rect2(0,0,960,540),Color("101b24"))
 var offset=-g.camera.round();A.draw_offset=offset;g.draw_set_transform(offset)
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
   if not explored:light=.22
   var base=color(k,z).lightened((sin(x*.4+y*.2)*.035+.035) if k==0 else float(h%5)/100).darkened(1-light)
   g.draw_rect(r,base)
   var texture_rect=Rect2(posmod(x*80,1200),posmod(y*80,1200),80,80)
   if not explored:
    g.draw_texture_rect_region(STONE,r,texture_rect,Color(.23,.29,.34,1))
    continue
   if k==0:
    g.draw_texture_rect_region(STONE,r,texture_rect,Color(.7,.8,.8,.17))
    for j in 16:
     var q=p+Vector2((h+j*17)%39,(h/7+j*11)%39)
     g.draw_line(q,q+Vector2(2+j%3,1),base.lightened(.025+(j%3)*.012),1)
    if h%7==0:
     var q=p+Vector2(12,21)
     g.draw_colored_polygon(PackedVector2Array([q,q+Vector2(5,-3),q+Vector2(11,1),q+Vector2(8,5),q+Vector2(2,4)]),base.lightened(.12))
     g.draw_line(q+Vector2(1,-1),q+Vector2(6,-2),base.lightened(.23),1)
    if h%11==0:g.draw_polyline(PackedVector2Array([p+Vector2(3,3),p+Vector2(12,11),p+Vector2(10,19),p+Vector2(21,28)]),base.darkened(.22),1)
    if world.at(c+Vector2i.UP)!=0:g.draw_rect(Rect2(p,Vector2(40,9)),Color(0,0,0,.28))
    if world.at(c+Vector2i.LEFT)!=0:g.draw_rect(Rect2(p,Vector2(7,40)),Color(0,0,0,.18))
   else:
    # Reuse the game's original stone artwork in continuous world-space, without tile seams.
    g.draw_texture_rect_region(STONE,r,texture_rect,Color(base.r*2.1,base.g*2.1,base.b*2.1,1))
    if world.at(c+Vector2i.UP)==0:g.draw_line(p+Vector2(0,1),p+Vector2(40,1),base.lightened(.25),2)
    if world.at(c+Vector2i.LEFT)==0:g.draw_line(p+Vector2(1,0),p+Vector2(1,40),base.lightened(.15),2)
    if explored and world.at(c+Vector2i.DOWN)==0:
     g.draw_rect(Rect2(p+Vector2(0,30),Vector2(40,10)),base.darkened(.35));g.draw_line(p+Vector2(2,30),p+Vector2(37,30),base.lightened(.23),2)
    if explored and world.at(c+Vector2i.RIGHT)==0:g.draw_line(p+Vector2(39,5),p+Vector2(39,34),base.darkened(.38),3)
    if k in [3,4,5,6]:
     var oc=ore_color(k).darkened(1-light)
     for j in 4:
      var q=p+Vector2(9+(h+j*7)%24,9+(h/9+j*7)%20)
      var points=PackedVector2Array([q+Vector2(-3,1),q+Vector2(0,-7 if k==6 else -3),q+Vector2(4,0),q+Vector2(2,5)])
      g.draw_colored_polygon(points,oc);g.draw_line(q+Vector2(0,-4),q+Vector2(0,3),oc.lightened(.3),1)
    if l.damage.has(id):
     var q=p+Vector2(20,18);g.draw_polyline(PackedVector2Array([q+Vector2(-12,-10),q,q+Vector2(-5,13),q+Vector2(4,16)]),Color("16242c"),2)
     g.draw_line(q,q+Vector2(12,-6),Color("16242c"),2)
    if c==aim and g.panel_id=="":g.draw_rect(r.grow(-1),Color("efd395"),false,2)
 # Geological landmarks are discovered through line of sight, never through solid rock.
 for f in l.features:
  if not f.found:continue
  var p=Deepworks.center(Vector2i(f.x,f.y))
  if f.type==0:
   for j in 5:g.draw_arc(p+Vector2(j*17-34,sin(j)*15),20+j*3,0,TAU,20,Color(.3,.55,.63,.24),2)
  elif f.type==1:
   for j in 7:
    var q=p+Vector2(cos(j*1.9)*60,sin(j*1.9)*36)
    g.draw_colored_polygon(PackedVector2Array([q+Vector2(-9,8),q+Vector2(-4,-14-j*2),q+Vector2(5,-20-j*2),q+Vector2(12,5)]),Color("7dcfcb"))
    g.draw_line(q+Vector2(2,-16-j*2),q+Vector2(2,6),Color("c5f3df"),2)
  else:
   for j in 4:
    var q=p+Vector2(j%2*70-35,j/2*70-35)
    g.draw_rect(Rect2(q-Vector2(12,10),Vector2(24,24)),Color("617779"));g.draw_rect(Rect2(q-Vector2(9,12),Vector2(18,18)),Color("99a69b"))
    g.draw_line(q+Vector2(-3,-7),q+Vector2(4,1),Color("d8ba75"),2)
   A.text(g,p+Vector2(-60,70),"THE OATH STILL HOLDS",10,Color("a5b4a7"))
 for link in world.data.links.values():
  if z not in [int(link.upper),int(link.lower)]:continue
  var c=Vector2i(link.x,link.y)
  if not l.seen.has(Deepworks.key(c)):continue
  var p=Vector2(c)*40
  g.draw_rect(Rect2(p+Vector2(4,3),Vector2(32,34)),Color("172630"))
  for j in 6:g.draw_rect(Rect2(p+Vector2(6+j*.7,5+j*5),Vector2(28-j*1.4,3)),Color("ad9b7c").darkened(j*.08))
  A.text(g,p+Vector2(-4,-70),"E ↓" if z==int(link.upper) else "⇧ E ↑",12,Color("efd395"))
 for id in l.fixtures:
  var xy=id.split(",");lamp(Deepworks.center(Vector2i(int(xy[0]),int(xy[1]))))
 if z==0:
  var entry=Deepworks.center(Deepworks.ENTRY)
  g.draw_rect(Rect2(entry-Vector2(46,32),Vector2(92,64)),Color("4e5146"))
  for j in 5:g.draw_line(entry+Vector2(-42,-25+j*12),entry+Vector2(42,-25+j*12),Color("9a8460"),3)
  lamp(entry+Vector2(-58,0));lamp(entry+Vector2(58,0))
  draw_worksite(entry)
  A.text(g,entry+Vector2(-64,-93),"KELDRATH ↑",15,Color("edcd8a"));A.text(g,entry+Vector2(-65,53),"E · RETURN HOME",12,Color("b9cbc0"))
 var actors:Array=[]
 for a in g.agents:
  if int(crew_entry(a).depth)==z:actors.append({"p":a.p,"agent":a})
 actors.append({"p":g.player,"player":true});actors.sort_custom(func(a,b):return a.p.y<b.p.y)
 for actor in actors:
  var p:Vector2=actor.p
  g.draw_set_transform(offset)
  g.draw_circle(p+Vector2(0,3),17,Color(0,0,0,.23))
  if actor.has("player"):
   var profile=g.state.appearance.duplicate();profile.air_pose=0;profile.gait_time=g.gait_clock
   var frame=4 if strike_left<=.15 else 1
   var pose=p+Vector2(0,12)
   if strike_left>0:
    var palm=pose+HoldCharacterArt.work_hand(4,profile)*Vector2(g.face,1)
    # A short body lean keeps the original grip and full-size tool in contact.
    var delta=contact-palm
    var lean=delta-delta.normalized()*[36.0,40.0,35.0,33.0][g.tool]
    pose+=lean*clampf((.28-strike_left)/.12,0,1)
   A.dwarf(g,pose,g.gait_clock,g.walking_pose and strike_left<=0,g.face,0,false,profile,(frame+.1)/8.0 if strike_left>0 else -1)
   g.draw_set_transform(offset)
   if strike_left>0:
    var hand=pose+HoldCharacterArt.work_hand(frame,profile)*Vector2(g.face,1);var progress=1-strike_left/.28
    var endpoint=contact if progress>=.46 and progress<=.65 else hand+(contact-hand).rotated(-g.face*(1-sin(progress*PI))*.95)
    if g.mining_gun.selected:g.draw_line(hand,contact,Color("c4f4e2"),3)
    else:
     HoldCharacterArt.draw_tool(g,hand+offset,endpoint+offset,g.tool,offset,g.face,-1,1.0)
     HoldCharacterArt.draw_grip(g,pose+offset,frame,profile,g.face,offset,g.character_tint(p))
  else:
   var a=actor.agent
   if a.type=="bot":A.bot(g,p+Vector2(0,10),g.clock,a.work)
   else:A.dwarf(g,p+Vector2(0,12),g.clock,not a.path.is_empty(),1,3,a.work,g.state.npc(a.id))
 g.draw_set_transform(offset)
 for s in sparks:g.draw_rect(Rect2(s.p,Vector2.ONE*s.size),Color(s.color,clampf(s.life*4,0,1)))
 for m in messages:A.text(g,m.p,m.text,13,Color(1,.88,.62,minf(1,m.life)))
 if pulse>0:g.draw_arc(contact,4+(1-pulse/.14)*17,0,TAU,12,Color(1,.9,.7,pulse*5),2)
 g.draw_set_transform(Vector2.ZERO);A.draw_offset=Vector2.ZERO
 g.draw_rect(Rect2(0,0,960,74),Color("0e202c"));g.draw_line(Vector2(24,73),Vector2(936,73),Color("63756c"))
 g.draw_rect(Rect2(0,438,960,60),Color(.04,.09,.12,.88));g.draw_rect(Rect2(0,498,960,42),Color("0e202c"));g.draw_rect(Rect2(18,80,610,25),Color(.035,.08,.12,.82))
 A.text(g,Vector2(24,456),"DEPTH %d / %d · %s" % [z+1,world.data.layers.size(),Deepworks.NAMES[z].to_upper()],16,Color("eac98b"))
 A.text(g,Vector2(24,480),"WASD  MOVE    LMB  DIG    E / SHIFT+E  STAIRS    V  BUILD    X  SURVEY    T  CREW",12,Color("b9d0c8"))
 if aim.x>=0:
  var k=world.at(aim);var d=float(l.damage.get(Deepworks.key(aim),0));var name=HoldData.TILES[k].name
  A.text(g,Vector2(700,453),name,14,ore_color(k));g.draw_rect(Rect2(700,464,210,5),Color("2b414a"));g.draw_rect(Rect2(700,464,210*d/world.resistance(k),5),Color("cbb57e"))
 A.text(g,Vector2(700,487),g.mining_gun.status() if g.mining_gun.selected else ("STEEL PICK" if g.state.steel else "1 PICK / 2 SHOVEL"),11,Color("a9c3bb"))
 if stair_work>0:A.text(g,Vector2(360,400),"CARVING STAIRS… %d%%" % int((1-stair_work/1.2)*100),16,Color("ebcd8e"))
 if survey_open:draw_survey()
func lamp(p:Vector2):
 for r in [40,28,16]:g.draw_circle(p-Vector2(0,15),r,Color(1,.7,.3,.025))
 g.draw_line(p+Vector2(0,8),p-Vector2(0,23),Color("796a4c"),4)
 g.draw_rect(Rect2(p-Vector2(5,26),Vector2(10,13)),Color("e9b76d"));g.draw_rect(Rect2(p-Vector2(3,24),Vector2(6,8)),Color("ffedb5"))
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
  g.draw_rect(Rect2(p+Vector2(2,1),Vector2(7,51)),Color("97794f"))
  for j in 3:g.draw_line(p+Vector2(4,6+j*15),p+Vector2(8,16+j*15),Color("5a4836"),1)
  g.draw_circle(p+Vector2(6,7),2,Color("b8aba0"))
 g.draw_rect(Rect2(entry+Vector2(-78,-78),Vector2(166,15)),Color("45382c"))
 g.draw_rect(Rect2(entry+Vector2(-76,-76),Vector2(162,8)),Color("a48858"))
 for j in 8:
  var y=entry.y+75+j*12
  var c=Deepworks.cell(Vector2(entry.x,y))
  if world.at(c)==0:
   g.draw_line(Vector2(entry.x-19,y),Vector2(entry.x+19,y),Color("736348"),4)
   for side in [-1,1]:g.draw_line(Vector2(entry.x+side*13,y-6),Vector2(entry.x+side*13,y+6),Color("9ca9a6"),2)
 for j in 3:
  var p=entry+Vector2(-126+j%2*27,28+j/2*27)
  g.draw_rect(Rect2(p+Vector2(3,5),Vector2(25,23)),Color(0,0,0,.3))
  g.draw_rect(Rect2(p,Vector2(24,22)),Color("806747"))
  g.draw_rect(Rect2(p+Vector2(3,3),Vector2(18,16)),Color("a08a61"),false,2)
  g.draw_line(p+Vector2(3,4),p+Vector2(20,18),Color("b39a6a"),2)
 # Empty ore tub waits beside the first coal face.
 var tub=entry+Vector2(104,48)
 g.draw_rect(Rect2(tub+Vector2(-17,8),Vector2(36,6)),Color("1b292c"))
 for x in [-10,12]:g.draw_circle(tub+Vector2(x,13),5,Color("24333a"))
 g.draw_colored_polygon(PackedVector2Array([tub+Vector2(-20,-9),tub+Vector2(21,-9),tub+Vector2(15,11),tub+Vector2(-15,11)]),Color("6d7d7d"))
 g.draw_rect(Rect2(tub+Vector2(-18,-10),Vector2(37,6)),Color("293b42"))
 g.draw_line(tub+Vector2(-18,-9),tub+Vector2(19,-9),Color("bac5b9"),2)

func camera_target()->Vector2:return Vector2(clampf(g.player.x-480,0,Deepworks.W*40-960),clampf(g.player.y-290,0,Deepworks.H*40-540))
