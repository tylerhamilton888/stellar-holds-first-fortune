extends "res://tests/support/game_fixture.gd"
func work():
 key(KEY_E)
 for i in 180:
  g.fieldwork.update(1.0/60)
  if g.fieldwork.action=="":break
  await process_frame
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://hearth78"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 for k in ["wood","stone","iron","water"]:g.state.add(k,100)
 check(g.fieldwork.craft_kit(),"Existing field tool kit supplies all four starter crops")
 var xp=HoldDisciplines.xp(g.state,"farming")
 for id in HoldHearth.CROPS:
  var i=HoldHearth.CROPS.keys().find(id);var p=Vector2(530+i*120,870);at(p+Vector2(-65,-18))
  check(g.fieldwork.build(p),"Build a reachable garden for "+id)
  var b=g.fieldwork.data().beds.back();at(Vector2(b.x,b.y+55));g.fieldwork.data().selected=id;var seeds=g.state.count(HoldHearth.CROPS[id].seed)
  await work();check(b.get("prepared",false) and not b.planted,"Soil loosens without consuming "+id+" seed")
  await work();check(b.planted and b.crop==id and g.state.count(HoldHearth.CROPS[id].seed)==seeds-1,"Selected "+id+" seed enters the actual bed")
  if id=="turnip":
   key(KEY_E)
   for frame in 90:
    g.fieldwork.update(1.0/60)
    if not g.fieldwork.moving and g.fieldwork.elapsed>=.3:break
    await process_frame
   await snap("01-watering")
   for frame in 90:
    g.fieldwork.update(1.0/60)
    if g.fieldwork.action=="":break
  else:await work()
  check(b.watered,"Watering starts forgiving "+id+" growth")
  var start=float(b.get("at",0));await work();check(b.get("tended",false) and b.get("at",start)<start,"Optional tending advances "+id+" without more water")
  g.state.elapsed+=300
 await snap("01-ripe-garden")
 for b in g.fieldwork.data().beds:
  at(Vector2(b.x,b.y+55));var count=g.state.count(g.fieldwork.crop(b));await work()
  check(g.state.count(g.fieldwork.crop(b))>count and not b.planted,"Harvest returns real "+g.fieldwork.crop(b)+" and resets the bed")
 check(HoldDisciplines.xp(g.state,"farming")==xp+4,"Only completed harvests earn farming mastery")
 # A genuine old bed has no crop or prepared fields. Preserve its timer and harvest.
 var legacy={"id":99,"claim":"old_delving","x":1030.0,"y":850.0,"planted":true,"watered":true,"at":g.state.elapsed-100000}
 g.fieldwork.data().beds.append(legacy);at(Vector2(965,832));var roots=g.state.count("turnip");await work()
 check(g.state.count("turnip")>roots,"Old planted beds remain ripe turnips after a long absence")
 for area in ["claim","trail","greenfields"]:
  g.surface.enter(area);settle();at(HoldHearth.SPOTS[area].bank);var place=g.fieldwork.spot();at(place.bank)
  var fish=place.fish[0];var count=g.state.count(fish);key(KEY_E)
  g.fieldwork.update(3.9);await snap("02-fishing-"+area)
  check(g.fieldwork.action=="fish","A bite waits without a timing failure at "+area)
  Input.action_press("interact");g.fieldwork.update(1);Input.action_release("interact")
  check(g.state.count(fish)>count,"The local catch reaches the pack at "+area)
 g.surface.enter("claim");settle();at(Vector2(1450,940));var farther=g.fieldwork.spot()
 check(g.fieldwork.near_water() and farther.float.x==1450,"Casting follows a different accessible riverbank position")
 at(Vector2(1450,800));check(not g.fieldwork.near_water(),"Dry land cannot produce a remote catch")
 check(HoldDisciplines.xp(g.state,"fishing")>=3,"Fishing catches award existing mastery")
 g.surface.enter("home:old_delving");settle();at(Vector2(440,375))
 check(g.hearth.cook("root_hotpot"),"Harvested ingredients queue hotpot at the home hearth")
 check(not g.hearth.serve("root_hotpot"),"An unfinished recipe cannot be served")
 for i in 10:g.state.tick(1)
 check(g.state.count("root_hotpot")==1,"Cooking completes into a real meal in the shared inventory")
 check(int(HoldHearth.saved(g.state).cooked.get("root_hotpot",0))==1,"Completed meals are recorded once")
 at(Vector2(560,410));var before=g.hearth.comforts().size();g.surface.placing="chair"
 check(g.surface.place(Vector2(580,350)),"Craft a chair beside the existing home table")
 check(g.hearth.comforts().size()>before and "Dining" in g.hearth.comforts(),"A usable table and chair add dining comfort")
 at(Vector2(610,350));var food=g.state.count("food")
 check(g.hearth.serve("root_hotpot"),"Serve the cooked harvest at the furnished home table")
 check(not g.hearth.serve("root_hotpot"),"Serving cannot duplicate an already consumed meal")
 check(g.state.count("root_hotpot")==0 and g.state.count("food")==food+1,"Comfort packs a modest extra provision without duplicating the meal")
 check(HoldHearth.work_bonus(g.state)==1.05,"Shared hotpot grants the documented modest production benefit")
 await snap("03-home-supper")
 var comfort=g.hearth.comforts().size()
 g.state.surface.decor.append({"area":g.surface.area,"z":0,"x":570.0,"y":500.0,"kind":"chair"})
 check(g.hearth.comforts().size()==comfort,"Duplicate furniture cannot inflate comfort")
 g.state.surface.decor.pop_back()
 check(not g.hearth.cook("root_hotpot"),"A table cannot remotely operate the kitchen")
 g.hearth.tab="home";g.open_panel("hearth");await snap("04-comfort-board");g.close_panel()
 g.hearth.tab="cook";at(Vector2(440,375));g.open_panel("hearth");await snap("05-home-kitchen");g.close_panel()
 var d=HoldHearth.saved(g.state).duplicate(true);var inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(JSON.parse_string(JSON.stringify(g.state.inventory))==JSON.parse_string(JSON.stringify(inventory)) and JSON.parse_string(JSON.stringify(HoldHearth.saved(g.state).meal))==JSON.parse_string(JSON.stringify(d.meal)),"Meals, exact inventory and benefit expiry survive save/reload")
 g.state.elapsed+=10000
 check(HoldHearth.work_bonus(g.state)==1 and g.state.count("food")==inventory.food,"Expired supper removes only its bonus, never stored food")
 # Every ingredient is tradable, so neither hobby is compulsory.
 g.state.money=1000
 for item in ["hearthcap","turnip","pond_perch","carrot"]:check(g.state.trade(item,true),"Buy alternate-path ingredient "+item)
 g.surface.enter("room:wayfarer");settle();at(Vector2(400,525))
 check(g.hearth.cook("fish_chowder"),"Public kitchen accepts purchased ingredients")
 for i in 10:g.state.tick(1)
 g.surface.enter("room:tavern");settle();at(Vector2(365,470))
 check(g.hearth.favor("fish_chowder"),"Hedrik accepts the optional supper after a comfortable home meal")
 check(g.hearth.comforts().is_empty(),"Public tavern furniture cannot count as the player home")
 check(g.state.tech.has("hearthkeeping") and not g.hearth.favor("fish_chowder"),"Favor grants the plans once without altering other quests")
 g.hearth.tab="neighbor";g.open_panel("hearth");await snap("06-neighbor-favor");g.close_panel()
 # Learn through the existing mastery API and verify each new effect.
 HoldDisciplines.award(g.state,"fishing",6)
 check(HoldDisciplines.learn(g.state,"patient_angler") and is_equal_approx(g.fieldwork.bite_time(),2.8),"Fishing mastery shortens the real bite wait by one second")
 HoldDisciplines.award(g.state,"farming",6)
 check(HoldDisciplines.learn(g.state,"gentle_tending"),"Farming work unlocks optional gentle tending")
 g.surface.enter("claim");settle()
 var tended=g.fieldwork.data().beds[0];tended.planted=true;tended.watered=true;tended.tended=true;tended.at=g.state.elapsed-300
 at(Vector2(tended.x,tended.y+55));var harvest_before=g.state.count(g.fieldwork.crop(tended));var base=3 if int(g.fieldwork.data().harvests)>=8 else 2
 await work()
 check(g.state.count(g.fieldwork.crop(tended))-harvest_before==base+1,"Gentle tending adds exactly one crop to a tended harvest")
 HoldDisciplines.award(g.state,"woodworking",6)
 check(HoldDisciplines.learn(g.state,"warm_table"),"Craftsmanship and Hearthkeeping unlock a welcoming table")
 g.surface.enter("home:old_delving");settle();at(Vector2(610,350));g.state.add("barley_bread",1)
 var provisions=g.state.count("food")
 check(g.hearth.serve("barley_bread"),"A bought or baked loaf can be shared at home")
 check(is_equal_approx(float(HoldHearth.saved(g.state).meal.until)-g.state.elapsed,600+g.hearth.comforts().size()*30+240),"Research and dining mastery each add their documented two minutes")
 check(g.state.count("food")==provisions+6,"Hearth bread supplies five provisions plus the comfort benefit")
 at(Vector2(350,380));g.surface.start_placement("pantry")
 check(g.surface.place(Vector2(350,330)),"Hearthkeeping plans craft a paid pantry through existing placement")
 g.open_panel("homestead");button("Improve cottage");g.close_panel()
 check(int(g.state.surface.homes[g.state.claim_id].level)==1,"The existing paid cottage improvement remains available")
 await snap("07-improved-home")
 # Existing progress and isolated pre-migration bytes remain recoverable.
 g.save_game();var path=g.state.save_path();var raw=FileAccess.get_file_as_string(path);var old=JSON.parse_string(raw);old.surface.erase("hearth78")
 var f=FileAccess.open(path,FileAccess.WRITE);f.store_string(JSON.stringify(old));f.close();var original=FileAccess.get_file_as_string(path)
 g.start_game(true);settle();var backup=false
 for file in DirAccess.get_files_at("user://"):
  if file.contains("pre-hearth78") and FileAccess.get_file_as_string("user://"+file)==original:backup=true
 check(backup,"Migration preserves the exact old save before adding household records")
 check(g.state.claim_id=="old_delving" and g.state.tech.has("hearthkeeping"),"Legacy claim and research survive household migration")
 print("HOMESTEAD78: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
