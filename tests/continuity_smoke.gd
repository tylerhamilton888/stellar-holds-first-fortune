extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var checks=0
var failures=0
func check(ok:bool,message:String):
 checks+=1
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false)
 check(not g.playing,"Title state initializes")
 g.skip_arrival=true;g.start_game(false);g.close_panel()
 check(g.playing and not g.state.inventory.is_empty(),"New game initializes player and inventory")
 var s=HoldState.new();s.reset(27419);s.add("iron_ore",2);s.add("coal",1)
 check(s.craft("iron"),"Smelting accepts materials")
 s.tick(10);check(s.count("iron")==1,"Smelting credits finished ingot")
 var cash=s.money;check(s.trade("iron",false) and s.money>cash,"Selling credits crowns")
 var geo=Geology.new();geo.cells.resize(Geology.W*Geology.H);geo.cells.fill(0)
 geo.cells[50*Geology.W+70]=5
 var note=HoldFieldSurvey.sample(geo,Vector2i(40,50))
 check(note.kind==5 and note.strength=="Faint","Sample reads actual mineral")
 check(HoldFieldSurvey.sample(geo,Vector2i(60,50)).strength=="Strong","Nearer sample strengthens signal")
 var sift=HoldFieldSurvey.sift(geo,Vector2i(60,50),16)
 check(sift.count==1 and sift.item=="coal","Dirt sifting awards coal")
 geo.cells[50*Geology.W+70]=0
 check(HoldFieldSurvey.sample(geo,Vector2i(60,50)).kind==0,"Exhausted deposit no longer signals")
 g.zone="mine";g.room_id="";g.player=Vector2(350,392);g.tool=0;g.prospecting=false
 g.geo.cells.fill(0);g.geo.damage.clear()
 for y in range(56,64):
  for x in range(40,65):g.geo.cells[y*Geology.W+x]=2
 for strike in 24:
  if not g.body_solid(g.player+Vector2(0,7)):break
  var cell=g.target_cell_at(g.player+Vector2(0,130))
  if cell.x<0:break
  g.hit_cell=cell;g.hit_point=g.contact_point(cell);g.face=g.strike_facing(g.hit_point);g.hit_terrain()
 check(not g.body_solid(g.player+Vector2(0,7)),"Downward excavation clears footing")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("CONTINUITY_SMOKE: ",checks," checks, ",failures," failures")
 quit(1 if failures else 0)
