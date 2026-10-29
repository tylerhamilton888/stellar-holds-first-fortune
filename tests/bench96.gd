extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 g.dev.start("exploration");settle();g.depth_nav.explore.preferred=false;g.combat.armed=false
 var h=g.handworks;var f={}
 for station in h.data().facilities:
  if h.local(station) and station.kind=="breaker":f=station
 check(not f.is_empty(),"Exploration preset supplies its workbench")
 var good=Vector2(f.x,f.y)
 f.y=740;g.player=Vector2(f.x,f.y+40)
 check(not h.working_space("breaker",Vector2(f.x,f.y)),"Old preset position blocks both working stances")
 h.data().carry=[{"id":999,"kind":"stone","units":4,"item":"iron_ore"}]
 key(KEY_E);Input.action_press("interact");h.update(.1)
 check(not f.job.is_empty() and float(f.job.progress)==0 and not h.working,"Blocked bench preserves loaded input without false progress")
 check(h.prompt().contains("Working position blocked"),"Blocked work explains the missing clearance")
 await snap("blocked-bench")
 Input.action_release("interact")
 f.x=good.x;f.y=good.y;g.player=good+Vector2(0,40);h.active_id=""
 var before=g.state.count("iron_ore")
 Input.action_press("interact")
 for i in 240:h.update(1.0/60)
 Input.action_release("interact")
 check(f.job.is_empty() and g.state.count("iron_ore")==before+4,"Holding E approaches the repaired bench and returns the full ore yield exactly once")
 await snap("overhead-bench")
 g.player=Vector2(820,780);var supplies=g.state.inventory.duplicate(true)
 h.data().facilities.erase(f)
 check(not h.build("breaker",Vector2(820,740)) and g.state.inventory==supplies,"Invalid working clearance refuses construction without charging materials")
 print("BENCH96: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
