class_name HoldMineworks143
extends RefCounted
# Annexes use existing depth-local terrain, cargo, furnishings and save owners.
# They are lateral worksites, never lower landings of the original five depths.
const FIRST=5
const SEAL=Vector2i(24,10)
const BRIDGE_COST={"wood":12,"iron":4,"stone":8}
const THEMES={"craft":"Craft district","stores":"Store district","hearth":"Hearth district"}
static func data(w)->Dictionary:
 if not w.data.has("mineworks143"):
  w.data.mineworks143={"version":1,"districts":{},"next":1,"seal":false,"bridge":false,"visited":{}}
 return w.data.mineworks143
static func label(z:int)->String:
 return Deepworks.NAMES[z] if z>=FIRST else "Depth %d · %s" % [z+1,Deepworks.NAMES[z]]
static func entrance(w)->Vector2i:
 var q=data(w)
 if q.has("entrance"):return Vector2i(q.entrance[0],q.entrance[1])
 # Find vacant, reachable floor; never clear or move an old save's property.
 var candidates=[Vector2i(3,3),Vector2i(11,3),Vector2i(10,10),Vector2i(6,10),Vector2i(10,6),Vector2i(6,6),Vector2i(8,9)]
 for y in range(4,16):
  for x in range(4,16):
   if Vector2i(x,y).distance_to(Deepworks.ENTRY)>=3:candidates.append(Vector2i(x,y))
 for c in candidates:
  if not w.walkable(c,0) or w.layer(0).fixtures.has(Deepworks.key(c)):continue
  if w.data.links.has(w.link_key(c,0)) or w.data.get("living",{}).get("furniture",{}).has(w.link_key(c,0)):continue
  var near_equipment=false
  for f in w.state.hauling.get("hands",{}).get("facilities",[]):
   if f.area=="mine:"+w.state.active_site+":0" and Deepworks.center(c).distance_to(Vector2(f.x,f.y))<115:near_equipment=true;break
  if near_equipment or w.route(Deepworks.ENTRY,0,"",c).is_empty():continue
  q.entrance=[c.x,c.y];return c
 return Vector2i(-1,-1)
static func prepare(w):
 if w.data.layers.size()>FIRST:return
 for z in range(FIRST,FIRST+3):
  var l={"cells":[],"strata":[],"damage":{},"seen":{},"features":[],"fixtures":{}}
  for y in Deepworks.H:
   for x in Deepworks.W:
    var k=2 if z!=6 else 7
    if absf(x-(18+sin(y*.12+float(int(w.data.seed)%31))*3))<1.5:k=5 if z==5 else 3
    if absf(x-(49+sin(y*.16)*4))<2:k=4 if z==5 else 6
    if x<1 or y<1 or x>=Deepworks.W-1 or y>=Deepworks.H-1:k=8
    l.strata.append(7 if z==6 else 2);l.cells.append(k)
  # A modest arrival bay; most of each 80 x 64 worksite stays unexcavated.
  for y in range(6,14):
   for x in range(5,13):l.cells[y*Deepworks.W+x]=0
  for c in [Vector2i(35,30),Vector2i(59,44)]:
   for y in range(c.y-3,c.y+4):
    for x in range(c.x-4,c.x+5):
     if Vector2(x-c.x,y-c.y).length()<4:l.cells[y*Deepworks.W+x]=0
  l.fixtures["7,7"]="lamp"
  if z==5:
   # An old driven heading points toward the sealed eastern adit.
   for x in range(13,24):
    for y in range(9,12):l.cells[y*Deepworks.W+x]=0
   l.cells[SEAL.y*Deepworks.W+SEAL.x]=7
  if z==6:
   for x in range(13,24):
    for y in range(11,14):l.cells[y*Deepworks.W+x]=0
   # The fault spans the entire map: digging around the bridge cannot cross it.
   for y in range(1,Deepworks.H-1):
    for x in range(24,31):l.cells[y*Deepworks.W+x]=8
   for x in range(31,36):
    for y in range(10,15):l.cells[y*Deepworks.W+x]=0
  w.data.layers.append(l)
 w.rebuild_landmarks()
static func return_landing(w,z:int)->Vector2i:
 if w.data.layers.size()<=z:return Vector2i(8,6)
 var q=data(w)
 if not q.has("returns144"):q.returns144={}
 if q.returns144.has(str(z)):
  var c=q.returns144[str(z)];return Vector2i(int(c[0]),int(c[1]))
 var chosen=Vector2i(8,6)
 for x in [8,9,10,7,6,11]:
  var clear=true
  for c in [Vector2i(x-1,6),Vector2i(x,6),Vector2i(x+1,6),Vector2i(x,7),Vector2i(x,8)]:
   if not w.terrain_walkable(c,z) or w.equipment_solid(Deepworks.center(c),z) or w.layer(z).fixtures.has(Deepworks.key(c)) or w.data.links.has(w.link_key(c,z)):clear=false
  if clear:chosen=Vector2i(x,6);break
 q.returns144[str(z)]=[chosen.x,chosen.y];return chosen
static func portals(w,z:int)->Array:
 var entry=entrance(w)
 if z==0:return [] if entry.x<0 else [{"id":"entry","c":entry,"to":5,"target":return_landing(w,5)+Vector2i.DOWN*2,"name":"Stonewright Delve","open":true}]
 if z==5:return [{"id":"return","c":return_landing(w,5),"to":0,"target":entry,"name":"Old Workings","open":entry.x>=0},{"id":"seal","c":Vector2i(23,10),"to":6,"target":return_landing(w,6)+Vector2i.DOWN*2,"name":"Blackvein Reach","open":bool(data(w).seal)}]
 if z==6:return [{"id":"return","c":return_landing(w,6),"to":5,"target":Vector2i(23,10),"name":"Stonewright Delve","open":true},{"id":"farbank","c":Vector2i(33,12),"to":7,"target":return_landing(w,7)+Vector2i.DOWN*2,"name":"Farbank Works","open":bool(data(w).bridge)}]
 if z==7:return [{"id":"return","c":return_landing(w,7),"to":6,"target":Vector2i(33,12),"name":"Blackvein Reach","open":bool(data(w).bridge)}]
 return []
static func reserved(w,c:Vector2i,z:int)->bool:
 if HoldMineEntrance.reserved(w,c,z):return true
 for p in portals(w,z):
  if c.distance_to(p.c)<2 or (p.id=="return" and c==p.c+Vector2i.DOWN*2):return true
 return (z==5 and c==SEAL) or (z==6 and Rect2i(22,10,14,5).has_point(c))
static func release_seal(w,c:Vector2i,z:int):
 if z==5 and c==SEAL:data(w).seal=true
static func near_bridge(g)->bool:
 return g.zone=="mine" and g.deep.world!=null and g.deep.world.depth()==6 and g.player.distance_to(Deepworks.center(Vector2i(23,12)))<70 and g.deep.world.visible(g.player,Deepworks.center(Vector2i(23,12)))
static func repair(g)->String:
 var w=g.deep.world
 if not near_bridge(g):return "Stand beside the broken bridge in Blackvein Reach."
 if data(w).bridge:return "The bridge is already sound."
 if not g.state.tech.has("stoneworking"):return "Research Stoneworking before rebuilding the bridge seats."
 if not g.state.pay(BRIDGE_COST):return "Bring "+HoldData.cost_text(BRIDGE_COST)+" to rebuild the crossing."
 for y in range(11,14):
  for x in range(24,31):w.set_cell(Vector2i(x,y),0)
 data(w).bridge=true;g.depth_nav.explore.invalidate();g.save_game()
 return "The fault bridge is restored. Walk across to the Farbank adit; carts can follow."
static func nearby(g)->Dictionary:
 if g.zone!="mine" or g.deep.world==null:return {}
 var w=g.deep.world
 for p in portals(w,w.depth()):
  if g.player.distance_to(Deepworks.center(p.c))<48 and w.visible(g.player,Deepworks.center(p.c)):return p
 return {}
static func work_priority(g,at:Vector2)->bool:
 # The closest target owns E; standing on a marked adit takes travel priority.
 var f=g.handworks.facility()
 if not f.is_empty() and not (g.handworks.vehicle(f) and f.hitched) and g.player.distance_to(g.handworks.pos(f))<g.player.distance_to(at):return true
 var raw=g.handworks.closest(g.handworks.data().loose,65)
 return not raw.is_empty() and g.player.distance_to(g.handworks.pos(raw))<g.player.distance_to(at)
static func prompt(g)->String:
 if near_bridge(g) and not data(g.deep.world).bridge:return "" if work_priority(g,Deepworks.center(Vector2i(23,12))) else "E · Inspect broken bridge"
 var p=nearby(g)
 if p.is_empty() or work_priority(g,Deepworks.center(p.c)):return ""
 return "E · Enter "+p.name if p.open else "Basalt seal · Mine with a tempered pick · V details"
static func interact(g)->bool:
 if prompt(g)=="":return false
 if near_bridge(g) and not data(g.deep.world).bridge:
  g.deep.works.page="Districts";g.open_panel("living");return true
 var p=nearby(g)
 if p.is_empty():return false
 if not p.open:g.notify("The basalt seal blocks this adit. Research Tempered steel, then mine the dark face beside the portal.");return true
 var w=g.deep.world;prepare(w)
 if not w.walkable(p.target,int(p.to)):
  g.notify("The far landing is blocked. Clear its approach before using this adit.");return true
 var vehicle=g.handworks.attached();var cart=g.deep.haul.cart();var cart_follows=not cart.is_empty() and cart.hitched and int(cart.depth)==w.depth() and g.deep.haul.cart_pos().distance_to(g.player)<100
 g.deep.works.cancel();w.data.depth=int(p.to);g.player=Deepworks.center(p.target);w.data.position=[g.player.x,g.player.y]
 g.handworks.arrive(vehicle)
 if cart_follows:cart.depth=w.depth();cart.x=g.player.x;cart.y=g.player.y
 g.deep.strike_left=0;g.deep.contact_hold=0;g.deep.stair_work=0;g.deep.survey_open=false;g.deep.rubble.clear();g.deep.sparks.clear();g.deep.messages.clear();g.deep.arrival_up_held=false
 g.velocity=Vector2.ZERO;g.fight.cancel_actions();g.camera=g.deep.camera_target();g.depth_nav.explore.invalidate()
 data(w).visited[str(w.depth())]=true;w.survey(g.player)
 g.begin_transition(label(w.depth()).to_upper());g.sound.effect("door",-16);g.save_game();return true
static func district_at(w,c:Vector2i,z:int=-1)->Dictionary:
 var depth=w.depth() if z<0 else z
 for d in data(w).districts.values():
  if int(d.depth)==depth and Rect2i(int(d.x),int(d.y),int(d.w),int(d.h)).has_point(c):return d
 return {}
static func designate(w,a:Vector2i,b:Vector2i,name:String,kind:String)->String:
 if w.depth()<FIRST:return "Plan districts in the dedicated mineworks; the adit is beside the Old Workings landing."
 if not THEMES.has(kind):return "Choose a district purpose."
 var rect=Rect2i(Vector2i(mini(a.x,b.x),mini(a.y,b.y)),Vector2i(absi(a.x-b.x)+1,absi(a.y-b.y)+1))
 if rect.size.x<6 or rect.size.y<6 or rect.size.x>30 or rect.size.y>30:return "Plan a district between 6 × 6 and 30 × 30 tiles."
 if not Rect2i(2,2,Deepworks.W-4,Deepworks.H-4).encloses(rect):return "Keep district plans inside the workable rock."
 if name.strip_edges()=="" or name.length()>32:return "Give the district a name of 1–32 characters."
 for y in range(rect.position.y,rect.end.y):
  for x in range(rect.position.x,rect.end.x):
   var c=Vector2i(x,y)
   if w.at(c)==8 or reserved(w,c,w.depth()):return "Leave the fault, adits and freight landings outside district plans."
 for d in data(w).districts.values():
  if int(d.depth)==w.depth() and Rect2i(d.x,d.y,d.w,d.h).intersects(rect):return "District plans cannot overlap."
 if data(w).districts.size()>=24:return "This site already has twenty-four district plans."
 var id=str(int(data(w).next));data(w).next=int(data(w).next)+1
 data(w).districts[id]={"id":id,"name":name.strip_edges(),"kind":kind,"depth":w.depth(),"x":rect.position.x,"y":rect.position.y,"w":rect.size.x,"h":rect.size.y}
 return "District planned: "+name.strip_edges()+". Carve its streets and chambers at your own pace."
static func progress(w,d:Dictionary)->String:
 var dug=0;var rooms=0;var equipment=0
 var rect=Rect2i(d.x,d.y,d.w,d.h)
 for y in range(rect.position.y,rect.end.y):
  for x in range(rect.position.x,rect.end.x):
   if w.at(Vector2i(x,y),int(d.depth))==0:dug+=1
 for r in w.data.get("living",{}).get("rooms",{}).values():
  if int(r.depth)==int(d.depth) and rect.encloses(Rect2i(r.x,r.y,r.w,r.h)):rooms+=1
 for f in w.state.hauling.get("hands",{}).get("facilities",[]):
  if f.area=="mine:"+w.state.active_site+":"+str(int(d.depth)) and rect.has_point(Deepworks.cell(Vector2(f.x,f.y))):equipment+=1
 return "%d%% excavated · %d rooms · %d worksite fixtures" % [dug*100/(int(d.w)*int(d.h)),rooms,equipment]
static func panel(g):
 var w=g.deep.world;var q=data(w)
 g.label(g.panel_body,"MINEWORKS & DISTRICTS",20)
 g.label(g.panel_body,"Stonewright Delve → Blackvein Reach → Farbank Works. Each is a separate, permanent worksite. Follow the adit beside the Old Workings landing. The original five depths remain accessible by their stairs.",15)
 g.label(g.panel_body,"Eastern seal: "+("Open" if q.seal else "Research Tempered steel, then mine the dark basalt face at the end of Stonewright's eastern heading."),15)
 g.label(g.panel_body,"Fault bridge: "+("Restored · carts can cross" if q.bridge else "Stoneworking + "+HoldData.cost_text(BRIDGE_COST)+". Inspect the broken seats in Blackvein Reach."),15)
 if near_bridge(g) and not q.bridge:
  g.button(g.panel_body,"Rebuild fault bridge",func():g.notify(repair(g));g.open_panel("living",false))
 if w.depth()>=FIRST:
  g.label(g.panel_body,"Reserve rock for a district, then carve its streets, chambers and storage bays. Furnish rooms with O; build stockpiles and worksite equipment with Shift+B.",14)
  var name=LineEdit.new();name.placeholder_text="Name your district";name.max_length=32;name.text="New district";g.panel_body.add_child(name)
  var row=g.row(g.panel_body)
  for kind in THEMES:
   g.small_button(row,THEMES[kind],func():g.deep.works.district_name=name.text;g.deep.works.choose("district",kind))
 for id in q.districts:
  var d=q.districts[id]
  g.label(g.panel_body,d.name+" · "+THEMES[d.kind]+" · "+Deepworks.NAMES[int(d.depth)],16)
  g.label(g.panel_body,progress(w,d),14)
  g.small_button(g.panel_body,"Remove plan: "+d.name,func():q.districts.erase(id);g.save_game();g.open_panel("living",false))
 g.label(g.panel_body,"Removing a plan leaves all excavated ground, rooms, belongings and equipment intact.",13)
static func props(w)->Array:
 var out=[]
 for p in portals(w,w.depth()):
  if w.layer().seen.has(Deepworks.key(p.c)):out.append({"p":Deepworks.center(p.c),"kind":"adit","open":p.open,"name":"OLD WORKINGS" if p.to==0 else "PASSAGE","side":p.id in ["seal","farbank"]})
 return out
static func draw_prop(n,o:Dictionary):
 HoldMineEntrance.draw_inside(n,o)
static func draw_floor(g):
 var w=g.deep.world
 if w.depth()==6:
  for y in range(8,17):
   for x in range(24,31):
    if not w.layer().seen.has(Deepworks.key(Vector2i(x,y))):continue
    var rect=Rect2(x*40,y*40,40,40)
    if q_bridge(w) and y in [11,12,13]:
     g.surface.house.material(1,rect,Color(.8,.76,.64))
     g.draw_line(rect.position+Vector2(0,5),rect.position+Vector2(40,5),Color("b3a080"),2)
    else:g.draw_rect(rect,Color("0e1822"))
  for x in [23,31]:
   for y in [10,14]:
    if w.layer().seen.has(Deepworks.key(Vector2i(x,y))):HoldFurnishings.draw(g,Deepworks.center(Vector2i(x,y))+Vector2(0,12),"plinth",Color(.7,.72,.68))
 if g.deep.works.mode=="district":
  for d in data(w).districts.values():
   if int(d.depth)==w.depth():g.draw_rect(Rect2(d.x*40,d.y*40,d.w*40,d.h*40),Color("91b9a4"),false,2)
static func q_bridge(w)->bool:return bool(data(w).bridge)
