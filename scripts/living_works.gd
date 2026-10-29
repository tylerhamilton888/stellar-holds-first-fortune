class_name LivingWorks
extends RefCounted
# One site-local spatial model. Existing inventory/research remain authoritative.
const FUNCTIONS={"workshop":{"name":"Workshop","needs":["bench","anvil","lamp"]},"bedroom":{"name":"Bedroom","needs":["bed","lamp"]}}
const FURNITURE={
 "mason":{"name":"Mason’s bench","cost":{"wood":3,"stone":2},"tech":"","solid":true,"function":2,"comfort":0,"heritage":1},
 "bench":{"name":"Joiner's bench","cost":{"wood":4,"stone":2},"tech":"","solid":true,"function":2,"comfort":0,"heritage":0},
 "anvil":{"name":"Forge hearth & anvil","cost":{"iron":3,"stone":4},"tech":"","solid":true,"function":3,"comfort":0,"heritage":1},
 "bed":{"name":"Timber bed","cost":{"wood":4},"tech":"","solid":true,"function":0,"comfort":2,"heritage":0},
 "lamp":{"name":"Warm lantern","cost":{"wood":1,"coal":1},"tech":"","solid":false,"function":1,"comfort":1,"heritage":0},
 "table":{"name":"Oak table","cost":{"wood":3},"tech":"","solid":true,"function":1,"comfort":1,"heritage":0},
 "shelf":{"name":"Tool shelf","cost":{"wood":2},"tech":"","solid":true,"function":1,"comfort":0,"heritage":1},
 "pillar":{"name":"Stone pillar","cost":{"stone":4},"tech":"stoneworking","solid":true,"function":0,"comfort":0,"heritage":1},
 "chair":{"name":"Carved chair","cost":{"wood":3},"tech":"furnishings","solid":false,"function":0,"comfort":2,"heritage":1},
 "rune":{"name":"Ancestral pillar","cost":{"stone":5,"copper":1},"tech":"fine_masonry","solid":true,"function":0,"comfort":0,"heritage":3}}
const FINISHES={
 "ashlar":{"name":"Dressed stone floor","surface":"floor","cost":{"dressed_stone":1},"tech":"","craft":2},
 "timber":{"name":"Timber floor","surface":"floor","cost":{"wood":1},"tech":"","craft":1},
 "flags":{"name":"Flagstone floor","surface":"floor","cost":{"stone":1},"tech":"stoneworking","craft":1},
 "inlay":{"name":"Copper-inlaid floor","surface":"floor","cost":{"stone":2,"copper":1},"tech":"fine_masonry","craft":2},
 "smooth":{"name":"Smoothed stone","surface":"wall","cost":{},"tech":"stoneworking","craft":1},
 "masonry":{"name":"Cut masonry","surface":"wall","cost":{"stone":2},"tech":"stoneworking","craft":1},
 "runic":{"name":"Runic stonework","surface":"wall","cost":{"stone":2,"copper":1},"tech":"fine_masonry","craft":2},
 "ancestor":{"name":"Rivethand knotwork","surface":"wall","cost":{"stone":2,"copper":1},"tech":"ancestor_marks","craft":2}}
const PREFERENCES={"brann":{"style":"masonry","interest":"A sound workshop and the old stone traditions","drink":"dark malt"},"dagr":{"style":"runic","interest":"Bold carvings and room to move","drink":"spiced ale"},"osvik":{"style":"smooth","interest":"Orderly tools and careful workmanship","drink":"small beer"}}
var s
var w:Deepworks
var data:Dictionary
func _init(state,world:Deepworks):
 s=state;w=world
 if not w.data.has("living"):w.data.living={"version":1,"next_id":1,"rooms":{},"furniture":{},"surfaces":{},"assignments":{},"folk":{},"opportunity":""}
 data=w.data.living
 for id in PREFERENCES:
  if not data.folk.has(id):data.folk[id]={"preference":PREFERENCES[id].duplicate(true),"morale":0,"rested_until":0.0,"activity":"Unassigned"}
func at(c:Vector2i,z:int=-1)->Dictionary:
 var level=w.depth() if z<0 else z
 for r in data.rooms.values():
  if int(r.depth)==level and c.x>=r.x and c.y>=r.y and c.x<r.x+r.w and c.y<r.y+r.h:return r
 return {}
func room_cells(r:Dictionary)->Array:
 var out=[]
 for y in range(r.y,r.y+r.h):
  for x in range(r.x,r.x+r.w):out.append(Vector2i(x,y))
 return out
func id_at(c:Vector2i,z:int=-1)->String:return w.link_key(c,w.depth() if z<0 else z)
func unlocked(definition:Dictionary)->bool:return definition.tech=="" or s.tech.has(definition.tech)
func designate(a:Vector2i,b:Vector2i,kind:String)->String:
 if not FUNCTIONS.has(kind):return "Unknown room function."
 var pos=Vector2i(mini(a.x,b.x),mini(a.y,b.y));var size=Vector2i(absi(a.x-b.x)+1,absi(a.y-b.y)+1)
 if size.x<4 or size.y<4 or size.x>9 or size.y>9:return "Choose an excavated rectangle from 4 x 4 to 9 x 9 tiles."
 if data.rooms.size()>=16:return "This worksite already has sixteen designated rooms."
 var r={"id":str(int(data.next_id)),"kind":kind,"depth":w.depth(),"x":pos.x,"y":pos.y,"w":size.x,"h":size.y,"name":FUNCTIONS[kind].name+" "+str(int(data.next_id)),"metrics":{}}
 for c in room_cells(r):
  if w.at(c)!=0:return "Excavate every tile inside the proposed room first."
  if not at(c).is_empty():return "Rooms cannot overlap."
  if w.depth()==0 and c.distance_to(Deepworks.ENTRY)<2:return "Leave the entrance and freight landing clear."
 data.rooms[r.id]=r;data.next_id+=1;refresh();return "Designated "+r.name+". Furnish it, finish its surfaces, then assign a Dwarf."
func connected(r:Dictionary,blocked:Vector2i=Vector2i(-1,-1))->bool:
 var floor=[]
 for c in room_cells(r):
  if c!=blocked and w.walkable(c,int(r.depth)):floor.append(c)
 if floor.is_empty():return false
 var seen={Deepworks.key(floor[0]):true};var queue=[floor[0]];var head=0
 while head<queue.size():
  var c=queue[head];head+=1
  for d in Deepworks.DIRS:
   var n=c+d;var k=Deepworks.key(n)
   if n in floor and not seen.has(k):seen[k]=true;queue.append(n)
 return seen.size()==floor.size()
func place(c:Vector2i,kind:String,occupied:Array=[])->String:
 if not FURNITURE.has(kind):return "Unknown furnishing."
 var def=FURNITURE[kind];var r=at(c);var key=id_at(c)
 if r.is_empty() or w.at(c)!=0:return "Place furnishings on floor inside a designated room."
 if w.landmark_solid(Deepworks.center(c),-1,Vector2(20,20)):return "Keep the landmark base clear."
 if not unlocked(def):return "Research "+HoldData.RESEARCH[def.tech].name+" first."
 if data.furniture.has(key) or w.layer().fixtures.has(Deepworks.key(c)):return "There is already a furnishing or work lamp here."
 if w.can_descend(c,w.depth()) or (w.depth()>0 and w.can_descend(c,w.depth()-1)):return "Keep stair landings clear."
 var cart=w.data.get("haulage",{}).get("cart",{})
 if not cart.is_empty() and int(cart.depth)==w.depth() and Deepworks.cell(Vector2(cart.x,cart.y))==c:return "Move the wheelbarrow before furnishing this floor."
 if c in occupied:return "Leave room for the Dwarf standing here."
 if def.solid:
  if c.x==r.x or c.y==r.y or c.x==r.x+r.w-1 or c.y==r.y+r.h-1:return "Keep the room's outer aisle free. Solid furniture belongs inside."
  if not connected(r,c):return "That would divide the walkable floor. Keep an open route around your furniture."
 if not s.pay(def.cost):return "Needs stored materials: "+HoldData.cost_text(def.cost)
 data.furniture[key]={"kind":kind,"x":c.x,"y":c.y,"depth":w.depth(),"room":r.id,"solid":def.solid,"paid":def.cost.duplicate()}
 refresh();return def.name+" installed."
func remove(c:Vector2i)->String:
 var key=id_at(c)
 if not data.furniture.has(key):return "No furniture here."
 var f=data.furniture[key]
 for item in f.paid:s.add(item,int(f.paid[item]))
 data.furniture.erase(key);refresh();return "Dismantled carefully. Construction materials returned to stores."
func finish(c:Vector2i,kind:String)->String:
 if not FINISHES.has(kind):return "Unknown finish."
 var def=FINISHES[kind]
 if not unlocked(def):return "This finish needs "+("Brann's craftsmanship opportunity." if def.tech=="ancestor_marks" else HoldData.RESEARCH[def.tech].name+".")
 var r=at(c)
 if def.surface=="wall":
  if w.at(c) in [0,8]:return "Choose an exposed natural wall beside your room."
  for d in Deepworks.DIRS:
   if not at(c+d).is_empty():r=at(c+d);break
 elif w.at(c)!=0:return "Floor finishes need excavated ground."
 if r.is_empty():return "Finish floor or boundary walls belonging to a designated room."
 var key=id_at(c)
 if data.surfaces.get(key,{}).get("kind","")==kind:return "This surface already has that finish."
 if not s.pay(def.cost):return "Needs stored materials: "+HoldData.cost_text(def.cost)
 data.surfaces[key]={"kind":kind,"x":c.x,"y":c.y,"depth":w.depth(),"room":r.id,"surface":def.surface}
 refresh();return def.name+" finished."
func quality(r:Dictionary)->Dictionary:
 var counts={};var comfort=0;var functionality=0;var heritage=0;var furniture_count=0;var access=true
 for f in data.furniture.values():
  if f.get("room","")!=r.id:continue
  furniture_count+=1;var n=int(counts.get(f.kind,0));counts[f.kind]=n+1
  if n>0:continue # duplicates add no score
  var def=FURNITURE[f.kind];comfort+=def.comfort;functionality+=def.function;heritage+=def.heritage
  var usable=false
  for d in Deepworks.DIRS:
   if w.walkable(Vector2i(f.x,f.y)+d,int(r.depth)):usable=true
  access=access and usable
 var floor_points=0.0;var wall_points=0.0;var styles={}
 for f in data.surfaces.values():
  if f.get("room","")!=r.id:continue
  if f.surface=="floor" and w.at(Vector2i(f.x,f.y),int(r.depth))==0:floor_points+=FINISHES[f.kind].craft
  elif f.surface=="wall" and w.at(Vector2i(f.x,f.y),int(r.depth))!=0:wall_points+=FINISHES[f.kind].craft
  else:continue
  styles[f.kind]=true
 var craft=minf(3,floor_points/(r.w*r.h)*6)+minf(3,wall_points/4)
 var missing=[]
 var needs=["bench","anvil"] if r.id=="old_cutters" else FUNCTIONS[r.kind].needs
 for k in needs:
  if not counts.has(k):missing.append(FURNITURE[k].name)
 var clutter=maxi(0,furniture_count-int(r.w*r.h*.32))*5
 var score=clampi(int((minf(5,functionality)*8 if r.kind=="workshop" else minf(5,comfort)*10)+craft*5+minf(3,heritage)*4)-clutter,0,100)
 return {"score":score,"comfort":mini(comfort,5),"function":mini(functionality,5),"craft":craft,"heritage":mini(heritage,3),"clutter":clutter,"active":missing.is_empty() and access and connected(r),"missing":missing,"styles":styles}
func refresh():
 for r in data.rooms.values():r.metrics=quality(r)
func assign(npc:String,room_id:String)->String:
 if not s.outpost.get("crew",{}).has(npc):return "Recruit this Dwarf through your existing outpost first."
 if not data.rooms.has(room_id):return "Choose a room first."
 var r=data.rooms[room_id]
 if not r.metrics.active:return "Finish the room's required furnishings and accessible layout first."
 if not data.assignments.has(npc):data.assignments[npc]={"work":"","home":"","present":""}
 var field="work" if r.kind=="workshop" else "home"
 for id in data.assignments:
  if id!=npc and data.assignments[id].get(field,"")==room_id:return "This room already has an assigned Dwarf."
 data.assignments[npc][field]=room_id
 if not data.folk.has(npc):data.folk[npc]={"preference":{"style":"flags","interest":"A practical place to work and rest","drink":"malt"},"morale":0,"rested_until":0.0,"activity":"Finding a route"}
 return s.npc(npc).name+" assigned. Existing tunnels and stairs must connect the room."
func destination(npc:String)->Dictionary:
 if not data.assignments.has(npc):return {}
 var a=data.assignments[npc];var home_time=fmod(s.elapsed,120.0)>=90.0
 var id=a.home if home_time and a.home!="" else a.work
 return data.rooms.get(id,{})
func stand(r:Dictionary)->Vector2i:
 for f in data.furniture.values():
  if f.get("room","")!=r.id or f.kind!=("bench" if r.kind=="workshop" else "bed"):continue
  for d in Deepworks.DIRS:
   var c=Vector2i(f.x,f.y)+d
   if not at(c,int(r.depth)).is_empty() and w.walkable(c,int(r.depth)):return c
 return Vector2i(r.x,r.y)
func arrived(npc:String,r:Dictionary):
 var a=data.assignments[npc];a.present=r.id
 var folk=data.folk[npc];var q=r.metrics
 folk.activity="Shaping tools" if r.kind=="workshop" else "Resting in a proper berth"
 if r.kind=="bedroom" and q.active:folk.rested_until=s.elapsed+180
 var preferred=q.styles.has(folk.preference.style)
 folk.morale=mini(15,int(q.score/10)+(3 if preferred else 0)+(3 if folk.rested_until>s.elapsed else 0))
 if npc=="brann" and r.kind=="workshop" and q.active and q.score>=40 and data.opportunity=="":
  data.opportunity="offered";HoldOutpost.record(s,"living_offer","Brann has an idea for the workshop: A mark worth leaving.")
func opportunity_ready()->bool:
 if data.opportunity!="offered" or not data.assignments.has("brann"):return false
 var r=data.rooms.get(data.assignments.brann.work,{})
 if r.is_empty():return false
 var has_rune=false
 for f in data.furniture.values():
  if f.get("room","")==r.id and f.kind=="rune":has_rune=true
 return r.metrics.active and r.metrics.score>=55 and has_rune and r.metrics.craft>=2
func complete_opportunity()->bool:
 if not opportunity_ready():return false
 data.opportunity="complete";s.tech.ancestor_marks=true;s.add("parts",2)
 HoldOutpost.record(s,"living_complete","Brann cut the first Rivethand knot into the workshop. His pattern is now yours to use.")
 return true
static func production(state)->float:
 if not state.agents_enabled:return 1.0
 var best=0.0
 for site in state.deepworks.values():
  var works=site.get("living",{})
  for id in works.get("assignments",{}):
   if not state.outpost.get("crew",{}).has(id):continue
   if state.outpost.crew[id].role!="miner":continue
   var a=works.assignments[id];var r=works.rooms.get(a.get("present",""),{})
   if r.get("kind","")=="workshop" and r.get("metrics",{}).get("active",false):best=maxf(best,minf(.10,r.metrics.score*.001))
 return 1+best
func morale_bonus(npc:String)->float:
 return minf(.08,float(data.folk.get(npc,{}).get("morale",0))*.005)
