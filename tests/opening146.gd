extends "res://tests/support/game_fixture.gd"

func has_label(fragment:String)->bool:
 for label in g.panel_body.find_children("*","Label",true,false):
  if fragment in label.text:return true
 return false

func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 g.state.save_slot=2;g.first_visit_pending=true;g.start_game(false)
 while HoldFolk.warming():HoldFolk.warm_step()
 var q=HoldFirstVisit99.data(g.state)
 check(g.opening_scene is HoldOpeningScene and g.opening_scene.mode=="frontier_arrival","New Game begins with the Stonebridge scene")
 check(q.intro_pending and g.surface.area==HoldFrontier103.lodge(g.state),"Scene starts in the real lodge and records pending state")
 await snap("01-arrival")
 g.opening_scene.age=1.0;g.opening_scene.advance()
 check(int(q.intro_beat)==1,"Advancing saves the current beat")
 g.start_game(true)
 while HoldFolk.warming():HoldFolk.warm_step()
 check(is_instance_valid(g.opening_scene) and g.opening_scene.mode=="frontier_arrival" and g.opening_scene.step==1,"Reload resumes an unfinished introduction")
 g.opening_scene.age=1.0;g.opening_scene.advance();g.opening_scene.age=1.0;g.opening_scene.advance()
 await snap("01b-ivar-welcome")
 g.opening_scene.finish();await process_frame
 check(not is_instance_valid(g.opening_scene) and not HoldFirstVisit99.data(g.state).intro_pending and g.surface.area==HoldFrontier103.lodge(g.state),"Skipping returns control in the lodge")
 g.open_panel("commission")
 check(has_label("A word with Ivar") and not has_label("campaign foundations"),"First journal leads with one immediate task")
 await snap("02-first-journal");g.close_panel()
 g.open_panel("great_claim102")
 check(has_label("where Stonebridge records work") and not has_label("The North Crossing"),"The ledger begins with a short explanation")
 await snap("03-ledger-introduction");button("Browse the projects")
 check(has_label("The Cold Forge") and not has_label("The North Crossing"),"The first project is introduced before later work")
 button("+ Other town projects");check(has_label("The North Crossing"),"The full ledger remains available on request")
 g.close_panel();at(Vector2(480,500));g.open_panel("frontier103")
 check(has_label("Ivar’s shift book") and not has_label("Winter Stores"),"The first shift book introduces the worksite")
 button("Look through the rest");check(has_label("A town taking root"),"The rest of the shift book remains available")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene),"A completed introduction does not replay on reload")
 var s=g.state;HoldFirstVisit99.data(s).erase("intro_pending");g.save_game();g.start_game(true);settle()
 check(not is_instance_valid(g.opening_scene),"Older saves without intro state do not replay the scene")
 print("OPENING146: %d passed / %d failed" % [passed,failed]);g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
