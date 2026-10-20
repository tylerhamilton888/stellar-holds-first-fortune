extends SceneTree
var good=0
func check(value:bool,message:String):
 assert(value,message);good+=1
func _initialize():call_deferred("run")
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=1
 var base=g.geo.mountain.duplicate(true)
 g.geo.cells.fill(0);g.geo.mountain=base.duplicate(true);g.geo.damage={}
 var c=Vector2i(76,50)
 g.geo.set_cell(c,2)
 for x in range(87,92):
  for y in range(55,60):g.geo.set_cell(Vector2i(x,y),4)
 var r=HoldFieldSurvey.sample(g.geo,c)
 check(r.kind==4,"Read real copper deposit")
 check(r.bearing.contains("east"),"Bearing follows deposit")
 check(r.strength=="Moderate","Signal attenuates with distance")
 check(g.geo.mountain.field_notes.size()==1,"Sample logged")
 HoldFieldSurvey.sample(g.geo,c+Vector2i(1,0))
 check(g.geo.mountain.field_notes.size()==1,"Nearby samples refresh, not spam")
 for x in range(87,92):
  for y in range(55,60):g.geo.set_cell(Vector2i(x,y),0)
 check(HoldFieldSurvey.sample(g.geo,c).kind==0,"Depleted deposits disappear from fresh reading")
 var restored=Geology.new();restored.restore(g.geo.snapshot())
 check(restored.mountain.field_notes.size()==1,"Notebook survives terrain snapshot")
 check(restored.mountain.tracked_sample.x==c.x,"Tracked spot survives snapshot")
 g.zone="mine";g.player=Vector2(489,392);g.face=1;g.tool=0;g.hit_cell=c;g.hit_point=g.contact_point(c)
 g.swing_duration=.55;g.swing=.55;g.swing_done=false;g.sampling_strike=true
 g.geo.mountain=base.duplicate(true);g.handle_mining(.1)
 check(not g.geo.mountain.has("field_notes"),"No sample before pick contact")
 g.handle_mining(.3)
 check(g.geo.mountain.get("field_notes",[]).size()==1,"Sample occurs at contact frame")
 check(g.geo.at(c.x,c.y)==2,"Sampling does not manufacture ore or excavate a tunnel")
 g.player=Vector2(900,392);g.geo.mountain=base.duplicate(true);g.sampling_strike=true;g.finish_field_sample()
 check(not g.geo.mountain.has("field_notes"),"Out-of-reach sampling rejected")
 g.geo.mountain=restored.mountain;g.state.save_world(g.geo,"mine",g.player)
 var state=HoldState.new();var loaded=Geology.new();state.load_world(loaded)
 check(loaded.mountain.field_notes.size()==1,"Notebook survives disk save and reload")
 g.open_panel("field_notes");check(g.panel_id=="field_notes","Notebook UI opens")
 print("SURVEY28: ",good," passed")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
