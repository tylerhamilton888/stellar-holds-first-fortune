extends "res://tests/support/game_fixture.gd"
func same(a,b)->bool:return JSON.stringify(a)==JSON.stringify(b)
func stand(p:Vector2):
 g.player=p;g.deep.world.survey(p);g.camera=g.deep.camera_target();g.transition_left=0
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.change_zone("mine");settle();var w=g.deep.world;var door=HoldMineEntrance.inside_position(w)
 check(Deepworks.cell(door).y==3 and w.at(Deepworks.cell(door)+Vector2i.UP)!=0,"Surface doorway is recessed against the north wall of the arrival bay")
 check(g.player==HoldMineEntrance.inside_arrival(w) and not w.solid(g.player),"Arrival stands on a clear approach inside the doorway")
 check(not HoldMineEntrance.inside_near(w,Deepworks.center(Deepworks.ENTRY)),"Freight floor is not an exit interaction")
 stand(Deepworks.center(Deepworks.ENTRY));Input.action_press("up");g.deep.move(.35);Input.action_release("up")
 check(g.zone=="mine" and g.player.y<300,"Crossing the old invisible floor line keeps the player inside")
 stand(Deepworks.center(Deepworks.ENTRY));key(KEY_E);settle()
 check(g.zone=="mine","E on the former floor hatch cannot leave the mine")
 check(w.solid(door+Vector2(60,0)) and not w.solid(door+Vector2(0,20)),"Stone jambs block feet while the actual throat remains walkable")
 stand(door+Vector2(-110,65));Input.action_press("right");g.deep.move(.8);Input.action_release("right")
 check(g.zone=="mine","Walking sideways past the doorway does not trigger a transition")
 stand(door+Vector2(0,60));g.notice_time=0;await snap("01-north-wall-entryway")
 var inventory=g.state.inventory.duplicate(true);var layers=w.data.layers.duplicate(true);var furniture=w.data.living.duplicate(true)
 g.deep.haul.bucket().stone=3;stand(door+Vector2(0,30));key(KEY_E);settle()
 check(g.zone!="mine" and g.surface.area=="trail","Real E at the wall doorway returns to the staging yard")
 check(g.state.count("stone")==int(inventory.get("stone",0))+3,"Exit preserves the existing freight delivery transaction")
 Input.action_press("up");g.change_zone("mine");settle();g.deep.move(1.2);Input.action_release("up");g.deep.poll_arrival_input()
 check(g.zone=="mine" and g.player.y>=door.y+39,"Held arrival movement cannot bounce back outside")
 check(same(w.data.layers,layers) and same(w.data.living,furniture),"Travel does not excavate, reseed or move existing property")
 stand(door+Vector2(0,60));Input.action_press("up");g.deep.move(.65);Input.action_release("up");settle()
 check(g.zone!="mine" and g.surface.area=="trail","Walking deliberately through the wall throat leaves the mine")
 g.change_zone("mine");settle();w=g.deep.world
 check(HoldMineworks143.reserved(w,Deepworks.cell(door)+Vector2i.DOWN,0),"New construction keeps the doorway approach clear")
 # Pre-fix save data with a furnished north bay picks a different doorway without moving belongings.
 w.data.erase("entryway144");var f={"kind":"bench","x":8,"y":3,"depth":0,"room":"legacy","solid":true,"paid":{}}
 w.data.living.furniture["0:8,3"]=f;var saved=f.duplicate(true);layers=w.data.layers.duplicate(true)
 var migrated=HoldMineEntrance.inside_position(w)
 check(migrated!=door and same(w.data.living.furniture["0:8,3"],saved) and same(w.data.layers,layers),"Old-save doorway avoids furniture and preserves all terrain and possessions")
 g.save_game();g.start_game(true);settle();w=g.deep.world
 check(HoldMineEntrance.inside_position(w)==migrated and w.data.living.furniture.has("0:8,3"),"Doorway migration is stable across JSON save and reload")
 var entry=HoldMineworks143.entrance(w);stand(Deepworks.center(entry));key(KEY_E);settle()
 check(w.depth()==5,"Original mine still leads into the lateral mineworks")
 var back=HoldMineworks143.return_landing(w,5)
 check(back.y==6 and w.at(back+Vector2i.UP)!=0,"Mineworks return doorway sits against the bay wall")
 check(g.player.distance_to(Deepworks.center(back))>=70 and HoldMineworks143.nearby(g).is_empty(),"Arriving in a minework leaves the player outside its return interaction")
 stand(Deepworks.center(back)+Vector2(0,60));await snap("02-mineworks-wall-return")
 stand(Deepworks.center(back));key(KEY_E);settle();check(w.depth()==0,"Wall return doorway preserves travel to Old Workings")
 stand(migrated+Vector2(0,70));g.depth_nav.explore.enabled=true;g.depth_nav.explore.mouse_look=false;g.depth_nav.update(0)
 await snap("03-entryway-perspective")
 check(g.depth_nav.explore.prop_pool.keys().any(func(k):return str(k).begins_with("entryway144:")),"Optional perspective view uses the same doorway artwork")
 g.depth_nav.explore.enabled=false
 print("ENTRYWAYS144: %d passed / %d failed" % [passed,failed]);quit(1 if failed else 0)
