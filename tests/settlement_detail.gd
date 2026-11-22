extends SceneTree
var g
var failures=[]
var count=0
func check(ok,description):
 count+=1
 if not ok:failures.append(description);print("FAIL ",description)
func ready():
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.transition_left=0;g.transition_shade.hide();g.loading_view._process(1);g.loading_view._process(1);g.loading_view.hide()
func key(code):
 var e=InputEventKey.new();e.pressed=true;e.keycode=code;e.physical_keycode=code;g._unhandled_input(e)
func walk_to(target):
 for tick in 270:
  var d=target-g.player
  if d.length()<3:return true
  var action=("right" if d.x>0 else "left") if absf(d.x)>2 else ("down" if d.y>0 else "up")
  var old=g.player
  Input.action_press(action);g.surface.move(.012);Input.action_release(action)
  if g.player.distance_to(old)<.01:print("Blocked: ",g.player," heading to ",target," in ",g.surface.area);return false
 return false
func follow(path,reverse_order=false):
 var route=path.duplicate()
 if reverse_order:route.reverse()
 for point in route:
  if not walk_to(point):return false
 return true
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host);g=host.get_child(0).get_child(0)
 g.set_process(false);ready()
 var ledger=load("res://scripts/great_claim102.gd");var towns=load("res://scripts/frontier103.gd")
 var room_art=load("res://settlement/rooms.gd");var ground=load("res://settlement/ground.gd")
 var signs=room_art.work_areas([{"kind":"bed","x":200,"y":380},{"kind":"bed","x":271,"y":380},{"kind":"bed","x":468,"y":380}],"room:lodge")
 check(signs.size()==2,"Adjacent bunks share a mat; a separated bunk gets its own")
 check(room_art.work_areas([],"room:research").is_empty(),"Empty room has no phantom furnishing marks")
 var start=g.player;var road=Vector2(151,692)
 check(g.surface.area=="trail","Town launcher starts in Stonebridge")
 check(ledger.TOWN_ACCESS.y>=road.y+175,"Reading area is across the road in its own precinct")
 check(g.surface.points().filter(func(p):return p.action=="great_claim102" and p.p==ledger.TOWN_ACCESS).size()==1,"One correctly located ledger interaction")
 var buildings=load("res://scripts/building_art.gd");var furniture=load("res://scripts/furnishings.gd")
 var site=load("res://settlement/building_site.gd")
 var plans=load("res://scripts/building_plans.gd")
 check(not site.town("frontier_lodge",Vector2(190,430)),"Former hanging bunkhouse fails the full foundation check")
 for building in g.surface.architecture.objects("trail")+g.surface.roads.buildings("trail"):
  check(site.fits(building,site.TOWN_BANKS),building.plan+" has full support and a supported approach")
 check(site.town("frontier_watch",towns.STORES_DOOR),"Later community storehouse stays on its riverbank")
 check(not site.town("frontier_forge",Vector2(1145,560)),"A dry door cannot validate a building that straddles the river")
 var lodge_id=towns.data(g.state).buildings.lodge
 var store=g.surface.architecture.data()
 var lodge=g.surface.architecture.record(lodge_id)
 var rooms=lodge.rooms.duplicate()
 lodge.x=190;lodge.y=430;towns.data(g.state).erase("frontage_revision")
 g.save_game();g.start_game(true);ready()
 lodge=g.surface.architecture.record(lodge_id)
 check(Vector2(lodge.x,lodge.y)==towns.LODGE_DOOR and lodge.rooms==rooms,"Prior saves regain the same fitted lodge at its new site")
 check(g.surface.architecture.data().instances.size()==store.instances.size(),"Migrating the frontage never duplicates a building")
 var silhouettes=[]
 for f in ledger.furnishings(g.surface.world,"trail"):
  if f.furnishing in ["ledger_memorial","civic_ledger","royal_brazier"]:
   check(not g.surface.walkable(f.p-Vector2(0,6)),f.furnishing+" has a solid foot")
   check(g.surface.walkable(Vector2(f.p.x,road.y)),"Road remains open past "+f.furnishing)
   silhouettes.append(furniture.silhouette(f.furnishing,f.p))
 for building in g.surface.roads.buildings("trail")+g.surface.architecture.objects("trail"):
  if building.get("kind","")!="building":continue
  var bounds=buildings.visual_bounds(building).grow(14)
  check(not silhouettes.any(func(r):return r.intersects(bounds)),"Shrine has clear silhouette beside "+str(building.get("plan","building")))
 check(g.surface.walkable(Vector2(365,613)) and not g.surface.points().any(func(f):return f.action=="great_claim102" and f.p.distance_to(Vector2(365,639))<80),"Former ledger court is clear")
 var mountain=load("res://scripts/mountain104.gd");var trial=load("res://scripts/claim127.gd")
 var mountain_data=mountain.data(g.state)
 var authenticated=mountain_data.get("authenticated",false)
 var prior_trial=g.state.surface.get("claim127",{}).duplicate(true)
 mountain_data.authenticated=true;trial.data(g.state).stage=1
 for station in trial.STATIONS:
  check(g.surface.walkable(station) and silhouettes.all(func(r):return not r.grow(45).has_point(station)),"Public lift trial station and its approach remain clear")
 for r in [Rect2(498,653,104,148),Rect2(728,653,104,148)]:
  check(silhouettes.all(func(b):return not r.grow(20).intersects(b)),"Working lift rigs clear every shrine silhouette")
 mountain_data.authenticated=authenticated
 if prior_trial.is_empty():g.state.surface.erase("claim127")
 else:g.state.surface.claim127=prior_trial
 check(walk_to(ledger.SHRINE_THRESHOLD) and follow(ledger.WEST_WALK,true) and walk_to(road),"Walk from shrine to through-road by the west gate")
 check(walk_to(Vector2(470,692)) and walk_to(ledger.EAST_WALK[0]),"Reach the Pinewood turnoff via the main street")
 check(follow(ledger.EAST_WALK) and walk_to(ledger.TOWN_ACCESS),"Enter from Pinewood and walk to the reader's spot")
 check(ledger.near(g) and g.surface.nearest().get("action")=="great_claim102","Book and contribution check agree")
 key(KEY_E)
 check(g.panel_id=="great_claim102","E opens the Ledger panel")
 g.close_panel()
 if OS.get_environment("DETAIL_FRAME")!="":
  g.camera=g.surface.camera_target();g.queue_redraw();key(KEY_E);g.ui.show()
  for f in 3:await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(OS.get_environment("DETAIL_FRAME"));g.close_panel()
 check(walk_to(ledger.SHRINE_THRESHOLD) and follow(ledger.WEST_WALK,true) and walk_to(road) and walk_to(Vector2(towns.LODGE_DOOR.x,692)),"Reach the bunkhouse approach")
 check(walk_to(towns.LODGE_DOOR+Vector2(0,35)),"Walk up the actual bunkhouse path")
 if g.surface.area=="trail":key(KEY_E)
 ready();check(g.surface.area==towns.lodge(g.state),"Enter bunkhouse at the door")
 var inn=g.surface.roads.inn_door()
 g.surface.enter("trail",Vector2(inn.x,685));ready()
 check(walk_to(inn+Vector2(0,32)),"Inn patio allows a clear walk from the main street")
 key(KEY_E);ready();check(g.surface.area=="room:wayfarer","Inn opens at its registered door")
 var returns=g.surface.roads.links("room:wayfarer")
 check(returns[0].landing==inn+Vector2(0,45),"The inn returns to its new doorstep")
 g.surface.enter("trail",Vector2(875,665));ready()
 check(walk_to(Vector2(880,606)),"Walk up the forge approach")
 if g.surface.area=="trail":key(KEY_E)
 ready();check(g.surface.area==towns.room(g.state,"forge"),"Enter communal forge through its door")
 var forge=load("res://scripts/forge147.gd");check(forge.forge_position(g)!=Vector2.INF,"Apron belongs to a real furnace")
 for name in ["survey","watch"]:
  g.surface.enter(towns.room(g.state,name));ready()
  check(g.surface.walkable(g.player) and g.surface.points().any(func(p):return p.action=="frontier103"),name+" counter and landing")
 g.surface.enter("claim",Vector2(2300,1145));ready();var house=g.surface.house
 var edge_cell=Vector2i(2,15)
 g.player=house.center(edge_cell)+Vector2(42,0)
 check(not house.valid(edge_cell,"wood_floor") and house.reason.contains("whole floor tile"),"A floor tile with just its center on the parcel is rejected")
 var blueprint=g.surface.architecture.room_blueprints
 var draft={"x":2,"y":14,"w":4,"h":3,"z":0,"purpose":"hall","doors":[]}
 check(not blueprint.validate(draft) and blueprint.message.contains("entire room foundation"),"A planned room cannot cut across the cliff")
 var candidate=plans.instance("frontier_lodge",Vector2(240,665))
 g.player=candidate.p+Vector2(0,60)
 check(not g.surface.architecture.valid(candidate) and g.surface.architecture.reason.contains("full foundation"),"The normal building placement path rejects an unsupported wall")
 check(site.covered(Rect2(1880,500,80,60),g.surface.CLAIM_GROUNDS),"A foundation across a shared dry parcel seam is valid")
 check(not site.covered(Rect2(1880,930,80,60),g.surface.CLAIM_GROUNDS),"A partly unsupported corner at the L-shaped claim fails")
 g.surface.enter("claim",Vector2(2300,1145));ready()
 var doors=g.surface.points().filter(func(p):return p.name=="Enter home")
 check(not doors.is_empty() and room_art.home_objects(g).any(func(o):return o.has("porch_sill")),"Threshold belongs to a real exterior door")
 g.player=doors[0].p+Vector2(0,35);key(KEY_E);ready()
 check(house.view.inside(),"Player enters the cottage")
 var objects=room_art.home_objects(g)
 check(objects.any(func(o):return o.has("bedrail")) and objects.any(func(o):return o.has("bedmat")),"Bed fits against its wall")
 var bed=g.state.surface.decor.filter(func(f):return f.kind=="bed" and house.local(f))[0]
 var pos=Vector2(bed.x,bed.y);bed.x+=600
 check(not room_art.home_objects(g).any(func(o):return o.has("bedrail") or o.has("bedmat")),"Moving bed releases former wall and floor dressing");bed.x=pos.x
 house.view.cooldown=0;key(KEY_E);ready()
 check(not house.view.inside(),"Return through the cottage door")
 g.surface.enter("trail",start);g.save_game();g.start_game(true);ready()
 check(g.surface.area=="trail" and g.player.distance_to(start)<2 and ledger.near(g),"Ledger remains usable after save/reload")
 print("SETTLEMENT ",count," checks. Failures ",failures);quit(0 if failures.is_empty() else 1)
