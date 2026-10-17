class_name HoldRegionMap
extends Node2D
# Regional movement owns its own coordinates. Local terrain remains saved at its
# entrance; switching scale never regenerates it. Future ship navigation can use
# the same address + persistent-location contract with a different controller.
const ATLAS=preload("res://assets/overworld-v26/scenery.png")
const MEADOW=preload("res://assets/overworld-v26/meadow.png")
const SURVEY_SCALE=.245
const SURVEY_ORIGIN=Vector2(186,80)
static var ground_cache:Dictionary={}
const WORLD=Vector2(2400,1500)
const VIEW=Vector2(960,540)
const SPEED=160.0
var g
var marker=Vector2.ZERO
var camera=Vector2.ZERO
var clock=0.0
var gait=0.0
var facing=1
var walking=false
var survey=false
var paused=false
var overview=false
var nearest=""
var selected=""
var save_clock=0.0
var foot_clock=0.0
var scenery:Array=[]
var roads:Array=[]
var ground:ImageTexture
var info:Label
var enter_button:Button
var mode_button:Button
var pause_button:Button
var quit_button:Button
var nodes={
 "hold":{"p":Vector2(300,680),"name":"Keldrath","art":3,"width":300.0,"detail":"Warm hearths, the forge and Ivar’s commissions."},
 "trail":{"p":Vector2(930,650),"name":"High Trail","art":6,"width":115.0,"detail":"A sheltered mountain lookout. Return to the basin map to choose your next stop."},
 "workings":{"p":Vector2(1300,475),"name":"Old Workings","art":4,"width":185.0,"detail":"Your first coal expedition. Every cut remains yours."},
 "forest":{"p":Vector2(335,1160),"name":"Pinewood","art":5,"width":180.0,"detail":"Fell marked firs and chop fallen logs with axe [3]. Timber for ladders, supports and your claim."},
 "old_delving":{"p":Vector2(1730,355),"name":"Old Delving","art":4,"width":155.0,"detail":"Iron workings. Purchase its charter in Keldrath."},
 "copper_ridge":{"p":Vector2(2080,900),"name":"Copper Ridge","art":4,"width":175.0,"detail":"Copper-bearing slopes. A charter opens this claim."},
 "wayfarer":{"p":Vector2(1380,1240),"name":"Wayfarer’s Rise","art":7,"width":180.0,"detail":"A southern concession beside the caravan road."}}
func _init(game):g=game
func current_node()->String:
 if g.state.active_site=="claim":return g.state.claim_id if nodes.has(g.state.claim_id) else "old_delving"
 return {"hub":"hold","approach":"trail","mine":"workings","road":"forest"}.get(g.zone,"hold")
func _ready():
 if nodes.has(g.state.claim_id):nodes[g.state.claim_id].name=HoldOutpost.title(g.state)
 survey=not g.can_region_travel() and not g.state.region_travel.get("active",false)
 marker=nodes[current_node()].p+Vector2(0,30)
 if g.state.region_travel.get("active",false):marker=Vector2(g.state.region_travel.get("x",marker.x),g.state.region_travel.get("y",marker.y))
 overview=survey
 build_world();camera=(marker-VIEW*.5).clamp(Vector2.ZERO,WORLD-VIEW)
 create_ui();update_nearest();remember();queue_redraw()
 if not survey:g.sound.set_context("road")
func create_ui():
 var header=Panel.new();header.position=Vector2(12,12);header.size=Vector2(470,57);add_child(header)
 var title=Label.new();title.text="KELDRATH BASIN";title.position=Vector2(25,17);title.add_theme_font_size_override("font_size",22);title.modulate=Color("f0d49b");add_child(title)
 var sub=Label.new();sub.text="G: change view    Esc: close survey" if survey else "WASD / arrows: walk    E: enter    G: survey    Esc: pause";sub.position=Vector2(25,45);sub.add_theme_font_size_override("font_size",13);add_child(sub)
 mode_button=g.small_button(self,("Close-up view" if survey else "Walk view") if overview else "Survey [G]",toggle_view);mode_button.position=Vector2(690,15);mode_button.size=Vector2(130,35)
 pause_button=g.small_button(self,"Close" if survey else "Pause",toggle_pause);pause_button.position=Vector2(830,15);pause_button.size=Vector2(115,35)
 var bottom=Panel.new();bottom.position=Vector2(12,455);bottom.size=Vector2(936,73);add_child(bottom)
 info=Label.new();info.position=Vector2(26,465);info.size=Vector2(680,56);info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;info.add_theme_font_size_override("font_size",17);add_child(info)
 enter_button=g.small_button(self,"Enter [E]",enter_location);enter_button.position=Vector2(755,470);enter_button.size=Vector2(175,40)
 quit_button=g.small_button(self,"Save & title",func():remember();g.save_game();g.show_title());quit_button.position=Vector2(405,265);quit_button.size=Vector2(150,45);quit_button.visible=false
func build_world():
 roads=[PackedVector2Array([nodes.hold.p,Vector2(450,740),Vector2(650,740),Vector2(790,700),nodes.trail.p]),PackedVector2Array([nodes.trail.p,Vector2(1080,580),nodes.workings.p,Vector2(1490,420),nodes.old_delving.p]),PackedVector2Array([nodes.hold.p,Vector2(280,840),Vector2(305,1010),nodes.forest.p]),PackedVector2Array([nodes.trail.p,Vector2(1050,850),Vector2(1160,1070),nodes.wayfarer.p]),PackedVector2Array([nodes.wayfarer.p,Vector2(1690,1180),Vector2(1900,1080),nodes.copper_ridge.p]),PackedVector2Array([nodes.old_delving.p,Vector2(1890,510),Vector2(2020,690),nodes.copper_ridge.p])]
 var rng=RandomNumberGenerator.new();rng.seed=HoldWorldStyle.address_seed(g.state.seed_value,0,Vector2i.ZERO,26)
 if ground_cache.has(g.state.seed_value):ground=ground_cache[g.state.seed_value]
 else:
  var img=Image.create(800,500,false,Image.FORMAT_RGBA8)
  var noise=FastNoiseLite.new();noise.seed=g.state.seed_value;noise.frequency=.012
  for y in 500:
   for x in 800:
    var p=Vector2(x*3,y*3);var v=noise.get_noise_2d(p.x,p.y)*.5+.5
    var c=Color.TRANSPARENT
    var grain=HoldTerrainView.grain(x,y)
    var distance=road_distance(p)
    if distance<23:
     var soil=Color("6e6346").lerp(Color("aa9871"),grain*.5+v*.3)
     var edge=1-smoothstep(12+grain*4,23,distance)
     c=soil;c.a=edge
    var water=absf(p.x-river_x(p.y))
    if water<52:
     var bank=Color("68775a").lerp(Color("a5a179"),grain*.4)
     c=bank;c.a=1-smoothstep(42+grain*3,52,water)
    if water<38:
     var blue=Color("28535d").lerp(Color("508982"),v*.5+grain*.18)
     c=c.lerp(blue,1-smoothstep(31,38,water));c.a=1
    img.set_pixel(x,y,c)
  ground=ImageTexture.create_from_image(img)
  if ground_cache.size()>2:ground_cache.clear()
  ground_cache[g.state.seed_value]=ground
 # Authored regional topology; seeded dressing stays clear of traversable roads.
 for i in 20:
  var p=Vector2(100+i*123,210+sin(i*.8)*75)
  var width=rng.randf_range(280,440)
  if scenery_clear_of_river(p,width):scenery.append({"p":p,"art":i%2,"width":width,"radius":58.0})
 for i in 145:
  var p=Vector2(rng.randf_range(65,2320),rng.randf_range(300,1450))
  var width=rng.randf_range(90,165)
  if road_distance(p)<100 or near_location(p,150) or not scenery_clear_of_river(p,width):continue
  scenery.append({"p":p,"art":2 if i%6 else 1,"width":width,"radius":22.0})
 for id in nodes:
  if id in ["hold","trail","forest","workings","copper_ridge","old_delving","wayfarer"]:
   scenery.append({"p":nodes[id].p+Vector2(-65,36),"detail":"waystone","width":35.0,"radius":10.0})
   if id in ["workings","forest","old_delving","copper_ridge"]:scenery.append({"p":nodes[id].p+Vector2(65,5),"detail":"cache","width":70.0,"radius":18.0})
 for id in nodes:scenery.append({"p":nodes[id].p,"art":nodes[id].art,"width":nodes[id].width,"radius":32.0,"site":id})
 scenery.sort_custom(func(a,b):return a.p.y<b.p.y)
func near_location(p:Vector2,r:float)->bool:
 for id in nodes:
  if p.distance_to(nodes[id].p)<r:return true
 return false
func scenery_clear_of_river(p:Vector2,width:float)->bool:
 # Reserve the whole rendered footprint, including roots and curved banks.
 for y in range(int(p.y-width*.91),int(p.y+width*.09)+5,4):
  if absf(p.x-river_x(y))<width*.5+60:return false
 return true
func river_x(y:float)->float:return 540+sin(y*.005)*50
func road_distance(p:Vector2)->float:
 var best=INF
 for road in roads:
  for i in range(road.size()-1):best=minf(best,p.distance_to(Geometry2D.get_closest_point_to_segment(p,road[i],road[i+1])))
 return best
func walkable(p:Vector2)->bool:
 if p.x<35 or p.y<230 or p.x>WORLD.x-35 or p.y>WORLD.y-35:return false
 if absf(p.x-river_x(p.y))<40 and absf(p.y-738)>8:return false
 if road_distance(p)<30:return true
 for obj in scenery:
  if p.distance_to(obj.p-Vector2(0,24))<float(obj.radius):return false
 return true
func move_by(delta:Vector2):
 # Small swept steps keep thin banks and tree trunks solid at low framerates.
 var steps=maxi(1,int(ceil(delta.length()/5)))
 var step=delta/steps
 for i in steps:
  if walkable(marker+Vector2(step.x,0)):marker.x+=step.x
  if walkable(marker+Vector2(0,step.y)):marker.y+=step.y
func handle_input(e:InputEvent):
 if not e is InputEventKey or not e.pressed or e.echo:return
 if e.keycode in [KEY_ESCAPE]:toggle_pause()
 elif e.keycode==KEY_G:toggle_view()
 elif e.keycode==KEY_E and not paused:enter_location()
 elif e.keycode==KEY_F5 and not survey:remember();g.save_game()
func toggle_view():
 overview=not overview;mode_button.text=("Close-up view" if survey else "Walk view") if overview else "Survey [G]";queue_redraw()
func toggle_pause():
 if survey:g.close_panel();return
 paused=not paused;pause_button.text="Resume" if paused else "Pause";quit_button.visible=paused;queue_redraw()
func _process(dt):
 clock+=dt
 var direction=Input.get_vector("left","right","up","down") if not paused and not survey else Vector2.ZERO
 var before=marker
 move_by(direction*SPEED*minf(dt,.05))
 walking=marker.distance_to(before)>.01
 if walking:
  gait+=dt
  if absf(direction.x)>.1:facing=1 if direction.x>0 else -1
  foot_clock+=dt
  if foot_clock>.34:g.sound.footstep("grass");foot_clock=0
  g.state.elapsed+=dt
 else:foot_clock=0
 camera=camera.lerp((marker-VIEW*.5).clamp(Vector2.ZERO,WORLD-VIEW),1-exp(-dt*8))
 update_nearest();remember()
 if not survey:
  save_clock+=dt
  if save_clock>30:g.save_game();save_clock=0
 queue_redraw()
func remember():
 if not survey:g.state.region_travel={"active":true,"x":marker.x,"y":marker.y,"address":{"galaxy":g.state.seed_value,"planet":0,"region_x":0,"region_y":0,"version":1}}
func update_nearest():
 nearest="";var distance=80.0
 for id in nodes:
  var d=marker.distance_to(nodes[id].p+Vector2(0,25))
  if d<distance:distance=d;nearest=id
 if not is_instance_valid(info):return
 if survey:
  info.text="SURVEY ONLY: "+g.region_travel_hint();enter_button.disabled=true;return
 var locked=nearest in ["old_delving","copper_ridge","wayfarer"] and g.state.claim_id!=nearest
 enter_button.disabled=nearest=="" or locked or paused
 enter_button.text="Charter required" if locked else "Enter [E]"
 if paused:info.text="Journey paused. Your position is saved with this fortune."
 elif nearest!="":info.text=nodes[nearest].name+"\n"+nodes[nearest].detail
 else:info.text="On the road • Explore the valley and approach a landmark to enter.\nPinewood lies southwest; the Old Workings are in the northern foothills."
func enter_location():
 if survey or paused or nearest=="":return
 if nearest in ["old_delving","copper_ridge","wayfarer"] and g.state.claim_id!=nearest:return
 var destination=nearest
 g.grounded=true;g.state.region_travel={};g.arrive_region(destination)
func sprite(obj:Dictionary):
 if obj.has("detail"):
  HoldWorldDetails.prop(self,obj.p,obj.detail,obj.width);return
 var w=float(obj.width);var cell=Vector2(ATLAS.get_width()/4.0,ATLAS.get_height()/2.0)
 var art=int(obj.art)
 var source=Rect2(Vector2(art%4,art/4)*cell,cell)
 if art==2:source.size.x-=30
 draw_texture_rect_region(ATLAS,Rect2(obj.p-Vector2(w*.5,w*.91),Vector2(w*source.size.x/cell.x,w)),source)
func draw_avatar():
 draw_set_transform(Vector2.ZERO)
 var z=.6
 var p=g.state.appearance.duplicate();p.gait_time=gait
 # This is the player's complete existing sculpt, not a portrait or map marker.
 if overview:
  var q=SURVEY_ORIGIN+marker*SURVEY_SCALE
  draw_circle(q,5,Color("f4d28d"));draw_arc(q,8,0,TAU,20,Color("fff0bd"),2,true)
 else:
  var q=marker-camera
  draw_ellipse_shadow(q)
  HoldCharacterArt.draw_sprite(self,q,gait,walking,facing,p,false,Vector2.ZERO,false,z)
func draw_ellipse_shadow(p:Vector2):
 draw_set_transform(p,0,Vector2(1,.35));draw_circle(Vector2.ZERO,15,Color(0,0,0,.26));draw_set_transform(Vector2.ZERO)
func _draw():
 draw_rect(Rect2(Vector2.ZERO,VIEW),Color("172d32"))
 if overview:draw_set_transform(SURVEY_ORIGIN,0,Vector2.ONE*SURVEY_SCALE)
 else:draw_set_transform(-camera)
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 draw_texture_rect(MEADOW,Rect2(Vector2.ZERO,WORLD),true,Color(.74,.83,.79))
 draw_texture_rect(ground,Rect2(Vector2.ZERO,WORLD),false)
 # River banks, deep water, ripples and a physical bridge at the western road.
 for y in range(0,1500,38):
  var x=river_x(y);var phase=fposmod(clock*7+y,25)
  draw_line(Vector2(x-11,y+phase),Vector2(x+3,y+phase+1),Color(.63,.83,.75,.18),1,true)
 var bx=river_x(740)
 HoldWorldDetails.bridge(self,bx)
 var avatar_drawn=false
 for obj in scenery:
  if not overview and not avatar_drawn and obj.p.y>marker.y:
   draw_avatar();draw_set_transform(-camera);avatar_drawn=true
  sprite(obj)
 if not avatar_drawn or overview:draw_avatar()
 if overview:draw_set_transform(SURVEY_ORIGIN,0,Vector2.ONE*SURVEY_SCALE)
 else:draw_set_transform(-camera)
 HoldWorldDetails.bridge(self,bx,true)
 for id in nodes:
  var pos=nodes[id].p+Vector2(0,34)
  if not overview and id==nearest:draw_arc(pos,29,0,TAU,32,Color("e9d49a"),2,true)
  # Labels are screen-scaled below, so they stay readable in the survey.
 draw_set_transform(Vector2.ZERO)
 for id in nodes:
  var pos=SURVEY_ORIGIN+(nodes[id].p+Vector2(0,45))*SURVEY_SCALE if overview else nodes[id].p+Vector2(0,45)-camera
  if pos.x<10 or pos.x>950 or pos.y<75 or pos.y>440:continue
  var text=nodes[id].name;var font=ThemeDB.fallback_font;var sz=14 if overview else 16
  var width=font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,sz).x
  draw_style_box(label_style(),Rect2(pos-Vector2(width*.5+7,14),Vector2(width+14,24)))
  draw_string(font,pos-Vector2(width*.5,-3),text,HORIZONTAL_ALIGNMENT_LEFT,-1,sz,Color("f1e1b8"))
 if paused:
  draw_rect(Rect2(0,75,960,370),Color(0,.035,.05,.72));draw_string(ThemeDB.fallback_font,Vector2(377,230),"JOURNEY PAUSED",HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color("f0d49b"))
func label_style()->StyleBoxFlat:
 var s=StyleBoxFlat.new();s.bg_color=Color(.07,.13,.13,.86);s.set_corner_radius_all(4);return s
