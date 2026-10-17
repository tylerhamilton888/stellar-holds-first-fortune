extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var geo=Geology.new();geo.cells.resize(Geology.W*Geology.H);geo.cells.fill(0)
 geo.cells[50*Geology.W+70]=5
 var a=HoldFieldSurvey.sample(geo,Vector2i(40,50))
 check(a.kind==5 and a.strength=="Faint" and "east" in a.bearing,"Real coal gives faint east bearing")
 var b=HoldFieldSurvey.sample(geo,Vector2i(60,50))
 check(b.strength=="Strong","Approaching gives stronger bearing")
 var first=HoldFieldSurvey.sift(geo,Vector2i(60,50),15)
 check(first.count==0 and geo.mountain.sift_bank[first.item]==15,"Partial sifting accumulates")
 geo.mountain=JSON.parse_string(JSON.stringify(geo.mountain))
 var second=HoldFieldSurvey.sift(geo,Vector2i(60,50),1)
 check(second.count==1 and geo.mountain.sift_bank[second.item]==0,"Saved remainder awards exactly one")
 check(HoldFieldSurvey.sift(geo,Vector2i(60,50),0).is_empty(),"No excavation gives no reward")
 geo.mountain.survey_focus=3
 check(HoldFieldSurvey.sample(geo,Vector2i(60,50)).kind==0,"Selected absent mineral reports no signal")
 check(HoldFieldSurvey.sift(geo,Vector2i(60,50),16).count==0,"No invented bonus ore")
 geo.mountain.survey_focus=0;geo.cells[50*Geology.W+70]=0
 check(HoldFieldSurvey.sample(geo,Vector2i(60,50)).kind==0,"Exhausted seam has no signal")
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.zone="mine";g.room_id="";g.player=Vector2(350,392);g.camera=Vector2.ZERO;g.tool=1;g.prospecting=true;g.grounded=true
 g.geo.cells.fill(0);g.geo.damage.clear();g.geo.mountain.survey_focus=5
 g.geo.cells[50*Geology.W+60]=5
 g.geo.mountain.sift_bank={"coal":15}
 g.geo.cells[50*Geology.W+54]=1
 g.hit_cell=Vector2i(54,50);g.hit_point=g.contact_point(g.hit_cell);g.face=g.strike_facing(g.hit_point)
 var coal_before=int(g.state.inventory.get("coal",0))
 g.hit_terrain()
 check(int(g.state.inventory.get("coal",0))==coal_before+1,"Actual shovel contact adds bonus coal to inventory")
 g.hit_terrain()
 check(int(g.state.inventory.get("coal",0))==coal_before+1,"Cleared dirt cannot pay twice")
 g.geo.generate_region(g.state.seed_value,0,Vector2i.ZERO);g.geo.redraw_all=true;g.ensure_mine_mouth()
 g.geo.mountain.active_reading={"kind":5,"strength":"Moderate","bearing":"east, at roughly this level","x":50,"y":50}
 g.geo.mountain.sift_item="coal";g.geo.mountain.sift_bank={"coal":9}
 g.update_hud();g.queue_redraw()
 await snap("survey-hud")
 g.open_panel("field_notes");await snap("survey-notebook")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("SURVEY42: ",failures," failures");quit(failures)
func snap(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/current42/"+name+".png")
