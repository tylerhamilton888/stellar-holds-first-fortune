extends "res://tests/support/game_fixture.gd"
class AtlasBoard extends Node2D:
 var camera=Vector2.ZERO
 var kind=0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("172c35"))
  for r in 3:
   for c in 6:
    var e={"kind":kind,"p":Vector2(78+c*153,148+r*170),"dir":[Vector2(1,1),Vector2.RIGHT,Vector2(1,-1)][r],"hp":0 if c==5 else 100,"state":"windup" if c==3 else "recover" if c==4 else "idle","time":HoldEnemyRoster.spec(kind).recover,"walk":c in [1,2],"gait":.2 if c==2 else 0.0,"flash":0.0,"dead_time":2.0}
    HoldEnemyRoster.draw(self,e)
    draw_circle(e.p,2,Color("66aa99"))
    HoldArt.text(self,e.p+Vector2(-45,20),["Ready","Left contact","Right contact","Windup","Impact","Defeated"][c],12)
func capture_board(kind:int):
 g.hotbar.set_process(false);g.hotbar.hide()
 var board=AtlasBoard.new();board.kind=kind;board.z_index=100;root.add_child(board)
 for i in 3:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/atlas-"+str(kind)+".png")
 board.queue_free();g.hotbar.set_process(true);g.hotbar.show();await process_frame
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 g.change_zone("mine");settle();var w=g.deep.world
 var natural_trolls=0
 for depth in [1,2,3,4]:
  w.data.depth=depth;g.fight.key="";g.fight.spawn()
  if depth==1:check(g.fight.enemies.any(func(e):return e.kind==2),"Natural Copperfold has an orc encounter")
  natural_trolls+=g.fight.enemies.filter(func(e):return e.kind==3).size()
 check(natural_trolls>0,"Untouched generated deep caverns contain trolls")
 w.data.depth=2
 for y in range(12,40):
  for x in range(12,65):w.set_cell(Vector2i(x,y),0)
 w.layer().erase("encounters");w.layer().erase("encounter_roster");w.layer().erase("encounter_companions")
 g.player=Deepworks.center(Vector2i(20,20));g.fight.key="";g.fight.spawn();var f=g.fight
 check(f.enemies.any(func(e):return e.kind==3),"Spacious deeper chambers actually spawn a troll")
 check(f.enemies.any(func(e):return e.kind==2) and f.enemies.any(func(e):return e.kind==0),"New encounters include orcs and goblins")
 var roster=w.layer().encounter_roster.duplicate(true);var members=[]
 for e in f.enemies:members.append([e.id,e.kind])
 f.key="";f.spawn();var revisited=[]
 for e in f.enemies:revisited.append([e.id,e.kind])
 check(members==revisited,"Saved encounter roles remain stable on revisit")
 w.layer().erase("encounter_roster");f.key="";f.spawn()
 check(f.enemies.all(func(e):return e.kind in [0,1]),"Legacy records retain goblin and beetle identities")
 w.layer().encounter_roster=roster
 for kind in [0,2,3]:
  var spec=HoldEnemyRoster.spec(kind);var e=f.make_enemy("roster84/"+str(kind),g.player+Vector2(70,0),kind)
  check(e.hp==spec.hp,"Distinct health: "+spec.name)
  for r in 3:
   for frame in 6:
    var rect:Rect2=HoldEnemyRoster.RECTS[kind][r][frame]
    check(rect.position.x>=0 and rect.position.y>=0 and rect.end.x<=1536 and rect.end.y<=1024,"Atlas crop in bounds %s/%s/%s" % [kind,r,frame])
  await capture_board(kind)
 g.combat.armed=true;g.state.combat.weapon="axe";g.state.combat.armor="clothes";f.aim=Vector2.RIGHT;f.locked_aim=Vector2.RIGHT
 var orc=f.make_enemy("orc84",g.player+Vector2(70,0),2);f.enemies=[orc];f.resolve()
 check(orc.hp==94,"Orc iron armor reduces axe damage")
 g.state.combat.weapon="hammer";orc.p=g.player+Vector2(70,0);f.resolve()
 check(orc.hp==52 and orc.state=="stun","Hammer bypasses orc armor and staggers")
 var troll=f.make_enemy("troll84",g.player+Vector2(110,0),3);f.enemies=[troll];g.state.combat.weapon="axe";f.guard=true;f.hurt_wait=0;f.parry=0
 var hp=g.state.combat.health;f.receive(troll)
 check(is_equal_approx(g.state.combat.health,hp-8.5),"Shield reduces but cannot erase a troll crushing blow")
 f.hurt_wait=0;f.parry=.1;hp=g.state.combat.health;f.receive(troll)
 check(g.state.combat.health==hp and g.combat.riposte>0,"Timed parry safely answers the troll")
 check(troll.time==.5 and troll.stagger_wait==3.0,"Troll stagger is shorter with longer resistance")
 f.parry=0;f.guard=false;f.dodge=.1;f.hurt_wait=0;f.receive(troll)
 check(g.state.combat.health==hp,"Dodge avoids heavy damage")
 f.dodge=0;g.combat.riposte=0;f.hurt_wait=0;f.hit_stop=0;g.combat.armed=false
 var origin=g.player;troll.p=origin-Vector2.from_angle(.8)*120;troll.home=troll.p;troll.dir=Vector2.RIGHT;troll.state="windup";troll.time=.01;f.update(.02)
 check(g.state.combat.health==hp,"Troll slam misses outside its drawn narrow arc")
 troll.p=origin-Vector2.from_angle(.6)*120;troll.state="windup";troll.time=.01;f.update(.02)
 check(g.state.combat.health==hp-34,"Troll reach and damage apply inside its telegraph")
 g.state.combat.health=100;g.combat.armed=true;g.state.combat.weapon="gun";g.state.add("ammo",3);f.locked_aim=Vector2.RIGHT
 orc=f.make_enemy("alert84",origin+Vector2(370,0),2);f.enemies=[orc];f.resolve();var before=orc.p;f.update(.1)
 check(orc.alert>0 and orc.p.distance_to(origin)<before.distance_to(origin),"Ranged hits alert enemies beyond normal sight range")
 g.state.combat.weapon="hammer";troll=f.make_enemy("loot84",origin+Vector2(70,0),3);troll.hp=1;f.enemies=[troll];f.locked_aim=Vector2.RIGHT
 var iron=g.state.count("iron_ore");var crystal=g.state.count("crystal");var xp=HoldDisciplines.xp(g.state,"warrior");f.resolve();f.resolve()
 check(g.state.count("iron_ore")==iron+4 and g.state.count("crystal")==crystal+1 and HoldDisciplines.xp(g.state,"warrior")==xp+1,"Troll grants its material salvage and mastery once")
 check(troll.hp==0 and HoldEnemyRoster.frame(troll)==5 and f.objects().size()==1,"Defeat uses the fallen pose before fading")
 f.update(2.5);check(f.objects().is_empty(),"Defeated body fades without blocking or respawning")
 # Exact circle/sector boundaries, not approximate center-only aim checks.
 check(HoldSkirmish.sector_hits(Vector2.ZERO,Vector2.RIGHT,76,.9,Vector2(87,0),12),"Weapon catches a body overlapping its outer edge")
 check(not HoldSkirmish.sector_hits(Vector2.ZERO,Vector2.RIGHT,76,.9,Vector2(89,0),12),"Body wholly beyond reach is safe")
 check(HoldSkirmish.sector_hits(Vector2.ZERO,Vector2.RIGHT,76,.9,Vector2.from_angle(1.0)*70,10),"Body clipping sector side receives contact")
 check(not HoldSkirmish.sector_hits(Vector2.ZERO,Vector2.RIGHT,76,.9,Vector2.from_angle(1.1)*70,10),"Body wholly outside sector side is safe")
 check(not HoldSkirmish.sector_hits(Vector2.ZERO,Vector2.RIGHT,76,.9,Vector2(-30,0),10),"Attack cannot hit behind its committed direction")
 g.player=origin;g.state.combat.weapon="axe";f.hit_stop=0;f.hurt_wait=0;f.cancel_actions();f.aim=Vector2.RIGHT
 orc=f.make_enemy("contact84",origin+Vector2(70,0),2);f.enemies=[orc];f.strike();f.aim=Vector2.LEFT
 g.camera=g.player-Vector2(0,25)-g.get_global_mouse_position()+Vector2(-100,0)
 f.update(.01)
 check(f.locked_aim==Vector2.LEFT and orc.hp==112,"Early preparation follows mouse without dealing damage")
 f.swing=.48*.72;f.locked_aim=Vector2.RIGHT
 f.update(.48*.23)
 check(orc.hp==112 and f.locked_aim==Vector2.RIGHT,"Committed anticipation no longer follows mouse")
 f.update(.48*.02)
 check(orc.hp==94 and f.hit_stop>0,"Damage and hit-stop begin on authored contact key")
 check(HoldWholeFrames.contact_frame(1-f.swing/.48)==2,"Hit-stop holds the actual contact drawing")
 var frozen_swing=f.swing;var frozen_pos=orc.p;var frozen_wait=f.hurt_wait
 f.buffered=.16;f.update(.01)
 check(f.swing==frozen_swing and orc.p==frozen_pos and f.hurt_wait==frozen_wait and f.movement(Vector2.RIGHT)==Vector2.ZERO,"Impact pause freezes both combat actors and action timers")
 check(f.buffered==.16,"Impact pause preserves queued attack input")
 f.update(.1)
 check(f.hit_stop==0 and f.movement(Vector2.RIGHT).length()>0 and orc.hp==94,"Movement resumes promptly and contact cannot damage twice")
 check(is_equal_approx(frozen_pos.distance_to(origin+Vector2(70,0)),8),"Light hit delivers bounded recoil")
 f.cancel_actions();g.state.combat.weapon="hammer";orc.p=origin+Vector2(70,0);orc.stagger_wait=0;f.locked_aim=Vector2.RIGHT;f.resolve()
 check(is_equal_approx(orc.p.distance_to(origin+Vector2(70,0)),22) and f.hit_stop==.065 and orc.state=="stun","Hammer has stronger recoil, longer impact and stagger")
 troll=f.make_enemy("resist84",origin+Vector2(70,0),3);f.enemies=[troll];f.resolve()
 check(absf(troll.p.distance_to(origin+Vector2(70,0))-6.6)<.01,"Heavy troll resists displacement")
 var wall=Vector2i(21,20);w.set_cell(wall,2)
 var pushed=f.push_body(origin,Vector2.RIGHT,100,10)
 check(pushed.distance_to(origin)<100 and f.body_open(pushed,10),"Swept recoil stops at solid terrain without tunnelling")
 w.set_cell(wall,0);g.state.combat.weapon="gun";f.locked_aim=Vector2.RIGHT
 check(is_inf(f.shot_entry(origin+Vector2(100,20),12)) and not is_inf(f.shot_entry(origin+Vector2(100,14),12)),"Carbine uses explicit projectile width plus body radius")
 f.cancel_actions();g.state.combat.weapon="axe";f.show_hitboxes=true;f.enemies=[orc,troll];orc.p=origin+Vector2(70,0);troll.p=origin+Vector2(170,40);troll.state="windup";troll.dir=Vector2.LEFT;troll.time=.8;f.aim=Vector2.RIGHT
 await snap("04-hitboxes")
 f.impact(orc.p,.065,Color("ffe0a0"),true);f.swing=.48*(1-HoldSkirmish.CONTACT_PHASE);f.struck=true
 await snap("05-contact-feedback")
 f.show_hitboxes=false;f.cancel_actions()
 var goblin=f.make_enemy("view-goblin",origin+Vector2(-110,15),0);orc=f.make_enemy("view-orc",origin+Vector2(95,-30),2);troll=f.make_enemy("view-troll",origin+Vector2(180,30),3)
 f.enemies=[goblin,orc,troll];f.aim=Vector2.RIGHT
 for e in f.enemies:e.dir=(origin-e.p).normalized()
 g.notice_time=0
 await snap("01-roster-scale")
 troll.state="windup";troll.time=.8;await snap("02-heavy-warning")
 troll.state="recover";troll.time=1.5;await snap("03-heavy-impact")
 # Record actual game frames through a complete distance-driven walk cycle.
 troll.state="idle";goblin.walk=true;orc.walk=true;troll.walk=true
 for frame in 8:
  for e in f.enemies:e.gait=float(frame)/20.0
  await snap("walk-%02d" % frame)
 g.save_game();g.start_game(true);settle()
 var restored=g.deep.world.data.layers[2].get("encounter_roster",{});var same=restored.size()==roster.size()
 for id in roster:
  same=same and restored.has(id) and int(restored.get(id,{}).get("lead",-1))==int(roster[id].lead) and int(restored.get(id,{}).get("companion",-1))==int(roster[id].companion)
 check(same,"Enemy roles survive JSON numeric conversion on real save reload")
 check(g.state.combat.cleared.has("loot84"),"Defeated troll stays cleared after real reload")
 for texture in [HoldEnemyRoster.GOBLIN,HoldEnemyRoster.ORC,HoldEnemyRoster.TROLL]:
  check(texture.get_image().get_pixel(256,50).a<.01,"Atlas background is actually transparent")
 print("ENEMIES84: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
