class_name HoldItemArt
extends RefCounted
const SHEET=preload("res://assets/character-parts/items.png")
const REGIONS=[Rect2(20,6,364,410),Rect2(460,5,190,410),Rect2(765,5,245,410),Rect2(1110,5,250,410),Rect2(5,435,363,277),Rect2(372,445,343,267),Rect2(724,459,358,257),Rect2(1084,432,360,285),Rect2(19,713,338,367),Rect2(364,719,344,356),Rect2(725,719,358,355),Rect2(1110,715,312,361)]
static func draw(n:CanvasItem,rect:Rect2,index:int,tint:Color=Color.WHITE):
 n.draw_texture_rect_region(SHEET,rect,REGIONS[index],tint)
static func item_index(id:String)->int:
 return {"energy_cell":8,"iron_slag":4,"copper_slag":4,"ammo":6,"scrap":9,"shell":4,"stone":4,"iron_ore":4,"copper_ore":4,"coal":5,"iron":6,"copper":6,"wood":7,"crystal":8,"parts":9,"assembly":9,"food":10,"water":11}.get(id,4)
static func tint(id:String)->Color:
 return {"stone":Color("9caab5"),"copper":Color("efac72"),"copper_ore":Color("ffba88")}.get(id,Color.WHITE)
static func icon(parent:Node,id:String):
 var view=TextureRect.new();var tex=AtlasTexture.new();tex.atlas=SHEET;tex.region=REGIONS[item_index(id)]
 view.texture=tex;view.modulate=tint(id);view.custom_minimum_size=Vector2(30,30);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;parent.add_child(view)
static func tool(n:Node2D,origin:Vector2,end:Vector2,kind:int,reset:Vector2=Vector2.ZERO):
 var length=origin.distance_to(end)
 n.draw_set_transform(origin,(end-origin).angle()+PI/2)
 var width=length*[.88,.46,.60,.61][clampi(kind,0,3)]
 draw(n,Rect2(-width/2,-length,width,length+4),clampi(kind,0,3))
 n.draw_set_transform(reset)
