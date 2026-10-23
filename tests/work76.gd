extends "res://tests/support/game_fixture.gd"
func station(kind:String,p:Vector2,owner:String="")->Dictionary:
 var h=g.handworks
 var f={"id":"work76:"+str(h.data().facilities.size()),"kind":kind,"area":h.context(),"x":p.x,"y":p.y,"raw":[],"cargo":{},"job":{},"hitched":false,"owner":owner}
 h.data().facilities.append(f);return f
func raw(kind:String,units:int,item:String="")->Dictionary:
 return {"id":9000+units,"kind":kind,"units":units,"item":item if item!="" else "wood" if kind=="log" else "stone","source":"work76"}
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var h=g.handworks
 var breaker=station("breaker",Vector2(940,600));var saw=station("saw",Vector2(1160,600))
 var rack=station("stone_pile",Vector2(840,600));var timber=station("timber_pile",Vector2(1160,480));var pallet=station("store",Vector2(1040,600))
 at(Vector2(940,680));await snap("01-empty-workshop")
 for i in 5:
  var tex=h.texture(i);check(tex.get_width()>100 and tex.get_height()>100,"Upright station texture loads: "+str(i))
 pallet.cargo={"stone":7,"wood":9};var original_store=pallet.cargo.duplicate()
 breaker.cargo={"stone":6,"iron_ore":3};breaker.job={"raw":raw("stone",4),"progress":.6}
 var stone=g.state.count("stone");var ore=g.state.count("iron_ore")
 g.save_game();g.start_game(true);settle();h=g.handworks
 breaker=h.data().facilities.filter(func(f):return f.id==breaker.id)[0]
 saw=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="saw")[0]
 rack=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="stone_pile")[0]
 timber=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="timber_pile")[0]
 pallet=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="store")[0]
 check(int(breaker.cargo.get("stone",0))==6 and int(breaker.cargo.get("iron_ore",0))==3 and is_equal_approx(breaker.job.progress,.6),"Older saved output and partial work survive loading unchanged")
 at(Vector2(940,665));key(KEY_E)
 check(breaker.cargo.is_empty() and g.state.count("stone")==stone+6 and g.state.count("iron_ore")==ore+3,"Plain E collects all older bench output without Shift")
 check(is_equal_approx(breaker.job.progress,.6) and breaker.job.raw.units==4,"Collecting old output does not consume or restart the saved job")
 Input.action_press("interact");await frames(150);Input.action_release("interact")
 check(breaker.job.is_empty() and breaker.cargo.is_empty() and g.state.count("stone")==stone+10,"Resumed player work delivers its exact yield automatically")
 check(pallet.cargo.size()==original_store.size() and int(pallet.cargo.get("stone",0))==7 and int(pallet.cargo.get("wood",0))==9,"Player work leaves previously stored pallet materials untouched")
 var done=g.state.inventory.duplicate();key(KEY_E);Input.action_press("interact");await frames(30);Input.action_release("interact")
 check(g.state.inventory==done and h.data().carry.is_empty(),"Repeating E on the empty bench neither duplicates output nor lifts raw supplies")
 saw.raw.append(raw("log",5));var wood=g.state.count("wood")
 at(Vector2(1160,660));Input.action_press("interact");await frames(80);await snap("02-saw-contact");await frames(100);Input.action_release("interact")
 check(g.state.count("wood")==wood+5 and saw.job.is_empty() and saw.cargo.is_empty(),"Sawing sends the log's full explicit yield directly to the pack")
 breaker.raw.append(raw("stone",4,"copper_ore"));at(Vector2(940,665));Input.action_press("interact");await frames(78);await snap("03-stone-contact");Input.action_release("interact")
 check(not breaker.job.is_empty(),"Released work retains its single reserved raw input")
 var saved_job=breaker.job.duplicate(true);var copper=g.state.count("copper_ore")
 g.save_game();g.start_game(true);settle();h=g.handworks;breaker=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="breaker")[0]
 check(is_equal_approx(breaker.job.progress,saved_job.progress) and int(breaker.job.raw.id)==int(saved_job.raw.id) and int(breaker.job.raw.units)==4 and breaker.job.raw.item=="copper_ore" and g.state.count("copper_ore")==copper,"Interrupted work preserves progress without early output on reload")
 Input.action_press("interact");await frames(100);Input.action_release("interact")
 check(g.state.count("copper_ore")==copper+4 and breaker.job.is_empty(),"Reloaded mineral job completes exactly once into the pack")
 HoldDisciplines.award(g.state,"masonry",16);g.state.tech.stoneworking=true
 check(HoldDisciplines.learn(g.state,"stone_finish"),"Existing stone finishing technique remains learnable")
 breaker.raw.append(raw("stone",2));stone=g.state.count("stone");var xp=HoldDisciplines.xp(g.state,"masonry")
 Input.action_press("interact");await frames(90);Input.action_release("interact")
 check(g.state.count("stone")==stone+3 and HoldDisciplines.xp(g.state,"masonry")==xp+1,"Automatic delivery retains the mastery bonus and one completed-work credit")
 saw=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="saw")[0]
 HoldDisciplines.award(g.state,"woodworking",12);check(HoldDisciplines.learn(g.state,"sawyer"),"Existing sawyer technique remains learnable")
 saw.raw.append(raw("log",2));wood=g.state.count("wood");at(Vector2(1160,660))
 Input.action_press("interact");await frames(80);await snap("03b-saw-contact");await frames(100);Input.action_release("interact")
 check(g.state.count("wood")==wood+3 and saw.cargo.is_empty(),"Automatic sawing delivery retains the one-unit mastery bonus")
 var crew=station("breaker",Vector2(720,600),"hold");crew.cargo={"stone":8};crew.raw.append(raw("stone",2))
 at(Vector2(720,660));done=g.state.inventory.duplicate();key(KEY_E)
 check(not h.begin(crew) and h.collect_output(crew)==0 and h.withdraw(crew)==0,"Hold crew input and output reject every player collection path")
 check(crew.cargo=={"stone":8} and crew.raw.size()==1 and g.state.inventory==done,"Rejected crew interactions conserve all materials")
 var remote=crew.duplicate(true);remote.owner="";remote.area="mine:hold:9"
 check(not h.begin(remote) and h.collect_output(remote)==0,"Other zones cannot be collected remotely")
 # Real rack contents, with one whole painted shoulder load and two-load carry.
 rack=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="stone_pile")[0];timber=h.data().facilities.filter(func(f):return h.local(f) and f.kind=="timber_pile")[0]
 for i in 12:rack.raw.append(raw("stone",2));timber.raw.append(raw("log",2))
 at(Vector2(950,710));h.data().carry.append(raw("stone",4));h.lift=0
 await snap("04-full-workshop")
 h.data().skills.miner=12;h.data().carry.append(raw("log",3));await snap("05-two-loads")
 g.save_game();var appearance=g.state.appearance.duplicate(true);var count=h.data().facilities.size();g.start_game(true);settle()
 check(g.state.appearance==appearance and h.data().facilities.size()==count and h.data().carry.size()==2,"Existing appearance, facilities and supported cargo survive save/reload")
 g.open_panel("handworks");await snap("06-workshop-board")
 check(g.panel.get_global_rect().end.y<=g.get_viewport_rect().size.y,"Workshop controls and keyboard-help footer fit the viewport")
 g.close_panel()
 # Legacy personal cargo is retained but no extra bucket/rock is drawn over the
 # approved actor carrying a raw load. Verify actual entrance unloading too.
 h.data().carry.clear();g.surface.enter("trail");g.surface.action("mine");settle()
 g.deep.haul.bucket().clear();g.deep.haul.bucket().merge({"rough_block":3,"stone":4})
 h.spawn("stone",g.player,4,"carry-view");key(KEY_E);h.lift=0
 for direction in [Vector2.DOWN,Vector2.RIGHT,Vector2.UP,Vector2.LEFT]:
  g.surface.direction=direction;g.face=-1 if direction.x<0 else 1;await snap("07-carry-"+str([Vector2.DOWN,Vector2.RIGHT,Vector2.UP,Vector2.LEFT].find(direction)))
 var cargo=g.deep.haul.bucket().duplicate();g.save_game();g.start_game(true);settle()
 check(g.deep.haul.bucket().size()==cargo.size() and int(g.deep.haul.bucket().get("rough_block",0))==3 and int(g.deep.haul.bucket().get("stone",0))==4 and h.data().carry.size()==1,"Removing the visual bucket preserves all legacy personal cargo and shoulder records")
 var before=g.state.count("rough_block");g.deep.haul.unload(Deepworks.center(Deepworks.ENTRY))
 check(g.deep.haul.bucket().is_empty() and g.state.count("rough_block")==before+3,"Preserved legacy cargo still unloads through the existing entrance workflow")
 print("WORK76: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
