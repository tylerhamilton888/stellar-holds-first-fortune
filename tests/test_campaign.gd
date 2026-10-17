extends SceneTree
var passed=0
var failed=0
func check(ok:bool,message:String):
 if ok:passed+=1;print("PASS: "+message)
 else:failed+=1;push_error("FAIL: "+message)
func _initialize():call_deferred("run")
func run():
 var s=HoldState.new();var g=Geology.new();s.reset(27419);g.generate(s.seed_value)
 check(s.opening==0 and s.claim_id=="" and s.money==45,"new dwarf starts employed without a charter")
 check(not s.finish_commission() and not s.buy_charter("old_delving"),"briefing and reference gate rewards and charters")
 s.opening=1
 var old_money=s.money
 check(not s.finish_commission() and s.money==old_money,"missing delivery cannot grant wages")
 for j in HoldCampaign.JOBS:
  for k in j.cost:s.inventory[k]=j.cost[k]
  var before=s.money
  check(s.finish_commission() and s.money==before+int(j.pay),"commission pays exactly once: "+j.name)
  for k in j.cost:check(s.count(k)==0,"delivered material consumed: "+k)
 check(not s.finish_commission(),"completed commission chain cannot be paid again")
 check(s.money==340 and s.opening==4,"three commissions fund every offered charter")
 check(not s.buy_charter("invalid"),"unknown charter rejected")
 s.money=0
 check(not s.buy_charter("old_delving") and s.claim_id=="","insufficient money preserves charter choice")
 s.money=340
 check(s.buy_charter("old_delving") and s.money==80 and s.camp_stage==1,"Old Delving includes inherited foundation")
 check(not s.buy_charter("copper_ridge"),"second charter cannot overwrite chosen mountain")
 g.strike(Vector2i(8,14),100);g.strike(Vector2i(9,14),.4)
 var original=g.cells.duplicate();var original_damage=g.damage.duplicate(true)
 check(s.switch_site("claim",g) and g.cells!=original,"claim is a distinct geological map")
 g.strike(Vector2i(8,14),100);g.strike(Vector2i(9,14),.8)
 var claim_cells=g.cells.duplicate();var claim_damage=g.damage.duplicate(true)
 s.switch_site("hold",g)
 check(g.cells==original and g.damage==original_damage,"returning to employer preserves exact excavation")
 s.switch_site("claim",g)
 check(g.cells==claim_cells and g.damage==claim_damage,"returning to claim preserves exact excavation")
 s.road_trees[0]=3
 check(s.save_world(g,"claim",Vector2(900,410)),"campaign save succeeds")
 var loaded=HoldState.new();var restored=Geology.new();var loc=loaded.load_world(restored)
 check(loaded.opening==4 and loaded.claim_id=="old_delving" and loaded.active_site=="claim","campaign and ownership survive reload")
 check(loaded.road_trees[0]==3 and restored.cells==claim_cells,"road timber and active mine persist")
 loaded.switch_site("hold",restored)
 check(restored.cells==original and restored.damage==original_damage,"inactive mine also survives reload")
 var snapshots=[]
 for c in HoldCampaign.CLAIMS:
  var map=Geology.new();HoldCampaign.prepare_claim(map,c,27419);snapshots.append(map.cells)
  check(not map.solid(Vector2(150,370)),"safe arrival for "+c.name)
 check(snapshots[0]!=snapshots[1] and snapshots[1]!=snapshots[2],"charter geology differs reproducibly")
 s.money=200
 for i in range(s.camp_stage,3):
  var stage=HoldCampaign.CAMP[i]
  for k in stage.cost:s.add(k,stage.cost[k])
  check(s.build_camp(),"founding work advances "+stage.name)
 check(s.camp_stage==3 and not s.build_camp(),"completed founding cannot consume more resources")
 # Simulate pre-campaign save: established operators keep their rights and excavation.
 var raw=JSON.parse_string(FileAccess.get_file_as_string(HoldState.SAVE))
 for k in ["opening","claim_id","camp_stage","active_site","worlds","road_trees"]:raw.erase(k)
 raw.zone="hub"
 var f=FileAccess.open(HoldState.SAVE,FileAccess.WRITE);f.store_string(JSON.stringify(raw));f.close()
 var legacy=HoldState.new();var legacy_geo=Geology.new();var legacy_loc=legacy.load_world(legacy_geo)
 check(legacy.claim_id=="legacy" and legacy.camp_stage==3 and legacy.opening==4,"legacy saves remain independent and unlocked")
 check(legacy.active_site=="claim" and legacy_loc.zone=="claim" and legacy_geo.cells==claim_cells,"legacy mine and surface migrate together")
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding")
 for page in ["briefing","commission","charters","gate","camp"]:
  game.open_panel(page);check(is_instance_valid(game.overworld) if page=="gate" else game.panel.visible,"opens campaign panel: "+page)
 game.state.opening=4;game.state.money=340;game.state.buy_charter("old_delving");game.travel_claim()
 check(game.zone=="claim" and game.state.active_site=="claim","travel reaches owned mountain")
 game.change_zone("mine");game.player=Deepworks.center(Deepworks.ENTRY);game.interact()
 check(game.zone=="claim","claim mine exits to its own mountain")
 game.state.worker=true;game.state.add("food",6);game.spawn_agents();game.travel_hold()
 var before=game.geo.cells.duplicate()
 for i in 200:game.update_agents(.1)
 check(game.geo.cells==before,"hired claim crew cannot excavate employer mine")
 game.travel_road();var wood=game.state.count("wood");game.tool=2;game.player=Vector2(HoldForestry.X[1]-65,410);game.grounded=true;game.forest_target=HoldForestry.target(game,Vector2(HoldForestry.X[1],380));game.hit_point=game.forest_target.p;game.hit_tree()
 check(game.state.count("wood")==wood+2 and game.state.road_trees[1]==7,"visible road firs yield timber")
 game.travel_hold();wood=game.state.count("wood");game.hit_tree()
 check(game.state.count("wood")==wood,"no invisible trees can be chopped inside hold")
 game.playing=false;game.sound.stop_all();await create_timer(.5).timeout;game.queue_free();await process_frame
 print("%d CAMPAIGN CHECKS PASSED / %d FAILED" % [passed,failed]);quit(1 if failed else 0)
