class_name HoldWorkplace98
extends RefCounted
# One persistent place, backed by ordinary terrain, furniture and Handworks cargo.
static func seed(world:Dictionary):
 var x=4+posmod(int(world.seed),3);var y=17+posmod(int(world.seed),2)
 var l=world.layers[0]
 for yy in range(y,y+7):
  for xx in range(x,x+8):l.cells[yy*Deepworks.W+xx]=0
 for yy in range(13,y):l.cells[yy*Deepworks.W+8]=2 if yy in [13,14] else 0
 world.workplace98={"x":x,"y":y,"found":false,"installed":false,"warm_until":0.0,"cuts":0,"person":{},"status":"Abandoned","retry":0.0}
 world.living={"version":1,"next_id":1,"rooms":{},"furniture":{},"surfaces":{},"assignments":{},"folk":{},"opportunity":""}
 var room={"id":"old_cutters","kind":"workshop","depth":0,"x":x,"y":y,"w":8,"h":7,"name":"The old cutters' bay","metrics":{}}
 world.workplace98.room=room
 for entry in [["table",Vector2i(x+1,y+1)],["bench",Vector2i(x+3,y+1)],["shelf",Vector2i(x+6,y+2)]]:
  var c:Vector2i=entry[1];var key="0:"+Deepworks.key(c)
  world.living.furniture[key]={"kind":entry[0],"x":c.x,"y":c.y,"depth":0,"room":room.id,"solid":true,"paid":{}}
 var tally=Vector2i(10,y)
 world.living.furniture["0:"+Deepworks.key(tally)]={"kind":"shelf","x":tally.x,"y":tally.y,"depth":0,"room":room.id,"solid":true,"paid":{},"tally":true}
 for yy in range(y,y+7):
  for xx in range(x,x+8):
   if posmod(xx*7+yy*11+int(world.seed),5)==0:continue
   var c=Vector2i(xx,yy)
   world.living.surfaces["0:"+Deepworks.key(c)]={"kind":"ashlar","x":xx,"y":yy,"depth":0,"room":room.id,"surface":"floor","paid":{}}
static func data(g)->Dictionary:
 if g.deep.world==null:return {}
 return g.deep.world.data.get("workplace98",{})
static func active(g)->bool:return g.zone=="mine" and g.deep.world!=null and g.deep.world.depth()==0 and not data(g).is_empty()
static func hearth(q:Dictionary)->Vector2i:return Vector2i(int(q.x)+5,int(q.y)+1)
static func warm(g)->bool:
 var q=data(g)
 if q.is_empty():return false
 var f=g.deep.works.model.data.furniture.get(g.deep.world.link_key(hearth(q),0),{})
 return f.get("kind","")=="anvil" and float(q.warm_until)>g.state.elapsed
static func station(g,suffix:String)->Dictionary:
 for f in g.handworks.data().facilities:
  if f.id=="workplace98:"+suffix and f.area=="mine:hold:0":return f
 return {}
static func enter(g):
 if not active(g):return
 var q=data(g)
 HoldWholeFrames.prepare_profile(profile())
 if q.installed:return
 for spec in [["bench","breaker",Vector2i(int(q.x)+2,int(q.y)+4)],["rack","stone_pile",Vector2i(int(q.x)+5,int(q.y)+5)]]:
  var p=Deepworks.center(spec[2])
  g.handworks.data().facilities.append({"id":"workplace98:"+spec[0],"kind":spec[1],"area":"mine:hold:0","x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false,"fixed":true,"owner":"loan","concealed":true})
 q.installed=true;g.deep.works.model.refresh()
static func profile()->Dictionary:
 var p=HoldAppearance.defaults();p.first_name="Odrin";p.family_name="Slatehand";p.name="Odrin Slatehand";p.sculpt=3;p.hair_color=5;p.beard_color=5;p.cloth_color=3
 return p
static func position(q:Dictionary)->Vector2:return Vector2(q.person.p[0],q.person.p[1])
static func path(g,a:Vector2,b:Vector2)->Array:
 if g.deep.world.solid(a) or g.deep.world.solid(b):return []
 return HoldAncestralClaim.route(g.deep.world,Deepworks.cell(a),Deepworks.cell(b))
static func work_position(g)->Vector2:
 var f=station(g,"bench")
 return g.handworks.pos(f)+Vector2(-56,-55) if not f.is_empty() else Vector2.INF
static func working_minutes(t:float)->float:
 var day=floor(t/1440.0);var minute=fposmod(t,1440.0)
 return day*540+clampf(minute-480,0,240)+clampf(minute-780,0,300)
static func finish_job(g,bench:Dictionary):
 var q=data(g);var raw=bench.job.raw;var item=HoldHandworks.raw_item(raw)
 bench.cargo[item]=int(bench.cargo.get(item,0))+int(raw.units);q.cuts=int(q.cuts)+int(raw.units);bench.job={}
static func catch_up(g):
 var q=data(g);var calendar=HoldCalendar.data(g.state);var now=float(calendar.day)*1440+float(calendar.minute)
 var last=float(q.get("last_elapsed",g.state.elapsed));var then=float(q.get("last_calendar",now))
 var gap=g.state.elapsed-last;var changed=false
 if gap>2 and not q.person.is_empty() and position(q).distance_to(work_position(g))<4 and q.status in ["Cutting stone","Waiting for a stone load","Waiting for the finished stock to be collected"] and not path(g,Deepworks.center(Deepworks.ENTRY),work_position(g)).is_empty() and g.deep.works.model.data.furniture.get(g.deep.world.link_key(hearth(q),0),{}).get("kind","")=="anvil":
  var end=minf(now,then+maxf(0,float(q.warm_until)-last)*.6)
  var seconds=minf(gap,maxf(0,working_minutes(end)-working_minutes(then))/.6)
  var bench=station(g,"bench");var rack=station(g,"rack")
  if not bench.is_empty() and not rack.is_empty():
   # Bounded by actual rack ownership and finished-stock capacity, never free production.
   for job in range(rack.raw.size()+1):
    if seconds<=0:break
    if bench.job.is_empty():
     if rack.raw.is_empty() or DeepHaul.amount(bench.cargo)>=40:break
     bench.job={"raw":rack.raw.pop_front(),"progress":0.0}
    var used=minf(seconds,maxf(0,1.26-float(bench.job.progress))/.21)
    bench.job.progress=float(bench.job.progress)+used*.21;seconds-=used;changed=changed or used>0
    if float(bench.job.progress)>=1.2599:finish_job(g,bench)
 q.last_elapsed=g.state.elapsed;q.last_calendar=now
 if changed:g.save_game()
static func tick(g,dt:float):
 if not active(g) or g.panel_id!="":return
 var q=data(g);var w=g.deep.world
 if not q.found and Rect2(Vector2(q.x,q.y)*40,Vector2(320,280)).has_point(g.player):
  if q.has("room"):
   g.deep.works.model.data.rooms[q.room.id]=q.room;q.erase("room");g.deep.works.model.refresh()
  q.found=true;g.notify("Cut stone under the dust. A collapsed supply passage left this bay and its hearth cold.");g.save_game()
 if not q.found:return
 catch_up(g)
 var minute=float(HoldCalendar.data(g.state).minute);var shift=minute>=480 and minute<1080
 var working_hour=shift and not (minute>=720 and minute<780)
 var entry=Deepworks.center(Deepworks.ENTRY);var workplace=work_position(g)
 q.access_retry=maxf(0,float(q.get("access_retry",0))-dt)
 if float(q.access_retry)<=0:
  q.access_retry=1.0;q.route_open=workplace!=Vector2.INF and not path(g,entry,workplace).is_empty()
 var usable=warm(g) and workplace!=Vector2.INF and not w.solid(workplace) and bool(q.get("route_open",false))
 q.retry=maxf(0,float(q.retry)-dt)
 if q.person.is_empty():
  if not usable or not shift or q.retry>0:return
  q.retry=2.0
  if path(g,entry,workplace).is_empty():q.status="The supply passage is still blocked";return
  q.person={"p":[entry.x,entry.y],"gait":0.0,"walking":false,"direction":[0.0,1.0],"route":[],"target":[],"work":false}
  g.save_game()
 var person=q.person;person.work=false;person.walking=false
 var player_working=g.handworks.active_id=="workplace98:bench" and (g.handworks.working or g.handworks.approaching)
 var target=workplace if usable and working_hour and not player_working else Deepworks.center(hearth(q)+Vector2i(0,1)) if usable and shift else entry
 var p=position(q)
 if p.distance_to(target)>3:
  q.status="Making room for you" if player_working else "Coming to work" if usable and working_hour else "Taking a hearth break" if usable and shift else "Heading home"
  if person.target!=[target.x,target.y] or (person.route.is_empty() and q.retry<=0):
   person.route=[];person.target=[target.x,target.y];q.retry=1.0
   for c in path(g,p,target):person.route.append([c.x,c.y])
   if not person.route.is_empty():person.route.pop_front()
  var next=target
  if not person.route.is_empty():next=Deepworks.center(Vector2i(person.route[0][0],person.route[0][1]))
  if not g.handworks.stance_clear(p,next):person.route=[];q.status="Waiting for the passage to clear";return
  var moved=p.move_toward(next,65*dt);person.direction=[next.x-p.x,next.y-p.y];person.walking=true;person.gait=float(person.gait)+HoldDrawnLocomotion.time_for_distance(p.distance_to(moved));person.p=[moved.x,moved.y]
  if moved.distance_to(next)<1 and not person.route.is_empty():person.route.pop_front()
  return
 if target==entry:q.person={};g.save_game();return
 if not working_hour:q.status="Warming his hands";return
 var bench=station(g,"bench");var rack=station(g,"rack")
 if bench.is_empty() or rack.is_empty():q.status="The old equipment is missing";return
 if player_working:q.status="Making room for you";return
 if bench.job.is_empty():
  if rack.raw.is_empty():q.status="Waiting for a stone load";return
  if DeepHaul.amount(bench.cargo)>=40:q.status="Waiting for the finished stock to be collected";return
  bench.job={"raw":rack.raw.pop_front(),"progress":0.0};g.save_game()
 q.status="Cutting stone";person.work=true
 bench.job.progress=float(bench.job.progress)+dt*.21
 if float(bench.job.progress)>=1.26:
  finish_job(g,bench);g.save_game()
static func near_hearth(g)->bool:
 return active(g) and g.player.distance_to(Deepworks.center(hearth(data(g))))<75
static func prompt(g)->String:
 if not active(g) or not data(g).found:return ""
 var q=data(g)
 if not q.person.is_empty() and g.player.distance_to(position(q))<60:return "E · Speak to Odrin · "+str(q.status)
 if near_hearth(g):return "Old hearth · E inspect / add one coal"+(" · Warm" if warm(g) else " · Cold")
 var tally=Vector2i(10,int(q.y))
 if g.deep.works.model.data.furniture.get(g.deep.world.link_key(tally,0),{}).get("tally",false) and g.player.distance_to(Deepworks.center(tally))<60:return "E · Read the cutters' tally"
 return ""
static func interact(g)->bool:
 if prompt(g)=="":return false
 var q=data(g)
 if not q.person.is_empty() and g.player.distance_to(position(q))<60:
  var line="My father cut the lift footings here. After the fall, there was no way to bring a load through. I kept his tally stick."
  if q.status=="Waiting for a stone load":line="Leave a raw load in the rack and I'll dress it. The finished stock stays on the bench for you."
  elif q.status=="Waiting for the passage to clear":line="That passage won't take a dwarf and a load now. I'll wait here until it's clear."
  elif not warm(g):line="The hearth's gone cold. I'll head back up if the passage is clear."
  elif int(q.cuts)>0:line="%d pieces cut here since you opened the passage. Father would have liked hearing that hammer again." % int(q.cuts)
  g.notify("Odrin: "+line);g.notice_time=9;return true
 if near_hearth(g):
  var f=g.deep.works.model.data.furniture.get(g.deep.world.link_key(hearth(q),0),{})
  if f.get("kind","")!="anvil":
   g.notify("The hearth bed survives. Install a forge hearth here with O → Furnish, then bring coal. Odrin's old bay needs a clear supply route.");g.notice_time=10
  elif warm(g):g.notify("The hearth is warm. Save your coal until it burns low.")
  elif g.state.pay({"coal":1}):q.warm_until=g.state.elapsed+1800;g.save_game();g.notify("The hearth catches. Warmth returns to the cutters' bay.")
  else:g.notify("Bring one coal to light the repaired hearth.")
  return true
 g.notify("Last tally: lift footings, west seam. 'Fall in the supply passage. Take the men out. Leave the benches. — Slatehand'\nThe bench and rack still work. A hearth and an open route would make the bay usable again.");g.notice_time=12;return true
static func is_working(g,id:String)->bool:
 return id=="workplace98:bench" and active(g) and not data(g).person.is_empty() and bool(data(g).person.work)
static func actors(g)->Array:
 if not active(g) or data(g).person.is_empty():return []
 return [{"p":position(data(g)),"kind":"workplace98"}]
static func draw_person(g,o:Dictionary,offset:Vector2):
 var q=data(g);var p=q.person;var direction=Vector2(p.direction[0],p.direction[1])
 if p.work:direction=Vector2(1,.45)
 var phase=fposmod(float(station(g,"bench").job.get("progress",0)),.42)/.42
 HoldDrawnAnimation.paint(g,o.p+Vector2(0,12)+offset,profile(),direction,bool(p.walking),float(p.gait),1.0,offset,"hammer" if p.work else "town_walk",phase)
 g.draw_set_transform(offset)
 if p.work:HoldDrawnAnimation.work_foreground(g,o.p+Vector2(0,12),profile(),direction,1.0,offset,"hammer",phase)
 if g.player.distance_to(o.p)<120:HoldArt.text(g,o.p+Vector2(-20,-80),"Odrin",10,Color("dfc695"))
static func props(g)->Array:
 if not active(g):return []
 var q=data(g);var c=hearth(q)
 if not g.deep.world.layer().seen.has(Deepworks.key(c)):return []
 return [{"p":Deepworks.center(c),"hot":warm(g),"repaired":g.deep.works.model.data.furniture.get(g.deep.world.link_key(c,0),{}).get("kind","")=="anvil"}]
static func draw_furniture(n:Node2D,f:Dictionary,p:Vector2):
 if f.get("tally",false):HoldFurnishings.draw(n,p+Vector2(0,8),"signpost",Color(.8,.75,.65));return
 if f.kind=="anvil":return # The hearth uses the same saved fuel state in both views.
 var kind={"table":"hearth_table","bench":"table","shelf":"bookcase"}.get(f.kind,"")
 if kind!="":HoldFurnishings.draw(n,p+Vector2(0,12),kind,Color(.75,.72,.67))
static func draw_prop(n:Node2D,o:Dictionary):
 var anchor=o.p+Vector2(0,12)
 if not o.repaired:
  HoldFurnishings.draw(n,anchor,"plinth",Color(.62,.61,.58))
  n.draw_line(o.p+Vector2(-12,-9),o.p+Vector2(1,-3),Color("30353a"),2)
  n.draw_line(o.p+Vector2(1,-3),o.p+Vector2(-5,2),Color("30353a"),2)
 elif o.hot:
  n.draw_texture_rect(HoldAmbientProps.glow_texture(),Rect2(o.p-Vector2(65,48),Vector2(130,90)),false)
  var transform=Transform2D(0,Vector2(.667,.667),0,anchor)
  var clock=n.get("clock")
  n.draw_mesh(HoldAmbientProps.hearth_mesh(float(clock) if clock!=null else 0.0),HoldFurnishings.ATLAS,transform)
 else:
  n.draw_texture_rect_region(HoldFurnishings.ATLAS,Rect2(anchor-Vector2(24,50.67),Vector2(48,50.67)),HoldFurnishings.CROPS[7],Color(.58,.62,.66))
  n.draw_rect(Rect2(anchor+Vector2(-8,-20),Vector2(16,8)),Color("272d32"))
