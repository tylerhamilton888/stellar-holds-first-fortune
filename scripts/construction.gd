class_name HoldConstruction
extends RefCounted
const OPTIONS={"stairs_right":{"name":"Stairs rising right","cost":{"wood":2}},"stairs_left":{"name":"Stairs rising left","cost":{"wood":2}},"platform":{"name":"Timber platform","cost":{"wood":2}},"support":{"name":"Braced roof frame","cost":{"wood":4,"stone":2}},"ladder":{"name":"Ladder section","cost":{"wood":2}},"remove_ladder":{"name":"Dismantle ladder","cost":{}}}
var g
var selected=""
func _init(game):g=game
func site()->String:return str(g.geo.seed_value)+"/"+g.state.active_site
func ladders()->Array:
 if not g.state.ladders.has(site()):g.state.ladders[site()]=[]
 return g.state.ladders[site()]
func ladder_rect(data:Array)->Rect2:return Rect2(float(data[0]),float(data[1]),56,126)
func on_ladder(p:Vector2)->bool:
 for data in ladders():
  if ladder_rect(data).grow(7).intersects(g.body_bounds(p)):return true
 return false
func ladder_center(p:Vector2)->float:
 for data in ladders():
  if ladder_rect(data).grow(7).intersects(g.body_bounds(p)):return ladder_rect(data).get_center().x
 return p.x
func footprint(c:Vector2i)->Array[Vector2i]:
 var cells:Array[Vector2i]=[]
 if selected in ["stairs_left","stairs_right"]:
  for x in 8:
   var height=1+int((x if selected=="stairs_right" else 7-x)/2)
   for y in height:cells.append(c+Vector2i(x,-y))
 elif selected=="platform":
  for x in 8:cells.append(c+Vector2i(x,0))
 elif selected=="support":
  for x in 12:cells.append(c+Vector2i(x,-12))

 return cells
func target()->Vector2i:return g.geo.cell_at(g.get_global_mouse_position()+g.camera)
func reason(c:Vector2i)->String:
 if g.zone!="mine" or g.room_id!="":return "Construction is available inside mines."
 if selected=="":return "Choose a structure with V."
 if g.geo.center(c).distance_to(g.player+Vector2(0,-30))>110:return "Move closer to the building site."
 if not g.geo.visible_from(g.player+Vector2(0,-30),c):return "The rock blocks access to this site."
 if selected=="remove_ladder":return ""
 if not g.state.afford(OPTIONS[selected].cost):return "Not enough materials."
 if selected=="ladder":
  var rect=Rect2(Vector2(c)*7,Vector2(56,126))
  for data in ladders():
   if rect.intersects(ladder_rect(data)):return "There is already a ladder here."
  for x in 8:
   for y in 18:
    if g.geo.at(c.x+x,c.y+y) not in [0,12]:return "Clear the ladder space first."
  var fixed=g.geo.solid(Vector2(rect.get_center().x,rect.end.y+1)) or g.geo.solid(rect.position+Vector2(-7,63)) or g.geo.solid(rect.position+Vector2(63,63))
  for data in ladders():
   if rect.grow(3).intersects(ladder_rect(data)):fixed=true
  return "" if fixed else "Anchor a ladder to rock, a floor, or another ladder."
 if selected=="support":
  if g.geo.at(c.x,c.y+1) in [0,12,13] or g.geo.at(c.x+11,c.y+1) in [0,12,13]:return "Both frame feet need firm ground."
  for y in 12:
   if g.geo.at(c.x,c.y-y) not in [0,12] or g.geo.at(c.x+11,c.y-y) not in [0,12]:return "Clear space for both posts."
 var cells=footprint(c)
 var attached=selected=="support"
 for cell in cells:
  if g.geo.at(cell.x,cell.y)!=0:return "Clear the building footprint first."
  var rect=Rect2(Vector2(cell)*7,Vector2(7,7))
  if rect.intersects(g.body_bounds(g.player)):return "Do not build into yourself."
  for e in g.combat.enemies:
   if e.hp>0 and rect.intersects(Rect2(e.p-Vector2(22,50),Vector2(44,50))):return "The site is occupied."
  for d in [Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]:
   if not cell+d in cells and g.geo.at(cell.x+d.x,cell.y+d.y) not in [0,12]:attached=true
 return "" if attached else "Attach the structure to existing ground or a wall."
func place(c:Vector2i)->bool:
 var problem=reason(c)
 if problem!="":g.notify(problem);return false
 if selected=="remove_ladder":
  for i in range(ladders().size()-1,-1,-1):
   if ladder_rect(ladders()[i]).grow(6).has_point(g.geo.center(c)):
    ladders().remove_at(i);g.state.add("wood",1);g.save_game();return true
  g.notify("Point at a ladder to dismantle it.");return false
 if not g.state.pay(OPTIONS[selected].cost):return false
 if selected=="ladder":ladders().append([c.x*7,c.y*7])
 else:
  for cell in footprint(c):g.geo.set_cell(cell,13);g.geo.activate_near(cell)
  if selected=="support":g.geo.structures.append({"x":c.x,"y":c.y})
 if selected in ["stairs_left","stairs_right","ladder","support"]:HoldOnboarding.fact(g.state,"built")
 HoldClaimStories.on_build(g,c,selected)
 g.sound.effect("build",-8);g.save_game();return true
func draw():
 if g.zone!="mine":return
 for data in ladders():
  var r=ladder_rect(data)
  for x in [r.position.x+7,r.end.x-7]:
   g.draw_line(Vector2(x,r.position.y),Vector2(x,r.end.y),Color("b09065"),3)
   g.draw_line(Vector2(x+1,r.position.y),Vector2(x+1,r.end.y),Color("e1c597"),1)
  for y in range(int(r.position.y)+5,int(r.end.y),9):g.draw_line(Vector2(r.position.x+7,y),Vector2(r.end.x-7,y),Color("c2a16f"),3)
 if selected=="" or g.panel_id!="":return
 var c=target();var color=Color(.55,.9,.75,.45) if reason(c)=="" else Color(1,.45,.3,.4)
 if selected in ["ladder","remove_ladder"]:g.draw_rect(Rect2(Vector2(c)*7,Vector2(56,126)),color,false,2)
 else:
  for cell in footprint(c):g.draw_rect(Rect2(Vector2(cell)*7,Vector2(7,7)),color)
func panel():
 g.label(g.panel_body,"Build your way back. Point within reach, then click to place. Stairs and platforms are solid; W/S climbs a nearby ladder. 1–4 returns to tools.",16)
 for id in OPTIONS:
  var entry=OPTIONS[id]
  var b=g.button(g.panel_body,entry.name+(" — "+HoldData.cost_text(entry.cost) if not entry.cost.is_empty() else " — recover 1 timber"),func():g.mining_gun.selected=false;selected=id;g.combat.armed=false;g.combat.reset_actions();g.swing=0;g.close_panel();g.notify(entry.name+": point and click to place. 1–4 cancels."))
  b.disabled=not g.state.afford(entry.cost)
  if b.disabled:g.label(g.panel_body,g.requirements(entry.cost),16,Color("b4c9c4"))
 g.label(g.panel_body,"Roof frames catch falling loose earth. They do not require repairs on a timer. Mine timber structures to remove them. Emergency extraction costs crowns; R shows the price before you commit.",16)

func maintain():
 # Posts stand beside the walking lane; only the overhead lintel is solid.
 # Remove a frame immediately when either footing or its lintel is mined away.
 var roof_anchors={}
 for i in range(g.geo.structures.size()-1,-1,-1):
  var frame=g.geo.structures[i];var valid=true
  for x in [int(frame.x),int(frame.x)+11]:
   if g.geo.at(x,int(frame.y)+1) in [0,12,13]:valid=false
  for x in range(int(frame.x),int(frame.x)+12):
   if g.geo.at(x,int(frame.y)-12)!=13:valid=false
  if not valid:
   for x in range(int(frame.x),int(frame.x)+12):
    var c=Vector2i(x,int(frame.y)-12)
    if g.geo.at(c.x,c.y)==13:g.geo.set_cell(c,0);g.geo.activate_near(c)
   g.geo.structures.remove_at(i);g.state.add("wood",2)
   g.notify("Unseated roof frame dismantled; 2 timber recovered.")
  else:
   for x in range(int(frame.x),int(frame.x)+12):roof_anchors[(int(frame.y)-12)*Geology.W+x]=true
 var visited={}
 for raw in g.geo.timbers.keys():
  var index=int(raw)
  if visited.has(index):continue
  var pending=[index];var component=[];var anchored=false
  visited[index]=true
  while not pending.is_empty():
   var current=int(pending.pop_back());component.append(current)
   if roof_anchors.has(current):anchored=true
   var c=Vector2i(current%Geology.W,current/Geology.W)
   for delta in [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]:
    var q=c+delta;var kind=g.geo.at(q.x,q.y);var next=q.y*Geology.W+q.x
    if kind not in [0,12,13]:anchored=true
    if kind==13 and not visited.has(next):visited[next]=true;pending.append(next)
  if not anchored:
   for current in component:
    var c=Vector2i(current%Geology.W,current/Geology.W)
    g.geo.set_cell(c,0);g.geo.activate_near(c)
   g.state.add("wood",maxi(1,component.size()/16))
 # Ladders must ultimately lead to terrain, not form a floating chain.
 var anchored_ladders={};var changed=true
 while changed:
  changed=false
  for i in ladders().size():
   if anchored_ladders.has(i):continue
   var rect=ladder_rect(ladders()[i]);var fixed=false
   for point in [Vector2(rect.get_center().x,rect.end.y+1),rect.position+Vector2(-7,63),rect.position+Vector2(63,63)]:
    if g.geo.at_pos(point) not in [0,12]:fixed=true
   for j in anchored_ladders:
    if rect.grow(3).intersects(ladder_rect(ladders()[j])):fixed=true
   if fixed:anchored_ladders[i]=true;changed=true
 for i in range(ladders().size()-1,-1,-1):
  if not anchored_ladders.has(i):ladders().remove_at(i);g.state.add("wood",1)
 g.geo.structure_dirty=false
