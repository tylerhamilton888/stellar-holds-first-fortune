class_name HoldConversation
extends RefCounted
const SERVICES={"ivar":["Review paid commissions","commission"],"orla":["Show me your wares","market"],"hedrik":["Food, drink and the hiring bench","tavern"],"borin":["Tools, smelting and equipment","forge"],"eldric":["Research and mountain charters","research"]}
const TOPICS={
 "ivar":[["How is the hold treating you?","I have worked three shifts under three lords. The stone is much the same. The paperwork gets thicker. Still, I know every name on this ledger. That is worth staying for."],["Any advice before I head below?","Put your way home in before you need it. Stairs, timber, a lamp where the passage turns. A full pack is poor company at the bottom of a shaft."]],
 "orla":[["How did you and Hedrik meet?","He delivered six crates of cups. Five arrived intact. He stayed to mend the sixth and somehow never quite finished leaving."],["Where can I find timber?","Pinewood. Use the expedition table and follow the basin road to the forest. Take an axe. Borin's spare lengths will get you started, but they won't build a hold."]],
 "hedrik":[["What is the house specialty?","Stew you can stand a spoon in, bread you can still bite, and tea with no business being that strong. Orla says the last one is a personal failing."],["Does everyone gather here?","Sooner or later. A mug is cheaper than a message runner, and considerably better at getting the truth out of someone."]],
 "borin":[["What are you working on?","A pump coupling. Whoever fitted the last one had great faith in optimism and very little in a measuring rule."],["What makes a good pick?","The temper, the haft, and the hand holding it. Keep the head seated. Replace a split handle before it teaches you why."]],
 "eldric":[["What lies beyond these mountains?","More mountains, for a start. Then seas. Then worlds with their own inconvenient geology. The first survey instrument aboard your ship should be a good notebook."],["What do the blue conduits do?","Carry the load that fire cannot. The old runes keep the current orderly. Science tells us how much; craft makes sure the answer holds under pressure."]],
 "eirik":[["What makes a good freeholder?","A sound roof, a fair wage, and the patience to hear bad news before it becomes worse. Gold will buy machinery. It will not make your people trust you."],["Has Keldrath always reached for the stars?","Our oldest songs speak of stone. Our oldest engines remember the sky. I see no reason a dwarf should have to choose between them."]]
}
static func local(g,id:String)->bool:
 if HoldNpcPresence.HOMES.has(id):return HoldOnboarding.local(g,id)
 if id.begins_with("visitor_"):return g.zone=="hub" and g.room_id=="" and g.player.distance_to(g.visitor_position(int(id.trim_prefix("visitor_"))))<75
 if g.room_id=="tavern":return HoldNpcPresence.tavern_guests(g.state).has(id)
 if g.zone=="claim":return g.state.outpost.get("crew",{}).has(id) and g.player.distance_to(HoldOutpostUI.position(g.state,id))<75
 return false
static func start(g,id:String):
 if not local(g,id):g.notify("Find "+g.state.npc(id).first_name+" at "+g.npc_where(id).label+".");return
 g.talk_id=id;g.talk_topic="";g.talk_line="";g.menu_history.clear();g.open_panel("conversation",false)
static func header(g,parent:Node,id:String,text:String,compact:bool=false):
 var line=g.row(parent);line.add_theme_constant_override("separation",22)
 var portrait=HoldRoyalHall.portrait() if id=="eirik" else HoldPortrait.new()
 if id!="eirik":portrait.profile=g.state.npc(id)
 portrait.custom_minimum_size=Vector2(96,96) if compact else Vector2(132,132);line.add_child(portrait)
 var body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;body.add_theme_constant_override("separation",4 if compact else 8);line.add_child(body)
 g.label(body,g.state.npc(id).name,22 if compact else 24,Color("edc98a"))
 g.label(body,HoldAppearance.NPC_ROLES.get(id,"A dwarf of Keldrath"),14,Color("a7c7c6"))
 g.label(body,HoldCulture.render(g.state,text),16 if compact else 18)
 var rule=HSeparator.new();parent.add_child(rule)
static func responses(g):
 if g.panel.find_child("Responses",true,false)!=null:return
 var box=GridContainer.new();box.name="Responses";box.columns=2
 box.add_theme_constant_override("h_separation",10);box.add_theme_constant_override("v_separation",9)
 box.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 var outer=g.panel_body.get_parent().get_parent();outer.add_child(box);outer.move_child(box,outer.get_child_count()-2)
static func return_choice(g,id:String):
 if local(g,id):choose(g,"Talk about something else",func():start(g,id))
 else:choose(g,"Back to my journal",func():g.open_panel("guidance"))
static func choose(g,text:String,fn:Callable,quest:bool=false)->Button:
 responses(g)
 var parent=g.panel.find_child("Responses",true,false)
 var b=g.button(parent,("◆  " if quest else "›  ")+text,fn)
 b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 b.custom_minimum_size.y=36
 for style_name in ["normal","hover","pressed","disabled","focus"]:
  var style=b.get_theme_stylebox(style_name).duplicate();style.set_content_margin_all(9);b.add_theme_stylebox_override(style_name,style)
 b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 b.add_theme_color_override("font_color",Color("efd7a7") if quest else Color("e4e9e5"))
 return b
static func greeting(g,id:String)->String:
 if g.talk_line!="":return g.talk_line
 var stage=HoldOnboarding.stage(g.state)
 if id=="ivar":return {1:"Newly of age, are you? Give me your name. You need a shift, and I need someone who listens before swinging a pick.",2:"Meet the folk who will keep you fed, supplied and properly equipped. Then we can begin.",3:"Eight coal for Borin. Keep the surplus. How did you fare?",4:"Sound coal and a safe return. I have sent your name to the Lord. He will hear you now.",5:"A fine room, isn't it? I prefer ceilings I can inspect without a telescope. Now, about those lift footings."}.get(stage,"Good to see you back. What have you brought me?")
 if id=="eirik":return "Ivar speaks well of your first shift. Come closer, "+g.state.appearance.first_name+"." if stage==4 else "A good hold is built by useful hands. What is on your mind?"
 return {"orla":"Come in. Mind the manifests. What can I do for you?","hedrik":"A seat, a supper, or a little company? There is room for all three.","borin":"Set your pack down clear of the bellows. What needs doing?","eldric":"Ah, a visitor with mud on the boots. Always more promising than one with a clean theory."}.get(id,HoldOutpost.line(g.state,id) if HoldOutpost.has_member(g.state,id) else "Good to see another face about the hold. How goes your day?")
static func panel(g):
 var id=g.talk_id;var s=g.state;var q=HoldOnboarding.ensure(s)
 if not local(g,id):g.label(g.panel_body,"This conversation has ended. Visit the resident to speak again.");return
 if g.talk_topic.begins_with("fluff"):
  header(g,g.panel_body,id,TOPICS[id][int(g.talk_topic.trim_prefix("fluff"))][1])
  choose(g,"There was something else…",func():g.talk_topic="";g.refresh_panel())
 elif g.talk_topic=="intro":
  header(g,g.panel_body,id,HoldOnboarding.intro_text(s,id))
  choose(g,"Thank you. I will put that to use.",func():
   if HoldOnboarding.introduce(s,id):g.save_game();g.talk_topic="";g.talk_line="You are welcome. Come back when you need anything.";g.refresh_panel(),true)
 else:
  header(g,g.panel_body,id,greeting(g,id))
  responses(g)
  if q.fresh and q.stage==2 and id in ["borin","orla","hedrik"] and not q.met.has(id):
   choose(g,"Introduce myself. Ivar sent me.",func():g.talk_topic="intro";g.refresh_panel(),true)
  if id=="ivar":ivar_options(g)
  if id=="eirik" and q.fresh and q.stage==4:
   choose(g,"Step forward for my audience",func():g.opening_scene=HoldOpeningScene.begin(g,"audience"),true)
  for lesson in HoldOnboarding.LESSONS:
   var entry=HoldOnboarding.LESSONS[lesson]
   if entry.host==id and HoldOnboarding.unlocked(s,lesson) and not q.done.has(lesson):
    choose(g,("Continue: " if q.accepted.has(lesson) else "Ask about: ")+entry.name,func():g.lesson_id=lesson;g.open_panel("lesson"),true)
  if HoldAnniversary.status(s,id)!="":
   var v=HoldAnniversary.gift(s,id)
   var title="You wanted a quiet word?" if v.is_empty() else HoldAnniversary.NAMES[id]
   if HoldAnniversary.ready(s) and HoldAnniversary.ensure(s).inviter==id:title="You wanted me to come along?"
   choose(g,title,func():g.anniversary_host=id;g.open_panel("anniversary"),true)
  var c=HoldCulture.ensure(s);var errand=HoldCulture.ERRANDS[c.errand.get("id",HoldCulture.offer(s))]
  if HoldOnboarding.side_stories(s) and not c.done and errand.host==id:
   choose(g,errand.name,func():g.open_panel("social"),true)
  var matter=HoldClaimStories.ensure(s).active
  if not matter.is_empty() and matter.actor==id:choose(g,HoldClaimStories.TITLES[matter.kind],func():g.open_panel("claim_stories"),true)
  if SERVICES.has(id) and id!="ivar":choose(g,SERVICES[id][0],func():g.open_panel(SERVICES[id][1]))
  for i in TOPICS.get(id,[]).size():
   choose(g,TOPICS[id][i][0],func():g.talk_topic="fluff"+str(i);g.refresh_panel())
  if HoldOutpost.has_member(s,id):choose(g,"Tell me about yourself",func():g.talk_line=HoldOutpost.line(s,id,true);g.refresh_panel())
 choose(g,"Good fortune. I'll leave you to it.",g.close_panel)
static func ivar_options(g):
 var s=g.state;var q=HoldOnboarding.ensure(s)
 if q.fresh and q.stage in [0,1]:
  choose(g,"I am "+s.appearance.first_name+" "+s.appearance.family_name+". I am ready to work.",func():
   q.stage=2;s.tracked_npc="borin";g.save_game();g.talk_line="Welcome to the shift, "+("sister" if s.appearance.gender else "brother")+". Borin checks the tools. Orla knows the routes. Hedrik will feed you. Meet all three, then bring eight coal from Old Workings. Sixty-five crowns when you return. The surplus is yours.";g.refresh_panel(),true)
 elif q.fresh and q.stage==4:
  choose(g,"Mark the King's hall on my map",func():g.state.tracked_npc="eirik";g.save_game();g.close_panel();g.notify("Leave the office, then G: Crownward, King's hall. Use the gallery stairs or hold lift."),true)
 elif q.fresh and q.stage==5:
  choose(g,"What needs doing next?",func():
   q.stage=6;s.tracked_npc="ivar";g.save_game();g.talk_line="Sixteen stone and eight timber for the lift footings. Pinewood has straight firs. Use the expedition table to find the road. Borin and Eldric have useful lessons when you have a moment; listen for other work as you visit the hold.";g.refresh_panel(),true)
 elif HoldOnboarding.commission_allowed(s) and s.opening in [1,2,3]:
  var job=HoldCampaign.JOBS[s.opening-1]
  choose(g,"Commission: "+job.name,func():g.open_panel("commission"),true)
  if s.afford(job.cost):
   choose(g,"Deliver "+HoldData.cost_text(job.cost),func():
    if s.finish_commission():g.save_game();g.sound.effect("quest",-10);g.talk_line=job.result;g.refresh_panel(),true)
