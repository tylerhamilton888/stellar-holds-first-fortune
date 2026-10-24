class_name HoldPeople
extends RefCounted
# Authored principals; supporting residents acquire one saved identity on meeting.
# No frame-time randomness, replacement portraits, or parallel inventory system.
const PRINCIPALS={
 "ivar":{"trait":"Dry-witted, protective, exacting","want":"I want every name on my shift ledger to answer at supper. Production figures can wait their turn.","worry":"I remember the sound of an empty cage coming up. I check the ropes myself now. Nobody argues twice.","close":"I used to think remembering every name made me a good foreman. These days I try to remember who needs asking twice if they are all right.","like":"barley_bread","dislike":"crystal","work":"wood","reason":"Dry pegs for the shift's lamp rack"},
 "orla":{"trait":"Shrewd, affectionate, quietly adventurous","want":"One day I will close the shutters for a season and see the ports on my manifests. Hedrik has already begun packing an entirely unreasonable kettle.","worry":"People think a good merchant never trusts anyone. I trust plenty of people. I write things down so we needn't quarrel about remembering them.","close":"Hedrik thinks I kept that broken delivery cup because it was expensive. It wasn't. Don't tell him; he enjoys trying to replace it.","like":"silver_char","dislike":"iron_slag","work":"wood","reason":"Dividers for the exchange's return crates"},
 "hedrik":{"trait":"Hospitable, observant, fond of gentle teasing","want":"I want the last person through my door to feel expected. Even if all I have left is the heel of a loaf.","worry":"I can tell who has had a bad shift by who jokes the loudest. Feeding them is easy. Getting them to sit long enough to talk takes practice.","close":"Orla wants to see the sea. So do I, though I've never admitted I cannot swim. I suppose there is time to learn before she buys the tickets.","like":"hearthcap","dislike":"coal","work":"turnip","reason":"Roots for a supper shared with the late shift"},
 "borin":{"trait":"Blunt, meticulous, proud of teaching","want":"I want an apprentice to make a tool better than mine and tell me exactly how. Preferably before my hands get too stiff to try it.","worry":"A bad joint can look beautiful. I would rather disappoint someone's eye than trust their weight to it.","close":"The first pick I made bent on its third strike. My teacher kept it above his bench. I hated that thing. Now I wish I had asked for it back.","like":"iron","dislike":"river_fish","work":"coal","reason":"Fuel for the apprentice's practice forge"},
 "eldric":{"trait":"Curious, patient, cheerfully absent-minded","want":"I want a map that says what we do not know as honestly as what we do. Blank spaces are invitations, not failures.","worry":"I once named a seam before checking the second sample. The correction took one line. Learning to write it took considerably longer.","close":"I keep my earliest notebook. Half of it is wrong. The other half asks better questions than I do now.","like":"crystal","dislike":"iron_slag","work":"stone","reason":"Reference pieces for the survey students"},
 "eirik":{"trait":"Measured, dutiful, privately restless","want":"I want a child born here to have a choice: a good life under this mountain, or a safe road beyond it. A hold should give roots without becoming a lock.","worry":"Everyone rehearses before speaking to a king. I worry most about the news they decide not to bring.","close":"When I was young I wanted a surveyor's boots, not a crown. I still keep a pair. They are embarrassingly clean.","like":"barley_bread","dislike":"gold","work":"dressed_stone","reason":"Replacement stones for the public stair"}}
const TEMPERAMENTS=[
 {"trait":"Quiet and practical","want":"A sound bench, a quiet evening, and time to finish one thing properly.","worry":"I mend things before they break. My family calls it worrying. I call it a peaceful evening.","close":"I do enjoy company. I just prefer the kind that lets a silence sit comfortably."},
 {"trait":"Sociable and generous","want":"A table long enough that nobody has to ask whether there is room.","worry":"I keep saying yes to helping. Then I wonder why my own chores are waiting at midnight.","close":"You remembered to stop and talk. That matters more than most people suppose."},
 {"trait":"Ambitious and competitive","want":"To do a piece of work that people still point out after I am gone.","worry":"I compare my work with everyone else's. Useful at the bench. Less useful when I am trying to sleep.","close":"I don't mind losing to someone good. I mind pretending it doesn't bother me."},
 {"trait":"Curious and independent","want":"To walk a road I haven't walked before and come home with something worth telling.","worry":"I have a shelf of unfinished projects. Every one seemed a sensible idea when I started it.","close":"I used to think leaving was the brave part. Sometimes coming back and asking for help takes more."}]
const LIKES=["barley_bread","hearthcap","river_fish","carrot","crystal","iron"]
const DISLIKES=["coal","iron_slag","turnip","gold"]
const WORK=["wood","stone","coal","turnip"]
static func records(s)->Dictionary:
 if not s.surface.has("people"):s.surface.people={}
 # JSON restores numbers as floats. Keep saved counters canonical, just as
 # inventory and appearance normalization do, without changing their values.
 for id in s.surface.people:
  var d=s.surface.people[id]
  HoldRoadCharacters.upgrade_record(id,d)
  for key in ["bond","chat_day","gift_day","work_day"]:
   d[key]=int(d.get(key,0 if key=="bond" else -1))
 return s.surface.people
static func background(id:String)->bool:return id.begins_with("resident:") or id.begins_with("road_folk:")
static func nearby(g,id:String)->Dictionary:
 if not background(id) or not g.surface.active():return {}
 var folk=g.surface.roads.people(g.surface.area) if id.begins_with("road_folk:") else g.surface.world.routines.people(g.surface.area,g.state.elapsed)
 for p in folk:
  if p.get("interaction","")==id and g.player.distance_to(p.p)<85 and g.surface.clear_interaction(g.player,p.p):return p
 return {}
static func meet(g,id:String):
 var s=g.state;var all=records(s)
 if background(id):
  var p=nearby(g,id)
  if p.is_empty():return
  if not s.npc_appearances.has(id):
   var profile=p.profile.duplicate(true);var parts=p.name.split(" ")
   profile.first_name=parts[0];profile.family_name=" ".join(parts.slice(1));profile.name=p.name
   s.npc_appearances[id]=profile
 if not all.has(id):
  var rng=RandomNumberGenerator.new();rng.seed=int(s.seed_value)+int(id.hash())
  var persona=PRINCIPALS[id].duplicate(true) if PRINCIPALS.has(id) else HoldRoadCharacters.persona(id)
  if persona.is_empty():
   persona=TEMPERAMENTS[rng.randi_range(0,TEMPERAMENTS.size()-1)].duplicate(true)
   persona.like=LIKES[rng.randi_range(0,LIKES.size()-1)];persona.dislike=DISLIKES[rng.randi_range(0,DISLIKES.size()-1)]
   persona.work=WORK[rng.randi_range(0,WORK.size()-1)];persona.reason={"wood":"A shelf for the household's worn tools","stone":"Repairs to the family hearth","coal":"Fuel for a neighbor's small stove","turnip":"Supper for a shared work shift"}[persona.work]
   if HoldOutpost.has_member(s,id):
    var member=HoldOutpost.member(s,id);persona.trait=HoldOutpost.describe(s,id)
    var lines=member.get("lines",[])
    if lines.size()>=3:persona.want=lines[0];persona.worry=lines[1];persona.close=lines[2]
    if not member.get("wish",{}).is_empty():persona.like=member.wish.keys()[0]
    if persona.dislike==persona.like:persona.dislike="iron_slag"
  all[id]={"persona":persona,"bond":0,"chat_day":-1,"gift_day":-1,"work_day":-1,"known":false,"last":"We have just met."}
  HoldRoadCharacters.upgrade_record(id,all[id])
 g.save_game()
static func level(d:Dictionary)->String:
 return "Trusted friend" if int(d.bond)>=12 else "Familiar face" if int(d.bond)>=5 else "Acquaintance"
static func role(s,id:String)->String:
 if id.begins_with("road_folk:"):return HoldRoads.FOLK[int(id.trim_prefix("road_folk:"))].role
 if id.begins_with("resident:"):return "Neighbor of "+id.split(":")[1].capitalize()
 return HoldAppearance.NPC_ROLES.get(id,"A dwarf of Keldrath")
static func chat(g,id:String)->String:
 if not HoldConversation.local(g,id):return "Let us talk when we are together."
 meet(g,id);var d=records(g.state)[id];var day=int(g.state.elapsed/600.0)
 if d.chat_day!=day:d.chat_day=day;d.bond=mini(20,int(d.bond)+1);d.last="We made time for a conversation.";g.save_game()
 var p=d.persona
 return p.close if int(d.bond)>=5 else (p.want if day%2==0 else p.worry)
static func gift(g,id:String,item:String)->String:
 if not HoldConversation.local(g,id):return "Come and see me first."
 var d=records(g.state).get(id,{})
 if d.is_empty() or not HoldData.ITEMS.has(item):return "Let us introduce ourselves first."
 var day=int(g.state.elapsed/600.0)
 if int(d.gift_day)==day:return "One gift is plenty for today. Keep something for yourself."
 if not g.state.pay({item:1}):return "You no longer have that in your pack."
 var liked=item==d.persona.like;var disliked=item==d.persona.dislike
 d.gift_day=day;d.bond=clampi(int(d.bond)+(3 if liked else -1 if disliked else 1),0,20)
 d.last=("Loved" if liked else "Disliked" if disliked else "Appreciated")+" your gift of "+HoldData.ITEMS[item].name.to_lower()+"."
 g.save_game()
 return "You remembered! That is a particular favorite of mine." if liked else "Thank you for thinking of me, but this isn't really to my taste." if disliked else "That's kind of you. Thank you."
static func help(g,id:String)->bool:
 if not HoldConversation.local(g,id):return false
 var d=records(g.state).get(id,{});var day=int(g.state.elapsed/600.0)
 if d.is_empty() or int(d.work_day)==day or not g.state.pay({d.persona.work:2}):return false
 d.work_day=day;d.bond=mini(20,int(d.bond)+2);d.last="You helped: "+d.persona.reason.to_lower()+"."
 # Fair reimbursement, not an infinite premium over the market.
 g.state.money+=2*int(HoldData.ITEMS[d.persona.work].price);g.save_game();return true
static func options(g,id:String):
 HoldConversation.choose(g,"How have you been?",func():g.talk_line=chat(g,id);g.talk_topic="person";g.refresh_panel())
static func panel(g,id:String):
 var d=records(g.state).get(id,{})
 if d.is_empty():return
 var p=d.persona
 HoldConversation.header(g,g.panel_body,id,g.talk_line if g.talk_line!="" else p.want,true)
 g.label(g.panel_body,d.persona.trait+" · "+level(d),15,Color("a7c7c6"))
 g.label(g.panel_body,d.last,14)
 if d.known:g.label(g.panel_body,"Enjoys "+HoldData.ITEMS[p.like].name.to_lower()+" · Not fond of "+HoldData.ITEMS[p.dislike].name.to_lower(),15)
 HoldConversation.choose(g,"What do you enjoy?",func():d.known=true;g.save_game();g.talk_line="I am always glad of "+HoldData.ITEMS[p.like].name.to_lower()+". "+HoldData.ITEMS[p.dislike].name+" isn't for me, though. A visit is welcome either way.";g.refresh_panel())
 HoldConversation.choose(g,"Give a gift from my pack",func():g.talk_topic="gift";g.refresh_panel())
 HoldConversation.choose(g,"Any small jobs need doing?",func():g.talk_topic="favor";g.refresh_panel())
 if HoldRoadCharacters.CAST.has(id):HoldConversation.choose(g,"Tell me about life here",func():g.talk_line="";g.talk_topic="road_story";g.refresh_panel())
 HoldConversation.return_choice(g,id)
static func favor(g,id:String):
 var d=records(g.state).get(id,{})
 if d.is_empty():return
 var p=d.persona;var day=int(g.state.elapsed/600.0)
 HoldConversation.header(g,g.panel_body,id,p.reason+". There is no hurry.",true)
 if d.work_day==day:
  g.label(g.panel_body,"You have helped today. Thank you. Nothing more is needed right now.",17)
 else:
  g.label(g.panel_body,"Bring 2 "+HoldData.ITEMS[p.work].name.to_lower()+" from your pack · You carry "+str(g.state.count(p.work)),17)
  g.label(g.panel_body,"Payment: "+str(2*int(HoldData.ITEMS[p.work].price))+" crowns. Helping also builds familiarity.",16)
  g.label(g.panel_body,"No deadline. One small job per workday (10 minutes of play). Stored and communal materials stay where they are.",14,Color("a7b4b0"))
  var b=HoldConversation.choose(g,"Deliver 2 "+HoldData.ITEMS[p.work].name.to_lower(),func():
   if help(g,id):g.talk_line="That will make a difference. Thank you for following through."
   g.refresh_panel())
  b.disabled=g.state.count(p.work)<2
 HoldConversation.choose(g,"Back to our conversation",func():g.talk_topic="person";g.refresh_panel())
static func gifts(g,id:String):
 var d=records(g.state).get(id,{})
 if d.is_empty():return
 HoldConversation.header(g,g.panel_body,id,"A small kindness",true)
 if int(d.gift_day)==int(g.state.elapsed/600.0):g.label(g.panel_body,"Already given a gift this workday. Another visit is enough.",16)
 else:
  g.label(g.panel_body,"Choose one item. Giving it removes one from your pack.",15)
  var count=0
  for item in g.state.inventory:
   if g.state.count(item)<=0 or not HoldData.ITEMS.has(item):continue
   count+=1
   HoldConversation.choose(g,HoldData.ITEMS[item].name+" ("+str(g.state.count(item))+")",func():g.talk_line=gift(g,id,item);g.talk_topic="person";g.refresh_panel())
  if count==0:g.label(g.panel_body,"Your pack has no gifts to give.",16)
 HoldConversation.choose(g,"Back to our conversation",func():g.talk_topic="person";g.refresh_panel())
static func notebook(g):
 var all=records(g.state)
 if all.is_empty():return
 g.label(g.panel_body,"People you are getting to know",22,Color("edc98a"))
 for id in all:
  var d=all[id]
  g.label(g.panel_body,g.state.npc(id).name+" · "+level(d),17)
  if HoldRoadCharacters.CAST.has(id):g.label(g.panel_body,HoldRoadCharacters.whereabouts(id),14,Color("a7c7c6"))
  g.label(g.panel_body,d.persona.trait+". "+d.last,14)
  if d.known:g.label(g.panel_body,"Enjoys "+HoldData.ITEMS[d.persona.like].name.to_lower()+"; dislikes "+HoldData.ITEMS[d.persona.dislike].name.to_lower()+".",14)
  if HoldConversation.local(g,id):g.button(g.panel_body,"Talk to "+g.state.npc(id).first_name,func():HoldConversation.start(g,id))
