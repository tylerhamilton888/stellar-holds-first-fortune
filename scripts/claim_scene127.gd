class_name HoldClaimScene127
extends HoldOpeningScene
# Short shots in the playable world. A saved beat replays only its current motion.
var cast:Array=[]
var load_height=0.0
var target_camera=Vector2.ZERO
var duration=2.0
var scene_title:Label
static func start_scene(g):
 if is_instance_valid(g.opening_scene):return
 var rise=HoldFrontier103.rise_pending(g.state)
 var d=HoldFrontier103.data(g.state).rise165 if rise else HoldClaim127.data(g.state)
 if not rise and (d.is_empty() or d.scene==""):return
 if not rise and d.scene not in ["trial","verdict","journey","reception"]:
  d.scene="";d.beat=0;g.save_game();return
 var scene=HoldClaimScene127.new();scene.game=g;scene.mode="rise" if rise else d.scene;scene.step=int(d.beat)
 g.close_panel();g.sound.stop_voice();HoldClaim127.cancel(g)
 g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer)
 g.opening_scene=scene;scene.layer.add_child(scene)
func _ready():
 var name=game.state.appearance.first_name
 var insights=HoldMountain104.data(game.state).insights
 match mode:
  "rise":
   lines=[["IVAR DEEPMEASURE","Old Stonewright's Rise. An abandoned quarry holding, east across the bridge. Sound ground, room for a hearth, and stone beneath it when you are ready to dig."],
    ["IVAR DEEPMEASURE","I will put your name beside it for provisional use. No fee, no deadline. Two civic projects or trade seals, and we record your permanent household charter. Everything you build stays where you put it."],
    ["IVAR DEEPMEASURE","Start with what you need. A dry room and a light are enough for a first night. Your room upstairs remains yours while you build. Come back when you want the charter recorded."]]
  "trial":
   lines=[["IVAR DEEPMEASURE",("The books are closed. Your work already exceeds Skarrin's tally, but he challenges your right to lead. Let the public test answer him. Today, the load decides." if HoldClaim127.closed_score(game.state)>int(HoldMountain104.data(game.state).rival_at_award) else "The books are closed. Work, deliveries and the charter allowance leave two equal claims. Today, the load decides.")],
    ["SKARRIN","My retaining wall already holds half this town. I trust we shall measure stone today, not grandfathers."],
    ["IVAR DEEPMEASURE","A safe ore lift: level footings, a frame that cannot rack, and a catch that holds when the operator lets go. Both claimants get the same proof load."],
    ["RURIK STONEHAND","If it holds my winter provisions, it will hold anything. No, Sigrid, I am not getting in the crate."],
    ["IVAR DEEPMEASURE","Read the drawings at each marked station. Bring six stone, four timber and two iron. Build carefully; there is no prize for hurrying a bad joint."]]
  "verdict":
   lines=[["IVAR DEEPMEASURE","Seats level. Frame braced. Catch engaged. Rurik, stand clear. We lift the proof load—and then we let go."],
    ["RURIK STONEHAND","Up she goes. Hands off the drum... Still holding! That catch is doing its work."],
    ["IVAR DEEPMEASURE","Skarrin's frame took the weight, but his free-running drum could not hold it without a hand at the crank. Yours passes all three published tests, "+name+". You are Stonebridge's rightful claimant."],
    ["IVAR DEEPMEASURE","Skarrin, your wall and drainage works have served every household here. We offer you Master of Works: authority over construction, crews and public maintenance. An honored office, with its own seat at council."],
    ["SKARRIN",("A seat? Beneath the name on that ancient stone? You asked who deserves the credit. Now you have your answer." if insights.get("credit",false) else "An honored servant, you mean. My hands built the walls. I will not spend my life asking permission from the person who inherits the view.")],
    ["SKARRIN",("Keep your council. There are roads beyond your gates—and people who judge a bargain without asking whose blood signs it." if insights.get("contacts",false) else "Keep the office. Keep the applause. There are people beyond these walls who know the worth of what I can build.")],
    ["IVAR DEEPMEASURE","The offer was sincere. So is the result. The High King will receive you in Keldrath, "+name+". Take the western road when you are ready. Your hearth stays here."]]
  "journey":
   lines=[["THE WESTERN ROAD","The forge falls quiet behind you. Stonebridge is no longer a stop on somebody else's road. It is the place you will return to."],
    ["IVAR DEEPMEASURE","There. King's Gate. See how the freight lines climb above the rooftops? Every stone up there passed through working hands."],
    ["IVAR DEEPMEASURE","Hearthward for a warm meal, Forgeward for the great workshops, Crownward for the Oath Court. Take a look around all three. The King can spare you an afternoon."],
    ["YOUR FIRST VISIT TO KELDRATH","The road remains open behind you. Explore, meet the city's people, and bring your invitation to the royal hall when you have found your bearings."]]
  "reception":
   lines=[["IVAR DEEPMEASURE","High King Eirik: Stonebridge's claimant. The recovered seals are authenticated, the contributions witnessed, and the public trial completed."],
    ["HIGH KING EIRIK GRANITECROWN","Come nearer, "+name+". I have read the tally. I would hear about the people who trusted you with their mountain."],
    ["HIGH KING EIRIK GRANITECROWN","A good claim rests on more than a seal. You brought your neighbors home, built a hearth, and made work that holds. Those are foundations I can recognize."],
    ["HIGH KING EIRIK GRANITECROWN","Thorek hears an oath; your neighbors must live with it. Before the formal investiture, walk my city. Remember the kitchens as well as the banners."],
    ["IVAR DEEPMEASURE","We will return for the ceremony. For now, there is a city to enjoy—and I have been promised supper without a ledger beside the plate."]]
 step=clampi(step,0,lines.size()-1)
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
 show_line()
func actor(id:String,p:Vector2,target:Vector2)->Dictionary:
 var profile=game.state.npc("ivar")
 if id.begins_with("road_folk:"):
  var i=int(id.get_slice(":",1));profile=HoldRoadCharacters.appearance(game.state,id,HoldAppearance.random_profile(game.state.seed_value+7500+i,HoldRoads.FOLK[i].gender))
 elif id.begins_with("lodge_folk:"):profile=HoldWorkerLodge100.profile(game,int(id.get_slice(":",1)))
 HoldWholeFrames.prepare_profile(profile)
 return {"id":id,"profile":profile,"p":p,"from":p,"to":target,"aim":Vector2.DOWN,"moving":false,"gait":0.0}
func locate(area:String,p:Vector2):
 if game.surface.area!=area:game.surface.enter(area,p)
 game.player=p;game.transition_left=0;game.transition_shade.visible=false;game.walking_pose=false
func show_line():
 age=0;cast.clear();duration=2.0;load_height=0
 var d=HoldFrontier103.data(game.state).rise165 if mode=="rise" else HoldClaim127.data(game.state);d.beat=step
 speaker.text=lines[step][0];caption.text=lines[step][1]
 scene_title.text={"rise":"OLD STONEWRIGHT’S RISE","trial":"THE PUBLIC TEST","verdict":"THE RIGHTFUL CLAIMANT","journey":"THE ROAD TO KELDRATH","reception":"BENEATH THE OLD KINGS"}[mode]+"   ·   "+str(step+1)+" / "+str(lines.size())
 next_button.text="Return to play" if step==lines.size()-1 else "Continue · Enter";next_button.disabled=true
 if mode=="rise":
  locate(HoldFrontier103.lodge(game.state),Vector2(550,555));game.surface.direction=Vector2.LEFT
  cast.append(actor("lodge_folk:0",Vector2(430,520) if step==0 else Vector2(480,520),Vector2(480,520)))
  target_camera=game.surface.camera_target()
 elif mode in ["trial","verdict"]:
  locate("trail",Vector2(760,905));game.surface.direction=Vector2.UP
  cast.append(actor("ivar",Vector2(620,890) if step==0 else Vector2(670,890),Vector2(670,890)))
  cast.append(actor("lodge_folk:1",Vector2(570,850) if step==0 else Vector2(600,850),Vector2(600,850)))
  cast.append(actor("lodge_folk:2",Vector2(850,915),Vector2(850,915)))
  if mode=="trial" or step<6:
   var end=Vector2(870,915) if mode=="trial" and step==1 else Vector2(900,915)
   if mode=="verdict" and step==5:end=Vector2(890,600);duration=4.6
   cast.append(actor("road_folk:8",Vector2(870,915) if mode=="trial" and step==2 else Vector2(900,915),end))
  target_camera=Vector2(300,560)
  if mode=="verdict" and step==1:duration=3.5
 elif mode=="journey":
  if step==0:
   locate("trail",Vector2(360,690));cast.append(actor("ivar",Vector2(300,690),Vector2(150,690)));duration=3.0
  else:
   locate("hearthward",HoldWorldZones.GATE+Vector2(0,75));cast.append(actor("ivar",HoldWorldZones.GATE+Vector2(-40 if step==1 else -90,55),HoldWorldZones.GATE+Vector2(-90,55)))
   game.surface.direction=Vector2.LEFT
  target_camera=game.surface.camera_target() if step==0 else Vector2(1090,140) if step==1 else Vector2(1000,175)
 else:
  locate("room:throne",Vector2(650,630 if step==0 else 650));game.surface.direction=Vector2.UP
  cast.append(actor("ivar",Vector2(550,650) if step==0 else Vector2(550,590),Vector2(550,590)))
  king=HoldRoyalStage.actor(HoldRoyalStage.THRONE-Vector2(0,17),14)
  if step>1:king=HoldRoyalStage.actor(Vector2(650,545))
  if step==1:duration=3.2
  target_camera=Vector2(170,245 if step==0 else 295)
 game.camera=target_camera+Vector2(18,0);game.sound.set_context("throne" if mode=="reception" else "road")
 game.save_game();game.queue_redraw()
func tick(dt:float):
 if finished or HoldFolk.warming():return
 var previous_age=age
 age+=dt;clock+=dt;game.clock+=dt
 if mode=="verdict" and step==1 and previous_age<2.4 and age>=2.4:game.sound.effect("metal_0",-16)
 for a in cast:
  var previous:Vector2=a.p
  a.p=a.from.lerp(a.to,smoothstep(0,duration,age));a.moving=a.p.distance_to(previous)>.01
  if a.moving:a.aim=(a.p-previous).normalized();a.gait+=HoldDrawnLocomotion.time_for_distance(a.p.distance_to(previous))
 if mode=="verdict":load_height=52*smoothstep(0,2.4,age) if step==1 else 52.0 if step>1 else 0.0
 if mode=="journey" and step==0:
  var old=game.player;game.player=Vector2(360,690).lerp(Vector2(210,690),smoothstep(0,duration,age));game.walking_pose=game.player.distance_to(old)>.01
  if game.walking_pose:game.surface.direction=Vector2.LEFT;HoldDrawnLocomotion.advance(game,game.player.distance_to(old),"stone")
 if mode=="reception" and step==1:
  if age<.6:king=HoldRoyalStage.actor(HoldRoyalStage.THRONE-Vector2(0,17*(1-age/.6)),13)
  else:king=HoldRoyalStage.actor(HoldRoyalStage.THRONE.lerp(Vector2(650,545),smoothstep(.6,duration,age)),12,Vector2.DOWN,age*.32,age<duration)
 elif mode=="reception" and step>1:king=HoldRoyalStage.actor(Vector2(650,545))
 game.camera=game.camera.lerp(target_camera,minf(1,dt*2));next_button.disabled=age<duration;game.queue_redraw()
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
 if mode=="rise":HoldFrontier103.data(game.state).rise165.scene=false
 else:HoldClaim127.complete_scene(game,mode)
 if mode=="journey":
  locate("hearthward",HoldWorldZones.GATE+Vector2(0,75));HoldClaim127.enter(game,"hearthward")
 game.opening_scene=null;game.velocity=Vector2.ZERO;game.walking_pose=false;game.swing=0;game.mining_buffer=0;game.jump_buffer=0
 game.surface.roads.portal_cooldown=1.0;game.camera=game.surface.camera_target()
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 game.notify({"rise":"Old Stonewright’s Rise is open. Follow the east road to your holding; O opens building plans.","trial":"The public lift trial is ready. E at each marked fitting; J keeps the instructions.","verdict":"Claim won. Skarrin refused Master of Works. The western road to Keldrath is open.","journey":"Welcome to Keldrath. Explore all three wards, then present your invitation in the royal hall.","reception":"Royal reception complete. Explore at your pace; King's Gate leads home."}[mode])
 game.save_game();game.update_hud();game.queue_redraw();layer.queue_free()
func objects()->Array:
 var out=[]
 for i in cast.size():out.append({"kind":"claim_actor127","p":cast[i].p,"index":i})
 return out
func draw_actor(index:int):
 var a=cast[index];var cam=game.camera.round()
 HoldDrawnAnimation.paint(game,a.p-cam,a.profile,a.aim,a.moving,a.gait,.85,-cam,"town_walk" if a.moving else "",0)
func _draw():pass
