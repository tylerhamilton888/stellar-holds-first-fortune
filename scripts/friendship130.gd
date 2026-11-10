class_name HoldFriendship130
extends RefCounted
const STORIES=HoldFriendshipStories130.STORIES
static func data(s)->Dictionary:
 if not s.surface.has("friendship130"):s.surface.friendship130={"records":{},"scene":{}}
 var d:Dictionary=s.surface.friendship130
 for r in d.records.values():
  r.index=int(r.index);r.choice=int(r.choice)
  for m in r.memories:m.choice=int(m.choice)
 if not d.scene.is_empty():d.scene.index=int(d.scene.index);d.scene.beat=int(d.scene.beat)
 return d
static func record(s,id:String)->Dictionary:
 if not STORIES.has(id):return {}
 var all=data(s).records
 if not all.has(id):all[id]={"index":0,"accepted":false,"worked":false,"area":"","place":"","pos":[0,0],"choice":-1,"memories":[]}
 var d=all[id];d.index=int(d.index);d.choice=int(d.choice)
 return d
static func episode(s,id:String)->Dictionary:
 var d=record(s,id)
 return {} if d.is_empty() or d.index>=STORIES[id].size() else STORIES[id][d.index]
static func bond(s,id:String)->int:return int(HoldPeople.records(s).get(id,{}).get("bond",0))
static func ready(s,id:String)->bool:
 var e=episode(s,id)
 return not e.is_empty() and bond(s,id)>=int(e.bond)
static func free_point(g,origin:Vector2,preferred:Vector2)->Vector2:
 for offset in [preferred,Vector2(75,0),Vector2(-75,0),Vector2(0,65),Vector2(0,-65),Vector2(45,45),Vector2(-45,45),Vector2.ZERO]:
  var p=origin+offset
  if g.surface.walkable(p) and g.surface.clear_interaction(origin,p):return p
 return origin
static func accept(g,id:String)->bool:
 if not STORIES.has(id) or not HoldConversation.local(g,id) or not ready(g.state,id) or is_instance_valid(g.opening_scene):return false
 var d=record(g.state,id)
 if d.accepted:return false
 var p=free_point(g,g.player,Vector2(85,0))
 d.accepted=true;d.area=g.surface.area;d.place=g.surface.label();d.pos=[p.x,p.y]
 g.save_game();return true
static func at_task(g,id:String)->bool:
 var d=record(g.state,id)
 if d.is_empty() or not d.accepted or d.worked or g.surface.area!=d.area or not g.surface.active():return false
 var p=Vector2(d.pos[0],d.pos[1])
 return g.player.distance_to(p)<65 and g.surface.clear_interaction(g.player,p)
static func interact(g)->bool:
 if not g.surface.active() or g.handworks.busy_hands():return false
 var p=g.surface.nearest()
 if p.is_empty() or not str(p.action).begins_with("friend130:"):return false
 var id=str(p.action).trim_prefix("friend130:")
 if not at_task(g,id):return false
 g.surface.action(p.action);return true
static func work(g,id:String,choice:int)->bool:
 if not at_task(g,id) or is_instance_valid(g.opening_scene) or g.handworks.busy_hands():return false
 var e=episode(g.state,id)
 if choice!=int(e.answer):g.notify("Take another look. "+e.prompt);return false
 if not g.state.pay(e.cost):g.notify("Bring "+HoldData.cost_text(e.cost)+" in your pack.");return false
 var d=record(g.state,id);d.worked=true;d.choice=choice
 g.save_game();g.notify("Ready · return to "+g.state.npc(id).first_name+" for "+e.title+".");return true
static func begin_scene(g,id:String)->bool:
 var d=record(g.state,id)
 if d.is_empty() or not d.worked or not HoldConversation.local(g,id) or is_instance_valid(g.opening_scene) or not data(g.state).scene.is_empty():return false
 if g.handworks.busy_hands():g.notify("Set down your load or park your cart before spending time together.");return false
 var npc=HoldPeople.nearby(g,id)
 var anchor=npc.get("p",free_point(g,g.player,Vector2(40,-20)))
 data(g.state).scene={"id":id,"index":d.index,"beat":0,"area":g.surface.area,"anchor":[anchor.x,anchor.y],"player":[g.player.x,g.player.y]}
 g.save_game();HoldFriendScene130.start_scene(g);return true
static func complete(g,id:String,index:int)->bool:
 var pending=data(g.state).scene;var d=record(g.state,id)
 if pending.is_empty() or pending.id!=id or int(pending.index)!=index or d.index!=index or not d.worked:return false
 var e=episode(g.state,id)
 # Complete the saved episode before paying once. Replays and stale callbacks are inert.
 d.memories.append({"title":e.title,"keepsake":e.memory,"choice":d.choice});d.index+=1;d.accepted=false;d.worked=false
 for item in e.reward:g.state.add(item,int(e.reward[item]))
 HoldDisciplines.award(g.state,e.path,int(e.xp),"friendship130:"+id+":"+str(index))
 data(g.state).scene={};g.save_game();return true
static func points(g)->Array:
 var out=[]
 for id in data(g.state).records:
  var d=record(g.state,id)
  if d.accepted and not d.worked and d.area==g.surface.area:
   out.append(g.surface.spot(d.pos[0],d.pos[1],episode(g.state,id).title+" · friendship errand","friend130:"+id))
 return out
static func option(g,id:String):
 if not STORIES.has(id):return
 var e=episode(g.state,id);var d=record(g.state,id)
 if e.is_empty() or d.accepted or ready(g.state,id):
  HoldConversation.choose(g,"Have you got a moment?" if not e.is_empty() else "Remember our time together?",func():g.talk_topic="friend130";g.refresh_panel(),true)
static func rewards(e:Dictionary)->String:
 return HoldData.cost_text(e.reward)+( " · "+str(e.xp)+" "+HoldDisciplines.PATHS[e.path][0]+" experience" if e.xp>0 else "")+" · a saved friendship memory"
static func panel(g,id:String,task:bool=false):
 if not STORIES.has(id):return
 var d=record(g.state,id);var e=episode(g.state,id)
 var words="We've shared a good few moments, haven't we?" if e.is_empty() else "There you are. Shall we spend a little time together?" if d.worked else e.offer
 HoldConversation.header(g,g.panel_body,id,words,true)
 if not e.is_empty():
  if d.worked:
   if HoldConversation.local(g,id):HoldConversation.choose(g,"Spend time together",func():begin_scene(g,id),true)
   else:g.label(g.panel_body,"Return to "+g.state.npc(id).first_name+" when you're ready.",16)
  elif d.accepted:
   if at_task(g,id):
    if not e.cost.is_empty():g.label(g.panel_body,"You'll need "+HoldData.cost_text(e.cost)+" from your pack.",16)
    g.label(g.panel_body,e.prompt,17)
    for i in e.choices.size():
     var b=HoldConversation.choose(g,e.choices[i],func():
      if work(g,id,i):g.refresh_panel(),true)
     b.disabled=not g.state.afford(e.cost) or g.handworks.busy_hands()
   else:g.label(g.panel_body,"Meet me at "+d.place+"."+(" Bring "+HoldData.cost_text(e.cost)+" from your pack." if not e.cost.is_empty() else ""),16)
  elif ready(g.state,id):
   HoldConversation.choose(g,"I'd be glad to help",func():
    if accept(g,id):g.refresh_panel(),true)
  else:g.label(g.panel_body,"Perhaps another time, when we know each other better.",16)
 if task:HoldConversation.choose(g,"Back to the world",g.close_panel)
 else:HoldConversation.return_choice(g,id)
static func journal(g):
 var all=data(g.state).records
 var shown=false
 for id in all:
  var d=record(g.state,id);var e=episode(g.state,id)
  if e.is_empty() or not (d.accepted or ready(g.state,id)):continue
  if not shown:g.label(g.panel_body,"Friendship stories",22,Color("edc98a"));shown=true
  g.label(g.panel_body,g.state.npc(id).first_name+" · "+e.title,17)
  g.label(g.panel_body,("Return to your friend for the scene." if d.worked else "Marked errand: "+d.place+" · "+HoldData.cost_text(e.cost) if d.accepted else "A new story is available. Visit them when you like."),15)
  g.label(g.panel_body,"Reward: "+rewards(e)+" · no deadline",14)
  g.label(g.panel_body,HoldRoadCharacters.whereabouts(id,g.state) if id.begins_with("road_folk:") else g.npc_where(id).label,14)
static func notebook(g,id:String,parent=null):
 if not STORIES.has(id):return
 var target=g.panel_body if parent==null else parent
 var d=record(g.state,id);var e=episode(g.state,id)
 g.label(target,"Friendship "+str(bond(g.state,id))+" / 20 · "+str(d.memories.size())+" / 3 stories shared",14)
 if not e.is_empty():g.label(target,("Story ready · " if ready(g.state,id) or d.accepted else "At "+str(e.bond)+" friendship · ")+e.title,14)
 for m in d.memories:g.label(target,"Memory · "+m.keepsake,14)
