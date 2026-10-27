extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var s=g.state;var d=HoldWorkEnergy.data(s)
 check(d.energy==100 and d.awake==0,"Legacy/new fortune initializes fully rested")
 s.add("food",20);s.add("hold_ale",3)
 for age in [0,3600,5400,7200]:
  d.awake=float(age);d.energy=0;d.full=0
  var expected={0:30.0,3600:22.5,5400:15.0,7200:7.5}[age]
  check(HoldWorkEnergy.recovery(s,"food")==expected,"Preview reflects tiredness at "+str(age))
  check(HoldWorkEnergy.eat(s,"food") and d.energy==expected,"Food restores previewed energy at "+str(age))
 var count=s.count("food")
 check(not HoldWorkEnergy.eat(s,"food") and s.count("food")==count,"Fullness prevents meal spam without spending food")
 d.energy=100;d.full=0
 check(not HoldWorkEnergy.eat(s,"food") and s.count("food")==count,"Full energy does not waste food")
 d.energy=50;d.awake=7200
 check(HoldWorkEnergy.ale(s) and d.energy==50 and d.awake==7200,"Ale grants comfort without replacing food or sleep")
 count=s.count("hold_ale");check(not HoldWorkEnergy.ale(s) and s.count("hold_ale")==count,"Drinks cannot be stacked")
 HoldWorkEnergy.spend(s,10);check(is_equal_approx(d.energy,40.5),"Drink comfort modestly reduces work expenditure")
 d.energy=0;check(HoldWorkEnergy.speed(s)==.8,"Exhaustion caps work penalty at twenty percent")
 HoldWorkEnergy.rest(s,true);check(d.energy==35 and d.awake==5400,"Nap restores some energy and physical rest")
 HoldWorkEnergy.rest(s);check(d.energy==100 and d.awake==0,"Sleep restores full energy and rest")
 d.energy=40;d.awake=5400;g.open_panel("energy");await snap("01-tired-meals")
 var before=float(d.awake);g._process(10)
 check(d.awake==before,"Energy menu pauses physical tiredness")
 g.close_panel();g.surface.enter("room:home");settle()
 g.player=HoldFurnishings.bedside(Vector2(290,420))
 g.open_panel("energy");await snap("02-bed-options");g.close_panel()
 var point=g.surface.nearest()
 check(g.surface.start_rest(point),"Existing bedside starts real sleep interaction")
 for i in 120:g.surface.move(1.0/60)
 check(d.energy==100 and d.awake<1,"Bed completion restores the same saved reserve")
 g.change_zone("mine");settle();g.deep.world.data.depth=0
 g.player=Deepworks.center(Vector2i(20,20));g.deep.world.set_cell(Vector2i(21,20),2)
 d.energy=100;d.comfort=0;d.rested=0;g.deep.hit(Vector2i(21,20))
 check(d.energy<100,"Actual mining contact spends work energy")
 g.state.opening=4;HoldOnboarding.ensure(g.state).combat=true;g.combat.armed=true
 d.energy=100;var normal=g.fight.movement(Vector2.RIGHT);d.energy=0
 check(g.fight.movement(Vector2.RIGHT)==normal,"Exhaustion leaves combat movement unchanged")
 g.fight.dodge=0;g.fight.dodge_wait=0;g.fight.evade()
 check(g.fight.dodge>0,"Zero work energy still allows dodge")
 d.energy=37;d.awake=4000;d.full=60;g.save_game();g.start_game(true);settle()
 d=HoldWorkEnergy.data(g.state)
 check(d.energy==37 and d.awake==4000 and d.full==60,"Energy tiredness and fullness survive save reload")
 await snap("03-hud")
 print("ENERGY90: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
