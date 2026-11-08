extends "res://tests/support/game_fixture.gd"
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 check(not HoldGreatClaim102.near(g),"Unentered fortunes gain no contribution access")
 HoldFirstVisit99.begin(g);settle();var s=g.state
 # JSON normalizes numeric types; compare saved values, not int/float spelling.
 s.surface.decor.append({"area":"claim","kind":"chair","x":900,"y":600,"z":0})
 s.surface.chests["civic145:personal"]={"area":"claim","x":1000,"y":600,"items":{"coal":7}}
 var decor=JSON.parse_string(JSON.stringify(s.surface.decor));var chests=JSON.parse_string(JSON.stringify(s.surface.chests))
 g.surface.enter("trail");settle();var p=HoldGreatClaim102.TOWN_ACCESS
 check(g.surface.roads.furnishings("trail").filter(func(f):return f.furnishing=="civic_ledger").size()==1,"Exactly one monumental town ledger")
 check(not g.surface.walkable(HoldGreatClaim102.TOWN_LEDGER-Vector2(0,20)),"Lectern base blocks walking")
 check(g.surface.walkable(p),"South reading approach is clear")
 at(Vector2(190,700));Input.action_press("right")
 for i in 60:g.surface.move(.02)
 Input.action_release("right")
 check(g.player.x>300 and g.surface.area=="trail","Bunkhouse road remains traversable past the forecourt")
 at(p);check(HoldGreatClaim102.near(g),"Town book authorizes existing contributions")
 check(g.surface.nearest().get("action","")=="great_claim102","Book owns the nearby E interaction")
 await snap("01-town-ledger")
 key(KEY_E);check(g.panel_id=="great_claim102","Real E opens the contribution book");await snap("02-contributions");g.close_panel()
 HoldFirstVisit99.data(s).rewarded=true;s.add("coal",8)
 var before=s.count("coal")
 check(HoldLedger137.contribute(g,"forge","coal",3) and s.count("coal")==before-3,"Town book accepts partial delivery with exact payment")
 at(p+Vector2(0,200));check(not HoldLedger137.contribute(g,"forge","coal",1),"Remote delivery remains blocked")
 g.surface.enter(HoldFrontier103.lodge(s));settle();at(Vector2(670,425))
 check(HoldGreatClaim102.near(g) and HoldLedger137.paid(s,"forge","coal")==3,"Indoor records desk shares the same saved ledger")
 g.surface.enter("trail");settle();at(p);g.save_game();g.start_game(true);settle();s=g.state
 check(HoldLedger137.paid(s,"forge","coal")==3 and s.count("coal")==before-3,"Delivery survives JSON reload without duplication")
 check(JSON.stringify(s.surface.decor)==JSON.stringify(decor) and JSON.stringify(s.surface.chests)==JSON.stringify(chests),"Installing the static landmark preserves existing possessions")
 at(p);check(HoldGreatClaim102.near(g),"Reloaded fortune can use town book")
 at(HoldGreatClaim102.TOWN_LEDGER+Vector2(0,-65));check(not HoldGreatClaim102.near(g),"Cannot deliver through the back of the solid lectern")
 at(Vector2(190,480));await snap("03-bunkhouse-exit")
 at(p);await snap("04-reloaded-town-ledger")
 print("CIVIC145: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
