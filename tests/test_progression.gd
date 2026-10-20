extends SceneTree
# A deterministic economy integration test. Mining travel and waits are accelerated;
# nothing is granted. All materials come from terrain, trees, pump, or paid trades.
var s=HoldState.new()
var g=Geology.new()
var blocks=0
var strikes=0
var manufactured=0
var failed=false
func _initialize():call_deferred("run")
func ensure_resource(item:String,amount:int):
 if failed:return
 if s.count(item)>=amount:return
 if HoldData.RECIPES.has(item):
  var r=HoldData.RECIPES[item]
  if r.tech!="" and not s.tech.has(r.tech):
   push_error("Locked recipe needed: "+item);failed=true;return
  while s.count(item)<amount and not failed:
   for k in r.cost:ensure_resource(k,r.cost[k])
   if not s.craft(item):push_error("Craft failed: "+item);failed=true;return
   s.tick(r.time+.1);manufactured+=1
 elif item=="water":
  # Public well, same six-canteen batches as the home interaction.
  while s.count(item)<amount:s.add("water",6)
 elif item=="wood":
  var chopped=false
  for i in s.trees.size():
   while s.trees[i]>0 and s.count(item)<amount:s.trees[i]-=1;s.add("wood",2);chopped=true
  if not chopped or s.count(item)<amount:
   while s.count(item)<amount:
    ensure_money(s.price("wood",true))
    if not s.trade("wood",true):failed=true;return
 else:
  var tries=0
  while s.count(item)<amount and tries<24000:
   tries+=1
   var route=g.route(g.cell_at(Vector2(150,370)),item)
   if route.is_empty():push_error("No exposed resources for "+item);failed=true;return
   var result={}
   while result.is_empty():
    result=g.strike(route.target,2.7 if s.steel else 1.4);strikes+=1
   s.add(result.item,result.count);blocks+=1
  if s.count(item)<amount:failed=true;push_error("Cannot source "+item)
func ensure_money(amount:int):
 while s.money<amount and not failed:
  var cost={"stone":20,"wood":6} if s.contract%2==0 else {"iron_ore":12,"copper_ore":8}
  for k in cost:ensure_resource(k,cost[k])
  if not s.pay(cost):failed=true;return
  s.money+=100 if s.contract%2==0 else 150
  s.contract+=1
func afford(cost:Dictionary,crowns:int):
 ensure_money(crowns)
 var keys=cost.keys();keys.reverse()
 for k in keys:ensure_resource(k,cost[k])
func run():
 s.reset(27419);g.generate(27419)
 s.opening=1
 for job in HoldCampaign.JOBS:
  for item in job.cost:ensure_resource(item,job.cost[item])
  if not s.finish_commission():failed=true;push_error("Commission failed")
  print("Completed commission: "+job.name)
 if not s.buy_charter("old_delving"):failed=true;push_error("Cannot afford earned charter")
 s.switch_site("claim",g)
 for stage_index in range(s.camp_stage,3):
  if stage_index==2:
   var r=HoldData.RESEARCH.metallurgy
   afford(r.cost,r.money)
   if not s.research("metallurgy"):failed=true
  var stage=HoldCampaign.CAMP[stage_index]
  afford(stage.cost,stage.money)
  if not s.build_camp():failed=true;push_error("Founding stage failed")
 print("Independent hold founded from earned materials")
 for research in ["extraction","metallurgy","automation"]:
  if s.tech.has(research):continue
  var r=HoldData.RESEARCH[research]
  afford(r.cost,r.money)
  if not s.research(research):failed=true;push_error("Research path failed")
  print("Researched "+research+" from earned materials")
  if research=="extraction":
   afford({"iron":5,"wood":2},0);s.pay({"iron":5,"wood":2});s.steel=true
 afford({"food":4},70);s.pay({"food":4},70);s.worker=true
 afford({"parts":6,"copper":2},60);s.pay({"parts":6,"copper":2},60);s.automaton=true
 for stage in HoldData.SHIP:
  afford(stage.cost,stage.money)
  if not s.pay(stage.cost,stage.money):failed=true;push_error("Ship stage failed")
  s.ship_stage+=1;print("Built "+stage.name)
 print("RESULT: %s / %d blocks / %d impacts / %d forge jobs / %d contracts / %d crowns left" % ["FAILED" if failed else "COMPLETE",blocks,strikes,manufactured,s.contract,s.money])
 quit(1 if failed else 0)
