class_name HoldRoomLayout
extends RefCounted
# Architectural dimensions, clear floor, door and furnishings share one plan.
# The forge is a proper hall; apartments retain their compact established plan.
static func floor_rect(area:String)->Rect2:return HoldBuildingPlans.geometry(area).floor
static func bounds(area:String)->Rect2:return HoldBuildingPlans.geometry(area).bounds
static func size(area:String)->Vector2:return HoldBuildingPlans.geometry(area).size
static func exit_point(area:String)->Vector2:return HoldBuildingPlans.geometry(area).exit
static func camera(area:String,p:Vector2)->Vector2:
 var plan=HoldBuildingPlans.geometry(area);var r=plan.floor;var max_y=r.end.y-375
 if plan.template=="room:throne":return (p-Vector2(480,280)).clamp(Vector2(170,100),Vector2(maxf(170,plan.size.x-960),maxf(705,plan.size.y-475)))
 var target=p-Vector2(480,280)
 target.y=maxf(target.y,lerpf(115,max_y,clampf((p.y-(r.end.y-220))/110.0,0,1)))
 return target.clamp(Vector2(0,115),Vector2(maxf(0,plan.size.x-960),max_y))
static func objects(w,area:String)->Array:
 if area=="room:home":
  if HoldFirstVisit99.lodge_intro(w.g.state):return []
  return [w.furn("bookcase",245,325),w.furn("bookcase",735,335),w.furn("chair",399,420),w.furn("chair",529,420),w.furn("tea_table",464,440),w.furn("chair",650,366),w.furn("bookcase",625,530),w.furn("lamp",690,505)]
 if area=="room:tavern":return [w.furn("counter",735,450),w.furn("bookcase",560,330),w.furn("bookcase",635,330),w.furn("chair",317,540),w.furn("chair",487,540),w.furn("chair",657,540),w.furn("tea_table",270,410),w.furn("chair",222,425),w.furn("chair",318,425),w.furn("lamp",765,335)]
 if area=="room:market":return [w.furn("counter",515,390),w.furn("bookcase",365,335),w.furn("bookcase",645,335),w.furn("worktable",285,510),w.furn("tea_table",700,530),w.furn("chair",747,550),w.furn("lamp",225,570)]
 if area=="room:research":return [w.furn("orrery",350,490),w.furn("bookcase",420,345),w.furn("bookcase",495,345),w.furn("bookcase",735,345),w.furn("desk",690,540),w.furn("lamp",735,510)]
 if area=="room:commission":return [w.furn("bookcase",420,345),w.furn("bookcase",735,345),w.furn("tea_table",310,520),w.furn("chair",263,540),w.furn("chair",357,540),w.furn("lamp",735,510),w.furn("bookcase",735,575)]
 if area!="room:forge":return []
 return [w.furn("hearth",1010,355),w.furn("worktable",970,550),w.furn("worktable",970,755),w.furn("worktable",680,755),w.furn("chest",1080,485),w.furn("chest",1080,735),w.furn("lamp",1140,320),w.furn("lamp",1140,850),w.furn("bookcase",780,335)]
static func obstacles(area:String)->Array:
 if area=="room:throne":return HoldRoyalStage.obstacles()
 if area!="room:forge":return []
 return [HoldFurnishings.footprint("stone_pillar",Vector2(800,578)),HoldFurnishings.footprint("stone_pillar",Vector2(800,823))]

static func rug(w,r:Rect2,tint:Color):
 var index=3 if tint.r>tint.g else 2
 w.g.draw_texture_rect_region(HoldMasonryArt.SURFACES,r,HoldMasonryArt.surface_region(index))
static func dressing(w,area:String):
 # Rugs group ordinary furniture into useful domestic/work areas; no collision.
 if area in ["room:wayfarer","room:greenhearth"]:
  rug(w,Rect2(210,345,140,220),Color("486c6b"))
  rug(w,Rect2(470,387,274,122),Color("756344"))
  rug(w,Rect2(455,540,50,75),Color("526f62"))
 elif area=="room:lodge":
  rug(w,Rect2(200,305,210,95),Color("486c6b"))
  rug(w,Rect2(405,405,150,115),Color("756344"))
 elif area=="room:home":
  rug(w,Rect2(247,342,95,143),Color("486c6b"))
  rug(w,Rect2(373,368,186,112),Color("58756c"))
  rug(w,Rect2(594,476,174,93),Color("636f64"))
 elif area=="room:tavern":
  rug(w,Rect2(205,467,475,105),Color("756344"))
  rug(w,Rect2(211,371,120,79),Color("526f62"))
 elif area in ["room:commission","room:research"]:
  rug(w,Rect2(232,476,155,98),Color("526c69"))
  rug(w,Rect2(565,336,120,105),Color("626c58"))
 elif area=="room:market":rug(w,Rect2(648,483,120,92),Color("746346"))
