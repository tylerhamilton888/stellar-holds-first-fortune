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
 var drag_end=Vector2i.ZERO
 var candidate={}
 var candidate_valid=false
 var candidate_reason=""
 func update_candidate(finish:Vector2i):
  drag_end=finish;candidate=planner.rectangle(start,finish)
  var prior=planner.message
  candidate_valid=planner.validate(candidate,planner.selected) and not planner.chosen().get("started",false)
  candidate_reason="Work has begun. Start a new room." if planner.chosen().get("started",false) else planner.message
  planner.message=prior;queue_redraw()
 func cell_at(p:Vector2)->Vector2i:return Vector2i(((p-origin)/scale_factor/40).floor())
 func _gui_input(event):
  if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN] and event.pressed:
   if dragging:accept_event();return
   planner.zoom=clampf(planner.zoom*(1.25 if event.button_index==MOUSE_BUTTON_WHEEL_UP else .8),1,12);queue_redraw();accept_event();return
  if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_MIDDLE:
   if dragging:accept_event();return
   panning=event.pressed;accept_event();return
  if event is InputEventMouseMotion and panning:
   planner.map_center-=event.relative/scale_factor;queue_redraw();accept_event();return
  if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
   if event.pressed:
    start=cell_at(event.position);dragging=not door_mode
    if dragging:update_candidate(start)
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
  if event is InputEventMouseMotion and dragging:update_candidate(cell_at(event.position));accept_event()
 func _draw():
  draw_style_box(HoldArchitectureView.Preview.backdrop(),Rect2(Vector2.ZERO,size))
  scale_factor=minf(size.x/3600,size.y/2200)*planner.zoom;origin=size*.5+Vector2(0,24)-planner.map_center*scale_factor
  draw_set_transform(origin,0,Vector2.ONE*scale_factor)
  for y in range(8,52):
   for x in range(2,88):
    var c=Vector2i(x,y)
    if planner.a.s.claim_ground(planner.a.s.house.center(c)):draw_rect(Rect2(Vector2(c)*40,Vector2(39,39)),Color("263b3d"))
  for solid in (planner.a.s.base_obstacles(0)+planner.a.obstacles("claim") if planner.level()==0 else []):draw_rect(solid,Color("756f62"))
  var planned={}
  for room in planner.rooms():
   for part in planner.parts(room):planned[planner.a.s.house.key(part.cell)]=true
  for k in planner.tiles():
   if planned.has(k):continue
   var t=planner.tiles()[k];var rect=Rect2(Vector2(planner.a.s.house.coords(k))*40,Vector2(40,40))
   draw_rect(rect,Color("baae8e") if t.get("wall","") in ["wall","window"] else Color("6b7970"))
  var measure=Rect2i()
  for r in planner.rooms():
   if str(r.id)==planner.selected:measure=planner.bounds(r)
   var rect=Rect2(planner.bounds(r));rect.position*=40;rect.size*=40
   var color=Color("87ce94") if states.get(str(r.id),"")=="Complete" else Color("e0ab68")
   if str(r.id)==planner.selected:draw_rect(rect.grow(12),Color("f3dfa1"),false,6)
   HoldRoomConstruction197.draw_room(self,planner,r,false,planner.preview_roof)
   draw_rect(rect,color,false,2)
  HoldUpperBlueprints.draw_map(self,planner)
  if planner.level()==0:HoldEstateCellar.draw_map(self,planner.a.g)
  if planner.level()==planner.a.s.house.level():draw_circle(planner.a.g.player,22,Color("fff0b9"))
  if dragging:
   measure=planner.bounds(candidate)
   if measure.size.x<=20 and measure.size.y<=20:
    HoldRoomConstruction197.draw_room(self,planner,candidate,true,planner.preview_roof,candidate_valid)
   draw_rect(Rect2(Vector2(measure.position)*40,Vector2(measure.size)*40),Color("9eefa1") if candidate_valid else Color("f27969"),false,4)
  draw_set_transform(Vector2.ZERO)
  if dragging:
   var note="Release to place foundation plan · no materials spent" if candidate_valid else candidate_reason
   draw_rect(Rect2(0,0,size.x,30),Color("14272d"))
   draw_string(ThemeDB.fallback_font,Vector2(10,21),note,HORIZONTAL_ALIGNMENT_LEFT,size.x-20,14,Color("b6efb4") if candidate_valid else Color("ffac98"))
  elif not planner.chosen().is_empty():
   var progress=planner.progress(planner.chosen())
   draw_rect(Rect2(0,0,size.x,30),Color("14272d"))
   draw_string(ThemeDB.fallback_font,Vector2(10,21),"%s · %d/%d building pieces" % [progress.stage,progress.built,progress.total],HORIZONTAL_ALIGNMENT_LEFT,size.x-20,14,Color("f1dba2"))
  if measure.has_area():
   var others=[]
   for r in planner.rooms():
    if str(r.id)!=planner.selected:others.append(planner.bounds(r))
   var axes=HoldRoomBlueprintView.aligned_axes(measure,others)
   for x in axes.x:
    var px=origin.x+x*40*scale_factor
    draw_dashed_line(Vector2(px,0),Vector2(px,size.y),Color(.92,.79,.48,.55),1,5)
   for y in axes.y:
    var py=origin.y+y*40*scale_factor
    draw_dashed_line(Vector2(0,py),Vector2(size.x,py),Color(.92,.79,.48,.55),1,5)
   dimension_label(measure)
 func dimension_label(rect:Rect2i):
  var screen=Rect2(origin+Vector2(rect.position)*40*scale_factor,Vector2(rect.size)*40*scale_factor)
  if not screen.intersects(Rect2(Vector2.ZERO,size)):return
  var text=HoldRoomBlueprintView.dimension_text(rect);var font=ThemeDB.fallback_font
  var width=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,14).x
  var at=Vector2(clampf(screen.get_center().x-width/2,7,maxf(7,size.x-width-7)),clampf(screen.end.y+20,20,size.y-7))
  draw_rect(Rect2(at-Vector2(5,16),Vector2(width+10,22)),Color("10262c"))
  draw_string(font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("f1dba2"))
static func dimension_text(rect:Rect2i)->String:return "%d × %d tiles" % [rect.size.x,rect.size.y]
static func aligned_axes(rect:Rect2i,others:Array)->Dictionary:
 var result={"x":[],"y":[]}
 var own={"x":[float(rect.position.x),float(rect.end.x),rect.position.x+rect.size.x/2.0],"y":[float(rect.position.y),float(rect.end.y),rect.position.y+rect.size.y/2.0]}
 for other in others:
  var edges={"x":[float(other.position.x),float(other.end.x),other.position.x+other.size.x/2.0],"y":[float(other.position.y),float(other.end.y),other.position.y+other.size.y/2.0]}
  for axis in ["x","y"]:
   for value in own[axis]:
    if value in edges[axis] and value not in result[axis]:result[axis].append(value)
 return result
static func show(a):
 var p=a.room_blueprints;var g=a.g
 var row=g.row(g.panel_body)
 HoldArchitectureView.action(g,row,"New room",func():p.selected="";g.refresh_panel())
 HoldArchitectureView.action(g,row,"Furnish",func():g.open_panel("architecture_details"))
 HoldArchitectureView.action(g,row,"Building pieces",func():g.open_panel("house_build"))
 HoldArchitectureView.action(g,row,"Buildings",func():a.room_planning=false;g.refresh_panel())
 var floors=g.row(g.panel_body);var floor_select=OptionButton.new();floor_select.custom_minimum_size=Vector2(190,34);floors.add_child(floor_select)
 for z in HoldHearthcraft.MAX_Z:floor_select.add_item("Ground floor" if z==0 else "Upper floor %d" % z)
 floor_select.select(clampi(p.level(),0,HoldHearthcraft.MAX_Z-1));floor_select.item_selected.connect(func(z):p.choose_level(z);g.refresh_panel())
 g.label(floors,"You are on floor %d. Changing this view does not move you." % a.s.house.level(),14)
 if not p.available():g.label(g.panel_body,"Visit your chartered holding and select a floor below the roof deck.",17);return
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
 var map=Map.new();map.planner=p;map.clip_contents=true;map.custom_minimum_size=Vector2(0,260);map.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_child(map)
 for room in p.rooms():map.states[str(room.id)]=p.progress(room).state
 var navigation=g.row(g.panel_body)
 HoldArchitectureView.action(g,navigation,"My position",func():p.map_center=g.player;p.zoom=3;map.queue_redraw())
 HoldArchitectureView.action(g,navigation,"Whole holding",func():p.map_center=Vector2(1800,1100);p.zoom=1;map.queue_redraw())
 HoldArchitectureView.action(g,navigation,"Selected room",func():p.map_center=Vector2(p.bounds(r).get_center())*40;p.zoom=3;map.queue_redraw(),not r.is_empty())
 var controls=g.row(g.panel_body);var door=CheckBox.new();door.text="Doorways";controls.add_child(door);door.disabled=r.is_empty();door.toggled.connect(func(value):map.door_mode=value)
 var roof=CheckBox.new();roof.text="Show roof";roof.button_pressed=p.preview_roof;controls.add_child(roof);roof.toggled.connect(func(value):p.preview_roof=value;map.queue_redraw())
 var remove=CheckBox.new();remove.text="Remove";remove.disabled=r.is_empty();controls.add_child(remove);remove.toggled.connect(func(value):map.remove_door=value)
 HoldArchitectureView.action(g,controls,"Build within reach",func():p.work();g.refresh_panel(),not r.is_empty() and p.level()==a.s.house.level())
 HoldArchitectureView.action(g,controls,"Remove plan",func():p.forget();g.refresh_panel(),not r.is_empty())
 if not r.is_empty():
  g.label(g.panel_body,"Footprint · "+dimension_text(p.bounds(r))+" · includes outer walls",14,Color("edc98a"))
  var fee=p.cost(r);HoldBuildingPlans.add_cost(fee,HoldBlueprintFinishes.cost(p,r));var status=p.progress(r)
  var prior=p.message;var fits=p.validate(r,p.selected);var obstruction=p.message;p.message=prior
  g.label(g.panel_body,(status.stage if fits else "Blocked: "+obstruction)+" · %d/%d structural pieces" % [status.built,status.total],15,Color("b8c5bc"))
  if not fits:map.states[p.selected]="Blocked"
  g.label(g.panel_body,"No materials remaining" if fee.is_empty() else "This room · "+HoldData.cost_text(fee),16,Color("edc98a"))
  g.label(g.panel_body,p.assessment(r),14,Color("b8c5bc"))
  if p.level()>0:g.label(g.panel_body,"%d missing supports below · %s" % [HoldUpperBlueprints.missing_supports(p,r),"Connected stair access" if HoldUpperBlueprints.access(p,r) else "Needs connected stair access"],14)
 var estate_fee=p.total_cost()
 if not estate_fee.is_empty():g.label(g.panel_body,"All saved plans · "+HoldData.cost_text(estate_fee)+" · shared pieces counted once",14)
 g.label(g.panel_body,p.message,15,Color("b8c5bc"))
 g.label(g.panel_body,"Drag: preview finished room · green: valid · red: blocked. Release: mark foundation. Wheel: zoom · middle drag: pan · Show roof: exterior/cutaway. Construction: foundation → walls → roof → complete.",14,Color("a8b9b6"))

 # Keep the primary build controls and quote above optional navigation/finishes.
 g.panel_body.move_child(floors,g.panel_body.get_child_count()-1)
 g.panel_body.move_child(settings,g.panel_body.get_child_count()-1)
 g.panel_body.move_child(navigation,g.panel_body.get_child_count()-1)
 g.panel_body.move_child(style_row,g.panel_body.get_child_count()-1)

 HoldUpperBlueprints.panel(p)
 if p.level()==0:HoldEstateCellar.panel(g)

 HoldEstateWorkers.panel(p)
 HoldEstateFreight.panel(p)
