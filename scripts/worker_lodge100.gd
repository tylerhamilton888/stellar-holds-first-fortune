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
 return HoldAppearance.normalized(p)

static func people(g)->Array:
 if g.surface.area!=ROOM:return []
 var result=[]
 if HoldFirstVisit99.lodge_intro(g.state) and not HoldFirstVisit99.data(g.state).get("ivar_departed",false):
  result.append({"p":Vector2(510,380),"kind":"citizen","profile":profile(g,0),"aim":Vector2.DOWN,"walking":false,"name":"Ivar Deepmeasure","role":"Foreman","time":g.clock,"gait":0.0,"interaction":"lodge_folk:0"})
 var t=float(g.state.elapsed);var phase=fposmod(t,28.0)
 var x=lerpf(250.0,350.0,clampf((phase-4.0)/6.0,0,1)) if phase<14 else lerpf(350.0,250.0,clampf((phase-18.0)/6.0,0,1))
 var walking=(phase>=4 and phase<10) or (phase>=18 and phase<24)
 result.append({"p":Vector2(x,490),"kind":"citizen","profile":profile(g,1),"aim":Vector2.RIGHT if phase<14 else Vector2.LEFT,"walking":walking,"name":MINERS[0],"role":"Stone hauler","time":t,"gait":t,"interaction":"lodge_folk:1"})
 result.append({"p":Vector2(620,480),"kind":"citizen","profile":profile(g,2),"aim":Vector2.DOWN,"walking":false,"name":MINERS[1],"role":"Miner","time":t,"gait":0.0,"pose":"drink","phase":float([0,1,2,1][posmod(int(t*2),4)]),"interaction":"lodge_folk:2"})
 return result

static func furnishings(w)->Array:
 return [w.furn("bed",235,375),w.furn("bed",305,375),w.furn("bed",375,375),w.furn("hearth",510,335),w.furn("table",485,450),w.furn("chair",435,470),w.furn("chair",535,470),w.furn("bookcase",585,325),w.furn("barrel",775,450),w.furn("crate",765,500),w.furn("lamp",200,540)]

static func draw_private_door(w,x:float=720):
 # Existing painted door, set in the north wall; the interaction is on the floor below it.
 var texture=HoldHearthcraft.MATERIALS
 var unit=texture.get_size()/Vector2(3,2)
 w.g.draw_texture_rect_region(texture,Rect2(x-40,205,80,85),Rect2(Vector2(2,1)*unit,unit))

static func speak(g,index:int):
 g.lodge_talker=clampi(index,0,2)
 if index==0:HoldFirstVisit99.meet_ivar(g)
 g.open_panel("lodge_talk")

static func panel(g):
 var index=clampi(g.lodge_talker,0,2);var p=profile(g,index)
 var row=g.row(g.panel_body);row.add_theme_constant_override("separation",18)
 var portrait=HoldPortrait.new();portrait.profile=p;portrait.custom_minimum_size=Vector2(96,96);row.add_child(portrait)
 var body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;row.add_child(body)
 g.label(body,p.name,21,Color("edc98a"))
 var text=""
 match index:
  0:
   text="Welcome to the shift. The bunks and hearth are shared; the room through that door is yours to use. Take a look, then come to Old Workings by the High Trail. The western rack and stonebreaker are on loan to you. Work a load and I'll see you paid."
  1:
   text="Rurik rolls a sore shoulder. 'A fresh face! The bunks are for whoever needs them, and the hearth's for everyone. Keep the west rack stocked and you'll have useful stone before you know it.'"
  2:
   text="Sigrid lifts her mug. 'There's a room through the north door if you want a little quiet. A chair and a lamp can make even a borrowed room feel like your own. The trail out to work starts at King's Gate.'"
 g.label(body,text,16)
 g.button(g.panel_body,"Thanks · back to the lodge",g.close_panel)
