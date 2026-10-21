extends "res://tests/support/game_fixture.gd"
func visit(id:String):
 g.surface.enter("room:"+id);settle()
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=2;HoldOnboarding.ensure(g.state).fresh=false
 check(not HoldAncestralClaim.act(g,"rescue"),"A journal cannot remotely accept the rescue")
 visit("commission");check(HoldAncestralClaim.act(g,"rescue"),"Ivar dispatches the player after proven work")
 g.surface.enter("trail");g.surface.action("mine");settle()
 var q=HoldAncestralClaim.data(g.state);var w=g.deep.world
 check(q.site.size()==2 and q.crew.size()==2,"Rescue occupies a persistent existing geological refuge")
 if q.site.is_empty():quit(1);return
 var c=Vector2i(int(q.site[0]),int(q.site[1]));var saved_cells=w.layer().cells.duplicate()
 HoldAncestralClaim.enter(g)
 check(saved_cells==w.layer().cells,"Rescue setup never overwrites existing terrain")
 check(HoldAncestralClaim.route(w,c,Deepworks.ENTRY).is_empty(),"The initial refuge requires a real excavated bypass")
 for i in 20:HoldAncestralClaim.tick(g,1.0)
 check(q.stage==1,"Time alone cannot rescue the crew")
 for x in range(Deepworks.ENTRY.x,c.x+1):
  var tile=Vector2i(x,Deepworks.ENTRY.y)
  for i in 24:
   if w.at(tile) not in [0,8]:g.deep.hit(tile)
 for y in range(Deepworks.ENTRY.y,c.y+1):
  var tile=Vector2i(c.x,y)
  for i in 24:
   if w.at(tile) not in [0,8]:g.deep.hit(tile)
 g.player=Deepworks.center(c);w.survey(g.player)
 await snap("01-refuge")
 check(HoldAncestralClaim.interact(g) and q.stage==2,"E starts evacuation only after a continuous walking route exists")
 for i in 80:HoldAncestralClaim.tick(g,.05)
 await snap("02-evacuation")
 g.save_game();g.start_game(true);settle();q=HoldAncestralClaim.data(g.state)
 check(q.stage==2 and q.site.size()==2,"Mid-rescue positions and objective survive reload")
 for i in 1600:HoldAncestralClaim.tick(g,.05)
 check(q.stage==3 and q.crew.all(func(a):return a.home),"Both miners physically walk home before the tablet becomes available")
 check(not HoldAncestralClaim.act(g,"appoint"),"Undeciphered evidence cannot grant a holding")
 visit("research");check(HoldAncestralClaim.act(g,"examine"),"Eldric preserves the tablet and opens evidence research")
 check(not HoldAncestralClaim.act(g,"translate"),"Translation requires archive and family evidence")
 visit("throne");check(HoldAncestralClaim.act(g,"archive"),"The Lord supplies the charter register")
 visit("commission");check(HoldAncestralClaim.act(g,"family"),"Ivar supplies the registered family record")
 visit("research");check(HoldAncestralClaim.act(g,"translate"),"Evidence authenticates script, descent and reclamation rights")
 g.talk_id="eldric";g.talk_topic="ancestral";g.open_panel("conversation");await snap("03-research")
 check(g.panel.get_global_rect().end.y<=g.get_viewport_rect().size.y,"Research conversation stays inside the visible window")
 g.close_panel()
 visit("throne");var money=g.state.money
 check(HoldAncestralClaim.act(g,"appoint") and g.state.claim_id=="old_delving" and q.title=="Overseer","The Lord appoints an Overseer of nearby Old Delving, not Keldrath")
 check(g.state.money==money and not HoldAncestralClaim.act(g,"appoint"),"Ancestral appointment is not a purchase or repeatable grant")
 check(not HoldAncestralClaim.act(g,"invest"),"Thane requires a functioning settlement")
 g.state.camp_stage=3;HoldOutpost.ensure(g.state);g.state.outpost.crew={"brann":{"role":"miner"},"osvik":{"role":"smith"}};g.state.add("food",12);g.state.add("water",12)
 check(HoldAncestralClaim.act(g,"invest") and q.title=="Thane","Developed works, Folk and supplies permit investiture")
 g.talk_id="eirik";g.talk_topic="ancestral";g.open_panel("conversation");await snap("04-thane")
 check(g.panel.get_global_rect().end.y<=g.get_viewport_rect().size.y,"Investiture controls stay inside the visible window")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(HoldAncestralClaim.data(g.state).title=="Thane","Title and recognition survive reload")
 q=HoldAncestralClaim.data(g.state);q.stage=5;g.state.claim_id="copper_ridge";g.state.camp_stage=3;visit("throne")
 check(HoldAncestralClaim.act(g,"appoint") and g.state.claim_id=="copper_ridge" and g.state.camp_stage==3,"Existing purchased holdings and construction are never replaced")
 print("ANCESTRAL70: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
