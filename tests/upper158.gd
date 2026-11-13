extends "res://tests/support/game_fixture.gd"
func normal(v):return JSON.parse_string(JSON.stringify(v))
func stand(c:Vector2i):g.player=Deepworks.center(c);g.transition_left=0
func build_room(p):
 var h=g.surface.house;var r=p.chosen();var b=p.bounds(r)
 for attempt in 8:
  for c in [b.get_center(),b.position+Vector2i.ONE,Vector2i(b.end.x-2,b.position.y+1),b.end-Vector2i(2,2),Vector2i(b.position.x+1,b.end.y-2)]:
   stand(c);p.work()
  if p.remaining(r).is_empty():break
 check(p.remaining(r).is_empty(),"Build floor-specific room using existing paid construction")
func shift_e():
 var e=InputEventKey.new();e.keycode=KEY_E;e.physical_keycode=KEY_E;e.pressed=true;e.shift_pressed=true;g._unhandled_input(e)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 for tech in HoldData.RESEARCH:g.state.tech[tech]=true
 g.surface.enter("claim",Vector2(2280,1760));settle()
 var p=g.surface.architecture.room_blueprints;var h=g.surface.house
 check(p.save_rectangle(Vector2i(50,30),Vector2i(56,38)),"Plan ground-floor hall")
 p.chosen().erase("z") # Existing pre-multilevel save format.
 var ground=p.selected;var carried=normal(g.state.inventory);var position=g.player
 p.choose_level(1)
 check(h.level()==0 and g.player==position,"Changing the planning floor never moves the player")
 check(p.save_rectangle(Vector2i(50,30),Vector2i(56,38)),"Plan an upper room directly over a ground-floor plan")
 var upper=p.selected
 check(HoldUpperBlueprints.missing_supports(p,p.chosen())==63,"Show all missing supports before construction")
 check(p.progress(p.chosen()).state=="Needs supports","Unsupported room has explicit planning status")
 check(normal(g.state.inventory)==carried,"Multilevel planning spends no resources")
 check(p.work()==0,"Cannot construct another floor remotely")
 check(not p.configure("purpose","Kitchen",ground),"Stale controls cannot edit the other floor")
 p.choose_level(0);p.select_room(ground);build_room(p)
 var ground_tiles=normal(h.tiles(0))
 stand(Vector2i(54,36));g.surface.start_placement("hearth");check(g.surface.place(Deepworks.center(Vector2i(52,36))),"Furnish a ground-floor kitchen beneath the bedroom")
 p.choose_level(1);p.select_room(upper)
 check(HoldUpperBlueprints.missing_supports(p,p.chosen())==0,"Completed lower floor provides actual support")
 check(p.progress(p.chosen()).state=="Needs stairs","Supported upper plan identifies missing access")
 check(p.remaining(p.chosen()).all(func(part):return not part.kind.ends_with("floor")),"Reuse the paid roof deck without charging twice for floors")
 stand(Vector2i(52,32));p.choose_level(0)
 check(HoldUpperBlueprints.plan(p),"Plan aligned stairs from the lower floor")
 check(not HoldUpperBlueprints.plan(p),"Duplicate stair guide rejected")
 carried=normal(g.state.inventory)
 check(HoldUpperBlueprints.build(p),"Build planned stairs through existing paid builder")
 check(g.state.count("wood")==int(carried.wood)-4 and g.state.count("stone")==int(carried.stone)-2,"Exact stair cost paid once")
 carried=normal(g.state.inventory);check(not HoldUpperBlueprints.build(p),"Already-built stair cannot charge twice")
 check(normal(g.state.inventory)==carried,"Repeated stair action preserves materials")
 p.choose_level(1);p.select_room(upper);check(HoldUpperBlueprints.access(p,p.chosen()),"Built stair connects the upper plan")
 var quote=p.cost(p.chosen());carried=normal(g.state.inventory)
 g.close_panel();key(KEY_E);settle();check(h.level()==1 and Deepworks.cell(g.player)==Vector2i(52,32),"Actual input climbs aligned stairs")
 build_room(p)
 for item in quote:check(g.state.count(item)==int(carried[item])-int(quote[item]),"Upper-room spending matches quote for "+item)
 check(normal(h.tiles(0))==ground_tiles,"Upper construction preserves the entire ground-floor shell")
 stand(Vector2i(54,34));g.surface.start_placement("bed");check(g.surface.place(Deepworks.center(Vector2i(52,36))),"Place usable bedroom furnishing upstairs")
 stand(Vector2i(52,34));g.surface.start_placement("chest");check(g.surface.place(Deepworks.center(Vector2i(54,34))),"Place separate upstairs storage")
 var chest_id=""
 for id in g.state.surface.chests:
  if int(g.state.surface.chests[id].get("z",0))==1:chest_id=id
 check(chest_id!="","Storage records the actual upper level")
 if chest_id!="":
  g.surface.selected_chest=chest_id;check(g.surface.transfer("stone",7,true)==7,"Deposit supplies through actual upstairs chest interaction")
 p.select_room(upper);check(p.configure("style_family","forge",upper),"Select upper-room renovation")
 for attempt in 5:
  for c in [Vector2i(51,31),Vector2i(55,31),Vector2i(51,37),Vector2i(55,37),Vector2i(53,33)]:stand(c);p.work()
 check(HoldBlueprintFinishes.cost(p,p.chosen()).is_empty(),"Finish upstairs with existing research and exact coverage payments")
 check(normal(h.tiles(0))==ground_tiles,"Upper finishes never recolor or charge the room below")
 var upper_tiles=normal(h.tiles(1));var furniture=normal(g.state.surface.decor);var chests=normal(g.state.surface.chests)
 stand(Vector2i(52,32));g.save_game();g.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(true);settle();p=g.surface.architecture.room_blueprints;h=g.surface.house
 check(h.level()==1 and p.level()==1,"Cold reload restores actual upper floor and its default planning view")
 check(normal(h.tiles(1))==upper_tiles and normal(g.state.surface.decor)==furniture and normal(g.state.surface.chests)==chests,"Cold reload preserves furnished renovated upper room and stocked storage")
 check(p.rooms().size()==1 and str(p.rooms()[0].id)==upper,"Only plans on the selected floor appear")
 check(HoldUpperBlueprints.stairs(p).size()==1,"Saved stair guide survives cold reload")
 p.choose_level(0);p.select_room(ground)
 check(p.configure("purpose","Kitchen",ground) and h.level()==1,"Edit the ground-floor designation from upstairs without moving")
 p.choose_level(1);p.select_room(upper);g.surface.architecture.room_planning=true;g.open_panel("architecture");await snap("01-upper-book");g.close_panel();await snap("02-upper-bedroom")
 p.choose_level(2);check(p.save_rectangle(Vector2i(59,30),Vector2i(63,34)),"Future unsupported expansion can be saved without construction")
 check(p.progress(p.chosen()).state=="Needs supports" and p.work()==0,"Future floor stays visibly unsupported and cannot build remotely")
 p.choose_level(1);p.select_room(upper);p.forget();check(normal(h.tiles(1))==upper_tiles and normal(g.state.surface.chests)==chests,"Removing upper plan preserves physical room and possessions")
 stand(Vector2i(52,32));shift_e();settle();check(h.level()==0,"Return to ground floor through the same stair")
 stand(Vector2i(52,35));check(not h.build(Deepworks.center(Vector2i(52,36)),"remove"),"Cannot recover the ceiling supporting the upstairs bed")
 # Existing-save fixture: a previously excavated claim cellar and its access.
 g.deep.ensure();var w=g.deep.world
 for x in range(8,55):w.set_cell(Vector2i(x,8),0,0)
 for y in range(8,35):w.set_cell(Vector2i(54,y),0,0)
 for y in range(31,38):
  for x in range(51,58):w.set_cell(Vector2i(x,y),0,0)
 stand(Vector2i(54,34));check(HoldEstateCellar.plan(g) and HoldEstateCellar.fit(g),"Existing cellar connection fits below the same three-level home")
 shift_e();settle();check(g.zone=="mine" and Deepworks.cell(g.player)==Vector2i(54,34),"Travel from ground floor into cellar")
 var ep=g.deep.works.blueprints
 check(ep.save_rectangle(Vector2i(51,31),Vector2i(57,37)) and ep.prepare_room(),"Prepare the existing excavated cellar as a furnishing space")
 check(g.deep.works.model.place(Vector2i(52,32),"bench").ends_with("installed."),"Fit cellar workshop equipment through existing paid furniture model")
 stand(Vector2i(55,35));check(g.handworks.build("store",Deepworks.center(Vector2i(56,36))),"Build a separate cellar storage pallet")
 var store=g.handworks.data().facilities.back();check(g.handworks.deposit(store)>0,"Deposit carried supplies in cellar storage")
 stand(Vector2i(54,34));shift_e();settle();check(g.surface.area=="claim" and h.level()==0,"Return from cellar to ground floor")
 stand(Vector2i(52,32));key(KEY_E);settle();check(h.level()==1,"Reach upper bedroom again after cellar trip")
 check(normal(g.state.surface.chests)==chests,"Three-level travel preserves upstairs storage contents")
 print("UPPER158: %d passed / %d failed" % [passed,failed]);g.queue_free();await process_frame;quit(1 if failed else 0)
