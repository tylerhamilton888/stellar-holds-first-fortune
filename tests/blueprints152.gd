extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 g.surface.enter("claim",Vector2(2200,1760));settle()
 var a=g.surface.architecture;var p=a.room_blueprints;var h=g.surface.house
 var before=g.state.inventory.duplicate(true)
 check(p.available(),"Planning is available on owned ground")
 g.open_panel("architecture");button("Plan Your Holding")
 check(a.room_planning,"Book opens blueprint mode")
 check(p.save_rectangle(Vector2i(54,40),Vector2i(58,44)),"Plan a five-tile room")
 var first=p.chosen();var first_id=p.selected
 check(p.cost(first)=={"stone":55,"wood":43},"Five-by-five shell quote includes area, perimeter, roof and door")
 check(g.state.inventory==before,"Planning spends nothing")
 p.purpose="Bedroom";check(p.save_rectangle(Vector2i(54,40),Vector2i(59,44)),"Resize an unbuilt room")
 check(p.chosen().purpose=="Bedroom","Designation survives editing")
 check(g.state.inventory==before,"Resizing spends nothing")
 check(not p.save_rectangle(Vector2i(54,40),Vector2i(54,40)),"Reject undersized room")
 check(p.chosen().w==6,"Rejected resize preserves old plan")
 p.selected="";p.purpose="Kitchen"
 check(p.save_rectangle(Vector2i(59,40),Vector2i(63,44)),"Adjacent room shares a boundary")
 var second_id=p.selected
 check(p.doorway(Vector2i(59,42)),"Add a connecting doorway")
 check("59,42" in p.chosen().doors,"Second room has shared doorway")
 p.selected=first_id;check("59,42" in p.chosen().doors,"First room has shared doorway")
 p.selected="";check(not p.save_rectangle(Vector2i(55,41),Vector2i(60,45)),"Reject overlapping usable spaces")
 check(not p.save_rectangle(Vector2i(5,40),Vector2i(9,44)),"Reject ground outside holding")
 p.selected=first_id;var quote=p.cost(p.chosen());var paid_before=g.state.inventory.duplicate(true)
 var count=p.work();check(count>0,"Nearby work builds actual pieces")
 check(p.chosen().started,"Physical work locks structural redraw")
 check(not p.save_rectangle(Vector2i(54,40),Vector2i(60,44)),"Cannot move paid structure by redrawing")
 # Approach each edge and room interior; only the normal builder spends materials.
 for iteration in 12:
  for c in [Vector2i(56,45),Vector2i(53,42),Vector2i(60,42),Vector2i(56,39),Vector2i(56,42)]:
   at(h.center(c));p.work()
 check(p.remaining(p.chosen()).is_empty(),"Room is physically complete")
 for item in quote:check(g.state.count(item)==int(paid_before[item])-int(quote[item]),"Exact total expenditure: "+item)
 var after=g.state.inventory.duplicate(true);check(p.work()==0,"Completed work is idempotent");check(g.state.inventory==after,"No duplicate payment")
 p.selected=second_id;var second_quote=p.cost(p.chosen())
 check(int(second_quote.stone)<55,"Shared built boundary reduces next room cost")
 var saved=JSON.parse_string(JSON.stringify(h.data().blueprints152));h.data().blueprints152=saved
 check(p.chosen().purpose=="Kitchen","Unfinished designation reloads")
 p.selected=first_id;check(p.remaining(p.chosen()).is_empty(),"Completed plan reconciles physical construction after JSON reload")
 var physical=h.tiles().duplicate(true);p.forget();check(h.tiles()==physical,"Removing plan preserves paid construction")
 p.selected=second_id;var inventory=g.state.inventory.duplicate(true);g.state.inventory={};at(Vector2(2500,1700));check(p.work()==0,"Unavailable materials are never spent");g.state.inventory=inventory
 g.surface.enter("town",Vector2(500,700));check(not p.available(),"Planning is unavailable off property");check(p.work()==0,"Stale work action cannot build off property")
 print("BLUEPRINTS152: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
