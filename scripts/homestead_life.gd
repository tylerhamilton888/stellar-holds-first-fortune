class_name HoldHomesteadLife
extends RefCounted
# Optional field work uses the same pack, clock, save, trade and production queue.
const PROPS=preload("res://assets/animation-v51/homestead-props.png")
const TOOLS=preload("res://assets/animation-v51/field-tools.png")
const BANK=Vector2(1130,550)
const GROW_TIME=180.0
var g
var placing=false
var action=""
var elapsed=0.0
var bed_id=-1
var focus_bed=-1
var origin=Vector2.ZERO
var cast_area=""
var completed_contact=false
var moving=false
var waypoints:Array=[]
func _init(game):g=game
func data()->Dictionary:
 g.surface.ensure()
 if not g.state.surface.has("fieldwork"):g.state.surface.fieldwork={"version":1,"kit":false,"beds":[],"next":1,"facts":{},"catches":0,"harvests":0}
 var d=g.state.surface.fieldwork
 if not d.has("selected"):d.selected="turnip"
 if not d.has("locations"):d.locations={}
 return d
func local(b:Dictionary)->bool:
 if not g.surface.active():return false
 if b.get("area","")=="greenfields":return g.surface.area=="greenfields"
 return g.surface.area=="claim" and g.surface.house.level()==0 and b.claim==g.state.claim_id
func pos(b:Dictionary)->Vector2:return Vector2(b.x,b.y)
func bed()->Dictionary:
 for b in data().beds:
  if int(b.id)==bed_id and local(b):return b
 return {}
func near_bed()->Dictionary:
 var found={};var distance=80.0
 for b in data().beds:
  if int(b.id)==focus_bed and local(b) and pos(b).distance_to(g.player)<80 and g.surface.clear_interaction(g.player,pos(b)):return b
 for b in data().beds:
  if local(b) and pos(b).distance_to(g.player)<distance and g.surface.clear_interaction(g.player,pos(b)):
   distance=pos(b).distance_to(g.player);found=b
 return found
func spot()->Dictionary:
 if not g.surface.active() or g.surface.house.level()>0:return {}
 return g.hearth.fishing_spot()
func near_water()->bool:
 var place=spot()
 return not place.is_empty() and g.player.distance_to(place.bank)<38 and g.surface.walkable(place.bank) and g.surface.clear_interaction(g.player,place.bank)
func crop(b:Dictionary)->String:return str(b.get("crop","turnip"))
func grow_time(b:Dictionary)->float:return float(HoldHearth.CROPS[crop(b)].time)
func ripe(b:Dictionary)->bool:return b.get("planted",false) and bool(b.get("watered",false)) and g.state.elapsed-float(b.get("at",0))>=grow_time(b)
func bite_time()->float:return 2.8 if HoldDisciplines.has(g.state,"patient_angler") else 3.8
func craft_kit()->bool:
 if data().kit:return false
 if not g.state.pay({"wood":3,"iron":1}):g.notify("Bring 3 timber and 1 iron ingot for your field tools.");return false
 data().kit=true;data().facts.tools=true;g.state.add("turnip_seed",4);g.state.add("carrot_seed",2);g.state.add("barley_seed",2);g.state.add("hearthcap_seed",2);g.save_game();return true
func build(p:Vector2)->bool:
 if g.surface.area!="claim" or g.surface.house.level()!=0 or not data().kit:return false
 p=(p/20).round()*20
 if not g.handworks.can_place(p):g.notify("Choose clear claim ground within reach, away from paths and buildings.");return false
 for b in data().beds:
  if local(b) and pos(b).distance_to(p)<100:return false
 if not g.state.pay({"wood":3,"stone":1}):g.notify("Bring 3 timber and 1 stone for a garden bed.");return false
 data().beds.append({"id":int(data().next),"claim":g.state.claim_id,"x":p.x,"y":p.y,"planted":false,"watered":false,"at":0.0});data().next=int(data().next)+1
 data().facts.bed=true;placing=false;g.sound.effect("build");g.save_game();return true
func start(kind:String,b:Dictionary={}):
 action=kind;elapsed=0;origin=g.player;cast_area=g.surface.area;bed_id=int(b.get("id",-1));completed_contact=false
 focus_bed=bed_id
 waypoints.clear();moving=false
 if not b.is_empty():
  var side=-1 if g.player.x<=b.x else 1
  if g.player.y>b.y-5:waypoints.append(pos(b)+Vector2(side*65,40))
  waypoints.append(pos(b)+Vector2(side*65,-18))
 g.surface.direction=(spot().float-g.player).normalized() if b.is_empty() and kind=="fish" else (pos(b)-g.player).normalized() if not b.is_empty() else Vector2.RIGHT
func cancel():action="";elapsed=0;bed_id=-1;moving=false;waypoints.clear()
func input(e:InputEvent)->bool:
 if not g.playing or not g.surface.active() or g.panel_id!="":return false
 if e is InputEventMouseButton and e.pressed and placing:
  if e.button_index==MOUSE_BUTTON_RIGHT:placing=false;return true
  if e.button_index==MOUSE_BUTTON_LEFT and not g.hotbar.over():build(g.get_global_mouse_position()+g.camera);return true
 if not e is InputEventKey or not e.pressed or e.echo or e.keycode!=KEY_E or e.shift_pressed:return false
 if action!="":return true
 var b=near_bed()
 if b.is_empty() and not near_water():return false
 if not data().kit:g.open_panel("fieldwork");return true
 if g.handworks.busy_hands():g.notify("Set down your load or park the cart before field work.");return true
 if b.is_empty() and near_water():start("fish");g.sound.effect("water",-18);return true
 if ripe(b):start("harvest",b)
 elif not b.planted:
  if not b.get("prepared",false):start("hoe",b)
  elif g.state.count(HoldHearth.CROPS[data().selected].seed)<1:g.notify("No selected seed in your pack. Choose a crop on the field board; The town stores sell all seeds.")
  else:start("plant",b)
 elif not b.watered:
  if g.state.count("water")<1:g.notify("Bring one water from your pack to water this bed.")
  else:start("water",b)
 elif not b.get("tended",false):start("tend",b)
 else:g.notify("%s · %d seconds to harvest. No more tending needed; crops never wither." % [HoldHearth.CROPS[crop(b)].name,ceili(maxf(0,grow_time(b)-(g.state.elapsed-float(b.at))))])
 return true
func update(dt:float):
 data()
 if action=="":return
 if not g.surface.active() or g.surface.area!=cast_area or Input.get_vector("left","right","up","down")!=Vector2.ZERO or g.panel_id!="" or g.handworks.busy_hands():cancel();return
 moving=false
 if not waypoints.is_empty():
  var target:Vector2=waypoints[0];var next=g.player.move_toward(target,185*dt)
  if not g.surface.walkable(next):cancel();g.notify("Keep a clear working space beside your garden bed.");return
  g.surface.direction=(target-g.player).normalized();HoldDrawnLocomotion.advance(g,g.player.distance_to(next),"stone");g.player=next;g.walking_pose=true;moving=true
  if g.player.distance_to(target)<2:waypoints.pop_front()
  return
 if bed_id>=0:
  var current=bed()
  if not current.is_empty():g.surface.direction=Vector2(1 if g.player.x<current.x else -1,0)
 if action!="fish":HoldWorkEnergy.spend(g.state,dt*.025)
 elapsed+=dt if action=="fish" else dt*HoldWorkEnergy.speed(g.state)
 if action=="fish":
  var bite=bite_time()
  if elapsed<bite:return
  if not completed_contact:
   completed_contact=true;g.sound.effect("water",-15);g.notify("A bite! Hold E to reel. Take your time; the fish will wait.")
  if Input.is_action_pressed("interact"):
   if elapsed>=bite+.9:
    var count=2 if int(data().catches)%4==3 else 1
    if HoldDisciplines.has(g.state,"river_lore") and int(data().catches)%3==2:count+=1
    var place=spot();var catches=int(data().locations.get(cast_area,0));var fish=place.fish[catches%place.fish.size()]
    HoldDisciplines.award(g.state,"fishing")
    g.state.add(fish,count);data().locations[cast_area]=catches+1;data().catches=int(data().catches)+1;data().facts.fish=true
    g.sound.effect("water",-12);g.notify("%s ×%d · a good catch for the hearth or exchange." % [HoldData.ITEMS[fish].name,count]);reward();g.save_game();cancel()
  else:elapsed=bite
  return
 var b=bed()
 if b.is_empty():cancel();return
 if elapsed>=.4 and not completed_contact:
  completed_contact=true
  if action=="hoe" and not b.planted:
   b.prepared=true;g.sound.effect("wood",-18);g.notify("Soil loosened · E plants your selected seed.")
  elif action=="plant" and not b.planted and b.get("prepared",false):
   var chosen=str(data().selected)
   if g.state.pay({HoldHearth.CROPS[chosen].seed:1}):
    b.crop=chosen;b.planted=true;b.tended=false;data().facts.plant=true;g.sound.effect("wood",-20)
  elif action=="water" and b.planted and not b.watered and g.state.pay({"water":1}):b.watered=true;b.at=g.state.elapsed;data().facts.water=true;g.sound.effect("water",-17)
  elif action=="tend" and b.planted and b.watered and not b.get("tended",false):
   b.tended=true;b.at=float(b.at)-grow_time(b)*.15;g.sound.effect("wood",-20);g.notify("Roots settled · a little sooner to harvest. Tending is always optional.")
  elif action=="harvest" and ripe(b):
   var id=crop(b);var amount=(3 if int(data().harvests)>=8 else 2)+(1 if HoldDisciplines.has(g.state,"seed_selection") else 0)
   if b.get("tended",false) and HoldDisciplines.has(g.state,"gentle_tending"):amount+=1
   HoldDisciplines.award(g.state,"farming");g.state.add(id,amount);g.state.add(HoldHearth.CROPS[id].seed,1);data().harvests=int(data().harvests)+1;data().facts.harvest=true
   b.planted=false;b.watered=false;b.prepared=false;b.tended=false;g.sound.effect("build",-20);g.notify("%s ×%d · seed saved for another planting." % [HoldHearth.CROPS[id].name,amount])
  reward();g.save_game()
 if elapsed>=.8:cancel()
func reward():
 var f=data().facts
 if f.get("harvest",false) and f.get("fish",false) and not f.get("reward",false):
  f.reward=true;g.state.add("food",3);g.notify("River & Root complete · three provisions for your Folk. Your first harvest and catch will feed the hold.")
func animation_phase()->float:
 if action!="fish":return clampf(elapsed/.8,0,1)
 if elapsed<.22:return 0
 if elapsed<.5:return 1
 return 2 if elapsed<bite_time() else 3
func held_label()->String:
 if action=="":return ""
 return {"hoe":"Preparing soil · Garden hoe","plant":"Planting · "+HoldHearth.CROPS[data().selected].name,"tend":"Tending · Settling the roots","water":"Watering · Copper can","harvest":"Gathering the harvest","fish":"Fishing · Rod · "+("Hold E to reel" if elapsed>=bite_time() else "Waiting for a bite")}.get(action,"")
func objects()->Array:
 var result=[]
 for b in data().beds:
  if local(b):result.append({"kind":"garden","p":pos(b),"bed":b})
 return result
func obstacles()->Array:
 var result=[]
 for b in data().beds:
  if local(b):result.append(Rect2(pos(b)-Vector2(35,25),Vector2(70,28)))
 return result
func sprite(index:int,p:Vector2,width:float,alpha:float=1):
 var r=HoldDrawnAnimation.bounds("homestead-props",index);var h=width*r.size.y/r.size.x
 g.draw_texture_rect_region(PROPS,Rect2(p-Vector2(width/2,h),Vector2(width,h)),Rect2(r),Color(1,1,1,alpha))
func draw_bed(b:Dictionary):
 sprite(3,pos(b),86)
 var p=pos(b)
 if b.get("prepared",false):
  for i in 4:g.draw_line(p+Vector2(-27,-12-i*5),p+Vector2(25,-12-i*5),Color("473b2e"),2)
 if b.planted:
  var progress=clampf((g.state.elapsed-float(b.get("at",g.state.elapsed)))/grow_time(b),0,1) if b.watered else 0.0
  var stage=2 if ripe(b) else 1 if progress>.45 else 0
  var tex=HoldItemArt.hearth_texture(crop(b))
  for row in 2:
   for col in 3:
    var size=Vector2(20,26)*(0.48+stage*.26);var at=p+Vector2(-22+col*22,-18+row*9)
    g.draw_texture_rect(tex,Rect2(at-Vector2(size.x/2,size.y),size),false)
  if ripe(b):
   var glint=p+Vector2(30,-40);g.draw_circle(glint,2+sin(g.clock*2)*.5,Color("e6cc87"))
  elif b.watered:g.draw_arc(p+Vector2(32,-12),4,-PI/2,TAU*progress-PI/2,16,Color("8dd5c2"),2)
func draw():
 if not g.surface.active():return
 var cam=g.camera.round();g.draw_set_transform(-cam)
 if placing:sprite(3,g.get_global_mouse_position()+g.camera,86,.5)
 var place=spot()
 if not place.is_empty():
  var float_at:Vector2=place.float
  for i in 3:g.draw_arc(float_at,7+i*9+fmod(g.clock*5,9),0,TAU,24,Color(.6,.83,.83,.2-i*.04),1)
  if action=="fish":
   float_at.y+=sin(g.clock*6)*(3 if elapsed<bite_time() else 7)
   var tip=HoldWholeFrames.tool_tip(g.state.appearance,g.surface.direction,"fish",animation_phase())
   g.draw_line(origin+tip*.85,float_at,Color(.86,.87,.72,.65),.8)
   g.draw_circle(float_at,3,Color("e9dab5"));g.draw_line(float_at+Vector2(0,-4),float_at,Color("cc6852"),2)
  if near_water():g.surface.plaque(place.bank+Vector2(-38,-100),"E · "+place.name)
 var b=near_bed()
 if not b.is_empty() and action=="":
  var text="E · Harvest" if ripe(b) else "E · Prepare soil" if not b.planted and not b.get("prepared",false) else "E · Plant "+HoldHearth.CROPS[data().selected].name if not b.planted else "E · Water" if not b.watered else "E · Tend (optional)" if not b.get("tended",false) else "Growing"
  g.surface.plaque(pos(b)+Vector2(0,-62),text)
 g.draw_set_transform(Vector2.ZERO)

func panel():
 var d=data()
 g.button(g.panel_body,"Hearth, meals & comfort",func():g.open_panel("hearth"))
 g.label(g.panel_body,"A little honest work for a well-fed hold. No stamina cost, no missed-bite penalty.",16)
 if not d.kit:
  g.label(g.panel_body,"Make a rod, hoe and watering can · 3 timber + 1 iron ingot. Includes turnip, carrot, barley and hearthcap seeds.",16)
  g.button(g.panel_body,"Craft your field tools",func():craft_kit();g.open_panel("fieldwork",false))
 else:
  g.label(g.panel_body,"Field tools ready · E equips the right tool when you stand beside a garden bed or the river fishing spot.",15)
  g.button(g.panel_body,"Craft & place garden bed · 3 timber + 1 stone",func():
   if g.surface.area!="claim" or g.surface.house.level()!=0:g.notify("Build garden beds on the ground of your own claim.");return
   placing=true;g.close_panel();g.notify("Choose clear claim ground nearby. LMB places; right click cancels."))
 var tools_row=g.row(g.panel_body)
 for i in [1,2,3]:
  var icon=TextureRect.new();var tex=AtlasTexture.new();tex.atlas=TOOLS;tex.region=Rect2(HoldDrawnAnimation.bounds("field-tools",i));icon.texture=tex;icon.custom_minimum_size=Vector2(50,44);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tools_row.add_child(icon)
 g.label(g.panel_body,"Choose your next crop",20)
 for id in HoldHearth.CROPS:
  var c=HoldHearth.CROPS[id]
  var b=g.button(g.panel_body,c.name+" · "+str(g.state.count(c.seed))+" seed · "+c.use,func():d.selected=id;g.open_panel("fieldwork",false));b.toggle_mode=true;b.button_pressed=d.selected==id
 g.label(g.panel_body,"E prepares soil, then plants the selected seed, then waters once. Optional tending shortens growth by 15%. Crops take 3–4½ minutes of world time and wait forever when ripe. Harvests return seed.",14)
 g.label(g.panel_body,"Fish at Stonebridge for trout, the southern claim river for char, and Greenhearth’s eastern river for perch. E casts; hold E when the float bobs. No missed-bite penalty; walk away to cancel.",14)
 g.label(g.panel_body,"Bring your harvest to a home hearth or public kitchen. Serve meals at your own table. The town exchanges buy and sell crops, fish, seeds and meals.",14)
 var lesson=GridContainer.new();lesson.columns=2;lesson.add_theme_constant_override("h_separation",20);g.panel_body.add_child(lesson)
 for step in [["tools","Craft your field tools"],["bed","Build a garden bed at your claim"],["plant","Plant a turnip seed"],["water","Water the planted bed"],["harvest","Bring in your first harvest"],["fish","Catch a river trout"]]:g.label(lesson,("✓ " if d.facts.get(step[0],false) else "○ ")+step[1],15,Color("9bd6c0") if d.facts.get(step[0],false) else Color("d3c7ac"))
 g.label(g.panel_body,"First harvest + first catch: 3 provisions for your Folk, once.",14)
