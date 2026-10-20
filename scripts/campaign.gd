class_name HoldCampaign
extends RefCounted

const JOBS=[
 {"name":"A cold hearth", "cost":{"coal":8}, "pay":65, "story":"A fall in the lower workings cut off the furnace supply. Bring eight coal from the old gallery. Borin can relight the communal forge; you keep every other stone you uncover.", "result":"Borin rekindles the hearth. Amber light returns to the forge, and the evening shift resumes."},
 {"name":"The weight of the mountain", "cost":{"stone":16,"wood":8}, "pay":95, "story":"The lift's stone footings and timber braces need replacing. Bring sixteen stone and eight timber. Walk through the King’s Gate and follow the High Trail south to Pinewood. Press E at its trail sign, then cut marked firs with your axe [3].", "result":"New braces settle under the mountain's weight. The freight cage is moving again."},
 {"name":"Copper in the veins", "cost":{"iron":5,"copper":3}, "pay":135, "story":"Forge five iron and three copper ingots for the aether conduit housings. Two ore and one coal make an ingot. These conduits power the hold's freight machinery, not magic without a cost.", "result":"The aether conduits glow. Lord Eirik signs your reference: reliable hands, sound judgment, a charter earned."}
]
const CLAIMS=[
 {"id":"old_delving","name":"Old Delving","price":260,"seed":4511,"desc":"An abandoned iron mine beneath the northeastern ridge. A long inherited gallery and extra shallow iron; fewer rich copper seams. Existing masonry supplies your first foundation.","bonus":"Foundation already laid; broad starter gallery.","focus":3},
 {"id":"copper_ridge","name":"Copper Ridge","price":290,"seed":9527,"desc":"An untouched eastern mountain, rich in shallow copper and deeper aether. No inherited buildings: every stone of the new hold will be yours.","bonus":"Extra copper and aether; start construction from bare ground.","focus":4},
 {"id":"wayfarer","name":"Wayfarer's Rise","price":240,"seed":14213,"desc":"A modest concession above the caravan road. Less concentrated ore, but a standing supply agreement grants ten extra crowns on each completed freight contract.","bonus":"Freight contracts pay +10 crowns.","focus":5}
]
const CAMP=[
 {"name":"Lay the founding stones","cost":{"stone":24,"wood":10},"money":0},
 {"name":"Raise your workshop","cost":{"stone":18,"wood":12,"iron":5},"money":35},
 {"name":"Commission the freight beacon","cost":{"copper":4,"parts":3,"wood":6},"money":50}
]
static func claim(id:String)->Dictionary:
 for c in CLAIMS:
  if c.id==id:return c
 return {"id":"legacy","name":"Keldrath Freehold","price":0,"seed":0,"desc":"Your established claim.","bonus":"Existing operation preserved.","focus":3}
static func prepare_claim(g:Geology,c:Dictionary,world_seed:int):
 g.generate_region(world_seed,0,Vector2i(int(c.seed),0))
 if c.id=="old_delving":
  var noise=FastNoiseLite.new();noise.seed=world_seed
  HoldMountain.tunnel(g,Vector2(53,49),Vector2(135,52),7,noise)
 for x in range(80,168):
  var y=68+posmod(x,12)
  for dy in 3:
   if g.at(x,y+dy) in [2,7]:g.cells[(y+dy)*Geology.W+x]=int(c.focus)
 if c.id=="copper_ridge":
  for y in range(96,100):
   for x in range(128,160):
    if g.at(x,y) in [2,7]:g.cells[y*Geology.W+x]=6
 if c.id=="wayfarer":
  for y in range(64,Geology.H-4):
   for x in range(172,Geology.W-4):
    if g.at(x,y) in [3,4,6] and posmod(x*17+y*13,3)==0:g.cells[y*Geology.W+x]=2 if y<112 else 7
 if c.id=="old_delving":
  for y in range(72,120):
   for x in range(176,320):
    if g.at(x,y)==4 and posmod(x+y,2)==0:g.cells[y*Geology.W+x]=3
 g.redraw_all=true
