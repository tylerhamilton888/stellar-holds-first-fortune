class_name HoldDisciplines
extends RefCounted

# Stable IDs are the save contract. Definitions may grow without replacing saves.
const PATHS={
 "mining":["Mining","Read the mountain; recover its riches.","Completed rock faces","pick"],
 "smithing":["Smithing","Turn recovered metal into dependable tools.","Completed metal batches","anvil"],
 "masonry":["Masonry","Shape enduring homes from living stone.","Processed stone loads","stone"],
 "forestry":["Forestry","Fell and section timber with purpose.","Recovered timber sections","tree"],
 "woodworking":["Woodworking","Work the grain into useful materials.","Processed logs and crafted furnishings","saw"],
 "brewing":["Brewing","A well-made brew sustains the Folk.","A dedicated brewing work loop is planned","mug"],
 "farming":["Farming","Cultivate a dependable harvest.","Harvested garden beds","sprout"],
 "fishing":["Fishing","Learn the river and provide for your hold.","Successful catches","fish"],
 "gathering":["Gathering","Recognize useful gifts of the deep.","Recovered root and spring deposits","basket"],
 "runecarving":["Runecarving","Give stone and brass a lasting purpose.","Completed runic cell batches","rune"],
 "warrior":["Warrior","Keep your footing. Protect your Folk.","Defeated cavern threats; practice gives no XP","shield"],
 "overseer":["Overseer","Bring people and productive work together.","First recruitment of each crew member","banner"],
 "engineer":["Engineer","Build the machinery of a greater hold.","Completed parts and drive batches","gear"]
}
# [path, title, description, lifetime work required, prerequisite node, research]
const NODES={
 "gentle_tending":["farming","Gentle tending","Optional tending adds one crop to a harvest. No crop needs daily care.",6,"",""],
 "patient_angler":["fishing","Reading the ripples","Fish bite one second sooner along every riverbank.",6,"",""],
 "warm_table":["woodworking","A welcoming table","A furnished dining corner adds two minutes to shared-meal benefits.",6,"","hearthkeeping"],
 "ore_sorting":["mining","Selective recovery","Recover one extra unit from each ore or crystal face.",24,"","extraction"],
 "metal_batches":["smithing","Bench organization","Metal production batches finish 15% faster.",12,"","metallurgy"],
 "stone_finish":["masonry","Careful dressing","Each stonebreaker load yields one extra unit.",16,"","stoneworking"],
 "timber_selection":["forestry","Sound timber","New recovered logs contain one extra timber.",16,"",""],
 "sawyer":["woodworking","Read the grain","Each sawn log yields one extra timber.",12,"",""],
 "seed_selection":["farming","Seed selection","Each harvested bed yields one additional crop.",16,"",""],
 "river_lore":["fishing","River lore","Every third catch yields one additional fish.",12,"",""],
 "field_lore":["gathering","Field lore","Root and spring deposits yield one additional provision or water.",12,"",""],
 "rune_economy":["runecarving","Resonant inscription","Each runic cell batch produces one additional cell.",8,"","thermal"],
 "sure_footing":["warrior","Sure footing","Dodge recovery falls from 0.72 to 0.58 seconds.",6,"",""],
 "crew_planning":["overseer","Crew planning","Make room for one additional crew member at an established camp.",2,"",""],
 "load_bracing":["engineer","Load bracing","Handcarts and freight wagons carry four additional raw loads.",10,"","metallurgy"],
 "fitted_drives":["engineer","Fitted drives","Parts and drive batches finish 20% faster.",24,"load_bracing","automation"]
}
const METHODS={"mining":["extraction"],"smithing":["metallurgy"],"masonry":["stoneworking","fine_masonry"],"woodworking":["furnishings","hearthkeeping"],"runecarving":["thermal"],"engineer":["automation","voidcraft"]}
static func data(s)->Dictionary:
 if not s.hauling.has("disciplines"):
  var old=s.hauling.get("hands",{}).get("skills",{})
  var xp={"mining":int(old.get("miner",0)),"masonry":int(old.get("mason",0)),"smithing":int(old.get("smith",0)),"forestry":int(old.get("forester",0))}
  # Historical forestry combined felling and sawing: retain credit in both paths.
  xp.woodworking=xp.forestry
  var field=s.surface.get("fieldwork",{})
  xp.farming=int(field.get("harvests",0));xp.fishing=int(field.get("catches",0))
  xp.warrior=s.combat.get("cleared",{}).size();xp.overseer=s.outpost.get("crew",{}).size()
  s.hauling.disciplines={"version":1,"xp":xp,"learned":{},"events":{}}
 return s.hauling.disciplines
static func xp(s,path:String)->int:return int(data(s).xp.get(path,0))
static func award(s,path:String,amount:int=1,event:String=""):
 if not PATHS.has(path) or amount<=0:return
 var d=data(s)
 if event!="":
  if d.events.has(path+":"+event):return
  d.events[path+":"+event]=true
 d.xp[path]=xp(s,path)+amount
static func has(s,id:String)->bool:return bool(data(s).learned.get(id,false))
static func missing(s,id:String)->String:
 if not NODES.has(id):return "Unknown technique"
 var n=NODES[id];var needs:PackedStringArray=[]
 if xp(s,n[0])<n[3]:needs.append("%d more completed work" % (n[3]-xp(s,n[0])))
 if n[4]!="" and not has(s,n[4]):needs.append(NODES[n[4]][1])
 if n[5]!="" and not s.tech.has(n[5]):needs.append("Research: "+HoldData.RESEARCH[n[5]].name)
 return " · ".join(needs)
static func learn(s,id:String)->bool:
 if has(s,id) or missing(s,id)!="":return false
 data(s).learned[id]=true;return true
static func recipe_path(id:String)->String:
 if id in ["parts","assembly"]:return "engineer"
 if id=="energy_cell":return "runecarving"
 if id in ["iron","copper","iron_slag","copper_slag","scrap_iron","shell_iron","ammo"]:return "smithing"
 return ""
static func recipe_speed(s,id:String)->float:
 var path=recipe_path(id)
 return 1.2 if path=="engineer" and has(s,"fitted_drives") else 1.15 if path=="smithing" and has(s,"metal_batches") else 1.0
