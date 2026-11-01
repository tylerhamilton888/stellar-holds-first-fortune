class_name HoldArchitectureView
extends RefCounted
# Presentation calls the same painter as the world, so previews stay truthful.
class Preview extends Control:
 var building={}
 var furnishing=""
 var finish={}
 var piece=""
 var clock=0.0
 func _draw():
  var r=Rect2(Vector2.ZERO,size)
  draw_style_box(backdrop(),r)
  if not piece.is_empty():
   var tile=Rect2(size.x*.5-30,size.y*.5-30,60,60)
   if piece in ["stone_floor","wood_floor"]:HoldArchitectureStyles.floor_draw(self,tile,"oak" if piece=="wood_floor" else "slate")
   elif piece=="roof":HoldArchitectureStyles.roof(self,tile,finish)
   elif piece=="wall":HoldArchitectureStyles.wall(self,tile,finish,false)
   elif piece=="window":draw_texture_rect_region(HoldArchitectureStyles.ATLAS,tile,HoldArchitectureStyles.WINDOWS[HoldArchitectureStyles.index(finish.wall)])
   elif piece=="door":
    var unit=HoldHearthcraft.MATERIALS.get_size()/Vector2(3,2)
    draw_texture_rect_region(HoldHearthcraft.MATERIALS,tile,Rect2(Vector2(2,1)*unit,unit))
   elif piece=="stairs":draw_texture_rect_region(HoldMasonryArt.ATLAS,Rect2(size.x*.5-18,5,36,size.y-10),HoldMasonryArt.STAIR)
   elif piece=="ladder":
    for x in [-18,18]:draw_line(size*.5+Vector2(x,-26),size*.5+Vector2(x,26),Color("ba935f"),5)
    for y in range(-20,26,10):draw_line(size*.5+Vector2(-18,y),size*.5+Vector2(18,y),Color("d6b174"),4)
  elif not furnishing.is_empty():
   var shape=HoldFurnishings.silhouette(furnishing,Vector2.ZERO)
   var scale=minf((size.x-22)/shape.size.x,(size.y-16)/shape.size.y)
   scale=minf(scale,2.0)
   draw_set_transform((size-shape.size*scale)*.5-shape.position*scale,0,Vector2.ONE*scale)
   HoldFurnishings.draw(self,Vector2.ZERO,furnishing)
  elif not building.is_empty():
   var bounds=HoldBuildingArt.visual_bounds(building)
   var scale=minf((size.x-18)/bounds.size.x,(size.y-18)/bounds.size.y)
   draw_set_transform(size*.5-bounds.get_center()*scale,0,Vector2.ONE*scale)
   HoldBuildingArt.elevation(self,building)
  elif not finish.is_empty():
   var floor=Rect2(12,28,size.x-24,size.y-40)
   HoldArchitectureStyles.floor_draw(self,floor,finish.floor)
   if finish.floor=="inlaid":
    draw_rect(floor.grow(-9),Color("c9b078"),false,2)
    draw_rect(floor.grow(-14),Color("526c71"),false,3)
   HoldArchitectureStyles.wall(self,Rect2(12,8,size.x-24,32),finish,false)
   for x in [24,size.x-24]:HoldArchitectureStyles.post(self,Vector2(x,42),34,finish.trim)
  draw_set_transform(Vector2.ZERO)
 static func backdrop()->StyleBoxFlat:
  var b=StyleBoxFlat.new();b.bg_color=Color("102128");b.set_corner_radius_all(5);b.border_color=Color("34474b");b.set_border_width_all(1);return b

static func preview(parent:Node,b:Dictionary,height:float=130)->Preview:
 var p=Preview.new();p.building=b;p.custom_minimum_size=Vector2(0,height);p.size_flags_horizontal=Control.SIZE_EXPAND_FILL;p.mouse_filter=Control.MOUSE_FILTER_IGNORE;parent.add_child(p);return p
static func grid(parent:Node,columns:int=3)->GridContainer:
 var n=GridContainer.new();n.columns=columns;n.add_theme_constant_override("h_separation",10);n.add_theme_constant_override("v_separation",10);n.size_flags_horizontal=Control.SIZE_EXPAND_FILL;parent.add_child(n);return n
static func card(g,parent:Node)->VBoxContainer:
 var box=g.section(parent,"");box.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL;return box
static func tab(g,parent:Node,title:String,active:bool,fn:Callable):
 var b=g.small_button(parent,title,fn);b.toggle_mode=true;b.button_pressed=active;b.alignment=HORIZONTAL_ALIGNMENT_CENTER;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
static func action(g,parent:Node,title:String,fn:Callable,enabled:bool=true):
 var b=g.small_button(parent,title,fn);b.disabled=not enabled;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL;return b
static func book(a):
 var g=a.g;var b=a.nearby()
 if not b.is_empty() and (not a.browse_only or a.interior()):
  renovation(a,b);return
 var tabs=g.row(g.panel_body)
 tab(g,tabs,"All plans",a.collection=="all",func():a.collection="all";g.refresh_panel())
 for id in HoldArchitectureStyles.FAMILIES:
  tab(g,tabs,HoldArchitectureStyles.FAMILIES[id].title,a.collection==id,func():a.collection=id;g.refresh_panel())
 if a.collection!="all":g.label(g.panel_body,HoldArchitectureStyles.FAMILIES[a.collection].mood,16,Color("b8c5bc"))
 else:g.label(g.panel_body,"Choose a familiar silhouette. Mix matching stone, roof and trim for its additions.",16,Color("b8c5bc"))
 if not b.is_empty():action(g,g.panel_body,"Return to "+b.name,func():a.browse_only=false;g.refresh_panel())
 var cards=grid(g.panel_body)
 for id in HoldBuildingPlans.catalogue():
  var p=HoldBuildingPlans.plan(id);var family=HoldArchitectureStyles.family(id)
  if a.collection!="all" and family!=a.collection:continue
  var box=card(g,cards);box.get_parent().custom_minimum_size.x=248
  preview(box,HoldBuildingPlans.instance(id,Vector2.ZERO),104)
  var name=g.label(box,p.name,16);name.custom_minimum_size.y=32
  g.label(box,"%d floor%s · %s" % [p.rooms.size(),"s" if p.rooms.size()>1 else "",p.category],14,Color("a8b9b6"))
  action(g,box,"Choose plan",func():a.select_plan(id))
 action(g,g.panel_body,"Build piece by piece · floors, walls and roofs",func():g.open_panel("house_build"))
static func renovation(a,b:Dictionary):
 if HoldFrontier103.public_building(b):
  var g=a.g
  preview(g.panel_body,a.building_object(b),180)
  g.label(g.panel_body,b.name+" · shared town building",21)
  g.label(g.panel_body,"This building uses the same shell, interiors and stairs available in your building book. You may build your own version on your household plot.",16)
  action(g,g.panel_body,"View this building plan",func():a.select_plan(b.plan))
  if HoldFrontier103.private_room(g):action(g,g.panel_body,"Furnish my upstairs room",func():g.open_panel("home"))
  return
 var g=a.g;var row=g.row(g.panel_body)
 var picture=preview(row,a.building_object(b),180);picture.custom_minimum_size.x=230;picture.size_flags_horizontal=Control.SIZE_SHRINK_BEGIN
 var summary=VBoxContainer.new();summary.size_flags_horizontal=Control.SIZE_EXPAND_FILL;row.add_child(summary)
 g.label(summary,b.name,21,Color("edc98a"))
 var style=HoldArchitectureStyles.resolve(b)
 g.label(summary,"%s · %d floor%s" % [HoldArchitectureStyles.FAMILIES[style.wall].title,b.rooms.size(),"s" if b.rooms.size()>1 else ""],16,Color("b8c5bc"))
 g.label(summary,"%d side bays · %d rear bays" % [int(b.extend_x),int(b.extend_y)],14,Color("b8c5bc"))
 var name=g.row(summary);var entry=LineEdit.new();entry.text=b.name;entry.max_length=48;entry.size_flags_horizontal=Control.SIZE_EXPAND_FILL;name.add_child(entry)
 action(g,name,"Rename",func():
  var value=entry.text.strip_edges()
  if value!="":b.name=value;g.save_game();g.refresh_panel())
 action(g,summary,"Materials & finishes",a.open_style)
 var tools=grid(g.panel_body)
 action(g,tools,"Furniture & details",func():g.open_panel("architecture_details"))
 action(g,tools,"Floors & partitions",func():g.open_panel("house_build"))
 action(g,tools,"Workstations & storage",func():g.open_panel("handworks"))
 action(g,tools,"Move furniture",a.s.move_nearby_furnishing)
 action(g,tools,"Recover furniture",a.s.recover_decor)
 var floor_button=action(g,tools,"Add upper floor" if b.rooms.size()<5 else "Five floors · complete",a.add_floor,b.rooms.size()<5 and g.state.afford(a.floor_cost(b)))
 floor_button.tooltip_text=HoldData.cost_text(a.floor_cost(b))+" · clear a stair landing on every floor"
 if not a.interior():
  var fee={"stone":24*b.rooms.size(),"wood":16*b.rooms.size()}
  g.label(g.panel_body,"Extend the foundation · "+HoldData.cost_text(fee)+" per bay",14,Color("b8c5bc"))
  var extend=g.row(g.panel_body)
  action(g,extend,"Add side bay",func():a.expand("extend_x"),int(b.extend_x)<6 and g.state.afford(fee))
  action(g,extend,"Add rear bay",func():a.expand("extend_y"),int(b.extend_y)<6 and g.state.afford(fee))
  action(g,extend,"Relocate building",a.move_building)
  var recover=action(g,extend,"Recover shell",a.recover,a.empty_for_recovery(b));recover.tooltip_text="Empty all floors first. Returns the materials paid for the shell and finishes."
  action(g,g.panel_body,"Browse more building plans",func():a.browse_only=true;g.refresh_panel())
 else:g.label(g.panel_body,"Step outside to extend or relocate this building. E climbs; Shift+E descends.",14,Color("b8c5bc"))
static func choices(a,parent:Node,draft:Dictionary):
 var g=a.g
 for key in HoldArchitectureStyles.OPTIONS:
  var row=g.row(parent);var title=g.label(row,{"wall":"Masonry","roof":"Roof","trim":"Posts & trim","floor":"Room finish"}[key],15);title.custom_minimum_size.x=110
  var picker=OptionButton.new();picker.name="Style_"+key;picker.size_flags_horizontal=Control.SIZE_EXPAND_FILL;picker.custom_minimum_size.y=34;row.add_child(picker)
  picker.add_theme_font_size_override("font_size",15)
  for state in ["normal","hover","pressed","disabled"]:
   var style=picker.get_theme_stylebox(state).duplicate();style.set_content_margin_all(5);picker.add_theme_stylebox_override(state,style)
  var values=HoldArchitectureStyles.OPTIONS[key].keys()
  for value in values:picker.add_item(HoldArchitectureStyles.OPTIONS[key][value])
  picker.select(values.find(draft[key]));picker.item_selected.connect(func(i):draft[key]=values[i];g.refresh_panel())
static func plan_page(a):
 var g=a.g;var p=HoldBuildingPlans.plan(a.selected)
 if p.is_empty():return
 if a.plan_style.is_empty():a.plan_style=HoldArchitectureStyles.preset(HoldArchitectureStyles.family(a.selected))
 var row=g.row(g.panel_body);var b=HoldBuildingPlans.instance(a.selected,Vector2.ZERO);b.style87=a.plan_style
 var art=preview(row,b,260);art.custom_minimum_size.x=270;art.size_flags_horizontal=Control.SIZE_SHRINK_BEGIN
 var right=VBoxContainer.new();right.size_flags_horizontal=Control.SIZE_EXPAND_FILL;right.add_theme_constant_override("separation",7);row.add_child(right)
 g.label(right,p.name,22,Color("edc98a"))
 g.label(right,"%d floor%s · %s" % [p.rooms.size(),"s" if p.rooms.size()>1 else "",p.category],15)
 var furnished=CheckBox.new();furnished.text="Include original furnishings";furnished.button_pressed=a.furnish_plan;right.add_child(furnished);furnished.toggled.connect(func(value):a.furnish_plan=value;g.refresh_panel())
 g.label(right,HoldData.cost_text(a.cost(a.selected)),16,Color("e9c586"))
 action(g,right,"Build this plan",func():a.start(a.selected),a.s.area=="claim" and g.state.afford(a.cost(a.selected)))
 g.label(right,"Place its doorway near you on your land. Large halls fit on the eastern grounds.",14,Color("a8b9b6"))
 var finish=g.section(g.panel_body,"Compatible materials")
 g.label(finish,"The original frontage stays intact. These choices finish its rooms, new wings and upper storeys.",14,Color("b8c5bc"))
 choices(a,finish,a.plan_style)
static func style_page(a):
 var g=a.g;var b=a.nearby()
 if b.is_empty() or str(b.id)!=a.style_owner:return
 var tabs=g.row(g.panel_body)
 for key in HoldArchitectureStyles.FAMILIES:
  tab(g,tabs,HoldArchitectureStyles.FAMILIES[key].title,a.draft_style==HoldArchitectureStyles.preset(key),func():a.draft_style=HoldArchitectureStyles.preset(key);g.refresh_panel())
 var row=g.row(g.panel_body);var left=VBoxContainer.new();left.custom_minimum_size.x=280;row.add_child(left)
 var study=a.building_object(b);study.p=Vector2.ZERO;study.extend_x=maxi(3,int(study.extend_x));study.extra_storeys=maxi(1,int(study.extra_storeys));study.style87=a.draft_style
 preview(left,study,148)
 g.label(left,"Example wing & upper room",14,Color("a8b9b6"))
 var room=preview(left,{},86);room.finish=a.draft_style
 var right=VBoxContainer.new();right.size_flags_horizontal=Control.SIZE_EXPAND_FILL;right.add_theme_constant_override("separation",8);row.add_child(right)
 g.label(right,b.name,20,Color("edc98a"));choices(a,right,a.draft_style)
 var fee=a.style_cost(b)
 g.label(right,"Already applied" if fee.is_empty() else HoldData.cost_text(fee),16,Color("e9c586"))
 action(g,right,"Apply finishes",a.apply_style,not fee.is_empty() and g.state.afford(fee))
 g.label(g.panel_body,"Mix any collection. The original frontage remains unchanged; finishes cover rooms, new partitions and additions. Existing furniture and painted floor tiles stay in place.",14,Color("a8b9b6"))
static func furniture(a):
 var g=a.g;var tabs=g.row(g.panel_body)
 var groups={"Hearth":["double_bed","bed","hearth","hearth_table","tea_table","table","chair","pantry","counter","serving_counter"],"Study & storage":["chest","desk","bookcase","lamp","orrery","notice_board"],"Workshop":["anvil","worktable","pressure_manifold","training_rack"],"Stonework":["stone_pillar","royal_pillar","royal_throne","royal_arch","royal_brazier","oath_stone"],"Roadside":["runestone","signpost","road_lantern","barrel","crate","plinth"]}
 for key in groups:tab(g,tabs,key,a.details_group==key,func():a.details_group=key;g.refresh_panel())
 g.label(g.panel_body,"Choose a piece, then place it on the grid. Keep doors, stairs and work approaches clear.",14,Color("b8c5bc"))
 var cards=grid(g.panel_body,3)
 for id in groups.get(a.details_group,groups.Hearth):
  var item=HoldFurnishings.ITEMS[id];var box=card(g,cards);box.get_parent().custom_minimum_size.x=248
  var pic=preview(box,{},86);pic.furnishing=id
  var title=g.label(box,item.title,15);title.custom_minimum_size.y=42
  var price=g.label(box,HoldData.cost_text(item.cost),14,Color("a8b9b6"));price.custom_minimum_size.y=24
  var unlocked=id not in ["pantry","hearth_table"] or g.state.tech.has("hearthkeeping")
  var btn=action(g,box,"Place" if unlocked else "Learn Hearthkeeping",func():a.s.start_placement(id),unlocked and a.s.can_furnish() and g.state.afford(item.cost))
  btn.tooltip_text=item.title
static func structure(a):
 var g=a.g;var house=a.s.house;var style=HoldArchitectureStyles.room(a.s.area)
 if not a.interior():
  var tabs=g.row(g.panel_body)
  for family in HoldArchitectureStyles.FAMILIES:
   tab(g,tabs,HoldArchitectureStyles.FAMILIES[family].title,style.wall==family,func():house.data().style87=HoldArchitectureStyles.preset(family);g.save_game();g.refresh_panel())
 else:action(g,g.panel_body,"Room materials & finishes",a.open_style)
 g.label(g.panel_body,"Choose a piece · hold LMB to build · right click to cancel",15,Color("b8c5bc"))
 var cards=grid(g.panel_body,3)
 for kind in house.TITLES:
  if kind=="remove" or (a.interior() and kind in ["roof","stairs","ladder"]):continue
  var box=card(g,cards);box.get_parent().custom_minimum_size.x=248
  var pic=preview(box,{},72);pic.piece=kind;pic.finish=style
  g.label(box,house.TITLES[kind],16)
  g.label(box,HoldData.cost_text(house.COSTS[kind]),14,Color("a8b9b6"))
  action(g,box,"Build",func():a.s.cancel_placement();a.s.placing="house:"+kind;g.handworks.placing="";g.close_panel(),g.state.afford(house.COSTS[kind]))
 var actions=g.row(g.panel_body)
 action(g,actions,"Recover top piece",func():a.s.cancel_placement();a.s.placing="house:remove";g.handworks.placing="";g.close_panel())
 action(g,actions,"Furniture catalogue",func():g.open_panel("architecture_details"))
 action(g,actions,"Building book",func():a.browse_only=false;g.open_panel("architecture"))
 if a.interior():g.label(g.panel_body,"Partitions and doors use this building’s finishes. Keep entrances, stair landings and workspaces clear.",14,Color("a8b9b6"))
 else:
  g.label(g.panel_body,"Z+%d · Walls + door + roof make a sheltered room. E climbs; Shift+E descends." % house.level(),14,Color("a8b9b6"))
  house.lesson()
