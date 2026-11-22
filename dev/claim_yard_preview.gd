extends Node
# The preview package selects this scene and an isolated save directory in override.cfg.
func _ready():
 if ProjectSettings.get_setting("application/config/custom_user_dir_name","")=="Stellar Holds Cottage Grounds Preview":
  call_deferred("start")

func start():
 var g=get_parent()
 if FileAccess.file_exists(HoldState.SAVE):
  g.start_game(true)
  return
 g.skip_arrival=true;g.first_visit_pending=true;g.start_game(false)
 if is_instance_valid(g.opening_scene):g.opening_scene.finish()
 g.close_panel()
 g.surface.enter("claim",Vector2(2060,1200))
 var supplies={"wood":36,"stone":36,"iron":2,"water":6}
 for item in supplies:g.state.add(item,supplies[item])
 g.fieldwork.craft_kit();g.fieldwork.data().selected="carrot"
 HoldTimberWing.install(g,"west");g.close_panel()
 g.handworks.build("saw",Vector2(2060,1140))
 for rack in [Vector2(2160,1180),Vector2(2640,1260)]:
  g.player=rack+Vector2(0,50)
  if g.handworks.build("timber_pile",rack):
   var stock=g.handworks.data().facilities.back()
   for i in 3:
    g.handworks.spawn("log",rack,1,"preview");g.handworks.data().carry.append(g.handworks.data().loose.pop_back())
    g.handworks.deposit(stock)
 g.player=Vector2(2014,1156);g.camera=g.surface.camera_target();g.surface.remember()
 g.save_game();g.close_panel();g.notify("Hold E at the sawbench. Press O to tend the grounds or move your bench.")
