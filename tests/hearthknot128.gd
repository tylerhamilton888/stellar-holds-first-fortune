extends "res://tests/support/game_fixture.gd"
const ID="road_folk:1"
func visit():
 g.surface.enter("room:wayfarer");settle()
 for actor in g.surface.roads.people("room:wayfarer"):
  if actor.interaction==ID:at(actor.p+Vector2(0,22));break
 HoldConversation.start(g,ID)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 HoldFirstVisit99.begin(g);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.state.appearance.gender=0
 g.surface.enter(HoldFrontier103.room(g.state,"forge"));settle();at(Vector2(480,500))
 g.state.inventory.wood=1;g.state.inventory.copper=0
 check(not HoldFrontier103.transact(g,"craft","hearthknot") and g.state.count("wood")==1,"Missing copper leaves timber untouched")
 g.state.inventory.copper=1
 g.player+=Vector2(300,0)
 check(not HoldFrontier103.transact(g,"craft","hearthknot"),"Remote crafting is rejected")
 at(Vector2(480,500));g.open_panel("frontier103");button("Craft a Hearthknot")
 check(g.state.count("wood")==0 and g.state.count("copper")==0 and g.state.count("hearthknot")==0,"Real forge queues the token and pays materials once")
 g.save_game();g.start_game(true);settle()
 check(g.state.queue.size()==1 and g.state.queue[0].id=="hearthknot","Crafting queue survives reload")
 g.state.tick(5)
 check(g.state.count("hearthknot")==1 and g.state.queue.is_empty(),"Normal production produces one Hearthknot")
 g.pack_selection="hearthknot";g.open_panel("inventory");await snap("crafted-hearthknot")
 var inv=g.state.inventory.duplicate(true);var crowns=g.state.money
 check(not g.state.trade("hearthknot",true) and not g.state.trade("hearthknot",false) and g.state.inventory==inv and g.state.money==crowns,"Personal token cannot be bought or sold")
 visit();var person=HoldPeople.records(g.state)[ID]
 var bond=int(person.bond);var gift_day=int(person.gift_day)
 check(HoldPeople.gift(g,ID,"hearthknot").contains("invitation") and g.state.count("hearthknot")==1 and person.bond==bond and person.gift_day==gift_day,"Ordinary gift callback preserves token, friendship and daily gift allowance")
 g.talk_topic="gift";g.refresh_panel()
 check(not g.panel.find_children("*","Button",true,false).any(func(b):return b.text.contains("Hearthknot")),"Ordinary gift list cannot spend a courtship token")
 check(not HoldCourtship101.begin(g,ID) and g.state.count("hearthknot")==1,"Token cannot bypass personal story")
 HoldCourtship101.record(g.state,ID).quest=3;HoldCourtship101.record(g.state,ID).keepsake=HoldCourtship101.ARCS[ID].keepsake;person.bond=4
 check(not HoldCourtship101.begin(g,ID) and g.state.count("hearthknot")==1,"Token cannot bypass familiarity")
 person.bond=5;g.state.inventory.hearthknot=0
 button("Back to our conversation");button("A personal word")
 check(g.panel.find_children("*","Button",true,false).any(func(b):return b.text.contains("Offer a Hearthknot") and b.disabled),"Missing token visibly disables the invitation")
 check(not HoldCourtship101.begin(g,ID) and HoldCourtship101.partner(g.state)=="","Missing token blocks a stale invitation callback")
 await process_frame;g.menu_scroll.scroll_vertical=int(g.menu_scroll.get_v_scroll_bar().max_value)
 await snap("invitation-needs-token")
 g.state.add("hearthknot",2);g.state.appearance.gender=1
 check(not HoldCourtship101.begin(g,ID) and g.state.count("hearthknot")==2,"Ineligible match keeps the token")
 g.state.appearance.gender=0;g.player+=Vector2(250,0)
 check(not HoldCourtship101.begin(g,ID) and g.state.count("hearthknot")==2,"Remote offer keeps the token")
 visit();button("A personal word")
 await process_frame;g.menu_scroll.scroll_vertical=int(g.menu_scroll.get_v_scroll_bar().max_value)
 await snap("invitation-ready")
 button("Offer a Hearthknot")
 check(HoldCourtship101.partner(g.state)==ID and g.state.count("hearthknot")==1 and g.talk_line.ends_with(HoldCourtship101.ARCS[ID].yes) and g.talk_line.contains("accepts your Hearthknot"),"Explicit offer begins mutually accepted courtship and spends exactly one token")
 check(not HoldCourtship101.begin(g,ID) and g.state.count("hearthknot")==1,"Repeated offer spends nothing")
 await snap("invitation-accepted")
 check(g.menu_scroll.scroll_vertical==0,"Accepted offer returns to the top so the reciprocal response is visible")
 g.state.inventory.hearthknot=0;g.save_game();g.start_game(true);settle()
 check(HoldCourtship101.partner(g.state)==ID,"Existing courtship reloads without a token")
 visit();HoldCalendar.advance(g.state,1440)
 check(HoldCourtship101.share_date(g,ID,0,0),"Existing relationship continues without another token")
 HoldCourtship101.record(g.state,ID).stage=2;g.save_game();g.start_game(true);settle()
 check(HoldCourtship101.record(g.state,ID).stage==2,"Existing betrothal reloads without a token")
 visit();check(HoldCourtship101.end(g,ID),"Breakup remains available")
 HoldCalendar.advance(g.state,1440)
 check(not HoldCourtship101.begin(g,ID),"Renewed courtship needs a new token")
 print("HEARTHKNOT128: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
