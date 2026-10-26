class_name HoldMenuView
extends RefCounted

# Presentation only. Game session, purchases and panel navigation remain on the host.
static func button(parent:Node,label:String,callback:Callable)->Button:
 var b=Button.new();b.text=label;b.custom_minimum_size.y=42;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.size_flags_vertical=Control.SIZE_SHRINK_CENTER;b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;parent.add_child(b);b.pressed.connect(callback);return b

static func label(parent:Node,s:String,size:int=15,color:Color=Color("e6e8e2"))->Label:
 var l=Label.new();l.text=s;l.add_theme_font_size_override("font_size",maxi(16,size));l.add_theme_color_override("font_color",color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size_flags_horizontal=Control.SIZE_EXPAND_FILL;parent.add_child(l);return l

static func row(parent:Node)->HBoxContainer:
 var r=HBoxContainer.new();r.add_theme_constant_override("separation",8);parent.add_child(r);return r

static func small_button(parent:Node,text:String,fn:Callable)->Button:
 var b=button(parent,text,fn);b.custom_minimum_size.y=30;b.add_theme_font_size_override("font_size",14)
 for style_name in ["normal","hover","pressed","disabled"]:
  var style=b.get_theme_stylebox(style_name).duplicate();style.set_content_margin_all(7);b.add_theme_stylebox_override(style_name,style)
 return b

static func section(parent:Node,title:String)->VBoxContainer:
 var box=PanelContainer.new();var style=StyleBoxFlat.new();style.bg_color=Color("1d3540");style.set_content_margin_all(12);style.set_corner_radius_all(4);box.add_theme_stylebox_override("panel",style);parent.add_child(box)
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

static func build_shell(g,id:String):
 g.panel.position=Vector2(120,44) if id=="living" else Vector2(60,44)
 g.panel.custom_minimum_size=Vector2.ZERO
 for child in g.panel.get_children():g.panel.remove_child(child);child.queue_free()
 g.panel.size=Vector2(720,452) if id=="living" else Vector2(840,452)
 var outer=VBoxContainer.new();outer.add_theme_constant_override("separation",9);g.panel.add_child(outer)
 var top=row(outer)
 if not g.menu_history.is_empty():small_button(top,"‹ Back",g.back_panel)
 var names={"architecture":"THE HOLD’S BUILDING BOOK","architecture_details":"FURNITURE & ARCHITECTURE","architecture_plan":"CHOOSE YOUR BUILDING","architecture_style":"MATERIALS & FINISHES","dev_testing":"DEV TESTING · SEPARATE SAVE","hearth":"HEARTH & HOMESTEAD","fieldwork":"RIVER & ROOT","handworks":"HANDS OF THE DWARF","wayfinding":"PATHS & DOORWAYS","storage":"YOUR STORAGE CHEST","house_build":"BUILD YOUR HEARTH","homestead":"YOUR HOMESTEAD","living":"THE LIVING WORKS","haulage":"MATERIALS & HAULAGE","projects":"PROJECT LEDGER","deepworks":"THE DEEPWORKS","pinewood":"THE WOODCUTTER'S FIELD BOARD","build_status":"BUILD STATUS · WIP","guidance":"YOUR FIRST SEASON","lesson":"WORK & KNOWLEDGE","throne":"THE KING'S HALL","training":"BORIN'S PRACTICE BAY","conversation":"CONVERSATION","anniversary":"A QUIET WORD","social":"AROUND THE HOLD","ivar_welcome":"IVAR • YOUR FIRST SHIFT","settings":"SOUND & COMFORT","equipment":"WEAPONS & ARMOR","construction":"BUILD YOUR RETURN ROUTE","rescue":"EMERGENCY EXTRACTION","briefing":"BENEATH THE CROWN OF STONE","commission":"QUEST JOURNAL","charters":"A MOUNTAIN OF YOUR OWN","world_map":"THE KELDRATH BASIN","gate":"THE KELDRATH BASIN","camp":"YOUR FOUNDING CHARTER","home":"YOUR QUARTERS","tavern":"THE COPPER KETTLE","market":"ORLA'S EXCHANGE","forge":"BORIN'S FORGE","research":"THE SURVEY OFFICE","inventory":"YOUR PROSPECTOR'S PACK","manage":"YOUR OUTPOST & CREW","ship":"THE FIRST FORTUNE","pause":"TAKE A BREATH","field_notes":"FIELD NOTEBOOK","help":"A PROSPECTOR'S HANDBOOK","victory":"FROM PROSPECTOR TO CAPTAIN","save_slots":"YOUR FORTUNES • THREE SAVE SLOTS","new_confirm":"BEGIN ANOTHER FORTUNE?","roster":"FACES OF KELDRATH","visitor":"A FAMILIAR FACE"}
 names["disciplines"]="Disciplines"
 label(top,names.get(id,"Claim business" if id=="claim_stories" else id).capitalize(),22,Color("e9c586"))
 var close=small_button(top,"×",g.close_panel);close.tooltip_text="Close menu · Esc";close.custom_minimum_size.x=36
 if g.playing and id not in ["architecture","architecture_details","architecture_plan","architecture_style","house_build","dev_testing","fieldwork","handworks","living","haulage","projects","deepworks","briefing","new_confirm","rescue","victory","ivar_welcome","world_map","basin_map","gate","conversation","anniversary","lesson","social","build_status","claim_stories","field_notes","pinewood"]:
  var nav=row(outer)
  for entry in [["commission","Journal · J"],["inventory","Pack · I"],["equipment","Gear · B"],["disciplines","Skills · Y"],["roster","People · N"],["wayfinding","Directions · G"],["help","Guide · F1"]]:
   var tab=small_button(nav,entry[1],func():g.menu_history.clear();g.open_panel(entry[0],false));tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL;tab.toggle_mode=true;tab.button_pressed=id==entry[0] or (id=="guidance" and entry[0]=="commission");tab.alignment=HORIZONTAL_ALIGNMENT_CENTER
   tab.tooltip_text="Open "+entry[1].split(" · ")[0]
 var scroll=ScrollContainer.new();scroll.follow_focus=true;scroll.custom_minimum_size.y=0;scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;outer.add_child(scroll);g.menu_scroll=scroll
 g.panel_body=VBoxContainer.new();g.panel_body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_theme_constant_override("separation",6 if id in ["commission","lesson","social"] else 9);scroll.add_child(g.panel_body)
 g.menu_footer(outer)
