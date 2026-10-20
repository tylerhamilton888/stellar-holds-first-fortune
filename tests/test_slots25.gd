extends SceneTree
func _initialize():call_deferred("run")
func run():
 var state=HoldState.new();var geo=Geology.new()
 for slot in range(1,4):
  state.save_slot=slot;state.reset(1000+slot);geo.generate(1000+slot)
  state.appearance.first_name="Tester%d" % slot;state.appearance.family_name="Stone"
  state.money=100*slot;state.road_trees[0]=slot
  geo.set_cell(Vector2i(150,70),slot)
  assert(state.save_world(geo,"mine",Vector2(150+slot,400)))
 for slot in range(1,4):
  state.save_slot=slot;var loaded=state.load_world(geo)
  assert(not loaded.is_empty() and loaded.pos.x==150+slot)
  assert(state.money==100*slot and state.road_trees[0]==slot)
  assert(geo.at(150,70)==slot)
  assert(HoldState.slot_summary(slot).name=="Tester%d Stone" % slot)
 assert(HoldState.slot_path(1)==HoldState.SAVE)
 state.save_slot=2;state.reset(9999);geo.generate(9999);state.money=9
 assert(state.save_world(geo,"hub",Vector2.ZERO))
 state.save_slot=1;state.load_world(geo);assert(state.money==100)
 state.save_slot=3;state.load_world(geo);assert(state.money==300)
 print("SLOTS25: Three independent worlds, replacement isolation, metadata and legacy slot path passed")
 quit()
