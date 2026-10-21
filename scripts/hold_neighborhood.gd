class_name HoldNeighborhood
extends RefCounted
# Residential galleries share actual coordinates, collision and stair landings.
const SIZE=Vector2(1880,1680)
const BOUNDS=Rect2(110,210,1660,1400)
const BRIDGE=Rect2(880,1020,160,110)
const STAIR=Vector2(700,550)
const FAMILIES=["Granitehand","Copperbraid","Deepmantle"]
static func home_id(ward:String,index:int,floor_number:int=0)->String:return "room:folk_"+ward+"_"+str(index)+"_"+str(floor_number)
static func is_home(area:String)->bool:return area.begins_with("room:folk_")
static func parts(area:String)->PackedStringArray:return area.trim_prefix("room:folk_").split("_")
static func home_door(index:int)->Vector2:return Vector2([350,690,1490][index],1500)
static func title(area:String)->String:
 var p=parts(area);var z={"crownward":1,"hearthward":0,"forgeward":-1}[p[0]]+int(p[2])
 return FAMILIES[int(p[1])]+" hearth · "+("upper rooms" if p[2]=="1" else "family room")+" · Z %+d" % z
static func buildings(ward:String)->Array:
 var result=[]
 for i in 3:result.append({"p":home_door(i),"kind":"building","art":0,"width":[260.0,240.0,280.0][i],"id":-2,"home":home_id(ward,i)})
 return result
static func rails()->Array:
 return [Rect2(110,1012,770,16),Rect2(1040,1012,730,16),Rect2(110,1122,770,16),Rect2(1040,1122,730,16),Rect2(870,1020,10,110),Rect2(1040,1020,10,110)]
static func obstacles()->Array:
 var result=rails()
 result.append_array([Rect2(110,1028,760,94),Rect2(1050,1028,720,94)])
 return result
static func stair_rails(p:Vector2,width:float=140)->Array:
 var scale=width/96
 return [Rect2(p+Vector2(-48,-72)*scale,Vector2(14,92)*scale),Rect2(p+Vector2(34,-72)*scale,Vector2(14,92)*scale),Rect2(p+Vector2(-34,-80)*scale,Vector2(68,10)*scale)]
static func stair_access(player:Vector2,p:Vector2,width:float=140)->bool:return absf(player.x-p.x)<=width*.5-24 and player.y>=p.y-30 and player.y<=p.y+52
static func draw_stairs(w,p:Vector2,up:bool,width:float=140):
 # Original painted staircase, fitted to the same 96x100 envelope as its rails.
 var source=w.LAND_RECTS[1 if up else 2]
 w.g.draw_texture_rect_region(w.LANDMARKS,Rect2(p-Vector2(48,80)*width/96,Vector2(96,100)*width/96),source)
static func draw_gallery(w):
 var g=w.g
 w.tile(0,Rect2(80,1000,1720,640),100,Color("b8c5bc") if w.s.area=="crownward" else Color("bca78c") if w.s.area=="forgeward" else Color("cfbea0"))
 # A real open shaft separates public streets from the inhabited gallery.
 g.draw_rect(Rect2(110,1020,1660,110),Color("101e26"))
 w.draw_lower_gallery()
 w.tile(0,BRIDGE,80,Color("e0cbaa"))
 for r in rails():
  g.draw_style_box(w.stone_style(Color("788b83")),r)
  g.draw_line(r.position,r.position+Vector2(r.size.x,0),Color("cbb98d"),3)
 for x in [880,1040]:
  for y in [1015,1130]:w.detail(4,Vector2(x,y),34,60)
 # Pillared outer envelope follows the enlarged walkable boundary.
 for x in [90,1790]:
  g.draw_rect(Rect2(x-10,1000,20,640),Color("31474b"))
  for y in [1180,1610]:w.detail(4,Vector2(x,y),58,90)
 for x in range(110,1770,80):w.s.house.material(3,Rect2(x,1620,80,40))
static func room_objects(w)->Array:
 var p=parts(w.s.area);var index=int(p[1]);var upper=p[2]=="1"
 var result=[w.furn("lamp",220,305),w.furn("lamp",740,305)]
 if upper:
  result.append_array([w.furn("bed",290,410),w.furn("bed",430,410),w.furn("desk",570,360),w.furn("bookcase",270,560)])
 else:
  result.append_array([w.furn("hearth",340,335),w.furn("tea_table",450,475),w.furn("chair",385,490),w.furn("chair",515,490),w.furn("counter",650,365),w.furn("bookcase",265,360)])
 if index==1:result.append(w.furn("lamp",570,570))
 return result
static func resident(w,index:int,p:Vector2,walking:bool=false,aim:Vector2=Vector2.DOWN,gait:float=0)->Dictionary:
 var ward=parts(w.s.area)[0] if is_home(w.s.area) else w.s.area
 var key="house:"+ward+str(index)
 if not w.profiles.has(key):w.profiles[key]=HoldAppearance.random_profile(w.g.state.seed_value+8200+index+HoldWorldZones.WARDS.find(ward)*31,index%2)
 return {"p":p,"kind":"citizen","profile":w.profiles[key],"aim":aim,"walking":walking,"gait":gait,"name":{"hearthward":["Oskar","Freya","Sten"],"crownward":["Bjarne","Astrid","Halvar"],"forgeward":["Einar","Bodil","Haldor"]}[ward][index]+" "+FAMILIES[index],"role":"Neighbor","index":index+6,"time":w.g.state.elapsed}
static func people(w,at_time:float=-1)->Array:
 var result=[];var time=float(w.g.state.elapsed) if at_time<0 else at_time
 for i in 3:
  var phase=fposmod(time+i*29,180)
  if is_home(w.s.area):
   var p=parts(w.s.area)
   if int(p[1])==i and p[2]=="0" and phase>=120:result.append(resident(w,i,Vector2(450,530)))
  elif phase<120:
   var a=home_door(i)+Vector2(0,45);var b=a+Vector2(150 if i<2 else -150,0)
   var t=fposmod(phase,30);var forward=t<15;var blend=clampf((t if forward else t-15)/6,0,1)
   var position=a.lerp(b,blend) if forward else b.lerp(a,blend)
   var aim=(b-a).normalized()*(1 if forward else -1);var walking=blend<1;var gait=HoldDrawnLocomotion.time_for_distance(blend*150+(0 if forward else 150))
   if phase<.75:position=home_door(i).lerp(a,phase/.75);aim=Vector2.DOWN;walking=true;gait=HoldDrawnLocomotion.time_for_distance(phase*60)
   elif phase>119.25:position=a.lerp(home_door(i),(phase-119.25)/.75);aim=Vector2.UP;walking=true;gait=HoldDrawnLocomotion.time_for_distance((phase-119.25)*60)
   result.append(resident(w,i,position,walking,aim,gait))
 return result

static func gallery_stairs(ward:String)->Array:
 var result=[]
 if ward in ["hearthward","crownward"]:result.append({"p":Vector2(180,1570),"dest":"crownward" if ward=="hearthward" else "hearthward","up":ward=="hearthward","side":"west"})
 if ward in ["hearthward","forgeward"]:result.append({"p":Vector2(1700,1570),"dest":"forgeward" if ward=="hearthward" else "hearthward","up":ward=="forgeward","side":"east"})
 return result
