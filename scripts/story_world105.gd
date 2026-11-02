class_name HoldStoryWorld105
extends RefCounted
# Activate only complete, reviewed bundles. Portrait coverage is independent.
const CAST=["dagna","ragnhild","brynja","edda","rurik","torvik","ketil","hakon","bram","sten"]
# Dagna and Ragnhild have reviewed four-view locomotion and resting stances.
# Dagna also has authored drinking keys; Ragnhild currently walks/rests.
# Remaining studies are quarantined; technical tests never grant approval.
const APPROVED:Array[String]=["dagna","ragnhild"]
const HEIGHTS={"brynja":58.0,"ragnhild":64.0,"edda":63.0,"yrsa":58.0,"sigrid":64.0}
const PREFIX="res://assets/story105/world/"
const ACTIVITIES={"dagna":{"drink":[20,21,22,23]}}
static func has_profile(p:Dictionary,action:String="")->bool:
 var id=str(p.get("cast_id",""))
 # An unsupported future activity must retain its existing action renderer,
 # never silently become a standing pose. Approve only reachable complete sets.
 return id in APPROVED and (action in ["","town_walk"] or ACTIVITIES.get(id,{}).has(action))
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
 var m=metadata[sheet][index];var r=m.rect
 var rect=Rect2(r[0],r[1],r[2],r[3]);var root=Vector2(m.root[0],m.root[1])
 var scale=float(HEIGHTS.get(p.cast_id,HoldWholeFrames.HEIGHT))/float(m.height)
 return {"sheet":sheet,"index":index,"view":view,"frame":key,"rect":rect,"root":root,"scale":scale,"shape":Vector2.ONE*scale,"action":action,"phase":phase,"walking":walking,"destination":Rect2((rect.position-root)*scale,rect.size*scale)}
