class_name HoldRoomBlueprintView
extends RefCounted
class Map extends Control:
 var planner
 var start=Vector2i.ZERO
 var dragging=false
 var door_mode=false
 var remove_door=false
 var panning=false
 var states={}
 var scale_factor=1.0
 var origin=Vector2.ZERO
 func cell_at(p:Vector2)->Vector2i:return Vector2i(((p-origin)/scale_factor/40).floor())
 func _gui_input(event):
  if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN] and event.pressed:
   planner.zoom=clampf(planner.zoom*(1.25 if event.button_index==MOUSE_BUTTON_WHEEL_UP else .8),1,5);queue_redraw();accept_event();return
  if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_MIDDLE:
   panning=event.pressed;accept_event();return
  if event is InputEventMouseMotion and panning:
   planner.map_center-=event.relative/scale_factor;queue_redraw();accept_event();return
  if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
   if event.pressed:
    start=cell_at(event.position);dragging=not door_mode
    if door_mode:planner.doorway(start,remove_door);planner.a.g.refresh_panel()
   elif dragging:
    dragging=false
    var finish=cell_at(event.position)
    if start==finish:
     for r in planner.rooms():
      if planner.bounds(r).has_point(start):planner.select_room(str(r.id));break
    else:planner.save_rectangle(start,finish)
    planner.a.g.refresh_panel()
   accept_event()
  if event is InputEventMouseMotion and dragging:queue_redraw();accept_event()
 func _draw():
  draw_style_box(HoldArchitectureView.Preview.backdrop(),Rect2(Vector2.ZERO,size))
  scale_factor=minf(size.x/3600,size.y/2200)*planner.zoom;origin=size*.5-planner.map_center*scale_factor
  draw_set_transform(origin,0,Vector2.ONE*scale_factor)
  for y in range(8,52):
   for x in range(2,88):
    var c=Vector2i(x,y)
    if planner.a.s.claim_ground(planner.a.s.house.center(c)):draw_rect(Rect2(Vector2(c)*40,Vector2(39,39)),Color("263b3d"))
  for solid in planner.a.s.base_obstacles()+planner.a.obstacles("claim"):draw_rect(solid,Color("756f62"))
  for k in planner.a.s.house.tiles():
   var t=planner.a.s.house.tiles()[k];var rect=Rect2(Vector2(planner.a.s.house.coords(k))*40,Vector2(40,40))
   draw_rect(rect,Color("baae8e") if t.get("wall","") in ["wall","window"] else Color("6b7970"))
  for r in planner.rooms():
   var rect=Rect2(planner.bounds(r));rect.position*=40;rect.size*=40
   var color={"Complete":Color("87ce94"),"Under construction":Color("e0ab68"),"Finishing":Color("e0ab68"),"Planned":Color("72b9c1")}.get(states.get(str(r.id),"Planned"),Color("d67b73"))
   if str(r.id)==planner.selected:draw_rect(rect.grow(12),Color("f3dfa1"),false,6)
   draw_rect(rect,Color(color,.12));draw_rect(rect,color,false,8)
   for k in r.doors:draw_rect(Rect2(Vector2(planner.a.s.house.coords(k))*40,Vector2(40,40)),Color("87ce94"))
  HoldEstateCellar.draw_map(self,planner.a.g)
  draw_circle(planner.a.g.player,22,Color("fff0b9"))
  if dragging:
   var end=cell_at(get_local_mouse_position());var low=Vector2i(mini(start.x,end.x),mini(start.y,end.y));var high=Vector2i(maxi(start.x,end.x),maxi(start.y,end.y))
   draw_rect(Rect2(Vector2(low)*40,Vector2(high-low+Vector2i.ONE)*40),Color("f1dba2"),false,8)
  draw_set_transform(Vector2.ZERO)
static func show(a):
 var p=a.room_blueprints;var g=a.g
 var row=g.row(g.panel_body)
 HoldArchitectureView.action(g,row,"Blueprint mode",func():pass,false)
 HoldArchitectureView.action(g,row,"Furnishing mode",func():g.open_panel("architecture_details"))
 HoldArchitectureView.action(g,row,"Fine construction",func():g.open_panel("house_build"))
 HoldArchitectureView.action(g,row,"Building catalogue",func():a.room_planning=false;g.refresh_panel())
 if not p.available():g.label(g.panel_body,"Visit your chartered holding at ground level to plan rooms.",17);return
 var r=p.chosen();var room_id=p.selected;var settings=g.row(g.panel_body)
 var picker=OptionButton.new();picker.custom_minimum_size=Vector2(170,34);settings.add_child(picker)
 for purpose in p.PURPOSES:picker.add_item(purpose)
 picker.select(p.PURPOSES.find(r.get("purpose",p.purpose)))
 picker.tooltip_text="A planning label. Beds, cooking hearths and workstations supply their own functions; mixed-use rooms are welcome."
 picker.item_selected.connect(func(i):
  p.configure("purpose",p.PURPOSES[i],room_id)
  g.refresh_panel())
 var floor_picker=OptionButton.new();floor_picker.custom_minimum_size=Vector2(140,34);settings.add_child(floor_picker);floor_picker.add_item("Stone floor");floor_picker.add_item("Oak floor")
 floor_picker.select(1 if r.get("floor",p.floor_kind)=="wood_floor" else 0);floor_picker.disabled=r.get("started",false)
 floor_picker.item_selected.connect(func(i):
  p.configure("floor","wood_floor" if i==1 else "stone_floor",room_id)
  g.refresh_panel())
 HoldArchitectureView.action(g,settings,"New room",func():p.selected="";g.refresh_panel())
 var select=OptionButton.new();select.custom_minimum_size=Vector2(140,34);settings.add_child(select);select.add_item("Select a plan")
 var ids=[""]
 for room in p.rooms():
  ids.append(str(room.id));select.add_item("%s · %s" % [room.id,room.purpose])
 select.select(maxi(0,ids.find(p.selected)))
 select.item_selected.connect(func(i):p.select_room(ids[i]);g.refresh_panel())
 var style_row=g.row(g.panel_body);var finish=OptionButton.new();finish.custom_minimum_size=Vector2(190,34);style_row.add_child(finish)
 var families=["","hearth","forge","oath"];finish.add_item("Keep current finishes")
 for family in families.slice(1):finish.add_item(HoldArchitectureStyles.FAMILIES[family].title)
 finish.select(maxi(0,families.find(r.get("style_family",p.style_family))))
 finish.item_selected.connect(func(i):
  p.configure("style_family",families[i],room_id)
  g.refresh_panel())
 var tech=HoldBlueprintFinishes.RESEARCH.get(r.get("style_family",p.style_family),"")
 if tech!="" and not g.state.tech.get(tech,false):g.label(style_row,"Finishing requires "+HoldData.RESEARCH[tech].name,14)
 else:g.label(style_row,"Finishes are paid by coverage; contents stay put.",14)
 var map=Map.new();map.planner=p;map.clip_contents=true;map.custom_minimum_size=Vector2(0,170);map.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_child(map)
 for room in p.rooms():map.states[str(room.id)]=p.progress(room).state
 var navigation=g.row(g.panel_body)
 HoldArchitectureView.action(g,navigation,"My position",func():p.map_center=g.player;p.zoom=3;map.queue_redraw())
 HoldArchitectureView.action(g,navigation,"Whole holding",func():p.map_center=Vector2(1800,1100);p.zoom=1;map.queue_redraw())
 HoldArchitectureView.action(g,navigation,"Selected room",func():p.map_center=Vector2(p.bounds(r).get_center())*40;p.zoom=3;map.queue_redraw(),not r.is_empty())
 var controls=g.row(g.panel_body);var door=CheckBox.new();door.text="Doorways";controls.add_child(door);door.disabled=r.is_empty();door.toggled.connect(func(value):map.door_mode=value)
 var remove=CheckBox.new();remove.text="Remove";remove.disabled=r.is_empty();controls.add_child(remove);remove.toggled.connect(func(value):map.remove_door=value)
 HoldArchitectureView.action(g,controls,"Build within reach",func():p.work();g.refresh_panel(),not r.is_empty())
 HoldArchitectureView.action(g,controls,"Remove plan",func():p.forget();g.refresh_panel(),not r.is_empty())
 if not r.is_empty():
  var fee=p.cost(r);HoldBuildingPlans.add_cost(fee,HoldBlueprintFinishes.cost(p,r));var status=p.progress(r)
  var prior=p.message;var fits=p.validate(r,p.selected);var obstruction=p.message;p.message=prior
  g.label(g.panel_body,(status.state if fits else "Blocked: "+obstruction)+" · %d/%d structural pieces" % [status.built,status.total],15,Color("b8c5bc"))
  if not fits:map.states[p.selected]="Blocked"
  g.label(g.panel_body,"No materials remaining" if fee.is_empty() else "This room · "+HoldData.cost_text(fee),16,Color("edc98a"))
  g.label(g.panel_body,p.assessment(r),14,Color("b8c5bc"))
 var estate_fee=p.total_cost()
 if not estate_fee.is_empty():g.label(g.panel_body,"All saved plans · "+HoldData.cost_text(estate_fee)+" · shared pieces counted once",14)
 g.label(g.panel_body,p.message,15,Color("b8c5bc"))
 g.label(g.panel_body,"Ground floor · wheel: zoom · middle drag: pan · click: select. Blue: planned · amber: building · green: complete · red: blocked. Add a new doorway before removing the old one.",14,Color("a8b9b6"))

 # Keep the primary build controls and quote above optional navigation/finishes.
 g.panel_body.move_child(navigation,g.panel_body.get_child_count()-1)
 g.panel_body.move_child(style_row,g.panel_body.get_child_count()-1)

 HoldEstateCellar.panel(g)
