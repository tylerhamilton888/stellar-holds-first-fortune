extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface;var titles={};var fronts={}
 for ward in HoldWorldZones.WARDS:
  s.enter(ward);settle()
  for p in [Vector2(480,545),Vector2(1310,650),Vector2(960,1000),Vector2(450,1530),Vector2(1400,1530)]:
   at(p);await snap(ward+"-"+str(int(p.x))+"-"+str(int(p.y)))
  for i in 3:
   var room=HoldNeighborhood.home_id(ward,i);titles[HoldNeighborhood.title(room)]=true
   var b=s.world.buildings().filter(func(item):return item.get("home","")==room)[0]
   fronts[str(HoldKeldrathArt.source(b).rect)]=true
   at(b.p+Vector2(0,15));key(KEY_E);settle()
   check(s.area==room,"Distinct household enters through its unchanged doorway: "+room)
   at(Vector2(480,570));await snap(ward+"-home-"+str(i))
   at(HoldNeighborhood.STAIR+Vector2(0,30));key(KEY_E);settle()
   var beds=s.world.room_objects().filter(func(o):return o.furnishing=="double_bed")
   check(s.area==room.left(-1)+"1" and beds.size()==1,"Family upper rooms contain one shared double bed")
   check(not s.walkable(beds[0].p-Vector2(0,30)) and s.walkable(beds[0].p+Vector2(60,-30)),"Double bed has a solid base and usable bedside")
   at(Vector2(480,550));await snap(ward+"-upper-"+str(i))
   at(HoldNeighborhood.STAIR+Vector2(0,30));key(KEY_E);settle()
   at(Vector2(480,610));key(KEY_E);settle()
   check(s.area==ward,"Household returns to its own ward")
 check(titles.size()==9 and fronts.size()==9,"Nine households have distinct names and frontages")
 s.enter("hearthward");settle();s.enter("room:tavern");settle()
 at(HoldHouseholds.KETTLE_STAIR+Vector2(0,30));await snap("kettle-stair");key(KEY_E);settle()
 check(s.area==HoldHouseholds.LOFT,"Copper Kettle staircase reaches the married couple's shared quarters")
 var beds=s.world.room_objects().filter(func(o):return o.furnishing in ["bed","double_bed"])
 check(beds.size()==1 and beds[0].furnishing=="double_bed","Hedrik and Orla share exactly one double bed")
 check(not s.points().any(func(p):return p.action=="leave") and not s.walkable(Vector2(480,625)),"Upstairs quarters have no phantom street exit")
 at(Vector2(590,420));key(KEY_E)
 check(s.world.speech.contains("Hedrik and Orla") and s.world.speech.contains("two pillows"),"Shared household can be inspected in play")
 g.save_game();g.start_game(true);settle()
 check(s.area==HoldHouseholds.LOFT,"Shared quarters survive saving and loading")
 s.world.speech="";at(Vector2(480,450));await snap("copperkettle-shared-bedroom")
 at(HoldHouseholds.KETTLE_STAIR+Vector2(0,30));key(KEY_E);settle()
 check(s.area=="room:tavern","Shared quarters return by the same real staircase")
 at(Vector2(480,610));key(KEY_E);settle();check(s.area=="hearthward","Tavern still returns to Hearthward")
 s.enter("crownward");settle();at(Vector2(350,465));key(KEY_E);settle()
 check(s.area==HoldHouseholds.ARCHIVE,"Former closed frontage opens the Hall of Names")
 at(Vector2(590,445));key(KEY_E);check(s.world.speech.contains("Nine family hearths"),"Household archive has a readable local purpose")
 s.world.speech="";at(Vector2(480,450));await snap("hall-of-names")
 at(Vector2(480,610));key(KEY_E);settle();check(s.area=="crownward","Archive returns to its own Crownward doorstep")
 for room in ["room:research","room:commission"]:
  s.enter(room);settle();at(Vector2(480,550));await snap(room.trim_prefix("room:"))
 print("KELDRATH77: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
