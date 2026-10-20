extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://docs/testing/whole-0.58.0/interaction"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 g.player=Vector2(650,850)
 for i in 4:
  key([KEY_1,KEY_2,KEY_3,KEY_4][i])
  var pose="hold_"+["pick","shovel","axe","hammer"][i]
  var start=g.player;Input.action_press("right");await frames(12);Input.action_release("right")
  check(g.hotbar.pose()==pose and g.player.x>start.x+25,"Number key changes the drawn held tool without slowing movement: "+pose)
  var a=HoldFolk.descriptor(g.state.appearance,Vector2.RIGHT,true,g.gait_clock,g.hotbar.pose(),0)
  var expected=HoldWholeFrames.identity(g.state.appearance)+("-motion" if HoldWholeFrames.metadata.has(HoldWholeFrames.identity(g.state.appearance)+"-motion") else "-equipped")
  check(a.sheet==expected and a.action==pose,"Walking uses the integrated gripping-hands drawing: "+pose)
  await snap("tool-"+str(i))
 var stone=g.state.count("stone");key(KEY_7)
 check(g.hotbar.pose()==("hold_supply" if stone>0 else ""),"An empty selected stack does not fabricate a visible load")
 g.state.add("stone",3);check(g.hotbar.pose()=="hold_supply","Actual pack resources occupy the supported supply tray")
 g.player=Vector2(900,850);var h=g.handworks;h.spawn("stone",g.player,4,"grip-test");key(KEY_E);await frames(24)
 check(h.data().carry.size()==1 and g.hotbar.pose()=="","Lifting a physical load suppresses the selected tray/tool")
 await snap("physical-stone")
 key(KEY_Q);await frames(24)
 check(h.data().carry.is_empty() and h.data().loose.size()==1 and g.hotbar.pose()=="hold_supply","Putting down restores selected supply without duplicating cargo")
 check(g.state.count("stone")==stone+3,"Changing and displaying equipment never spends pack materials")
 g.save_game();g.start_game(true);settle()
 check(g.hotbar.item=="stone" and g.hotbar.pose()=="hold_supply" and g.state.count("stone")==stone+3,"Reload preserves selected supply and exact inventory")
 check(g.handworks.data().loose.size()==1 and g.handworks.data().carry.is_empty(),"Ground load keeps independent ownership through reload")
 g.state.outpost.mining_gun=true;key(KEY_5)
 check(g.mining_gun.selected and g.hotbar.pose()=="hold_rifle","Unlocked Slagcaster selects its complete rifle grip")
 for gender in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":0});HoldFolk.prepare(g);settle()
  var count=HoldWholeFrames.cache.size()
  for view in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]:
   for tool in ["pick","shovel","axe","hammer","supply","rifle"]:
    var a=HoldFolk.descriptor(g.state.appearance,view,true,0,"hold_"+tool,0)
    HoldWholeFrames.texture(g.state.appearance,a.sheet,a.index)
  check(HoldWholeFrames.cache.size()==count,"All turn/selection silhouettes are warmed before walking: gender "+str(gender))
  for view in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]:
   var a=HoldFolk.descriptor(g.state.appearance,view,false,0,"lift_log",.5)
   HoldWholeFrames.texture(g.state.appearance,a.sheet,a.index)
  check(HoldWholeFrames.cache.size()==count,"Existing log lift also stays prewarmed through cargo transitions: gender "+str(gender))
 print("WHOLE58: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
