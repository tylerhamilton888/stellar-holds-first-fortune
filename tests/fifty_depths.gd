extends SceneTree
# Start with the prior quarry preview's five-floor slot, with four stairs at (9,9).
var game
var world
var checks=0
var failures=0
var report=[]
func verify(ok:bool,description:String):
 checks+=1
 if not ok:
  failures+=1
  push_error(description)

func _initialize():call_deferred("run")

func run():
 var tree=load("res://furrow/start.tscn").instantiate()
 root.add_child(tree)
 game=tree.get_child(0).get_child(0);game.set_process(false)
 world=game.deep.world
 var c=Vector2i(9,9)
 var original=world.layer(4).cells.duplicate()
 var original_links=world.data.links.duplicate(true)
 var old_count=world.data.layers.size()
 verify(world.depth()==4 and old_count in [5,8],"legacy save opens at depth 5")
 verify(world.layer(4).fixtures.has("11,9") and world.layer(3).damage.has("16,17"),"old fixtures and fractures")
 var S=load("res://scripts/claim_strata.gd")
 var gates={6:"steel pick",12:"Stoneworking",21:"reinforced pick",31:"powered workshop",41:"sealed engineering bay"}
 var seam=""
 var material_count=0
 var alias_floor=[]
 for n in range(6,51):
  var at=world.depth()
  if gates.has(n):
   var before=world.data.layers.size()
   for kind in ["ladder","stair"]:
    verify(gates[n] in world.carve_stairs(c,kind),"gate "+str(n)+" "+kind)
   verify(world.prepare_below(at)<0 and not world.traverse(c,false),"survey and travel blocked")
   verify(world.data.layers.size()==before,"locked floor was never allocated")
   match n:
    6:game.state.steel=true
    12:
     game.state.tech.stoneworking=true
     verify("workshop" in world.carve_stairs(c),"research alone cannot supply braces")
     game.state.camp_stage=2
    21:game.state.outpost.reinforced_pick=true
    31:
     game.state.tech.automation=true
     verify("powered workshop" in world.carve_stairs(c),"automation plans alone cannot supply power")
     game.state.outpost.industry_claim=1
    41:
     game.state.tech.voidcraft=true
     verify("sealed engineering bay" in world.carve_stairs(c),"engineering plans alone cannot seal the shaft")
     game.state.outpost.industry_claim=2
  var lower=world.prepare_below(at)
  verify(lower==S.slot(n),"survey reaches requested level")
  var size_before=world.data.layers.size()
  verify(world.prepare_below(at)==lower and size_before==world.data.layers.size(),"repeat survey stable")
  var why=world.carve_stairs(c)
  verify(world.can_descend(c,at),"could not cut stairs D"+str(n)+" "+why)
  game.deep.use_stairs(false)
  verify(world.depth()==lower,"gameplay descend D"+str(n))
  if world.depth()!=lower:break
  if n==6:
   alias_floor=world.layer(5).cells.duplicate()
   verify(world.below(5)<0 and world.below(6)<0 and world.below(7)<0,"annexes stay lateral")
   if old_count==8:verify(world.layer(6).fixtures.has("40,25") and world.data.mineworks143.bridge,"existing annex edits retained")
  if n<=10:
   var y=9
   var face=Vector2i(-1,-1)
   for x in range(20,43):
    var pt=Vector2i(x,y)
    if world.at(pt)==3 and world.formation(pt).get("id","")=="3:seam1":face=pt;break
   verify(face.x>0,"could follow the same iron seam on D"+str(n))
   if n==10 and face.x>0:
    # Drive a heading from the landing, mine the seam, and put this actual
    # load in the player's hauling bucket for the trip home.
    for x in range(c.x+1,face.x+1):
     var point=Vector2i(x,y)
     var result={}
     for hit in 20:
      if world.at(point)==0:break
      result=world.strike(point,-1,false,false)
     if point==face:
      verify(result.get("item","")=="iron_ore","iron recovered")
      material_count=int(result.count)
      game.deep.haul.collect(result.item,material_count,world.center(point))
    var pre=int(game.state.inventory.get("iron_ore",0))
    game.save_game();game.start_game(true);game.set_process(false);world=game.deep.world
    verify(world.depth()==lower and world.at(face)==0,"reload at mined seam on D10")
    for up in 9:game.deep.use_stairs(true)
    verify(world.depth()==0,"return all the way home")
    game.deep.haul.unload(game.player)
    verify(material_count>0 and int(game.state.inventory.get("iron_ore",0))==pre+material_count,"ore delivered to hold stores")
    for down in 9:game.deep.use_stairs(false)
    verify(world.depth()==lower,"return to the saved heading")
  if S.SITES.has(n):
   var site=world.layer().features[0]
   var p=world.center(Vector2i(site.x,site.y))+Vector2(0,76)
   var id=site.salvage.keys()[0]
   var amount=int(game.state.inventory.get(id,0))
   world.survey(p)
   verify(site.found and int(game.state.inventory.get(id,0))==amount+int(site.salvage[id]),"find "+str(site.name))
   world.survey(p)
   verify(int(game.state.inventory.get(id,0))==amount+int(site.salvage[id]),"salvage once")
   report.append([n,site.name])
 verify(world.depth()==S.slot(50) and world.prepare_below(world.depth())==-1,"bottom at D50")
 verify(not world.traverse(c,false),"bedrock cannot be crossed")
 verify(PackedInt32Array(world.layer(4).cells)==PackedInt32Array(original) and PackedInt32Array(world.layer(5).cells)==PackedInt32Array(alias_floor),"upper terrain and side mine cells retained")
 for key in original_links:verify(world.data.links.has(key),"historic travel links")
 game.depth_nav.open_map();game.close_panel()
 game.save_game();game.start_game(true);game.set_process(false);world=game.deep.world
 verify(world.depth()==S.slot(50) and world.layer().features[0].found,"bottom and throne room persist")
 print("50 DEPTHS ",checks," checks ",failures," failures | iron delivered ",material_count," | ",report)
 quit(1 if failures else 0)
