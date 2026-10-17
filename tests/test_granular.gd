extends SceneTree
var checks=0
var failures=0
func check(ok:bool,label:String):
 checks+=1
 if not ok:failures+=1;push_error(label)
func blank()->Geology:
 var g=Geology.new();g.cells.resize(Geology.W*Geology.H);g.cells.fill(0);return g
func _initialize():call_deferred("run")
func run():
 var g=blank()
 for y in range(20,30):
  for x in range(20,30):g.set_cell(Vector2i(x,y),2)
 var contact=Vector2(140.1,140.1)
 var result=g.excavate(contact,Vector2(120,130),0,100)
 check(result.size()==1,"Fine cut removes exactly the chosen corner grain")
 check(g.at(21,20)==2,"Fine cut preserves adjacent grain")
 g=blank()
 for y in range(20,30):
  for x in range(20,30):g.set_cell(Vector2i(x,y),2)
 result=g.excavate(Vector2(140.1,157.5),Vector2(110,157.5),11,100)
 check(result.size()>1,"Normal pick removes a surface patch")
 check(g.at(21,22)==2,"Stroke cannot tunnel into hidden layers")
 g=blank();var units=0
 for x in 16:
  g.set_cell(Vector2i(20+x,20),3);units+=g.strike(Vector2i(20+x,20),100).count
 check(units==2 and g.grain_bank.iron_ore==0,"Sixteen grains retain old ore yield")
 g.set_cell(Vector2i(20,20),4);g.strike(Vector2i(20,20),100)
 var saved=g.snapshot();var restored=Geology.new();restored.restore(JSON.parse_string(JSON.stringify(saved)))
 check(restored.grain_bank.copper_ore==2,"Fractional resources persist through JSON save")
 g=blank();g.set_cell(Vector2i(20,20),1);g.activate_near(Vector2i(20,20));g.tick_materials(.05)
 check(g.at(20,21)==1 and g.at(20,20)==0,"Unsupported earth falls")
 check(g.cells.count(1)==1,"Falling earth conserves mass")
 g=blank();g.set_cell(Vector2i(20,20),1);g.activate_near(Vector2i(20,20));g.tick_materials(.05,Rect2(0,147,1000,1000))
 check(g.at(20,20)==1,"Earth does not fall inside actor")
 g=blank();g.set_cell(Vector2i(20,20),10);g.activate_near(Vector2i(20,20));g.tick_materials(.05)
 check(g.at(20,21)==12,"Breached reservoir releases water")
 check(not g.solid(g.center(Vector2i(20,21))),"Water permits passage")
 check(g.cells.count(12)==1,"Water conserves mass")
 var old=HoldLegacyGeology.new();old.generate(27419);old.cells[14*96+20]=0
 restored=Geology.new();restored.restore({"cells":old.cells,"seed":27419,"damage":{"21,14":1.0}})
 for dy in 4:
  for dx in 4:check(restored.at(80+dx,56+dy)==0,"Old excavation preserved")
 check(restored.damage.get("84,56")==.5,"Partial old damage migrated")
 check(restored.center(Vector2i(80,56)).x>=560,"Migration keeps physical footprint")
 var generated=Geology.new();generated.generate(27419)
 check(generated.cells.size()==67584,"Fine world size")
 check(generated.route(generated.cell_at(Vector2(150,370)),"coal").size()>0,"Opening coal is reachable")
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.change_zone("mine")
 game.geo=g;game.player=Vector2(150,147)
 check(not game.body_solid(game.player),"Body can move through empty and fluid cells")
 g.set_cell(Vector2i(21,15),2)
 check(game.body_solid(game.player),"Fine cell body collision covers torso")
 game.geo=generated;game.player=Vector2(150,370);game.velocity=Vector2.ZERO
 Input.action_press("right")
 for i in 120:game.move_player(1.0/60.0)
 Input.action_release("right")
 check(game.player.x>350 and not game.body_solid(game.player),"Broad actor walks gallery without embedding in rock")
 var rightmost=game.player.x
 Input.action_press("left")
 for i in 90:game.move_player(1.0/60.0)
 Input.action_release("left")
 check(game.player.x<rightmost-100 and not game.body_solid(game.player),"Broad actor reverses direction safely")
 game.playing=false;game.sound.stop_all();await create_timer(.3).timeout;game.queue_free();await process_frame
 print("GRANULAR TEST: %d checks, %d failures" % [checks,failures]);quit(1 if failures else 0)
