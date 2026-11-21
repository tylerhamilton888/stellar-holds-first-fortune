extends SceneTree
func _initialize():call_deferred("test")
func test():
 var game=load("res://furrow/start.tscn").instantiate();root.add_child(game)
 var S=load("res://scripts/claim_strata.gd")
 var cases=0;var failed=0
 for seed_no in [17612,42,512903,33178,7941,52829,11,7812]:
  for n in range(6,51):
   var a=S.make_layer(seed_no,n)
   var b=S.make_layer(seed_no,n)
   if a!=b or a.cells.size()!=5120 or a.strata.size()!=5120:failed+=1
   if S.SITES.has(n) and a.features.size()!=1:failed+=1
   for x in 80:
    if a.cells[x]!=8 or a.cells[63*80+x]!=8:failed+=1
   for y in 64:
    if a.cells[y*80]!=8 or a.cells[y*80+79]!=8:failed+=1
   cases+=1
 print("Seed validation: ",cases," floors; errors=",failed);quit(1 if failed else 0)
