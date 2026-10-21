extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface
 for gender in 2:
  for sculpt in 7:
   var profile=HoldAppearance.defaults();profile.gender=gender;profile.sculpt=sculpt
   var player=HoldWholeFrames.descriptor(profile,Vector2.RIGHT,true,.14,"",0)
   var citizen=HoldWholeFrames.descriptor(profile,Vector2.RIGHT,true,.14,"town_walk",0)
   check(player.sheet.ends_with("-core") and citizen.sheet.ends_with("-town") and player.frame==citizen.frame,"NPC passing pose is isolated from player art: %s/%s"%[gender,sculpt])
 for ward in HoldWorldZones.WARDS:
  s.enter(ward);settle()
  var solid=true
  for b in s.world.buildings():
   var art=HoldWorldZones.building_rect(b)
   for fraction in [.3,.5,.75]:
    if s.walkable(Vector2(b.p.x,lerpf(art.position.y,b.p.y-25,fraction))):solid=false
  check(solid,ward+" painted wall body blocks feet, including upper facade")
  var samples=[]
  for t in range(100):
   var a=s.world.people(float(t))[0];var b=s.world.people(float(t)+.6)[0]
   if a.walking and b.walking and a.aim==b.aim and a.p.distance_to(b.p)>30:
    samples=[a,a,b,b];break
  check(samples[0].walking and samples[0].p!=samples[3].p,"Resident moves through the real street")
  check(is_equal_approx(samples[3].gait-samples[0].gait,HoldDrawnLocomotion.time_for_distance(samples[0].p.distance_to(samples[3].p))),"Resident advances the player's distance-based gait clock")
 s.enter("room:home");settle()
 at(Vector2(290,450));check(s.nearest().get("action","")!="rest","Foot of bed is not a use anchor")
 at(Vector2(342,390));key(KEY_E);await frames(120)
 check(g.player.distance_to(HoldFurnishings.bedside(Vector2(290,420)))<1 and g.state.surface.facts.get("rest",false),"Rest approaches the visible bedside and saves")
 await snap("bedside")
 var pack=g.state.inventory.duplicate(true);var stage=HoldOnboarding.stage(g.state)
 at(Vector2(735,547));key(KEY_E)
 check(g.panel_id=="letter","E at the writing desk opens the letter")
 await snap("letter-draft")
 check(not HoldLetters.sent(g.state),"Reading a draft does not silently send it")
 button("Seal for the homeward post")
 check(HoldLetters.sent(g.state) and not HoldLetters.post(g),"Letter is recorded once")
 g.close_panel();g.save_game();g.start_game(true);settle()
 check(HoldLetters.sent(g.state) and g.state.surface.facts.letter_text.contains(g.state.appearance.first_name),"Written letter and identity persist on reload")
 check(g.state.inventory==pack and HoldOnboarding.stage(g.state)==stage,"Personal correspondence preserves inventory and main progression")
 s.enter("hearthward");settle();at(HoldWorldZones.ROYAL+Vector2(0,30));key(KEY_E)
 check(not s.stair_trip.is_empty() and s.area=="hearthward","Stair use starts a climb instead of immediate map teleport")
 s.tick_stair(.5);await snap("on-stair")
 check(g.player.y<HoldWorldZones.ROYAL.y and g.walking_pose,"Climb visibly moves up the drawn flight")
 settle();check(s.area=="crownward" and g.player==HoldWorldZones.ROYAL+Vector2(0,30),"Climb lands at the matching XY on the next Z")
 key(KEY_E);settle();check(s.area=="hearthward","Same staircase returns to its paired floor")
 at(HoldWorldZones.ROYAL-Vector2(0,40));Input.action_press("up");s.move(1);Input.action_release("up")
 check(g.player.y>HoldWorldZones.ROYAL.y-100,"Stair top cannot be walked through into unrelated paving")
 at(Vector2(960,980));await snap("stacked-gallery")
 # Native side-by-side sequence: actual unarmed resident and unchanged equipped player.
 var c=s.world.people(4)[0];g.state.appearance=c.profile.duplicate(true);at(c.p+Vector2(0,70));g.hotbar.select(0,false)
 for i in 12:
  g.state.elapsed=4+i*.10;c=s.world.people(g.state.elapsed)[0];g.player=c.p+Vector2(0,70);s.direction=c.aim;g.walking_pose=c.walking;g.gait_clock=c.gait
  await snap("parity-%02d"%i)
 print("CONTINUITY66: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
