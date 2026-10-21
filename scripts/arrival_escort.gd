class_name HoldArrivalEscort
extends HoldOpeningScene
# A scene in the playable hold. Both feet follow the same collision-checked route.
const STREET=[Vector2(1270,915),Vector2(1270,870),Vector2(1240,870),Vector2(1240,720),Vector2(780,720),Vector2(780,520),Vector2(350,520),Vector2(350,475)]
const INSIDE=[Vector2(480,550),Vector2(480,480),Vector2(560,480)]
var guide=Vector2(1270,860)
var guide_direction=Vector2.DOWN
var guide_gait=0.0
var travel=0.0
var route:Array=[]
var route_length=0.0
var moving=false
var departing=false
var leaving_point=0
var failed_route=false
static func start(g):
 var scene=HoldArrivalEscort.new();scene.game=g;scene.mode="escort"
 HoldOnboarding.ensure(g.state).settle_required=true
 g.close_panel();g.sound.stop_voice();g.velocity=Vector2.ZERO;g.swing=0
 g.surface.enter("hearthward",STREET[0]);g.transition_left=0;g.transition_shade.visible=false
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer)
 g.opening_scene=scene;scene.layer.add_child(scene)
 return scene
func _ready():
 # The guide is an extra cast member, not one of the generated street citizens.
 # Prepare his complete walking frames before the scene begins to move.
 HoldWholeFrames.prepare_profile(game.state.npc("ivar"))
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=false
 game.notice_time=0
 var ui=Control.new();ui.theme=game.ui.theme;add_child(ui)
 var top=ColorRect.new();top.size=Vector2(960,46);top.color=Color("101f2b");ui.add_child(top)
 var title=Label.new();title.text="A PLACE TO BEGIN";title.position=Vector2(26,10);title.modulate=Color("edc98a");ui.add_child(title)
 var bg=ColorRect.new();bg.position=Vector2(0,398);bg.size=Vector2(960,142);bg.color=Color(.045,.095,.12,1);ui.add_child(bg)
 speaker=Label.new();speaker.position=Vector2(28,411);speaker.text="IVAR DEEPMEASURE";speaker.modulate=Color("edc98a");ui.add_child(speaker)
 caption=Label.new();caption.position=Vector2(28,441);caption.size=Vector2(716,88);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",17);ui.add_child(caption)
 next_button=game.button(ui,"Follow Ivar",advance);next_button.position=Vector2(765,461);next_button.size=Vector2(172,48)
 var skip=game.button(ui,"Skip walk · Esc",finish);skip.position=Vector2(784,5);skip.size=Vector2(154,35)
 set_line(""+game.state.appearance.first_name+", is it? I’m Ivar. Long road for your first shift. Come along—there’s a room waiting for you. We can talk about work once you’ve put your feet up.","Follow Ivar")
 game.surface.direction=(guide-game.player).normalized();game.camera=game.surface.camera_target();game.queue_redraw()
func set_line(text:String,button_text:String):
 age=0;caption.text=text;next_button.text=button_text;next_button.disabled=moving or departing
func follow(points:Array,lead:float=0):
 route=points;travel=lead;route_length=0
 for i in range(1,route.size()):route_length+=route[i-1].distance_to(route[i])
 # Do not hide a route regression by forcing actors through scenery.
 for i in range(1,route.size()):
  var count=int(ceil(route[i-1].distance_to(route[i])/4.0))
  for j in count+1:
   if not game.surface.walkable(route[i-1].lerp(route[i],float(j)/maxi(1,count))):
    failed_route=true;push_error("Arrival escort route is obstructed");finish();return
 moving=true;next_button.disabled=true
func sample_route(distance:float)->Vector2:
 for i in range(1,route.size()):
  var length=route[i-1].distance_to(route[i])
  if distance<=length:return route[i-1].lerp(route[i],clampf(distance/maxf(.001,length),0,1))
  distance-=length
 return route[-1]
func advance():
 if age<.25 or moving or departing or finished:return
 match step:
  0:
   step=1;set_line("King’s Gate behind us leads to the High Trail. The Old Workings lie north, Pinewood south. For now, keep your boots on the warm side of the mountain.","Walking…");follow(STREET,55)
  2:
   step=3
   # Walk the last few paces to the visible door before entering.
   set_line("Here we are. A good lock and a roof that doesn’t leak. Mind the threshold.","This way…");follow([game.player,Vector2(350,475)])
  4:step=5;set_line("Settle in first: rest at the bed and check your chest. Then introduce yourself to Borin down in Forgeward, Orla at the exchange, and Hedrik at the Copper Kettle. J keeps the names and directions.","Make myself at home")
  5:
   departing=true;leaving_point=0;next_button.disabled=true
   set_line("I’ll be in the office southeast of the fountain. No hurry—the mountain has waited this long. Welcome to Keldrath.","See you soon")
func tick(dt:float):
 if finished or HoldFolk.warming():return
 clock+=dt;age+=dt;game.clock+=dt;game.state.elapsed+=dt
 if moving:
  var old=game.player;var old_guide=guide
  var limit=route_length if step==1 or game.surface.room() else route_length+55
  travel=minf(limit,travel+140*dt)
  guide=sample_route(minf(travel,route_length))
  game.player=sample_route(maxf(0,travel-55))
  if guide.distance_to(old_guide)>.01:guide_direction=(guide-old_guide).normalized();guide_gait+=HoldDrawnLocomotion.time_for_distance(guide.distance_to(old_guide))
  ivar_walking=guide.distance_to(old_guide)>.01
  game.walking_pose=old.distance_to(game.player)>.01
  if game.walking_pose:game.surface.direction=(game.player-old).normalized();HoldDrawnLocomotion.advance(game,old.distance_to(game.player),"wood" if game.surface.room() else "stone")
  if travel>=limit:
   moving=false;ivar_walking=false;game.walking_pose=false;next_button.disabled=false
   if step==1:
    step=2;game.surface.direction=Vector2.UP;guide_direction=Vector2.DOWN
    set_line("These are your quarters, on the northwestern street. The tavern and exchange are just along here. Eastern stairs go down to Borin’s forge; the western stairs climb to the Crownward.","Go inside")
   elif step==3 and not game.surface.room():
    game.surface.action("room:home");game.transition_left=0;game.transition_shade.visible=false
    follow(INSIDE,55);guide=sample_route(55)
   elif step==3:
    step=4;guide_direction=Vector2.LEFT;game.surface.direction=Vector2.RIGHT
    set_line("Bed on the left. Your own chest beside the table—supplies stay here until you take them out. Your pack comes with you. The room stays yours, even when you’ve a mountain of your own.","What comes next?")
 elif departing:
  var targets=[Vector2(560,565),Vector2(480,565),Vector2(480,620)];var old=guide
  guide=guide.move_toward(targets[leaving_point],125*dt);ivar_walking=true
  guide_direction=(guide-old).normalized();guide_gait+=HoldDrawnLocomotion.time_for_distance(old.distance_to(guide))
  if guide.distance_to(targets[leaving_point])<1:
   leaving_point+=1
   if leaving_point==targets.size():finish();return
 game.camera=game.camera.lerp(game.surface.camera_target(),minf(1,dt*7));game.queue_redraw()
func _process(dt):
 if get_window().has_focus():tick(dt)
func draw_guide():
 var cam=game.camera.round()
 game.draw_set_transform(guide-cam,0,Vector2(1,.3));game.draw_circle(Vector2.ZERO,19,Color(0,0,0,.3))
 HoldDrawnAnimation.paint(game,guide-cam,game.state.npc("ivar"),guide_direction,ivar_walking,guide_gait,.85,-cam,"town_walk")
func finish():
 if finished:return
 finished=true
 var q=HoldOnboarding.ensure(game.state);q.escort_pending=false;q.arrival_seen=true;q.stage=1
 game.state.tracked_npc="";game.state.resident_visits.erase("ivar")
 if game.surface.area!="room:home":game.surface.enter("room:home",Vector2(480,500))
 game.transition_left=0;game.transition_shade.visible=false
 game.walking_pose=false;game.velocity=Vector2.ZERO;game.surface.direction=Vector2.DOWN
 game.opening_scene=null;game.camera=game.surface.camera_target()
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 game.notify("Your room is ready. WASD / arrows: walk · E: bed or chest · I: pack · J: journal")
 game.save_game();game.update_hud();game.queue_redraw();layer.queue_free()
func _draw():pass
