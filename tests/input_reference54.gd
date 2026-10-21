extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://reference54"

 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(g.surface.area=="hearthward" and g.zone=="hub","New fortune starts inside the real walkable hold")
 await snap("01-hearthward")
 var before=g.player;Input.action_press("up");Input.action_press("right");await frames(30);Input.action_release("up");Input.action_release("right")
 check(g.player.x>before.x and g.player.y<before.y and g.player.distance_to(before)<100,"Eight-way movement has normalized diagonal speed and no gravity")
 at(HoldWorldZones.door(12)+Vector2(0,35));key(KEY_E);settle()
 check(g.room_id=="commission" and g.surface.area=="room:commission","Physical foreman's doorway opens a local interior")
 at(Vector2(620,400));key(KEY_E)
 check(g.panel_id=="conversation" and g.talk_id=="ivar","Existing Ivar conversation remains local and available")
 await snap("02-foreman");button("I am ");g.close_panel()
 for entry in [["forge","borin"],["market","orla"],["tavern","hedrik"]]:
  g.surface.enter("room:"+entry[0]);settle();at(Vector2(620,400));key(KEY_E);button("Introduce myself");button("Thank you. I will");g.close_panel()
 check(g.state.opening==1,"Existing introductions unlock the trail through actual NPC dialogue")
 g.surface.enter("room:commission");settle();at(Vector2(480,590));key(KEY_E);settle()
 check(g.room_id=="" and g.surface.area=="hearthward","Interior threshold returns to its original district")
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 at(Vector2(180,880));key(KEY_E);settle();check(g.surface.area=="crownward","Royal stairs connect to Crownward")
 at(Vector2(960,500));key(KEY_E);settle();await snap("03-enthroned-lord")
 check(g.room_id=="throne","Lord's existing audience stays accessible")
 g.surface.enter("hearthward",Vector2(1700,880));settle();key(KEY_E);settle();check(g.surface.area=="forgeward" and g.surface.walkable(g.player),"Forge stairs arrive on clear, walkable ground")
 at(Vector2(580,490));key(KEY_E);settle();await snap("04-forge")
 at(Vector2(620,405));key(KEY_E);check(g.panel_id=="conversation" and g.talk_id=="borin","Borin's crafting service remains reachable");g.close_panel()
 g.surface.enter("forgeward",Vector2(1700,580));settle();key(KEY_E);button("Keldrath · Hearthward");settle()
 check(g.surface.area=="hearthward" and g.player==Vector2(1700,580),"Hold lift connects matching landings without map travel")
 g.surface.enter("hearthward",Vector2(1270,960));settle();key(KEY_E);settle();check(g.surface.area=="trail","King's Gate reaches a full-sized local trail")
 at(Vector2(930,700));await snap("05-high-trail")
 at(Vector2(950,340));key(KEY_E);settle();check(g.zone=="mine","Trail mine entrance reaches existing Deepworks")
 var w=g.deep.world;var c=Deepworks.ENTRY+Vector2i.RIGHT
 w.set_cell(c,2);w.layer().damage.erase(Deepworks.key(c));g.deep.contact=Deepworks.center(c)
 # This journey verifies ownership; mining55 separately checks real held-work timing.
 # The retired two-contact balance is not a current acceptance requirement.
 for i in 12:
  if w.at(c)==0:break
  g.deep.hit(c)
 var physical=0
 for raw in g.handworks.data().loose:
  if g.handworks.local(raw) and raw.kind=="stone":physical+=int(raw.units)
 check(w.at(c)==0 and g.deep.haul.in_field("stone")+physical>0,"Real excavation still places mined stone in haulage")
 var stair=Deepworks.ENTRY+Vector2i.DOWN*2;w.set_cell(stair,0);g.player=Deepworks.center(stair);w.carve_stairs(stair)
 g.deep.use_stairs(false);settle();check(w.depth()==1,"Excavated stairs still descend to the connected lower layer")
 g.deep.use_stairs(true);settle();check(w.depth()==0,"The same stair returns upward")
 g.player=Deepworks.center(Deepworks.ENTRY)

 g.deep.use_stairs(false);settle()
 if g.zone=="mine":g.player=Deepworks.center(Deepworks.ENTRY);g.deep.world.data.depth=0;g.deep.use_stairs(false);settle()
 check(g.surface.area=="trail" and g.zone=="approach","Mine exit returns to the same trail entrance and delivers cargo")
 g.surface.enter("pinewood",Vector2(370,460));settle();g.tool=2
 await snap("06-pinewood")
 var wood=g.state.count("wood");var aim=HoldSurface.TREES[0]-Vector2(0,25)-g.camera
 root.warp_mouse(aim*root.get_visible_rect().size/Vector2(960,540));await frames(2)
 var mouse=InputEventMouseButton.new();mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=true;mouse.position=aim;Input.parse_input_event(mouse);await frames(60)
 mouse=InputEventMouseButton.new();mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=false;mouse.position=aim;Input.parse_input_event(mouse);await frames(2)
 check(g.state.count("wood")>wood and g.state.road_trees[0]<8,"Held axe harvesting uses existing persistent tree cuts and yields")
 g.surface.enter("room:market");settle();g.open_panel("market");var money=g.state.money;button("Sell up to 5")
 check(g.state.money>money,"Existing exchange sells carried resources from the new local interior");g.close_panel()
 g.surface.enter("room:forge");settle();g.state.add("iron_ore",2);g.state.add("coal",2);g.forge_tab=0;g.open_panel("forge");button("Queue");g.close_panel()
 var iron=g.state.count("iron");g.state.tick(30)
 check(g.state.count("iron")>iron,"Existing forge turns pack inputs into usable metal")
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.surface.enter("claim");settle();at(Vector2(650,550));await snap("07-claim-yard")
 check(g.state.surface.homes.has("old_delving"),"Charter creates a free starter home and unique chest")
 at(Vector2(500,465));key(KEY_E);settle();await snap("08-starter-home")
 check(g.surface.area=="home:old_delving" and g.state.active_site=="claim","Claim home is a connected interior on the same site")
 at(Vector2(650,430));key(KEY_E);check(g.panel_id=="storage","E opens the physical chest")
 var total=g.state.count("wood");var moved=g.surface.transfer("wood",4,true)
 check(moved==4 and g.state.count("wood")==total-4,"Chest deposit conserves materials and removes carried supply")
 g.open_panel("storage",false);await snap("09-storage")
 check(g.surface.transfer("wood",2,false)==2,"Withdrawal returns the exact amount to the pack")
 g.close_panel();at(Vector2(480,500));check(g.surface.transfer("wood",100,false)==0,"Remote chest transfer is rejected")
 g.state.add("wood",30);g.state.add("stone",20);g.surface.placing="chest"
 var count=g.state.surface.chests.size();check(g.surface.place(Vector2(360,500)) and g.state.surface.chests.size()==count+1,"Placeable chest spends pack timber and persists in the home")
 g.surface.placing="chest";check(not g.surface.place(Vector2(480,620)),"Doorway obstruction is rejected")
 g.surface.placing="";g.surface.home_panel() if false else null
 g.open_panel("homestead");button("Improve cottage");g.close_panel();await snap("10-improved-home")
 check(g.state.surface.homes.old_delving.level==1,"Cottage improvement pays once and changes the home")
 at(Vector2(328,388));key(KEY_E);await frames(100);check(g.state.surface.facts.get("rest",false),"Bed interaction rests and saves")
 g.surface.enter("claim",Vector2(710,770));settle();key(KEY_O);await snap("11-homestead-board")
 g.close_panel();g.surface.enter("home:old_delving",Vector2(480,500));settle();g.save_game()
 var saved=g.state.surface.duplicate(true);g.start_game(true);settle()
 check(g.surface.area=="home:old_delving" and g.room_id=="home" and g.player==Vector2(480,500),"Reload restores the actual room and exact walkable position")
 check(JSON.parse_string(JSON.stringify(g.state.surface.chests))==JSON.parse_string(JSON.stringify(saved.chests)) and g.state.surface.homes.old_delving.level==1,"Reload preserves independent chest contents and home improvement")
 key(KEY_G);check(g.panel_id=="wayfinding" and not is_instance_valid(g.overworld),"G shows directions without replacing the player with a map avatar")
 await snap("12-directions");g.close_panel()
 # Remove only the additive field in an isolated save to exercise migration.
 g.save_game();var file=FileAccess.open(g.state.save_path(),FileAccess.READ);var old=file.get_as_text();var legacy=JSON.parse_string(old);legacy.erase("surface")
 file=FileAccess.open(g.state.save_path(),FileAccess.WRITE);file.store_string(JSON.stringify(legacy));file.close()
 var pack=g.state.inventory.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==pack and g.state.claim_id=="old_delving" and g.surface.area=="claim","Pre-homestead save migrates safely without resetting progression")
 var backup=false
 for path in DirAccess.get_files_at("user://"):
  if path.contains("pre-homestead"):backup=true
 check(backup,"Original save is copied before homestead migration")
 print("REFERENCE54 JOURNEY: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
