class_name HoldFurnishings
extends RefCounted
# One catalogue for town props, player construction, previews and physical bases.
# Source crops are measured, with no painted room/floor baked into them.
const ANVIL=preload("res://assets/anniversary-v31/anvil.png")
const DOUBLE_BED=preload("res://assets/hold77/double-bed.png")
const ATLAS=preload("res://assets/furnishings-v56/interior.png")
const CROPS=[Rect2(40,83,316,237),Rect2(424,22,308,300),Rect2(805,57,326,271),Rect2(1250,36,210,289),Rect2(15,429,407,224),Rect2(442,397,320,258),Rect2(805,376,325,282),Rect2(1180,328,323,340),Rect2(54,661,288,342),Rect2(491,668,188,334),Rect2(853,751,257,226),Rect2(1204,698,280,291)]
# size is the visible silhouette; base is its ground-plane occupied rectangle.
const ITEMS={
 "anvil":{"title":"Forge anvil","size":Vector2(43.35,42.5),"base":Rect2(-22.475,-20.7,48,28),"cost":{"iron":8,"wood":4,"stone":2},"sort_offset":-35.7},
 "royal_throne":{"title":"High-seat throne","size":Vector2(132,160),"base":Rect2(-54,-60,108,65),"cost":{"dressed_stone":30,"iron":8,"crystal":4},"sort_offset":-55.0},
 "royal_pillar":{"title":"Royal carved pillar","size":Vector2(85,162),"base":Rect2(-34,-22,68,25),"cost":{"dressed_stone":14,"iron":2}},
 "royal_arch":{"title":"Royal relief arch","size":Vector2(435,254),"base":Rect2(),"cost":{"dressed_stone":40,"iron":8,"crystal":6},"sort_offset":-110.0},
 "royal_brazier":{"title":"Royal brazier","size":Vector2(48,76),"base":Rect2(-19,-20,38,23),"cost":{"dressed_stone":6,"iron":5,"coal":4}},
 "pantry":{"title":"Carved pantry shelf","base_kind":"bookcase","cost":{"wood":6,"stone":2},"dressing":[["kettle",Vector2(-10,-30)],["mug",Vector2(10,-30)]]},
 "hearth_table":{"title":"Family supper table","base_kind":"table","cost":{"wood":6,"stone":2},"dressing":[["kettle",Vector2(0,-30)],["mug",Vector2(-17,-29)],["mug",Vector2(17,-29)]]},
 "double_bed":{"title":"Shared oak double bed","size":Vector2(86,77),"base":Rect2(-41,-62,82,62),"cost":{"wood":10,"stone":4}},
 "orrery":{"title":"Founders’ orrery","size":Vector2(76,94),"base":Rect2(-31,-25,62,25),"cost":{"stone":8,"iron":6,"crystal":2}},
 "notice_board":{"title":"Public notice board","size":Vector2(78,72),"base":Rect2(-36,-16,72,16),"cost":{"wood":8,"stone":4}},
 "oath_stone":{"title":"Ancestral oath-stone","size":Vector2(144,132),"base":Rect2(-68,-48,136,48),"cost":{"stone":20,"dressed_stone":8}},
 "pressure_manifold":{"title":"Pressure manifold display","size":Vector2(100,92),"base":Rect2(-46,-28,92,28),"cost":{"stone":8,"iron":12}},
 "training_rack":{"title":"Training weapon rack","size":Vector2(92,72),"base":Rect2(-43,-18,86,18),"cost":{"wood":8,"iron":4}},
 "worktable":{"title":"Workshop table","art":4,"size":Vector2(108,34),"base":Rect2(-51,-18,102,18),"cost":{"wood":8,"stone":2}},
 "stone_pillar":{"title":"Carved stone pillar","size":Vector2(54,124),"base":Rect2(-25,-22,50,22),"cost":{"stone":12,"dressed_stone":4}},
 "tea_table":{"title":"Tea table","base_kind":"table","cost":{"wood":4,"stone":2},"dressing":[["kettle",Vector2(0,-30)],["mug",Vector2(-16,-29)],["mug",Vector2(16,-29)]]},
 "serving_counter":{"title":"Serving counter","base_kind":"counter","cost":{"wood":9,"stone":2},"dressing":[["mug",Vector2(-23,-41)],["mug",Vector2(19,-41)]]},
 "chest":{"title":"Storage chest","art":0,"size":Vector2(44,33),"base":Rect2(-20,-17,40,17),"cost":{"wood":4}},
 "chest_open":{"title":"Storage chest","art":1,"size":Vector2(44,43),"base":Rect2(-20,-17,40,17),"cost":{"wood":4}},
 "table":{"title":"Oak table","art":2,"size":Vector2(57,47),"base":Rect2(-26,-26,52,26),"cost":{"wood":3,"stone":2}},
 "chair":{"title":"Carved chair","art":3,"size":Vector2(25,35),"base":Rect2(-11,-13,22,13),"cost":{"wood":2}},
 "counter":{"title":"Tavern counter","art":4,"size":Vector2(108,60),"base":Rect2(-51,-27,102,27),"cost":{"wood":8,"stone":2}},
 "desk":{"title":"Writing desk","art":5,"size":Vector2(66,53),"base":Rect2(-30,-27,60,27),"cost":{"wood":5,"stone":2}},
 "bookcase":{"title":"Low bookcase","art":6,"size":Vector2(50,44),"base":Rect2(-23,-14,46,14),"cost":{"wood":5,"stone":4}},
 "hearth":{"title":"Stone hearth","art":7,"size":Vector2(72,76),"base":Rect2(-32,-28,64,28),"cost":{"wood":2,"stone":12}},
 "bed":{"title":"Oak bed","art":8,"size":Vector2(48,76),"base":Rect2(-22,-62,44,62),"cost":{"wood":5,"stone":2}},
 "lamp":{"title":"Standing lantern","art":9,"size":Vector2(22,39),"base":Rect2(-9,-12,18,12),"cost":{"wood":3,"stone":2}},
 "mug":{"title":"Copper mug","art":10,"size":Vector2(6,6),"base":Rect2(),"cost":{}},
 "kettle":{"title":"Tea kettle","art":11,"size":Vector2(12,12),"base":Rect2(),"cost":{}}
}
const BUILDABLE=["anvil","double_bed","royal_throne","royal_pillar","royal_arch","royal_brazier","pantry","hearth_table","chest","table","tea_table","chair","lamp","bed","desk","bookcase","counter","serving_counter","worktable","hearth","stone_pillar","orrery","notice_board","oath_stone","pressure_manifold","training_rack"]
static func geometry(kind:String)->Dictionary:
 var item=ITEMS.get(kind,ITEMS.table)
 return ITEMS[item.base_kind] if item.has("base_kind") else item
static func footprint(kind:String,p:Vector2)->Rect2:
 var r:Rect2=geometry(kind).base
 return Rect2(p+r.position,r.size)
static func silhouette(kind:String,p:Vector2)->Rect2:
 var size:Vector2=geometry(kind).size
 return Rect2(p-Vector2(size.x*.5,size.y),size)
static func draw(n:CanvasItem,p:Vector2,kind:String,tint:Color=Color.WHITE):
 var item=geometry(kind)
 if kind.begins_with("royal_"):
  var index=["royal_throne","royal_pillar","royal_arch","royal_brazier"].find(kind)
  HoldRoyalStage.draw_prop(n,{"p":p,"art":index,"width":item.size.x},float(n.get("clock")),tint)
 elif HoldCivicArt.CROPS.has(kind):HoldCivicArt.draw(n,p,kind,tint)
 elif kind=="anvil":draw_anvil(n,silhouette(kind,p),tint)
 elif kind=="double_bed":n.draw_texture_rect_region(DOUBLE_BED,silhouette(kind,p),Rect2(31,33,1250,1114),tint)
 elif kind=="stone_pillar":HoldMasonryArt.pillar(n,p,124,tint)
 elif kind=="hearth":
  var clock=n.get("clock")
  HoldAmbientProps.hearth(n,p,float(clock) if clock!=null else 0.0,tint)
 else:n.draw_texture_rect_region(ATLAS,silhouette(kind,p),CROPS[item.art],tint)
 for detail in ITEMS.get(kind,ITEMS.table).get("dressing",[]):draw(n,p+detail[1],detail[0],tint)
static func draw_anvil(n:CanvasItem,r:Rect2,tint:Color=Color.WHITE):n.draw_texture_rect(ANVIL,r,false,tint)
# Service anchors are on the usable side of the physical prop.
static func bedside(p:Vector2,side:int=1,kind:String="bed")->Vector2:return p+Vector2(side*(geometry(kind).base.size.x*.5+16),-32)
static func desk_access(p:Vector2)->Vector2:return p+Vector2(0,22)
static func cost_text(kind:String)->String:
 var parts=PackedStringArray()
 for resource in ITEMS[kind].cost:parts.append(str(ITEMS[kind].cost[resource])+" "+("timber" if resource=="wood" else resource))
 return " + ".join(parts)
