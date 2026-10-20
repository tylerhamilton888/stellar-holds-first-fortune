extends SceneTree
var failures=0
var checks=0
func check(ok:bool,label:String):
 checks+=1
 if not ok:failures+=1;push_error(label)
func _initialize():call_deferred("run")
func reset(g):
 for action in ["left","right","jump","up","down"]:Input.action_release(action)
 g.player=Vector2(900,392);g.velocity=Vector2.ZERO;g.grounded=true;g.jump_buffer=0;g.coyote_left=0;g.jump_was_held=false;g.movement_remainder=0;g.combat.dodge_left=0;g.combat.guard=false
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.set_process(false);g.zone="mine";g.state.opening=4
 for y in range(0,90):
  for x in range(60,240):g.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 var ends=[]
 for fps in [30,60,120]:
  reset(g);Input.action_press("right")
  for i in fps:g.move_player(1.0/fps)
  ends.append(g.player.x)
  Input.action_release("right")
  var x=g.player.x
  for i in 12:g.move_player(1.0/120)
  check(g.velocity.x==0 and g.player.x-x<8,"Release stops within 8px at %d FPS"%fps)
 check(absf(ends[0]-ends[2])<.05 and absf(ends[1]-ends[2])<.05,"Render FPS does not alter travel")
 reset(g);g.velocity.x=190;Input.action_press("left")
 for i in 10:g.move_player(1.0/120)
 check(g.velocity.x<0,"Direction reversal responds within 84ms")
 reset(g);g.player.y=388;g.velocity.y=100;g.grounded=false;Input.action_press("jump")
 for i in 9:g.move_player(1.0/120)
 check(g.velocity.y< -250 and g.player.y<388,"Buffered jump fires on landing")
 reset(g);g.grounded=false;g.coyote_left=.06;g.player.y=380;Input.action_press("jump");g.move_player(1.0/120)
 check(g.velocity.y< -300,"Coyote jump fires just after an edge")
 reset(g);g.grounded=false;g.coyote_left=0;g.player.y=300;Input.action_press("jump");g.move_player(1.0/120)
 check(g.velocity.y>0,"Cannot jump again in midair")
 var apex=[]
 for tap in [false,true]:
  reset(g);Input.action_press("jump");var top=g.player.y
  for i in 120:
   if tap and i==4:Input.action_release("jump")
   g.move_player(1.0/120);top=minf(top,g.player.y)
  apex.append(top)
  check(g.grounded,"Jump lands cleanly")
  check(g.velocity.y==0,"Holding jump does not bunny-hop")
 check(apex[1]-apex[0]>25,"Tap jumps are meaningfully shorter")
 # A one-cell step is climbable only with enough headroom.
 for x in range(140,143):g.geo.set_cell(Vector2i(x,55),2)
 for x in range(110,150):g.geo.set_cell(Vector2i(x,44),2)
 reset(g);Input.action_press("right")
 for i in 60:g.move_player(1.0/120)
 check(not g.body_solid(g.player) and g.body_bounds(g.player).end.x<=980.05,"Low ceiling blocks step without head penetration")
 for x in range(110,150):g.geo.set_cell(Vector2i(x,44),0)
 reset(g);Input.action_press("right")
 for i in 48:g.move_player(1.0/120)
 check(g.player.y<386 and not g.body_solid(g.player),"Single-cell rubble step is climbed with headroom")
 for x in range(140,143):g.geo.set_cell(Vector2i(x,55),0)
 # A single seven-pixel wall must stop a dodge at all render rates.
 for y in 56:g.geo.set_cell(Vector2i(150,y),2)
 for fps in [30,60,120]:
  reset(g);g.combat.dodge_left=.2;g.combat.dodge_direction=1
  for i in fps/2:g.move_player(1.0/fps)
  check(absf(g.body_bounds(g.player).end.x-1050)<.05 and not g.body_solid(g.player),"Dodge cannot tunnel at %d FPS"%fps)
 reset(g)
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("CONTROLLER20: %d checks, %d failures"%[checks,failures]);quit(1 if failures else 0)
