extends SceneTree
var good=0
var bad=0
var events=[]
func check(ok:bool,msg:String):
 if ok:good+=1
 else:bad+=1;push_error(msg)
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1
 for gender in 2:
  g.state.appearance.gender=gender
  for tool in 4:
   g.tool=tool
   for facing in [-1,1]:
    for reach in [12.0,24.0,32.0]:
     var origin=g.contact_hand(facing);var target=origin+Vector2(facing*.8,-.6)*reach
     var transform=HoldCharacterArt.tool_transform(origin,target,tool,facing)
     var actual=transform*(HoldCharacterArt.TOOL_CONTACTS[tool]-HoldCharacterArt.tool_grip(tool,reach))
     check(actual.distance_to(target)<.001,"Fixed-size tool head exactly meets target")
     check((transform*Vector2.ZERO).distance_to(origin)<.001,"Grip stays in the hand")
 # Contact event owns sound, fracture and damage exactly once.
 g.state.appearance.gender=0;g.tool=0;g.face=1;g.zone="mine";g.player=Vector2(440,392);g.grounded=true
 g.geo.cells.fill(0);g.geo.damage={};g.geo.structures=[];g.geo.timbers={};g.geo.mountain={}
 for x in range(72,80):
  for y in range(45,60):g.geo.set_cell(Vector2i(x,y),2)
 g.hit_cell=Vector2i(72,51);g.hit_point=g.contact_point(g.hit_cell)
 g.sound.audio_event.connect(func(id):events.append(id))
 g.swing_duration=.38;g.swing=.38;g.swing_done=false
 g.handle_mining(.15)
 check(events.is_empty() and g.geo.damage.is_empty(),"Windup cannot damage or sound early")
 g.handle_mining(.07)
 check(events.filter(func(id):return id.begins_with("pick_real")).size()==1,"Exactly one real impact at contact")
 check(not g.geo.damage.is_empty(),"First stone strike visibly accumulates fracture")
 check(HoldCharacterArt.action_frame(1-g.swing/g.swing_duration,g.tool)==4,"Sound and damage occur on contact drawing")
 g.handle_mining(.01)
 check(events.filter(func(id):return id.begins_with("pick_real")).size()==1,"Contact cannot repeat during recovery")
 g.hit_terrain();check(g.geo.at(72,51)==0,"Second ordinary stone strike breaks the surface")
 var count=events.size();g.player.x-=100;g.hit_terrain();check(events.size()==count,"Out-of-reach swing makes no remote impact")
 var geo=Geology.new();geo.generate(7342)
 check(geo.mountain.geodes.size()==3,"Three actual concealed geode formations")
 for deposit in geo.mountain.geodes:
  check(geo.at(deposit.x,deposit.y)==0 and geo.at(deposit.x+5,deposit.y)==6,"Geode has void and mineable crystal lining")
 var c=Vector2i(40,40);geo.set_cell(c,6);geo.damage={};geo.grain_bank={}
 var normal=geo.strike(c,10);geo.set_cell(c,6);var careful=geo.strike(c,10,true)
 check(careful.grains==normal.grains*2,"Fine extraction preserves more crystal")
 g.state.save_slot=3;g.geo.generate(7342);g.geo.mountain.geodes[0].seen=true
 check(g.state.save_world(g.geo,"mine",Vector2(90,392)),"Discovery save succeeds")
 var loaded=HoldState.new();loaded.save_slot=3;loaded.load_world(geo)
 check(geo.mountain.geodes[0].seen,"Discovery state survives loading without repeat reward")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("MINING27: %d passed; %d failed" % [good,bad]);quit(1 if bad else 0)
