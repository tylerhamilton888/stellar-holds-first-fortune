from pathlib import Path
p=Path('scripts/anniversary.gd');s=p.read_text()
s=s.replace(' return s.outpost.anniversary',' var q=s.outpost.anniversary\n if not q.has("delivery_order"):\n  q.delivery_order=[]\n  for id in ["orla","hedrik"]:\n   if q.gifts.get(id,{}).get("delivered",false):q.delivery_order.append(id)\n if not q.has("inviter"):q.inviter=str(q.delivery_order.back()) if q.delivery_order.size()==2 else ""\n return q',1)
s=s.replace('static func accept(s,id:String)->bool:', 'static func accept(s,id:String,local:bool=false)->bool:')
s=s.replace(' if not NAMES.has(id) or not HoldOnboarding.side_stories(s)', ' if not local or not NAMES.has(id) or not HoldOnboarding.side_stories(s)',1)
s=s.replace('static func prepare(s,id:String,choice:int)->bool:', 'static func prepare(s,id:String,choice:int,local:bool=false)->bool:')
s=s.replace(' if v.is_empty() or v.delivered or choice<0', ' if not local or v.is_empty() or v.delivered or choice<0')
s=s.replace(' v.delivered=true\n return true',' v.delivered=true\n var q=ensure(s)\n if id not in q.delivery_order:q.delivery_order.append(id)\n if ready(s):q.inviter=id\n return true')
a=s.index(' return g.state.active_site',s.index('static func local_host'));b=s.index('\nstatic func status',a)
s=s[:a]+' return NAMES.has(id) and HoldOnboarding.local(g,id)\n'+s[b:]
s=s.replace('if ready(s):return "ready" if id=="hedrik" else ""','if ready(s):return "ready" if id==ensure(s).inviter else ""')
a=s.index('static func panel(g):');b=s.index('# Painted sprites',a)
complete=s[s.index(' if q.complete:',a):s.index(' g.label(g.panel_body,"Keep both surprises quiet.',a)]
s=s[:a]+'''static func invitation(s,id:String)->String:
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
'''+complete+''' var id=g.anniversary_host
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

'''+s[b:]
p.write_text(s)
p=Path('scripts/culture.gd');s=p.read_text().replace('  g.button(body,"Accept the introduction",func():\n   if accept(s):g.save_game();g.refresh_panel())','  var b=g.button(body,"Accept the introduction",func():\n   if HoldOnboarding.local(g,quest.host) and accept(s):g.save_game();g.refresh_panel())\n  b.disabled=not HoldOnboarding.local(g,quest.host)');p.write_text(s)
# Entry is local to whichever spouse invited the player. Replays remain at the table.
p=Path('scripts/anniversary_scene.gd');s=p.read_text().replace(' var scene=HoldAnniversaryScene.new();scene.game=g',' var q=HoldAnniversary.ensure(g.state)\n if not q.complete and not HoldAnniversary.local_host(g,str(q.inviter)):return null\n var scene=HoldAnniversaryScene.new();scene.game=g');p.write_text(s)
