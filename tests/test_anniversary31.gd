extends SceneTree
var passed=0
var failed=0
func check(value:bool,message:String):
 if value:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var totals=[]
 for gender in 2:
  var s=HoldState.new();s.reset(3100+gender);s.appearance.gender=gender
  check(not HoldAnniversary.accept(s,"hedrik"),"Requires first shift")
  s.opening=2
  check(HoldAnniversary.status(s,"hedrik")=="offer","Available marker")
  var total={}
  for id in ["orla","hedrik"]:
   check(HoldAnniversary.accept(s,id,true),"Each spouse offers a quest")
   check(not HoldAnniversary.accept(s,id,true),"No duplicate acceptance")
   check(HoldAnniversary.status(s,id)=="active","Preparation required")
   check(not HoldAnniversary.deliver(s,id,true),"No unprepared delivery")
   check(not HoldAnniversary.prepare(s,id,3,true),"Invalid choice rejected")
   check(HoldAnniversary.prepare(s,id,2,true),"Choice saved")
   var cost=HoldAnniversary.cost(gender,id)
   s.inventory={}
   check(not HoldAnniversary.deliver(s,id,true),"Cannot deliver without supplies")
   for k in cost:s.add(k,cost[k]);total[k]=total.get(k,0)+cost[k]
   check(HoldAnniversary.status(s,id)=="ready","Ready marker uses actual inventory")
   check(not HoldAnniversary.deliver(s,id,false),"Remote hand-in forbidden")
   s.appearance.gender=1-gender
   check(HoldAnniversary.gift(s,id).gender==gender,"Route locked through appearance changes")
   check(HoldAnniversary.deliver(s,id,true),"Valid delivery")
   check(s.inventory.values().all(func(x):return x==0),"Exact cost charged")
   check(not HoldAnniversary.deliver(s,id,true),"Cannot pay twice")
   s.appearance.gender=gender
  totals.append(total)
  check(HoldAnniversary.ready(s),"Either gift order reaches ceremony")
  check(HoldAnniversary.status(s,"hedrik")=="ready","Ceremony marker on Hedrik")
  var money=s.money
  check(HoldAnniversary.finish(s),"Finish or skip rewards")
  check(s.money==money+50 and s.count("food")==4,"Equal reward")
  check(not HoldAnniversary.finish(s),"Replay does not duplicate rewards")
  check(HoldAnniversary.status(s,"orla")=="","Completed marker clears")
  check(HoldAnniversary.refill(s),"First flask")
  check(not HoldAnniversary.refill(s),"No infinite provisions")
  s.elapsed+=1200
  check(HoldAnniversary.refill(s),"Play-time cooldown")
  var geo=Geology.new();geo.generate(3100);s.save_world(geo,"hub",Vector2(475,410))
  var restored=HoldState.new();restored.load_world(Geology.new())
  check(HoldAnniversary.ensure(restored).complete,"Completion persists")
  check(HoldAnniversary.gift(restored,"orla").choice==2,"Carving persists")
  check(not HoldAnniversary.refill(restored),"Refill cooldown persists")
 check(totals[0]==totals[1],"Exact material parity across player genders")
 var s=HoldState.new();s.reset(3102)
 check(HoldQuestMarkers.status(s,"ivar")=="offer","Opening commission marker")
 s.opening=1;s.add("coal",8)
 check(HoldQuestMarkers.status(s,"ivar")=="ready","Commission ready marker")
 s.opening=4
 check(HoldQuestMarkers.status(s,"ivar")=="offer","Finished commissions leave the new return-route lesson available")
 HoldOnboarding.ensure(s).done.route=true
 check(HoldQuestMarkers.status(s,"ivar")=="","All Ivar work complete clears marker")
 check(HoldNpcActivity.smith_frame(.85)==4,"Hammer contact pose")
 check(HoldNpcActivity.smith_frame(6)==-1,"Smith takes inspection pauses")
 check(HoldNpcActivity.struck_between(.79,.81),"Audio on contact")
 check(not HoldNpcActivity.struck_between(.81,.89),"No duplicate contact audio")
 check(not HoldNpcActivity.struck_between(5,5.1),"No hammer audio during rest")
 print("ANNIVERSARY31: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
