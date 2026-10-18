class_name HoldHandworks
extends RefCounted
# Raw records have exactly one owner: ground, shoulders, a rack or a vehicle.
# Processed output uses existing resource dictionaries and DeepHaul.transfer.
const ART=preload("res://assets/animation-v51/workshop.png")
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
var working=false
var approaching=false
var last_beat=-1
var lift=0.0
var setting_down:Dictionary={}
var textures={}
func _init(game):g=game
func data()->Dictionary:
 if not g.state.hauling.has("hands"):g.state.hauling.hands={"version":1,"next":1,"loose":[],"carry":[],"facilities":[],"skills":{"miner":0,"mason":0,"forester":0,"smith":0},"facts":{}}
 return g.state.hauling.hands
func context()->String:
 if g.zone=="mine":return "mine:"+g.state.active_site+":"+str(g.deep.world.depth())
 return "surface:"+g.surface.area+":"+str(g.surface.house.level() if g.surface.area=="claim" else 0)
func local(o:Dictionary)->bool:return o.get("area","")==context()
func vehicle(f:Dictionary)->bool:return f.get("kind","") in ["cart","wagon"]
func pos(o:Dictionary)->Vector2:return Vector2(o.x,o.y)
func busy_hands()->bool:
 if working or not data().carry.is_empty() or not setting_down.is_empty():return true
 var cart=nearby_cart()
 return not cart.is_empty() and cart.hitched
func work_pose()->Vector2:return g.player
func held_label()->String:
 if not setting_down.is_empty():return "Setting down · "+str(setting_down.kind)
 if working:
  var f=facility()
  if not f.is_empty():return "Working · "+SPECS[f.kind].name
 if not data().carry.is_empty():return "Carrying · "+("stone chunk" if data().carry[0].kind=="stone" else "raw log")+" · %d / %d" % [data().carry.size(),capacity()]
 var cart=nearby_cart()
 return "Pushing · %s · %d / %d loads" % [SPECS[cart.kind].name,cart.raw.size(),SPECS[cart.kind].capacity] if not cart.is_empty() and cart.hitched else ""
func capacity()->int:return 2 if int(data().skills.mason)+int(data().skills.forester)>=8 else 1
func award(path:String):data().skills[path]=int(data().skills.get(path,0))+1
func spawn(kind:String,p:Vector2,units:int,source:String=""):
 var d=data();var id=int(d.next);d.next=id+1
 d.loose.append({"id":id,"kind":kind,"units":units,"source":source,"area":context(),"x":p.x,"y":p.y})
 d.facts.extract=true
func rock(result:Dictionary,c:Vector2i)->bool:
 if result.kind!=2 or posmod(c.x*7+c.y*11+g.state.seed_value,4)!=0:return false
 spawn("stone",Deepworks.center(c),int(result.count),"stone:"+str(g.deep.world.depth())+":"+str(c))
 award("miner");return true
func clear_line(a:Vector2,b:Vector2)->bool:
 if g.zone=="mine":return g.deep.world.visible(a,b)
 for i in 8:
  if not g.surface.walkable(a.lerp(b,float(i+1)/8)):return false
 return true
func closest(list:Array,radius:float=78)->Dictionary:
 var best={};var distance=radius
 for o in list:
  if not local(o):continue
  var d=g.player.distance_to(pos(o))
  if d<distance and clear_line(g.player,pos(o)):best=o;distance=d
 return best
func facility()->Dictionary:
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
 if g.player.distance_to(p)>140:return false
 if g.zone=="mine":
  if g.deep.world.entrance(p):return false
  for offset in [Vector2.ZERO,Vector2(24,0),Vector2(-24,0),Vector2(0,20),Vector2(0,-20)]:
   if g.deep.world.solid(p+offset):return false
  var c=Deepworks.cell(p)
  if g.deep.world.can_descend(c,g.deep.world.depth()) or g.deep.world.data.links.has(g.deep.world.link_key(c,g.deep.world.depth()-1)):return false
  for f in g.deep.works.model.data.furniture.values():
   if int(f.depth)==g.deep.world.depth() and Deepworks.center(Vector2i(f.x,f.y)).distance_to(p)<65:return false
 else:
  if g.surface.area not in ["pinewood","claim"] and not g.surface.area.begins_with("home:"):return false
  for offset in [Vector2.ZERO,Vector2(24,0),Vector2(-24,0),Vector2(0,20),Vector2(0,-20)]:
   if not g.surface.walkable(p+offset):return false
  for point in g.surface.points():
   if point.p.distance_to(p)<85:return false
  for dec in g.state.surface.decor:
   if g.surface.house.local(dec) and pos(dec).distance_to(p)<65:return false
 for f in data().facilities:
  if local(f) and pos(f).distance_to(p)<80:return false
 return clear_line(g.player,p)
func build(kind:String,p:Vector2)->bool:
 if kind=="wagon" and capacity()<2:g.notify("Freight wagon plans unlock with Strong Shoulders: eight productive masonry/forestry jobs.");return false
 p=(p/20).round()*20
 if not SPECS.has(kind) or not can_place(p):g.notify("Choose clear floor nearby, away from doors, stairs and other furniture.");return false
 if not g.state.pay(SPECS[kind].cost):g.notify("Bring the construction materials in your pack.");return false
 var d=data();var id=str(d.next);d.next=int(d.next)+1
 d.facilities.append({"id":id,"kind":kind,"area":context(),"x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false})
 d.facts.build=true;g.sound.effect("build");g.save_game();return true
func accepts(f:Dictionary,r:Dictionary)->bool:
 return SPECS[f.kind].accept in [r.kind,"all"]
func deposit(f:Dictionary)->int:
 var moved=0;var carry=data().carry
 for i in range(carry.size()-1,-1,-1):
  if f.raw.size()>=SPECS[f.kind].capacity or not accepts(f,carry[i]):continue
  f.raw.append(carry.pop_at(i));moved+=1
 if vehicle(f):
  for r in data().loose.duplicate():
   if f.raw.size()>=SPECS[f.kind].capacity:break
   if local(r) and pos(r).distance_to(pos(f))<90 and clear_line(pos(r),pos(f)):data().loose.erase(r);f.raw.append(r);moved+=1
 elif f.kind in ["stone_pile","timber_pile"]:
  var cart=nearby_cart()
  if not cart.is_empty():
   for i in range(cart.raw.size()-1,-1,-1):
    if f.raw.size()<SPECS[f.kind].capacity and accepts(f,cart.raw[i]):f.raw.append(cart.raw.pop_at(i));moved+=1
 if f.kind=="store":
  for k in OUTPUTS:
   var incoming={k:g.state.count(k)};var n=DeepHaul.transfer(incoming,f.cargo,200)
   g.state.add(k,-n);moved+=n
 if moved>0:lift=.3;data().facts.stockpile=true;g.sound.effect("wood",-15)
 return moved
func withdraw(f:Dictionary)->int:
 var moved=0
 if not f.cargo.is_empty():moved=DeepHaul.transfer(f.cargo,g.state.inventory)
 elif not f.raw.is_empty() and data().carry.size()<capacity():data().carry.append(f.raw.pop_back());setting_down={};moved=1;lift=.35
 return moved
func drop()->bool:
 var d=data()
 if d.carry.is_empty():return false
 var r=d.carry.pop_back();r.area=context();r.x=g.player.x;r.y=g.player.y+8;d.loose.append(r);lift=.35
 if d.carry.is_empty():setting_down=r.duplicate(true)
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
    f.hitched=not f.hitched
    if not f.hitched:
     var parked=g.player+Vector2(-45 if g.surface.direction.x<-.3 else 45,10)
     if clear_line(g.player,parked):f.x=parked.x;f.y=parked.y
    g.save_game();return true
  if e.keycode==KEY_E:
   var f=facility();var raw=closest(data().loose,65)
   if not raw.is_empty() and not e.shift_pressed and data().carry.size()<capacity() and (f.is_empty() or g.player.distance_to(pos(raw))+15<g.player.distance_to(pos(f))):
    data().loose.erase(raw);data().carry.append(raw);setting_down={};lift=.35;data().facts.lift=true;g.save_game();return true
   if not f.is_empty():
    if e.shift_pressed:withdraw(f)
    elif f.kind in ["breaker","saw"]:active_id=f.id;begin(f)
    else:deposit(f)
    g.save_game();return true
   if not raw.is_empty():
    if data().carry.size()>=capacity():g.notify("Shoulders full. Q sets one down; E deposits at a rack.");return true
    data().loose.erase(raw);data().carry.append(raw);setting_down={};lift=.35;data().facts.lift=true;g.sound.effect("stone_0",-18);g.save_game();return true
 if e is InputEventMouseButton and e.pressed and placing!="":
  if e.button_index==MOUSE_BUTTON_RIGHT:placing="";return true
  if e.button_index==MOUSE_BUTTON_LEFT and not g.hotbar.over():
   if build(placing,g.get_global_mouse_position()+g.camera):placing=""
   return true
 return false
func begin(f:Dictionary)->bool:
 g.surface.house.impact=0;g.surface.cut_target=-1;g.surface.cut_clock=0
 if not f.job.is_empty():return true
 if DeepHaul.amount(f.cargo)>=180:g.notify("Output full. Shift+E collects finished materials.");return false
 var inputs=[data().carry,f.raw]
 for stock in data().facilities:
  if local(stock) and stock.kind in ["stone_pile","timber_pile","cart","wagon"] and pos(stock).distance_to(pos(f))<150 and clear_line(pos(stock),pos(f)):inputs.append(stock.raw)
 for cargo in inputs:
  for i in cargo.size():
   if accepts(f,cargo[i]):
    f.job={"raw":cargo.pop_at(i),"progress":0.0};last_beat=-1;return true
 if active_id!=f.id:g.notify("Bring a raw "+("stone chunk" if f.kind=="breaker" else "log")+" on your shoulder or in a rack within 150 units.")
 return false
func update(dt:float):
 lift=maxf(0,lift-dt);working=false;approaching=false
 if lift<=0 or Input.get_vector("left","right","up","down")!=Vector2.ZERO:setting_down={}
 if not g.playing or g.panel_id!="" or g.room_id=="training":return
 var d=data()
 for f in d.facilities:
  if vehicle(f) and f.hitched:
   # Never teleport abandoned equipment across a map or ladder.
   if not local(f) or pos(f).distance_to(g.player)>145:f.hitched=false
   else:f.x=g.player.x;f.y=g.player.y
 var f=facility()
 if f.is_empty() or f.kind not in ["breaker","saw"] or not Input.is_action_pressed("interact") or Input.get_vector("left","right","up","down")!=Vector2.ZERO:return
 if not begin(f):return
 var side=-1 if g.player.x<=f.x else 1
 var stance=pos(f)+Vector2(side*(48 if f.kind=="breaker" else 42),-45 if f.kind=="breaker" else -22)
 if g.player.distance_to(stance)>3 and clear_line(g.player,stance):
  var before_pos=g.player;g.player=g.player.move_toward(stance,185*dt);g.walking_pose=true;g.gait_clock+=dt;g.surface.direction=(stance-before_pos).normalized();approaching=true;return
 working=true;active_id=f.id
 var before=float(f.job.progress)
 f.job.progress=before+dt
 if int((before+.21)/.42)!=int((float(f.job.progress)+.21)/.42):g.sound.effect("wood" if f.kind=="saw" else "stone_0",-14)
 if float(f.job.progress)<1.26:return
 var raw=f.job.raw;var item="wood" if raw.kind=="log" else "stone"
 f.cargo[item]=int(f.cargo.get(item,0))+int(raw.units)
 f.job={};award("forester" if raw.kind=="log" else "mason");d.facts.process=true
 for store in d.facilities:
  if local(store) and store.kind=="store" and pos(store).distance_to(pos(f))<150 and clear_line(pos(store),pos(f)):DeepHaul.transfer(f.cargo,store.cargo,200);break
 g.sound.effect("build",-20);g.save_game()
func recover():
 var f=facility()
 if f.is_empty():g.notify("Stand beside your own equipment to recover it.");return
 if not f.raw.is_empty() or not f.cargo.is_empty() or not f.job.is_empty():g.notify("Empty the equipment first, including its unfinished job.");return
 for k in SPECS[f.kind].cost:g.state.add(k,int(SPECS[f.kind].cost[k]))
 data().facilities.erase(f);g.save_game();g.open_panel("handworks",false)
func cancel_job(f:Dictionary):
 if f.raw.size()>=SPECS[f.kind].capacity:g.notify("Make room in the station before returning its unfinished input.");return
 f.raw.append(f.job.raw);f.job={};g.save_game();g.open_panel("handworks",false)
func panel():
 var d=data()
 g.label(g.panel_body,"E lift / deliver · Q set down · Shift+E collect · C push cart",15,Color("a7dac5"))
 g.label(g.panel_body,"Craft here, then place nearby. Hold E at a supplied bench to work.",15)
 var grid=GridContainer.new();grid.columns=3;grid.add_theme_constant_override("h_separation",10);grid.add_theme_constant_override("v_separation",8);g.panel_body.add_child(grid)
 for kind in SPECS:
  var id=str(kind);var card=g.section(grid,SPECS[id].name);card.custom_minimum_size.x=220;card.add_theme_constant_override("separation",3)
  card.get_child(0).add_theme_font_size_override("font_size",16)
  var frame=card.get_parent().get_theme_stylebox("panel").duplicate();frame.set_content_margin_all(8);card.get_parent().add_theme_stylebox_override("panel",frame)
  var icon=TextureRect.new();icon.texture=texture(SPECS[id].art);icon.custom_minimum_size=Vector2(200,36);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;card.add_child(icon)
  g.label(card,HoldData.cost_text(SPECS[id].cost),13,Color("edc98a"))
  g.small_button(card,"Craft & place",func():placing=id;g.close_panel();g.notify("LMB places nearby; right click cancels. Materials charged only on valid placement."))
 g.label(g.panel_body,"Keep input racks and output pallets close to the bench, with a clear path. Work takes three short strokes. Collect finished materials into your pack before building or trading.",14)
 g.small_button(g.panel_body,"Recover empty equipment · full material refund",recover)
 var f=facility()
 if not f.is_empty() and not f.job.is_empty():g.small_button(g.panel_body,"Return unfinished input to this station",func():cancel_job(f))
 g.label(g.panel_body,"Strong shoulders · %d / 8 productive cuts/jobs · capacity %d" % [mini(8,int(d.skills.mason)+int(d.skills.forester)),capacity()],16)
 for step in [["build","Craft and place a station or stockpile"],["extract","Free a raw chunk or log"],["lift","Lift it with E; Q sets it down"],["stockpile","Deliver it to a suitable rack"],["process","Hold E at the matching bench; collect with Shift+E"]]:g.label(g.panel_body,("✓ " if d.facts.get(step[0],false) else "○ ")+step[1],15)
func texture(index:int)->Texture2D:
 if textures.has(index):return textures[index]
 # The painted objects slightly cross mathematical thirds; explicit atlas bounds
 # avoid drawing fragments of the neighboring row above an otherwise empty rack.
 var regions=[Rect2i(35,30,430,330),Rect2i(540,40,460,325),Rect2i(1030,20,490,340),Rect2i(0,360,490,335),Rect2i(525,390,485,305),Rect2i(1030,365,495,335),Rect2i(80,700,390,315),Rect2i(530,700,480,310),Rect2i(1060,705,440,310)]
 if index==9:
  var tex=ImageTexture.create_from_image(preload("res://assets/animation-v51/field-tools.png").get_image().get_region(HoldDrawnAnimation.bounds("field-tools",5)));textures[index]=tex;return tex
 var img=(preload("res://assets/animation-v51/homestead-props.png").get_image().get_region(HoldDrawnAnimation.bounds("homestead-props",index-6)) if index in [6,7,8] else ART.get_image().get_region(HoldDrawnAnimation.bounds("workshop",index)));var cell=img.get_size();var lo=cell;var hi=Vector2i.ZERO
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
  if local(o) and int(o.id)!=int(setting_down.get("id",-1)) and pos(o).distance_to(g.player)<900:list.append({"p":pos(o),"kind":"handwork","raw":o})
 for f in data().facilities:
  if local(f) and pos(f).distance_to(g.player)<900:list.append({"p":pos(f),"kind":"handwork","facility":f})
 return list
func raw_sprite(raw:Dictionary,p:Vector2):
 sprite(7 if raw.kind=="log" else 6,p,40)
func vehicle_loads(f:Dictionary,p:Vector2):
 # Pack lengthwise into the bed, two rows per tier; never build a tall icon tower.
 # Every raw record still contributes one matching stone/log silhouette.
 for i in f.raw.size():
  var col=i%4;var row=int(i/4)%2;var tier=int(i/8)
  var at=p+Vector2(7+(col-1.5)*16,-34+row*8-tier*7)
  sprite(7 if f.raw[i].kind=="log" else 6,at,27)
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
  HoldArt.text(g,o.p+Vector2(-22,16),"%d / %d" % [count,SPECS[f.kind].capacity],11,Color("f1d8a0"))
 if not f.job.is_empty():
  raw_sprite(f.job.raw,o.p+Vector2(0,-27))
  var phase=fmod(float(f.job.progress),.42)/.42
  var tip=o.p+Vector2(0,-48)
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
 if placing!="":sprite(SPECS[placing].art,g.get_global_mouse_position()+g.camera,85,.55)
 var f=facility();var raw=closest(data().loose,65);var text=""
 if not f.is_empty():text=SPECS[f.kind].name+" · %d / %d raw · %d output · %s" % [f.raw.size(),SPECS[f.kind].capacity,DeepHaul.amount(f.cargo),"Hold E work · Shift+E collect" if f.kind in ["breaker","saw"] else "E deposit · Shift+E take" ]
 if not f.is_empty() and f.kind=="store":text="Materials pallet · %d / 200 materials · E deposit · Shift+E take" % DeepHaul.amount(f.cargo)
 elif f.is_empty() and not raw.is_empty():text="E · Lift "+("raw log" if raw.kind=="log" else "stone chunk")
 elif not data().carry.is_empty():text="Carrying %d / %d · Q put down · E deliver" % [data().carry.size(),capacity()]
 if placing!="":text="Placing "+SPECS[placing].name+" · LMB build · Right click cancel"
 g.draw_set_transform(Vector2.ZERO)
 if text!="":
  var width=minf(924,ThemeDB.fallback_font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+24)
  g.draw_rect(Rect2(18,82,width,27),Color(.03,.08,.10,.9));HoldArt.text(g,Vector2(28,101),text,13,Color("ead6a4"))
