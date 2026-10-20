class_name HoldFrontier
extends RefCounted
# Generated people use authored voices. Identity is stored once, never rerolled on load.
const VOICES={
 "careful":{"trait":"Careful planner","lines":["I measure the way out before I measure the seam.","Show me where the spare lamps live. Then we can talk about a longer shift.","We can afford to be patient with stone. It has been patient with us.","I keep two copies of a survey. One is usually damp."]},
 "ambitious":{"trait":"Restless builder","lines":["There is room for another workshop along that ridge.","Give me a sound crew and a difficult job. I'll sleep well afterward.","I want to come back here in a hundred years and recognize something I built.","A good result deserves a celebration. A bad one deserves another drawing."]},
 "sociable":{"trait":"Keeper of the supper bench","lines":["Tell me who is on the late shift. I'll leave a portion covered.","I brought my own mug. More importantly, I brought a spare.","We should give the tunnels proper names before somebody calls all of them the old tunnel.","A quiet supper is pleasant. A silent crew makes me ask questions."]},
 "precise":{"trait":"Exacting craftsperson","lines":["That joint will hold. I checked it before I admired it.","There is a place for every tool. I'll mark the places if that helps.","I put the date on my work. I expect to be answering for it a long time.","The machine has a rhythm when it is running properly. Listen for the missing beat."]}}
static func candidates(s)->Dictionary:
 if not s.outpost.has("candidates"):
  var result={};var used={}
  for i in 4:
   var seed_number=absi(s.seed_value*97+i*7919+320032)
   var rng=RandomNumberGenerator.new();rng.seed=seed_number
   var p=HoldAppearance.random_profile(seed_number)
   var first=["Aldrik","Bjarven","Durven","Fendrik","Gormund","Harvek","Kjeldan","Ragnik","Stenvor","Ulfran"] if p.gender==0 else ["Aldra","Brenna","Dagna","Eydra","Hildra","Kelna","Ragna","Sivra"]
   p.first_name=first[rng.randi_range(0,first.size()-1)]
   if used.has(p.first_name):p.first_name=first[(first.find(p.first_name)+i+1)%first.size()]
   used[p.first_name]=true;p=HoldAppearance.normalized(p)
   var voice=VOICES.keys()[rng.randi_range(0,VOICES.size()-1)]
   var role=["miner","smith","engineer","surveyor"][i]
   var wish={"wood":4} if role=="miner" else {"copper":2} if role in ["smith","surveyor"] else {"parts":1}
   result["settler_"+str(i)]={"name":p.name,"gender":p.gender,"sculpt":p.sculpt,"color":p.hair_color,"profile":p,"trait":("Exacting craftswoman" if p.gender==1 else "Exacting craftsman") if voice=="precise" else VOICES[voice].trait,"voice":voice,"specialty":role,"fee":30+i*5,"wish":wish,"reason":"A fitted tool chest for the new quarters","lines":VOICES[voice].lines.duplicate()}
  s.outpost.candidates=result
 return s.outpost.candidates
static func is_generated(id:String)->bool:return id.begins_with("settler_")
