class_name HoldExcavationBlueprintView
extends RefCounted
class Map extends Control:
 var planner
 var start=Vector2i.ZERO
 var dragging=false
 var panning=false
 var stairs=false
 var scale_factor=1.0
 var origin=Vector2.ZERO
 var statuses={}
 func cell_at(p:Vector2)->Vector2i:return Vector2i(((p-origin)/scale_factor/40).floor())
 func _gui_input(e):
  if e is InputEventMouseButton and e.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN] and e.pressed:
   planner.zoom=clampf(planner.zoom*(1.25 if e.button_index==MOUSE_BUTTON_WHEEL_UP else .8),1,8);queue_redraw();accept_event();return
  if e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_MIDDLE:panning=e.pressed;accept_event();return
  if e is InputEventMouseMotion and panning:planner.map_center-=e.relative/scale_factor;queue_redraw();accept_event();return
  if e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_LEFT:
   if e.pressed:
    start=cell_at(e.position);dragging=not stairs
    if stairs:planner.plan_stair(start);planner.g.refresh_panel()
   elif dragging:
    dragging=false;var finish=cell_at(e.position)
    if start==finish:
     for r in planner.rooms():
      if planner.bounds(r).has_point(start):planner.selected=str(r.id);break
    else:planner.save_rectangle(start,finish)
    planner.g.refresh_panel()
   accept_event()
  if e is InputEventMouseMotion and dragging:queue_redraw();accept_event()
 func _draw():
  draw_style_box(HoldArchitectureView.Preview.backdrop(),Rect2(Vector2.ZERO,size))
  scale_factor=minf(size.x/(Deepworks.W*40),size.y/(Deepworks.H*40))*planner.zoom;origin=size*.5-planner.map_center*scale_factor
  draw_set_transform(origin,0,Vector2.ONE*scale_factor)
  var w=planner.w
  for y in Deepworks.H:
   for x in Deepworks.W:
    var c=Vector2i(x,y);var color=Color("18292e")
    if w.layer().seen.has(Deepworks.key(c)):
     var k=w.at(c);color=Color("6a7972") if k==0 else Color("736f62") if k!=8 else Color("29363d")
    draw_rect(Rect2(Vector2(c)*40,Vector2(39,39)),color)
  for r in planner.model.data.rooms.values():
   if int(r.depth)!=w.depth():continue
   var rect=Rect2(planner.bounds(r));rect.position*=40;rect.size*=40
   draw_rect(rect,Color("618375"),false,5)
  for r in planner.rooms():
   var rect=Rect2(planner.bounds(r));rect.position*=40;rect.size*=40
   var color={"Planned":Color("80bec6"),"Excavating":Color("d2b577"),"Excavated":Color("8bc69a"),"Obstructed":Color("cf8a77")}.get(statuses.get(str(r.id),"Planned"),Color.WHITE)
   draw_rect(rect,Color(color,.13));draw_rect(rect,color,false,7)
   if str(r.id)==planner.selected:draw_rect(rect.grow(10),Color("f3dfa1"),false,4)
  for s in planner.data().stairs:
   if w.depth() not in [int(s.depth),int(s.depth)+1]:continue
   var p=Vector2(s.x,s.y)*40
   for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:draw_rect(Rect2(p+Vector2(d)*40,Vector2(40,40)),Color("b99e6b"),false,3)
   for i in 4:draw_line(p+Vector2(3+i*3,5+i*9),p+Vector2(37-i*3,5+i*9),Color("e2c385"),4)
  draw_circle(planner.g.player,24,Color("ffedbd"))
  if dragging:
   var end=cell_at(get_local_mouse_position());var low=Vector2i(mini(start.x,end.x),mini(start.y,end.y));var high=Vector2i(maxi(start.x,end.x),maxi(start.y,end.y))
   draw_rect(Rect2(Vector2(low)*40,Vector2(high-low+Vector2i.ONE)*40),Color("f1dba2"),false,7)
  draw_set_transform(Vector2.ZERO)
static func action(g,row,title:String,callback:Callable,enabled:bool=true):return HoldArchitectureView.action(g,row,title,callback,enabled)
static func show(p):
 var g=p.g
 if not p.available():g.label(g.panel_body,"Visit the mine to plan its chambers.",17);return
 g.label(g.panel_body,"Plan Your Holding · "+HoldMineworks143.label(p.w.depth()),19,Color("edc98a"))
 var r=p.chosen();var id=p.selected
 if p.view_depth!=p.w.depth():p.view_depth=p.w.depth();p.map_center=g.player;p.zoom=4;p.focus_id=""
 if not r.is_empty() and p.focus_id!=id:p.focus_id=id;p.map_center=Vector2(p.bounds(r).get_center())*40;p.zoom=minf(5,64.0/(int(r.h)+4))
 var controls=g.row(g.panel_body)
 var purpose=OptionButton.new();purpose.custom_minimum_size=Vector2(150,34);controls.add_child(purpose)
 for name in p.PURPOSES:purpose.add_item(name)
 purpose.select(p.PURPOSES.find(r.get("purpose",p.purpose)))
 purpose.item_selected.connect(func(i):p.configure("purpose",p.PURPOSES[i],id);g.refresh_panel())
 action(g,controls,"New room",func():p.selected="";g.refresh_panel())
 var selector=OptionButton.new();selector.custom_minimum_size=Vector2(180,34);controls.add_child(selector);selector.add_item("Select a plan");var ids=[""]
 for plan in p.rooms():ids.append(str(plan.id));selector.add_item("%s · %s" % [plan.id,plan.purpose])
 selector.select(maxi(0,ids.find(id)))
 selector.item_selected.connect(func(i):p.selected=ids[i];g.refresh_panel())
 var map=Map.new();map.planner=p;map.clip_contents=true;map.custom_minimum_size=Vector2(0,140);map.size_flags_horizontal=Control.SIZE_EXPAND_FILL;g.panel_body.add_child(map)
 for room in p.rooms():map.statuses[str(room.id)]=p.progress(room).state
 var actions=g.row(g.panel_body)
 action(g,actions,"Return to mining",func():p.owner.cancel();g.close_panel();g.tool=0;g.mining_gun.selected=false)
 action(g,actions,"Prepare / furnish",func():
  if p.prepare_room():p.owner.page="Furnish"
  g.refresh_panel(),not r.is_empty())
 action(g,actions,"Finish within reach",func():p.finish_nearby();g.refresh_panel(),not r.is_empty())
 action(g,actions,"Remove guide",func():p.forget();g.refresh_panel(),not r.is_empty())
 if not r.is_empty():
  var progress=p.progress(r)
  g.label(g.panel_body,"%s · %d/%d floor tiles cleared" % [progress.state,progress.open,progress.total],16,Color("edc98a"))
  var costs=p.cost(r)
  g.label(g.panel_body,"Finishes · "+("No materials remaining" if costs.is_empty() else HoldData.cost_text(costs)),15)
  if progress.hard:g.label(g.panel_body,"%d basalt tiles need a tempered pick. All rock keeps its normal hardness and yields." % progress.hard,14)
  if r.room!="" and p.model.data.rooms.has(r.room):
   var q=p.model.quality(p.model.data.rooms[r.room]);g.label(g.panel_body,"Comfort %d · Craft %.1f · Heritage %d · Furnishings supply function." % [q.comfort,q.craft,q.heritage],14)
 g.label(g.panel_body,p.message,14,Color("b8c5bc"))
 g.label(g.panel_body,"Drag: plan · Click: select · Wheel: zoom · Middle drag: pan. Blue: planned · Amber: excavation begun · Green: cleared. Dark ground is unsurveyed.",13,Color("a8b9b6"))
 var nav=g.row(g.panel_body)
 action(g,nav,"My position",func():p.map_center=g.player;p.zoom=5;map.queue_redraw())
 action(g,nav,"Whole level",func():p.map_center=Vector2(Deepworks.W,Deepworks.H)*20;p.zoom=1;map.queue_redraw())
 action(g,nav,"Selected room",func():p.map_center=Vector2(p.bounds(r).get_center())*40;p.zoom=minf(5,64.0/(int(r.h)+4));map.queue_redraw(),not r.is_empty())
 var finishes=g.row(g.panel_body)
 for surface in ["floor","wall"]:
  var picker=OptionButton.new();picker.custom_minimum_size=Vector2(230,34);finishes.add_child(picker);picker.add_item("Keep current "+surface);var options=[""]
  for key in LivingWorks.FINISHES:
   var def=LivingWorks.FINISHES[key]
   if def.surface==surface:options.append(key);picker.add_item(def.name+(" · research needed" if not p.model.unlocked(def) else ""))
  picker.select(maxi(0,options.find(r.get(surface,""))));picker.disabled=r.is_empty()
  picker.item_selected.connect(func(i):p.configure(surface,options[i],id);g.refresh_panel())
 g.label(g.panel_body,"Excavation is handwork. Natural bedrock needs no fabricated shell. Finishes use actual coverage; furnishing and storage have their own costs.",13)
 var links=g.row(g.panel_body);var stair=CheckBox.new();stair.text="Plan stairs";links.add_child(stair);stair.toggled.connect(func(value):map.stairs=value)
 action(g,links,"Fit stairs here",func():p.fit_stair();g.refresh_panel())
 action(g,links,"Remove stair guide",func():p.forget_stair();g.refresh_panel())
 action(g,links,"Workstations / storage",func():g.open_panel("handworks"))
 g.label(g.panel_body,"Stair crosses mark both landings. Mine their five tiles through existing access, then fit from above. The five original depths support stairs; lateral worksites keep their adits. E down · Shift+E up.",13)
