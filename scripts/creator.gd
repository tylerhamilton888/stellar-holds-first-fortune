class_name HoldCreator
extends Control
signal accepted(profile:Dictionary)
signal cancelled
var profile=HoldAppearance.defaults()
var portrait:HoldPortrait
var sprite:HoldSpritePreview
var name_input:LineEdit
var family_input:LineEdit
var summary:Label
var form:VBoxContainer
var picks:Dictionary={}
var creating=true
var option_page=0
var page_buttons:Array[Button]=[]
func _ready():
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var shade=ColorRect.new();shade.color=Color("0b1c28");shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(shade)
 var title=Label.new();title.text="FORGE YOUR IDENTITY";title.add_theme_font_override("font",load("res://assets/HoldRunic.ttf"));title.position=Vector2(30,18);title.add_theme_font_size_override("font_size",27);title.modulate=Color("efd2a0");add_child(title)
 var sub=Label.new();sub.text="Every great hold begins with someone worth remembering.";sub.position=Vector2(32,53);sub.add_theme_font_size_override("font_size",16);sub.modulate=Color("9dc9bf");add_child(sub)
 var left=PanelContainer.new();left.position=Vector2(30,86);left.size=Vector2(326,362);add_child(left)
 var holder=Control.new();left.add_child(holder)
 portrait=HoldPortrait.new();portrait.position=Vector2(44,2);portrait.size=Vector2(208,208);portrait.profile=profile;holder.add_child(portrait)
 sprite=HoldSpritePreview.new();sprite.position=Vector2(184,235);sprite.size=Vector2(96,96);sprite.profile=profile;holder.add_child(sprite)
 summary=Label.new();summary.position=Vector2(7,216);summary.size=Vector2(174,75);summary.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;summary.add_theme_font_size_override("font_size",14);holder.add_child(summary)
 var walk=Button.new();walk.text="Preview: walking";walk.position=Vector2(4,313);walk.size=Vector2(158,28);walk.add_theme_font_size_override("font_size",14);compact_button(walk);holder.add_child(walk)
 walk.pressed.connect(func():sprite.motion="work" if sprite.motion=="walk" else "walk";walk.text="Preview: working" if sprite.motion=="work" else "Preview: walking")
 var baseline=Button.new();baseline.text="Baseline look";baseline.position=Vector2(4,278);baseline.size=Vector2(158,28);baseline.add_theme_font_size_override("font_size",14);compact_button(baseline);holder.add_child(baseline)
 baseline.pressed.connect(func():
  var defaults=HoldAppearance.defaults()
  for key in ["skin","hair_color","beard_color","cloth_color","outfit","tattoo","jewelry"]:profile[key]=defaults[key]
  profile.sculpt=0
  profile.hair_style=1 if profile.gender==1 else 0
  profile.beard_style=5 if profile.gender==1 else 0
  rebuild_options();update_preview())
 var area=PanelContainer.new();area.position=Vector2(373,86);area.size=Vector2(557,362);add_child(area)
 var outer=VBoxContainer.new();outer.add_theme_constant_override("separation",8);area.add_child(outer)
 var nr=HBoxContainer.new();outer.add_child(nr)
 nr.add_theme_constant_override("separation",6)
 for field in ["first_name","family_name"]:
  var nl=Label.new();nl.text="GIVEN" if field=="first_name" else "FAMILY";nl.add_theme_font_size_override("font_size",14);nr.add_child(nl)
  var input=LineEdit.new();input.text=profile[field];input.max_length=20 if field=="first_name" else 24;input.custom_minimum_size=Vector2(192,34);input.size_flags_horizontal=Control.SIZE_EXPAND_FILL;nr.add_child(input)
  input.add_theme_font_size_override("font_size",16)
  var style=StyleBoxFlat.new();style.bg_color=Color("0f2530");style.border_color=Color("c6a365");style.set_border_width_all(1);style.set_content_margin_all(6);input.add_theme_stylebox_override("normal",style)
  if field=="first_name":name_input=input
  else:
   family_input=input;input.editable=creating;input.tooltip_text="Your family name, kept separate from your given name." if not creating else "Your family name. What your descendants make of it is still unwritten."
  input.text_changed.connect(func(text):profile[field]=text;profile=HoldAppearance.normalized(profile);update_preview())
 var tabs=HBoxContainer.new();tabs.add_theme_constant_override("separation",8);outer.add_child(tabs)
 for page in 2:
  var tab=Button.new();tab.text=["Design & colors","Markings & details"][page];tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL;tab.custom_minimum_size.y=30;compact_button(tab);tabs.add_child(tab);page_buttons.append(tab)
  tab.pressed.connect(func():option_page=page;rebuild_options())
 form=VBoxContainer.new();form.size_flags_horizontal=Control.SIZE_EXPAND_FILL;form.add_theme_constant_override("separation",2);outer.add_child(form)
 rebuild_options()
 var spacer=Control.new();spacer.size_flags_vertical=Control.SIZE_EXPAND_FILL;outer.add_child(spacer)
 var buttons=HBoxContainer.new();buttons.position=Vector2(30,469);buttons.size=Vector2(900,43);buttons.add_theme_constant_override("separation",12);add_child(buttons)
 add_button(buttons,"Randomize look",func():
  var keep_name=name_input.text;var keep_family=family_input.text
  profile=HoldAppearance.random_profile(randi(),int(profile.gender));profile.first_name=keep_name;profile.family_name=keep_family;rebuild_options();update_preview())
 add_button(buttons,"Suggest name",func():
  var suggested=HoldAppearance.random_profile(randi(),int(profile.gender))
  profile.first_name=suggested.first_name
  if creating:profile.family_name=suggested.family_name
  profile=HoldAppearance.normalized(profile);name_input.text=profile.first_name;family_input.text=profile.family_name;update_preview())
 add_button(buttons,"Cancel",func():cancelled.emit())
 var accept=add_button(buttons,"Begin your fortune" if creating else "Keep this look",func():
  profile.first_name=name_input.text.strip_edges();profile.family_name=family_input.text.strip_edges()
  if profile.first_name=="":name_input.grab_focus();name_input.placeholder_text="Given name";return
  if profile.family_name=="":family_input.grab_focus();family_input.placeholder_text="Family name";return
  accepted.emit(HoldAppearance.normalized(profile)))
 accept.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 update_preview()
func add_button(parent:Node,text:String,fn:Callable)->Button:
 var b=Button.new();b.text=text;b.custom_minimum_size.y=40;parent.add_child(b);b.pressed.connect(fn);return b
func rebuild_options():
 profile=HoldAppearance.normalized(profile)
 for child in form.get_children():form.remove_child(child);child.queue_free()
 picks.clear()
 for i in page_buttons.size():page_buttons[i].disabled=i==option_page
 if option_page==0:
  option("gender","Character",["Male dwarf","Female dwarf"])
  option("skin","Complexion",HoldAppearance.SKIN_NAMES)
  option("sculpt","Dwarf design",HoldAppearance.FEMALE_SCULPTS if profile.gender==1 else HoldAppearance.SCULPTS)
  option("hair_color","Hair & beard" if profile.gender==0 else "Hair color",HoldAppearance.HAIR_NAMES,HoldAppearance.HAIR_COLORS)
 else:
  option("tattoo","Runic tattoo",HoldAppearance.TATTOOS)
  option("jewelry","Fittings",HoldAppearance.JEWELRY)
  var note=Label.new();note.text="Choose your starting look here.\nEquip weapons and armor through Gear [B] in the world.";note.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;note.add_theme_font_size_override("font_size",16);note.modulate=Color("bbc9ca");form.add_child(note)
func compact_button(button:Button):
 button.add_theme_color_override("font_disabled_color",Color("efd2a0"))
 for state in ["normal","hover","pressed","disabled","focus"]:
  var style=StyleBoxFlat.new();style.bg_color=Color("203a46") if state!="disabled" else Color("38565b")
  if state=="hover":style.bg_color=Color("2c4c59")
  if state=="pressed":style.bg_color=Color("40646b")
  if state=="focus":style.bg_color=Color.TRANSPARENT;style.border_color=Color("9d8555");style.set_border_width_all(1);style.set_content_margin_all(4)
  style.set_content_margin_all(4)
  button.add_theme_stylebox_override(state,style)
func option(key:String,title:String,choices:Array,colors:Array=[]):
 var r=HBoxContainer.new();r.add_theme_constant_override("separation",6);form.add_child(r)
 var l=Label.new();l.text=title;l.custom_minimum_size.x=140;l.add_theme_font_size_override("font_size",16);r.add_child(l)
 var left=Button.new();left.text="<";left.custom_minimum_size=Vector2(35,31);compact_button(left);r.add_child(left)
 var value=Button.new();value.text=str(choices[int(profile[key])]);value.custom_minimum_size=Vector2(257,31);value.add_theme_font_size_override("font_size",16);compact_button(value);r.add_child(value)
 if not colors.is_empty():
  var color=ColorRect.new();color.custom_minimum_size=Vector2(17,17);color.color=Color(colors[int(profile[key])]);color.mouse_filter=Control.MOUSE_FILTER_IGNORE;r.add_child(color)
 var right=Button.new();right.text=">";right.custom_minimum_size=Vector2(35,31);compact_button(right);r.add_child(right)
 var change=func(delta:int):
  profile[key]=posmod(int(profile[key])+delta,choices.size())
  if key=="gender" and profile.gender==1:profile.beard_style=5
  if key=="gender" and profile.gender==0 and profile.beard_style==5:profile.beard_style=0
  rebuild_options();update_preview()
 left.pressed.connect(change.bind(-1));right.pressed.connect(change.bind(1));value.pressed.connect(change.bind(1))
 picks[key]=value
func update_preview():
 if not is_instance_valid(portrait):return
 portrait.apply_profile(profile);sprite.profile=HoldAppearance.normalized(profile)
 summary.text=profile.first_name+"\n"+profile.family_name
func _unhandled_key_input(event):
 if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:cancelled.emit();get_viewport().set_input_as_handled()
