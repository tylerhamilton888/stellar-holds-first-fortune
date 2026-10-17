extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 for order in [["borin","orla","hedrik"],["borin","hedrik","orla"],["orla","borin","hedrik"],["orla","hedrik","borin"],["hedrik","borin","orla"],["hedrik","orla","borin"]]:
  var s=HoldState.new();s.reset(322);HoldOnboarding.begin_fortune(s);HoldOnboarding.ensure(s).stage=2
  for id in order:
   if id=="hedrik":check(("will have shown" in HoldOnboarding.intro_text(s,id))==HoldOnboarding.ensure(s).met.has("orla"),"Hedrik respects introduction order")
   check(HoldOnboarding.introduce(s,id),"Introduction accepted")
   if HoldOnboarding.stage(s)==2:check(not HoldOnboarding.ensure(s).met.has(s.tracked_npc),"Marker targets someone still unmet")
  check(s.opening==1 and HoldOnboarding.stage(s)==3,"All orders start coal commission")
  check(not HoldOnboarding.introduce(s,"borin"),"No repeated introduction reward")
 var g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 g.state.opening=0;g.zone="hub";g.room_id="";g.grounded=true
 check(not g.can_region_travel() and "introductions" in g.region_travel_hint(),"Unmet hosts explain travel restriction")
 g.state.opening=1;g.room_id="market"
 check(not g.can_region_travel() and "building" in g.region_travel_hint(),"Indoor survey explains building exit")
 g.room_id="";g.zone="mine";g.player=Vector2(500,800)
 check(not g.can_region_travel() and "mine mouth" in g.region_travel_hint(),"Deep survey explains return route")
 g.zone="hub";g.grounded=false
 check(not g.can_region_travel() and "Land" in g.region_travel_hint(),"Airborne survey explains footing")
 g.grounded=true;check(g.can_region_travel(),"Outside grounded first-shift dwarf can travel")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("OPENING322: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
