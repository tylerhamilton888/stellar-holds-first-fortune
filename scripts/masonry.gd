class_name HoldMasonry
extends RefCounted
# Site-local work orders; material ownership stays in DeepHaul containers.
var g
var w:Deepworks
var works:LivingWorks
var data:Dictionary
var flash=0.0
var flash_pos=Vector2.ZERO
var transfer_from=Vector2.ZERO
var transfer_to=Vector2.ZERO
var transfer_time=0.0
func _init(game,world:Deepworks,model:LivingWorks):
 g=game;w=world;works=model
 if not works.data.has("masonry"):works.data.masonry={"cuts":{},"bench_work":{},"facts":{},"jobs":{},"rewarded":false}
 data=works.data.masonry
func fact(id:String):data.facts[id]=true
func has(id:String)->bool:return bool(data.facts.get(id,false))
func bench(c:Vector2i,z:int=-1)->Dictionary:
 var f=works.data.furniture.get(w.link_key(c,w.depth() if z<0 else z),{})
 return f if f.get("kind","")=="mason" else {}
func stand(f:Dictionary)->Vector2i:
 for d in [Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP]:
  var c=Vector2i(f.x,f.y)+d
  if w.walkable(c,int(f.depth)):return c
 return Vector2i(-1,-1)
func supply(f:Dictionary,require_raw:bool=true)->Dictionary:
 var st=stand(f)
 if st.x<0:return {}
 for p in g.deep.haul.data.piles.values():
  if not p.marked or int(p.depth)!=int(f.depth):continue
  var c=Vector2i(p.x,p.y)
  if c.distance_to(Vector2i(f.x,f.y))>3 or (require_raw and int(p.cargo.get("rough_block",0))<=0):continue
  if w.walkable(c,int(f.depth)) and not w.route(st,int(f.depth),"",c).is_empty():return p
 return {}
func quarry(c:Vector2i)->String:
 var k=w.at(c)
 if k not in [2,7]:return "Choose ordinary stone or basalt, not ore, soil or finished floor."
 if k==7 and not g.state.steel:return "Basalt needs a forged steel pick before it can be quarried."
 var id=w.link_key(c,w.depth());data.cuts[id]=int(data.cuts.get(id,0))+1
 flash=.35;flash_pos=Deepworks.center(c)
 if int(data.cuts[id])<3:return "Chisel line %d / 3 · keep holding." % data.cuts[id]
 data.cuts.erase(id);w.set_cell(c,0);w.layer().damage.erase(Deepworks.key(c));g.state.mined+=1
 g.deep.haul.collect("rough_block",1,g.player);fact("extract")
 transfer_from=Deepworks.center(c);transfer_to=g.player;transfer_time=.45
 works.refresh();return "One sound block freed. O → Masonry: cache it beside your mason's bench."
func cache()->String:
 var c=Deepworks.cell(g.player)
 if not w.walkable(c):return "Stand on clear floor to mark a stockpile."
 var p=g.deep.haul.pile(c,true);var moved=0
 var containers=[g.deep.haul.bucket(),g.state.inventory]
 if g.deep.haul.near_cart(g.player):containers.append(g.deep.haul.cart().cargo)
 for cargo in containers:
  for item in ["rough_block","dressed_stone"]:
   var n=int(cargo.get(item,0))
   if n>0:p.cargo[item]=int(p.cargo.get(item,0))+n;cargo.erase(item);moved+=n
 if int(p.cargo.get("rough_block",0))>0:fact("stockpile")
 transfer_from=g.player+Vector2(0,-24);transfer_to=Deepworks.center(c)+Vector2(16,12);transfer_time=.45
 return "Marked masonry stockpile · %d units set down. Keep it within three tiles of the bench with a clear path." % moved
func observe():
 for p in g.deep.haul.data.piles.values():
  if p.marked and int(p.cargo.get("rough_block",0))>0:fact("stockpile")
 for f in works.data.surfaces.values():
  if f.kind=="ashlar":fact("build")
func dress(c:Vector2i,crush:bool=false)->String:
 var f=bench(c)
 if f.is_empty():return "Aim at your mason's bench. Place one through O → Masonry."
 for job in data.jobs.values():
  if job.bench==w.link_key(c,w.depth()):return "Your mason is using this bench. Release the assignment first."
 var p=supply(f)
 if p.is_empty():return "Cache a rough block in a marked stockpile within three tiles, with a clear walking route."
 var id=w.link_key(c,w.depth());var mode="stone" if crush else "dressed_stone"
 var job=data.bench_work.get(id,{"hits":0,"out":mode})
 if job.out!=mode:job={"hits":0,"out":mode}
 job.hits+=1;data.bench_work[id]=job;flash=.35;flash_pos=Deepworks.center(c)+Vector2(0,17)
 if job.hits<3:return "Squaring the block · %d / 3 · keep holding." % job.hits
 data.bench_work.erase(id)
 p.cargo.rough_block-=1
 if p.cargo.rough_block==0:p.cargo.erase("rough_block")
 var n=4 if crush else (3 if g.state.tech.has("fine_masonry") else 2)
 p.cargo[mode]=int(p.cargo.get(mode,0))+n
 if not crush:fact("dress")
 transfer_from=Deepworks.center(c);transfer_to=Deepworks.center(Vector2i(p.x,p.y));transfer_time=.45
 return "%d %s placed in the stockpile. Shift+U loads it; U at the entrance delivers it." % [n,HoldData.ITEMS[mode].name]
func claim()->bool:
 observe()
 if data.rewarded or not (has("extract") and has("stockpile") and has("dress") and has("build")):return false
 data.rewarded=true;g.state.tech.masonry_apprentice=true;g.state.add("parts",1)
 HoldOutpost.record(g.state,"masonry_apprentice","A sound block became a finished floor. Brann approved the work and taught the mason's handover.")
 return true
func release(id:String):
 if not data.jobs.has(id):return
 var job=data.jobs[id]
 if not job.get("cargo",{}).is_empty():
  var p=g.deep.haul.data.piles.get(job.get("pile",""),{})
  if p.is_empty():
   var f=works.data.furniture.get(job.bench,{"x":Deepworks.ENTRY.x,"y":Deepworks.ENTRY.y,"depth":0})
   var key=w.link_key(Vector2i(f.x,f.y),int(f.depth))
   g.deep.haul.data.piles[key]={"x":f.x,"y":f.y,"depth":f.depth,"cargo":{},"marked":true};p=g.deep.haul.data.piles[key]
  DeepHaul.transfer(job.cargo,p.cargo)
 data.jobs.erase(id)
func assign(id:String,f:Dictionary)->String:
 if not g.state.tech.has("masonry_apprentice"):return "Finish Brann's first stonework lesson before delegating."
 if not g.state.outpost.get("crew",{}).has(id):return "Recruit this Dwarf at your claimed mountain first."
 var room=works.data.rooms.get(f.room,{})
 if room.is_empty() or room.kind!="workshop" or not room.metrics.active:return "Your mason needs a functional workshop: joiner's bench, forge/anvil and lantern."
 for other in data.jobs:
  if other!=id and data.jobs[other].bench==w.link_key(Vector2i(f.x,f.y),int(f.depth)):return "This bench already has a mason."
 var result=works.assign(id,room.id)
 if works.data.assignments.get(id,{}).get("work","")!=room.id:return result
 release(id)
 data.jobs[id]={"bench":w.link_key(Vector2i(f.x,f.y),int(f.depth)),"phase":"fetch","cargo":{},"pile":"","time":0.0}
 return g.state.npc(id).first_name+" will fetch, dress and return stone through the nearby stockpile."
func worker(a:Dictionary,dt:float)->bool:
 if not data.jobs.has(a.id):return false
 var job=data.jobs[a.id];var f=works.data.furniture.get(job.bench,{})
 if f.is_empty():release(a.id);return false
 var room=works.data.rooms[f.room]
 if works.data.assignments.get(a.id,{}).get("work","")!=room.id:release(a.id);return false
 if not room.metrics.active:a.status="Workshop needs furnishings";return true
 var saved=g.deep.crew_entry(a);var z=int(saved.depth)
 if z!=int(f.depth):return false # existing inter-level routing reaches the workshop
 var p=g.deep.haul.data.piles.get(job.pile,{})
 if job.phase=="fetch":
  p=supply(f)
  if p.is_empty():a.status="Mason: needs nearby stocked pile";works.data.folk[a.id].activity=a.status;return true
  job.pile=w.link_key(Vector2i(p.x,p.y),z)
 var dest=Vector2i(p.x,p.y) if job.phase in ["fetch","return"] and not p.is_empty() else stand(f)
 if dest.x<0:a.status="Mason's bench blocked";return true
 if Deepworks.cell(a.p)!=dest:
  var route=w.route(Deepworks.cell(a.p),z,"",dest)
  if route.is_empty():a.status="Mason: route blocked";return true
  a.path=route.path;return true
 works.arrived(a.id,room)
 if job.phase=="fetch":
  if int(p.cargo.get("rough_block",0))<=0:return true
  p.cargo.rough_block-=1
  if p.cargo.rough_block==0:p.cargo.erase("rough_block")
  job.cargo={"rough_block":1};job.phase="dress";job.time=0.0;works.data.folk[a.id].activity="Carrying a sound block"
 elif job.phase=="dress":
  a.work=true;job.time+=dt;a.status="Dressing a sound block";works.data.folk[a.id].activity=a.status
  if a.cool<=0:
   a.cool=.55
   if z==w.depth() and g.zone=="mine":g.sound.effect("stone",-26);flash=.35;flash_pos=Deepworks.center(Vector2i(f.x,f.y))+Vector2(0,17)
  if job.time>=2.0:
   job.cargo={"dressed_stone":3 if g.state.tech.has("fine_masonry") else 2};job.phase="return";works.data.folk[a.id].activity="Carrying dressed stone"
 elif job.phase=="return":
  if p.is_empty():a.status="Stockpile missing";return true
  DeepHaul.transfer(job.cargo,p.cargo);job.phase="fetch";a.fuel=maxi(0,a.fuel-1);fact("delegate");works.data.folk[a.id].activity="Stacking finished stone"
 return true
func panel():
 observe();g.label(g.panel_body,"BRANN · A sound block, a lasting floor",19,Color("edc98a"))
 var goals=[["extract","1 · Quarry one sound block: choose Chisel, aim at stone, hold LMB."],["stockpile","2 · Rooms: mark 4×4 clear floor. Place a mason’s bench; cache beside it."],["dress","3 · Dress the block at the bench. Output goes to the same pile."],["build","4 · Load with Shift+U, deliver with U at the entrance, lay one dressed floor tile."]]
 for goal in goals:g.label(g.panel_body,("✓ " if has(goal[0]) else "○ ")+goal[1],14)
 var row=g.row(g.panel_body)
 g.small_button(row,"Chisel sound blocks",func():g.deep.works.choose("quarry","rough_block"))
 g.small_button(row,"Place mason's bench · 3 timber + 2 stone",func():g.deep.works.choose("furniture","mason"))
 row=g.row(g.panel_body)
 g.small_button(row,"Cache masonry here",func():g.notify(cache());g.save_game();g.close_panel())
 g.small_button(row,"Dress blocks",func():g.deep.works.choose("dress","dressed_stone"))
 g.small_button(row,"Break into 4 ordinary stone",func():g.deep.works.choose("dress","stone"))
 g.small_button(g.panel_body,"Lay dressed floor · 1 delivered dressed stone",func():g.deep.works.choose("finish","ashlar"))
 if not data.rewarded:
  var b=g.small_button(g.panel_body,"Complete Brann’s lesson · mason delegation + 1 machine part",func():
   if claim():g.sound.effect("quest");g.notify("A floor worth leaving to your Folk. Mason delegation learned.");g.save_game()
   g.open_panel("living",false))
  b.disabled=not (has("extract") and has("stockpile") and has("dress") and has("build"))
 else:g.label(g.panel_body,"Brann: 'Sound work. Give a recruited Dwarf a proper workshop and let him carry it on.'"+(" Handover proven." if has("delegate") else " Next: assign a mason and watch one block return as dressed stone."),14)
 for f in works.data.furniture.values():
  if not g.state.tech.has("masonry_apprentice") or f.kind!="mason" or int(f.depth)!=w.depth():continue
  for a in g.agents:
   if a.type!="worker":continue
   var id=str(a.id);var fixture=f
   g.small_button(g.panel_body,"Assign "+g.state.npc(id).first_name+" → bench ("+str(f.x)+", "+str(f.y)+")",func():g.notify(assign(id,fixture));g.save_game();g.open_panel("living",false))
 for id in data.jobs:
  var who=str(id)
  g.small_button(g.panel_body,"Release mason "+g.state.npc(who).first_name+" · return carried materials",func():release(who);g.save_game();g.open_panel("living",false))
 g.label(g.panel_body,"No stamina or timing test. Three quick contacts dress 1 block into 2 dressed stone (3 with Fine Masonry). Ordinary stone remains valid for basic construction. Masonry uses real marked piles, not remote stores.",13)
func tick(dt:float):flash=maxf(0,flash-dt);transfer_time=maxf(0,transfer_time-dt)
static func block(n:CanvasItem,p:Vector2,finished:bool=false,scale:float=1):
 n.draw_colored_polygon(PackedVector2Array([p+Vector2(-15,7)*scale,p+Vector2(-17,-7)*scale,p+Vector2(-7,-14)*scale,p+Vector2(14,-10)*scale,p+Vector2(18,5)*scale,p+Vector2(5,12)*scale]),Color("8e9f9e"))
 n.draw_line(p+Vector2(-14,-6)*scale,p+Vector2(12,-9)*scale,Color("d0d7ba"),2*scale)
 if finished:n.draw_rect(Rect2(p-Vector2(14,9)*scale,Vector2(28,18)*scale),Color("abb7a5"));n.draw_line(p+Vector2(-12,-7)*scale,p+Vector2(12,-7)*scale,Color("e5d9b2"),2*scale)
 else:n.draw_polyline(PackedVector2Array([p+Vector2(-6,-8)*scale,p+Vector2(-2,-1)*scale,p+Vector2(-6,5)*scale]),Color("4b6069"),2*scale)
func draw():
 for key in data.cuts:
  var bits=key.split(":")
  if int(bits[0])!=w.depth():continue
  var xy=bits[1].split(",");var c=Vector2i(int(xy[0]),int(xy[1]))
  if w.at(c)==0:continue
  var p=Deepworks.center(c)
  g.draw_rect(Rect2(p-Vector2(13,13),Vector2(26,26)),Color("ddc695"),false,1)
  for j in int(data.cuts[key])+1:g.draw_line(p+Vector2(-10+j*7,-12),p+Vector2(-12+j*7,12),Color("243a43"),2)
 if flash>0:
  for j in 8:
   var p=flash_pos+Vector2.from_angle(j*.8)*((.35-flash)*90+8)
   g.draw_rect(Rect2(p,Vector2(3,2)),Color(.8,.82,.67,flash*2))
 if transfer_time>0:block(g,transfer_from.lerp(transfer_to,1-transfer_time/.45)+Vector2(0,-sin(transfer_time/.45*PI)*20),false,.65)
func carry(p:Vector2,face:int,cargo:Dictionary):
 if int(cargo.get("rough_block",0))+int(cargo.get("dressed_stone",0))<=0:return
 var at=p+Vector2(face*9,-25+sin(g.gait_clock*9)*1.2)
 block(g,at,int(cargo.get("rough_block",0))==0,.8)
 # Both hands visibly support the load; existing legs retain their walking cycle.
 for x in [-12,12]:
  g.draw_line(p+Vector2(x,-35),at+Vector2(x*.8,3),Color("497674"),6)
  g.draw_circle(at+Vector2(x*.8,3),3.5,Color("e5b87e"))
func chisel(p:Vector2,tip:Vector2=Vector2.INF):
 var contact=g.deep.contact if tip==Vector2.INF else tip
 g.draw_line(contact,contact+Vector2(8,11),Color("d8e0cf"),3)
 g.draw_circle(contact+Vector2(4,6),3.5,Color("e4b57e"))
 g.draw_line(p+Vector2(-8,-35),contact+Vector2(4,6),Color("477b78"),5)

func foreground():
 # Bring the bench between the worker and camera; hands and tools sit above its top.
 for f in works.data.furniture.values():
  if f.kind!="mason" or int(f.depth)!=w.depth():continue
  var point=Deepworks.center(Vector2i(f.x,f.y))
  var actors=[]
  if g.deep.works.mode=="dress" and g.deep.strike_left>0 and g.deep.target==Vector2i(f.x,f.y):actors.append({"p":g.player,"face":g.face,"profile":g.state.appearance,"phase":1-g.deep.strike_left/g.deep.swing_duration})
  for a in g.agents:
   if a.work and data.jobs.get(a.id,{}).get("bench","")==w.link_key(Vector2i(f.x,f.y),w.depth()):actors.append({"p":a.p,"face":1,"profile":g.state.npc(a.id),"phase":fmod(g.clock,.55)/.55})
  if actors.is_empty():continue
  g.deep.works.draw_furniture("mason",point)
  for a in actors:
   var contact=point+Vector2(0,17)
   var hand=a.p+Vector2(a.face*12,-40)
   var head=contact+Vector2(a.face*7,-absf(cos(a.phase*PI))*22)
   chisel(a.p,contact)
   g.draw_line(a.p+Vector2(a.face*7,-44),hand,Color("477b78"),7)
   HoldCharacterArt.draw_tool(g,hand-g.camera,head-g.camera,3,-g.camera,a.face,-1,1.0)
   g.draw_circle(hand,4,Color("e5b87e"))
