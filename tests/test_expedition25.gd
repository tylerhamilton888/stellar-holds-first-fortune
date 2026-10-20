extends SceneTree
var g
var good=0
var bad=0
func check(ok:bool,msg:String):
 if ok:good+=1
 else:bad+=1;push_error(msg)
func _initialize():call_deferred("run")
func release():
 for key in ["right","left","up","down","jump"]:Input.action_release(key)
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1
 for seed in [1234,4444,7408,17799,36521]:
  var geo=Geology.new();geo.generate(seed)
  var hard=0
  for y in 150:
   for x in Geology.W:
    if geo.at(x,y)==7:hard+=1
  check(hard==0,"No shallow basalt barrier: "+str(seed))
  check(geo.mountain.caves.size()==5,"Sparse cave pockets instead of chamber grid")
  var coal=0
  for x in range(116,134):
   for y in range(43,59):
    if geo.at(x,y)==5:coal+=1
  check(coal>=128,"Accessible face contains first commission coal")
  for x in range(0,110,10):check(geo.at(x,56+int(maxi(0,x-35)/24))==2,"Starter haulage floor is solid rock")
 # Continuous crossing in both directions, with velocity and world-space position preserved.
 g.zone="mine";g.player=Vector2(60,392);g.velocity=Vector2(-190,0);g.grounded=true;g.movement_remainder=0
 Input.action_press("left");var previous=g.player.x+HoldJourney.offset(g.zone)
 for i in 90:
  g.move_player_step(1.0/120)
  var global_x=g.player.x+HoldJourney.offset(g.zone)
  check(global_x<previous+.001,"Westward motion remains continuous at seam")
  previous=global_x
 check(g.zone=="approach" and g.velocity.x< -180,"Mine exit preserves held movement")
 release();Input.action_press("right")
 for i in 130:g.move_player_step(1.0/120)
 check(g.zone=="mine" and g.velocity.x>180,"Trail entry preserves movement")
 release()
 for kind in 4:
  var a=HoldCharacterArt.tool_transform(Vector2.ZERO,Vector2(30,0),kind)
  var b=HoldCharacterArt.tool_transform(Vector2.ZERO,Vector2(120,0),kind)
  check(abs(a.get_scale().length()-b.get_scale().length())<.00001,"Tool never stretches: "+str(kind))
 # A shaft with a clear full-body ladder lane and solid footings.
 g.geo.cells.fill(0);g.geo.timbers={};g.geo.structures=[]
 for x in range(30,65):g.geo.set_cell(Vector2i(x,80),2)
 g.player=Vector2(350,560);g.velocity=Vector2.ZERO;g.grounded=true;g.zone="mine";g.state.add("wood",10)
 g.construction.selected="ladder"
 check(g.construction.place(Vector2i(46,62)),"Full-width ladder can be built on a floor")
 var rectangle=g.construction.ladder_rect(g.construction.ladders()[0])
 check(rectangle.size.x>=g.BODY_SIZE.x and rectangle.size.y>g.BODY_SIZE.y,"Ladder fits dwarf body")
 Input.action_press("up")
 for i in 50:g.move_player_step(1.0/120)
 check(g.player.y<530 and g.winch,"Dwarf climbs ladder")
 release();var y=g.player.y
 for i in 30:g.move_player_step(1.0/120)
 check(abs(g.player.y-y)<.01,"Dwarf holds ladder without sliding when input stops")
 # Saved terrain survives a round trip through the regional map.
 g.geo.generate(7408);g.state.active_site="hold";g.state.worlds={};g.geo.set_cell(Vector2i(140,80),0)
 g.zone="mine";g.player=Vector2(500,650);g.grounded=true
 check(not g.can_region_travel(),"Regional travel cannot bypass underground return route")
 g.player=Vector2(95,392);g.grounded=true;g.ladder_attached=false
 check(g.can_region_travel(),"Mine entrance permits travel")
 g.arrive_region("forest");check(g.zone=="road" and g.geo.at(140,80)==0,"Forest travel preserves excavations")
 g.state.road_trees[0]=0;g.arrive_region("workings")
 check(g.zone=="mine" and g.geo.at(140,80)==0 and g.state.road_trees[0]==0,"Round trip preserves mine and woodland changes")
 g.grounded=true;g.open_panel("world_map")
 for child in g.panel_body.get_children():
  if child is HoldRegionMap:
   child.selected="forest";child.start_travel()
   check(child.travelling and child.route.size()>=4,"Regional route follows connected roads")
   child._process(child.duration+.1)
   check(g.zone=="road" and g.panel_id=="","Animated route arrives and closes map")
   break
 # Budgeted avalanche updates conserve matter and leave work queued.
 var geo=Geology.new();geo.generate(1);geo.cells.fill(0);geo.active_grains={};geo.structures=[];geo.timbers={}
 for x in range(40,120):
  for yy in range(30,45):geo.set_cell(Vector2i(x,yy),1);geo.active_grains[yy*Geology.W+x]=true
 var total=geo.cells.count(1);var worst=0
 for i in 20:
  var start=Time.get_ticks_usec();var moved=geo.tick_materials(.05);worst=maxi(worst,Time.get_ticks_usec()-start)
  check(moved<=160,"Avalanche update has bounded cell work")
 check(geo.cells.count(1)==total,"Budgeting conserves falling dirt")
 print("MATERIAL WORST TICK us: ",worst)
 # Uphill camera tracks above its former zero ceiling.
 g.zone="mine";g.player=Vector2(850,150);g.camera=Vector2(300,0);g.open_panel("inventory");g.menu_paused=false;g._process(.1)
 check(g.camera.y<0,"Camera follows an uphill character above entrance elevation")
 g.playing=false;release();g.sound.stop_all();g.queue_free();await process_frame
 print("EXPEDITION25: %d passed; %d failed" % [good,bad]);quit(1 if bad else 0)
