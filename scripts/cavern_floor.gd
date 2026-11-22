extends RefCounted


const CORNERS = [Vector2i.ZERO, Vector2i.RIGHT, Vector2i.ONE, Vector2i.DOWN]
const EDGES = [Vector2(0.5, 0), Vector2(1, 0.5), Vector2(0.5, 1), Vector2(0, 0.5)]

static func paint(g, world, bounds: Rect2i, texture: Texture2D):
	var visible = Rect2i(world.cell(g.camera) - Vector2i.ONE, Vector2i(27, 17)).intersection(bounds)
	var seen = world.layer().seen
	for y in range(visible.position.y, visible.end.y):
		for x in range(visible.position.x, visible.end.x):
			var c = Vector2i(x, y); var mask = 0
			for i in 4:
				var n = c + CORNERS[i]
				if world.at(n) == 0 and seen.has(world.key(n)): mask |= 1 << i
			if mask == 0: continue
			var tl = world.center(c)
			var pts = PackedVector2Array(); var joins = PackedVector2Array()
			for i in 4:
				var open = (mask & (1 << i)) != 0; var next = (mask & (1 << ((i + 1) % 4))) != 0
				if open: pts.append(tl + Vector2(CORNERS[i]) * 40)
				if open != next:
					var p = tl + EDGES[i] * 40
					var jitter = sin(p.x * 0.091 + p.y * 0.047) * 3.7
					p += Vector2(jitter, 0) if i % 2 == 0 else Vector2(0, jitter)
					pts.append(p);joins.append(p)

			if mask in [5, 10]:
				for i in 4:
					if mask & (1 << i):
						var vertex = tl + Vector2(CORNERS[i]) * 40
						var tri = PackedVector2Array([vertex, tl + EDGES[i] * 40, tl + EDGES[(i + 3) % 4] * 40])
						fill(g, tri, bounds, texture)
				continue
			fill(g, pts, bounds, texture)
			if joins.size() == 2:
				var a = joins[0]; var b = joins[1]; var center = Vector2.ZERO
				for p in pts: center += p
				center /= pts.size()
				var mid = (a + b) * 0.5; var normal = (center - mid).normalized()
				var bend = mid + normal * sin(mid.x * 0.42 + mid.y * 0.19) * 2.6
				var edge = PackedVector2Array([a, bend, b])
				g.draw_polyline(edge, Color(0.1, 0.15, 0.15, 0.72), 5, true)
				if normal.y > 0.2:
					g.draw_polyline(PackedVector2Array([a - Vector2(0, 4), bend - Vector2(0, 5), b - Vector2(0, 4)]), Color(0.46, 0.51, 0.46, 0.62), 2, true)

static func fill(g, pts: PackedVector2Array, bounds: Rect2i, texture: Texture2D):
	var uv = PackedVector2Array(); var colors = PackedColorArray()
	for p in pts:
		uv.append((p / 40 - Vector2(bounds.position)) / Vector2(bounds.size))
		var shade = clampf(1.06 - p.distance_to(g.player) / 850, 0.52, 1)
		colors.append(Color(0.89 * shade, 0.975 * shade, 0.95 * shade, 1))
	g.draw_polygon(pts, colors, uv, texture)
