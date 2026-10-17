extends SceneTree
var failures=0
var checks=0
func check(ok:bool,label:String):
 checks+=1
 if not ok:failures+=1;push_error(label)
func _initialize():
 for value in [27419,12345,67890,4511,9527,14213,99999,10000]:
  var g=Geology.new();g.generate(value)
  var same=Geology.new();same.generate(value)
  check(g.cells==same.cells,"Seed reproduces geology")
  same.generate(value+1);check(g.cells!=same.cells,"New seed changes geology")
  var counts={}
  for k in g.cells:counts[k]=counts.get(k,0)+1
  for k in range(11):check(counts.get(k,0)>0,"Every material exists: %d" % k)
  for x in Geology.W:check(g.at(x,Geology.H-1)==8,"Bottom boundary intact")
  for y in Geology.H:check(g.at(0,y)==8 and g.at(Geology.W-1,y)==8,"Side boundary intact")
  check(not g.solid(Vector2(150,370)) and not g.solid(Vector2(150,310)),"Full-height safe arrival")
  for kind in [9,10]:
   var index=g.cells.find(kind)
   var cell=Vector2i(index%Geology.W,index/Geology.W)
   check(g.at(cell.x,cell.y)==kind,"Starter cavern contains gathering deposit")
   var result=g.strike(cell,99)
   check(g.at(cell.x,cell.y)==0 and result.grains==3,"Gathering removes deposit and yields supplies")
   check(g.strike(cell,99).is_empty(),"Depleted deposit cannot duplicate supplies")
  # A mined wall opens a real traversable passage; damage is persistent per tile.
  g.cells[12*Geology.W+19]=2
  var target=Vector2i(19,12)
  check(g.strike(target,.5).is_empty() and g.damage.has(g.key(target)),"Partial damage accumulates")
  check(not g.strike(target,99).is_empty() and g.at(19,12)==0,"Wall can be breached")
  var route=g.route(g.cell_at(Vector2(150,370)),"food")
  check(not route.is_empty(),"Gathering reachable by excavation route")
 print("%d GEOLOGY CHECKS / %d FAILED" % [checks,failures]);quit(1 if failures else 0)
