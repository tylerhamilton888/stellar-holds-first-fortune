extends SceneTree
var checks=0
var failures=0
func check(ok:bool,message:String):
 if not ok:
  push_error("FAILED: "+message);failures+=1;return
 checks+=1
 print("PASS: "+message)
func _initialize():call_deferred("run")
func run():
 var g=Geology.new();g.generate(27419)
 var identical=Geology.new();identical.generate(27419)
 check(g.cells==identical.cells,"same seed produces identical geology")
 identical.generate(30000)
 check(g.cells!=identical.cells,"different seeds change geological formations")
 var kinds={}
 for k in g.cells:kinds[k]=true
 check(kinds.size()==11,"generator includes all strata, deposits, cavities and boundary")
 var route=g.route(Vector2i(5,13),"iron_ore")
 check(not route.is_empty(),"starter gallery exposes connected iron deposits")
 for p in route.path:check(not g.solid(p),"worker route traverses air")
 var target=route.target
 var rock=g.at(target.x,target.y)
 var result={}
 while result.is_empty():result=g.strike(target,1.4)
 check(result.item=="iron_ore" and g.at(target.x,target.y)==0,"impacts destroy real terrain and yield the matching resource")
 var s=HoldState.new();s.reset(27419)
 check(not s.pay({"iron":4},30) and s.money==45,"unaffordable transactions are atomic")
 check(not s.craft("assembly"),"research blocks advanced recipes")
 s.add("iron_ore",2);s.add("coal",1)
 check(s.craft("iron"),"smelting reserves input resources")
 check(s.count("iron_ore")==0 and s.count("coal")==0,"reserved ingredients cannot be spent twice")
 s.tick(4)
 check(s.count("iron")==1 and s.queue.is_empty(),"production completes and credits inventory")
 s.money=2000
 for k in HoldData.ITEMS:s.add(k,150)
 check(s.research("metallurgy"),"precision forging unlocks fabrication")
 check(s.research("extraction"),"extraction research unlocks pick upgrade")
 check(s.research("automation"),"automation requires and accepts metallurgy")
 check(not s.research("automation"),"research cannot charge twice")
 check(s.craft("parts"),"unlocked fabrication queues machine parts")
 s.tick(5)
 var old=s.price("iron_ore",false)
 for i in 15:s.trade("iron_ore",false)
 check(s.price("iron_ore",false)<old,"selling depresses prices through supply")
 var funds=s.money
 s.trade("coal",true);s.trade("coal",false)
 check(s.money<funds,"bid/ask spread prevents immediate arbitrage")
 s.bargain=100
 check(s.price("stone",false)>=1,"bargained prices remain valid")
 for stage in HoldData.SHIP:
  check(s.pay(stage.cost,stage.money),"ship stage consumes listed materials and crowns")
  s.ship_stage+=1
 check(s.ship_stage==3,"all three construction stages complete")
 s.craft("iron")
 g.strike(Vector2i(8,15),.5)
 # Use isolated test userdata; tests never run against a real player's save.
 check(s.save_world(g,"mine",Vector2(140,370)),"atomic save succeeds")
 var loaded=HoldState.new();var restored=Geology.new();var loc=loaded.load_world(restored)
 check(not loc.is_empty() and loc.zone=="mine","load restores zone and position")
 check(restored.cells==g.cells and restored.damage==g.damage,"load preserves destroyed cells and partially damaged rock")
 check(loaded.inventory==s.inventory and loaded.queue==s.queue,"load preserves inventory and production jobs")
 check(loaded.tech==s.tech and loaded.ship_stage==3,"load preserves research and ship progression")
 var game=load("res://main.tscn").instantiate();root.add_child(game)
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding")
 game.change_zone("mine")
 for i in 60:game.move_player(1.0/60)
 check(game.grounded and not game.body_solid(game.player),"player settles above the mine floor without collision penetration")
 var before=game.player.x
 Input.action_press("right")
 for i in 30:game.move_player(1.0/60)
 Input.action_release("right")
 check(game.player.x>before+40,"keyboard movement advances the dwarf")
 Input.action_press("up")
 var y=game.player.y
 for i in 30:game.move_player(1.0/60)
 Input.action_release("up")
 check(game.player.y>=y,"Climbing requires a built ladder; no free winch flight")
 game.state.claim_id="legacy";game.state.opening=4;game.state.camp_stage=3
 game.state.worker=true;game.state.automaton=true;game.state.add("coal",10);game.spawn_agents()
 var cells_before=game.geo.cells.duplicate()
 for i in 1200:game.update_agents(.05)
 check(game.geo.cells!=cells_before,"worker and automaton travel and excavate actual terrain")
 check(game.state.mined>0,"automated mining yields real inventory")
 game.state.agents_enabled=false
 cells_before=game.geo.cells.duplicate()
 for i in 50:game.update_agents(.1)
 check(game.geo.cells==cells_before,"pause assignments stops excavation")
 for menu in ["home","tavern","market","forge","research","inventory","manage","ship","pause","help","victory"]:
  game.open_panel(menu)
  check(game.panel.visible,"opens "+menu+" interface")
 game.close_panel();game.state.ship_stage=3;game.begin_launch()
 for i in 80:game._process(.1)
 check(game.state.launched and game.panel_id=="victory","launch sequence reaches saved victory state")
 game.playing=false;game.sound.stop_all()
 await create_timer(.5).timeout
 game.queue_free();await process_frame
 print("%d CHECKS PASSED / %d FAILED" % [checks,failures])
 quit(1 if failures else 0)
