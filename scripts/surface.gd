class_name HoldSurface
extends RefCounted
# Walkable local scenes share the real game state. No map avatar or second inventory.
const A=preload("res://scripts/art.gd")
const BED=preload("res://assets/directional-v47/bed.png")
const PROPS=preload("res://assets/surface-v46/props.png")
const ROYAL=preload("res://assets/surface-v46/audience-room.png")
const INTERIORS=preload("res://assets/surface-v46/interiors.png")
const MEADOW=preload("res://assets/overworld-v26/meadow.png")
const ATLAS=preload("res://assets/overworld-v26/scenery.png")
const SIZE=Vector2(1880,1080)
const ROOM_SIZE=Vector2(960,720)
const FIR=preload("res://assets/pinewood-v40/silver-fir.png")
const NAMES={"hearthward":"Keldrath · Hearthward · Z 0","crownward":"Keldrath · Crownward · Z +1","forgeward":"Keldrath · Forgeward · Z -1","trail":"The High Trail","pinewood":"Pinewood","claim":"Your mountain homestead"}
const TREES=[Vector2(430,430),Vector2(690,610),Vector2(930,370),Vector2(1190,620),Vector2(1430,420),Vector2(1630,690),Vector2(1550,860)]
var g
var area="hearthward"
var return_area="hearthward"
var selected_chest=""
var placing=""
var direction=Vector2.DOWN
var foot=0.0
var cut_clock=0.0
var cut_target=-1
var cut_flash=0.0
var route_hint=""
var ground_cache={}
var bed_bounds=Rect2i()
var house

func _init(game):
 g=game;house=HoldHearthcraft.new(self)
func active()->bool:return g.playing and g.zone!="mine" and g.room_id!="training"
func ensure():
 HoldForestry.ensure(g.state)
 if g.state.surface.is_empty():g.state.surface={"version":1,"area":"hearthward","positions":{},"chests":{},"homes":{},"decor":[],"facts":{}}
 var s=g.state.surface
 for key in ["positions","chests","homes","facts"]:
  if not s.has(key):s[key]={}
 if not s.has("decor"):s.decor=[]
 if g.state.claim_id!="" and not s.homes.has(g.state.claim_id):
  s.homes[g.state.claim_id]={"level":0,"lesson":false}
  var id="claim:"+g.state.claim_id+":starter"
  s.chests[id]={"area":"home:"+g.state.claim_id,"x":650.0,"y":380.0,"items":{}}
func room()->bool:return area.begins_with("room:") or area.begins_with("home:")
func size()->Vector2:return ROOM_SIZE if room() else SIZE
func label()->String:
 if area.begins_with("home:"):return "Your hearth · "+HoldOutpost.title(g.state)
 if area.begins_with("room:"):return HoldInteriors.ROOMS.get(g.room_id,{"name":"Keldrath"}).name
 if area=="claim":return NAMES[area]+" · Z+"+str(house.level())
 return NAMES.get(area,"Keldrath")
func remember():
 ensure()
 if not active():return
 g.state.surface.area=area;g.state.surface.return_area=return_area
 g.state.surface.positions[area]=[g.player.x,g.player.y]
func restore():
 ensure()
 if g.zone=="mine":return
 var desired=str(g.state.surface.get("area","hearthward"))
 if g.zone=="claim" and not desired.begins_with("home:"):desired="claim"
 elif g.zone=="road":desired="pinewood"
 elif g.zone=="approach":desired="trail"
 area=desired;return_area=str(g.state.surface.get("return_area","hearthward"))
 g.room_id="home" if area.begins_with("home:") else (area.trim_prefix("room:") if area.begins_with("room:") else "")
 var p=g.state.surface.positions.get(area,[])
 g.player=Vector2(p[0],p[1]) if p.size()==2 else spawn(area)
 if not walkable(g.player):
  if area=="claim":house.data().z=0
  g.player=spawn(area)
 g.grounded=true;g.camera=camera_target();g.velocity=Vector2.ZERO
func spawn(id:String)->Vector2:
 if id.begins_with("room:") or id.begins_with("home:"):return Vector2(480,590)
 return {"hearthward":Vector2(1180,720),"crownward":Vector2(724,680),"forgeward":Vector2(331,906),"trail":Vector2(245,690),"pinewood":Vector2(260,650),"claim":Vector2(300,760)}.get(id,Vector2(480,600))
func enter(id:String,at:Vector2=Vector2.INF):
 ensure()
 if id=="claim" and g.state.claim_id=="":g.open_panel("charters");return
 if id=="room:throne" and HoldOnboarding.ensure(g.state).fresh and HoldOnboarding.stage(g.state)<4:g.notify("Ivar's first-shift reference opens the royal audience.");return
 if id in ["trail","pinewood","claim"] and g.state.opening==0:g.notify(g.region_travel_hint());return
 remember();var old=area
 g.flush_pickups()
 var claim_site=id=="claim" or id.begins_with("home:") or (id.begins_with("room:") and g.state.active_site=="claim" and old=="claim")
 g.state.switch_site("claim" if claim_site else "hold",g.geo)
 if id.begins_with("room:") or id.begins_with("home:"):
  if not room():return_area=old
  elif id!=old:return_area="claim" if claim_site else ("crownward" if id=="room:throne" else "forgeward" if id=="room:forge" else "hearthward")
 if old=="claim" and id!="claim":house.data().z=0
 area=id
 g.zone="claim" if claim_site else ("road" if id=="pinewood" else "approach" if id=="trail" else "hub")
 g.room_id="home" if id.begins_with("home:") else id.trim_prefix("room:") if id.begins_with("room:") else ""
 g.player=spawn(id) if at==Vector2.INF else at
 if not walkable(g.player):g.player=spawn(id)
 g.velocity=Vector2.ZERO;g.grounded=true;g.walking_pose=false;g.gait_clock=0;g.swing=0;placing="";cut_clock=0;cut_target=-1;house.impact=0
 g.combat.armed=false;g.combat.reset_actions();g.construction.selected=""
 g.state.region_travel.active=false;g.state.hold_travel.active=false
 g.camera=camera_target();g.close_panel();g.spawn_agents();g.sound.set_context(g.room_id if room() else g.zone)
 g.begin_transition(label().to_upper());g.save_game()
func leave():
 var back=return_area
 var p=g.state.surface.positions.get(back,[])
 enter(back,Vector2(p[0],p[1])+Vector2(0,35) if p.size()==2 else spawn(back))
func camera_target()->Vector2:
 if room():return Vector2(0,135)
 return (g.player-Vector2(480,300)).clamp(Vector2(0,-65),Vector2(maxf(0,size().x-960),maxf(-65,size().y-480)))
func level()->int:return 0 if area=="crownward" else 2 if area=="forgeward" else 1
func points()->Array:
 var result=[]
 if area in ["hearthward","crownward","forgeward"]:
  for i in HoldDistrictMap.DOORS:
   if int(i)/7!=level():continue
   var d=HoldDistrictMap.DOORS[i];var action="room:"+d.id
   if d.id=="concourse":action="anniversary"
   elif d.id=="gate":action="trail"
   elif d.id=="training":action="training"
   result.append({"p":HoldFloorPlan.door(i),"name":d.name if d.id!="gate" else "King's Gate · High Trail","action":action})
  result.append(spot(1636,878,"Hold lift","hold_lift"))
  if level()==1:
   result.append({"p":Vector2(724,637),"name":"Royal stairs · Crownward","action":"crownward"})
   result.append({"p":Vector2(331,906),"name":"Forge stairs · Forgeward","action":"forgeward"})
  else:result.append({"p":Vector2(724,637) if level()==0 else Vector2(331,906),"name":"Stairs · Hearthward","action":"hearthward"})
 elif area=="trail":
  result=[spot(220,690,"Keldrath's gate","hearthward"),spot(950,300,"Old Workings · enter mine","mine"),spot(470,920,"Pinewood trail","pinewood"),spot(1650,700,"Your claim" if g.state.claim_id!="" else "Unclaimed mountain · charter required","claim")]
 elif area=="claim":
  result=[spot(180,790,"High Trail · Keldrath","trail"),spot(500,440,"Your home","home:"+g.state.claim_id),spot(1280,345,"Your Deepworks","mine"),spot(970,690,"Founding stones","camp"),spot(1370,760,"Workshop","room:forge"),spot(1650,840,"Launchyard","ship"),spot(740,780,"Homestead workbench","homestead")]
 elif area=="pinewood":result=[spot(180,650,"High Trail","trail"),spot(300,790,"Woodcutter's field board","pinewood_panel")]
 elif room():
  result=[spot(480,620,"Leave · "+NAMES.get(return_area,"your claim"),"leave")]
  if area.begins_with("home:"):
   result.append(spot(290,420,"Bed · rest and save","rest"));result.append(spot(735,515,"Homestead workbench","homestead"))
  else:
   var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
   result.append(spot(620,410,HoldInteriors.ROOMS.get(g.room_id,{"action":"Rest and supplies"}).action,"talk:"+host if host!="" and g.state.active_site=="hold" else g.room_id))
   if g.room_id=="forge":result.append(spot(740,490,"Practice bay","training"))
   if g.room_id=="tavern":
    var guests=HoldNpcPresence.tavern_guests(g.state)
    for i in mini(3,guests.size()):result.append(spot(270+i*170,550,"Speak with "+g.state.npc(guests[i]).first_name,"talk:"+guests[i]))
 if area=="claim" and house.level()==0:
  var index=0
  for id in g.state.outpost.get("crew",{}):
   result.append(spot(1040+index*75,850,"Speak with "+g.state.npc(id).first_name,"talk:"+id));index+=1
 if area=="claim" and house.level()>0:result=[]
 for id in g.state.surface.chests:
  var c=g.state.surface.chests[id]
  if house.local(c):result.append(spot(c.x,c.y,"Storage chest","chest:"+id))
 result.append_array(house.points())
 for d in g.state.surface.decor:
  if house.local(d) and d.kind=="bed":result.append(spot(d.x,d.y+25,"Bed · rest in your own house","house_rest"))
 return result
func spot(x:float,y:float,title:String,action:String)->Dictionary:return {"p":Vector2(x,y),"name":title,"action":action}
func nearest()->Dictionary:
 var found={};var distance=78.0
 for p in points():
  var d=g.player.distance_to(p.p)
  if d<distance:distance=d;found=p
 return found
func use():
 var p=nearest()
 if p.is_empty():g.notify("Walk to a doorway, signpost, chest or workstation and press E.");return
 action(p.action)
func action(id:String):
 if id=="leave":leave()
 elif id=="mine":
  remember();g.state.surface.mine_return=area;g.change_zone("mine")
 elif id=="house_up":house.use_stairs(true)
 elif id=="house_down":house.use_stairs(false)
 elif id.begins_with("house:"):house.toggle(id.trim_prefix("house:"))
 elif id=="house_rest":
  for d in g.state.surface.decor:
   if house.local(d) and d.kind=="bed" and g.player.distance_to(Vector2(d.x,d.y))<85:house.rest(Vector2(d.x,d.y));break
 elif id=="rest":
  g.state.surface.facts.rest=true;g.save_game();g.sound.effect("door",-18);g.notify("A warm bed and a sound roof. Rested; fortune saved.")
 elif id=="training":g.enter_room("training")
 elif id.begins_with("talk:"):HoldConversation.start(g,id.trim_prefix("talk:"))
 elif id.begins_with("chest:"):selected_chest=id.trim_prefix("chest:");g.open_panel("storage")
 elif id=="pinewood_panel":g.open_panel("pinewood")
 elif id in ["homestead","camp","ship","home","forge","anniversary","hold_lift"]:g.open_panel(id)
 else:enter(id)
func base_obstacles()->Array:
 var list=[]
 if area=="claim" and house.level()>0:return list
 if room():
  list=[Rect2(185,260,185,160),Rect2(560,280,220,110)]
  if g.room_id=="home":list=[Rect2(185,260,185,160),Rect2(580,230,180,125),Rect2(705,440,85,100)]
  if g.room_id=="throne":list=[Rect2(560,285,200,100)]
  if g.room_id=="tavern":list=[Rect2(230,270,540,105),Rect2(240,425,100,100),Rect2(420,425,100,100),Rect2(600,425,100,100)]
 elif area=="trail":list=[Rect2(65,210,300,390),Rect2(810,110,280,165)]
 elif area=="claim":list=[Rect2(340,240,320,170),Rect2(1150,120,260,190),Rect2(1250,540,240,170)]
 elif area=="pinewood":
  for i in TREES.size():
   if g.state.road_trees[i]>0:list.append(Rect2(TREES[i]-Vector2(17,24),Vector2(34,30)))
 return list
func obstacles()->Array:
 var list=base_obstacles()
 list.append_array(house.obstacles())
 for c in g.state.surface.chests.values():
  if house.local(c):list.append(Rect2(Vector2(c.x,c.y)-Vector2(20,24),Vector2(40,26)))
 for d in g.state.surface.decor:
  if house.local(d):list.append(Rect2(Vector2(d.x,d.y)-Vector2(22,25),Vector2(44,30)))
 return list
func walkable(p:Vector2)->bool:
 if area=="claim" and house.level()>0 and not house.on_floor(p,house.level()):return false
 if area in ["hearthward","crownward","forgeward"] and not HoldFloorPlan.walkable(p,level()):return false
 elif room():
  if not Rect2(180,355,600,280).has_point(p):return false
 elif not Rect2(90,210,1700,750).has_point(p):return false
 for r in obstacles():
  if r.grow(10).has_point(p):return false
 return true
func move(dt:float):
 var input=Input.get_vector("left","right","up","down")
 if input!=Vector2.ZERO:direction=input
 var delta=input*185*dt
 var before=g.player
 var steps=maxi(1,ceili(delta.length()/6.0))
 for i in steps:
  for axis in [Vector2(delta.x,0)/steps,Vector2(0,delta.y)/steps]:
   if walkable(g.player+axis):g.player+=axis
 g.velocity=(g.player-before)/maxf(dt,.001);g.grounded=true;g.walking_pose=g.velocity.length()>1
 if absf(input.x)>.1:g.face=1 if input.x>0 else -1
 if g.walking_pose:
  g.gait_clock+=dt;foot+=dt
  if foot>.38:g.sound.footstep("wood" if room() else "stone");foot=0
 cut_flash=maxf(0,cut_flash-dt)
 if area=="pinewood":chop(dt)
 house.update(dt)
func input(e:InputEvent)->bool:
 if not active() or g.panel_id!="":return false
 if e is InputEventKey and e.pressed and not e.echo:
  if e.keycode==KEY_E:
   if e.shift_pressed and area=="claim":house.use_stairs(false)
   else:use()
   return true
  if e.keycode==KEY_G:g.open_panel("wayfinding");return true
  if e.keycode==KEY_O and (area=="claim" or area.begins_with("home:")):g.open_panel("homestead");return true
  if e.keycode in [KEY_SPACE,KEY_V,KEY_X,KEY_P,KEY_F,KEY_Q]:return true
 if e is InputEventMouseButton and e.pressed:
  if e.button_index==MOUSE_BUTTON_RIGHT:placing="";return true
  if e.button_index==MOUSE_BUTTON_LEFT and placing!="":
   if placing.begins_with("house:"):house.build(g.get_global_mouse_position()+g.camera,placing.trim_prefix("house:"));house.timer=.18
   else:place(g.get_global_mouse_position()+g.camera)
   return true
 return false
func place(p:Vector2)->bool:
 ensure();p=(p/40).round()*40
 if not (area=="claim" or area.begins_with("home:")):g.notify("Build around your own hearth and claim.");return false
 if p.distance_to(g.player)>140 or not walkable(p):g.notify("Choose clear ground within reach.");return false
 for point in points():
  if p.distance_to(point.p)<80:g.notify("Keep doorways, workstations and paths clear.");return false
 var cost={"wood":4} if placing=="chest" else {"wood":5,"stone":2} if placing=="bed" else {"wood":3,"stone":2}
 if not g.state.afford(cost):g.notify("Bring "+("4 timber" if placing=="chest" else "3 timber and 2 stone")+" in your pack.");return false
 for k in cost:g.state.add(k,-cost[k])
 if placing=="chest":
  var serial=int(g.state.surface.get("next_chest",0))
  while g.state.surface.chests.has("chest:"+str(serial)):serial+=1
  g.state.surface.next_chest=serial+1
  var id="chest:"+str(serial)
  g.state.surface.chests[id]={"area":area,"z":house.level(),"x":p.x,"y":p.y,"items":{}}
 else:g.state.surface.decor.append({"area":area,"z":house.level(),"x":p.x,"y":p.y,"kind":placing})
 g.state.surface.facts.build=true;placing="";g.sound.effect("build");g.save_game();return true
func transfer(item:String,n:int,deposit:bool)->int:
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:return 0
 var source=g.state.inventory if deposit else c.items;var target=c.items if deposit else g.state.inventory
 var moved=mini(maxi(0,n),int(source.get(item,0)))
 if moved<=0:return 0
 source[item]=int(source.get(item,0))-moved;target[item]=int(target.get(item,0))+moved
 if source[item]==0:source.erase(item)
 g.state.surface.facts.storage=true;g.save_game();return moved
func recover_chest()->bool:
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:return false
 for value in c.items.values():
  if int(value)>0:g.notify("Empty the chest before taking it apart.");return false
 g.state.surface.chests.erase(selected_chest);g.state.add("wood",4);g.close_panel();g.save_game();return true
func recover_decor()->bool:
 for i in g.state.surface.decor.size():
  var d=g.state.surface.decor[i]
  if house.local(d) and g.player.distance_to(Vector2(d.x,d.y))<85:
   g.state.surface.decor.remove_at(i);g.state.add("wood",5 if d.kind=="bed" else 3);g.state.add("stone",2);g.save_game();g.close_panel();return true
 g.notify("Stand beside a lamp or table you placed.");return false
func chest_panel():
 var c=g.state.surface.chests.get(selected_chest,{})
 if c.is_empty() or not house.local(c) or g.player.distance_to(Vector2(c.x,c.y))>85:g.label(g.panel_body,"Walk to your chest and press E.");return
 g.label(g.panel_body,"YOUR CHEST · YOUR SUPPLIES",20,Color("edc98a"))
 g.label(g.panel_body,"Stored items stay here. Withdraw materials into your pack before crafting or selling. Mines keep their own buckets and stockpiles.",14)
 var row=g.row(g.panel_body)
 g.small_button(row,"Store all carried resources",func():
  for k in g.state.inventory.keys():transfer(k,g.state.count(k),true)
  g.open_panel("storage",false))
 g.small_button(row,"Take all",func():
  for k in c.items.keys():transfer(k,int(c.items[k]),false)
  g.open_panel("storage",false))
 g.small_button(g.panel_body,"Dismantle empty chest · recover 4 timber",recover_chest)
 for item in HoldData.ITEMS:
  if g.state.count(item)+int(c.items.get(item,0))==0:continue
  var key=str(item);var line=g.row(g.panel_body);HoldItemArt.icon(line,key)
  g.label(line,HoldData.ITEMS[key].name+"   Pack %d · Chest %d" % [g.state.count(key),int(c.items.get(key,0))],14)
  g.small_button(line,"Store 10",func():transfer(key,10,true);g.open_panel("storage",false))
  g.small_button(line,"Take 10",func():transfer(key,10,false);g.open_panel("storage",false))
func home_panel():
 ensure();g.label(g.panel_body,"A HEARTH OF YOUR OWN",22,Color("edc98a"))
 if g.state.claim_id=="":g.label(g.panel_body,"Your mountain charter includes a starter cottage and a storage chest.");return
 var h=g.state.surface.homes[g.state.claim_id]
 g.label(g.panel_body,"Your charter includes a weatherproof stone cottage, a bed and a personal chest. Improve it at your own pace.",16)
 for step in [["rest","1 · Enter your cottage and rest at the bed."],["storage","2 · Put supplies in your chest, then withdraw what you need."],["build","3 · Place a chest, table or lamp around your home."]]:g.label(g.panel_body,("✓ " if g.state.surface.facts.get(step[0],false) else "○ ")+step[1],15)
 for kind in ["chest","table","lamp"]:
  var id=str(kind)
  g.button(g.panel_body,"Place "+id+" · "+("4 timber" if id=="chest" else "3 timber + 2 stone"),func():placing=id;g.close_panel();g.notify("Choose clear ground nearby. LMB builds; right click cancels."))
 g.small_button(g.panel_body,"Recover nearby placed furnishing",recover_decor)
 g.button(g.panel_body,"Build a house · floors, walls, doors and roofs",func():g.open_panel("house_build"))
 if int(h.level)==0:
  var b=g.button(g.panel_body,"Improve cottage · 12 timber + 8 stone",func():
   if int(h.level)==0 and g.state.afford({"wood":12,"stone":8}):
    g.state.add("wood",-12);g.state.add("stone",-8);h.level=1;g.sound.effect("build");g.save_game();g.open_panel("homestead",false))
  b.disabled=not g.state.afford({"wood":12,"stone":8})
 else:g.label(g.panel_body,"A proper freeholder’s hearth: copper roofing, a woven rug and a warm fire.",16,Color("a7d5be"))
 g.label(g.panel_body,"O opens this board on your claim. I opens your pack. E opens nearby chests and doors. Stored resources are never spent remotely.",14)
func lift_panel():
 g.label(g.panel_body,"THE HOLD LIFT",22,Color("edc98a"))
 for destination in ["crownward","hearthward","forgeward"]:
  var id=str(destination)
  g.button(g.panel_body,NAMES[id],func():enter(id,Vector2(1636,878)))
func guide_panel():
 g.label(g.panel_body,"FOLLOW THE PATHS",22,Color("edc98a"))
 g.label(g.panel_body,"Walk with WASD or arrows. Press E at doors, stairs, trail signs and workstations. You are here: "+label()+".",16)
 for text in ["Hearthward: quarters, tavern, exchange and Ivar’s office.","Royal stairs → Crownward (Z +1): Lord Eirik and the survey office.","Forge stairs → Forgeward (Z -1): Borin’s forge and practice bay.","King’s Gate → High Trail → Old Workings, Pinewood and your claim.","Your claim: home beside the mine, founding stones, workshop and launchyard. O builds your house; roofs and upper floors use real Z-levels. E climbs, Shift+E descends at your built landings."]:
  g.label(g.panel_body,text,16)
 g.label(g.panel_body,"G is a guide, not a travel screen. Every doorway takes you to a connected local area. J keeps your existing quests.",14)
func chop(dt:float):
 HoldForestry.ensure(g.state)
 if g.tool!=2 or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):cut_clock=0;cut_target=-1;return
 var aim=g.get_global_mouse_position()+g.camera;var best=-1;var dist=80.0
 for i in TREES.size():
  if g.state.road_trees[i]<=0 and HoldForestry.logs(g.state,i)<=0:continue
  var d=aim.distance_to(TREES[i]-Vector2(0,25))
  if d<dist and g.player.distance_to(TREES[i])<105:dist=d;best=i
 if best<0:cut_clock=0;return
 if best!=cut_target:cut_clock=0;cut_target=best
 g.face=1 if TREES[best].x>g.player.x else -1
 cut_clock+=dt
 if cut_clock<.36:return
 cut_clock-=.36;cut_flash=.16
 var is_log=g.state.road_trees[best]<=0
 if is_log:
  if HoldForestry.fall_age(g.state,best)<HoldForestry.FALL_TIME:return
  g.state.forestry.logs[str(best)]=HoldForestry.logs(g.state,best)-1
 else:
  g.state.road_trees[best]-=1
  if g.state.road_trees[best]==0:
   g.state.forestry.logs[str(best)]=3;g.state.forestry.fell_at[str(best)]=g.state.elapsed;g.state.forestry.direction[str(best)]=g.face
 g.state.add("wood",2);HoldOnboarding.fact(g.state,"woodcut",2);g.sound.effect("wood",-14)
 g.notify("+2 timber · "+("Chop the fallen trunk for more." if g.state.road_trees[best]<=0 else "The cut is deepening."))
func hud():
 g.objectives.visible=false
 g.hud.text=label().to_upper()+"   %d CROWNS" % g.state.money
 if g.panel_id=="":
  var p=nearest()
  g.footer.text="LMB place "+placing+" · Right click cancel" if placing!="" else ("E · "+p.name if not p.is_empty() else "WASD walk   E interact   I pack   G directions   J journal")
  if g.notice_time>0:g.footer.text=g.notice
func draw():
 var cam=g.camera.round();g.draw_set_transform(-cam)
 if area in ["hearthward","crownward","forgeward"]:
  g.draw_texture_rect(HoldFloorPlan.PLATES[level()],Rect2(Vector2.ZERO,SIZE),false)
 elif room():draw_room()
 else:draw_outdoors()
 if area=="claim" and house.level()>0:g.draw_rect(Rect2(Vector2.ZERO,SIZE),Color(.02,.06,.08,.5))
 house.floor_draw()
 var objects=[]
 if area=="claim":
  for k in house.tiles():
   if house.tiles()[k].get("wall","")!="":objects.append({"p":house.center(house.coords(k))+Vector2(0,20),"kind":"wall","c":house.coords(k)})
 for c in g.state.surface.chests.values():
  if house.local(c):objects.append({"p":Vector2(c.x,c.y),"kind":"chest_open" if g.panel_id=="storage" and c==g.state.surface.chests.get(selected_chest,{}) else "chest"})
 for d in g.state.surface.decor:
  if house.local(d):objects.append({"p":Vector2(d.x,d.y),"kind":d.kind})
 if room() and not area.begins_with("home:"):
  var host=HoldInteriors.ROOMS.get(g.room_id,{}).get("host","")
  if host!="" and g.state.active_site=="hold":objects.append({"p":Vector2(620,370 if host=="eirik" else 410),"kind":"npc","id":host})
  if g.room_id=="tavern":
   var guests=HoldNpcPresence.tavern_guests(g.state)
   for i in mini(3,guests.size()):objects.append({"p":Vector2(270+i*170,550),"kind":"npc","id":guests[i]})
 if area=="claim" and house.level()==0:
  var index=0
  for id in g.state.outpost.get("crew",{}):
   objects.append({"p":Vector2(1040+index*75,850),"kind":"npc","id":id});index+=1
 if area=="hearthward" and HoldAnniversary.ensure(g.state).complete:
  g.draw_set_transform(-cam);HoldAnniversary.station(g,Vector2(1259,370),g.clock)
 if area=="pinewood":
  for i in TREES.size():objects.append({"p":TREES[i],"kind":"tree","i":i})
 objects.append({"p":g.player,"kind":"player"});objects.sort_custom(func(a,b):return a.p.y<b.p.y)
 for o in objects:
  g.draw_set_transform(-cam)
  if o.kind=="player":actor(o.p,g.state.appearance,g.walking_pose,g.face,g.gait_clock)
  elif o.kind=="npc":
   if o.id=="eirik":g.draw_texture_rect(HoldRoyalHall.SPRITE,Rect2(o.p-Vector2(57,125),Vector2(114,136)),false)
   elif o.id=="borin" and g.room_id=="forge":
    A.draw_offset=-cam;HoldNpcActivity.smith(g,o.p,g.clock,g.state.opening>=2);A.draw_offset=Vector2.ZERO
   elif g.room_id=="tavern":
    A.draw_offset=-cam;HoldNpcActivity.social(g,o.p,g.clock,-1,g.state.npc(o.id),true);A.draw_offset=Vector2.ZERO
   else:actor(o.p,g.state.npc(o.id),false,-1,g.clock)
   g.draw_set_transform(-cam);A.text(g,o.p+Vector2(-30,-140 if o.id=="eirik" else -90),g.state.npc(o.id).first_name,12,Color("e8ce93"))
  elif o.kind=="wall":house.wall_draw(o.c)
  elif o.kind=="tree":draw_fir(o.p,int(o.i))
  else:furniture(o.p,o.kind)
 g.draw_set_transform(-cam)
 house.roof_draw()
 if area in ["hearthward","crownward","forgeward"]:
  for point in points():
   # Only the nearby door is captioned; the painted architecture stays readable.
   if point.p.distance_to(g.player)<240:plaque(point.p+Vector2(0,-72),point.name)
 else:
  for point in points():
   if point.action.begins_with("chest:") or point.action.begins_with("talk:") or point.action.begins_with("house:") or point.action in ["house_rest","house_up","house_down"]:continue
   if not room():signpost(point.p,point.name)
 var near=nearest()
 if not near.is_empty():
  g.draw_arc(near.p+Vector2(0,6),23,0,TAU,24,Color("dfbd76"),2)
  plaque(near.p+Vector2(0,38),"E · "+near.name)
 house.preview()
 if placing!="" and not placing.begins_with("house:"):
  var p=((g.get_global_mouse_position()+g.camera)/40).round()*40
  g.draw_rect(Rect2(p-Vector2(22,24),Vector2(44,30)),Color(.5,.9,.7,.4) if walkable(p) else Color(.9,.3,.2,.4))
 g.draw_set_transform(Vector2.ZERO);A.draw_offset=Vector2.ZERO
 g.draw_rect(Rect2(0,0,960,74),Color("10232d"));g.draw_line(Vector2(20,73),Vector2(940,73),Color("6e796b"))
 g.draw_rect(Rect2(0,498,960,42),Color("10232d"))
 if g.panel_id=="" and area in ["hearthward","crownward","forgeward"] and g.state.tracked_npc!="":
  var target=HoldNpcPresence.room_for(g.state,g.state.tracked_npc)
  for i in HoldDistrictMap.DOORS:
   if HoldDistrictMap.DOORS[i].id==target:
    var here=int(i)/7==level()
    var dest=HoldFloorPlan.door(i) if here else (Vector2(724,637) if int(i)/7==0 else Vector2(331,906))
    var screen=(dest-cam).clamp(Vector2(130,105),Vector2(830,445))
    plaque(screen,g.state.npc(g.state.tracked_npc).first_name+" · "+("door" if here else "take stairs"))
 if g.panel_id!="":g.draw_rect(Rect2(0,0,960,540),Color(.02,.04,.055,.48))
func actor(p:Vector2,profile:Dictionary,walking:bool,face:int,time:float):
 var cam=g.camera.round()
 g.draw_set_transform(p-cam,0,Vector2(1,.3));g.draw_circle(Vector2.ZERO,19,Color(0,0,0,.3))
 var look=profile.duplicate();look.air_pose=0
 # Original complete character drawings retain wardrobe, beard and silhouette.
 if p==g.player and cut_target<0:
  HoldDirectional.draw(g,p-cam,look,direction,walking,time,.85,-cam)
 else:HoldCharacterArt.draw_sprite(g,p-cam,time,walking,face,look,false,-cam,false,.85,Color("eff0dc"))
 g.draw_set_transform(-cam)
 if p==g.player and house.impact>0:
  var hand=p+Vector2(g.face*17,-29);var contact=house.contact-Vector2(0,5)
  var phase=1-house.impact/.24;var end=hand+(contact-hand).limit_length(43).rotated(-g.face*(1-phase)*.7)
  HoldCharacterArt.draw_tool(g,hand-cam,end-cam,1,-cam,g.face,-1,.7)
  for i in 5:g.draw_circle(contact+Vector2.from_angle(i*1.3)*phase*18,1.5,Color("c9bb92"))
 if p==g.player and area=="pinewood" and cut_target>=0:
  var hand=p+HoldCharacterArt.carry_hand(0,look)*Vector2(face,1)*.85
  var target=TREES[cut_target]-Vector2(0,18)
  var end=hand+(target-hand).normalized()*35
  end=hand+(end-hand).rotated(-face*(1-clampf(cut_clock/.36,0,1))*.8)
  HoldCharacterArt.draw_tool(g,hand-cam,end-cam,2,-cam,face,-1,.9)
  if cut_flash>0:
   for i in 7:g.draw_circle(target+Vector2.from_angle(i*.9)*(8+( .16-cut_flash)*90),2,Color("d7b079"))
func plaque(p:Vector2,text:String):
 var width=ThemeDB.fallback_font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x+18
 var style=StyleBoxFlat.new();style.bg_color=Color(.06,.13,.16,.9);style.border_color=Color("9b885e");style.set_border_width_all(1);style.set_corner_radius_all(3)
 g.draw_style_box(style,Rect2(p-Vector2(width/2,17),Vector2(width,24)))
 A.text(g,p-Vector2(width/2-9,0),text,13,Color("ead4a0"))
func signpost(p:Vector2,text:String):
 HoldWorldDetails.prop(g,p+Vector2(-48,4),"waystone",62)
 if p.distance_to(g.player)<300:plaque(p+Vector2(0,-65),text)
func prop(p:Vector2,index:int,width:float):
 var cell=Vector2(PROPS.get_width()/3.0,PROPS.get_height()/2.0)
 g.draw_texture_rect_region(PROPS,Rect2(p-Vector2(width/2,width*.94),Vector2(width,width)),Rect2(Vector2(index%3,index/3)*cell,cell))
func furniture(p:Vector2,kind:String):
 if kind=="bed":
  if bed_bounds.size==Vector2i.ZERO:bed_bounds=BED.get_image().get_used_rect()
  g.draw_texture_rect_region(BED,Rect2(p-Vector2(26,77),Vector2(52,82)),Rect2(bed_bounds))
  return
 var index={"chest":0,"chest_open":1,"table":2,"lamp":3}.get(kind,2)
 prop(p,index,64 if kind.begins_with("chest") else 82 if kind=="table" else 64)
 if kind=="lamp":
  for r in [85,60,35]:g.draw_circle(p-Vector2(0,32),r,Color(1,.7,.3,.035))
func building(p:Vector2,width:float,title:String,roof:Color):
 var rect=Rect2(p-Vector2(width/2,180),Vector2(width,165))
 g.draw_rect(Rect2(rect.position+Vector2(12,18),rect.size),Color(0,0,0,.23))
 g.draw_rect(rect,Color("646e6b"))
 for y in range(int(rect.position.y+65),int(p.y-15),22):
  g.draw_line(Vector2(rect.position.x,y),Vector2(rect.end.x,y),Color("414e50"),2)
  for x in range(int(rect.position.x+posmod(y,2)*20),int(rect.end.x),42):g.draw_line(Vector2(x,y),Vector2(x,y+20),Color("4c5959"),1)
 var poly=PackedVector2Array([p+Vector2(-width/2-18,-100),p+Vector2(-width/2+12,-200),p+Vector2(width/2-12,-200),p+Vector2(width/2+18,-100)])
 g.draw_colored_polygon(poly,roof)
 for y in [-180,-158,-136,-114]:g.draw_line(p+Vector2(-width/2+8,y),p+Vector2(width/2-8,y),roof.darkened(.25),3)
 g.draw_line(p+Vector2(-width/2-18,-99),p+Vector2(width/2+18,-99),Color("c6ae7d"),6)
 g.draw_rect(Rect2(p+Vector2(-26,-76),Vector2(52,68)),Color("273c40"));g.draw_rect(Rect2(p+Vector2(-20,-70),Vector2(40,60)),Color("85603c"))
 g.draw_circle(p+Vector2(12,-38),3,Color("ecc67e"))
 for x in [-width*.31,width*.31]:
  g.draw_rect(Rect2(p+Vector2(x-16,-78),Vector2(32,35)),Color("c6ae7d"));g.draw_rect(Rect2(p+Vector2(x-12,-74),Vector2(24,27)),Color("e7ba6b"));g.draw_line(p+Vector2(x,-74),p+Vector2(x,-47),Color("6f5940"),3)
 g.draw_rect(Rect2(p+Vector2(-35,-12),Vector2(70,15)),Color("abb09b"))
 plaque(p+Vector2(0,-220),title)
func draw_outdoors():
 g.draw_texture_rect(MEADOW,Rect2(Vector2.ZERO,SIZE),false,Color("a4b2a2"))
 var roads=[PackedVector2Array([Vector2(170,790),Vector2(500,690),Vector2(960,690),Vector2(1650,790)]),PackedVector2Array([Vector2(500,690),Vector2(500,440)]),PackedVector2Array([Vector2(960,690),Vector2(1280,345)])] if area=="claim" else [PackedVector2Array([Vector2(180,650),Vector2(700,690),Vector2(1100,600),Vector2(1650,700)]),PackedVector2Array([Vector2(700,690),Vector2(950,300)]),PackedVector2Array([Vector2(700,690),Vector2(470,920)])]
 if not ground_cache.has(area):
  var img=Image.create(940,540,false,Image.FORMAT_RGBA8)
  var noise=FastNoiseLite.new();noise.seed=g.state.seed_value;noise.frequency=.023
  for y in 540:
   for x in 940:
    var p=Vector2(x*2,y*2);var dist=10000.0
    for path in roads:
     for j in path.size()-1:dist=minf(dist,p.distance_to(Geometry2D.get_closest_point_to_segment(p,path[j],path[j+1])))
    var n=noise.get_noise_2d(p.x,p.y);var grain=HoldTerrainView.grain(x,y)
    if dist<48+n*11:
     var color=Color("8e7955").lerp(Color("bcaa7d"),.4+n*.25+grain*.22)
     color.a=1-smoothstep(24+n*9,48+n*11,dist);img.set_pixel(x,y,color)
  ground_cache[area]=ImageTexture.create_from_image(img)
 g.draw_texture_rect(ground_cache[area],Rect2(Vector2.ZERO,SIZE),false)
 for i in 8:scenery(Vector2(120+i*245,245+sin(i)*30),1,330)
 if area=="claim":
  var upgraded=int(g.state.surface.homes[g.state.claim_id].level)>0
  scenery(Vector2(500,470),7 if upgraded else 5,395)
  scenery(Vector2(1370,770),5,290)
  scenery(Vector2(1280,390),4,340);furniture(Vector2(740,780),"table")
  prop(Vector2(395,560),4,120);prop(Vector2(595,560),4,120)
  for i in 4:prop(Vector2(880+i*42,695),5,40)
 elif area=="trail":scenery(Vector2(220,660),3,430);scenery(Vector2(950,340),4,330)
 elif area=="pinewood":
  for i in 9:
   var p=Vector2(170+i*190,250+sin(i)*30);g.draw_texture_rect(FIR,Rect2(p-Vector2(90,210),Vector2(180,230)),false,Color("8ca291"))
  furniture(Vector2(300,790),"table")
func scenery(p:Vector2,index:int,width:float):
 var cell=Vector2(ATLAS.get_width()/4.0,ATLAS.get_height()/2.0)
 var source=Rect2(Vector2(index%4,index/4)*cell,cell)
 g.draw_texture_rect_region(ATLAS,Rect2(p-Vector2(width*.5,width*.91),Vector2(width,width)),source)
func mine_arch(p:Vector2):
 g.draw_rect(Rect2(p-Vector2(100,120),Vector2(200,125)),Color("64716d"))
 g.draw_rect(Rect2(p-Vector2(65,90),Vector2(130,90)),Color("172b31"))
 for x in [-81,81]:
  g.draw_line(p+Vector2(x,0),p+Vector2(x,-120),Color("aa986d"),16);furniture(p+Vector2(x,-8),"lamp")
 g.draw_line(p+Vector2(-95,-120),p+Vector2(95,-120),Color("ac9667"),15)
 for x in [-32,32]:g.draw_line(p+Vector2(x,10),p+Vector2(x,70),Color("829391"),3)
func draw_fir(p:Vector2,i:int):
 if g.state.road_trees[i]>0:
  var fade=.35 if g.player.y<p.y and absf(g.player.x-p.x)<80 and p.y-g.player.y<190 else 1.0
  g.draw_texture_rect(FIR,Rect2(p-Vector2(95,220),Vector2(190,235)),false,Color(1,1,1,fade))
  g.draw_line(p-Vector2(12,25),p+Vector2(12,-25),Color("e9c583"),3)
 else:
  var age=HoldForestry.fall_age(g.state,i)
  if age<HoldForestry.FALL_TIME:
   var angle=pow(clampf(age/HoldForestry.FALL_TIME,0,1),1.8)*PI*.48*HoldForestry.direction(g.state,i)
   g.draw_set_transform(p-g.camera.round(),angle)
   g.draw_texture_rect(FIR,Rect2(Vector2(-95,-220),Vector2(190,235)),false)
   g.draw_set_transform(-g.camera.round())
  g.draw_rect(Rect2(p-Vector2(18,10),Vector2(36,18)),Color("896446"))
  if HoldForestry.logs(g.state,i)>0:
   g.draw_line(p+Vector2(-45,-5),p+Vector2(40,3),Color("6d4c35"),17)
   g.draw_circle(p+Vector2(40,3),9,Color("c5a46c"));g.draw_arc(p+Vector2(40,3),5,0,TAU,12,Color("876540"),1)
func draw_room():
 g.draw_rect(Rect2(Vector2.ZERO,ROOM_SIZE),Color("142a32"))
 var index={"home":0,"tavern":1,"forge":2,"market":3,"commission":4,"research":5,"throne":5}.get(g.room_id,0)
 var cell=Vector2(INTERIORS.get_width()/3.0,INTERIORS.get_height()/2.0)
 if g.room_id=="throne":g.draw_texture_rect(ROYAL,Rect2(105,205,750,430),false)
 else:g.draw_texture_rect_region(INTERIORS,Rect2(105,205,750,430),Rect2(Vector2(index%3,index/3)*cell,cell))
 if area.begins_with("home:"):
  var upgraded=int(g.state.surface.homes[g.state.claim_id].level)>0
  if upgraded:
   for r in [18,32,48]:g.draw_circle(Vector2(640,314),r,Color(1,.55,.18,.025+.008*sin(g.clock*5)))
  else:g.draw_rect(Rect2(602,296,75,42),Color(.1,.16,.16,.55))
 # Living flames and warm lamp pools are subtle overlays, not baked animation.
 if g.room_id in ["home","tavern","forge"]:
  var fire=Vector2(630,325) if g.room_id!="forge" else Vector2(345,320)
  for r in [35,65,95]:g.draw_circle(fire,r,Color(1,.66,.26,.017+.004*sin(g.clock*4)))
