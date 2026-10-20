extends "res://tests/support/game_fixture.gd"
func run():
 output="res://docs/testing/refinement58/gameplay";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false)
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving"
 g.surface.enter("claim");settle()
 for sculpt in [4,5]:
  g.state.appearance=HoldAppearance.normalized({"sculpt":sculpt,"hair_color":4})
  HoldFolk.prepare(g);settle()
  for tool in 4:
   g.player=Vector2(650,850);key([KEY_1,KEY_3,KEY_4,KEY_2][tool])
   var start=g.player;Input.action_press("up");await frames(18);Input.action_release("up")
   check(g.player.y<start.y-35 and g.surface.direction.y<0,"Rear movement remains responsive: %d / tool %d"%[sculpt,tool])
   await snap("rear-%d-%d"%[sculpt,tool])
 for gender in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":4})
  g.handworks.data().carry.clear();g.handworks.data().loose.clear()
  g.player=Vector2(900,850);g.handworks.spawn("stone",g.player,4,"refinement58")
  key(KEY_E);await frames(24)
  check(g.handworks.data().carry.size()==1,"Physical lift still takes exactly one load: gender "+str(gender))
  for direction in ["down","up"]:
   var start=g.player;Input.action_press(direction);await frames(18);Input.action_release(direction)
   check(g.player.distance_to(start)>20 and g.handworks.data().carry.size()==1,"Moving carry retains ownership: "+str(gender)+direction)
   await snap("carry-%d-%s"%[gender,direction])
  key(KEY_Q);await frames(24)
  check(g.handworks.data().carry.is_empty() and g.handworks.data().loose.size()==1,"Set down returns one physical load: gender "+str(gender))
 # Use real E input through casting, waiting, reeling and one inventory reward.
 g.state.appearance=HoldAppearance.normalized({"gender":1,"sculpt":4,"hair_color":2})
 g.surface.enter("trail");settle();g.player=HoldHomesteadLife.BANK;g.fieldwork.data().kit=true
 HoldFolk.prepare(g);settle();var before=g.state.count("river_fish")
 key(KEY_E);check(g.fieldwork.action=="fish","E begins the existing fishing interaction")
 await frames(15);await snap("fish-cast")
 await frames(220);await snap("fish-bite")
 var a=HoldWholeFrames.descriptor(g.state.appearance,Vector2.RIGHT,false,0,"fish",3)
 var m=HoldWholeFrames.metadata[a.sheet][a.index]
 check(m.rect==HoldWholeFrames.metadata["female4-utility"][25].rect,"Reeling uses this character's raised rod, with no harvest bundle")
 Input.action_press("interact");await frames(60);Input.action_release("interact")
 check(g.state.count("river_fish")==before+1 and g.fieldwork.action=="","Held E reels exactly one catch")
 g.save_game();var appearance=g.state.appearance.duplicate(true);var fish=g.state.count("river_fish")
 g.start_game(true);settle()
 check(g.state.count("river_fish")==fish and g.state.appearance==appearance,"Reload preserves exact catch and complete character identity")
 print("REFINEMENT58 PLAY: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
