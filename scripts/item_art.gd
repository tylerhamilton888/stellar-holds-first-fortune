class_name HoldItemArt
extends RefCounted
const SUPPLIES=["barley_seed","carrot_seed","hearthcap_seed","turnip_seed","rough_block","dressed_stone","basalt_block","dressed_basalt","shaped_haft","forged_pickhead","tool_fittings","iron","copper","river_fish","water","hearthknot"]
static var supply_sheet:Texture2D
static var supply_icons={}
static var hearth_textures={}

static func supply_icon(index:int)->Texture2D:
 if supply_sheet==null:
  var source=Image.new()
  if source.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://assets/stonebridge_ui/goods.webp"))!=OK:return null
  supply_sheet=ImageTexture.create_from_image(source)
 if not supply_icons.has(index):
  var tex=AtlasTexture.new()
  tex.atlas=supply_sheet;tex.region=Rect2((index%4)*96,floori(index/4.0)*96,96,96);tex.filter_clip=true
  supply_icons[index]=tex
 return supply_icons[index]

static func hearth_texture(id:String)->Texture2D:
 if id in HoldRawArt135.GOODS:return HoldRawArt135.texture_for(id)
 if not hearth_textures.has(id):hearth_textures[id]=load("res://assets/hearth78/"+id+".svg")
 return hearth_textures[id]
const HEARTH_IDS=["carrot", "barley", "hearthcap", "pond_perch", "silver_char", "root_hotpot", "barley_bread", "fish_chowder", "char_plate", "turnip", "hold_ale", "hearthknot"]
const FIELD=preload("res://assets/animation-v51/homestead-props.png")
const TOOLS=preload("res://assets/animation-v51/field-tools.png")
const SHEET=preload("res://assets/character-parts/items.png")
const REGIONS=[Rect2(20,6,364,410),Rect2(460,5,190,410),Rect2(765,5,245,410),Rect2(1110,5,250,410),Rect2(5,435,363,277),Rect2(372,445,343,267),Rect2(724,459,358,257),Rect2(1084,432,360,285),Rect2(19,713,338,367),Rect2(364,719,344,356),Rect2(725,719,358,355),Rect2(1110,715,312,361)]
static func draw(n:CanvasItem,rect:Rect2,index:int,tint:Color=Color.WHITE):
 if index>=100:
  n.draw_texture_rect(supply_icon(index-100),rect,false);return
 if index>=60:
  HoldRawArt135.draw(n,rect,HoldRawArt135.GOODS[index-60],tint);return
 if index>=40:
  HoldRawArt135.draw(n,rect,HoldRawArt135.IDS[index-40],tint);return
 if index>=20:
  n.draw_texture_rect(hearth_texture(HEARTH_IDS[index-20]),rect,false,tint);return
 if index>=12:
  n.draw_texture_rect_region(TOOLS if index==14 else FIELD,rect,Rect2(HoldDrawnAnimation.bounds("field-tools" if index==14 else "homestead-props",0 if index==14 else 6 if index==12 else 7)),tint);return
 n.draw_texture_rect_region(SHEET,rect,REGIONS[index],tint)
static func item_index(id:String)->int:
 if id in SUPPLIES:return 100+SUPPLIES.find(id)
 if id in HoldRawArt135.GOODS:return 60+HoldRawArt135.GOODS.find(id)
 if id in HoldRawArt135.IDS:return 40+HoldRawArt135.IDS.find(id)
 if id in HEARTH_IDS:return 20+HEARTH_IDS.find(id)
 if id.ends_with("_seed"):return 13
 return {"shaped_haft":7,"forged_pickhead":6,"tool_fittings":9,"river_fish":12,"turnip_seed":13,"turnip":14,"energy_cell":8,"iron_slag":4,"copper_slag":4,"ammo":6,"scrap":9,"shell":4,"stone":4,"iron_ore":4,"copper_ore":4,"coal":5,"iron":6,"copper":6,"wood":7,"crystal":8,"parts":9,"assembly":9,"food":10,"water":11}.get(id,4)
static func tint(id:String)->Color:
 if id in SUPPLIES or id in HoldRawArt135.IDS:return Color.WHITE
 return {"stone":Color("9caab5"),"copper":Color("efac72"),"copper_ore":Color("ffba88")}.get(id,Color.WHITE)
static func icon(parent:Node,id:String):
 if id in SUPPLIES or id in HoldRawArt135.IDS or id in HoldRawArt135.GOODS:
  var art=TextureRect.new();art.texture=supply_icon(SUPPLIES.find(id)) if id in SUPPLIES else HoldRawArt135.texture_for(id);art.custom_minimum_size=Vector2(30,30);art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;parent.add_child(art);return
 if id in HEARTH_IDS:
  var art=TextureRect.new();art.texture=hearth_texture(id);art.custom_minimum_size=Vector2(30,30);art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;parent.add_child(art);return
 var view=TextureRect.new();var tex=AtlasTexture.new();var index=item_index(id);tex.atlas=TOOLS if index==14 else FIELD if index>=12 else SHEET;tex.region=Rect2(HoldDrawnAnimation.bounds("field-tools" if index==14 else "homestead-props",0 if index==14 else 6 if index==12 else 7)) if index>=12 else REGIONS[index]
 view.texture=tex;view.modulate=tint(id);view.custom_minimum_size=Vector2(30,30);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;parent.add_child(view)
static func tool(n:Node2D,origin:Vector2,end:Vector2,kind:int,reset:Vector2=Vector2.ZERO):
 var length=origin.distance_to(end)
 n.draw_set_transform(origin,(end-origin).angle()+PI/2)
 var width=length*[.88,.46,.60,.61][clampi(kind,0,3)]
 draw(n,Rect2(-width/2,-length,width,length+4),clampi(kind,0,3))
 n.draw_set_transform(reset)
