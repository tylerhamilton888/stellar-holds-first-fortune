extends "res://tests/support/game_fixture.gd"
func panel_fits(label:String):
 check(g.panel.get_global_rect().end.x<=960 and g.panel.get_global_rect().end.y<=540,label+" fits the viewport")
 check(g.panel_body.size.x<=g.menu_scroll.size.x+1,label+" has no horizontal clipping")
func reveal(name:String):
 g.camera=g.player-Vector2(480,440);g.update_hud();g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 for id in HoldData.RESEARCH:g.state.tech[id]=true
 g.surface.enter("claim",Vector2(2200,1760));settle();var a=g.surface.architecture
 g.open_panel("architecture");await snap("01-building-collections");panel_fits("Building collections")
 for family in HoldArchitectureStyles.FAMILIES:
  button(HoldArchitectureStyles.FAMILIES[family].title);await process_frame
  check(a.collection==family,"Collection button selects "+family)
  check(not g.panel.find_children("*","Button",true,false).filter(func(b):return b.text=="Choose plan").is_empty(),family+" exposes actual building plans")
 a.select_plan("cottage");await snap("02-plan-preview");panel_fits("Plan preview")
 var build_button=g.panel.find_children("*","Button",true,false).filter(func(btn):return btn.text=="Build this plan")[0]
 check(g.menu_scroll.get_global_rect().encloses(build_button.get_global_rect()),"Plan confirmation is visible without scrolling")
 var before=g.state.inventory.duplicate(true);var fee=a.cost("cottage")
 button("Build this plan");check(g.surface.placing=="blueprint:cottage" and g.panel_id=="","Plan card starts real building placement")
 check(a.place(Vector2(2200,1700)),"Build a cottage through the preview selection")
 var b=a.data().instances.back();var id=str(b.id);var room=HoldBuildingPlans.room_id(id)
 check(g.state.count("stone")==before.stone-fee.stone,"Plan preview quotes the charged stone cost")
 var original=HoldBuildingArt.facade(a.building_object(b));var footprint=HoldBuildingArt.footprint(a.building_object(b))
 for i in 3:check(a.expand("extend_x"),"Full-size side bay "+str(i+1))
 check(a.expand("extend_y") and a.add_floor(),"Add rear bay and upper room")
 var art=HoldBuildingArt.facade(a.building_object(b))
 check(art.source==original.source and art.destination==original.destination,"Extensions retain the complete original frontage at the original scale")
 var enlarged=HoldBuildingArt.footprint(a.building_object(b))
 check(enlarged.size==footprint.size+Vector2(120,40),"Painted annexes use the existing physical bay dimensions")
 for chest in g.state.surface.chests.values():
  if chest.area==room:chest.items={"crystal":7}
 var inventory=g.state.inventory.duplicate(true);var contents=g.state.surface.decor.duplicate(true);var chests=g.state.surface.chests.duplicate(true)
 g.open_panel("architecture");button("Materials & finishes");await snap("03-hearthstone-study");panel_fits("Materials study")
 var apply_button=g.panel.find_children("*","Button",true,false).filter(func(btn):return btn.text=="Apply finishes")[0]
 check(g.menu_scroll.get_global_rect().encloses(apply_button.get_global_rect()),"Material confirmation is visible without scrolling")
 check(g.menu_paused and g.panel_id=="architecture_style","Materials menu pauses play")
 button("Forgehold");await snap("04-forgehold-study")
 check(g.state.inventory==inventory and HoldArchitectureStyles.resolve(b).wall=="hearth","Browsing a finish never spends resources or alters the building")
 var quoted=a.style_cost(b);button("Apply finishes");await process_frame
 for item in quoted:check(g.state.count(item)==int(inventory[item])-int(quoted[item]),"Finish transaction charges quoted "+item)
 var paid=g.state.inventory.duplicate(true)
 check(not a.apply_style() and g.state.inventory==paid,"Applying the same finish twice is a free no-op")
 check(g.state.surface.decor==contents and g.state.surface.chests==chests,"Refinishing preserves furnishings and chest contents")
 g.close_panel();await reveal("05-forgehold-cottage")
 a.open_style();button("Oathhall");await snap("06-oathhall-study");button("Apply finishes");g.close_panel();await reveal("07-oathhall-cottage")
 a.open_style()
 var picker=g.panel.find_child("Style_roof",true,false);picker.item_selected.emit(0);await process_frame
 var trim=g.panel.find_child("Style_trim",true,false);trim.item_selected.emit(1);await process_frame
 var floor_picker=g.panel.find_child("Style_floor",true,false);floor_picker.item_selected.emit(0);await process_frame
 check(a.draft_style.wall=="oath" and a.draft_style.roof=="slate" and a.draft_style.trim=="copper" and a.draft_style.floor=="oak","Independent selectors compose a mixed collection")
 await snap("08-mixed-materials");check(a.apply_style(),"Mixed materials apply to the actual building")
 var expected=HoldArchitectureStyles.resolve(b);g.close_panel()
 g.surface.enter(room);settle();at(Vector2(420,480));await snap("09-finished-interior")
 check(HoldArchitectureStyles.room(room)==expected,"Interior uses the saved mixed finishes")
 g.open_panel("architecture_details");await snap("10-furniture-cards");panel_fits("Furniture cards")
 button("Study & storage");await snap("11-study-cards");panel_fits("Study cards")
 button("Stonework");await snap("12-stonework-cards");panel_fits("Stonework cards")
 g.open_panel("house_build");await snap("13-partition-cards");panel_fits("Partition cards")
 check(g.menu_paused,"Partition catalogue pauses play")
 g.close_panel();at(Vector2(800,520));check(g.surface.house.build(Vector2(900,460),"window"),"Styled partition is built through the real construction system: "+g.surface.house.reason)
 check(not g.surface.walkable(Vector2(900,460)),"Styled window retains collision")
 check(g.surface.house.build(Vector2(900,460),"remove"),"Styled partition remains recoverable")
 g.save_game();g.start_game(true);settle();a=g.surface.architecture;b=a.record(id)
 check(HoldArchitectureStyles.resolve(b)==expected and HoldArchitectureStyles.room(room)==expected,"Mixed exterior and interior finishes survive save/reload")
 for chest_id in chests:
  if chests[chest_id].area==room:
   var chest=g.state.surface.chests.get(chest_id,{})
   check(chest.get("area","")==room and chest.get("items",{}).get("crystal",0)==7 and Vector2(chest.get("x",0),chest.get("y",0))==Vector2(chests[chest_id].x,chests[chest_id].y),"Refinish/reload preserves private chest identity, position and stored goods")
 a.open_style();a.draft_style=HoldArchitectureStyles.preset("forge");var saved_inventory=g.state.inventory.duplicate(true);g.state.inventory={}
 check(not a.apply_style() and HoldArchitectureStyles.resolve(b)==expected,"Unaffordable refinish leaves appearance unchanged")
 g.state.inventory=saved_inventory;a.draft_style.wall="invalid";var inv=g.state.inventory.duplicate(true)
 check(not a.apply_style() and g.state.inventory==inv,"Unknown material rejects without charging")
 var legacy=b.duplicate(true);legacy.erase("style87")
 check(HoldArchitectureStyles.resolve(legacy)==HoldArchitectureStyles.preset("hearth"),"Old building records receive compatible defaults without save migration")
 legacy.style87={"wall":"missing","roof":"bad"};check(HoldArchitectureStyles.resolve(legacy)==HoldArchitectureStyles.preset("hearth"),"Unknown saved finishes safely fall back")
 for family in ["hearth","forge","oath"]:
  a.open_style();a.draft_style=HoldArchitectureStyles.preset(family);a.apply_style();g.close_panel();at(Vector2(410,380));await snap("room-"+family)
 a.leave();settle();at(Vector2(2200,1760))
 for i in 3:check(a.add_floor(),"Add later storey "+str(i+3)+" with the mixed material system")
 g.open_panel("architecture");await snap("15-five-storey-building");panel_fits("Five-storey renovation")
 g.open_panel("house_build");button("Forgehold");await snap("14-free-building-collection");panel_fits("Free construction cards")
 check(HoldArchitectureStyles.room("claim").wall=="forge","Freeform construction also exposes the compatible collections")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(HoldArchitectureStyles.room("claim").wall=="forge","Freeform collection survives save/reload")
 print("ARCHITECTURE87: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
