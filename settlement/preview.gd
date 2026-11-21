extends RefCounted
const JOURNEYS=["stonebridge","cottage","underground"]
static func launch(g,route):
 g.state.save_slot=JOURNEYS.find(route)+1
 var file=g.state.save_path()
 var fresh=not FileAccess.file_exists(file)
 if fresh:
  var save=FileAccess.open(file,FileAccess.WRITE)
  if save==null:push_error("Cannot write the settlement preview save.");return
  save.store_buffer(FileAccess.get_file_as_bytes("res://court/gate.json"));save.close()
 g.start_game(true)
 if not fresh:return
 if route=="stonebridge":
  g.surface.enter("trail",HoldGreatClaim102.TOWN_ACCESS+Vector2(0,14))
 elif route=="cottage":
  load("res://workshop/sample.gd").build(g,"yard")
  var home=g.surface.points().filter(func(p):return p.name=="Enter home")
  if not home.is_empty():
   var approach=home[0].p+Vector2(0,45)
   if g.surface.walkable(approach):g.player=approach
  g.camera=g.surface.camera_target()
 else:load("res://workshop/sample.gd").build(g,"undercroft")
 g.surface.direction=Vector2.UP;g.hotbar.stow(false);g.save_game()
