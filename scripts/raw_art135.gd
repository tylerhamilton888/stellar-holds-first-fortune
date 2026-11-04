class_name HoldRawArt135
extends RefCounted
# Whole painted loads share one source in the world, pack and quick bar.
const SHEET=preload("res://assets/polish135/raw-materials.png")
const IDS=["stone","iron_ore","copper_ore","coal","crystal","wood"]
const REGIONS=[Rect2(78,88,399,371),Rect2(568,89,401,362),Rect2(1058,88,404,367),Rect2(77,577,398,357),Rect2(568,555,393,386),Rect2(1055,571,424,369)]
const INVENTORY=preload("res://assets/polish135/inventory.png")
const GOODS=["carrot","barley","hearthcap","pond_perch","silver_char","root_hotpot","barley_bread","fish_chowder","char_plate","turnip","hold_ale","food","iron_slag","copper_slag","ammo","scrap","shell","energy_cell","parts","assembly"]
const GOOD_REGIONS=[Rect2(62,49,213,237),Rect2(315,51,228,237),Rect2(578,70,208,208),Rect2(843,110,234,149),Rect2(1115,99,251,177),Rect2(34,325,231,226),Rect2(301,326,236,227),Rect2(569,326,233,226),Rect2(839,326,246,228),Rect2(1152,316,222,246),Rect2(49,587,219,235),Rect2(302,582,233,240),Rect2(574,598,225,220),Rect2(846,599,238,205),Rect2(1122,615,235,191),Rect2(40,855,242,225),Rect2(369,881,103,178),Rect2(596,856,157,215),Rect2(833,861,234,224),Rect2(1102,851,273,229)]
static var goods_textures={}
static var textures={}
static func texture_for(id:String)->Texture2D:
 if id not in GOODS:return texture(id)
 var index=GOODS.find(id)
 if not goods_textures.has(index):
  var atlas=AtlasTexture.new();atlas.atlas=INVENTORY;atlas.region=GOOD_REGIONS[index];atlas.filter_clip=true;goods_textures[index]=atlas
 return goods_textures[index]
static func texture(id:String)->Texture2D:
 var index=maxi(0,IDS.find(id))
 if not textures.has(index):
  var atlas=AtlasTexture.new();atlas.atlas=SHEET;atlas.region=REGIONS[index];atlas.filter_clip=true;textures[index]=atlas
 return textures[index]
static func draw(canvas:CanvasItem,rect:Rect2,id:String,tint:Color=Color.WHITE):
 var tex=texture_for(id);var size=tex.get_size();var scale=minf(rect.size.x/size.x,rect.size.y/size.y)
 var fitted=size*scale
 canvas.draw_texture_rect(tex,Rect2(rect.position+Vector2((rect.size.x-fitted.x)/2,rect.size.y-fitted.y),fitted),false,tint)
