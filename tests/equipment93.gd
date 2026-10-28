extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var s=g.state
 s.opening=4;HoldOnboarding.ensure(s).fresh=false;HoldOnboarding.ensure(s).combat=true
 var legacy={"health":73.0,"weapon":"hammer","armor":"mail","owned":["axe","clothes","hammer","mail"],"cleared":{"old":true},"wounds":{"alive":30}}
 s.combat=HoldCombat.normalize(legacy)
 var d=HoldEquipment93.ensure(s.combat)
 check(d.items.size()==4 and s.combat.weapon=="hammer" and s.combat.health==73,"Legacy ownership and equipped types migrate without stat changes")
 check(s.combat.cleared.has("old") and s.combat.wounds.alive==30,"Migration preserves encounter state")
 check(HoldEquipment93.ensure(s.combat).items==d.items and d.items.size()==4,"Repeated migration does not duplicate gear")
 for item in ["iron","copper","wood","parts","crystal","coal"]:s.add(item,50)
 var inventory=s.inventory.duplicate(true)
 check(HoldEquipment93.forge(g,"axe",1)=="" and inventory==s.inventory,"Remote forge cannot charge or create equipment")
 g.surface.enter("room:forge");settle()
 check(HoldEquipment93.forge(g,"axe",1)=="" and inventory==s.inventory,"Tempered gear requires metallurgy without consuming materials")
 s.tech.metallurgy=true
 var before=s.count("iron");var axe=HoldEquipment93.forge(g,"axe",1)
 check(axe!="" and s.count("iron")==before-6,"Tempered axe charges base and finishing materials once")
 check(g.combat.weapon().damage==30 and s.combat.gear93.equipped.weapon==axe,"Forging equips the new instance with effective damage")
 var copy=HoldEquipment93.forge(g,"axe",1)
 check(copy!=axe and HoldEquipment93.find(s.combat,axe).kind=="axe","Second commission creates an independent piece without replacing the first")
 check(HoldEquipment93.equip(g,"legacy_axe") and g.combat.weapon().damage==24,"Switching to original gear restores its actual stats")
 check(HoldEquipment93.comparison(s.combat,HoldEquipment93.find(s.combat,axe)).contains("+6"),"Comparison reports actual damage increase")
 var armor=HoldEquipment93.forge(g,"mail",1)
 check(is_equal_approx(g.combat.armor().reduction,.33),"Tempered mail adds eight protection points")
 var missing=s.inventory.duplicate(true);s.inventory.iron=0
 var count=HoldEquipment93.ensure(s.combat).items.size()
 check(HoldEquipment93.forge(g,"hammer",1)=="" and HoldEquipment93.ensure(s.combat).items.size()==count,"Unaffordable commission creates no phantom item")
 s.inventory=missing
 check(not HoldEquipment93.equip(g,"missing"),"Unknown instance cannot be equipped")
 check(HoldEquipment93.forge(g,"clothes",1)=="" and HoldEquipment93.forge(g,"axe",9)=="","Unsupported recipes cannot be forged")
 g.gear_tab="weapon";g.open_panel("equipment");await snap("weapons")
 check(g.panel.get_global_rect().end.x<=960 and g.panel.get_global_rect().end.y<=540,"Gear catalogue fits viewport")
 button("Equip Tempered Holdguard");check(g.combat.weapon().damage==30,"Real equipment button equips a specific upgraded weapon")
 button("Forge gear");g.gear_recipe="mail";g.refresh_panel();await snap("forge")
 check(g.menu_scroll.scroll_vertical==0 and g.menu_scroll.get_v_scroll_bar().max_value<=g.menu_scroll.size.y+1,"Forge comparisons and actions fit without scrolling")
 for kind in ["axe","hammer","gun","rune"]:
  g.gear_recipe=kind;g.refresh_panel();await snap("forge-"+kind)
  check(g.menu_scroll.get_v_scroll_bar().max_value<=g.menu_scroll.size.y+1,"Both forge grades fit for "+kind)
 g.gear_tab="armor";g.refresh_panel();await snap("armor");g.close_panel()
 var expected=s.combat.gear93.duplicate(true)
 g.save_game();g.start_game(true);settle();s=g.state
 check(s.combat.gear93==expected and s.combat.gear93.equipped.armor==armor,"Instance identities, workmanship and equipped pieces survive real reload")
 # Real legacy-file load keeps an exact rollback copy before any new autosave.
 var path=s.save_path();var old=JSON.parse_string(FileAccess.get_file_as_string(path));old.combat.erase("gear93")
 var file=FileAccess.open(path,FileAccess.WRITE);file.store_string(JSON.stringify(old));file.close()
 var bytes=FileAccess.get_file_as_bytes(path);g.start_game(true);settle();s=g.state
 var backup_ok=false
 for name in DirAccess.get_files_at(path.get_base_dir()):
  if name.begins_with(path.get_file()+".pre-equipment93-") and FileAccess.get_file_as_bytes(path.get_base_dir()+"/"+name)==bytes:backup_ok=true
 check(backup_ok,"Legacy load preserves exact pre-equipment save bytes")
 check(HoldEquipment93.ensure(s.combat).items.size()==s.combat.owned.size(),"Legacy file grants one standard instance per owned type")
 # Active combat: same effectiveness and work reserve at full and zero energy.
 g.change_zone("mine");settle();g.deep.world.data.depth=1
 for y in range(14,30):
  for x in range(14,30):g.deep.world.set_cell(Vector2i(x,y),0)
 g.player=Deepworks.center(Vector2i(20,20));var f=g.fight;f.spawn();g.combat.armed=true
 HoldEquipment93.equip(g,axe)
 # The earlier legacy-file test intentionally downgraded instances; forge fresh upgraded gear.
 g.room_id="forge";var test_axe=HoldEquipment93.forge(g,"axe",1);var test_mail=HoldEquipment93.forge(g,"mail",1);g.room_id=""
 check(test_axe!="" and test_mail!="","Upgraded gear can be commissioned after a migrated reload")
 var target=f.make_enemy("upgraded93",g.player+Vector2(50,0),0);f.enemies=[target];f.locked_aim=Vector2.RIGHT;f.resolve()
 check(target.hp==34,"Tempered weapon bonus reaches actual enemy damage")
 f.guard=false;f.dodge=0;f.hurt_wait=0;s.combat.health=100;f.receive(target)
 check(is_equal_approx(s.combat.health,89.28),"Tempered armor reduces an actual incoming hit")
 for energy in [100.0,0.0]:
  var reserve=HoldWorkEnergy.data(s);reserve.energy=energy;reserve.awake=8000
  HoldEquipment93.equip(g,"legacy_axe");HoldEquipment93.equip(g,"legacy_clothes");s.combat.health=100;f.cancel_actions();f.hurt_wait=0;f.dodge_wait=0;f.aim=Vector2.RIGHT;f.locked_aim=Vector2.RIGHT
  var enemy=f.make_enemy("energy93/"+str(energy),g.player+Vector2(50,0),0);f.enemies=[enemy]
  f.strike();check(f.swing>0,"Attack starts at energy "+str(energy));f.resolve()
  check(enemy.hp==40,"Axe damage unchanged at energy "+str(energy))
  f.swing=0;f.guard=true;f.parry=0;f.receive(enemy)
  check(s.combat.health==100,"Shield blocks at energy "+str(energy))
  f.hurt_wait=0;f.parry=.1;f.receive(enemy)
  check(g.combat.riposte>0 and s.combat.health==100,"Parry works at energy "+str(energy))
  f.parry=0;f.hurt_wait=0;f.evade();f.receive(enemy)
  check(f.dodge>0 and s.combat.health==100,"Dodge avoids damage at energy "+str(energy))
  f.dodge=0;f.swing=0;f.bash_wait=0;f.shield_bash()
  check(f.bash_left>0,"Shield shove starts at energy "+str(energy))
  f.cancel_actions();s.combat.weapon="gun";s.add("ammo",2);var ammo=s.count("ammo");f.strike();f.locked_aim=Vector2.RIGHT;f.resolve()
  check(s.count("ammo")==ammo-1,"Carbine uses ammunition at energy "+str(energy))
  g.handworks.data().carry=[{"kind":"stone","units":1}];g.walking_pose=true;g.handworks.update(1)
  check(reserve.energy==energy,"Attacks, defenses and carried loads do not spend combat energy "+str(energy))
  g.handworks.data().carry.clear();g.walking_pose=false
 print("EQUIPMENT93: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
