extends SceneTree
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1
 g.zone="mine";g.player=Vector2(489,392);g.face=1;g.tool=0;g.grounded=true
 g.geo.cells.fill(0);g.geo.structures=[];g.geo.timbers={};g.geo.mountain={};g.geo.damage={};g.geo.grain_bank={}
 for y in range(56,100):
  for x in range(1,200):g.geo.set_cell(Vector2i(x,y),2)
 for y in range(42,56):
  for x in range(76,100):g.geo.set_cell(Vector2i(x,y),2 if x<88 else 3)
 var start=g.player.x;var strikes=0
 for tick in 6000:
  var dt=1.0/120
  if g.swing<=0:
   var chosen=Vector2i(-1,-1)
   for x in range(int(g.player.x/7),mini(100,int(g.player.x/7)+12)):
    for y in range(45,56):
     var c=Vector2i(x,y)
     if g.geo.at(x,y)==0:continue
     var point=g.contact_point(c)
     if g.contact_reachable(point,1) and g.geo.visible_from(g.player+Vector2(0,-29),c):chosen=c;break
    if chosen.x>=0:break
   if chosen.x>=0:
    g.hit_cell=chosen;g.hit_point=g.contact_point(chosen);g.swing_duration=.38;g.swing=.38;g.swing_done=false;strikes+=1
   else:
    Input.action_press("right");g.move_player_step(dt);Input.action_release("right")
  if g.impact_pause>0:g.impact_pause=maxf(0,g.impact_pause-dt)
  else:g.handle_mining(dt)
  g.update_effects(dt)
  g.update_hud()
  if g.player.x>620:break
 assert(g.player.x>start+25,"Excavation creates a navigable full-body passage")
 assert(g.state.mined>40,"Repeated physical contact actually removes material")
 g.save_game()
 assert(g.state.count("stone")>0,"Broken material enters the resource economy")
 print("MINING27 PATH: ",strikes," swings; ",g.state.mined," grains; ",g.player.x-start," px advanced; ",g.state.count("stone")," stone collected")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
