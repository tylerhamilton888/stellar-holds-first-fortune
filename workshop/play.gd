extends RefCounted
const L=preload("res://workshop/layout.gd")
const Art=preload("res://workshop/art.gd")
var g
var owner_ref:WeakRef
var h:
 get:return owner_ref.get_ref()
var mode=""
var moving=""
var turn=0
var last_step=Vector2i(-999,-999)
var last_area=""
var skipped=""
func _init(game,hands):g=game;owner_ref=weakref(hands)
func area()->String:return h.context()
func room(create=false)->Dictionary:
 var data=h.data()
 if not data.has("workshops"):
  if not create:return {}
  data.workshops={}
 var id=area()
 if not data.workshops.has(id) and create:data.workshops[id]=L.blank()
 return data.workshops.get(id,{})
func wall(c:Vector2i)->bool:
 if g.zone=="mine":return g.deep.world.at(c)!=0
 if g.surface.area!="claim":return false
 var house=g.surface.house;var t=house.tiles().get(house.key(house.cell(L.center(c))),{})
 return t.get("wall","") in ["wall","window"]
func blocked(p:Vector2)->bool:
 return not g.deep.world.walkable(L.coord(p)) if g.zone=="mine" else not g.surface.walkable(p)
func permitted()->bool:
 return g.zone=="mine" or (g.surface.active() and (g.surface.area=="claim" or g.surface.area.begins_with("home:")) and not g.surface.house.view.inside() and g.surface.house.level()==0)
func technology(kind:String)->String:
 return {"chair":"furnishings","flags":"stoneworking"}.get(kind,"")
func unlocked(kind:String)->bool:
 var tech=technology(kind)
 return tech=="" or g.state.tech.has(tech)
func reason(f:Dictionary,ignore:String="",pay=true)->String:
 if not permitted():return "Use your claim or an excavated mine floor."
 if pay and ignore=="" and not unlocked(f.kind):return "Research "+technology(f.kind)+" first."
 var area_data=room();var b=L.rect(f);var tile=f.kind=="flags"
 if g.player.distance_to(L.anchor(f))>170:return "Stand closer to place this."
 if not tile and L.foot(f).grow(9).has_point(g.player):return "Step out of the footprint."
 if tile and area_data.get("flags",{}).has(L.key(L.cell(f))):return "This tile is already paved."
 if tile and g.zone=="mine" and wall(L.cell(f)):
  var c=L.cell(f)
  if g.deep.world.at(c)==8 or not visible(c):return "Choose exposed, workable rock."
  if area_data.get("facing",{}).has(L.key(c)):return "This rock is already faced."
  if not h.clear_line(g.player,L.center(c)):return "Work from the exposed side."
  var exposed=false
  for d in L.DIR:
   if not wall(c+d):exposed=true
  if not exposed:return "Expose the rock before dressing it."
  if pay and not g.state.afford(L.COST.flags):return "Needs one stone."
  return ""
 var why=""
 skipped=ignore
 for y in range(b.position.y,b.end.y):
  for x in range(b.position.x,b.end.x):
   var c=Vector2i(x,y);var p=L.center(c);var old=L.on_cell(area_data,c)
   if not old.is_empty() and L.key(L.cell(old))!=ignore:why="Lift the furnishing on this tile first.";break
   if g.zone=="mine":
    var w=g.deep.world;var z=w.depth()
    if w.at(c)!=0 or w.landmark_solid(p,-1,Vector2(19,19)) or g.deep.works.model.data.furniture.has(w.link_key(c,z)) or w.can_descend(c,z) or w.data.links.has(w.link_key(c,w.above(z))) or w.entrance(p) or HoldEstateCellar.reserved(g.state,c,z) or HoldMineworks143.reserved(w,c,z) or w.layer().fixtures.has(L.key(c)):why="Keep rock, landings and existing fixtures clear.";break
    for fac in h.data().facilities:
     if h.local(fac) and h.footprint(fac).intersects(Rect2(p-Vector2(18,18),Vector2(36,36))):why="Existing equipment needs this space."
   else:
    if g.fieldwork and g.fieldwork.has_method("outdoors") and g.fieldwork.outdoors() and g.fieldwork.soil().has(g.fieldwork.Ground.key(g.fieldwork.Ground.cell(p))):why="Leave the cultivated ground clear.";break
    if preload("res://assets/timber_wing/claim_path.gd").on_lane(p):why="Keep the road clear.";break
    for delta in [Vector2.ZERO,Vector2(-12,-10),Vector2(12,-10),Vector2(-12,10),Vector2(12,10)]:
     if blocked(p+delta):why="Choose clear, level ground.";break
    if HoldEstateCellar.overlaps(g,Rect2(p-Vector2(16,16),Vector2(32,32))):why="Leave the cellar landing clear."
    for point in g.surface.points():
     if point.p.distance_to(p)<39:why="Leave the doorway or approach clear."
   if why!="":break
 skipped=""
 if why!="":return why
 if not h.clear_line(g.player,L.anchor(f)):return "Reach this spot from the same side of the wall."
 if pay and ignore=="" and not g.state.afford(L.COST[f.kind]):return "Needs "+HoldData.cost_text(L.COST[f.kind])+"."
 return ""
func install(f:Dictionary,ignore="")->String:
 var why=reason(f,ignore)
 if why!="":return why
 var r=room(true);var k=L.key(L.cell(f))
 if ignore!="":
  var old=r.pieces.get(ignore,{})
  if old.is_empty() or old.kind!=f.kind:return "Select the furnishing again."
  var rotation=f.turn
  f=old.duplicate(true);var at=k.split(",");f.x=int(at[0]);f.y=int(at[1]);f.turn=rotation
  r.pieces.erase(ignore)
 elif not g.state.pay(L.COST[f.kind]):return "Materials are missing."
 if f.kind=="flags" and wall(L.cell(f)):
  if not r.has("facing"):r.facing={}
  r.facing[k]=true
 elif f.kind=="flags":r.flags[k]=true
 else:r.pieces[k]=f
 return ""
func remove(c:Vector2i)->bool:
 var r=room();var f=L.on_cell(r,c);var kind="flags"
 if not f.is_empty():kind=f.kind;r.pieces.erase(L.key(L.cell(f)))
 elif not r.get("flags",{}).erase(L.key(c)) and not r.get("facing",{}).erase(L.key(c)):return false
 for id in L.COST[kind]:g.state.add(id,L.COST[kind][id])
 return true
func pick(action:String):
 if g.zone=="mine":g.deep.works.cancel()
 if g.fieldwork:
  g.fieldwork.cancel()
  if "terrain_mode" in g.fieldwork:g.fieldwork.terrain_mode=""
 g.surface.cancel_placement();h.placing="";mode=action;moving="";turn=0;g.close_panel()
func input(e)->bool:
 if mode!="" and e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_R:turn=posmod(turn+1,4);return true
  if e.keycode==KEY_ESCAPE:mode="";moving="";return true
 if mode!="" and e is InputEventMouseButton and e.pressed:
  if e.button_index==MOUSE_BUTTON_RIGHT:mode="";moving="";return true
  if e.button_index!=MOUSE_BUTTON_LEFT or g.hotbar.over():return false
  return click(L.coord(g.world_mouse()))
 if e is InputEventKey and e.pressed and not e.echo and e.keycode==KEY_E and not e.shift_pressed and mode=="" and not h.busy_hands():
  var f=usable()
  if not f.is_empty():g.notify(use(f));g.save_game();return true
 return false
func click(c:Vector2i)->bool:
 if mode=="" or not permitted():return false
 if g.player.distance_to(L.center(c))>170 or not h.clear_line(g.player,L.center(c)):g.notify("Stand within reach on this side.");return true
 var obj=L.on_cell(room(),c)
 if mode=="move":
  if obj.is_empty():g.notify("Select a furnishing to move.");return true
  moving=L.key(L.cell(obj));mode=obj.kind;turn=int(obj.turn);return true
 if mode=="lift":
  if remove(c):g.save_game();g.notify("Lifted. Materials returned.")
  mode="";return true
 var why=install(L.record(mode,c,turn),moving)
 if why!="":g.notify(why);return true
 if mode!="flags":mode="";moving=""
 g.save_game();return true
func panel():
 g.label(g.panel_body,"Workshop furnishings",20,Color("e7c589"))
 g.label(g.panel_body,"R turns a furnishing. E works from its front. Flagstones pave floors and face exposed rock.",14)
 var grid=GridContainer.new();grid.columns=3;g.panel_body.add_child(grid)
 for id in L.COST:
  var kind=str(id)
  if not unlocked(kind):continue
  g.small_button(grid,L.TITLE[kind]+" · "+HoldData.cost_text(L.COST[kind]),func():pick(kind))
 g.small_button(grid,"Move or rotate",func():pick("move"))
 g.small_button(grid,"Lift & refund",func():pick("lift"))
func usable()->Dictionary:
 var r=room();var c=L.coord(g.player)
 for d in [Vector2i.ZERO,Vector2i.DOWN,Vector2i.UP,Vector2i.LEFT,Vector2i.RIGHT]:
  var f=L.on_cell(r,c+d)
  if f.is_empty() or f.kind=="chair":continue
  if c in L.side(f,L.DIR[int(f.turn)]) and h.clear_line(g.player,L.anchor(f)):return f
 return {}
func mark(c:Vector2i,id:String,amount:int):
 var r=room(true);var k=L.key(c)
 if not r.wear.has(k):r.wear[k]={}
 r.wear[k][id]=mini(12,int(r.wear[k].get(id,0))+amount)
func use(f:Dictionary)->String:
 var c=L.cell(f);var front=L.DIR[int(f.turn)]
 if f.kind=="table":
  if f.get("served",false):f.served=false;return "Supper cleared from the table."
  if not g.state.pay({"food":1}):return "Bring one food to serve supper."
  f.served=true;return "Supper served."
 if f.kind=="forge":
  if not g.state.pay({"iron_ore":1,"coal":1}):return "Smelting one iron needs one iron ore and one coal."
  g.state.add("iron",1)
  for n in L.side(f,-front):
   if wall(n):mark(n,"soot",2)
  mark(c+front,"scale",1);g.sound.effect("metal",-15);return "Smelted one iron."
 if f.kind=="anvil":
  if not g.state.pay({"iron":1}):return "Bring one iron to forge fittings."
  g.state.add("parts",1);mark(c+front,"scale",2);g.sound.effect("metal",-12);return "Forged one set of parts."
 return ""
func tick():
 if not g.playing or not (g.zone=="mine" or g.surface.active()):return
 var r=room();var c=L.coord(g.player);var a=area()
 if a!=last_area:last_area=a;last_step=c;mode="";moving="";return
 if c==last_step:return
 var nearby=false
 if g.walking_pose and last_step.distance_to(c)<2 and not r.get("pieces",{}).is_empty():
  for f in r.pieces.values():
   if L.cell(f).distance_to(c)<4.5:nearby=true;break
 if nearby:mark(c,"traffic",1)
 last_step=c
func obstacles()->Array:
 var list=[];var r=room()
 for k in r.get("pieces",{}):
  if str(k)!=skipped:list.append(L.foot(r.pieces[k]))
 return list
func visible(c:Vector2i)->bool:
 return g.zone!="mine" or g.deep.world.layer().seen.has(L.key(c))
func objects()->Array:
 var r=room();var out=[]
 if r.is_empty():return out
 if g.zone!="mine":out.append({"p":g.player,"sort_y":-100000.,"kind":"handwork","work_floor":true})
 for f in r.pieces.values():
  if visible(L.cell(f)) and L.anchor(f).distance_to(g.player)<780:
   out.append({"kind":"handwork","p":L.anchor(f)+Vector2(0,L.foot(f).size.y*.37),"work_piece":f})
   for seam in L.neighbors(f,r,wall).joints:
    out.append({"kind":"handwork","p":seam+Vector2(0,18),"work_seam":seam,"sideways":int(f.turn)%2==1})
 return out
func ground():Art.ground(self,room())
func paint(f:Dictionary):Art.piece(self,f,room())
func ghost():
 if mode=="":return
 var p=g.world_mouse()
 if mode in ["move","lift"]:
  var f=L.on_cell(room(),L.coord(p))
  if not f.is_empty():g.draw_rect(L.foot(f),Color("f1d799"),false,2)
 else:
  var f=L.record(mode,L.coord(p),turn);var ok=reason(f,moving)==""
  Art.piece(self,f,room(),.55)
  g.draw_rect(L.foot(f),Color("9add96") if ok else Color("e8876e"),false,2)
func hint()->String:
 if mode!="":return "Click to "+("select a furnishing" if mode=="move" else "lift" if mode=="lift" else "place "+L.TITLE[mode])+" · R turn · Right click cancel"
 var f=usable()
 if f.is_empty():return ""
 return {"forge":"E · Smelt iron (1 ore, 1 coal)","anvil":"E · Forge parts (1 iron)","table":"E · Clear supper" if f.get("served",false) else "E · Serve supper (1 food)"}.get(f.kind,"")
