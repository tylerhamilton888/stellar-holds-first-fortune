class_name HoldHandworks
extends RefCounted
# Raw records have exactly one owner: ground, shoulders, a rack or a vehicle.
# Processed output uses existing resource dictionaries and DeepHaul.transfer.
const ART=preload("res://assets/animation-v51/workshop.png")
const STATIONS=[preload("res://assets/workshop76/stonebreaker.png"),preload("res://assets/workshop76/sawbench.png"),preload("res://assets/workshop76/stone-rack.png"),preload("res://assets/workshop76/timber-rack.png"),preload("res://assets/workshop76/materials-pallet.png")]
const SPECS={
 "breaker":{"name":"Stonebreaker","cost":{"wood":3,"stone":4},"art":0,"accept":"stone","capacity":4},
 "saw":{"name":"Sawbench","cost":{"wood":5,"stone":2},"art":1,"accept":"log","capacity":4},
 "stone_pile":{"name":"Stone stockpile","cost":{"wood":2,"stone":2},"art":2,"accept":"stone","capacity":12},
 "timber_pile":{"name":"Timber stockpile","cost":{"wood":4},"art":3,"accept":"log","capacity":12},
 "store":{"name":"Materials pallet","cost":{"wood":3},"art":4,"accept":"processed","capacity":200},
 "wagon":{"name":"Freight wagon","cost":{"wood":12,"iron":4},"art":9,"accept":"all","capacity":24},
 "cart":{"name":"Handcart","cost":{"wood":6,"iron":2},"art":5,"accept":"all","capacity":8}}
const OUTPUTS=["stone","wood","dressed_stone","iron_ore","copper_ore","coal","crystal"]
var g
var placing=""
var active_id=""
var active_anchor=Vector2.INF
var working=false
var approaching=false
var last_beat=-1
var lift=0.0
var setting_down:Dictionary={}
var field_raw:Dictionary={}
var textures={}
func _init(game):g=game
func data()->Dictionary:
 g.state.hauling.mining_revision=55
 if not g.state.hauling.has("hands"):g.state.hauling.hands={"version":1,"next":1,"loose":[],"carry":[],"facilities":[],"skills":{"miner":0,"mason":0,"forester":0,"smith":0},"facts":{}}
 return g.state.hauling.hands
func context()->String:
 if g.zone=="mine":return "mine:"+g.state.active_site+":"+str(g.deep.world.depth())
 return "surface:"+g.surface.area+":"+str(g.surface.house.level() if g.surface.area=="claim" else 0)
func local(o:Dictionary)->bool:return o.get("area","")==context()
func vehicle(f:Dictionary)->bool:return f.get("kind","") in ["cart","wagon"]
func pos(o:Dictionary)->Vector2:return Vector2(o.x,o.y)
func attached()->Dictionary:
 for f in data().facilities:
  if vehicle(f) and f.get("hitched",false) and local(f) and pos(f).distance_to(g.player)<145:return f
 return {}
func arrive(f:Dictionary):
 if f.is_empty():return
 f.area=context();f.x=g.player.x;f.y=g.player.y;f.hitched=true
func travel_speed()->float:
 var f=attached()
 return 120.0 if f.get("kind","")=="wagon" else 135.0 if not f.is_empty() else 150.0
func passage(id:String)->Dictionary:
 var f=attached()
 if f.is_empty():return f
 if id=="room:training" or (f.kind=="wagon" and (id.begins_with("room:") or id.begins_with("home:"))):
  f.hitched=false;g.notify("Your "+SPECS[f.kind].name.to_lower()+" is parked outside with its cargo. C takes the handles when you return.");return {}
 return f
func busy_hands()->bool:
 if working or not data().carry.is_empty() or not setting_down.is_empty():return true
 var cart=nearby_cart()
 return not cart.is_empty() and cart.hitched
func work_pose()->Vector2:return g.player
func work_direction(f:Dictionary)->Vector2:return Vector2(1 if float(f.x)>=g.player.x else -1,.45)
func held_label()->String:
 if not setting_down.is_empty():return "Setting down · "+raw_name(setting_down)
 if working:
  var f=facility()
  if not f.is_empty():return "Working · "+SPECS[f.kind].name
 if not field_raw.is_empty():return "Dressing · "+raw_name(field_raw)
 if not data().carry.is_empty():return "Carrying · "+raw_name(data().carry[0])+" · %d / %d" % [data().carry.size(),capacity()]
 var cart=nearby_cart()
 return "Pushing · %s · %d / %d loads" % [SPECS[cart.kind].name,cart.raw.size(),load_capacity(cart)] if not cart.is_empty() and cart.hitched else ""
func capacity()->int:return 2 if int(data().skills.mason)+int(data().skills.forester)>=8 or int(data().skills.miner)>=12 else 1
func load_capacity(f:Dictionary)->int:
 return int(SPECS[f.kind].capacity)+(4 if vehicle(f) and int(data().skills.miner)>=40 else 0)+(4 if vehicle(f) and HoldDisciplines.has(g.state,"load_bracing") else 0)
static func raw_item(raw:Dictionary)->String:return str(raw.get("item","wood" if raw.kind=="log" else "stone"))
static func raw_name(raw:Dictionary)->String:return "raw log" if raw.kind=="log" else HoldData.ITEMS[raw_item(raw)].name.to_lower()+" chunk"
func award(path:String):
 HoldDisciplines.data(g.state)
 data().skills[path]=int(data().skills.get(path,0))+1
 HoldDisciplines.award(g.state,{"miner":"mining","mason":"masonry","forester":"forestry","smith":"smithing"}.get(path,path))
func spawn(kind:String,p:Vector2,units:int,source:String="",item:String=""):
 var d=data();var id=int(d.next);d.next=id+1
 if kind=="log" and HoldDisciplines.has(g.state,"timber_selection"):units+=1
 var raw={"id":id,"kind":kind,"units":units,"source":source,"area":context(),"x":p.x,"y":p.y}
 if item!="":raw.item=item
 d.loose.append(raw)
 d.facts.extract=true
func rock(result:Dictionary,c:Vector2i)->bool:
 if result.kind not in [2,3,4,5,6,7] or result.item in ["iron_slag","copper_slag"] or result.count<=0:return false
 spawn("stone",Deepworks.center(c),int(result.count)+(1 if result.kind in [3,4,5,6] and HoldDisciplines.has(g.state,"ore_sorting") else 0),"rock:"+str(g.deep.world.depth())+":"+str(c),result.item)
 award("miner");return true
static func footprint(f:Dictionary)->Rect2:return Rect2(Vector2(f.x,f.y)-Vector2(30,12),Vector2(60,16))
func surface_obstacles()->Array:
 var result=[]
 for f in data().facilities:
  if local(f) and not f.get("hitched",false):result.append(footprint(f))
 return result
func clear_line(a:Vector2,b:Vector2)->bool:
 if g.zone=="mine":return g.deep.world.visible(a,b)
 var solids=g.surface.obstacles()
 for r in solids:
  if r.has_point(a) or r.has_point(b):continue
  for i in range(1,9):
   if r.has_point(a.lerp(b,i/8.0)):return false
 return true
func stance_clear(a:Vector2,b:Vector2)->bool:
 for i in range(1,maxi(2,ceili(a.distance_to(b)/5.0))+1):
  var p=a.lerp(b,float(i)/maxi(2,ceili(a.distance_to(b)/5.0)))
  if g.deep.world.solid(p) if g.zone=="mine" else not g.surface.walkable(p):return false
 return true
func closest(list:Array,radius:float=78)->Dictionary:
 var best={};var distance=radius
 for o in list:
  if not local(o):continue
  var d=g.player.distance_to(pos(o))
  if d<distance and clear_line(g.player,pos(o)):best=o;distance=d
 return best
func facility()->Dictionary:
 if active_anchor.distance_to(g.player)<8 and Input.get_vector("left","right","up","down")==Vector2.ZERO:
  for station in data().facilities:
   if str(station.id)==str(active_id) and local(station) and pos(station).distance_to(g.player)<120 and clear_line(g.player,pos(station)):return station
 var fixed=[]
 for f in data().facilities:
  if not vehicle(f) or not f.hitched:fixed.append(f)
 var f=closest(fixed,90)
 return closest(data().facilities,90) if f.is_empty() else f
func nearby_cart()->Dictionary:
 var carts=[]
 for f in data().facilities:
  if vehicle(f):carts.append(f)
 return closest(carts,100)
func can_place(p:Vector2)->bool:
 if g.player.distance_to(p)>140 or footprint({"x":p.x,"y":p.y}).grow(10).has_point(g.player):return false
 if g.zone=="mine":
  if g.deep.world.entrance(p):return false
  for offset in [Vector2.ZERO,Vector2(24,0),Vector2(-24,0),Vector2(0,20),Vector2(0,-20)]:
   if g.deep.world.solid(p+offset):return false
  var c=Deepworks.cell(p)
  if g.deep.world.can_descend(c,g.deep.world.depth()) or g.deep.world.data.links.has(g.deep.world.link_key(c,g.deep.world.depth()-1)):return false
  for f in g.deep.works.model.data.furniture.values():
   if int(f.depth)==g.deep.world.depth() and Deepworks.center(Vector2i(f.x,f.y)).distance_to(p)<65:return false
 else:
  if g.surface.area not in ["pinewood","claim"] and not g.surface.area.begins_with("home:") and not g.surface.architecture.interior():return false
  for offset in [Vector2.ZERO,Vector2(24,0),Vector2(-24,0),Vector2(0,20),Vector2(0,-20)]:
   if not g.surface.walkable(p+offset):return false
  for point in g.surface.points():
   if point.p.distance_to(p)<85:return false
  for dec in g.state.surface.decor:
   if g.surface.house.local(dec) and pos(dec).distance_to(p)<65:return false
 for f in data().facilities:
  if local(f) and pos(f).distance_to(p)<80:return false
 return clear_line(g.player,p)
static func snap_build(p:Vector2)->Vector2:return (p/20).round()*20
func placement_ready(kind:String,p:Vector2)->bool:
 return SPECS.has(kind) and (kind!="wagon" or capacity()>=2) and g.state.afford(SPECS[kind].cost) and can_place(snap_build(p))
func build(kind:String,p:Vector2)->bool:
 if kind=="wagon" and capacity()<2:g.notify("Freight wagon plans unlock with Strong Shoulders: eight productive masonry/forestry jobs.");return false
 p=snap_build(p)
 if not SPECS.has(kind) or not can_place(p):g.notify("Choose clear floor nearby, away from doors, stairs and other furniture.");return false
 if not g.state.pay(SPECS[kind].cost):g.notify("Bring the construction materials in your pack.");return false
 var d=data();var id=str(d.next);d.next=int(d.next)+1
 d.facilities.append({"id":id,"kind":kind,"area":context(),"x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false})
 HoldFirstShift.event(g,"rack" if kind=="stone_pile" else "bench" if kind=="breaker" else "equipment")
 d.facts.build=true;g.sound.effect("build");g.save_game();return true
func accepts(f:Dictionary,r:Dictionary)->bool:
 return SPECS[f.kind].accept in [r.kind,"all"]
func deposit(f:Dictionary)->int:
 if f.get("owner","")=="hold":g.notify("Hold crew stock. Use the western loan rack for your own material.");return 0
 var moved=0;var carry=data().carry
 for i in range(carry.size()-1,-1,-1):
  if f.raw.size()>=load_capacity(f) or not accepts(f,carry[i]):continue
  f.raw.append(carry.pop_at(i));moved+=1
 if vehicle(f) or f.kind in ["stone_pile","timber_pile"]:
  for r in data().loose.duplicate():
   if f.raw.size()>=load_capacity(f):break
   if local(r) and accepts(f,r) and pos(r).distance_to(pos(f))<90 and clear_line(pos(r),pos(f)):data().loose.erase(r);f.raw.append(r);moved+=1
 if f.kind in ["stone_pile","timber_pile"]:
  var cart=nearby_cart()
  if not cart.is_empty():
   for i in range(cart.raw.size()-1,-1,-1):
    if f.raw.size()<load_capacity(f) and accepts(f,cart.raw[i]):f.raw.append(cart.raw.pop_at(i));moved+=1
 if f.kind=="store":
  for k in OUTPUTS:
   var incoming={k:g.state.count(k)};var n=DeepHaul.transfer(incoming,f.cargo,200)
   g.state.add(k,-n);moved+=n
 if moved>0:lift=0;data().facts.stockpile=true;HoldFirstShift.event(g,"stock");g.sound.effect("wood",-15)
 return moved
func collect_output(f:Dictionary)->int:
 # Finished player work goes to the existing pack. Storage and raw loads remain
 # deliberate transfers; the hold crew keeps ownership of its own output.
 if f.get("owner","")=="hold" or not local(f):return 0
 var moved=DeepHaul.transfer(f.cargo,g.state.inventory)
 if moved>0:HoldFirstShift.event(g,"collect")
 return moved
func withdraw(f:Dictionary)->int:
 if f.get("owner","")=="hold":g.notify("These materials belong to the hold. Your worksite uses your own output.");return 0
 var moved=0
 if not f.cargo.is_empty():
  moved=collect_output(f)
 elif not f.raw.is_empty() and data().carry.size()<capacity():data().carry.append(f.raw.pop_back());setting_down={};moved=1;lift=.35
 return moved
func drop()->bool:
 var d=data()
 if d.carry.is_empty():return false
 var r=d.carry.pop_back();r.area=context();r.x=g.player.x;r.y=g.player.y+8;d.loose.append(r);lift=.35
 if d.carry.is_empty():setting_down=r.duplicate(true)
 else:lift=0.0 # Keep the remaining load supported; do not replay its pickup.
 g.save_game();return true
func input(e:InputEvent)->bool:
 if not g.playing or g.panel_id!="" or g.room_id=="training":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_B and e.shift_pressed:g.open_panel("handworks");return true
  if e.keycode==KEY_Q and drop():return true
  if e.keycode==KEY_C:
   var f=nearby_cart()
   if not f.is_empty() and vehicle(f):
    if not data().carry.is_empty():g.notify("Set your shoulder load down before taking the handles.");return true
    var hitch=not f.hitched
    for other in data().facilities:
     if vehicle(other):other.hitched=false
    f.hitched=hitch
    if not f.hitched:
     var parked=g.player+Vector2(-45 if g.surface.direction.x<-.3 else 45,10)
     if clear_line(g.player,parked):f.x=parked.x;f.y=parked.y
    g.save_game();return true
  if e.keycode==KEY_E:
   if g.zone=="mine":
    var world=g.deep.world;var upper=world.depth()-1 if e.shift_pressed else world.depth()
    if upper>=0 and world.can_descend(Deepworks.cell(g.player),upper):return false
   var f=facility();var raw=closest(data().loose,65)
   if e.shift_pressed and g.zone=="mine" and f.is_empty() and (not raw.is_empty() or not data().carry.is_empty()):return true
   if not raw.is_empty() and not e.shift_pressed and data().carry.size()<capacity() and (f.is_empty() or g.player.distance_to(pos(raw))+15<g.player.distance_to(pos(f))):
    data().loose.erase(raw);data().carry.append(raw);setting_down={};lift=.35;data().facts.lift=true;HoldFirstShift.event(g,"lift");g.save_game();return true
   if not f.is_empty():
    if f.get("owner","")=="hold":g.notify("Hold crew equipment and materials. The western loan benches are available for your work.");return true
    if vehicle(f):
     if f.hitched:return false # E remains available for doors and landings.
     if g.surface.active() and data().carry.is_empty() and not e.shift_pressed:
      var near=g.surface.nearest();var action=str(near.get("action",""))
      if action in ["leave","mine","trail","hearthward","crownward","forgeward","pinewood","claim","lift"] or action.begins_with("room:") or action.begins_with("home:"):return false
    if e.shift_pressed:withdraw(f)
    elif f.kind in ["breaker","saw"]:active_id=f.id;begin(f)
    else:deposit(f)
    g.save_game();return true
   if not raw.is_empty():
    if data().carry.size()>=capacity():g.notify("Shoulders full. Q sets one down; E deposits at a rack.");return true
    data().loose.erase(raw);data().carry.append(raw);setting_down={};lift=.35;data().facts.lift=true;HoldFirstShift.event(g,"lift");g.sound.effect("stone_0",-18);g.save_game();return true
 if e is InputEventMouseButton and e.pressed and placing!="":
  if e.button_index==MOUSE_BUTTON_RIGHT:placing="";return true
  if e.button_index==MOUSE_BUTTON_LEFT and not g.hotbar.over():
   if build(placing,g.get_global_mouse_position()+g.camera):placing=""
   return true
 return false
func begin(f:Dictionary)->bool:
 if f.get("owner","")=="hold" or not local(f) or f.kind not in ["breaker","saw"]:return false
 # Plain E also recovers output left on a bench by an older save, even if
 # there is no fresh input. Never clear nearby pallets or unfinished jobs.
 if collect_output(f)>0:g.save_game()
 g.surface.house.impact=0;g.surface.cut_target=-1;g.surface.cut_clock=0
 if not f.job.is_empty():return true
 var inputs=[data().carry,f.raw]
 for stock in data().facilities:
  if stock.get("owner","")!="hold" and local(stock) and stock.kind in ["stone_pile","timber_pile","cart","wagon"] and pos(stock).distance_to(pos(f))<150 and clear_line(pos(stock),pos(f)):inputs.append(stock.raw)
 for cargo in inputs:
  for i in cargo.size():
   if accepts(f,cargo[i]):
    f.job={"raw":cargo.pop_at(i),"progress":0.0};last_beat=-1;return true
 if active_id!=f.id:g.notify("Bring a raw "+("stone chunk" if f.kind=="breaker" else "log")+" on your shoulder or in a rack within 150 units.")
 return false
func update(dt:float):
 lift=maxf(0,lift-dt);working=false;approaching=false;field_raw={}
 if Input.get_vector("left","right","up","down")!=Vector2.ZERO:active_id=""
 if Input.get_vector("left","right","up","down")!=Vector2.ZERO:lift=0.0
 if lift<=0:setting_down={}
 if not g.playing or g.panel_id!="" or g.room_id=="training":return
 var d=data()
 if g.walking_pose and not d.carry.is_empty():HoldWorkEnergy.spend(g.state,dt*.02)
 for f in d.facilities:
  if vehicle(f) and f.hitched:
   # Only explicit, validated passages transfer equipment; abandoned carts stay put.
   if not local(f) or pos(f).distance_to(g.player)>145:f.hitched=false
   else:f.x=g.player.x;f.y=g.player.y
 var f=facility()
 if f.is_empty() and g.zone=="mine" and Input.is_key_pressed(KEY_SHIFT) and Input.is_action_pressed("interact") and Input.get_vector("left","right","up","down")==Vector2.ZERO:
  var raw=closest(d.loose,65) if d.carry.is_empty() else d.carry.back()
  if not raw.is_empty() and raw.kind=="stone":
   field_raw=raw;working=true;g.surface.direction=Vector2(1,.45)
   var before=float(raw.get("dressing",0));raw.dressing=before+dt*HoldWorkEnergy.speed(g.state);HoldWorkEnergy.spend(g.state,dt*.05)
   if int((before+.315)/.7)!=int((float(raw.dressing)+.315)/.7):g.sound.effect("stone_0",-14)
   if float(raw.dressing)>=2.1:
    if raw in d.carry:d.carry.erase(raw)
    else:d.loose.erase(raw)
    g.deep.haul.collect(raw_item(raw),int(raw.units),g.player);d.facts.process=true;d.facts.field_dress=true;field_raw={};working=false;g.save_game()
   return
 if f.is_empty() or f.kind not in ["breaker","saw"] or not Input.is_action_pressed("interact") or Input.get_vector("left","right","up","down")!=Vector2.ZERO:return
 if not begin(f):return
 active_id=f.id;active_anchor=g.player
 var side=-1 if g.player.x<=f.x else 1
 var stance=Vector2.INF;var approach=Vector2.INF
 for sign in [side,-side]:
  var candidate=pos(f)+Vector2(sign*(56 if f.kind=="breaker" else 34),-55 if f.kind=="breaker" else -24)
  if stance_clear(g.player,candidate):stance=candidate;approach=candidate;break
  var corner=pos(f)+Vector2(sign*60,35)
  if stance_clear(g.player,corner) and stance_clear(corner,candidate):stance=candidate;approach=corner;break
  # Saw stance sits beside the top edge. Walk around both corners of its solid
  # base, rather than cutting diagonally through the visible bench.
  var rear=pos(f)+Vector2(sign*60,-30)
  if stance_clear(g.player,rear) and stance_clear(rear,candidate):stance=candidate;approach=rear;break
  if stance_clear(g.player,corner) and stance_clear(corner,rear) and stance_clear(rear,candidate):stance=candidate;approach=corner;break
 if stance==Vector2.INF:return
 if g.player.distance_to(stance)>3:
  var before_pos=g.player;g.player=g.player.move_toward(approach,150*dt);active_anchor=g.player;g.walking_pose=true;HoldDrawnLocomotion.advance(g,g.player.distance_to(before_pos),"stone");g.surface.direction=(approach-before_pos).normalized();approaching=true
  return
 working=true;active_id=f.id
 var before=float(f.job.progress)
 f.job.progress=before+dt*HoldIndustry.production(g.state)*HoldWorkEnergy.speed(g.state);HoldWorkEnergy.spend(g.state,dt*.05)
 if int((before+.21)/.42)!=int((float(f.job.progress)+.21)/.42):g.sound.effect("wood" if f.kind=="saw" else "stone_0",-14)
 if float(f.job.progress)<1.26:return
 var raw=f.job.raw;var item=raw_item(raw)
 f.cargo[item]=int(f.cargo.get(item,0))+int(raw.units)+(1 if HoldDisciplines.has(g.state,"sawyer" if raw.kind=="log" else "stone_finish") else 0)
 f.job={}
 if raw.kind=="log":
  HoldDisciplines.data(g.state);data().skills.forester=int(data().skills.forester)+1;HoldDisciplines.award(g.state,"woodworking")
 else:award("mason")
 collect_output(f)
 d.facts.process=true;HoldFirstShift.event(g,"process")
 g.sound.effect("build",-20);g.save_game()
func recover():
 var f=facility()
 if f.is_empty():g.notify("Stand beside your own equipment to recover it.");return
 if f.get("fixed",false):g.notify("The loan benches stay with the hold. Build your own equipment to take with you.");return
 if not f.raw.is_empty() or not f.cargo.is_empty() or not f.job.is_empty():g.notify("Empty the equipment first, including its unfinished job.");return
 for k in SPECS[f.kind].cost:g.state.add(k,int(SPECS[f.kind].cost[k]))
 data().facilities.erase(f);g.save_game();g.open_panel("handworks",false)
func cancel_job(f:Dictionary):
 if f.get("owner","")=="hold":g.notify("This is the hold crew’s work order.");return
 if f.raw.size()>=SPECS[f.kind].capacity:g.notify("Make room in the station before returning its unfinished input.");return
 f.raw.append(f.job.raw);f.job={};g.save_game();g.open_panel("handworks",false)
func panel():
 var d=data()
 g.label(g.panel_body,"E lift / deliver · Q set down · Shift+E take from storage · C push cart",15,Color("a7dac5"))
 g.label(g.panel_body,"Craft here, then place nearby. Hold E at a supplied bench to work.",15)
 var grid=GridContainer.new();grid.columns=3;grid.add_theme_constant_override("h_separation",10);grid.add_theme_constant_override("v_separation",8);g.panel_body.add_child(grid)
 for kind in SPECS:
  var id=str(kind);var card=g.section(grid,SPECS[id].name);card.custom_minimum_size.x=220;card.add_theme_constant_override("separation",3)
  card.get_child(0).add_theme_font_size_override("font_size",16)
  var frame=card.get_parent().get_theme_stylebox("panel").duplicate();frame.set_content_margin_all(8);card.get_parent().add_theme_stylebox_override("panel",frame)
  var icon=TextureRect.new();icon.texture=texture(SPECS[id].art);icon.custom_minimum_size=Vector2(200,36);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;card.add_child(icon)
  g.label(card,HoldData.cost_text(SPECS[id].cost),13,Color("edc98a"))
  g.small_button(card,"Craft & place",func():g.surface.cancel_placement();placing=id;g.close_panel();g.notify("LMB places nearby; right click cancels. Materials charged only on valid placement."))
 g.label(g.panel_body,"Stonebreakers dress stone, ore, coal and crystal chunks into their original materials. Racks within 150 units feed the bench. Finished work goes straight into your pack. E at a rack or parked cart gathers nearby loose loads; pallets store materials you deposit.",14)
 g.label(g.panel_body,"Prospecting without a station? Away from equipment, hold Shift+E beside a chunk or while carrying it: three field-dressing blows preserve its full yield. Benches process batches faster; powered workshop technology improves them further.",14)
 g.small_button(g.panel_body,"Recover empty equipment · full material refund",recover)
 var f=facility()
 if not f.is_empty() and not f.job.is_empty():g.small_button(g.panel_body,"Return unfinished input to this station",func():cancel_job(f))
 g.label(g.panel_body,"Strong shoulders · %d / 8 masonry / forestry jobs OR %d / 12 mined faces · capacity %d" % [mini(8,int(d.skills.mason)+int(d.skills.forester)),mini(12,int(d.skills.miner)),capacity()],15)
 g.label(g.panel_body,"Miner · %d productive faces · 12: strong shoulders & joint reading · 40: controlled sections & four extra cart loads" % int(d.skills.miner),15)
 for step in [["build","Craft and place a station or stockpile"],["extract","Free a raw chunk or log"],["lift","Lift it with E; Q sets it down"],["stockpile","Deliver it to a suitable rack"],["process","Hold E at the matching bench; output enters your pack"]]:g.label(g.panel_body,("✓ " if d.facts.get(step[0],false) else "○ ")+step[1],15)
func texture(index:int)->Texture2D:
 if textures.has(index):return textures[index]
 # Upright work props share this path for placement, menus and the live world.
 # Historical vehicle/raw art retains its canonical atlas bounds.
 if index==9:
  var tex=ImageTexture.create_from_image(preload("res://assets/animation-v51/field-tools.png").get_image().get_region(HoldDrawnAnimation.bounds("field-tools",5)));textures[index]=tex;return tex
 var img=STATIONS[index].get_image() if index<STATIONS.size() else (preload("res://assets/animation-v51/homestead-props.png").get_image().get_region(HoldDrawnAnimation.bounds("homestead-props",index-6)) if index in [6,7,8] else ART.get_image().get_region(HoldDrawnAnimation.bounds("workshop",index)));var cell=img.get_size();var lo=cell;var hi=Vector2i.ZERO
 for y in img.get_height():
  for x in img.get_width():
   if img.get_pixel(x,y).a>.3:lo=lo.min(Vector2i(x,y));hi=hi.max(Vector2i(x,y))
 var tex=ImageTexture.create_from_image(img.get_region(Rect2i(lo,hi-lo+Vector2i.ONE)));textures[index]=tex;return tex
func sprite(index:int,p:Vector2,width:float,alpha:float=1.0):
 var tex=texture(index);var h=width*tex.get_height()/tex.get_width()
 g.draw_texture_rect(tex,Rect2(p-Vector2(width/2,h),Vector2(width,h)),false,Color(1,1,1,alpha))
func objects()->Array:
 var list=[]
 for o in data().loose:
  if local(o) and int(o.id)!=int(setting_down.get("id",-1)) and int(o.id)!=int(field_raw.get("id",-1)) and pos(o).distance_to(g.player)<900:list.append({"p":pos(o),"kind":"handwork","raw":o})
 for f in data().facilities:
  if local(f) and pos(f).distance_to(g.player)<900:list.append({"p":pos(f),"kind":"handwork","facility":f})
 return list
func raw_sprite(raw:Dictionary,p:Vector2,width:float=40):
 var tex=HoldFolk.raw_texture(raw.kind=="log");var height=width*tex.get_height()/tex.get_width()
 HoldFolk.raw_draw(g,raw,Rect2(p-Vector2(width/2,height),Vector2(width,height)))
func vehicle_loads(f:Dictionary,p:Vector2):
 # Pack lengthwise into the bed, two rows per tier; never build a tall icon tower.
 # Every raw record still contributes one matching stone/log silhouette.
 for i in f.raw.size():
  var col=i%4;var row=int(i/4)%2;var tier=int(i/8)
  var at=p+Vector2(7+(col-1.5)*16,-34+row*8-tier*7)
  raw_sprite(f.raw[i],at,27)
func draw_object(o:Dictionary):
 if o.has("raw"):raw_sprite(o.raw,o.p);return
 var f=o.facility
 if vehicle(f) and f.hitched:return
 sprite(SPECS[f.kind].art,o.p,110 if f.kind=="wagon" else 90 if f.kind in ["breaker","saw","cart"] else 82)
 # Every large raw record has a visible counterpart, including a full 12-load rack.
 if vehicle(f):vehicle_loads(f,o.p)
 for i in (0 if vehicle(f) else f.raw.size()):
  var row=0 if i<4 else (1 if i<8 else (2 if i<11 else 3))
  var col=i if i<4 else (i-4 if i<8 else (i-8 if i<11 else 0))
  var at=o.p+Vector2((col-1.5)*17 if row<2 else ((col-1)*17 if row==2 else 0),-10-row*8)
  raw_sprite(f.raw[i],at)
 # Processed units aggregate in bundles of twenty; quantities remain exact in cargo.
 var bundle=0
 for item in f.cargo:
  for i in ceili(float(f.cargo[item])/20.0):
   var at=o.p+Vector2((bundle%3-1)*19,-12-int(bundle/3)*10)
   if item in ["stone","dressed_stone"]:sprite(8,at,30)
   else:HoldItemArt.draw(g,Rect2(at-Vector2(15,24),Vector2(30,24)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
   bundle+=1
 if g.player.distance_to(o.p)<200 and f.kind in ["stone_pile","timber_pile","store","cart","wagon"]:
  var count=DeepHaul.amount(f.cargo) if f.kind=="store" else f.raw.size()
  HoldArt.text(g,o.p+Vector2(-22,16),"%d / %d" % [count,load_capacity(f)],11,Color("f1d8a0"))
 if not f.job.is_empty():
  var work_side=-1 if f.id=="firstshift:crewbench" or g.player.x<=f.x else 1
  var work_at=o.p+Vector2(work_side*26,-34) if ((working and active_id==f.id) or f.id=="firstshift:crewbench") and f.kind=="breaker" else o.p+Vector2(0,-27)
  raw_sprite(f.job.raw,work_at,30 if f.kind=="breaker" else 40)
  var phase=fmod(float(f.job.progress),.42)/.42
  var tip=work_at+Vector2(0,-12)
  if f.kind=="breaker":
   for i in int(float(f.job.progress)/.42):g.draw_line(tip+Vector2(-8+i*7,-10),tip+Vector2(3+i*4,8),Color("354049"),1.5)
  if working and active_id==f.id and phase>.45 and phase<.7:
   for i in 5:g.draw_circle(tip+Vector2.from_angle(i*1.2)*phase*19,1.5,Color("c8ad7c"))
  g.draw_rect(Rect2(o.p+Vector2(-30,4),Vector2(60,3)),Color("1d3038"));g.draw_rect(Rect2(o.p+Vector2(-30,4),Vector2(60*float(f.job.progress)/1.26,3)),Color("e8c27d"))
func pushing()->bool:
 var f=nearby_cart()
 if not f.is_empty() and f.hitched and data().carry.is_empty():return true
 return g.zone=="mine" and g.deep.world!=null and not g.deep.haul.cart().is_empty() and g.deep.haul.cart().hitched and data().carry.is_empty()
func carry_action()->String:
 var cargo=data().carry
 if working:return ""
 if cargo.is_empty():return "lift_"+str(setting_down.kind) if not setting_down.is_empty() else ""
 if cargo.size()>1:return "double_"+(cargo[0].kind if cargo[0].kind==cargo[1].kind else "mixed")
 return ("lift_" if lift>0 else "carry_")+str(cargo[0].kind)
func carry_phase()->float:return clampf(lift/.35 if not setting_down.is_empty() else 1-lift/.35,0,1)
func carried(p:Vector2):
 if not pushing():return
 var facing=-1 if g.surface.direction.x<-.3 else 1
 var f=nearby_cart();var cart_type="cart"
 if not f.is_empty() and f.hitched:cart_type=f.kind
 g.draw_set_transform(p-g.camera.round(),0,Vector2(facing,1)*g.character_scale())
 sprite(9 if cart_type=="wagon" else 5,Vector2(49,12),110 if cart_type=="wagon" else 90)
 if not f.is_empty() and f.hitched:
  vehicle_loads(f,Vector2(49,12))
 elif g.zone=="mine":g.deep.cargo_art(g.deep.haul.cart().cargo,Vector2(55,-20))
 g.draw_set_transform(-g.camera.round())
func overlay():
 if g.panel_id!="":return
 g.draw_set_transform(-g.camera)
 HoldFirstShift.draw_target(g)
 if placing!="":
  var p=snap_build(g.get_global_mouse_position()+g.camera);var ok=placement_ready(placing,p)
  if g.zone=="mine" or g.surface.area in ["claim","pinewood"] or g.surface.area.begins_with("home:"):
   HoldBuildPreview.grid(g,g.camera,20,Rect2(g.player-Vector2(180,180),Vector2(360,360)) if g.zone=="mine" else g.surface.build_bounds())
  sprite(SPECS[placing].art,p,85,.55)
  HoldBuildPreview.outline(g,footprint({"x":p.x,"y":p.y}),ok)
  if placing in ["breaker","saw"]:
   for stock in data().facilities:
    if local(stock) and stock.get("owner","")!="hold" and stock.kind in (["stone_pile","cart","wagon"] if placing=="breaker" else ["timber_pile","cart","wagon"]) and pos(stock).distance_to(p)<150 and clear_line(pos(stock),p):
     g.draw_dashed_line(p,pos(stock),Color("97c6bb"),2,6)
 var f=facility();var raw=closest(data().loose,65);var text=""
 if not f.is_empty():text=SPECS[f.kind].name+" · %d / %d raw · %d output · %s" % [f.raw.size(),load_capacity(f),DeepHaul.amount(f.cargo),"C park · E doorway / stairs" if vehicle(f) and f.hitched else "Hold E work · output to pack" if f.kind in ["breaker","saw"] else "E deposit · Shift+E take" ]
 if not f.is_empty() and f.kind=="store":text="Materials pallet · %d / 200 materials · E deposit · Shift+E take" % DeepHaul.amount(f.cargo)
 elif f.is_empty() and not raw.is_empty():text="E · Lift "+raw_name(raw)+" · %d units" % int(raw.units)+(" · Hold Shift+E dress" if g.zone=="mine" and raw.kind=="stone" else "")
 elif not data().carry.is_empty():text="Carrying %d / %d · Q put down · E deliver" % [data().carry.size(),capacity()]
 if not f.is_empty() and f.get("owner","")=="hold":text="Hold crew · reserved stock and work order"
 if placing!="":text="Placing "+SPECS[placing].name+" · LMB build · Right click cancel"
 if text=="":text=HoldFirstShift.context_hint(g)
 g.draw_set_transform(Vector2.ZERO)
 if text!="":
  var width=minf(924,ThemeDB.fallback_font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+24)
  g.draw_rect(Rect2(18,82,width,27),Color(.03,.08,.10,.9));HoldArt.text(g,Vector2(28,101),text,13,Color("ead6a4"))
