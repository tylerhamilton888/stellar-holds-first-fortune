class_name HoldRoomBlueprintView
extends RefCounted
class Map extends Control:
 var planner
 var start=Vector2i.ZERO
 var dragging=false
 var door_mode=false
 var scale_factor=1.0
 var origin=Vector2.ZERO
 func cell_at(p:Vector2)->Vector2i:return Vector2i(((p-origin)/scale_factor/40).floor())
 func _gui_input(event):
  if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
   if event.pressed:
    start=cell_at(event.position);dragging=not door_mode
    if door_mode:planner.doorway(start);planner.a.g.refresh_panel()
   elif dragging:
    dragging=false;planner.save_rectangle(start,cell_at(event.position));planner.a.g.refresh_panel()
   accept_event()
  if event is InputEventMouseMotion and dragging:queue_redraw();accept_event()
 func _draw():
  draw_style_box(HoldArchitectureView.Preview.backdrop(),Rect2(Vector2.ZERO,size))
  scale_factor=minf(size.x/3600,size.y/2200);origin=(size-Vector2(3600,2200)*scale_factor)*.5
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
   var color=Color("e6c27b") if str(r.id)==planner.selected else Color("72b9c1")
   draw_rect(rect,Color(color,.12));draw_rect(rect,color,false,8)
   for k in r.doors:draw_rect(Rect2(Vector2(planner.a.s.house.coords(k))*40,Vector2(40,40)),Color("87ce94"))
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
 var r=p.chosen();var settings=g.row(g.panel_body)
 var picker=OptionButton.new();picker.custom_minimum_size=Vector2(170,34);settings.add_child(picker)
 for purpose in p.PURPOSES:picker.add_item(purpose)
 picker.select(p.PURPOSES.find(r.get("purpose",p.purpose)))
 picker.item_selected.connect(func(i):
  p.purpose=p.PURPOSES[i]
  if not r.is_empty():r.purpose=p.purpose;g.save_game()
  g.refresh_panel())
 var floor_picker=OptionButton.new();floor_picker.custom_minimum_size=Vector2(140,34);settings.add_child(floor_picker);floor_picker.add_item("Stone floor");floor_picker.add_item("Oak floor")
 floor_picker.select(1 if r.get("floor",p.floor_kind)=="wood_floor" else 0);floor_picker.disabled=r.get("started",false)
 floor_picker.item_selected.connect(func(i):
  p.floor_kind="wood_floor" if i==1 else "stone_floor"
  if not r.is_empty():r.floor=p.floor_kind;g.save_game()
  g.refresh_panel())
 HoldArchitectureView.action(g,settings,"New room",func():p.selected="";g.refresh_panel())
 var select=OptionButton.new();select.custom_minimum_size=Vector2(140,34);settings.add_child(select);select.add_item("Select a plan")
 var ids=[""]
 for room in p.rooms():
  ids.append(str(room.id));select.add_item("%s · %s" % [room.id,room.purpose])
 select.select(maxi(0,ids.find(p.selected)))
 select.item_selected.connect(func(i):p.selected=ids[i];g.refresh_panel())
 var map=Map.new();map.planner=p;map.custom_minimum_size=Vector2(0,280);map.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_child(map)
 var controls=g.row(g.panel_body);var door=CheckBox.new();door.text="Add doorway";controls.add_child(door);door.disabled=r.is_empty();door.toggled.connect(func(value):map.door_mode=value)
 HoldArchitectureView.action(g,controls,"Build within reach",func():p.work();g.refresh_panel(),not r.is_empty())
 HoldArchitectureView.action(g,controls,"Remove plan",func():p.forget();g.refresh_panel(),not r.is_empty())
 if not r.is_empty():
  var fee=p.cost(r);g.label(g.panel_body,"Complete" if fee.is_empty() else "Remaining materials · "+HoldData.cost_text(fee),16,Color("edc98a"))
 g.label(g.panel_body,p.message,15,Color("b8c5bc"))
 g.label(g.panel_body,"Ground floor · gold: selected · blue: planned · green: doorway. Drag again to resize an unbuilt plan. Designations suggest a purpose; equipment supplies its function.",14,Color("a8b9b6"))
