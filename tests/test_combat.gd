extends SceneTree
var failed=0
var checks=0
func check(ok:bool,s:String):
 checks+=1
 if not ok:failed+=1;push_error(s)
func enemy(p:Vector2,id:String="test")->Dictionary:
 return {"id":id,"p":p,"home":p,"kind":0,"hp":64.0,"max":64.0,"state":"idle","timer":0.0,"face":-1,"walk":false,"flash":0.0}
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.close_panel();game.set_process(false);game.zone="mine";game.transition_left=0;game.transition_shade.visible=false
 var c=game.combat
 for seed_value in [12,27419,81271,452]:
  game.geo.generate(seed_value);c.map_key="";c.spawn()
  check(c.enemies.size()>0 and c.enemies.size()<=3,"Sparse encounters exist for seed "+str(seed_value))
  for e in c.enemies:check(e.p.x>=784,"Starter gallery remains safe")
 # Clear a controlled test chamber; physical walls and collision still apply.
 for y in range(40,65):
  for x in range(100,210):game.geo.set_cell(Vector2i(x,y),0 if y<56 else 2)
 game.player=Vector2(900,392);game.face=1;c.armed=true;c.attack_direction=Vector2.RIGHT
 var e=enemy(Vector2(955,392));c.enemies=[e];c.resolve_attack();check(e.hp==40,"Axe hits front target")
 e.hp=64;e.state="windup";e.timer=.6;c.resolve_attack();check(e.state=="windup","Ordinary axe hits do not permanently interrupt windups")
 e.state="idle"
 e.hp=64;e.p=Vector2(845,392);c.resolve_attack();check(e.hp==64,"Axe cannot hit behind player")
 e.p=Vector2(955,392)
 for y in range(40,56):game.geo.set_cell(Vector2i(132,y),2)
 c.resolve_attack();check(e.hp==64,"Wall blocks melee")
 for y in range(40,56):game.geo.set_cell(Vector2i(132,y),0)
 c.guard=true;c.parry_left=.18;c.invulnerable=0;e.p=Vector2(955,392)
 check(c.receive_hit(e,20)=="parry" and game.state.combat.health==100 and c.riposte>0,"Timed parry prevents damage and opens counter")
 e.hp=64;c.resolve_attack();check(e.hp<40,"Riposte increases damage")
 c.invulnerable=0;c.parry_left=0;c.guard=true;game.state.combat.health=100;c.receive_hit(e,20)
 check(game.state.combat.health>96,"Shield block greatly reduces damage")
 c.invulnerable=0;game.state.combat.health=100;e.p=Vector2(845,392);c.receive_hit(e,20)
 check(game.state.combat.health==80,"Guard does not protect rear")
 c.invulnerable=0;c.guard=false;game.state.combat.health=100;game.state.combat.armor="rune";c.receive_hit(e,20)
 check(is_equal_approx(game.state.combat.health,89),"Equipped armor reduces incoming damage")
 c.invulnerable=0;c.dodge_left=.2;game.state.combat.health=100
 check(c.receive_hit(e,20)=="dodge" and game.state.combat.health==100,"Dodge grants brief invulnerability")
 c.dodge_left=0;c.dodge_cooldown=0;c.attack_left=0;c.dodge();var cooldown=c.dodge_cooldown;c.dodge();check(c.dodge_cooldown==cooldown,"Dodge cannot be spam-reset")
 c.dodge_left=0;c.invulnerable=0;c.guard=false;game.state.combat.health=1;c.receive_hit(e,100)
 check(game.player.x==150 and game.state.combat.health==65,"Defeat rescues rather than deleting inventory")
 game.player=Vector2(900,392);game.face=1;game.state.combat.weapon="gun";game.state.inventory.ammo=3;c.attack_direction=Vector2.RIGHT
 e=enemy(Vector2(1100,392));c.enemies=[e];c.resolve_attack()
 check(e.hp==30 and game.state.count("ammo")==2,"Carbine hits at range and consumes ammunition")
 e.hp=64
 for y in range(40,56):game.geo.set_cell(Vector2i(140,y),2)
 c.resolve_attack();check(e.hp==64,"Bullets stop at rock")
 for y in range(40,56):game.geo.set_cell(Vector2i(140,y),0)
 game.state.inventory.ammo=0;c.attack_left=0;c.attack();check(c.attack_left==0,"Empty gun cannot fire")
 game.state.combat.weapon="hammer";e=enemy(Vector2(955,392),"permanent");e.kind=1;c.enemies=[e];c.resolve_attack();check(e.hp==22,"Hammer bypasses shell resistance")
 c.hurt_enemy(e,100);check(game.state.count("shell")==2 and game.state.combat.cleared.has("permanent"),"Enemy yields useful resources and permanent clearance")
 game.state.combat.owned=["axe","hammer","clothes","rune"];game.state.combat.weapon="hammer";game.state.combat.armor="rune";game.state.tracked_npc="ivar";game.save_game()
 var loaded=HoldState.new();loaded.load_world(Geology.new())
 check(loaded.combat.armor=="rune" and loaded.combat.weapon=="hammer" and loaded.combat.cleared.has("permanent"),"Equipment and cleared encounters survive reload")
 check(loaded.tracked_npc=="ivar","Tracked person survives reload")
 var hp=game.state.combat.health;game.open_panel("inventory");c.update(2);check(game.state.combat.health==hp,"Menus pause combat")
 check(game.npc_where("ivar").p.x==1205,"Foreman tracking targets his office")
 var first=game.npc_where("visitor_0").p;game.clock=10;check(game.npc_where("visitor_0").p!=first,"Visitor tracking follows movement")
 var p=game.state.appearance.duplicate();var plain=game.sprite_atlas.key_for(p);p.armor=2;check(plain!=game.sprite_atlas.key_for(p),"Equipped armor gets distinct sprite atlas")
 game.state.add("scrap",3);game.state.add("coal",1);check(game.state.craft("scrap_iron"),"Salvage enters crafting economy")
 game.close_panel();game.player=Vector2(900,392);game.face=1;game.state.combat.weapon="axe";c.reset_actions();c.invulnerable=0;c.parry_cooldown=0;c.dodge_left=0;c.map_key=str(game.geo.seed_value)+"/"+game.state.active_site
 e=enemy(Vector2(955,392));e.state="windup";e.timer=.01;c.enemies=[e]
 var event=InputEventMouseButton.new();event.button_index=MOUSE_BUTTON_RIGHT;event.pressed=true;Input.parse_input_event(event)
 Input.flush_buffered_events()
 c.update(.02)
 check(e.state=="stun" and c.riposte>0,"Live attack state preserves parry stagger")
 event=InputEventMouseButton.new();event.button_index=MOUSE_BUTTON_RIGHT;event.pressed=false;Input.parse_input_event(event)
 game.close_panel();game.room_id="forge";game.state.opening=2;game.state.tech.metallurgy=true;game.state.combat.owned=["axe","clothes"]
 for item in ["iron","copper","parts","wood","crystal"]:game.state.inventory[item]=40
 game.open_panel("equipment")
 for node in game.panel_body.find_children("*","Button",true,false):
  if node is Button and node.text=="Forge & equip Piston warhammer":node.pressed.emit();break
 check("hammer" in game.state.combat.owned and game.state.combat.weapon=="hammer","Equipment menu actually forges and equips the chosen weapon")
 game.state.combat.weapon="axe";c.armed=true;c.reset_actions();game.velocity=Vector2(190,0)
 check(c.profile().shield_pose,"Moving axe uses complete equipment rig")
 c.guard=true;check(not c.profile().shield_guard,"Guarded movement retains walking legs")
 game.velocity=Vector2.ZERO;var guarding=game.sprite_atlas.key_for(c.profile())
 check(c.profile().shield_guard,"Stationary guard selects complete guard poses")
 c.guard=false;check(guarding!=game.sprite_atlas.key_for(c.profile()),"Guard poses have distinct cached atlas")
 game.state.combat.weapon="hammer";check(not c.profile().shield_pose,"Hammer remains on its own rig")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame
 print("COMBAT: %d checks, %d failures" % [checks,failed]);quit(1 if failed else 0)
