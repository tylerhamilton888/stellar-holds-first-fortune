class_name HoldMenuView
extends RefCounted

# Presentation only. Game session, purchases and panel navigation remain on the host.
static func button(parent:Node,label:String,callback:Callable)->Button:
 var b=Button.new();b.text=label;b.custom_minimum_size.y=42;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.size_flags_vertical=Control.SIZE_SHRINK_CENTER;b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;parent.add_child(b);b.pressed.connect(callback);return b

static func label(parent:Node,s:String,size:int=15,color:Color=Color("e6e8e2"))->Label:
 var l=Label.new();l.text=s;l.add_theme_font_size_override("font_size",maxi(14,size));l.add_theme_color_override("font_color",ink(parent,color));l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size_flags_horizontal=Control.SIZE_EXPAND_FILL;parent.add_child(l);return l

static func row(parent:Node)->HBoxContainer:
 var r=HBoxContainer.new();r.add_theme_constant_override("separation",8);parent.add_child(r);return r

static func small_button(parent:Node,text:String,fn:Callable)->Button:
 var b=button(parent,text,fn);b.custom_minimum_size.y=30;b.add_theme_font_size_override("font_size",14)
 for style_name in ["normal","hover","pressed","disabled"]:
  var style=b.get_theme_stylebox(style_name).duplicate();style.set_content_margin_all(7);b.add_theme_stylebox_override(style_name,style)
 return b

static func section(parent:Node,title:String)->VBoxContainer:
 var box=PanelContainer.new();var style=StyleBoxFlat.new();style.bg_color=Color("e4d1ab") if folio(parent) else Color("1d3540");style.set_content_margin_all(12);style.set_corner_radius_all(4);box.add_theme_stylebox_override("panel",style);parent.add_child(box)
 var body=VBoxContainer.new();body.add_theme_constant_override("separation",7);box.add_child(body)
 if title!="":label(body,title,18,Color("edc98a"))
 return body

static func make_theme()->Theme:
 var theme=Theme.new();theme.default_font=ThemeDB.fallback_font;theme.default_font_size=16
 for type in ["Button","PanelContainer"]:
  var style=StyleBoxFlat.new();style.bg_color=Color("152731");style.border_color=Color("8c784f");style.set_border_width_all(1);style.set_content_margin_all(11);style.set_corner_radius_all(6)
  theme.set_stylebox("normal" if type=="Button" else "panel",type,style)
  if type=="Button":
   var hover=style.duplicate();hover.bg_color=Color("34565b");hover.border_color=Color("e2b96d");theme.set_stylebox("hover",type,hover)
   var pressed=style.duplicate();pressed.bg_color=Color("355c58");pressed.border_color=Color("e7c789");theme.set_stylebox("pressed",type,pressed)
   var disabled=style.duplicate();disabled.bg_color=Color("202d36");disabled.border_color=Color("3e4a50");theme.set_stylebox("disabled",type,disabled)
   theme.set_color("font_color","Button",Color("f0dbaf"));theme.set_color("font_disabled_color","Button",Color("a5b2b7"))
   var focus=StyleBoxFlat.new();focus.bg_color=Color(0,0,0,0);focus.border_color=Color("a7dfcb");focus.set_border_width_all(2);theme.set_stylebox("focus","Button",focus)
 theme.set_color("font_color","Label",Color("e6e8e2"));theme.set_constant("line_spacing","Label",4)
 return theme

const TABS=[["inventory","Pack","I"],["equipment","Gear","B"],["disciplines","Skills","Y"],["roster","People","N"],["recipes","Craft",""],["commission","Journal","J"],["wayfinding","Map","G"],["calendar","Calendar",""],["settings","Options",""]]
static func folio(node:Node)->bool:
 while node!=null:
  if node.has_meta("folio"):return true
  node=node.get_parent()
 return false
static func ink(node:Node,color:Color)->Color:
 if not folio(node):return color
 if color.r>color.b*1.12:return Color("79501f")
 if color.g>color.r*1.08:return Color("355d54")
 return Color("382d24")
static func paper_style(fill:String,border:String="a47b43",width:int=1)->StyleBoxFlat:
 var s=StyleBoxFlat.new();s.bg_color=Color(fill);s.border_color=Color(border);s.set_border_width_all(width);s.set_corner_radius_all(3);s.set_content_margin_all(10);return s
static func book_theme()->Theme:
 var t=make_theme();t.default_font_size=16
 var frame=paper_style("f0dfbb","795332",3);frame.set_content_margin_all(16);frame.shadow_color=Color(0,0,0,.35);frame.shadow_size=8;t.set_stylebox("panel","PanelContainer",frame)
 for type in ["Button","OptionButton","CheckButton","CheckBox"]:
  t.set_stylebox("normal",type,paper_style("e4cda0"))
  t.set_stylebox("hover",type,paper_style("f9edce","8e5e2d",2))
  t.set_stylebox("pressed",type,paper_style("b9ccbb","44695a",2))
  t.set_stylebox("disabled",type,paper_style("ded2b9","b6a58a"))
  for key in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:t.set_color(key,type,Color("382d24"))
  t.set_color("font_disabled_color",type,Color("7b705f"))
  t.set_stylebox("focus",type,paper_style("ffffff00","317565",2))
 t.set_color("font_color","Label",Color("382d24"))
 t.set_stylebox("normal","LineEdit",paper_style("fff2d7"));t.set_color("font_color","LineEdit",Color("382d24"));t.set_color("font_placeholder_color","LineEdit",Color("75664f"));t.set_color("caret_color","LineEdit",Color("382d24"))
 var track=paper_style("d4c2a0","b19a74");track.set_content_margin_all(0);var fill=paper_style("648d74","47715b");fill.set_content_margin_all(0)
 t.set_stylebox("background","ProgressBar",track);t.set_stylebox("fill","ProgressBar",fill)
 t.set_stylebox("panel","PopupMenu",paper_style("f0dfbb"));t.set_color("font_color","PopupMenu",Color("382d24"));t.set_color("font_hover_color","PopupMenu",Color("382d24"));t.set_stylebox("hover","PopupMenu",paper_style("b9ccbb"))
 t.set_stylebox("panel","TooltipPanel",paper_style("fff2d7","795332",2));t.set_color("font_color","TooltipLabel",Color("382d24"))
 return t
static func tab_id(id:String)->String:
 return {"energy":"inventory","guidance":"commission","commissions_detail":"commission","festivals":"calendar","help":"settings","pause":"settings"}.get(id,id)
static func has_tabs(id:String)->bool:
 return id in ["inventory","equipment","disciplines","roster","recipes","commission","commissions_detail","guidance","wayfinding","calendar","festivals","energy","settings","pause","help"]
static func cycle_tab(g,direction:int):
 if not has_tabs(g.panel_id):return
 var ids=[]
 for entry in TABS:ids.append(entry[0])
 var index=ids.find(tab_id(g.panel_id));g.menu_history.clear();g.open_panel(ids[posmod(index+direction,ids.size())],false)
static func build_shell(g,id:String):
 var dialogue=id=="conversation"
 g.panel.set_meta("folio",true);g.panel.theme=book_theme()
 g.panel.position=Vector2(60,174) if dialogue else Vector2(40,24)
 g.panel.custom_minimum_size=Vector2.ZERO
 for child in g.panel.get_children():g.panel.remove_child(child);child.queue_free()
 g.panel.size=Vector2(840,342) if dialogue else Vector2(880,492)
 var outer=VBoxContainer.new();outer.add_theme_constant_override("separation",10);g.panel.add_child(outer)
 var top=row(outer);top.visible=not dialogue
 if not g.menu_history.is_empty():small_button(top,"‹ Back",g.back_panel)
 var names={"camera_controls":"Exploration · camera & controls","depth_map":"The mine · floors & routes","recipes":"Crafting recipes","inventory":"Your pack","equipment":"Weapons & armor","disciplines":"Skills & mastery","roster":"People of the hold","commission":"Quest journal","commissions_detail":"Ivar’s commissions","guidance":"Your first season","wayfinding":"Maps & directions","calendar":"The turning year","energy":"Meals, ale & rest","settings":"Sound & comfort","pause":"Take a breath","conversation":"A moment together","forge":"Borin’s workbench","market":"Orla’s exchange","research":"The survey office","architecture":"The building book","dev_testing":"Dev Testing · Separate save"}
 var names_legacy={"architecture":"THE HOLD’S BUILDING BOOK","architecture_details":"FURNITURE & ARCHITECTURE","architecture_plan":"CHOOSE YOUR BUILDING","architecture_style":"MATERIALS & FINISHES","dev_testing":"DEV TESTING · SEPARATE SAVE","hearth":"HEARTH & HOMESTEAD","fieldwork":"RIVER & ROOT","handworks":"HANDS OF THE DWARF","wayfinding":"PATHS & DOORWAYS","storage":"YOUR STORAGE CHEST","house_build":"BUILD YOUR HEARTH","homestead":"YOUR HOMESTEAD","living":"THE LIVING WORKS","haulage":"MATERIALS & HAULAGE","projects":"PROJECT LEDGER","deepworks":"THE DEEPWORKS","pinewood":"THE WOODCUTTER'S FIELD BOARD","build_status":"BUILD STATUS · WIP","guidance":"YOUR FIRST SEASON","lesson":"WORK & KNOWLEDGE","throne":"THE KING'S HALL","training":"BORIN'S PRACTICE BAY","conversation":"CONVERSATION","anniversary":"A QUIET WORD","social":"AROUND THE HOLD","ivar_welcome":"IVAR • YOUR FIRST SHIFT","settings":"SOUND & COMFORT","equipment":"WEAPONS & ARMOR","construction":"BUILD YOUR RETURN ROUTE","rescue":"EMERGENCY EXTRACTION","briefing":"BENEATH THE CROWN OF STONE","commission":"QUEST JOURNAL","charters":"A MOUNTAIN OF YOUR OWN","world_map":"THE KELDRATH BASIN","gate":"THE KELDRATH BASIN","camp":"YOUR FOUNDING CHARTER","home":"YOUR QUARTERS","tavern":"THE COPPER KETTLE","market":"ORLA'S EXCHANGE","forge":"BORIN'S FORGE","research":"THE SURVEY OFFICE","inventory":"YOUR PROSPECTOR'S PACK","manage":"YOUR OUTPOST & CREW","ship":"THE FIRST FORTUNE","pause":"TAKE A BREATH","field_notes":"FIELD NOTEBOOK","help":"A PROSPECTOR'S HANDBOOK","victory":"FROM PROSPECTOR TO CAPTAIN","save_slots":"YOUR FORTUNES • THREE SAVE SLOTS","new_confirm":"BEGIN ANOTHER FORTUNE?","roster":"FACES OF KELDRATH","visitor":"A FAMILIAR FACE"}
 for key in names_legacy:
  if not names.has(key):names[key]=names_legacy[key].capitalize()
 label(top,names.get(id,id.replace("_"," ").capitalize()),21,Color("edc98a"))
 var close=small_button(top,"×",g.close_panel);close.tooltip_text="Close menu · Esc";close.custom_minimum_size.x=34
 if g.playing and has_tabs(id):
  var nav=row(outer);nav.name="BookTabs";nav.add_theme_constant_override("separation",4)
  for entry in TABS:
   var tab=small_button(nav,entry[1],func():g.menu_history.clear();g.open_panel(entry[0],false));tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL;tab.toggle_mode=true;tab.button_pressed=tab_id(id)==entry[0];tab.alignment=HORIZONTAL_ALIGNMENT_CENTER
   tab.tooltip_text=entry[1]+(" · "+entry[2] if entry[2]!="" else "")+" · Page Up / Page Down switches tabs"
 var scroll=ScrollContainer.new();scroll.follow_focus=true;scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;outer.add_child(scroll);g.menu_scroll=scroll
 g.panel_body=VBoxContainer.new();g.panel_body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_theme_constant_override("separation",10);scroll.add_child(g.panel_body)
 g.menu_footer(outer)
