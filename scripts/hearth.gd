class_name HoldHearth
extends RefCounted
# Additive household records. Inventory, recipes, furniture and clock retain ownership.
const CROPS={
 "turnip":{"name":"Turnips","seed":"turnip_seed","time":180.0,"use":"Stew, hotpot and Kettle orders","color":"bd81bb"},
 "carrot":{"name":"Copper carrots","seed":"carrot_seed","time":210.0,"use":"Chowder and roasted roots","color":"d89652"},
 "barley":{"name":"Hold barley","seed":"barley_seed","time":270.0,"use":"Hearth bread; a future brewing grain","color":"d9ba65"},
 "hearthcap":{"name":"Hearthcaps","seed":"hearthcap_seed","time":240.0,"use":"Hotpot; a shade-loving cultivation crop","color":"b99e79"}}
const SPOTS={
 "trail":{"name":"Stonebridge current","bank":Vector2(1130,550),"float":Vector2(1205,546),"fish":["river_fish","river_fish","silver_char"]},
 "claim":{"name":"Mountain tributary","bank":Vector2(1280,940),"float":Vector2(1280,1000),"fish":["silver_char","river_fish","silver_char"]},
 "greenfields":{"name":"Greenhearth slow river","bank":Vector2(1760,600),"float":Vector2(1840,600),"fish":["pond_perch","pond_perch","river_fish"]}}
const MEALS={
 "root_hotpot":{"effect":"Warm supper: +5% workshop speed for 10 minutes","time":600.0,"work":1.05},
 "barley_bread":{"effect":"Pack 5 provisions; a simple shared supper","time":600.0,"work":1.0},
 "fish_chowder":{"effect":"Good company: better selling terms for 5 minutes","time":300.0,"work":1.0},
 "char_plate":{"effect":"Well fed: +10% workshop speed for 5 minutes","time":300.0,"work":1.10}}
const TRADE=["turnip_seed","carrot_seed","barley_seed","hearthcap_seed","turnip","carrot","barley","hearthcap","river_fish","pond_perch","silver_char","root_hotpot","barley_bread","fish_chowder","char_plate"]
const GROUPS={"Rest":["bed","double_bed"],"Warmth":["hearth"],"Light":["lamp"],"Storage":["chest","bookcase","pantry"],"Character":["desk","orrery","stone_pillar","notice_board"]}
var g
var tab="home"
func _init(game):g=game
static func saved(s)->Dictionary:
 if not s.surface.has("hearth78"):s.surface.hearth78={"version":1,"cooked":{},"meal":{},"best_comfort":0,"favor":false}
 return s.surface.hearth78
static func record_cooking(s,id:String):
 var d=saved(s);d.cooked[id]=int(d.cooked.get(id,0))+1
static func work_bonus(s)->float:
 var m=saved(s).meal
 return float(MEALS.get(m.get("id",""),{}).get("work",1.0)) if float(m.get("until",0))>s.elapsed else 1.0
func own_home()->bool:
 return g.surface.area=="room:home" or g.surface.area.begins_with("home:") or g.surface.area=="claim" or g.surface.architecture.interior()
func furniture()->Array:
 var list=[]
 if g.surface.room():
  for o in g.surface.world.room_objects():
   if o.kind=="furnishing":list.append({"kind":o.furnishing,"p":o.p})
 for d in g.state.surface.decor:
  if g.surface.house.local(d):list.append({"kind":d.kind,"p":Vector2(d.x,d.y)})
 for c in g.state.surface.chests.values():
  if g.surface.house.local(c):list.append({"kind":"chest","p":Vector2(c.x,c.y)})
 return list
func comforts()->Array:
 if not own_home():return []
 var result=[];var things=furniture()
 for group in GROUPS:
  for f in things:
   if f.kind in GROUPS[group]:result.append(group);break
 for f in things:
  if f.kind not in ["table","tea_table","hearth_table","counter","serving_counter"]:continue
  for seat in things:
   if seat.kind=="chair" and seat.p.distance_to(f.p)<110:
    result.append("Dining");return result
 return result
func accessible(f:Dictionary)->bool:
 return g.player.distance_to(f.p)<100 and g.surface.clear_interaction(g.player,f.p+Vector2(0,25))
func near_kind(kinds:Array)->bool:
 for f in furniture():
  if f.kind in kinds and accessible(f):return true
 return false
func kitchen()->bool:
 return own_home() and near_kind(["hearth","counter","serving_counter"])
func table_near()->bool:
 return own_home() and near_kind(["table","tea_table","hearth_table","counter","serving_counter"])
func points()->Array:
 var result=[]
 if own_home():
  for f in furniture():
   if f.kind in ["hearth","counter","serving_counter","table","tea_table","hearth_table"]:result.append({"p":f.p+Vector2(0,28),"name":"Hearth & Homestead","action":"hearth"})
 # Optional visit at an existing host; no new actor or changed routine.
 if g.surface.area=="room:tavern":result.append({"p":Vector2(365,470),"name":"Hedrik's supper invitation","action":"hearth"})
 return result
func kitchen_ready()->bool:
 if kitchen():return true
 if g.surface.area not in HoldRoads.ROOMS:return false
 var p=Vector2(400,525) if g.surface.area=="room:wayfarer" else Vector2(350,475)
 return g.player.distance_to(p)<=75 and g.surface.clear_interaction(g.player,p)
func cook(id:String)->bool:
 var public_kitchen=g.surface.area in HoldRoads.ROOMS
 if id not in MEALS and id not in ["turnip_stew","trout_supper"]:return false
 if public_kitchen:return g.surface.roads.cook(id)
 if not kitchen() or not g.state.craft(id):return false
 g.sound.effect("water",-19);g.save_game();return true
func serve(id:String)->bool:
 if id not in MEALS or not table_near() or not g.state.pay({id:1}):return false
 var c=comforts();var d=saved(g.state);var duration=float(MEALS[id].time)+c.size()*30
 if g.state.tech.has("hearthkeeping"):duration+=120
 if "Dining" in c and HoldDisciplines.has(g.state,"warm_table"):duration+=120
 d.meal={"id":id,"until":g.state.elapsed+duration,"area":g.surface.area,"z":g.surface.house.level(),"claim":g.state.claim_id}
 d.best_comfort=maxi(int(d.best_comfort),c.size())
 if id=="barley_bread":g.state.add("food",5)
 if id=="fish_chowder":g.state.bargain=maxf(g.state.bargain,duration)
 if c.size()>=4:g.state.add("food",1)
 g.sound.effect("build",-20);g.notify("Supper is served · "+MEALS[id].effect+". Home comfort extends your time.");g.save_game();return true
func favor(id:String)->bool:
 var d=saved(g.state)
 if g.surface.area!="room:tavern" or g.player.distance_to(Vector2(365,470))>85 or d.favor or id not in ["root_hotpot","fish_chowder"] or int(d.best_comfort)<3:return false
 if not g.state.pay({id:1}):return false
 d.favor=true;g.state.money+=25;g.state.tech.hearthkeeping=true;g.state.add("barley_seed",3)
 g.notify("Hedrik: A home with a warm table! These old pantry plans are yours. · 25 crowns, Hearthkeeping and barley seed.");g.save_game();return true
func panel():
 saved(g.state)
 var tabs=g.row(g.panel_body)
 for id in ["home","cook","supper","neighbor"]:
  var b=g.small_button(tabs,id.capitalize(),func():tab=id;g.open_panel("hearth",false));b.toggle_mode=true;b.button_pressed=tab==id
 if tab=="home":
  var c=comforts();g.label(g.panel_body,"A home that welcomes you",23)
  g.label(g.panel_body,"Comfort %d / 6 · %s" % [c.size()," · ".join(c)],16)
  g.label(g.panel_body,"Rest, warmth, light, storage, personal character, and a table with a nearby chair. Each category counts once; choose any style. Four comforts pack one extra provision when you serve a meal.",15)
  g.label(g.panel_body,"Comfort adds 30 seconds per category to supper benefits. Sleep is optional. Meals and crops never spoil.",15)
  if not own_home():g.label(g.panel_body,"Visit your own quarters, cottage or claim to assess its furnishings.",15)
  g.button(g.panel_body,"Garden & fishing tools",func():g.open_panel("fieldwork"))
  g.button(g.panel_body,"Furnish this home",func():g.open_panel("home" if g.surface.area=="room:home" else "homestead"))
  var m=saved(g.state).meal
  if float(m.get("until",0))>g.state.elapsed:g.label(g.panel_body,"Shared supper · %d seconds remaining" % int(m.until-g.state.elapsed),16,Color("a7dfcb"))
 elif tab=="cook":cooking_panel()
 elif tab=="supper":
  g.label(g.panel_body,"Set the table",23)
  g.label(g.panel_body,"Stand beside a table or serving counter in your home. A new supper replaces the previous workshop benefit; durations do not stack.",15)
  for id in MEALS:
   g.label(g.panel_body,HoldData.ITEMS[id].name+" · "+MEALS[id].effect,15)
   var b=g.button(g.panel_body,"Serve · %d in pack" % g.state.count(id),func():serve(id);g.open_panel("hearth",false));b.disabled=not table_near() or g.state.count(id)<1
 else:
  g.label(g.panel_body,"Hedrik's welcoming table",23)
  g.label(g.panel_body,"Serve a meal at your own home with at least three comforts, then bring Hedrik either root hotpot or fish chowder. Bought ingredients and meals are welcome. No deadline.",15)
  var d=saved(g.state)
  g.label(g.panel_body,"Reward: 25 crowns, three barley seeds and Hearthkeeping plans. You may research these plans yourself instead.",15)
  if d.favor:g.label(g.panel_body,"Hedrik has toasted your new hearth. The favor is complete.",16)
  else:
   g.label(g.panel_body,"Best supper comfort: %d / 3" % int(d.best_comfort),16)
   for id in ["root_hotpot","fish_chowder"]:
    var b=g.button(g.panel_body,"Give "+HoldData.ITEMS[id].name,func():favor(id);g.open_panel("hearth",false));b.disabled=g.surface.area!="room:tavern" or g.player.distance_to(Vector2(365,470))>85 or int(d.best_comfort)<3 or g.state.count(id)<1
func cooking_panel():
 g.label(g.panel_body,"At the hearth",23)
 g.label(g.panel_body,"Cook beside your hearth or counter, or at a public kitchen. Bring ingredients in your pack; Orla sells every ingredient. Meals finish cooking while you play.",15)
 for id in ["turnip_stew","trout_supper"]+MEALS.keys():
  var recipe=HoldData.RECIPES[id]
  var card=g.section(g.panel_body,recipe.name);g.label(card,HoldData.cost_text(recipe.cost),14)
  g.label(card,MEALS[id].effect if id in MEALS else "Three provisions for your crew",14)
  var b=g.small_button(card,"Prepare",func():cook(id);g.refresh_panel());b.disabled=not g.state.afford(recipe.cost) or g.state.queue.size()>=12 or not kitchen_ready()
func fishing_spot()->Dictionary:
 var area=g.surface.area
 if area not in SPOTS or g.surface.house.level()>0:return {}
 var result=SPOTS[area].duplicate();var p:Vector2=g.player
 if area=="claim":
  var x=clampf(p.x,300,1700);result.bank=Vector2(x,940);result.float=Vector2(x,1000)
 elif area=="greenfields":
  var y=clampf(p.y,300,900);result.bank=Vector2(1760,y);result.float=Vector2(1840,y)
 else:
  var y=clampf(p.y,300,620) if p.y<700 else clampf(p.y,780,900)
  result.bank=Vector2(1130 if p.x<1235 else 1340,y);result.float=Vector2(1205 if p.x<1235 else 1265,y)
 return result
func draw_water():
 # River reaches continue beyond the existing playable bounds, preserving every
 # saved building, garden and route. Fish along their banks, not at fixed nodes.
 var area=g.surface.area
 if area not in ["claim","greenfields"] or g.surface.house.level()>0:return
 if area=="claim":
  for x in range(0,1880,24):
   var shore=977+sin(x*.009)*10
   river_tile(3,Rect2(x,shore,24,1080-shore),Color("b0b6a0"))
   river_tile(4,Rect2(x,shore+9,24,1071-shore),Color("abc6ca"))
  for x in range(20,1880,55):
   var drift=fmod(g.clock*9,45);g.draw_line(Vector2(x+drift,994+sin(x)*5),Vector2(x+drift+24,996+sin(x)*5),Color(.65,.86,.85,.35),1.4)
 else:
  for y in range(200,1080,24):
   var shore=1810+sin(y*.009)*11
   river_tile(3,Rect2(shore,y,1880-shore,24),Color("b0b6a0"))
   river_tile(4,Rect2(shore+9,y,1871-shore,24),Color("c2d1b5"))
  for y in range(220,1050,45):
   var drift=fmod(g.clock*5,35);g.draw_line(Vector2(1824,y+drift),Vector2(1843,y+drift+3),Color(.65,.86,.85,.3),1.4)
func river_tile(index:int,rect:Rect2,tint:Color):
 # Keep texture coordinates continuous across shoreline strips.
 var origin=Vector2(index%3,index/3)*512
 var y=rect.position.y
 while y<rect.end.y:
  var x=rect.position.x;var h=minf(160-fposmod(y,160),rect.end.y-y)
  while x<rect.end.x:
   var w=minf(160-fposmod(x,160),rect.end.x-x);var size=Vector2(w,h)
   var uv=Vector2(fposmod(x,160),fposmod(y,160))
   g.draw_texture_rect_region(g.surface.world.TERRAIN,Rect2(Vector2(x,y),size),Rect2(origin+uv*3.2,size*3.2),tint)
   x+=w
  y+=h
func draw_table():
 var m=saved(g.state).meal
 if float(m.get("until",0))<=g.state.elapsed or m.get("area","")!=g.surface.area or int(m.get("z",0))!=g.surface.house.level() or m.get("claim","")!=g.state.claim_id:return
 for f in furniture():
  if f.kind not in ["table","tea_table","hearth_table","counter","serving_counter"]:continue
  var p=f.p+Vector2(10,-36)
  g.draw_set_transform(-g.camera.round());HoldItemArt.draw(g,Rect2(p+Vector2(-9,-5),Vector2(18,14)),HoldItemArt.item_index(m.id))
  for i in 2:g.draw_arc(p+Vector2(i*7-4,-12-fmod(g.clock*4,8)),4,-PI/2,PI/2,8,Color(1,.93,.8,.3),1)
  g.draw_set_transform(Vector2.ZERO);break
