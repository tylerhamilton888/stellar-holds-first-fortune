extends "res://tests/input_surface49.gd"
func mouse(pressed:bool,aim:Vector2):
 root.warp_mouse(aim*root.get_visible_rect().size/Vector2(960,540))
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=pressed;e.position=aim;Input.parse_input_event(e)
func run():
 output="res://docs/testing/animation-0.51.0/contacts";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.surface.enter("trail");settle();g.surface.action("mine");settle();g.state.steel=true;g.state.tech.extraction=true
 var w=g.deep.world;var c=Deepworks.ENTRY+Vector2i(0,4)
 for direction in [Vector2i.RIGHT,Vector2i.LEFT,Vector2i.UP,Vector2i.DOWN]:
  for y in range(c.y-2,c.y+3):
   for x in range(c.x-2,c.x+3):w.set_cell(Vector2i(x,y),0)
  var target=c+direction*2;w.set_cell(target,7);g.player=Deepworks.center(c);g.camera=g.deep.camera_target();g.deep.strike_left=0;g.deep.contact_hold=0;g.tool=0;g.hotbar.item="";g.surface.direction=Vector2(direction)
  w.survey(g.player);var aim=Deepworks.center(target)-g.camera;mouse(true,aim)
  for i in 200:
   await frames(1)
   if g.deep.struck and g.deep.strike_left>0 and g.deep.strike_left<=DeepworksPlay.IMPACT:break
  mouse(false,aim);check(g.deep.struck and float(w.layer().damage.get(Deepworks.key(target),0))>0,"Held pick reaches and damages "+str(direction)+" face")
  await snap("pick-"+str(direction.x)+"-"+str(direction.y))
 g.surface.enter("pinewood");settle();g.hotbar.select(2);g.player=HoldSurface.TREES[0]+Vector2(-42,-15);g.camera=g.surface.camera_target();g.state.road_trees[0]=8
 var aim=HoldSurface.TREES[0]-Vector2(0,25)-g.camera;mouse(true,aim)
 for i in 100:
  await frames(1)
  if g.surface.cut_struck:break
 mouse(false,aim);check(g.state.road_trees[0]==7,"Drawn axe contact coincides with one actual trunk cut");await snap("axe-contact")
 g.state.claim_id="old_delving";g.surface.enter("claim");settle();g.state.add("wood",30);g.state.add("stone",30)
 for kind in ["breaker","saw"]:
  g.player=Vector2(880,640);var p=Vector2(920,600) if kind=="breaker" else Vector2(1120,600)
  g.player=p+Vector2(0,60);g.handworks.build(kind,p);g.handworks.spawn("stone" if kind=="breaker" else "log",g.player,2);key(KEY_E);await frames(30)
  Input.action_press("interact")
  for i in 160:
   await frames(1)
   var f=g.handworks.facility()
   if g.handworks.working and not f.is_empty() and not f.job.is_empty() and fmod(float(f.job.progress),.42)>.22:break
  Input.action_release("interact");await snap(kind+"-contact")
  g.handworks.working=false
 print("CONTACTS51: ",passed," passed / ",failed," failed");g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
