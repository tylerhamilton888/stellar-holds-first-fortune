extends "res://tests/support/game_fixture.gd"
func normalized(value):return JSON.parse_string(JSON.stringify(value))
func construct(p,id:String):
 p.select_room(id);var h=g.surface.house;var b=p.bounds(p.chosen())
 for cycle in 6:
  if p.remaining(p.chosen()).is_empty():break
  for offset in [Vector2i(-1,-1),Vector2i(1,-1),Vector2i(-1,1),Vector2i(1,1)]:
   var position=h.center(b.get_center()+offset)
   if g.surface.walkable(position):at(position);p.work()
 check(p.remaining(p.chosen()).is_empty(),"Complete room "+id+" through normal construction")
func furnish(kind:String,position:Vector2,approach:Vector2)->bool:
 at(approach);g.surface.placing=kind
 var success=g.surface.place(position);check(success,"Install usable "+kind);return success
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 for tech in HoldData.RESEARCH:g.state.tech[tech]=true
 g.surface.enter("claim",Vector2(2100,1400));settle()
 var a=g.surface.architecture;var p=a.room_blueprints;var h=g.surface.house
 g.open_panel("architecture");button("Plan Your Holding");await process_frame
 var map=g.panel.find_children("*","Control",true,false).filter(func(n):return n is HoldRoomBlueprintView.Map)[0]
 if DisplayServer.get_name()!="headless":
  await snap("01-empty-book")
  var press=InputEventMouseButton.new();press.button_index=MOUSE_BUTTON_LEFT;press.pressed=true;press.position=map.global_position+map.origin+Vector2(50.5,25.5)*40*map.scale_factor
  root.push_input(press,true);await process_frame
  var release=InputEventMouseButton.new();release.button_index=MOUSE_BUTTON_LEFT;release.pressed=false;release.position=map.global_position+map.origin+Vector2(57.5,32.5)*40*map.scale_factor
  root.push_input(release,true);await process_frame
  check(p.rooms().size()==1,"Native GUI drag saves a room")
 else:check(p.save_rectangle(Vector2i(50,25),Vector2i(57,32)),"Headless room plan")
 if p.rooms().is_empty():print("BLUEPRINT_MANOR152: %d passed / %d failed" % [passed,failed]);quit(1);return
 var hall_id=p.selected;var ids=[hall_id]
 for spec in [["Bedroom",57,25,64,32],["Kitchen",50,32,57,39],["Workshop",57,32,64,39],["Storehouse",64,32,71,39]]:
  p.selected="";p.purpose=spec[0]
  check(p.save_rectangle(Vector2i(spec[1],spec[2]),Vector2i(spec[3],spec[4])),"Plan connected "+spec[0])
  ids.append(p.selected)
  if spec[0]=="Bedroom":check(p.doorway(Vector2i(57,28)),"Connect bedroom to hall")
  if spec[0]=="Workshop":check(p.doorway(Vector2i(57,35)),"Connect kitchen to workshop")
  if spec[0]=="Storehouse":check(p.doorway(Vector2i(64,35)),"Connect workshop to storehouse")
 var sum={}
 for r in p.rooms():HoldBuildingPlans.add_cost(sum,p.cost(r))
 var fee=p.total_cost();check(int(fee.stone)<int(sum.stone),"Estate estimate counts shared partitions once")
 var inventory=g.state.inventory.duplicate(true)
 for id in ids:construct(p,id)
 for resource in fee:check(g.state.count(resource)==int(inventory[resource])-int(fee[resource]),"Whole-estate estimate equals actual spending: "+resource)
 for c in [Vector2i(57,28),Vector2i(53,32),Vector2i(57,35),Vector2i(64,35)]:check(g.surface.walkable(h.center(c)),"Connected doorway is physically walkable: "+str(c))
 g.close_panel()
 var bed=Vector2(2080,1160);var bedside=HoldFurnishings.bedside(bed)
 furnish("bed",bed,bedside)
 at(bedside);check(g.surface.house.rest(bed),"Bed in undesignated hall provides shelter and rest")
 check(p.rooms()[0].purpose=="Undesignated","Using bed never forces a designation")
 furnish("hearth",Vector2(2180,1120),Vector2(2180,1170))
 at(Vector2(2180,1170));check(g.hearth.cook("root_hotpot"),"Cooking works in mixed-use undesignated hall")
 furnish("worktable",Vector2(2440,1380),Vector2(2440,1430))
 furnish("hearth",Vector2(2440,1500),Vector2(2440,1450))
 at(Vector2(2440,1430));check(a.can_forge(),"Physical equipment enables the workshop")
 furnish("chest",Vector2(2720,1450),Vector2(2720,1500))
 var chests=g.state.surface.chests.values().filter(func(c):return c.area=="claim")
 check(not chests.is_empty(),"Storehouse uses real chest storage")
 if not chests.is_empty():
  var chest=chests.back();g.surface.selected_chest=g.state.surface.chests.find_key(chest);at(Vector2(chest.x,chest.y+25));check(g.surface.transfer("crystal",7,true)==7,"Deposit actual resources in storage")
 var stair=Vector2i(55,30);at(h.center(stair))
 check(h.build(h.center(stair),"stairs"),"Fine construction adds a stair inside a planned room")
 check(h.use_stairs(true) and h.level()==1,"Real stair travel reaches the supported upper floor")
 check(not p.available(),"Surface planner does not pretend to support upper-floor plans")
 check(h.use_stairs(false) and h.level()==0,"Real stair travel returns to the same holding")
 var decor=g.state.surface.decor.duplicate(true);var stores=g.state.surface.chests.duplicate(true)
 p.select_room(hall_id);p.chosen().style_family="forge"
 for c in [Vector2i(52,27),Vector2i(55,27),Vector2i(52,30),Vector2i(55,30)]:at(h.center(c));HoldBlueprintFinishes.work(p,p.chosen(),400)
 check(g.state.surface.decor==decor and g.state.surface.chests==stores,"Renovation preserves furnished rooms and chest contents")
 g.save_game();g.start_game(true);settle();a=g.surface.architecture;p=a.room_blueprints;h=g.surface.house
 check(p.rooms().size()==5,"Five connected plans survive actual reload")
 check(h.link_at(stair,0),"Stair connection survives the same save reload")
 var expected={"decor":normalized(decor),"chests":normalized(stores)}
 var actual={"decor":normalized(g.state.surface.decor),"chests":normalized(g.state.surface.chests)}
 if expected!=actual:
  var file=FileAccess.open(output+"/reload-diff.json",FileAccess.WRITE);file.store_string(JSON.stringify({"expected":expected,"actual":actual}));file.close()
 check(expected==actual,"Furnishings and storage survive reload")
 for r in p.rooms():check(p.remaining(r).is_empty(),"Reloaded structure remains complete: "+str(r.id))
 at(Vector2(2330,1410));p.select_room(ids[3]);p.zoom=2.5;p.map_center=Vector2(2440,1300);a.room_planning=true;g.open_panel("architecture")
 if DisplayServer.get_name()!="headless":
  await snap("02-manor-book")
  check(g.panel_body.size.x<=g.menu_scroll.size.x+1,"Blueprint controls fit panel width")
  g.close_panel();await snap("03-furnished-manor")
 print("BLUEPRINT_MANOR152: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
