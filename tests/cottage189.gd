extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.first_visit_pending=true;g.start_game(false);settle()
 if is_instance_valid(g.opening_scene):g.opening_scene.finish()
 g.surface.enter("claim",Vector2(2300,1160));settle()
 var h=g.surface.house;var door="57,27";var outside=h.center(Vector2i(57,28));var landing=h.center(Vector2i(57,26))
 at(outside)
 check(h.view.groups()[0].cells.size()==42,"Exterior includes all four masonry corners")
 check(h.view.groups().size()==1,"Starter cottage is one enclosed building")
 check(not h.view.inside(),"Grounds retain outdoor view")
 check(not g.surface.walkable(h.center(Vector2i(57,27))),"Exterior threshold requires deliberate interaction even when saved open")
 g.surface.architecture.room_blueprints.data() # Initialize existing lazy planning metadata before the preservation snapshot.
 var tiles=h.data().duplicate(true);var belongings=g.state.surface.chests.duplicate(true);var furniture=g.state.surface.decor.duplicate(true)
 await snap("01-exterior")
 at(h.center(Vector2i(56,28)));await snap("01b-door-clearance");at(outside)
 check(g.surface.nearest().get("action","")=="house:"+door,"Exterior door is the nearby interaction")
 key(KEY_E)
 check(h.view.inside() and g.player==landing,"E enters the real cottage interior")
 check(not h.view.visible(outside) and h.view.visible(HoldFrontier103.HOME_BED),"Interior excludes grounds and retains its bed")
 var position=g.player;key(KEY_E)
 check(g.player==position,"Transition cannot immediately bounce back outside")
 settle();await snap("02-interior")
 check(h.data()==tiles and g.state.surface.chests==belongings and g.state.surface.decor==furniture,"Entry preserves construction and belongings")
 g.save_game();g.start_game(true);settle();h=g.surface.house
 check(h.view.inside(),"Load resumes the actual interior location")
 h.view.cooldown=0;at(landing);key(KEY_E);settle()
 check(not h.view.inside() and g.player==outside,"E leaves at the matching exterior landing")
 h.view.cooldown=0
 g.state.surface.decor.append({"area":"claim","kind":"chest","x":landing.x,"y":landing.y,"z":0})
 h.toggle(door)
 check(g.player==outside,"Blocked landing rejects entry")
 g.state.surface.decor.pop_back()
 # Enlarge one side through ordinary construction data, without resetting possessions.
 for y in range(22,28):
  h.tiles()[h.key(Vector2i(60,y))].wall="wall" if y in [22,27] else ""
  h.tiles()[h.key(Vector2i(61,y))]={"floor":"stone_floor","roof":true,"wall":"wall"}
 check(h.view.groups()[0].bounds.size.x==320,"Expansion changes the same exterior and interior footprint")
 await snap("03a-expanded-exterior")
 h.toggle(door);settle();await snap("03-expanded-interior")
 check(h.view.inside() and h.view.current().body.has("60,25"),"New room floor belongs to the live interior")
 # A partition door joins rooms; no additional zoning between connected rooms.
 for y in range(23,27):h.tiles()[h.key(Vector2i(58,y))].wall="door" if y==25 else "wall"
 check(h.view.groups().size()==1 and h.view.current().body.has("58,25"),"Internal doorway connects both rooms in one view")
 h.data().levels["1"]=h.tiles().duplicate(true);h.data().z=1;at(landing)
 check(h.view.inside(),"Enclosed upper storey uses its actual interior floor")
 await snap("04-upper-interior")
 h.data().z=0;at(outside);await snap("05-upper-exterior")
 h.tiles()["61,25"].wall=""
 check(h.view.at(h.center(Vector2i(60,25))).is_empty(),"Opening a shell returns that unfinished room to outdoor presentation")
 print("COTTAGE189: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
