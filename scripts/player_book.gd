class_name HoldPlayerBook
extends RefCounted
# Presentation over existing pack, hotbar and people records. No parallel inventory.
const GROUPS={
 "Seeds":["barley_seed","carrot_seed","hearthcap_seed","turnip_seed"],
 "Provisions":["food","water","hold_ale","barley","carrot","hearthcap","turnip","pond_perch","river_fish","silver_char","root_hotpot","barley_bread","fish_chowder","char_plate"],
 "Stone & timber":["stone","rough_block","dressed_stone","basalt_block","dressed_basalt","wood"],
 "Ore & metal":["iron_ore","copper_ore","coal","iron","copper","iron_slag","copper_slag","scrap","shell","crystal"],
 "Workshop goods":["energy_cell","ammo","parts","assembly","shaped_haft","forged_pickhead","tool_fittings","hearthknot"]}
const USES={
 "energy_cell":"Fuel for powered workshop machinery.","ammo":"Cartridges for the slagcaster.",
 "stone":"Use loose stone for building or work it into dressed stone.","rough_block":"A roughly squared block from the stonebreaker.",
 "dressed_stone":"Cut masonry for public works and stone construction.","wood":"Building timber for structures, furnishings and tool handles.",
 "iron_ore":"Smelt it with coal to make iron ingots.","copper_ore":"Smelt it with coal to make copper ingots.",
 "coal":"Fuel for smelting. Borin’s cold forge also needs a supply.","iron":"Stock for smithing tools and machine parts.","copper":"Stock for tool fittings, machinery and inlay.",
 "basalt_block":"A block cut from the deeper basalt beds.","dressed_basalt":"Finished dark masonry from a basalt block.",
 "shell":"Smelt carapace with coal to recover iron.","scrap":"Refine it with coal to reclaim iron and copper.",
 "iron_slag":"Iron-bearing residue from metalwork.","copper_slag":"Copper-bearing residue from metalwork.",
 "shaped_haft":"The wooden handle for a reinforced pick.","forged_pickhead":"The working head for a reinforced pick.","tool_fittings":"The hardware that joins a reinforced pickhead to its haft.",
 "crystal":"Aether crystal used in machinery and energy cells.","parts":"Precision components for machinery.","assembly":"A finished drive for ship construction.",
 "hold_ale":"Drink to reduce work energy costs by 5% for five minutes.","water":"Used in cooking, brewing and stonework.",
 "hearthcap":"An edible mushroom used in stews.","river_fish":"A catch from freshwater fishing.","pond_perch":"A golden freshwater fish.","silver_char":"A fish used in char with roasted roots.",
 "barley":"Grain for baking and brewing.","carrot":"A sweet root used in the kitchen.","turnip":"A root vegetable for hotpot and other meals."}

static func item_group(id:String)->String:
 for group in GROUPS:
  if id in GROUPS[group]:return group
 return "Other"

static func item_use(id:String)->String:
 if HoldData.ITEMS[id].has("desc"):return HoldData.ITEMS[id].desc
 if id.ends_with("_seed"):return "Plant in a prepared bed and water it to grow "+HoldData.ITEMS[id.trim_suffix("_seed")].name.to_lower()+"."
 if id in HoldWorkEnergy.MEALS:return "Eat to recover work energy. Meals are available from the energy menu."
 return USES.get(id,HoldData.ITEMS[id].name)

static func clear_children(container:Control):
 for child in container.get_children():container.remove_child(child);child.queue_free()

static func inventory(g):
 var bar=g.row(g.panel_body)
 var ownership=OptionButton.new();ownership.name="PackScope";ownership.add_item("Carried items");ownership.add_item("Item catalogue");bar.add_child(ownership)
 ownership.select(0 if g.inventory_owned_only else 1)
 var category=OptionButton.new();category.name="PackCategory";category.add_item("All categories")
 for group in GROUPS:category.add_item(group)
 category.select(int(g.get_meta("pack_category",0)));bar.add_child(category)
 var search=LineEdit.new();search.name="PackSearch";search.placeholder_text="Search items…";search.clear_button_enabled=true
 search.size_flags_horizontal=Control.SIZE_EXPAND_FILL;search.text=str(g.get_meta("pack_query",""));bar.add_child(search)
 var layout=g.row(g.panel_body);layout.add_theme_constant_override("separation",14)
 var left=VBoxContainer.new();left.custom_minimum_size.x=465;layout.add_child(left)
 var pack_scroll=ScrollContainer.new();pack_scroll.name="PackScroll";pack_scroll.follow_focus=true;pack_scroll.custom_minimum_size.y=183
 pack_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;left.add_child(pack_scroll)
 var grid=GridContainer.new();grid.name="PackGrid";grid.columns=8;grid.add_theme_constant_override("h_separation",4);grid.add_theme_constant_override("v_separation",4);pack_scroll.add_child(grid)
 var empty=g.label(left,"",15)
 var details=g.section(layout,"");details.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
 var cards=[]
 var show_item=func(id:String):
  g.pack_selection=id;clear_children(details)
  for card in cards:card.node.button_pressed=card.id==id
  if id=="":
   g.label(details,"Item details",19);g.label(details,"Choose a visible item to inspect it.",15);return
  var head=g.row(details);HoldItemArt.icon(head,id);head.get_child(0).custom_minimum_size=Vector2(48,48)
  var words=VBoxContainer.new();words.size_flags_horizontal=Control.SIZE_EXPAND_FILL;head.add_child(words)
  g.label(words,HoldData.ITEMS[id].name,19);g.label(words,"%s  ·  %d carried" % [item_group(id),g.state.count(id)],14)
  g.label(details,item_use(id),15)
  var pins=g.row(details);g.label(pins,"Quick bar",14)
  for slot in range(5,10):
   var pin=g.small_button(pins,str((slot+1)%10),func():g.hotbar.assign(id,slot))
   pin.tooltip_text="Assign %s to slot %d" % [HoldData.ITEMS[id].name,(slot+1)%10]
  if id in HoldWorkEnergy.MEALS or id=="hold_ale":g.small_button(details,"Meals & energy",func():g.open_panel("energy"))
  var selected=grid.get_node_or_null("Item_"+id)
  if selected!=null:pack_scroll.call_deferred("ensure_control_visible",selected)
 var ids=HoldData.ITEMS.keys()
 ids.sort_custom(func(a,b):return str(HoldData.ITEMS[a].name).naturalnocasecmp_to(HoldData.ITEMS[b].name)<0)
 for id in ids:
  var count=g.state.count(id);var b=Button.new();b.name="Item_"+id;b.custom_minimum_size=Vector2(52,48);b.toggle_mode=true
  b.tooltip_text=HoldData.ITEMS[id].name+" · "+str(count)+" carried";b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;grid.add_child(b)
  for spec in [["normal","30443f","53675b"],["hover","496255","d0ad70"],["pressed","536e59","d9ab55"],["hover_pressed","536e59","e8c17a"]]:
   var style=HoldMenuView.paper_style(spec[1],spec[2],2 if spec[0] in ["pressed","hover_pressed"] else 1);style.set_content_margin_all(0);b.add_theme_stylebox_override(spec[0],style)
  HoldItemArt.icon(b,id);var icon=b.get_child(0);icon.position=Vector2(6,3);icon.size=Vector2(37,37);icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
  var amount=Label.new();amount.text=str(count);amount.add_theme_font_size_override("font_size",13);amount.add_theme_color_override("font_color",Color("fff6dc"));amount.add_theme_color_override("font_outline_color",Color("182622"));amount.add_theme_constant_override("outline_size",4)
  amount.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT;amount.position=Vector2(0,27);amount.size=Vector2(48,18);amount.mouse_filter=Control.MOUSE_FILTER_IGNORE;b.add_child(amount)
  if count==0:icon.modulate.a=.66
  cards.append({"node":b,"id":id,"title":str(HoldData.ITEMS[id].name).to_lower(),"group":item_group(id),"count":count})
  b.pressed.connect(func():show_item.call(id))
 var apply=func():
  var match_id="";var keep=false;var query=search.text.strip_edges().to_lower()
  g.set_meta("pack_query",search.text);g.set_meta("pack_category",category.selected)
  for card in cards:
   card.node.visible=(not g.inventory_owned_only or card.count>0) and (category.selected==0 or category.get_item_text(category.selected)==card.group) and (query.is_empty() or card.title.contains(query))
   if card.node.visible:
    if match_id=="":match_id=card.id
    if card.id==g.pack_selection:keep=true
  pack_scroll.visible=match_id!="";empty.visible=match_id=="";empty.text="No items match. Try another category or clear the search." if query!="" or category.selected>0 else "Your pack is empty. Switch to the item catalogue to browse supplies."
  show_item.call(g.pack_selection if keep else match_id)
 search.text_changed.connect(func(_query):apply.call())
 category.item_selected.connect(func(_index):apply.call())
 ownership.item_selected.connect(func(index):g.inventory_owned_only=index==0;apply.call())
 apply.call()
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
   if HoldCourtship101.ARCS.has(id):
    g.label(body,HoldCourtship101.status(g.state,id),14)
    if int(g.state.surface.get("courtship101",{}).get(id,{}).get("stage",0))==1:g.label(body,"More time together becomes available on later days; there is no penalty for waiting.",14)
   if d.known:g.label(body,"Likes "+HoldData.ITEMS[d.persona.like].name.to_lower()+" · Dislikes "+HoldData.ITEMS[d.persona.dislike].name.to_lower(),14)
  else:g.label(body,"Not yet acquainted",14)
  HoldFriendship130.notebook(g,id,body)
  var actions=VBoxContainer.new();actions.custom_minimum_size.x=145;row.add_child(actions)
  if HoldConversation.local(g,id):g.small_button(actions,"Talk",func():HoldConversation.start(g,id))
  if not HoldPeople.background(id):g.small_button(actions,"Track location" if g.state.tracked_npc!=id else "Stop tracking",func():g.state.tracked_npc=id if g.state.tracked_npc!=id else "";g.save_game();g.close_panel())
  elif HoldRoadCharacters.CAST.has(id):g.label(actions,HoldRoadCharacters.whereabouts(id,g.state),14)
 search.text_changed.connect(func(query):
  for row in rows:row.node.visible=query.strip_edges().to_lower() in row.name)

static func recipes(g):

 var layout=g.row(g.panel_body);layout.add_theme_constant_override("separation",18)
 var scroller=ScrollContainer.new();scroller.name="RecipeList";scroller.custom_minimum_size=Vector2(350,231);scroller.follow_focus=true;scroller.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;layout.add_child(scroller)
 var grid=VBoxContainer.new();grid.size_flags_horizontal=Control.SIZE_EXPAND_FILL;scroller.add_child(grid)
 var detail=g.section(layout,"");detail.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL;detail.get_parent().custom_minimum_size.x=300
 var buttons={}
 var select=func(id:String):
  g.recipe_selection=id
  for child in detail.get_children():detail.remove_child(child);child.queue_free()
  var recipe=HoldData.RECIPES[id]
  var head=g.row(detail);HoldItemArt.icon(head,recipe.out.keys()[0]);g.label(head,recipe.name,19)
  g.label(detail,"Makes "+HoldData.cost_text(recipe.out),15)
  if id in HoldForge147.COMPONENTS:g.label(detail,"Reinforced-pick component · make at the communal workshop or buy at the market.",14)
  for item in recipe.cost:
   var row=g.row(detail);HoldItemArt.icon(row,item);g.label(row,"%s · %d / %d%s" % [HoldData.ITEMS[item].name,g.state.count(item),recipe.cost[item]," · need %d more" % (recipe.cost[item]-g.state.count(item)) if g.state.count(item)<recipe.cost[item] else ""],14)
  var locked_reason=HoldCollections141.recipe_reason(g.state,id)
  var unlocked=locked_reason==""
  g.label(detail,("Materials ready" if g.state.afford(recipe.cost) else "Gather the missing materials") if unlocked else locked_reason,15)
  g.label(detail,"%d seconds per batch at a workstation" % recipe.time,14)
  for key in buttons:buttons[key].button_pressed=key==id
 for id in HoldData.RECIPES:
  if HoldCollections141.recipe_reason(g.state,id)!="":continue
  var recipe=HoldData.RECIPES[id];var b=g.small_button(grid,recipe.name,func():select.call(id));b.toggle_mode=true;b.tooltip_text=recipe.name;buttons[id]=b
  HoldItemArt.icon(b,recipe.out.keys()[0]);var art=b.get_child(0);b.icon=art.texture;b.expand_icon=true;b.add_theme_constant_override("icon_max_width",27);b.custom_minimum_size.y=36;b.remove_child(art);art.queue_free()
 if not buttons.is_empty():select.call(g.recipe_selection if buttons.has(g.recipe_selection) else buttons.keys()[0])
 else:g.label(detail,"Learn a recipe through research or town collections.",16)
 if g.room_id=="forge":g.button(g.panel_body,"Use this forge",func():g.open_panel("forge"))
 else:g.small_button(g.panel_body,"Find Borin’s forge",func():g.state.tracked_npc="borin";g.save_game();g.close_panel())
