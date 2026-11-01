class_name HoldFirstVisit99
extends RefCounted
# Optional opening; all work, stock and larger milestones remain in their existing owners.
const TASKS=[
 ["Find your feet","Walk around the entrance bay with WASD or the arrow keys. The north stairs lead back to the High Trail."],
 ["Check your pack","Press I to see your tools and supplies. Close it with Escape. Menus pause the world."],
 ["A stone on your shoulder","Select the pick [1], face exposed stone and hold left mouse while standing still. Press E beside a freed stone load to lift it."],
 ["A place for raw stone","Carry your load to the borrowed rack on the WEST side of the entrance bay. Press E to put it down there. The eastern crew stock belongs to the hold."],
 ["Your first useful stone","Stand beside the western stonebreaker and hold E. It takes a load from the rack and works it into usable stone. New output enters your pack; E collects any older output left on a bench."]
]
static func active(s)->bool:return s.surface.has("first_visit99")
static func data(s)->Dictionary:return s.surface.get("first_visit99",{})
static func lodge_intro(s)->bool:return active(s) and bool(data(s).get("lodge_intro",false))
static func begin(g):
 var s=g.state
 s.surface.first_visit99={"done":{},"guided":true,"focus":"lodge","rewarded":false,"bay_found":false,"bay_warm":false,"bay_worked":false,"lodge_intro":true,"ivar_spoken":false,"ivar_departed":false,"room_seen":false,"work_started":false,"home_made":false,"origin":[0.0,0.0]}
 HoldGreatClaim102.begin(s)
 s.opening=1;s.tracked_npc=""
 var q=HoldOnboarding.ensure(s)
 q.fresh=false;q.stage=3;q.arrival_seen=true;q.escort_pending=false;q.settle_required=false;q.combat=true
 s.add("wood",6)
 HoldFirstShift.data(g).accepted=true;HoldFirstShift.data(g).kit=true;HoldFirstShift.data(g).guided=true
 g.surface.enter(HoldWorkerLodge100.ROOM,Vector2(480,555))
 g.notify("Welcome to the miners' lodge · E speaks with Ivar · J keeps your first steps.")
 g.save_game()
static func meet_ivar(g):
 if not lodge_intro(g.state):return
 var q=data(g.state)
 if not q.get("ivar_spoken",false):q.ivar_spoken=true;g.save_game()
static func leave_lodge(g):
 if not lodge_intro(g.state):return
 data(g.state).ivar_departed=true
static func room_entered(g):
 if not lodge_intro(g.state):return
 var q=data(g.state)
 if not q.get("room_seen",false):
  q.room_seen=true;q.ivar_departed=true
  g.notify("Your room in the lodge · bed, chest and desk are ready · O opens furnishing plans.")
static func mine_entered(g):
 if not lodge_intro(g.state):return
 var q=data(g.state)
 if q.get("work_started",false):return
 q.work_started=true;q.origin=[g.player.x,g.player.y];q.ivar_departed=true
 if q.focus=="lodge":q.focus="basics"
 if g.depth_nav.explore.enabled:g.depth_nav.toggle_view()
 g.notify("First shift · the western rack and stonebreaker are on loan · J: work steps.")
static func furnished(g,kind:String):
 if not lodge_intro(g.state):return
 var q=data(g.state)
 if q.get("home_made",false):return
 q.home_made=true
 if q.get("rewarded",false) and q.focus=="home":q.focus="bay"
 g.notify("A place of your own: "+HoldFurnishings.ITEMS[kind].title+" built. J has your next leads.")
static func step(s)->int:
 var q=data(s)
 for i in TASKS.size():
  if not q.get("done",{}).get(str(i),false):return i
 return TASKS.size()
static func seen_pack(s):
 if active(s):data(s).pack_seen=true
static func tick(g):
 if not active(g.state):return
 var q=data(g.state);var changed=false;var f=HoldFirstShift.data(g).facts
 if lodge_intro(g.state) and not q.get("work_started",false):
  if g.zone=="mine":mine_entered(g);changed=true
  else:return
 var origin=Vector2(q.origin[0],q.origin[1])
 var checks=[g.zone!="mine" or g.player.distance_to(origin)>80,q.get("pack_seen",false),f.get("lift",false),f.get("stock",false),f.get("collect",false)]
 for i in checks.size():
  if checks[i] and not q.done.get(str(i),false):q.done[str(i)]=true;changed=true
 if step(g.state)==TASKS.size() and not q.rewarded:
  q.rewarded=true
  if q.focus=="basics":q.focus="home" if lodge_intro(g.state) and not q.get("home_made",false) else "bay"
  for item in {"stone":4,"iron":3,"coal":2}:g.state.add(item,{"stone":4,"iron":3,"coal":2}[item])
  if lodge_intro(g.state):
   g.state.money+=20;g.state.add("wood",4)
   g.notify("First shift complete · 20 crowns and room supplies earned. "+("J has your next lead." if q.get("home_made",false) else "Return to your quarters · O opens plans."))
  else:g.notify("First shift learned. Your repair allowance: 4 stone, 3 iron, 2 coal. J has a lead on an old workplace.")
  g.sound.effect("quest",-18);changed=true
 if g.state.active_site=="hold" and HoldWorkplace98.active(g):
  var bay=HoldWorkplace98.data(g)
  for pair in [["bay_found",bay.get("found",false)],["bay_warm",HoldWorkplace98.warm(g)],["bay_worked",int(bay.get("cuts",0))>0]]:
   if pair[1] and not q.get(pair[0],false):q[pair[0]]=true;changed=true
  if q.bay_worked and q.focus=="bay":
   q.focus="free";g.notify("Hammering in the old bay again. You have made a place useful. J holds longer ambitions whenever you want them.")
 if changed:g.save_game()
static func bay_hint(g)->String:
 var q=data(g.state)
 if not q.bay_found:return "Find the old cutters' bay · south of the entrance, through the fallen passage · J"
 if not q.bay_warm:return "Repair the old hearth · O → Furnish → Forge hearth & anvil, then E to add coal · J"
 return "Supply the old bay's rack with raw stone, then give Odrin room to work · J"
static func goal(g)->String:
 if not active(g.state):return ""
 var q=data(g.state)
 if not q.guided:return "Explore at your own pace · J: resume guidance or choose a goal"
 match str(q.focus):
  "lodge":
   if not q.get("ivar_spoken",false) and not q.get("ivar_departed",false):return "First morning · Speak with Ivar by the lodge hearth · E"
   if not q.get("room_seen",false):return "First morning · Visit your room through the lodge's north door · E"
   return "First shift · King's Gate → High Trail → Old Workings · J: directions"
  "home":
   if g.surface.area=="room:home" and g.zone!="mine":return "Your own corner · O: furnish your room · choose a chair, lamp or table"
   return "Your own corner · return to the miners' lodge in Hearthward · J: directions"
  "basics":
   var n=step(g.state)
   return "First visit · %d/%d · %s · J: help" % [mini(n+1,5),5,TASKS[n][0]] if n<5 else "The basics are yours · J: choose what comes next"
  "bay":return bay_hint(g)
  "reference":return "Earn Ivar's reference · three hold commissions · J: requirements"
  "charter":return "A mountain of your own · survey office after Ivar's reference · J"
  "hold":return "A home and a working hold · your claim ledger [M] · J"
  "ship":return "The First Fortune · build your hold and launchyard · M: requirements"
 return "Make yourself at home · mine, build, explore or meet the hold · J: ambitions"
static func focus(g,id:String):
 var q=data(g.state);q.focus=id;q.guided=true;g.save_game();g.refresh_panel()
static func journal(g):
 var s=g.state;var q=data(s);var n=step(s)
 var before_shift=lodge_intro(s) and not q.get("work_started",false)
 g.label(g.panel_body,"FIRST VISIT TO THE HOLD",22,Color("edc98a"))
 g.label(g.panel_body,"A bunk by the shared hearth, a room to make your own, and honest work in the mountain. No deadlines; explore and return to any step whenever you like." if before_shift else "Ivar has put your name on the shift book and lent you a place at the western benches. Learn a little, then make this life your own. No deadlines; you can leave any task and return later." if n<5 else "The basics are yours. Follow a lead, choose a longer ambition, or take the afternoon for yourself.",16)
 var nav=g.row(g.panel_body)
 g.small_button(nav,"Take a break from guidance" if q.guided else "Resume guidance",func():q.guided=not q.guided;g.save_game();g.refresh_panel())
 g.small_button(nav,"Close journal · play",g.close_panel)
 if before_shift:
  var arrival=HoldMenuView.section(g.panel_body,"A place to begin")
  g.label(arrival,("✓ " if q.get("ivar_spoken",false) else "○ ")+"Speak with Ivar beside the lodge hearth. E talks; you may explore without waiting.",15)
  g.label(arrival,("✓ " if q.get("room_seen",false) else "○ ")+"Visit your private room through the north door. The bed, chest and desk are yours to use.",15)
  g.label(arrival,"First shift: leave the lodge into Hearthward, go through King's Gate to the High Trail, then enter Old Workings at the northern mine. G gives directions. The western rack and stonebreaker are loaned to you.",15)
  g.label(arrival,"Your first completed load earns 20 crowns and materials for a furnishing. Your own mountain and homestead are longer ambitions, not a deadline.",15)
  g.small_button(arrival,"Follow the first morning",func():focus(g,"lodge"))
 elif n<5:
  var card=HoldMenuView.section(g.panel_body,"A small beginning · task %d of 5" % (n+1))
  g.label(card,TASKS[n][0],19,Color("edc98a"));g.label(card,TASKS[n][1],16)
  g.label(card,"Take as long as you like. J reopens this page; G gives directions outside.",14)
  g.small_button(card,"Follow the basics",func():focus(g,"basics"))
 else:
  g.label(g.panel_body,goal(g),17,Color("edc98a"))
  g.label(g.panel_body,"✓ Repair allowance received: 4 stone, 3 iron and 2 coal.",14,Color("a7dfcb"))
 if n<5 and not before_shift:
  for i in TASKS.size():g.label(g.panel_body,("✓ " if q.done.get(str(i),false) else "○ ")+TASKS[i][0],14)
 elif n>=5:
  if lodge_intro(s):
   var home=HoldMenuView.section(g.panel_body,"A little place of your own")
   g.label(home,("✓ " if q.get("home_made",false) else "○ ")+"Furnish your room in the miners' lodge. From the mine, return to the High Trail, enter Keldrath, and find the lodge on Hearthward's northwestern street.",15)
   g.label(home,"In your room press O, choose a chair, lamp or table, and left-click a green position within reach. Right-click cancels without spending. Your first shift paid 20 crowns and supplied timber and stone.",15)
   if not q.get("home_made",false):g.small_button(home,"Follow the room project",func():focus(g,"home"))
  var bay=HoldMenuView.section(g.panel_body,"A hearth under the dust · a first project")
  g.label(bay,"Ivar's note: 'There was a cutters' bay south of the entrance, beyond the fallen supply passage. Slatehand's people worked there. If the old hearth survives, Odrin might know what to do with it.'",16)
  g.label(bay,("✓ " if q.bay_found else "○ ")+"Open the fallen passage and step into the bay. Follow the old corridor south from the entrance, mining the rock that blocks it.",15)
  g.label(bay,("✓ " if q.bay_warm else "○ ")+"At the damaged hearth: O → Furnish → Forge hearth & anvil. Place it on the old plinth (4 stone, 3 iron); close plans and press E there to add 1 coal.",15)
  g.label(bay,("✓ " if q.bay_worked else "○ ")+"Put a raw stone load into the bay's rack. Keep the passage and bench clear. Odrin works 08:00–18:00, with a noon break; return later if he is away.",15)
  g.label(bay,"Warmth lasts half an hour of active play. The furniture and work remain when it cools. No deadline or failure penalty. E beside Odrin lets you talk.",14)
  if not q.bay_worked:g.small_button(bay,"Follow the old bay lead",func():focus(g,"bay"))
 if HoldGreatClaim102.active(s):g.button(g.panel_body,"Great Claim · civic ledger",func():g.open_panel("great_claim102"))
 var goals=HoldMenuView.section(g.panel_body,"Longer ambitions · choose your own pace")
 for spec in [["reference","A trusted pair of hands",s.opening>=4,"Finish Ivar's three commissions: coal for the forge, stone and timber for the lift, then smelted metal for the conduits. These earn wages and a reference."],["charter","A mountain with your name on it",s.claim_id!="","With the reference, visit the survey office in Keldrath. Compare the mountains before buying a charter; prices begin at 240 crowns."],["hold","A place for your people",s.camp_stage>=3,"On your claim, M shows the foundation, workshop and freight beacon. Build at your pace; recruit help at the Copper Kettle when you can afford it."],["ship","The First Fortune",s.launched,"Establish your hold, recruit and assign an engineer, then work toward the keel and launchyard stages in M. A long-term ambition, not today's homework."]]:
  g.label(goals,("✓ " if spec[2] else "○ ")+spec[1],18,Color("a7dfcb") if spec[2] else Color("edc98a"))
  g.label(goals,spec[3],15)
  if spec[0]=="reference" and s.opening<4:
   var job=HoldCampaign.JOBS[s.opening-1]
   g.label(goals,"%d / 3 delivered · Next: %s · %s" % [s.opening-1,job.name,HoldData.cost_text(job.cost)],15)
  if not spec[2]:g.small_button(goals,"Track · "+spec[1],func():focus(g,spec[0]))
 g.button(g.panel_body,"Ivar's commissions · requirements & delivery",func():g.open_panel("commissions_detail"))
 g.button(g.panel_body,"Local lessons · timber, fishing, craft and more",func():g.open_panel("guidance"))
 g.label(g.panel_body,"Free afternoons: walk north out of the mine to the High Trail; Pinewood is south, Keldrath west. Talk to people, chop timber, try fishing or improve your worksite. F6 tries the optional mine exploration camera; F7 opens its controls. Combat never consumes work energy.",15)
 g.small_button(g.panel_body,"Just let me explore",func():focus(g,"free"))
