extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var passed=0
var failed=0
func check(ok:bool,label:String):
 if ok:passed+=1
 else:failed+=1;push_error(label)
func strings(node:Node)->String:
 var result=""
 if node is Label or node is Button:result+=node.text+"\n"
 for child in node.get_children():result+=strings(child)
 return result
func _initialize():call_deferred("run")
func run():
 for gender in 2:
  for order in [["hedrik","orla"],["orla","hedrik"]]:
   var s=HoldState.new();s.reset(390);s.opening=2;s.appearance.gender=gender
   check(not HoldAnniversary.accept(s,order[0]),"Remote acceptance denied")
   for id in order:
    check(HoldAnniversary.accept(s,id,true),"Local host accepts own gift")
    check(not HoldAnniversary.accept(s,id,true),"No duplicate acceptance")
    check(not HoldAnniversary.prepare(s,id,0,false),"No remote preparation")
    check(HoldAnniversary.prepare(s,id,0,true),"Prepare gift")
    for k in HoldAnniversary.cost(gender,id):s.add(k,HoldAnniversary.cost(gender,id)[k])
    check(not HoldAnniversary.deliver(s,id,false),"No remote hand-in")
    check(HoldAnniversary.deliver(s,id,true),"Deliver locally")
    if id==order[0]:check(HoldAnniversary.ensure(s).inviter=="","First delivery reveals no second gift or invitation")
   check(HoldAnniversary.ensure(s).inviter==order[1],"Second host invites in either order")
   check(HoldAnniversary.status(s,order[1])=="ready" and HoldAnniversary.status(s,order[0])=="","Marker follows inviter")
   var money=s.money
   check(HoldAnniversary.finish(s) and s.money==money+50,"Single ceremony reward")
   check(not HoldAnniversary.finish(s),"Replay cannot duplicate reward")
   check(HoldAnniversary.invitation(s,order[1])!=HoldAnniversary.invitation(s,order[0]),"Host-specific invitation")
 # A fixed grip projects to the exact drawn palm at every pose, direction and aim.
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt})
   for f in 8:
    for face in [-1,1]:
     for length in [8.0,20.0,36.0]:
      var hand=HoldCharacterArt.work_hand(f,p)*Vector2(face,1)
      var end=hand+Vector2(face*length,-12)
      var trans=HoldCharacterArt.tool_transform(hand,end,0,face)
      var offset=HoldCharacterArt.TOOL_GRIPS[0]-HoldCharacterArt.tool_grip(0,length)
      check((trans*offset).distance_to(hand)<.001,"Tool grip remains in fist")
      check(is_equal_approx(trans.get_scale().length(),sqrt(2.0)*36.0/(HoldCharacterArt.TOOL_CONTACTS[0]-HoldCharacterArt.TOOL_GRIPS[0]).length()),"Tool never stretches")
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.state.opening=2
 var q=HoldOnboarding.ensure(g.state);q.stage=6
 g.room_id="commission";g.player=Vector2(600,410);g.zone="hub";g.state.active_site="hold"
 HoldConversation.start(g,"ivar")
 var text=strings(g.panel)
 check(not text.contains("kettle") and not text.contains("secrets") and not text.contains("Anniversary"),"Ivar conversation does not reveal spouse gifts")
 g.open_panel("guidance");text=strings(g.panel)
 check(not text.contains(HoldAnniversary.NAMES.hedrik) and not text.contains(HoldAnniversary.NAMES.orla),"Undiscovered gifts absent from journal")
 g.anniversary_host="orla";g.open_panel("anniversary");text=strings(g.panel)
 check(not text.contains("I'll help") and not text.contains("eight years"),"Remote secret panel cannot offer or reveal quest")
 g.room_id="market";g.open_panel("anniversary");text=strings(g.panel)
 check(text.contains("I'll help") and not text.contains("kettle") and not text.contains("both"),"Orla offers only own secret")
 HoldAnniversary.accept(g.state,"orla",true);g.open_panel("guidance");text=strings(g.panel)
 check(text.contains(HoldAnniversary.NAMES.orla) and not text.contains(HoldAnniversary.NAMES.hedrik),"Journal records only known gift")
 g.room_id="";check(not HoldAnniversary.local_host(g,"orla"),"No outdoor Orla duplicate")
 g.close_panel();g.state.hold_travel={};g.state.region_travel={};g.open_panel("world_map");var m=g.overworld;m.set_process(false)
 for tier in 3:
  var seen={};var queue=[Vector2i(55,49)];seen[queue[0]]=true;var cursor=0
  while cursor<queue.size():
   var cell=queue[cursor];cursor+=1
   for offset in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
    var next=cell+offset
    if not seen.has(next) and HoldFloorPlan.walkable(Vector2(next)*16,tier):seen[next]=true;queue.append(next)
  for i in HoldDistrictMap.DOORS:
   if i/7!=tier:continue
   var p=HoldFloorPlan.door(i)
   check(HoldFloorPlan.walkable(p,tier),"Door footing clear: "+str(i))
   check(seen.has(Vector2i((p/16).round())),"Connected floor route: "+str(i))
  for i in ([2,5,6] if tier==0 else [10,11,13] if tier==1 else [16,19,20]):
   check(seen.has(Vector2i((HoldFloorPlan.point(i)/16).round())),"Connected stair/lift landing: "+str(i))
 m.change_floor(10);m.enter_location();check(m.level==0,"Royal stair goes up")
 m.enter_location();check(m.level==1,"Royal stair returns")
 m.change_floor(11);m.enter_location();check(m.level==2,"Forge stair goes down")
 m.change_floor(8);m.floor_pos=HoldFloorPlan.door(8);m.enter_location();check(g.room_id=="tavern","Door enters actual room")
 g.leave_room();check(g.overworld is HoldDistrictMap,"Room returns to hold floor")
 g.close_panel();g.room_id="";g.zone="hub";g.state.region_travel={};g.state.hold_travel={"active":true,"at":10,"floor_x":900,"floor_y":100,"version":2};g.open_panel("world_map");g.overworld.set_process(false)
 check(g.overworld.floor_pos==HoldFloorPlan.point(10),"Old floor save migrates to valid landing")
 g.close_panel();g.room_id="";g.zone="hub";g.player=Vector2(2001,410);g.advance_journey()
 check(g.zone=="hub" and not g.continuous_journey(),"Walking cannot cross hold/mine seam")
 g.zone="mine";g.player=Vector2(600,700);g.grounded=true
 check(not g.can_region_travel(),"Map cannot escape underground")
 g.player=Vector2(95,392);check(g.can_region_travel(),"Entrance allows regional return")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("REVISION39: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
