extends SceneTree
var g
var passed=0
var failed=0
var output="res://docs/testing/reference-0.54.0/journey"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.pressed=true;g._unhandled_input(e)
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func snap(name:String):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud();g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func at(p:Vector2):g.player=p;g.camera=g.surface.camera_target();g.notice_time=0
func button(prefix:String):
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.begins_with(prefix) or b.text.trim_prefix("◆  ").trim_prefix("›  ").begins_with(prefix):b.pressed.emit();return
 failed+=1;push_error("Missing button "+prefix)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(g.state.npc("orla").name=="Orla Copperkettle" and g.state.npc("hedrik").family_name=="Copperkettle","Exported cast names agree")
 g.surface.enter("hearthward",Vector2(1090,700));settle();await snap("fountain")
 var water0=root.get_texture().get_image().get_data();g.clock+=.29;await snap("fountain-motion")
 check(water0!=root.get_texture().get_image().get_data(),"Exported fountain animates on the native renderer")
 check(not g.surface.walkable(Vector2(970,635)) and g.surface.walkable(Vector2(1080,680)),"Exported basin collision and adjacent path agree with the art")
 g.surface.enter("room:home");settle();await snap("fire")
 var fire0=root.get_texture().get_image().get_data();g.clock+=.29;await snap("fire-motion")
 check(fire0!=root.get_texture().get_image().get_data(),"Exported painted hearth animates")
 var fire1=root.get_texture().get_image().get_data();await snap("fire-paused")
 check(fire1==root.get_texture().get_image().get_data(),"Exported hearth is stationary without advancing simulation time")
 g.surface.enter("room:market");settle();HoldConversation.start(g,"orla");await snap("orla")
 var names=[]
 for n in g.panel.find_children("*","Label",true,false):names.append(n.text)
 check(names.any(func(s):return s.contains("Orla Copperkettle")),"Actual exported Orla dialogue displays her married name")
 g.close_panel();g.opening_scene=HoldArrivalEscort.start(g);var scene=g.opening_scene;scene.set_process(false);scene.age=1;scene.advance()
 var before=g.player;scene.tick(.2);check(g.player==before,"Exported escort waits for asset preparation")
 settle();var keys={};var guide_keys={}
 for i in 90:
  scene.tick(1.0/60)
  keys[HoldWholeFrames.descriptor(g.state.appearance,g.surface.direction,g.walking_pose,g.gait_clock,"",0).index]=true
  guide_keys[HoldWholeFrames.descriptor(g.state.npc("ivar"),scene.guide_direction,scene.ivar_walking,scene.guide_gait,"",0).index]=true
 check(g.player!=before and keys.size()>=4 and guide_keys.size()>=4,"Exported escort moves both actors with changing painted frames")
 await snap("escort");scene.finish();await process_frame;settle()
 var q=HoldOnboarding.ensure(g.state);q.stage=4;q.fresh=true;g.state.opening=2
 g.surface.enter("room:throne");settle();g.opening_scene=HoldOpeningScene.begin(g,"audience");scene=g.opening_scene;scene.set_process(false);scene.shot_age=1
 check(scene!=null,"Royal audience opens with the existing progression gate")
 keys={};guide_keys={};before=g.player;var king_start=scene.king.p
 scene.step=1;scene.show_line();scene.shot_age=1
 for i in 180:
  scene.age+=1.0/60
  scene.update_staging(1.0/60)
  if g.walking_pose:keys[HoldWholeFrames.descriptor(g.state.appearance,g.surface.direction,true,g.gait_clock,"",0).index]=true
  if scene.king.moving:guide_keys[scene.king.gait]=true
 check(g.surface.area=="room:throne" and g.player.y<before.y and keys.size()>=2 and scene.king.p.y>king_start.y and guide_keys.size()>1,"Exported top-down audience moves the petitioner and King with advancing walk poses")
 await snap("audience");scene.finish();await process_frame;settle()
 var inventory=g.state.inventory.duplicate(true);g.save_game();g.start_game(true);settle()
 check(g.state.inventory==inventory and g.state.npc("orla").family_name=="Copperkettle","Exact pack reload preserves inventory and the married surname")
 print("PACK AMBIENT61: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;await process_frame;quit(1 if failed else 0)
