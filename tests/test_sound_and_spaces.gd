extends SceneTree
var failed=0
var passed=0
func check(ok:bool,message:String):
 if ok:passed+=1;print("PASS: "+message)
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game)
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.set_process(false);game.close_panel()
 for id in ["score_oath","score_mine","score_hold","amb_mine","amb_hearth","break_rock","stone_0","coal_2","door","pickup"]:
  check(game.sound.streams.has(id),"Audio asset loaded: "+id)
 var stream=game.sound.loop_stream("score_oath")
 check(stream.stereo and stream.loop_end==stream.data.size()/4,"Stereo music loop ends on the correct frame")
 var previous=""
 for i in 20:
  var next=game.sound.variant("stone");check(next!=previous,"Consecutive strikes use distinct takes");previous=next
 game.state.opening=1
 for id in HoldInteriors.ROOMS:
  game.player=Vector2(1205,410);game.zone="hub";game.enter_room(id)
  check(game.room_id==id and game.sound.context==("forge_cold" if id=="forge" else id),"Entering "+id+" changes space and sound")
  game.player.x=625;game.interact()
  check(game.panel_id==id,"Workbench interaction opens "+id)
  game.close_panel();game.save_game()
  var restored=HoldState.new();var d=restored.load_world(Geology.new())
  check(d.pos==Vector2(1205,410),"Interior save resumes safely at its exterior doorway")
  game.player.x=115;game.interact()
  check(game.room_id=="" and game.player==Vector2(1205,410),"Door exits to the same exterior position")
 game.state.music_volume=.25;game.state.ambience_volume=.4;game.state.effects_volume=.75;game.save_game()
 var settings=HoldState.new();settings.load_world(Geology.new())
 check(settings.music_volume==.25 and settings.ambience_volume==.4 and settings.effects_volume==.75,"Separate mixer levels survive save/load")
 game.state.opening=0;game.open_panel("briefing");game.briefing_topic="charter";game.refresh_panel()
 check(game.state.opening==0,"Asking about a charter does not accept employment")
 game.accept_employment();check(game.state.opening==1 and game.panel_id=="ivar_welcome","Accepting employment starts first commission")
 game.accept_employment();check(game.state.opening==1,"Repeated acceptance cannot advance commissions")
 game.change_zone("mine");game.geo.generate(27419);game.geo.cells.fill(0);game.player=Vector2(150,370)
 game.hit_cell=Vector2i(26,50);game.hit_point=Vector2(182.1,353.5);game.tool=0
 game.geo.set_cell(game.hit_cell,3);game.geo.grain_bank.iron_ore=14
 var key=game.geo.key(game.hit_cell)
 game.hit_terrain()
 check(float(game.geo.damage.get(key,0))>0 and game.impact_pause>0,"Contact creates persistent cracks and a brief impact pause")
 game.geo.set_cell(Vector2i(24,49),2)
 var damage=float(game.geo.damage[key]);game.hit_terrain()
 check(game.geo.damage[key]==damage,"Intervening rock blocks a queued strike")
 game.geo.set_cell(Vector2i(24,49),0)
 var before=game.state.count("iron_ore")
 game.hit_terrain()
 check(game.geo.at(26,50)==0 and game.drops.size()==1,"Completing a resource unit creates exactly one drop")
 game.update_effects(.1)
 check(game.state.count("iron_ore")==before,"Fragments scatter before attraction")
 game.save_game()
 check(game.drops.is_empty() and game.state.count("iron_ore")==before+1,"Saving during fragment motion collects exact yield")
 game.update_effects(1)
 check(game.state.count("iron_ore")==before+1,"Flushed fragments cannot duplicate resources")
 game.hit_cell=Vector2i(25,50);game.hit_point=Vector2(175.1,353.5)
 game.geo.set_cell(game.hit_cell,3);game.geo.grain_bank.iron_ore=14
 game.hit_terrain();game.hit_terrain()
 for i in 15:game.update_effects(.1)
 check(game.state.count("iron_ore")==before+2 and game.drops.is_empty(),"Scattered resources return to the player normally")

 game.playing=false;game.sound.stop_all();await create_timer(.3).timeout;game.queue_free();await process_frame
 print("%d SOUND / SPACES / MINING CHECKS PASSED; %d FAILED" % [passed,failed]);quit(1 if failed else 0)
