class_name HoldFieldSurvey
extends RefCounted
# Samples report broad bearings from real geology, never invented deposits.
static func sample(geo:Geology,c:Vector2i,radius:int=36,remember:bool=true)->Dictionary:
 var totals={};var nearest={};var distances={}
 for y in range(maxi(1,c.y-radius),mini(Geology.H-1,c.y+radius+1)):
  for x in range(maxi(1,c.x-radius),mini(Geology.W-1,c.x+radius+1)):
   var kind=geo.at(x,y)
   if kind not in [3,4,5,6]:continue
   var distance=Vector2(x-c.x,y-c.y).length()
   if distance>radius:continue
   totals[kind]=int(totals.get(kind,0))+1
   if distance<float(distances.get(kind,INF)):distances[kind]=distance;nearest[kind]=Vector2i(x,y)
 var best=0;var score=0.0
 var wanted=int(geo.mountain.get("survey_focus",0))
 for kind in totals:
  if wanted!=0 and kind!=wanted:continue
  var value=minf(totals[kind],80)/(8+float(distances[kind]))
  if value>score:score=value;best=kind
 var record={"x":c.x,"y":c.y,"kind":best,"bearing":"","strength":"","clue":"No "+(HoldData.TILES[wanted].name.to_lower() if wanted!=0 else "mineral")+" signal within reach. Sample farther along the bank."}
 if best!=0:
  var d:Vector2i=nearest[best]-c
  var vertical="deeper" if d.y>5 else "higher" if d.y< -5 else "at roughly this level"
  var horizontal="east" if d.x>5 else "west" if d.x< -5 else "near this shaft"
  record.bearing=horizontal+", "+vertical
  record.strength="Strong" if distances[best]<12 else "Moderate" if distances[best]<24 else "Faint"
  record.clue=record.strength+" "+HoldData.TILES[best].name.to_lower()+" signature: "+record.bearing+"."
 if not remember:return record
 geo.mountain.active_reading=record.duplicate(true)
 var notes:Array=geo.mountain.get("field_notes",[])
 var replaced=false
 for i in notes.size():
  if Vector2(notes[i].x-c.x,notes[i].y-c.y).length()<12:
   notes[i]=record;replaced=true;break
 if not replaced:notes.append(record)
 if notes.size()>24:notes.pop_front()
 geo.mountain.field_notes=notes
 geo.mountain.tracked_sample={"x":c.x,"y":c.y}
 return record
static func sift(geo:Geology,c:Vector2i,grains:int)->Dictionary:
 # One scan per shovel stroke, not one scan per excavated grain.
 if grains<=0:return {}
 var result=sample(geo,c,40,false)
 if result.kind==0:
  geo.mountain.erase("sift_item");geo.mountain.active_reading=result.duplicate(true)
  return {"count":0,"clue":"Clean earth. Try closer to a mineral bearing.","item":""}
 var item=HoldData.TILES[result.kind].item
 var bank:Dictionary=geo.mountain.get("sift_bank",{})
 var total=int(bank.get(item,0))+grains
 var count=int(total/16)
 bank[item]=total%16;geo.mountain.sift_bank=bank
 geo.mountain.sift_item=item
 geo.mountain.active_reading=result.duplicate(true)
 return {"count":count,"item":item,"clue":result.clue}
static func hud(g):
 var A=HoldArt
 A.rect(g,18,146,330,99,Color(.035,.08,.12,.94))
 A.text(g,Vector2(30,166),"READ THE MOUNTAIN",14,Color("e9c586"))
 var note:Dictionary=g.geo.mountain.get("active_reading",{})
 if note.is_empty():
  A.text(g,Vector2(30,186),"Find ore before digging a blind tunnel.",13)
  A.text(g,Vector2(30,206),"Aim at nearby rock + X to read a bearing.",13)
 else:
  var title="No mineral signal. Try another outcrop."
  if int(note.kind)!=0:title=str(note.strength)+" "+HoldData.TILES[int(note.kind)].name.to_lower()+" • "+str(note.bearing)
  A.text(g,Vector2(30,186),title,12,Color("bde7da"))
  A.text(g,Vector2(30,206),"Bearing from your sample. X: check ahead.",12)
 if g.prospecting and g.tool==1:
  var item=str(g.geo.mountain.get("sift_item",""))
  var progress=int(g.geo.mountain.get("sift_bank",{}).get(item,0))
  var text="SIFT: hold LMB on dirt near a mineral seam"
  if item!="":text="SIFT: %d/16 dirt toward +1 %s" % [progress,HoldData.ITEMS[item].name]
  A.text(g,Vector2(30,225),text,12,Color("e9c586"))
  A.rect(g,30,233,304,3,Color("364b52"));A.rect(g,30,233,304.0*progress/16,3,Color("e9c586"))
 else:A.text(g,Vector2(30,228),"P: sift dirt for bonus ore    K: how it works",12,Color("abc6c0"))
static func panel(g):
 g.label(g.panel_body,"FIND A SEAM. FOLLOW IT. BRING IT HOME.",21,Color("e9c586"))
 g.label(g.panel_body,"X • READ THE ROCK",17,Color("bde7da"))
 g.label(g.panel_body,"Aim at a nearby bank + X. Follow the bearing toward ore, then sample again. Faint → Moderate → Strong means you are getting closer. Sampling is free; it does not remove ore.",16)
 g.label(g.panel_body,"P • SIFT FOR EXTRA ORE",17,Color("bde7da"))
 g.label(g.panel_body,"P equips the sifting shovel. Hold LMB on dirt near a seam: 16 dirt grains = 1 bonus ore. Progress is saved. Slower than normal digging; P again turns it off. Clean earth and stone give no bonus.",16)
 g.label(g.panel_body,"LOOK FOR",16,Color("e9c586"))
 var choices=g.row(g.panel_body)
 for kind in [0,3,4,5,6]:
  var k:int=kind
  var name="Any mineral" if k==0 else HoldData.TILES[k].name
  g.small_button(choices,("✓ " if int(g.geo.mountain.get("survey_focus",0))==k else "")+name,func():
   g.geo.mountain.survey_focus=k;g.geo.mountain.erase("active_reading");g.geo.mountain.erase("sift_item");g.open_panel("field_notes"))
 g.label(g.panel_body,"Coal helps with Ivar's first commission. This choice affects your next sample and sift. Bearings start at the sample marker, not your feet. Re-sample after digging; old notes may be out of date.",14,Color("abc6c0"))
 g.button(g.panel_body,"Back to the mine • aim at a bank and press X",func():g.close_panel())
 var notes:Array=g.geo.mountain.get("field_notes",[])
 if notes.is_empty():g.label(g.panel_body,"No samples yet. Your first bearing will appear here and beside your character's view.",16)
 for i in range(notes.size()-1,-1,-1):
  var note:Dictionary=notes[i]
  g.label(g.panel_body,"SAMPLE %02d • %s" % [i+1,note.clue],16)
  g.button(g.panel_body,"Follow this reading",func():g.geo.mountain.tracked_sample={"x":note.x,"y":note.y};g.geo.mountain.active_reading=note.duplicate(true);g.close_panel())
 if not notes.is_empty():g.button(g.panel_body,"Clear reading and marker",func():g.geo.mountain.erase("tracked_sample");g.geo.mountain.erase("active_reading");g.close_panel())
