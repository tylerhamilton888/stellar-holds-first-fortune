class_name HoldThaneLines131
extends RefCounted
static func lines(g,mode:String)->Array:
 var name=g.state.appearance.first_name;var d=HoldInvasion131.data(g.state)
 var knew=HoldMountain104.data(g.state).insights.get("contacts",false) or HoldPeople.records(g.state).get("road_folk:8",{}).get("bond",0)>=5
 match mode:
  "ceremony":return [
   ["IVAR DEEPMEASURE","The three wards are ready. Your neighbors stand among the witnesses. Walk forward, "+name+". You have done the work that brought you here."],
   ["HIGH KING EIRIK","Stonebridge's claim has been tested in the mountain and before its people. Before these witnesses, I would receive your oath—"],
   ["SKARRIN","An oath? Dress an inheritance in enough fine words and you call it merit. If this claimant has earned the place, let us settle it with steel. Here. Now."],
   ["HIGH KING EIRIK","Your answer has been heard. This hall does not surrender its judgment to an angry man's challenge."],
   ["SKARRIN",("You heard me speak of other roads. You never asked where they led. " if knew else "You should have asked who knew the service tunnels. ")+"My allies have no use for your pedigrees. The counterweights are released. Your gates are open."],
   ["THE ALARM","A horn answers from King's Gate. Steel rings below. Guards move for the stairs as goblins and orcs pour through the breach."],
   ["HIGH KING EIRIK","Guards, hold the landings! Get the families under stone. You, claimant—take the Oath Court, then the refuge and forge pumps. We save our people first. The title can wait."]]
  "king":return [
   ["THE GREAT STAIRS","The giant falls hard enough to shake the landing. Beyond it, five more squeeze out of the breached passage. Their shoulders brush the arch; each fist could crush a Dwarf."],
   ["HIGH KING EIRIK","You have held long enough. Close the gate and find the man who opened it. These are mine."],
   ["THE KING'S AXE","Eirik steps into the first giant's swing. His axe answers with a blow that shakes dust from the arch. The other four hesitate."],
   ["HIGH KING EIRIK","Go! A crown is no excuse to leave the hard work to someone else. I will meet you when the gate is shut."]]
  "return":return [
   ["IVAR DEEPMEASURE","The breach is closed. The families are counted. Skarrin is under guard. But nobody has seen the King since the stairs fell quiet."],
   ["THE KING RETURNS","A scrape sounds on the stone. Eirik comes through the smoke, unbowed, dragging a gigantic troll's head. The frightened murmurs become a roar."],
   ["HIGH KING EIRIK","Five came for my crown. Four fled. This one was too slow."],
   ["HIGH KING EIRIK","See to the wounded. Write down the names of those we lost. There will be time for cheering—and then there will be judgment. Bring Skarrin to my hall."]]
  "trial":return [
   ["HIGH KING EIRIK","Skarrin, the broken counterweights, your own words, and the surviving guards bear witness. You opened Keldrath to its enemies. Claimant, you knew the man before this day. Speak."],
   ["YOUR TESTIMONY","The court waits. The betrayal is established; your words will tell your neighbors what you make of it."],
   ["HIGH KING EIRIK","I have heard you. Skarrin, your retaining walls stood. Your drains carried water. You could have built a life worthy of remembrance. Instead, you made your wounded pride a debt for other families to pay."],
   ["HIGH KING EIRIK","You were offered honorable work and refused it. You chose the breach. For treason against your own people, the sentence is death. I will carry it out."],
   ["THE OATH COURT","The King carries out the sentence. No cheer follows. The guards lower their weapons, and the hall stands silent for those who will not come home."],
   ["HIGH KING EIRIK","Let his useful works be recorded truthfully. Let his betrayal be recorded beside them. We have graves to honor and a city to mend. We will not build our future around his resentment."]]
  "investiture":return [
   ["HIGH KING EIRIK","Keldrath needs timber, iron, food, and hands that can be trusted. Your mountain has all the beginnings of a good Hold. You have shown us what you will do with them."],
   ["HIGH KING EIRIK","Your ancestral right was proved before this day. Your courage and care have answered it. Stand before your neighbors, "+name+"."],
   ["THE THANE'S OATH","You pledge to keep faith with your people, honor lawful obligations, guard the roads and hearths entrusted to you, and leave sound work for those who follow."],
   ["HIGH KING EIRIK","By the witnessed charter and the authority of this crown, I name you Thane of Stonebridge. Your first fortune is not the stone beneath it. It is the people who will build beside you."],
   ["IVAR DEEPMEASURE","Well then, Thane. Same mountain. Same neighbors. Rather more responsibility. Come home when you are ready; I believe someone has put the kettle on."]]
  "home":return [
   ["THE ROAD HOME","The old trial yard comes into view. The winch still stands where you built it. Smoke rises above familiar roofs. Nothing you made has been swept away."],
   ["IVAR DEEPMEASURE","You left as our claimant. You return as our Thane. We kept your place by the hearth."],
   ["MAREN HEARTHWELL","A title is no reason to let your supper go cold. Sit down. You can tell us the important parts between mouthfuls."],
   ["THE FIRST FORTUNE","Your first chapter is complete. The holding, workshops, discoveries and friendships you built remain yours to tend. Tomorrow, there is work to do. Tonight, you are home."]]
 return []
