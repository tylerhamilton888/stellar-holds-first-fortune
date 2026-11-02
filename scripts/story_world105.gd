class_name HoldStoryWorld105
extends RefCounted
# Activate only complete, reviewed bundles. Portrait coverage is independent.
const CAST=["dagna","ragnhild","brynja","edda","rurik","torvik","ketil","hakon","bram","sten","orla","sigrid","yrsa","skarrin","ivar","hedrik","borin","eldric","brann","dagr","odrin","osvik","tovan","kelvar"]
# All twenty-four named bundles have reviewed four-view locomotion and resting stances.
# Approved social and working keys cover the activities listed below.
# Future studies remain gated; technical tests never grant approval.
const APPROVED:Array[String]=["dagna","ragnhild","brynja","edda","rurik","torvik","ketil","hakon","bram","sten","orla","sigrid","yrsa","skarrin","ivar","hedrik","borin","eldric","brann","dagr","odrin","osvik","tovan","kelvar"]
const HEIGHTS={"brynja":58.0,"ragnhild":64.0,"edda":63.0,"yrsa":58.0,"sigrid":64.0}
const PREFIX="res://assets/story105/world/"
const ACTIVITIES={"dagna":{"drink":[20,21,22,23]},"orla":{"drink":[20,21,22,23]},"sigrid":{"drink":[20,21,22,23]},"yrsa":{"drink":[20,21,22,23]},"hedrik":{"drink":[20,21,22,23]},"brann":{"drink":[20,21,22,23]},"dagr":{"drink":[20,21,22,23]},"osvik":{"drink":[20,21,22,23]},"tovan":{"drink":[20,21,22,23]},"kelvar":{"drink":[20,21,22,23]}}
# Working keys follow the existing contact timing. Pick views match the current
# front/side/back worker renderer; a hammer is always the authored side view.
const WORK={
 "borin":{"hammer":{1:[20,21,22,23]}},"odrin":{"hammer":{1:[20,21,22,23]}},
 "brann":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}},
 "dagr":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}},
 "osvik":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}},
 "tovan":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}},
 "kelvar":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}},
 "yrsa":{"hammer":{1:[24,25,26,27]},"pick":{0:[28,29,30,31],1:[32,33,34,35],3:[36,37,38,39]}}
}
static func has_profile(p:Dictionary,action:String="")->bool:
 var id=str(p.get("cast_id",""))
 # An unsupported future activity must retain its existing action renderer,
 # never silently become a standing pose. Approve only reachable complete sets.
 return id in APPROVED and (action in ["","town_walk"] or ACTIVITIES.get(id,{}).has(action) or WORK.get(id,{}).has(action))
static func register(metadata:Dictionary,include_candidates:bool=false):
 for id in (CAST if include_candidates else APPROVED):
  metadata[PREFIX+id+".webp"]=JSON.parse_string(FileAccess.get_file_as_string(PREFIX+id+".json"))
static func descriptor(p:Dictionary,d:Vector2,walking:bool,time:float,action:String,phase:float,metadata:Dictionary)->Dictionary:
 var view=HoldDirectional.view(d)
 var key=posmod(int(time/HoldWholeFrames.CYCLE*4),4)
 var sheet=PREFIX+str(p.cast_id)+".webp"
 var index=view if not walking else 4+view*4+key
 var activities:Dictionary=ACTIVITIES.get(str(p.cast_id),{})
 if activities.has(action):
  key=clampi(int(phase),0,3);index=activities[action][key];view=0;walking=false
 var work:Dictionary=WORK.get(str(p.cast_id),{})
 if work.has(action):
  view=(0 if d.y>0 else 3) if action=="pick" and absf(d.y)>absf(d.x)*1.35 else 1
  key=HoldWholeFrames.contact_frame(phase);index=work[action][view][key];walking=false
 var m=metadata[sheet][index];var r=m.rect
 var rect=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1])
 var scale=float(HEIGHTS.get(p.cast_id,HoldWholeFrames.HEIGHT))/float(m.height)
 return {"sheet":sheet,"index":index,"view":view,"frame":key,"rect":rect,"root":root,"scale":scale,"shape":Vector2.ONE*scale,"action":action,"phase":phase,"walking":walking,"destination":Rect2((rect.position-root)*scale,rect.size*scale)}
