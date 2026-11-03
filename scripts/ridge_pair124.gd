class_name HoldRidgePair124
extends RefCounted
# Player commitments advance this story; elapsed days never reserve a romance.
const IDS=["road_folk:10","road_folk:11"]
const NAMES={"road_folk:10":"Alden","road_folk:11":"Maren"}
const KEY="ridge_pair124"
static func data(s)->Dictionary:
 if not s.surface.has(KEY):s.surface[KEY]={"met":{},"start":-1,"last_day":-1,"free_days":0,"stage":0,"interest":"","courted_day":-1,"betrothed_day":-1,"events":[]}
 var d:Dictionary=s.surface[KEY]
 for key in ["start","last_day","free_days","stage","courted_day","betrothed_day"]:d[key]=int(d[key])
 for id in d.met:d.met[id]=int(d.met[id])
 for remembered in d.events:
  remembered.stage=int(remembered.stage);remembered.day=int(remembered.day)
 return d
static func paired(s)->bool:return int(s.surface.get(KEY,{}).get("stage",0))>=2
static func blocked(s,d:Dictionary)->bool:
 return HoldCourtship101.partner(s) in IDS or str(d.interest) in IDS
static func meet(s,id:String):
 if id not in IDS:return
 var d=data(s);var today=HoldCourtship101.day(s)
 if not d.met.has(id):d.met[id]=today
 if d.met.size()==2 and d.start<0:d.start=today;d.last_day=today
 advance(s)
static func event(d:Dictionary,stage:int,day:int):
 d.stage=stage;d.events.append({"stage":stage,"day":day})
static func advance(s):
 # Reconcile existing saves and successful commitment events, never elapsed time.
 var commitment=HoldCourtship101.partner(s)
 if commitment=="" or commitment in IDS:return
 var d=data(s);var today=HoldCourtship101.day(s)
 d.interest=""
 if d.stage<2:
  d.courted_day=today;event(d,2,today)
 if d.stage==2 and int(HoldCourtship101.record(s,commitment).stage)==2:
  d.betrothed_day=today;event(d,3,today)
static func available(s,id:String)->bool:
 if id not in IDS:return true
 advance(s)
 return not paired(s)
static func express_interest(g,id:String)->bool:
 if id not in IDS or not HoldCourtship101.local(g,id):return false
 if not HoldRoadCharacters.future_candidate(id,int(g.state.appearance.gender)) or HoldCourtship101.partner(g.state)!="" or not available(g.state,id):return false
 var d=data(g.state);d.interest=id;d.last_day=HoldCourtship101.day(g.state)
 g.save_game();return true
static func release_interest(g,id:String)->bool:
 if id not in IDS or not HoldCourtship101.local(g,id) or str(data(g.state).interest)!=id:return false
 player_ended(g.state,id);g.save_game();return true
static func player_ended(s,id:String):
 if id not in IDS or not s.surface.has(KEY):return
 var d=data(s);d.interest=""
static func summary(s,id:String)->String:
 if id not in IDS or not s.surface.has(KEY):return ""
 var d=data(s)
 if blocked(s,d):return ""
 var other=NAMES[IDS[1] if id==IDS[0] else IDS[0]]
 if d.stage==3:return "Betrothed to "+other
 if d.stage==2:return "Courting "+other
 if d.stage==1:return "Alden and Maren have been finding excuses to spend time together."
 return ""
static func greeting(s,id:String)->String:
 if id not in IDS or not paired(s):return ""
 if int(data(s).stage)==3:
  if id==IDS[0]:return "Alden brushes flour from his sleeve. 'Maren and I are to be married. Six brothers have offered advice. I have asked them to bring clean cups instead.'"
  return "Maren touches her blue ribbon. 'Alden asked where I wanted our home to be. Then he listened to the answer. I believe we shall do very well together.'"
 if id==IDS[0]:return "Alden grins. 'Maren is simple and sweet and sassy as can be. And she says I have improved considerably. I remembered to ask before planning supper.'"
 return "Maren smiles towards Alden. 'A good heart, a clean shirt, and he is learning to listen. I call that a promising beginning.'"
static func options(g,id:String):
 if id not in IDS:return
 var s=g.state;var d=data(s);var line=summary(s,id)
 if line!="":g.label(g.panel_body,line,15)
 if paired(s) or HoldCourtship101.partner(s)!="" or not HoldRoadCharacters.future_candidate(id,int(s.appearance.gender)):return
 if str(d.interest)==id:
  g.label(g.panel_body,"You have asked for time to explore a courtship. They will wait for your decision.",15)
  HoldConversation.choose(g,"Tell them you would prefer friendship",func():
   if release_interest(g,id):g.talk_line="Thank you for telling me. We can still be glad of each other's company."
   g.refresh_panel())
 else:
  HoldConversation.choose(g,"I'd like time to get to know you, with courtship in mind",func():
   if express_interest(g,id):g.talk_line="I would like that. Take the time you need, and tell me honestly what you decide."
   g.refresh_panel())
