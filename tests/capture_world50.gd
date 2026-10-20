extends "res://tests/input_surface49.gd"
func run():
 output="res://docs/testing/world-0.50.0";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for id in ["hearthward","crownward","forgeward"]:
  g.surface.enter(id,Vector2(960,570));settle();await snap(id)
 for id in ["tavern","commission","forge","throne","home","market","research"]:
  g.surface.enter("room:"+id);settle();await snap(id)
 g.surface.enter("trail",Vector2(1220,700));settle();await snap("bridge")
 print("WORLD CAPTURE COMPLETE");g.playing=false;g.queue_free();await process_frame;quit()
