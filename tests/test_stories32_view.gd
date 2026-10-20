extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("stories32-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel()
 var s=g.state;s.opening=4;s.money=1000;s.buy_charter("old_delving");s.camp_stage=3;s.switch_site("claim",g.geo);g.zone="claim";g.room_id="";g.player=Vector2(480,410);g.camera=Vector2.ZERO
 for key in HoldData.ITEMS:s.inventory[key]=50
 HoldOutpost.recruit(s,"settler_0");HoldOutpost.recruit(s,"settler_1");HoldClaimStories.poll(s)
 g.open_panel("claim_stories");await snap("supper")
 g.outpost_tab=2;g.open_panel("manage");await snap("hiring")
 HoldClaimStories.choose(g,"table");g.close_panel();await snap("claim-table")
 var c=Vector2i(85,50);g.geo.set_cell(c,4);g.geo.set_cell(c+Vector2i.RIGHT,4);g.geo.set_cell(c+Vector2i.LEFT,0)
 HoldClaimStories.notice_ore(s,g.geo,g.geo.strike(c,100));s.elapsed+=60;HoldClaimStories.poll(s);g.zone="mine";g.player=g.geo.center(c)+Vector2(-60,0)
 g.open_panel("claim_stories");await snap("seam")
 g.close_panel();g.zone="hub";g.room_id="tavern";s.active_site="hold"
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(s,id);HoldAnniversary.prepare(s,id,0);HoldAnniversary.deliver(s,id,true)
 g.anniversary_scene=HoldAnniversaryScene.begin(g)
 var scene=g.anniversary_scene;scene.set_process(false);scene.clock=3
 for beat in [0,3,6,8,10,11,12,13,14]:
  scene.step=beat;scene.show_line();scene.age=3;scene.queue_redraw();await snap("gift-"+str(beat))
 scene.finish();await process_frame
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
