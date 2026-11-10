class_name HoldWorkerLodge100
extends RefCounted
# A shared, reachable room. Personal storage and furnishings remain in room:home.
const ROOM="room:lodge"
const PRIVATE_DOOR=Vector2(720,330)
const RETURN_FROM_ROOM=Vector2(720,385)
const MINERS=["Rurik Stonehand","Sigrid Emberbraid"]

static func profile(g,index:int)->Dictionary:
 if index==0:return g.state.npc("ivar")
 var p=HoldAppearance.random_profile(g.state.seed_value+7120+index*37,1 if index==2 else 0)
 var parts=MINERS[index-1].split(" ")
 p.first_name=parts[0];p.family_name=parts[1]
 return HoldStoryArt105.tag(HoldAppearance.normalized(p),"lodge_folk:"+str(index))

static func people(g)->Array:
 if g.surface.area!=HoldFrontier103.lodge(g.state):return []
 var result=[]
 if HoldFirstVisit99.lodge_intro(g.state) and (HoldFrontier103.active(g.state) or not HoldFirstVisit99.data(g.state).get("ivar_departed",false)):
  result.append({"p":Vector2(510,380),"kind":"citizen","profile":profile(g,0),"aim":Vector2.DOWN,"walking":false,"name":"Ivar Deepmeasure","role":"Foreman","time":g.clock,"gait":0.0,"interaction":"lodge_folk:0"})
 var t=float(g.state.elapsed);var phase=fposmod(t,28.0)
 var x=lerpf(250.0,350.0,clampf((phase-4.0)/6.0,0,1)) if phase<14 else lerpf(350.0,250.0,clampf((phase-18.0)/6.0,0,1))
 var walking=(phase>=4 and phase<10) or (phase>=18 and phase<24)
 result.append({"p":Vector2(x,490),"kind":"citizen","profile":profile(g,1),"aim":Vector2.RIGHT if phase<14 else Vector2.LEFT,"walking":walking,"name":MINERS[0],"role":"Stone hauler","time":t,"gait":t,"interaction":"lodge_folk:1"})
 var sigrid=HoldTraditions126.sigrid(g,t)
 sigrid.merge({"kind":"citizen","profile":profile(g,2),"name":MINERS[1],"time":t,"interaction":"lodge_folk:2"})
 result.append(sigrid)
 return result

static func furnishings(w)->Array:
 return [w.furn("bed",235,375),w.furn("bed",305,375),w.furn("bed",375,375),w.furn("hearth",510,335),w.furn("table",485,450),w.furn("chair",435,470),w.furn("chair",535,470),w.furn("bookcase",585,325),w.furn("barrel",775,450),w.furn("crate",765,500),w.furn("lamp",200,540),w.furn("ancestral_shrine",HoldTraditions126.MEMORIAL.x,HoldTraditions126.MEMORIAL.y)]

static func draw_private_door(w,x:float=720):
 # Existing painted door, set in the north wall; the interaction is on the floor below it.
 var texture=HoldHearthcraft.MATERIALS
 var unit=texture.get_size()/Vector2(3,2)
 w.g.draw_texture_rect_region(texture,Rect2(x-40,205,80,85),Rect2(Vector2(2,1)*unit,unit))

static func speak(g,index:int):
 g.lodge_talker=clampi(index,0,2)
 g.remove_meta("lodge_memorial_reply")
 if index==0:HoldFirstVisit99.meet_ivar(g)
 g.open_panel("lodge_talk")

static func panel(g):
 var index=clampi(g.lodge_talker,0,2);var p=profile(g,index)
 var identity=g.panel.find_child("ConversationIdentity",true,false)
 var portrait=HoldPortrait.new();portrait.profile=p;portrait.custom_minimum_size=Vector2(96,96);identity.add_child(portrait)
 g.label(identity,p.name,16,Color("edc98a"))
 g.small_button(identity,"End · Esc",g.close_panel)
 var text=""
 match index:
  0:
   text="Ivar sets down his cup. 'Sleep well enough? The room upstairs is yours. Bed, chest, a little peace from Rurik's snoring. Go and make yourself comfortable. There'll be work when you're ready.'"
   if HoldFirstVisit99.data(g.state).get("room_seen",false):
    text="'Found everything? Good. Old Workings is north of town. Take the western rack and stonebreaker; they're set aside for you. Work your first load and you'll have twenty crowns, with a little timber and stone for your room.'"
  1:
   text="Rurik rolls a sore shoulder. 'You're the new hand, then? Don't mind the snoring. Sigrid says it's the roof timbers settling, but she only says that when I'm listening.'"
  2:
   text="Sigrid lifts her mug. 'Rurik's already blamed the roof for the noise, hasn't he? There's a room through the north door if you want some quiet.'"
 if index==0 and not HoldFrontier103.active(g.state):
  text="Ivar sets down his cup. 'The room through the north door is yours. When you're ready, Old Workings is beyond King's Gate and the High Trail. The western rack and stonebreaker are on loan. Work your first load and I'll see you paid.'"
  text=text.replace("room upstairs","room through the north door").replace("Old Workings, north of town","Old Workings, beyond King's Gate and the High Trail")
 if HoldFrontier103.active(g.state):
  text=text.replace("room through that door","room upstairs").replace("north door","stairs").replace("The trail out to work starts at King's Gate.","Old Workings lies north of the town square.")
  if index==2:text="Sigrid lifts her mug. 'Rurik's already blamed the roof for the noise, hasn't he? There's an upstairs room if you want some quiet.'"
 if index==0 and HoldFirstVisit99.data(g.state).get("rewarded",false):
  text="'Good work. Your first twenty crowns are counted, and there's a little timber for your room. When you're settled, take a look at the great book outside. It keeps track of the work the town needs doing.'" if not HoldFirstVisit99.data(g.state).get("home_made",false) else "'That room's looking more lived in. There's more work in the great book outside whenever you're ready. Borin's forge could use a hand, for one.'"
 if index==0 and HoldFirstVisit99.data(g.state).get("rewarded",false) and HoldFirstVisit99.data(g.state).get("home_made",false) and g.state.opening>=2:
  text="'That room's looking more lived in. Good to hear Borin's hearth drawing again, too. The great book has the town's other work whenever you're ready.'"
 if index==0 and HoldFirstVisit99.data(g.state).get("rewarded",false) and not HoldFrontier103.active(g.state):
  text="'Good work. Your first twenty crowns are counted, and there's a little timber for your room. Your journal has the next leads when you're ready.'"
 if index in [1,2] and bool(g.get_meta("lodge_memorial_reply",false)):
  text="Rurik rubs his shoulder. 'The old shift. Keldran gets a nod before I go below, but I still check the props. My grandfather would haunt me for skipping that.'" if index==1 else "Sigrid sets down her mug. 'Our departed. Nyrda keeps them; we keep their names. I read them on Namesday. Come if you like. Grandmother preferred a useful deed to a long speech.'"
 g.label(g.panel_body,text,19,Color("f2e7d2"))
 if index==0 and HoldFrontier103.active(g.state):g.button(g.panel_body,"Where should I go next?",func():g.open_panel("commission"))
 if index==0 and HoldFrontier103.active(g.state):g.button(g.panel_body,"Ask about the shift book",func():g.open_panel("frontier103"))
 if index in [1,2]:
  if not bool(g.get_meta("lodge_memorial_reply",false)):
   g.button(g.panel_body,"Whose names are on that stone?",func():g.set_meta("lodge_memorial_reply",true);g.refresh_panel();g.restore_menu.call_deferred(0,""))
  else:g.button(g.panel_body,"Back to our conversation",func():g.remove_meta("lodge_memorial_reply");g.refresh_panel();g.restore_menu.call_deferred(0,""))
 g.button(g.panel_body,"Thanks · back to the lodge",g.close_panel)
