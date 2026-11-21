extends RefCounted

const LANE = [
 [Vector2(1748, 547), preload("res://assets/timber_wing/lane-0.png")],
 [Vector2(2112, 548), preload("res://assets/timber_wing/lane-1.png")],
 [Vector2(2496, 563), preload("res://assets/timber_wing/lane-2.png")],
 [Vector2(2880, 682), preload("res://assets/timber_wing/lane-3.png")],
 [Vector2(2871, 896), preload("res://assets/timber_wing/lane-4.png")],
 [Vector2(2880, 896), preload("res://assets/timber_wing/lane-5.png")],
 [Vector2(2636, 1280), preload("res://assets/timber_wing/lane-6.png")],
 [Vector2(2880, 1280), preload("res://assets/timber_wing/lane-7.png")],
 [Vector2(2471, 1874), preload("res://assets/timber_wing/lane-8.png")],
 [Vector2(2496, 1664), preload("res://assets/timber_wing/lane-9.png")]
]

const PORCH = [
 [Vector2(2268, 1076), preload("res://assets/timber_wing/porch-0.png")],
 [Vector2(2496, 1127), preload("res://assets/timber_wing/porch-1.png")],
 [Vector2(2880, 1161), preload("res://assets/timber_wing/porch-2.png")]
]

static func draw(g, cam: Vector2):
 var area = Rect2(cam, Vector2(960,540))
 for course in [LANE,PORCH]:
  for piece in course:
   if area.intersects(Rect2(piece[0],piece[1].get_size())):g.draw_texture(piece[1],piece[0])

# The same stone lane used in the authored claim. Leave a cart-width verge.
const ROUTE=[Vector2(1786,600),Vector2(1940,600),Vector2(2130,589),Vector2(2320,603),Vector2(2510,605),Vector2(2710,624),Vector2(2830,675),Vector2(2904,772),Vector2(2926,924),Vector2(2920,1100),Vector2(2918,1230),Vector2(2890,1370),Vector2(2800,1530),Vector2(2650,1710),Vector2(2521,1916)]
const PORCH_WALK=[Vector2(2300,1115),Vector2(2309,1160),Vector2(2350,1175),Vector2(2432,1180),Vector2(2515,1175),Vector2(2592,1167),Vector2(2700,1165),Vector2(2800,1176),Vector2(2900,1190)]
static func porch_point(p: Vector2) -> Vector2:
 var closest: Vector2 = PORCH_WALK[0]
 for i in range(1, PORCH_WALK.size()):
  var q = Geometry2D.get_closest_point_to_segment(p, PORCH_WALK[i - 1], PORCH_WALK[i])
  if p.distance_squared_to(q) < p.distance_squared_to(closest): closest = q
 return closest
static func on_lane(p:Vector2)->bool:
 return p.distance_squared_to(porch_point(p)) < 43 * 43 or on_cart_lane(p)
static func on_cart_lane(p: Vector2) -> bool:
 for i in range(1,ROUTE.size()):
  if p.distance_squared_to(Geometry2D.get_closest_point_to_segment(p,ROUTE[i-1],ROUTE[i]))<64*64:return true
 return false
