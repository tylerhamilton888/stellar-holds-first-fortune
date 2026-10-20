class_name HoldCulture
extends RefCounted
# Subject-aware templates. Plural groups and inanimate objects keep ordinary grammar.
static func words(profile:Dictionary)->Dictionary:
 var female=int(profile.get("gender",0))==1
 return {"subject":"she" if female else "he","object":"her" if female else "him","possessive":"her" if female else "his","own":"hers" if female else "his","reflexive":"herself" if female else "himself","kin":"sister" if female else "brother","adult":"woman" if female else "man"}
static func render(s,text:String)->String:
 var ids=["player"]+HoldAppearance.NPC_NAMES.keys()+HoldOutpost.candidate_ids(s)
 for id in ids:
  if not text.contains("{"+id+":"):continue
  var p=s.appearance if id=="player" else s.npc(id)
  var forms=words(p)
  for key in forms:
   text=text.replace("{"+id+":"+key+"}",forms[key])
   text=text.replace("{"+id+":"+key.capitalize()+"}",forms[key].capitalize())
 return text
static func ensure(s)->Dictionary:
 HoldOutpost.ensure(s)
 if not s.outpost.has("culture"):s.outpost.culture={"count":0,"last":-3,"seen":{},"active":{},"errand":{},"done":false}
 return s.outpost.culture
const REACTIONS={
 "ivar":["Another brother joining the lower shift. Keep your word and mark your route; the crew will learn your name.","A woman for the lower shift? We don't often see that. Very well: a sound pick, fair wages, and a marked route home. Welcome to the works."],
 "brann":["Room on the shift for another brother. Hang your spare lamp beside mine; that's how you know which bench is home.","I haven't worked beside many women at the face. Let me show you the dry way down. Nobody should spend a first shift with wet boots."],
 "dagr":["A new brother with a pick! Excellent. Somebody hasn't yet heard about my record shift.","A woman racing me to the seam? That's new. The wager stands: loser carries the lunch tins."],
 "osvik":["My brothers all wanted axes. I wanted a lathe. If you understand that, we shall get along.","My mother taught me to check the underside of a weld. She would approve of your workshop plans."],
 "tovan":["Brother, leave a space at the bench for the next arrival. A hold grows one extra mug at a time.","A sister at the founding table. I'll set another mug beside the ledger. Tell me how you take your tea."],
 "kelvar":["Brother, the emergency valve is marked in red. That is an instruction, not a decorating preference.","Sister, the emergency valve is marked in red. That is an instruction, not a decorating preference."],
 "yrsa":["My brothers used to bring me interesting stones. Usually after testing them with a hammer. Try bringing one intact.","Another woman heading below. Good. At last I can discuss samples before someone asks whether I'm lost."],
 "orla":["A new brother with a mountain in mind. Let me introduce you to the freight clerks before you promise delivery dates.","Women at the mining face are uncommon here. If you're staying, help me make room at the common table. A hold needs a place to gather as well as a place to work."],
 "hedrik":["New brother on the shift? The haulers stop here for supper. Bring a sound sample shipment and I'll make the introductions.","Welcome, sister. A few heads turned when you came in carrying that pick. They'll be arguing about freight prices again by supper."],
 "borin":["Brother, I made that pick to bite stone. Spare it the nails in your bunkhouse.","Sister, I made that pick to bite stone. Spare it the nails in your bunkhouse."],
 "eldric":["Brother, a family chronicle needs a first page. Bring back a discovery worth drawing.","Sister, a family chronicle needs a first page. Bring back a discovery worth drawing."]
}
static func advance(s,id:String,index:int):
 var c=ensure(s);c.count=int(c.count)+1;c.active={}
 # One authored aside per speaker per fortune, and at least eight conversations apart.
 if not REACTIONS.has(id) or c.seen.has(id) or int(c.count)-int(c.last)<8:return
 c.last=c.count;c.seen[id]=true;c.active={"id":id,"index":index}
static func aside(s,id:String,index:int)->String:
 var c=ensure(s);var a=c.active
 if a.get("id","")!=id or int(a.get("index",-1))!=index:return ""
 return REACTIONS[id][int(s.appearance.gender)]
static func charter_reference(s)->String:
 return render(s,"Ivar's reference: I counted {player:object} out of the lower works after every shift. {player:Subject} delivered sound work, kept {player:possessive} word, and earned this charter recommendation.")
const ERRANDS={
 "bench":{"name":"A place at the mess bench","host":"orla","cost":{"stone":8,"wood":4},"reward":{"wood":6,"food":4},"intro":"Orla sets aside a requisition for the common dining room. 'A sister's welcome at our table. Bring stone for the stove footing and timber for another bench; I'll see the work supplied and put aside provisions for your expedition.'"},
 "freight":{"name":"Hedrik's freight introduction","host":"hedrik","cost":{"copper_ore":4,"wood":4},"reward":{"copper":2,"food":4},"intro":"Hedrik taps a freight docket left by one of his regulars. 'A new brother planning his own claim needs buyers who know his name. Bring a small copper shipment and crating timber; I'll introduce you to the haulers who stop here.'"}
}
static func offer(s)->String:return "bench" if int(s.appearance.gender)==1 else "freight"
static func accept(s)->bool:
 var c=ensure(s)
 if not HoldOnboarding.side_stories(s) or c.done or not c.errand.is_empty():return false
 c.errand={"id":offer(s)}
 return true
static func complete(s,host:String)->bool:
 var c=ensure(s)
 if c.done or c.errand.is_empty():return false
 var quest=ERRANDS[c.errand.id]
 if host!=quest.host or not s.pay(quest.cost):return false
 for item in quest.reward:s.add(item,quest.reward[item])
 s.bargain=maxf(s.bargain,180);c.done=true
 HoldOutpost.record(s,"first_social_bond",s.appearance.name+" completed "+quest.name.to_lower()+". A practical introduction became a place in Keldrath's working life.")
 return true
static func panel(g):
 var s=g.state
 if not HoldOnboarding.side_stories(s):return
 var c=ensure(s)
 var id=c.errand.get("id",offer(s));var quest=ERRANDS[id]
 if g.panel_id in ["market","tavern"] and quest.host!=("orla" if g.panel_id=="market" else "hedrik"):return
 if g.panel_id!="social":
  # Requests are offered by the host through conversation, not service menus.
  pass
  return
 var nearby=HoldOnboarding.local(g,quest.host)
 if nearby:HoldConversation.header(g,g.panel_body,quest.host,completion_line(s,id) if c.done else introduction(s,id),true)
 else:g.label(g.panel_body,"QUEST JOURNAL · "+s.npc(quest.host).name,17)
 g.label(g.panel_body,quest.name,21,Color("edc98a"))
 if not c.done:
  g.label(g.panel_body,"Supplies: "+HoldData.cost_text(quest.cost),16)
  g.label(g.panel_body,g.requirements(quest.cost),16,Color("b6d8c9"))
  g.label(g.panel_body,"Reward: "+HoldData.cost_text(quest.reward)+" and 3 minutes of favorable trading terms.",16)
 HoldConversation.responses(g)
 if not c.done:
  if c.errand.is_empty():
   var b=HoldConversation.choose(g,"I'll take care of it.",func():
    if HoldOnboarding.local(g,quest.host) and accept(s):g.save_game();g.refresh_panel(),true)
   b.disabled=not nearby
  else:
   var b=HoldConversation.choose(g,"Deliver the supplies" if nearby else "Return to "+s.npc(quest.host).first_name,func():
    if HoldOnboarding.local(g,quest.host) and complete(s,quest.host):g.save_game();g.sound.effect("quest",-7);g.refresh_panel(),true)
   b.disabled=not nearby or not s.afford(quest.cost)
 if not nearby:HoldConversation.choose(g,"Track "+s.npc(quest.host).first_name,func():s.tracked_npc=quest.host;g.save_game();g.close_panel())
 HoldConversation.return_choice(g,quest.host)
static func completion_line(s,id:String)->String:
 # Resolve current appearance even if changed after accepting. The errand itself stays fixed.
 if id=="bench":return render(s,"Orla checks the dining-room requisition. 'Our new {player:kin} has earned {player:possessive} place at the bench. Keep a seat for the next arrival.'")
 return render(s,"Hedrik passes the manifest to a waiting hauler. '{player:Subject} delivered what {player:subject} promised. Put {player:possessive} name in the reliable column.' The introduction comes with useful supplies.")
static func repair_legacy_entries(s):
 HoldOutpost.ensure(s)
 for entry in s.outpost.chronicle:
  if not str(entry.text).ends_with(" under their assignment."):continue
  for id in HoldOutpost.CREW:
   if str(entry.text).begins_with(HoldOutpost.CREW[id].name+" worked "):
    entry.text=str(entry.text).replace("under their assignment.","as part of "+words(s.npc(id)).possessive+" assignment.")

static func introduction(s,id:String)->String:
 if id==offer(s):return ERRANDS[id].intro
 if id=="bench":return "Orla points to the stores. 'Your contribution is still welcome. Stone for the stove footing and timber for another bench, as agreed.'"
 return "Hedrik opens the manifest. 'Your introduction is arranged. Bring the sample copper and crating timber, as agreed, and we can meet the buyers.'"
