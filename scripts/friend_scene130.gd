class_name HoldFriendScene130
extends HoldOpeningScene
# All staging is transient. The saved beat owns recovery; real furniture is never changed.
const MAREN_LIFT=preload("res://assets/friendship130/maren-lift.png")
var cast:Array=[]
var friend_id=""
var episode_index=0
var spec:Dictionary={}
var anchor=Vector2.ZERO
var origin=Vector2.ZERO
var area=""
var duration=1.6
var target_camera=Vector2.ZERO
var scene_title:Label
var tilt=0.0
static func start_scene(g):
 if is_instance_valid(g.opening_scene):return
 var d=HoldFriendship130.data(g.state).scene
 if d.is_empty():return
 var id=str(d.get("id",""));var index=int(d.get("index",-1))
 if not HoldFriendship130.STORIES.has(id) or index<0 or index>=3 or HoldFriendship130.record(g.state,id).index!=index or not HoldFriendship130.record(g.state,id).worked:
  HoldFriendship130.data(g.state).scene={};g.save_game();return
 var scene=HoldFriendScene130.new();scene.game=g;scene.mode="friend130";scene.friend_id=id;scene.episode_index=index
 scene.spec=HoldFriendship130.STORIES[id][index];scene.step=int(d.get("beat",0));scene.area=d.area
 scene.anchor=Vector2(d.anchor[0],d.anchor[1]);scene.origin=Vector2(d.player[0],d.player[1])
 g.close_panel();g.sound.stop_voice();HoldClaim127.cancel(g)
 g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer);g.opening_scene=scene;scene.layer.add_child(scene)
func _ready():
 lines=spec.lines.duplicate();step=clampi(step,0,lines.size()-1)
 if spec.action=="flip" and HoldClaim127.absent(game.state,"road_folk:8"):
  lines[0]="Two miners who once worked for Skarrin elbow their empty bowls aside. One boasts about his old foreman while telling cooks to keep quiet."
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=false
 game.sync_hud_controls()
 var ui=Control.new();ui.theme=game.ui.theme;add_child(ui)
 var top=ColorRect.new();top.size=Vector2(960,46);top.color=Color("101f2b");ui.add_child(top)
 scene_title=Label.new();scene_title.position=Vector2(26,10);scene_title.modulate=Color("edc98a");ui.add_child(scene_title)
 var bg=ColorRect.new();bg.position=Vector2(0,398);bg.size=Vector2(960,142);bg.color=Color("101f2b");ui.add_child(bg)
 speaker=Label.new();speaker.position=Vector2(26,409);speaker.modulate=Color("edc98a");speaker.add_theme_font_size_override("font_size",17);ui.add_child(speaker)
 caption=Label.new();caption.position=Vector2(26,437);caption.size=Vector2(716,97);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",16);ui.add_child(caption)
 next_button=game.button(ui,"Continue · Enter",advance);next_button.position=Vector2(765,462);next_button.size=Vector2(175,48)
 var skip=game.button(ui,"Skip scene · Esc",finish);skip.position=Vector2(775,5);skip.size=Vector2(165,35)
 if game.surface.area!=area:game.surface.enter(area,origin)
 game.player=origin;game.transition_left=0;game.transition_shade.visible=false
 show_line()
func actor(id:String,p:Vector2,end:Vector2)->Dictionary:
 var profile=game.state.npc(id) if not id.begins_with("rude130") else HoldAppearance.random_profile(13001 if id.ends_with("a") else 13002,0)
 HoldWholeFrames.prepare_profile(profile)
 return {"id":id,"profile":profile,"p":p,"from":p,"to":end,"aim":Vector2.DOWN,"moving":false,"gait":0.0}
func show_line():
 age=0;tilt=0;cast.clear();duration=1.6
 HoldFriendship130.data(game.state).scene.beat=step
 scene_title.text=spec.title.to_upper()+"   ·   "+str(step+1)+" / "+str(lines.size())
 speaker.text="A MOMENT TOGETHER" if step==0 else game.state.npc(friend_id).name.to_upper()
 caption.text=lines[step];next_button.text="Return to play" if step==lines.size()-1 else "Continue · Enter";next_button.disabled=true
 if spec.action=="flip":
  game.player=Vector2(540,555)
  var start=Vector2(550,510) if step==0 else Vector2(565,485)
  cast.append(actor(friend_id,start,Vector2(565,485)))
  cast.append(actor("rude130a",Vector2(742,520) if step>=2 else Vector2(700,500),Vector2(742,520) if step in [1,2] else Vector2(700,500)))
  cast.append(actor("rude130b",Vector2(630,575) if step>=2 else Vector2(660,560),Vector2(630,575) if step in [1,2] else Vector2(660,560)))
  cast.append(actor("road_folk:1",Vector2(500,470) if step>=3 else Vector2(520,420),Vector2(500,470) if step>=2 else Vector2(520,420)))
  if step==1:duration=2.5
  if step==2:tilt=2.7;speaker.text="DAGNA & MAREN"
  if step==3:duration=2.5;speaker.text="A TABLE SET RIGHT"
  target_camera=Vector2(0,200)
 else:
  var end=anchor
  for offset in [(anchor-origin).normalized()*48,Vector2(-65,0),Vector2(65,0),Vector2(0,-65),Vector2(0,65)]:
   var candidate=anchor+offset
   if candidate.distance_to(origin)>=60 and game.surface.walkable(candidate) and game.surface.clear_interaction(anchor,candidate):end=candidate;break
  cast.append(actor(friend_id,anchor if step==0 else end,end))
  target_camera=(anchor+origin)*.5-Vector2(480,240)
  if game.surface.room():target_camera=game.surface.camera_target()
 game.camera=target_camera;game.walking_pose=false;game.save_game();game.queue_redraw()
func tick(dt:float):
 if finished or HoldFolk.warming():return
 var previous=age;age+=dt;clock+=dt;game.clock+=dt
 for a in cast:
  var before:Vector2=a.p;a.p=a.from.lerp(a.to,smoothstep(0,duration,age));a.moving=a.p.distance_to(before)>.01
  if a.moving:a.aim=(a.p-before).normalized();a.gait+=HoldDrawnLocomotion.time_for_distance(a.p.distance_to(before))
 if spec.action=="flip":
  if step==1:
   tilt=2.7*smoothstep(.35,1.15,age)
   if previous<1.15 and age>=1.15:game.sound.effect("wood",-10)
  elif step==3:tilt=2.7*(1-smoothstep(.3,1.8,age))
 next_button.disabled=age<duration;game.queue_redraw()
func _process(dt):
 if get_window().has_focus():tick(dt)
func advance():
 if finished or age<duration:return
 if step==lines.size()-1:finish();return
 step+=1;show_line()
func _input(event):
 if event is InputEventKey and event.pressed and not event.echo:
  if event.keycode in [KEY_SPACE,KEY_ENTER]:advance()
  elif event.keycode==KEY_ESCAPE:finish()
  get_viewport().set_input_as_handled()
func finish():
 if finished:return
 finished=true
 var paid=HoldFriendship130.complete(game,friend_id,episode_index)
 game.player=origin;game.opening_scene=null;game.velocity=Vector2.ZERO;game.walking_pose=false;game.swing=0;game.mining_buffer=0;game.jump_buffer=0
 game.surface.roads.portal_cooldown=1.0;game.camera=game.surface.camera_target()
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 if paid:game.sound.effect("quest",-12);game.notify("Friendship memory · "+spec.title+" · "+HoldFriendship130.rewards(spec))
 game.save_game();game.update_hud();game.queue_redraw();layer.queue_free()
func hide_object(o:Dictionary)->bool:
 if cast.any(func(a):return a.id==str(o.get("interaction",o.get("id","")))):return true
 return spec.action=="flip" and o.kind=="furnishing" and o.p==Vector2(650,450)
func objects()->Array:
 var out=[]
 for i in cast.size():out.append({"kind":"friend_actor130","p":cast[i].p,"index":i})
 if spec.action=="flip":out.append({"kind":"friend_prop130","p":Vector2(600,515)})
 elif spec.action in ["work","inspect"]:out.append({"kind":"friend_prop130","p":anchor+Vector2(24,10)})
 return out
func draw_actor(index:int):
 var a=cast[index];var cam=game.camera.round()
 if spec.action=="flip" and a.id==friend_id and step in [1,2,3]:
  var frame=3 if step!=1 or age>=1.15 else 0 if age<.35 else 1 if age<.7 else 2
  var crops=[Rect2(80,130,480,570),Rect2(600,70,480,630),Rect2(1155,38,480,662),Rect2(1680,38,400,662)]
  var feet=[Vector2(275,687),Vector2(800,687),Vector2(1330,687),Vector2(1880,687)]
  var crop:Rect2=crops[frame];var scale=.08
  game.draw_set_transform(a.p-cam)
  game.draw_texture_rect_region(MAREN_LIFT,Rect2((crop.position-feet[frame])*scale,crop.size*scale),crop)
  game.draw_set_transform(-cam);return
 var toast=spec.action=="toast" and step>0 and a.id==friend_id
 HoldDrawnAnimation.paint(game,a.p-cam,a.profile,a.aim,a.moving,a.gait,.85,-cam,"drink" if toast else "town_walk" if a.moving else "",float(clampi(int(age/.4),0,3)) if toast else 0.0)
func draw_prop():
 var cam=game.camera.round()
 if spec.action=="flip":
  # Pivot around the far table edge; plates remain on the floor until cleanup.
  game.draw_set_transform(Vector2(625,500)-cam,tilt)
  HoldFurnishings.draw(game,Vector2(-25,0),"table")
  game.draw_set_transform(-cam)
  if step in [1,2] and (step==2 or age>.7):
   var flight=clampf((age-.7)/.65,0,1) if step==1 else 1.0
   for i in 2:
    var p=Vector2(600+i*16,465).lerp(Vector2(650+i*18,550+i*12),flight)+Vector2(0,-30*sin(flight*PI))
    HoldFurnishings.draw(game,p,"mug")
 else:
  var p=anchor+Vector2(24,10)
  game.draw_set_transform(p-cam,(sin(age*4)*.08 if spec.action=="inspect" and step==0 else 0.0))
  HoldFurnishings.draw(game,Vector2.ZERO,"crate")
 game.draw_set_transform(-cam)
func _draw():pass
