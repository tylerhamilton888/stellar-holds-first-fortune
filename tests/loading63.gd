extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 await snap("title")
 check(not g.playing and not g.loading_view.visible,"Title opens without a loading obstruction")
 var pose=HoldWholeFrames.descriptor(g.state.appearance,Vector2(-1,.45),false,0,"hold_pick",0)
 check(pose.sheet.ends_with("-motion"),"Title uses current whole-character held-pick frame")
 seed(63012);g.open_creator(true)
 var generated=g.creator.profile.duplicate(true)
 check(generated!=HoldAppearance.defaults() and generated==HoldAppearance.normalized(generated),"New fortune starts with a randomized valid identity")
 check(g.creator.name_input.text==generated.first_name and g.creator.family_input.text==generated.family_name,"Generated names populate editable creation fields")
 await snap("creator")
 g.skip_arrival=false;g.creator.accepted.emit(generated)
 check(g.state.appearance==generated,"Accepted generated identity becomes the player")
 check(HoldFolk.warming(),"New fortune queues real animation preparation")
 var before=g.player;key(KEY_E)
 check(g.player==before,"Loading blocks gameplay input")
 var cold_start=Time.get_ticks_msec();var cold_jobs=HoldWholeFrames.warm_jobs.size()
 for i in 30:HoldFolk.warm_step()
 for i in 6:await process_frame
 await snap("loading")
 check(g.loading_view.visible and g.loading_view.get_parent().layer==100,"Loading art covers both HUD and the Ivar cutscene")
 var last=HoldWholeFrames.progress();var started=cold_start
 while HoldFolk.warming():
  HoldFolk.warm_step()
  check_progress(last)
  last=HoldWholeFrames.progress()
  await process_frame
 print("COLD PREPARATION MS: ",Time.get_ticks_msec()-started," / FRAMES: ",cold_jobs)
 check(HoldWholeFrames.progress()==1.0,"Actual preparation reaches completion")
 for i in 30:await process_frame
 check(not g.loading_view.visible,"Loading overlay clears after preparation")
 check(is_instance_valid(g.opening_scene),"Opening scene survives animation preparation")
 await snap("opening")
 var p=g.state.appearance;var a=HoldWholeFrames.descriptor(p,Vector2.DOWN,false,0,"",0)
 var first=HoldWholeFrames.texture(p,a.sheet,a.index).get_image()
 HoldWholeFrames.cache.clear();HoldWholeFrames.order.clear();var hits=HoldWholeFrames.disk_hits
 var second=HoldWholeFrames.texture(p,a.sheet,a.index).get_image()
 check(HoldWholeFrames.disk_hits==hits+1,"Prepared animation reloads from persistent cache")
 check(first.get_data()==second.get_data(),"Cached pixels preserve skin, hair and clothing exactly")
 HoldWholeFrames.cache.clear();HoldWholeFrames.order.clear();HoldWholeFrames.prepare(g)
 var cached_start=Time.get_ticks_msec();var jobs=HoldWholeFrames.warm_jobs.size();var cache_hits=HoldWholeFrames.disk_hits
 while HoldFolk.warming():HoldFolk.warm_step();await process_frame
 print("CACHED PREPARATION MS: ",Time.get_ticks_msec()-cached_start," / FRAMES: ",jobs)
 check(HoldWholeFrames.disk_hits-cache_hits==jobs,"Entire second preparation uses persisted frames")
 HoldWholeFrames.cache.clear();HoldWholeFrames.order.clear()
 g.opening_scene.age=1;g.opening_scene.finish();await process_frame
 check(g.opening_scene is HoldArrivalEscort,"Opening hands off to the real Ivar escort")
 var guide=g.opening_scene.guide
 for i in 6:await process_frame
 check(HoldFolk.warming() and g.opening_scene.guide==guide,"Ivar waits while his new area is preparing")
 await snap("ivar-loading")
 while HoldFolk.warming():HoldFolk.warm_step();await process_frame
 for i in 30:await process_frame
 await snap("ivar")
 check(not g.loading_view.visible,"Escort is unobstructed once its frames are ready")
 g.opening_scene.finish();await process_frame;settle()
 g.open_creator(false)
 check(g.creator.profile==generated,"Existing character wardrobe does not reroll identity")
 g.creator.cancelled.emit();g.save_game()
 g.start_game(true);settle()
 check(g.state.appearance==generated,"Save and reload preserve the randomized name and appearance")
 print("LOADING63: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
func check_progress(previous:float):
 if HoldWholeFrames.progress()<previous:failed+=1;push_error("Progress went backwards")
