extends "res://tests/support/game_fixture.gd"
func text_in_panel(needle:String)->bool:
 return g.panel.find_children("*","Label",true,false).any(func(l):return l.text.contains(needle))
func bar_clear(label:String):
 var feet=g.player-g.camera
 var actor=Rect2(feet-Vector2(24,80),Vector2(48,80))
 var bar=Rect2(250,g.hotbar.bar_y(),460,60)
 check(not bar.intersects(actor),label+" keeps the quick bar off the player")
 for i in 10:check(Rect2(0,0,960,498).encloses(g.hotbar.slot_rect(i)),label+" quick slot fits "+str(i))
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 await snap("01-title")
 g.first_visit_pending=true;g.start_game(false);settle()
 await snap("02-lodge");bar_clear("Bunkhouse")
 key(KEY_J);await snap("03-first-morning")
 check(text_in_panel("A word with Ivar") and not text_in_panel("180"),"First morning introduces the next action before later milestones")
 g.close_panel();at(Vector2(560,380));key(KEY_E);g.close_panel()
 g.surface.enter(HoldFrontier103.quarters(g.state));settle();await snap("04-room");bar_clear("Upstairs landing")
 g.surface.enter("trail",Vector2(950,345));settle();g.surface.action("mine");settle()
 await snap("05-mine");bar_clear("Mine entrance")
 check(g.footer.text.contains("Find your feet"),"Mine footer follows the same first-visit task as the journal")
 key(KEY_J);await snap("06-first-load");check(text_in_panel("Find your feet") and not text_in_panel("180"),"Mine journal shows a focused illustrated work step")
 g.close_panel();g.player+=Vector2(85,0);HoldFirstVisit99.tick(g);key(KEY_I);g.close_panel();HoldFirstVisit99.tick(g)
 var w=g.deep.world
 for c in [Vector2i(12,11),Vector2i(13,11)]:
  w.set_cell(c,2)
  for i in 8:
   if w.at(c)!=0:g.deep.hit(c)
 g.player=Vector2(500,460);key(KEY_E);HoldFirstVisit99.tick(g)
 g.player=Vector2(260,420);key(KEY_E);HoldFirstVisit99.tick(g)
 var money=g.state.money
 g.player=Vector2(220,345);Input.action_press("interact");await frames(300);Input.action_release("interact")
 check(HoldFirstVisit99.data(g.state).rewarded and g.state.money==money+20,"Real excavation and processing still pay the first wage")
 check(g.goal().contains("room above"),"The paid objective follows the promised room project")
 key(KEY_J);await snap("07-first-wages");check(text_in_panel("A corner that is yours") and not text_in_panel("Ore for the hearth"),"The journal agrees with the wage handoff")
 button("Choose a trade instead");check(text_in_panel("Ore for the hearth"),"Room furnishing stays optional with an explicit next route")
 HoldFirstVisit99.data(g.state).focus="home";g.close_panel()
 g.surface.enter(HoldFrontier103.lodge(g.state));settle();at(Vector2(560,380));key(KEY_E)
 check(text_in_panel("first twenty crowns"),"Ivar acknowledges completed work")
 await snap("08-ivar-paid");g.close_panel()
 g.surface.enter(HoldFrontier103.quarters(g.state));settle();g.player=Vector2(535,520);g.surface.placing="chair"
 check(g.surface.place(Vector2(600,520)),"Normal room furnishing consumes the existing supplies")
 key(KEY_J);check(text_in_panel("Ore for the hearth"),"A furnished room leads back to the trade lessons");await snap("09-next-trade")
 g.open_panel("frontier103");await snap("10-town-services")
 button("+ Around Stonebridge");check(text_in_panel("Survey hall & watch stores"),"Optional town directions remain accessible")
 g.close_panel();g.open_panel("inventory");await snap("11-pack");g.close_panel()
 for id in HoldRawArt135.IDS:
  var tex=HoldRawArt135.texture(id)
  check(tex.get_width()>300 and tex.get_height()>300,"Whole painted material resolves: "+id)
  check(HoldItemArt.item_index(id)==40+HoldRawArt135.IDS.find(id),"Pack and world use the same material: "+id)
 g.dev.arena(0);settle();g.combat.armed=false;g.player=Vector2(800,730);g.camera=g.deep.camera_target()
 for i in HoldRawArt135.IDS.size():
  var id=HoldRawArt135.IDS[i]
  g.handworks.spawn("log" if id=="wood" else "stone",Vector2(590+i*85,650),2,"review135:"+id,id)
 await snap("12-materials-in-world")
 g.player=g.camera+Vector2(480,455);bar_clear("Low screen position")
 g.save_game();var inventory=g.state.inventory.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==inventory,"Visual changes preserve the saved inventory")
 print("POLISH135: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
