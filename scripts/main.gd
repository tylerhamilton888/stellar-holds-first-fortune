extends Node2D

const A=preload("res://scripts/art.gd")
const SCENERY=preload("res://scripts/scenery.gd")
const HALL=preload("res://assets/scenery/keldrath-hall.png")
const WORKINGS_VALLEY=preload("res://assets/hold-v39/workings-valley.png")
const VALLEY=preload("res://assets/scenery/king-road-valley.png")
const RIDGE=preload("res://assets/scenery/independent-ridge.png")
const JOURNEY=preload("res://scripts/journey.gd")
const HUB_FLOOR=410.0
const TOOL_NAMES=["Pickaxe","Shovel","Axe","Hammer"]
const STATIONS=[{"x":225.0,"name":"Workers' quarters","panel":"home"},{"x":410.0,"name":"The Copper Kettle","panel":"tavern"},{"x":685.0,"name":"Orla's exchange","panel":"market"},{"x":970.0,"name":"Borin's forge","panel":"forge"},{"x":1205.0,"name":"Foreman's office","panel":"commission"},{"x":1465.0,"name":"Expedition map table","panel":"expedition"},{"x":1780.0,"name":"Survey office","panel":"research"},{"x":1945.0,"name":"The King's Gate","panel":"gate"}]
const ROAD_STATIONS=[{"x":190.0,"name":"Woodcutter's field board","panel":"pinewood"}]
const CLAIM_STATIONS=[{"x":150.0,"name":"Your quarters","panel":"home"},{"x":400.0,"name":"Return to Keldrath","panel":"gate"},{"x":970.0,"name":"Founding your hold","panel":"camp"},{"x":1205.0,"name":"Workshop","panel":"forge"},{"x":1465.0,"name":"Your mine","panel":"mine"},{"x":1780.0,"name":"Future launchyard","panel":"ship"}]

var handworks:HoldHandworks
var hotbar:HoldHotbar
var surface:HoldSurface
var deep:DeepworksPlay
var forest_view:Node2D
var backdrop:Sprite2D
var sprite_atlas:HoldSpriteAtlas
var state=HoldState.new()
var geo=Geology.new()
var terrain_view=HoldTerrainView.new()
var overworld
var hold_room_return=false
var construction:HoldConstruction
var mining_gun:HoldMiningGun
var combat:HoldCombat
var sound:HoldSound
var playing=false
var zone="hub"
var player=Vector2(150,HUB_FLOOR)
var velocity=Vector2.ZERO
var grounded=false
var jump_buffer=0.0
var coyote_left=0.0
var jump_was_held=false
var movement_remainder=0.0
var face=1
var camera=Vector2.ZERO
var clock=0.0
var gait_clock=0.0
var walking_pose=false
var ladder_attached=false
var prospecting=false
var sampling_strike=false
var tool=0
var swing=0.0
var swing_done=false
var swing_duration=.38
var impact_pause=0.0
var impact_flashes:Array=[]
var step_distance=0.0
var room_id=""
var exterior_position=Vector2.ZERO
var transition_left=0.0
var transition_shade:ColorRect
var transition_label:Label
var briefing_topic=""
var talk_id="ivar"
var talk_topic=""
var talk_line=""
var anniversary_host=""
var forest_target:Dictionary={}
var hit_cell=Vector2i.ZERO
var hit_point=Vector2.ZERO
var mining_buffer=0.0
var shake_amount=0.0
var particles:Array=[]
var popups:Array=[]
var drops:Array=[]
var agents:Array=[]
var autosave=0.0
var notice=""
var notice_time=0.0
var ui:Control
var panel:PanelContainer
var panel_id=""
var menu_history:Array=[]
var menu_scroll:ScrollContainer
var menu_paused=false
var inventory_owned_only=true
var gear_tab="weapon"
var help_tab=0
var trade_tab="sell"
var forge_tab=0
var research_tab=0
var panel_body:VBoxContainer
var hud:Label
var footer:Label
var status:Label
var objectives:Label
var title_ui:Control
var panel_info:Label
var build_anim=0.0
var launching=false
var launch_time=0.0
var capture_mode=""
var captured=false
var winch=false
var market_scroll=0
var creator:HoldCreator
var visitor_key="visitor_0"
var outpost_tab=0
var anniversary_scene:HoldAnniversaryScene
var opening_scene:HoldOpeningScene
var room_return=""
var lesson_id=""
var skip_arrival=false

func _ready():
 get_window().focus_exited.connect(pause_for_focus_loss)
 get_tree().auto_accept_quit=false
 backdrop=Sprite2D.new();backdrop.centered=false;backdrop.z_index=-10;add_child(backdrop)
 var atmosphere=ShaderMaterial.new();atmosphere.shader=load("res://scripts/atmosphere.gdshader");backdrop.material=atmosphere
 forest_view=preload("res://scripts/forestry_view.gd").new();forest_view.host=self;forest_view.z_index=-5;add_child(forest_view)
 sprite_atlas=HoldSpriteAtlas.new();add_child(sprite_atlas)
 combat=HoldCombat.new(self);construction=HoldConstruction.new(self);mining_gun=HoldMiningGun.new(self)
 deep=DeepworksPlay.new(self);surface=HoldSurface.new(self);handworks=HoldHandworks.new(self)
 setup_inputs()
 sound=HoldSound.new();add_child(sound)
 setup_ui()
 hotbar=HoldHotbar.new();hotbar.g=self;ui.add_child(hotbar)
 state.load_audio_settings();apply_audio_settings()
 geo.generate(27419)
 show_title()
 for arg in OS.get_cmdline_user_args():
  if arg=="--smoke":smoke_boot.call_deferred()
  if arg.begins_with("--capture="):
   capture_mode=arg.trim_prefix("--capture=")
   if capture_mode!="title":
    start_game(false)
    if capture_mode=="briefing":open_panel("briefing")
    elif capture_mode=="road":travel_road();player.x=900;camera.x=420
    elif capture_mode=="charters":travel_road();open_panel("charters")
    elif capture_mode=="camp":
     state.opening=4;state.claim_id="old_delving";state.camp_stage=3;state.tech.metallurgy=true;travel_claim();player.x=1000;camera.x=520
    elif capture_mode=="restored":state.opening=4;player.x=1200;camera.x=720
    elif capture_mode=="cold":state.opening=1;player.x=1080;camera.x=600
    elif capture_mode=="approach":
     state.opening=1;zone="approach";player=Vector2(900,410);camera=Vector2(420,0)
    elif capture_mode=="mine-mouth":
     state.opening=1;zone="approach";player=Vector2(1900,392);camera=Vector2(1420,0)
    elif capture_mode=="mine":
     change_zone("mine");state.opening=1;player=Vector2(460,392);state.appearance.hair_color=1;state.appearance.beard_color=1
    elif capture_mode=="ship":
     state.opening=4;state.claim_id="old_delving";state.camp_stage=3;travel_claim();state.ship_stage=3;player.x=1750;camera.x=1040
    elif capture_mode.begins_with("interior-") and capture_mode!="interior-cold":
     state.opening=4;enter_room(capture_mode.trim_prefix("interior-"));player.x=450
    elif capture_mode=="interior-cold":
     state.opening=1;enter_room("forge");player.x=450
    elif capture_mode=="dialog-charter":briefing_topic="charter";open_panel("briefing")
    elif capture_mode=="foreman":
     state.opening=1;enter_room("commission");open_panel("commission")
    elif capture_mode=="forge":enter_room("forge");open_panel("forge")
    elif capture_mode=="creator":open_creator(false)
    elif capture_mode=="creator-attire":
     open_creator(false);creator.option_page=1;creator.rebuild_options()
    elif capture_mode=="creator-female":
     state.appearance=HoldAppearance.random_profile(106,1);state.appearance.first_name="Astrid";state.appearance.family_name="Copperbraid";state.appearance=HoldAppearance.normalized(state.appearance);state.appearance.hair_style=0;state.appearance.hair_color=2;state.appearance.cloth_color=1;open_creator(false)
    elif capture_mode=="portraits":open_panel("roster")
    elif capture_mode=="orla":player.x=700;camera.x=220;open_panel("market")
 queue_redraw()

func setup_inputs():
 var bindings={"left":[KEY_A,KEY_LEFT],"right":[KEY_D,KEY_RIGHT],"jump":[KEY_SPACE],"up":[KEY_W,KEY_UP],"down":[KEY_S,KEY_DOWN],"interact":[KEY_E],"recall":[KEY_R],"inventory":[KEY_I],"manage":[KEY_M],"help":[KEY_F1],"pause":[KEY_ESCAPE],"save":[KEY_F5]}
 for action in bindings:
  if not InputMap.has_action(action):InputMap.add_action(action)
  for k in bindings[action]:
   var e=InputEventKey.new();e.physical_keycode=k;InputMap.action_add_event(action,e)

func setup_ui():
 var layer=CanvasLayer.new();add_child(layer)
 ui=Control.new();ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);ui.mouse_filter=Control.MOUSE_FILTER_IGNORE;layer.add_child(ui)
 var theme=Theme.new();theme.default_font=ThemeDB.fallback_font;theme.default_font_size=16
 for type in ["Button","PanelContainer"]:
  var style=StyleBoxFlat.new();style.bg_color=Color("152731");style.border_color=Color("8c784f");style.set_border_width_all(1);style.set_content_margin_all(14);style.set_corner_radius_all(3)
  theme.set_stylebox("normal" if type=="Button" else "panel",type,style)
  if type=="Button":
   var hover=style.duplicate();hover.bg_color=Color("34565b");hover.border_color=Color("e2b96d");theme.set_stylebox("hover",type,hover)
   var pressed=style.duplicate();pressed.bg_color=Color("496561");theme.set_stylebox("pressed",type,pressed)
   var disabled=style.duplicate();disabled.bg_color=Color("202d36");disabled.border_color=Color("3e4a50");theme.set_stylebox("disabled",type,disabled)
   theme.set_color("font_color","Button",Color("f0dbaf"));theme.set_color("font_disabled_color","Button",Color("a5b2b7"))
   var focus=StyleBoxFlat.new();focus.bg_color=Color(0,0,0,0);focus.border_color=Color("a7dfcb");focus.set_border_width_all(2);theme.set_stylebox("focus","Button",focus)
 theme.set_color("font_color","Label",Color("e6e8e2"));theme.set_constant("line_spacing","Label",4);ui.theme=theme
 hud=Label.new();hud.position=Vector2(24,17);hud.add_theme_font_size_override("font_size",19);ui.add_child(hud)
 status=Label.new();status.position=Vector2(24,48);status.add_theme_color_override("font_color",Color("a3c4bd"));ui.add_child(status)
 objectives=Label.new();objectives.position=Vector2(24,84);objectives.add_theme_font_size_override("font_size",14);ui.add_child(objectives)
 footer=Label.new();footer.position=Vector2(24,507);footer.size.x=912;footer.clip_text=true;footer.add_theme_font_size_override("font_size",14);ui.add_child(footer)
 panel=PanelContainer.new();panel.z_index=10;panel.position=Vector2(60,44);panel.size=Vector2(840,452);panel.visible=false;ui.add_child(panel)
 transition_shade=ColorRect.new();transition_shade.color=Color("0b1721");transition_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);transition_shade.z_index=90;transition_shade.mouse_filter=Control.MOUSE_FILTER_IGNORE;transition_shade.visible=false;ui.add_child(transition_shade)
 transition_label=Label.new();transition_label.position=Vector2(100,240);transition_label.size=Vector2(760,60);transition_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;transition_label.add_theme_font_size_override("font_size",25);transition_label.modulate=Color("edc98a");transition_shade.add_child(transition_label)

func show_title():
 playing=false;room_id="";transition_left=0;transition_shade.visible=false;sound.set_context("title")
 for n in [hud,status,objectives,footer]:n.visible=false
 close_panel()
 title_ui=Control.new();ui.add_child(title_ui)
 var title=Label.new();title.text="THE STELLAR\nHOLDS";title.add_theme_font_override("font",load("res://assets/HoldRunic.ttf"));title.position=Vector2(65,94);title.add_theme_font_size_override("font_size",48);title.add_theme_color_override("font_color",Color("f0d49b"));title_ui.add_child(title)
 var sub=Label.new();sub.text="THE FIRST FORTUNE";sub.position=Vector2(69,218);sub.add_theme_font_size_override("font_size",19);sub.modulate=Color("85c9bc");title_ui.add_child(sub)
 var description=Label.new();description.text="Earn your mountain. Found your house.";description.position=Vector2(69,254);description.add_theme_font_size_override("font_size",14);title_ui.add_child(description)
 var box=VBoxContainer.new();box.position=Vector2(69,288);box.size=Vector2(288,150);box.add_theme_constant_override("separation",6);title_ui.add_child(box)
 button(box,"Choose a fortune • 3 save slots",func():open_panel("save_slots"))
 button(box,"Begin a new fortune",func():open_panel("save_slots"))
 button(box,"Sound options",func():open_panel("settings"))
 button(box,"Quit",shutdown)
 for b in box.get_children():
  b.add_theme_font_size_override("font_size",18)
  for key in ["normal","hover","pressed","disabled"]:
   var style=b.get_theme_stylebox(key).duplicate();style.content_margin_top=8;style.content_margin_bottom=8;b.add_theme_stylebox_override(key,style)
 var chapter=Label.new();chapter.text="KELDRATH  /  THE LOWER WORKS";chapter.position=Vector2(69,65);chapter.add_theme_font_size_override("font_size",12);chapter.modulate=Color("91c6bd");title_ui.add_child(chapter)
 var vista=Label.new();vista.text="BENEATH THE OLD KINGS\nThe mountain still remembers.";vista.position=Vector2(548,456);vista.add_theme_font_size_override("font_size",16);vista.modulate=Color("f0d49b");title_ui.add_child(vista)
 var credit=Label.new();credit.text="THE FIRST FORTUNE  /  0.50.0";credit.position=Vector2(69,501);credit.add_theme_font_size_override("font_size",12);title_ui.add_child(credit)

func start_game(load_saved:bool,custom_appearance:Dictionary={}):
 room_id="";room_return="";hold_room_return=false;briefing_topic="";impact_pause=0;impact_flashes.clear()
 jump_buffer=0;coyote_left=0;movement_remainder=0;jump_was_held=Input.is_action_pressed("jump");grounded=false
 mining_gun.selected=false;mining_gun.flash=0
 combat.map_key="";combat.enemies.clear();combat.armed=false;combat.reset_actions();construction.selected=""
 if load_saved:
  var d=state.load_world(geo)
  if d.is_empty():notify("Could not read the save. Your file was not changed.");return
  zone=d.zone;player=d.pos
 else:
  state.reset(randi_range(10000,99999));geo.generate_region(state.seed_value,0,Vector2i.ZERO);zone="hub";player=Vector2(150,HUB_FLOOR)
 deep.world=null;deep.haul=null
 if not custom_appearance.is_empty():state.appearance=HoldAppearance.normalized(custom_appearance)
 if load_saved and zone=="mine":deep.enter(not state.deepworks_migrated)
 HoldOutpost.ensure(state)
 if not load_saved:HoldOnboarding.begin_fortune(state)
 else:HoldOnboarding.ensure(state)
 state.ensure_dynasty()
 for key in HoldAppearance.NPC_NAMES:state.npc(key)
 for i in 3:state.npc("visitor_"+str(i))
 HoldPaintedWalk.warm(combat.profile())
 velocity=Vector2.ZERO;camera=Vector2.ZERO;particles.clear();drops.clear();popups.clear()
 if zone=="mine":camera=deep.camera_target()
 playing=true;launching=false;launch_time=0;autosave=0;close_panel()
 surface.restore()
 if is_instance_valid(title_ui):title_ui.queue_free()
 for n in [hud,status,objectives,footer]:n.visible=true
 state.load_audio_settings();apply_audio_settings();sound.set_context(zone);spawn_agents()
 notify("Welcome to Keldrath. Your first wages begin at the foreman's office.")
 if state.deepworks_migrated:notify("Deepworks ready. Your original save was backed up; old terrain and structures remain archived. All supplies and progress are retained.")
 state.region_travel.active=false;state.hold_travel.active=false
 hotbar.restore()
 if not load_saved:
  save_game()
  if capture_mode=="" and not skip_arrival:opening_scene=HoldOpeningScene.begin(self,"arrival")
  else:HoldOnboarding.arrived(state)
 elif not HoldOnboarding.ensure(state).arrival_seen:
  opening_scene=HoldOpeningScene.begin(self,"arrival")

func spawn_agents():
 var previous=agents.duplicate()
 agents.clear();HoldOutpost.ensure(state)
 if state.active_site!="claim" and state.claim_id!="legacy":return
 for id in state.outpost.crew:
  var member=state.outpost.crew[id]
  if member.role!="miner":continue
  agents.append({"type":"worker","id":id,"p":Vector2(165+agents.size()*20,363),"path":[],"target":Vector2i(-1,-1),"cool":0.0,"fuel":member.get("fuel",0),"grain_work":member.get("grain_work",0),"work":false,"status":"Awaiting assignment"})
 for agent in agents:
  for old in previous:
   if old.get("id","")==agent.id:
    agent.p=old.p
    if old.get("priority","")==state.outpost.crew[agent.id].priority:agent.path=old.path;agent.target=old.target
  agent["priority"]=state.outpost.crew[agent.id].priority
 if state.automaton:agents.append({"type":"bot","id":"bot","p":Vector2(210,363),"path":[],"target":Vector2i(-1,-1),"cool":0.0,"fuel":state.outpost.get("bot_fuel",0),"work":false,"status":"Awaiting coal"})
func remember_agents():
 HoldOutpost.ensure(state)
 for agent in agents:
  if agent.type=="worker" and state.outpost.crew.has(agent.id):
   state.outpost.crew[agent.id].fuel=agent.fuel;state.outpost.crew[agent.id].grain_work=agent.get("grain_work",0)
  elif agent.type=="bot":state.outpost.bot_fuel=agent.fuel

func pause_for_focus_loss():
 if is_instance_valid(anniversary_scene) or is_instance_valid(opening_scene):return
 if is_instance_valid(overworld):
  if not overworld.paused and not overworld.survey:overworld.toggle_pause()
  return
 if playing and panel_id!="pause" and not is_instance_valid(creator):open_panel("pause")

func _process(dt):
 if is_instance_valid(anniversary_scene) or is_instance_valid(opening_scene):return
 if playing and (menu_paused or panel_id in ["pause","settings"] or is_instance_valid(creator)):
  jump_buffer=0;movement_remainder=0;jump_was_held=Input.is_action_pressed("jump")
  update_hud();queue_redraw();return
 var previous_clock=clock
 clock+=dt
 if playing and state.opening>=2 and state.active_site=="hold" and zone=="hub" and room_id=="forge":
  if HoldNpcActivity.struck_between(previous_clock,clock):sound.effect("metal_0",-25 if room_id=="forge" else -30)
 mining_gun.cool=maxf(0,mining_gun.cool-dt);mining_gun.flash=maxf(0,mining_gun.flash-dt);mining_gun.braced=maxf(0,mining_gun.braced-dt)
 if transition_left>0:
  transition_left=maxf(0,transition_left-dt);transition_shade.modulate.a=clampf(transition_left/.55,0,1)
  if transition_left==0:transition_shade.visible=false
 notice_time=maxf(0,notice_time-dt);build_anim=maxf(0,build_anim-dt)
 if playing:
  state.market_open=panel_id=="market"
  var completed=state.tick(dt)
  HoldForestry.update(self,dt)
  var matter=HoldClaimStories.poll(state)
  if matter!="":notify("Claim business: "+matter+". M opens your ledger.");save_game()
  if completed!="":notify(completed);sound.effect("build")
  if zone!="mine" and not surface.active():combat.update(dt)
  if panel_id=="" and not launching and not is_instance_valid(creator) and transition_left<=0:
   handworks.update(dt)
   if zone=="mine":deep.move(dt);deep.mine(dt)
   elif surface.active():surface.move(dt)
   else:move_player(dt)
   if zone=="mine":pass
   elif impact_pause>0:impact_pause=maxf(0,impact_pause-dt)
   elif room_id=="" and not surface.active() and not combat.armed and construction.selected=="":handle_mining(dt)
  elif transition_left>0:swing=0
  else:swing=0
  if panel_id!="" or launching or is_instance_valid(creator) or transition_left>0:
   jump_buffer=0;movement_remainder=0;jump_was_held=Input.is_action_pressed("jump")
  # Legacy terrain is retained verbatim; Deepworks owns active excavation.
  # Archived side-view structures are not simulated or removed.
  deep.agents(dt)
  update_effects(dt)
  autosave+=dt
  if autosave>45:save_game();autosave=0
  if launching:
   launch_time+=dt
   if launch_time>6:
    launching=false;state.launched=true;save_game();open_panel("victory")
  var desired=Vector2(clampf(player.x-480,0,1040),0) if zone!="mine" else Vector2(clampf(player.x-480,0,Geology.W*Geology.TILE-960),clampf(player.y-360,-180,Geology.H*Geology.TILE-470))
  if continuous_journey():desired=Vector2(clampf(player.x-480,-JOURNEY.offset(zone),Geology.W*Geology.TILE-960 if zone=="mine" else 2000),clampf(player.y-360,-180,Geology.H*Geology.TILE-470) if zone=="mine" else lerpf(-50.0,-68.0,smoothstep(1500.0,2000.0,player.x)) if zone=="approach" else 0)
  if zone=="mine":desired=deep.camera_target()
  if room_id!="":desired=Vector2.ZERO
  if surface.active():desired=surface.camera_target()
  camera=camera.lerp(desired,1-exp(-dt*7))
  shake_amount=move_toward(shake_amount,0,dt*14)
  update_hud()
 if capture_mode!="" and clock>2 and not captured:
  captured=true;capture.call_deferred()
 queue_redraw()

func capture():
 await RenderingServer.frame_post_draw
 var path=OS.get_environment("STELLAR_CAPTURE_DIR")
 if path=="":path="user://"
 get_viewport().get_texture().get_image().save_png(path.path_join(capture_mode+".png"))
 shutdown()

func _unhandled_input(e):
 if is_instance_valid(anniversary_scene) or is_instance_valid(opening_scene):return
 if is_instance_valid(overworld):
  if e is InputEventKey:
   overworld.handle_input(e)
   if e.keycode not in [KEY_TAB,KEY_ENTER,KEY_KP_ENTER]:get_viewport().set_input_as_handled()
  return
 if is_instance_valid(creator):return
 if not playing and panel_id!="" and e.is_action_pressed("pause"):
  back_panel();get_viewport().set_input_as_handled();return
 if not playing or transition_left>0:return
 if handworks.input(e):get_viewport().set_input_as_handled();return
 if hotbar.handle(e):get_viewport().set_input_as_handled();return
 if deep.input(e):get_viewport().set_input_as_handled();return
 if surface.input(e):get_viewport().set_input_as_handled();return
 if panel_id=="" and e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_LEFT and e.pressed:mining_buffer=.16
 if panel_id=="" and e.is_action_pressed("jump") and not e.is_echo():jump_buffer=.12
 if panel_id=="" and e.is_action_released("jump") and velocity.y< -140:velocity.y=-140
 if e is InputEventMouseButton and e.button_index==MOUSE_BUTTON_LEFT and e.pressed and panel_id=="" and construction.selected!="":
  construction.place(construction.target());get_viewport().set_input_as_handled();return
 if e is InputEventKey and e.pressed and not e.echo:
  if e.is_action_pressed("pause"):
   if panel_id!="":back_panel()
   else:open_panel("pause")
  elif e.keycode==KEY_K:toggle_panel("field_notes")
  elif e.keycode==KEY_X and panel_id=="":begin_field_sample()
  elif e.keycode==KEY_P and panel_id=="":
   hotbar.select(1,false);mining_gun.selected=false;prospecting=not prospecting;tool=1;combat.armed=false;combat.reset_actions();construction.selected=""
   notify("Sifting ON: hold LMB on dirt near ore. 16 grains = 1 bonus ore. K explains; P turns off." if prospecting else "Normal digging.")
  elif e.keycode==KEY_V:toggle_panel("construction")
  elif e.keycode==KEY_B:toggle_panel("equipment")
  elif e.keycode==KEY_N:toggle_panel("roster")
  elif e.keycode==KEY_F and panel_id=="":mining_gun.selected=false;construction.selected="";combat.toggle()
  elif e.keycode==KEY_Q and panel_id=="" and (zone=="mine" or room_id=="training"):combat.dodge()
  elif e.keycode==KEY_C:open_creator(false)
  elif e.keycode==KEY_G:toggle_panel("world_map")
  elif e.keycode==KEY_J:toggle_panel("commission")
  elif e.is_action_pressed("save"):save_game();notify("Hold saved.")
  elif e.is_action_pressed("inventory"):toggle_panel("inventory")
  elif e.is_action_pressed("manage"):toggle_panel("manage")
  elif e.is_action_pressed("help"):toggle_panel("help")
  elif e.is_action_pressed("recall") and panel_id=="" and zone=="mine":
   open_panel("rescue")
  elif e.is_action_pressed("interact") and panel_id=="":interact()

func move_player(dt:float):
 # Consume edges once, then integrate at a fixed rate independent of render FPS.
 var held=Input.is_action_pressed("jump")
 if held and not jump_was_held:jump_buffer=.12
 if not held and jump_was_held and velocity.y< -140:velocity.y=-140
 jump_was_held=held
 movement_remainder+=minf(dt,.1)
 while movement_remainder>=1.0/120.0-.000001:
  movement_remainder-=1.0/120.0
  move_player_step(1.0/120.0)

func move_player_step(dt:float):
 var before=player;var was_grounded=grounded;var falling_speed=velocity.y
 var axis=Input.get_axis("left","right")
 velocity.x=move_toward(velocity.x,axis*(90 if combat.guard else 160),dt*(2400 if axis and signf(axis)!=signf(velocity.x) else (1900 if axis else 2800)))
 if combat.dodge_left>0:velocity.x=combat.dodge_direction*440
 if axis and combat.attack_left<=0 and combat.dodge_left<=0:face=1 if axis>0 else -1
 var ladder_near=zone=="mine" and construction.on_ladder(player)
 if not ladder_near or absf(axis)>.1:ladder_attached=false
 if ladder_near and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):ladder_attached=true
 winch=ladder_near and ladder_attached
 if winch:
  velocity.y=Input.get_axis("up","down")*115
  if absf(axis)<.1:
   var aligned=player;aligned.x=move_toward(player.x,construction.ladder_center(player),120*dt)
   if not body_solid(aligned):player.x=aligned.x
  coyote_left=.09
 else:velocity.y=minf(velocity.y+900*dt,650)
 if grounded:coyote_left=.09
 else:coyote_left=maxf(0,coyote_left-dt)
 if jump_buffer>0 and (coyote_left>0 or winch):
  velocity.y=-355 if jump_was_held else -220
  grounded=false;winch=false;ladder_attached=false;coyote_left=0;jump_buffer=0
 else:jump_buffer=maxf(0,jump_buffer-dt)
 if zone!="mine":
  var low=0.0 if continuous_journey() and zone=="approach" else (65.0 if room_id!="" else 30.0)
  if zone=="hub" and room_id=="" and state.active_site=="hold":low=55.0
  var high=2001.0 if continuous_journey() else (890.0 if room_id!="" else 1990.0)
  if room_id=="throne":high=530.0
  player.x=clampf(player.x+velocity.x*dt,low,high);player.y+=velocity.y*dt
  var floor_height=JOURNEY.floor_y(player.x) if zone=="approach" else HUB_FLOOR
  grounded=player.y>=floor_height
  if grounded:player.y=floor_height;velocity.y=0
 else:
  # Substeps prevent tunnelling through tiles at low frame rates.
  var steps=maxi(1,int(ceil(dt*120)))
  for i in steps:
   var proposed=player+Vector2(velocity.x*dt/steps,0)
   if not body_solid(proposed):player=proposed
   elif grounded and velocity.y>=0 and not body_solid(player-Vector2(0,Geology.TILE)) and not body_solid(proposed-Vector2(0,Geology.TILE)):
    player=proposed-Vector2(0,Geology.TILE)
   else:
    player=move_to_surface(player,proposed);velocity.x=0
   proposed=player+Vector2(0,velocity.y*dt/steps)
   if not body_solid(proposed):player=proposed;grounded=false
   else:
    player=move_to_surface(player,proposed)
    if velocity.y>0:grounded=true
    velocity.y=0
  player.x=clampf(player.x,-1 if continuous_journey() else 40,Geology.W*Geology.TILE-40);player.y=maxf(55,player.y)
  if velocity.y>=0:grounded=body_solid(player+Vector2(0,.25))
 if continuous_journey():advance_journey()
 var surface="wood" if room_id in ["home","tavern"] else ("gravel" if zone in ["mine","road","claim","approach"] else "stone")
 var distance=absf(player.x-before.x)
 walking_pose=grounded and distance>.01 and absf(velocity.x)>10 and combat.dodge_left<=0 and swing<=0 and combat.attack_left<=0 and not winch
 if walking_pose:
  var previous_frame=int(gait_clock*20)
  gait_clock+=distance/80.0
  if int(gait_clock*20)!=previous_frame and posmod(int(gait_clock*20),16) in [0,8]:sound.footstep(surface)
 else:gait_clock=0
 if grounded and not was_grounded and falling_speed>180:
  sound.footstep(surface);burst(player,Color("8c9387"),4)

# Feet are the world-space origin shared by art, terrain and construction.
const BODY_SIZE=Vector2(44,76)
func body_bounds(p:Vector2)->Rect2:return Rect2(p-Vector2(BODY_SIZE.x*.5,BODY_SIZE.y),BODY_SIZE)
func settle_loaded_body():
 # Migrate old wall-adjacent saves to the slightly broader standing silhouette.
 # This only corrects small existing overlaps, never tunnels through terrain.
 if not body_solid(player):return
 for radius in range(1,15):
  for delta in [Vector2(0,-radius),Vector2(-radius,0),Vector2(radius,0)]:
   if not body_solid(player+delta):player+=delta;return
func move_to_surface(start:Vector2,end:Vector2)->Vector2:
 var free=start;var blocked=end
 for iteration in 10:
  var middle=(free+blocked)*.5
  if body_solid(middle):blocked=middle
  else:free=middle
 return free
func body_solid(p:Vector2)->bool:
 var box=body_bounds(p)
 var first=geo.cell_at(box.position);var last=geo.cell_at(box.end-Vector2.ONE*.001)
 for y in range(first.y,last.y+1):
  for x in range(first.x,last.x+1):
   if continuous_journey() and x<0:
    if y*Geology.TILE<JOURNEY.floor_y(2000+x*Geology.TILE):continue
   if geo.at(x,y) not in [0,12]:return true
 return false

func contact_point(c:Vector2i)->Vector2:
 var center=geo.center(c)
 var origin=player+Vector2(0,-29)
 if downward_strike(center):
  var direction=face if absf(center.x-player.x)<.1 else (1 if center.x>player.x else -1)
  origin=player+HoldCharacterArt.work_hand(6,state.appearance)*Vector2(direction,1)
 return origin.clamp(center-Vector2.ONE*Geology.TILE*.49,center+Vector2.ONE*Geology.TILE*.49)
func downward_strike(point:Vector2)->bool:
 return point.y>=player.y-12 and absf(point.x-player.x)<=BODY_SIZE.x*.5+20
func overhead_strike(point:Vector2)->bool:
 return point.y<player.y-60
func mining_frame(progress:float)->int:
 var phase=HoldCharacterArt.action_frame(progress,tool)
 if downward_strike(hit_point):return [0,1,2,3,6,6,7,0][phase]
 return [0,1,2,2,3,2,1,0][phase] if overhead_strike(hit_point) else phase
func strike_facing(point:Vector2)->int:
 if downward_strike(point) and absf(point.x-player.x)>.1:return 1 if point.x>player.x else -1
 return face if absf(point.x-player.x)<=8 else (1 if point.x>player.x else -1)
func contact_hand(direction:int,point:Vector2=Vector2.INF)->Vector2:
 var frame=6 if point!=Vector2.INF and downward_strike(point) else (3 if point!=Vector2.INF and overhead_strike(point) else 4)
 return player+HoldCharacterArt.work_hand(frame,state.appearance)*Vector2(direction,1)
func contact_reachable(point:Vector2,direction:int)->bool:
 return contact_hand(direction,point).distance_to(point)<=[36.0,40.0,35.0,33.0][tool]+.01
func target_cell()->Vector2i:
 return target_cell_at(get_global_mouse_position()+camera)
func target_cell_at(aim:Vector2)->Vector2i:
 if aim.y>=player.y-2 and absf(aim.x-player.x)<=32 and not Input.is_key_pressed(KEY_SHIFT):
  var footing=downward_target(aim)
  if footing.x>=0:return footing
 var origin=player+Vector2(0,-29)
 var delta=aim-origin
 if delta.length()>100:delta=delta.normalized()*100
 # The first solid surface blocks hits on cells behind it.
 for step in range(1,int(delta.length())+1,3):
  var p=origin+delta.normalized()*step
  if geo.at_pos(p) not in [0,12]:
   var cell=Vector2i(floor(p.x/Geology.TILE),floor(p.y/Geology.TILE))
   var point=contact_point(cell);var direction=strike_facing(point)
   return cell if contact_reachable(point,direction) else Vector2i(-1,-1)
 return Vector2i(-1,-1)

func downward_target(aim:Vector2)->Vector2i:
 # Chip the highest remaining footing first. Never delete a shaft wholesale:
 # each chosen surface still passes the same reach, visibility and hardness checks.
 var first=geo.cell_at(player-Vector2(BODY_SIZE.x*.5,0))
 var last=geo.cell_at(player+Vector2(BODY_SIZE.x*.5-.001,28))
 var best=Vector2i(-1,-1);var score=INF
 var origin=player+Vector2(0,-29)
 for x in range(first.x,last.x+1):
  for y in range(first.y,last.y+1):
   var c=Vector2i(x,y);var kind=geo.at(x,y)
   if kind in [0,12]:continue
   var point=contact_point(c);var direction=strike_facing(point)
   if kind!=8 and geo.exposed(c) and geo.visible_from(origin,c) and contact_reachable(point,direction):
    var value=(y-first.y)*100+absf(geo.center(c).x-aim.x)
    if value<score:score=value;best=c
   break
 return best

func begin_field_sample():
 mining_gun.selected=false
 if zone!="mine" or room_id!="":notify("Take field samples inside a mine. K opens your field notebook.");return
 if swing>0:return
 var c=target_cell()
 if c.x<0 or geo.at(c.x,c.y) in [0,8,12]:notify("Aim at exposed soil or stone within pick reach.");return
 tool=0;combat.armed=false;combat.reset_actions();construction.selected=""
 hit_cell=c;hit_point=contact_point(c);face=strike_facing(hit_point)
 swing_duration=.55;swing=.55;swing_done=false;sampling_strike=true;mining_buffer=0
 sound.effect("swing",-12)

func finish_field_sample():
 sampling_strike=false
 if not contact_reachable(hit_point,face) or not clear_strike_path():notify("Sample missed. Step closer to the exposed surface.");return
 var kind=geo.at(hit_cell.x,hit_cell.y)
 if kind in [0,8,12]:return
 HoldOnboarding.fact(state,"sample")
 var result=HoldFieldSurvey.sample(geo,hit_cell,48 if HoldOutpost.role_count(state,"surveyor")>0 else 36)
 sound.impact(kind,false);impact_pause=.025
 burst(hit_point,HoldTerrainView.COLORS[kind],3)
 impact_flashes.append({"p":hit_point,"life":.1,"broken":false})
 notify(result.clue+"  [K] Field notebook")

func handle_mining(dt:float):
 if mining_gun.selected:
  mining_gun.update();return
 mining_buffer=maxf(0,mining_buffer-dt)
 if swing>0:
  swing=maxf(0,swing-dt)
  if swing<=swing_duration*.45 and not swing_done:
   swing=swing_duration*.45;swing_done=true
   if sampling_strike:finish_field_sample()
   elif zone=="mine":hit_terrain()
   else:hit_tree()
 if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or mining_buffer>0) and swing<=0:
  if zone=="mine":
   var c=target_cell()
   if c.x<0:return
   hit_cell=c
   hit_point=contact_point(c)
   face=strike_facing(hit_point)
  else:
   if zone!="road" or tool!=2:return
   forest_target=HoldForestry.target(self,get_global_mouse_position()+camera)
   if forest_target.is_empty():return
   hit_point=forest_target.p;face=forest_target.face
  swing_duration=.55 if prospecting and tool==1 else (.30 if tool==1 else (.43 if tool==3 else .38))
  sampling_strike=false
  mining_buffer=0; swing=swing_duration;swing_done=false;sound.effect("swing",-8)

func clear_strike_path()->bool:
 var origin=player+Vector2(0,-29)
 var delta=hit_point-origin
 for step in range(1,int(delta.length()),3):
  var point=origin+delta.normalized()*step
  var cell=Vector2i(floor(point.x/Geology.TILE),floor(point.y/Geology.TILE))
  if geo.at(cell.x,cell.y) not in [0,12] and cell!=hit_cell:return false
 return true

func cut_radius(kind:int)->float:
 if Input.is_key_pressed(KEY_SHIFT):return 0.0
 if prospecting and tool==1:return 12.0
 return 18.0 if tool==1 and kind in [1,9,10,12] else (11.0 if tool in [0,3] else 5.0)
func hit_terrain():
 if not contact_reachable(hit_point,face) or not clear_strike_path():return
 var kind=geo.at(hit_cell.x,hit_cell.y)
 if kind==0:return
 if kind==8:notify("The edge of your licensed claim.");return
 if kind==7 and not state.steel:notify("Basalt needs a tempered steel pick.");sound.impact(kind,false);impact_pause=.025;return
 var power=(2.7 if state.steel else 1.4) if tool==0 else (3.0 if tool==1 and kind in [1,9,10,12] else .4)
 if tool==3:power=.7
 var results=geo.excavate(hit_point,player+Vector2(0,-29),cut_radius(kind),power,state.steel)
 sound.impact(kind,not results.is_empty())
 impact_pause=.025 if results.is_empty() else .04
 impact_flashes.append({"p":hit_point,"life":.1,"broken":not results.is_empty()})
 burst(hit_point,HoldTerrainView.COLORS[kind],3 if results.is_empty() else 7)
 if kind in [3,4,6]:
  for i in 3:particles.append({"p":hit_point,"v":Vector2(randf_range(-45,45),randf_range(-70,-20)),"life":.18,"c":Color("b5fff0") if kind==6 else Color("f3c482"),"size":1.5})
 reveal_discoveries()
 shake_amount=(.6 if results.is_empty() else 1.4) if state.shake else 0
 var sifted=0
 for result in results:
  HoldClaimStories.notice_ore(state,geo,result)
  if result.count>0:
   drops.append({"p":geo.center(result.cell),"v":Vector2(randf_range(-25,25),-40),"item":result.item,"count":result.count,"age":0.0})
  if prospecting and tool==1 and result.kind==1:sifted+=1
  state.mined+=1
  if result.kind==6 and not state.discovered:
   state.discovered=true;state.money+=40;notify("Aether resonance discovered! Survey bounty: 40 crowns.")
 if sifted>0:
  var trace=HoldFieldSurvey.sift(geo,hit_cell,sifted)
  if trace.count>0:
   state.add(trace.item,trace.count)
   popups.append({"p":hit_point+Vector2(0,-22),"text":"SIFTED +%d %s" % [trace.count,HoldData.ITEMS[trace.item].name.to_upper()],"life":2.0})
   notify("Recovered bonus ore from the dirt. "+trace.clue)
  elif trace.item=="":notify(trace.clue+" X: sample • K: choose mineral")
 if not results.is_empty():
  for i in 3:particles.append({"p":hit_point,"v":Vector2(randf_range(-18,18),randf_range(-18,-6)),"life":.4,"c":HoldTerrainView.COLORS[kind],"size":randf_range(3,6),"dust":true})

func hit_tree():
 HoldForestry.strike(self,forest_target)
func tree_x(i:int)->float:return HoldForestry.X[i]

func update_agents(dt:float):
 var route_budget=1
 if not state.agents_enabled or (state.claim_id!="legacy" and state.active_site!="claim"):return
 for agent in agents:
  agent.work=false;agent.cool-=dt
  if agent.fuel<=0:
   var resource="food" if agent.type=="worker" else "coal"
   if state.count(resource)==0:
    agent.status="Needs "+HoldData.ITEMS[resource].name
    if agent.type=="worker":HoldOutpost.record(state,"supply_"+agent.id,HoldOutpost.member(state,agent.id).name+" paused mining when provisions ran out. The crew waits safely for supplies.")
    continue
   state.add(resource,-1);agent.fuel=12 if agent.type=="worker" else 18
  if not agent.path.is_empty():
   var p:Vector2=agent.path[0]
   agent.p=agent.p.move_toward(p,dt*(80 if agent.type=="worker" else 105))
   agent.status="Travelling by survey cable"
   if agent.p.distance_to(p)<2:agent.path.pop_front()
   continue
  var c:Vector2i=agent.target
  if c.x<0 or geo.at(c.x,c.y)==0:
   if agent.cool>0 or route_budget<=0:continue
   route_budget-=1
   var start=Vector2i(floor(agent.p.x/Geology.TILE),floor(agent.p.y/Geology.TILE))
   var priority=state.outpost.crew[agent.id].priority if agent.type=="worker" else state.priority
   var route=geo.route(start,priority)
   if route.is_empty():agent.status="No accessible deposits — open a passage";agent.cool=1.5;continue
   agent.target=route.target;agent.path=route.path;agent.status="Heading to seam";continue
  if agent.p.distance_to(geo.center(c))>48:
   agent.target=Vector2i(-1,-1);continue
  agent.work=true;agent.status="Excavating "+HoldData.TILES[geo.at(c.x,c.y)].name
  if agent.cool<=0:
   agent.cool=(.52 if HoldOutpost.member(state,agent.id).specialty=="miner" else .72) if agent.type=="worker" else .44
   if agent.type=="worker":agent.cool/=(1.0+HoldClaimStories.trust(state,agent.id)+(.05 if state.outpost.favors.get(agent.id,false) else 0.0))
   var kind=geo.at(c.x,c.y)
   var results=geo.excavate(geo.center(c),agent.p,18 if agent.type=="worker" else 25,1.5 if agent.type=="worker" else 2.1,state.steel,true)
   if zone=="mine":burst(geo.center(c),Color(HoldData.TILES[kind].color),4)
   for result in results:
    HoldClaimStories.notice_ore(state,geo,result)
    state.add(result.item,result.count);state.mined+=1
    if agent.type=="worker" and result.item in ["iron_ore","copper_ore","coal","crystal"]:HoldOutpost.record(state,"seam_"+agent.id+"_"+result.item,HoldOutpost.member(state,agent.id).name+" worked the crew's first "+HoldData.ITEMS[result.item].name.to_lower()+" seam as part of "+HoldCulture.words(state.npc(agent.id)).possessive+" assignment.")
    agent["grain_work"]=int(agent.get("grain_work",0))+1
    if agent.grain_work>=16:agent.fuel-=1;agent.grain_work=0
    if zone=="mine" and result.count>0:popups.append({"p":geo.center(c),"text":"+%d %s" % [result.count,result.item.replace("_ore","" )],"life":1.3})

 remember_agents()

func update_effects(dt:float):
 for i in range(impact_flashes.size()-1,-1,-1):
  impact_flashes[i].life-=dt
  if impact_flashes[i].life<=0:impact_flashes.remove_at(i)
 for i in range(particles.size()-1,-1,-1):
  var p=particles[i];p.life-=dt
  if p.get("dust",false):p.p+=p.v*dt
  else:
   p.v.y+=420*dt
   var next=p.p+p.v*dt
   if zone=="mine" and geo.solid(next):
    p.v=Vector2(p.v.x*.45,-absf(p.v.y)*.3);p.life=minf(p.life,.22)
   else:p.p=next
  if p.life<=0:particles.remove_at(i)
 for i in range(popups.size()-1,-1,-1):
  popups[i].life-=dt;popups[i].p.y-=dt*22
  if popups[i].life<=0:popups.remove_at(i)
 for i in range(drops.size()-1,-1,-1):
  var d=drops[i];d.age+=dt
  if d.age<.26:
   d.v.y+=300*dt
   var next=d.p+d.v*dt
   if zone=="mine" and geo.solid(next):d.v.y=-absf(d.v.y)*.35
   else:d.p=next
  else:d.p=d.p.move_toward(player+Vector2(0,-20),dt*340)
  if d.age>.26 and (d.p.distance_to(player+Vector2(0,-20))<18 or d.age>2):
   state.add(d.item,d.count);sound.effect("pickup",-10);popups.append({"p":d.p,"text":"+%d %s" % [d.count,HoldData.ITEMS[d.item].name],"life":1.3});drops.remove_at(i)
func burst(p:Vector2,c:Color,num:int):
 for i in num:particles.append({"p":p,"v":Vector2(randf_range(-90,90),randf_range(-140,15)),"life":randf_range(.2,.65),"c":c.lightened(randf_range(0,.2)),"size":randf_range(2,4)})
func notify(s:String):notice=s;notice_time=5.5
func save_game():
 if hotbar and playing:hotbar.data().selected=hotbar.selected()
 if surface:surface.remember()
 if deep:deep.remember()
 remember_agents()
 # Flush attracted pickups so an immediate save cannot lose a broken tile's yield.
 for d in drops:state.add(d.item,d.count)
 drops.clear()
 if not state.save_world(geo,zone,exterior_position if room_id!="" else player):notify("Save failed. Check disk permissions.")
func change_zone(z:String):
 if z!="mine" and surface:
  surface.enter("claim" if z=="claim" or state.active_site=="claim" else "hearthward");return
 if zone=="mine" and z!="mine":deep.depart()
 room_id="";swing=0;impact_pause=0
 for d in drops:state.add(d.item,d.count)
 drops.clear();particles.clear();popups.clear();close_panel();zone=z;velocity=Vector2.ZERO
 player=Vector2(150,370) if z=="mine" else Vector2(1465,HUB_FLOOR)
 camera=Vector2.ZERO if z=="mine" else Vector2(985,0)
 if z=="mine":deep.enter()
 begin_transition("THE LOWER WORKINGS" if z=="mine" else "BACK TO THE HOLD");sound.set_context(z)
 notify("DEEPWORKS: WASD move · Hold LMB dig · V carve stairs · E down / Shift+E up · X survey below." if z=="mine" else "Welcome home. Your forge and crew keep working while you explore.")
 save_game()
func interact():
 if surface.active():surface.use();return
 if zone=="mine":deep.use_stairs(Input.is_key_pressed(KEY_SHIFT));return
 if zone=="road" and room_id=="":
  HoldForestry.interact(self);return
 if zone=="hub" and room_id=="" and state.active_site=="hold" and player.x<125:
  enter_west_gallery();return
 if zone=="hub" and room_id=="" and HoldAnniversary.ensure(state).complete and absf(player.x-535)<42:
  open_panel("anniversary");return
 if zone=="claim" and room_id=="" and absf(player.x-nearest_station().x)>60:
  for id in state.outpost.get("crew",{}):
   if player.distance_to(HoldOutpostUI.position(state,id))<48:
    visitor_key=id;HoldConversation.start(self,id);return
 if room_id!="":
  if room_id=="tavern":
   var guests=HoldNpcPresence.tavern_guests(state)
   for i in guests.size():
    if absf(player.x-(280+i*100))<42:
     visitor_key=guests[i];HoldConversation.start(self,visitor_key);return
  if absf(player.x-115)<95:leave_room()
  elif absf(player.x-625)<115:
   var host=str(HoldInteriors.ROOMS[room_id].host)
   if host!="":HoldConversation.start(self,host)
   else:open_panel(room_id)
  else:notify("Walk to the workbench or your host and press E. The exit is on the left.")
  return
 if zone=="approach":
  open_panel("basin_map");return
 if zone=="mine":
  if state.active_site=="hold":
   if can_region_travel():open_panel("basin_map")
   else:notify("Return to the mine entrance to set out. V builds your way back.")
   return
  if player.distance_to(Vector2(150,370))<110:change_zone("claim")
  else:notify("Build a return route with V. R requests paid emergency extraction.")
 else:
  var closest=nearest_station()
  if zone=="hub":
   for i in 3:
    if player.distance_to(visitor_position(i))<48:
     visitor_key="visitor_"+str(i);HoldConversation.start(self,visitor_key);return
  if absf(player.x-closest.x)>95:notify("Move near a doorway and press E.");return
  if closest.panel=="expedition":
   if can_region_travel():open_panel("basin_map")
   else:notify(region_travel_hint())
  elif closest.panel=="mine":
   if state.opening==0:open_panel("briefing")
   elif zone=="hub":notify("Press G to explore Keldrath. Leave by the King's Gate on Hearthward, then walk to Old Workings along the High Trail.")
   else:change_zone("mine")
  elif closest.panel=="gate" and zone=="hub":
   if can_region_travel():open_panel("basin_map")
   else:notify(region_travel_hint())
  elif closest.panel=="travel_claim":
   if state.claim_id=="":open_panel("charters")
   else:travel_claim()
  elif HoldInteriors.ROOMS.has(closest.panel):enter_room(closest.panel)
  else:open_panel(closest.panel)
func enter_west_gallery():
 velocity=Vector2.ZERO
 var entrance=HoldFloorPlan.door(10)+Vector2(0,15)
 state.hold_travel={"active":true,"at":10,"toward":-1,"progress":0,"floor_x":entrance.x,"floor_y":entrance.y,"concourse_x":95,"version":2}
 open_panel("world_map")
func nearest_station()->Dictionary:
 var stations=ROAD_STATIONS if zone=="road" else (CLAIM_STATIONS if zone=="claim" else STATIONS)
 var best=stations[0]
 for station in stations:
  if absf(station.x-player.x)<absf(best.x-player.x):best=station
 return best
func goal()->String:
 var primary=HoldOnboarding.primary(state)
 if primary!="":return primary
 if state.opening==0:return "A NEW SHIFT: Introduce yourself to Ivar at the foreman's office."
 if state.opening<4:
  var j=HoldCampaign.JOBS[state.opening-1]
  return "HOLD COMMISSION: "+j.name.to_upper()+" / J: JOURNAL"
 if state.claim_id=="":return "YOUR OWN MOUNTAIN: Visit the survey office. Charters from 240 crowns."
 if state.camp_stage<3:return "FOUND YOUR OUTPOST: "+HoldCampaign.CAMP[state.camp_stage].name.to_upper()+" / M: PLAN"
 if state.launched:return "Your first ship is flying. Your outpost remains yours to grow. / M: MANAGE"
 if not state.tech.has("metallurgy"):return "FIRST STEPS: Mine iron, copper and coal. Smelt at the forge."
 if not state.tech.has("automation"):return "GROW YOUR HOLD: Research clockwork industry; recruit a crew."
 return "YOUR FIRST STARSHIP: Build at the eastern launchyard (%d/3)." % state.ship_stage
func update_hud():
 var place="KELDRATH"
 if zone=="approach":place="MOUNTAIN APPROACH"
 elif zone=="road":place="PINEWOOD"
 elif state.active_site=="claim":place=HoldOutpost.title(state).to_upper()
 if room_id!="":place=HoldInteriors.ROOMS[room_id].name.to_upper()
 hud.text=place+" / "+("DEEP WORKINGS" if zone=="mine" else ("KELDRATH" if zone=="approach" else "TIMBER COUPE" if zone=="road" else "MOUNTAIN HOLD"))+"   %d CROWNS" % state.money
 status.text="IRON ORE %d   COPPER %d   COAL %d   CRYSTAL %d   TIMBER %d" % [state.count("iron_ore"),state.count("copper_ore"),state.count("coal"),state.count("crystal"),state.count("wood")]
 objectives.text=goal()
 objectives.visible=zone!="mine" and playing
 for item in [hud,status,footer]:item.visible=playing and not (zone=="mine" and panel_id!="")
 if menu_paused or panel_id in ["pause","settings"]:footer.text="PAUSED — TAKE YOUR TIME   |   CLOSE TO RESUME"
 elif panel_id!="":footer.text="ESC  BACK / CLOSE     |     "+("PRODUCTION CONTINUES" if not state.queue.is_empty() else "YOUR HOLD, YOUR FORTUNE")
 elif room_id!="":
  footer.text="E  LEAVE BUILDING" if absf(player.x-115)<95 else ("E  "+str(HoldInteriors.ROOMS[room_id].action).to_upper() if absf(player.x-625)<115 else "A/D WALK   E INTERACT   EXIT TO THE LEFT")
 elif zone=="hub" and room_id=="" and state.active_site=="hold" and player.x<125:footer.text="E  WEST GALLERY / EXPLORE KELDRATH     |     D  RETURN TO THE CONCOURSE"
 elif notice_time>0:footer.text=notice
 elif construction.selected!="":footer.text="BUILD: "+HoldConstruction.OPTIONS[construction.selected].name+"   LMB PLACE   1–4 CANCEL   V OPTIONS"
 elif zone=="road":footer.text=HoldForestry.hint(self)
 elif zone=="approach":footer.text="HIGH TRAIL LOOKOUT   |   G BASIN MAP   E PLAN JOURNEY   A/D WALK"
 elif zone=="mine":footer.text="WASD move   LMB mine   E interact   O rooms   H haulage   X survey   F1 help"
 else:
  var nearest=nearest_station()
  footer.text="E  "+nearest.name.to_upper()+"    |    A/D MOVE   I PACK   M CREW   F1 HELP" if absf(nearest.x-player.x)<95 else "A/D MOVE   E INTERACT   C CHARACTER   I PACK   M CREW   F1 HELP"

 if surface and surface.active():surface.hud()
 status.visible=false

func _draw():
 forest_view.visible=playing and zone=="road" and room_id=="" and not surface.active()
 if forest_view.visible:forest_view.queue_redraw()
 if not playing:draw_title();return
 if zone=="mine":deep.draw();return
 if surface.active():surface.draw();return
 draw_background()
 var offset=-camera
 if shake_amount>0:offset+=Vector2(sin(clock*103),cos(clock*137))*shake_amount
 offset=offset.round()
 A.draw_offset=offset
 draw_set_transform(offset)
 if continuous_journey():draw_journey_world(offset)
 elif room_id!="":HoldInteriors.draw(self,room_id,clock,state)
 elif zone=="hub":draw_hub()
 elif zone=="approach":JOURNEY.approach(self,clock)
 elif zone=="road":pass # Separate filtered scenery canvas; character art keeps its own sampling.
 elif zone=="claim":
  SCENERY.camp(self,clock,state,launch_time*launch_time*13 if launching else 0)
  HoldOutpostUI.draw_crew(self)
 else:
  draw_mine()
  if state.active_site=="hold":
   SCENERY.expedition_table(self,Vector2(85,392))
   A.text(self,Vector2(34,268),"E / G: BASIN MAP",12,Color("b7d4cc"))
 for d in drops:
  HoldItemArt.draw(self,Rect2(d.p-Vector2(8,8),Vector2(16,16)),HoldItemArt.item_index(d.item),HoldItemArt.tint(d.item))
 if zone=="mine":
  for agent in agents:
   var p:Vector2=agent.p+Vector2(0,14)
   A.line(self,Vector2(p.x,0),p+Vector2(0,-35),Color(.5,.6,.6,.25),1)
   if agent.type=="worker":
    var look=agent.path[0] if not agent.path.is_empty() else geo.center(agent.target)
    A.dwarf(self,p,clock,not agent.path.is_empty(),-1 if look.x<agent.p.x else 1,3,agent.work,state.npc(agent.get("id","brann")))
   else:A.bot(self,p,clock,agent.work)
   if agent.type=="worker":HoldQuestMarkers.draw(self,p,state,agent.get("id","brann"))
 combat.draw_enemies()
 var action=(mining_frame(1-swing/swing_duration)+.1)/8.0 if swing>0 else -1.0
 if mining_gun.selected and mining_gun.braced>0:action=4.1/8.0
 if combat.profile().get("shield_guard",false):
  var guard_frame=0 if combat.guard_reaction<=0 else (3 if combat.guard_reaction<.08 else (2 if combat.guard_parried else 1))
  action=(guard_frame+.1)/8.0
 if combat.attack_left>0 and state.combat.weapon=="gun":action=4.1/8.0
 if combat.attack_left>0 and state.combat.weapon!="gun":action=clampf(1-combat.attack_left/combat.weapon().time,0,.99)
 var player_profile=combat.profile();player_profile["air_pose"]=0 if grounded or winch else (1 if velocity.y<0 else 2);player_profile["gait_time"]=gait_clock
 A.dwarf(self,player,gait_clock,walking_pose,face,0,false,player_profile,action)
 construction.draw()
 HoldClaimStories.draw(self)
 if combat.armed:combat.draw_weapon()
 elif mining_gun.selected:mining_gun.draw()
 else:draw_tool()
 for p in particles:
  var color:Color=p.c;color.a=clampf(p.life*3,0,.35 if p.get("dust",false) else 1)
  A.rect(self,p.p.x,p.p.y,p.size,p.size,color)
 for flash in impact_flashes:
  var radius=(1-flash.life/.12)*10+2
  draw_arc(flash.p,radius,0,TAU,8,Color(1,.86,.55,flash.life*5),1.5)
 for p in popups:A.text(self,p.p,p.text,13,Color(1,.88,.6,minf(1,p.life)))
 draw_set_transform(Vector2.ZERO)
 A.draw_offset=Vector2.ZERO
 # Unobtrusive HUD framing.
 A.rect(self,0,0,960,74,Color(.035,.08,.12,.92));A.line(self,Vector2(24,73),Vector2(936,73),Color("63756c"))
 A.rect(self,0,498,960,42,Color(.035,.08,.12,.95))
 A.rect(self,18,80,610,25,Color(.035,.08,.12,.82))
 A.rect(self,720,82,210,22,Color(.035,.08,.12,.9))
 A.rect(self,726,88,98,8,Color("303e49"));A.rect(self,726,88,98*state.combat.health/100,8,Color("8bc8ab"))
 A.text(self,Vector2(832,98),"%d HP / B GEAR" % state.combat.health,12,Color("d4e5da"))
 draw_tracking()
 for i in 4:
  var x=370+i*59
  A.rect(self,x,445,53,42,"355655" if tool==i and not mining_gun.selected else "152d38")
  if tool==i and not mining_gun.selected:draw_rect(Rect2(x,445,53,42),Color("d5b374"),false,2)
  A.text(self,Vector2(x+5,459),str(i+1),11)
  draw_tool_icon(Vector2(x+29,469),i)
 if state.outpost.get("mining_gun",false):
  A.rect(self,610,445,54,42,"355655" if mining_gun.selected else "152d38")
  A.text(self,Vector2(615,461),"5",12);A.text(self,Vector2(616,480),"RUNE",11)
 if zone=="mine" and panel_id=="" and not combat.armed and not mining_gun.selected:
  var c=hit_cell if swing>0 else target_cell()
  if c.x>=0:
   var p=(hit_point if swing>0 else contact_point(c))-camera
   var kind=geo.at(c.x,c.y)
   var radius=cut_radius(kind)
   draw_arc(p,maxf(4,radius),0,TAU,20,Color("e7d3a2"),1)
   if radius==0:draw_rect(Rect2(Vector2(c)*Geology.TILE-camera,Vector2.ONE*Geology.TILE),Color("e7d3a2"),false,1)
   A.text(self,Vector2(680,468),HoldData.TILES.get(kind,{"name":"Fractured surface"}).name,14)
   A.text(self,Vector2(680,486),"FINE CUT" if radius==0 else "SHIFT: FINE CUT",11,Color("a8c5b9"))
 if zone=="mine" and panel_id=="":
  HoldFieldSurvey.hud(self)
  A.text(self,Vector2(25,448),"X: sample    P: sift    K: notebook",13,Color("b5e1d5"))
 A.text(self,Vector2(25,476),(combat.weapon().name if combat.armed else (mining_gun.status() if mining_gun.selected else "Sifting dirt [P]" if prospecting and tool==1 else TOOL_NAMES[tool]))+(" +" if tool==0 and state.steel and not mining_gun.selected else ""),15,Color("b3d2c9"))
 if playing:A.text(self,Vector2(705,29),state.appearance.name.left(29),12,Color("abcdbf"))
 if not state.queue.is_empty():A.text(self,Vector2(695,493),"FORGE: %d JOBS" % state.queue.size(),12)

func draw_background():
 if continuous_journey():
  backdrop.visible=false
  var global_camera=camera+Vector2(JOURNEY.offset(zone),0)
  A.rect(self,0,0,960,540,"101c2a")
  JOURNEY.backdrop(self,VALLEY,0,8000,global_camera)
  JOURNEY.backdrop(self,HALL,0,2120,global_camera,Rect2(),true)
  if 4000-global_camera.x<960:HoldMountain.background(self,geo,global_camera-Vector2(4000,0))
  return
 if room_id!="" or zone=="road":backdrop.visible=false;return
 backdrop.visible=zone!="mine"
 if zone!="mine":
  var texture=HALL if zone=="hub" else (RIDGE if zone=="claim" else VALLEY)
  backdrop.texture=texture;backdrop.position=Vector2(round(-camera.x*.6),-75);backdrop.scale=Vector2(1728.0/texture.get_width(),576.0/texture.get_height())
  # Atmospheric foreground shade keeps the tiny working figures readable.
  A.rect(self,0,337,960,73,Color(.04,.10,.13,.18))
  if zone=="hub":
   # Small moving freight cages sell the scale of the distant machinery.
   var x=fposmod(clock*18,1600)-camera.x*.6
   A.line(self,Vector2(x+16,142),Vector2(x+16,183),"52676e",1)
   A.rect(self,x,183,32,15,"415961");A.rect(self,x+2,184,28,2,"b79b66")
   if state.opening<2:A.rect(self,0,0,960,410,Color(.03,.08,.12,.15))
 else:
  A.rect(self,0,0,960,540,"101c2a")
  JOURNEY.backdrop(self,WORKINGS_VALLEY,0,4000,camera)
  HoldMountain.background(self,geo,camera)

func draw_hub():
 SCENERY.hall(self,clock,state)
 if HoldAnniversary.ensure(state).complete:
  HoldAnniversary.station(self,Vector2(535,410),clock,true,true,int(HoldAnniversary.gift(state,"orla").choice))
  A.text(self,Vector2(503,310),"E • TEA",11,Color("e4c58b"))
 # Named residents are inside their workplaces. Mark the entrance, not a duplicate body.
 for id in HoldNpcPresence.HOMES:
  var place=HoldNpcPresence.HOMES[id]
  if place.room in ["tavern","market","commission","forge","research"]:
   HoldQuestMarkers.draw(self,Vector2(place.x,410),state,id)
 for i in 3:
  var motion=visitor_motion(i)
  A.dwarf(self,motion.p,clock*.7+i,motion.walking,motion.facing,0,false,state.npc("visitor_"+str(i)))

func draw_mine():
 terrain_view.draw(self,geo,clock,camera)
 var sample:Dictionary=geo.mountain.get("tracked_sample",{})
 if not sample.is_empty():
  var spot=Vector2(sample.x,sample.y)*Geology.TILE+Vector2(3.5,3.5)
  draw_arc(spot,9,0,TAU,24,Color("80e5da"),1.5,true)
  A.text(self,spot+Vector2(13,-8),"SAMPLE • K",11,Color("a2eee1"))
 var min_x=maxi(0,int(camera.x/Geology.TILE));var max_x=mini(Geology.W,int((camera.x+960)/Geology.TILE)+1)
 var min_y=maxi(0,int(camera.y/Geology.TILE));var max_y=mini(Geology.H,int((camera.y+540)/Geology.TILE)+1)
 # Exposed contours are baked with the terrain, including fresh cuts.
 for key in geo.damage:
  var xy=key.split(",");var c=Vector2i(int(xy[0]),int(xy[1]))
  if c.x<min_x or c.x>=max_x or c.y<min_y or c.y>=max_y:continue
  var p=Vector2(c)*Geology.TILE
  var kind=geo.at(c.x,c.y)
  if kind not in [0,8]:
   var progress=clampf(float(geo.damage[key])/geo.hardness(kind),0,1)
   var center=p+Vector2(3,3);var extent=2+progress*5
   var crack=PackedVector2Array([center+Vector2(-extent,-extent*.6),center+Vector2(-1,1),center+Vector2(2,-1),center+Vector2(extent,extent*.8)])
   draw_polyline(crack,Color("17272d"),1.2)
   if progress>.45:draw_line(center,center+Vector2(-extent*.5,extent),Color("17272d"),1)
   if progress>.75:draw_line(center+Vector2(1,-1),center+Vector2(4,-extent),Color("c1b896"),1)
 # Frames are grounded in terrain; their solid roof remains mineable.
 for frame in geo.structures:
  var base=Vector2(frame.x*7,(frame.y+1)*7)
  draw_texture_rect_region(HoldTerrainView.ATLAS,Rect2(base-Vector2(0,91),Vector2(84,91)),Rect2(526,521,482,455))
 if state.active_site!="hold":A.text(self,Vector2(98,282),"E  HOME",12)

 # Supplies sit on the entrance floor and vanish if their footing is excavated.
 if geo.at(18,56)!=0:HoldWorldDetails.prop(self,Vector2(129,392),"cache",72)
 # Player lantern: restrained translucent rings, no black visibility mask.
 if zone=="mine":
  for i in range(4,0,-1):draw_circle(player+Vector2(9,-44),35+i*23,Color(1,.72,.38,.012))

func draw_tool_icon(p:Vector2,kind:int):
 HoldItemArt.draw(self,Rect2(p-Vector2(12,18),Vector2(25,33)),kind)
func draw_tool():
 if swing<=0:return
 var progress=1-swing/swing_duration
 var frame=mining_frame(progress)
 var phase=HoldCharacterArt.action_frame(progress,tool)
 var scale=character_scale()
 var hand=HoldCharacterArt.work_hand(frame,state.appearance)*scale
 var origin=player+hand*Vector2(face,1)
 var direction=(HoldCharacterArt.work_end(frame,state.appearance,tool)-HoldCharacterArt.work_hand(frame,state.appearance)).normalized()*Vector2(face,1)
 # Aim by rotating around the grip. Neither tool size nor grip position changes with range.
 var weight=[0.0,.25,.5,.75,1.0,.75,.4,0.0][phase] if overhead_strike(hit_point) or downward_strike(hit_point) else [0.0,0.0,0.0,0.0,1.0,.65,.2,0.0][phase]
 if origin.distance_to(hit_point)>1:
  direction=Vector2.from_angle(lerp_angle(direction.angle(),(hit_point-origin).angle(),weight))
 var end=origin+direction*[36.0,40.0,35.0,33.0][tool]*scale
 HoldCharacterArt.draw_tool(self,origin+A.draw_offset,end+A.draw_offset,tool,A.draw_offset,face,-1,scale)
 HoldCharacterArt.draw_grip(self,player+A.draw_offset,frame,state.appearance,face,A.draw_offset,character_tint(player),false,scale)

func draw_title():
 backdrop.visible=true;backdrop.texture=HALL;backdrop.position=Vector2(-290,-30);backdrop.scale=Vector2(1728.0/HALL.get_width(),576.0/HALL.get_height())
 A.rect(self,0,0,470,540,Color(.025,.065,.09,.9))
 for i in 24:A.rect(self,470+i*4,0,4,540,Color(.025,.065,.09,.8*(1.0-float(i)/24)))
 A.rect(self,34,48,2,436,"a18b61")
 A.line(self,Vector2(24,48),Vector2(45,48),Color("d8b878"),2)
 A.line(self,Vector2(24,484),Vector2(45,484),Color("d8b878"),2)
 for i in 18:
  var x=540+fmod(i*71.0+sin(clock*.4+i)*12,400)
  var y=440-fmod(clock*(9+i%4)+i*29,370)
  A.rect(self,x,y,2,2,Color(1,.72,.36,.22+.18*sin(clock+i)))
 A.dwarf(self,Vector2(815,449),clock,false,-1,0,false,state.appearance)
 A.line(self,Vector2(65,282),Vector2(425,282),Color("aa8a55"),2)

func button(parent:Node,label:String,callback:Callable)->Button:
 var b=Button.new();b.text=label;b.custom_minimum_size.y=42;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.size_flags_vertical=Control.SIZE_SHRINK_CENTER;b.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;parent.add_child(b);b.pressed.connect(callback);return b
func label(parent:Node,s:String,size:int=15,color:Color=Color("e6e8e2"))->Label:
 var l=Label.new();l.text=s;l.add_theme_font_size_override("font_size",maxi(16,size));l.add_theme_color_override("font_color",color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size_flags_horizontal=Control.SIZE_EXPAND_FILL;parent.add_child(l);return l
func row(parent:Node)->HBoxContainer:
 var r=HBoxContainer.new();r.add_theme_constant_override("separation",8);parent.add_child(r);return r
func toggle_panel(id:String):
 if panel_id==id:close_panel()
 else:open_panel(id)
func close_panel():
 mining_buffer=0
 if is_instance_valid(overworld):
  overworld.queue_free();overworld=null
  for n in [hud,status,objectives,footer]:n.visible=playing
 sound.stop_voice()
 if playing and panel_id in ["pause","settings"]:save_game()
 panel.visible=false;panel_id="";panel_info=null;menu_history.clear();menu_paused=false
 jump_buffer=0;movement_remainder=0
func back_panel():
 if playing and panel_id=="settings":save_game()
 if menu_history.is_empty():close_panel();return
 var previous=menu_history.pop_back()
 open_panel(previous.id,false)
 restore_menu.call_deferred(previous.scroll,"")
func restore_menu(offset:int,focus_text:String):
 if not is_instance_valid(menu_scroll):return
 menu_scroll.scroll_vertical=offset
 if focus_text!="":
  for b in panel.find_children("*","Button",true,false):
   if b.text==focus_text and not b.disabled:
    b.grab_focus();break
func refresh_panel():
 var offset=menu_scroll.scroll_vertical if is_instance_valid(menu_scroll) else 0
 var focused=get_viewport().gui_get_focus_owner()
 var text=focused.text if focused is Button else ""
 open_panel(panel_id,false);restore_menu.call_deferred(offset,text)
func small_button(parent:Node,text:String,fn:Callable)->Button:
 var b=button(parent,text,fn);b.custom_minimum_size.y=30;b.add_theme_font_size_override("font_size",14)
 for style_name in ["normal","hover","pressed","disabled"]:
  var style=b.get_theme_stylebox(style_name).duplicate();style.set_content_margin_all(7);b.add_theme_stylebox_override(style_name,style)
 return b
func section(parent:Node,title:String)->VBoxContainer:
 var box=PanelContainer.new();var style=StyleBoxFlat.new();style.bg_color=Color("1d3540");style.set_content_margin_all(12);style.set_corner_radius_all(4);box.add_theme_stylebox_override("panel",style);parent.add_child(box)
 var body=VBoxContainer.new();body.add_theme_constant_override("separation",7);box.add_child(body)
 if title!="":label(body,title,18,Color("edc98a"))
 return body
func requirements(cost:Dictionary,crowns:int=0)->String:
 var missing:PackedStringArray=[]
 for k in cost:
  if state.count(k)<cost[k]:missing.append("%d %s" % [cost[k]-state.count(k),HoldData.ITEMS[k].name])
 if state.money<crowns:missing.append("%d crowns" % (crowns-state.money))
 return "Ready" if missing.is_empty() else "Need "+", ".join(missing)
func compact_person(key:String,quote:String):
 var r=row(panel_body)
 label(r,state.npc(key).name+" / "+quote,16,Color("b8cfc6"))
 if HoldConversation.local(self,key):small_button(r,"Talk",func():HoldConversation.start(self,key))

func menu_footer(parent:Node):
 var bottom=row(parent)
 label(bottom,"Choose your fortune" if panel_id=="save_slots" else ("Paused" if menu_paused else "Safe to browse • production continues"),14,Color("a7c8bf"))
 var hint=label(bottom,"Tab: focus  •  Enter: select  •  Esc: back / close",14,Color("a7c8bf"));hint.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT

func purchase(cost:Dictionary,crowns:int,callback:Callable):
 if not state.pay(cost,crowns):notify("Not enough materials or crowns.");return
 callback.call();sound.effect("build");save_game();refresh_panel()
func open_panel(id:String,remember:bool=true):
 if id in ["world_map","basin_map","gate"]:id="wayfinding"
 if playing and panel_id=="settings" and id!="settings":save_game()
 if remember and panel_id!="" and panel_id!=id:
  menu_history.append({"id":panel_id,"scroll":menu_scroll.scroll_vertical if is_instance_valid(menu_scroll) else 0})
 if panel_id=="ivar_welcome" and id not in ["ivar_welcome","pause","settings"]:sound.stop_voice()
 if id in ["handworks","house_build","wayfinding","homestead","storage","pause","settings","build_status","ivar_welcome","world_map","basin_map","gate","conversation","anniversary","lesson","social","commission","claim_stories","field_notes","pinewood"]:menu_paused=true
 panel_id=id;panel.visible=true
 panel.position=Vector2(120,44) if id=="living" else Vector2(60,44)
 panel.size=Vector2(720,452) if id=="living" else Vector2(840,452)
 for child in panel.get_children():panel.remove_child(child);child.queue_free()
 var outer=VBoxContainer.new();outer.add_theme_constant_override("separation",9);panel.add_child(outer)
 var top=row(outer)
 if not menu_history.is_empty():small_button(top,"‹ Back",back_panel)
 var names={"handworks":"HANDS OF THE DWARF","wayfinding":"PATHS & DOORWAYS","storage":"YOUR STORAGE CHEST","house_build":"BUILD YOUR HEARTH","homestead":"YOUR HOMESTEAD","living":"THE LIVING WORKS","haulage":"MATERIALS & HAULAGE","projects":"PROJECT LEDGER","deepworks":"THE DEEPWORKS","pinewood":"THE WOODCUTTER'S FIELD BOARD","build_status":"BUILD STATUS · WIP","guidance":"YOUR FIRST SEASON","lesson":"WORK & KNOWLEDGE","throne":"THE KING'S HALL","training":"BORIN'S PRACTICE BAY","conversation":"CONVERSATION","anniversary":"A QUIET WORD","social":"AROUND THE HOLD","ivar_welcome":"IVAR • YOUR FIRST SHIFT","settings":"SOUND & COMFORT","equipment":"WEAPONS & ARMOR","construction":"BUILD YOUR RETURN ROUTE","rescue":"EMERGENCY EXTRACTION","briefing":"BENEATH THE CROWN OF STONE","commission":"THE LOWER WORKS","charters":"A MOUNTAIN OF YOUR OWN","world_map":"THE KELDRATH BASIN","gate":"THE KELDRATH BASIN","camp":"YOUR FOUNDING CHARTER","home":"YOUR QUARTERS","tavern":"THE COPPER KETTLE","market":"ORLA'S EXCHANGE","forge":"BORIN'S FORGE","research":"THE SURVEY OFFICE","inventory":"YOUR PROSPECTOR'S PACK","manage":"YOUR OUTPOST & CREW","ship":"THE FIRST FORTUNE","pause":"TAKE A BREATH","field_notes":"FIELD NOTEBOOK","help":"A PROSPECTOR'S HANDBOOK","victory":"FROM PROSPECTOR TO CAPTAIN","save_slots":"YOUR FORTUNES • THREE SAVE SLOTS","new_confirm":"BEGIN ANOTHER FORTUNE?","roster":"FACES OF KELDRATH","visitor":"A FAMILIAR FACE"}
 label(top,names.get(id,"Claim business" if id=="claim_stories" else id.to_upper()),22,Color("e9c586"))
 small_button(top,"Close ×",close_panel)
 if playing and id not in ["handworks","living","haulage","projects","deepworks","briefing","new_confirm","rescue","victory","ivar_welcome","world_map","basin_map","gate","conversation","anniversary","lesson","social","build_status","commission","claim_stories","field_notes","pinewood"]:
  var nav=row(outer)
  for entry in [["commission","Journal · J"],["inventory","Pack · I"],["equipment","Gear · B"],["roster","People · N"],["wayfinding","Directions · G"],["help","Guide · F1"]]:
   var tab=small_button(nav,entry[1],func():open_panel(entry[0]));tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL
   if id==entry[0]:tab.modulate=Color("a7e2ce")
 var scroll=ScrollContainer.new();scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;outer.add_child(scroll);menu_scroll=scroll
 panel_body=VBoxContainer.new();panel_body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;panel_body.add_theme_constant_override("separation",6 if id in ["commission","lesson","social"] else 9);scroll.add_child(panel_body)
 menu_footer(outer)
 match id:
  "conversation":HoldConversation.panel(self)
  "field_notes":
   if zone=="mine":deep.panel()
   else:HoldFieldSurvey.panel(self)
  "equipment":combat.panel()
  "deepworks":deep.panel()
  "haulage":deep.haulage_panel()
  "living":deep.works.panel()
  "projects":deep.project_panel()
  "construction":
   if zone=="mine":deep.panel()
   else:construction.panel()
  "rescue":
   label(panel_body,"EMERGENCY EXTRACTION",21,Color("edc98a"))
   label(panel_body,"Try stairs, ladders, or digging a return route first. The rescue crew charges %d crowns. Any amount you cannot pay becomes a debt deducted from future income." % rescue_cost(),17)
   label(panel_body,"Outstanding rescue debt: %d crowns. Equipment and materials are recovered." % state.rescue_debt,16)
   button(panel_body,"Pay %d crowns / accept debt and extract" % rescue_cost(),func():perform_rescue("Emergency extraction"))
   button(panel_body,"Stay and find my own way out",close_panel)
  "ivar_welcome":ivar_welcome_panel()
  "briefing":briefing_panel()
  "commission":commission_panel()
  "charters":charters_panel()
  "pinewood":HoldForestry.panel(self)
  "gate":world_map_panel()
  "world_map":world_map_panel()
  "basin_map":world_map_panel(true)
  "hold_lift":surface.lift_panel()
  "storage":surface.chest_panel()
  "handworks":handworks.panel()
  "homestead":surface.home_panel()
  "house_build":surface.house.panel()
  "wayfinding":surface.guide_panel()
  "camp":camp_panel()
  "home":
   player_card(panel_body)
   button(panel_body,"Wardrobe & name - customize your character",func():open_creator(false))
   label(panel_body,"A narrow bed. A good lock. Room to dream of your own mountain.",17)
   label(panel_body,"Lord Eirik provides these quarters and access to the old gallery. Commission deliveries earn wages; surplus ore belongs to you. J opens your work journal.")
   button(panel_body,"Work journal & charter progress",func():open_panel("commission"))
   button(panel_body,"Save your progress",func():save_game();notify("Hold saved.");close_panel())
   button(panel_body,"Meet the hold - character portraits",func():open_panel("roster"))
   button(panel_body,"Read the prospector's handbook",func():open_panel("help"))
   button(panel_body,"Fill canteens at the courtyard pump (+6 water)",func():
    if state.count("water")>=30:notify("You already have 30 canteens. Plenty for now.")
    else:state.add("water",mini(6,30-state.count("water")));notify("Fresh water drawn from the hold's well.")
    refresh_panel())
   label(panel_body,"WASD moves. E opens nearby doors. Leave by the King’s Gate and follow the High Trail to Old Workings. F5 saves anywhere.",14,Color("97c6bb"))
  "tavern":
   compact_person("hedrik","Food, drink and company")
   button(panel_body,"Share a round - 8 crowns",func():
    if state.pay({},8):state.hospitality=360;state.add("food",2);sound.effect("coin");notify("Good company: 2 provisions. Orla will entertain a bargain for six minutes.");refresh_panel()
    else:notify("You need 8 crowns."))
   button(panel_body,"Buy trail provisions - 7 crowns / 3 meals",func():
    if state.pay({},7):state.add("food",3);notify("Three hearty meals packed.");refresh_panel()
    else:notify("You need 7 crowns."))
   button(panel_body,"Meet the hiring bench • six prospective crewmates",func():outpost_tab=2;open_panel("manage"))
   HoldCulture.panel(self)
  "roster":
   for key in HoldAppearance.NPC_NAMES:
    if key=="eirik" and HoldOnboarding.ensure(state).fresh and HoldOnboarding.stage(state)<4:continue
    character_card(panel_body,key,"A familiar face in Keldrath.")
   for key in HoldOutpost.candidate_ids(state):
    if not HoldAppearance.NPC_NAMES.has(key):character_card(panel_body,key,HoldOutpost.line(state,key))
   for i in 3:character_card(panel_body,"visitor_"+str(i),"Taking a turn through the hold.")
  "visitor":
   character_card(panel_body,visitor_key,HoldOutpost.line(state,visitor_key) if HoldOutpost.has_member(state,visitor_key) else visitor_quote())
   label(panel_body,("A member of your founding crew. " if state.outpost.get("crew",{}).has(visitor_key) else "A fellow dwarf of Keldrath. ")+"Track "+HoldCulture.words(state.npc(visitor_key)).possessive+" location whenever you want to find "+HoldCulture.words(state.npc(visitor_key)).object+" again.",14)
   button(panel_body,"Good fortune to you",close_panel)
  "claim_stories":HoldClaimStories.panel(self)
  "guidance":HoldOnboarding.journal(self)
  "lesson":HoldOnboarding.lesson_panel(self)
  "throne":HoldRoyalHall.panel(self)
  "training":
   lesson_id="training";HoldOnboarding.lesson_panel(self)
  "anniversary":HoldAnniversary.panel(self)
  "social":HoldCulture.panel(self)
  "market":market_panel()
  "forge":forge_panel()
  "research":research_panel()
  "inventory":inventory_panel()
  "manage":management_panel()
  "ship":ship_panel()
  "pause":
   var grid=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",12);grid.add_theme_constant_override("v_separation",12);panel_body.add_child(grid)
   for entry in [["Resume adventure",resume_adventure],["Save game",func():save_game();notify("Hold saved.")],["Sound & comfort",func():open_panel("settings")],["Controls & field guide",func():open_panel("help")],["Build status · WIP",func():open_panel("build_status")],["Save and return to title",func():save_game();show_title()],["Save and quit",func():save_game();shutdown()]]:
    var b=button(grid,entry[0],entry[1]);b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
   label(panel_body,"The world is paused. Take your time. Switching away from the game also pauses it; return when ready.",16,Color("b4c9c4"))
  "settings":settings_panel()
  "build_status":build_status_panel()
  "help":help_panel();button(panel_body,"Open field notebook [K]",func():open_panel("field_notes"))
  "victory":
   label(panel_body,"The First Fortune is yours.",23,Color("a8e0cc"))
   label(panel_body,"From a borrowed forge to a ship bearing your own rune. Below, the hold is already raising a toast. Above, the stars have never looked quite so close.",17)
   label(panel_body,"%d blocks mined by you and your crew. %d minutes building a future." % [state.mined,int(state.elapsed/60)],16,Color("e3ba79"))
   label(panel_body,"This is the end of the first playable milestone. You can keep mining, trading, and improving your hold.")
   wip_note(panel_body,"Interstellar travel & Great Works","Not implemented in this build. Launch completes the current chapter; it does not open another star system.")
   button(panel_body,"Return to Keldrath",close_panel)
  "save_slots":save_slots_panel()
  "new_confirm":
   label(panel_body,"Replace slot %d — %s? The other two fortunes are unaffected. This slot is replaced only when you finish creating your new character." % [state.save_slot,HoldState.slot_summary(state.save_slot).get("name","Unreadable save")],17)
   button(panel_body,"Create replacement for slot %d" % state.save_slot,func():open_creator(true))
   button(panel_body,"Keep my existing hold",close_panel)

 if id=="living":panel.set_deferred("size",Vector2(720,452))

func inventory_panel():
 var top=row(panel_body)
 label(top,"%d crowns  •  Carried supplies" % state.money,18,Color("edc98a"))
 small_button(top,"Show all resources" if inventory_owned_only else "Show carried resources",func():inventory_owned_only=not inventory_owned_only;refresh_panel())
 label(panel_body,"Your pack supplies crafting and trading. Chest contents stay where you put them; withdraw before use. Underground buckets and marked stockpiles remain separate.",16)
 var grid=GridContainer.new();grid.columns=2;grid.size_flags_horizontal=Control.SIZE_EXPAND_FILL;grid.add_theme_constant_override("h_separation",10);grid.add_theme_constant_override("v_separation",8);panel_body.add_child(grid)
 var count=0
 for k in HoldData.ITEMS:
  if inventory_owned_only and state.count(k)==0:continue
  count+=1
  var card=section(grid,"");card.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
  var r=row(card);HoldItemArt.icon(r,k);label(r,HoldData.ITEMS[k].name,16)
  var bind=OptionButton.new();bind.add_item("Pin to bar…")
  for slot in range(5,10):bind.add_item("Slot "+str((slot+1)%10))
  r.add_child(bind);bind.item_selected.connect(func(index):
   if index>0:hotbar.assign(k,index+4);bind.select(0))
  var amount=label(r,str(state.count(k)),18,Color("edc98a"));amount.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT;amount.size_flags_horizontal=0;amount.custom_minimum_size.x=38
 if count==0:label(panel_body,"Your pack is empty. Dig loose earth or stone to gather your first materials.",16)
 label(panel_body,"1 Pickaxe  •  2 Shovel  •  3 Axe  •  4 Hammer
5 Slagcaster (when unlocked) • 6–0 pinned supplies. Click a slot or press its number.
Pin carried resources using the selectors above; quantities always come from your pack.
Open Gear above to change weapons or armor.",16,Color("b4c9c4"))
func resume_adventure():
 if not menu_history.is_empty() and menu_history[-1].id=="ivar_welcome":back_panel()
 else:close_panel()
func apply_audio_settings():
 sound.volume(state.volume);sound.mix(state.music_volume,state.ambience_volume,state.effects_volume,state.footsteps_volume,state.dialogue_volume)
func settings_panel():
 label(panel_body,"Changes apply and save immediately. Set a slider to 0% to mute that category.",16)
 for setting in [["Master volume","volume"],["Music","music_volume"],["Environment","ambience_volume"],["Tools & combat","effects_volume"],["Footsteps","footsteps_volume"],["Dialogue","dialogue_volume"]]:
  var r=row(panel_body);var title=label(r,setting[0],16);title.custom_minimum_size.x=180
  var slider=HSlider.new();slider.min_value=0;slider.max_value=1;slider.step=.05;slider.value=state.get(setting[1]);slider.custom_minimum_size=Vector2(250,32);slider.size_flags_horizontal=Control.SIZE_EXPAND_FILL;r.add_child(slider)
  var value=label(r,"%d%%" % roundi(slider.value*100),16);value.custom_minimum_size.x=55;value.size_flags_horizontal=0
  slider.value_changed.connect(func(v):state.set(setting[1],v);value.text="%d%%" % roundi(v*100);apply_audio_settings();state.save_audio_settings())
 var samples=row(panel_body)
 small_button(samples,"Test pick",func():sound.effect("pick_real_0",-3))
 small_button(samples,"Test footsteps",func():sound.footstep("stone"))
 small_button(samples,"Reset audio defaults",func():
  for entry in [["volume",.6],["music_volume",.65],["ambience_volume",.8],["effects_volume",.9],["footsteps_volume",.8],["dialogue_volume",1.0]]:state.set(entry[0],entry[1])
  apply_audio_settings();state.save_audio_settings();refresh_panel())
 var check=CheckButton.new();check.text="Gentle mining camera shake";check.button_pressed=state.shake;panel_body.add_child(check);check.toggled.connect(func(v):state.shake=v)
 label(panel_body,"Turn shake off for a steadier view. Losing window focus always pauses the game.",16,Color("b4c9c4"))

func market_panel():
 HoldCulture.panel(self)
 compact_person("orla","A fair price is one we both complain about.")
 var tabs=row(panel_body)
 label(tabs,"%d crowns" % state.money,18,Color("edc98a"))
 for mode in ["sell","buy","contracts"]:
  var b=small_button(tabs,mode.capitalize(),func():trade_tab=mode;open_panel("market",false))
  if mode==trade_tab:b.modulate=Color("a7e2ce")
 if trade_tab!="contracts":
  label(panel_body,"Sell your surplus. Prices below are per item." if trade_tab=="sell" else "Buy supplies for your next expedition. Prices below are per item.",16,Color("b4c9c4"))
  var shown=0
  for k in ["stone","iron_ore","copper_ore","coal","wood","water","food","iron","copper","parts","crystal","assembly","ammo","scrap","shell"]:
   if trade_tab=="sell" and state.count(k)==0:continue
   shown+=1
   var r=row(panel_body);HoldItemArt.icon(r,k)
   label(r,"%s  •  %d owned" % [HoldData.ITEMS[k].name,state.count(k)],16)
   if trade_tab=="buy":
    var price=state.price(k,true);var b=button(r,"Buy 1 · %d crowns" % price,func():trade_item(k,true));b.disabled=state.money<price
    if b.disabled:b.tooltip_text="Need %d more crowns" % (price-state.money)
   else:
    button(r,"Sell 1 · %d crowns" % state.price(k,false),func():trade_item(k,false))
    button(r,"Sell up to 5",func():
     var sold=0
     for i in 5:
      if state.trade(k,false):sold+=1
      else:break
     sound.effect("coin");notify("Sold %d %s." % [sold,HoldData.ITEMS[k].name]);refresh_panel())
  if shown==0:label(panel_body,"Nothing to sell yet. Mine resources or gather timber, then return to Orla.",16)
  label(panel_body,"Local supply changes prices. Contracts and tavern hospitality can earn you better terms.",16,Color("b4c9c4"))
 else:
  var contract_cost={"stone":20,"wood":6} if state.contract%2==0 else {"iron_ore":12,"copper_ore":8}
  var reward=(100 if state.contract%2==0 else 150)+(10 if state.claim_id=="wayfarer" else 0)
  var card=section(panel_body,"Guaranteed freight contract • %d crowns" % reward)
  label(card,HoldData.cost_text(contract_cost)+"\n"+requirements(contract_cost),16)
  var b=button(card,"Deliver contract",func():
   if state.pay(contract_cost):state.money+=reward;state.contract+=1;sound.effect("coin");notify("Contract delivered. Orla now trusts you enough to bargain.");save_game();refresh_panel())
  b.disabled=not state.afford(contract_cost)
  label(panel_body,"Bargained terms active" if state.bargain>0 else "Complete a contract or share a round at the tavern to unlock better terms.",16)
  var bargain=button(panel_body,"Negotiate better prices",func():
   state.bargain=180 if state.hospitality>0 else 120;notify("Orla agrees to better terms for a short while.");refresh_panel())
  bargain.disabled=state.hospitality<=0 and state.contract<=0
func trade_item(k:String,buy:bool):
 if state.trade(k,buy):sound.effect("coin");refresh_panel()
 else:notify("You cannot afford that trade.")
func forge_panel():
 if zone=="claim" and state.camp_stage<2:
  label(panel_body,"Raise your workshop at the founding stones first. Keldrath's public forge remains available.",17);return
 compact_person("borin","Measure twice. Hit it until it agrees.")
 if state.opening<2:
  label(panel_body,"The lower hearth is cold. Deliver 8 coal to Ivar at the foreman's office; the first commission will relight it.",17)
  button(panel_body,"Open work journal",func():open_panel("commission"));return
 label(panel_body,"Jobs use materials now; finished items go straight into your carried supplies.",16,Color("b4c9c4"))
 var tabs=row(panel_body)
 for i in 4:
  var b=small_button(tabs,["Smelting","Crafting","Tools","Industry"][i],func():forge_tab=i;open_panel("forge",false));b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  if i==forge_tab:b.modulate=Color("a7e2ce")
 small_button(tabs,"Weapons & armor",func():open_panel("equipment"))
 if forge_tab==3:HoldIndustry.panel(self);return
 if not state.queue.is_empty():
  label(panel_body,"%d/12 JOBS  /  %s  /  %.0f sec" % [state.queue.size(),HoldData.RECIPES[state.queue[0].id].name,state.queue[0].left],16,Color("a6d7c4"))
  button(panel_body,"Refresh production status",refresh_panel)
 var recipe_order=["iron","copper","scrap_iron","shell_iron"] if forge_tab==0 else HoldData.RECIPES.keys()
 for k in recipe_order:
  if forge_tab==2 or (forge_tab==0 and k not in ["iron","copper","scrap_iron","shell_iron"]) or (forge_tab==1 and k in ["iron","copper","scrap_iron","shell_iron"]):continue
  var recipe=HoldData.RECIPES[k]
  var r=row(panel_body)
  var text=label(r,recipe.name+"\nInputs: "+HoldData.cost_text(recipe.cost)+"\nMakes: "+HoldData.cost_text(recipe.out)+" • %d sec" % recipe.time,16)
  text.tooltip_text="Outputs: "+HoldData.cost_text(recipe.out)
  var unlocked=recipe.tech=="" or state.tech.has(recipe.tech)
  var b=button(r,"Queue" if unlocked else "Research needed",func():
   if state.craft(k):sound.effect("build");refresh_panel()
   else:notify("Not enough materials, or queue is full."))
  b.disabled=not unlocked or not state.afford(recipe.cost) or state.queue.size()>=12
  var need=requirements(recipe.cost) if unlocked else "Research "+HoldData.RESEARCH[recipe.tech].name
  if need!="Ready":text.text+="\n"+need
  if state.queue.size()>=12:text.text+=" • Queue full"
  var bulk=button(r,"Up to 5",func():
   var done=0
   for i in 5:
    if state.craft(k):done+=1
   notify("Queued %d jobs." % done);refresh_panel())
  bulk.disabled=b.disabled
 if forge_tab==2 and state.tech.has("extraction") and not state.steel:
  var b=button(panel_body,"Forge steel pick - 5 iron + 2 timber",func():purchase({"iron":5,"wood":2},0,func():state.steel=true;notify("Tempered steel pick forged! Faster impacts; basalt is now breakable.")))
  b.disabled=not state.afford({"iron":5,"wood":2})
 if forge_tab==2 and state.tech.has("automation") and not state.automaton:
  var b=button(panel_body,"Build MOTE-1 automaton - 6 parts + 2 copper + 60 crowns",func():purchase({"parts":6,"copper":2},60,func():state.automaton=true;spawn_agents();notify("MOTE-1 is alive! Supply coal and assign seams with M.")))
  b.disabled=not state.afford({"parts":6,"copper":2},60)
 if forge_tab==2:
  label(panel_body,"Steel pick: "+("Owned" if state.steel else ("Ready to forge" if state.tech.has("extraction") else "Research Tempered steel"))+"\nMOTE-1: "+("Built" if state.automaton else ("Ready to build" if state.tech.has("automation") else "Research Clockwork industry")),16)
 label(panel_body,"Timber feeds provisions and construction. Water fills canteens and cools your future drive.",14,Color("9ac4ba"))
func research_panel():
 compact_person("eldric","Bring samples, funding and a little ambition.")
 var tabs=row(panel_body)
 for i in 3:
  var tab=small_button(tabs,["Mining & industry","Craftsmanship","Starflight"][i],func():research_tab=i;open_panel("research",false))
  tab.size_flags_horizontal=Control.SIZE_EXPAND_FILL;tab.toggle_mode=true;tab.button_pressed=research_tab==i
 var groups=[["extraction","metallurgy","automation","thermal"],["stoneworking","furnishings","fine_masonry"],["voidcraft"]]
 for id in groups[research_tab]:
  var r=HoldData.RESEARCH[id];var card=section(panel_body,"");var line=row(card)
  var text=VBoxContainer.new();text.size_flags_horizontal=Control.SIZE_EXPAND_FILL;line.add_child(text)
  label(text,r.name+(" · Complete" if state.tech.has(id) else ""),18,Color("9dd5c3"))
  label(text,r.desc,14)
  if not state.tech.has(id):
   label(text,HoldData.cost_text(r.cost)+" / %d crowns" % r.money,14,Color("dfc795"))
   var b=small_button(line,"Research",func():
    if state.research(id):sound.effect("crystal");notify("New capability unlocked: "+r.name);save_game();refresh_panel())
   b.disabled=not state.afford(r.cost,r.money) or (r.requires!="" and not state.tech.has(r.requires))
   b.tooltip_text=("First research "+HoldData.RESEARCH[r.requires].name) if r.requires!="" and not state.tech.has(r.requires) else requirements(r.cost,r.money)
   if b.disabled:label(text,b.tooltip_text,14,Color("b4c9c4"))
 small_button(panel_body,"Mountain charters and surveys",func():open_panel("charters"))
func management_panel():
 HoldOutpostUI.panel(self)
func ship_panel():
 wip_note(panel_body,"Beyond the first launch","Ship construction and launch are playable. Flying to other worlds and star systems is not implemented yet.")
 if state.claim_id=="" or state.camp_stage<3:
  label(panel_body,"First a home in the mountain. Then a place among the stars.",20,Color("dabc80"))
  label(panel_body,"Earn your charter, raise a workshop and commission its freight beacon. That establishes your first independent hold and opens the launchyard.",16)
  button(panel_body,"View founding progress",func():open_panel("camp"));return
 label(panel_body,"Your first starship. Small enough to build. Large enough to change everything.",17,Color("a7dac5"))
 label(panel_body,"Build at your launchyard with hammer [4] and a crew member assigned to Ship engineering. Each stage changes the ship on the pad.",16)
 label(panel_body,"Sealed engineering bay: 20% material savings applied below." if HoldIndustry.tier(state)>=2 else "Optional: commission a sealed engineering bay after the keel to save 20% of remaining ship materials.",16)
 label(panel_body,"Engineering staff: %d • M opens outpost assignments." % HoldOutpost.role_count(state,"engineer"),16)
 button(panel_body,"Manage outpost & crew",func():open_panel("manage"))
 var stages=["I. KEEL & LANDING FRAME","II. PRESSURE HULL","III. AETHER DRIVE"]
 for i in 3:
  label(panel_body,stages[i]+("  [BUILT]" if state.ship_stage>i else ""),18,Color("dfbb7d"))
  var s=HoldIndustry.ship_stage(state,i)
  label(panel_body,HoldData.cost_text(s.cost)+" / %d crowns" % s.money,14)
  if i==state.ship_stage:
   label(panel_body,requirements(s.cost,s.money),16)
   var at_yard=zone=="claim" and room_id=="" and absf(player.x-1780)<150 and tool==3 and not mining_gun.selected
   var b=button(panel_body,s.name if at_yard else "Visit launchyard with hammer [4]",func():
    if HoldOutpost.build_ship(state):build_anim=3;save_game();sound.effect("build");notify("Construction complete. Your ship takes shape.");refresh_panel())
   b.disabled=not at_yard or not state.afford(s.cost,s.money) or HoldOutpost.role_count(state,"engineer")==0
 if state.ship_stage==3 and zone=="claim" and absf(player.x-1780)<150:
  if state.launched:button(panel_body,"Launch again",begin_launch)
  else:button(panel_body,"Launch the First Fortune",begin_launch)
func begin_launch():
 close_panel();zone="claim" if state.active_site=="claim" else "hub";player=Vector2(1660,HUB_FLOOR);launching=true;launch_time=0;sound.effect("crystal");notify("The sky is no longer the limit.")
func help_panel():
 button(panel_body,"Craft workstations & stockpiles · Shift+B",func():open_panel("handworks"))
 small_button(panel_body,"Build status · WIP areas & planned systems",func():open_panel("build_status"))
 label(panel_body,"WASD / arrows walk through local zones. E enters doors, uses stairs and opens nearby chests. The King’s Gate connects Hearthward to the High Trail, Old Workings, Pinewood and your claim. G lists directions; I opens your pack. Your charter includes a cottage and chest. O on your claim opens home improvements.",16)
 var tabs=row(panel_body)
 for i in 4:
  var b=small_button(tabs,["First steps","Mining & building","Combat","Hold & saving"][i],func():help_tab=i;open_panel("help",false))
  b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  if i==help_tab:b.modulate=Color("a7e2ce")
 var topics=[
  [["Your first shift","Meet Ivar and introduce yourself to Borin, Orla and Hedrik. Leave Hearthward through the King’s Gate, follow the High Trail to Old Workings, and press E at the entrance. Mine 8 coal. Return to Ivar's office for 65 crowns; keep your surplus."],["Move & explore","WASD or arrows: walk in eight directions  •  E: interact
J: work journal  •  N: people and location tracking
I: resources  •  B: weapons and armor"],["What comes next?","Your first coal delivery earns an audience with the Lord. Return to Ivar for the lift commission and new lessons. Finish all three commissions to earn a reference, buy a mountain charter, and hire a founding crew as you build your workshop and freight beacon."]],
  [["Dig comfortably","WASD / arrows move in eight directions underground. Hold LMB with pick [1] for rock or shovel [2] for dirt. Hammer [4] exploits existing cracks; Shift + pick extracts ore selectively. Axe [3] is for Pinewood timber."],["Connect the depths","V opens stairs, timber ladder shafts and lamps. Build on clear floor; E descends, Shift + E ascends at that same location. Ladders carry Dwarfs and buckets; stairs also carry carts and machines. X surveys the layer below. T assigns crew depth. Return through the entrance to deliver cargo and leave."],["Build your hold","O opens Rooms, Furnish, Finishes and Folk. Designate excavated floor, then place furniture or apply finishes with LMB. Right mouse cancels. H manages hauling; C takes/parks the cart, U unloads and Shift + U loads piles. L opens the project ledger. Delivered supplies fund crafting and construction."]],
  [["Draw your weapon","F switches between your weapon and tools. Left mouse attacks; hold right mouse to guard. Press guard just before an impact to parry, then counterattack. Q dodges. There is no stamina."],["Prepare for an expedition","B opens gear. Borin introduces the starter axe and shield in his safe practice bay after the lift repair and return-route lesson. Hostile encounters unlock when you report your training. Forge upgrades at Borin's workbench; equipped armor changes your appearance. Guns consume cartridges."],["Choose your fights","Cleared encounters stay cleared. Enemies drop useful salvage. Rest outside the mine to heal. Defeat triggers paid rescue, so prepare an escape route."]],
  [["Craft, trade, grow","The forge reserves materials when you queue a job; completed items enter your pack automatically. Production continues while browsing ordinary menus. Sell surplus at Orla's exchange; contracts or tavern hospitality unlock bargaining."],["Save & pause","F5 saves. Escape opens pause or goes back through menus. Losing window focus pauses the world until you resume. Auto-save runs every 45 seconds and on major purchases or travel. Three separate save slots; a new fortune asks before replacing the selected slot."],["Comfort & controls","Use Sound & comfort from the pause menu for music, ambience, effects and camera shake. Tab moves focus; Enter activates a button. Given and family names are separate. There is no hunger timer: provisions fuel your worker."]]
 ]
 for entry in topics[help_tab]:
  var card=section(panel_body,entry[0]);label(card,entry[1],16)

func wip_note(parent,title:String,detail:String):
 var card=section(parent,"WIP · "+title)
 label(card,detail,16,Color("dfc7ac"))
func build_status_panel():
 label(panel_body,"WHAT IS PLAYABLE?",21,Color("a7dac5"))
 label(panel_body,"The opening, local expeditions, mining and building, equipment and combat, hold upgrades, founding a claim, managing a crew, and constructing and launching your first ship are playable.",16)
 label(panel_body,"WIP means not implemented in this build. A quest, research or material requirement means a playable feature that you can unlock.",16,Color("edc98a"))
 wip_note(panel_body,"Unopened hold wings","Doors marked WIP in Crownward and Forgeward have no playable interior. The named rooms, stairs and lift remain available, subject to their quest requirements.")
 wip_note(panel_body,"Planetary & galactic exploration","The Keldrath basin is the current travel area. Full planets, travel between star systems and Great Works are not implemented. Your first ship launch ends the current chapter.")
 wip_note(panel_body,"Marriage, family & succession","Given and family names, a founding identity, crewmates and the outpost chronicle are present. Player marriage, children and dynastic succession are not implemented.")

func shutdown():
 playing=false;close_panel()
 sound.stop_all()
 await get_tree().create_timer(.4).timeout
 get_tree().quit()
func _notification(what):
 if what==NOTIFICATION_WM_CLOSE_REQUEST:
  if playing:save_game()
  shutdown()

func smoke_boot():
 await get_tree().create_timer(.5).timeout
 for id in ["score_oath","score_mine","score_hold","amb_mine","stone_0","door","break_rock"]:
  if not sound.streams.has(id) or sound.streams[id]==null:push_error("Missing packaged audio: "+id);sound.stop_all();get_tree().quit(1);return
 for id in sound.streams:
  if sound.streams[id]==null or sound.streams[id].get_length()<=0:push_error("Invalid packaged audio: "+id);get_tree().quit(1);return
 print("PACK AUDIO: %d streams loaded" % sound.streams.size())
 print("PACK BOOT OK")
 shutdown()

func open_creator(new_fortune:bool):
 close_panel()
 if is_instance_valid(creator):creator.queue_free()
 creator=HoldCreator.new();creator.z_index=30;creator.creating=new_fortune
 creator.profile=(HoldAppearance.defaults() if new_fortune else state.appearance.duplicate(true))
 ui.add_child(creator)
 creator.accepted.connect(func(p:Dictionary):
  creator.queue_free();creator=null
  if new_fortune:start_game(false,p)
  else:state.appearance=p;save_game();notify("Your name and appearance are saved. Good fortune, "+p.name+"."))
 creator.cancelled.connect(func():creator.queue_free();creator=null)
func character_card(parent:Node,key:String,quote:String):
 var r=row(parent);r.add_theme_constant_override("separation",18)
 var portrait
 if key=="eirik":portrait=HoldRoyalHall.portrait()
 else:portrait=HoldPortrait.new();portrait.profile=state.npc(key)
 portrait.custom_minimum_size=Vector2(96,96);r.add_child(portrait)
 var details=VBoxContainer.new();details.size_flags_horizontal=Control.SIZE_EXPAND_FILL;details.add_theme_constant_override("separation",10);r.add_child(details)
 label(details,state.npc(key).name,20,Color("edc98a"))
 var status=HoldQuestMarkers.status(state,key)
 if status!="":label(details,HoldQuestMarkers.caption(status),14,Color("edc98a"))
 label(details,HoldOutpost.describe(state,key) if HoldOutpost.has_member(state,key) else HoldAppearance.NPC_ROLES.get(key,"A dwarf of Keldrath"),13,Color("93c8b8"))
 if panel_id!="roster":label(details,'"'+(HoldOutpost.line(state,key) if HoldOutpost.has_member(state,key) or HoldOutpost.TOWN.has(key) else quote)+'"',15)
 if HoldConversation.local(self,key):button(details,"Talk",func():HoldConversation.start(self,key))
 var r2=row(details)
 var preview:Control
 if key=="eirik":
  var royal=TextureRect.new();royal.texture=HoldRoyalHall.SPRITE;royal.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;royal.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;preview=royal
 else:
  var dwarf=HoldSpritePreview.new();dwarf.profile=state.npc(key);dwarf.motion="idle";preview=dwarf
 preview.custom_minimum_size=Vector2(54,54);r2.add_child(preview)
 label(r2,npc_where(key).label,14,Color("b0c2b5"))
 button(details,"Track location" if state.tracked_npc!=key else "Stop tracking",func():state.tracked_npc=key if state.tracked_npc!=key else "";save_game();close_panel())
func player_card(parent:Node):
 var r=row(parent)
 var portrait=HoldPortrait.new();portrait.profile=state.appearance;portrait.custom_minimum_size=Vector2(108,108);r.add_child(portrait)
 var body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;r.add_child(body)
 label(body,state.appearance.name,21,Color("edc98a"))
 label(body,"Keldrath employee" if state.claim_id=="" else "Freeholder of "+HoldOutpost.title(state),14,Color("9fcbbf"))
 label(body,str(state.appearance.first_name)+" "+str(state.appearance.family_name)+"\nYour story begins with you. C opens your wardrobe.",14)
func visitor_motion(i:int)->Dictionary:
 # Eight seconds still, a deliberate four-second walk, then pause and return.
 var phase=fposmod(clock+i*7.0,24.0)
 var base=[290.0,824.0,1620.0][i]
 var x=base;var moving=false;var facing=1
 if phase>=8 and phase<12:x+=30*(phase-8);moving=true
 elif phase>=12 and phase<20:x+=120;facing=-1
 elif phase>=20:x+=120-30*(phase-20);moving=true;facing=-1
 return {"p":Vector2(x,410),"walking":moving,"facing":facing}
func visitor_position(i:int)->Vector2:return visitor_motion(i).p
func visitor_quote()->String:
 var lines=["My grandmother braided a rune into every ribbon. Said a loose knot was an invitation to bad luck.","I came here with three crowns and a very good hammer. Still have the hammer.","Your ship will need a name worth singing, "+state.appearance.name+". A launch is a promise to return."]
 return lines[posmod(visitor_key.hash(),lines.size())]

func briefing_panel():
 commission_panel()
func accept_employment():
 if HoldOnboarding.ensure(state).fresh and HoldOnboarding.stage(state)<3:
  open_panel("commission");return
 if state.opening==0:state.opening=1;save_game();sound.effect("quest",-7)
 briefing_topic="";close_panel();open_panel("ivar_welcome")
 notify("IVAR: Eight coal, then my office. Keep the surplus. J opens your work journal.")
func ivar_welcome_panel():
 compact_person("ivar","Foreman of the lower works")
 button(panel_body,"Back to work",close_panel)
 label(panel_body,"Ivar's advice for the work ahead. J opens your current commissions and lessons." if HoldOnboarding.ensure(state).fresh else "Your first task: mine 8 coal, then return to Ivar’s office. J opens your work journal.",17,Color("edc98a"))
 label(panel_body,"Ivar’s advice",18)
 label(panel_body,"Mind your head. Gate was built for kings in their crowns. Somehow it’s the rest of us who keep hitting it.\n\nI’m Ivar. Foreman of the lower works.\n\nYou’ll have a room, a sound pick, and wages for what you bring up. Keep the stairs clear. Brace your workings. And if something down there starts glowing, fetch me before you hit it again.\n\nSee those lights along the vault? My grandfather helped lay the conduits. His grandfather carved the stone around them. Both swore the other had the easier trade.\n\nYou could make a good life here.\n\nBut if it’s a mountain of your own you’re after… well. Earn your charter. Find good folk. Give them a reason to stay.\n\nYour name isn’t carved above a gate yet.\n\nPlenty of stone left.\n\nCome on. Let’s get you started.",17)
func commission_panel():
 button(panel_body,"Hands of the Dwarf · workshop lesson",func():open_panel("handworks"))
 if state.claim_id!="":
  label(panel_body,"YOUR OWN HEARTH · Build, furnish and climb your house. O opens plans on your claim.",16)
  small_button(panel_body,"House-building lesson & first-season work",func():open_panel("guidance"))
 var q=HoldOnboarding.ensure(state);var nearby=HoldConversation.local(self,"ivar")
 if q.fresh and q.stage in [0,1,2,4,5]:
  if nearby:
   talk_id="ivar";talk_topic="";talk_line="";HoldConversation.panel(self)
  else:
   label(panel_body,"WORK JOURNAL",22,Color("edc98a"))
   label(panel_body,HoldOnboarding.primary(state),17)
   HoldConversation.choose(self,"Track "+state.npc("ivar" if q.stage!=4 else "eirik").first_name,func():state.tracked_npc="eirik" if q.stage==4 else "ivar";save_game();close_panel())
   HoldConversation.choose(self,"First season journal",func():open_panel("guidance"))
  return
 if nearby:HoldConversation.header(self,panel_body,"ivar",HoldCampaign.JOBS[state.opening-1].story if state.opening in [1,2,3] else "Your reference is signed. A sound beginning, and your own mountain to come.",true)
 else:label(panel_body,"WORK JOURNAL · IVAR",22,Color("edc98a"))
 if state.opening in [1,2,3]:
  var job=HoldCampaign.JOBS[state.opening-1]
  label(panel_body,job.name,21,Color("edc98a"))
  if not nearby:label(panel_body,job.story,16)
  label(panel_body,"Required: "+HoldData.cost_text(job.cost)+"  •  "+requirements(job.cost),16,Color("b6d8c9"))
  label(panel_body,"Wage: %d crowns. Surplus materials are yours to keep." % job.pay,16)
  HoldConversation.responses(self)
  var b=HoldConversation.choose(self,"Deliver the commission" if nearby else "Return to Ivar to deliver",func():
   if HoldConversation.local(self,"ivar") and state.finish_commission():
    save_game();sound.effect("quest",-7);HoldConversation.start(self,"ivar");talk_line=job.result;refresh_panel(),true)
  b.disabled=not nearby or not state.afford(job.cost)
 else:
  label(panel_body,"Your reference is signed. Review the mountain surveys when you are ready to choose a claim.",17)
  HoldConversation.responses(self)
  HoldConversation.choose(self,"Review mountain charters",func():open_panel("charters"))
 if not nearby:HoldConversation.choose(self,"Track Ivar",func():state.tracked_npc="ivar";save_game();close_panel())
 HoldConversation.choose(self,"First season journal",func():open_panel("guidance"))
 HoldConversation.return_choice(self,"ivar")
func gate_panel():
 label(panel_body,"Beyond these doors: the King's Road, old workings, and the mountains you have watched from the hold's high galleries.",18,Color("d6bc8b"))
 button(panel_body,"Explore Keldrath [G]",func():open_panel("world_map"))
 button(panel_body,"Review mountain charters",func():open_panel("charters"))
 label(panel_body,"Walk to Old Workings for coal, Pinewood for timber, or your chartered mountain. WASD / arrows move you across the basin; E enters the nearby landmark.",16)
 label(panel_body,"Travel is free. Your work in each mine is preserved. Keldrath remains open for trade, research and fellowship.",14,Color("a3c8bb"))
func charters_panel():
 if HoldOnboarding.ensure(state).fresh and HoldOnboarding.stage(state)<5:
  label(panel_body,"A charter requires a royal reference. Begin with Ivar and your first shift.",17);return
 label(panel_body,"THE VALLEY BELOW KELDRATH",20,Color("e7c389"))
 label(panel_body,"Three ridges, three different beginnings. Inspect their surveys before committing. Your choice is permanent for this save.",15)
 if state.opening<4:label(panel_body,"Lord Eirik's reference required: finish the three restoration commissions. You may survey now and buy later.",15,Color("d6aa88"))
 if state.claim_id!="":
  label(panel_body,"YOUR CHARTER: "+HoldCampaign.claim(state.claim_id).name.to_upper(),18,Color("a2d9bc"))
  button(panel_body,"Travel to your mountain",travel_claim)
 for c in HoldCampaign.CLAIMS:
  label(panel_body,c.name.to_upper()+" / %d CROWNS" % c.price,19,Color("e0c18a"))
  label(panel_body,c.desc,15);label(panel_body,c.bonus,14,Color("9ed1c2"))
  if state.claim_id=="":
   var b=button(panel_body,"Purchase "+c.name+" charter - %d crowns" % c.price,func():
    open_charter_confirmation(c))
   b.disabled=state.opening<4 or state.money<int(c.price)
 label(panel_body,"Your savings: %d crowns. All charters include permanent access to Keldrath's markets and public services." % state.money,14)
func open_charter_confirmation(c:Dictionary):
 open_panel("charters")
 for child in panel_body.get_children():panel_body.remove_child(child);child.queue_free()
 label(panel_body,"SIGN THE "+c.name.to_upper()+" CHARTER?",21,Color("e6bf80"))
 label(panel_body,c.desc,16)
 label(panel_body,"This spends %d crowns and fixes your mountain choice for this save. Remaining savings: %d." % [c.price,state.money-int(c.price)],16)
 button(panel_body,"Sign the charter",func():
  if state.buy_charter(c.id):
   save_game();travel_claim();open_panel("camp");sound.effect("crystal");notify("A mountain of your own. Your founding charter bears "+state.appearance.name+"."))
 button(panel_body,"Return to the surveys",func():open_panel("charters"))
func camp_panel():
 if state.claim_id=="":
  label(panel_body,"You have not purchased a mountain charter yet. Complete Ivar's commissions, then review mountain charters at the survey office.",17)
  button(panel_body,"Review mountain charters",func():open_panel("charters"));return
 label(panel_body,HoldOutpost.title(state).to_upper(),22,Color("e4bf80"))
 label(panel_body,HoldOutpost.next_step(state),16,Color("b4dfcf"))
 button(panel_body,"Name your outpost • manage crew • plan construction [M]",func():outpost_tab=0;open_panel("manage"))
 label(panel_body,"Chartered to "+str(state.appearance.first_name)+" "+str(state.appearance.family_name)+". This is your ground, your workshop, and the beginning of your own hold.",16)
 if state.camp_stage>=3:
  label(panel_body,"FIRST HOLD ESTABLISHED",21,Color("a4dec1"))
  label(panel_body,"The workshop stands. The freight beacon answers Keldrath. Your first independent operation is ready. Recruit your founding crew, expand production, and build the ship that will carry your fortune beyond this valley.",16)
  button(panel_body,"Continue building your future",close_panel)
  button(panel_body,"Review the future launchyard",func():open_panel("ship"));return
 var c=HoldCampaign.CAMP[state.camp_stage]
 label(panel_body,"FOUNDING WORK %d / 3: %s" % [state.camp_stage+1,c.name.to_upper()],18,Color("acd4c3"))
 for k in c.cost:label(panel_body,"%s: %d / %d" % [HoldData.ITEMS[k].name,state.count(k),c.cost[k]],15)
 label(panel_body,"Cost: %d crowns. Hammer (4) required at the founding stones." % c.money,15)
 var nearby=zone=="claim" and player.distance_to(Vector2(970,690))<100 and tool==3 and not mining_gun.selected
 var b=button(panel_body,"Build "+c.name.to_lower() if nearby else "Visit founding stones with hammer (4)",func():
  if state.build_camp():save_game();sound.effect("build");open_panel("camp");notify("Your hold takes shape: "+c.name+"."))
 b.disabled=not nearby or not state.afford(c.cost,int(c.money))
 label(panel_body,"Mine your own seams. Cut marked firs in Pinewood. Keldrath's forge and survey office remain available while you build.",14)
func flush_pickups():
 if zone=="mine":deep.depart()
 remember_agents()
 for d in drops:state.add(d.item,d.count)
 drops.clear()
func travel_hold():
 surface.enter("hearthward");return
 flush_pickups();state.switch_site("hold",geo);zone="hub";player=Vector2(1940,HUB_FLOOR);finish_travel()
func travel_road():
 surface.enter("pinewood");return
 flush_pickups();state.switch_site("hold",geo);zone="road";player=Vector2(150,HUB_FLOOR);finish_travel()
func travel_claim():
 surface.enter("claim");return
 if state.claim_id=="":open_panel("charters");return
 flush_pickups();state.switch_site("claim",geo);zone="claim";player=Vector2(150,HUB_FLOOR);finish_travel()
func finish_travel():
 ensure_mine_mouth()
 room_id="";swing=0;impact_pause=0;sound.set_context(zone);begin_transition("PINEWOOD" if zone=="road" else ("YOUR MOUNTAIN" if zone=="claim" else "KELDRATH"))
 velocity=Vector2.ZERO;camera=Vector2(clampf(player.x-480,0,1040),0)
 particles.clear();popups.clear();close_panel();spawn_agents();save_game()
 notify("PINEWOOD: E at the field board explains cutting and timber. 3: axe. G: trail directions." if zone=="road" else ("Welcome to "+HoldCampaign.claim(state.claim_id).name+". Founding stones are east." if zone=="claim" else "Keldrath's gates stand open to you."))

func character_tint(p:Vector2)->Color:
 if room_id!="":return Color("ffe0b7") if room_id in ["home","forge","tavern"] else Color("d8e1d6")
 if zone=="mine":return Color("c9d6d6").lerp(Color("ffe0ac"),.25)
 var warm=0.0
 if zone=="hub":
  for x in [410.0,685.0,970.0]:
   if x!=970.0 or state.opening>=2:warm=maxf(warm,clampf(1-absf(p.x-x)/120,0,1))
 elif zone=="claim" and state.camp_stage>=2:warm=clampf(1-absf(p.x-970)/120,0,1)
 return Color("d6e1df").lerp(Color("ffe4bd"),warm*.72)

func begin_transition(title:String):
 transition_left=.65;transition_shade.visible=true;transition_shade.modulate.a=1;transition_label.text=title
 swing=0;impact_pause=0;impact_flashes.clear()
func enter_room(id:String):
 if id!="training" and surface:
  surface.enter("home:"+state.claim_id if id=="home" and state.active_site=="claim" else "room:"+id);return
 if not HoldInteriors.ROOMS.has(id):return
 if id==room_id:close_panel();return
 if id=="throne" and HoldOnboarding.ensure(state).fresh and HoldOnboarding.stage(state)<4:notify("The steward requires Ivar's reference from your first shift.");return
 if id=="training" and not HoldOnboarding.ensure(state).accepted.has("training"):notify("Ask Borin about Keep your feet before using the practice bay.");return
 var previous_room=room_id
 if previous_room=="training":state.resident_visits.erase("borin")
 if id=="training":state.resident_visits.borin="training"
 if previous_room=="":hold_room_return=false
 sound.effect("door_real",-8)
 mining_gun.selected=false;mining_gun.flash=0;mining_gun.braced=0
 flush_pickups();particles.clear();popups.clear()
 if previous_room=="":exterior_position=player
 room_return=previous_room if id in ["throne","training"] else ""
 room_id=id;player=Vector2(213,HUB_FLOOR);camera=Vector2.ZERO;velocity=Vector2.ZERO
 if id=="training":player.x=550;combat.map_key="";combat.armed=true;combat.reset_actions();face=1
 close_panel();sound.set_context("forge_cold" if id=="forge" and state.opening<2 and state.active_site=="hold" else id);begin_transition(str(HoldInteriors.ROOMS[id].name).to_upper())
 notify(HoldInteriors.ROOMS[id].detail)
func leave_room():
 if surface and surface.active():surface.leave();return
 if room_id=="training":surface.enter("room:forge");return
 if room_id=="":return
 if room_id=="training":state.resident_visits.erase("borin")
 if room_id=="throne":
  # Also repair old saves that still remember the removed office shortcut.
  room_return="";hold_room_return=true
  var threshold=HoldFloorPlan.door(1)+Vector2(0,22)
  state.hold_travel={"active":false,"return":true,"at":1,"version":3,"floor_x":threshold.x,"floor_y":threshold.y}
 if hold_room_return and room_return=="":
  sound.effect("door_close_real",-8);room_id="";hold_room_return=false
  player=exterior_position;velocity=Vector2.ZERO;grounded=true
  state.hold_travel.active=true
  close_panel();open_panel("world_map");save_game();return
 if room_return!="":
  var back=room_return;room_return="";room_id=back;player=Vector2(805,410);velocity=Vector2.ZERO;combat.map_key="";combat.enemies.clear();combat.armed=false;combat.reset_actions();close_panel();sound.set_context(back);begin_transition(HoldInteriors.ROOMS[back].name);save_game();return
 sound.effect("door_close_real",-8)
 room_id="";player=exterior_position;camera=Vector2(clampf(player.x-480,0,1040),0);velocity=Vector2.ZERO
 close_panel();sound.set_context(zone);begin_transition("KELDRATH" if zone=="hub" else "YOUR HOLD");save_game()

func character_scale()->float:return .85 if surface and surface.active() else (1.5 if room_id!="" and room_id!="training" else 1.0)

func continuous_journey()->bool:
 return false # Expeditions are connected by the map table, not hidden scene seams.
func ensure_mine_mouth():
 if state.active_site!="hold":return
 # The old isolated-level border formed a visible vertical strip through the
 # entrance arch and blocked jumps across the seam. Continue the gallery air
 # above ground and natural rock below; the out-of-map wall still bounds digging.
 for y in range(0,Geology.H-4):
  for x in 4:
   if geo.at(x,y)==8:
    geo.cells[y*Geology.W+x]=0 if y<56 else (geo.at(4,y) if geo.at(4,y) not in [0,8] else 2)
    geo.redraw_all=true
func cross_journey(next:String,delta:float):
 flush_pickups();particles.clear();popups.clear();impact_flashes.clear()
 zone=next;player.x+=delta;camera.x+=delta
 swing=0;impact_pause=0;step_distance=0
 sound.set_context(zone);autosave=maxf(autosave,43.0)
 if next=="approach" and delta<0:notify("Forge warmth gives way to mountain air. The lower workings lie along the trail.")
func advance_journey():
 if not continuous_journey():return
 if zone=="hub" and player.x>=2000:
  if state.opening==0:player.x=1990;velocity.x=0;notify("Speak with the foreman before beginning your first shift.")
  else:cross_journey("approach",-2000)
 elif zone=="approach":
  if player.x<=0 and velocity.x<0:cross_journey("hub",2000)
  elif player.x>=2000:ensure_mine_mouth();cross_journey("mine",-2000)
 elif zone=="mine" and player.x<=0 and velocity.x<0 and player.y<=410:cross_journey("approach",2000)
func draw_journey_world(offset:Vector2):
 var origin=JOURNEY.offset(zone)
 var original_camera=camera
 for segment in ["hub","approach","mine"]:
  var shift=JOURNEY.offset(segment)-origin
  var width=Geology.W*Geology.TILE if segment=="mine" else 2000
  if shift+width<camera.x or shift>camera.x+960:continue
  draw_set_transform(offset+Vector2(shift,0));A.draw_offset=offset+Vector2(shift,0)
  if segment=="hub":
   draw_hub()

  elif segment=="approach":JOURNEY.approach(self,clock)
  else:
   camera=original_camera-Vector2(shift,0);draw_mine();camera=original_camera
 draw_set_transform(offset);A.draw_offset=offset

func npc_where(key:String)->Dictionary:
 HoldOutpost.ensure(state)
 if HoldOutpost.has_member(state,key):
  if not state.outpost.crew.has(key):return {"zone":"hub","p":Vector2(410,410),"label":"Keldrath — Copper Kettle hiring bench"}
  var role=state.outpost.crew[key].role
  if role=="miner":
   for agent in agents:
    if agent.get("id","")==key:return {"zone":"mine" if state.active_site=="claim" else "claim_mine","p":agent.p,"label":HoldOutpost.title(state)+" — mine crew"}
  return {"zone":"claim" if role!="miner" else "claim_mine","p":HoldOutpostUI.position(state,key),"label":HoldOutpost.title(state)+" — "+HoldOutpost.ROLES[role]}
 if key.begins_with("visitor_"):return {"zone":"hub","p":visitor_position(clampi(int(key.trim_prefix("visitor_")),0,2)),"label":"Keldrath — walking the main concourse"}
 if key=="brann" and state.worker:
  if state.active_site=="claim":
   for agent in agents:
    if agent.type=="worker":return {"zone":"mine","p":agent.p,"label":"Your claim mine — working with the crew"}
  return {"zone":"claim_mine","p":Vector2(150,370),"label":"Your claim mine — crew assignment"}
 if state.resident_visits.has(key):
  var room=state.resident_visits[key]
  return {"zone":"hub","p":Vector2(970 if room=="training" else 1205,410),"label":"Keldrath / Inside "+HoldInteriors.ROOMS[room].name}
 var place=HoldNpcPresence.HOMES.get(key,{"x":410,"label":"Inside the Copper Kettle"})
 return {"zone":"hub","p":Vector2(place.x,410),"label":"Keldrath / "+place.label}
func draw_tracking():
 if state.tracked_npc=="":return
 var target=npc_where(state.tracked_npc);var text=state.npc(state.tracked_npc).name+" — "+target.label
 if room_id!="":
  if HoldOnboarding.local(self,state.tracked_npc):text=state.npc(state.tracked_npc).first_name+" is here. E: speak near the desk."
  else:text="Leave this building to follow "+state.npc(state.tracked_npc).name
 elif target.zone==zone:
  var delta=target.p-player;text=("← " if delta.x<0 else "→ ")+state.npc(state.tracked_npc).name+" · "+str(int(absf(delta.x)/7))+" paces"
  var marker=target.p-camera+Vector2(0,-92);marker.x=clampf(marker.x,25,935);marker.y=clampf(marker.y,150,420)
  A.poly(self,[marker+Vector2(-6,-8),marker+Vector2(6,-8),marker],"d6c28c")
 elif target.zone=="hub" and zone in ["mine","approach"]:text="Return to the mine entrance · "+state.npc(state.tracked_npc).name
 A.rect(self,18,111,680,24,Color(.035,.08,.12,.88));A.text(self,Vector2(25,128),text,14,Color("e2cfa1"))

func rescue_cost()->int:return maxi(25,int(ceil(state.money*.2)))
func perform_rescue(reason:String):
 var fee=rescue_cost();var paid=mini(state.money,fee);state.money-=paid;state.rescue_debt+=fee-paid
 flush_pickups();close_panel();player=Vector2(150,370);velocity=Vector2.ZERO;state.combat.health=65.0
 combat.reset_actions();combat.invulnerable=3;construction.selected=""
 if zone=="mine":deep.enter()
 notify(reason+": %d crowns charged. Dig or build your way back next time." % fee);save_game()

func _exit_tree():
 if combat:combat.g=null
 if construction:construction.g=null
 if deep:deep.g=null

func can_region_travel()->bool:
 if room_id!="" or state.opening==0:return false
 if zone=="mine":deep.ensure();return deep.world.entrance(player)
 return grounded and zone in ["hub","approach","road","claim"]
func region_travel_hint()->String:
 if state.opening==0:return "Finish your introductions to Borin, Orla and Hedrik first. J lists who remains."
 if room_id!="":return "Leave the building by its left exit, then press G outside to set out."
 if zone=="mine":return "Follow stairs up (Shift+E) to the Lamplight entrance before travelling. V carves connected stairs."
 if not grounded:return "Land on solid ground before setting out."
 return "Step onto the surface to begin regional travel."
func enter_hold_destination(id:String):
 close_panel()
 zone="hub";grounded=true;velocity=Vector2.ZERO
 if id=="concourse":
  var return_x=float(state.hold_travel.get("concourse_x",535))
  state.hold_travel={};player=Vector2(return_x,HUB_FLOOR);camera=Vector2(maxf(0,return_x-480),0);face=1
  sound.set_context("hub");save_game();return
 var exterior=id
 if id=="throne":exterior="commission"
 if id=="training":exterior="forge"
 for station in STATIONS:
  if station.panel==exterior:player=Vector2(station.x,HUB_FLOOR)
 enter_room(id)
 hold_room_return=room_id==id
 save_game()
func world_map_panel(_basin:bool=false):
 surface.guide_panel()
func arrive_region(destination:String):
 if destination=="workings":surface.enter("trail",Vector2(950,345));surface.action("mine");return
 surface.enter({"hold":"hearthward","forest":"pinewood","trail":"trail"}.get(destination,"claim"));return
 if not can_region_travel():notify(region_travel_hint());return
 if destination in ["old_delving","copper_ridge","wayfarer"]:
  if state.claim_id==destination:travel_claim()
  return
 flush_pickups();state.switch_site("hold",geo)
 zone={"hold":"hub","trail":"approach","workings":"mine","forest":"road"}.get(destination,"hub")
 player={"hold":Vector2(1780,HUB_FLOOR),"trail":Vector2(1000,410),"workings":Vector2(95,392),"forest":Vector2(265,HUB_FLOOR)}[destination]
 room_id="";velocity=Vector2.ZERO;grounded=true;gait_clock=0;walking_pose=false;swing=0
 ensure_mine_mouth();camera=Vector2(player.x-480,player.y-360) if continuous_journey() else Vector2(clampf(player.x-480,0,1040),0)
 if zone=="mine":deep.enter()
 close_panel();sound.set_context(zone);particles.clear();popups.clear();spawn_agents();save_game()
 var arrival_hints={"forest":"PINEWOOD: E at the field board explains cutting and timber. 3: axe. G: trail directions.","workings":"DEEPWORKS: WASD move. Hold LMB to dig. V carves stairs; E down / Shift+E up. X surveys below. E at the entrance returns home.","hold":"KELDRATH: Walk the galleries; E uses stairs, lift and doors. G lists directions. E enters doors. J shows your work; N tracks people.","trail":"HIGH TRAIL: Walk north to Old Workings, south to Pinewood or east to your claim. E uses each entrance; G lists directions."}
 notify(arrival_hints.get(destination,"G lists directions; walk to a doorway and press E."))


func save_slots_panel():
 label(panel_body,"Separate characters, mountains and progress. Autosave stays in the slot you choose.",16)
 for slot in range(1,4):
  var summary=HoldState.slot_summary(slot)
  var box=section(panel_body,"")
  var line=row(box)
  var details=VBoxContainer.new();details.size_flags_horizontal=Control.SIZE_EXPAND_FILL;line.add_child(details)
  label(details,"SLOT %d  —  %s" % [slot,summary.get("name","Unreadable save" if summary.exists else "Empty")],18,Color("edc98a"))
  if summary.get("valid",false):
   var places={"hub":"Keldrath","mine":"Underground","approach":"Mountain trail","road":"Pinewood","claim":"Your claim"}
   label(details,"%s  •  %d min  •  %d crowns" % [places.get(summary.zone,summary.zone),summary.minutes,summary.money],16)
  else:label(details,"Begin a separate story here.",16)
  var actions=row(line)
  if summary.get("valid",false):button(actions,"Continue",func():state.save_slot=slot;start_game(true))
  button(actions,"New fortune" if not summary.exists else "Replace this fortune…",func():
   state.save_slot=slot
   if summary.exists:open_panel("new_confirm")
   else:open_creator(true))


func reveal_discoveries():
 for deposit in geo.mountain.get("geodes",[]):
  if deposit.get("seen",false):continue
  var center=Vector2(deposit.x,deposit.y)*Geology.TILE
  if player.distance_to(center)>150:continue
  var exposed=false
  for y in range(int(deposit.y)-int(deposit.r),int(deposit.y)+int(deposit.r)+1):
   for x in range(int(deposit.x)-int(deposit.r),int(deposit.x)+int(deposit.r)+1):
    var c=Vector2i(x,y)
    if geo.at(x,y)==6 and geo.exposed(c) and geo.visible_from(player+Vector2(0,-29),c):exposed=true;break
   if exposed:break
  if exposed:
   deposit.seen=true;state.money+=20
   popups.append({"p":center,"text":"A SEALED AETHER GEODE • +20 survey crowns","life":3.0})
   notify("An intact geode! Shift + pick preserves more crystal. Follow the pale mineral seam.")
