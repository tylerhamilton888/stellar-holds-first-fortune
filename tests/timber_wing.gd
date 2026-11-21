extends "res://tests/support/game_fixture.gd"

var destination: String

func picture(name: String):
 g.ui.hide()
 g.camera=Vector2(1880,790)
 g.notice_time=0
 g.queue_redraw()
 for i in 5:await process_frame
 await RenderingServer.frame_post_draw
 var grab=root.get_texture().get_image().get_region(Rect2i(0,49,960,448))
 check(grab.save_png(destination.path_join(name+".png"))==OK,"Captured "+name)
 g.ui.show()

func export_spots(choice:String,slot:Vector2):
 var spots=[]
 for y in range(1100,1261,20):
  for x in range(int(slot.x)-140,int(slot.x)+141,20):
   var p=Vector2(x,y)
   g.player=p+Vector2(0,48)
   if g.surface.walkable(g.player) and g.handworks.placement_ready("saw",p):
    spots.append([x-1880,y-839])
 var file=FileAccess.open(destination.path_join(choice+"-spots.json"),FileAccess.WRITE)
 file.store_string(JSON.stringify(spots))
 check(spots.has([int(slot.x)-1880,int(slot.y)-839]) and spots.size()>12,"Recommended and free positions verified on the game grid")

func run():
 var args=OS.get_cmdline_user_args()
 destination=args[0]
 var choice=args[1]
 root.size=Vector2i(960,540)
 root.content_scale_size=root.size
 g=load("res://main.tscn").instantiate()
 root.add_child(g)
 g.set_process(false)
 g.skip_arrival=true
 g.first_visit_pending=true
 g.start_game(false)
 settle()
 if is_instance_valid(g.opening_scene):g.opening_scene.finish()
 g.surface.enter("claim",Vector2(2300,1150))
 settle()
 var spec:Dictionary=HoldTimberWing.SIDES[choice]
 var slot:Vector2=spec.slot
 var hands=g.handworks
 check(HoldTimberWing.compatible(g),"Only the seeded cottage is eligible")
 at(Vector2(2320,1150))
 await picture(choice+"-starter")
 for k in ["wood","stone"]:g.state.inventory[k]=0
 check(not HoldTimberWing.install(g,choice),"Cannot build without materials")
 for k in ["wood","stone"]:g.state.add(k,60)
 var block=spec.posts[0].get_center()
 at(block)
 check(not HoldTimberWing.install(g,choice),"Cannot build over player")
 at(slot+Vector2(0,65))
 g.open_panel("homestead")
 check(not button_named("Build "+choice+" wing").is_empty(),"Wing is available from O on the grounds")
 var price=g.state.count("wood")
 button("Build "+choice+" wing")
 check(HoldTimberWing.side(g)==choice and g.state.count("wood")==price-8,"Selected side built and paid once")
 check(not HoldTimberWing.install(g,choice) and g.state.count("wood")==price-8,"Repeat purchase rejected")
 g.close_panel()
 at(Vector2(3060,1250))
 await picture(choice+"-canvas")
 export_spots(choice,slot)
 at(slot+Vector2(0,65))
 check(not g.surface.walkable(block),"New structural post has collision")
 await picture(choice+"-empty")
 g.open_panel("homestead")
 button("Fit sawbench in bay")
 var benches=hands.data().facilities.filter(func(f):return hands.local(f) and f.kind=="saw")
 check(benches.size()==1,"One suggested sawbench was built")
 if benches.is_empty():quit(1);return
 var saw=benches[0]
 check(hands.pos(saw)==slot,"Suggested bench sits inside the bay")
 at(slot+Vector2(-46,16))
 check(hands.facility().get("id")==saw.id,"Operator can reach suggested bench")
 await picture(choice+"-fitted")
 var new_slot=slot+(Vector2(60,60) if choice=="west" else Vector2(80,140))
 g.open_panel("homestead")
 button("Move nearby sawbench")
 var mode=hands.placing
 check(mode=="move_saw/"+str(saw.id),"Menu selects this bench for relocation")
 check(hands.prompt().begins_with("Moving sawbench"),"Moving has a usable placement prompt")
 var balance=g.state.inventory.duplicate(true)
 saw.cargo["wood"]=2
 at(new_slot+Vector2(0,55))
 check(not hands.build(mode,HoldTimberWing.THRESHOLD),"Cannot move a bench into the doorway")
 check(hands.pos(saw)==slot,"Invalid move keeps old position")
 at(Vector2(2900,1245))
 check(not hands.build(mode,Vector2(2920,1200)),"Public road stays clear")
 at(Vector2(2740,1215))
 check(not hands.build(mode,Vector2(2740,1180)),"Cottage approach stays clear")
 at(new_slot+Vector2(0,55))
 check(hands.build(mode,new_slot),"Bench can be repositioned freely")
 hands.placing=""
 check(saw.cargo.get("wood")==2 and balance==g.state.inventory,"Relocation keeps cargo and has no fee")
 if choice=="west":
  at(slot+Vector2(0,65))
  check(hands.build(mode,slot),"Restored bench to sheltered position")
 var operating:Vector2=hands.pos(saw)
 var rack=operating+Vector2(-100 if choice=="east" else 100,0 if choice=="east" else 40)
 at(rack+Vector2(0,48))
 check(hands.build("timber_pile",rack),"Placed separate supply rack")
 var stocks=hands.data().facilities.filter(func(f):return hands.local(f) and f.kind=="timber_pile")
 if stocks.is_empty():quit(1);return
 for i in 3:
  hands.spawn("log",rack,1,"wing-test")
  hands.data().carry.append(hands.data().loose.pop_back())
  check(hands.deposit(stocks.back())==1,"Loaded raw timber onto rack")
 if choice=="east":
  g.fieldwork.data().kit=true
  for spot in [Vector2(2010,1160),Vector2(2120,1180)]:
   at(spot+Vector2(0,50))
   if g.fieldwork.build(spot):
    var bed=g.fieldwork.data().beds.back()
    bed.planted=true;bed.watered=true;bed.crop="carrot";bed.at=g.state.elapsed-3000
   else:check(false,"Player can plant the quiet side of the plot")
 at(operating+Vector2(-46,16))
 Input.action_press("interact")
 for i in 90:
  hands.update(.04)
  if hands.working and saw.job.get("progress",0.0)>.45:break
 if not hands.working:print("Work diagnosis: state=",g.panel_id," near=",hands.facility().get("kind")," blocked=",hands.blocked_id," working=",hands.working," between=",hands.clear_line(rack,operating)," stock=",stocks.back().raw.size()," player=",g.player)
 check(hands.working and not saw.job.is_empty(),"Bench draws timber and Dwarf works")
 await picture(choice+"-working")
 for i in 120:
  hands.update(.04)
  if saw.job.is_empty():break
 Input.action_release("interact")
 hands.update(0)
 check(hands.data().skills.forester>0,"Finished a timber work cycle")
 at(Vector2(2300,1140))
 key(KEY_E);settle()
 check(g.surface.house.view.inside(),"House doorway remains usable")
 g.save_game();g.start_game(true);settle()
 check(HoldTimberWing.side(g)==choice,"Wing choice survives reload")
 var restored=g.handworks.data().facilities.filter(func(f):return f.id==saw.id and f.kind=="saw")
 check(restored.size()==1 and g.handworks.pos(restored[0])==operating,"One relocated bench survives reload")
 var door=g.surface.house.center(Vector2i(57,26))
 at(door);g.surface.house.view.cooldown=0;key(KEY_E);settle();g.open_panel("homestead")
 var old_money=g.state.count("wood")
 check(HoldTimberWing.dismantle(g) and g.state.count("wood")==old_money+8,"Removing the wing refunds once")
 check(not HoldTimberWing.dismantle(g) and restored[0].id==saw.id,"Removal preserves equipment")
 print("TIMBER WING ",choice," ",passed," passed / ",failed," failed");quit(1 if failed else 0)

func button_named(prefix: String)->Array:
 return g.panel.find_children("*","Button",true,false).filter(func(b):return b.text.begins_with(prefix))
