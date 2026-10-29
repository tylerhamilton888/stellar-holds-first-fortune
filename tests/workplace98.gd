extends "res://tests/support/game_fixture.gd"
func ticks(n:int):
 for i in n:HoldWorkplace98.tick(g,.1)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 g.dev.start("workplace");settle();var w=g.deep.world;var q=HoldWorkplace98.data(g);var h=g.handworks
 check(g.dev.mode()=="workplace" and not q.is_empty(),"Separate test save creates the old bay")
 check(not g.deep.works.model.data.rooms.has("old_cutters"),"Undiscovered room does not appear in the works catalogue")
 check(not q.found and q.person.is_empty(),"Unopened ruin has no artificial resident or completed flag")
 check(not h.objects().any(func(o):return o.has("facility") and str(o.facility.id).begins_with("workplace98:")),"Unknown equipment stays hidden behind the fallen passage")
 await snap("sealed-passage")
 # Real mining opens the old supply passage, leaving one obstruction in place.
 for y in range(12,int(q.y)):
  if y==13:continue
  g.player=Deepworks.center(Vector2i(8,y-1))
  for strike in 20:
   if w.at(Vector2i(8,y)) not in [0,8]:g.deep.hit(Vector2i(8,y))
 g.player=Deepworks.center(Vector2i(8,int(q.y)+2));w.survey(g.player);ticks(1)
 check(q.found,"Walking into the bay discovers its history")
 await snap("cold-bay")
 var c=HoldWorkplace98.hearth(q);g.player=Deepworks.center(c+Vector2i.DOWN)
 check(g.deep.works.model.place(c,"anvil").ends_with("installed."),"Repair uses ordinary furnishing placement and inventory costs")
 var coal=g.state.count("coal");key(KEY_E)
 check(HoldWorkplace98.warm(g) and g.state.count("coal")==coal-1,"Real E interaction fuels the repaired hearth exactly once")
 key(KEY_E);check(g.state.count("coal")==coal-1,"A warm hearth does not waste additional coal")
 ticks(20);check(q.person.is_empty(),"Warmth cannot summon a worker through a blocked supply passage")
 g.player=Deepworks.center(Vector2i(8,12))
 for strike in 20:
  if w.at(Vector2i(8,13))!=0:g.deep.hit(Vector2i(8,13))
 ticks(240)
 check(not q.person.is_empty() and HoldWorkplace98.position(q).distance_to(HoldWorkplace98.work_position(g))<4,"Odrin walks the actual reopened route to his bench")
 var rack=HoldWorkplace98.station(g,"rack");var bench=HoldWorkplace98.station(g,"bench")
 check(q.cuts==0 and bench.cargo.is_empty(),"An occupied workshop cannot invent materials without stock")
 g.player=h.pos(rack);h.spawn("stone",g.player,3,"rock:0:workplace98");h.data().carry.append(h.data().loose.pop_back());h.deposit(rack)
 ticks(30);g.player=Deepworks.center(Vector2i(int(q.x)+4,int(q.y)+4));w.survey(g.player)
 settle();await snap("working-bay")
 ticks(100)
 check(rack.raw.is_empty() and bench.job.is_empty() and int(bench.cargo.get("stone",0))==3 and q.cuts==3,"Resident consumes real raw stock and leaves exactly its processed yield")
 ticks(100);check(q.cuts==3 and int(bench.cargo.stone)==3,"Empty input cannot produce duplicate output")
 h.active_id=bench.id;h.approaching=true;ticks(60)
 check(HoldWorkplace98.position(q).distance_to(HoldWorkplace98.work_position(g))>30 and not q.person.work,"Resident physically steps away when the player uses his bench")
 h.active_id="";h.approaching=false;ticks(90)
 var stone=g.state.count("stone");h.collect_output(bench)
 check(g.state.count("stone")==stone+3 and bench.cargo.is_empty(),"Finished resident work joins ordinary player inventory")
 # Time spent in another zone advances only supplied, already occupied work.
 h.spawn("stone",h.pos(rack),2,"rock:0:away");rack.raw.append(h.data().loose.pop_back());ticks(1)
 g.surface.enter("trail");settle();g.state.elapsed+=30;HoldCalendar.data(g.state).minute+=18
 g.change_zone("mine");settle();ticks(1)
 check(q.cuts==5 and int(bench.cargo.get("stone",0))==2,"Returning from elsewhere finds actual supplied work completed")
 g.save_game();g.start_game(true,{},true);settle();w=g.deep.world;q=HoldWorkplace98.data(g);h=g.handworks
 check(q.found and q.cuts==5 and HoldWorkplace98.warm(g) and not q.person.is_empty(),"Discovery heat resident and work history survive reload")
 HoldCalendar.data(g.state).minute=740;ticks(70)
 check(q.status=="Warming his hands","Calendar lunch break sends the resident to the hearth")
 await snap("hearth-break")
 HoldCalendar.data(g.state).minute=800
 w.set_cell(Vector2i(8,int(q.y)-1),2);ticks(160)
 check(q.status=="Waiting for the passage to clear" and not q.person.work,"A new obstruction stops work and strands the resident without teleporting")
 w.set_cell(Vector2i(8,int(q.y)-1),0);q.warm_until=0;ticks(260)
 check(q.person.is_empty(),"A cold workplace sends Odrin home along the clear route")
 g.player=Deepworks.center(c+Vector2i.DOWN);key(KEY_E);ticks(250)
 check(not q.person.is_empty(),"Relighting the hearth brings the same resident back")
 g.player=Deepworks.center(Vector2i(int(q.x)+4,int(q.y)+5));w.survey(g.player)
 g.depth_nav.explore.mouse_look=false;g.depth_nav.toggle_view();g.depth_nav.update(0);settle();await snap("exploration-bay")
 check(g.depth_nav.explore.sprite_pool.has("workplace98:odrin"),"Original resident artwork appears in exploration view")
 # Room membership is optional for standalone/legacy furniture. Both views must draw it.
 g.depth_nav.toggle_view();g.player=Deepworks.center(Vector2i(8,10));w.survey(g.player)
 var pillar_cell=Vector2i(6,10);var pillar_key=w.link_key(pillar_cell,0)
 g.deep.works.model.data.furniture[pillar_key]={"x":6,"y":10,"depth":0,"kind":"pillar","solid":true}
 g.deep.works.model.refresh();g.save_game();g.start_game(true,{},true);settle();w=g.deep.world
 check(not g.deep.works.model.data.furniture[pillar_key].has("room"),"Legacy standalone furniture survives reload without a fabricated room")
 await snap("standalone-overhead")
 g.depth_nav.explore.enabled=true;g.depth_nav.explore.invalidate();g.depth_nav.update(0);await snap("standalone-exploration")
 check(g.depth_nav.explore.prop_pool.has("furniture:"+str(Deepworks.center(pillar_cell))),"Exploration captures standalone furniture without room membership")
 var saved_cells=w.layer().cells.duplicate();w.data.erase("workplace98");var existing=Deepworks.new(g.state)
 check(existing.layer().cells==saved_cells and not existing.data.has("workplace98"),"Loading an existing mine never inserts or overwrites a new ruin")
 print("WORKPLACE98: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
