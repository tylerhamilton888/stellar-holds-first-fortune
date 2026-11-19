extends "res://tests/support/game_fixture.gd"
var p
var h
var first_id=""
func stage():return HoldRoomConstruction197.phase(p,p.chosen())
func map_control():return g.panel.find_children("*","Control",true,false).filter(func(n):return n is HoldRoomBlueprintView.Map)[0]
func show_plan():
 g.surface.architecture.room_planning=true;g.open_panel("architecture")
 for i in 3:await process_frame
func capture_stage(name):
 await show_plan();await snap(name+"-planner")
 settle();at(h.center(Vector2i(62,43)));await snap(name+"-world")
func sweep():
 for c in [Vector2i(57,46),Vector2i(53,42),Vector2i(61,42),Vector2i(57,39),Vector2i(57,42)]:
  at(h.center(c));p.work()
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 for tech in HoldData.RESEARCH:g.state.tech[tech]=true
 g.surface.enter("claim",Vector2(2200,1760));settle()
 p=g.surface.architecture.room_blueprints;h=g.surface.house
 p.map_center=Vector2(2300,1720);p.zoom=5;p.data()
 await show_plan()
 var before=h.data().duplicate(true);var inventory=g.state.inventory.duplicate(true)
 var map=map_control();map.start=Vector2i(54,40);map.dragging=true;map.update_candidate(Vector2i(60,45))
 check(map.candidate_valid,"Finished green preview passes the same placement guard")
 var ghost=HoldRoomConstruction197.snapshot(p,map.candidate,true)
 check(ghost.size()==42 and ghost.values().all(func(t):return t.get("roof",false)),"Ghost includes exact planned floor and complete roof")
 check(ghost["57,45"].wall=="door","Preview and placed plan share their doorway")
 check(h.data()==before and g.state.inventory==inventory,"Preview neither builds pieces nor spends materials")
 for i in 20:await process_frame
 await snap("01-green-preview")
 var roof_toggle=g.panel.find_children("*","CheckBox",true,false).filter(func(n):return n.text=="Show roof")[0]
 roof_toggle.button_pressed=false;await snap("02-green-cutaway")
 check(not p.preview_roof,"Cutaway checkbox changes the live renderer")
 roof_toggle.button_pressed=true;map.update_candidate(Vector2i(54,40));check(not map.candidate_valid,"Undersized placement is blocked in preview")
 map.start=Vector2i(5,40);map.update_candidate(Vector2i(11,45));check(not map.candidate_valid,"Off-property preview is blocked")
 check(not p.save_rectangle(Vector2i(5,40),Vector2i(11,45)),"Commit independently rejects blocked placement")
 check(p.save_rectangle(Vector2i(54,40),Vector2i(60,45)),"Place planned foundation")
 first_id=p.selected
 check(stage()=="Marked out" and g.state.inventory==inventory,"Placed plan starts as stakes without a charge")
 var quote=p.cost(p.chosen());await capture_stage("03-marked-foundation")
 at(h.center(Vector2i(57,43)));check(p.work()>0,"First work lays paid foundation pieces")
 check(stage()=="Foundation","Partly built floor reports foundation stage")
 check(p.parts(p.chosen()).filter(func(part):return part.kind in ["wall","door","roof"]).all(func(part):return not p.fulfilled(part)),"Foundation work cannot jump ahead to walls or roof")
 await capture_stage("04-foundation")
 for i in 6:
  if stage()!="Foundation":break
  at(h.center(Vector2i(57,43)));p.work()
 check(stage()=="Walls","Complete foundation unlocks walls")
 at(h.center(Vector2i(53,42)));p.work();await capture_stage("05-walls")
 check(p.remaining(p.chosen()).any(func(part):return part.kind in ["wall","door"]),"Wall acceptance capture is actually unfinished")
 check(not p.parts(p.chosen()).any(func(part):return part.kind=="roof" and p.fulfilled(part)),"Partial walls do not build roof early")
 for i in 12:
  if stage()!="Walls":break
  for c in [Vector2i(57,46),Vector2i(53,42),Vector2i(61,42),Vector2i(57,39)]:
   if stage()!="Walls":break
   at(h.center(c));p.work()
 check(stage()=="Roof & finishing","Complete walls unlock roofing")
 at(h.center(Vector2i(53,42)));p.work();await capture_stage("06-roof")
 check(stage()=="Roof & finishing","Roof capture retains actual unfinished roof")
 var paid=g.state.inventory.duplicate(true);var remaining=p.cost(p.chosen())
 g.save_game();g.start_game(true);settle();p=g.surface.architecture.room_blueprints;h=g.surface.house;p.selected=first_id
 check(stage()=="Roof & finishing" and p.cost(p.chosen())==remaining,"Save/reload preserves exact unfinished stage and remaining cost")
 check(g.state.inventory==paid,"Reload does not spend or refund construction")
 for i in 10:
  if stage()=="Complete":break
  sweep()
 check(stage()=="Complete","Real construction reaches completed room")
 for item in quote:check(g.state.count(item)==int(inventory[item])-int(quote[item]),"Phase boundaries preserve exact payment: "+item)
 var complete_inventory=g.state.inventory.duplicate(true);check(p.work()==0 and g.state.inventory==complete_inventory,"Repeated complete action cannot charge again")
 p.select_room(first_id);await capture_stage("07-complete")
 p.preview_roof=false;await show_plan();await snap("08-complete-cutaway")
 var completed=h.tiles().duplicate(true);p.forget();check(h.tiles()==completed,"Removing plan leaves the paid building intact")
 print("ROOM_STAGES197: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
