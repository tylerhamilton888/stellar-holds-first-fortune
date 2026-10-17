extends SceneTree
var checks=0
var failures=0
func check(value:bool,message:String):
 checks+=1
 if not value:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var g=Geology.new();g.generate(27419)
 var same=Geology.new();same.generate(27419)
 check(g.cells==same.cells,"Identical seed gives identical geology")
 same.generate(27420);check(g.cells!=same.cells,"Different worlds differ")
 check(g.mountain.surface[0]>g.mountain.surface[85]+25,"Mountain rises above trail")
 check(g.mountain.caves.size()==10,"Natural cave network generated")
 check(g.at(47,50)==1,"Adit ends in diggable overburden")
 check(g.at(35,58)==5,"Opening coal commission accessible beneath adit")
 check(g.at(31,56) not in [0,12] and g.at(42,56) not in [0,12],"Starter support feet are grounded")
 var soil=0;var traces=0
 for y in range(20,80):
  for x in range(12,100):
   if g.at(x,y)!=1:continue
   var c=Vector2i(x,y);var result=g.strike(c,100)
   if result.is_empty():continue
   soil+=1
   if not g.prospect(c).is_empty():traces+=1
   check(g.strike(c,100).is_empty(),"Consumed dirt cannot be mined repeatedly")
 check(soil>100 and traces>5,"Sifting overburden yields nearby mineral traces")
 var restored=Geology.new();restored.restore(g.snapshot())
 check(restored.cells==g.cells and restored.grain_bank==g.grain_bank,"Excavations and fractional traces persist")
 check(restored.structures==g.structures,"Grounded support metadata persists")
 var state=HoldState.new();state.reset(27419);state.ensure_dynasty()
 check(not state.dynasty.founded,"Character begins before a dynasty is founded")
 for gender in 2:
  for design in 5:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=design;p=HoldAppearance.normalized(p)
   check(p.sculpt==design,"All ten designs survive normalization")
   if gender:check(p.beard_style==5,"Women have no facial hair")
   for frame in 16:
    var sockets=HoldEquipmentRig.sockets(p,frame)
    check(sockets.hand.is_finite() and sockets.head.y<sockets.chest.y,"Pose equipment sockets are ordered and finite")
 print("MOUNTAIN18: %d checks, %d failures"%[checks,failures]);quit(1 if failures else 0)
