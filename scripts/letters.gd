class_name HoldLetters
extends RefCounted
# A small personal story, using the existing journal and atomic surface save.
static func sent(s)->bool:return bool(s.surface.get("facts",{}).get("letter_home",false))
static func letter(s)->String:
 var news="Ivar met me at the gate and found me a room. There is a warm hearth, a sound bed, and a chest that is mine to use. I am learning the names of the folk here."
 if s.claim_id!="":news="I have earned a mountain charter. There is ground here that I can call my own, and more work than one pair of hands could ever finish. I think you would like it."
 elif s.opening>=2:news="My first shift is paid. The stone is stubborn, the tools are sound, and I am finding my feet. Ivar has more work for me."
 return "Dear Mother and Father,\n\nI arrived safely in Keldrath. "+news+"\n\nI have been eating properly. You may tell Father that I wrote before he had to come looking for me.\n\nThere is a great deal of mountain above this little desk. For the first time, it feels like a beginning.\n\nWith love,\n"+s.appearance.first_name
static func post(g)->bool:
 if sent(g.state):return false
 var point=g.surface.nearest()
 if point.get("action","")!="letter":g.notify("Return to your writing desk to finish the letter.");return false
 var f=g.state.surface.facts
 f.letter_text=letter(g.state).replace("\\n","\n");f.letter_home=true;f.letter_posted_at=g.state.elapsed
 HoldOutpost.record(g.state,"letter_home","A first letter home, written at a desk in "+g.surface.label()+".")
 g.save_game();g.sound.effect("quest",-14);g.notify("Letter sealed for the homeward post. A promise kept.")
 g.refresh_panel();return true
static func panel(g):
 if g.surface.area=="room:home":g.small_button(g.panel_body,"Wardrobe & quarters",func():g.open_panel("home"))
 elif g.surface.area.begins_with("home:"):g.small_button(g.panel_body,"Homestead plans",func():g.open_panel("homestead"))
 g.label(g.panel_body,"A LETTER HOME",22,Color("edc98a"))
 g.label(g.panel_body,"A sheet of good paper, a steady hand, and a little news for the folk who raised you.",15)
 var text=str(g.state.surface.facts.get("letter_text",letter(g.state))).replace("\\n","\n")
 g.label(g.panel_body,text,17,Color("eee1c7"))
 if sent(g.state):g.label(g.panel_body,"Sealed for the homeward post · a copy remains in your journal.",15,Color("a7d5be"))
 else:g.button(g.panel_body,"Seal for the homeward post",func():post(g))
static func journal(g):
 if sent(g.state):
  g.label(g.panel_body,"✓ WORD HOME · Your first letter is on its way.",16,Color("a7d5be"))
  g.small_button(g.panel_body,"Read your letter",func():g.open_panel("letter"))
 else:
  g.label(g.panel_body,"WORD HOME · Write to your family when you have a quiet moment.",17,Color("edc98a"))
  g.label(g.panel_body,"Use the writing desk on the right of your starting quarters, or a desk you build at home. No supplies are required; this can wait until you are ready.",14)
