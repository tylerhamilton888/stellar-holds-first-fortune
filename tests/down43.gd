extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var failures=0
var checks=0
func check(ok:bool,message:String):
 checks+=1
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="mine";g.room_id="";g.camera=Vector2.ZERO;g.grounded=true;g.prospecting=false
 for gender in 2:
  for design in 5:
   g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":design,"hair_color":5})
   for facing in [-1,1]:
    for offset in [0,3,6]:
     for kind in [1,2]:
      g.player=Vector2(350+offset,392);g.face=facing;g.tool=1 if kind==1 else 0
      g.geo.cells.fill(0);g.geo.damage.clear();g.geo.mountain.clear();g.geo.structures.clear();g.geo.timbers.clear()
      for y in range(56,70):
       for x in range(35,70):g.geo.cells[y*Geology.W+x]=kind
      var valid=true
      for strike in 24:
       if not g.body_solid(g.player+Vector2(0,7)):break
       var c=g.target_cell_at(g.player+Vector2(0,130))
       if c.x<0:valid=false;break
       g.hit_cell=c;g.hit_point=g.contact_point(c);g.face=g.strike_facing(g.hit_point)
       if not g.contact_reachable(g.hit_point,g.face) or not g.clear_strike_path():valid=false;break
       g.hit_terrain()
      check(valid,"Downward selection/contact valid for all designs and grid alignments")
      check(not g.body_solid(g.player+Vector2(0,7)),"Foot-width shaft clears without sideways shuffling")
      check(g.mining_frame(.55)==6,"Body uses lower contact pose")
      g.player+=Vector2(0,7)
      check(g.target_cell_at(g.player+Vector2(0,130)).x>=0,"Next layer remains targetable after descent")
 # Existing overhead targeting remains reachable.
 for sex in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":sex,"sculpt":0})
  for facing in [-1,1]:
   g.face=facing;g.tool=0;g.player=Vector2(350,392);g.geo.cells.fill(0)
   for x in range(38,63):g.geo.cells[43*Geology.W+x]=2
   for dx in [-22,0,22]:
    var ceiling=g.target_cell_at(g.player+Vector2(dx,-105))
    check(ceiling.x>=0,"Overhead targeting still works")
 # Reject out of reach floor and preserve basalt gate.
 g.player=Vector2(350,392);g.tool=0;g.geo.cells.fill(0)
 for x in range(35,70):g.geo.cells[68*Geology.W+x]=2
 check(g.target_cell_at(Vector2(350,600)).x<0,"No long-distance digging")
 g.geo.cells.fill(0)
 for x in range(35,70):g.geo.cells[56*Geology.W+x]=7
 g.state.steel=false;var c=g.target_cell_at(Vector2(350,500));g.hit_cell=c;g.hit_point=g.contact_point(c);g.face=g.strike_facing(g.hit_point)
 g.hit_terrain();check(g.geo.at(c.x,c.y)==7,"Basalt still requires steel")
 g.particles.clear();g.popups.clear();g.impact_flashes.clear();g.shake_amount=0;g.drops.clear()
 # Visual contact poses over a flat bank, both sexes/facings.
 g.geo.generate_region(g.state.seed_value,0,Vector2i.ZERO);g.geo.redraw_all=true;g.ensure_mine_mouth()
 for sex in 2:
  for facing in [-1,1]:
   g.state.appearance=HoldAppearance.normalized({"gender":sex,"sculpt":0,"hair_color":5});g.face=facing;g.player=Vector2(350,392);g.tool=0
   g.hit_point=g.player+Vector2(facing*14,0);g.swing_duration=.38;g.swing=.38*.45
   g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/current43/down-%d-%d.png" % [sex,facing])
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("DOWN43: ",checks," checks, ",failures," failures");quit(1 if failures else 0)
