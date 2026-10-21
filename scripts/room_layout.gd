class_name HoldRoomLayout
extends RefCounted
# Architectural dimensions, clear floor, door and furnishings share one plan.
# The forge is a proper hall; apartments retain their compact established plan.
static func floor_rect(area:String)->Rect2:
 return Rect2(160,260,1020,650) if area=="room:forge" else Rect2(160,260,640,385)
static func bounds(area:String)->Rect2:
 var r=floor_rect(area)
 return Rect2(r.position+Vector2(15,30),r.size-Vector2(30,40))
static func size(area:String)->Vector2:return Vector2(1340,1010) if area=="room:forge" else Vector2(960,720)
static func exit_point(area:String)->Vector2:return Vector2(480,floor_rect(area).end.y-25)
static func camera(area:String,p:Vector2)->Vector2:
 # Keep the real south threshold above the hotbar as the player approaches it.
 var r=floor_rect(area);var max_y=r.end.y-375
 var target=p-Vector2(480,280)
 target.y=maxf(target.y,lerpf(115,max_y,clampf((p.y-(r.end.y-220))/110.0,0,1)))
 return target.clamp(Vector2(0,115),Vector2(380 if area=="room:forge" else 0,max_y))
static func objects(w,area:String)->Array:
 if area!="room:forge":return []
 return [w.furn("hearth",1010,355),w.furn("worktable",970,550),w.furn("worktable",970,755),w.furn("worktable",680,755),w.furn("chest",1080,485),w.furn("chest",1080,735),w.furn("lamp",1140,320),w.furn("lamp",1140,850),w.furn("bookcase",780,335)]
static func obstacles(area:String)->Array:
 if area!="room:forge":return []
 return [HoldFurnishings.footprint("stone_pillar",Vector2(800,578)),HoldFurnishings.footprint("stone_pillar",Vector2(800,823))]
