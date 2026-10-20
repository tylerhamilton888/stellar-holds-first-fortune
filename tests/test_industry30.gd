extends SceneTree
var passed=0
var failed=0
func check(ok:bool,message:String):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func supply(s):
 s.money=10000
 for k in HoldData.ITEMS:s.add(k,200)
func wall(kind:int)->Geology:
 var geo=Geology.new();geo.cells.resize(Geology.W*Geology.H);geo.cells.fill(0)
 for y in range(30,48):
  for x in range(35,45):geo.set_cell(Vector2i(x,y),kind)
 return geo
func _initialize():call_deferred("run")
func run():
 var s=HoldState.new();s.reset(3001);supply(s)
 check(HoldIndustry.tier(s)==0 and HoldIndustry.production(s)==1,"Legacy state starts without free machinery")
 check(not HoldIndustry.install(s,"claim"),"Requires claim workshop")
 s.claim_id="old_delving";s.camp_stage=2
 check(not HoldIndustry.install(s,"claim"),"Requires research")
 s.tech.automation=true
 var iron=s.count("iron");var money=s.money
 check(HoldIndustry.install(s,"claim"),"Powered installation succeeds")
 check(s.count("iron")==iron-10 and s.money==money-75,"Installation consumes exact materials and money")
 check(HoldIndustry.production(s)==1.5,"Powered throughput bonus")
 s.queue=[{"id":"iron","left":3.0}];s.tick(1)
 check(is_equal_approx(s.queue[0].left,1.5),"Actual production receives machinery speed")
 check(not HoldIndustry.build_gun(s),"Thermal research required for gun")
 s.tech.thermal=true
 check(HoldIndustry.build_gun(s),"Fabricate gun")
 money=s.money;check(not HoldIndustry.build_gun(s) and money==s.money,"Duplicate gun cannot consume materials")
 s.tech.voidcraft=true
 check(not HoldIndustry.install(s,"claim"),"Engineering gated by freight and first keel")
 s.camp_stage=3;s.ship_stage=1
 check(HoldIndustry.install(s,"claim"),"Engineering benchmark unlocks installation")
 check(HoldIndustry.production(s)==2,"Engineering doubles production")
 var stage=HoldIndustry.ship_stage(s,2)
 check(stage.cost.assembly==3 and stage.cost.water==8 and stage.money==150,"Material savings round up, crowns unchanged")
 check(HoldData.SHIP[2].cost.water==10,"Shared ship definitions never mutate")
 money=s.money;check(not HoldIndustry.install(s,"claim") and money==s.money,"Maximum tier cannot consume money")
 check(not HoldIndustry.install(s,"hold"),"Hold restoration independent")
 s.opening=4
 check(HoldIndustry.install(s,"hold") and HoldIndustry.tier(s,"hold")==1,"Separate town upgrade")
 check(HoldIndustry.production(s)==2,"Town and claim speed do not multiply")
 var geo=wall(7);var origin=Vector2(150,270);var aim=Vector2(330,270)
 s.outpost.gun_charge=0;s.inventory.energy_cell=2
 var result=HoldMiningGun.fire(s,geo,origin,aim)
 check(not result.has("error") and s.count("energy_cell")==1 and s.outpost.gun_charge==23,"Advanced cell loads once and consumes one pulse")
 check(geo.at(35,38)==0 and geo.at(36,38)==7,"Basalt melts but single pulse cannot tunnel through next layer")
 var charge=s.outpost.gun_charge
 result=HoldMiningGun.fire(s,geo,Vector2(100,100),Vector2(200,100))
 check(result.has("error") and s.outpost.gun_charge==charge,"Empty air consumes no energy")
 for kind in [8,10,12,13]:
  geo=wall(kind);charge=s.outpost.gun_charge
  result=HoldMiningGun.fire(s,geo,origin,aim)
  check(result.has("error") and geo.at(35,38)==kind and s.outpost.gun_charge==charge,"Protected contact stops beam: "+str(kind))
 geo=wall(3);charge=s.outpost.gun_charge
 result=HoldMiningGun.fire(s,geo,Vector2(235,270),aim)
 check(result.has("error") and s.outpost.gun_charge==charge,"Wall overlapping muzzle cannot be shot through")
 result=HoldMiningGun.fire(s,geo,Vector2(10,270),aim)
 check(result.has("error") and s.outpost.gun_charge==charge,"Cannot exceed 180 pixel reach")
 for kind in [3,4,5,6,9]:
  geo=wall(kind);result=HoldMiningGun.fire(s,geo,origin,aim)
  check(not result.has("error"),"Thermal cut works: "+str(kind))
  for r in result.results:
   if kind in [3,4]:check(r.item==("iron_slag" if kind==3 else "copper_slag"),"Metal returns slag")
   elif kind in [5,9]:check(r.count==0 and r.grains==0,"Coal and roots destroyed without yield")
   elif kind==6:check(r.grains==1,"Crystal yields half a fine pick cut")
 s.outpost.gun_charge=0;s.inventory.energy_cell=0;geo=wall(2)
 check(HoldMiningGun.fire(s,geo,origin,aim).has("error") and geo.at(35,38)==2,"No free extraction without cells")
 s.outpost.industry_claim=1;s.outpost.industry_hold=0;s.inventory.energy_cell=1
 check(not HoldMiningGun.fire(s,geo,origin,aim).has("error") and s.outpost.gun_charge==15,"Standard cell gives sixteen pulses")
 s.queue=[];s.inventory.energy_cell=0
 check(s.craft("energy_cell"),"Energy recipe queues")
 s.tick(10)
 check(s.count("energy_cell")==3,"Energy cell recipe yields three")
 s.queue=[];s.inventory.iron_slag=2;s.inventory.water=1;iron=s.count("iron")
 check(s.craft("iron_slag"),"Quench slag recipe")
 s.tick(10);check(s.count("iron")==iron+1 and s.count("water")==0,"Slag becomes ingot using coolant")
 s.outpost.gun_charge=7
 check(s.save_world(geo,"mine",origin),"Save succeeds")
 var loaded=HoldState.new();var restored=Geology.new();loaded.load_world(restored)
 check(loaded.outpost.mining_gun and int(loaded.outpost.gun_charge)==7 and HoldIndustry.tier(loaded)==1,"Gun, remaining charge and local machinery persist")
 print("INDUSTRY30: %d passed; %d failed" % [passed,failed]);quit(1 if failed else 0)
