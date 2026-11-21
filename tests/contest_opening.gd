extends SceneTree
# Run with a fresh user-data directory and -- campaign. Optionally set CAPTURE_DIR.
var g
var failures=[]
var folder=OS.get_environment("CAPTURE_DIR")

func _initialize():
 call_deferred("run")

func check(ok:bool,message:String):
 if not ok:failures.append(message)
 print("PASS " if ok else "FAIL ",message)

func visible_nodes(node,result:Array):
 if node is CanvasLayer and not node.visible:return
 if node is CanvasItem and not node.is_visible_in_tree():return
 if node is Label or node is Button:result.append(node)
 for child in node.get_children():visible_nodes(child,result)

func click(label:String)->bool:
 var nodes=[];visible_nodes(g,nodes)
 for node in nodes:
  if node is Button and not node.disabled and node.text==label:
   node.pressed.emit()
   return true
 return false

func frames():
 for i in 4:await process_frame

func capture(id:String):
 if folder=="" or DisplayServer.get_name()=="headless":return
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(folder.path_join(id+".png"))

func cross(target:String):
 var roads=g.surface.roads
 var link=roads.links(g.surface.area).filter(func(x):return x.target==target)[0]
 roads.portal_cooldown=0;roads.return_hold.clear()
 g.player=link.p+link.normal*2
 return roads.moved(link.p-link.normal*2,.1)

func ready_to_advance(scene)->bool:
 var deadline=Time.get_ticks_msec()+45000
 while scene.age<.3 and Time.get_ticks_msec()<deadline:await process_frame
 if scene.age<.3:
  check(false,"Opening did not advance: window focused=%s, beat age=%s" % [root.has_focus(),scene.age])
  return false
 return true

func run():
 g=load("res://main.tscn").instantiate()
 root.add_child(g)
 root.grab_focus()
 await frames()
 check(not g.playing,"Campaign launcher opens the title screen")
 if not click("New Game"):check(false,"New Game button");quit(1);return
 await frames()
 var words=[];visible_nodes(g,words)
 check(words.any(func(x):return x is Label and "Skarrin leads" in x.text),"Slot introduction names the contest")
 if not click("New fortune"):check(false,"Fresh slot");quit(1);return
 await frames()
 if not click("Begin your fortune"):check(false,"Character creation");quit(1);return
 await frames()
 var scene=g.opening_scene
 if not is_instance_valid(scene):check(false,"Frontier scene began");quit(1);return
 var q=g.state.surface.first_visit99
 var home=g.state.surface.frontier103.home169
 check(scene.mode=="frontier_arrival" and "Thane" in scene.caption.text,"Contest named on first beat")
 if not await ready_to_advance(scene):quit(1);return
 await capture("1-road")
 for i in range(1,8):
  if not await ready_to_advance(scene):quit(1);return
  scene.next_button.pressed.emit()
  await frames()
  check(scene.step==i and q.intro_beat==i,"Opening beat "+str(i)+" played and checkpointed")
  if i==3:
   var cast=g.surface.roads.people(g.surface.area).filter(func(x):return x.interaction=="road_folk:8")
   check(scene.speaker.text=="SKARRIN" and cast.size()==1 and scene.foreman_portrait.visible,"Skarrin speaks in person with portrait")
   await capture("2-skarrin")
   var checkpoint=OS.get_environment("CHECKPOINT_PATH")
   if checkpoint!="":
    var result=DirAccess.copy_absolute(ProjectSettings.globalize_path(g.state.save_path()),checkpoint)
    check(result==OK,"Saved an unmodified mid-intro checkpoint")
  if i==4:await capture("3-ledger")
 if not await ready_to_advance(scene):quit(1);return
 scene.next_button.pressed.emit()
 await frames()
 check(not q.intro_pending and q.focus=="forge" and g.state.claim_id=="copper_ridge","Borin tracked and cottage owned after opening")
 check(g.surface.roads.people(g.surface.area).all(func(x):return x.interaction!="road_folk:8"),"Skarrin returns to his town route")
 var frontier=load("res://scripts/frontier103.gd")
 var ledgers=load("res://scripts/ledger137.gd")
 check("again" in ledgers.skarrin(g.state),"Town greeting remembers the lodge meeting")
 var guide=load("res://scripts/worker_lodge100.gd").people(g)[0]
 g.player=guide.p
 if is_instance_valid(g.opening_scene):check(false,"Intro completed");quit(1);return
 if not frontier.offer_rise(g):check(false,"Ivar can lead the player to the Rise");quit(1);return
 scene=g.opening_scene
 scene.tick(4);scene.advance()
 await frames()
 check(scene.mode=="rise" and g.surface.area=="claim","Ivar brings the player to the actual holding")
 await capture("4-rise")
 scene.finish()
 await frames()
 var marks=g.state.surface.great_claim102.points
 check(cross("trail") and home.homeward=="away","Leave the holding by its road")
 check(cross("claim") and home.homeward=="returned","Returning by road marks the first homecoming")
 check(cross("trail") and cross("claim") and home.homeward=="returned","Later crossings keep the completed homecoming")
 check(g.state.surface.great_claim102.points==marks,"Travel and deed award no contest marks")
 print("RESULT ",failures)
 quit(0 if failures.is_empty() else 1)
