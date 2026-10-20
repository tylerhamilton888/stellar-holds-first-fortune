class_name HoldFirstShift
extends RefCounted
static func panel(g):
 var s=g.state;var q=HoldOnboarding.ensure(s)
 g.label(g.panel_body,"IVAR DEEPMEASURE",22,Color("edc98a"))
 var local=HoldOnboarding.local(g,"ivar")
 if HoldOnboarding.settling(s):
  g.label(g.panel_body,"'Put your feet up first. Your bed and storage chest are in the workers’ quarters on the northwestern street. Then introduce yourself to Borin, Orla and Hedrik.'",17)
  g.button(g.panel_body,"Review settling in",func():g.open_panel("guidance"));return
 match int(q.stage):
  0,1:
   g.label(g.panel_body,"Ivar looks up from a ledger thick with coal dust. 'Newly of age, are you? Give me your name. You need a shift, and I need someone who listens before swinging a pick.'",17)
   g.label(g.panel_body,"'Borin checks the tools. Orla knows the routes. Hedrik will feed you. Meet all three, then take eight coal from the Old Workings. Sixty-five crowns when you bring it back. The surplus is yours.'",17)
   g.label(g.panel_body,"'A woman for the lower shift? We do not see that often. Sound work earns sound wages here, sister.'" if int(s.appearance.gender)==1 else "'Welcome to the shift, brother. Work carefully and keep your word. That will do for a beginning.'",16,Color("b6d8c9"))
   var b=g.button(g.panel_body,"My name is "+s.appearance.first_name+" "+s.appearance.family_name+". I am ready to work.",func():
    q.stage=2;s.tracked_npc="borin";g.save_game();g.refresh_panel();g.notify("Meet Borin, Orla and Hedrik. Their quest signs mark the introductions."))
   b.disabled=not local
   if not local:g.label(g.panel_body,"Visit Ivar's office beside the pithead. Follow his location marker and press E at the door.",15)
  2:
   g.label(g.panel_body,"'Meet the people you will be relying on. Borin's forge is down the eastern stairs in Forgeward. Orla's exchange and the Copper Kettle are on Hearthward's north street. Introduce yourself properly.'",17)
   for id in ["borin","orla","hedrik"]:
    g.button(g.panel_body,("Met: " if q.met.has(id) else "Find: ")+s.npc(id).name,func():s.tracked_npc=id;g.save_game();g.close_panel())
   g.label(g.panel_body,"After all three introductions, your coal commission begins. Step outside and press G for regional travel. Walk northeast to Old Workings, then press E to enter. J keeps the route and mining controls.",16)
  4:
   g.label(g.panel_body,"Ivar weighs the coal and signs a short note. 'The hearth can burn again. Your wage is paid. The Lord takes an interest in new hands who do what they promise. The King's hall is on Crownward. The gallery stairs and hold lift will take you there.'",17)
   g.button(g.panel_body,"Track the audience",func():s.tracked_npc="eirik";g.save_game();g.close_panel())
  5:
   g.label(g.panel_body,"'A fine room, isn't it? I prefer ceilings I can inspect without a telescope. Now, the lift needs sixteen stone and eight timber. The firs in Pinewood will serve. Bring straight lengths.'",17)
   g.label(g.panel_body,"'While you are out, practice building a return route. Borin can teach you to smelt. Eldric will show you what a sample tells us. There is other work about the hold, too. Ask the folk you meet.'",17)
   var b=g.button(g.panel_body,"Take the lift commission and ask about work around the hold",func():
    q.stage=6;s.tracked_npc="ivar";g.save_game();g.refresh_panel();g.notify("New work is marked around the hold. J lists the first-season lessons and local stories."))
   b.disabled=not local
  _:
   g.label(g.panel_body,"'Begin with a sound day's work. The rest follows.'",17)
   if s.opening==0:g.button(g.panel_body,"Begin the first shift",g.accept_employment)
 if not local:g.button(g.panel_body,"Track Ivar",func():s.tracked_npc="ivar";g.save_game();g.close_panel())
