extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
class WallBoard extends Node2D:
 var geo:Geology
 var camera=Vector2.ZERO
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color.MAGENTA)
  HoldMountain.background(self,geo,camera)
var passed=0
var failed=0
func check(ok:bool,why:String):
 if ok:passed+=1
 else:failed+=1;push_error(why)
func snap(name:String)->Image:
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 var img=root.get_texture().get_image()
 if name!="":img.save_png("/workspace/scratch/dc3395c394d3/tools/quality40/"+name+".png")
 return img
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="mine";g.room_id="";g.player=Vector2(350,392);g.camera=Vector2.ZERO;g.tool=0;g.grounded=true
 # Ray selection and actual excavation, for every design and both facings.
 for gender in 2:
  for design in 5:
   g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":design,"hair_color":5})
   for direction in [-1,1]:
    for dx in [-22,0,22]:
     g.geo.cells.fill(0);g.geo.damage.clear();g.geo.dirty.clear();g.face=direction
     for x in range(38,63):g.geo.cells[43*Geology.W+x]=2
     var c=g.target_cell_at(g.player+Vector2(dx,-105))
     check(c.x>=0 and c.y==43,"Ceiling can be selected")
     if c.x<0:continue
     g.hit_cell=c;g.hit_point=g.contact_point(c);g.face=g.strike_facing(g.hit_point)
     check(g.contact_reachable(g.hit_point,g.face) and g.clear_strike_path(),"Raised hand reaches selected ceiling")
     var before=g.state.mined
     for strike in 8:g.hit_terrain()
     check(g.state.mined>before,"Ceiling strikes excavate actual rock")
     check(g.mining_frame(.55)==3,"Contact uses raised pose")
 g.geo.cells.fill(0);g.geo.cells[30*Geology.W+50]=2
 check(g.target_cell_at(Vector2(350,210)).x<0,"Out-of-reach ceiling rejected")
 g.geo.generate_region(g.state.seed_value,0,Vector2i.ZERO);g.geo.redraw_all=true;g.ensure_mine_mouth()
 g.player=Vector2(350,392);g.camera=Vector2(0,20);g.hit_point=g.player+Vector2(0,-100);g.swing_duration=.38
 for sex in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":sex,"sculpt":0,"hair_color":5});g.face=1 if sex==0 else -1
  for f in 8:
   g.swing=.38*(1-(f+.1)/8);g.queue_redraw();await snap("overhead-"+str(sex)+"-"+str(f))
 g.swing=0
 for i in 4:
  g.camera=Vector2(330+i*.37,120+i*.23);g.queue_redraw();await snap("mine-pan"+str(i))
 g.zone="hub";g.state.active_site="hold";g.room_id="commission";g.player=Vector2(805,410);g.camera=Vector2.ZERO;g.state.opening=2
 var q=HoldOnboarding.ensure(g.state);q.stage=6
 g.interact();check(g.room_id=="commission","Old office shortcut removed")
 g.close_panel();g.queue_redraw();await snap("office")
 g.player=Vector2(625,410);g.talk_id="ivar";g.open_panel("commission");await snap("commission")
 g.lesson_id="route";g.open_panel("lesson");await snap("lesson")
 g.room_id="tavern";g.state.appearance.gender=0;g.open_panel("social");await snap("errand")
 g.room_id="throne";g.room_return="commission";g.hold_room_return=false;g.leave_room()
 check(g.room_id=="" and g.overworld is HoldDistrictMap,"Throne exit opens hold district")
 check(g.overworld.level==0 and g.overworld.at==1,"Throne exit returns to Crownward")
 g.overworld.set_process(false);g.overworld.queue_redraw();await snap("royal-exit")
 g.close_panel();g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 var board=WallBoard.new();board.geo=Geology.new();root.add_child(board)
 for seed in [39,927]:
  board.geo.generate_region(seed,0,Vector2i.ZERO)
  for i in 8:
   board.camera=Vector2(270+i*.137,90+i*.219);board.queue_redraw()
   var img=await snap("" )
   var leaks=0
   for x in range(8,950,13):
    var world_x=clampi(int((x+board.camera.x)/7),0,Geology.W-1)
    var top=board.geo.mountain.surface[world_x]*7-board.camera.y
    for y in range(maxi(0,int(ceil(top))+2),530,17):
     var c=img.get_pixel(int(x*img.get_width()/960.0),int(y*img.get_height()/540.0))
     if c.r>.8 and c.b>.8 and c.g<.2:leaks+=1
   check(leaks==0,"Opaque cave backing while camera moves")
 board.queue_free();await process_frame
 print("REVIEW40: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
