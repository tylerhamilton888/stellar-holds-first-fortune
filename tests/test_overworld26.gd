extends SceneTree
var good=0
var bad=0
var g
func check(ok:bool,msg:String):
 if ok:good+=1
 else:bad+=1;push_error(msg)
func _initialize():call_deferred("run")
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1;g.grounded=true
 g.geo.set_cell(Vector2i(140,80),0)
 g.open_panel("world_map");var map=g.overworld
 check(not map.survey and g.state.region_travel.active,"Surface entry starts a persistent journey")
 check(map.marker.distance_to(map.nodes.hold.p)<50,"Journey starts at current location")
 var before=map.marker;map.move_by(Vector2(30,0));check(map.marker.x>before.x,"Character moves in regional coordinates")
 map.marker=Vector2(map.river_x(1000)-60,1000);map.move_by(Vector2(120,0))
 check(map.marker.x<map.river_x(1000),"Riverbank prevents walking through water")
 map.marker=Vector2(map.river_x(740)-70,740);map.move_by(Vector2(140,0))
 check(map.marker.x>map.river_x(740)+40,"Bridge crosses the same river collision")
 # Check every road segment is traversable, including both directions.
 for road in map.roads:
  for i in range(road.size()-1):
   for flip in [false,true]:
    var a=road[i+1] if flip else road[i];var b=road[i] if flip else road[i+1]
    map.marker=a;map.move_by(b-a)
    check(map.marker.distance_to(b)<1,"Continuous road passage")
 map.marker=Vector2(800,740);map.remember();g.save_game()
 var saved=HoldState.new();var geo=Geology.new();saved.load_world(geo)
 check(saved.region_travel.active and saved.region_travel.x==800,"Mid-journey position survives save/load")
 check(geo.at(140,80)==0,"Saving travel preserves local excavation")
 var resumed=load("res://main.tscn").instantiate();root.add_child(resumed);resumed.set_process(false);resumed.start_game(true)
 await process_frame
 check(is_instance_valid(resumed.overworld) and resumed.overworld.marker.x==800,"Continue reopens the journey at its saved position")
 resumed.playing=false;resumed.sound.stop_all();resumed.close_panel();resumed.queue_free();await process_frame
 map.toggle_pause();before=map.marker;Input.action_press("right");map._process(.05);Input.action_release("right")
 check(map.marker==before,"Pause stops regional movement")
 map.toggle_pause();map.marker=map.nodes.workings.p+Vector2(0,30);map.update_nearest();map.enter_location()
 check(g.zone=="mine" and g.panel_id=="" and g.state.region_travel.is_empty(),"Walking to entrance enters existing mine")
 check(g.geo.at(140,80)==0,"Entering preserves excavation")
 g.player=Vector2(600,700);g.grounded=true;g.open_panel("world_map");map=g.overworld
 check(map.survey,"Underground opens read-only survey")
 before=map.marker;Input.action_press("right");map._process(.05);Input.action_release("right")
 check(map.marker==before and g.state.region_travel.is_empty(),"Survey cannot escape underground")
 map.toggle_pause();check(g.panel_id=="" and g.zone=="mine","Closing survey returns to excavation")
 g.playing=false;g.sound.stop_all();g.close_panel();g.queue_free();await process_frame
 print("OVERWORLD26: %d passed; %d failed" % [good,bad]);quit(1 if bad else 0)
