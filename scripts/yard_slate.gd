extends RefCounted

const APPROACH = preload("res://assets/timber_wing/claim_path.gd")
const FLAG = preload("res://assets/cottage_timber/slate.png")
const EARTH = preload("res://assets/claim_yard/wear.png")
const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
const TILE = 40.0
const UV = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]

static func flag(g, centre: Vector2, span: Vector2, seed_value: int, alpha: float):

	var lean = deg_to_rad(float(posmod(seed_value, 11) - 5))
	var half = span * 0.5
	var variant = posmod(seed_value, 4)
	var uv_offset = Vector2(variant % 2, floori(variant / 2.0)) * 0.5
	var uvs = PackedVector2Array()
	for uv in UV:
		uvs.append(uv_offset + uv * 0.5)
	var corners = PackedVector2Array()
	for corner in [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]:
		corners.append(centre + (corner * half).rotated(lean))
	var value = 0.92 + 0.018 * posmod(seed_value, 5)
	var tint = Color(value * 0.97, value * 1.04, value * 1.16, alpha)
	g.draw_polygon(corners, PackedColorArray([tint]), uvs, FLAG)

static func earth(g, centre: Vector2, size: Vector2, alpha: float):
	g.draw_texture_rect(EARTH, Rect2(centre - size * 0.5, size), false, Color(0.85, 0.8, 0.68, alpha * 0.47))

static func draw(g, p: Vector2, paths: Dictionary, alpha: float = 1):
	var seed_value = roundi(p.x / TILE) * 31 + roundi(p.y / TILE) * 13
	var connections = []
	var nearest = APPROACH.porch_point(p)
	var distance = p.distance_to(nearest)
	var approach_direction = p.direction_to(nearest)
	var joins_approach = distance >= 30 and distance <= 61 and not APPROACH.on_cart_lane(p)
	for direction in DIRECTIONS:
		if paths.has(HoldClaimYard.key(p + direction * TILE)):
			connections.append(direction)
			if direction.dot(approach_direction) > 0.62:
				joins_approach = false


	var centre = p
	if connections.size() == 2 and connections[0].dot(connections[1]) == 0:
		centre += (connections[0] + connections[1]) * 6.0
	earth(g, centre, Vector2(44, 40), alpha)
	for direction in connections:

		if alpha == 1 and (direction == Vector2.LEFT or direction == Vector2.UP):
			continue
		var bridge: Vector2 = p + direction * (TILE * 0.5)
		earth(g, bridge, Vector2(37, 33), alpha)
		var span = Vector2(17, 23) if direction.x != 0 else Vector2(26, 16)
		flag(g, bridge + Vector2(0.6, -0.5), span, seed_value + 2, alpha)
	if joins_approach:
		var outer_edge = p + approach_direction * (distance - 10)
		var steps = maxi(1, roundi(p.distance_to(outer_edge) / 16.0))
		for i in range(1, steps + 1):
			var join = p.lerp(outer_edge, float(i) / steps)
			earth(g, join, Vector2(39, 33), alpha)
			flag(g, join, Vector2(23, 17), seed_value + i, alpha)
	flag(g, centre + Vector2(posmod(seed_value, 3) - 1, 0), Vector2(27, 24), seed_value, alpha)
