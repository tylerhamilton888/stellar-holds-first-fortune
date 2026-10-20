class_name HoldPaintedPortraits
extends RefCounted
const PALETTE=preload("res://scripts/portrait_palette60.gdshader")
static var sources:Dictionary={}
static func identity(p:Dictionary)->String:
 return "eirik" if p.get("cast_id","")=="eirik" else HoldWholeFrames.identity(p)
static func texture(p:Dictionary)->Texture2D:
 var id=identity(p)
 if not sources.has(id):sources[id]=load("res://assets/portraits60/"+id+".png")
 return sources[id]
static func apply(canvas:CanvasItem,p:Dictionary):
 if identity(p)=="eirik":canvas.material=null;return
 if canvas.material==null:
  canvas.material=ShaderMaterial.new();canvas.material.shader=PALETTE
 var m:ShaderMaterial=canvas.material
 m.set_shader_parameter("hair_colour",HoldAppearance.hair(p))
 m.set_shader_parameter("cloth_colour",HoldAppearance.cloth(p))
 m.set_shader_parameter("skin_colour",HoldAppearance.skin(p))
 m.set_shader_parameter("metal_colour",Color(["d8a651","c3cfd2","d59742","746f60"][p.jewelry]))
 m.set_shader_parameter("change_metal",p.jewelry>0)
