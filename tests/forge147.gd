extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();HoldFirstVisit99.data(g.state).rewarded=true
 var s=g.state;var room=HoldFrontier103.room(s,"forge")
 var exit_marker=HoldFirstVisit99.forge_marker(g)
 at(exit_marker.p+Vector2(0,2))
 check(g.surface.roads.moved(exit_marker.p-Vector2(0,2),1.0) and g.surface.area=="trail","Walk through the marked bunkhouse exit")
 settle()
 var forge_door=g.surface.architecture.connections("trail").filter(func(c):return c.target==room)[0]
 check(HoldFirstVisit99.forge_marker(g).p==forge_door.p and HoldFirstVisit99.goal(g).contains("main street"),"Town guidance points to the real forge door")
 at(forge_door.p+Vector2(0,70));await snap("first-quest-forge")
 at(forge_door.p+Vector2(0,-2))
 check(g.surface.roads.moved(forge_door.p+Vector2(0,2),1.0) and g.surface.area==room,"Walk through the marked forge door")
 settle()
 check(HoldForge147.active(g),"The public forge has its own workshop")
 var contents=s.surface.decor.duplicate(true);var chest_id=""
 for id in s.surface.chests:
  if s.surface.chests[id].area==room:chest_id=id;break
 check(chest_id!="","The existing forge storage is still present")
 if chest_id!="":s.surface.chests[chest_id].items={"iron":7}
 var chest=s.surface.chests[chest_id].duplicate(true) if chest_id!="" else {}
 var fixtures=HoldForge147.props(g);var blocks=HoldForge147.obstacles(g)
 check(fixtures.size()>=2 and fixtures.size()==blocks.size(),"Only visible workshop fixtures have new collision")
 var points=HoldForge147.points(g);var forge={};var anvil={};var borin={};var benches=[]
 for p in points:
  if p.action=="forge147:smelt":forge=p
  if p.action=="forge147:anvil":anvil=p
  if p.action=="talk:borin":borin=p
  if p.action=="forge147:bench":benches.append(p)
 check(not forge.is_empty() and not anvil.is_empty() and not borin.is_empty() and benches.size()>0,"Hearth, anvil, smith and workbenches have distinct uses")
 var grid=AStarGrid2D.new();grid.region=Rect2i(0,0,65,50);grid.cell_size=Vector2(20,20);grid.offset=Vector2(100,100);grid.diagonal_mode=AStarGrid2D.DIAGONAL_MODE_NEVER;grid.update()
 for y in 50:
  for x in 65:
   var id=Vector2i(x,y);grid.set_point_solid(id,not g.surface.walkable(grid.get_point_position(id)))
 var exit=HoldRoomLayout.exit_point(room);var start=Vector2i(roundi((exit.x-100)/20),roundi((exit.y-100)/20))
 for p in points:
  var target=Vector2i(roundi((p.p.x-100)/20),roundi((p.p.y-100)/20))
  check(g.surface.walkable(p.p) and not grid.get_id_path(start,target).is_empty(),"Workshop interaction reachable: "+p.name)
 check(HoldFirstVisit99.forge_marker(g).p==forge.p and HoldFirstVisit99.goal(g).contains("Press E"),"Forge guidance points to the usable hearth")
 at(forge.p);await snap("first-quest-hearth");key(KEY_E);check(g.panel_id=="frontier103","The cold hearth opens its restoration panel")
 button("Inspect the cold hearth");check(HoldLedger137.data(s).inspected and HoldFirstVisit99.forge_marker(g).is_empty() and HoldFirstVisit99.goal(g).to_lower().contains("coal"),"Inspection advances guidance to coal and clears the marker");g.close_panel()
 at(borin.p);key(KEY_E);check(g.talk_id=="borin" and g.panel_id!="","Borin can be spoken to in his workshop");g.close_panel()
 HoldWork132.produced(s,"coal",1,"cut");s.add("coal",8)
 g.surface.enter(HoldFrontier103.lodge(s));settle();at(Vector2(670,425));check(HoldLedger137.contribute(g,"forge","coal",8),"Fuel is contributed at the ledger")
 g.surface.enter(room);settle();at(forge.p);key(KEY_E);button("Relight the communal forge");check(s.opening==2,"The forge is restored through its real project");g.close_panel()
 check(g.opening_scene is HoldQuestScene181,"First firing opens its narrative scene")
 if g.opening_scene is HoldQuestScene181:g.opening_scene.finish()
 at(forge.p);key(KEY_E);check(g.panel_id=="frontier103" and g.get_meta("forge147_station","")=="smelt","The restored hearth opens smelting");g.close_panel()
 s.add("iron_ore",2);s.add("coal",1);check(HoldFrontier103.transact(g,"craft","iron"),"The restored hearth starts real smelting")
 at(anvil.p);key(KEY_E);check(g.get_meta("forge147_station","")=="anvil","The anvil opens metalwork");g.close_panel()
 at(benches[0].p);key(KEY_E);check(g.get_meta("forge147_station","")=="bench","A workbench opens metalwork");g.close_panel()
 at(anvil.p);key(KEY_E);s.tech.extraction=true;g.refresh_panel()
 check(not g.panel.find_children("*","Label",true,false).any(func(l):return l.text.contains("First research Steel tools")),"Learned steel research is not presented as an unmet requirement")
 await snap("learned-steel");g.close_panel()
 at(Vector2(230,560));check(not HoldFrontier103.transact(g,"craft","iron"),"The forge cannot be used remotely")
 check(s.surface.decor==contents,"Workshop fixtures do not overwrite saved furniture")
 g.save_game();g.start_game(true);settle();g.surface.enter(room);settle()
 check(chest_id!="" and JSON.parse_string(JSON.stringify(g.state.surface.chests[chest_id]))==JSON.parse_string(JSON.stringify(chest)),"Existing chest position and contents survive save and reload")
 check(HoldForge147.active(g) and g.state.opening==2,"The restored workshop survives reload")
 print("FORGE147: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
