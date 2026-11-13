extends "res://tests/support/game_fixture.gd"
const LANDING=Vector2i(54,34)
func normal(v):return JSON.parse_string(JSON.stringify(v))
func stand(c:Vector2i):
 g.player=Deepworks.center(c);g.transition_left=0
 if g.zone=="mine":g.deep.world.survey(g.player)
func shift_e():
 var e=InputEventKey.new();e.keycode=KEY_E;e.physical_keycode=KEY_E;e.pressed=true;e.shift_pressed=true;g._unhandled_input(e)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 g.surface.enter("claim",Deepworks.center(LANDING));settle()
 var p=g.surface.architecture.room_blueprints;var h=g.surface.house
 check(p.save_rectangle(Vector2i(50,30),Vector2i(58,38)),"Plan a home over the future cellar")
 for pass_index in 8:
  for y in range(29,40,2):
   for x in range(49,60,2):stand(Vector2i(x,y));p.work()
 check(p.remaining(p.chosen()).is_empty(),"Build complete home with existing paid blueprint construction")
 stand(LANDING);g.deep.ensure();var w=g.deep.world
 # Existing-save fixture: an old excavated approach, stopping short of the new cellar.
 for x in range(8,55):w.set_cell(Vector2i(x,8),0,0)
 for y in range(8,33):w.set_cell(Vector2i(54,y),0,0)
 var terrain=normal(w.data.layers);var money=normal(g.state.inventory)
 g.open_panel("architecture");button("Plan Your Holding");button("Plan cellar stair here")
 check(HoldEstateCellar.plans(g).size()==1,"Book plans a saved cellar stair at player coordinates")
 check(normal(w.data.layers)==terrain and normal(g.state.inventory)==money,"Planning preserves all terrain and materials")
 check(not HoldEstateCellar.fit(g),"Cannot fit stairs into unexcavated rock")
 check(normal(g.state.inventory)==money,"Rejected fit spends nothing")
 check(not HoldEstateCellar.plan(g),"Duplicate plan is rejected")
 g.save_game();g.start_game(true);settle();w=g.deep.world;h=g.surface.house
 check(HoldEstateCellar.plans(g).size()==1 and not HoldEstateCellar.plans(g)[0].built,"Unbuilt connection survives real reload")
 stand(LANDING);check(HoldEstateCellar.forget(g),"Unbuilt guide may be removed")
 check(normal(g.state.deepworks.claim.layers)==terrain,"Removing guide leaves existing mine untouched")
 check(HoldEstateCellar.plan(g),"Replan connection without paying")
 g.change_zone("mine");settle();w=g.deep.world;stand(Vector2i(54,32))
 var ep=g.deep.works.blueprints
 check(ep.save_rectangle(Vector2i(50,30),Vector2i(58,38)),"Plan aligned cellar chamber in existing claim mine")
 var room_id=ep.selected;var cells=ep.cells(ep.chosen());var remaining=cells.filter(func(c):return w.at(c)!=0);var mined=g.state.mined
 for attempt in 150:
  if remaining.is_empty():break
  var worked=false
  for c in remaining:
   for d in Deepworks.DIRS:
    if not w.walkable(c+d) or w.route(Deepworks.cell(g.player),0,"",c+d).is_empty():continue
    stand(c+d);g.deep.contact=Deepworks.center(c)
    for hit in 20:
     if w.at(c)==0:break
     g.deep.hit(c)
    if w.at(c)==0:remaining.erase(c);worked=true
    break
   if worked:break
  if not worked:break
 check(remaining.is_empty(),"Excavate cellar through reachable normal mining contacts")
 check(g.state.mined>mined and not g.handworks.data().loose.is_empty(),"Actual excavation produces physical mining cargo")
 check(ep.prepare_room(),"Cleared cellar becomes a furnishing space")
 check(not HoldEstateCellar.fit(g),"Fitting is local to the surface landing")
 g.surface.enter("claim",Deepworks.center(LANDING));settle();stand(LANDING);w=g.deep.world
 stand(Vector2i(54,37));g.surface.start_placement("bed");check(g.surface.place(Deepworks.center(Vector2i(52,37))),"Furnish the surface home with an actual bed")
 stand(LANDING)
 var wood=g.state.count("wood");g.state.inventory.wood=0
 check(not HoldEstateCellar.fit(g),"Missing stair materials block fitting")
 check(not HoldEstateCellar.plans(g)[0].built and g.state.count("wood")==0,"Missing materials preserve unbuilt plan")
 g.state.inventory.wood=wood
 var paid=normal(g.state.inventory);var geology=normal(w.data.layers);var mined_before=g.state.mined
 check(HoldEstateCellar.fit(g),"Fit paid stairs after both landings and approach are clear")
 for item in HoldEstateCellar.COST:check(g.state.count(item)==int(paid[item])-int(HoldEstateCellar.COST[item]),"Exact stair cost for "+item)
 check(normal(w.data.layers)==geology and g.state.mined==mined_before,"Fitting neither deletes geology nor awards ore")
 paid=normal(g.state.inventory);check(not HoldEstateCellar.fit(g),"Repeated fitting is rejected")
 check(normal(g.state.inventory)==paid,"Repeated fitting never charges again")
 check(not HoldEstateCellar.forget(g),"Built connection cannot be erased by guide removal")
 stand(LANDING+Vector2i(0,2));check(not g.surface.house.build(Deepworks.center(LANDING),"remove"),"Landing foundation cannot be recovered beneath the stair")
 check(not g.surface.house.build(Deepworks.center(LANDING),"wall"),"Construction cannot block built landing")
 check(not g.handworks.can_place(Deepworks.center(LANDING)),"Equipment cannot occupy stair landing")
 stand(LANDING)
 check(g.handworks.build("cart",Deepworks.center(LANDING+Vector2i(2,2))),"Build a real cart beside the surface stair")
 var cart=g.handworks.data().facilities.back();cart.hitched=true
 shift_e();check(g.zone=="claim" and cart.area=="surface:claim:0","Hitched cart cannot silently cross cellar boundary")
 cart.hitched=false;g.notice_time=0;await snap("01-home-stair")
 g.surface.architecture.room_planning=true;g.open_panel("architecture");await process_frame
 for scroll in g.panel.find_children("*","ScrollContainer",true,false):scroll.scroll_vertical=10000
 await snap("03-cellar-controls");g.close_panel()
 var carried=normal(g.state.inventory);shift_e();settle()
 check(g.zone=="mine" and g.state.active_site=="claim" and g.deep.world.depth()==0,"Shift+E travels from home into its actual claim mine")
 check(Deepworks.cell(g.player)==LANDING,"Surface and cellar landing coordinates align")
 check(normal(g.state.inventory)==carried,"Carried resources survive descent unchanged")
 check(g.deep.world.carve_stairs(LANDING).contains("home cellar landing"),"Deeper stairs cannot overwrite cellar landing")
 check(g.deep.works.model.place(LANDING,"bed").contains("cellar"),"Mine furnishings cannot block cellar stair")
 ep=g.deep.works.blueprints;ep.selected=room_id
 check(g.deep.works.model.place(Vector2i(52,35),"bed").ends_with("installed."),"Furnish cellar through existing room model")
 stand(Vector2i(56,36));check(g.handworks.build("store",Deepworks.center(Vector2i(57,37))),"Build real cellar storage")
 var store=g.handworks.data().facilities.back();check(g.handworks.deposit(store)>0,"Store carried supplies in cellar pallet")
 var facilities=normal(g.handworks.data().facilities);var furniture=normal(g.deep.works.model.data.furniture)
 stand(LANDING);await snap("02-cellar-stair");g.save_game()
 g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle()
 check(g.zone=="mine" and Deepworks.cell(g.player)==LANDING,"Reload resumes inside cellar at persistent landing")
 check(normal(g.handworks.data().facilities)==facilities and normal(g.deep.works.model.data.furniture)==furniture,"Reload preserves cellar storage contents and furnishings")
 check(g.handworks.prompt().contains("return home"),"Stair prompt matches Shift+E priority over loose cargo")
 var old_floor=HoldEstateCellar.home(g).building.tiles["54,34"].duplicate(true)
 HoldEstateCellar.home(g).building.tiles["54,34"].wall="wall"
 shift_e();check(g.zone=="mine","Blocked destination prevents travel instead of moving player elsewhere")
 HoldEstateCellar.home(g).building.tiles["54,34"]=old_floor
 shift_e();settle();check(g.surface.active() and g.surface.area=="claim" and Deepworks.cell(g.player)==LANDING,"Shift+E returns to exact home landing after reload")
 check(g.state.surface.decor.any(func(d):return d.kind=="bed" and d.area=="claim"),"Surface furnishing survives cellar trip and reload")
 g.save_game();g.start_game(true);settle();check(g.zone=="claim","Surface save reload stays in the home")
 stand(LANDING);shift_e();settle();check(g.zone=="mine","Surface reload retains usable cellar connection")
 stand(LANDING+Vector2i(2,0));shift_e();check(g.zone=="mine","Stair cannot be used remotely")
 g.state.switch_site("hold",g.geo);g.deep.ensure();check(not HoldEstateCellar.travel(g),"Other mine cannot use household stairs")
 print("CELLAR156: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
