extends SceneTree
var g
var output="/workspace/scratch/a447fc5d46ab/review"
func _initialize():call_deferred("run")
func snap(name:String):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.state.opening=1;g.grounded=true
 g.arrive_region("workings");g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
 await snap("01-entrance")
 g.player=Deepworks.center(Vector2i(11,8));g.camera=g.player-Vector2(430,290);g.deep.world.survey(g.player)
 g.deep.target=Vector2i(12,8);g.deep.contact=Vector2(480,340);g.deep.strike_left=.13;g.face=1
 await snap("02-pick-contact")
 g.deep.hit(g.deep.target);g.deep.strike_left=0
 await snap("03-break")
 g.player=Deepworks.center(Deepworks.ENTRY);g.deep.world.carve_stairs(Deepworks.ENTRY);g.deep.use_stairs(false);g.transition_left=0;g.transition_shade.visible=false
 g.deep.survey_open=true;await snap("04-lower-survey")
 g.deep.survey_open=false
 g.deep.strike_left=0
 var w=g.deep.world;var f=w.layer().features[1]
 # Capture the actual generated geode without altering it.
 g.player=Deepworks.center(Vector2i(f.x,f.y));g.camera=g.player-Vector2(480,290);w.survey(g.player);g.notice_time=0
 await snap("05-geode")
 var r=w.layer().features[2];g.player=Deepworks.center(Vector2i(r.x,r.y));g.camera=g.player-Vector2(480,290);w.survey(g.player)
 await snap("06-ruins")
 g.open_panel("deepworks");await snap("07-build-board")
 g.close_panel();w.data.depth=0
 for sex in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":sex,"sculpt":0})
  for direction in [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]:
   var c=Vector2i(8,5) if direction==Vector2i.UP else Vector2i(8,11) if direction==Vector2i.DOWN else Vector2i(4,8) if direction==Vector2i.LEFT else Vector2i(11,9)
   g.player=Deepworks.center(c);g.camera=g.deep.camera_target();w.survey(g.player)
   g.deep.contact=g.player+Vector2(direction)*20;g.face=-1 if direction.x<0 else 1;g.deep.strike_left=.13
   await snap("contact-%d-%d-%d" % [sex,direction.x,direction.y])
 g.deep.strike_left=0
 g.close_panel();g.travel_road();g.transition_left=0;g.transition_shade.visible=false;g.notice_time=0
 await snap("08-pinewood")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
