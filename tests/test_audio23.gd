extends SceneTree
var game
var events:Array=[]
var passed=0
var failed=0
func check(ok:bool,msg:String):
 if ok:passed+=1
 else:failed+=1;push_error(msg)
func _initialize():call_deferred("run")
func run():
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel()
 game.sound.audio_event.connect(func(id):events.append(id))
 for id in ["score_oath","score_hold","score_road","score_mine","air_real","machine_real"]:
  check(game.sound.streams.has(id) and game.sound.streams[id].get_length()>8,"Uploaded track loaded: "+id)
 for pair in [["title","score_oath"],["hub","score_hold"],["approach","score_road"],["mine","score_mine"]]:
  game.sound.set_context(pair[0]);check(game.sound.music_track==pair[1],"Location selects supplied music")
 check(game.sound.loop_stream("air_real").loop,"Atmosphere is looped")
 game.zone="hub";game.room_id="";game.player=Vector2(500,410);game.velocity=Vector2.ZERO;game.grounded=true;game.swing=0;game.combat.reset_actions();game.combat.armed=false
 Input.action_press("right")
 for i in 120:
  var prior=events.size();game.move_player_step(1.0/120)
  if events.size()>prior:
   check(posmod(int(game.gait_clock*12),8) in [2,6],"Footfall occurs on shared sprite contact frame")
 Input.action_release("right")
 check(events.size()>=2,"Walking produces footsteps")
 game.velocity=Vector2.ZERO;events.clear()
 for i in 20:game.move_player_step(1.0/120)
 check(events.is_empty(),"Standing still produces no footsteps")
 game.player.y=200;game.grounded=false;game.velocity=Vector2(190,0);Input.action_press("right");events.clear()
 game.move_player_step(.05);Input.action_release("right");check(events.is_empty() and not game.walking_pose,"Airborne movement produces neither footfalls nor walking pose")
 game.zone="mine";game.geo.generate(27419);game.geo.cells.fill(0);game.player=Vector2(150,370);game.hit_cell=Vector2i(26,50);game.hit_point=Vector2(182.1,353.5);game.tool=0;game.geo.set_cell(game.hit_cell,3)
 game.swing_duration=.38;game.swing=.38;game.swing_done=false;events.clear()
 game.handle_mining(.1);check(events.is_empty(),"Windup is silent until contact")
 game.handle_mining(.13);check(events.filter(func(id):return id.begins_with("pick_real")).size()==1 and events[0].begins_with("pick_real"),"Pick sound fires exactly once at terrain contact")
 check(HoldCharacterArt.action_frame(1-game.swing/game.swing_duration,0)==4,"Audible contact is the tool-head contact drawing")
 var count=events.size();game.handle_mining(.02);check(events.size()==count,"Recovery does not retrigger impact")
 game.player=Vector2(800,200);game.swing=.38;game.swing_done=false;events.clear();game.handle_mining(.25);check(events.is_empty(),"Out-of-reach swings do not play rock contact")
 game.close_panel();game.state.opening=0;game.accept_employment();check(game.panel_id=="ivar_welcome" and not game.sound.voice.playing,"First shift opens written welcome without voice")
 await create_timer(.4).timeout
 check(abs(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("ScoreDuck")))<.1,"Written welcome does not duck music")
 game.open_panel("pause");game.sound._process(.1);check(not game.sound.voice.playing,"Pause cannot start retired voice")
 game.back_panel();game.sound._process(.1);check(not game.sound.voice.stream_paused,"Back resumes welcome")
 game.close_panel();await create_timer(.6).timeout;check(not game.sound.voice.playing and abs(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("ScoreDuck")))<.1,"Skip stops voice and restores music")
 events.clear();game.begin_transition("TRAIL");check(events.is_empty(),"Open terrain transitions do not play door effects")
 game.zone="hub";game.enter_room("home");check(events.has("door_real"),"Entering room triggers opening sound")
 game.leave_room();check(events.has("door_close_real"),"Leaving room triggers closing sound")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame
 print("AUDIO23: %d passed; %d failed" % [passed,failed]);quit(1 if failed else 0)
