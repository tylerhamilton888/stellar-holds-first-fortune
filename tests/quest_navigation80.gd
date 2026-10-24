extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0]
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 var s=g.state
 HoldOnboarding.begin_fortune(s)
 var q=HoldOnboarding.ensure(s)
 q.stage=2;q.settled=true;q.met={}
 for id in ["borin","orla","hedrik"]:
  check(HoldOnboarding.primary_host(s)==id,"Introduction tracks next unmet resident")
  q.met[id]=true
 q.stage=4
 check(HoldOnboarding.primary_host(s)=="eirik","Royal summons tracks Eirik")
 q.stage=1;q.settled=false
 check(HoldOnboarding.primary_host(s)=="","Settling directs to room instead of NPC")
 check(HoldQuestMarkers.status(s,"ivar")=="","No false Ivar offer while settling")
 check(not HoldOnboarding.side_stories(s),"Side quests remain gated during arrival")
 g.open_panel("commission");await snap("arrival-journal")
 q.settled=true;q.stage=6;s.opening=2
 check(HoldOnboarding.accept(s,"timber"),"Available lesson can be accepted")
 q.facts.woodcut=6
 check(HoldOnboarding.progress(s,"timber").ready,"Completed work becomes ready to return")
 check(not HoldOnboarding.complete(s,"timber",false),"Remote reward collection rejected")
 check(HoldOnboarding.complete(s,"timber",true),"Local reward collection accepted")
 var ancestral=HoldAncestralClaim.data(s)
 ancestral.stage=4;ancestral.family=false;ancestral.archive=false
 check(HoldAncestralClaim.marker(s,"ivar")=="ready" and HoldAncestralClaim.marker(s,"eirik")=="ready","Investigation marks required contacts")
 ancestral.family=true;ancestral.archive=true
 check(HoldAncestralClaim.marker(s,"ivar")=="" and HoldAncestralClaim.marker(s,"eldric")=="ready","Investigation markers advance with evidence")
 ancestral.stage=7
 check(HoldAncestralClaim.marker(s,"eirik")=="","Finished appointment removes marker")
 var money=s.money
 check(not HoldOnboarding.complete(s,"timber",true) and s.money==money,"Reward cannot be collected twice")
 g.open_panel("guidance");check(g.menu_paused,"Quest browsing pauses play");await snap("quest-groups")
 g.open_panel("inventory");await snap("pack")
 g.open_panel("settings");await snap("settings")
 for id in ["commission","guidance","inventory","settings","road_order"]:
  g.open_panel(id)
  for i in 8:await process_frame
  check(g.panel.get_global_rect().end.y<=root.size.y,"Menu stays within viewport: "+id)
 print("QUEST_NAVIGATION80: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
