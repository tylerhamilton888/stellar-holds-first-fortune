class_name LivingPlay
extends RefCounted
const A=preload("res://scripts/art.gd")
var g
var w:Deepworks
var model:LivingWorks
var mode=""
var selected=""
var corner=Vector2i(-1,-1)
var pending:Dictionary={}
var ready=false
var selected_room=""
var sparkle=0.0
func _init(game,world:Deepworks):g=game;w=world;model=LivingWorks.new(g.state,w)
func cancel():
 if not pending.is_empty():g.deep.strike_left=0;g.deep.contact_hold=0
 mode="";pending={};corner=Vector2i(-1,-1);ready=false
func choose(action:String,id:String):
 cancel();mode=action;selected=id;g.close_panel();g.tool=3;g.mining_gun.selected=false
 g.notify("Click two corners of clear floor." if action=="room" else "Aim nearby and hold LMB to work. Right mouse cancels. O reopens the works board.")
func input(e:InputEvent)->bool:
 if mode=="":return false
 if e is InputEventKey and e.pressed and e.keycode==KEY_ESCAPE:cancel();return true
 if e is InputEventMouseButton:
  if e.button_index==MOUSE_BUTTON_RIGHT and e.pressed:cancel();return true
  if e.button_index==MOUSE_BUTTON_LEFT:
   if not e.pressed:ready=true;return true
   if mode=="room" and ready:
    var c=Deepworks.cell(g.get_global_mouse_position()+g.camera)
    if Deepworks.center(c).distance_to(g.player)>280:g.notify("Move closer to the room's corners.");return true
    if corner.x<0:corner=c;g.notify("First corner set. Click the opposite corner.")
    else:
     var before=model.data.rooms.size();g.notify(model.designate(corner,c,selected));corner=Vector2i(-1,-1)
     if model.data.rooms.size()>before:g.sound.effect("build");g.save_game();cancel()
   return true
 return false
func begin():
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):ready=true;return
 if not ready or mode=="room" or not pending.is_empty():return
 var c=Deepworks.cell(g.get_global_mouse_position()+g.camera)
 var p=Deepworks.center(c)
 if p.distance_to(g.player)>105 or not w.visible(g.player,p):return
 g.tool=3
 pending={"mode":mode,"kind":selected,"cell":c}
 g.deep.target=c;g.deep.contact=p;g.deep.swing_duration=.32;g.deep.strike_left=.32;g.deep.struck=false;g.face=1 if p.x>=g.player.x else -1
 g.sound.effect("swing",-20)
func impact():
 var job=pending;pending={}
 if job.is_empty():return
 var c:Vector2i=job.cell
 if Deepworks.center(c).distance_to(g.player)>115 or not w.visible(g.player,Deepworks.center(c)):return
 var result=""
 match job.mode:
  "furniture":
   var occupied=[Deepworks.cell(g.player)]
   for a in g.agents:
    if int(g.deep.crew_entry(a).depth)==w.depth():occupied.append(Deepworks.cell(a.p))
   result=model.place(c,job.kind,occupied)
  "finish":result=model.finish(c,job.kind)
  "remove":result=model.remove(c)
 g.notify(result);g.sound.effect("build",-14);g.deep.pulse=.12;sparkle=.4;g.save_game()
 # Each furniture/removal click is deliberate; finishes can be painted by holding.
 if job.mode!="finish":ready=false
func interact()->bool:
 var r=model.at(Deepworks.cell(g.player))
 if r.is_empty() or not r.metrics.active:return false
 for f in model.data.furniture.values():
  if f.room==r.id and f.kind in ["bench","anvil"] and g.player.distance_to(Deepworks.center(Vector2i(f.x,f.y)))<68:
   g.open_panel("forge");return true
 return false
func panel():
 model.refresh();g.label(g.panel_body,"THE LIVING WORKS",21)
 g.label(g.panel_body,"Excavate a 4 x 4 to 9 x 9 chamber. Designate two corners, then fit it out. O returns here; right mouse cancels placement. Hold Shift with the pick for selective ore extraction; hammer [4] breaks fractured faces efficiently.",15)
 var line=g.row(g.panel_body)
 for id in LivingWorks.FUNCTIONS:g.small_button(line,"Designate "+LivingWorks.FUNCTIONS[id].name,func():choose("room",id))
 var here=model.at(Deepworks.cell(g.player))
 if selected_room=="" and not here.is_empty():selected_room=here.id
 if not model.data.rooms.has(selected_room) and not model.data.rooms.is_empty():selected_room=model.data.rooms.keys()[0]
 for r in model.data.rooms.values():
  g.button(g.panel_body,"%s · D%d · quality %d · %s" % [r.name,int(r.depth)+1,r.metrics.score,"FUNCTIONAL" if r.metrics.active else "needs furnishings"],func():selected_room=r.id;g.open_panel("living",false))
 if model.data.rooms.has(selected_room):
  var room=model.data.rooms[selected_room];var q=room.metrics
  g.label(g.panel_body,room.name+" · "+("Ready to use" if q.active else "Needs: "+", ".join(q.missing)),18)
  g.label(g.panel_body,"Comfort %d/5 · Function %d/5 · Craft %.1f/6 · Heritage %d/3\nRepeated objects add no quality. Crowding penalty: %d. Keep the outer aisle open." % [q.comfort,q.function,q.craft,q.heritage,q.clutter],14)
  for a in g.agents:
   if a.type!="worker":continue
   var id=str(a.id)
   g.button(g.panel_body,"Assign "+g.state.npc(id).name+" to "+room.name,func():g.notify(model.assign(id,selected_room));g.save_game();g.open_panel("living",false))
  if g.agents.is_empty():g.label(g.panel_body,"Recruit a mining Dwarf at your claimed mountain, then assign a workshop or berth here. The employer's crew is not yours to relocate.",14)
 g.label(g.panel_body,"FURNISH · costs use delivered supplies",18)
 for id in LivingWorks.FURNITURE:
  var def=LivingWorks.FURNITURE[id];var b=g.button(g.panel_body,def.name+" · "+HoldData.cost_text(def.cost)+( "" if model.unlocked(def) else " · research required"),func():choose("furniture",id))
  b.disabled=not model.unlocked(def)
 g.button(g.panel_body,"Dismantle furnishing · recover its materials",func():choose("remove",""))
 g.label(g.panel_body,"FINISH · per tile · rough surfaces remain useful",18)
 for id in LivingWorks.FINISHES:
  var def=LivingWorks.FINISHES[id];var b=g.button(g.panel_body,def.name+" · "+("handwork only" if def.cost.is_empty() else HoldData.cost_text(def.cost))+("" if model.unlocked(def) else " · locked"),func():choose("finish",id))
  b.disabled=not model.unlocked(def)
 g.button(g.panel_body,"Research construction capabilities",func():g.open_panel("research"))
 g.label(g.panel_body,"THE FOLK",18)
 for id in model.data.assignments:
  var f=model.data.folk[id]
  g.label(g.panel_body,g.state.npc(id).name+" · "+f.activity+" · morale +"+str(f.morale)+"\n"+f.preference.interest+". Favors "+f.preference.style+"; enjoys "+f.preference.drink+".",14)
  g.button(g.panel_body,"Release "+g.state.npc(id).name+" to existing mining duties",func():model.data.assignments.erase(id);g.save_game();g.open_panel("living",false))
 g.label(g.panel_body,"A staffed, usable workshop gives up to 10% production speed. Only the best staffed room counts. A comfortable berth supports modest morale and mining rhythm. Dwarfs use real routes; unreachable rooms give no staffed benefit. No mandatory sleep or daily upkeep chores.",14)
 if model.data.opportunity!="":
  g.label(g.panel_body,"BRANN · A MARK WORTH LEAVING",18,Color("eac487"))
  if model.data.opportunity=="complete":g.label(g.panel_body,"The Rivethand knotwork is yours. Brann's two machine parts are in stores.",15)
  else:
   g.label(g.panel_body,"'A bench is a beginning. Give this room a finished floor and an ancestral pillar, and I will show you the knot my father cut into his first hold.'\nImprove Brann's workshop to quality 55, craftsmanship 2, with an ancestral pillar. Reward: Rivethand wall carving and 2 machine parts.",15)
   var b=g.button(g.panel_body,"Invite Brann to carve the first mark",func():
    if model.complete_opportunity():g.sound.effect("crystal");g.notify("Rivethand knotwork unlocked. Brann crafted two machine parts.");g.save_game()
    g.open_panel("living",false))
   b.disabled=not model.opportunity_ready()
func hud():
 var room=model.at(Deepworks.cell(g.player))
 if not room.is_empty():A.text(g,Vector2(24,165),"O · "+room.name+(" · E AT BENCH" if room.kind=="workshop" and room.metrics.active else "")+" · QUALITY %d · %s" % [room.metrics.score,"FUNCTIONAL" if room.metrics.active else "FURNISH TO ACTIVATE"],12,Color("e5c695"))
 else:A.text(g,Vector2(24,165),"O · LIVING WORKS · ROOMS / FURNISHINGS",12,Color("c8c7b0"))
 if mode!="":
  g.draw_rect(Rect2(235,390,490,34),Color("172b32"))
  A.text(g,Vector2(248,412),"%s · %s · RIGHT MOUSE CANCEL" % [mode.to_upper(),selected.to_upper()],13,Color("edc489"))
 if model.data.opportunity=="offered":A.text(g,Vector2(24,184),"BRANN HAS AN IDEA · O: THE FOLK",12,Color("eac487"))
func lamps()->Array:
 var result=[]
 for f in model.data.furniture.values():
  if int(f.depth)==w.depth() and f.kind=="lamp":result.append(Deepworks.center(Vector2i(f.x,f.y)))
 return result
func draw():
 var z=w.depth();var lights=lamps()
 for surface in model.data.surfaces.values():
  if int(surface.depth)!=z:continue
  var c=Vector2i(surface.x,surface.y)
  if not w.layer().seen.has(Deepworks.key(c)):continue
  var floor=surface.surface=="floor"
  if floor!=(w.at(c)==0):continue
  var p=Vector2(c)*40;var kind=surface.kind
  var light=clampf(1.1-Deepworks.center(c).distance_to(g.player)/500,.4,1)
  for lamp in lights:light=maxf(light,clampf(1.05-lamp.distance_to(Deepworks.center(c))/290,0,.95))
  var base=Color("8b7653") if kind=="timber" else Color("687972")
  base=base.lightened(float(posmod(c.x*17+c.y*31,7))*.009)
  if kind in ["runic","ancestor","inlay"]:base=Color("536c71")
  g.draw_rect(Rect2(p,Vector2(40,40)),base.darkened(1-light))
  if kind=="timber":
   for j in 4:
    g.draw_line(p+Vector2(j*10,0),p+Vector2(j*10,40),Color("4c4638").darkened(1-light),1)
    g.draw_line(p+Vector2(j*10+3,6),p+Vector2(j*10+4,31),Color("b39a6a").darkened(1-light),1)
  else:
   for j in 2:
    var y=j*20;g.draw_line(p+Vector2(0,y),p+Vector2(40,y),Color("354b52"),1)
    g.draw_line(p+Vector2(10+j*20,y),p+Vector2(10+j*20,y+20),Color("354b52"),1)
   g.draw_line(p+Vector2(2,2),p+Vector2(37,2),base.lightened(.15).darkened(1-light),1)
  for j in 7:
   var fleck=p+Vector2(posmod(c.x*13+j*17,36)+2,posmod(c.y*19+j*7,36)+2)
   g.draw_line(fleck,fleck+Vector2(2,0),base.lightened(.12).darkened(1-light),1)
  if kind in ["inlay","runic","ancestor"]:
   var q=p+Vector2(20,20);var col=Color("d6ae66").darkened(1-light)
   g.draw_polyline(PackedVector2Array([q+Vector2(0,-13),q+Vector2(-8,-4),q+Vector2(8,4),q+Vector2(0,13)]),col,2)
   g.draw_line(q+Vector2(0,-13),q+Vector2(0,13),col,1)
   if kind=="ancestor":g.draw_arc(q,13,0,TAU,12,col,1)
  if not floor:g.draw_rect(Rect2(p+Vector2(0,32),Vector2(40,8)),base.darkened(.5))
 for r in model.data.rooms.values():
  if int(r.depth)!=z:continue
  var rect=Rect2(r.x*40+2,r.y*40+2,r.w*40-4,r.h*40-4)
  g.draw_rect(rect,Color(.8,.69,.43,.35),false,1)
  A.text(g,rect.position+Vector2(5,14),r.name.to_upper(),10,Color("d2bb8e"))
 for f in model.data.furniture.values():
  if int(f.depth)==z:draw_furniture(f.kind,Deepworks.center(Vector2i(f.x,f.y)))
 if mode!="":
  var c=Deepworks.cell(g.get_global_mouse_position()+g.camera);var p=Vector2(c)*40
  if mode=="room" and corner.x>=0:
   var left=Vector2(mini(c.x,corner.x),mini(c.y,corner.y))*40
   var size=Vector2(absi(c.x-corner.x)+1,absi(c.y-corner.y)+1)*40
   g.draw_rect(Rect2(left,size),Color(.8,.7,.4,.16));g.draw_rect(Rect2(left,size),Color("e7c583"),false,2)
  else:
   g.draw_rect(Rect2(p,Vector2(40,40)),Color(.9,.75,.4,.25));g.draw_rect(Rect2(p,Vector2(40,40)),Color("e7c583"),false,2)
func draw_furniture(kind:String,p:Vector2):
 var wood=Color("896440");var rim=Color("c7a16c");var iron=Color("536a70")
 g.draw_circle(p+Vector2(0,7),18,Color(0,0,0,.26))
 match kind:
  "lamp":g.deep.lamp(p);return
  "bed":
   g.draw_rect(Rect2(p-Vector2(14,18),Vector2(28,36)),wood)
   g.draw_rect(Rect2(p-Vector2(11,12),Vector2(22,27)),Color("457d79"))
   g.draw_rect(Rect2(p-Vector2(10,15),Vector2(20,9)),Color("dbcf9e"))
   g.draw_line(p+Vector2(-11,2),p+Vector2(11,2),Color("d7bb80"),2)
   for x in [-14,14]:g.draw_line(p+Vector2(x,-20),p+Vector2(x,19),rim,3)
  "bench","table":
   for x in [-13,13]:g.draw_line(p+Vector2(x,-9),p+Vector2(x,14),wood.darkened(.25),4)
   g.draw_rect(Rect2(p-Vector2(17,13),Vector2(34,22)),wood);g.draw_rect(Rect2(p-Vector2(17,13),Vector2(34,4)),rim)
   for y in [-5,3]:g.draw_line(p+Vector2(-15,y),p+Vector2(15,y),wood.darkened(.3),1)
   if kind=="bench":
    g.draw_line(p+Vector2(-9,-8),p+Vector2(5,3),rim,3);g.draw_rect(Rect2(p+Vector2(1,-1),Vector2(10,4)),iron.lightened(.25))
    g.draw_rect(Rect2(p+Vector2(8,-12),Vector2(7,9)),iron)
  "anvil":
   g.draw_rect(Rect2(p-Vector2(15,16),Vector2(30,29)),Color("596a6b"))
   for j in 3:g.draw_line(p+Vector2(-15,-10+j*9),p+Vector2(15,-10+j*9),Color("34464b"),2)
   g.draw_rect(Rect2(p-Vector2(9,11),Vector2(18,12)),Color("2c3338"))
   for j in 5:g.draw_circle(p+Vector2(j*3-6,-4),3+sin(g.clock*4+j),Color("e49a50"))
   g.draw_colored_polygon(PackedVector2Array([p+Vector2(-17,0),p+Vector2(16,0),p+Vector2(8,5),p+Vector2(7,11),p+Vector2(-8,11),p+Vector2(-7,5)]),iron.lightened(.25))
   g.draw_line(p+Vector2(-16,0),p+Vector2(14,0),Color("d3d5bf"),2)
  "shelf":
   g.draw_rect(Rect2(p-Vector2(17,15),Vector2(34,30)),wood.darkened(.3))
   for y in [-14,0,14]:g.draw_line(p+Vector2(-17,y),p+Vector2(17,y),rim,3)
   for j in 6:g.draw_rect(Rect2(p+Vector2(-13+j%3*10,-12+j/3*14),Vector2(6,9)),Color("839893") if j%2 else Color("b18d57"))
  "pillar","rune":
   g.draw_rect(Rect2(p-Vector2(13,13),Vector2(26,29)),Color("455c62"))
   g.draw_rect(Rect2(p-Vector2(10,18),Vector2(20,30)),Color("8c9b93"));g.draw_rect(Rect2(p-Vector2(14,21),Vector2(28,7)),Color("a9b3a1"))
   if kind=="rune":
    g.draw_line(p+Vector2(0,-12),p+Vector2(0,8),rim,2)
    g.draw_polyline(PackedVector2Array([p+Vector2(0,-12),p+Vector2(6,-6),p+Vector2(-6,1),p+Vector2(0,8)]),rim,2)
  "chair":
   g.draw_rect(Rect2(p-Vector2(9,6),Vector2(18,18)),wood);g.draw_rect(Rect2(p-Vector2(11,17),Vector2(22,13)),rim)
   g.draw_line(p+Vector2(-7,-14),p+Vector2(7,-14),Color("445e66"),2)
