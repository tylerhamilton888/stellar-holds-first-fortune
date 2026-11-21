extends RefCounted


const STEP = 20
const CLEARANCE = 26

static func xy(p: Array) -> Vector2:
	return Vector2(p[0], p[1])

static func pair(p: Vector2) -> Array:
	return [roundi(p.x), roundi(p.y)]

static func near_segment(a: Vector2, b: Vector2, rect: Rect2) -> bool:
	if rect.has_point(a) or rect.has_point(b): return true
	var top = Vector2(rect.end.x, rect.position.y)
	var bottom = Vector2(rect.position.x, rect.end.y)
	for edge in [[rect.position, top], [top, rect.end], [rect.end, bottom], [bottom, rect.position]]:
		if Geometry2D.segment_intersects_segment(a, b, edge[0], edge[1]) != null: return true
	return false

static func clear_line(a: Vector2, b: Vector2, blocked: Array) -> bool:
	for rect in blocked:
		if near_segment(a, b, rect): return false
	return true

static func route(grid: AStarGrid2D, a: Vector2, b: Vector2, blocked: Array) -> Array:
	if clear_line(a, b, blocked): return [pair(a), pair(b)]
	var steps = grid.get_point_path(Vector2i((a / STEP).round()), Vector2i((b / STEP).round()))
	if steps.is_empty(): return []
	var points = PackedVector2Array([a])
	points.append_array(steps);points.append(b)
	var path = [pair(a)]; var index = 0
	while index < points.size() - 1:
		var next = points.size() - 1
		while next > index and not clear_line(points[index], points[next], blocked): next -= 1
		if next == index: return []
		path.append(pair(points[next]));index = next
	return path

static func compose(seed_value: int, bounds: Rect2, fixed: Dictionary, solids: Array, reserved: Array, sites: Array, links: Array) -> Dictionary:
	var rng = RandomNumberGenerator.new();rng.seed = seed_value
	for attempt in 16:
		var marks = fixed.duplicate(); var occupied = reserved.duplicate(); var blocked = solids.duplicate()
		var placed = 0
		for site in sites:
			var candidates = []
			for y in range(site.band.position.y, site.band.end.y + 1, 40):
				for x in range(site.band.position.x, site.band.end.x + 1, 40): candidates.append(Vector2(x, y))

			for i in range(candidates.size() - 1, 0, -1):
				var j = rng.randi_range(0, i); var swap = candidates[j];candidates[j] = candidates[i];candidates[i] = swap
			for center in candidates:
				var parcel = Rect2(center + site.parcel.position, site.parcel.size)
				if not bounds.encloses(parcel): continue
				if occupied.any( func(rect): return rect.intersects(parcel)) or solids.any( func(rect): return rect.intersects(parcel)): continue
				occupied.append(parcel);marks[site.id] = center
				var facing = 1 if rng.randi() % 2 == 0 else -1
				for name in site.parts:
					var part = site.parts[name]; var pos = center + Vector2(part[0].x * facing, part[0].y)
					if part.size() > 2:
						pos += Vector2(rng.randi_range( - part[2].x, part[2].x), rng.randi_range( - part[2].y, part[2].y))
					marks[name] = pos;blocked.append(Rect2(pos - part[1], part[1] * 2))
				placed += 1;break
		if placed != sites.size(): continue
		var barriers = []
		for rect in blocked: barriers.append(rect.grow(CLEARANCE))
		var grid = AStarGrid2D.new()
		var first = Vector2i((bounds.position / STEP).ceil()); var last = Vector2i((bounds.end / STEP).floor())
		grid.region = Rect2i(first, last - first + Vector2i.ONE);grid.cell_size = Vector2.ONE * STEP
		grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES;grid.update()
		for rect in barriers:
			var lo = Vector2i((rect.position / STEP).floor()); var hi = Vector2i((rect.end / STEP).ceil())
			for y in range(lo.y, hi.y + 1):
				for x in range(lo.x, hi.x + 1):
					if grid.region.has_point(Vector2i(x, y)) and rect.has_point(Vector2(x, y) * STEP): grid.set_point_solid(Vector2i(x, y))
		var paths = []
		for edge in links:
			var path = route(grid, marks[edge[0]], marks[edge[1]], barriers)
			if path.is_empty(): break
			paths.append(path)
		if paths.size() != links.size(): continue
		var packed = {}
		for name in marks: packed[name] = pair(marks[name])
		return {"version": 1, "seed": seed_value, "marks": packed, "paths": paths}
	return {}
