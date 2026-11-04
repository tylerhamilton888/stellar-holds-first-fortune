class_name HoldBridgeScene139
extends HoldClaimScene127
# Reuse the established scene controls, actor painter and alternating walking poses.
static func start_bridge(g):
 if is_instance_valid(g.opening_scene) or not HoldRestoration139.active(g.state):return
 var d=HoldRestoration139.data(g.state)
 if not d.scene or not d.built or d.dedicated:return
 var scene=HoldBridgeScene139.new();scene.game=g;scene.mode="bridge";scene.step=int(d.beat)
 g.close_panel();g.sound.stop_voice();g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer)
 g.opening_scene=scene;scene.layer.add_child(scene)
func _ready():
 var name=game.state.appearance.first_name
 lines=[["IVAR DEEPMEASURE","The old north span carries feet again. Stone, fittings, meals: three shifts supplied, and every pair of hands recorded. Thank you, "+name+"."],
  ["SKARRIN","A fine result. Of course, I set out the original abutments. It is gratifying to see a newcomer flourish under the example I established."],
  ["IVAR DEEPMEASURE","Your earlier work is in the book, Skarrin. So are the masons, the cooks, and the dwarf who brought this crew together. There is room for every name."],
  ["SKARRIN","Naturally. Though some names seem to need rather more reading aloud than others."],
  ["IVAR DEEPMEASURE","The crossing is yours to use, all of you. Edda has the surviving charter upstairs. Let sound work and sound evidence speak together."]]
 if HoldClaim127.absent(game.state,"road_folk:8"):
  lines=[["IVAR DEEPMEASURE","The old north span is open. Your title did not finish this work for you; your hands and your neighbors did."],["IVAR DEEPMEASURE","Stone, fittings, meals: every contribution has a name. The survey hall and Old Workings are closer for everyone now."]]
 super._ready()
func show_line():
 age=0;cast.clear();duration=1.8
 HoldRestoration139.data(game.state).beat=step
 speaker.text=lines[step][0];caption.text=lines[step][1]
 scene_title.text="A NAME BESIDE THE WORK   ·   %d / %d" % [step+1,lines.size()]
 next_button.text="Return to play" if step==lines.size()-1 else "Continue · Enter";next_button.disabled=true
 locate("trail",Vector2(1090,530));game.surface.direction=Vector2.RIGHT
 cast.append(actor("ivar",Vector2(1160,510) if step==0 else Vector2(1190,510),Vector2(1190,510)))
 if not HoldClaim127.absent(game.state,"road_folk:8"):
  cast.append(actor("road_folk:8",Vector2(1275,510) if step==2 else Vector2(1310,510),Vector2(1275,510) if step==1 else Vector2(1310,510)))
 target_camera=Vector2(750,260);game.camera=target_camera
 game.sound.set_context("road");game.save_game();game.queue_redraw()
func finish():
 if finished:return
 finished=true
 var d=HoldRestoration139.data(game.state);d.scene=false;d.beat=0;d.dedicated=true
 game.opening_scene=null;game.velocity=Vector2.ZERO;game.walking_pose=false;game.swing=0;game.mining_buffer=0;game.jump_buffer=0
 game.surface.roads.portal_cooldown=1.0;game.camera=game.surface.camera_target()
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 game.notify("The North Crossing serves Stonebridge. Your earlier recognition remains unchanged." if HoldMountain104.data(game.state).authenticated else "The North Crossing is witnessed. Edda can compare your family and archive evidence at the survey desk.")
 game.save_game();game.update_hud();game.queue_redraw();layer.queue_free()
