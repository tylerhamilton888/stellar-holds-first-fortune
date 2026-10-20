extends "res://tests/support/game_fixture.gd"
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.appearance.sculpt=4;g.state.claim_id="old_delving";g.state.add("iron",13);g.surface.enter("claim");settle();g.state.add("wood",20);g.state.add("stone",20)
 g.player=Vector2(940,660);g.handworks.build("breaker",Vector2(940,600));g.save_game()
 var path=g.state.save_path();var legacy=JSON.parse_string(FileAccess.get_file_as_string(path));legacy.surface.erase("folk_revision")
 var text=JSON.stringify(legacy);var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(text);f.close()
 var inventory=g.state.inventory.duplicate(true);var structures=g.handworks.data().facilities.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==inventory and g.state.claim_id=="old_delving" and g.state.opening==4,"Pre-reference save retains inventory, charter and quest progression")
 check(g.state.appearance.sculpt==4 and g.handworks.data().facilities==structures,"Existing appearance selector and player workstations survive additive upgrade")
 var exact=false
 for name in DirAccess.get_files_at("user://"):
  if name.begins_with(path.get_file()+".pre-folk-54-") and FileAccess.get_file_as_string("user://"+name)==text:exact=true
 check(exact,"Original pre-reference save is preserved byte for byte in a separate backup")
 check(g.state.surface.folk_revision==54,"Loaded save records completed additive visual upgrade")
 g.save_game();var backups=0
 for name in DirAccess.get_files_at("user://"):
  if name.begins_with(path.get_file()+".pre-folk-54-"):backups+=1
 g.start_game(true);settle();var after=0
 for name in DirAccess.get_files_at("user://"):
  if name.begins_with(path.get_file()+".pre-folk-54-"):after+=1
 check(after==backups,"Reloading upgraded save does not create redundant migration backups")
 print("SAVE54: ",passed," passed / ",failed," failed");g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
