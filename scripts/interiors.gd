class_name HoldInteriors
extends RefCounted
const A=preload("res://scripts/art.gd")
const ROOMS={
 "kettle_loft":{"name":"Hedrik and Orla’s quarters","host":"","action":"","detail":"A shared home above the Copper Kettle."},
 "clan_archive":{"name":"Hall of Names","host":"","action":"","detail":"The Folk who bear the mountain."},
 "practice":{"name":"The practice hall","host":"","action":"Review training","detail":"The safe sparring alcove beyond Borin’s forge."},
 "throne":{"name":"The King's Hall","host":"eirik","action":"Address Lord Eirik","detail":"Old kings in stone. A living lord on the dais."},
 "training":{"name":"Borin's practice bay","host":"","action":"Review your training","detail":"Padded blows, firm footing. Practice without wounds."},
 "home":{"name":"Workers' quarters","host":"","action":"Rest, wardrobe & supplies","detail":"A warm hearth. A borrowed room. A place to begin."},
 "tavern":{"name":"The Copper Kettle","host":"hedrik","action":"Speak with Hedrik","detail":"Oak smoke, copper mugs, and the end of a long shift."},
 "forge":{"name":"Borin's forge","host":"borin","action":"Work with Borin","detail":"The bellows breathe. Every useful thing begins here."},
 "market":{"name":"Orla's exchange","host":"orla","action":"Trade with Orla","detail":"Freight manifests cover every mile between the holds."},
 "commission":{"name":"Foreman's office","host":"ivar","action":"Speak with Ivar","detail":"Names, wages, and the weight of the mountain."},
 "research":{"name":"The survey office","host":"eldric","action":"Consult Eldric","detail":"Old stone. New instruments. Unanswered questions."}
}
const HEARTHS=preload("res://assets/scenery/interiors-hearths.png")
const COLD_HEARTHS=preload("res://assets/scenery/interiors-hearths-cold.png")
const WORKROOMS=preload("res://assets/scenery/interiors-workrooms.png")
# Atlas source bounds are fitted to the actual painted thresholds, not equal rows.
const FRAMES={"home":[0,420,365],"tavern":[420,480,430],"forge":[900,502,422],"market":[0,460,397],"commission":[460,465,408],"research":[925,477,407]}
static func draw(n:Node2D,id:String,t:float,state:HoldState):
 if id=="throne":HoldRoyalHall.draw(n,t,state);return
 if id=="training":HoldPractice.draw_room(n,t);return
 var lit=id!="forge" or state.opening>=2 or state.active_site=="claim"
 var texture=HEARTHS if id in ["home","tavern","forge"] else WORKROOMS
 if id=="forge" and not lit:texture=COLD_HEARTHS
 var frame=FRAMES[id]
 var scale=960.0/texture.get_width()
 A.rect(n,0,0,960,540,"12232d")
 n.draw_texture_rect_region(texture,Rect2(0,410-frame[2]*scale,960,frame[1]*scale),Rect2(0,frame[0],texture.get_width(),frame[1]))
 HoldScenery.platform(n)
 # Small flickering light pools and embers animate the painted room.
 if id in ["home","tavern","forge"] and lit:
  var fire=Vector2(854,366) if id=="forge" else Vector2(614,338)
  for radius in [25,45,65]:
   n.draw_circle(fire,radius,Color(1,.55,.19,.012+sin(t*5)*.003))
  for i in 7:
   var y=fposmod(t*(13+i)+i*17,55)
   A.rect(n,fire.x+sin(t+i)*12,fire.y-y,1.5,2,Color(1,.72,.32,(1-y/55)*.5))
 if id=="research":
  n.draw_circle(Vector2(810,300),29,Color(.35,1,.85,.025+.009*sin(t*2)))
 var host=str(ROOMS[id].host)
 if host!="" and HoldNpcPresence.inside(state,host,id):
  if id=="forge":HoldNpcActivity.smith(n,Vector2(639,410),t,lit)
  else:HoldNpcActivity.social(n,Vector2(639,410),t,-1,state.npc(host),id=="tavern")
  if state.active_site=="hold":HoldQuestMarkers.draw(n,Vector2(639,410),state,host)
 if id=="tavern":
  HoldOutpost.ensure(state)
  var shown=0
  for key in HoldNpcPresence.tavern_guests(state):
   HoldNpcActivity.social(n,Vector2(280+shown*100,410),t+shown*5,1,state.npc(key),true);shown+=1
   if shown>=3:break
