class_name HoldCivicArt
extends RefCounted
# Measured source silhouettes; town, construction and collision share the catalogue.
const ATLAS=preload("res://assets/hold-kit68/civic.png")
const CROPS={"orrery":Rect2(617,22,372,458),"notice_board":Rect2(1080,65,432,406),"oath_stone":Rect2(50,554,448,408),"pressure_manifold":Rect2(547,535,459,425),"training_rack":Rect2(1048,591,460,360)}
const EXIT=Rect2(40,65,467,420)
static func draw(g,p:Vector2,kind:String,tint:Color=Color.WHITE):
 g.draw_texture_rect_region(ATLAS,HoldFurnishings.silhouette(kind,p),CROPS[kind],tint)
static func exit_rect(area:String)->Rect2:
 return Rect2(HoldRoomLayout.exit_point(area)-Vector2(76,60),Vector2(152,100))
static func exit_sides(area:String)->Array:
 var p=HoldRoomLayout.exit_point(area)
 return [Rect2(p+Vector2(-72,-18),Vector2(33,58)),Rect2(p+Vector2(39,-18),Vector2(33,58))]
static func has_exit(area:String)->bool:
 return not HoldNeighborhood.is_home(area) or HoldNeighborhood.parts(area)[2]!="1"
static func exit_floor(g,area:String):
 if not has_exit(area):return
 var p=HoldRoomLayout.exit_point(area)
 # Gentle threshold light, clipped to its actual clear approach, never a radius disc.
 for i in range(5,0,-1):
  g.draw_rect(Rect2(p+Vector2(-32,-18-i*8),Vector2(64,8)),Color(1,.78,.42,.07+(5-i)*.012))
 g.draw_texture_rect_region(ATLAS,exit_rect(area),EXIT)
