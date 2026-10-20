class_name HoldCharacterMaterials
extends RefCounted
# Immutable material labels, authored offline for each exact exported pose.
# 0 untouched, 1 hair (including beard/brows), 3 skin, 4 cloth, 5 fittings.
static var cache:Dictionary={}
static func mask_for(id:String,width:int,height:int)->PackedByteArray:
 if cache.has(id):return cache[id]
 var path="res://assets/walk-v37/"+id.trim_prefix("walk37/")+".mask" if id.begins_with("walk37/") else "res://assets/palette-v36/"+id+".mask"
 var bytes=FileAccess.get_file_as_bytes(path)
 if bytes.size()!=width*height:
  push_error("Invalid character material mask: "+id)
  bytes.resize(width*height)
  bytes.fill(0) # Fail closed: never recolor guessed skin or equipment.
 cache[id]=bytes
 return bytes
