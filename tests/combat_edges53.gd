extends "res://tests/playability53.gd"
func run():
 output="res://docs/testing/playability-0.53.0/combat";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4
 HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world;w.data.depth=1
 var c=Vector2i(20,20)
 for y in range(16,25):
  for x in range(16,26):w.set_cell(Vector2i(x,y),0)
 g.player=Deepworks.center(c);g.fight.spawn();g.combat.armed=true;g.fight.enemies.clear()
 var e=g.fight.make_enemy("fixture53",g.player+Vector2(70,0),0);g.fight.enemies.append(e)
 g.fight.aim=Vector2.LEFT;g.fight.guard=true;g.fight.receive(e)
 check(g.state.combat.health==84,"Guarding backwards does not block an incoming blow")
 g.fight.hurt_wait=0;g.fight.aim=Vector2.RIGHT;g.fight.receive(e)
 check(g.state.combat.health==84,"Facing guard blocks damage without stamina drain")
 g.fight.guard=false;g.fight.hurt_wait=0;g.state.combat.armor="mail";g.fight.receive(e)
 check(g.state.combat.health==72,"Existing mail reduction applies to top-down attacks")
 g.fight.hurt_wait=0;g.fight.dodge=.1;g.fight.receive(e);check(g.state.combat.health==72,"Dodge invulnerability prevents contact damage");g.fight.dodge=0
 await aim_at(e.p-Vector2(0,25));await mouse(MOUSE_BUTTON_RIGHT,true);g.fight.parry=0;await mouse(MOUSE_BUTTON_RIGHT,false);await mouse(MOUSE_BUTTON_RIGHT,true)
 check(g.fight.parry==0 and g.fight.parry_wait>0,"Rapid guard taps cannot reopen the parry window continuously")
 await mouse(MOUSE_BUTTON_RIGHT,false);g.fight.guard=false
 g.state.combat.weapon="gun";g.state.combat.owned.append("gun");g.state.add("ammo",5);g.fight.locked_aim=Vector2.RIGHT;var ammo=g.state.count("ammo")
 var wall=c+Vector2i.RIGHT;w.set_cell(wall,2);e.p=g.player+Vector2(120,0);g.fight.resolve()
 check(e.hp==e.max and g.state.count("ammo")==ammo-1,"Stone stops a carbine shot while consuming one cartridge")
 w.set_cell(wall,0);g.fight.resolve();check(e.hp==e.max-34,"Clear top-down firing line hits its target")
 await snap("01-carbine")
 g.state.inventory.ammo=0;g.fight.swing=0;g.fight.strike();check(g.fight.swing==0,"Empty gun gives feedback without a false attack")
 g.state.combat.weapon="hammer";g.state.combat.owned.append("hammer");e.hp=84;e.max=84;e.kind=1;e.p=g.player+Vector2(70,0);g.fight.resolve()
 check(e.hp==42 and e.state=="stun","Warhammer defeats shell resistance and staggers")
 g.fight.swing=.45;g.fight.locked_aim=Vector2.RIGHT;await snap("02-hammer-contact")
 g.fight.swing=0;g.state.combat.weapon="axe";g.fight.aim=Vector2.RIGHT;e.state="windup";e.dir=Vector2.LEFT;e.time=.4;await snap("03-telegraph")
 var timer=e.time;g.open_panel("inventory");g.fight.update(1)
 check(e.time==timer,"Menus pause enemy windups instead of hiding lethal attacks");g.close_panel()
 print("COMBAT53: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
