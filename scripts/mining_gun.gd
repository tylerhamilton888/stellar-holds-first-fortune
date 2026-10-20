class_name HoldMiningGun
extends RefCounted
const RANGE=180.0
const RADIUS=18.0
var g
var selected=false
var cool=0.0
var flash=0.0
var braced=0.0
var endpoint=Vector2.ZERO
var direction=Vector2.RIGHT
func _init(game):g=game
func equip():
 if g.room_id!="":g.notify("Equip the slagcaster outside, at a mining face.");return
 if not g.state.outpost.get("mining_gun",false):g.notify("Fabricate a slagcaster at a powered forge • Industry tab.");return
 selected=true;g.swing=0;g.combat.armed=false;g.combat.reset_actions();g.construction.selected="";g.mining_buffer=0
 g.notify("SLAGCASTER • Hold LMB • cells auto-load on contact • heat destroys coal and roots")
func status()->String:return "Slagcaster • %d charge / %d cells" % [g.state.outpost.get("gun_charge",0),g.state.count("energy_cell")]
static func trace(geo,origin:Vector2,aim:Vector2)->Dictionary:
 var delta=aim-origin
 if delta.length()<1:return {}
 var dir=delta.normalized()
 for step in range(1,int(minf(RANGE,delta.length()))+1,2):
  var p=origin+dir*step;var c=geo.cell_at(p);var kind=geo.at(c.x,c.y)
  if kind==0:continue
  return {"p":p,"cell":c,"kind":kind,"distance":step}
 return {}
static func fire(s,geo,origin:Vector2,aim:Vector2)->Dictionary:
 if not s.outpost.get("mining_gun",false):return {"error":"Slagcaster not built"}
 var contact=trace(geo,origin,aim)
 if contact.is_empty():return {"error":"Aim at an exposed rock face"}
 if contact.kind in [8,10,12,13]:return {"error":"Boundary, timber and water block the beam"}
 if contact.distance<27:return {"error":"Step back to clear the muzzle"}
 var charge=int(s.outpost.get("gun_charge",0))
 if charge<=0:
  if s.count("energy_cell")<=0:return {"error":"No energy • craft runic cells at a forge"}
  s.add("energy_cell",-1)
  charge=24 if maxi(HoldIndustry.tier(s),HoldIndustry.tier(s,"hold"))>=2 else 16
 # Full-power pulses cleave a single exposed layer; the snapshot prevents wall piercing.
 var results=geo.excavate(contact.p,origin,RADIUS,30.0,true,true,true)
 if results.is_empty():
  # The pulse was blocked after tracing: retain the loaded cell without spending a charge.
  s.outpost.gun_charge=charge;return {"error":"No exposed surface"}
 s.outpost.gun_charge=charge-1
 for result in results:
  HoldClaimStories.notice_ore(s,geo,result)
  if result.count>0:s.add(result.item,result.count)
  s.mined+=1
  if result.kind==6 and not s.discovered:s.discovered=true;s.money+=40
 return {"contact":contact,"results":results}
func update():
 if not g.state.outpost.get("mining_gun",false):selected=false;return
 if braced>0:g.face=1 if direction.x>=0 else -1
 if g.zone!="mine" or cool>0:return
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and g.mining_buffer<=0:return
 g.mining_buffer=0
 var aim=g.get_global_mouse_position()+g.camera
 if absf(aim.x-g.player.x)>8:g.face=1 if aim.x>g.player.x else -1
 var hand=g.player+HoldCharacterArt.work_hand(4,g.state.appearance)*Vector2(g.face,1)
 var angle=clampf(atan2(aim.y-hand.y,absf(aim.x-hand.x)),-.85,.85)
 direction=Vector2(g.face*cos(angle),sin(angle))
 # A forward hand must not shoot through a wall overlapping the body.
 if not trace(g.geo,g.player+Vector2(0,-29),hand).is_empty():cool=.3;g.notify("Step back to clear the muzzle");return
 var result=fire(g.state,g.geo,hand,hand+direction*RANGE)
 cool=.24
 if result.has("error"):g.notify(result.error);cool=.6;return
 endpoint=result.contact.p;flash=.12;braced=.30
 g.sound.effect("thermal_pulse",-9)
 g.burst(endpoint,Color("ffc58b"),6)
 g.reveal_discoveries()
 g.impact_flashes.append({"p":endpoint,"life":.1,"broken":true})
func draw():
 if not selected:return
 if g.zone=="mine" and g.panel_id=="":
  var aim=g.get_global_mouse_position()+g.camera
  var face=1 if aim.x>=g.player.x else -1
  var preview_hand=g.player+HoldCharacterArt.work_hand(4,g.state.appearance)*Vector2(face,1)
  var a=clampf(atan2(aim.y-preview_hand.y,absf(aim.x-preview_hand.x)),-.85,.85)
  var target=trace(g.geo,preview_hand,preview_hand+Vector2(face*cos(a),sin(a))*RANGE)
  if not target.is_empty():
   var color=Color("d99368") if target.kind in [5,9] else Color("97d3bb")
   if target.kind in [8,10,12,13] or target.distance<27:color=Color("b37777")
   g.draw_arc(target.p,RADIUS,0,TAU,20,color,1)
 var firing=braced>0
 var frame=4 if firing else (posmod(int(g.gait_clock*12),8) if g.walking_pose else 0)
 var palm=HoldCharacterArt.work_hand(frame,g.state.appearance) if firing else HoldCharacterArt.carry_hand(frame,g.state.appearance)
 var painted=not firing and (g.walking_pose or (not g.grounded and not g.winch))
 var walk_frame=HoldPaintedWalk.frame_index(g.gait_clock,0 if g.grounded or g.winch else (1 if g.velocity.y<0 else 2))
 if painted:palm=HoldPaintedWalk.sockets(g.state.appearance,walk_frame,false).hand
 var hand=g.player+palm*Vector2(g.face,1)
 var dir=direction if firing else Vector2(g.face,.10)
 var angle=atan2(dir.y,absf(dir.x))*(1 if g.face>0 else -1)
 g.draw_set_transform(hand+g.A.draw_offset,angle,Vector2(g.face,1))
 # Fixed-size barrel, rear grip under palm, copper induction coils and ceramic nozzle.
 g.draw_style_box(body_style(),Rect2(-10,-10,35,14))
 g.draw_rect(Rect2(-3,-1,6,12),Color("745a40"))
 g.draw_rect(Rect2(-1,0,2,10),Color("c8a16e"))
 g.draw_rect(Rect2(19,-7,11,8),Color("1b2c38"))
 g.draw_rect(Rect2(25,-8,5,10),Color("a9b7b2"))
 for x in [5,10,15]:
  g.draw_rect(Rect2(x,-11,3,15),Color("bd8a51"))
  g.draw_rect(Rect2(x,-7,2,6),Color("a6f5dc") if firing else Color("518e89"))
 g.draw_rect(Rect2(-8,-8,8,3),Color("789e9e"))
 g.draw_set_transform(g.A.draw_offset)
 if painted:HoldPaintedWalk.draw_grip(g,g.player+g.A.draw_offset,walk_frame,g.state.appearance,g.face,g.A.draw_offset,g.character_tint(g.player))
 else:HoldCharacterArt.draw_grip(g,g.player+g.A.draw_offset,frame,g.state.appearance,g.face,g.A.draw_offset,g.character_tint(g.player),not firing)
 if flash>0:
  var muzzle=hand+dir*29+Vector2(0,-3)
  g.draw_line(muzzle,endpoint,Color(.3,.9,.8,.16),9)
  g.draw_line(muzzle,endpoint,Color(1,.69,.32,.7),3)
  g.draw_line(muzzle,endpoint,Color("fff0c9"),1)
static var style:StyleBoxFlat
static func body_style()->StyleBoxFlat:
 if style==null:
  style=StyleBoxFlat.new();style.bg_color=Color("354a55");style.border_color=Color("aa9166");style.set_border_width_all(1);style.set_corner_radius_all(2)
 return style
