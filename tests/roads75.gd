extends "res://tests/support/game_fixture.gd"
func walk(action:String,n:int=38):
 Input.action_press(action);await frames(n);Input.action_release(action);await frames(1)
func held_crossings(action:String,n:int)->int:
 var changes=0;var previous=g.zone+"|"+g.surface.area
 Input.action_press(action)
 for i in n:
  await frames(1);var here=g.zone+"|"+g.surface.area
  if here!=previous:changes+=1;previous=here
 Input.action_release(action);await frames(1)
 return changes
func passage(area:String,p:Vector2,action:String,target:String,hold_frames:int=38):
 g.surface.enter(area,p);settle();g.surface.roads.portal_cooldown=0
 await walk(action,hold_frames)
 check(g.zone=="mine" if target=="mine" else g.surface.area==target,"Walk from "+area+" into "+target+" without E or a travel menu")
 settle()
 check(g.panel_id=="" and not is_instance_valid(g.overworld),"Crossing remains in the actual world")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var identity=g.state.appearance.duplicate(true)
 g.surface.enter("hearthward",HoldWorldZones.GATE+Vector2(0,45));settle();await walk("up")
 check(g.surface.area=="hearthward","Fresh arrival keeps Ivar's introduction gate")
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.state.camp_stage=3
 await passage("hearthward",Vector2(350,495),"up","room:home")
 await passage("room:home",Vector2(480,550),"down","hearthward")
 await passage("forgeward",Vector2(580,495),"up","room:forge")
 await passage("room:forge",Vector2(480,840),"down","forgeward")
 await passage("hearthward",HoldWorldZones.GATE+Vector2(0,45),"up","trail")
 at(Vector2(670,665));await snap("01-stonebridge")
 await passage("trail",Vector2(220,735),"up","hearthward")
 await passage("trail",Vector2(470,875),"down","pinewood")
 at(Vector2(540,730));await snap("02-pinewood-workyard")
 await passage("pinewood",Vector2(150,650),"left","trail")
 await passage("trail",Vector2(1540,875),"down","greenfields")
 at(Vector2(800,620));await snap("03-greenhearth")
 await passage("greenfields",Vector2(940,285),"up","trail")
 await passage("trail",Vector2(1730,700),"right","claim")
 await passage("claim",Vector2(150,790),"left","trail")
 await passage("trail",Vector2(510,565),"up","room:wayfarer")
 await snap("04-wayfarers-hearth")
 at(HoldFurnishings.bedside(HoldRoads.BED));g.state.combat.health=40;key(KEY_E);await frames(100)
 check(g.state.combat.health==100,"Wayside bunk provides real rest and save")
 at(Vector2(400,525));g.state.add("turnip",2);g.state.add("water",1);var food=g.state.count("food")
 check(g.surface.roads.cook("turnip_stew"),"Wayside kitchen queues a real recipe using carried ingredients")
 g.state.tick(4);check(g.state.count("food")==food+3,"Roadside cooking shares existing production and provisions")
 at(Vector2(700,580));key(KEY_E);check(g.panel_id=="storage","Wayside chest is usable persistent storage");g.close_panel()
 await passage("room:wayfarer",Vector2(480,550),"down","trail")
 await passage("greenfields",Vector2(550,495),"up","room:greenhearth")
 await snap("05-farmhouse")
 await passage("room:greenhearth",Vector2(480,550),"down","greenfields")
 await passage("trail",Vector2(950,355),"up","mine",180)
 check(g.player.y>=300,"Held entry input cannot immediately walk back out of Old Workings")
 at(Deepworks.center(Deepworks.ENTRY));var exits=await held_crossings("up",180);settle()
 check(exits==1 and g.zone=="approach" and g.surface.area=="trail","Held movement walks out of the mine exactly once to its staging yard")
 await passage("claim",Vector2(1280,400),"up","mine",180)
 check(g.player.y>=300,"Held entry input cannot immediately walk back out of the claim mine")
 at(Deepworks.center(Deepworks.ENTRY));exits=await held_crossings("up",180);settle()
 check(exits==1 and g.surface.area=="claim" and g.state.active_site=="claim","Held movement leaves the claim mine once with site ownership intact")
 g.surface.enter("hearthward",HoldWorldZones.GATE+Vector2(0,45));settle()
 var wagon={"id":"roads-test-wagon","kind":"wagon","area":g.handworks.context(),"x":g.player.x,"y":g.player.y,"raw":[],"cargo":{"wood":4},"job":{},"hitched":true}
 g.handworks.data().facilities.append(wagon);g.surface.roads.portal_cooldown=0
 var gate_crossings=await held_crossings("up",300);settle()
 check(gate_crossings==1 and g.surface.area=="trail" and g.handworks.local(wagon) and wagon.cargo.wood==4,"Five seconds of held wagon movement crosses the King's Gate exactly once")
 gate_crossings=await held_crossings("up",300);settle()
 check(gate_crossings==1 and g.surface.area=="hearthward" and g.handworks.local(wagon) and wagon.cargo.wood==4,"Releasing then walking back returns the same wagon without bouncing")
 g.handworks.data().facilities.erase(wagon)
 # Crossings are directed: standing near a portal or passing beside it cannot warp.
 g.surface.enter("pinewood",Vector2(180,650));settle();await frames(60)
 check(g.surface.area=="pinewood","Standing at a threshold never bounces between scenes")
 check(g.surface.roads.crossing(Vector2(185,740),Vector2(165,740)).is_empty(),"Walking beside an exit does not trigger it")
 # Real loaded cart and shoulder cargo cross with exactly one owner.
 g.surface.enter("trail",Vector2(1540,875));settle();var h=g.handworks
 var cart={"id":"roads-test-cart","kind":"cart","area":h.context(),"x":1540.0,"y":875.0,"raw":[{"id":987,"kind":"stone","units":3}],"cargo":{"wood":4},"job":{},"hitched":true}
 h.data().facilities.append(cart);h.data().carry.append({"id":988,"kind":"log","units":2})
 g.surface.roads.portal_cooldown=0;await walk("down",52);settle()
 check(g.surface.area=="greenfields" and h.local(cart) and cart.hitched and cart.cargo.wood==4 and cart.raw.size()==1,"Loaded cart crosses with its existing records and cargo")
 check(h.data().carry.size()==1 and h.data().carry[0].id==988,"Shoulder load survives a crossing without duplication")
 cart.hitched=false;h.data().carry.clear()
 # Farm lease and crops reuse HomesteadLife and the actual inventory.
 at(HoldRoads.ORDERS.greenfields.p);g.state.money=100
 var count=g.fieldwork.data().beds.size();check(g.surface.roads.lease(),"Local board leases the four-bed allotment")
 check(g.state.money==88 and g.fieldwork.data().beds.size()==count+4 and not g.surface.roads.lease(),"Lease is paid exactly once")
 g.state.add("wood",3);g.state.add("iron",1);g.fieldwork.craft_kit();g.state.add("water",3)
 var b=g.fieldwork.data().beds.back();at(Vector2(b.x-65,b.y-18));var seed=g.state.count("turnip_seed")
 key(KEY_E);await frames(60)
 check(b.get("prepared",false) and not b.planted,"Soil preparation preserves seed until planting")
 key(KEY_E);await frames(60)
 check(b.planted and g.state.count("turnip_seed")==seed-1,"Physical planting spends the same carried seed as claim gardens")
 key(KEY_E);await frames(60);check(b.watered,"Allotment watering uses the existing field-work action")
 var crops=g.state.count("turnip");g.state.elapsed+=181;key(KEY_E);await frames(60)
 check(g.state.count("turnip")>crops and not b.planted,"Grown allotment crops harvest into the real pack")
 at(HoldRoads.ORDERS.greenfields.p);g.state.add("turnip",6);var stock=g.state.count("turnip");var cash=g.state.money
 check(g.surface.roads.deliver(),"Local produce order accepts a real delivery")
 check(g.state.count("turnip")==stock-6 and g.state.money==cash+30 and not g.surface.roads.deliver(),"Delivery conserves crops and prevents duplicate payment")
 at(Vector2(940,500));g.state.elapsed+=600
 check(not g.surface.roads.deliver(),"Delivery cannot be completed remotely")
 # No relocation of existing deep terrain, character or record data on reload.
 # Existing claim garden records retain their own scope beside the new allotment.
 g.fieldwork.data().beds.append({"id":int(g.fieldwork.data().next),"claim":"old_delving","x":780.0,"y":830.0,"planted":true,"watered":true,"at":g.state.elapsed})
 g.fieldwork.data().next+=1
 var terrain=g.state.deepworks.duplicate(true);var gardens=g.fieldwork.data().beds.duplicate(true);var inventory=g.state.inventory.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.surface.area=="greenfields" and g.player==Vector2(940,500),"New outdoor area restores exact saved position")
 check(g.state.inventory==inventory and g.state.appearance==identity,"Travel and reload preserve inventory and approved character identity")
 check(JSON.parse_string(JSON.stringify(g.state.deepworks))==JSON.parse_string(JSON.stringify(terrain)) and JSON.parse_string(JSON.stringify(g.fieldwork.data().beds))==JSON.parse_string(JSON.stringify(gardens)),"Excavation and both garden types survive reload")
 var loans=0
 for f in h.data().facilities:
  if str(f.id).begins_with("roads75:"):loans+=1
 g.surface.ensure();g.surface.ensure()
 var after=0
 for f in h.data().facilities:
  if str(f.id).begins_with("roads75:"):after+=1
 check(loans==4 and after==loans,"Loan equipment is idempotent across reloads")
 g.surface.enter("pinewood");settle()
 var bench={}
 for f in h.data().facilities:
  if str(f.id)=="roads75:pinewood:saw":bench=f
 at(Vector2(bench.x,bench.y+50));var timber=g.state.count("wood");h.recover();g.close_panel()
 check(h.data().facilities.has(bench) and g.state.count("wood")==timber,"Fixed loan stations cannot be dismantled for free materials")
 for area in ["trail","pinewood","greenfields"]:
  g.surface.enter(area);settle()
  var folk=g.surface.roads.people(area,0);var later=g.surface.roads.people(area,3)
  check(not folk.is_empty() and folk[0].profile==later[0].profile,"Local residents keep their canonical identity in "+area)
  for person in folk:check(g.surface.walkable(person.p),"Resident stands on usable floor: "+person.name)
  at(HoldRoads.ORDERS[area].p);key(KEY_E)
  check(g.panel_id=="road_order","Useful local board reachable in "+area);g.close_panel()
 g.surface.enter("trail",Vector2(1120,700));settle();await walk("right",100)
 check(g.player.x>1300 and g.surface.area=="trail","Existing river bridge remains a walkable connection")
 at(Vector2(760,590));g.open_panel("road_order");await snap("06-local-work");g.close_panel()
 key(KEY_G);check(g.panel_id=="wayfinding" and not is_instance_valid(g.overworld),"Directions do not turn into an overworld travel mode")
 # An old-version save is backed up byte-for-byte before the additive migration.
 g.close_panel();g.surface.enter("pinewood",Vector2(900,700));settle();g.save_game()
 var old=JSON.parse_string(FileAccess.get_file_as_string(g.state.save_path()));old.surface.erase("roads")
 var bytes=JSON.stringify(old);var file=FileAccess.open(g.state.save_path(),FileAccess.WRITE);file.store_string(bytes);file.close()
 var inventory_before=g.state.inventory.duplicate(true);g.start_game(true);settle()
 var backup_ok=false
 for path in DirAccess.get_files_at("user://"):
  if path.contains("pre-roads-75") and FileAccess.get_file_as_string("user://"+path)==bytes:backup_ok=true
 check(backup_ok and g.state.inventory==inventory_before,"Old save bytes are backed up before roads migration without losing inventory")
 check(g.fieldwork.data().beds.size()==gardens.size(),"Existing claim and allotment beds are never reseeded by migration")
 print("ROADS75: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
