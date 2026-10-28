class_name HoldDisciplineView
extends RefCounted

static func panel(g):
 if not g.skill_detail:
  overview(g);return
 g.small_button(g.panel_body,"‹ All skills",func():g.skill_detail=false;g.refresh_panel())
 var body=g.panel_body
 var path=g.discipline_tab;var info=HoldDisciplines.PATHS[path]
 var hero=g.row(body);var art=TextureRect.new();art.texture=load("res://assets/disciplines71/"+path+".svg");art.custom_minimum_size=Vector2(94,94);art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;hero.add_child(art)
 var heading=VBoxContainer.new();heading.size_flags_horizontal=Control.SIZE_EXPAND_FILL;hero.add_child(heading)
 g.label(heading,info[0],24,Color("edc98a"));g.label(heading,info[1],16);g.label(heading,"%d work completed · %s" % [HoldDisciplines.xp(g.state,path),info[2]],16,Color("a7dfcb"))
 if path=="brewing":g.label(body,"Brewing techniques will arrive with a dedicated brewing workstation. There are no spendable unlocks here yet.",16)
 if path=="overseer":g.label(body,"Leadership skill is separate from your civic title. Learning a technique grants no claim or access to hold-owned supplies.",16)
 if path=="mining":g.label(body,"Milestones · 12 mined faces: strong shoulders and joint reading. 40 faces: controlled sections and four extra cart loads.",16)
 for id in HoldDisciplines.NODES:
  var n=HoldDisciplines.NODES[id]
  if n[0]!=path:continue
  var learned=HoldDisciplines.has(g.state,id);var need=HoldDisciplines.missing(g.state,id)
  var card=g.section(body,n[1]+(" · Learned" if learned else ""));g.label(card,n[2],16)
  if not learned:
   var bar=ProgressBar.new();bar.max_value=n[3];bar.value=mini(n[3],HoldDisciplines.xp(g.state,path));bar.show_percentage=false;bar.custom_minimum_size.y=8;card.add_child(bar)
   g.label(card,"%d / %d completed work · %s" % [mini(n[3],HoldDisciplines.xp(g.state,path)),n[3],"Ready to learn" if need=="" else need],16)
   var b=g.small_button(card,"Learn technique",func():
    if HoldDisciplines.learn(g.state,id):g.sound.effect("crystal");g.save_game();g.open_panel("disciplines",false))
   b.disabled=need!="";b.tooltip_text="Experience is retained; learning does not spend it." if need=="" else need
 for id in HoldDisciplines.METHODS.get(path,[]):
  var method=HoldData.RESEARCH[id];var done=g.state.tech.has(id);var card=g.section(body,method.name+(" · Researched" if done else " · Research"));g.label(card,method.desc,16)
  if not done:
   var need="First research "+HoldData.RESEARCH[method.requires].name if method.requires!="" and not g.state.tech.has(method.requires) else ""
   g.label(card,HoldData.cost_text(method.cost)+" / %d crowns" % method.money,16)
   if need!="":g.label(card,need,16)
   var b=g.small_button(card,"Research method",func():
    if g.state.research(id):g.sound.effect("crystal");g.save_game();g.open_panel("disciplines",false))
   b.disabled=need!="" or not g.state.afford(method.cost,method.money);b.tooltip_text=need if need!="" else "Requires the listed materials and crowns."

static func overview(g):
 g.label(g.panel_body,"Useful work builds mastery. Select a skill to see techniques and research.",16)
 var grid=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",10);grid.add_theme_constant_override("v_separation",4);g.panel_body.add_child(grid)
 for path in HoldDisciplines.PATHS:
  var info=HoldDisciplines.PATHS[path];var work=HoldDisciplines.xp(g.state,path);var total=0;var learned=0;var target=0
  for id in HoldDisciplines.NODES:
   var n=HoldDisciplines.NODES[id]
   if n[0]!=path:continue
   total+=1
   if HoldDisciplines.has(g.state,id):learned+=1
   elif target==0 or n[3]<target:target=n[3]
  var card=g.section(grid,"");card.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
  var style=card.get_parent().get_theme_stylebox("panel").duplicate();style.set_content_margin_all(2);card.get_parent().add_theme_stylebox_override("panel",style)
  var row=g.row(card)
  var art=TextureRect.new();art.texture=load("res://assets/disciplines71/"+path+".svg");art.custom_minimum_size=Vector2(28,28);art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(art)
  var title=g.small_button(row,info[0],func():g.discipline_tab=path;g.skill_detail=true;g.refresh_panel());title.custom_minimum_size.x=118;title.tooltip_text=info[1]
  var body=VBoxContainer.new();body.add_theme_constant_override("separation",1);body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;row.add_child(body)
  var bar=ProgressBar.new();bar.max_value=maxi(1,target);bar.value=mini(work,target) if target>0 else (1 if total>0 else 0);bar.show_percentage=false;bar.custom_minimum_size.y=6;body.add_child(bar)
  g.label(body,"%d / %d work" % [mini(work,target),target] if target>0 else ("All techniques learned" if total>0 else "No techniques available yet"),14)
  title.tooltip_text+=" · %d / %d techniques learned" % [learned,total]
