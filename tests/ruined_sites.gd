extends SceneTree

# Run in an isolated data directory with the court sample.
var failures=0
var checks=0
func verify(ok:bool,where:String):
 checks+=1
 if not ok:failures+=1;push_error(where)
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host)
 var game=host.get_child(0).get_child(0);game.set_process(false)
 var s=load("res://scripts/claim_strata.gd")
 for seed_value in [42,5343,231,7911,2167,33178,7941,52829]:
  for n in [36,50]:
   var l=s.make_layer(seed_value,n)
   var f=l.features[0]
   verify(l==s.make_layer(seed_value,n),"seed determinism")
   var base=Vector2i(f.x,f.y)
   for loc in ([Vector2i(0,8),Vector2i(-9,-3),Vector2i(8,1),Vector2i(0,2)] if n==50 else [Vector2i(-6,2),Vector2i(2,3),Vector2i(0,-2)]):
    var c=base+loc;verify(l.cells[c.y*80+c.x]==0,"generated route "+str(c))
   var modified=base+Vector2i(1,1)
   var idx=modified.y*80+modified.x
   l.cells[idx]=2;l.damage["%d,%d"%[modified.x,modified.y]]=1.5
   f.erase("court_plan");f.erase("regulator_plan");f.found=true
   if n==50:s.Court.install(l,f)
   else:s.Court.Regulator.install(l,f)
   verify(l.cells[idx]==2 and f.found,"previous fracture and discovery retained")
   l.cells[idx]=0
   if n==50:s.Court.install(l,f)
   else:s.Court.Regulator.install(l,f)
   verify(l.cells[idx]==0,"excavation retained")
 var w=game.deep.world
 var f=w.layer().features[0]
 var base=w.center(Vector2i(f.x,f.y))
 var blocked={"p":base+Vector2(-360,95),"half":Vector2(64,28)}
 var parts=s.Court.furniture(w,w.depth(),f,[blocked])
 verify(not "mess" in parts.map(func(part):return part.prop),"existing construction keeps its space")
 print("RUINED SITES: ",checks," checks, ",failures," failures")
 quit(1 if failures else 0)
