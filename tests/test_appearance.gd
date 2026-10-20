extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1;print("PASS: "+message)
 else:failed+=1;push_error("FAIL: "+message)
func _initialize():call_deferred("run")
func run():
 var p=HoldAppearance.random_profile(712,0)
 check(p==HoldAppearance.random_profile(712,0),"randomization is deterministic for a stable seed")
 check(p!=HoldAppearance.random_profile(713,0),"different seeds provide different appearances")
 check(HoldAppearance.random_profile(712,1).beard_style==5,"female profiles use female hair and no beard")
 check(HoldAppearance.normalized({"name":"   "}).name!="","blank names receive a safe migration fallback")
 check(HoldAppearance.normalized({"sculpt":99,"cloth_color":-8}).sculpt==4 and HoldAppearance.normalized({"cloth_color":-8}).cloth_color==0,"out-of-range options are normalized")
 check(HoldAppearance.normalized({"beard_style":7}).sculpt==1,"Legacy long beard migrates to complete braided design")
 check(HoldAppearance.normalized({"gender":1,"sculpt":1,"beard_style":9}).beard_style==5,"Female design cannot acquire facial hair")
 var s=HoldState.new();s.reset(35718)
 p.first_name="Tyler";p.family_name="Ironbeard";p=HoldAppearance.normalized(p);p.tattoo=3;p.sculpt=1;p.cloth_color=3;p=HoldAppearance.normalized(p);s.appearance=p
 var npc=s.npc("orla").duplicate(true)
 check(s.npc("orla")==npc,"NPC looks do not reroll on repeated encounters")
 check(s.npc("orla").gender==1 and s.npc("brann").gender==0,"named character identities are preserved")
 var g=Geology.new();g.generate(s.seed_value)
 s.save_world(g,"hub",Vector2(150,410))
 var loaded=HoldState.new();var restored=Geology.new();loaded.load_world(restored)
 check(loaded.appearance==p,"name, hair, beard, clothing and tattoo survive save/load")
 check(loaded.npc("orla")==npc,"NPC appearances survive save/load")
 # Simulate an untouched v0.1 save with the new fields absent.
 var f=FileAccess.open(HoldState.SAVE,FileAccess.READ)
 var old=JSON.parse_string(f.get_as_text());f.close();old.erase("appearance");old.erase("npc_appearances")
 f=FileAccess.open(HoldState.SAVE,FileAccess.WRITE);f.store_string(JSON.stringify(old));f.close()
 var migrated=HoldState.new();var old_geo=Geology.new();var loc=migrated.load_world(old_geo)
 check(not loc.is_empty() and old_geo.cells==g.cells,"v0.1 saves migrate to a valid mountain grid")
 check(migrated.appearance.name!="" and not migrated.npc("orla").is_empty(),"old saves receive compatible appearance defaults")
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.start_game(false,p)
 check(game.state.appearance==p,"new game accepts the creator's named profile")
 game.open_creator(false)
 await process_frame
 var original=game.state.appearance.duplicate(true)
 game.creator.profile.cloth_color=6;game.creator.cancelled.emit()
 await process_frame
 check(game.state.appearance==original,"canceling the wardrobe leaves the character unchanged")
 game.open_creator(false)
 await process_frame
 game.creator.name_input.text="Astrid"
 game.creator.profile.gender=1;game.creator.profile.hair_style=0;game.creator.profile.hair_color=2
 game.creator.profile.first_name=game.creator.name_input.text
 game.creator.accepted.emit(HoldAppearance.normalized(game.creator.profile))
 await process_frame
 check(game.state.appearance.name=="Astrid Ironbeard" and game.state.appearance.gender==1,"accepting creator updates name and appearance together")
 var after=HoldState.new();var after_geo=Geology.new();after.load_world(after_geo)
 check(after.appearance==game.state.appearance,"wardrobe changes are immediately persisted")
 # Every rendered variant shares one source profile, not independently randomized components.
 for gender in 2:
  for style in 6:
   var candidate=HoldAppearance.random_profile(423+style,gender);candidate.sculpt=style%2 if gender==0 else 0;candidate.hair_color=style;candidate=HoldAppearance.normalized(candidate)
   var portrait=HoldPortrait.new();portrait.profile=candidate;portrait.size=Vector2(96,96);game.ui.add_child(portrait)
   var sprite=HoldSpritePreview.new();sprite.profile=candidate;sprite.size=Vector2(96,96);game.ui.add_child(sprite)
   await process_frame
   check(portrait.profile.hair_style==sprite.profile.hair_style and portrait.profile.hair_color==sprite.profile.hair_color,"portrait/sprite consistency gender %d palette %d" % [gender,style])
   portrait.queue_free();sprite.queue_free()
 game.playing=false;game.sound.stop_all();await create_timer(.5).timeout;game.queue_free();await process_frame
 print("%d APPEARANCE CHECKS PASSED / %d FAILED" % [passed,failed])
 quit(1 if failed else 0)
