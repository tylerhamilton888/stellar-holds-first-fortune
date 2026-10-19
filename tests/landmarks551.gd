extends "res://tests/input_reference54.gd"
func digest(value)->String:return JSON.stringify(JSON.parse_string(JSON.stringify(value)))
func signature(w:Deepworks)->Array:
 var all:Array=[]
 for z in w.data.layers.size():
  var a:Array=[]
  for p in w.landmarks(z):a.append([p.art,p.p.x,p.p.y,p.width,p.height,p.base.x,p.base.y,p.radius.x,p.radius.y,p.feature.name,p.feature.found])
  all.append(a)
 return all
func snap(name:String):
 if g.zone=="mine":g.deep.world.survey(g.player)
 await super.snap(name)
func run():
 output="res://docs/testing/landmarks-0.55.1";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle()
 check(g.zone=="mine","Existing trail enters the integrated mine")
 var w=g.deep.world
 var natural_crystal=w.landmarks()[1];w.survey(natural_crystal.base+Vector2(0,90))
 check(natural_crystal.feature.found,"Approaching solid crystal still discovers it through line of sight")
 var natural_oath=w.landmarks()[4];w.survey(natural_oath.base+Vector2(80,0))
 check(natural_oath.feature.found,"Approaching solid oath pillar still discovers the refuge")
 for z in 5:
  for f in w.layer(z).features:f.found=true
  var counts=[0,0]
  for part in w.landmarks(z):counts[0 if part.art==3 else 1]+=1
  check(counts==[4,6],"Depth %d retains four crystal formations and six oath pillars" % z)
 g.deep.world.survey(Deepworks.center(Vector2i(w.layer().features[1].x,w.layer().features[1].y)))
 var original=signature(w);var cells=[]
 for z in 5:cells.append(w.layer(z).cells.duplicate())
 var crystal=w.landmarks()[1]
 g.player=crystal.base+Vector2(0,65);g.deep.remember();g.clock=10;g.notice_time=0
 await snap("01-crystal-before-load")
 g.save_game()
 var save_path=g.state.save_path();var saved=JSON.parse_string(FileAccess.get_file_as_string(save_path));saved.erase("landmark_revision")
 var old_bytes=JSON.stringify(saved);var file=FileAccess.open(save_path,FileAccess.WRITE);file.store_string(old_bytes);file.close()
 g.start_game(true);settle();w=g.deep.world;g.clock=10;g.notice_time=0
 check(digest(signature(w))==digest(original),"Actual old-save reload preserves all landmark art, names, positions and discovery flags")
 var exact=false
 for name in DirAccess.get_files_at("user://"):
  if ".pre-landmarks-551-" in name and FileAccess.get_file_as_string("user://"+name)==old_bytes:exact=true
 check(exact,"Pre-fix save receives byte-exact unique recovery copy")
 await snap("02-crystal-after-load")
 for cycle in 3:
  g.save_game();g.start_game(true);settle();w=g.deep.world
  check(digest(signature(w))==digest(original),"Repeated save/reload %d preserves visual identity" % cycle)
 for z in 5:
  check(digest(w.layer(z).cells)==digest(cells[z]),"Depth %d terrain remains unchanged" % z)
 # All bases reject the Dwarf and navigation, whether discovered or not.
 for z in 5:
  var all_solid=true
  for part in w.landmarks(z):
   if not w.solid(part.base,z):all_solid=false
  check(all_solid,"Every visible solid base has physical collision on depth %d" % z)
 w.data.depth=0;crystal=w.landmarks()[1]
 var center:Vector2=crystal.base
 for i in 8:
  var dir=Vector2.from_angle(i*TAU/8)
  g.player=center+dir*100;var start=g.player
  if dir.x>.1:Input.action_press("left")
  if dir.x<-.1:Input.action_press("right")
  if dir.y>.1:Input.action_press("up")
  if dir.y<-.1:Input.action_press("down")
  for n in 100:g.deep.move(1.0/60)
  for action in ["left","right","up","down"]:Input.action_release(action)
  check(not w.solid(g.player) and g.player.distance_to(start)>10 and g.player.distance_to(center)>15,"Actual movement stops at crystal base from approach %d" % i)
 for index in [0,4]:
  var obstacle=w.landmarks()[index]
  for i in 8:
   var dir=Vector2.from_angle(i*TAU/8);g.player=w.safe_position(obstacle.base+dir*90);var start=g.player
   if dir.x>.1:Input.action_press("left")
   if dir.x<-.1:Input.action_press("right")
   if dir.y>.1:Input.action_press("up")
   if dir.y<-.1:Input.action_press("down")
   for n in 90:g.deep.move(1.0/60)
   for action in ["left","right","up","down"]:Input.action_release(action)
   check(not w.solid(g.player) and g.player.distance_to(obstacle.base)>10,"No clipping from approach %d to landmark variant %d (including grouped pillars)" % [i,index])
 check(not w.visible(center-Vector2(100,0),center+Vector2(100,0)),"Landmark base blocks reaching and hauling through solid artwork")
 var blocked_target=Deepworks.cell(center+Vector2(100,0));var old_kind=w.at(blocked_target);w.set_cell(blocked_target,2)
 check(w.target(center-Vector2(100,0),Deepworks.center(blocked_target),240)==Vector2i(-1,-1),"Pick target ray cannot pass through crystal base")
 w.set_cell(blocked_target,old_kind)
 g.player=center+Vector2(0,90)
 check(not g.handworks.can_place(center),"Workstation placement respects landmark base")
 # Walking behind an upright formation should be allowed, and its body occludes us.
 g.player=center-Vector2(0,crystal.radius.y+12);g.clock=10
 await snap("03-behind-crystal")
 check(not w.solid(g.player),"Tall crystal silhouette does not create an oversized invisible wall")
 g.player=center+Vector2(0,crystal.radius.y+12)
 await snap("04-front-crystal")
 var pillar=w.landmarks()[4]
 g.player=pillar.base-Vector2(0,pillar.radius.y+12)
 await snap("05-behind-oath-pillar")
 g.player=pillar.base+Vector2(0,pillar.radius.y+12)
 await snap("06-front-oath-pillar")
 # Route goes around a real base; no cell-centre edge may pass through it.
 var start=Deepworks.cell(center+Vector2(-100,60));var dest=Deepworks.cell(center+Vector2(100,-60))
 var route=w.route(start,0,"coal",dest);var p=Deepworks.center(start);var safe=not route.is_empty()
 for q in route.get("path",[]):
  if not w.clear_step(p,q,0):safe=false
  p=q
 check(safe and p==Deepworks.center(dest),"Crew route skirts landmark footprint with clear full-body steps")
 # Adjacent Z-level passage must reject a lower landing obstructed by a landmark.
 var target=w.landmarks(1)[1];var c=Deepworks.cell(target.base);w.set_cell(c,0,0);g.player=Deepworks.center(c);w.data.depth=0
 var links=w.data.links.size();var result=w.carve_stairs(c)
 check(w.data.links.size()==links and "blocks" in result,"New stairs cannot open inside a landmark below")
 # Legacy stair crossing a previously decorative base remains usable. Shift only art.
 w.data.links[w.link_key(c,0)]={"x":c.x,"y":c.y,"upper":0,"lower":1,"kind":"stair"}
 var retained=digest(w.data.links);var before=target.p;w.rebuild_landmarks()
 check(digest(w.data.links)==retained and w.walkable(c,1),"Legacy passage stays at original coordinates; overlapping landmark moves aside")
 check(w.landmarks(1)[1].p!=before,"Legacy overlap correction moves the artwork and collision together")
 g.player=Deepworks.center(c);key(KEY_E);settle();check(w.depth()==1 and not w.solid(g.player),"Real E descends through preserved landing")
 # Old player position inside another base resolves nearby on the same floor.
 var trapped=w.landmarks()[0].base;g.player=trapped;g.save_game();g.start_game(true);settle();w=g.deep.world
 check(w.depth()==1 and not w.solid(g.player) and g.player.distance_to(trapped)<165,"Old embedded player is recovered locally without changing depth")
 var fixed=signature(w);g.save_game();g.start_game(true);settle();w=g.deep.world
 check(digest(signature(w))==digest(fixed),"Corrected legacy landmark anchors persist on next reload")
 # Exit via the real matching passage and settlement entrance.
 g.player=Deepworks.center(c);var up=InputEventKey.new();up.keycode=KEY_E;up.pressed=true;up.shift_pressed=true;g._unhandled_input(up);settle()
 check(w.depth()==0,"Shift+E returns through the same passage")
 g.player=Deepworks.center(Deepworks.ENTRY);key(KEY_E);settle();check(g.zone!="mine","Existing mine return remains functional")
 print("LANDMARKS551: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
