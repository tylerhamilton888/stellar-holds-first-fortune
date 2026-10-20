extends SceneTree
var game
var good=0
var bad=0
func check(ok:bool,msg:String):
 if ok:good+=1
 else:bad+=1;push_error(msg)
func _initialize():call_deferred("run")
func run():
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false)
 var s=game.sound
 check(AudioServer.get_bus_send(AudioServer.get_bus_index("Music"))=="ScoreDuck","Music routes through dialogue ducking")
 check(AudioServer.get_bus_index("ScoreDuck")<AudioServer.get_bus_index("Music"),"Ducking route is upstream in Godot bus order")
 check(s.voice.bus=="Dialogue","Voice has its own bus")
 check(AudioServer.get_bus_effect(0,0) is AudioEffectLimiter and AudioServer.is_bus_effect_enabled(0,0),"Master limiter is active")
 for pair in [["Music",0],["Ambience",1],["Effects",2],["Footsteps",3],["Dialogue",4]]:
  var levels=[.65,.8,.9,.8,1.0];levels[pair[1]]=0;s.mix(levels[0],levels[1],levels[2],levels[3],levels[4])
  for bus in ["Music","Ambience","Effects","Footsteps","Dialogue"]:check(AudioServer.is_bus_mute(AudioServer.get_bus_index(bus))==(bus==pair[0]),"Mute isolation: "+pair[0]+" / "+bus)
 s.mix(.65,.8,.9,.8,1);s.volume(0);check(AudioServer.is_bus_mute(0),"Master zero truly mutes");s.volume(.6)
 s.footstep("stone");var found=false
 for p in s.effects:
  if p.playing and p.bus=="Footsteps":found=true
 check(found,"Footstep player routes to independent bus")
 s.effect("pick_real_0");found=false
 for p in s.effects:
  if p.playing and p.bus=="Effects":found=true
 check(found,"Tool routes to effects bus")
 s.set_context("title");await create_timer(1.6).timeout
 var old=s.music;s.set_context("mine");await create_timer(.7).timeout
 var sum=db_to_linear(old.volume_db)/db_to_linear(-6)+db_to_linear(s.music.volume_db)/db_to_linear(-11)
 check(sum>.85 and sum<1.15,"Crossfade does not create a midpoint volume hole")
 check(s.ambience_gain("machine_real")<=-16 and s.ambience_gain("air_real")<=-14,"Loud ambient recordings are attenuated")
 game.state.footsteps_volume=.25;game.state.dialogue_volume=.75;game.state.music_volume=0;game.state.save_audio_settings()
 var prefs=HoldState.new();prefs.load_audio_settings();check(prefs.footsteps_volume==.25 and prefs.dialogue_volume==.75 and prefs.music_volume==0,"Independent audio preferences persist without a world save")
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.accept_employment();game.open_panel("pause");s._process(.1);check(not s.voice.playing,"Written welcome remains silent through pause")
 game.resume_adventure();s._process(.1);check(game.panel_id=="ivar_welcome" and not s.voice.stream_paused,"Resume returns to written advice without starting speech")
 game.close_panel();s.stop_all();game.playing=false;game.queue_free();await process_frame
 print("AUDIO24: %d passed; %d failed" % [good,bad]);quit(1 if bad else 0)
