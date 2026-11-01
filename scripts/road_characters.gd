class_name HoldRoadCharacters
extends RefCounted
# Stable road_folk IDs retain their existing names and appearances.
# Romance is authoring metadata only. No gameplay consumes it yet.
const ROMANCE_ENABLED=false
# Reviewed whole-character designs; natural pigments are applied by the existing
# shared sprite/portrait pipeline. Saved acquaintances keep their identity.
const CANDIDATE_APPEARANCES={
 "road_folk:1":{"gender":1,"sculpt":2,"hair_color":3,"cloth_color":3,"skin":1},
 "road_folk:2":{"gender":0,"sculpt":1,"hair_color":4,"cloth_color":4,"skin":1},
 "road_folk:3":{"gender":1,"sculpt":0,"hair_color":2,"cloth_color":4,"skin":2},
 "road_folk:4":{"gender":0,"sculpt":0,"hair_color":1,"cloth_color":1,"skin":0}}
static func appearance(s,id:String,fallback:Dictionary)->Dictionary:
 if s.npc_appearances.has(id):return s.npc_appearances[id].duplicate(true)
 if not CANDIDATE_APPEARANCES.has(id):return fallback
 var p=fallback.duplicate(true)
 for field in CANDIDATE_APPEARANCES[id]:p[field]=CANDIDATE_APPEARANCES[id][field]
 return HoldAppearance.normalized(p)

const FAMILIAR_WELCOMES={
 "road_folk:0":"Ah, a face I know. Come tell me something the bridge hasn't already heard.",
 "road_folk:1":"There you are. No need to find an excuse to visit; your company will do.",
 "road_folk:2":"I kept an interesting offcut to show you. It looks like nothing yet. That is the enjoyable part.",
 "road_folk:3":"Good timing. I could use a second opinion, preferably one less stubborn than mine.",
 "road_folk:4":"A friendly audience! Don't worry, I can manage a conversation without singing. Usually.",
 "road_folk:5":"Good to see you back on your own two feet. That is always my preferred arrangement."}
const CAST={
 "road_folk:0":{
  "trait":"Gruff, conscientious, secretly sentimental",
  "want":"A bridge my grandchildren can cross without knowing my name. That would be a decent life's work.",
  "worry":"The ledger calls a bridge finished when the last stone is paid for. I call it finished after the spring floods. We disagree every year.",
  "close":"My eldest sends drawings of bridges from other holds. I grumble about the fanciful arches, then keep every page flat under my best books.",
  "like":"barley_bread","dislike":"copper_slag","work":"stone","reason":"Sound stones for the bridge's worn approach",
  "topics":[["How did the Hearth get its name?","There was a brazier here before there was an inn. Dagna's mother kept it lit for the road crews. Dagna built walls around the same idea. Don't tell her I put it that nicely."],["Who keeps you company on the road?","Sten checks the mine loads; I check the bridge. Dagna checks whether either of us has eaten. My wife says she is the only sensible one of the three."]],
  "adult":true,"gender":0,"relationship":"married","romance_candidate":false},
 "road_folk:1":{
  "trait":"Warm, quick-witted, steadfastly hospitable",
  "want":"A traveler should find one place where the first question isn't what they can pay. That is what I want this hearth to be. A proper bakehouse would help it pay its own way.",
  "worry":"I am good at noticing an empty plate. Less good at admitting when I am tired. Bram has started leaving firewood without knocking, which is infuriatingly considerate.",
  "close":"I kept my mother's chipped cup. For years I served everyone else from it and drank from a tin one. Last winter I finally sat down and used it myself. A small thing, perhaps.",
  "like":"hearthcap","dislike":"iron_slag","work":"wood","reason":"Dry kindling for the Wayfarer's evening hearth",
  "topics":[["What makes this place yours?","Mother ran a roadside kettle. I added a roof that mostly behaved, then the bunk. The chipped mugs stay; the leaking roof did not. Sit as long as you need. The bunk is free."],["Do you know Hedrik at the Copper Kettle?","He sends advice folded around recipes. I send the recipes back with corrections. We have kept this very serious professional quarrel going for years. Orla finds the postage hilarious."]],
  "adult":true,"gender":1,"relationship":"single","romance_candidate":true,"future_player_gender":0},
 "road_folk:2":{
  "trait":"Reserved, patient, unexpectedly playful",
  "want":"I want to build instruments from the offcuts. A tree ought to leave a little music behind, as well as a roof.",
  "worry":"People hear 'timber worker' and expect me to hurry the saw. I have seen what a hurried cut does. I'd rather be called slow by someone with all their fingers.",
  "close":"The first little fiddle I made sounded like a kettle losing an argument. Dagna still asked for another tune. I knew what she was doing. It helped anyway.",
  "like":"iron","dislike":"coal","work":"wood","reason":"Straight offcuts for repairs to the communal tool handles",
  "topics":[["What do you do with the offcuts?","Handles first. Then pegs, wedges, and the pieces I pretend are too awkward to use. Those become fiddles. Borin spotted that last category immediately."],["Who hears you play?","Ketil sings. Very loudly. Dagna has kindly offered us the Hearth, provided we agree on the same song before starting. We are working up to that."]],
  "adult":true,"gender":0,"relationship":"single","romance_candidate":true,"future_player_gender":1},
 "road_folk:3":{
  "trait":"Forthright, inventive, quietly affectionate",
  "want":"A seed cupboard with a little of everything that will grow here. Not just the best-selling crop. A bad season has a way of teaching the value of the unfashionable ones.",
  "worry":"My family planted the same beds for generations. I keep the old methods in one notebook and my trials in another. Somehow everyone assumes one means I despise the other.",
  "close":"Grandmother's seed labels are nearly unreadable now. I copied every one, mistakes and all. When I try something new, I still catch myself turning to tell her.",
  "like":"carrot","dislike":"copper_slag","work":"wood","reason":"Dividers to keep the seed cupboard's varieties apart",
  "topics":[["Why offer beds to newcomers?","Someone once lent my grandmother a patch of soil. Our family has been eating because of it ever since. Pay for the lease once, then make your own mistakes. The beds will wait for you."],["How do you and Ketil get along?","He says I argue with the weather. I say he flirts with an audience even when the audience is a row of turnips. He works hard, though. And he notices when someone needs cheering up."]],
  "adult":true,"gender":1,"relationship":"single","romance_candidate":true,"future_player_gender":0},
 "road_folk:4":{
  "trait":"Outgoing, proud, more thoughtful than he lets on",
  "want":"To sing a harvest song people remember without forgetting who grew the supper. I can work a field and want a stage. The two needn't quarrel.",
  "worry":"It is easy to be the amusing one. If a joke goes badly, you tell another. If you say something that matters, you have to stand there and mean it.",
  "close":"I practice the quiet songs out beyond the last rows. Torvik heard once. He didn't laugh or applaud. He just asked what key it was in and brought his fiddle next time.",
  "like":"barley_bread","dislike":"iron_slag","work":"turnip","reason":"Roots for the field crew's shared supper",
  "topics":[["Do you always sing while you work?","Only when the work is dull, difficult, pleasant, or in need of improvement. Ragnhild says that covers rather a lot. She is an exacting critic."],["What brings you to the Wayfarer's Hearth?","Dagna lets us try new songs there. Bram claims he comes for the bread. He knows every chorus. One day I'll catch him admitting it."]],
  "adult":true,"gender":0,"relationship":"single","romance_candidate":true,"future_player_gender":1},
 "road_folk:5":{
  "trait":"Methodical, gentle, dryly funny",
  "want":"Everyone coming out of the mine with the same number of fingers they took in. The tally is simple. Keeping it that way takes attention.",
  "worry":"I used to measure a good shift by the weight moved. Now I check who is trying to carry too much and pretending it is nothing. I recognize the expression.",
  "close":"My daughter made me a little wooden tally stick. One notch for coming home, she said. There isn't much room left on it. I intend to make that a problem.",
  "like":"river_fish","dislike":"crystal","work":"wood","reason":"Replacement pegs for the porters' load rack",
  "topics":[["Why work at the mine entrance?","Somebody ought to remember what went in as well as what came out. Tools, lamps, people. Especially people. Ivar taught me the order of that list; I reversed it."],["Where do you go after your shift?","Home to my wife and daughter, by way of Dagna's kettle if the road crew needs a hand. Bram calls that a long way round. He takes it too."]],
  "adult":true,"gender":0,"relationship":"married","romance_candidate":false}}

static func persona(id:String)->Dictionary:
 var result={}
 if not CAST.has(id):return result
 for key in ["trait","want","worry","close","like","dislike","work","reason"]:result[key]=CAST[id][key]
 return result

static func greeting(g,id:String)->String:
 var practical:String=HoldRoads.FOLK[int(id.trim_prefix("road_folk:"))].line
 var d=HoldPeople.records(g.state).get(id,{})
 if int(d.get("bond",0))>=5:return FAMILIAR_WELCOMES.get(id,"Good to see you again.")+"\n\n"+practical
 return practical

static func whereabouts(id:String)->String:
 return {"road_folk:0":"Stonebridge road","road_folk:1":"Inside the Wayfarer's Hearth, Stonebridge","road_folk:2":"Pinewood timber yard","road_folk:3":"Greenhearth allotments","road_folk:4":"Greenhearth fields","road_folk:5":"Outside Old Workings, Stonebridge"}.get(id,"")

static func upgrade_record(id:String,d:Dictionary):
 if not CAST.has(id):return
 d.road_story_version=int(d.get("road_story_version",0))
 if d.road_story_version>=2:return
 if d.road_story_version==1:
  d.persona.trait=CAST[id].trait
  d.road_story_version=2
  return
 # A known preference, gift history or unpaid favor must not change underneath
 # an existing acquaintance. Upgrade only the formerly generic narrative.
 for key in ["trait","want","worry","close"]:d.persona[key]=CAST[id][key]
 d.road_story_version=2

static func future_candidate(id:String,player_gender:int)->bool:
 # Authoring query, deliberately NOT an unlock or a declaration of consent.
 var d=CAST.get(id,{})
 return d.get("adult",false) and d.get("relationship","")=="single" and d.get("romance_candidate",false) and int(d.get("future_player_gender",-1))==player_gender

static func panel(g,id:String):
 if not CAST.has(id):HoldConversation.return_choice(g,id);return
 HoldConversation.header(g,g.panel_body,id,g.talk_line if g.talk_line!="" else "What would you like to know?",true)
 for topic in CAST[id].topics:
  var answer:String=topic[1]
  HoldConversation.choose(g,topic[0],func():g.talk_line=answer;g.refresh_panel())
 HoldConversation.choose(g,"Back to our conversation",func():g.talk_line="";g.talk_topic="person";g.refresh_panel())
