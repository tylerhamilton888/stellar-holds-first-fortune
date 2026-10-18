class_name HoldAnniversary
extends RefCounted

const A=preload("res://scripts/art.gd")
const INSCRIPTIONS=["Fifty years. The kettle is just warming.","One hearth. Two stubborn hearts.","For all the shifts still to come."]
const MOTIFS=["Interwoven roots","Mountain and hearth","Twin household runes"]
const NAMES={"hedrik":"A modest little kettle","orla":"Only eight years of carving"}

static func ensure(s)->Dictionary:
 HoldOutpost.ensure(s)
 if not s.outpost.has("anniversary"):
  s.outpost.anniversary={"gifts":{},"complete":false,"refill_at":0.0}
 var q=s.outpost.anniversary
 if not q.has("delivery_order"):
  q.delivery_order=[]
  for id in ["orla","hedrik"]:
   if q.gifts.get(id,{}).get("delivered",false):q.delivery_order.append(id)
 if not q.has("inviter"):q.inviter=str(q.delivery_order.back()) if q.delivery_order.size()==2 else ""
 return q

static func gift(s,id:String)->Dictionary:
 return ensure(s).gifts.get(id,{})

static func cost(gender:int,id:String)->Dictionary:
 # Both routes total 2 copper, 2 iron, 6 timber, 4 stone and 2 meals.
 if id=="hedrik":return {"copper":2,"food":2,"wood":3} if gender else {"copper":2,"food":2,"iron":2}
 return {"wood":3,"stone":4,"iron":2} if gender else {"wood":6,"stone":4}

static func accept(s,id:String,local:bool=false)->bool:
 var q=ensure(s)
 if not local or not NAMES.has(id) or not HoldOnboarding.side_stories(s) or q.complete or q.gifts.has(id):return false
 q.gifts[id]={"gender":int(s.appearance.gender),"choice":-1,"delivered":false}
 return true

static func prepare(s,id:String,choice:int,local:bool=false)->bool:
 var v=gift(s,id)
 if not local or v.is_empty() or v.delivered or choice<0 or choice>2:return false
 v.choice=choice
 return true

static func deliver(s,id:String,local:bool)->bool:
 var v=gift(s,id)
 if not local or v.is_empty() or v.delivered or int(v.choice)<0:return false
 if not s.pay(cost(int(v.gender),id)):return false
 v.delivered=true
 var q=ensure(s)
 if id not in q.delivery_order:q.delivery_order.append(id)
 if ready(s):q.inviter=id
 return true

static func ready(s)->bool:
 for id in NAMES:
  if not gift(s,id).get("delivered",false):return false
 return true

static func finish(s)->bool:
 var q=ensure(s)
 if q.complete or not ready(s):return false
 q.complete=true;s.money+=50;s.add("food",4)
 HoldOutpost.record(s,"fiftieth_anniversary",s.appearance.name+" kept two secrets for Orla and Hedrik's fiftieth anniversary. Their gifts became the hold's warmest tea table.")
 return true

static func refill(s)->bool:
 var q=ensure(s)
 if not q.complete or s.elapsed<float(q.refill_at):return false
 s.add("food",2);q.refill_at=s.elapsed+1200.0
 return true

static func local_host(g,id:String)->bool:
 return NAMES.has(id) and HoldOnboarding.local(g,id)

static func status(s,id:String)->String:
 if not HoldOnboarding.side_stories(s) or not NAMES.has(id) or ensure(s).complete:return ""
 if ready(s):return "ready" if id==ensure(s).inviter else ""
 var v=gift(s,id)
 if v.is_empty():return "offer"
 if v.delivered:return ""
 return "ready" if int(v.choice)>=0 and s.afford(cost(int(v.gender),id)) else "active"

static func introduction(id:String,gender:int)->String:
 if id=="hedrik":
  return "Orla and I have been married fifty years. Only fifty, mind. We agreed on small gifts. So: a kettle. Copper, a pressure valve, an inscription inside the lid. She'll see it when she fills it. " + ("You're a woman with an eye for a household's little comforts. Help me choose the words and fit a handle that stays cool; I've put aside her favorite tea." if gender else "Brother, help me fit the iron heating cradle. It must warm her tea without cooking her fingers. A gift ought to work properly.")
 return "Hedrik thinks I've forgotten our fiftieth. I've made him a little serving table for his tavern. Heated shelves, room for his mugs. Eight years' carving, on and off. Don't make a thing of it. " + ("Sister, help me set the tableware and choose a household motif. He notices care, though he pretends only to notice supper." if gender else "I need a strong pair of hands for its timber braces and stone feet. Help me choose the carving, too. He'll insist on inspecting the underside.")

static func invitation(s,id:String)->String:
 if id=="orla":return "There. He won't see it until I lift the cloth. Come with me to the Copper Kettle, would you? I need someone to help carry this small gift. And someone sensible to tell Hedrik that eight years is not long for proper carving."
 return "That is the last fitting. Orla will be along shortly. Come with me to the concourse. You helped make it; you ought to see her face when I lift the lid. If she asks, this was a very modest undertaking."

static func journal(g):
 var q=ensure(g.state)
 for id in NAMES:
  var v=gift(g.state,id)
  if v.is_empty():continue
  var suffix=" / delivered" if v.delivered else " / in progress"
  g.button(g.panel_body,NAMES[id]+suffix,func():g.anniversary_host=id;g.open_panel("anniversary"))
 if ready(g.state) and not q.complete:
  g.label(g.panel_body,g.state.npc(q.inviter).first_name+" has invited you to come along. Visit "+g.npc_where(q.inviter).label+".",16,Color("a7d4c3"))

static func panel(g):
 var s=g.state;var q=ensure(s)
 if not HoldOnboarding.side_stories(s):g.label(g.panel_body,"You have no request to follow here yet.");return
 if q.complete:
  g.label(g.panel_body,"Their masterwork kettle and carved table now warm the concourse outside the Copper Kettle. A small gift, made properly.",17)
  g.label(g.panel_body,'Inside the lid: “'+INSCRIPTIONS[int(gift(s,"hedrik").choice)]+'”',16)
  g.label(g.panel_body,"Carving: "+MOTIFS[int(gift(s,"orla").choice)]+". Matching commemorative mugs stay at the table.",15)
  var here=s.active_site=="hold" and g.zone=="hub" and g.room_id=="" and absf(g.player.x-535)<100
  var wait=maxi(0,int(ceil((float(q.refill_at)-s.elapsed)/60.0)))
  var b=g.button(g.panel_body,"Fill your expedition flask • +2 provisions" if wait==0 else "Fresh brew in %d minutes of play" % wait,func():
   if refill(s):g.save_game();g.notify("Hot tea and a wrapped bite for the trail. +2 provisions.");g.refresh_panel())
  b.disabled=not here or wait>0
  g.label(g.panel_body,"Visit the tea table outside the tavern. Refill once per 20 minutes of active play; no real-world waiting.",14)
  var replay=g.button(g.panel_body,"Remember the gift exchange",func():g.anniversary_scene=HoldAnniversaryScene.begin(g))
  replay.disabled=not here
  return
 var id=g.anniversary_host
 if not NAMES.has(id):
  g.label(g.panel_body,"Your journal records the requests you have accepted. Speak to people in the hold to learn what they need.",17)
  journal(g);return
 var v=gift(s,id);var local=local_host(g,id)
 # Undiscovered secrets cannot be opened through a journal, remote roster or Ivar.
 if v.is_empty() and not local:
  g.label(g.panel_body,"Visit "+s.npc(id).first_name+" to speak in person.",17)
  g.button(g.panel_body,"Track location",func():s.tracked_npc=id;g.save_game();g.close_panel());return
 var line=invitation(s,id) if ready(s) and q.inviter==id else introduction(id,int(v.get("gender",s.appearance.gender)))
 if v.get("delivered",false) and not (ready(s) and q.inviter==id):line="Finished and safely hidden. Thank you for the help. Not a word until the day, mind."
 HoldConversation.header(g,g.panel_body,id,line)
 g.label(g.panel_body,NAMES[id],20,Color("edc98a"))
 if ready(s) and q.inviter==id:
  var b=HoldConversation.choose(g,"I'd be glad to come along.",func():
   if local_host(g,id):g.anniversary_scene=HoldAnniversaryScene.begin(g),true)
  b.disabled=not local
 elif v.is_empty():
  HoldConversation.choose(g,"I'll help. Your secret is safe.",func():
   if accept(s,id,local_host(g,id)):g.save_game();g.refresh_panel(),true)
 elif not v.delivered:
  g.label(g.panel_body,"Supplies: "+HoldData.cost_text(cost(int(v.gender),id)),16)
  g.label(g.panel_body,g.requirements(cost(int(v.gender),id)),16,Color("b6d8c9"))
  if int(v.choice)<0:
   g.label(g.panel_body,"Choose the inscription inside the lid:" if id=="hedrik" else "Choose the table's carving:",17)
   var choices=INSCRIPTIONS if id=="hedrik" else MOTIFS
   for i in 3:
    var b=HoldConversation.choose(g,choices[i],func():
     if prepare(s,id,i,local_host(g,id)):g.save_game();g.refresh_panel())
    b.disabled=not local
  else:
   g.label(g.panel_body,"Chosen: "+(INSCRIPTIONS if id=="hedrik" else MOTIFS)[int(v.choice)],16)
   var b=HoldConversation.choose(g,"Fit the parts and hide the gift" if local else "Return to "+s.npc(id).first_name+" with the supplies",func():
    if deliver(s,id,local_host(g,id)):g.save_game();g.sound.effect("build",-16);g.notify("The gift is finished and safely hidden.");g.refresh_panel(),true)
   b.disabled=not local or not s.afford(cost(int(v.gender),id))
 if not local:g.button(g.panel_body,"Track "+s.npc(id).first_name,func():s.tracked_npc=id;g.save_game();g.close_panel())
 if local:HoldConversation.choose(g,"Talk about something else",func():HoldConversation.start(g,id))
 else:g.button(g.panel_body,"Back to my journal",func():g.open_panel("guidance"))

# Painted sprites use measured alpha bounds, with animation and player-selected ornaments.
const TEA_STATION=preload("res://assets/story-v44/tea-station.png")
const TABLE=preload("res://assets/anniversary-v31/table.png")
const KETTLE=preload("res://assets/anniversary-v31/kettle.png")
static func station(n:Node2D,p:Vector2,t:float,table:bool=true,kettle:bool=true,motif:int=0,steam:bool=true):
 var x=p.x;var y=p.y
 if table and kettle:
  n.draw_texture_rect(TEA_STATION,Rect2(x-62,y-83,124,83),false)
  if motif==1:A.poly(n,[Vector2(x-4,y-45),Vector2(x,y-50),Vector2(x+4,y-45)],"d2a875")
  elif motif==2:A.rune(n,Vector2(x,y-47),.30,Color("d3ac69"))
  if steam:
   for i in 4:
    var h=fposmod(t*13+i*9,30)
    n.draw_arc(Vector2(x-14+sin(t+i)*3,y-63-h),3,PI*.4,PI*1.4,8,Color(.85,.9,.9,(1-h/30)*.3),1.2)
  return
 if table:
  A.poly(n,[Vector2(x-50,y-1),Vector2(x-43,y-7),Vector2(x+44,y-7),Vector2(x+52,y)],Color(0,0,0,.25))
  n.draw_texture_rect(TABLE,Rect2(x-49,y-55.65,98,55.65),false)
  A.text(n,Vector2(x-5,y-34),"50",8,Color("f3dca6"))
  for dx in [-22,22]:
   if motif==0:
    n.draw_arc(Vector2(x+dx,y-35),4,0,TAU,12,Color("dab37d"),1)
   elif motif==1:A.poly(n,[Vector2(x+dx-4,y-33),Vector2(x+dx,y-38),Vector2(x+dx+4,y-33)],"d2a875")
   else:A.rune(n,Vector2(x+dx,y-35),.30,Color("d3ac69"))
 if kettle:
  var base=y-54 if table else y
  n.draw_texture_rect(KETTLE,Rect2(x-20,base-39.56,40,39.56),false)
  if steam:
   for i in 4:
    var h=fposmod(t*13+i*9,38)
    var q=Vector2(x-18+sin(t*1.6+i)*3,base-21-h)
    n.draw_arc(q,3+h*.05,PI*.4,PI*1.4,8,Color(.8,.86,.82,(1-h/38)*.35),1.5)
