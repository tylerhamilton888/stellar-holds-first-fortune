extends "res://tests/support/game_fixture.gd"
var dst:String
const WEST=Vector2(2060,1140)
const EAST=Vector2(2740,1260)
func capture(name:String):
 g.ui.hide();g.notice_time=0
 g.camera=Vector2(1870,790)
 g.queue_redraw()
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 var shot=root.get_texture().get_image().get_region(Rect2i(0,49,960,448))
 check(shot.save_png(dst.path_join(name+".png"))==OK,"Captured "+name)
 g.ui.show()

func saw_at(p:Vector2):
 at(p+Vector2(-46,16))
 var rank:int=g.handworks.data().skills.forester
 Input.action_press("interact")
 for i in 200:
  g.handworks.update(.035)
  if g.handworks.data().skills.forester>rank:break
 Input.action_release("interact");g.handworks.update(0)
 check(g.handworks.data().skills.forester>rank,"Completed production at "+str(p))

func run():
 dst=OS.get_cmdline_user_args()[0]
 root.size=Vector2i(960,540);root.content_scale_size=root.size
 g=load("res://dev/claim_yard_preview.tscn").instantiate()
 root.add_child(g);g.set_process(false)
 g.get_node("GroundsPreview").start()
 settle()
 check(HoldClaimYard.here(g) and HoldTimberWing.side(g)=="west","Preview starts outside at the furnished cottage")
 var hands=g.handworks
 var benches=hands.data().facilities.filter(func(f):return hands.local(f) and f.kind=="saw")
 check(benches.size()==1,"Preview supplies exactly one player sawbench")
 if benches.is_empty():quit(1);return
 var saw=benches[0]
 check(HoldClaimYard.data(g).wear.is_empty(),"Fresh ground has no work marks")
 await capture("inherited")
 await saw_at(WEST)
 check(HoldClaimYard.data(g).wear.has(HoldClaimYard.key(WEST)),"First job leaves a patch at the west bench")
 await capture("west-work")
 at(WEST+Vector2(-46,16));g.open_panel("homestead");button("Move nearby sawbench")
 var mode:String=hands.placing
 at(EAST+Vector2(0,55));check(hands.build(mode,EAST),"Moved the same bench across the plot");hands.placing=""
 check(not HoldClaimYard.data(g).wear.has(HoldClaimYard.key(EAST)),"Moving alone leaves no shavings")
 await saw_at(EAST)
 check(HoldClaimYard.data(g).wear.has(HoldClaimYard.key(EAST)),"East job leaves a second patch")
 at(WEST+Vector2(0,55));check(g.fieldwork.build(WEST),"Garden replaces old bench at the same coordinates")
 check(not HoldClaimYard.data(g).wear.has(HoldClaimYard.key(WEST)),"Old ground is reclaimed by planting bed")
 var bed=g.fieldwork.data().beds.back()
 for job in ["hoe","plant","water"]:
  at(WEST+Vector2(-65,-18));g.fieldwork.start(job,bed)
  for i in 100:g.fieldwork.update(.04)
 check(bed.planted and bed.watered and bed.crop=="carrot","Field kit grows carrots in the former work spot")
 g.state.elapsed+=g.fieldwork.grow_time(bed)+1
 var path=Vector2(2480,1240)
 at(path+Vector2(0,50));g.open_panel("homestead");button("Tend cottage grounds");button("Lay stone path")
 check(g.surface.placing=="yard:pave","Grounds tools are available through O")
 var stone:int=g.state.count("stone")
 check(HoldClaimYard.apply(g,"pave",path) and not HoldClaimYard.apply(g,"pave",path),"Path tiles charge once")
 check(HoldClaimYard.apply(g,"lift",path) and g.state.count("stone")==stone and not HoldClaimYard.apply(g,"lift",path),"Lift refunds a tile once")
 for offset in [Vector2.ZERO,Vector2(40,0),Vector2(80,0),Vector2(-40,0)]:check(HoldClaimYard.apply(g,"pave",path+offset),"Laid a connected path")
 g.surface.cancel_placement()
 at(Vector2(2740,1220))
 check(not HoldClaimYard.apply(g,"pave",Vector2(2740,1180)),"Public walkway is protected")
 at(EAST+Vector2(-46,16));await capture("east-garden")
 var d=HoldClaimYard.data(g)
 check(d.rowan and not g.surface.walkable(HoldClaimYard.TREE),"Standing rowan has trunk collision")
 at(HoldClaimYard.TREE+Vector2(40,30))
 var wood:int=g.state.count("wood")
 check(HoldClaimYard.apply(g,"fell",HoldClaimYard.TREE) and g.surface.walkable(HoldClaimYard.TREE),"Felling opens the former trunk")
 check(not HoldClaimYard.apply(g,"fell",HoldClaimYard.TREE) and g.state.count("wood")==wood+4,"Rowan gives wood only once")
 var grass:Vector2=HoldClaimYard.VERGE[8]
 at(grass+Vector2(0,48));check(HoldClaimYard.apply(g,"cut",grass),"Cut a chosen patch of tall grass")
 at(EAST+Vector2(-46,16));g.save_game();g.start_game(true);settle()
 d=HoldClaimYard.data(g)
 check(not d.rowan and d.paths.size()==4 and d.cuts.has(HoldClaimYard.key(grass)),"Tree, paths and mown verge survive reload")
 check(d.wear.size()==1 and d.wear.has(HoldClaimYard.key(EAST)) and g.fieldwork.data().beds.back().crop=="carrot","Reload retains separate garden and worksite")
 await capture("cleared")
 at(EAST+Vector2(-46,16))
 check(HoldClaimYard.apply(g,"sweep",EAST) and d.wear.is_empty(),"Player can rake a used patch")
 HoldClaimYard.sawed(g,EAST);g.state.elapsed+=HoldClaimYard.LIFE+1
 check(HoldClaimYard.action_target(g,"sweep",EAST)==Vector2.INF,"Old shavings weather away")
 print("CLAIM YARD ",passed," passed / ",failed," failed");quit(1 if failed else 0)
