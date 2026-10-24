extends "res://tests/support/game_fixture.gd"
class PickBoard extends Node2D:
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("233237"))
  for sculpt in 7:
   for view in 3:
    for frame in 4:
     var p=HoldAppearance.defaults();p.sculpt=sculpt
     var at=Vector2(44+(view*4+frame)*77,65+sculpt*72)
     HoldWholeFrames.paint(self,at,p,[Vector2.RIGHT,Vector2.DOWN,Vector2.UP][view],false,0,.9,Vector2.ZERO,"pick",[.05,.3,.6,.9][frame])
func walk(action:String,n:int):
 Input.action_press(action);await frames(n);Input.action_release(action);await frames(1)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.state.camp_stage=3
 for gender in 2:
  for sculpt in 7:
   var profile=g.state.appearance.duplicate(true);profile.gender=gender;profile.sculpt=sculpt
   for direction in [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN]:
    for phase in [.05,.3,.6,.9]:
     var pose=HoldWholeFrames.descriptor(profile,direction,false,0,"pick",phase)
     check(pose.action=="pick" and (pose.sheet.ends_with("-motion") if gender==0 and phase in [.05,.9] else not pose.sheet.ends_with("-motion")),"Pick identity through pose "+str([gender,sculpt,direction,phase]))
 var board_layer=CanvasLayer.new();board_layer.layer=150;root.add_child(board_layer)
 var board=PickBoard.new();board_layer.add_child(board);board.queue_redraw()
 await snap("pick-sequence")
 board_layer.queue_free();await process_frame
 HoldFirstShift.data(g).kit=true
 var inventory=g.state.inventory.duplicate(true)
 # Actual feet movement through both sides of the wider mouth, plus pier collision.
 for area in ["trail","claim"]:
  var mouth=HoldMineEntrance.position(area)
  for x in [-52,0,52]:
   g.surface.enter(area,mouth+Vector2(x,65));settle();g.surface.roads.portal_cooldown=0
   check(g.surface.walkable(mouth+Vector2(x,10)),area+" visible mouth is walkable at "+str(x))
   await walk("up",32)
   check(g.zone=="mine",area+" off-center approach crosses into the mine at "+str(x))
  g.surface.enter(area,mouth+Vector2(-98,65));settle();g.surface.roads.portal_cooldown=0
  await walk("up",32)
  check(g.zone!="mine" and g.player.y>mouth.y+10,area+" solid pier blocks feet")
  at(mouth+Vector2(0,95));await snap("entrance-"+area)
 check(g.state.inventory==inventory,"Crossings preserve carried inventory")
 # Primary cast uses authored motives. An approach is required for every transfer.
 g.surface.enter("hearthward");settle()
 g.surface.enter("room:commission",Vector2(620,465));settle()
 HoldConversation.start(g,"ivar");check(g.panel_id=="conversation","Ivar's existing conversation remains accessible")
 button("How have you been?");await snap("ivar-personality")
 var d=HoldPeople.records(g.state).ivar
 check(d.persona.trait==HoldPeople.PRINCIPALS.ivar.trait and d.bond==1,"Ivar receives authored personality and one conversation credit")
 HoldPeople.chat(g,"ivar");check(d.bond==1,"Repeated talk does not farm familiarity")
 button("What do you enjoy?");check(d.known,"Preferences are discovered through conversation")
 var liked=d.persona.like;var disliked=d.persona.dislike;g.state.add(liked,2)
 var before=g.state.count(liked);HoldPeople.gift(g,"ivar",liked)
 check(g.state.count(liked)==before-1 and d.bond==4,"Liked gift consumes exactly one actual pack item and improves bond")
 HoldPeople.gift(g,"ivar",liked);check(g.state.count(liked)==before-1 and d.bond==4,"Daily gift limit rejects another transfer")
 var material=d.persona.work;g.state.add(material,2);before=g.state.count(material);var money=g.state.money
 check(HoldPeople.help(g,"ivar"),"Local work favor completes with materials")
 check(g.state.count(material)==before-2 and g.state.money==money+2*int(HoldData.ITEMS[material].price) and d.bond==6,"Favor consumes materials, pays stated amount, and records familiarity")
 check(not HoldPeople.help(g,"ivar"),"Completed daily favor cannot be repeated")
 g.state.elapsed+=600;g.state.add(disliked,1);HoldPeople.gift(g,"ivar",disliked)
 check(d.bond==5 and d.last.begins_with("Disliked"),"Disliked gift has its own saved reaction")
 check(HoldPeople.chat(g,"ivar")==d.persona.close,"Familiarity unlocks personal dialogue")
 var saved=d.duplicate(true);g.save_game();g.close_panel();g.start_game(true);settle()
 check(HoldPeople.records(g.state).ivar==saved,"Personality, preferences, bond, limits and memory survive save/reload")
 var after_reload=HoldPeople.records(g.state).ivar
 g.surface.enter("trail",Vector2(700,690));settle();before=g.state.count(liked)
 HoldPeople.gift(g,"ivar",liked);check(g.state.count(liked)==before and not HoldPeople.help(g,"ivar"),"Remote gifts and work are rejected")
 # A supporting resident retains the rendered identity and acquires stable traits.
 var person=g.surface.roads.people("trail")[0];at(person.p+Vector2(0,22));HoldConversation.start(g,person.interaction)
 var id=person.interaction;var p=HoldPeople.records(g.state)[id].duplicate(true)
 check(g.state.npc(id).name==person.name and g.state.npc(id).sculpt==person.profile.sculpt,"Road resident keeps actual name and physical appearance in portrait")
 button("How have you been?");button("What do you enjoy?");await snap("neighbor-personality")
 g.state.add(p.persona.like,1);button("Give a gift from my pack");await snap("gift-picker")
 g.close_panel();HoldPeople.meet(g,id)
 check(HoldPeople.records(g.state)[id].persona==p.persona,"Repeated meetings never reroll supporting personality")
 var known=HoldPeople.records(g.state)[id].duplicate(true);g.save_game();g.start_game(true);settle()
 check(HoldPeople.records(g.state)[id]==known and g.state.npc(id).name==person.name,"Supporting acquaintance persists independently of renderer caches")
 # A household resident can be met in the actual current room, without teleporting.
 var routine=g.surface.world.routines;routine.ensure();var resident=routine.sample(routine.plans[0],g.state.elapsed)
 g.surface.enter(resident.area,resident.p+Vector2(0,22));settle();HoldConversation.start(g,resident.interaction)
 check(g.panel_id=="conversation" and HoldPeople.records(g.state).has(resident.interaction),"Scheduled household resident can become a persistent acquaintance")
 g.open_panel("roster");await snap("people-notebook")
 check(g.panel.get_rect().end.y<=g.get_viewport_rect().size.y,"Acquaintance notebook fits the viewport")
 # Migration is additive: a save without people starts with no fabricated history.
 var backup=g.state.surface.people.duplicate(true);g.state.surface.erase("people")
 check(HoldPeople.records(g.state).is_empty(),"Legacy saves receive an empty acquaintance registry")
 g.state.surface.people=backup
 print("PEOPLE82: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
