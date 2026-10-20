extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func press_named(g,text:String):
 var nodes=[g.panel_body]
 while not nodes.is_empty():
  var n=nodes.pop_front()
  if n is Button and n.text.begins_with(text):
   check(not n.disabled,"Button available: "+text)
   if not n.disabled:n.pressed.emit()
   return
  nodes.append_array(n.get_children())
 check(false,"Missing button: "+text)
func run():
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.start_game(false)
 check(is_instance_valid(g.opening_scene) and g.panel_id=="","Arrival precedes all conversations")
 check(g.opening_scene.mode=="arrival","Arrival narrative first")
 check(not HoldOnboarding.combat_ready(g.state),"New fortune has no hostile encounters")
 var time=g.state.elapsed;g._process(8);check(g.state.elapsed==time,"Arrival pauses simulation")
 g.opening_scene.finish();await process_frame
 check(HoldOnboarding.stage(g.state)==1 and g.state.tracked_npc=="ivar","Arrival points to foreman")
 g.enter_room("throne");check(g.room_id=="","No royal audience before proving worth")
 g.player=Vector2(1205,410);g.enter_room("commission");g.transition_left=0;g.open_panel("commission")
 press_named(g,"My name is")
 check(HoldOnboarding.stage(g.state)==2 and g.state.opening==0,"Introductions precede commission")
 for pair in [["borin","forge"],["orla","market"],["hedrik","tavern"]]:
  g.room_id=pair[1];g.open_panel(pair[1]);press_named(g,"Introduce yourself")
 check(HoldOnboarding.stage(g.state)==3 and g.state.opening==1,"All three introductions start first shift")
 check(not HoldOnboarding.side_stories(g.state),"Anniversary held for later")
 g.state.add("coal",8)
 check(g.state.finish_commission(),"First coal delivery accepted")
 check(HoldOnboarding.stage(g.state)==4,"First shift earns audience")
 for k in HoldCampaign.JOBS[1].cost:g.state.add(k,100)
 check(not g.state.finish_commission(),"Second commission cannot skip audience")
 g.room_id="commission";g.player=Vector2(820,410);g.interact();g.transition_left=0
 check(g.room_id=="throne" and g.room_return=="commission","Royal stair enters real room")
 g.open_panel("throne");press_named(g,"Step forward")
 check(is_instance_valid(g.opening_scene) and g.opening_scene.mode=="audience","Audience staged in throne room")
 g.opening_scene.finish();await process_frame
 check(HoldOnboarding.stage(g.state)==5,"Audience sends player back to foreman")
 check(not HoldOnboarding.side_stories(g.state),"Still awaiting next assignment")
 g.leave_room();g.transition_left=0;g.open_panel("commission");press_named(g,"Take the lift commission")
 check(HoldOnboarding.stage(g.state)==6 and HoldOnboarding.side_stories(g.state),"Follow-up opens local stories and lessons")
 check(HoldAnniversary.accept(g.state,"orla") and HoldAnniversary.accept(g.state,"hedrik"),"Both anniversary secrets available at proper point")
 check(HoldOnboarding.accept(g.state,"route"),"Return route lesson available")
 HoldOnboarding.fact(g.state,"built")
 check(not HoldOnboarding.complete(g.state,"route",false),"Lesson report requires host")
 check(HoldOnboarding.complete(g.state,"route",true),"Return-route report succeeds")
 check(not HoldOnboarding.complete(g.state,"route",true),"No repeated lesson reward")
 check(not HoldOnboarding.unlocked(g.state,"training"),"Training waits for lift repair")
 check(g.state.finish_commission(),"Lift repair follows audience")
 check(HoldOnboarding.unlocked(g.state,"training"),"Training now offered")
 check(HoldOnboarding.accept(g.state,"training"),"Borin offers safe practice")
 g.room_id="forge";g.enter_room("training");g.transition_left=0;g.close_panel();g.combat.spawn()
 check(g.combat.enemies.size()==1 and g.combat.enemies[0].id=="practice","Real combat system uses padded target")
 var e=g.combat.enemies[0];g.player=Vector2(550,410);g.face=1;g.combat.attack_direction=Vector2.RIGHT
 var health=g.state.combat.health
 for i in 3:g.combat.resolve_attack()
 check(HoldOnboarding.ensure(g.state).facts.get("practice_hit",0)==3,"Three real attack contacts recorded")
 g.combat.guard=true;g.combat.parry_left=.18
 check(g.combat.receive_hit(e,30)=="parry","Actual parry recognized")
 g.combat.guard=false;g.combat.invulnerable=0;g.combat.receive_hit(e,30)
 check(g.state.combat.health==health,"Practice cannot injure")
 g.combat.dodge();check(HoldOnboarding.progress(g.state,"training").ready,"Attack guard and dodge complete lesson")
 check(g.state.combat.cleared.is_empty(),"Practice grants no enemy loot or clears")
 g.leave_room();g.transition_left=0
 check(g.room_id=="forge","Practice returns to Borin")
 check(HoldOnboarding.complete(g.state,"training",HoldOnboarding.local(g,"borin")),"Report training locally")
 check(HoldOnboarding.combat_ready(g.state),"Hostiles unlock after training")
 check(HoldOnboarding.unlocked(g.state,"salvage"),"Salvage lesson follows training")
 g.state.save_world(g.geo,"hub",Vector2(970,410))
 var loaded=HoldState.new();loaded.load_world(Geology.new())
 check(HoldOnboarding.combat_ready(loaded) and HoldOnboarding.ensure(loaded).done.has("training"),"Guidance and combat gates persist")
 var legacy=HoldState.new();legacy.reset(31);legacy.opening=4
 check(HoldOnboarding.combat_ready(legacy) and HoldOnboarding.side_stories(legacy),"Existing fortunes retain access")
 for gender in 2:
  var s=HoldState.new();s.reset(31);s.appearance.gender=gender;HoldOnboarding.begin_fortune(s);HoldOnboarding.arrived(s)
  HoldOnboarding.ensure(s).stage=2
  for id in ["borin","orla","hedrik"]:HoldOnboarding.introduce(s,id)
  check(s.opening==1,"Both genders get same first shift")
  var amounts=[]
  for id in HoldOnboarding.LESSONS:amounts.append(HoldOnboarding.LESSONS[id].money)
  check(amounts.size()==15,"Fifteen authored system lessons")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("OPENING31: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
