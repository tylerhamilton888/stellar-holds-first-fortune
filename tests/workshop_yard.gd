extends SceneTree
var failures=[]
var count=0
func check(ok,msg):
 count+=1
 if not ok:failures.append(msg)
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host)
 var g=host.get_child(0).get_child(0);var play=g.handworks.workshop;var L=play.L
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.set_process(false);g.transition_left=0;g.loading_view._process(1);g.loading_view._process(1)
 var r=play.room();var forge={}
 for f in r.pieces.values():
  if f.kind=="forge":forge=f
 check(g.zone=="claim" and not forge.is_empty(),"Outdoor workshop resumed")
 var origin=L.cell(forge)
 var lane=load("res://assets/timber_wing/claim_path.gd")
 var off_road=true
 for f in r.pieces.values():
  for n in L.side(f,Vector2i.DOWN):off_road=off_road and not lane.on_lane(L.center(n-Vector2i.DOWN))
 for k in r.flags:
  var xy=k.split(",");off_road=off_road and not lane.on_lane(L.center(Vector2i(int(xy[0]),int(xy[1]))))
 check(off_road,"Workshop and approach leave road unobstructed")
 check(L.neighbors(forge,r,play.wall).back.is_empty(),"A freestanding forge has no wall socket")
 check(not g.surface.walkable(L.anchor(forge)),"Raised hearth blocks feet")
 g.player=L.center(origin+Vector2i(2,1));play.tick()
 play.pick("table");var cell=origin+Vector2i(1,2)
 var paid=g.state.count("wood");play.click(cell)
 check(L.on_cell(r,cell).get("kind","")=="table" and g.state.count("wood")==paid-3,"Paid outdoor placement")
 play.pick("lift");play.click(cell)
 check(L.on_cell(r,cell).is_empty() and g.state.count("wood")==paid,"Lifted and refunded on the claim")
 g.player=L.center(origin+Vector2i(1,1));var iron=g.state.count("iron")
 var key=InputEventKey.new();key.keycode=KEY_E;key.pressed=true;g._unhandled_input(key)
 check(g.state.count("iron")==iron+1,"Outdoor E smelts")
 g.state.tech.erase("furnishings")
 check(not play.unlocked("chair") and play.reason(L.record("chair",cell,0)).contains("Research"),"New chair respects technology")
 g.state.tech["furnishings"]=true
 var board=g.deep.world.depth()
 g.save_game();g.start_game(true);g.set_process(false)
 check(g.handworks.workshop.room().get("pieces",{}).size()==4 and g.state.count("iron")==iron+1,"Claim restores without duplicating the sample")
 print("YARD ",count," checks. Failures ",failures);quit(0 if failures.is_empty() else 1)
