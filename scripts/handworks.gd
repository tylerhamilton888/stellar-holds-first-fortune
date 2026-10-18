class_name HoldHandworks
extends RefCounted
# Raw records have exactly one owner: ground, shoulders, a rack or a vehicle.
# Processed output uses existing resource dictionaries and DeepHaul.transfer.
const ART=preload("res://assets/handworks-v49/workshop-empty.png")
const SPECS={
 "breaker":{"name":"Stonebreaker","cost":{"wood":3,"stone":4},"art":0,"accept":"stone","capacity":4},
 "saw":{"name":"Sawbench","cost":{"wood":5,"stone":2},"art":1,"accept":"log","capacity":4},
 "stone_pile":{"name":"Stone stockpile","cost":{"wood":2,"stone":2},"art":2,"accept":"stone","capacity":12},
 "timber_pile":{"name":"Timber stockpile","cost":{"wood":4},"art":3,"accept":"log","capacity":12},
 "store":{"name":"Materials pallet","cost":{"wood":3},"art":4,"accept":"processed","capacity":200},
 "cart":{"name":"Handcart","cost":{"wood":6,"iron":2},"art":5,"accept":"all","capacity":8}}
const OUTPUTS=["stone","wood","dressed_stone","iron_ore","copper_ore","coal","crystal"]
var g
var placing=""
var active_id=""
var working=false
var last_beat=-1
var lift=0.0
var textures={}
func _init(game):g=game
func data()->Dictionary:
 if not g.state.hauling.has("hands"):g.state.hauling.hands={"version":1,"next":1,"loose":[],"carry":[],"facilities":[],"skills":{"miner":0,"mason":0,"forester":0,"smith":0},"facts":{}}
 return g.state.hauling.hands
func context()->String:
 if g.zone=="mine":return "mine:"+g.state.active_site+":"+str(g.deep.world.depth())
 return "surface:"+g.surface.area+":"+str(g.surface.house.level() if g.surface.area=="claim" else 0)
func local(o:Dictionary)->bool:return o.get("area","")==context()
func pos(o:Dictionary)->Vector2:return Vector2(o.x,o.y)
func busy_hands()->bool:
 if working or not data().carry.is_empty():return true
 var cart=nearby_cart()
 return not cart.is_empty() and cart.hitched
func work_pose()->Vector2:
 if not working:return g.player
 var f=facility()
 return g.player+(pos(f)-g.player).normalized()*20 if not f.is_empty() else g.player
func held_label()->String:
 if working:
  var f=facility()
  if not f.is_empty():return "Working · "+SPECS[f.kind].name
 if not data().carry.is_empty():return "Carrying · "+("stone chunk" if data().carry[0].kind=="stone" else "raw log")+" · %d / %d" % [data().carry.size(),capacity()]
 var cart=nearby_cart()
 return "Pushing · Handcart · %d / 8 loads" % cart.raw.size() if not cart.is_empty() and cart.hitched else ""
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
  if f.kind!="cart" or not f.hitched:fixed.append(f)
 var f=closest(fixed,90)
 return closest(data().facilities,90) if f.is_empty() else f
func nearby_cart()->Dictionary:
 var carts=[]
 for f in data().facilities:
  if f.kind=="cart":carts.append(f)
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
 if f.kind=="cart":
  for r in data().loose.duplicate():
   if f.raw.size()>=SPECS.cart.capacity:break
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
 elif not f.raw.is_empty() and data().carry.size()<capacity():data().carry.append(f.raw.pop_back());moved=1;lift=.3
 return moved
func drop()->bool:
 var d=data()
 if d.carry.is_empty():return false
 var r=d.carry.pop_back();r.area=context();r.x=g.player.x;r.y=g.player.y+8;d.loose.append(r);lift=.3;g.save_game();return true
func input(e:InputEvent)->bool:
 if not g.playing or g.panel_id!="" or g.room_id=="training":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_B and e.shift_pressed:g.open_panel("handworks");return true
  if e.keycode==KEY_Q and drop():return true
  if e.keycode==KEY_C:
   var f=nearby_cart()
   if not f.is_empty() and f.kind=="cart":f.hitched=not f.hitched;g.save_game();return true
  if e.keycode==KEY_E:
   var f=facility();var raw=closest(data().loose,65)
   if not raw.is_empty() and not e.shift_pressed and data().carry.size()<capacity() and (f.is_empty() or g.player.distance_to(pos(raw))+15<g.player.distance_to(pos(f))):
    data().loose.erase(raw);data().carry.append(raw);lift=.35;data().facts.lift=true;g.save_game();return true
   if not f.is_empty():
    if e.shift_pressed:withdraw(f)
    elif f.kind in ["breaker","saw"]:active_id=f.id;begin(f)
    else:deposit(f)
    g.save_game();return true
   if not raw.is_empty():
    if data().carry.size()>=capacity():g.notify("Shoulders full. Q sets one down; E deposits at a rack.");return true
    data().loose.erase(raw);data().carry.append(raw);lift=.35;data().facts.lift=true;g.sound.effect("stone_0",-18);g.save_game();return true
 if e is InputEventMouseButton and e.pressed and placing!="":
  if e.button_index==MOUSE_BUTTON_RIGHT:placing="";return true
  if e.button_index==MOUSE_BUTTON_LEFT and not g.hotbar.over():
   if build(placing,g.get_global_mouse_position()+g.camera):placing=""
   return true
 return false
func begin(f:Dictionary)->bool:
 if not f.job.is_empty():return true
 if DeepHaul.amount(f.cargo)>=180:g.notify("Output full. Shift+E collects finished materials.");return false
 var inputs=[data().carry,f.raw]
 for stock in data().facilities:
  if local(stock) and stock.kind in ["stone_pile","timber_pile","cart"] and pos(stock).distance_to(pos(f))<150 and clear_line(pos(stock),pos(f)):inputs.append(stock.raw)
 for cargo in inputs:
  for i in cargo.size():
   if accepts(f,cargo[i]):
    f.job={"raw":cargo.pop_at(i),"progress":0.0};last_beat=-1;return true
 if active_id!=f.id:g.notify("Bring a raw "+("stone chunk" if f.kind=="breaker" else "log")+" on your shoulder or in a rack within 150 units.")
 return false
func update(dt:float):
 lift=maxf(0,lift-dt);working=false
 if not g.playing or g.panel_id!="" or g.room_id=="training":return
 var d=data()
 for f in d.facilities:
  if f.kind=="cart" and f.hitched:
   # Never teleport abandoned equipment across a map or ladder.
   if not local(f) or pos(f).distance_to(g.player)>145:f.hitched=false
   else:f.x=g.player.x-24;f.y=g.player.y+14
 var f=facility()
 if f.is_empty() or f.kind not in ["breaker","saw"] or not Input.is_action_pressed("interact") or Input.get_vector("left","right","up","down")!=Vector2.ZERO:return
 if not begin(f):return
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
 var d=data();g.label(g.panel_body,"YOUR WORKSHOP · BUILD IT WHERE YOU WORK",20,Color("edc98a"))
 g.label(g.panel_body,"Shift+B opens this board. Place equipment in your claim, home, Pinewood or a clear mine floor. Town workshops remain available. E lifts/deposits; Q puts down; Shift+E withdraws; C pushes or parks a handcart. E at a cart gathers nearby loose loads in a batch; E at a rack unloads a nearby cart. Hold E at a bench to process.",15)
 g.label(g.panel_body,"Some solid stone faces release full chunks; logs from cuts in Pinewood. Keep input racks and output pallets within 150 units of a bench, with a clear floor route. Work takes three short strokes. Outputs remain at the bench/pallet until collected.",15)
 for kind in SPECS:
  var id=str(kind);g.button(g.panel_body,"Craft & place "+SPECS[id].name+" · "+HoldData.cost_text(SPECS[id].cost),func():placing=id;g.close_panel();g.notify("LMB places nearby; right click cancels. Materials charged only on valid placement."))
 g.small_button(g.panel_body,"Recover empty equipment · full material refund",recover)
 var f=facility()
 if not f.is_empty() and not f.job.is_empty():g.small_button(g.panel_body,"Return unfinished input to this station",func():cancel_job(f))
 g.label(g.panel_body,"Strong shoulders · %d / 8 productive cuts/jobs · capacity %d" % [mini(8,int(d.skills.mason)+int(d.skills.forester)),capacity()],16)
 for step in [["build","Craft and place a station or stockpile"],["extract","Free a raw chunk or log"],["lift","Lift it with E; Q sets it down"],["stockpile","Deliver it to a suitable rack"],["process","Hold E at the matching bench; collect with Shift+E"]]:g.label(g.panel_body,("✓ " if d.facts.get(step[0],false) else "○ ")+step[1],15)
func texture(index:int)->Texture2D:
 if textures.has(index):return textures[index]
 var source=ART.get_image();var cell=Vector2i(source.get_width()/3,source.get_height()/3)
 var img=source.get_region(Rect2i(Vector2i(index%3,index/3)*cell,cell));var lo=cell;var hi=Vector2i.ZERO
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
  if local(o) and pos(o).distance_to(g.player)<900:list.append({"p":pos(o),"kind":"handwork","raw":o})
 for f in data().facilities:
  if local(f) and pos(f).distance_to(g.player)<900:list.append({"p":pos(f),"kind":"handwork","facility":f})
 return list
func raw_sprite(raw:Dictionary,p:Vector2):
 sprite(7 if raw.kind=="log" else 6,p,40)
func draw_object(o:Dictionary):
 if o.has("raw"):raw_sprite(o.raw,o.p);return
 var f=o.facility;sprite(SPECS[f.kind].art,o.p,90 if f.kind in ["breaker","saw","cart"] else 82)
 # Every large raw record has a visible counterpart, including a full 12-load rack.
 for i in f.raw.size():
  var row=0 if i<4 else (1 if i<8 else (2 if i<11 else 3))
  var col=i if i<4 else (i-4 if i<8 else (i-8 if i<11 else 0))
  var at=o.p+Vector2((col-1.5)*17 if row<2 else ((col-1)*17 if row==2 else 0),-10-row*8)
  if f.kind=="cart":at=o.p+Vector2(2+(i%4)*9,-28-int(i/4)*10)
  raw_sprite(f.raw[i],at)
 # Processed units aggregate in bundles of twenty; quantities remain exact in cargo.
 var bundle=0
 for item in f.cargo:
  for i in ceili(float(f.cargo[item])/20.0):
   var at=o.p+Vector2((bundle%3-1)*19,-12-int(bundle/3)*10)
   if item in ["stone","dressed_stone"]:sprite(8,at,30)
   else:HoldItemArt.draw(g,Rect2(at-Vector2(15,24),Vector2(30,24)),HoldItemArt.item_index(item),HoldItemArt.tint(item))
   bundle+=1
 if g.player.distance_to(o.p)<200 and f.kind in ["stone_pile","timber_pile","store","cart"]:
  var count=DeepHaul.amount(f.cargo) if f.kind=="store" else f.raw.size()
  HoldArt.text(g,o.p+Vector2(-22,16),"%d / %d" % [count,SPECS[f.kind].capacity],11,Color("f1d8a0"))
 if not f.job.is_empty():
  raw_sprite(f.job.raw,o.p+Vector2(0,-27))
  var phase=fmod(float(f.job.progress),.42)/.42
  var tip=o.p+Vector2(0,-48)
  if f.kind=="breaker":
   for i in int(float(f.job.progress)/.42):g.draw_line(tip+Vector2(-8+i*7,-10),tip+Vector2(3+i*4,8),Color("354049"),1.5)
  var palm=work_pose()+(Vector2(0,12) if g.zone=="mine" else Vector2.ZERO)+HoldDirectional.hand(g.state.appearance,(o.p-g.player).normalized(),phase,g.character_scale())
  if working and active_id==f.id:
   var end=tip if phase>.42 and phase<.7 else tip+Vector2(-12,-25)*(1-sin(phase*PI))
   if f.kind=="saw":
    g.draw_line(tip+Vector2(-25+sin(phase*TAU)*8,0),tip+Vector2(25+sin(phase*TAU)*8,0),Color("ccd4cb"),5)
    g.draw_line(palm,tip+Vector2(20+sin(phase*TAU)*8,0),HoldAppearance.cloth(g.state.appearance),6)
   else:HoldCharacterArt.draw_tool(g,palm-g.camera,end-g.camera,3,-g.camera,g.face,-1,.7)
   if phase>.45 and phase<.7:
    for i in 5:g.draw_circle(tip+Vector2.from_angle(i*1.2)*phase*19,1.5,Color("c8ad7c"))
  g.draw_rect(Rect2(o.p+Vector2(-30,4),Vector2(60,3)),Color("1d3038"));g.draw_rect(Rect2(o.p+Vector2(-30,4),Vector2(60*float(f.job.progress)/1.26,3)),Color("e8c27d"))
func carried(p:Vector2):
 for cart in data().facilities:
  if local(cart) and cart.kind=="cart" and cart.hitched:
   for side in [-1,1]:
    var hand=pos(cart)+Vector2(-17+side*10,-8)
    g.draw_line(p+Vector2(side*14,-30),hand,HoldAppearance.cloth(g.state.appearance),6)
    g.draw_circle(hand,3,Color(HoldAppearance.SKIN_COLORS[g.state.appearance.get("skin",0)]))
 var carry=data().carry
 for i in carry.size():
  var side=-1 if i==0 else 1
  var at=p+Vector2(side*19,-43-sin(lift/.35*PI)*10)
  raw_sprite(carry[i],at)
  g.draw_line(p+Vector2(side*16,-32),at+Vector2(0,-8),HoldAppearance.cloth(g.state.appearance),7)
  g.draw_circle(at+Vector2(0,-8),3,Color(HoldAppearance.SKIN_COLORS[g.state.appearance.get("skin",0)]))
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
