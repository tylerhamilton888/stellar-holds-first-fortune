extends "res://tests/support/game_fixture.gd"
func visit(id:String):
 if id.begins_with("road_folk:"):
  var index=int(id.get_slice(":",1));var area=HoldRoads.FOLK[index].area
  if index==10 and HoldRidgePair124.paired(g.state):area="room:wayfarer"
  g.surface.enter(area);settle()
  for a in g.surface.roads.people(area):
   if a.interaction==id:at(a.p+Vector2(0,22));break
 else:
  g.state.active_site="hold";g.surface.enter("room:"+HoldNpcPresence.HOMES[id].room);settle();at(Vector2(620,450))
 HoldConversation.start(g,id)
func routes(scene):
 for a in scene.cast:
  for t in [0.0,.5,1.0]:check(g.surface.walkable(a.from.lerp(a.to,t)),"Clear scene route "+scene.friend_id+" beat "+str(scene.step)+" "+a.id)
func shot(name:String):
 g.queue_redraw()
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 check(HoldFriendship130.STORIES.size()==12,"Twelve authored characters with friendship stories")
 var decor=g.state.surface.decor.duplicate(true);var chests=g.state.surface.chests.duplicate(true)
 var romance=HoldCourtship101.all(g.state).duplicate(true)
 for id in HoldFriendship130.STORIES:
  visit(id);check(HoldConversation.local(g,id),"Reachable host: "+id)
  for index in 3:
   visit(id);var e=HoldFriendship130.episode(g.state,id);var d=HoldFriendship130.record(g.state,id)
   check(d.index==index and int(e.bond)==[5,12,18][index],"Sequential friendship threshold: "+id+" "+str(index))
   for item in e.cost:check(HoldData.ITEMS.has(item),"Valid task supply "+item)
   for item in e.reward:check(HoldData.ITEMS.has(item),"Valid reward "+item)
   HoldPeople.records(g.state)[id].bond=int(e.bond)-1
   check(not HoldFriendship130.accept(g,id),"Story cannot be accepted below threshold")
   HoldPeople.records(g.state)[id].bond=int(e.bond)
   g.player+=Vector2(500,0)
   # Principal conversations use their existing room-local boundary.
   if id.begins_with("road_folk:"):check(not HoldFriendship130.accept(g,id),"Remote story callback rejected")
   visit(id);button("Friendship stories");button("I'd be glad to help")
   check(d.accepted and not d.worked,"Local offer accepts optional story")
   check(not HoldFriendship130.accept(g,id),"Repeated acceptance is inert")
   check(not HoldFriendship130.begin_scene(g,id),"Scene cannot bypass its task")
   var p=Vector2(d.pos[0],d.pos[1]);check(g.surface.walkable(p),"Errand has a clear approach")
   at(p+Vector2(250,0));check(not HoldFriendship130.work(g,id,e.answer),"Work cannot be performed remotely")
   at(p);g.close_panel();key(KEY_E)
   check(g.panel_id=="friend130","Physical errand opens its own task panel")
   if id=="road_folk:11" and index==1:await shot("maren-errand")
   for item in e.cost:g.state.inventory[item]=0
   if not e.cost.is_empty():check(not HoldFriendship130.work(g,id,e.answer),"Missing supplies block work without granting story")
   for item in e.cost:g.state.add(item,int(e.cost[item]))
   var before=g.state.inventory.duplicate(true)
   check(not HoldFriendship130.work(g,id,1-int(e.answer)) and g.state.inventory==before,"Wrong practical answer costs nothing")
   HoldPeople.records(g.state)[id].bond=0
   button(e.choices[e.answer]);check(d.worked,"Accepted story remains playable after friendship falls")
   var paid=g.state.inventory.duplicate(true)
   check(not HoldFriendship130.work(g,id,e.answer) and g.state.inventory==paid,"Task cost cannot be paid twice")
   visit(id);g.handworks.data().carry=[{"kind":"stone","count":1}]
   check(not HoldFriendship130.begin_scene(g,id),"Carried load prevents scene without losing task")
   g.handworks.data().carry=[]
   var xp=HoldDisciplines.xp(g.state,e.path);var inventory=g.state.inventory.duplicate(true)
   button("Friendship stories");button("Spend time together");settle()
   check(g.opening_scene is HoldFriendScene130,"Friendship scene starts: "+e.title)
   if not g.opening_scene is HoldFriendScene130:continue
   g.opening_scene.set_process(false)
   check(not g.calendar_button.visible and not g.energy_button.visible,"Scene hides interactive HUD")
   check(not HoldFriendship130.begin_scene(g,id),"Cannot overlap scenes")
   if id=="road_folk:11" and index==1:
    var scene=g.opening_scene;scene.tick(2);scene.advance();scene.tick(.3)
    g.save_game();g.start_game(true);settle();g.opening_scene.set_process(false)
    check(g.opening_scene is HoldFriendScene130 and g.opening_scene.step==1,"Table flip resumes saved beat after reload")
    check(g.state.inventory==inventory,"Reload cannot repeat task payment or grant early rewards")
    for frame in 5:
     g.opening_scene.tick(.3);await shot("maren-flip-"+str(frame))
    check(g.opening_scene.tilt>2.5,"Table visibly overturns")
   var scene=g.opening_scene
   routes(scene)
   if id in ["road_folk:2","borin"] and index==2:scene.tick(2);scene.advance();scene.tick(1.2);await shot(id.replace(":","-")+"-close")
   if index==0:
    scene.tick(.1);var beat=scene.step;scene.advance();check(scene.step==beat,"Continue waits for visible action")
    scene.finish()
   else:
    while g.opening_scene is HoldFriendScene130:
     routes(g.opening_scene)
     g.opening_scene.tick(3);g.opening_scene.advance()
   check(g.opening_scene==null and g.hud.visible,"Scene returns control and HUD")
   check(HoldFriendship130.record(g.state,id).index==index+1,"Completed story advances once")
   check(HoldDisciplines.xp(g.state,e.path)==xp+int(e.xp),"Relevant experience awarded once")
   for item in e.reward:check(g.state.count(item)==int(inventory.get(item,0))+int(e.reward[item]),"Exact item reward: "+item)
   var rewarded=g.state.inventory.duplicate(true)
   check(not HoldFriendship130.complete(g,id,index) and g.state.inventory==rewarded,"Stale completion cannot repeat rewards")
   check(g.state.surface.decor==decor and g.state.surface.chests==chests,"Real furnishings and storage preserved")
  check(HoldFriendship130.record(g.state,id).memories.size()==3,"Three persistent friendship memories: "+id)
 check(HoldCourtship101.all(g.state)==romance,"Friendship stories never start or change romance")
 var saved=HoldFriendship130.data(g.state).duplicate(true);g.save_game();g.start_game(true);settle()
 check(HoldFriendship130.data(g.state)==saved,"All stories, choices and keepsakes survive reload")
 # An established NPC couple stays available for friendship stories.
 g.state.surface.erase("friendship130")
 HoldCourtship101.record(g.state,"road_folk:1").stage=1;HoldRidgePair124.advance(g.state)
 visit("road_folk:11");HoldPeople.records(g.state)["road_folk:11"].bond=20
 check(HoldRidgePair124.paired(g.state) and not HoldCourtship101.eligible(g.state,"road_folk:11") and HoldFriendship130.accept(g,"road_folk:11"),"Coupled Maren remains fully available for friendship")
 # Interrupt a fresh, already-paid story at title; resume without replaying work.
 g.state.surface.erase("friendship130");visit("road_folk:11");HoldPeople.records(g.state)["road_folk:11"].bond=20
 HoldFriendship130.accept(g,"road_folk:11");var d=HoldFriendship130.record(g.state,"road_folk:11");at(Vector2(d.pos[0],d.pos[1]));g.state.add("turnip",2);HoldFriendship130.work(g,"road_folk:11",0);visit("road_folk:11");HoldFriendship130.begin_scene(g,"road_folk:11");settle()
 g.opening_scene.set_process(false);g.show_title();await process_frame
 check(g.opening_scene==null,"Title clears staged scene nodes")
 g.start_game(true);settle();check(g.opening_scene is HoldFriendScene130,"Continue resumes interrupted friendship scene")
 if g.opening_scene is HoldFriendScene130:g.opening_scene.finish()
 g.open_panel("roster")
 for search in g.panel_body.find_children("*","LineEdit",true,false):search.text="Maren";search.text_changed.emit("Maren")
 var memory_visible=false
 for label in g.panel_body.find_children("*","Label",true,false):
  if label.text.begins_with("Memory ·") and label.is_visible_in_tree():memory_visible=true
 check(memory_visible,"People screen displays the saved friendship memory")
 await shot("friendship-memories")
 # Starting a different fortune cannot retain the prior staged cast or story.
 visit("road_folk:11");HoldFriendship130.accept(g,"road_folk:11")
 d=HoldFriendship130.record(g.state,"road_folk:11");at(Vector2(d.pos[0],d.pos[1]));g.state.add("barley_bread",2);HoldFriendship130.work(g,"road_folk:11",0)
 visit("road_folk:11");HoldFriendship130.begin_scene(g,"road_folk:11");settle()
 g.start_game(false);settle();await process_frame
 check(g.opening_scene==null and HoldFriendship130.data(g.state).records.is_empty(),"A different fortune clears staged actors and uses its own friendship records")
 print("FRIENDSHIP130: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
