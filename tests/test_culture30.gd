extends SceneTree
var passed=0
var failed=0
func check(ok:bool,message:String):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var s=HoldState.new();s.reset(3002)
 for gender in 2:
  s.appearance.gender=gender
  var expected="She brought her pick herself; the claim is hers." if gender else "He brought his pick himself; the claim is his."
  check(HoldCulture.render(s,"{player:Subject} brought {player:possessive} pick {player:reflexive}; the claim is {player:own}.")==expected,"Player grammar: "+str(gender))
  check(HoldCulture.charter_reference(s).contains("She delivered" if gender else "He delivered"),"Reference resolves player gender")
  for id in HoldOutpost.CREW:
   var female=int(s.npc(id).gender)==1
   check(HoldCulture.render(s,"{"+id+":Subject} brought {"+id+":possessive} tools.")==("She brought her tools." if female else "He brought his tools."),"NPC reference follows subject: "+id)
  s.outpost.culture={"count":0,"last":-3,"seen":{},"active":{},"errand":{},"done":false}
  var last=-100;var number=0
  var ids=HoldCulture.REACTIONS.keys()
  for i in 40:
   var id=ids[i%ids.size()]
   HoldOutpost.line(s,id,true)
   var cursor=int(s.outpost.talk[id]);var line=HoldOutpost.line(s,id)
   var aside=HoldCulture.aside(s,id,cursor)
   if aside!="":
    number+=1;check(i-last>=8,"Cultural reactions spaced across all speakers");last=i
    check(line==HoldCulture.REACTIONS[id][gender],"Correct male/female authored reaction")
    var count=s.outpost.culture.count
    for j in 5:check(HoldOutpost.line(s,id)==line,"Rerender keeps stable line")
    check(s.outpost.culture.count==count,"Menu previews do not advance cultural timer")
  check(number>=3 and number<=5,"Occasional reactions, not constant commentary")
  s.outpost.culture.errand={};s.outpost.culture.done=false;s.opening=1
  check(not HoldCulture.accept(s),"Social errand follows first paid shift")
  s.opening=2
  check(HoldCulture.accept(s),"Social errand can be accepted")
  var id=s.outpost.culture.errand.id;var quest=HoldCulture.ERRANDS[id]
  check(id==("bench" if gender else "freight"),"Different early social path")
  check(not HoldCulture.accept(s),"No duplicate acceptance")
  s.inventory={}
  check(not HoldCulture.complete(s,quest.host),"Cannot deliver missing materials")
  for k in quest.cost:s.add(k,quest.cost[k])
  check(not HoldCulture.complete(s,"wrong_host"),"Delivery must be to correct dwarf")
  s.appearance.gender=1-gender
  check(s.outpost.culture.errand.id==id and not HoldCulture.accept(s),"Changing appearance cannot reroll or duplicate errand")
  check(not HoldCulture.introduction(s,id).contains("A woman"),"Accepted errand intro adapts if appearance changes")
  check(HoldCulture.complete(s,quest.host),"Complete social errand")
  check(s.bargain>=180,"Real trading benefit awarded")
  for k in quest.reward:check(s.count(k)==quest.reward[k],"Correct tangible reward: "+k)
  check(HoldCulture.completion_line(s,id).contains("her" if s.appearance.gender else "his"),"Completion resolves current player pronouns")
  var bank=s.inventory.duplicate()
  check(not HoldCulture.complete(s,quest.host) and s.inventory==bank,"One reward per fortune")
 var geo=Geology.new();geo.generate(3002)
 s.outpost.chronicle.append({"minute":0,"text":"Yrsa Cinderlace worked the crew's first Iron ore seam under their assignment."})
 s.outpost.chronicle.append({"minute":0,"text":"Brann Rivethand worked the crew's first Iron ore seam under their assignment."})
 check(s.save_world(geo,"hub",Vector2(150,410)),"Save cultural state")
 var loaded=HoldState.new();loaded.load_world(Geology.new())
 check(loaded.outpost.culture.done and loaded.outpost.culture.errand.id=="bench","Errand branch and completion persist")
 check(loaded.outpost.culture.count==s.outpost.culture.count and loaded.outpost.culture.seen==s.outpost.culture.seen,"Reaction cooldown and seen speakers persist")
 check(loaded.outpost.chronicle[-2].text.ends_with("her assignment.") and loaded.outpost.chronicle[-1].text.ends_with("his assignment."),"Legacy singular references repaired without touching plural text")
 print("CULTURE30: %d passed; %d failed" % [passed,failed]);quit(1 if failed else 0)
