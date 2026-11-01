class_name HoldAncestralClaim
extends RefCounted
# Evidence and appointments live in the established outpost save, never in inventory counters.
static func data(s)->Dictionary:
 HoldOutpost.ensure(s)
 if not s.outpost.has("ancestral_claim"):
  s.outpost.ancestral_claim={"stage":0,"crew":[],"site":[],"archive":false,"family":false,"title":"","legacy":s.claim_id!=""}
 return s.outpost.ancestral_claim
static func active(g)->bool:return g.zone=="mine" and g.state.active_site=="hold" and g.deep.world.depth()==0
static func route(w,start:Vector2i,finish:Vector2i)->Array:
 var todo=[start];var from={Deepworks.key(start):start};var i=0
 while i<todo.size():
  var c:Vector2i=todo[i];i+=1
  if c==finish:
   var result=[c]
   while c!=start:c=from[Deepworks.key(c)];result.push_front(c)
   return result
  for d in Deepworks.DIRS:
   var n=c+d;var k=Deepworks.key(n)
   if not from.has(k) and w.walkable(n):from[k]=c;todo.append(n)
 return []
static func enter(g):
 var q=data(g.state)
 if not active(g) or q.stage!=1 or not q.site.is_empty():return
 var w=g.deep.world;var chosen=Vector2i(-1,-1)
 # Reuse existing geology. Never close old tunnels or overwrite a player's work.
 for f in w.layer().features:
  var center=Vector2i(int(f.x),int(f.y));var candidate=Vector2i(-1,-1)
  for dy in range(-3,4):
   for dx in range(-3,4):
    var c=center+Vector2i(dx,dy)
    if w.walkable(c) and w.walkable(c+Vector2i.RIGHT):candidate=c;break
   if candidate.x>=0:break
  if candidate.x<0:continue
  if chosen.x<0:chosen=candidate
  if route(w,candidate,Deepworks.ENTRY).is_empty():chosen=candidate;break
 if chosen.x<0:
  g.notify("Ivar is revising the rescue approach; no safe assembly point is available in this developed gallery.");return
 q.site=[chosen.x,chosen.y];var p=Deepworks.center(chosen)
 q.crew=[{"p":[p.x,p.y],"gait":0.0,"home":false},{"p":[p.x+40 if w.walkable(chosen+Vector2i.RIGHT) else p.x,p.y if w.walkable(chosen+Vector2i.RIGHT) else p.y+40],"gait":0.0,"home":false}]
 HoldMountain104.setup(g)
 g.save_game()
static func tick(g,dt:float):
 var q=data(g.state)
 if not active(g) or q.stage!=2 or g.panel_id!="":return
 for n in q.crew.size():
  var c=q.crew[n];c.walking=false
  if c.home:continue
  # Stagger departures so the two whole-character sprites do not overlap.
  if n>0 and not q.crew[n-1].home and Vector2(q.crew[n-1].p[0],q.crew[n-1].p[1]).distance_to(Deepworks.center(Vector2i(q.site[0],q.site[1])))<70:continue
  var p=Vector2(c.p[0],c.p[1]);var path=c.get("path",[])
  c.retry=maxf(0,float(c.get("retry",0))-dt)
  if path.is_empty():
   if c.retry>0:continue
   c.retry=1.0
   for cell in route(g.deep.world,Deepworks.cell(p),Deepworks.ENTRY):path.append([cell.x,cell.y])
   c.path=path
  if path.is_empty():continue
  var target=Deepworks.center(Vector2i(int(path[0][0]),int(path[0][1])))
  c.aim=[target.x-p.x,target.y-p.y]
  var next=p.move_toward(target,70*dt)
  if not g.deep.world.solid(next):c.walking=p.distance_to(next)>.01;c.gait+=HoldDrawnLocomotion.time_for_distance(p.distance_to(next));c.p=[next.x,next.y]
  else:c.path=[]
  if next.distance_to(target)<1 and not path.is_empty():path.pop_front()
  if next.distance_to(Deepworks.center(Deepworks.ENTRY))<8:c.home=true
 if q.crew.all(func(c):return c.home):
  q.stage=3;HoldOutpost.record(g.state,"crew_rescue","Sten and the survey crew returned through the opened gallery with an ancestral fragment." if HoldMountain104.active(g.state) else "Two trapped miners returned through the opened gallery. An old charter slab was recovered from their refuge.")
  g.notify("The crew is safe. Return to Ivar’s shift book for the gathering." if HoldMountain104.active(g.state) else "Both miners are safe. The slab bears your family mark. Take it to Eldric for examination.");g.save_game()
static func interact(g)->bool:
 var q=data(g.state)
 if not active(g) or q.stage!=1 or q.site.is_empty():return false
 var p=Deepworks.center(Vector2i(q.site[0],q.site[1]))
 if g.player.distance_to(p)>70 or not g.deep.world.visible(g.player,p):return false
 if route(g.deep.world,Deepworks.cell(p),Deepworks.ENTRY).is_empty():g.notify("The crew needs a continuous walkable route to the entrance. Clear the bypass first.");return true
 if HoldMountain104.active(g.state) and not HoldMountain104.safe(g):return true
 q.stage=2;g.save_game();g.notify("The miners are on their feet. Keep the route clear while they walk out; their recovered slab can wait.");return true
static func actors(g)->Array:
 var q=data(g.state);var out=[]
 if not active(g) or int(q.stage) not in [1,2]:return out
 for i in q.crew.size():
  var c=q.crew[i]
  if c.home:continue
  var p=Vector2(c.p[0],c.p[1])
  if not g.deep.world.layer().seen.has(Deepworks.key(Deepworks.cell(p))):continue
  out.append({"kind":"rescue_crew","p":p,"index":i})
 return out
static func draw(g,a:Dictionary,offset:Vector2):
 var q=data(g.state);var c=q.crew[a.index];var walk=bool(c.get("walking",false))
 var direction=c.get("aim",[0,1]);var aim=Vector2(direction[0],direction[1]).normalized() if walk else Vector2.DOWN
 HoldDrawnAnimation.paint(g,a.p+offset,HoldMountain104.profile(g,a.index),aim,walk,float(c.gait),.85,offset,"town_walk",1.0)
 g.draw_set_transform(offset)
 if q.stage==1 and g.player.distance_to(a.p)<70:HoldArt.text(g,a.p+Vector2(-4,-58),"E",14,Color("edc98a"))
static func eligible(s)->bool:
 if HoldMountain104.active(s):return HoldMountain104.eligible(s)
 return s.claim_id!="" or (s.opening>=2 and (not HoldOnboarding.ensure(s).fresh or HoldOnboarding.stage(s)>=6))
static func act(g,action:String)->bool:
 if HoldMountain104.active(g.state):return HoldMountain104.act(g,action)
 var s=g.state;var q=data(s);var done=false
 match action:
  "rescue":
   if q.stage==0 and eligible(s) and HoldConversation.local(g,"ivar"):q.stage=1;done=true
  "examine":
   if q.stage==3 and HoldConversation.local(g,"eldric"):q.stage=4;done=true
  "archive":
   if q.stage==4 and HoldConversation.local(g,"eirik"):q.archive=true;done=true
  "family":
   if q.stage==4 and HoldConversation.local(g,"ivar"):q.family=true;done=true
  "translate":
   if q.stage==4 and q.archive and q.family and HoldConversation.local(g,"eldric"):q.stage=5;done=true
  "appoint":
   if q.stage==5 and HoldConversation.local(g,"eirik"):
    if s.claim_id=="":s.claim_id="old_delving";s.camp_stage=1
    q.stage=6;q.title="Overseer";done=true
    HoldOutpost.record(s,"overseership","Lord Eirik recognized the ancestral charter and appointed "+s.appearance.name+" Overseer of "+HoldCampaign.claim(s.claim_id).name+". Existing property and Keldrath's communal stores remain separately owned.")
  "invest":
   if q.stage==6 and ready(s) and HoldConversation.local(g,"eirik"):
    q.stage=7;q.title="Thane";done=true
    HoldOutpost.record(s,"thane","Before the Oath Court, "+s.appearance.name+" was invested as Thane of "+HoldOutpost.title(s)+". The restored holding was recognized as a Highhold.")
 if done:g.talk_topic="ancestral";g.save_game();g.sound.effect("quest",-14);g.refresh_panel()
 return done
static func ready(s)->bool:
 HoldOutpost.ensure(s)
 return s.claim_id!="" and s.camp_stage>=3 and s.outpost.crew.size()>=2 and s.count("food")>=12 and s.count("water")>=12
static func description(s)->String:
 if HoldMountain104.active(s):return HoldMountain104.description(s)
 var q=data(s)
 match int(q.stage):
  0:return "Ivar may have work requiring judgment as well as strong hands after your first paid shift."
  1:
   return "Two miners are stranded beyond a fall in Old Workings. Enter depth 1, excavate a bypass to their refuge, then speak to them with E. There is no countdown. Keep a continuous walking route to the entrance."+(" Refuge survey: column %d, row %d (40-unit cells)." % [q.site[0],q.site[1]] if not q.site.is_empty() else "")
  2:return "The crew is walking to the entrance. Remain on depth 1 and keep the route clear. Their recovered charter slab can wait until both are safe."
  3:return "The rescued miners recovered an ancient slab bearing your family mark. Bring it to Eldric at the survey office. Its script and legal meaning remain unknown."
  4:return "Eldric has preserved a rubbing. The text appears to concern Old Delving, a nearby holding—not Keldrath. Ask Lord Eirik for an archive comparison and Ivar for your registered family record, then return to Eldric.\nArchive comparison: "+("obtained" if q.archive else "needed")+" · Family record: "+("obtained" if q.family else "needed")
  5:return "Eldric has matched the ancient script, charter seals and your family record. You descend from Old Delving's founding house. Its hereditary reclamation right survives. Petition Lord Eirik: your rescue earns backing for the claim, not ownership of Keldrath. An existing purchased holding will remain yours."
  6:return "You are Overseer of "+HoldCampaign.claim(s.claim_id).name+". Restore the workshop and freight beacon, recruit two Folk, and maintain at least 12 food and 12 water before petitioning for investiture as Thane. Supplies remain yours; inspection does not consume them.\nWorks: %d/3 · Folk: %d/2 · Food: %d/12 · Water: %d/12" % [s.camp_stage,s.outpost.get("crew",{}).size(),s.count("food"),s.count("water")]
 return "Thane "+s.appearance.name+" of "+HoldOutpost.title(s)+". Your holding is recognized as a Highhold. Your ancestry established the right; your work established its future. Keldrath's stores remain Keldrath's property."
static func journal(g):
 var q=data(g.state)
 if q.stage==0:return
 g.label(g.panel_body,"THE STONE REMEMBERS"+(" · "+q.title if q.title!="" else ""),18,Color("edc98a"))
 g.label(g.panel_body,description(g.state),15)
static func marker(s,id:String)->String:
 if HoldMountain104.active(s):return ""
 var q=data(s)
 if id=="ivar":
  if q.stage==0 and eligible(s):return "offer"
  if q.stage==4 and not q.family:return "ready"
 if id=="eldric":
  if q.stage==3 or (q.stage==4 and q.archive and q.family):return "ready"
 if id=="eirik":
  if (q.stage==4 and not q.archive) or q.stage==5 or (q.stage==6 and ready(s)):return "ready"
 return ""

static func options(g,id:String):
 var q=data(g.state)
 var choices=[]
 if id=="ivar":
  if q.stage==0 and eligible(g.state):choices.append(["A crew is missing? I will help open a way out.","rescue"])
  if q.stage==4 and not q.family:choices.append(["Compare my family registration with the tablet's mark","family"])
 if id=="eldric":
  if q.stage==3:choices.append(["Examine the ancient slab recovered during the rescue","examine"])
  if q.stage==4 and q.archive and q.family:choices.append(["Decipher and authenticate the ancestral charter","translate"])
 if id=="eirik":
  if q.stage==4 and not q.archive:choices.append(["Request the old charter register for Eldric's research","archive"])
  if q.stage==5:choices.append(["Accept appointment as Overseer of my holding","appoint"])
  if q.stage==6 and ready(g.state):choices.append(["Present the restored holding for investiture as Thane","invest"])
 if q.stage>0 and id in ["ivar","eldric","eirik"]:g.label(g.panel_body,description(g.state),15)
 for choice in choices:
  var action=str(choice[1]);HoldConversation.choose(g,choice[0],func():act(g,action),true)
