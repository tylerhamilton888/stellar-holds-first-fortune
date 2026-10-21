class_name HoldDisciplineView
extends RefCounted

static func panel(g):
 g.label(g.panel_body,"Useful work earns mastery. Research opens methods. Choose techniques when ready.",16,Color("b4c9c4"))
 var layout=g.row(g.panel_body)
 var nav=ScrollContainer.new();nav.follow_focus=true;nav.custom_minimum_size=Vector2(170,310);nav.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;layout.add_child(nav)
 var tabs=VBoxContainer.new();tabs.size_flags_horizontal=Control.SIZE_EXPAND_FILL;nav.add_child(tabs)
 for id in HoldDisciplines.PATHS:
  var b=g.small_button(tabs,HoldDisciplines.PATHS[id][0],func():g.discipline_tab=id;g.open_panel("disciplines",false))
  b.toggle_mode=true;b.button_pressed=g.discipline_tab==id;b.tooltip_text=HoldDisciplines.PATHS[id][1]
  if b.button_pressed:nav.set_deferred("scroll_vertical",maxi(0,int(HoldDisciplines.PATHS.keys().find(id))*37-120))
 var scroll=ScrollContainer.new();scroll.follow_focus=true;scroll.custom_minimum_size=Vector2(0,310);scroll.size_flags_horizontal=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;layout.add_child(scroll)
 var body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;body.add_theme_constant_override("separation",10);scroll.add_child(body)
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
