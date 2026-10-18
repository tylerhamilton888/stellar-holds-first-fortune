extends "res://tests/input_surface49.gd"
func run():
 output="res://docs/testing/world-0.50.0/final";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for sample in [["hearthward",Vector2(1450,840),"foreman"],["hearthward",Vector2(180,880),"royal-stair"],["forgeward",Vector2(1700,880),"forge-stair"],["hearthward",Vector2(1270,960),"kings-gate"],["forgeward",Vector2(1250,490),"practice-hall"],["crownward",Vector2(960,500),"royal-hall"],["trail",Vector2(220,720),"trail-gate"]]:
  g.surface.enter(sample[0],sample[1]);settle();await snap(sample[2])
 print("FINAL WORLD VIEWS COMPLETE");g.playing=false;g.queue_free();await process_frame;quit()
