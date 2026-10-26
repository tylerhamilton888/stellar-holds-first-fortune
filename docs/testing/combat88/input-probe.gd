extends "res://tests/support/game_fixture.gd"
var capture_index=0
var motions=[]
func mouse_button(which:int,down:bool):
 var event=InputEventMouseButton.new();event.button_index=which;event.pressed=down;event.position=g.get_global_mouse_position();Input.parse_input_event(event)
func sequence(count:int):
 for i in count:
  var target=g.fight.enemies[0].p-Vector2(0,25)-g.camera
  root.warp_mouse(target*root.get_visible_rect().size/Vector2(960,540))
  g._process(1.0/60);await process_frame
  if i%4==0:
   await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/frame-%04d.png"%capture_index)
   motions.append({"frame":capture_index,"weapon":g.state.combat.weapon,"pose":g.fight.player_pose(),"phase":1-g.fight.swing/g.combat.weapon().time,"recoil":g.fight.shield_recoil})
   capture_index+=1
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.surface.enter("room:training");settle();g.combat.armed=true;g.fight.spawn();g.close_panel()
 for identity in [{"gender":0,"sculpt":0},{"gender":1,"sculpt":3}]:
  g.state.appearance.gender=identity.gender;g.state.appearance.sculpt=identity.sculpt
  for weapon in ["axe","hammer"]:
   mouse_button(MOUSE_BUTTON_LEFT,false);mouse_button(MOUSE_BUTTON_RIGHT,false)
   g.state.combat.weapon=weapon;g.fight.cancel_actions();g.player=Vector2(500,430);g.fight.enemies[0].p=Vector2(580,430);g.camera=g.surface.camera_target()
   await sequence(30)
   Input.action_press("down");await sequence(30);Input.action_release("down")
   Input.action_press("up");await sequence(30);Input.action_release("up")
   mouse_button(MOUSE_BUTTON_LEFT,true);await sequence(120);mouse_button(MOUSE_BUTTON_LEFT,false)
   mouse_button(MOUSE_BUTTON_RIGHT,true);await sequence(120);mouse_button(MOUSE_BUTTON_RIGHT,false)
   mouse_button(MOUSE_BUTTON_LEFT,true);await sequence(60);mouse_button(MOUSE_BUTTON_LEFT,false)
 var file=FileAccess.open(output+"/motion.json",FileAccess.WRITE);file.store_string(JSON.stringify(motions,"  "));file.close()
 print("INPUT MOTION CAPTURE: ",capture_index," frames")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit()
