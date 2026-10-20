extends SceneTree
var failed=0
func check(ok:bool,s:String):
 if not ok:failed+=1;push_error(s)
func _initialize():
 var women=0
 for seed_value in 1200:
  var p=HoldAppearance.random_profile(seed_value)
  women+=int(p.gender)
  check(p==HoldAppearance.random_profile(seed_value),"Stable seeded identity")
  if p.gender:check(p.beard_style==5,"Female dwarfs have no facial hair")
 check(women>120 and women<240,"Rare, present female population")
 var foreman=HoldAppearance.npc_profile("ivar",123)
 check(foreman.gender==0 and foreman.name=="Ivar Deepmeasure" and foreman.beard_style!=5,"Male named foreman")
 var s=HoldState.new();s.reset(123)
 s.appearance=HoldAppearance.random_profile(33,1);s.ensure_dynasty()
 s.opening=2;s.money=117
 s.npc_appearances={"ingrid":HoldAppearance.random_profile(1,1),"visitor_0":HoldAppearance.random_profile(5,1),"orla":HoldAppearance.npc_profile("orla",123)}
 var player=s.appearance.duplicate(true);var dynasty=s.dynasty.duplicate(true);var orla=s.npc_appearances.orla.duplicate(true)
 var g=Geology.new();g.generate(123);s.save_world(g,"approach",Vector2(300,410))
 var f=FileAccess.open(HoldState.SAVE,FileAccess.READ);var raw=JSON.parse_string(f.get_as_text());f.close();raw.erase("npc_population_version")
 f=FileAccess.open(HoldState.SAVE,FileAccess.WRITE);f.store_string(JSON.stringify(raw));f.close()
 var loaded=HoldState.new();loaded.load_world(Geology.new())
 check(not loaded.npc_appearances.has("ingrid") and loaded.npc("ivar").gender==0,"Old save migrates supervisor")
 check(loaded.appearance==player and loaded.dynasty==dynasty,"Female player and dynasty retained")
 check(loaded.opening==2 and loaded.money==117,"Quest and money retained")
 check(loaded.npc("orla")==orla,"Other authored characters retained")
 var cast=loaded.npc_appearances.duplicate(true);loaded.migrate_population(2)
 check(loaded.npc_appearances==cast,"Migration does not reroll current cast")
 print("POPULATION: %d / 1200 women; %d failures" % [women,failed]);quit(1 if failed else 0)
