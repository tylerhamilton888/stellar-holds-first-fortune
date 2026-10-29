class_name HoldDepthNavigation94
extends RefCounted
var g
var viewed=0
var goal=Vector3i(-1,-1,-1)
var path:Array=[]
var message="Select explored ground to mark a walking route."
var ghost=true
var view_button:Button
var map_button:Button
var controls_button:Button
var explore
var site=""
func _init(game):
 g=game
 view_button=g.small_button(g.ui,"Explore in 3D · F6",toggle_view);view_button.position=Vector2(744,154);view_button.size=Vector2(194,30)
 map_button=g.small_button(g.ui,"Depth map · Z",open_map);map_button.position=Vector2(744,118);map_button.size=Vector2(194,30)
 controls_button=g.small_button(g.ui,"Camera controls · F7",func():g.open_panel("camera_controls"));controls_button.position=Vector2(744,190);controls_button.size=Vector2(194,30)
 explore=HoldMineView94.new(g)
func reset():
 goal=Vector3i(-1,-1,-1);path.clear();site="";explore.enabled=explore.preferred;explore.invalidate()
func toggle_view():
 if g.zone!="mine" or not g.playing:return
 explore.enabled=not explore.enabled;explore.save_preference()
 g.notify("3D exploration · Mouse look · WASD move · Alt cursor · F7 controls" if explore.enabled and explore.mouse_look else "3D exploration · [ / ] camera · F7 controls" if explore.enabled else "Traditional overhead view · F6 explores in 3D")
 explore.sync(0)
func open_map():
 if g.zone!="mine":return
 viewed=g.deep.world.depth();g.open_panel("depth_map")
func input(e)->bool:
 if explore.active() and e is InputEventMouseButton and not explore.actions_allowed():
  g.hotbar.handle(e);return true
 if g.zone!="mine" or not e is InputEventKey or not e.pressed or e.echo:return false
 if e.keycode==KEY_F7 and g.panel_id in ["","camera_controls"]:g.toggle_panel("camera_controls");return true
 if e.keycode==KEY_F6 and g.panel_id=="":toggle_view();return true
 if e.keycode==KEY_Z and g.panel_id in ["","depth_map"]:
  if g.panel_id=="":open_map()
  else:g.close_panel()
  return true
 if g.panel_id=="depth_map" and e.keycode in [KEY_PAGEUP,KEY_PAGEDOWN]:
  viewed=clampi(viewed+(-1 if e.keycode==KEY_PAGEUP else 1),0,g.deep.world.data.layers.size()-1);g.refresh_panel();return true
 if explore.active() and g.panel_id=="" and e.keycode in [KEY_BRACKETLEFT,KEY_BRACKETRIGHT]:
  explore.yaw+=(-1 if e.keycode==KEY_BRACKETLEFT else 1)*PI/2;explore.invalidate();return true
 return false
func update(dt:float):
 var visible=g.playing and g.zone=="mine" and g.panel_id=="" and not g.deep.survey_open
 view_button.visible=visible;map_button.visible=visible;controls_button.visible=visible and explore.enabled
 if visible:
  if site!=g.state.active_site:site=g.state.active_site;goal=Vector3i(-1,-1,-1);path.clear()
  map_button.text="Depth %d · Map [Z]" % (g.deep.world.depth()+1)
  view_button.text="3D after building · F6" if explore.enabled and not explore.active() else "Overhead view · F6" if explore.enabled else "Explore in 3D · F6"
 explore.sync(dt)
func known(c:Vector2i,z:int)->bool:
 return g.deep.world.layer(z).seen.has(Deepworks.key(c))
func passable(c:Vector2i,z:int)->bool:
 return known(c,z) and g.deep.world.walkable(c,z)
func route_to(c:Vector2i,z:int):
 site=g.state.active_site
 path.clear();goal=Vector3i(-1,-1,-1)
 if not passable(c,z):message="Choose explored, walkable ground.";return
 var w=g.deep.world;var start=Deepworks.cell(g.player);var origin=Vector3i(start.x,start.y,w.depth());var target=Vector3i(c.x,c.y,z)
 var queue=[origin];var parents={origin:origin};var index=0
 var cart=not g.handworks.attached().is_empty() or (not g.deep.haul.cart().is_empty() and g.deep.haul.cart().get("hitched",false))
 while index<queue.size() and not parents.has(target):
  var p:Vector3i=queue[index];index+=1;var cell=Vector2i(p.x,p.y);var next=[]
  for dir in Deepworks.DIRS:next.append(Vector3i(p.x+dir.x,p.y+dir.y,p.z))
  for upper in [p.z-1,p.z]:
   if upper<0:continue
   var link=w.data.links.get(w.link_key(cell,upper),{})
   if not link.is_empty() and not (cart and link.kind=="ladder"):next.append(Vector3i(p.x,p.y,upper if p.z>upper else upper+1))
  for step in next:
   if step.z<0 or step.z>=w.data.layers.size() or parents.has(step) or not passable(Vector2i(step.x,step.y),step.z):continue
   parents[step]=p;queue.append(step)
 if not parents.has(target):message="No explored walking route"+(" for this cart. Ladders cannot carry carts." if cart else ". Check stairs and blocked landings.");return
 goal=target;var at=target
 while at!=origin:path.push_front(at);at=parents[at]
 path.push_front(origin)
 message="Route marked to depth %d. Follow the gold trail; stairs change floors." % (z+1)
func hint()->String:
 if goal.z<0:return "Z: depth map · F6: change view"
 var w=g.deep.world;var c=Deepworks.cell(g.player)
 if Vector3i(c.x,c.y,w.depth())==goal:return "Destination reached · Z selects another route"
 for i in range(path.size()-1):
  if path[i].z==w.depth() and path[i+1].z!=w.depth():return "Destination D%d · %s at the gold stair marker" % [goal.z+1,"E down" if path[i+1].z>w.depth() else "Shift+E up"]
 return "Destination D%d · follow the gold trail · Z replans" % (goal.z+1)
func panel():
 var w=g.deep.world
 var row=g.row(g.panel_body)
 for z in w.data.layers.size():
  var b=g.small_button(row,"D%d%s" % [z+1," · YOU" if z==w.depth() else ""],func():viewed=z;g.refresh_panel());b.toggle_mode=true;b.button_pressed=z==viewed;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 g.label(g.panel_body,"Viewing D%d · %s   |   Dwarf on D%d" % [viewed+1,Deepworks.NAMES[viewed],w.depth()+1],17)
 var split=g.row(g.panel_body)
 var map=FloorMap.new();map.nav=self;map.name="DepthFloorMap";map.custom_minimum_size=Vector2(510,250);split.add_child(map)
 var actions=VBoxContainer.new();actions.size_flags_horizontal=Control.SIZE_EXPAND_FILL;split.add_child(actions)
 g.small_button(actions,"Return to dwarf",func():viewed=w.depth();g.refresh_panel())
 var b=g.small_button(actions,"Adjacent floors: "+("shown" if ghost else "hidden"),func():ghost=not ghost;g.refresh_panel());b.toggle_mode=true;b.button_pressed=ghost
 g.small_button(actions,"Clear route",func():path.clear();goal=Vector3i(-1,-1,-1);message="Select explored ground to mark a walking route.";g.refresh_panel())
 g.label(actions,message,14)
 g.label(actions,"Gold: route · white: dwarf · cyan: stairs · faded: adjacent explored floor. Browsing pauses play; it never moves you.",14)
class FloorMap extends Control:
 var nav
 var scale_map=3.8
 var bounds=Rect2i(0,0,Deepworks.W,Deepworks.H)
 func fit():
  var found=false
  for z in [nav.viewed-1,nav.viewed,nav.viewed+1]:
   if z<0 or z>=nav.g.deep.world.data.layers.size() or (z!=nav.viewed and not nav.ghost):continue
   for key in nav.g.deep.world.layer(z).seen:
    var xy=key.split(",");var c=Vector2i(int(xy[0]),int(xy[1]))
    if not found:bounds=Rect2i(c,Vector2i.ONE);found=true
    else:bounds=bounds.merge(Rect2i(c,Vector2i.ONE))
  if found:bounds=bounds.grow(2)
  scale_map=minf(14,minf(size.x/bounds.size.x,size.y/bounds.size.y))
 func origin()->Vector2:return (size-Vector2(bounds.size)*scale_map)/2-Vector2(bounds.position)*scale_map
 func _gui_input(e):
  if e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_LEFT and e.pressed:
   var p=(e.position-origin())/scale_map;nav.route_to(Vector2i(floor(p.x),floor(p.y)),nav.viewed);nav.g.refresh_panel();accept_event()
 func _draw():
  fit();var w=nav.g.deep.world;var offset=origin();draw_rect(Rect2(Vector2.ZERO,size),Color("142934"))
  for y in Deepworks.H:
   for x in Deepworks.W:
    var c=Vector2i(x,y);var p=offset+Vector2(c)*scale_map
    if nav.ghost:
     for z in [nav.viewed-1,nav.viewed+1]:
      if z>=0 and z<w.data.layers.size() and nav.known(c,z) and w.at(c,z)==0:draw_rect(Rect2(p,Vector2.ONE*scale_map),Color("314449"))
    if not nav.known(c,nav.viewed):continue
    var k=w.at(c,nav.viewed);draw_rect(Rect2(p,Vector2.ONE*scale_map),Color("a4a591") if k==0 else nav.g.deep.ore_color(k).darkened(.4) if k in [3,4,5,6] else Color("58646a"))
  for step in nav.path:
   if step.z==nav.viewed:draw_circle(offset+(Vector2(step.x,step.y)+Vector2.ONE*.5)*scale_map,1.6,Color("ffd47d"))
  for link in w.data.links.values():
   var c=Vector2i(link.x,link.y)
   if nav.viewed not in [int(link.upper),int(link.lower)] or not nav.known(c,nav.viewed):continue
   draw_rect(Rect2(offset+(Vector2(c)+Vector2.ONE*.5)*scale_map-Vector2.ONE*3,Vector2.ONE*6),Color("73e1dc"),false,1.5)
  if nav.viewed==w.depth():draw_circle(offset+nav.g.player/Deepworks.TILE*scale_map,3,Color.WHITE)
  if nav.goal.z==nav.viewed:draw_arc(offset+(Vector2(nav.goal.x,nav.goal.y)+Vector2.ONE*.5)*scale_map,5,0,TAU,16,Color("ffd47d"),1.5)
