extends SceneTree
var g
var output="/workspace/scratch/a447fc5d46ab/review42"
func _initialize():call_deferred("run")
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func snap(name:String):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=1;g.grounded=true
 g.arrive_region("workings");settle()
 var w=g.deep.world;var h=g.deep.haul
 g.player=Deepworks.center(Vector2i(11,8));g.camera=g.player-Vector2(430,285);w.survey(g.player)
 g.state.add("iron",2);g.state.add("wood",6);h.build_cart(g.player+Vector2(-40,40));h.collect("coal",150,g.player);h.bucket().stone=24
 g.deep.target=Vector2i(12,8);g.deep.contact=Vector2(480,340);g.deep.strike_left=.26;g.face=1
 await snap("01-anticipation")
 g.deep.strike_left=.15;await snap("02-contact")
 g.deep.hit(g.deep.target);g.deep.strike_left=.12;await snap("03-fracture")
 g.deep.mine(.12);g.deep.strike_left=0;await snap("04-filled-cart")
 g.open_panel("haulage");await snap("05-haulage-board");g.close_panel()
 g.state.hauling.project="steel";g.open_panel("projects");await snap("06-ledger");g.close_panel()
 g.player=h.cart_pos();h.cache_cart(g.player);await snap("07-stockpile")
 h.load_pile(g.player);h.toggle_cart(g.player);g.player=Deepworks.center(Deepworks.ENTRY);h.follow(g.player);g.deep.unload();g.notice_time=0
 await snap("08-delivery")
 # The same entry point used by normal play; cart and cargo follow the real link.
 w.carve_stairs(Deepworks.ENTRY);g.deep.use_stairs(false);settle();g.deep.survey_open=true
 await snap("09-lower-haulage")
 g.deep.survey_open=false;g.deep.use_stairs(true);settle();g.deep.use_stairs(false);g.close_panel()
 g.arrive_region("forest");settle();await snap("10-pinewood")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
