class_name HoldMineView94
extends RefCounted
# A second presentation of the existing mine. No duplicate world or physics state.
var g
var enabled=false
var yaw=0.0
var pitch=.62
var distance=9.5
var sensitivity=1.0
var invert_y=false
var mouse_look=true
var cursor_held=false
var captured=false
var buttons_blocked=false
var walls:Array=[]
var viewport:SubViewport
var screen:SubViewportContainer
var scene:Node3D
var camera:Camera3D
var terrain:Node3D
var actors:Node3D
var props:Node3D
var hud
var player_sprite:Sprite3D
var sprite_pool={}
var materials={}
var context=""
var timer=0.0
var textures={}
var prop_pool={}
var effects:Node3D
var preferred=false
func _init(game):
 g=game
 var cfg=ConfigFile.new()
 if cfg.load("user://view_settings94.cfg")==OK:
  preferred=bool(cfg.get_value("view","exploration",false))
  mouse_look=bool(cfg.get_value("view","mouse_look",true));invert_y=bool(cfg.get_value("view","invert_y",false))
  sensitivity=clampf(float(cfg.get_value("view","sensitivity",1.0)),.25,2.5)
  distance=clampf(float(cfg.get_value("view","distance",9.5)),5,12)
 enabled=preferred
func active()->bool:return enabled and g.playing and g.zone=="mine" and g.handworks.placing=="" and (g.deep.works==null or g.deep.works.mode=="")
func save_preference():
 preferred=enabled;var cfg=ConfigFile.new()
 for key in ["mouse_look","invert_y","sensitivity","distance"]:cfg.set_value("view",key,get(key))
 cfg.set_value("view","exploration",preferred);cfg.save("user://view_settings94.cfg")
func release_pointer():
 if captured:Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
 captured=false;buttons_blocked=true;g.mining_buffer=0
 if g.fight!=null:g.fight.buffered=0;g.fight.guard=false;g.fight.guard_was=false
func sync_pointer():
 var wanted=active() and mouse_look and not cursor_held and not g.deep.survey_open and g.panel_id=="" and g.transition_left<=0 and not HoldFolk.warming() and not is_instance_valid(g.creator) and not is_instance_valid(g.opening_scene) and not is_instance_valid(g.anniversary_scene)
 if wanted!=captured:
  if wanted:
   captured=true;buttons_blocked=true;Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
   var focus=g.get_viewport().gui_get_focus_owner()
   if focus!=null:focus.release_focus()
  else:release_pointer()
 if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):buttons_blocked=false
func actions_allowed()->bool:
 return not active() or not mouse_look or (captured and not buttons_blocked)
# Runs before GUI dispatch: captured motion must not be swallowed by a HUD control.
func input(e:InputEvent)->bool:
 if e is InputEventKey and e.keycode==KEY_ALT:
  cursor_held=e.pressed;sync_pointer();return active() and mouse_look
 if not active() or g.panel_id!="":return false
 if e is InputEventMouseMotion and captured:
  yaw=wrapf(yaw-e.screen_relative.x*.003*sensitivity,-PI,PI)
  pitch=clampf(pitch+e.screen_relative.y*.003*sensitivity*(-1 if invert_y else 1),.38,1.18)
  update_camera();return true
 if e is InputEventMouseButton and e.pressed and captured and e.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
  distance=clampf(distance+(-.65 if e.button_index==MOUSE_BUTTON_WHEEL_UP else .65),5,12)
  update_camera();save_preference();return true
 return false
func controls_panel():
 g.label(g.panel_body,"3D in 2D · your painted Dwarf, a mouse-controlled view",19)
 var row=g.row(g.panel_body)
 for choice in [true,false]:
  var b=g.small_button(row,"Mouse look" if choice else "Free cursor",func():mouse_look=choice;save_preference();g.refresh_panel())
  b.toggle_mode=true;b.button_pressed=mouse_look==choice;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 g.label(g.panel_body,"Mouse turns and tilts the view. WASD moves relative to it; aim with the reticle. Wheel zooms. Hold Alt for the cursor. Esc pauses. F6 returns overhead.",16)
 g.label(g.panel_body,"Free cursor retains click-to-aim and [ / ] camera turns. Combat: LMB strike, RMB guard, Space dodge. Work: stop moving, then hold LMB on the highlighted face.",15)
 var r=g.row(g.panel_body);var value=g.label(r,"Sensitivity: %.2f×" % sensitivity,16)
 var slider=HSlider.new();slider.min_value=.25;slider.max_value=2.5;slider.step=.05;slider.value=sensitivity;slider.custom_minimum_size=Vector2(320,32);r.add_child(slider)
 slider.value_changed.connect(func(v):sensitivity=v;value.text="Sensitivity: %.2f×" % v;save_preference())
 var invert=CheckButton.new();invert.text="Invert vertical look";invert.button_pressed=invert_y;g.panel_body.add_child(invert)
 invert.toggled.connect(func(v):invert_y=v;save_preference())
 g.small_button(g.panel_body,"Reset camera & sensitivity",func():yaw=0;pitch=.62;distance=9.5;sensitivity=1;invert_y=false;save_preference();g.refresh_panel())
func invalidate():context="";timer=0
func make():
 screen=SubViewportContainer.new();screen.name="MineExploration94";screen.size=Vector2(960,540);screen.stretch=true;screen.mouse_filter=Control.MOUSE_FILTER_IGNORE;g.add_child(screen)
 viewport=SubViewport.new();viewport.size=Vector2i(960,540);viewport.own_world_3d=true;viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS;screen.add_child(viewport)
 scene=Node3D.new();viewport.add_child(scene)
 var env=WorldEnvironment.new();var settings=Environment.new();settings.background_mode=Environment.BG_COLOR;settings.background_color=Color("111c24");settings.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR;settings.ambient_light_color=Color("c5d7de");settings.ambient_light_energy=.8;env.environment=settings;scene.add_child(env)
 var sun=DirectionalLight3D.new();sun.rotation_degrees=Vector3(-60,-25,0);sun.light_color=Color("ffe3bc");sun.light_energy=1.0;scene.add_child(sun)
 camera=Camera3D.new();camera.fov=58;camera.near=.1;camera.far=40;scene.add_child(camera);camera.current=true
 terrain=Node3D.new();actors=Node3D.new();props=Node3D.new();effects=Node3D.new();scene.add_child(terrain);scene.add_child(props);scene.add_child(actors);scene.add_child(effects)
 # Keep the player readable when the tilted paper sprite meets a rock face.
 player_sprite=Sprite3D.new();player_sprite.no_depth_test=true;actors.add_child(player_sprite)
 hud=ViewHUD.new();hud.view=self;screen.add_child(hud)
func sync(dt:float):
 sync_pointer()
 if not active():
  if is_instance_valid(screen):screen.visible=false;viewport.render_target_update_mode=SubViewport.UPDATE_DISABLED
  return
 if not is_instance_valid(screen):make()
 screen.visible=true;viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 g.deep.ensure();var w=g.deep.world
 update_camera()
 timer-=dt
 var key=g.state.active_site+":"+str(w.depth())+":"+str(Deepworks.cell(g.player))
 if context!=key or timer<=0:
  context=key;timer=.25;rebuild();rebuild_props()
 update_cutaway();update_actors()
 for entry in prop_pool.values():apply_sprite(entry.card,entry.vp.get_texture(),Rect2(-128,-220,256,256),entry.canvas.object.p)
 update_effects();hud.queue_redraw()
func update_camera():
 if not is_instance_valid(camera):return
 var center=point(g.player);var back=Vector3(sin(yaw),0,cos(yaw))
 if mouse_look:
  # Close zoom eases over the shoulder and raises the dwarf above the hotbar.
  var close=clampf((9.5-distance)/4.5,0,1);var right=Vector3(cos(yaw),0,-sin(yaw))
  camera.position=center+back*cos(pitch)*distance+right*close*1.4+Vector3.UP*(.8+sin(pitch)*distance)
  camera.look_at(center-back*lerpf(2.0,.7,close)+right*close*.9+Vector3.UP*.8)
 else:
  camera.position=center+back*7.4+Vector3.UP*6.2;camera.look_at(center+Vector3.UP*.35)
func update_cutaway():
 for wall in walls:
  var height=tile_height(wall.c,wall.kind)
  if height==wall.height:continue
  wall.height=height
  wall.multi.set_instance_transform(wall.index,Transform3D(Basis.from_scale(Vector3(1,height,1)),Vector3(wall.c.x+.5,height*.5-.06,wall.c.y+.5)))
func point(p:Vector2)->Vector3:return Vector3(p.x/40,0,p.y/40)
func heading()->float:return atan2(camera.global_basis.z.x,camera.global_basis.z.z) if is_instance_valid(camera) else yaw
func movement(axis:Vector2)->Vector2:return axis.rotated(-heading()) if active() else axis
func mouse_world()->Vector2:
 if not active() or not is_instance_valid(camera):return g.get_global_mouse_position()+g.camera
 var mouse=Vector2(480,270) if mouse_look else g.get_global_mouse_position()
 var origin=camera.project_ray_origin(mouse);var direction=camera.project_ray_normal(mouse)
 var hit=Plane(Vector3.UP,.8 if g.combat.armed else 0).intersects_ray(origin,direction)
 return Vector2(hit.x,hit.z)*40 if hit!=null else g.player
func material(kind:int)->StandardMaterial3D:
 if materials.has(kind):return materials[kind]
 var m=StandardMaterial3D.new();m.roughness=1.0;m.vertex_color_use_as_albedo=true
 var image=DeepworksPlay.STONE.get_image().get_region(Rect2i(0,627 if kind==0 else 0,600,600));m.albedo_texture=ImageTexture.create_from_image(image)
 m.albedo_color=Color("8b9694") if kind==0 else g.deep.ore_color(kind).lightened(.12) if kind in [3,4,5,6] else Color("839397")
 materials[kind]=m;return m
func clear_children(node:Node):
 for child in node.get_children():node.remove_child(child);child.queue_free()
func rebuild():
 walls.clear();clear_children(terrain)
 var groups={};var w=g.deep.world;var c=Deepworks.cell(g.player)
 for y in range(maxi(0,c.y-12),mini(Deepworks.H,c.y+13)):
  for x in range(maxi(0,c.x-12),mini(Deepworks.W,c.x+13)):
   var tile=Vector2i(x,y);var seen=w.layer().seen.has(Deepworks.key(tile));var k=w.at(tile) if seen else 8
   # Unexplored space remains opaque; previewing cannot reveal caverns or ore.
   var height=tile_height(tile,k)
   var transform=Transform3D(Basis.from_scale(Vector3(1,height,1)),Vector3(x+.5,height*.5-.06,y+.5))
   if not groups.has(k):groups[k]=[]
   groups[k].append({"t":transform,"color":Color.WHITE if seen else Color("253139"),"c":tile,"height":height})
 for k in groups:
  var mesh=BoxMesh.new();mesh.size=Vector3.ONE;mesh.material=material(k)
  var multi=MultiMesh.new();multi.transform_format=MultiMesh.TRANSFORM_3D;multi.use_colors=true;multi.mesh=mesh;multi.instance_count=groups[k].size()
  for i in groups[k].size():
   multi.set_instance_transform(i,groups[k][i].t);multi.set_instance_color(i,groups[k][i].color)
   if k!=0:walls.append({"multi":multi,"index":i,"c":groups[k][i].c,"height":groups[k][i].height,"kind":k})
  var batch=MultiMeshInstance3D.new();batch.multimesh=multi;terrain.add_child(batch)
 for link in w.data.links.values():
  var p=Deepworks.center(Vector2i(link.x,link.y))
  if w.depth() not in [int(link.upper),int(link.lower)] or p.distance_to(g.player)>440 or not w.layer().seen.has(Deepworks.key(Deepworks.cell(p))):continue
  var down=w.depth()==int(link.upper)
  for i in 5:box(terrain,point(p)+Vector3(0,.04+i*.075,(i-2)*.16),Vector3(.8,.08,.18),Color("99bbb8"))
  label3d(terrain,point(p)+Vector3(0,.8,0),("↓ E · D%d" % (int(link.lower)+1)) if down else ("↑ Shift+E · D%d" % (int(link.upper)+1)),Color("a2fff0"))
 for step in g.depth_nav.path:
  if step.z==w.depth() and Deepworks.center(Vector2i(step.x,step.y)).distance_to(g.player)<450:box(terrain,point(Deepworks.center(Vector2i(step.x,step.y)))+Vector3(0,.035,0),Vector3(.15,.025,.15),Color("ffd27c"))
func tile_height(c:Vector2i,kind:int)->float:
 if kind==0:return .06
 var delta=(Deepworks.center(c)-g.player)/40;var back=Vector2(sin(yaw),cos(yaw))
 return .32 if delta.dot(back)>-.5 and absf(delta.cross(back))<2.3 else 1.65
func box(parent:Node,p:Vector3,size:Vector3,color:Color):
 var item=MeshInstance3D.new();var mesh=BoxMesh.new();mesh.size=size;var mat=StandardMaterial3D.new();mat.albedo_color=color;mesh.material=mat;item.mesh=mesh;item.position=p;parent.add_child(item)
func label3d(parent:Node,p:Vector3,text:String,color:Color):
 var label=Label3D.new();label.text=text;label.font_size=40;label.outline_size=8;label.pixel_size=.012;label.billboard=BaseMaterial3D.BILLBOARD_ENABLED;label.modulate=color;label.position=p;parent.add_child(label)
func sprite(id:String)->Sprite3D:
 if not sprite_pool.has(id):
  var s=Sprite3D.new();actors.add_child(s);sprite_pool[id]=s
 var s=sprite_pool[id];s.visible=true;return s
func apply_sprite(s:Sprite3D,texture:Texture2D,rect:Rect2,p:Vector2,flip:bool=false):
 s.texture=texture;s.pixel_size=.025;s.billboard=BaseMaterial3D.BILLBOARD_ENABLED;s.alpha_cut=SpriteBase3D.ALPHA_CUT_DISCARD;s.texture_filter=BaseMaterial3D.TEXTURE_FILTER_LINEAR;s.flip_h=flip
 s.scale=Vector3(rect.size.x/texture.get_width(),rect.size.y/texture.get_height(),1)
 var center=rect.get_center();s.position=point(p)+camera.global_basis.x*center.x*.025*(-1 if flip else 1)-camera.global_basis.y*center.y*.025
func person(s:Sprite3D,p:Vector2,profile:Dictionary,direction:Vector2,walking:bool,time:float,action:String="",phase:float=0):
 var d=direction.rotated(heading());var frame=HoldWholeFrames.descriptor(profile,d,walking,time,action,phase)
 apply_sprite(s,HoldWholeFrames.texture(profile,frame.sheet,frame.index),frame.destination,p,d.x<-.3)
func update_actors():
 for s in sprite_pool.values():s.visible=false
 var d=g.deep;var f=g.fight;var action=g.hotbar.pose();var phase=0.0;var direction=g.surface.direction
 if mouse_look and not g.walking_pose:direction=movement(Vector2.UP)
 if g.combat.armed:action=f.player_pose();phase=1-f.swing/g.combat.weapon().time if f.swing>0 else 0;direction=f.bash_aim if f.bash_left>0 else f.locked_aim if f.swing>0 else f.aim
 elif d.strike_left>0:action=["pick","shovel","axe","hammer"][g.tool];phase=1-d.strike_left/d.swing_duration;direction=(d.contact-g.player).normalized()
 elif g.handworks.working:
  var station=g.handworks.facility()
  if not station.is_empty() and not station.job.is_empty():action="saw" if station.kind=="saw" else "hammer";phase=fmod(float(station.job.progress),.42)/.42;direction=g.handworks.work_direction(station)
  elif not g.handworks.field_raw.is_empty():action="hammer";phase=fmod(float(g.handworks.field_raw.dressing),.7)/.7;direction=Vector2(1,.45)
 elif g.handworks.carry_action()!="":action=g.handworks.carry_action();phase=g.handworks.carry_phase()
 elif g.handworks.pushing():action="push"
 person(player_sprite,g.player,g.combat.profile(),direction,g.walking_pose,g.gait_clock,action,phase)
 for e in f.enemies:
  if e.hp<=0 or e.p.distance_to(g.player)>500 or not d.world.layer().seen.has(Deepworks.key(Deepworks.cell(e.p))):continue
  var facing=e.dir.rotated(heading());var s=sprite("enemy:"+str(e.id));var kind=int(e.kind)
  var source:Rect2;var root:Vector2;var scale:float;var tex:Texture2D
  if kind==1:
   var index=2 if e.state=="windup" else 3 if e.state=="recover" else int(e.gait*8)%2
   source=[Rect2(35,585,375,275),Rect2(465,585,400,275),Rect2(880,540,375,320),Rect2(1270,625,504,235)][index];root=[Vector2(220,845),Vector2(650,845),Vector2(1060,845),Vector2(1480,845)][index];scale=.16;tex=HoldCombat.ENEMIES
  else:
   var row=HoldEnemyRoster.row(facing);var frame=HoldEnemyRoster.frame(e);source=HoldEnemyRoster.RECTS[kind][row][frame];root=HoldEnemyRoster.ROOTS[kind][row][frame];scale=float(HoldEnemyRoster.spec(kind).height)/[194.0,1.0,191.0,194.0][kind];tex=HoldEnemyRoster.GOBLIN if kind==0 else HoldEnemyRoster.ORC if kind==2 else HoldEnemyRoster.TROLL
  var key=str(kind)+":"+str(source)
  if not textures.has(key):var atlas=AtlasTexture.new();atlas.atlas=tex;atlas.region=source;textures[key]=atlas
  apply_sprite(s,textures[key],Rect2((source.position-root)*scale,source.size*scale),e.p,facing.x<0)
 for a in g.agents:
  if int(d.crew_entry(a).depth)!=d.world.depth() or not nearby(a.p):continue
  if a.type=="bot":continue # Original mechanical art is captured with props below.
  var beat=fposmod(1.5-float(a.cool)/maxf(.1,float(a.get("swing",.6))),1.0)
  person(sprite("crew:"+str(a.id)),a.p,g.state.npc(a.id),a.get("facing",Vector2.DOWN),not a.path.is_empty(),float(a.get("gait",0)),"pick" if a.work else "",beat)
 for a in HoldFirstShift.actors(g):
  if not nearby(a.p):continue
  var crew=HoldFirstShift.data(g).crew;var bench=HoldFirstShift.station(g,"crewbench");var mason=a.role=="mason"
  var working=mason and not bench.job.is_empty();var carrying=not mason and not crew.carry.is_empty()
  var target=Vector2(360,420) if crew.phase=="fetch" else Vector2(364,280);var walking=not mason and a.p.distance_to(target)>2
  var aim=Vector2(1,.45) if mason else (target-a.p).normalized() if walking else Vector2.DOWN
  person(sprite("shift:"+a.role),a.p,HoldFirstShift.profile_for(mason),aim,walking,float(crew.gait),"hammer" if working else "carry_stone" if carrying else "town_walk",fmod(float(bench.job.get("progress",0)),.42)/.42 if working else 1.0)
 for a in HoldWorkplace98.actors(g):
  if nearby(a.p):
   var resident=HoldWorkplace98.data(g).person
   person(sprite("workplace98:odrin"),a.p,HoldWorkplace98.profile(),Vector2(1,.45) if resident.work else Vector2(resident.direction[0],resident.direction[1]),resident.walking,float(resident.gait),"hammer" if resident.work else "town_walk",fposmod(float(HoldWorkplace98.station(g,"bench").job.get("progress",0)),.42)/.42)
 for a in HoldAncestralClaim.actors(g):
  if nearby(a.p):
   var survivor=HoldAncestralClaim.data(g.state).crew[a.index];var rescue_aim=survivor.get("aim",[0,1])
   person(sprite("rescue:"+str(a.index)),a.p,HoldMountain104.profile(g,a.index),Vector2(rescue_aim[0],rescue_aim[1]).normalized(),bool(survivor.get("walking",false)),float(survivor.gait))
func nearby(p:Vector2)->bool:return p.distance_to(g.player)<480 and g.depth_nav.known(Deepworks.cell(p),g.deep.world.depth())
func rebuild_props():
 for entry in prop_pool.values():entry.used=false
 # Static original props are rendered to small transparent cards; their physical bases remain authoritative.
 for object in HoldWorkplace98.props(g):
  if nearby(object.p):capture(object,"workplace98")
 for object in g.handworks.objects():
  if nearby(object.p):capture(object,"handwork")
 for part in g.deep.world.landmarks():
  if part.feature.found and nearby(part.p):capture(part,"landmark")
 for furniture in g.deep.works.model.data.furniture.values():
  if furniture.get("room","")=="old_cutters" and not g.deep.world.layer().seen.has(Deepworks.key(Vector2i(furniture.x,furniture.y))):continue
  var p=Deepworks.center(Vector2i(furniture.x,furniture.y))
  if int(furniture.depth)==g.deep.world.depth() and nearby(p):capture({"p":p,"furniture":furniture},"furniture")
 for key in g.deep.world.layer().fixtures:
  var bits=key.split(",");var p=Deepworks.center(Vector2i(int(bits[0]),int(bits[1])))
  if nearby(p):capture({"p":p},"lamp")
 for a in g.agents:
  if a.type=="bot" and int(g.deep.crew_entry(a).depth)==g.deep.world.depth() and nearby(a.p):capture({"p":a.p,"work":a.work},"bot")
 for pile in g.deep.haul.data.piles.values():
  var p=Deepworks.center(Vector2i(pile.x,pile.y))
  if int(pile.depth)==g.deep.world.depth() and nearby(p) and DeepHaul.amount(pile.cargo)>0:capture({"p":p,"cargo":pile.cargo},"pile")
 var cart=g.deep.haul.cart()
 if not cart.is_empty() and int(cart.depth)==g.deep.world.depth() and nearby(g.deep.haul.cart_pos()):capture({"p":g.deep.haul.cart_pos(),"cargo":cart.cargo},"cart")
 for key in prop_pool.keys():
  if not prop_pool[key].used:prop_pool[key].vp.queue_free();prop_pool[key].card.queue_free();prop_pool.erase(key)
func capture(object:Dictionary,kind:String):
 var key=kind+":"+str(object.get("facility",object.get("raw",{})).get("id",object.p))
 if not prop_pool.has(key):
  var vp=SubViewport.new();vp.size=Vector2i(256,256);vp.transparent_bg=true;props.add_child(vp)
  var canvas=PropCanvas.new();canvas.game=g;canvas.kind=kind;vp.add_child(canvas)
  var card=Sprite3D.new();props.add_child(card)
  prop_pool[key]={"vp":vp,"canvas":canvas,"card":card,"used":true}
 var entry=prop_pool[key];entry.used=true;entry.canvas.object=object;entry.canvas.queue_redraw();entry.vp.render_target_update_mode=SubViewport.UPDATE_ONCE
 apply_sprite(entry.card,entry.vp.get_texture(),Rect2(-128,-220,256,256),object.p)
func update_effects():
 clear_children(effects)
 for e in g.fight.enemies:
  if e.hp<=0 or e.p.distance_to(g.player)>500 or not g.depth_nav.known(Deepworks.cell(e.p),g.deep.world.depth()):continue
  var spec=HoldEnemyRoster.spec(e.kind)
  label3d(effects,point(e.p)+camera.global_basis.y*(float(spec.height)/40+.3),("! " if e.state=="windup" else "")+str(ceili(e.hp)),Color("ffce7b") if e.state=="windup" else Color("d4e2db"))
  if e.state=="windup":
   var tool=SurfaceTool.new();tool.begin(Mesh.PRIMITIVE_TRIANGLES)
   var center=point(e.p)+Vector3(0,.04,0);var a=e.dir.angle();var angle=float(spec.angle);var radius=float(spec.reach)/40
   for i in 16:
    for v in [Vector3.ZERO,Vector3(cos(a-angle+i*angle/8)*radius,0,sin(a-angle+i*angle/8)*radius),Vector3(cos(a-angle+(i+1)*angle/8)*radius,0,sin(a-angle+(i+1)*angle/8)*radius)]:tool.add_vertex(center+v)
   var marker=MeshInstance3D.new();marker.mesh=tool.commit();var mat=StandardMaterial3D.new();mat.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED;mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA;mat.cull_mode=BaseMaterial3D.CULL_DISABLED;mat.albedo_color=Color(1,.65,.2,.45);marker.material_override=mat;effects.add_child(marker)
 if not g.combat.armed and g.panel_id=="":
  var target=g.deep.world.target(g.player,mouse_world(),180 if g.mining_gun.selected else 52)
  if target.x>=0:
   var p=point(Deepworks.center(target));var height=tile_height(target,g.deep.world.at(target));box(effects,p+Vector3(0,height-.025,0),Vector3(.9,.035,.9),Color("f8d287"))
   label3d(effects,p+Vector3(0,height+.45,0),HoldData.TILES[g.deep.world.at(target)].name,Color("ffe4a1"))
class PropCanvas extends Node2D:
 var game
 var object:Dictionary
 var kind=""
 var hand_painter
 var living_painter
 func _get(property):
  if property=="player":return game.player-object.p+Vector2(128,220)
  return game.get(property) if is_instance_valid(game) else null
 func _draw():
  var at=Vector2(128,220)
  if hand_painter==null:hand_painter=HoldHandworks.new(self);hand_painter.textures=game.handworks.textures
  if kind=="lamp":HoldArt.lamp(self,at-Vector2(0,25),0)
  elif kind=="workplace98":
   var prop=object.duplicate();prop.p=at;HoldWorkplace98.draw_prop(self,prop)
  elif kind=="handwork":
   var painter=hand_painter;painter.working=game.handworks.working;painter.active_id=game.handworks.active_id
   var copy=object.duplicate(true);copy.p=at
   if copy.has("facility"):copy.facility.hitched=false;copy.facility.x=at.x;copy.facility.y=at.y
   painter.draw_object(copy)
  elif kind=="bot":HoldArt.bot(self,at,game.clock,object.work)
  elif kind in ["cart","pile"]:
   var painter=hand_painter;painter.sprite(5 if kind=="cart" else 2,at,90 if kind=="cart" else 58)
   var i=0
   for item in object.cargo:
    if int(object.cargo[item])<=0:continue
    HoldItemArt.draw(self,Rect2(at+Vector2(-20+i*13,-42),Vector2(28,28)),HoldItemArt.item_index(item),HoldItemArt.tint(item));i+=1
  elif kind=="landmark":
   if int(object.art)==4:HoldMasonryArt.pillar(self,at,object.height)
   else:draw_texture_rect_region(HoldWorldZones.DETAILS,Rect2(at-Vector2(object.width/2,object.height),Vector2(object.width,object.height)),HoldWorldZones.DETAIL_RECTS[int(object.art)])
  elif kind=="furniture":
   if object.furniture.get("room","")=="old_cutters":HoldWorkplace98.draw_furniture(self,object.furniture,at)
   elif object.furniture.kind=="lamp":HoldArt.lamp(self,at-Vector2(0,25),0)
   else:
    if living_painter==null:living_painter=LivingPlay.new(self,game.deep.world)
    living_painter.draw_furniture(object.furniture.kind,at)
class ViewHUD extends Node2D:
 var view
 func _draw():
  var game=view.g;var w=game.deep.world
  draw_rect(Rect2(0,0,960,77),Color("0e202c"));draw_rect(Rect2(0,462,960,78),Color("0e202c"))
  HoldArt.text(self,Vector2(24,483),"D%d · %s · 3D EXPLORATION" % [w.depth()+1,Deepworks.NAMES[w.depth()]],14,Color("edca8c"))
  HoldArt.text(self,Vector2(24,100),game.depth_nav.hint(),14,Color("ffe0a0"))
  HoldArt.text(self,Vector2(490,483),"Alt: cursor · Wheel: zoom · F7: camera" if view.mouse_look else "[ / ] camera · F7: controls",14,Color("b9d5d3"))
  if view.mouse_look and game.panel_id=="" and not game.deep.survey_open:
   if view.captured:
    var at=Vector2(480,270);var color=Color("ffe1a4")
    for d in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:
     draw_line(at+d*5,at+d*11,Color("14242b"),4);draw_line(at+d*5,at+d*11,color,1.5)
    draw_circle(at,1.5,color)
   else:HoldArt.text(self,Vector2(290,350),"Release Alt to return to mouse look",15,Color("ffe1a4"))
  if game.combat.armed:HoldArt.text(self,Vector2(24,126),"HP %d · LMB strike · RMB guard · Space dodge" % game.state.combat.health,14,Color("efdbc3"))
  elif game.handworks.prompt()!="":HoldArt.text(self,Vector2(24,126),game.handworks.prompt(),12,Color("efdbc3"))
  if game.deep.survey_open and game.panel_id=="":game.deep.draw_survey(self)
