class_name HoldAppearance
extends RefCounted

const HAIR_COLORS=["e2c491","bd8a4c","a65134","754532","432e2c","282936","a5a9ac","ece0cd"]
const HAIR_NAMES=["Flaxen","Honey","Copper","Chestnut","Oak","Raven","Iron grey","Snow"]
const CLOTH_COLORS=["407e83","506a9d","925c91","a84e47","538064","b28a48","6b7887","574b6c"]
const CLOTH_NAMES=["Fjord teal","Woad blue","Heather","Rowan red","Pine green","Ochre","Slate","Night violet"]
const SKIN_COLORS=["f3d6bc","eed0b7","e6c1ad","f4dcd0"]
const SKIN_NAMES=["Ivory","Warm fair","Rose fair","Porcelain"]
const SCULPTS=["Short square beard","Twin oath braids","Mountain greatbeard","Topknot & braids","Banded forkbeard","Grand moustache","Bare crown & beard"]
const FEMALE_SCULPTS=["Crown braid","Practical bun","Loose waves","Side braid","Layered bob","Twin braids","High ponytail"]
const MALE_HAIR=["Swept crest","Braided sides","Wild mane","High knot","Cropped","Bare crown"]
const FEMALE_HAIR=["Twin braids","Crown braid","Wave & braid","High knot","Side braid","Loose waves"]
const BEARDS=["Greatbeard","Twin braids","Forked beard","Rounded beard","Braided goatee","Clean shaven","Oath braid","Long twin braids","King’s mantle","Royal triple plait"]
const OUTFITS=["Prospector","Hearthkeeper","Runesmith"]
const TATTOOS=["None","Oath rune","Woad band","Knotwork"]
const JEWELRY=["Bronze clasp","Silver clasp","Amber pendant","Plain"]
const NPC_NAMES={"hedrik":"Hedrik Copperkettle","orla":"Orla Brassbraid","borin":"Borin Cinderthumb","eldric":"Eldric Farspan","brann":"Brann Rivethand","eirik":"Lord Eirik Granitecrown","ivar":"Ivar Deepmeasure"}
const NPC_ROLES={"hedrik":"Keeper of the hearth","orla":"Merchant & freight broker","borin":"Master of the forge","eldric":"Surveyor of impossible things","brann":"Cable-certified miner","eirik":"Lord of Keldrath","ivar":"Foreman of the lower works"}
static func clean_family(value:String)->String:
 # Retire recognizable borrowed generated surnames, including legacy saves.
 return {"oakenshield":"Fellcopper","farsight":"Farspan"}.get(value.to_lower(),value)
static func defaults()->Dictionary:
 return {"first_name":"Haldor","family_name":"Stonehand","title":"","name":"Haldor Stonehand","gender":0,"sculpt":0,"skin":0,"hair_style":0,"hair_color":1,"beard_style":0,"beard_color":1,"cloth_color":0,"outfit":0,"tattoo":0,"jewelry":0}
static func normalized(raw:Dictionary)->Dictionary:
 var p=defaults()
 var limits={"gender":2,"skin":4,"hair_style":6,"hair_color":8,"beard_style":BEARDS.size(),"beard_color":8,"cloth_color":8,"outfit":3,"tattoo":4,"jewelry":4}
 for k in limits:p[k]=clampi(int(raw.get(k,p[k])),0,limits[k]-1)
 # Complete sprite designs own their hair/beard geometry. Old saves map to
 # the closest design, preserving names, palettes, equipment and world state.
 p.sculpt=clampi(int(raw.get("sculpt",1 if int(raw.get("beard_style",0)) in [1,6,7,8,9] else 0)),0,6)
 if p.gender==1:p.hair_style=[1,3,5,4,2,0,3][p.sculpt];p.beard_style=5
 else:p.hair_style=[0,1,2,3,1,0,5][p.sculpt];p.beard_style=[0,7,8,2,9,5,3][p.sculpt]
 # Canonical fields win; full name is derived for display.
 var legacy=str(raw.get("name","Haldor Stonehand")).strip_edges()
 var honorific=str(raw.get("title","")).strip_edges().left(16)
 if legacy.begins_with("Lord "):
  honorific="Lord";legacy=legacy.trim_prefix("Lord ")
 var split=legacy.find(" ")
 var first=legacy if split<0 else legacy.left(split)
 var family="Stonehand" if split<0 else legacy.substr(split+1)
 p.first_name=str(raw.get("first_name",first)).strip_edges().left(20)
 p.family_name=clean_family(str(raw.get("family_name",family)).strip_edges().left(24))
 if p.first_name=="":p.first_name="Unnamed"
 if p.family_name=="":p.family_name="Stonehand"
 p.title=honorific
 p.name=(honorific+" " if honorific!="" else "")+p.first_name+" "+p.family_name
 if p.gender==1:
  p.beard_style=5
 if raw.has("cast_id"):p.cast_id=raw.cast_id
 p.beard_color=p.hair_color # One pigment for hair, brows, mustache and beard, including old saves.
 return p
static func random_profile(seed_number:int,gender:int=-1)->Dictionary:
 var rng=RandomNumberGenerator.new();rng.seed=seed_number
 var p=defaults()
 p.gender=gender if gender>=0 else (1 if rng.randi_range(0,19)<3 else 0)
 for k in ["hair_color","cloth_color"]:p[k]=rng.randi_range(0,7)
 p.beard_color=p.hair_color
 p.sculpt=rng.randi_range(0,6)
 p.skin=rng.randi_range(0,3);p.hair_style=rng.randi_range(0,5)
 p.beard_style=[0,1,2,3,4,6,7,8,9][rng.randi_range(0,8)] if p.gender==0 else 5
 p.outfit=0;p.tattoo=rng.randi_range(0,3);p.jewelry=rng.randi_range(0,3)
 var first=["Haldor","Torsten","Brynjar","Eirik","Duncan","Rurik"] if p.gender==0 else ["Astrid","Eira","Runa","Moira","Freya","Sigrid"]
 var last=["Stonehand","Copperbraid","Ashforge","Ironroot","Fellcopper","Emberhall","Slateweld","Coilwarden","Mossrivet","Flintgauge","Cairnweft","Brasshaven"]
 p.first_name=first[rng.randi_range(0,first.size()-1)];p.family_name=last[rng.randi_range(0,last.size()-1)]
 return normalized(p)
# Authored cast has one silhouette and palette across every fortune.
const CAST={
 "hedrik":{"gender":0,"sculpt":3,"hair_color":3,"beard_color":3,"cloth_color":3,"outfit":1,"skin":1,"tattoo":0,"jewelry":0},
 "orla":{"gender":1,"sculpt":0,"hair_color":2,"cloth_color":1,"outfit":1,"skin":2,"tattoo":0,"jewelry":0},
 "ivar":{"gender":0,"sculpt":0,"hair_color":6,"beard_color":6,"cloth_color":5,"outfit":0,"skin":0,"tattoo":1,"jewelry":0},
 "borin":{"gender":0,"sculpt":2,"hair_color":4,"beard_color":4,"cloth_color":6,"outfit":2,"skin":1,"tattoo":0,"jewelry":0},
 "eldric":{"gender":0,"sculpt":1,"hair_color":6,"beard_color":6,"cloth_color":1,"outfit":2,"skin":3,"tattoo":1,"jewelry":1},
 "brann":{"gender":0,"sculpt":0,"hair_color":3,"beard_color":3,"cloth_color":4,"outfit":0,"skin":0,"tattoo":0,"jewelry":0},
 "eirik":{"gender":0,"sculpt":4,"hair_color":7,"beard_color":7,"cloth_color":1,"outfit":2,"skin":0,"tattoo":0,"jewelry":0}}
static func npc_profile(key:String,world_seed:int)->Dictionary:
 if CAST.has(key):
  var p=CAST[key].duplicate();p.name=NPC_NAMES[key]
  var profile=normalized(p);profile.cast_id=key;return profile
 return random_profile(world_seed+int(key.hash()))
static func hair_name(p:Dictionary)->String:
 return (FEMALE_HAIR if p.gender else MALE_HAIR)[p.hair_style]
static func hair(p:Dictionary)->Color:return Color("c7622e") if p.get("cast_id","")=="orla" else Color(HAIR_COLORS[p.hair_color])
static func beard(p:Dictionary)->Color:return hair(p)
static func cloth(p:Dictionary)->Color:return Color(CLOTH_COLORS[p.cloth_color])
static func skin(p:Dictionary)->Color:return Color(SKIN_COLORS[p.skin])
static func metal(p:Dictionary)->Color:return Color("becdd3") if p.jewelry==1 else Color("d9ad61")
