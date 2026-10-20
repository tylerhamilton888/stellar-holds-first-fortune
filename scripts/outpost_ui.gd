class_name HoldOutpostUI
extends RefCounted
static func position(s,id:String)->Vector2:
 var role=s.outpost.crew[id].role
 var x={"miner":1320,"smith":780,"engineer":1640,"surveyor":1240,"rest":500}.get(role,500)
 var rank=0
 for other in s.outpost.crew:
  if other==id:break
  if s.outpost.crew[other].role==role:rank+=1
 return Vector2(minf(x+rank*75,2060),410)
static func draw_crew(g):
 HoldOutpost.ensure(g.state)
 for id in g.state.outpost.crew:
  var p=position(g.state,id)
  g.A.dwarf(g,p,g.clock,false,1,0,false,g.state.npc(id))
  HoldQuestMarkers.draw(g,p,g.state,id)
  if g.player.distance_to(p)<65:g.A.text(g,p+Vector2(-30,-125 if HoldQuestMarkers.status(g.state,id)!="" else -85),"E • "+g.state.npc(id).first_name,12,Color("e6d5ac"))
 if g.state.claim_id!="":g.A.text(g,Vector2(80,300),HoldOutpost.title(g.state),17,Color("e6d5ac"))
static func panel(g):
 var s=g.state;HoldOutpost.ensure(s)
 g.label(g.panel_body,HoldOutpost.title(s) if s.claim_id!="" else "YOUR FUTURE OUTPOST",22,Color("edc98a"))
 var tabs=g.row(g.panel_body)
 for i in 5:
  var b=g.small_button(tabs,["Progress","Crew","Hiring","Claim business","Chronicle"][i],func():g.outpost_tab=i;g.open_panel("manage",false))
  b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  if g.outpost_tab==i:b.modulate=Color("a7e2ce")
 if g.outpost_tab==0:overview(g)
 elif g.outpost_tab==1:crew(g)
 elif g.outpost_tab==2:recruits(g)
 elif g.outpost_tab==3:HoldClaimStories.panel(g)
 else:chronicle(g)
static func overview(g):
 var s=g.state
 g.label(g.panel_body,HoldOutpost.next_step(s),19,Color("b5e1d3"))
 g.label(g.panel_body,"Charter → workshop → founding crew → freight beacon → first ship",16)
 if s.claim_id!="":
  var r=g.row(g.panel_body);var edit=LineEdit.new();edit.placeholder_text="Name your outpost";edit.text=s.outpost.get("name","");edit.max_length=32;edit.size_flags_horizontal=Control.SIZE_EXPAND_FILL;r.add_child(edit)
  g.button(r,"Save name",func():s.outpost.name=edit.text.strip_edges();g.save_game();g.refresh_panel())
 g.label(g.panel_body,"Crew %d / %d berths   •   %d provisions   •   %d coal   •   %d crowns" % [s.outpost.crew.size(),HoldOutpost.capacity(s),s.count("food"),s.count("coal"),s.money],16)
 g.label(g.panel_body,"Foundations house 2 dwarves; workshop 4; freight beacon 6. Assign specialists for stronger bonuses. Crew work stops when paused; there are no offline wages or starvation penalties.",15,Color("abc6c0"))
 var matter=HoldClaimStories.ensure(s).active
 if not matter.is_empty():g.button(g.panel_body,"Claim business: "+HoldClaimStories.TITLES[matter.kind],func():g.outpost_tab=3;g.open_panel("manage"))
 var links=g.row(g.panel_body)
 for pair in [["Work journal","commission"],["Founding works","camp"],["First ship","ship"]]:g.small_button(links,pair[0],func():g.open_panel(pair[1]))
 if s.claim_id!="":
  var cost={};var crowns=0;var heading=""
  if s.camp_stage<3:
   var stage=HoldCampaign.CAMP[s.camp_stage];cost=stage.cost;crowns=stage.money;heading=stage.name
  elif s.ship_stage<3:
   var stage=HoldIndustry.ship_stage(s,s.ship_stage);cost=stage.cost;crowns=stage.money;heading=stage.name
  if heading!="":
   g.label(g.panel_body,"SAVE FOR: "+heading.to_upper(),18,Color("edc98a"))
   g.label(g.panel_body,HoldData.cost_text(cost)+" • %d crowns" % crowns,16)
   g.label(g.panel_body,g.requirements(cost,crowns),16,Color("b5e1d3"))
 g.button(g.panel_body,"Review technology & machinery",func():g.forge_tab=3;g.open_panel("forge"))
 g.label(g.panel_body,"Workshop staff: 1 provision / 120 productive seconds. Miners: 1 / 192 excavated grains. Engineering and surveying have no supply drain.",15,Color("abc6c0"))
 g.label(g.panel_body,"Mining crew excavate actual reachable terrain while your claim is loaded. Workshops use shared stores and continue queued work while you travel. No hidden resource generation.",15,Color("abc6c0"))
 g.button(g.panel_body,"Pause all crew work" if s.agents_enabled else "Resume crew work",func():s.agents_enabled=not s.agents_enabled;g.save_game();g.refresh_panel())
static func crew(g):
 var s=g.state
 if s.outpost.crew.is_empty():g.label(g.panel_body,"No founding crew yet. The hiring bench at the Copper Kettle has experienced hands and visiting candidates. Build foundations to provide your first two berths.",17);return
 g.label(g.panel_body,"Choose a role and mining priority. Assignments take effect immediately.",16)
 for id in s.outpost.crew:
  var c=HoldOutpost.member(s,id);var member=s.outpost.crew[id]
  var card=g.section(g.panel_body,c.name)
  portrait(g,card,id)
  if HoldClaimStories.trust(s,id)>0:g.label(card,"Trust from shared work: +%d%% contribution" % roundi(HoldClaimStories.trust(s,id)*100),14,Color("a7d4c3"))
  g.label(card,HoldOutpost.describe(s,id)+" • Specialty: "+HoldOutpost.ROLES[c.specialty]+(" • Trust earned (+5% mining speed / workshop contribution)" if s.outpost.favors.get(id,false) else ""),15,Color("b5d9cf"))
  var r=g.row(card);g.label(r,"Assignment",16)
  var choices=OptionButton.new();choices.custom_minimum_size=Vector2(190,38);r.add_child(choices)
  for role in HoldOutpost.ROLES:
   choices.add_item(HoldOutpost.ROLES[role])
   var index=choices.item_count-1
   if role==member.role:choices.select(index)
   choices.set_item_disabled(index,role in ["smith","engineer","surveyor"] and s.camp_stage<2)
  choices.item_selected.connect(func(index):g.remember_agents();HoldOutpost.assign(s,id,HoldOutpost.ROLES.keys()[index]);g.spawn_agents();g.save_game();g.refresh_panel())
  if member.role=="miner":
   var ore=OptionButton.new();ore.custom_minimum_size=Vector2(160,38);r.add_child(ore)
   var minerals=["iron_ore","copper_ore","coal","crystal","stone"]
   for k in minerals:
    ore.add_item(HoldData.ITEMS[k].name)
    if k==member.priority:ore.select(ore.item_count-1)
   ore.item_selected.connect(func(index):g.remember_agents();member.priority=minerals[index];g.spawn_agents();g.save_game();g.refresh_panel())
   var status="At claim • load your mountain to resume mining"
   for agent in g.agents:
    if agent.get("id","")==id:status=agent.status
   g.label(card,status,15)
  if member.role=="smith":g.label(card,"Workshop team speed: +%d%% when supplied" % roundi(HoldOutpost.bonus(s,"smith")*100),15)
  var actions=g.row(card)
  g.button(actions,"Talk with "+s.npc(id).first_name,func():g.visitor_key=id;HoldOutpost.line(s,id,true);g.open_panel("visitor"))
  g.button(actions,"Track location",func():s.tracked_npc=id;g.save_game();g.close_panel())
  if not s.outpost.favors.get(id,false):
   var project=HoldOutpost.project(s,id)
   g.label(card,"Personal project: "+project.reason+"\n"+HoldData.cost_text(project.cost),15)
   var b=g.button(card,"Contribute supplies",func():
    if HoldOutpost.favor(s,id):g.save_game();g.notify(s.npc(id).first_name+": That's a thoughtful start. This place is becoming home.");g.refresh_panel())
   b.disabled=not s.afford(project.cost)
static func portrait(g,parent,id:String):
 var r=g.row(parent);var portrait=HoldPortrait.new();portrait.profile=g.state.npc(id);portrait.custom_minimum_size=Vector2(72,72);r.add_child(portrait)
 g.label(r,'“'+HoldOutpost.line(g.state,id)+'”',16)
static func recruits(g):
 var s=g.state;var available=g.room_id=="tavern" or s.camp_stage>=3
 g.label(g.panel_body,"Meet candidates at the Copper Kettle. Once your freight beacon is working, you can recruit remotely through its dispatch service.",16)
 g.label(g.panel_body,"%d / %d berths occupied. Recruitment is a one-time signing payment and 2 provisions; assignments have no recurring wages." % [s.outpost.crew.size(),HoldOutpost.capacity(s)],16,Color("b5d9cf"))
 for id in HoldOutpost.candidate_ids(s):
  var c=HoldOutpost.member(s,id);var card=g.section(g.panel_body,c.name+ (" • RECRUITED" if s.outpost.crew.has(id) else ""))
  portrait(g,card,id)
  if HoldFrontier.is_generated(id):g.label(card,"Visiting candidate • "+c.trait,14,Color("b5d9cf"))
  g.label(card,HoldOutpost.describe(s,id)+" • Specialty: "+HoldOutpost.ROLES[c.specialty],15)
  if s.outpost.crew.has(id):continue
  var reason="Recruit • %d crowns + 2 provisions" % c.fee
  if s.claim_id=="":reason="Earn a mountain charter first"
  elif s.outpost.crew.size()>=HoldOutpost.capacity(s):reason="Build the next outpost stage for more berths"
  elif not available:reason="Visit the Copper Kettle to recruit"
  var b=g.button(card,reason,func():
   if HoldOutpost.recruit(s,id):g.spawn_agents();g.save_game();g.notify(c.name+" joins your founding crew. M opens assignments.");g.refresh_panel())
  b.disabled=not available or s.claim_id=="" or s.outpost.crew.size()>=HoldOutpost.capacity(s) or not s.afford({"food":2},c.fee)
  g.button(card,"Talk / find "+s.npc(id).first_name,func():g.visitor_key=id;g.open_panel("visitor"))

static func chronicle(g):
 var entries=g.state.outpost.chronicle
 g.label(g.panel_body,"THE BEGINNING OF A HOLD",20,Color("edc98a"))
 g.label(g.panel_body,"WIP · Marriage, children and dynastic succession are not implemented. This chronicle records your current outpost and crew.",15,Color("dfc7ac"))
 g.label(g.panel_body,"The people, discoveries, and decisions that made this outpost. Each entry marks something your crew has done.",16)
 if entries.is_empty():g.label(g.panel_body,"Your first recruitment will open the chronicle.",17)
 for i in range(entries.size()-1,-1,-1):
  var e=entries[i]
  g.label(g.panel_body,"Shift minute %d  •  %s" % [e.minute,e.text],17,Color("b5d9cf"))
