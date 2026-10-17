class_name HoldState
extends RefCounted
const SAVE="user://first_fortune_v1.json"
var save_slot:int=1
var region_travel:Dictionary={}
var hold_travel:Dictionary={}
var resident_visits:Dictionary={}
var outpost:Dictionary={}
static func slot_path(slot:int)->String:
 return SAVE if slot==1 else "user://first_fortune_slot_%d.json" % clampi(slot,1,3)
static func slot_summary(slot:int)->Dictionary:
 var path=slot_path(slot)
 if not FileAccess.file_exists(path):return {"exists":false}
 var f=FileAccess.open(path,FileAccess.READ)
 if not f:return {"exists":true,"valid":false}
 var d=JSON.parse_string(f.get_as_text())
 if not d is Dictionary or d.get("version",0)!=1 or d.get("cells",[]).size() not in [Geology.W*Geology.H,96*44]:return {"exists":true,"valid":false}
 var p=HoldAppearance.normalized(d.get("appearance",{}))
 return {"exists":true,"valid":true,"name":p.name,"minutes":int(d.get("elapsed",0)/60),"zone":str(d.get("zone","hub")),"money":int(d.get("money",0))}
func save_path()->String:return slot_path(save_slot)
var ladders:Dictionary={}
var rescue_debt=0
var combat:Dictionary=HoldCombat.defaults()
var tracked_npc=""
var appearance:Dictionary=HoldAppearance.defaults()
var npc_appearances:Dictionary={}
var dynasty:Dictionary={}
var opening:int=0
var claim_id:String=""
var camp_stage:int=0
var active_site:String="hold"
var worlds:Dictionary={}
var forestry:Dictionary={}
var road_trees:Array=[8,8,8,8,8]
var inventory:Dictionary={}
var money:int=45
var tech:Dictionary={}
var queue:Array=[]
var market:Dictionary={}
var steel:bool=false
var worker:bool=false
var automaton:bool=false
var priority:String="iron_ore"
var ship_stage:int=0
var launched:bool=false
var contract:int=0
var bargain:float=0
var hospitality:float=0
var elapsed:float=0
var mined:int=0
var seed_value:int=27419
var trees:Array=[8,8,8,8,8]
var discovered:bool=false
var agents_enabled:bool=true
var market_open:bool=false
var volume:float=.6
var shake:bool=true
var music_volume:float=.65
var ambience_volume:float=.8
var effects_volume:float=.9
var footsteps_volume:float=.8
var dialogue_volume:float=1.0
const AUDIO_SETTINGS=["volume","music_volume","ambience_volume","effects_volume","footsteps_volume","dialogue_volume"]
func load_audio_settings():
 var cfg=ConfigFile.new()
 if cfg.load("user://audio_settings.cfg")!=OK:return
 for key in AUDIO_SETTINGS:set(key,clampf(float(cfg.get_value("audio",key,get(key))),0,1))
func save_audio_settings():
 var cfg=ConfigFile.new()
 for key in AUDIO_SETTINGS:cfg.set_value("audio",key,get(key))
 cfg.save("user://audio_settings.cfg")
func reset(seed_number:int):
 region_travel={};hold_travel={};resident_visits={};outpost={};forestry={}
 ladders={};rescue_debt=0
 combat=HoldCombat.defaults();tracked_npc=""
 appearance=HoldAppearance.defaults();npc_appearances={};dynasty={}
 opening=0;claim_id="";camp_stage=0;active_site="hold";worlds={};road_trees=[8,8,8,8,8]
 inventory={"wood":8,"food":6,"water":6}
 money=45
 tech={};queue=[];market={};steel=false;worker=false;automaton=false
 priority="iron_ore";ship_stage=0;launched=false;contract=0;bargain=0;hospitality=0;elapsed=0;mined=0
 seed_value=seed_number;trees=[8,8,8,8,8];discovered=false;agents_enabled=true
func count(k:String)->int:return int(inventory.get(k,0))
func add(k:String,n:int):inventory[k]=count(k)+n
func afford(cost:Dictionary, crowns:int=0)->bool:
 if money<crowns:return false
 for k in cost:
  if count(k)<cost[k]:return false
 return true
func pay(cost:Dictionary,crowns:int=0)->bool:
 if not afford(cost,crowns):return false
 for k in cost:add(k,-int(cost[k]))
 money-=crowns
 return true
func price(k:String,buy:bool)->int:
 var supply=float(market.get(k,0))
 var demand=clampf(1.0-supply*.018,.55,1.5)
 return maxi(1,int(round(HoldData.ITEMS[k].price*demand*(1.40 if buy else (.85 if bargain>0 else .72)))))
func trade(k:String,buy:bool)->bool:
 var p=price(k,buy)
 if buy:
  if money<p:return false
  money-=p;add(k,1);market[k]=float(market.get(k,0))-1
 else:
  if count(k)<1:return false
  add(k,-1);money+=p;market[k]=float(market.get(k,0))+1
 return true
func craft(id:String)->bool:
 var r=HoldData.RECIPES[id]
 if r.tech!="" and not tech.has(r.tech):return false
 if queue.size()>=12 or not pay(r.cost):return false
 queue.append({"id":id,"left":r.time})
 return true
func research(id:String)->bool:
 var r=HoldData.RESEARCH[id]
 if tech.has(id) or (r.requires!="" and not tech.has(r.requires)):return false
 if not pay(r.cost,r.money):return false
 tech[id]=true
 return true
func tick(dt:float)->String:
 if rescue_debt>0 and money>0:
  var paid=mini(money,rescue_debt);money-=paid;rescue_debt-=paid
 elapsed+=dt;bargain=maxf(0,bargain-dt);hospitality=maxf(0,hospitality-dt)
 if not market_open:
  for k in market:market[k]=move_toward(float(market[k]),0,dt*.025)
 if queue.is_empty():return ""
 queue[0].left-=dt*HoldOutpost.workshop_speed(self,dt)*HoldIndustry.production(self)
 if queue[0].left<=0:
  var id=queue[0].id
  for k in HoldData.RECIPES[id].out:add(k,HoldData.RECIPES[id].out[k])
  if id=="iron":HoldOnboarding.fact(self,"smelt")
  queue.pop_front()
  return HoldData.RECIPES[id].name+" complete"
 return ""
func ensure_dynasty():
 appearance=HoldAppearance.normalized(appearance)
 if dynasty.is_empty():
  dynasty={"id":"house_%d_%d" % [seed_value,appearance.family_name.hash()],"family_name":appearance.family_name,"founder_first_name":appearance.first_name,"founded":false}
 dynasty.family_name=HoldAppearance.clean_family(str(dynasty.family_name))
 appearance.family_name=dynasty.family_name
 appearance=HoldAppearance.normalized(appearance)
func save_world(geo:Geology,zone:String,pos:Vector2)->bool:
 ensure_dynasty()
 HoldOutpost.ensure(self)
 var data={"hold_travel":hold_travel,"outpost":outpost,"region_travel":region_travel,"mountain":geo.mountain,"structures":geo.structures,"world_address":geo.world_address,"version":1,"ladders":ladders,"rescue_debt":rescue_debt,"combat":combat,"tracked_npc":tracked_npc,"npc_population_version":2,"dynasty":dynasty,"opening":opening,"claim_id":claim_id,"camp_stage":camp_stage,"active_site":active_site,"worlds":worlds,"road_trees":road_trees,"forestry":forestry,"appearance":appearance,"npc_appearances":npc_appearances,"inventory":inventory,"money":money,"tech":tech,"queue":queue,"market":market,"steel":steel,"worker":worker,"automaton":automaton,"priority":priority,"ship_stage":ship_stage,"launched":launched,"contract":contract,"bargain":bargain,"hospitality":hospitality,"elapsed":elapsed,"mined":mined,"seed_value":seed_value,"trees":trees,"discovered":discovered,"agents_enabled":agents_enabled,"volume":volume,"music_volume":music_volume,"ambience_volume":ambience_volume,"effects_volume":effects_volume,"footsteps_volume":footsteps_volume,"dialogue_volume":dialogue_volume,"shake":shake,"geo_seed":geo.seed_value,"cells":geo.cells,"damage":geo.damage,"geo_grid":Geology.TILE,"grain_bank":geo.grain_bank,"active_grains":geo.active_grains.keys(),"zone":zone,"x":pos.x,"y":pos.y}
 var f=FileAccess.open(save_path()+".tmp",FileAccess.WRITE)
 if not f:return false
 f.store_string(JSON.stringify(data));f.close()
 # Atomic replacement: a failed write never truncates the preceding save.
 return DirAccess.rename_absolute(save_path()+".tmp",save_path())==OK
func load_world(geo:Geology)->Dictionary:
 resident_visits.clear()
 if not FileAccess.file_exists(save_path()):return {}
 var f=FileAccess.open(save_path(),FileAccess.READ)
 if not f:return {}
 var d=JSON.parse_string(f.get_as_text())
 if not d is Dictionary or d.get("version",0)!=1 or d.get("cells",[]).size() not in [Geology.W*Geology.H,96*44]:return {}
 for k in ["inventory","money","tech","queue","market","steel","worker","automaton","priority","ship_stage","launched","contract","bargain","hospitality","elapsed","mined","seed_value","trees","discovered","agents_enabled","volume","music_volume","ambience_volume","effects_volume","footsteps_volume","dialogue_volume","shake"]:
  if d.has(k):set(k,d[k])
 # Earlier saves already owned their claim; do not re-lock their progression.
 outpost=d.get("outpost",{});HoldOutpost.ensure(self)
 region_travel=d.get("region_travel",{})
 hold_travel=d.get("hold_travel",{})
 opening=int(d.get("opening",4));claim_id=str(d.get("claim_id","legacy"));camp_stage=int(d.get("camp_stage",3))
 active_site=str(d.get("active_site","claim"));worlds=d.get("worlds",{});road_trees=d.get("road_trees",[8,8,8,8,8]);forestry=d.get("forestry",{})
 ladders=d.get("ladders",{});rescue_debt=maxi(0,int(d.get("rescue_debt",0)))
 combat=HoldCombat.normalize(d.get("combat",{}));tracked_npc=str(d.get("tracked_npc",""))
 appearance=HoldAppearance.normalized(d.get("appearance",HoldAppearance.defaults()))
 dynasty=d.get("dynasty",{});ensure_dynasty()
 npc_appearances=d.get("npc_appearances",{})
 migrate_population(int(d.get("npc_population_version",1)))
 for key in npc_appearances:npc_appearances[key]=HoldAppearance.normalized(npc_appearances[key])
 HoldCulture.repair_legacy_entries(self)
 geo.restore({"mountain":d.get("mountain",{}),"structures":d.get("structures",[]),"world_address":d.get("world_address",{}),"cells":d.cells,"damage":d.get("damage",{}),"seed":int(d.get("geo_seed",seed_value)),"grain_bank":d.get("grain_bank",{}),"active_grains":d.get("active_grains",[])})
 for k in inventory:inventory[k]=int(inventory[k])
 for i in trees.size():trees[i]=int(trees[i])
 var rebuilt=int(geo.mountain.get("version",0))<2
 if rebuilt:
  geo.generate(int(d.get("geo_seed",seed_value)));ladders={}
 var loaded_zone=d.zone
 if not d.has("opening") and loaded_zone=="hub":loaded_zone="claim"
 return {"zone":loaded_zone,"pos":Vector2(150,392) if rebuilt and loaded_zone=="mine" else Vector2(d.x,d.y)}

func npc(key:String)->Dictionary:
 if HoldAppearance.CAST.has(key):
  npc_appearances[key]=HoldAppearance.npc_profile(key,seed_value)
  return npc_appearances[key]
 if not npc_appearances.has(key) or HoldOutpost.CREW.has(key):
  if HoldOutpost.has_member(self,key):
   var c=HoldOutpost.member(self,key);var p=c.profile.duplicate() if c.has("profile") else HoldAppearance.random_profile(320032+int(key.hash()),c.gender)
   p.erase("first_name");p.erase("family_name");p.name=c.name;p.sculpt=c.sculpt;p.hair_color=c.color;p.beard_color=c.color
   npc_appearances[key]=HoldAppearance.normalized(p)
  elif HoldAppearance.NPC_NAMES.has(key):npc_appearances[key]=HoldAppearance.npc_profile(key,seed_value)
  else:npc_appearances[key]=HoldAppearance.random_profile(seed_value+int(key.hash()))
 return npc_appearances[key]

func finish_commission()->bool:
 if opening<1 or opening>3 or not HoldOnboarding.commission_allowed(self):return false
 var job=HoldCampaign.JOBS[opening-1]
 if not pay(job.cost):return false
 money+=int(job.pay);opening+=1
 HoldOnboarding.after_commission(self)
 return true
func buy_charter(id:String)->bool:
 if opening<4 or claim_id!="":return false
 var found=false
 for c in HoldCampaign.CLAIMS:
  if c.id==id:found=true
 if not found:return false
 var c=HoldCampaign.claim(id)
 if not pay({},int(c.price)):return false
 claim_id=id;camp_stage=1 if id=="old_delving" else 0
 return true
func build_camp()->bool:
 if claim_id=="" or camp_stage>=3:return false
 var stage=HoldCampaign.CAMP[camp_stage]
 if not pay(stage.cost,int(stage.money)):return false
 camp_stage+=1
 if camp_stage==3:
  ensure_dynasty();dynasty.founded=true
  HoldOutpost.record(self,"founded","The freight beacon at "+HoldOutpost.title(self)+" answered Keldrath. An independent outpost entered service.")
 return true
func store_site(g:Geology):
 worlds[active_site]=g.snapshot()
func switch_site(site:String,g:Geology)->bool:
 if site not in ["hold","claim"] or (site=="claim" and claim_id==""):return false
 if active_site==site:return true
 store_site(g);active_site=site
 if worlds.has(site):
  g.restore(worlds[site])
  if int(g.mountain.get("version",0))<2:g.generate(g.seed_value)
 elif site=="hold":g.generate_region(seed_value,0,Vector2i.ZERO)
 else:HoldCampaign.prepare_claim(g,HoldCampaign.claim(claim_id),seed_value)
 return true

func migrate_population(version:int):
 # One-time cast revision. Never touches the player, dynasty or progression.
 if version>=2:return
 npc_appearances.erase("ingrid")
 npc_appearances["ivar"]=HoldAppearance.npc_profile("ivar",seed_value)
 for key in npc_appearances.keys():
  if str(key).begins_with("visitor_"):npc_appearances[key]=HoldAppearance.random_profile(seed_value+int(key.hash()))
