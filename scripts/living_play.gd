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
var page="Rooms"
var sparkle=0.0
var masonry:HoldMasonry
func _init(game,world:Deepworks):g=game;w=world;model=LivingWorks.new(g.state,w);masonry=HoldMasonry.new(g,w,model)
func cancel():
 if mode!="" or not pending.is_empty():g.deep.strike_left=0;g.deep.contact_hold=0
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
    var c=Deepworks.cell(g.world_mouse())
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
 var c=Deepworks.cell(g.world_mouse())
 var p=Deepworks.center(c)
 if mode=="quarry" and w.at(c)==0:return
 if mode=="dress" and masonry.bench(c).is_empty():return
 if p.distance_to(g.player)>105 or not w.visible(g.player,p):return
 g.tool=3
 pending={"mode":mode,"kind":selected,"cell":c}
 g.deep.target=c;g.deep.contact=p+Vector2(0,17) if mode=="dress" else p
 if mode=="quarry":
  for i in range(1,115):
   var edge=g.player+(p-g.player).normalized()*i
   if Deepworks.cell(edge)==c:g.deep.contact=edge;break
 g.deep.swing_duration=.32;g.deep.strike_left=.32;g.deep.struck=false;g.face=1 if p.x>=g.player.x else -1
 g.sound.effect("swing",-20)
func impact():
 var job=pending;pending={}
 if job.is_empty():return
 var c:Vector2i=job.cell
 if Deepworks.center(c).distance_to(g.player)>115 or not w.visible(g.player,Deepworks.center(c)):return
 var before={}
 for id in model.data.rooms:before[id]=int(model.data.rooms[id].metrics.score)
 var result=""
 match job.mode:
  "quarry":result=masonry.quarry(c)
  "dress":result=masonry.dress(c,job.kind=="stone")
  "furniture":
   var occupied=[Deepworks.cell(g.player)]
   for a in g.agents:
    if int(g.deep.crew_entry(a).depth)==w.depth():occupied.append(Deepworks.cell(a.p))
   result=model.place(c,job.kind,occupied)
  "finish":result=model.finish(c,job.kind)
  "remove":
   for id in masonry.data.jobs.keys():
    if masonry.data.jobs[id].bench==model.id_at(c):masonry.release(id)
   result=model.remove(c)
 if job.mode in ["quarry","dress"] and masonry.flash>0:
  g.sound.effect("stone",-14);g.deep.pulse=.12;g.save_game()
 var succeeded=result.ends_with("installed.") or result.ends_with("finished.") or result.begins_with("Dismantled carefully")
 if succeeded:
  var timber=job.kind in ["bench","bed","table","shelf","chair","timber"]
  g.sound.effect("wood" if timber else ("metal" if job.kind in ["anvil","lamp","inlay"] else "stone"),-14)
  g.deep.pulse=.12;sparkle=.4
  for id in model.data.rooms:
   var r=model.data.rooms[id];var gain=int(r.metrics.score)-int(before.get(id,0))
   if gain>0:result+=" "+r.name+" quality +"+str(gain)+"."
  g.save_game()
 g.notify(result)
 # Each furniture/removal click is deliberate; finishes can be painted by holding.
 if job.mode not in ["finish","quarry","dress"]:ready=false
func interact()->bool:
 for f in model.data.furniture.values():
  if f.kind=="mason" and int(f.depth)==w.depth() and g.player.distance_to(Deepworks.center(Vector2i(f.x,f.y)))<68:
   page="Masonry";g.open_panel("living");return true
 var r=model.at(Deepworks.cell(g.player))
 if r.is_empty() or not r.metrics.active:return false
 for f in model.data.furniture.values():
  if f.get("room","")==r.id and f.kind in ["bench","anvil"] and g.player.distance_to(Deepworks.center(Vector2i(f.x,f.y)))<68:
   g.open_panel("forge");return true
 return false
func panel():
 model.refresh()
 var tabs=g.row(g.menu_scroll.get_parent());g.menu_scroll.get_parent().move_child(tabs,g.menu_scroll.get_index())
 for name in ["Rooms","Furnish","Finishes","Folk","Masonry"]:
  var tab=g.small_button(tabs,name+(" •" if name=="Folk" and model.data.opportunity=="offered" else ""),func():page=name;g.open_panel("living",false))
  tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL;tab.toggle_mode=true;tab.button_pressed=page==name
 match page:
  "Masonry":masonry.panel()
  "Rooms":rooms_panel()
  "Furnish":catalog(false)
  "Finishes":catalog(true)
  "Folk":folk_panel()
func rooms_panel():
 g.label(g.panel_body,"Carve out a home",20,Color("edc98a"))
 g.label(g.panel_body,"Clear a 4 × 4 to 9 × 9 chamber, then choose its two corners.",14)
 var line=g.row(g.panel_body)
 for id in LivingWorks.FUNCTIONS:g.small_button(line,"Designate "+LivingWorks.FUNCTIONS[id].name,func():choose("room",id))
 var here=model.at(Deepworks.cell(g.player))
 if selected_room=="" and not here.is_empty():selected_room=here.id
 if not model.data.rooms.has(selected_room) and not model.data.rooms.is_empty():selected_room=model.data.rooms.keys()[0]
 if not model.data.rooms.is_empty():
  var selector=OptionButton.new();selector.custom_minimum_size.y=36;g.panel_body.add_child(selector)
  var ids=model.data.rooms.keys()
  for id in ids:
   var r=model.data.rooms[id];selector.add_item("%s · Depth %d · Quality %d" % [r.name,int(r.depth)+1,r.metrics.score])
  selector.selected=ids.find(selected_room)
  selector.item_selected.connect(func(index):selected_room=ids[index];g.open_panel("living",false))
 if model.data.rooms.has(selected_room):
  var room=model.data.rooms[selected_room];var q=room.metrics
  g.label(g.panel_body,room.name+" · "+("Ready to use" if q.active else "Needs: "+", ".join(q.missing)),18)
  g.label(g.panel_body,"Comfort %d/5 · Function %d/5 · Craft %.1f/6 · Heritage %d/3\nRepeated objects add no quality. Crowding penalty: %d. Keep the outer aisle open." % [q.comfort,q.function,q.craft,q.heritage,q.clutter],14)
  for a in g.agents:
   if a.type!="worker":continue
   var id=str(a.id)
   g.small_button(g.panel_body,"Assign "+g.state.npc(id).name+" to "+room.name,func():g.notify(model.assign(id,selected_room));g.save_game();g.open_panel("living",false))
  if g.agents.is_empty():g.label(g.panel_body,"Recruit a mining Dwarf at your claimed mountain, then assign a workshop or berth here. The employer's crew is not yours to relocate.",14)
func catalog(finishes:bool):
 g.label(g.panel_body,"Shape the stone" if finishes else "Made for Dwarven hands",20,Color("edc98a"))
 g.label(g.panel_body,"Choose a finish, then hold LMB to apply it. Costs are per tile." if finishes else "Choose a furnishing, then place it with a hammer strike. Costs use delivered supplies.",14)
 var grid=GridContainer.new();grid.columns=3;grid.add_theme_constant_override("h_separation",8);grid.add_theme_constant_override("v_separation",7);g.panel_body.add_child(grid)
 var definitions=LivingWorks.FINISHES if finishes else LivingWorks.FURNITURE
 for id in definitions:
  if id=="mason":continue # specialized bench lives on its teaching tab
  var def=definitions[id];var unlocked=model.unlocked(def)
  var cost="Handwork only" if def.cost.is_empty() else HoldData.cost_text(def.cost)
  var b=g.small_button(grid,def.name+"\n"+(cost if unlocked else "Requires "+str(HoldData.RESEARCH.get(def.tech,{}).get("name","Brann's carving"))),func():choose("finish" if finishes else "furniture",id))
  b.size_flags_horizontal=Control.SIZE_EXPAND_FILL;b.custom_minimum_size.y=48;b.add_theme_font_size_override("font_size",14)
  b.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS;b.tooltip_text=def.name+" · "+cost;b.disabled=not unlocked
 if finishes:g.small_button(g.panel_body,"Research construction capabilities",func():g.research_tab=1;g.open_panel("research"))
 else:g.small_button(g.panel_body,"Dismantle furnishing · recover its materials",func():choose("remove",""))
func folk_panel():
 g.label(g.panel_body,"THE FOLK",18)
 for id in model.data.assignments:
  var f=model.data.folk[id]
  g.label(g.panel_body,g.state.npc(id).name+" · "+f.activity+" · morale +"+str(int(f.morale))+"\n"+f.preference.interest+". Favors "+f.preference.style+"; enjoys "+f.preference.drink+".",14)
  g.button(g.panel_body,"Release "+g.state.npc(id).name+" to existing mining duties",func():masonry.release(id);model.data.assignments.erase(id);g.save_game();g.open_panel("living",false))
 g.label(g.panel_body,"Best staffed workshop: up to +10% crafting speed. Comfortable bedrooms improve morale. Unreachable rooms give no staffed benefit.",14)
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
 if g.panel_id!="":return
 var room=model.at(Deepworks.cell(g.player))
 if not room.is_empty():
  g.draw_style_box(chip(),Rect2(20,109,365,28))
  var detail="Quality %d" % room.metrics.score if room.metrics.active else "Needs furnishings"
  if room.id=="old_cutters":detail="Warm hearth" if HoldWorkplace98.warm(g) else "Cold hearth"
  A.text(g,Vector2(30,128),"O · %s · %s" % [room.name,detail],12,Color("e5c695"))
 if mode!="":
  g.draw_style_box(chip(),Rect2(230,392,500,37))
  var title=LivingWorks.FUNCTIONS.get(selected,{}).get("name",selected) if mode=="room" else (LivingWorks.FURNITURE if mode=="furniture" else LivingWorks.FINISHES).get(selected,{}).get("name","Dismantle")
  if mode=="quarry":title="Chisel a sound block"
  elif mode=="dress":title="Dress at mason’s bench"
  A.text(g,Vector2(244,416),str(title)+" · LMB work · Right mouse cancel",13,Color("edc489"))
func chip()->StyleBoxFlat:
 var style=StyleBoxFlat.new();style.bg_color=Color(.055,.12,.15,.92);style.set_corner_radius_all(5)
 style.border_color=Color(.55,.48,.31,.65);style.set_border_width_all(1);return style
func lamps()->Array:
 var result=[]
 if HoldWorkplace98.active(g) and HoldWorkplace98.warm(g):result.append(Deepworks.center(HoldWorkplace98.hearth(HoldWorkplace98.data(g))))
 for f in model.data.furniture.values():
  if int(f.depth)==w.depth() and f.kind=="lamp":result.append(Deepworks.center(Vector2i(f.x,f.y)))
 return result
func draw():
 masonry.draw()
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
  if kind=="ashlar":base=Color("a0afa2")
  g.draw_rect(Rect2(p,Vector2(40,40)),base.darkened(1-light))
  if kind=="timber":
   for j in 4:
    g.draw_line(p+Vector2(j*10,0),p+Vector2(j*10,40),Color("4c4638").darkened(1-light),1)
    g.draw_line(p+Vector2(j*10+3,6),p+Vector2(j*10+4,17+posmod(c.x+c.y+j,12)),Color("b39a6a").darkened(1-light),1)
  else:
   for j in 2:
    var y=j*20;g.draw_line(p+Vector2(0,y),p+Vector2(40,y),Color("354b52"),1)
    g.draw_line(p+Vector2(10+posmod(c.y+j,2)*20,y),p+Vector2(10+posmod(c.y+j,2)*20,y+20),Color("354b52"),1)
   g.draw_line(p+Vector2(2,2),p+Vector2(37,2),base.lightened(.15).darkened(1-light),1)
  for j in 7:
   var fleck=p+Vector2(posmod(c.x*13+j*17,36)+2,posmod(c.y*19+j*7,36)+2)
   g.draw_line(fleck,fleck+Vector2(2,0),base.lightened(.12).darkened(1-light),1)
  if kind=="ashlar":
   g.draw_rect(Rect2(p+Vector2(3,3),Vector2(34,34)),Color("ced0b2").darkened(1-light),false,1)
   g.draw_line(p+Vector2(5,35),p+Vector2(35,35),Color("4c6465").darkened(1-light),2)
  if kind in ["inlay","runic","ancestor"]:
   var q=p+Vector2(20,20);var col=Color("d6ae66").darkened(1-light)
   g.draw_polyline(PackedVector2Array([q+Vector2(0,-13),q+Vector2(-8,-4),q+Vector2(8,4),q+Vector2(0,13)]),col,2)
   g.draw_line(q+Vector2(0,-13),q+Vector2(0,13),col,1)
   if kind=="ancestor":g.draw_arc(q,13,0,TAU,12,col,1)
  if not floor:g.draw_rect(Rect2(p+Vector2(0,32),Vector2(40,8)),base.darkened(.5))
 for r in model.data.rooms.values():
  if int(r.depth)!=z:continue
  var rect=Rect2(r.x*40+2,r.y*40+2,r.w*40-4,r.h*40-4)
  if mode!="" or g.panel_id=="living":
   g.draw_rect(rect,Color(.8,.69,.43,.35),false,1)
   A.text(g,rect.position+Vector2(5,14),r.name.to_upper(),10,Color("d2bb8e"))
 for f in model.data.furniture.values():
  if int(f.depth)!=z:continue
  if f.get("room","")=="old_cutters":
   if w.layer().seen.has(Deepworks.key(Vector2i(f.x,f.y))):HoldWorkplace98.draw_furniture(g,f,Deepworks.center(Vector2i(f.x,f.y)))
  else:draw_furniture(f.kind,Deepworks.center(Vector2i(f.x,f.y)))
 if mode!="":
  var c=Deepworks.cell(g.world_mouse());var p=Vector2(c)*40
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
   for j in 4:g.draw_line(p+Vector2(-9+j*6,1),p+Vector2(-9+j*6,13),Color("689c91"),1)
   for x in [-14,14]:g.draw_line(p+Vector2(x,-20),p+Vector2(x,19),rim,3)
  "mason":
   var bench_id=model.id_at(Deepworks.cell(p))
   p+=Vector2(0,25)
   for x in [-15,15]:
    g.draw_line(p+Vector2(x,-8),p+Vector2(x,17),wood.darkened(.3),6)
    g.draw_line(p+Vector2(x-1,2),p+Vector2(x-1,15),wood.lightened(.12),1)
   g.draw_line(p+Vector2(-15,10),p+Vector2(15,10),wood,4)
   g.draw_rect(Rect2(p-Vector2(22,15),Vector2(44,25)),Color("293d46"))
   g.draw_rect(Rect2(p-Vector2(21,14),Vector2(42,18)),Color("71827e"))
   g.draw_line(p+Vector2(-20,-14),p+Vector2(20,-14),Color("c2ba96"),2)
   g.draw_line(p+Vector2(-21,5),p+Vector2(21,5),wood,4)
   for x in [-17,17]:g.draw_circle(p+Vector2(x,5),1.5,Color("c6b987"))
   HoldMasonry.block(g,p+Vector2(0,-8),masonry.data.bench_work.get(bench_id,{}).get("hits",0)>1,.65)
   g.draw_line(p+Vector2(14,-1),p+Vector2(18,-10),Color("243b44"),4)
   g.draw_line(p+Vector2(14,-1),p+Vector2(18,-10),Color("e1ce99"),2)
  "bench","table":
   for x in [-13,13]:g.draw_line(p+Vector2(x,-9),p+Vector2(x,14),wood.darkened(.25),4)
   g.draw_rect(Rect2(p-Vector2(17,13),Vector2(34,22)),wood);g.draw_rect(Rect2(p-Vector2(17,13),Vector2(34,4)),rim)
   for y in [-5,3]:g.draw_line(p+Vector2(-15,y),p+Vector2(15,y),wood.darkened(.3),1)
   for x in [-14,14]:
    for y in [-10,6]:g.draw_circle(p+Vector2(x,y),1,Color("dec79a"))
   if kind=="table":
    g.draw_circle(p+Vector2(8,-3),4,Color("bea76f"));g.draw_circle(p+Vector2(8,-3),2,Color("3c3430"))
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
   HoldMasonryArt.pillar(g,p+Vector2(0,16),70)
   if kind=="rune":
    g.draw_polyline(PackedVector2Array([p+Vector2(0,-34),p+Vector2(4,-26),p+Vector2(-4,-19),p+Vector2(0,-12)]),Color("bde5d6"),1.3,true)
  "chair":
   g.draw_rect(Rect2(p-Vector2(9,6),Vector2(18,18)),wood);g.draw_rect(Rect2(p-Vector2(11,17),Vector2(22,13)),rim)
   g.draw_line(p+Vector2(-7,-14),p+Vector2(7,-14),Color("445e66"),2)
