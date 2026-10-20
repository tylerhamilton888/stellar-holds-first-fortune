class_name HoldSurface
extends RefCounted
# Walkable local scenes share the real game state. No map avatar or second inventory.
const A=preload("res://scripts/art.gd")
const BED=preload("res://assets/directional-v47/bed.png")
const PROPS=preload("res://assets/surface-v46/props.png")
const ROYAL=preload("res://assets/surface-v46/audience-room.png")
const INTERIORS=preload("res://assets/surface-v46/interiors.png")
const MEADOW=preload("res://assets/overworld-v26/meadow.png")
const ATLAS=preload("res://assets/overworld-v26/scenery.png")
const SIZE=Vector2(1880,1080)
const ROOM_SIZE=Vector2(960,720)
const FIR=preload("res://assets/pinewood-v40/silver-fir.png")
const NAMES={"hearthward":"Keldrath · Hearthward · Z 0","crownward":"Keldrath · Crownward · Z +1","forgeward":"Keldrath · Forgeward · Z -1","trail":"The High Trail","pinewood":"Pinewood","claim":"Your mountain homestead"}
const TREES=[Vector2(430,430),Vector2(690,610),Vector2(930,370),Vector2(1190,620),Vector2(1430,420),Vector2(1630,690),Vector2(1550,860)]
var g
var area="hearthward"
var return_area="hearthward"
var selected_chest=""
const FURNITURE_GRID=10.0
const FOOT_RADIUS=10.0
var moving_furnishing:Dictionary={}
var placing=""
var direction=Vector2.DOWN
var foot=0.0
var cut_clock=0.0
var cut_target=-1
var cut_struck=false
var cut_approach=false
var cut_flash=0.0
var rest_time=0.0
var rest_elapsed=0.0
var route_hint=""
var ground_cache={}
var bed_bounds=Rect2i()
var house
var world

func _init(game):
 g=game;house=HoldHearthcraft.new(self);world=HoldWorldZones.new(self)
func active()->bool:return g.playing and g.zone!="mine"
func ensure():
 HoldForestry.ensure(g.state)
 if g.state.surface.is_empty():g.state.surface={"version":1,"area":"hearthward","positions":{},"chests":{},"homes":{},"decor":[],"facts":{}}
 var s=g.state.surface
 s.folk_revision=56
 if int(s.get("world_layout",0))<50:
  s.legacy_positions=s.get("positions",{}).duplicate(true)
  for id in ["hearthward","crownward","forgeward"]:s.get("positions",{}).erase(id)
  s.world_layout=50
 for key in ["positions","chests","homes","facts"]:
  if not s.has(key):s[key]={}
 if not s.has("decor"):s.decor=[]
 if not s.chests.has("keldrath:quarters"):
  s.chests["keldrath:quarters"]={"area":"room:home","x":650.0,"y":420.0,"items":{},"fixed":true}
 if g.state.claim_id!="" and not s.homes.has(g.state.claim_id):
  s.homes[g.state.claim_id]={"level":0,"lesson":false}
  var id="claim:"+g.state.claim_id+":starter"
  s.chests[id]={"area":"home:"+g.state.claim_id,"x":650.0,"y":380.0,"items":{}}
func room()->bool:return area.begins_with("room:") or area.begins_with("home:")
func size()->Vector2:return ROOM_SIZE if room() else SIZE
func label()->String:
 if area.begins_with("home:"):return "Your hearth · "+HoldOutpost.title(g.state)
 if area.begins_with("room:"):return HoldInteriors.ROOMS.get(g.room_id,{"name":"Keldrath"}).name
 if area=="claim":return NAMES[area]+" · Z+"+str(house.level())
 return NAMES.get(area,"Keldrath")
func remember():
 ensure()
 if not active():return
 g.state.surface.area=area;g.state.surface.return_area=return_area
 g.state.surface.positions[area]=[g.player.x,g.player.y]
func restore():
 rest_time=0;rest_elapsed=0
 ensure()
 if g.zone=="mine":return
 var desired=str(g.state.surface.get("area","hearthward"))
 if g.zone=="claim" and not desired.begins_with("home:"):desired="claim"
 elif g.zone=="road":desired="pinewood"
 elif g.zone=="approach":desired="trail"
 area=desired;return_area=str(g.state.surface.get("return_area","hearthward"))
 g.room_id="home" if area.begins_with("home:") else (area.trim_prefix("room:") if area.begins_with("room:") else "")
 var p=g.state.surface.positions.get(area,[])
 g.player=Vector2(p[0],p[1]) if p.size()==2 else spawn(area)
 if not walkable(g.player):
  if area=="claim":house.data().z=0
  g.player=spawn(area)
 g.grounded=true;g.camera=camera_target();g.velocity=Vector2.ZERO
func spawn(id:String)->Vector2:
 if id.begins_with("room:") or id.begins_with("home:"):return Vector2(480,550)
 return {"hearthward":Vector2(1100,570),"crownward":Vector2(180,880),"forgeward":Vector2(1700,880),"trail":Vector2(245,690),"pinewood":Vector2(260,650),"claim":Vector2(300,760)}.get(id,Vector2(480,600))
func enter(id:String,at:Vector2=Vector2.INF):
 ensure()
 if id=="claim" and g.state.claim_id=="":g.open_panel("charters");return
 if id=="room:throne" and HoldOnboarding.ensure(g.state).fresh and HoldOnboarding.stage(g.state)<4:g.notify("Ivar's first-shift reference opens the royal audience.");return
 if id in ["trail","pinewood","claim"] and g.state.opening==0:g.notify(g.region_travel_hint());return
 if g.room_id=="training":g.state.resident_visits.erase("borin")
 var travelling_cart=g.handworks.passage(id)
 world.speech="";rest_time=0
 remember();var old=area
 g.flush_pickups()
 var claim_site=id=="claim" or id.begins_with("home:") or (id.begins_with("room:") and g.state.active_site=="claim" and old=="claim")
 g.state.switch_site("claim" if claim_site else "hold",g.geo)
 if id.begins_with("room:") or id.begins_with("home:"):
  if not room():return_area=old
  elif id!=old:return_area="claim" if claim_site else ("crownward" if id in ["room:throne","room:research"] else "forgeward" if id in ["room:forge","room:practice"] else "hearthward")
 if old=="claim" and id!="claim":house.data().z=0
 area=id
 g.zone="claim" if claim_site else ("road" if id=="pinewood" else "approach" if id=="trail" else "hub")
 g.room_id="home" if id.begins_with("home:") else id.trim_prefix("room:") if id.begins_with("room:") else ""
 var landing=world.arrival(old,id) if at==Vector2.INF else at
 g.player=spawn(id) if landing==Vector2.INF else landing
 if not walkable(g.player):g.player=spawn(id)
 g.velocity=Vector2.ZERO;g.grounded=true;g.walking_pose=false;g.gait_clock=0;g.swing=0;placing="";moving_furnishing={};cut_clock=0;cut_target=-1;house.impact=0
 g.combat.armed=false;g.combat.reset_actions();g.construction.selected=""
 g.state.region_travel.active=false;g.state.hold_travel.active=false
 g.camera=camera_target();g.close_panel();g.spawn_agents();g.sound.set_context(g.room_id if room() else g.zone)
 g.handworks.arrive(travelling_cart)
 g.begin_transition(label().to_upper());g.save_game()
func leave():
 var back=return_area
 var p=g.state.surface.positions.get(back,[])
 enter(back,Vector2(p[0],p[1])+Vector2(0,35) if p.size()==2 else spawn(back))
func camera_target()->Vector2:
 if room():return Vector2(0,135)
 return (g.player-Vector2(480,300)).clamp(Vector2(0,-65),Vector2(maxf(0,size().x-960),maxf(-65,size().y-480)))
func level()->int:return 0 if area=="crownward" else 2 if area=="forgeward" else 1
func points()->Array:
 var result=[]
 if area in ["hearthward","crownward","forgeward"]:
  result=world.points()
 elif area=="trail":
  result=[spot(220,690,"Keldrath's gate","hearthward"),spot(950,300,"Old Workings · enter mine","mine"),spot(470,920,"Pinewood trail","pinewood"),spot(1650,700,"Your claim" if g.state.claim_id!="" else "Unclaimed mountain · charter required","claim")]
 elif area=="claim":
  result=[spot(180,790,"High Trail · Keldrath","trail"),spot(500,440,"Your home","home:"+g.state.claim_id),spot(1280,345,"Your Deepworks","mine"),spot(970,690,"Founding stones","camp"),spot(1370,760,"Workshop","room:forge"),spot(1650,840,"Launchyard","ship"),spot(740,780,"Homestead workbench","homestead")]
 elif area=="pinewood":result=[spot(180,650,"High Trail","trail"),spot(300,790,"Woodcutter's field board","pinewood_panel")]
 elif room():
  result=[spot(480,620,"Leave · "+NAMES.get(return_area,"your claim"),"leave")]
  if area.begins_with("home:") or area=="room:home":
   result.append(spot(290,420,"Bed · rest and save","rest"));result.append(spot(735,515,"Wardrobe & supplies" if area=="room:home" else "Homestead workbench","home" if area=="room:home" else "homestead"))
  elif area=="room:training":
   result.append(spot(660,570,"Borin’s training notes","training_notes"))
  else:
   var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
   result.append(spot(620,410,HoldInteriors.ROOMS.get(g.room_id,{"action":"Rest and supplies"}).action,"talk:"+host if host!="" and g.state.active_site=="hold" else "training" if g.room_id=="practice" else g.room_id))
   if g.room_id in ["forge","practice"]:result.append(spot(740,490,"Practice bay","training"))
   if g.room_id=="tavern":
    var guests=HoldNpcPresence.tavern_guests(g.state)
    for i in mini(3,guests.size()):result.append(spot(270+i*170,550,"Speak with "+g.state.npc(guests[i]).first_name,"talk:"+guests[i]))
 if area=="claim" and house.level()==0:
  var index=0
  for id in g.state.outpost.get("crew",{}):
   result.append(spot(1040+index*75,850,"Speak with "+g.state.npc(id).first_name,"talk:"+id));index+=1
 if area=="claim" and house.level()>0:result=[]
 for id in g.state.surface.chests:
  var c=g.state.surface.chests[id]
  if house.local(c):result.append(spot(c.x,c.y,"Storage chest","chest:"+id))
 result.append_array(house.points())
 for d in g.state.surface.decor:
  if house.local(d) and d.kind=="bed":result.append(spot(d.x,d.y+25,"Bed · rest in your own house","house_rest"))
 return result
func spot(x:float,y:float,title:String,action:String)->Dictionary:return {"p":Vector2(x,y),"name":title,"action":action}
func nearest()->Dictionary:
 var found={};var distance=78.0
 for p in points():
  var d=g.player.distance_to(p.p)
  if (p.action.begins_with("room:") or p.action.begins_with("home:") or p.action=="private") and (absf(g.player.x-p.p.x)>34 or g.player.y<p.p.y-8):continue
  if p.action=="leave" and absf(g.player.x-p.p.x)>34:continue
  if not clear_interaction(g.player,p.p):continue
  if d<distance:distance=d;found=p
 return found
func clear_interaction(a:Vector2,b:Vector2)->bool:
 for i in range(1,10):
  var p=a.lerp(b,i/10.0)
  for r in obstacles():
   # The bar is solid underfoot, but Hedrik can talk across its counter.
   if area=="room:tavern" and b.distance_to(Vector2(620,410))<1 and r==HoldFurnishings.footprint("counter",Vector2(620,450)):continue
   if not r.has_point(b) and r.has_point(p):return false
 return true
func use():
 var p=nearest()
 if p.is_empty():g.notify("Walk to a doorway, signpost, chest or workstation and press E.");return
 action(p.action)
func action(id:String):
 if id=="leave":leave()
 elif id=="mine":
  remember();g.state.surface.mine_return=area;g.change_zone("mine")
 elif id=="house_up":house.use_stairs(true)
 elif id=="house_down":house.use_stairs(false)
 elif id.begins_with("house:"):house.toggle(id.trim_prefix("house:"))
 elif id=="house_rest":
  for d in g.state.surface.decor:
   if house.local(d) and d.kind=="bed" and g.player.distance_to(Vector2(d.x,d.y))<85:house.rest(Vector2(d.x,d.y));break
 elif id=="rest":
  if g.handworks.busy_hands():g.notify("Park or set down your load before resting.");return
  rest_time=1.1;rest_elapsed=0;g.notify("Taking a breather · move to cancel")
 elif id=="training_notes":g.lesson_id="training";g.open_panel("lesson")
 elif id=="training":g.enter_room("training")
 elif id=="private":g.notify("Folk homes · private quarters. Meet the neighbors in the streets and tavern.")
 elif id.begins_with("citizen:"):world.speak(int(id.trim_prefix("citizen:")))
 elif id.begins_with("talk:"):HoldConversation.start(g,id.trim_prefix("talk:"))
 elif id.begins_with("chest:"):
  selected_chest=id.trim_prefix("chest:")
  if selected_chest=="keldrath:quarters":HoldOnboarding.settle(g,"chest")
  g.open_panel("storage")
 elif id=="pinewood_panel":g.open_panel("pinewood")
 elif id in ["homestead","camp","ship","home","forge","anniversary","hold_lift"]:g.open_panel(id)
 else:enter(id)
func base_obstacles()->Array:
 var list=[]
 if area=="claim" and house.level()>0:return list
 if HoldWorldZones.ward(area):return world.obstacles()
 if room():return world.room_obstacles()
 if area=="trail":
  for pair in [[Vector2(220,690),330.0],[Vector2(950,300),240.0]]:
   for side in [-1,1]:list.append(Rect2(pair[0]+Vector2(side*pair[1]*.32-pair[1]*.14,-pair[1]*.34),Vector2(pair[1]*.28,pair[1]*.42)))
  list.append_array([Rect2(1134,643,202,12),Rect2(1134,745,202,12)])
 elif area=="claim":
  list=[Rect2(346,265,308,155),Rect2(1255,630,230,110)]
  for side in [-1,1]:list.append(Rect2(Vector2(1280,345)+Vector2(side*260*.32-260*.14,-260*.34),Vector2(260*.28,260*.42)))
 elif area=="pinewood":
  for i in TREES.size():
   if g.state.road_trees[i]>0:list.append(Rect2(TREES[i]-Vector2(17,24),Vector2(34,30)))
 return list
func obstacles(ignore:Dictionary={})->Array:
 var list=base_obstacles()
 if area in ["claim","pinewood"] and house.level()==0:list.append(HoldFurnishings.footprint("desk",Vector2(740,780) if area=="claim" else Vector2(300,790)))
 list.append_array(house.obstacles())
 if g.fieldwork:list.append_array(g.fieldwork.obstacles())
 for c in g.state.surface.chests.values():
  if house.local(c) and (ignore.is_empty() or c!=ignore):list.append(HoldFurnishings.footprint("chest",Vector2(c.x,c.y)))
 for d in g.state.surface.decor:
  if house.local(d) and (ignore.is_empty() or d!=ignore):list.append(HoldFurnishings.footprint(d.kind,Vector2(d.x,d.y)))
 return list
func walkable(p:Vector2,ignore:Dictionary={})->bool:
 if area=="claim" and house.level()>0 and not house.on_floor(p,house.level()):return false
 if HoldWorldZones.ward(area):
  if not Rect2(110,210,1660,780).has_point(p):return false
 elif room():
  if not Rect2(175,290,610,345).has_point(p):return false
 elif not Rect2(90,210,1700,750).has_point(p):return false
 if area=="trail" and p.x>1170 and p.x<1300 and (p.y<665 or p.y>735):return false
 for r in obstacles(ignore):
  if r.grow(FOOT_RADIUS).has_point(p):return false
 return true
func move(dt:float):
 if g.handworks.approaching or g.fieldwork.moving:return
 var input=Input.get_vector("left","right","up","down")
 if input!=Vector2.ZERO and not (g.fight.enabled() and g.combat.armed):direction=input
 if rest_time>0:
  if input!=Vector2.ZERO:rest_time=0;g.notify("Back on your feet.")
  else:
   rest_time=maxf(0,rest_time-dt);rest_elapsed+=dt;g.walking_pose=false
   if rest_time<=0:
    g.state.surface.facts.rest=true;g.state.combat.health=100;g.notify("Rested · health restored · fortune saved")
    if area=="room:home":HoldOnboarding.settle(g,"bed")
    g.save_game()
   return
 var delta=g.fight.movement(input)*dt
 var before=g.player
 var steps=maxi(1,ceili(delta.length()/6.0))
 for i in steps:
  for axis in [Vector2(delta.x,0)/steps,Vector2(0,delta.y)/steps]:
   if walkable(g.player+axis):g.player+=axis
 g.velocity=(g.player-before)/maxf(dt,.001);g.grounded=true;g.walking_pose=g.velocity.length()>1
 if absf(input.x)>.1:g.face=1 if input.x>0 else -1
 if g.walking_pose:
  if not (g.fight.enabled() and g.combat.armed):direction=(g.player-before).normalized()
  HoldDrawnLocomotion.advance(g,g.player.distance_to(before),"wood" if room() else "stone")
 cut_flash=maxf(0,cut_flash-dt)
 if area=="pinewood":chop(dt)
 house.update(dt)
func input(e:InputEvent)->bool:
 if not active() or g.panel_id!="":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_E:
   if e.shift_pressed and area=="claim":house.use_stairs(false)
   else:use()
   return true
  if e.keycode==KEY_G:g.open_panel("wayfinding");return true
  if e.keycode==KEY_O and (area=="claim" or area.begins_with("home:")):g.open_panel("homestead");return true
  if e.keycode in [KEY_SPACE,KEY_V,KEY_X,KEY_P,KEY_F,KEY_Q]:return true
 if e is InputEventMouseButton and e.pressed:
  if e.button_index==MOUSE_BUTTON_RIGHT:cancel_placement();return true
  if e.button_index==MOUSE_BUTTON_LEFT and placing!="":
   if placing.begins_with("house:"):house.build(g.get_global_mouse_position()+g.camera,placing.trim_prefix("house:"));house.timer=.18
   else:place(g.get_global_mouse_position()+g.camera)
   return true
 return false
static func snap_furnishing(p:Vector2)->Vector2:return (p/FURNITURE_GRID).round()*FURNITURE_GRID
func cancel_placement():
 placing="";moving_furnishing={}
func start_placement(kind:String):
 cancel_placement();g.handworks.placing="";placing=kind;g.close_panel()
 g.notify("Place on the fine grid. LMB builds; right click cancels. Keep approaches clear.")
func move_nearby_furnishing()->bool:
 if not (area=="claim" or area.begins_with("home:")):return false
 var best:Dictionary={};var kind="";var distance=85.0
 for d in g.state.surface.decor:
  if house.local(d) and not d.get("fixed",false) and g.player.distance_to(Vector2(d.x,d.y))<distance:
   best=d;kind=d.kind;distance=g.player.distance_to(Vector2(d.x,d.y))
 for c in g.state.surface.chests.values():
  if house.local(c) and not c.get("fixed",false) and g.player.distance_to(Vector2(c.x,c.y))<distance:
   best=c;kind="chest";distance=g.player.distance_to(Vector2(c.x,c.y))
 if best.is_empty():g.notify("Stand beside a furnishing you placed.");return false
 moving_furnishing=best;g.handworks.placing="";placing=kind;g.close_panel()
 g.notify("Reposition "+HoldFurnishings.ITEMS[kind].title+" · LMB confirms; right click leaves it in place.")
 return true
func furniture_ready(p:Vector2,kind:String)->bool:
 return furniture_valid(p,kind) and (not moving_furnishing.is_empty() or g.state.afford(HoldFurnishings.ITEMS[kind].cost))
func build_bounds()->Rect2:
 return Rect2(175,290,610,345) if room() else Rect2(90,210,1700,750)
func furniture_valid(p:Vector2,kind:String)->bool:
 if not (area=="claim" or area.begins_with("home:")):return false
 if not HoldFurnishings.ITEMS.has(kind) or p.distance_to(g.player)>140:return false
 var base=HoldFurnishings.footprint(kind,p)
 if kind in ["chest","bed"] and not walkable(p+Vector2(0,25),moving_furnishing):return false
 for corner in [base.position,Vector2(base.end.x,base.position.y),base.end,Vector2(base.position.x,base.end.y),base.get_center()]:
  if not walkable(corner,moving_furnishing):return false
 for obstacle in obstacles(moving_furnishing):
  if base.grow(6).intersects(obstacle):return false
 # Check the entire base, not just its corners, across upper-floor tile seams.
 if area=="claim" and house.level()>0:
  for x in range(int(base.position.x),int(base.end.x)+1,5):
   for y in range(int(base.position.y),int(base.end.y)+1,5):
    if not house.on_floor(Vector2(x,y),house.level()):return false
 for point in points():
  if not moving_furnishing.is_empty() and point.action.begins_with("chest:") and g.state.surface.chests.get(point.action.trim_prefix("chest:"),{})==moving_furnishing:continue
  if moving_furnishing.get("kind","")=="bed" and point.action=="house_rest" and point.p==Vector2(moving_furnishing.x,moving_furnishing.y+25):continue
  if point.action.begins_with("chest:") or point.action=="house_rest":
   var approach=Rect2(point.p+Vector2(-16,10 if point.action.begins_with("chest:") else -10),Vector2(32,24))
   if base.grow(FOOT_RADIUS).intersects(approach):return false
   continue
  if p.distance_to(point.p)<80 or base.grow(36).has_point(point.p):return false
 return not base.grow(8).has_point(g.player)
func place(p:Vector2)->bool:
 ensure();p=snap_furnishing(p)
 if not (area=="claim" or area.begins_with("home:")):g.notify("Build around your own hearth and claim.");return false
 if not furniture_valid(p,placing):g.notify("Choose clear ground within reach; leave room for the entire furnishing.");return false
 if not moving_furnishing.is_empty():
  moving_furnishing.x=p.x;moving_furnishing.y=p.y
  cancel_placement();g.sound.effect("build");g.save_game();return true
 var cost=HoldFurnishings.ITEMS[placing].cost
 if not g.state.afford(cost):g.notify("Bring "+HoldFurnishings.cost_text(placing)+" in your pack.");return false
 for k in cost:g.state.add(k,-cost[k])
 if placing=="chest":
  var serial=int(g.state.surface.get("next_chest",0))
  while g.state.surface.chests.has("chest:"+str(serial)):serial+=1
  g.state.surface.next_chest=serial+1
  var id="chest:"+str(serial)
  g.state.surface.chests[id]={"area":area,"z":house.level(),"x":p.x,"y":p.y,"items":{}}
 else:g.state.surface.decor.append({"area":area,"z":house.level(),"x":p.x,"y":p.y,"kind":placing})
 g.state.surface.facts.build=true;placing="";g.sound.effect("build");g.save_game();return true
func transfer(item:String,n:int,deposit:bool)->int:
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:return 0
 var source=g.state.inventory if deposit else c.items;var target=c.items if deposit else g.state.inventory
 var moved=mini(maxi(0,n),int(source.get(item,0)))
 if moved<=0:return 0
 source[item]=int(source.get(item,0))-moved;target[item]=int(target.get(item,0))+moved
 if source[item]==0:source.erase(item)
 g.state.surface.facts.storage=true;g.save_game();return moved
func recover_chest()->bool:
 cancel_placement()
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.get("fixed",false):g.notify("This chest belongs to your borrowed quarters. Its contents are yours.");return false
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:return false
 for value in c.items.values():
  if int(value)>0:g.notify("Empty the chest before taking it apart.");return false
 g.state.surface.chests.erase(selected_chest);g.state.add("wood",4);g.close_panel();g.save_game();return true
func recover_decor()->bool:
 cancel_placement()
 for i in g.state.surface.decor.size():
  var d=g.state.surface.decor[i]
  if house.local(d) and g.player.distance_to(Vector2(d.x,d.y))<85:
   g.state.surface.decor.remove_at(i)
   for item in HoldFurnishings.ITEMS.get(d.kind,HoldFurnishings.ITEMS.table).cost:g.state.add(item,HoldFurnishings.ITEMS.get(d.kind,HoldFurnishings.ITEMS.table).cost[item])
   g.save_game();g.close_panel();return true
 g.notify("Stand beside a lamp or table you placed.");return false
func chest_panel():
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:g.label(g.panel_body,"Walk to your chest and press E.");return
 g.label(g.panel_body,"YOUR CHEST · YOUR SUPPLIES",20,Color("edc98a"))
 g.label(g.panel_body,"Stored items stay here. Withdraw materials into your pack before crafting or selling. Mines keep their own buckets and stockpiles.",14)
 var row=g.row(g.panel_body)
 g.small_button(row,"Store all carried resources",func():
  for k in g.state.inventory.keys():transfer(k,g.state.count(k),true)
  g.open_panel("storage",false))
 g.small_button(row,"Take all",func():
  for k in c.items.keys():transfer(k,int(c.items[k]),false)
  g.open_panel("storage",false))
 if not c.get("fixed",false):g.small_button(g.panel_body,"Dismantle empty chest · recover 4 timber",recover_chest)
 for item in HoldData.ITEMS:
  if g.state.count(item)+int(c.items.get(item,0))==0:continue
  var key=str(item);var line=g.row(g.panel_body);HoldItemArt.icon(line,key)
  g.label(line,HoldData.ITEMS[key].name+"   Pack %d · Chest %d" % [g.state.count(key),int(c.items.get(key,0))],14)
  g.small_button(line,"Store 10",func():transfer(key,10,true);g.open_panel("storage",false))
  g.small_button(line,"Take 10",func():transfer(key,10,false);g.open_panel("storage",false))
func home_panel():
 g.button(g.panel_body,"River & Root · fishing and gardening",func():g.open_panel("fieldwork"))
 g.button(g.panel_body,"Craft workstations & stockpiles · Shift+B",func():g.open_panel("handworks"))
 ensure();g.label(g.panel_body,"A HEARTH OF YOUR OWN",22,Color("edc98a"))
 if g.state.claim_id=="":g.label(g.panel_body,"Your mountain charter includes a starter cottage and a storage chest.");return
 var h=g.state.surface.homes[g.state.claim_id]
 g.label(g.panel_body,"Your charter includes a weatherproof stone cottage, a bed and a personal chest. Improve it at your own pace.",16)
 for step in [["rest","1 · Enter your cottage and rest at the bed."],["storage","2 · Put supplies in your chest, then withdraw what you need."],["build","3 · Place a chest, table or lamp around your home."]]:g.label(g.panel_body,("✓ " if g.state.surface.facts.get(step[0],false) else "○ ")+step[1],15)
 for kind in HoldFurnishings.BUILDABLE:
  var id=str(kind)
  g.button(g.panel_body,"Place "+HoldFurnishings.ITEMS[id].title+" · "+HoldFurnishings.cost_text(id),func():start_placement(id))
 g.small_button(g.panel_body,"Move nearby furnishing or chest",move_nearby_furnishing)
 g.small_button(g.panel_body,"Recover nearby placed furnishing",recover_decor)
 g.button(g.panel_body,"Build a house · floors, walls, doors and roofs",func():g.open_panel("house_build"))
 if int(h.level)==0:
  var b=g.button(g.panel_body,"Improve cottage · 12 timber + 8 stone",func():
   if int(h.level)==0 and g.state.afford({"wood":12,"stone":8}):
    g.state.add("wood",-12);g.state.add("stone",-8);h.level=1;g.sound.effect("build");g.save_game();g.open_panel("homestead",false))
  b.disabled=not g.state.afford({"wood":12,"stone":8})
 else:g.label(g.panel_body,"A proper freeholder’s hearth: copper roofing, a woven rug and a warm fire.",16,Color("a7d5be"))
 g.label(g.panel_body,"O opens this board on your claim. I opens your pack. E opens nearby chests and doors. Stored resources are never spent remotely.",14)
func lift_panel():
 g.label(g.panel_body,"THE HOLD LIFT",22,Color("edc98a"))
 for destination in ["crownward","hearthward","forgeward"]:
  var id=str(destination)
  g.button(g.panel_body,NAMES[id],func():enter(id,HoldWorldZones.LIFT+Vector2(0,30)))
func guide_panel():
 g.label(g.panel_body,"FOLLOW THE PATHS",22,Color("edc98a"))
 g.label(g.panel_body,"Walk with WASD or arrows. Press E at doors, stairs, trail signs and workstations. You are here: "+label()+".",16)
 for text in ["Hearthward: quarters, tavern, exchange and Ivar’s office.","Western Royal stairs → Crownward (Z +1): Lord Eirik and the survey office.","Eastern Forge stairs → Forgeward (Z -1): Borin’s forge and practice bay.","King’s Gate → High Trail → Old Workings, Pinewood and your claim.","Your claim: home beside the mine, founding stones, workshop and launchyard. O builds your house; roofs and upper floors use real Z-levels. E climbs, Shift+E descends at your built landings."]:
  g.label(g.panel_body,text,16)
 g.label(g.panel_body,"G is a guide, not a travel screen. Every doorway takes you to a connected local area. J keeps your existing quests.",14)
func chop(dt:float):
 cut_approach=false
 HoldForestry.ensure(g.state)
 if g.hotbar.blocked_work() or g.tool!=2 or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):cut_clock=0;cut_target=-1;return
 var aim=g.get_global_mouse_position()+g.camera;var best=-1;var dist=80.0
 for i in TREES.size():
  if g.state.road_trees[i]<=0 and HoldForestry.logs(g.state,i)<=0:continue
  var d=aim.distance_to(TREES[i]-Vector2(0,25))
  if d<dist and g.player.distance_to(TREES[i])<105:dist=d;best=i
 if best<0:cut_clock=0;return
 if best!=cut_target:cut_clock=0;cut_target=best;cut_struck=false
 g.face=1 if TREES[best].x>g.player.x else -1
 var stance=TREES[best]+Vector2(-g.face*32,-6)
 if Input.get_vector("left","right","up","down")==Vector2.ZERO and g.player.distance_to(stance)>3:
  var step=g.player.move_toward(stance,150*dt)
  if walkable(step):
   direction=(stance-g.player).normalized();HoldDrawnLocomotion.advance(g,g.player.distance_to(step),"wood");g.player=step;g.walking_pose=true;cut_approach=true;cut_clock=0;cut_struck=false;return
 cut_clock+=dt
 if cut_clock>=.64:cut_clock=fmod(cut_clock,.64);cut_struck=false
 if cut_clock<.35 or cut_struck:return
 cut_struck=true;cut_flash=.16
 var is_log=g.state.road_trees[best]<=0
 if is_log:
  if HoldForestry.fall_age(g.state,best)<HoldForestry.FALL_TIME:return
  g.state.forestry.logs[str(best)]=HoldForestry.logs(g.state,best)-1
 else:
  g.state.road_trees[best]-=1
  if g.state.road_trees[best]==0:
   g.state.forestry.logs[str(best)]=3;g.state.forestry.fell_at[str(best)]=g.state.elapsed;g.state.forestry.direction[str(best)]=g.face
 if is_log or g.state.road_trees[best]==0:g.handworks.spawn("log",TREES[best]+Vector2(24,24),2,"pine:"+str(best));g.handworks.award("forester")
 else:g.state.add("wood",2)
 HoldOnboarding.fact(g.state,"woodcut",2);g.sound.effect("wood",-14)
 g.notify(("Raw log freed · E lifts it. " if is_log or g.state.road_trees[best]==0 else "+2 timber · ")+("Chop the fallen trunk for more." if g.state.road_trees[best]<=0 else "The cut is deepening."))
func hud():
 g.objectives.visible=false
 g.hud.text=label().to_upper()+"   %d CROWNS" % g.state.money
 if g.panel_id=="":
  var p=nearest()
  g.footer.text=("LMB move " if not moving_furnishing.is_empty() else "LMB place ")+placing+" · Right click cancel" if placing!="" else ("E · "+p.name if not p.is_empty() else "WASD walk   E interact   I pack   G directions   J journal")
  if g.notice_time>0:g.footer.text=g.notice
  if g.handworks.busy_hands():g.footer.text="Shift+B · Workshop lesson & crafting   Q · Set down   Shift+E · Collect"
func draw():
 var cam=g.camera.round();g.draw_set_transform(-cam)
 var near=nearest()
 if area in ["hearthward","crownward","forgeward"]:
  world.draw_ground()
 elif room():draw_room()
 else:draw_outdoors()
 if area=="claim" and house.level()>0:g.draw_rect(Rect2(Vector2.ZERO,SIZE),Color(.02,.06,.08,.5))
 house.floor_draw()
 var objects=[]
 if HoldWorldZones.ward(area):
  objects.append_array(world.buildings());objects.append_array(world.people());objects.append_array(world.landmarks())
  objects.append_array(world.street_furnishings())
 if room():objects.append_array(world.room_objects())
 if area in ["claim","pinewood"] and house.level()==0:objects.append(world.furn("desk",740 if area=="claim" else 300,780 if area=="claim" else 790))
 if area in ["claim","trail"]:objects.append_array(world.exterior_objects())
 if area=="claim":
  for k in house.tiles():
   if house.tiles()[k].get("wall","")!="":objects.append({"p":house.center(house.coords(k))+Vector2(0,20),"kind":"wall","c":house.coords(k)})
 for c in g.state.surface.chests.values():
  if house.local(c):objects.append({"p":Vector2(c.x,c.y),"kind":"chest_open" if g.panel_id=="storage" and c==g.state.surface.chests.get(selected_chest,{}) else "chest"})
 for d in g.state.surface.decor:
  if house.local(d):objects.append({"p":Vector2(d.x,d.y),"kind":d.kind})
 if room() and not area.begins_with("home:") and area!="room:training":
  var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
  if host!="" and g.state.active_site=="hold":objects.append({"p":Vector2(620,370 if host=="eirik" else 410),"kind":"npc","id":host})
  if g.room_id=="tavern":
   var guests=HoldNpcPresence.tavern_guests(g.state)
   for i in mini(3,guests.size()):objects.append({"p":Vector2(270+i*170,550),"kind":"npc","id":guests[i]})
 if area=="claim" and house.level()==0:
  var index=0
  for id in g.state.outpost.get("crew",{}):
   objects.append({"p":Vector2(1040+index*75,850),"kind":"npc","id":id});index+=1
 if area=="hearthward" and HoldAnniversary.ensure(g.state).complete:
  g.draw_set_transform(-cam);HoldAnniversary.station(g,HoldWorldZones.door(10),g.clock)
 if area=="pinewood":
  for i in TREES.size():objects.append({"p":TREES[i],"kind":"tree","i":i})
 objects.append_array(g.fight.objects())
 objects.append_array(g.handworks.objects())
 objects.append_array(g.fieldwork.objects())
 if g.opening_scene is HoldArrivalEscort:objects.append({"p":g.opening_scene.guide,"kind":"escort"})
 objects.append({"p":g.player,"kind":"player"});objects.sort_custom(func(a,b):return a.p.y<b.p.y)
 for o in objects:
  g.draw_set_transform(-cam)
  if o.kind=="building":world.draw_building(o)
  elif o.kind=="landmark":world.draw_landmark(o)
  elif o.kind=="furnishing":world.draw_furnishing(o)
  elif o.kind=="citizen":world.draw_citizen(o)
  elif o.kind=="fighter":g.fight.draw_enemy(o.enemy)
  elif o.kind=="escort":g.opening_scene.draw_guide()
  elif o.kind=="garden":g.fieldwork.draw_bed(o.bed)
  elif o.kind=="handwork":g.handworks.draw_object(o)
  elif o.kind=="player":actor(o.p,g.state.appearance,g.walking_pose,g.face,g.gait_clock)
  elif o.kind=="npc":
   if o.id=="eirik":g.draw_texture_rect(HoldRoyalHall.SPRITE,Rect2(o.p-Vector2(40,88),Vector2(80,96)),false)
   elif o.id=="borin" and g.room_id=="forge":
    A.draw_offset=-cam;HoldNpcActivity.smith(g,o.p,g.clock,g.state.opening>=2);A.draw_offset=Vector2.ZERO
   elif g.room_id=="tavern":
    A.draw_offset=-cam;HoldNpcActivity.social(g,o.p,g.clock+(0 if o.id=="hedrik" else posmod(hash(o.id),11)),-1,g.state.npc(o.id),true);A.draw_offset=Vector2.ZERO
   else:actor(o.p,g.state.npc(o.id),false,-1,g.clock)
   g.draw_set_transform(-cam);
   if near.get("action","")=="talk:"+o.id or g.state.tracked_npc==o.id:A.text(g,o.p+Vector2(-25,-103 if o.id=="eirik" else -68),g.state.npc(o.id).first_name,12,Color("e8ce93"))
  elif o.kind=="wall":house.wall_draw(o.c)
  elif o.kind=="tree":draw_fir(o.p,int(o.i))
  else:furniture(o.p,o.kind)
 if g.handworks.working:
  var station=g.handworks.facility()
  if not station.is_empty() and not station.job.is_empty():
   HoldDrawnAnimation.work_foreground(g,g.player,g.state.appearance,g.handworks.work_direction(station),.85,-cam,"saw" if station.kind=="saw" else "hammer",fmod(float(station.job.progress),.42)/.42)
 g.draw_set_transform(-cam)
 house.roof_draw()
 if g.opening_scene is HoldArrivalEscort:
  g.draw_set_transform(Vector2.ZERO);A.draw_offset=Vector2.ZERO;return
 if area in ["hearthward","crownward","forgeward"]:
  for point in points():
   # Only the nearby door is captioned; the painted architecture stays readable.
   if not point.action.begins_with("citizen:") and point.p.distance_to(g.player)<180 and point.p.distance_to(g.player)>78:plaque(point.p+Vector2(0,-72),point.name)
 else:
  for point in points():
   if point.action.begins_with("chest:") or point.action.begins_with("talk:") or point.action.begins_with("house:") or point.action in ["house_rest","house_up","house_down"]:continue
   if not room():signpost(point.p,point.name)
 if not near.is_empty() and not str(near.action).begins_with("talk:") and not str(near.action).begins_with("citizen:") and not g.handworks.busy_hands() and g.handworks.facility().is_empty():
  g.draw_arc(near.p+Vector2(0,6),23,0,TAU,24,Color("dfbd76"),2)
  # The footer already names this action; keep the actor and footwork unobscured.
 house.preview()
 if placing!="" and not placing.begins_with("house:"):
  var p=snap_furnishing(g.get_global_mouse_position()+g.camera)
  if area=="claim" or area.begins_with("home:"):HoldBuildPreview.grid(g,g.camera,FURNITURE_GRID,build_bounds())
  var ok=furniture_ready(p,placing);var tint=HoldBuildPreview.color(ok)
  HoldFurnishings.draw(g,p,placing,Color(tint,.65))
  HoldBuildPreview.outline(g,HoldFurnishings.footprint(placing,p),ok)
 g.draw_set_transform(Vector2.ZERO);A.draw_offset=Vector2.ZERO
 g.draw_rect(Rect2(0,0,960,48),Color(.06,.14,.18,.94));g.draw_line(Vector2(20,47),Vector2(940,47),Color("6e796b"))
 g.draw_rect(Rect2(0,498,960,42),Color("10232d"))
 if g.panel_id=="" and area in ["hearthward","crownward","forgeward"] and g.state.tracked_npc!="":
  var target=HoldNpcPresence.room_for(g.state,g.state.tracked_npc)
  for i in HoldDistrictMap.DOORS:
   if HoldDistrictMap.DOORS[i].id==target:
    var here=int(i)/7==level()
    var dest=HoldWorldZones.door(i) if here else (HoldWorldZones.ROYAL if level()==0 or (level()==1 and int(i)/7==0) else HoldWorldZones.FORGE)
    var screen=(dest-cam).clamp(Vector2(130,105),Vector2(830,445))
    if dest.distance_to(g.player)<180:continue
    plaque(screen,g.state.npc(g.state.tracked_npc).first_name+" · "+("door" if here else "take stairs"))
 world.speech_overlay()
 g.handworks.overlay()
 g.fieldwork.draw()
 g.fight.overlay()
 if rest_time>0:
  g.draw_rect(Rect2(0,74,960,424),Color(.04,.08,.10,sin(rest_elapsed/1.1*PI)*.6))
  A.text(g,Vector2(340,300),"A moment by your own hearth…",18,Color("efcf95"))
 if g.panel_id!="":g.draw_rect(Rect2(0,0,960,540),Color(.02,.04,.055,.48))
func actor(p:Vector2,profile:Dictionary,walking:bool,face:int,time:float):
 var is_player=p==g.player
 if is_player and g.fight.enabled() and g.combat.armed:
  g.fight.draw_player(p,.85,-g.camera.round());return
 if is_player:p=g.handworks.work_pose()
 var cam=g.camera.round()
 g.draw_set_transform(p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,19,Color(0,0,0,.3))
 var look=profile.duplicate();look.air_pose=0
 var aim=direction if is_player else Vector2(face,.45)
 var action=-1.0
 if is_player and cut_target>=0 and not cut_approach:aim=(TREES[cut_target]-p).normalized();action=clampf(cut_clock/.64,0,1)
 elif is_player and house.impact>0:aim=(house.contact-p).normalized();action=1-house.impact/.24
 if is_player and g.handworks.working:
  var station=g.handworks.facility()
  if not station.is_empty() and not station.job.is_empty():aim=g.handworks.work_direction(station);action=fmod(float(station.job.progress),.42)/.42
 var animation=""
 if is_player:
  if cut_target>=0 and not cut_approach:animation="axe"
  elif house.impact>0:animation="hammer"
  elif g.handworks.working:
   var station=g.handworks.facility();animation="saw" if not station.is_empty() and station.kind=="saw" else "hammer"
  elif g.handworks.carry_action()!="":animation=g.handworks.carry_action();action=g.handworks.carry_phase()
  elif g.handworks.pushing():animation="push"
 if is_player and g.fieldwork.action!="":animation="" if g.fieldwork.moving else g.fieldwork.action;action=g.fieldwork.animation_phase();aim=direction
 if is_player and animation=="" and action<0 and not g.opening_scene is HoldArrivalEscort:animation=g.hotbar.pose()
 HoldDrawnAnimation.paint(g,p-cam,look,aim,walking,time,.85,-cam,animation,maxf(0,action))
 g.draw_set_transform(-cam)
 if is_player:
  g.handworks.carried(p)
  if cut_flash>0 and cut_target>=0:
   var target=TREES[cut_target]-Vector2(0,18)
   for i in 7:g.draw_circle(target+Vector2.from_angle(i*.9)*(8+(.16-cut_flash)*90),2,Color("d7b079"))
func plaque(p:Vector2,text:String):
 var width=ThemeDB.fallback_font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+18
 var style=StyleBoxFlat.new();style.bg_color=Color(.06,.13,.16,.9);style.border_color=Color("9b885e");style.set_border_width_all(1);style.set_corner_radius_all(3)
 g.draw_style_box(style,Rect2(p-Vector2(width/2,17),Vector2(width,24)))
 A.text(g,p-Vector2(width/2-9,0),text,13,Color("ead4a0"))
func signpost(p:Vector2,text:String):
 HoldWorldDetails.prop(g,p+Vector2(-48,4),"waystone",62)
 if p.distance_to(g.player)<300 and not g.handworks.busy_hands():plaque(p+Vector2(0,-65),text)
func prop(p:Vector2,index:int,width:float):
 var cell=Vector2(PROPS.get_width()/3.0,PROPS.get_height()/2.0)
 g.draw_texture_rect_region(PROPS,Rect2(p-Vector2(width/2,width*.94),Vector2(width,width)),Rect2(Vector2(index%3,index/3)*cell,cell))
func furniture(p:Vector2,kind:String):
 HoldFurnishings.draw(g,p,kind)
func draw_outdoors():
 world.tile(2,Rect2(Vector2.ZERO,SIZE),200,Color("adb99e"))
 for edge in [Rect2(0,0,1880,200),Rect2(0,200,80,880),Rect2(1800,200,80,880),Rect2(0,970,1880,110)]:world.tile(3,edge,180,Color("bac1ae"))
 var roads=[PackedVector2Array([Vector2(170,790),Vector2(500,690),Vector2(960,690),Vector2(1650,790)]),PackedVector2Array([Vector2(500,690),Vector2(500,440)]),PackedVector2Array([Vector2(960,690),Vector2(1280,345)])] if area=="claim" else [PackedVector2Array([Vector2(180,650),Vector2(700,690),Vector2(1100,700),Vector2(1650,700)]),PackedVector2Array([Vector2(700,690),Vector2(950,300)]),PackedVector2Array([Vector2(700,690),Vector2(470,920)])]
 if not ground_cache.has(area):
  var img=Image.create(940,540,false,Image.FORMAT_RGBA8)
  var noise=FastNoiseLite.new();noise.seed=g.state.seed_value;noise.frequency=.023
  for y in 540:
   for x in 940:
    var p=Vector2(x*2,y*2);var dist=10000.0
    for path in roads:
     for j in path.size()-1:dist=minf(dist,p.distance_to(Geometry2D.get_closest_point_to_segment(p,path[j],path[j+1])))
    var n=noise.get_noise_2d(p.x,p.y);var grain=HoldTerrainView.grain(x,y)
    if dist<48+n*11:
     var color=Color("8e7955").lerp(Color("bcaa7d"),.4+n*.25+grain*.22)
     color.a=1-smoothstep(24+n*9,48+n*11,dist);img.set_pixel(x,y,color)
  ground_cache[area]=ImageTexture.create_from_image(img)
 if area=="trail":world.draw_river()
 g.draw_texture_rect(ground_cache[area],Rect2(Vector2.ZERO,SIZE),false)
 if area=="trail":world.draw_bridge()
 for i in 8:scenery(Vector2(120+i*245,245+sin(i)*30),1,330)
 if area=="claim":
  var upgraded=int(g.state.surface.homes[g.state.claim_id].level)>0

  prop(Vector2(395,560),4,120);prop(Vector2(595,560),4,120)
  for i in 4:prop(Vector2(880+i*42,695),5,40)
 elif area=="pinewood":
  for i in 9:
   var p=Vector2(170+i*190,250+sin(i)*30);g.draw_texture_rect(FIR,Rect2(p-Vector2(90,210),Vector2(180,230)),false,Color("8ca291"))

func scenery(p:Vector2,index:int,width:float):
 var cell=Vector2(ATLAS.get_width()/4.0,ATLAS.get_height()/2.0)
 var source=Rect2(Vector2(index%4,index/4)*cell,cell)
 g.draw_texture_rect_region(ATLAS,Rect2(p-Vector2(width*.5,width*.91),Vector2(width,width)),source)
func mine_arch(p:Vector2):
 g.draw_rect(Rect2(p-Vector2(100,120),Vector2(200,125)),Color("64716d"))
 g.draw_rect(Rect2(p-Vector2(65,90),Vector2(130,90)),Color("172b31"))
 for x in [-81,81]:
  g.draw_line(p+Vector2(x,0),p+Vector2(x,-120),Color("aa986d"),16);furniture(p+Vector2(x,-8),"lamp")
 g.draw_line(p+Vector2(-95,-120),p+Vector2(95,-120),Color("ac9667"),15)
 for x in [-32,32]:g.draw_line(p+Vector2(x,10),p+Vector2(x,70),Color("829391"),3)
func draw_fir(p:Vector2,i:int):
 if g.state.road_trees[i]>0:
  var fade=.35 if g.player.y<p.y and absf(g.player.x-p.x)<80 and p.y-g.player.y<190 else 1.0
  g.draw_texture_rect(FIR,Rect2(p-Vector2(95,220),Vector2(190,235)),false,Color(1,1,1,fade))
  g.draw_line(p-Vector2(12,25),p+Vector2(12,-25),Color("e9c583"),3)
 else:
  var age=HoldForestry.fall_age(g.state,i)
  if age<HoldForestry.FALL_TIME:
   var angle=pow(clampf(age/HoldForestry.FALL_TIME,0,1),1.8)*PI*.48*HoldForestry.direction(g.state,i)
   g.draw_set_transform(p-g.camera.round(),angle)
   g.draw_texture_rect(FIR,Rect2(Vector2(-95,-220),Vector2(190,235)),false)
   g.draw_set_transform(-g.camera.round())
  # Keep the actual fir bark at its rooted position after the crown falls.
  g.draw_texture_rect_region(FIR,Rect2(p+Vector2(-16,-8),Vector2(32,17)),Rect2(340,1360,370,140))
  g.draw_set_transform(p+Vector2(0,-7)-g.camera.round(),0,Vector2(1,.35))
  g.draw_circle(Vector2.ZERO,10,Color("b28a59"));g.draw_arc(Vector2.ZERO,7,0,TAU,20,Color("775331"),1)
  g.draw_set_transform(-g.camera.round())
  var remaining=HoldForestry.logs(g.state,i)
  if age>=HoldForestry.FALL_TIME and remaining>0:g.handworks.raw_sprite({"kind":"log"},p+Vector2(0,9),36+remaining*5)
func draw_room():
 world.draw_room_floor()
 return
