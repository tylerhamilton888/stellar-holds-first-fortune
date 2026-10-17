class_name HoldSound
extends Node
# Explicit manifest: imported audio filenames are not enumerable in every PCK.
const AUDIO_FILES=["thermal_pulse", "carbine", "parry", "amb_forge", "amb_hall", "amb_hearth", "amb_mine", "amb_road", "amb_study", "break_crystal", "break_earth", "break_rock", "build", "coal_0", "coal_1", "coal_2", "coin", "crystal", "crystal_0", "crystal_1", "crystal_2", "door", "earth", "earth_0", "earth_1", "earth_2", "hold_at_dusk", "latch", "metal", "metal_0", "metal_1", "metal_2", "pickup", "quest", "step_gravel_0", "step_gravel_1", "step_gravel_2", "step_stone_0", "step_stone_1", "step_stone_2", "step_wood_0", "step_wood_1", "step_wood_2", "stone", "stone_0", "stone_1", "stone_2", "swing", "winch", "wood"]
signal audio_event(id:String)
var voice:AudioStreamPlayer
var duck:Tween
var music:AudioStreamPlayer
var music_layers:Array[AudioStreamPlayer]=[]
var ambience_layers:Array[AudioStreamPlayer]=[]
var effects:Array[AudioStreamPlayer]=[]
var streams:Dictionary={}
var context=""
var music_track=""
var ambience_track=""
var music_slot=0
var ambience_slot=0
var music_fade:Tween
var ambience_fade:Tween
var last_variant:Dictionary={}
var last_pickup=-1.0
var elapsed=0.0
func _ready():
 for bus in ["ScoreDuck","Music","Ambience","Effects","Footsteps","Dialogue"]:
  if AudioServer.get_bus_index(bus)<0:
   AudioServer.add_bus();AudioServer.set_bus_name(AudioServer.bus_count-1,bus)
 if AudioServer.get_bus_effect_count(0)==0:
  var limiter=AudioEffectLimiter.new();limiter.ceiling_db=-1.0;limiter.threshold_db=-2.0;limiter.soft_clip_db=0.0
  AudioServer.add_bus_effect(0,limiter)
 AudioServer.set_bus_send(AudioServer.get_bus_index("Music"),"ScoreDuck")
 voice=AudioStreamPlayer.new();voice.bus="Dialogue";add_child(voice);voice.finished.connect(stop_voice)
 for i in 2:
  var m=AudioStreamPlayer.new();m.bus="Music";add_child(m);music_layers.append(m)
  var a=AudioStreamPlayer.new();a.bus="Ambience";add_child(a);ambience_layers.append(a)
 music=music_layers[0]
 for id in AUDIO_FILES:
  streams[id]=load("res://audio/"+id+".wav")
 for id in ["score_oath","score_hold","score_mine","score_road","air_real","machine_real"]:
  streams[id]=load("res://audio/"+id+".ogg")
 for family in [["pick_real",6],["dig_real",3],["step_real",4],["rubble_real",2]]:
  for i in family[1]:
   var id=family[0]+"_"+str(i);streams[id]=load("res://audio/"+id+".wav")
 for id in ["door_real","door_close_real"]:streams[id]=load("res://audio/"+id+".wav")
 for i in 16:
  var p=AudioStreamPlayer.new();p.bus="Effects";add_child(p);effects.append(p)
 mix(.65,.8,.9)
 set_context("title")
func _process(dt):
 elapsed+=dt
 if voice.playing or voice.stream_paused:
  voice.stream_paused=get_parent().panel_id in ["pause","settings"] if "panel_id" in get_parent() else false
 if music and music.playing and music.stream.get_length()-music.get_playback_position()<1.5 and (not music_fade or not music_fade.is_running()):
  start_music(music_track)
func loop_stream(id:String)->AudioStream:
 var stream=streams[id].duplicate()
 if stream is AudioStreamOggVorbis:stream.loop=true
 else:
  stream.loop_mode=AudioStreamWAV.LOOP_FORWARD;stream.loop_begin=0
  stream.loop_end=stream.data.size()/(4 if stream.stereo else 2)
 return stream
func start_music(song:String):
 music_track=song
 if music_fade:music_fade.kill()
 var old=music_layers[music_slot];music_slot=1-music_slot;music=music_layers[music_slot]
 music.stream=streams[song];music.volume_db=-60;music.play()
 music_fade=create_tween().set_parallel(true)
 fade_player(music_fade,old,0.0,1.4)
 fade_player(music_fade,music,db_to_linear(-6.0 if context!="mine" else -11.0),1.4)
 music_fade.chain().tween_callback(old.stop)
func set_duck(db:float,seconds:float):
 if duck:duck.kill()
 var bus=AudioServer.get_bus_index("ScoreDuck")
 duck=create_tween();duck.tween_method(func(v):AudioServer.set_bus_volume_db(bus,v),AudioServer.get_bus_volume_db(bus),db,seconds)
func stop_voice():
 if voice:voice.stop();voice.stream_paused=false
 set_duck(0.0,.5)
func set_context(place:String):
 if context==place:return
 context=place
 var song="score_oath" if place=="title" else ("score_mine" if place=="mine" else ("score_road" if place in ["road","approach","claim"] else "score_hold"))
 var bed={"training":"machine_real","throne":"amb_hall","title":"amb_hall","hub":"amb_hall","claim":"air_real","road":"air_real","approach":"air_real","mine":"amb_mine","home":"amb_hearth","tavern":"amb_hearth","forge":"machine_real","forge_cold":"amb_study","market":"amb_hall","commission":"amb_study","research":"amb_study"}.get(place,"amb_hall")
 if song!=music_track:start_music(song)
 if bed!=ambience_track:
  ambience_track=bed
  if ambience_fade:ambience_fade.kill()
  var old=ambience_layers[ambience_slot];ambience_slot=1-ambience_slot
  var next=ambience_layers[ambience_slot];next.stream=loop_stream(bed);next.volume_db=-60;next.play()
  ambience_fade=create_tween().set_parallel(true)
  fade_player(ambience_fade,old,0.0,2.5)
  fade_player(ambience_fade,next,db_to_linear(ambience_gain(bed)),2.5)
  ambience_fade.chain().tween_callback(old.stop)
func ambience_gain(id:String)->float:
 return {"air_real":-16.0,"machine_real":-18.0,"amb_mine":7.0,"amb_hearth":8.0,"amb_hall":0.0,"amb_study":1.0}.get(id,-4.0)
func fade_player(tween:Tween,player:AudioStreamPlayer,target:float,seconds:float):
 # Fade amplitude, not decibels: a dB ramp caused a deep audible hole at midpoint.
 tween.tween_method(func(v):player.volume_db=linear_to_db(maxf(v,.000001)),db_to_linear(player.volume_db),target,seconds)
func variant(id:String,count:int=3)->String:
 var next=randi_range(0,count-1)
 if next==last_variant.get(id,-1):next=(next+1)%count
 last_variant[id]=next
 return id+"_"+str(next)
func impact(kind:int,broken:bool):
 var dirt=kind in [1,9,10,12]
 effect(variant("dig_real",3) if dirt else variant("pick_real",6),-3.0)
 # Restrained material accents share the exact contact event; never loop.
 if kind in [3,4]:effect(variant("metal",3),-23)
 elif kind==6:effect(variant("crystal",3),-22)
 if broken and not dirt:effect(variant("rubble_real",2),-10)
func footstep(_surface:String):effect(variant("step_real",4),-12)
func effect(id:String,gain:float=-8):
 if id=="pickup":
  if elapsed-last_pickup<.1:return
  last_pickup=elapsed
 if not streams.has(id):return
 for p in effects:
  if not p.playing:
   p.bus="Footsteps" if id.begins_with("step_") else "Effects";p.stream=streams[id];p.pitch_scale=1.0 if id in ["door_real","door_close_real"] else randf_range(.98,1.02);p.volume_db=gain;p.play();audio_event.emit(id);return
func set_level(bus:String,value:float):
 var index=AudioServer.get_bus_index(bus)
 if index<0:return
 value=clampf(value,0,1)
 AudioServer.set_bus_mute(index,value<=0)
 AudioServer.set_bus_volume_db(index,linear_to_db(maxf(value,.0001)))
func volume(v:float):set_level("Master",v)
func mix(score:float,environment:float,foley:float,steps:float=.8,dialogue:float=1.0):
 for pair in [["Music",score],["Ambience",environment],["Effects",foley],["Footsteps",steps],["Dialogue",dialogue]]:set_level(pair[0],pair[1])
func stop_all():
 if duck:duck.kill()
 if voice:voice.stop();voice.stream=null
 AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ScoreDuck"),0)
 context="";music_track="";ambience_track=""
 if music_fade:music_fade.kill()
 if ambience_fade:ambience_fade.kill()
 for p in music_layers+ambience_layers+effects:
  if is_instance_valid(p):p.stop();p.stream=null
func _exit_tree():stop_all()
