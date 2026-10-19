extends "res://tests/input_reference54.gd"
func run():
 output="res://docs/testing/quality58/play";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 g.open_creator(true);g.creator.profile.sculpt=5;g.creator.profile.hair_color=3;g.creator.rebuild_options();g.creator.update_preview()
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/creator-bearded.png")
 check(g.creator.portrait.profile.beard_style!=5,"Creator represents moustache identity with a full beard")
 g.creator.queue_free();await process_frame
 g.skip_arrival=true;g.start_game(false);g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving"
 g.state.appearance=HoldAppearance.normalized({"sculpt":5,"hair_color":3,"beard_style":5,"first_name":"Ulrik","family_name":"Copperbraid"})
 g.surface.enter("claim");settle();g.player=Vector2(650,850)
 for n in 7:
  check(HoldAppearance.normalized({"sculpt":n,"beard_style":5}).beard_style!=5,"Male identity retains a beard: "+str(n))
 check(HoldAppearance.normalized({"gender":1,"sculpt":5}).beard_style==5,"Female identity is preserved")
 for tool in [0,2,3,5]:
  g.hotbar.select(tool,false)
  for direction in ["right","left","up","down"]:
   var start=g.player;Input.action_press(direction);await frames(12);Input.action_release(direction)
   check(g.player.distance_to(start)>20,"Responsive bearded movement: %d / %s"%[tool,direction])
  await snap("tool-%d"%tool)
 g.state.add("iron_ore",11);g.state.money=123
 var keep=g.state.inventory.duplicate(true);var profile=g.state.appearance.duplicate(true)
 g.save_game()
 # Exercise the previous moustache-only appearance in a real saved slot.
 var path=g.state.save_path();var raw=JSON.parse_string(FileAccess.get_file_as_string(path));raw.appearance.beard_style=5
 var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(JSON.stringify(raw));f.close()
 g.start_game(true);settle()
 check(g.state.appearance==profile,"Old moustache save keeps exact identity and palette with corrected beard")
 check(g.state.inventory==keep and g.state.money==123 and g.state.claim_id=="old_delving","Appearance correction preserves inventory, money and claim")
 await snap("reloaded-bearded")
 g.surface.enter("hearthward");settle();await snap("keldrath-bearded")
 g.surface.enter("room:tavern");settle();await frames(100);await snap("tavern-bearded")
 g.surface.enter("room:throne");settle();await snap("throne-preserved")
 print("BEARD QUALITY58: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
