extends "res://tests/collision_reference54.gd"
func near_route(reached:Dictionary,p:Vector2)->bool:
 for c in reached:
  var at=Vector2(c)*20
  if at.distance_to(p)<74 and g.surface.clear_interaction(at,p):return true
 return false
func planted_span(pose:Dictionary)->float:
 var im=pose.texture.get_image();var lo=1000.0;var hi=-1000.0
 for y in im.get_height():
  var wy=pose.rect.position.y+float(y)/im.get_height()*pose.rect.size.y
  if wy< -4:continue
  for x in im.get_width():
   if im.get_pixel(x,y).a>.6:
    var wx=pose.rect.position.x+float(x)/im.get_width()*pose.rect.size.x
    lo=minf(lo,wx);hi=maxf(hi,wx)
 return hi-lo
func run():
 output="res://docs/testing/art-0.56.0/integration";DirAccess.make_dir_recursive_absolute(output)
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt})
   var attached=true;var grip_stable=true
   for d in [Vector2.DOWN,Vector2(1,.5),Vector2(1,-.5),Vector2.UP]:
    var idle=HoldFolk.grip(p,d,0,false)
    for f in 4:
     var time=(f+.05)*HoldFolk.CYCLE/4
     var a=HoldFolk.descriptor(p,d,true,time,"",0);var head=HoldFolk.head_rect(p,a).rect
     attached=attached and head.end.y>(a.neck-a.root).y*a.scale+4 and head.intersects(HoldFolk.body_rect(a))
     var walking=HoldFolk.grip(p,d,time,true)
     grip_stable=grip_stable and signf(idle.x)==signf(walking.x) and idle.distance_to(walking)<9
   check(attached,"All facings attach hair/beard to shoulders: gender %d design %d"%[gender,sculpt])
   check(grip_stable,"Idle/walk retain the same supporting hand: gender %d design %d"%[gender,sculpt])
 var spans=[];var keys=[]
 for f in 4:
  var pose=HoldFolk.stride(1,(f+.05)*HoldFolk.CYCLE/4)
  spans.append(planted_span(pose));keys.append(hash(pose.texture.get_image().get_data()))
 check(spans[0]>spans[1]+8 and spans[2]>spans[3]+8,"Side contact spreads both feet; each passing pose lifts one clear of the floor")
 check(keys[0]!=keys[1] and keys[1]!=keys[2] and keys[2]!=keys[3],"Four distinct drawn side-step silhouettes are active")
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for id in ["home","tavern","forge","market","commission","research","throne","practice","training"]:
  g.surface.enter("room:"+id);settle();var reached=reachable(g.player)
  var access=true
  for p in g.surface.points():access=access and near_route(reached,p.p)
  check(access,"Walkable approach to every door, resident and service: "+id)
  var solid=true
  for o in g.surface.world.room_objects():solid=solid and not g.surface.walkable(g.surface.world.furn_footprint(o).get_center())
  check(solid,"Furniture sprite bases block feet: "+id)
  g.player=Vector2(480,600);key(KEY_E);settle();check(not g.surface.room(),"Actual south doorway exits: "+id)
 g.surface.enter("room:tavern",Vector2(620,478));settle();key(KEY_E)
 check(g.panel_id=="conversation" and g.talk_id=="hedrik","Solid bar permits a natural conversation across the counter")
 g.close_panel();await snap("01-tavern")
 for ward in ["hearthward","crownward","forgeward"]:
  g.surface.enter(ward);settle();var reached=reachable(g.player);var access=true
  for p in g.surface.points():
   if not p.action.begins_with("citizen:"):access=access and near_route(reached,p.p)
  check(access,"Town thresholds remain connected: "+ward)
 g.state.claim_id="old_delving";g.surface.enter("claim");settle();g.state.add("wood",200);g.state.add("stone",200)
 var old_count=g.state.surface.decor.size();var built=[]
 for i in HoldFurnishings.BUILDABLE.size():
  var kind=HoldFurnishings.BUILDABLE[i];var p=Vector2(720+i*120,560)
  g.player=p+Vector2(0,50);g.surface.placing=kind
  check(g.surface.place(p),"Player crafts and places the same sprite catalogue: "+kind)
  if kind!="chest":built.append(g.state.surface.decor.back().duplicate(true))
 g.surface.placing="table";g.player=Vector2(840,610)
 var wood=g.state.count("wood")
 check(not g.surface.place(Vector2(840,560)) and g.state.count("wood")==wood,"Overlapping full furnishing footprint is rejected without spending")
 var bed=built[3];var base=HoldFurnishings.footprint("bed",Vector2(bed.x,bed.y))
 check(g.surface.house.occupied(g.surface.house.cell(base.position+Vector2(5,5))),"Building system reserves the far end of a bed, not only its anchor")
 g.player=Vector2(1200,650);await snap("02-catalogue-built")
 g.save_game();var path=g.state.save_path();var data=JSON.parse_string(FileAccess.get_file_as_string(path));data.surface.folk_revision=54
 var bytes=JSON.stringify(data);var file=FileAccess.open(path,FileAccess.WRITE);file.store_string(bytes);file.close()
 g.start_game(true);settle();var backup=false
 for name in DirAccess.get_files_at("user://"):
  if ".pre-art-560-" in name and FileAccess.get_file_as_string("user://"+name)==bytes:backup=true
 check(backup,"Old fortune receives an exact non-overwritten pre-art recovery copy")
 check(g.state.surface.decor.size()==old_count+built.size() and g.state.count("wood")==wood,"Furniture, resource payments and prior progress survive reload")
 var first=built[0];g.player=Vector2(first.x,first.y+35);var cost=HoldFurnishings.ITEMS[first.kind].cost;wood=g.state.count("wood")
 check(g.surface.recover_decor() and g.state.count("wood")==wood+int(cost.wood),"Dismantling refunds the exact catalogue recipe")
 g.surface.enter("home:old_delving");settle();g.surface.placing="counter";g.player=Vector2(480,560)
 check(not g.surface.place(Vector2(480,600)),"Full-size counter cannot obstruct the home doorway")
 await snap("03-home")
 print("INTEGRATION56: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
