extends Node
func _ready():
 var folder=OS.get_executable_path().get_base_dir()
 var args=OS.get_cmdline_args();var index=args.find("--main-pack")
 if index>=0 and index+1<args.size():folder=ProjectSettings.globalize_path(args[index+1]).get_base_dir()
 if FileAccess.file_exists(folder.path_join("Junctions.pck")) and (not ProjectSettings.load_resource_pack(folder.path_join("Cottage-Grounds.pck")) or not ProjectSettings.load_resource_pack(folder.path_join("Junctions.pck"))):
  OS.alert("Place the preview beside the Cottage Grounds executable and data pack.");get_tree().quit(1);return
 var samples=OS.get_cmdline_user_args()
 var route=6 if samples.has("regulator") else 5 if samples.has("court") else 4 if samples.has("depth5") else 3 if samples.has("adit") else 2 if samples.has("back") else (1 if samples.has("below") else 0)
 var game=load("res://main.tscn").instantiate();add_child(game)
 if samples.has("campaign"):return
 for journey in ["stonebridge","cottage","underground"]:
  if samples.has(journey):
   load("res://settlement/preview.gd").launch(game,journey);return
 for i in ["yard","undercroft","mess"]:
  if samples.has(i):
   game.state.save_slot=["yard","undercroft","mess"].find(i)+1
   var file=game.state.save_path()
   var fresh=not FileAccess.file_exists(file)
   if fresh:
    var stream=FileAccess.open(file,FileAccess.WRITE)
    stream.store_buffer(FileAccess.get_file_as_bytes("res://court/gate.json"));stream.close()
   game.start_game(true)
   if fresh:load("res://workshop/sample.gd").build(game,i)
   return
 open_sample(game,route)

func open_sample(game,route:int):
 game.state.save_slot=1 if route==3 else 2 if route in [0,4,6] else 3
 var file=game.state.save_path()
 var new_sample=not FileAccess.file_exists(file)
 if new_sample and route in [5,6]:
  var stream=FileAccess.open(file,FileAccess.WRITE)
  if stream==null:push_error("Could not open the court preview save");get_tree().quit(1);return
  var raw=FileAccess.get_file_as_bytes("res://court/gate.json")
  if route==5:stream.store_buffer(raw)
  else:
   var sample=JSON.parse_string(raw.get_string_from_utf8())
   var mine=sample.deepworks.claim
   var z=38
   var f=mine.layers[z].features[0]
   var feet=Vector2(f.x*40+20,f.y*40+20+115)
   mine.depth=z;mine.position=[feet.x,feet.y];sample.x=feet.x;sample.y=feet.y
   f.found=false;mine.discoveries.erase(f.name);mine.layers[z].seen={}
   for item in f.salvage:sample.inventory[item]=maxi(0,int(sample.inventory.get(item,0))-int(f.salvage[item]))
   stream.store_string(JSON.stringify(sample))
  stream.close()
 elif new_sample:
  var J=load("res://quarry/buried_quarry.gd")
  var W=load("res://scripts/deepworks.gd")
  var s=JSON.parse_string(FileAccess.get_file_as_string("res://junction/pine-a.json"))
  s.seed_value=[33178,7941,52829,33178,33178][route]
  var mine=W.generate(int(s.seed_value)+7919)
  var q=J.plan(mine)
  if q.is_empty():push_error("No valid quarry in sample");get_tree().quit(1);return
  var y=J.road_y(q)
  var crest=Vector2i(q.x+q.width-1,y)
  var at=crest+Vector2i.LEFT;var depth=0
  if route==1:
   at=crest+Vector2i(7,3);depth=1
  elif route==2:at=Vector2i(q.x-2,y)
  if route==3:
   at=Vector2i(J.bench(q).x,crest.y+5);depth=1
  var p=W.center(at)+Vector2(0,12 if route!=2 else 0);mine.position=[p.x,p.y];mine.depth=depth
  s.deepworks.claim=mine;s.zone="mine";s.x=p.x;s.y=p.y
  var stream=FileAccess.open(file,FileAccess.WRITE)
  if stream==null:push_error("Cannot create the sample save");get_tree().quit(1);return
  stream.store_string(JSON.stringify(s));stream.close()
 game.start_game(true)
 if new_sample and route==4:
  var w=game.deep.world
  var landing=Vector2i(9,9)
  game.state.steel=true
  for z in 4:
   w.carve_stairs(landing)
   if not w.traverse(landing,false):
    push_error("Failed to prepare the shaft to depth five");return
  game.player=w.center(landing)
  w.data.position=[game.player.x,game.player.y]
  game.camera=game.deep.camera_target()
  w.survey(game.player)
  game.save_game()
