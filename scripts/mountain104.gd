class_name HoldMountain104
extends RefCounted
# Frontier chapter adapters; excavation and evacuation remain in their existing owners.
static func active(s)->bool:return HoldFrontier103.active(s)
static func data(s)->Dictionary:
 var q=HoldAncestralClaim.data(s)
 if not q.has("mountain104"):q.mountain104={"celebrated":false,"allowance":0,"authenticated":false,"insights":{},"reactions":{}}
 return q.mountain104
static func eligible(s)->bool:
 return active(s) and HoldFrontier103.data(s).get("home_reward",false) and int(HoldGreatClaim102.data(s).get("points",0))>=180
static func missing(s,id:String)->bool:
 if not active(s):return false
 var q=HoldAncestralClaim.data(s)
 return int(q.stage) in [1,2] and id in q.get("victims",[])
static func gathering(s,id:String)->bool:
 return active(s) and int(HoldAncestralClaim.data(s).stage)==3 and id in HoldAncestralClaim.data(s).get("victims",[])
static func guests(g,area:String)->Array:
 if not active(g.state) or area!=HoldFrontier103.lodge(g.state) or int(HoldAncestralClaim.data(g.state).stage)!=3:return []
 var out=[];var crew=HoldAncestralClaim.data(g.state).crew
 for i in crew.size():
  var c=crew[i]
  out.append({"kind":"citizen","p":[Vector2(350,530),Vector2(590,550),Vector2(600,430)][i],"profile":c.profile,"aim":Vector2.DOWN,"walking":false,"gait":0.0,"name":c.profile.name,"role":"Returned survey crew","index":int(str(c.id).get_slice(":",1)),"interaction":c.id})
 return out
static func setup(g):
 var q=HoldAncestralClaim.data(g.state)
 if not active(g.state) or q.site.is_empty() or q.has("victims"):return
 var partner=HoldCourtship101.partner(g.state)
 q.victims=["road_folk:5","road_folk:2",partner if partner!="" and partner!="road_folk:2" else "road_folk:6"]
 var anchor=Vector2i(int(q.site[0]),int(q.site[1]));var cells=[]
 for y in range(-2,3):
  for x in range(-2,3):
   var c=anchor+Vector2i(x,y)
   if g.deep.world.walkable(c) and not HoldAncestralClaim.route(g.deep.world,anchor,c).is_empty():cells.append(c)
 if cells.size()<3:q.victims=q.victims.slice(0,2)
 q.crew=[]
 for i in q.victims.size():
  var p=Deepworks.center(anchor if i==0 else cells[i]);var id=str(q.victims[i]);var n=int(id.get_slice(":",1));var f=HoldRoads.FOLK[n]
  var profile=HoldRoadCharacters.appearance(g.state,id,HoldAppearance.random_profile(g.state.seed_value+7500+n,f.gender))
  profile.first_name=f.name;profile.name=f.name+" "+profile.family_name
  g.state.npc_appearances[id]=profile.duplicate(true)
  q.crew.append({"p":[p.x,p.y],"gait":0.0,"home":false,"id":id,"profile":profile})
 g.save_game()
static func profile(g,i:int)->Dictionary:
 var c=HoldAncestralClaim.data(g.state).crew[i]
 return c.get("profile",HoldFirstShift.profile_for(i==0))
static func safe(g)->bool:
 var q=HoldAncestralClaim.data(g.state);var cell=Vector2i(int(q.site[0]),int(q.site[1]));var work=g.deep.worksite(cell)
 if not work.braced or not work.lit:
  g.notify("The refuge needs light and a masonry support before the wounded move. V places a lamp; O designates an excavated room and installs a stone pillar. Research stoneworking at the town survey desk.");return false
 for c in q.crew:
  if HoldAncestralClaim.route(g.deep.world,Deepworks.cell(Vector2(c.p[0],c.p[1])),Deepworks.ENTRY).is_empty():g.notify("Every survivor needs a clear route to the entrance.");return false
 return true
static func act(g,action:String)->bool:
 if not active(g.state):return false
 var s=g.state;var q=HoldAncestralClaim.data(s);var d=data(s);var done=false
 match action:
  "rescue":
   if q.stage==0 and eligible(s) and HoldFrontier103.near(g,"lodge"):q.stage=1;done=true
  "celebrate":
   if q.stage==3 and not d.celebrated and HoldFrontier103.near(g,"lodge"):
    d.celebrated=true;done=true
    HoldOutpost.record(s,"frontier_rescue","Sten and the trapped crew returned alive. Stonebridge gathered at the bunkhouse hearth; Ivar read every rescuer's and worker's name.")
  "examine":
   if q.stage==3 and d.celebrated and HoldFrontier103.near(g,"survey"):q.stage=4;done=true
  "family":
   if q.stage==4 and not q.family and HoldFrontier103.near(g,"lodge"):q.family=true;done=true
  "archive":
   if q.stage==4 and not q.archive and g.zone!="mine" and g.surface.area==HoldFrontier103.room(s,"survey",1) and g.player.distance_to(Vector2(690,575))<90:q.archive=true;done=true
  "translate":
   if q.stage==4 and q.family and q.archive and not d.authenticated and HoldFrontier103.near(g,"survey"):
    var ledger=HoldGreatClaim102.data(s);var rival=int(HoldGreatClaim102.standings(s)[0][1]);var score=int(ledger.points)
    d.allowance=maxi(0,rival-score);d.work_at_award=score;d.rival_at_award=rival;ledger.points=score+int(d.allowance)
    d.authenticated=true;q.stage=5;q.title="Authenticated claimant";done=true
    HoldOutpost.record(s,"frontier_ancestry","Edda matched the fragment's seals, the upper archive and Ivar's family registration: the founding house of this very mountain. Work marks: %d; hereditary allowance: %d; total: %d. Household tenure and construction remain unchanged." % [score,d.allowance,ledger.points])
 if done:g.save_game();g.sound.effect("quest",-14);g.refresh_panel()
 return done
static func description(s)->String:
 var q=HoldAncestralClaim.data(s);var d=data(s)
 match int(q.stage):
  0:return "After registering your home and earning 180 contribution marks, visit Ivar's shift book."
  1:return "A fall has sealed a survey refuge in Old Workings, depth 1. Sten and his companions are trapped. Excavate a bypass, light and brace their refuge, then press E beside them. There is no countdown. V: lamps; O: rooms and masonry pillars."+(" Survey location: column %d, row %d." % [q.site[0],q.site[1]] if not q.site.is_empty() else " Enter Old Workings to locate the refuge.")
  2:return "Stay on depth 1 while the crew walks out. Blocked routes halt evacuation; clear the obstruction. Their ancient fragment can wait until everyone is safe."
  3:return "The crew is safe. Gather at Ivar's shift book for the communal celebration, then bring the recovered fragment to Edda's survey desk." if not d.celebrated else "Around the shared hearth, Sten raises his mug: 'To the hands that came back for us.' Torvik can scarcely finish his tune. Ivar names every worker. The fragment belongs at Edda's survey desk; your home and belongings await you."
  4:return "Edda recognizes the mountain's founding seal, but requires independent evidence. Compare the upstairs archive and Ivar's family register, in either order, then return to the survey desk. Archive: %s · Family: %s." % ["verified" if q.archive else "needed","verified" if q.family else "needed"]
 return "Authenticated: you descend from the founding house of this mountain. Recorded work: %d; hereditary allowance: %d; award total: %d. Skarrin demands a public test: 'My walls hold this place up. Your dead ancestors laid none of them.' No title or new land is granted yet. Your household remains yours." % [int(d.get("work_at_award",0)),int(d.allowance),int(d.get("work_at_award",0))+int(d.allowance)]
static func panel(g):
 if not active(g.state):return
 g.label(g.panel_body,"THE MOUNTAIN REMEMBERS",20,Color("edc98a"));g.label(g.panel_body,description(g.state),16)
 var q=HoldAncestralClaim.data(g.state);var d=data(g.state);var choices=[]
 if HoldFrontier103.near(g,"lodge"):
  if q.stage==0 and eligible(g.state):choices.append(["The missing survey crew · begin rescue","rescue"])
  if q.stage==3 and not d.celebrated:choices.append(["Gather around the hearth · celebrate the survivors","celebrate"])
  if q.stage==4 and not q.family:choices.append(["Compare my family registration","family"])
 if HoldFrontier103.near(g,"survey"):
  if q.stage==3 and d.celebrated:choices.append(["Ask Edda to examine the recovered fragment","examine"])
  if q.stage==4 and q.archive and q.family:choices.append(["Authenticate the ancestral right and record its allowance","translate"])
 if q.stage==4 and not q.archive and g.surface.area==HoldFrontier103.room(g.state,"survey",1):choices.append(["Compare the founding charter in the archive","archive"])
 for choice in choices:
  var action=str(choice[1]);g.button(g.panel_body,choice[0],func():act(g,action))
static func reaction(g,id:String):
 if not active(g.state) or HoldPeople.nearby(g,id).is_empty():return
 var q=HoldAncestralClaim.data(g.state);var d=data(g.state)
 if id=="road_folk:8":
  if int(HoldPeople.records(g.state).get(id,{}).get("bond",0))>=4:
   HoldConversation.choose(g,"You speak of equality, but who gets the credit?",func():
    d.insights.credit=true;g.talk_line="'Direction is work. A hundred hands without mine would merely move the wrong stones.' Skarrin's short, severe answers leave little room for the names in Ivar's ledger.";g.save_game();g.refresh_panel())
  if int(HoldPeople.records(g.state).get(id,{}).get("bond",0))>=8:
   HoldConversation.choose(g,"Who were you meeting beyond the watch road?",func():
    d.insights.contacts=true;g.talk_line="'Trade does not require a pedigree. Nor does an Orc ask whose grandfather blessed a road.' He closes his satchel before you can read the marked route inside.";g.save_game();g.refresh_panel())
  if q.stage>=5:g.label(g.panel_body,"'I built this settlement. You found a stone.' He waits for applause that does not come, then adds: 'There are people outside these walls who understand what I am owed.'",16)
 if q.stage>=3 and id in q.get("victims",[]):
  var line="I counted the lamps on the way out. Yours was the one that mattered." if id=="road_folk:5" else "I kept listening for your pick. When it stopped, I thought—well. I'm glad you're here."
  if HoldCourtship101.partner(g.state)==id:line="When I heard your voice through the stone, I knew you had come for me. Stay beside me a while."
  HoldConversation.choose(g,"How are you after the collapse?",func():d.reactions[id]=true;g.talk_line=line;g.save_game();g.refresh_panel())
