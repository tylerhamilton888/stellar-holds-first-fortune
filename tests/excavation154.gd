extends "res://tests/support/game_fixture.gd"
func normal(value):return JSON.parse_string(JSON.stringify(value))
func stand(c:Vector2i):
 g.player=Deepworks.center(c);g.deep.world.survey(g.player);g.camera=g.deep.camera_target();g.transition_left=0
func excavate(p,r:Dictionary):
 var w=g.deep.world;var left=p.cells(r).filter(func(c):return w.at(c)!=0)
 var attempts=0
 while not left.is_empty() and attempts<500:
  attempts+=1;var worked=false
  for c in left:
   for d in Deepworks.DIRS:
    var approach=c+d
    if not w.walkable(approach) or w.route(Deepworks.cell(g.player),w.depth(),"",approach).is_empty():continue
    stand(approach);g.deep.contact=Deepworks.center(c)
    for hit in 16:
     if w.at(c)==0:break
     g.deep.hit(c)
    if w.at(c)==0:left.erase(c);worked=true
    break
   if worked:break
  if not worked:break
 check(left.is_empty(),"Excavate planned cells through reachable real mining contacts")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.change_zone("mine");settle();var w=g.deep.world
 stand(HoldMineworks143.entrance(w));key(KEY_E);settle()
 check(w.depth()==5,"Enter persistent Stonewright worksite through real adit")
 var p=g.deep.works.blueprints;var m=g.deep.works.model
 var original=normal(w.layer());var inventory=normal(g.state.inventory);var mined=g.state.mined
 stand(Vector2i(10,12));g.open_panel("living");button("Plan Your Holding");await process_frame
 p.map_center=Vector2(560,640);p.zoom=3;g.refresh_panel();await snap("01-excavation-book")
 var map=g.panel.find_children("*","Control",true,false).filter(func(n):return n is HoldExcavationBlueprintView.Map)[0]
 var press=InputEventMouseButton.new();press.button_index=MOUSE_BUTTON_LEFT;press.pressed=true;press.position=map.global_position+map.origin+Vector2(10.5,13.5)*40*map.scale_factor
 original=normal(w.layer());root.push_input(press,true);await process_frame
 var release=InputEventMouseButton.new();release.button_index=MOUSE_BUTTON_LEFT;release.pressed=false;release.position=map.global_position+map.origin+Vector2(12.5,18.5)*40*map.scale_factor
 root.push_input(release,true);await process_frame
 check(p.rooms().size()==1,"Native GUI drag saves underground corridor")
 if p.rooms().is_empty():print("EXCAVATION154: %d passed / %d failed" % [passed,failed]);quit(1);return
 var corridor=p.selected
 check(p.configure("purpose","Corridor",corridor),"Optional corridor label")
 p.selected="";check(p.save_rectangle(Vector2i(13,15),Vector2i(20,22)),"Plan chamber in solid stone beside corridor")
 var room=p.selected;var r=p.chosen()
 check(normal(w.layer())==original and normal(g.state.inventory)==inventory and g.state.mined==mined,"Planning preserves geology, damage, yields and inventory")
 check(p.cost(r).is_empty(),"Natural chamber has no fabricated shell cost")
 check(not p.prepare_room(),"Unexcavated plan cannot become furnishing floor")
 p.selected="";check(not p.save_rectangle(Vector2i(14,16),Vector2i(16,18)),"Overlapping floor plan rejected")
 check(not p.save_rectangle(Vector2i(0,0),Vector2i(3,3)),"Boundary plan rejected")
 check(not p.save_rectangle(Vector2i(7,6),Vector2i(10,9)),"Adit landing protected")
 p.selected=corridor;g.close_panel();stand(Vector2i(10,13));g.deep.contact=Deepworks.center(Vector2i(10,14));g.deep.hit(Vector2i(10,14))
 check(p.started(p.chosen()),"Partial mining damage counts as begun work")
 check(not p.save_rectangle(Vector2i(10,13),Vector2i(12,19)),"Mining locks redraw without losing the excavation")
 var partial=normal(w.layer().damage);g.save_game();g.start_game(true);settle();w=g.deep.world;p=g.deep.works.blueprints;m=g.deep.works.model;p.selected=corridor
 check(normal(w.layer().damage)==partial and p.rooms().size()==2,"Partial excavation and both guides survive actual save reload")
 excavate(p,p.chosen());check(p.prepare_room(),"Cleared corridor uses existing room ownership")
 p.selected=room;excavate(p,p.chosen());check(p.progress(p.chosen()).open==64,"Chamber progress follows actual cleared terrain")
 check(g.state.mined>mined and not g.handworks.data().loose.is_empty(),"Excavation creates normal mined counts and physical raw loads")
 # Clear the floor through real field dressing, conserving every extracted unit.
 var raw_totals={};var carried_before={}
 for item in HoldData.ITEMS:carried_before[item]=g.state.count(item)+g.deep.haul.in_field(item)
 for raw in g.handworks.data().loose:
  var item=g.handworks.raw_item(raw);raw_totals[item]=int(raw_totals.get(item,0))+int(raw.units)
 var shift=InputEventKey.new();shift.keycode=KEY_SHIFT;shift.physical_keycode=KEY_SHIFT;shift.pressed=true;Input.parse_input_event(shift);await process_frame
 Input.action_press("interact")
 for raw in g.handworks.data().loose.duplicate():
  stand(Deepworks.cell(g.handworks.pos(raw)))
  for step in 40:
   if raw not in g.handworks.data().loose:break
   g.handworks.update(.25)
  stand(Vector2i(10,12));g.deep.haul.unload(g.player)
 Input.action_release("interact");shift.pressed=false;Input.parse_input_event(shift);await process_frame
 check(g.handworks.data().loose.is_empty(),"Process the mined chunks through real field dressing before furnishing")
 for item in raw_totals:check(g.state.count(item)+g.deep.haul.in_field(item)==int(carried_before.get(item,0)),"Extracted material conserved through processing: "+item)
 check(p.prepare_room(),"Connected chamber ready for real furnishing")
 var room_record=m.data.rooms[p.chosen().room]
 check(room_record.kind=="undesignated","Designation remains optional")
 for resource in ["wood","stone","iron","coal","copper"]:g.state.add(resource,200)
 for spec in [["bench",14,16],["anvil",16,16],["lamp",15,18],["bed",17,18]]:
  check(m.place(Vector2i(spec[1],spec[2]),spec[0]).ends_with("installed."),"Install "+spec[0]+" in undesignated chamber")
 stand(Vector2i(14,17));check(g.deep.works.interact() and g.panel_id=="forge","Actual bench opens production without workshop label")
 g.close_panel();check(LivingWorks.room_role(room_record,m.data.furniture)=="workshop","Installed equipment identifies worker function")
 g.state.outpost.crew["brann"]={"role":"miner","priority":"iron_ore","fuel":0,"grain_work":0}
 check(m.assign("brann",room_record.id).contains("assigned"),"Existing worker can be assigned to furnished undesignated room")
 check(w.route(Deepworks.cell(g.player),w.depth(),"",m.stand(room_record)).has("path"),"Worker destination has a physical tunnel route")
 var previous_claim=g.state.claim_id;g.state.claim_id="legacy";g.state.agents_enabled=true
 var actor={"id":"brann","type":"worker","p":Deepworks.center(Vector2i(10,13)),"path":[],"target":Vector2i(-1,-1),"cool":0.0,"fuel":100.0,"work":false,"status":""}
 g.agents=[actor];w.data.crew.brann={"depth":5,"assigned":5,"x":actor.p.x,"y":actor.p.y}
 for step in 300:g.deep.agents(.1)
 check(m.data.assignments.brann.present==room_record.id and actor.work,"Assigned worker walks actual corridors and works in undesignated workshop")
 g.agents=[];g.state.claim_id=previous_claim
 p.configure("floor","flags",room);var quote=p.cost(p.chosen());check(quote=={"stone":64},"Finishing quote uses cleared floor coverage only")
 var before=g.state.count("stone");g.state.tech.erase("stoneworking");check(p.finish_nearby()==0 and g.state.count("stone")==before,"Finishing research cannot be bypassed")
 g.state.tech.stoneworking=true
 for c in p.cells(p.chosen()):
  if w.walkable(c):stand(c);p.finish_nearby()
 check(p.cost(p.chosen()).is_empty() and g.state.count("stone")==before-64,"Actual nearby finishes spend exact quoted materials")
 before=g.state.count("stone");check(p.finish_nearby()==0 and g.state.count("stone")==before,"No duplicate finish payment")
 p.configure("wall","masonry",room);var wall_quote=p.cost(p.chosen());before=g.state.count("stone")
 check(int(wall_quote.get("stone",0))>0,"Natural boundary walls have a separate coverage quote")
 for c in p.cells(p.chosen()):
  if w.walkable(c):stand(c);p.finish_nearby()
 check(p.cost(p.chosen()).is_empty() and g.state.count("stone")==before-int(wall_quote.get("stone",0)),"Boundary wall finish spends its exact separate quote")
 check(not w.walkable(Vector2i(13,14)) and w.at(Vector2i(13,14))!=0,"Finished boundary remains real solid rock")
 check(m.data.furniture.size()>=4,"Finishing preserves furnishings")
 g.deep.works.page="Plans";g.open_panel("living");await snap("02-finished-chamber-book")
 var focused=g.panel.find_children("*","Control",true,false).filter(func(n):return n is HoldExcavationBlueprintView.Map)[0]
 var frame=Rect2(p.bounds(p.chosen()));frame.position=frame.position*40*focused.scale_factor+focused.origin;frame.size*=40*focused.scale_factor
 check(Rect2(Vector2.ZERO,focused.size).encloses(frame),"Selected chamber fits inside the compact planning map")
 g.close_panel();stand(Vector2i(15,19));g.deep.mine(2);await snap("03-furnished-chamber")
 stand(Vector2i(18,20));check(g.handworks.build("store",Deepworks.center(Vector2i(19,21))),"Build actual materials pallet inside planned chamber")
 var pallet=g.handworks.data().facilities.back();check(g.handworks.deposit(pallet)>0 and not pallet.cargo.is_empty(),"Deposit owned supplies into real storage")
 var storage=normal(g.handworks.data().facilities)
 var furnishings=normal(m.data.furniture);var surfaces=normal(m.data.surfaces);g.save_game();g.start_game(true);settle();w=g.deep.world;p=g.deep.works.blueprints;m=g.deep.works.model;p.selected=room
 check(normal(g.handworks.data().facilities)==storage,"Stocked storage survives actual save reload")
 check(normal(m.data.furniture)==furnishings and normal(m.data.surfaces)==surfaces,"Furnished and finished chamber survives actual reload")
 p.forget();check(normal(g.handworks.data().facilities)==storage,"Guide removal preserves storage contents");check(normal(m.data.furniture)==furnishings and normal(m.data.surfaces)==surfaces and m.data.rooms.has(room_record.id),"Removing guide preserves actual room and possessions")
 check(not p.plan_stair(Vector2i(16,19)),"Lateral mineworks cannot create unsupported vertical levels")
 # Original depth pair: plan connections without terrain deletion, then excavate landings.
 w.data.depth=0;var upper=Vector2i(-1,-1)
 for candidate in [Vector2i(10,7),Vector2i(5,8),Vector2i(10,10),Vector2i(6,10)]:
  var clear=w.at(candidate,1) not in [0,8]
  for d in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   clear=clear and w.walkable(candidate+d,0) and not HoldMineworks143.reserved(w,candidate+d,0)
  if clear:upper=candidate;break
 check(upper.x>=0,"Find a genuinely clear upper landing around existing equipment")
 stand(upper);var before_layers=normal(w.data.layers);check(p.plan_stair(upper),"Save supported upper/lower stair guide")
 check(normal(w.data.layers)==before_layers,"Stair planning never clears rock")
 check(not p.fit_stair(),"Unexcavated landing blocks blueprint stair fitting")
 # Existing manual access opens the lower level; blueprint fitting itself must clear nothing.
 w.carve_stairs(Vector2i(8,8));stand(Vector2i(8,8));key(KEY_E);settle();check(w.depth()==1,"Use existing physical shaft to reach lower landing")
 var low=Vector2i(mini(upper.x,8)-1,mini(upper.y,8)-1);var high=Vector2i(maxi(upper.x,8)+1,maxi(upper.y,8)+1)
 excavate(p,{"x":low.x,"y":low.y,"w":high.x-low.x+1,"h":high.y-low.y+1})
 stand(Vector2i(8,8));var up=InputEventKey.new();up.keycode=KEY_E;up.pressed=true;up.shift_pressed=true;g._unhandled_input(up);settle();stand(upper)
 var landings=normal(w.data.layers);var earned=g.state.mined;check(p.fit_stair(),"Fit stairs only after both landings are mined")
 check(normal(w.data.layers)==landings and g.state.mined==earned,"Fitting stairs neither erases geology nor grants rewards")
 g.deep.works.page="Plans";g.open_panel("living");await process_frame;g.menu_scroll.scroll_vertical=int(g.menu_scroll.get_v_scroll_bar().max_value);await snap("04-stair-and-finish-controls");g.close_panel()
 key(KEY_E);settle();check(w.depth()==1,"New stairs provide actual downward travel")
 g._unhandled_input(up);settle();check(w.depth()==0,"New stairs provide actual upward travel")
 g.save_game();g.start_game(true);settle();w=g.deep.world;p=g.deep.works.blueprints
 check(w.can_descend(upper,0) and p.data().stairs.size()==1,"Stair guide and connection survive reload")
 g.surface.enter("town",Vector2(500,700));check(not p.available() and not p.fit_stair() and not p.configure("purpose","Forge",p.selected),"Stale off-site controls cannot change the mine")
 print("EXCAVATION154: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
