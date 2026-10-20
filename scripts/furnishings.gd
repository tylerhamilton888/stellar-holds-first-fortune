class_name HoldFurnishings
extends RefCounted
# One catalogue for town props, player construction, previews and physical bases.
# Source crops are measured, with no painted room/floor baked into them.
const ATLAS=preload("res://assets/furnishings-v56/interior.png")
const CROPS=[Rect2(40,83,316,237),Rect2(424,22,308,300),Rect2(805,57,326,271),Rect2(1250,36,210,289),Rect2(15,429,407,224),Rect2(442,397,320,258),Rect2(805,376,325,282),Rect2(1180,328,323,340),Rect2(54,661,288,342),Rect2(491,668,188,334),Rect2(853,751,257,226),Rect2(1204,698,280,291)]
# size is the visible silhouette; base is its ground-plane occupied rectangle.
const ITEMS={
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
const BUILDABLE=["chest","table","chair","lamp","bed","desk","bookcase","counter","hearth"]
static func footprint(kind:String,p:Vector2)->Rect2:
 var r:Rect2=ITEMS.get(kind,ITEMS.table).base
 return Rect2(p+r.position,r.size)
static func silhouette(kind:String,p:Vector2)->Rect2:
 var size:Vector2=ITEMS.get(kind,ITEMS.table).size
 return Rect2(p-Vector2(size.x*.5,size.y),size)
static func draw(n:Node2D,p:Vector2,kind:String,tint:Color=Color.WHITE):
 var item=ITEMS.get(kind,ITEMS.table)
 if kind=="hearth":
  var clock=n.get("clock")
  HoldAmbientProps.hearth(n,p,float(clock) if clock!=null else 0.0,tint)
 else:n.draw_texture_rect_region(ATLAS,silhouette(kind,p),CROPS[item.art],tint)
static func cost_text(kind:String)->String:
 var parts=PackedStringArray()
 for resource in ITEMS[kind].cost:parts.append(str(ITEMS[kind].cost[resource])+" "+("timber" if resource=="wood" else resource))
 return " + ".join(parts)
