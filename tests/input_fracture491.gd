extends "res://tests/input_readability48.gd"
func run():
 output="res://docs/testing/fracture-0.49.1";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("trail",Vector2(950,340));settle();g.surface.action("mine");settle();key(KEY_1)
 var w=g.deep.world;var c=Deepworks.ENTRY+Vector2i(5,2)
 for y in range(-3,3):
  for x in range(-2,4):
   var tile=c+Vector2i(x,y);w.set_cell(tile,0);w.layer().seen[Deepworks.key(tile)]=true
 g.player=Deepworks.center(c+Vector2i.LEFT);g.camera=g.deep.camera_target()
 w.set_cell(c,3);w.layer().seen[Deepworks.key(c)]=true
 var shape=g.deep.rock_outline(c)
 check(shape==g.deep.rock_outline(c),"Rock silhouette remains deterministic across frames")
 check(shape!=g.deep.rock_outline(c+Vector2i.DOWN),"Neighboring rocks have varied shapes")
 check(shape!=g.deep.rock_outline(c,.7),"Damage chips the actual rendered silhouette")
 await snap("01-intact")
 var result=w.strike(c,-1,false,false)
 check(not result.broken and float(w.layer().damage[Deepworks.key(c)])==1,"First pick contact leaves a persistent damaged iron face")
 await snap("02-fractured")
 g.save_game();g.start_game(true);settle();w=g.deep.world
 check(w.at(c)==3 and float(w.layer().damage[Deepworks.key(c)])==1,"Damaged terrain survives real save and reload")
 # Showcase all three visible damage bands using saved damage, without changing resistance.
 for j in 3:
  var tile=c+Vector2i(j-1,-2);w.set_cell(tile,7);w.layer().seen[Deepworks.key(tile)]=true;w.layer().damage[Deepworks.key(tile)]=[.8,2.0,3.0][j]
 await snap("03-damage-bands")
 w.set_cell(c,3);w.layer().damage[Deepworks.key(c)]=1
 g.deep.contact=Deepworks.center(c);g.deep.target=c;g.deep.hit(c)
 check(w.at(c)==0 and not w.layer().damage.has(Deepworks.key(c)),"Final actual contact clears only the broken face and its damage")
 check(not g.deep.rubble.is_empty(),"Breakthrough retains transient settling fragments")
 await snap("04-breakthrough")
 w.set_cell(c,2);w.layer().damage.erase(Deepworks.key(c));g.deep.strike_left=0;g.deep.contact_hold=0
 var aim=Deepworks.center(c)-g.camera
 var held=InputEventMouseButton.new();held.button_index=MOUSE_BUTTON_LEFT;held.pressed=true;held.position=aim
 Input.parse_input_event(held);root.warp_mouse(aim)
 for i in 45:g._process(1.0/60);await process_frame
 held.pressed=false;Input.parse_input_event(held);await process_frame
 check(w.at(c)==0,"Held-button ordinary stone remains quick to excavate")
 print("FRACTURE491: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
