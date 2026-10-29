class_name HoldDevTesting
extends RefCounted
# Temporary, opt-in developer fixtures. No production progression rules are bypassed.
const SAVE="user://dev_testing85.json"
const MODES={
 "workplace":{"name":"The old cutters bay","detail":"Break through the fallen supply passage, inspect the old hearth, repair it with ordinary furnishings and bring warmth and work back. Separate save."},
 "expedition":{"name":"First expedition","detail":"Meet Ivar, mine and process fresh iron and coal, return for handcart materials, then follow the crystal lead. Separate test save."},
 "exploration":{"name":"Mine views & depth routes","detail":"Two connected floors, a mineral face and workbench. F6 changes view; mouse looks, Alt frees cursor, F7 controls; Z plans a route."},
 "calendar":{"name":"Calendar & celebrations","detail":"Daylight, night, seasons and all four feasts. Jump to a host or bed."},
 "combat":{"name":"Combat arena","detail":"All weapons and armor. Choose enemies, heal, or inspect hitboxes."},
 "building":{"name":"Construction & decorating","detail":"Owned land, cottage, plans and supplies. Build, decorate and reload."},
 "work":{"name":"Mining & workstations","detail":"Mineral wall, benches, racks, cart and raw loads. Dig, haul and process."},
 "hearth":{"name":"Farming, fishing & cooking","detail":"Prepared gardens and ingredients. Jump to water or the kitchen."}}
var g
var badge:Button
var choosing=false
func _init(game):
 g=game
 badge=g.button(g.ui,"DEV TEST · F9",func():g.open_panel("dev_testing"))
 badge.position=Vector2(744,45);badge.size=Vector2(194,30);badge.visible=false
func active()->bool:return HoldBuild.DEV_TESTING and g.playing and g.state.test_session
func mode()->String:return str(g.state.surface.get("dev_testing85",{}).get("mode",""))
func update_badge():
 badge.visible=active() and g.panel_id==""
 if active():
  g.objectives.visible=false
  g.footer.text="DEV TEST · "+str(MODES.get(mode(),{"name":"Free exploration"}).name)+" · F9 controls / reset · separate test save"
func leave():
 g.state.test_session=false;badge.visible=false;choosing=false
func saved_mode()->String:
 if not FileAccess.file_exists(SAVE):return ""
 var d=JSON.parse_string(FileAccess.get_file_as_string(SAVE))
 if not d is Dictionary or not d.get("dev_testing",false) or d.get("version",0)!=1 or d.get("cells",[]).size()!=Geology.W*Geology.H:return ""
 return str(d.get("surface",{}).get("dev_testing85",{}).get("mode",""))
func panel():
 fit_panel.call_deferred()
 if not HoldBuild.DEV_TESTING:g.label(g.panel_body,"Developer testing is disabled in this build.",17);return
 if g.playing and not active():g.label(g.panel_body,"Return to the title screen to launch a separate test session.",17);return
 g.label(g.panel_body,"Standalone test world. Starting a preset replaces only the last test.",16)
 if active() and not choosing:
  g.label(g.panel_body,"Current test: "+MODES.get(mode(),{"name":"Free exploration"}).name,18)
  var row=GridContainer.new();row.columns=2;g.panel_body.add_child(row)
  g.small_button(row,"Resume test",g.close_panel)
  g.small_button(row,"Heal & restock",func():restock();g.save_game();g.close_panel())
  g.small_button(row,"Reset this preset",func():start(mode()))
  g.small_button(row,"Save & reload test",func():g.save_game();resume())
  if mode()=="calendar":
   var times=g.row(g.panel_body)
   for hour in [6,12,19,23]:g.small_button(times,"%02d:00" % hour,func():HoldCalendar.data(g.state).minute=hour*60.0;g.save_game();g.close_panel())
   var feasts=GridContainer.new();feasts.columns=2;g.panel_body.add_child(feasts)
   for index in 4:g.small_button(feasts,HoldCalendar.HOLIDAYS[index].name,func():HoldCalendar.fixture(g,index))
   var places=GridContainer.new();places.columns=2;g.panel_body.add_child(places)
   g.small_button(places,"Next day",func():HoldCalendar.pass_time(g,1440);g.save_game();g.close_panel())
   g.small_button(places,"Visit feast counter",func():go("room:wayfarer",Vector2(400,525)))
   g.small_button(places,"Visit a bed",func():go("room:home",HoldFurnishings.bedside(Vector2(290,420))))
   g.small_button(places,"Return to lantern trail",func():go("trail",Vector2(610,650)))
   g.small_button(places,"Open calendar",func():g.open_panel("calendar"))
  elif mode()=="combat":
   g.label(g.panel_body,"Fresh encounters reset arena enemies and health. Combat also restarts on reload.",15)
   var waves=GridContainer.new();waves.columns=2;g.panel_body.add_child(waves)
   for id in [0,1,2,3]:g.small_button(waves,"Fight "+HoldEnemyRoster.spec(id).name,func():wave([id]))
   g.small_button(waves,"Fight goblin + orc",func():wave([0,2]))
   for lesson in ["Flanking","Stagger","Parry","Wall impact"]:
    g.small_button(waves,lesson+" drill",func():drill(lesson))
   g.small_button(waves,"Hitboxes: "+("ON" if g.fight.show_hitboxes else "OFF"),func():g.fight.show_hitboxes=not g.fight.show_hitboxes;g.refresh_panel())
   g.button(g.panel_body,"Weapons & armor · B",func():g.open_panel("equipment"))
  elif mode()=="building":
   g.button(g.panel_body,"Building book · all prepared designs",func():g.open_panel("architecture"))
   g.button(g.panel_body,"Go to eastern building grounds",func():go("claim",Vector2(2450,850)))
   g.button(g.panel_body,"Open construction plans",func():g.open_panel("house_build"))
   g.button(g.panel_body,"Open furniture & home options",func():g.open_panel("homestead"))
   g.button(g.panel_body,"Go to cottage interior",func():go("home:old_delving",Vector2(480,550)))
   g.button(g.panel_body,"Return to building plot",func():go("claim",Vector2(920,500)))
  elif mode()=="exploration":
   g.button(g.panel_body,"Open depth map · Z",func():g.depth_nav.open_map())
   g.button(g.panel_body,"Change overhead / exploration · F6",func():g.close_panel();g.depth_nav.toggle_view())
   g.button(g.panel_body,"Add a goblin for combat",func():
    g.fight.enemies.clear();var e=g.fight.make_enemy("dev94/goblin",g.player+Vector2(100,0),0)
    if not g.deep.world.solid(e.p):g.fight.enemies.append(e);g.combat.armed=true
    g.close_panel())
  elif mode()=="work":g.button(g.panel_body,"Open workstation & hauling plans",func():g.open_panel("handworks"))
  elif mode()=="hearth":
   g.button(g.panel_body,"Go to garden beds",func():go("claim",Vector2(530,925)))
   g.button(g.panel_body,"Go to riverbank",func():go("claim",HoldHearth.SPOTS.claim.bank))
   g.button(g.panel_body,"Go to home kitchen",func():go("home:old_delving",Vector2(440,375)))
   g.button(g.panel_body,"Ripen planted beds",func():
    for b in g.fieldwork.data().beds:
     if b.planted:b.watered=true;b.at=g.state.elapsed-1000
    g.save_game();g.close_panel())
  g.small_button(g.panel_body,"Save test & return to title",func():g.save_game();g.show_title())
  g.small_button(g.panel_body,"Choose another preset",func():choosing=true;g.refresh_panel())
  return
 else:
  if MODES.has(saved_mode()):g.button(g.panel_body,"Resume last test · "+MODES[saved_mode()].name,resume)
 if active():g.small_button(g.panel_body,"Back to test controls",func():choosing=false;g.refresh_panel())
 var presets=GridContainer.new();presets.columns=2;presets.add_theme_constant_override("h_separation",10);presets.add_theme_constant_override("v_separation",10);g.panel_body.add_child(presets)
 for id in MODES:
  var card=g.section(presets,MODES[id].name)
  card.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
  card.get_parent().custom_minimum_size.x=390
  g.label(card,MODES[id].detail,15)
  g.small_button(card,"Start "+MODES[id].name,func():start(id))
func fit_panel():
 # Wrapped labels need one layout pass before restoring the intended viewport bounds.
 for i in 2:
  await g.get_tree().process_frame
  if g.panel_id!="dev_testing":return
  g.panel.position=Vector2(40,24);g.panel.size=Vector2(880,492)
func restock():
 if not active():return
 HoldWorkEnergy.rest(g.state)
 g.state.money=10000;g.state.combat.health=100;g.state.rescue_debt=0
 for item in HoldData.ITEMS:g.state.inventory[item]=maxi(g.state.count(item),2000 if mode()=="building" else 200)
 g.state.combat.owned=["axe","hammer","gun","clothes","mail","rune"]
 for id in HoldData.RESEARCH:g.state.tech[id]=true
 g.state.tech.hearthkeeping=true;g.state.steel=true
 g.handworks.data().skills.miner=maxi(12,int(g.handworks.data().skills.miner))
 g.fight.hurt_wait=0
func start(id:String):
 if not HoldBuild.DEV_TESTING or not MODES.has(id) or (g.playing and not active()):return
 if g.playing:g.save_game()
 choosing=false;g.fight.show_hitboxes=false
 var skip=g.skip_arrival;g.skip_arrival=true
 g.start_game(false,g.state.appearance.duplicate(true),true);g.skip_arrival=skip
 g.state.surface.dev_testing85={"mode":id,"wave":[0]}
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.tracked_npc=""
 var q=HoldOnboarding.ensure(g.state)
 q.fresh=false;q.stage=7;q.arrival_seen=true;q.escort_pending=false;q.settle_required=false;q.combat=true
 if id not in ["expedition","workplace"]:restock()
 if id=="workplace":
  g.state.add("wood",4);g.state.add("stone",8);g.state.add("iron",3);g.state.add("coal",2)
  g.change_zone("mine");g.player=Deepworks.center(Vector2i(8,11));g.deep.world.survey(g.player)
 elif id=="expedition":
  g.state.add("wood",4);g.state.add("stone",8)
  g.surface.enter("room:commission")
 elif id=="exploration":exploration()
 elif id in ["combat","work"]:
  arena(2 if id=="combat" else 0)
  if id=="combat":wave([0]);return
  workshops()
 else:
  go("claim",Vector2(920,500))
  if id=="hearth":gardens()
  if id=="calendar":HoldCalendar.fixture(g,0);go("trail",Vector2(610,650))
 finish()
func resume():
 if not HoldBuild.DEV_TESTING or not MODES.has(saved_mode()) or (g.playing and not active()):return
 g.start_game(true,{},true)
 if mode()=="combat" and g.zone=="mine":wave(g.state.surface.dev_testing85.get("wave",[0]));return
 finish()
func go(area:String,position:Vector2):
 if not active():return
 g.surface.enter(area,position);finish()
func arena(depth:int):
 g.change_zone("mine");g.deep.world.data.depth=depth
 var w=g.deep.world;var layer=w.layer()
 layer.features=[];layer.fixtures={};layer.damage={};layer.encounters=[];layer.encounter_companions={};layer.encounter_roster={}
 for y in range(14,30):
  for x in range(14,33):w.set_cell(Vector2i(x,y),2 if x in [14,32] or y in [14,29] else 0)
 w.rebuild_landmarks();g.player=Deepworks.center(Vector2i(20,20));g.fight.reset();g.fight.spawn()
func wave(kinds:Array):
 if not active() or mode()!="combat":return
 g.state.surface.dev_testing85.wave=kinds.duplicate()
 arena(2);g.state.combat.health=100;g.state.combat.cleared.clear();g.state.combat.wounds.clear()
 g.combat.armed=true;g.fight.aim=Vector2.RIGHT;g.fight.locked_aim=Vector2.RIGHT
 for i in kinds.size():
  var e=g.fight.make_enemy("dev85/"+str(i),g.player+Vector2(170+i*95,i*75),int(kinds[i]));e.dir=Vector2.LEFT;g.fight.enemies.append(e)
 finish()
func drill(lesson:String):
 if not active() or mode()!="combat":return
 wave([0,2] if lesson=="Flanking" else [3] if lesson=="Parry" else [2])
 g.state.combat.weapon="axe";g.fight.cancel_actions()
 var tip=""
 match lesson:
  "Flanking":tip="Keep both foes in view. The goblin circles while the orc commits."
  "Stagger":tip="Land repeated axe hits before turquoise pressure fades. Switch to hammer with B to compare."
  "Parry":tip="Tap RMB just before the troll connects, then counter with LMB. Space evades."
  "Wall impact":
   var w=g.deep.world
   for y in range(17,25):w.set_cell(Vector2i(24,y),2)
   g.player=Deepworks.center(Vector2i(22,20))
   g.fight.enemies[0].p=Deepworks.center(Vector2i(23,20))
   tip="Face the orc against the wall. Hold RMB and click LMB to shove; compare a hammer impact."
 finish();g.notify(tip);g.notice_time=12
func workshops():
 var w=g.deep.world
 for x in range(17,30):w.set_cell(Vector2i(x,14),[2,3,4,5,6][(x-17)%5])
 for entry in [["breaker",Vector2(820,900)],["saw",Vector2(1020,900)],["stone_pile",Vector2(820,1020)],["timber_pile",Vector2(1020,1020)],["cart",Vector2(660,1020)]]:
  g.player=entry[1]+Vector2(0,60);g.handworks.build(entry[0],entry[1])
 g.handworks.spawn("stone",Vector2(700,840),3,"dev85","iron_ore")
 g.handworks.spawn("log",Vector2(1080,840),3,"dev85")
 g.player=Deepworks.center(Vector2i(20,20))
func gardens():
 g.fieldwork.craft_kit()
 for i in 4:
  var p=Vector2(530+i*120,870);g.player=p+Vector2(-65,-18)
  if g.fieldwork.build(p):
   var b=g.fieldwork.data().beds.back();b.crop=HoldHearth.CROPS.keys()[i];b.prepared=i>0;b.planted=i>1;b.watered=i==3;b.at=g.state.elapsed-1000
 g.player=Vector2(530,925)
func finish():
 g.close_panel();g.transition_left=0;g.transition_shade.visible=false;g.velocity=Vector2.ZERO
 g.camera=g.deep.camera_target() if g.zone=="mine" else g.surface.camera_target()
 g.notice_time=0;g.save_game();g.update_hud();g.queue_redraw()

func exploration():
 if not active():return
 arena(0)
 var w=g.deep.world
 for z in [0,1]:
  var layer=w.layer(z);layer.features=[];layer.fixtures={};layer.damage={};layer.encounters=[];layer.encounter_companions={};layer.encounter_roster={};layer.seen.clear()
  for y in range(16,27):
   for x in range(17,29):
    w.set_cell(Vector2i(x,y),2 if x in [17,28] or y in [16,26] else 0,z)
    layer.seen[Deepworks.key(Vector2i(x,y))]=true
 w.data.depth=0;w.carve_stairs(Vector2i(25,20))
 w.set_cell(Vector2i(23,23),3,0);w.layer(0).fixtures["21,20"]="lamp";w.layer(1).fixtures["25,21"]="lamp"
 g.player=Deepworks.center(Vector2i(20,20));g.handworks.build("breaker",Deepworks.center(Vector2i(20,19)))
 g.handworks.spawn("stone",Deepworks.center(Vector2i(19,22)),4,"dev94","iron_ore")
 w.rebuild_landmarks();g.player=Deepworks.center(Vector2i(21,24));g.fight.reset();g.depth_nav.reset();g.depth_nav.explore.yaw=0
 g.depth_nav.route_to(Vector2i(22,19),1)
