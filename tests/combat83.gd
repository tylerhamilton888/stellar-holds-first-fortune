extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world;w.data.depth=1
 for y in range(14,30):
  for x in range(14,30):w.set_cell(Vector2i(x,y),0)
 g.player=Deepworks.center(Vector2i(20,20));g.fight.spawn();g.combat.armed=true
 var f=g.fight
 check(w.layer().has("encounter_companions"),"New encounter records persist companion positions")
 check(f.enemies.size()>=2 and f.enemies.size()<=4,"New deep chambers contain bounded pairs")
 var records=w.layer().encounters.duplicate(true);var companions=w.layer().encounter_companions.duplicate(true)
 var saved_ids=[]
 for enemy in f.enemies:saved_ids.append(enemy.id)
 f.key="";f.spawn();var restored_ids=[]
 for enemy in f.enemies:restored_ids.append(enemy.id)
 check(saved_ids==restored_ids,"Encounter members retain stable IDs on revisit")
 w.layer().erase("encounter_companions");f.key="";f.spawn()
 check(f.enemies.size()==records.size(),"Legacy encounter arrays do not gain surprise companions")
 var old=f.enemies[0].id;g.state.combat.cleared[old]=true;f.key="";f.spawn()
 check(f.enemies.filter(func(e):return e.id==old).is_empty(),"Cleared legacy enemy stays absent")
 w.layer().encounter_companions=companions
 f.enemies.clear();g.state.combat.cleared.clear();g.state.hauling.erase("disciplines")
 var e=f.make_enemy("combat83/a",g.player+Vector2(70,0),0);f.enemies.append(e)
 f.aim=Vector2.LEFT;f.guard=true;f.receive(e)
 check(g.state.combat.health==84,"Rear attack bypasses shield")
 f.hurt_wait=0;f.aim=Vector2.RIGHT;f.receive(e)
 check(g.state.combat.health==84,"Facing axe shield fully blocks")
 g.state.combat.weapon="hammer";f.hurt_wait=0;f.receive(e)
 check(g.state.combat.health==78,"Hammer brace reduces damage without a shield")
 f.hurt_wait=0;f.parry=.1;f.receive(e)
 check(g.state.combat.health==78 and g.combat.riposte>0,"Timed hammer parry negates damage and opens counter")
 f.parry=0;f.guard=false;f.hurt_wait=0;f.dodge=.1;f.receive(e)
 check(g.state.combat.health==78,"Directional dodge avoids damage")
 f.dodge=0;f.dodge_wait=0;f.evade()
 check(is_equal_approx(f.dodge_wait,.72),"Live default dodge matches mastery description")
 f.dodge=0;f.dodge_wait=0;HoldDisciplines.award(g.state,"warrior",6);HoldDisciplines.learn(g.state,"sure_footing");f.evade()
 check(is_equal_approx(f.dodge_wait,.58),"Sure footing shortens the actual top-down dodge")
 f.dodge=0;g.combat.riposte=0;f.locked_aim=Vector2.RIGHT;e.hp=84;e.max=84;e.kind=1;e.stagger_wait=0
 f.resolve()
 check(e.hp==42 and e.state=="stun","Hammer bypasses shell and staggers")
 e.state="idle";e.hp=84;f.resolve()
 check(e.state=="idle","Repeated hammer contact cannot chain stun")
 g.state.combat.weapon="axe";e.hp=84;f.resolve()
 check(is_equal_approx(e.hp,64.8),"Shell resists axe damage")
 e.hp=1;var xp=HoldDisciplines.xp(g.state,"warrior");var scrap=g.state.count("shell");f.resolve();f.resolve()
 check(HoldDisciplines.xp(g.state,"warrior")==xp+1 and g.state.count("shell")==scrap+2,"Real kill awards mastery and salvage exactly once")
 # First-ever live defeat must not be counted both by migration and the kill event.
 g.state.hauling.erase("disciplines");g.state.combat.cleared.clear();e.hp=1;f.resolve()
 check(HoldDisciplines.xp(g.state,"warrior")==1,"First defeat initializes migration before awarding exactly one point")
 g.state.combat.weapon="gun";g.state.combat.owned.append("gun");g.state.combat.owned.append("hammer");g.state.add("ammo",5)
 var near=f.make_enemy("combat83/near",g.player+Vector2(100,0),0);var far=f.make_enemy("combat83/far",g.player+Vector2(180,0),0)
 f.enemies=[far,near];f.resolve()
 check(near.hp==30 and far.hp==64,"Carbine hits nearest target regardless of enemy list order")
 var wall=Vector2i(21,20);w.set_cell(wall,2);var ammo=g.state.count("ammo");f.resolve()
 check(near.hp==30 and g.state.count("ammo")==ammo-1,"Stone blocks a paid shot")
 w.set_cell(wall,0);g.state.inventory.ammo=0;f.swing=0;f.strike()
 check(f.swing==0,"Empty gun cannot start attack")
 near.state="windup";near.time=.5;near.dir=Vector2.LEFT
 check(not f.attack_slot(far),"Nearby enemy waits for committed attack")
 near.state="recover";check(not f.attack_slot(far),"Recovery leaves a readable opening before next attacker")
 near.state="idle";check(f.attack_slot(far),"Next enemy can attack after recovery")
 near.state="windup";near.time=.5;g.open_panel("inventory");f.update(1)
 check(near.time==.5,"Menu pauses enemy commitment");g.close_panel()
 # Exercise the actual update path at both sides of the displayed cone boundary.
 f.enemies=[near];f.swing=0;f.guard=false;g.combat.armed=false;f.hurt_wait=0
 var origin=g.player;near.p=origin-Vector2.from_angle(.95)*70;near.home=near.p;near.dir=Vector2.RIGHT;near.state="windup";near.time=.01
 var hp=g.state.combat.health;f.update(.02)
 check(g.state.combat.health==hp,"Outside amber cone is safe at actual impact")
 near.p=origin-Vector2.from_angle(.85)*70;near.state="windup";near.time=.01;f.update(.02)
 check(g.state.combat.health==hp-16,"Inside amber cone is hit at actual impact")
 f.enemies=[near,far];g.combat.armed=true;near.p=origin+Vector2(70,0);near.state="windup";near.time=.5
 g.notice_time=0
 g.state.combat.weapon="axe";f.aim=Vector2.RIGHT;f.guard=true;near.dir=Vector2.LEFT;far.p=g.player+Vector2(140,65);far.kind=1
 await snap("01-pair-shield")
 g.state.combat.weapon="hammer";f.guard=false;f.swing=.45;await snap("02-hammer")
 g.state.combat.weapon="gun";f.swing=0;await snap("03-carbine")
 f.swing=.4;f.buffered=.1;g.open_panel("equipment");button("Equip Piston")
 check(g.state.combat.weapon=="hammer" and f.swing==0 and f.buffered==0,"Actual equipment button cancels pending live strike")
 await snap("04-equipment")
 check(g.panel.get_global_rect().end.y<=g.get_viewport_rect().size.y,"Gear panel stays within viewport after switching")
 g.menu_scroll.scroll_vertical=10000;await snap("05-equipment-bottom")
 check(g.menu_scroll.scroll_vertical>0,"All weapon choices remain accessible by scrolling")
 g.close_panel()
 g.room_id="training";f.enemies=[near];near.hp=64;g.state.combat.weapon="axe";f.locked_aim=Vector2.RIGHT
 var practice_xp=HoldDisciplines.xp(g.state,"warrior");f.resolve()
 check(near.hp==64 and HoldDisciplines.xp(g.state,"warrior")==practice_xp,"Practice awards lesson credit without damage or farmable mastery")
 g.room_id=""
 var credit=HoldDisciplines.xp(g.state,"warrior");g.save_game();g.start_game(true);settle()
 check(HoldDisciplines.xp(g.state,"warrior")==credit and g.state.combat.cleared.has("combat83/a"),"Defeat and mastery survive real save reload")
 print("COMBAT83: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
