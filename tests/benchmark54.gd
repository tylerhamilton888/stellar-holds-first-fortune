extends SceneTree
var g
func _initialize():call_deferred("run")
func run():
 var loading=Time.get_ticks_usec()
 g=load("res://main.tscn").instantiate();root.add_child(g);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false;g.state.opening=4
 while g.state.elapsed<.04:await process_frame
 print("LOAD_MS ",(Time.get_ticks_usec()-loading)/1000.0)
 for lap in 2:
  var samples=[];var calls=[];var last=Time.get_ticks_usec()
  for i in 420:
   g.player=Vector2(230+fmod(i*4.0,1430.0),580);g.surface.direction=Vector2.RIGHT;g.walking_pose=true
   await process_frame
   var now=Time.get_ticks_usec();samples.append((now-last)/1000.0);last=now
   calls.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
  samples.sort();calls.sort()
  print("BENCH ",lap," ",JSON.stringify({"frames":samples.size(),"p50_ms":samples[210],"p95_ms":samples[399],"p99_ms":samples[415],"max_ms":samples[-1],"draw_calls_p95":calls[399]}))
 g.sound.stop_all();g.queue_free();await process_frame;quit()
