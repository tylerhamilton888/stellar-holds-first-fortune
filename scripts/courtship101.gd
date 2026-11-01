class_name HoldCourtship101
extends RefCounted
# Explicit player choices; save state stays separate from friendship.
const ARCS={
 "road_folk:1": {
  "title": "A place at her own table",
  "request": "Dagna wants to bake her mother's feast loaf for the road crew. Bring two hearth barley breads and three hearthcaps; she insists that this time she will sit down with everyone else.",
  "cost": {
   "barley_bread": 2,
   "hearthcap": 3
  },
  "question": "The supper is ready, but Dagna reaches for the washing bowl. 'There is always one more thing.'",
  "choices": [
   "Set a place for her beside you.",
   "Offer to share the washing after supper."
  ],
  "answers": [
   "You pull out the chair. Dagna studies you, then sits with a relieved laugh. 'You are a stubborn one. I rather like it.'",
   "'Together, then.' She puts the bowl down and brings two plates. For once, the hostess eats while her supper is hot."
  ],
  "keepsake": "Dagna's mother's feast recipe",
  "yes": "'Yes. I was beginning to wonder whether you came for the bread or for me.' Her smile softens. 'Let us make time for each other.'",
  "promise": "'A table for two, and room for whoever needs us. Yes, I will marry you.'",
  "dates": [
   [
    "The last loaf",
    "Dagna leaves the last slice between you. 'Mother always said the heel was the best bit. Convenient, when it was all she kept.'",
    [
     "Split it with her.",
     "Ask her for another story about her mother."
    ],
    [
     "She breaks it in two and gives you the larger half. You trade halves until you are both laughing.",
     "She tells you about a snowy night when the roadside kettle fed three stranded families. Her hand settles over yours."
    ]
   ],
   [
    "A quiet hearth",
    "For once nobody calls for another plate. Dagna leans beside the hearth. 'What would your own home feel like?'",
    [
     "Warm enough that nobody hurries away.",
     "Quiet enough that you can rest there."
    ],
    [
     "'Then save me a chair.' She says it lightly, but does not look away.",
     "'That sounds lovely.' Her shoulder rests against yours while the fire settles."
    ]
   ],
   [
    "The good cups",
    "Dagna brings out two unchipped cups. 'I thought we might use the good ones for no particular occasion.'",
    [
     "Raise a toast to the two of you.",
     "Tell her she makes an ordinary day worth celebrating."
    ],
    [
     "She answers the toast, eyes bright. The empty cups remain on the table long after the conversation ends.",
     "Her practiced reply deserts her. At last she squeezes your hand. 'You may have to say that again.'"
    ]
   ]
  ]
 },
 "road_folk:2": {
  "title": "Music in the offcuts",
  "request": "Torvik has saved wood for a fiddle but needs three finished timber and one iron ingot for its fittings and small tools. Bring them to the Pinewood yard.",
  "cost": {
   "wood": 3,
   "iron": 1
  },
  "question": "Torvik tests the new fiddle. The first note wavers. 'A roof never minds when people listen to it.'",
  "choices": [
   "Ask him to play the tune he likes best.",
   "Offer to keep the first performance between friends."
  ],
  "answers": [
   "He plays a slow road song. By its final phrase he has forgotten to look nervous. 'I hoped you would like that one.'",
   "He sits beside you and begins again, quietly. By the end neither of you is watching the busy yard."
  ],
  "keepsake": "Torvik's first road-song notation",
  "yes": "'I would like that. Very much.' Torvik smiles without hiding it. 'I am better at making things than speeches, but you will never have to guess whether I mean them.'",
  "promise": "'Yes. A home built by both of us, and music in it. That is a promise I can make with my whole heart.'",
  "dates": [
   [
    "A tune for two",
    "Torvik picks out a melody on a work break. 'Quick dance, or slow song?'",
    [
     "Ask for the slow song.",
     "Try a few steps to the dance."
    ],
    [
     "The tune fills a comfortable silence. He meets your eyes at the last note.",
     "He taps the beat on the timber stack, smiling when you turn back toward him."
    ]
   ],
   [
    "A maker's hands",
    "Torvik shows you a tiny carved bird. 'Offcut. Too small for anything useful, they said.'",
    [
     "Admire the care in its wings.",
     "Ask him to show you how he carved it."
    ],
    [
     "He places it in your palm. 'Then it has found somewhere useful to be.'",
     "His hand steadies yours around the blunt practice tool. The lesson takes rather longer than either expected."
    ]
   ],
   [
    "Coming home",
    "The yard is quiet. Torvik asks what you hope to build when your fortune is your own.",
    [
     "A home with room for his music.",
     "A workshop where you can both be proud of your work."
    ],
    [
     "He looks down, then back at you. 'I had been hoping you might say that.'",
     "'Beside each other, then.' He takes your hand, and lets the silence do the rest."
    ]
   ]
  ]
 },
 "road_folk:3": {
  "title": "The names in the seed cupboard",
  "request": "Ragnhild is preserving her grandmother's seed labels. Bring two timber for dry dividers and three carrots from your pack to help prepare the next planting.",
  "cost": {
   "wood": 2,
   "carrot": 3
  },
  "question": "One label has a spelling mistake in her grandmother's hand. Ragnhild holds the fresh copy beside it. 'I know what it ought to say.'",
  "choices": [
   "Keep the original beside the new label.",
   "Copy the old spelling and add a clear note."
  ],
  "answers": [
   "'Both have earned their place.' She fixes them side by side and leaves your initials on the divider.",
   "She smiles at the familiar crooked word. 'Grandmother would have said the carrots never complained.'"
  ],
  "keepsake": "A seed-label sketch in Ragnhild's hand",
  "yes": "'Yes. I like the person you are when nobody is keeping score.' She brushes the soil from her hands before taking yours.",
  "promise": "'Yes. Roots, a roof, and something growing for the years after us. I want to build that with you.'",
  "dates": [
   [
    "The first green shoots",
    "Ragnhild kneels beside a healthy seedling. 'Grandmother would have pretended not to be pleased.'",
    [
     "Ask which crop her grandmother loved best.",
     "Tell her she has carried the work forward well."
    ],
    [
     "She tells you about barley taller than a little girl's head, and the great boots she followed between the rows.",
     "For a moment she says nothing. Then: 'That means a great deal, coming from you.'"
    ]
   ],
   [
    "Stubborn weather",
    "A passing cloud makes Ragnhild narrow her eyes. 'Don't say it. Ketil has enough jokes about me arguing with the sky.'",
    [
     "Offer to take her side against the cloud.",
     "Ask her to take a break with you."
    ],
    [
     "She laughs and slips her arm through yours. 'At last, a useful ally.'",
     "She sets her tools aside. 'For you, I can leave the weather unattended a little while.'"
    ]
   ],
   [
    "Next spring",
    "Ragnhild sketches next year's beds. There is an empty space beside the little house in the margin.",
    [
     "Ask about a shared garden.",
     "Suggest a bench where you can sit together."
    ],
    [
     "She draws a second set of tools. 'We would have to agree about the rows.' Her smile promises an enjoyable argument.",
     "She draws it carefully, wide enough for two. 'There. Now I have another reason to finish.'"
    ]
   ]
  ]
 },
 "road_folk:4": {
  "title": "The verse he never sings",
  "request": "Ketil wants the late field crew to hear his new harvest song. Bring two barley breads and two provisions so the audience can finish work and eat together.",
  "cost": {
   "barley_bread": 2,
   "food": 2
  },
  "question": "Ketil reaches the last verse and stops. It is about his family, and for once he has no joke ready.",
  "choices": [
   "Listen without filling the silence.",
   "Tell him he can sing it quietly, just for his friends."
  ],
  "answers": [
   "He finds the first note again. When the song ends, his thanks are plain and unpracticed.",
   "He finishes the verse with his eyes on the table. Then he looks up at you. 'That was the difficult bit. Thank you.'"
  ],
  "keepsake": "Ketil's handwritten harvest verse",
  "yes": "'Yes. And before I spoil it with a clever line: I mean yes.' He offers his hand with an unexpectedly shy smile.",
  "promise": "'Yes. I can promise you songs, honest work, and a man who comes home. The grand speech can wait until I stop grinning.'",
  "dates": [
   [
    "A willing audience",
    "Ketil bows extravagantly. 'One song. You choose.'",
    [
     "Ask for something cheerful.",
     "Ask for the quiet family verse."
    ],
    [
     "He sings a lively chorus and invites you to join. The missed notes become the best part.",
     "He sets the performance aside and sings as though only you can hear him."
    ]
   ],
   [
    "Two left boots",
    "Ketil offers a simple harvest dance between breaks. 'I make no guarantees for my dignity.'",
    [
     "Take his hand.",
     "Ask him to teach the steps slowly."
    ],
    [
     "He gets the second turn wrong and laughs at himself before drawing you gently back into time.",
     "He counts softly, hand warm around yours. For once he is in no hurry to finish a performance."
    ]
   ],
   [
    "Without the audience",
    "There is nobody nearby to impress. Ketil asks, quietly, 'Do you ever wish I would stop talking?'",
    [
     "Tell him you like the quiet moments with him too.",
     "Tell him he needn't earn your company with a performance."
    ],
    [
     "He smiles and stays beside you. The silence proves easier than he expected.",
     "'Then I shall try being simply glad you are here.' For a while, he manages it beautifully."
    ]
   ]
  ]
 },
 "road_folk:6": {
  "title": "The maker's mark",
  "request": "Brynja is making a workshop sign with her own family's mark. Bring two copper ingots and two finished timber for its fittings and backing.",
  "cost": {
   "copper": 2,
   "wood": 2
  },
  "question": "Brynja turns the finished sign toward the light. 'Father's mark beside mine, or mine alone? I have thought about it for weeks.'",
  "choices": [
   "Suggest keeping both generations on the sign.",
   "Tell her a new branch can still honor its roots."
  ],
  "answers": [
   "She sets the old mark beside the new. 'A beginning with something behind it.' She asks you to hold it while she fixes the last pin.",
   "She engraves her own mark, then her father's teaching on the back. 'There. He will know where to look.'"
  ],
  "keepsake": "A rubbing of Brynja's maker's mark",
  "yes": "'Yes. I have been finding reasons to keep you at the bench after the work was done.' Her cheeks warm. 'I suppose I can stop inventing them now.'",
  "promise": "'Yes. Let us build a home worth handing down. I will make the hinges; you may remind me when it is time to put the tools away.'",
  "dates": [
   [
    "The stubborn hinge",
    "Brynja shows you an elegant hinge that works perfectly. She is still holding the file.",
    [
     "Gently ask her to put the file down.",
     "Invite her to admire what she has finished."
    ],
    [
     "She sets it aside and gives you her full attention. 'You have caught me at it again.'",
     "She works the hinge once, then smiles. 'It is good, isn't it?' She sounds pleasantly surprised."
    ]
   ],
   [
    "The good sleeves",
    "Brynja has repaired the embroidery on her cuffs. 'Not everything I make has to survive a hammer.'",
    [
     "Compliment the careful stitching.",
     "Ask about the family pattern."
    ],
    [
     "She turns her wrist so you can see the tiny leaves. 'I hoped you would notice.'",
     "She tells you who taught each part of the pattern. Your hands remain close long after the explanation."
    ]
   ],
   [
    "Above the door",
    "Brynja sketches a future workshop. A little house is tucked beside it.",
    [
     "Ask which window catches the evening light.",
     "Offer to help build it when the time comes."
    ],
    [
     "She draws you into the plan without quite saying so: two chairs beneath the western window.",
     "She sets the pencil down. 'I would like that to mean more than carrying timber.' You tell her it does."
    ]
   ]
  ]
 },
 "road_folk:7": {
  "title": "A shelter for the watch",
  "request": "Hakon wants the road watch to have a dry place for spare provisions. Bring four dressed stones and two provisions for the shelter repairs and its first store.",
  "cost": {
   "dressed_stone": 4,
   "food": 2
  },
  "question": "The work is finished. Hakon rubs his father's old watch clasp. 'He made this job look easier than it is.'",
  "choices": [
   "Tell him keeping the oath is what matters.",
   "Ask what his father said after that first patrol."
  ],
  "answers": [
   "'Then I shall keep at it.' He straightens, and his thanks are warmer than the formal words.",
   "'Being frightened is no disgrace. Leaving your people is.' He smiles at the memory. 'I think he would have liked you.'"
  ],
  "keepsake": "Hakon's sketch of the old watch clasp",
  "yes": "'Yes. Gladly.' Hakon's steady voice turns soft. 'I would like you to know the man who comes off watch, too.'",
  "promise": "'Yes. By hearth and kin, I mean it. Whatever titles we gain, I want us to be able to trust the person beside us.'",
  "dates": [
   [
    "Between patrols",
    "Hakon shares a quiet break where the road bends. 'For once, nobody needs rescuing.'",
    [
     "Enjoy the quiet beside him.",
     "Ask what he does with a free evening."
    ],
    [
     "He relaxes enough to lean toward you. For a little while the road can look after itself.",
     "'Walk, eat well, try not to tread on anyone at a dance. I would like to do those things with you.'"
    ]
   ],
   [
    "The second turn",
    "Hakon admits he has practiced the dance Torvik taught him. 'I may still need a patient partner.'",
    [
     "Offer your hand.",
     "Promise to laugh with him if it goes wrong."
    ],
    [
     "He takes your hand with surprising gentleness. This time, the second turn goes right.",
     "'That is all I ask.' One clumsy step later, you are both keeping the promise."
    ]
   ],
   [
    "A hearth after watch",
    "Hakon asks what you would want waiting at the end of a hard day.",
    [
     "Someone who is glad you came home.",
     "A warm supper and honest conversation."
    ],
    [
     "'Then we want much the same thing.' His hand closes warmly around yours.",
     "He nods. 'No grand speeches required. I believe I could be good at that.'"
    ]
   ]
  ]
 }
}

static func all(s)->Dictionary:
 if not s.surface.has("courtship101"):s.surface.courtship101={}
 return s.surface.courtship101
static func record(s,id:String)->Dictionary:
 if not ARCS.has(id):return {}
 var records=all(s)
 if not records.has(id):records[id]={"quest":0,"approach":-1,"stage":0,"began":-1,"last_date":-1,"ended":-1,"dates":[],"keepsake":""}
 var d=records[id]
 for key in ["quest","approach","stage","began","last_date","ended"]:d[key]=int(d[key])
 for event in d.dates:
  for key in ["event","choice","day"]:event[key]=int(event[key])
 return d
static func day(s)->int:return int(HoldCalendar.data(s).day)
static func partner(s)->String:
 for id in all(s):
  if ARCS.has(id) and int(all(s)[id].get("stage",0))>0:return id
 return ""
static func local(g,id:String)->bool:return ARCS.has(id) and HoldConversation.local(g,id) and HoldPeople.records(g.state).has(id)
static func eligible(s,id:String)->bool:return HoldRoadCharacters.future_candidate(id,int(s.appearance.gender))
static func bond(s,id:String)->int:return int(HoldPeople.records(s).get(id,{}).get("bond",0))
static func accept(g,id:String)->bool:
 if not local(g,id):return false
 var d=record(g.state,id)
 if d.quest!=0:return false
 d.quest=1;g.save_game();return true
static func deliver(g,id:String)->bool:
 if not local(g,id):return false
 var d=record(g.state,id)
 if d.quest!=1 or not g.state.pay(ARCS[id].cost):return false
 d.quest=2;g.save_game();return true
static func resolve(g,id:String,choice:int)->bool:
 if not local(g,id) or choice not in [0,1]:return false
 var d=record(g.state,id)
 if d.quest!=2:return false
 d.quest=3;d.approach=choice;d.keepsake=ARCS[id].keepsake
 var p=HoldPeople.records(g.state)[id];p.bond=mini(20,int(p.bond)+3);p.last="We completed "+ARCS[id].title.to_lower()+" together."
 g.save_game();return true
static func begin(g,id:String)->bool:
 if not local(g,id) or not eligible(g.state,id) or partner(g.state)!="":return false
 var d=record(g.state,id)
 if d.quest!=3 or d.stage!=0 or bond(g.state,id)<5 or d.ended==day(g.state):return false
 d.stage=1;d.began=day(g.state);d.dates=[];d.last_date=day(g.state)
 g.save_game();return true
static func date_ready(s,id:String)->bool:
 var d=record(s,id)
 return not d.is_empty() and d.stage==1 and partner(s)==id and d.dates.size()<ARCS[id].dates.size() and day(s)>d.last_date
static func share_date(g,id:String,index:int,choice:int)->bool:
 if not local(g,id) or choice not in [0,1] or not date_ready(g.state,id):return false
 var d=record(g.state,id)
 if index!=d.dates.size():return false
 d.dates.append({"event":index,"choice":choice,"day":day(g.state)})
 d.last_date=day(g.state)
 var p=HoldPeople.records(g.state)[id];p.bond=mini(20,int(p.bond)+2);p.last="We shared "+str(ARCS[id].dates[index][0]).to_lower()+"."
 g.save_game();return true
static func can_promise(s,id:String)->bool:
 var d=record(s,id)
 return not d.is_empty() and d.stage==1 and partner(s)==id and d.dates.size()==3 and day(s)>d.last_date and bond(s,id)>=12
static func promise(g,id:String)->bool:
 if not local(g,id) or not can_promise(g.state,id):return false
 record(g.state,id).stage=2;g.save_game();return true
static func end(g,id:String)->bool:
 if not local(g,id):return false
 var d=record(g.state,id)
 if d.stage not in [1,2]:return false
 d.stage=0;d.ended=day(g.state);d.dates=[];d.last_date=-1
 g.save_game();return true
static func status(s,id:String)->String:
 if not ARCS.has(id):return ""
 var d=s.surface.get("courtship101",{}).get(id,{})
 var stage=int(d.get("stage",0))
 if stage==2:return "Betrothed · "+str(ARCS[id].title)
 if stage==1:return "Courting · %d of 3 shared moments" % d.get("dates",[]).size()
 return "Personal story complete" if int(d.get("quest",0))==3 else "Personal story: "+ARCS[id].title
static func open(g):g.talk_topic="courtship101";g.talk_line="";g.refresh_panel()
static func option(g,id:String):
 if ARCS.has(id):HoldConversation.choose(g,"A personal word · "+ARCS[id].title,func():open(g),true)
static func panel(g,id:String):
 if not local(g,id):return
 var d=record(g.state,id);var arc=ARCS[id]
 var text=arc.request
 if d.quest==2:text=arc.question
 elif d.stage==2:text=arc.promise
 elif d.quest==3:text=HoldRoadCharacters.CAST[id].close
 if date_ready(g.state,id):text=arc.dates[d.dates.size()][1]
 HoldConversation.header(g,g.panel_body,id,g.talk_line if g.talk_line!="" else text,true)
 g.label(g.panel_body,status(g.state,id),17)
 if d.quest==0:
  HoldConversation.choose(g,"Offer to help",func():
   if accept(g,id):g.talk_line="Thank you. There is no deadline; come back when you have what we need."
   g.refresh_panel())
 elif d.quest==1:
  g.label(g.panel_body,"Bring from your pack: "+HoldData.cost_text(arc.cost)+". Stored supplies stay where they are.",15)
  var b=HoldConversation.choose(g,"Deliver the materials",func():
   if deliver(g,id):g.talk_line=arc.question
   g.refresh_panel())
  b.disabled=not g.state.afford(arc.cost)
 elif d.quest==2:
  for i in 2:
   var choice=i
   HoldConversation.choose(g,arc.choices[i],func():
    if resolve(g,id,choice):g.talk_line=arc.answers[choice]
    g.refresh_panel())
 else:
  g.label(g.panel_body,"Keepsake: "+d.keepsake,14)
  if d.stage==0:
   if eligible(g.state,id):
    if partner(g.state)!="":g.label(g.panel_body,"You have made a commitment to someone else. This friendship can still grow.",15)
    elif bond(g.state,id)<5:g.label(g.panel_body,"Spend a little more time getting to know each other. Friendship can stay friendship.",15)
    elif d.ended==day(g.state):g.label(g.panel_body,"Give each other a little time before beginning again.",15)
    else:HoldConversation.choose(g,"Ask whether we might court each other",func():
     if begin(g,id):g.talk_line=arc.yes
     g.refresh_panel())
   else:g.label(g.panel_body,"A valued friendship. Their personal story remains yours to share.",15)
  elif d.stage==1:
   if date_ready(g.state,id):
    var index=d.dates.size();var scene=arc.dates[index]
    g.label(g.panel_body,scene[0],17)
    for i in 2:
     var choice=i
     HoldConversation.choose(g,scene[2][i],func():
      if share_date(g,id,index,choice):g.talk_line=scene[3][choice]
      g.refresh_panel())
   elif d.dates.size()<3:g.label(g.panel_body,"Come back another day for time together. There is no missed-visit penalty.",15)
   if can_promise(g.state,id):HoldConversation.choose(g,"Ask to become betrothed",func():
    if promise(g,id):g.talk_line=arc.promise
    g.refresh_panel())
   elif d.dates.size()==3:g.label(g.panel_body,"Let these memories settle. Return another day as trusted friends to discuss a shared future.",15)
  if d.stage in [1,2]:HoldConversation.choose(g,"Discuss ending our courtship",func():g.talk_topic="courtship_end101";g.refresh_panel())
 HoldConversation.return_choice(g,id)
static func end_panel(g,id:String):
 if not local(g,id):return
 HoldConversation.header(g,g.panel_body,id,"Are you sure you want to end this commitment? Your friendship and shared personal history will remain.",true)
 HoldConversation.choose(g,"Yes · end the commitment kindly",func():
  if end(g,id):g.talk_line="It is better to speak honestly. We can still treat each other with kindness."
  g.talk_topic="courtship101";g.refresh_panel())
 HoldConversation.choose(g,"No · stay together",func():open(g))
