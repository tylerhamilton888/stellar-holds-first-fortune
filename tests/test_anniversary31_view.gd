extends SceneTree
var g
class DrinkBoard extends Node2D:
 func character_scale()->float:return 1.6
 func _draw():
  HoldArt.draw_offset=Vector2.ZERO
  HoldArt.rect(self,0,0,960,540,"182c38")
  HoldArt.text(self,Vector2(30,40),"Social poses • all ten complete character designs",22)
  for gender in 2:
   for sculpt in 5:
    var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt;p=HoldAppearance.normalized(p)
    var pos=Vector2(100+sculpt*185,240+gender*240)
    HoldNpcActivity.social(self,pos,14,1 if sculpt%2==0 else -1,p,true)
    HoldArt.text(self,pos+Vector2(-55,27),("Female " if gender else "Male ")+str(sculpt+1),16)
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("anniversary31-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=2;g.grounded=true
 g.room_id="";g.player=Vector2(190,410);g.camera=Vector2.ZERO;g.clock=6
 for k in HoldData.ITEMS:g.state.add(k,50)
 await snap("offers")
 for gender in 2:
  g.state.appearance.gender=gender;g.state.outpost.erase("anniversary")
  g.open_panel("anniversary");await snap("offer-"+str(gender));g.close_panel()
 for id in ["hedrik","orla"]:
  HoldAnniversary.accept(g.state,id);HoldAnniversary.prepare(g.state,id,2);HoldAnniversary.deliver(g.state,id,true)
 g.room_id="forge";g.player=Vector2(790,410);g.clock=.85
 await snap("forge-contact")
 g.clock=.25;await snap("forge-lift")
 g.clock=6;await snap("forge-rest")
 g.room_id="";g.player=Vector2(1100,410);g.camera=Vector2(650,0);g.clock=.85;await snap("forge-exterior")
 g.camera=Vector2.ZERO
 g.room_id="tavern";g.clock=14;g.player=Vector2(810,410)
 await snap("tavern-drinks")
 g.close_panel();g.anniversary_scene=HoldAnniversaryScene.begin(g)
 var scene=g.anniversary_scene;scene.set_process(false)
 for i in [0,5,8,10,11,14]:
  scene.step=i;scene.show_line();scene.age=2;scene.clock=2;scene.queue_redraw();await snap("scene-"+str(i))
 scene.finish();await process_frame
 g.clock=14;await snap("tea-table")
 g.open_panel("anniversary");await snap("completed")
 var layer=CanvasLayer.new();layer.layer=40;g.add_child(layer);var board=DrinkBoard.new();layer.add_child(board);await snap("drink-board")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
