class_name HoldStoryArt105
extends RefCounted
# Authored identity is explicit, never inferred from a generated person's name.
# Portrait production ships independently of unaccepted world animation studies.
const CAST=[
 "dagna","ragnhild","brynja","orla","edda","sigrid",
 "yrsa","ivar","skarrin","rurik","torvik","ketil",
 "hakon","hedrik","borin","eldric","bram","sten",
 "brann","dagr","odrin","osvik","tovan","kelvar"]
const ROAD=["bram","dagna","torvik","ragnhild","ketil","sten","brynja","hakon","skarrin","edda"]
const SHEETS=[
 preload("res://assets/story105/portraits-0.webp"),
 preload("res://assets/story105/portraits-1.webp"),
 preload("res://assets/story105/portraits-2.webp"),
 preload("res://assets/story105/portraits-3.webp")]
static var portraits:Dictionary={}
static func resolve(id:String)->String:
 if id.begins_with("road_folk:"):
  var suffix=id.trim_prefix("road_folk:")
  if not suffix.is_valid_int():return ""
  var index=int(suffix)
  return ROAD[index] if index>=0 and index<ROAD.size() else ""
 if id.begins_with("lodge_folk:"):
  return {"lodge_folk:0":"ivar","lodge_folk:1":"rurik","lodge_folk:2":"sigrid"}.get(id,"")
 return id if id in CAST or id=="eirik" else ""
static func tag(profile:Dictionary,id:String)->Dictionary:
 var name_id=resolve(id)
 if name_id=="":return profile
 var result=profile.duplicate(true);result.cast_id=name_id
 return result
static func has_portrait(p:Dictionary)->bool:
 return str(p.get("cast_id","")) in CAST
static func texture(p:Dictionary)->Texture2D:
 var id=str(p.get("cast_id",""));var index=CAST.find(id)
 if index<0:return null
 if not portraits.has(id):
  var atlas=AtlasTexture.new();atlas.atlas=SHEETS[int(index/6)]
  atlas.region=Rect2((index%3)*512,int((index%6)/3)*512,512,512)
  atlas.filter_clip=true;portraits[id]=atlas
 return portraits[id]
