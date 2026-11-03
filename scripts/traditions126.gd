class_name HoldTraditions126
extends RefCounted
# Small, opt-in customs. No worship counters, allegiance or mandatory observance.
const MEMORIAL=Vector2(220,435)
const ACCESS=Vector2(220,465)
const GODS=[
 ["Keldran","Mining, stone, masonry, endurance"],
 ["Borund","Smithing, craftsmanship, invention"],
 ["Hadrun","Travel, trade, exploration"],
 ["Haldra","Warfare, courage, protection"],
 ["Thorek","Oaths, honor, justice, kingship"],
 ["Brenna","Hearth, family, marriage, hospitality"],
 ["Bromund","Brewing, feasting, friendship, celebration"],
 ["Nyrda","Ancestors, memory, history, death"]]
const REPAIR_COST={"dressed_stone":2}
static func data(s)->Dictionary:
 if not s.surface.has("traditions126"):s.surface.traditions126={"accepted":false,"repaired":false,"remembered":false}
 return s.surface.traditions126
static func ensure_lodge(g):
 # Older frontier buildings already contain their furniture. Add only this fixed
 # memorial; never reseed the room, replace possessions, or reset the calendar.
 if not HoldFrontier103.active(g.state):return
 var area=HoldFrontier103.lodge(g.state)
 for f in g.state.surface.decor:
  if f.area==area and f.kind=="ancestral_shrine" and f.get("fixed",false):return
 g.state.surface.decor.append({"area":area,"kind":"ancestral_shrine","x":MEMORIAL.x,"y":MEMORIAL.y,"z":0,"fixed":true})
static func near(g,p:Vector2)->bool:
 return g.surface.active() and g.player.distance_to(p)<=60 and g.surface.walkable(p) and g.surface.clear_interaction(g.player,p)
static func at_memorial(g)->bool:
 return g.surface.area==HoldFrontier103.lodge(g.state) and near(g,ACCESS)
static func home_shrine(g)->bool:
 for f in g.state.surface.decor:
  if f.kind=="ancestral_shrine" and not f.get("fixed",false) and g.surface.house.local(f) and near(g,Vector2(f.x,f.y)+Vector2(0,30)):return true
 return false
static func points(g)->Array:
 var result=[]
 if g.surface.area==HoldFrontier103.lodge(g.state):result.append({"p":ACCESS,"name":"Shared ancestral memorial","action":"traditions126"})
 for f in g.state.surface.decor:
  if f.kind=="ancestral_shrine" and not f.get("fixed",false) and g.surface.house.local(f):result.append({"p":Vector2(f.x,f.y)+Vector2(0,30),"name":"Household ancestral shrine","action":"hearth126"})
 return result
static func accept(g)->bool:
 var d=data(g.state)
 if not at_memorial(g) or d.accepted or d.repaired:return false
 d.accepted=true;return true
static func repair(g)->bool:
 var d=data(g.state)
 if not at_memorial(g) or not d.accepted or d.repaired or not g.state.pay(REPAIR_COST):return false
 d.repaired=true;g.state.add("food",2)
 HoldOutpost.record(g.state,"memorial126","The shift's weathered names were set into sound stone. Sigrid read each one back; Rurik left two wrapped meals in thanks.")
 return true
static func remember(g)->bool:
 var d=data(g.state)
 if not home_shrine(g) or d.remembered:return false
 d.remembered=true
 HoldOutpost.record(g.state,"hearth126",g.state.appearance.name+" made a place at home for family names and inherited tools. A household begins with what it chooses to remember.")
 return true
static func journal(g):
 var d=g.state.surface.get("traditions126",{})
 if not d.get("accepted",false) or d.get("repaired",false):return
 var card=g.section(g.panel_body,"Names in the stone · optional")
 g.label(card,"Bring 2 dressed stone to the shared memorial in the miners' lodge. Sigrid will check the names; Rurik has promised two meals. No deadline.",15)
 g.small_button(card,"Read the memorial errand",func():g.open_panel("traditions126"))
static func memorial_panel(g):
 var d=data(g.state)
 g.label(g.panel_body,"Names in the stone",22)
 g.label(g.panel_body,"The shift keeps the names of its departed beside a small carved stone. A chisel rests beneath them, worn smooth by several generations of hands.",16)
 if d.repaired:g.label(g.panel_body,"The new name tablets sit firmly in their setting. Sigrid has checked every letter; there is room for the next generation's account.",16)
 else:
  g.label(g.panel_body,"Sigrid's note: Two dressed stones would replace the cracked name tablets. Copy the names exactly. Rurik has put aside two meals for whoever helps. There is no deadline.",16)
  if not d.accepted:
   var b=g.button(g.panel_body,"Offer to restore the name tablets",func():
    if accept(g):g.save_game();g.refresh_panel())
   b.disabled=not at_memorial(g)
  else:
   g.label(g.panel_body,"Bring 2 dressed stone · "+g.requirements(REPAIR_COST),16)
   var b=g.button(g.panel_body,"Fit the new name tablets",func():
    if repair(g):g.save_game();g.refresh_panel())
   b.disabled=not at_memorial(g) or not g.state.afford(REPAIR_COST)
 g.button(g.panel_body,"Read about the Eight and the ancestors",func():g.open_panel("eight126"))
 g.button(g.panel_body,"Leave the memorial",g.close_panel)
static func home_panel(g):
 g.label(g.panel_body,"A place for family memory",22)
 g.label(g.panel_body,"A modest hearthstone holds family names and the memory of tools handed down. Some households speak a blessing to Brenna; others simply tell the children who made the things they use.",16)
 if data(g.state).remembered:g.label(g.panel_body,"Your family remembrance is recorded in the household chronicle. The stone asks nothing more of you.",16)
 else:
  var b=g.button(g.panel_body,"Begin a family remembrance",func():
   if remember(g):g.save_game();g.refresh_panel())
  b.disabled=not home_shrine(g)
 g.button(g.panel_body,"Read about the Eight and the ancestors",func():g.open_panel("eight126"))
 g.button(g.panel_body,"Return to your day",g.close_panel)
static func lore_panel(g):
 g.label(g.panel_body,"The Eight and the ancestors",22)
 g.label(g.panel_body,"Dwarves were made in the image of the Eight Elder Gods. Their domains belong to one life: ore becomes a tool, a shield protects a family, and the worker comes home. Living well as a Dwarf is itself devotion. None demands that another be forsaken.",16)
 for i in GODS.size():g.label(g.panel_body,"%s · %s — %s" % [HoldCalendar.WEEK[i],GODS[i][0],GODS[i][1]],15)
 g.label(g.panel_body,"Worthy ancestors dwell in celestial halls. They are remembered in names, inherited tools and family histories. An exceptional ancestor may truly appear to guide or protect descendants; the greatest may ascend as lesser gods of a family, craft or community. Such encounters are rare enough to shape a life.",16)
 g.button(g.panel_body,"Close the record",g.close_panel)
static func gathering(s)->String:
 var d=HoldCalendar.data(s);var minute=float(d.minute)
 if minute<1080 or minute>=1200:return ""
 return {6:"cup",7:"names"}.get(HoldCalendar.weekday(int(d.day)),"")
static func sigrid(g,t:float)->Dictionary:
 var home=Vector2(620,480);var event=gathering(g.state)
 if event=="":return {"p":home,"aim":Vector2.DOWN,"walking":false,"pose":"drink","role":"Miner","gait":0.0,"phase":float([0,1,2,1][posmod(int(t*2),4)])}
 var path=[home,Vector2(620,565),Vector2(280,565),Vector2(280,465),Vector2(255,465)] if event=="names" else [home,Vector2(580,500)]
 var length=0.0
 for i in range(1,path.size()):length+=path[i-1].distance_to(path[i])
 var minute=float(HoldCalendar.data(g.state).minute)
 var outward=minute<1140;var distance=minf(length,(minute-1080 if outward else 1200-minute)*60.0)
 var p:Vector2=path[0];var aim=Vector2.LEFT if event=="names" else Vector2.DOWN
 var left=distance
 for i in range(1,path.size()):
  var span=path[i-1].distance_to(path[i])
  if left<span:
   p=path[i-1].lerp(path[i],left/span);aim=(path[i]-path[i-1]).normalized()*(1 if outward else -1);break
  left-=span;p=path[i]
 var walking=distance<length
 return {"p":p,"aim":aim,"walking":walking,"pose":"town_walk" if walking else "drink" if event=="cup" else "","role":"Namesday remembrance" if event=="names" else "Cupday company","gait":HoldDrawnLocomotion.time_for_distance(distance if outward else length*2-distance),"phase":float([0,1,2,1][posmod(int(t*2),4)])}
