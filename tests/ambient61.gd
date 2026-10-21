extends "res://tests/support/game_fixture.gd"
func image_now()->Image:
 g.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 return root.get_texture().get_image()
func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://ambient61"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 # A legacy stored name must normalize at the same accessor used by dialogue,
 # portraits, story captions and the resident roster, without changing identity.
 var orla=g.state.npc("orla").duplicate(true)
 orla.family_name="Brassbraid";orla.name="Orla Brassbraid";g.state.npc_appearances.orla=orla
 var pack=g.state.inventory.duplicate(true);var appearance=g.state.appearance.duplicate(true)
 g.save_game();g.start_game(true);settle()
 check(g.state.npc("orla").family_name=="Copperkettle" and g.state.npc("hedrik").family_name=="Copperkettle","Existing saves use the Copperkettle family name for both spouses")
 check(g.state.npc("orla").cast_id=="orla" and g.state.npc("orla").sculpt==orla.sculpt and g.state.npc("orla").hair_color==orla.hair_color,"Orla retains her cast identity, sculpt and palette")
 check(g.state.inventory==pack and g.state.appearance==appearance,"Name update preserves pack and player appearance on reload")
 for ward in HoldWorldZones.WARDS:
  g.surface.enter(ward);settle()
  var moved={};var keys={}
  for step in 80:
   var people=g.surface.world.people(3.1+step*.1)
   for c in people:
    if not moved.has(c.index):moved[c.index]=[];keys[c.index]={}
    if c.walking:
     moved[c.index].append(c.p)
     var a=HoldWholeFrames.descriptor(c.profile,c.aim,true,c.gait,"town_walk",0)
     keys[c.index][a.index]=true
  for i in 6:check(moved[i].size()>4 and keys[i].size()>=3,ward+" citizen "+str(i)+" travels with at least three distinct painted walk keys")
  check(not g.surface.walkable(Vector2(970,635)) and g.surface.walkable(Vector2(1080,680)),ward+" fountain basin blocks feet while surrounding paving stays walkable")
 g.surface.enter("hearthward",Vector2(1090,700));settle();g.camera=Vector2(490,350)
 # Native rendered captures with fixed residents/player: only water animates.
 g.clock=0;var still=await image_now();still.save_png(output+"/fountain-0.png")
 g.clock=.31;var water=await image_now();water.save_png(output+"/fountain-1.png")
 check(still.get_data()!=water.get_data(),"Native fountain rendering changes with the game clock")
 var frozen=await image_now();check(water.get_data()==frozen.get_data(),"Fountain stays still when its game clock is paused")
 for id in ["home","tavern","forge"]:
  g.surface.enter("room:"+id);settle()
  if id=="forge":at(Vector2(800,450)) # The expanded hall's hearths are north of its entry camera.
  g.camera=g.surface.camera_target();g.clock=0
  var a=await image_now();a.save_png(output+"/"+id+"-0.png")
  g.clock=.28;var b=await image_now();b.save_png(output+"/"+id+"-1.png")
  check(a.get_data()!=b.get_data(),"Native "+id+" hearth has painted fire movement and glow")
 g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 g.player=Vector2(650,860);g.state.add("wood",2);g.state.add("stone",12);g.surface.placing="hearth"
 check(g.surface.place(Vector2(640,800)),"Player constructs a real hearth through the existing furnishing system")
 g.clock=0;g.camera=g.surface.camera_target();var built_a=await image_now()
 g.clock=.28;var built_b=await image_now();built_b.save_png(output+"/built-hearth.png")
 check(built_a.get_data()!=built_b.get_data(),"Player-built hearth uses the same painted animation as town hearths")
 g.save_game();g.start_game(true);settle()
 check(g.state.surface.decor.any(func(d):return d.kind=="hearth" and int(d.x)==640),"Constructed hearth persists through reload")
 check(HoldFurnishings.ITEMS.hearth.cost=={"wood":2,"stone":12} and HoldFurnishings.footprint("hearth",Vector2(650,800))==Rect2(618,772,64,28),"Player hearth keeps the shared construction cost and physical footprint")
 # The escort must wait while frames load, then visibly cycle both actors.
 g.opening_scene=HoldArrivalEscort.start(g);var scene=g.opening_scene;scene.set_process(false)
 scene.age=1;scene.advance();var p=g.player;var guide=scene.guide;var travel=scene.travel
 check(HoldFolk.warming(),"Escort queues the next area's actor frames")
 scene.tick(.5);check(g.player==p and scene.guide==guide and scene.travel==travel,"Escort cannot move unseen behind character warm-up")
 settle();var player_keys={};var guide_keys={}
 for i in 60:
  scene.tick(1.0/60)
  var a=HoldWholeFrames.descriptor(g.state.appearance,g.surface.direction,g.walking_pose,g.gait_clock,"",0)
  var b=HoldWholeFrames.descriptor(g.state.npc("ivar"),scene.guide_direction,scene.ivar_walking,scene.guide_gait,"town_walk",0)
  player_keys[a.index]=true;guide_keys[b.index]=true
 check(player_keys.size()>=4 and guide_keys.size()>=4,"Player and Ivar both cycle complete walk frames during the real escort")
 await snap("escort");scene.finish();await process_frame;settle()
 # Record native sequences at 20 fps for inspection, using the same draw paths.
 for part in ["fountain","hearth","street"]:
  g.surface.enter("room:home" if part=="hearth" else "hearthward",Vector2(1090,700) if part!="hearth" else Vector2(510,440));settle()
  g.camera=g.surface.camera_target() if part=="hearth" else Vector2(490,350)
  for frame in 40:
   g.clock=float(frame)/20
   if part=="street":g.state.elapsed=4.1+float(frame)/20
   var img=await image_now();img.save_png(output+"/"+part+"-%03d.png"%frame)
 print("AMBIENT61: ",passed," passed / ",failed," failed; native sequences complete")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;await process_frame;quit(1 if failed else 0)
