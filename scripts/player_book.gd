class_name HoldPlayerBook
extends RefCounted
# Presentation over existing pack, hotbar and people records. No parallel inventory.
static func inventory(g):
 var bar=g.row(g.panel_body)
 g.label(bar,"Carried supplies",19)
 var search=LineEdit.new();search.name="PackSearch";search.placeholder_text="Find an item…";search.clear_button_enabled=true;search.custom_minimum_size=Vector2(205,32);bar.add_child(search)
 var filter=g.small_button(bar,"All materials" if g.inventory_owned_only else "Carried only",func():g.inventory_owned_only=not g.inventory_owned_only;g.refresh_panel())
 filter.tooltip_text="Include materials you do not currently carry" if g.inventory_owned_only else "Show only items in your pack"
 var layout=g.row(g.panel_body);layout.add_theme_constant_override("separation",18)
 var left=VBoxContainer.new();left.size_flags_horizontal=Control.SIZE_EXPAND_FILL;layout.add_child(left)
 var grid=GridContainer.new();grid.name="PackGrid";grid.columns=10;grid.add_theme_constant_override("h_separation",5);grid.add_theme_constant_override("v_separation",5);left.add_child(grid)
 var details=g.section(layout,"");details.get_parent().custom_minimum_size.x=235;details.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
 var cards=[]
 var show_item=func(id:String):
  g.pack_selection=id
  for child in details.get_children():details.remove_child(child);child.queue_free()
  var head=g.row(details);HoldItemArt.icon(head,id);g.label(head,HoldData.ITEMS[id].name,20)
  g.label(details,"%d in your pack" % g.state.count(id),18)
  g.label(details,"Pin to quick bar",16)
  var pins=g.row(details)
  for slot in range(5,10):
   var pin=g.small_button(pins,str((slot+1)%10),func():g.hotbar.assign(id,slot));pin.tooltip_text="Pin "+HoldData.ITEMS[id].name+" to slot "+str((slot+1)%10)
  g.small_button(details,"Meals, ale & rest",func():g.open_panel("energy"))
  for card in cards:card.node.button_pressed=card.id==id
 for id in HoldData.ITEMS:
  if g.inventory_owned_only and g.state.count(id)==0:continue
  var b=Button.new();b.name="Item_"+id;b.custom_minimum_size=Vector2(46,46);b.toggle_mode=true;b.tooltip_text=HoldData.ITEMS[id].name+" · "+str(g.state.count(id))+" carried";b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;grid.add_child(b)
  HoldItemArt.icon(b,id);var icon=b.get_child(0);icon.position=Vector2(8,3);icon.size=Vector2(30,30);icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
  var amount=Label.new();amount.text=str(g.state.count(id));amount.add_theme_font_size_override("font_size",13);amount.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT;amount.position=Vector2(2,28);amount.size=Vector2(40,17);amount.mouse_filter=Control.MOUSE_FILTER_IGNORE;b.add_child(amount)
  cards.append({"node":b,"id":id,"name":str(HoldData.ITEMS[id].name).to_lower()})
  b.pressed.connect(func():show_item.call(id))
 var empty=g.label(left,"Your pack is empty. Gather materials or withdraw supplies from storage.",16);empty.visible=cards.is_empty()
 search.text_changed.connect(func(query):
  var visible_count=0
  for card in cards:
   card.node.visible=query.strip_edges().to_lower() in card.name
   if card.node.visible:visible_count+=1
  empty.text="No matching items.";empty.visible=visible_count==0)
 if not cards.is_empty():show_item.call(g.pack_selection if cards.any(func(c):return c.id==g.pack_selection) else cards[0].id)
 else:g.label(details,"Select an item to inspect it or pin it to your quick bar.",16)
 var rule=HSeparator.new();g.panel_body.add_child(rule)
 var summary=g.row(g.panel_body)
 var portrait=HoldPortrait.new();portrait.profile=g.state.appearance;portrait.custom_minimum_size=Vector2(48,48);summary.add_child(portrait)
 var name=VBoxContainer.new();name.size_flags_horizontal=Control.SIZE_EXPAND_FILL;summary.add_child(name)
 g.label(name,g.state.appearance.name,18);g.label(name,"%d crowns · %s" % [g.state.money,HoldCalendar.date(int(HoldCalendar.data(g.state).day))],14)
 var shortcuts=HBoxContainer.new();summary.add_child(shortcuts)
 g.small_button(shortcuts,"Weapons & armor",func():g.open_panel("equipment"))
 g.small_button(shortcuts,"Tools & quick bar",func():g.open_panel("help"))

static func people(g):
 var search=LineEdit.new();search.placeholder_text="Find someone…";search.clear_button_enabled=true;search.custom_minimum_size.y=32;g.panel_body.add_child(search)
 var records=HoldPeople.records(g.state);var ids=[]
 for id in HoldAppearance.NPC_NAMES:
  if id=="eirik" and HoldOnboarding.ensure(g.state).fresh and HoldOnboarding.stage(g.state)<4:continue
  ids.append(id)
 for id in records:
  if not ids.has(id):ids.append(id)
 for id in HoldOutpost.candidate_ids(g.state):
  if not ids.has(id):ids.append(id)
 for i in 3:
  var id="visitor_"+str(i)
  if not ids.has(id):ids.append(id)
 var rows=[]
 for id in ids:
  var card=g.section(g.panel_body,"");rows.append({"node":card.get_parent(),"name":str(g.state.npc(id).name).to_lower()})
  var row=g.row(card);row.add_theme_constant_override("separation",14)
  var portrait=HoldRoyalHall.portrait() if id=="eirik" else HoldPortrait.new()
  if id!="eirik":portrait.profile=g.state.npc(id)
  portrait.custom_minimum_size=Vector2(64,64);row.add_child(portrait)
  var body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;row.add_child(body)
  g.label(body,g.state.npc(id).name,18);g.label(body,HoldPeople.role(g.state,id),14)
  var status=HoldQuestMarkers.status(g.state,id)
  if status!="":g.label(body,HoldQuestMarkers.caption(status),14,Color("edc98a"))
  if not HoldPeople.background(id):g.label(body,g.npc_where(id).label,14)
  if records.has(id):
   var d=records[id];var progress=ProgressBar.new();progress.max_value=20;progress.value=d.bond;progress.show_percentage=false;progress.custom_minimum_size=Vector2(160,9);progress.tooltip_text=HoldPeople.level(d);body.add_child(progress)
   g.label(body,HoldPeople.level(d)+" · "+d.last,14)
   if d.known:g.label(body,"Likes "+HoldData.ITEMS[d.persona.like].name.to_lower()+" · Dislikes "+HoldData.ITEMS[d.persona.dislike].name.to_lower(),14)
  else:g.label(body,"Not yet acquainted",14)
  var actions=VBoxContainer.new();actions.custom_minimum_size.x=145;row.add_child(actions)
  if HoldConversation.local(g,id):g.small_button(actions,"Talk",func():HoldConversation.start(g,id))
  if not HoldPeople.background(id):g.small_button(actions,"Track location" if g.state.tracked_npc!=id else "Stop tracking",func():g.state.tracked_npc=id if g.state.tracked_npc!=id else "";g.save_game();g.close_panel())
  elif HoldRoadCharacters.CAST.has(id):g.label(actions,HoldRoadCharacters.whereabouts(id),14)
 search.text_changed.connect(func(query):
  for row in rows:row.node.visible=query.strip_edges().to_lower() in row.name)

static func recipes(g):
 g.label(g.panel_body,"Select a recipe. Make it at a forge or kitchen.",16)
 var layout=g.row(g.panel_body);layout.add_theme_constant_override("separation",18)
 var grid=GridContainer.new();grid.columns=7;grid.add_theme_constant_override("h_separation",6);grid.add_theme_constant_override("v_separation",6);layout.add_child(grid)
 var detail=g.section(layout,"");detail.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL;detail.get_parent().custom_minimum_size.x=300
 var buttons={}
 var select=func(id:String):
  g.recipe_selection=id
  for child in detail.get_children():detail.remove_child(child);child.queue_free()
  var recipe=HoldData.RECIPES[id]
  var head=g.row(detail);HoldItemArt.icon(head,recipe.out.keys()[0]);g.label(head,recipe.name,19)
  g.label(detail,"Makes "+HoldData.cost_text(recipe.out),15)
  for item in recipe.cost:
   var row=g.row(detail);HoldItemArt.icon(row,item);g.label(row,"%s · %d / %d" % [HoldData.ITEMS[item].name,g.state.count(item),recipe.cost[item]],14)
  var unlocked=recipe.tech=="" or g.state.tech.has(recipe.tech)
  g.label(detail,("Materials ready" if g.state.afford(recipe.cost) else "Gather the missing materials") if unlocked else "Research "+HoldData.RESEARCH[recipe.tech].name,15)
  g.label(detail,"%d seconds per batch at a workstation" % recipe.time,14)
  for key in buttons:buttons[key].button_pressed=key==id
 for id in HoldData.RECIPES:
  var recipe=HoldData.RECIPES[id];var b=Button.new();b.custom_minimum_size=Vector2(58,58);b.toggle_mode=true;b.tooltip_text=recipe.name;grid.add_child(b);buttons[id]=b
  HoldItemArt.icon(b,recipe.out.keys()[0]);var icon=b.get_child(0);icon.position=Vector2(10,7);icon.size=Vector2(38,38);icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
  if recipe.tech!="" and not g.state.tech.has(recipe.tech):icon.modulate.a=.45;b.tooltip_text+=" · Research required"
  b.pressed.connect(func():select.call(id))
 select.call(g.recipe_selection if HoldData.RECIPES.has(g.recipe_selection) else HoldData.RECIPES.keys()[0])
 if g.room_id=="forge":g.button(g.panel_body,"Use this forge",func():g.open_panel("forge"))
 else:g.small_button(g.panel_body,"Find Borin’s forge",func():g.state.tracked_npc="borin";g.save_game();g.close_panel())
