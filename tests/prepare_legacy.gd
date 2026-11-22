extends SceneTree
func _initialize():call_deferred("run")
func run():
 var tree=load("res://furrow/start.tscn").instantiate()
 root.add_child(tree)
 var g=tree.get_child(0).get_child(0)
 g.set_process(false)
 var w=g.deep.world
 if OS.get_cmdline_user_args().has("annex"):
  load("res://scripts/mineworks143.gd").prepare(w)
  w.data.mineworks143.bridge=true
  w.layer(6).fixtures["40,25"]="lamp"
 w.data.depth=0
 var c=Vector2i(9,9)
 g.player=w.center(c);g.state.steel=true
 for z in 4:
  print("LEGACY ",w.carve_stairs(c)," | ",w.traverse(c,false))
 g.player=w.center(c);w.data.position=[g.player.x,g.player.y]
 w.layer(4).fixtures["11,9"]="lamp";w.layer(3).damage["16,17"]=.8
 g.state.steel=false;g.save_game()
 print("LEGACY FILE ",g.state.save_path()," floors ",w.data.layers.size()," depth ",w.depth())
 quit()
