extends "res://tests/input_surface49.gd"
func run():
 output="res://docs/testing/world-0.50.0";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/title.png")
 g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 g.state.add("iron",17);g.state.tech.automation=true;g.state.worker=true;g.state.automaton=true
 g.state.surface.chests["claim:old_delving:starter"].items={"stone":27}
 g.surface.enter("hearthward");settle();g.save_game()
 var path=g.state.save_path();var f=FileAccess.open(path,FileAccess.READ);var old=JSON.parse_string(f.get_as_text());f.close()
 old.surface.erase("world_layout");old.surface.positions.hearthward=[1630,390]
 var bytes=JSON.stringify(old);f=FileAccess.open(path,FileAccess.WRITE);f.store_string(bytes);f.close()
 g.start_game(true);settle()
 check(g.state.surface.world_layout==50 and g.surface.walkable(g.player),"Old ward coordinates migrate to a clear arrival")
 check(g.state.surface.legacy_positions.hearthward==[1630.0,390.0],"Original ward coordinates retained as migration evidence")
 check(JSON.parse_string(JSON.stringify(g.state.inventory))==old.inventory and g.state.money==old.money and g.state.tech==old.tech,"Migration preserves inventory money and technology")
 check(g.state.surface.chests==old.surface.chests and g.state.surface.homes==old.surface.homes,"Migration preserves player storage and home data")
 check(g.state.worker and g.state.automaton and g.state.hauling==old.hauling,"Migration preserves workers automaton and physical cargo assignments")
 var exact=false
 for name in DirAccess.get_files_at("user://"):
  if name.contains("pre-world-50"):
   var backup=FileAccess.open("user://"+name,FileAccess.READ)
   if backup.get_as_text()==bytes:exact=true
 check(exact,"Exact old save bytes preserved before migration autosave")
 g.surface.enter("crownward",Vector2(1100,570));settle();g.save_game();g.start_game(true);settle()
 check(g.surface.area=="crownward" and g.player==Vector2(1100,570),"Current ward and exact position survive new-layout reload")
 g.surface.world.speak(0);await snap("citizen-directions")
 check(g.panel_id=="" and g.surface.world.speech!="","Citizen directions are nonmodal and leave movement available")
 print("WORLD50 MIGRATION: ",passed," passed / ",failed," failed");g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
