extends "res://tests/input_reference54.gd"
const ACTIONS=["hold_pick","hold_axe","hold_hammer","hold_shovel","hold_supply","hold_rifle","carry_stone","carry_log","double_stone","double_log","double_mixed"]
const DIRECTIONS=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://docs/testing/motion59/play"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 for gender in 2:
  for sculpt in 7:
   g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":3})
   var id=HoldWholeFrames.identity(g.state.appearance);var sheet=id+"-motion"
   check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==176,id+" has all eleven four-view, four-key states")
   HoldFolk.prepare(g);settle();var count=HoldWholeFrames.cache.size();var complete=true
   for action in ACTIONS:
    for d in DIRECTIONS:
     var seen={}
     for k in 4:
      var a=HoldWholeFrames.descriptor(g.state.appearance,d,true,(k+.1)*HoldWholeFrames.CYCLE/4,action,0)
      complete=complete and a.sheet==sheet;seen[a.index]=true
      HoldWholeFrames.texture(g.state.appearance,a.sheet,a.index)
     complete=complete and seen.size()==4
     var stopped=HoldWholeFrames.descriptor(g.state.appearance,d,false,.41,action,0)
     complete=complete and stopped.sheet==sheet and stopped.index%4==0
   check(complete and HoldWholeFrames.cache.size()==count,id+" turns/stops in the same complete artwork with every gait key prewarmed")
   print("MOTION59 identity complete: ",id)
   await process_frame
 for gender in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":3});HoldFolk.prepare(g);settle()
  var h=g.handworks;h.data().skills.mason=8;g.hotbar.select(2)
  for kinds in [["stone"],["log"],["stone","stone"],["log","log"],["stone","log"]]:
   at(Vector2(900,850));h.data().loose.clear()
   var ids=[]
   for kind in kinds:
    h.spawn(kind,g.player,3,"motion59");ids.append(int(h.data().loose.back().id));key(KEY_E);await frames(24)
   var expected="double_"+(kinds[0] if kinds[0]==kinds[1] else "mixed") if kinds.size()==2 else "carry_"+kinds[0]
   check(h.carry_action()==expected and h.data().carry.size()==kinds.size() and g.hotbar.pose()=="","Actual pickup selects only the correct supported load: "+str(gender)+" "+expected)
   var responsive=true
   for d in DIRECTIONS:
    var before=g.player
    for a in ["left","right","up","down"]:Input.action_release(a)
    if d.x:Input.action_press("right" if d.x>0 else "left")
    if d.y:Input.action_press("down" if d.y>0 else "up")
    await frames(14)
    responsive=responsive and g.player.distance_to(before)>12 and h.carry_action()==expected
   for a in ["left","right","up","down"]:Input.action_release(a)
   await frames(2)
   check(responsive,"Eight-direction loaded movement stays responsive and keeps cargo: "+str(gender)+" "+expected)
   await snap("load-"+str(gender)+"-"+expected)
   g.save_game();g.start_game(true);settle();h=g.handworks
   var actual=[]
   for raw in h.data().carry:actual.append(int(raw.id))
   if actual!=ids or h.carry_action()!=expected:print("CARGO RELOAD expected ",ids," / ",expected," actual ",actual," / ",h.carry_action())
   check(actual==ids and h.carry_action()==expected,"Reload preserves exact physical cargo identities and drawing: "+str(gender)+" "+expected)
   for i in kinds.size():key(KEY_Q);await frames(24)
   var released=[]
   for raw in h.data().loose:released.append(int(raw.id))
   ids.sort();released.sort()
   check(h.data().carry.is_empty() and released==ids and g.hotbar.pose()=="hold_axe","Put-down restores the selected tool with every load owned exactly once")
 g.state.add("stone",3);g.hotbar.select(6);at(Vector2(900,850))
 for d in DIRECTIONS:
  g.surface.direction=d;await snap("supply-"+str(DIRECTIONS.find(d)))
 print("MOTION59 PLAY COMPLETE: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
