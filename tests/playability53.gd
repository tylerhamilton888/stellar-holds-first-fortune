extends "res://tests/input_world52.gd"
func aim_at(p:Vector2):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target()
 root.warp_mouse((p-g.camera)*root.get_visible_rect().size/Vector2(960,540));await frames(2)
func mouse(button_index:int,pressed:bool):
 var e=InputEventMouseButton.new();e.button_index=button_index;e.pressed=pressed;Input.parse_input_event(e);await frames(3)
func cart(kind:String)->Dictionary:
 var f={"id":"test53-"+kind,"kind":kind,"area":g.handworks.context(),"x":g.player.x,"y":g.player.y,"raw":[{"id":5301,"kind":"stone","units":4,"source":"test"}],"cargo":{"coal":7},"job":{},"hitched":true}
 g.handworks.data().facilities.append(f);return f
func run():
 output="res://docs/testing/playability-0.53.0/loops";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var q=HoldOnboarding.ensure(g.state);q.escort_pending=false;q.settle_required=true;q.fresh=true
 g.surface.enter("room:home",Vector2(290,450));settle();g.state.combat.health=40;key(KEY_E);await frames(20)
 check(g.surface.rest_time>0 and g.state.combat.health==40,"Rest has a brief visible interval before healing")
 Input.action_press("right");await frames(1);Input.action_release("right")
 check(g.surface.rest_time==0 and not q.get("settle_bed",false) and g.state.combat.health==40,"Movement cancels rest without false credit")
 at(Vector2(290,450));key(KEY_E);await frames(70)
 check(g.state.combat.health==100 and q.get("settle_bed",false),"Completed rest heals, saves and credits bed")
 check(HoldOnboarding.primary(g.state).contains("Check your chest"),"Tutorial names only the unfinished next step")
 await snap("01-rested")
 at(Vector2(650,430));key(KEY_E);settle()
 check(q.get("settled",false),"Checking personal chest completes settling without spending supplies")
 g.state.opening=4;q.fresh=false
 g.surface.enter("hearthward",Vector2(1270,960));settle();var f=cart("cart");key(KEY_E);settle()
 check(g.surface.area=="trail" and g.handworks.attached()==f,"Hitched cart uses the real gate without swallowing E")
 check(f.raw.size()==1 and f.cargo.coal==7,"Portal preserves original raw IDs and processed cargo")
 at(Vector2(950,340));f.x=g.player.x;f.y=g.player.y;key(KEY_E);settle()
 check(g.zone=="mine" and g.handworks.attached()==f,"Same cart reaches the mine through the actual trail door")
 var w=g.deep.world;var c=Deepworks.ENTRY+Vector2i.DOWN*2;w.set_cell(c,0);g.player=Deepworks.center(c);f.x=g.player.x;f.y=g.player.y;w.carve_stairs(c)
 key(KEY_E);settle();check(w.depth()==1 and g.handworks.attached()==f,"Cart descends matching stairs with cargo")
 g.deep.use_stairs(true);settle();check(w.depth()==0 and g.handworks.attached()==f,"Cart returns up the same stair")
 var ladder=c+Vector2i.RIGHT*3;w.set_cell(ladder,0);g.state.add("wood",2);w.carve_stairs(ladder,"ladder");g.player=Deepworks.center(ladder);f.x=g.player.x;f.y=g.player.y
 key(KEY_E);check(w.depth()==0 and f.hitched,"Ladder rejects hitched cart without losing it")
 g.player=Deepworks.center(Deepworks.ENTRY);f.x=g.player.x;f.y=g.player.y;key(KEY_E);settle()
 check(g.surface.area=="trail" and g.handworks.attached()==f,"Loaded cart returns naturally to the trail")
 await snap("02-cart-return")
 g.save_game();g.start_game(true);settle();f=g.handworks.attached()
 check(not f.is_empty() and f.raw[0].id==5301 and f.cargo.coal==7,"Reload preserves cart hitch, location and exact contents")
 f.hitched=false;g.surface.enter("hearthward",Vector2(1450,840));settle();var wagon=cart("wagon");key(KEY_E);settle()
 check(g.room_id=="commission" and not wagon.hitched and wagon.area=="surface:hearthward:0","Wagon parks with cargo outside narrow interior")
 at(Vector2(480,590));key(KEY_E);settle();key(KEY_C)
 check(g.handworks.attached()==wagon and wagon.raw.size()==1,"Returned player can retake parked wagon handles")
 wagon.hitched=false
 q=HoldOnboarding.ensure(g.state);q.accepted.training=true;q.done.route=true;g.surface.enter("room:practice");settle();g.enter_room("training");settle();await frames(2)
 check(g.room_id=="training" and g.surface.active() and g.fight.enemies.size()==1,"Borin practice opens in the integrated top-down room")
 var before=g.player;Input.action_press("up");Input.action_press("left");await frames(20);Input.action_release("up");Input.action_release("left")
 check(g.player.x<before.x and g.player.y<before.y and g.player.distance_to(before)<63,"Combat movement is normalized and free of platform gravity")
 var e=g.fight.enemies[0];g.player=Vector2(500,450);e.p=Vector2(570,450);e.home=e.p;e.state="idle"
 await aim_at(e.p-Vector2(0,25));await mouse(MOUSE_BUTTON_LEFT,true);await frames(95);await mouse(MOUSE_BUTTON_LEFT,false)
 check(int(q.facts.get("practice_hit",0))>=3,"Held attack lands repeated facing blows without click spam")
 g.fight.swing=0;g.fight.buffered=0;e.state="windup";e.dir=Vector2.LEFT;e.time=.12;e.p=Vector2(570,450);g.player=Vector2(500,450)
 await aim_at(e.p-Vector2(0,25));await mouse(MOUSE_BUTTON_RIGHT,true);await frames(10)
 check(int(q.facts.get("practice_guard",0))>0 and e.state=="stun","Facing a timed strike parries and staggers Borin")
 await snap("03-parry");await mouse(MOUSE_BUTTON_RIGHT,false)
 g.fight.hurt_wait=0;e.state="windup";e.time=.15;e.dir=Vector2.LEFT;e.p=Vector2(570,450);g.player=Vector2(500,450)
 Input.action_press("down");key(KEY_Q);await frames(16);Input.action_release("down")
 check(int(q.facts.get("practice_dodge",0))>0,"Directional dodge evades a real telegraphed strike")
 check(g.state.combat.health==100,"Practice never injures the player")
 await snap("04-practice")
 e.state="idle";g.player=Vector2(500,450);e.p=Vector2(570,450);g.fight.locked_aim=Vector2.LEFT;var hits=int(q.facts.practice_hit);g.fight.resolve()
 check(int(q.facts.practice_hit)==hits,"Melee does not hit enemies behind the swing")
 g.player=Vector2(250,350);g.fight.dodge_wait=0;Input.action_press("up");key(KEY_Q);await frames(16);Input.action_release("up")
 check(g.surface.walkable(g.player),"Dodge respects room collision")
 at(Vector2(660,570));key(KEY_E)
 check(g.panel_id=="lesson" and HoldOnboarding.progress(g.state,"training").ready,"Practice bench opens completed lesson report")
 var gold=g.state.money;button("Report");settle()
 check(HoldOnboarding.combat_ready(g.state) and g.state.money==gold+20,"Reporting training unlocks combat and pays once")
 at(Vector2(480,590));key(KEY_E);settle()
 check(g.room_id=="practice" and not g.combat.armed,"Practice door returns to the connected hall with tools ready")
 g.surface.enter("room:forge");settle();g.enter_room("training");settle();at(Vector2(480,590));key(KEY_E);settle()
 check(g.room_id=="forge","Practice entered from the forge returns through its own doorway")
 g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle();w=g.deep.world;g.player=Deepworks.center(c);key(KEY_E);settle();await frames(2)
 check(w.depth()==1 and g.fight.enemies.size()>0,"Lower geology contains deterministic persistent encounters")
 if g.zone=="mine" and w.depth()==1 and not g.fight.enemies.is_empty():
  e=g.fight.enemies[0];g.player=e.p+Vector2(0,60);g.combat.armed=true;g.fight.locked_aim=Vector2.UP;g.fight.resolve();var hp=e.hp;var id=e.id
  check(hp<e.max,"Top-down mine combat deals actual directional damage")
  g.save_game();g.start_game(true);settle();await frames(2);e=g.fight.enemies[0]
  print("WOUND ",id," -> ",e.id," hp ",hp," -> ",e.hp," saved ",g.state.combat.wounds)
  check(e.id==id and is_equal_approx(e.hp,hp),"Enemy wounds and location persist through reload")
  g.player=e.p+Vector2(0,60);g.combat.armed=true;g.fight.locked_aim=Vector2.UP;var scrap=g.state.count("scrap")
  for i in 5:g.fight.resolve()
  check(g.state.combat.cleared.has(id) and g.state.count("scrap")==scrap+3,"Defeat awards salvage exactly once")
  await snap("05-cleared-cavern");g.save_game();g.start_game(true);settle();await frames(2)
  var respawn=false
  for foe in g.fight.enemies:if foe.id==id:respawn=true
  check(not respawn and g.state.count("scrap")==scrap+3,"Cleared encounter remains cleared after reload")
 print("PLAYABILITY53: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
