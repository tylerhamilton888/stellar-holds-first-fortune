extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://royal79"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.surface.enter("hearthward");settle();at(HoldWorldZones.GATE+Vector2(0,45));await snap("00-gate-in-bedrock")
 for ward in HoldWorldZones.WARDS:
  g.surface.enter(ward);settle()
  for pos in [Vector2(760,550),Vector2(140,1300),Vector2(960,1100)]:
   at(pos);await snap("00-"+ward+"-"+str(int(pos.x)))
 var q=HoldOnboarding.ensure(g.state);q.fresh=true;q.stage=4;g.state.opening=2
 g.surface.enter("crownward");settle();g.surface.enter("room:throne");settle();g.state.elapsed=0
 check(g.surface.area=="room:throne","Earned royal hall is accessible")
 check(HoldRoomLayout.floor_rect("room:throne").size.y>700,"Royal hall has a full processional nave")
 for y in range(470,1040,25):check(g.surface.walkable(Vector2(650,y)),"Processional aisle clear at "+str(y))
 for r in HoldRoyalStage.obstacles():check(not g.surface.walkable(r.get_center()),"Royal architecture has a physical base")
 at(Vector2(650,660));await snap("01-grand-hall")
 at(Vector2(650,470));await snap("02-enthroned-king")
 g.state.elapsed=35;var point=HoldRoyalStage.current(g).p
 check(point==Vector2(650,585),"King leaves his throne and stands among petitioners")
 var found=false
 for p in g.surface.points():
  if p.action=="talk:eirik":found=p.p.distance_to(point)<60
 check(found,"Conversation marker follows the actual royal actor")
 at(Vector2(650,670));await snap("03-king-on-floor")
 g.opening_scene=HoldOpeningScene.begin(g,"audience");var scene=g.opening_scene;scene.set_process(false)
 check(is_instance_valid(scene),"Earned audience opens")
 for stage in [0,1,3,6]:
  scene.step=stage;scene.show_line();scene.age=0
  for i in 240:scene.age+=1.0/60;scene.update_staging(1.0/60)
  check(scene.staging_ready(),"Audience blocking completes for line "+str(stage))
  g.queue_redraw();scene.queue_redraw();await frames(1)
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output+"/04-audience-"+str(stage)+".png")
 check(scene.king.pose==14,"King settles back into his throne after the audience")
 scene.step=2;scene.show_line();scene.update_staging(1.0/60)
 check(g.player==Vector2(650,540),"Next speech keeps the petitioner in place instead of restarting the entrance")
 scene.step=3;scene.show_line();scene.update_staging(1.0/60)
 check(g.player==Vector2(650,540) and not g.walking_pose,"Dialogue advances without a teleport or false walk")
 scene.finish();await process_frame
 check(HoldOnboarding.stage(g.state)==5,"Audience advances existing commission progression once")
 check(g.surface.area=="room:throne" and not is_instance_valid(g.opening_scene),"Audience returns control in the same hall")
 check(g.surface.walkable(g.player),"Cinematic leaves player on clear walkable floor")
 var inv=g.state.inventory.duplicate(true);g.save_game();g.start_game(true);settle()
 check(JSON.stringify(g.state.inventory)==JSON.stringify(inv),"Royal staging preserves inventory across save/load")
 check(HoldOnboarding.stage(g.state)==5,"Audience completion survives reloading")
 g.surface.leave();settle();check(g.surface.area=="crownward","Southern hall door returns to Crownward")
 q=HoldOnboarding.ensure(g.state);q.stage=4;g.surface.enter("room:throne");settle()
 g.opening_scene=HoldOpeningScene.begin(g,"audience");scene=g.opening_scene;scene.set_process(false)
 scene.step=1;scene.show_line();scene.age=1.2;scene.update_staging(1.0/60)
 check(scene.king.moving and not scene.staging_ready(),"Entrance movement delays Continue while Skip stays available")
 scene.finish();scene.finish();await process_frame
 check(HoldOnboarding.stage(g.state)==5,"Skipping is safe and completion remains idempotent")
 check(HoldRoyalStage.current(g).pose==14,"King remains seated when cinematic control returns")
 check(not g.state.resident_visits.has("ivar"),"Temporary audience attendance is cleaned up")
 HoldRoyalStage.prepare()
 for i in 16:check(HoldRoyalStage.frames[i].size.y>200 and HoldRoyalStage.frames[i].size.x>170,"Complete royal silhouette retained in key "+str(i))
 print("ROYAL79: ",passed," passed / ",failed," failed");g.sound.stop_all();g.queue_free();await process_frame;quit(0 if failed==0 else 1)
