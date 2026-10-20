class_name HoldClaimStories
extends RefCounted
const TITLES={"supper":"A place at the table","seam":"A seam worth keeping","workshop":"The sound of a good workshop","freight":"An address worth remembering"}
static func ensure(s)->Dictionary:
 HoldOutpost.ensure(s)
 if not s.outpost.has("claim_stories"):s.outpost.claim_stories={"version":1,"claims":{}}
 var all=s.outpost.claim_stories.claims
 var key=str(s.seed_value)+"/"+s.claim_id
 if not all.has(key):all[key]={"active":{},"done":{},"trust":{},"features":{},"discovery":{},"markers":[],"next_at":0.0,"next_check":0.0}
 return all[key]
static func actor(s,roles:Array=[])->String:
 var eligible=[]
 for id in s.outpost.crew:
  if roles.is_empty() or s.outpost.crew[id].role in roles:eligible.append(id)
 if eligible.is_empty():return ""
 eligible.sort()
 return eligible[posmod(s.seed_value+s.contract,eligible.size())]
static func poll(s)->String:
 var q=ensure(s)
 if s.claim_id=="" or s.camp_stage<1 or s.active_site!="claim" or s.elapsed<q.next_check:return ""
 q.next_check=s.elapsed+5
 if not q.active.is_empty() or s.elapsed<q.next_at:return ""
 var kind="";var who=""
 if not q.done.has("supper"):
  who=actor(s)
  if who!="":kind="supper"
 if kind=="" and not q.done.has("seam") and not q.discovery.is_empty():
  who=actor(s,["miner","surveyor"])
  if who!="":kind="seam"
 if kind=="" and not q.done.has("workshop") and s.camp_stage>=2 and not s.queue.is_empty():
  who=actor(s,["smith","engineer"])
  if who!="":kind="workshop"
 if kind=="" and not q.done.has("freight") and s.camp_stage>=3:
  who=actor(s)
  if who!="":kind="freight"
 if kind=="":return ""
 q.active={"kind":kind,"actor":who,"phase":"offer","at":s.elapsed,"deferred":false}
 if kind=="seam":q.active.target=q.discovery.duplicate(true)
 if kind=="freight":
  q.active.cost={"stone":12,"copper":4} if posmod(s.seed_value,2)==0 else {"iron":4,"wood":6}
  q.active.crowns=110
 HoldOutpost.record(s,"story_offer_"+s.claim_id+"_"+kind,s.npc(who).name+" raised a matter for the claim: "+TITLES[kind].to_lower()+".")
 return TITLES[kind]
static func notice_ore(s,geo:Geology,result:Dictionary):
 if s.claim_id=="" or s.active_site!="claim" or int(result.get("kind",0)) not in [3,4,5,6]:return
 var q=ensure(s)
 if q.done.has("seam") or not q.discovery.is_empty():return
 # Bind the story to ore that still exists beside a face actually worked by a miner.
 var c:Vector2i=result.cell;var kind=int(result.kind)
 for y in range(c.y-5,c.y+6):
  for x in range(c.x-5,c.x+6):
   if geo.at(x,y)==kind and geo.exposed(Vector2i(x,y)):
    q.discovery={"x":x,"y":y,"kind":kind,"geo_seed":geo.seed_value};return
static func target_live(g,event:Dictionary)->bool:
 if not event.has("target") or g.state.active_site!="claim" or g.geo.seed_value!=int(event.target.geo_seed):return false
 var c=Vector2i(int(event.target.x),int(event.target.y))
 for y in range(c.y-12,c.y+13):
  for x in range(c.x-12,c.x+13):
   if g.geo.at(x,y)==int(event.target.kind):return true
 return false
static func on_build(g,c:Vector2i,kind:String):
 if g.state.active_site!="claim" or kind!="support":return
 var event=ensure(g.state).active
 if event.get("kind","")!="seam" or event.get("phase","")!="brace":return
 if g.geo.seed_value!=int(event.target.geo_seed):return
 if Vector2(c).distance_to(Vector2(event.target.x,event.target.y))*Geology.TILE<=210:event.brace={"x":c.x,"y":c.y}
static func braced(g,event:Dictionary)->bool:
 if not event.has("brace") or not target_live(g,event):return false
 for frame in g.geo.structures:
  if int(frame.x)==int(event.brace.x) and int(frame.y)==int(event.brace.y):
   var c=Vector2i(int(frame.x),int(frame.y))
   for x in [c.x,c.x+11]:
    if g.geo.at(x,c.y+1) in [0,12,13]:return false
   for x in range(c.x,c.x+12):
    if g.geo.at(x,c.y-12)!=13:return false
   return true
 return false
static func trust(s,id:String)->float:
 return minf(int(ensure(s).trust.get(id,0)),3)*.02
static func finish(s,choice:String,message:String):
 var q=ensure(s);var event=q.active
 if event.is_empty() or q.done.has(event.kind):return
 q.done[event.kind]={"choice":choice,"actor":event.actor,"minute":int(s.elapsed/60),"text":message}
 if choice!="decline":q.trust[event.actor]=int(q.trust.get(event.actor,0))+1
 HoldOutpost.record(s,"story_done_"+s.claim_id+"_"+event.kind,message)
 q.active={};q.next_at=s.elapsed+45
static func choose(g,choice:String)->bool:
 var s=g.state;var q=ensure(s);var e=q.active
 if s.claim_id=="" or s.active_site!="claim" or g.zone not in ["claim","mine"] or e.is_empty() or not s.outpost.crew.has(e.actor):return false
 var name=s.npc(e.actor).name
 if choice=="later":e.deferred=true;return true
 if choice=="decline":finish(s,choice,name+" accepted the decision to leave '"+TITLES[e.kind]+"' for another time.");return true
 if e.kind=="supper" and choice in ["meal","table"]:
  var cost={"food":4,"water":2}
  if choice=="table":cost.wood=4
  if not s.pay(cost):return false
  q.features[choice]=true
  finish(s,choice,name+" gathered the founding crew for supper"+(" at their new common table." if choice=="table" else ". The first shared meal became a custom."));return true
 if e.kind=="seam":
  if not target_live(g,e):return false
  if choice=="brace" and e.phase=="offer":e.phase="brace";e.deferred=false;return true
  if choice=="survey" and e.phase=="offer":
   if not s.pay({"copper":1,"food":1}):return false
   var marker=e.target.duplicate(true);marker.label=s.npc(e.actor).family_name+" seam";q.markers.append(marker)
   finish(s,choice,name+" surveyed and named the "+HoldData.TILES[int(e.target.kind)].name.to_lower()+" working. Its position is marked in the mine.");return true
  if choice=="report" and e.phase=="brace" and braced(g,e):
   finish(s,choice,name+" inspected a new anchored roof frame beside the working face. The route was left sound for the next shift.");return true
 if e.kind=="workshop" and choice in ["calibrate","stores"]:
  if s.camp_stage<2 or not s.outpost.crew[e.actor].role in ["smith","engineer"]:return false
  if not s.pay({"parts":2,"copper":1} if choice=="calibrate" else {"wood":4,"food":2}):return false
  q.features[choice]=true
  if choice=="stores":s.outpost.support_fuel=float(s.outpost.get("support_fuel",0))+240
  finish(s,choice,name+(" calibrated the workshop gauges. Supplied workshop assistance is 5% faster." if choice=="calibrate" else " fitted a dry stores rack and packed two provisions for 240 productive seconds of workshop assistance."));return true
 if e.kind=="freight" and choice=="trade":
  if s.camp_stage<3 or not s.pay(e.cost):return false
  s.money+=int(e.crowns)
  finish(s,choice,name+" filled the first visiting hauler's order at "+HoldOutpost.title(s)+". The payment was entered in the claim ledger.");return true
 return false
static func opening(s,e:Dictionary)->String:
 var p=HoldOutpost.personality(s,e.actor);var quirk=p.quirk
 var voice=HoldOutpost.member(s,e.actor).get("voice","")
 if e.kind=="supper":return "We have beds and work. Could we find time for a meal together? I've counted the mugs." if quirk in ["host","gardener"] or voice=="sociable" else "Before we put another shift behind us, I'd like to sit down with the others. We ought to know who we're building this place with."
 if e.kind=="seam":
  if voice=="ambitious" or quirk=="competitive":return "There's good ore at the face we opened. Give that working a name and we can make something of it. I'll take the next shift."
  return "There is more ore beside the face we worked. I'd like a proper survey, or a brace before we push farther. The next dwarf deserves a sound approach."
 if e.kind=="workshop":return "I heard the workshop running. We can fit a proper set of gauges, or make a dry rack for the shift provisions. Both would save us trouble."
 return "A hauler answered our beacon. There's space on the return journey, if we can fill an order. I've written down the goods and the payment."
static func panel(g):
 var s=g.state;var q=ensure(s);var e=q.active
 g.label(g.panel_body,"MATTERS OF THE CLAIM",22,Color("edc98a"))
 g.label(g.panel_body,"Requests from your people, based on work happening here. There are no hidden deadlines. You may defer or decline a request.",16)
 if e.is_empty():
  g.label(g.panel_body,"Nothing needs a decision right now.",18)
  g.label(g.panel_body,"A founding crew opens shared traditions. Working a real seam can prompt a survey or support request. A staffed workshop with a queued order and a working freight beacon open further opportunities.",15)
 else:
  if HoldConversation.local(g,e.actor):HoldConversation.header(g,g.panel_body,e.actor,opening(s,e),true)
  else:
   g.label(g.panel_body,"CLAIM LEDGER · "+s.npc(e.actor).name,18,Color("b6d8c9"))
   g.label(g.panel_body,opening(s,e),16)
  g.label(g.panel_body,TITLES[e.kind],20,Color("edc98a"))
  var local=s.active_site=="claim" and g.zone in ["claim","mine"]
  if not local:g.label(g.panel_body,"Return to your claim to make this decision.",16)
  var options=[]
  if e.kind=="supper":options=[["Share a meal • 4 provisions, 2 water","meal"],["Build a common table • 4 timber, 4 provisions, 2 water","table"]]
  elif e.kind=="seam":
   var height=(int(e.target.y)*7-385)/10
   g.label(g.panel_body,"Working face: %d m east, %d m %s the mine entrance." % [int(e.target.x)*7/10,absi(height),"below" if height>=0 else "above"],16)
   if not target_live(g,e):g.label(g.panel_body,"Load your claim mine to inspect this face. If the seam has been exhausted, you may close the request.",15)
   if e.phase=="offer":options=[["Survey and mark the seam • 1 copper, 1 provision","survey"],["I'll brace the working • build an anchored roof frame within 21 m","brace"]]
   else:
    g.label(g.panel_body,"Use V for construction. Build a braced roof frame near the marked face, then report here. The frame must still be standing.",16)
    options=[["Report the completed brace","report"]]
  elif e.kind=="workshop":
   g.label(g.panel_body,"Gauges: +5% supplied workshop assistance. Stores: a visible rack and 240 productive seconds of provisions. Both earn this dwarf's trust.",15)
   options=[["Calibrate the gauges • 2 parts, 1 copper","calibrate"],["Fit the stores rack • 4 timber, 2 provisions","stores"]]
  elif e.kind=="freight":options=[["Fill order • "+HoldData.cost_text(e.cost)+" → 110 crowns","trade"]]
  for option in options:
   var b=HoldConversation.choose(g,option[0],func():
    if choose(g,option[1]):g.save_game();g.refresh_panel()
    else:g.notify("Check the supplies, assignment, and working face before reporting."))
   b.disabled=not local or (option[1]=="report" and not braced(g,e))
  g.label(g.panel_body,"Completing a request earns +2% work contribution from this dwarf, up to +6%. No penalty for declining.",14,Color("abc6c0"))
  HoldConversation.choose(g,"Leave it on the ledger",func():choose(g,"later");g.save_game();g.close_panel())
  HoldConversation.choose(g,"Decline this request",func():choose(g,"decline");g.save_game();g.refresh_panel())
 if not q.done.is_empty():
  g.label(g.panel_body,"DECISIONS THAT STAY WITH THIS CLAIM",18,Color("edc98a"))
  for kind in q.done:g.label(g.panel_body,q.done[kind].text,15)
static func draw(g):
 if g.state.claim_id=="" or g.state.active_site!="claim":return
 var q=ensure(g.state)
 if g.zone=="claim" and g.room_id=="":
  if q.features.get("table",false):g.draw_texture_rect(HoldAnniversary.TABLE,Rect2(Vector2(560,354)+g.A.draw_offset,Vector2(98,56)),false)
  if q.features.get("stores",false):
   var p=Vector2(870,410)
   for x in [0,45]:g.A.rect(g,p.x+x,p.y-46,4,46,"815d3f")
   for y in [-40,-20]:g.A.rect(g,p.x,p.y+y,49,5,"bc945a")
   for x in [7,25]:g.A.rect(g,p.x+x,p.y-37,14,14,"b49359")
 if g.zone!="mine":return
 var markers=q.markers.duplicate()
 if q.active.get("kind","")=="seam":
  var target=q.active.target.duplicate();target.label="Working face • M: claim business";markers.append(target)
 for mark in markers:
  if int(mark.geo_seed)!=g.geo.seed_value:continue
  var p=g.geo.center(Vector2i(int(mark.x),int(mark.y)))
  if p.distance_to(g.player)>440:continue
  g.A.line(g,p+Vector2(-7,-11),p+Vector2(0,-17),"e7bd75",2);g.A.line(g,p+Vector2(0,-17),p+Vector2(7,-11),"e7bd75",2)
  g.A.text(g,p+Vector2(-70,-23),mark.label,12,Color("e7bd75"))
