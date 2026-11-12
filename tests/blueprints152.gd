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
 for tech in HoldData.RESEARCH:g.state.tech[tech]=true
 g.open_panel("architecture");button("Plan Your Holding")
 check(a.room_planning,"Book opens blueprint mode")
 check(p.save_rectangle(Vector2i(54,40),Vector2i(58,44)),"Plan a five-tile room")
 var first=p.chosen();var first_id=p.selected
 check(p.cost(first)=={"stone":55,"wood":43},"Five-by-five shell quote includes area, perimeter, roof and door")
 check(g.state.inventory==before,"Planning spends nothing")
 if DisplayServer.get_name()!="headless":
  g.refresh_panel();await snap("01-plan-book")
 p.purpose="Bedroom";check(p.save_rectangle(Vector2i(54,40),Vector2i(59,44)),"Resize an unbuilt room")
 check(p.chosen().purpose=="Bedroom","Designation survives editing")
 check(g.state.inventory==before,"Resizing spends nothing")
 check(not p.save_rectangle(Vector2i(54,40),Vector2i(54,40)),"Reject undersized room")
 check(p.chosen().w==6,"Rejected resize preserves old plan")
 p.selected="";p.purpose="Kitchen"
 check(p.save_rectangle(Vector2i(59,40),Vector2i(63,44)),"Adjacent room shares a boundary")
 var second_id=p.selected
 check(p.configure("floor","wood_floor",second_id),"Unbuilt room material can be selected")
 check(p.parts(p.chosen()).any(func(part):return part.cell==Vector2i(59,41) and part.kind=="stone_floor"),"Shared foundation material is independent of construction order")
 check(not p.configure("floor","wood_floor",first_id),"Stale room controls cannot edit another selection")
 check(not p.configure("style_family","missing_style",second_id),"Unknown finish choices are rejected")
 p.configure("floor","stone_floor",second_id)
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
 var before_door=p.total_cost()
 p.selected=first_id
 check(not p.doorway(Vector2i(55,40)),"Built wall cannot be silently replaced by a door")
 check(not p.doorway(Vector2i(56,44),true),"Built doorway cannot be silently removed")
 p.selected=second_id
 check(p.doorway(Vector2i(61,40)),"Add an unbuilt doorway")
 check(p.doorway(Vector2i(61,44),true),"Remove an unbuilt doorway after providing a replacement")
 check(p.total_cost().get("stone",0)<=before_door.get("stone",0),"Door changes recompute shared estimates")
 var saved=JSON.parse_string(JSON.stringify(h.data().blueprints152));h.data().blueprints152=saved
 check(p.chosen().purpose=="Kitchen","Unfinished designation reloads")
 p.selected=first_id;check(p.remaining(p.chosen()).is_empty(),"Completed plan reconciles physical construction after JSON reload")
 var placed=g.state.surface.decor.duplicate(true)
 var style_room=p.chosen();style_room.style_family="oath";g.state.tech.erase("fine_masonry")
 var style_quote=HoldBlueprintFinishes.cost(p,style_room);var style_before=g.state.inventory.duplicate(true)
 at(h.center(Vector2i(56,42)));check(HoldBlueprintFinishes.work(p,style_room,400)==0,"Finish research is checked at activation")
 g.state.tech.fine_masonry=true
 for c in [Vector2i(56,42),Vector2i(58,42)]:at(h.center(c));HoldBlueprintFinishes.work(p,style_room,400)
 check(HoldBlueprintFinishes.cost(p,style_room).is_empty(),"Room finishes cover their physical surfaces")
 for resource in style_quote:check(g.state.count(resource)==int(style_before[resource])-int(style_quote[resource]),"Exact finish payment: "+resource)
 check(HoldBlueprintFinishes.work(p,style_room,400)==0,"Repeated finish work charges nothing")
 check(g.state.surface.decor==placed,"Finishing preserves furniture")
 g.save_game();g.start_game(true);settle();a=g.surface.architecture;p=a.room_blueprints;h=g.surface.house;p.selected=first_id
 check(p.chosen().style_family=="oath","Actual save-file reload preserves room finishes")
 check(HoldBlueprintFinishes.cost(p,p.chosen()).is_empty(),"Physical finish payments survive reload")
 p.selected=second_id;check(not p.remaining(p.chosen()).is_empty(),"Actual save-file reload preserves unfinished plan")
 p.selected=first_id
 if DisplayServer.get_name()!="headless":
  a.room_planning=true;g.open_panel("architecture");await snap("02-renovated-room")
 var physical=h.tiles().duplicate(true);p.forget();check(h.tiles()==physical,"Removing plan preserves paid construction")
 var corner=Vector2i(54,40);var original_tile=h.tile(corner).duplicate(true);var recovered=g.state.inventory.duplicate(true)
 var refunds=original_tile.get("finish_paid152",{}).duplicate(true)
 for kind in ["roof","wall","stone_floor"]:HoldBuildingPlans.add_cost(refunds,h.COSTS[kind])
 at(h.center(Vector2i(53,39)))
 for i in 3:check(h.build(h.center(corner),"remove"),"Fine construction recovers a finished component")
 for resource in refunds:check(g.state.count(resource)==int(recovered[resource])+int(refunds[resource]),"Finished tile recovery conserves "+resource)
 var after_recovery=g.state.inventory.duplicate(true);check(not h.build(h.center(corner),"remove"),"Removed finish cannot be refunded twice");check(g.state.inventory==after_recovery,"Repeated recovery leaves inventory unchanged")
 p.selected=second_id;var inventory=g.state.inventory.duplicate(true);g.state.inventory={};at(Vector2(2500,1700));check(p.work()==0,"Unavailable materials are never spent");g.state.inventory=inventory
 g.surface.enter("town",Vector2(500,700));check(not p.available(),"Planning is unavailable off property");check(p.work()==0,"Stale work action cannot build off property");check(not p.configure("purpose","Forge",second_id),"Stale designation action cannot change property remotely")
 print("BLUEPRINTS152: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
