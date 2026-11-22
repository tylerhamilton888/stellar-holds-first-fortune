extends RefCounted
const Layout = preload("res://scripts/site_layout.gd")
const BOUNDS = Rect2(100, 240, 1660, 700)
const DUFF = preload("res://assets/pinewood_layout/duff.webp")
const APRON = preload("res://assets/pinewood_layout/apron.webp")
const TREE_HALF = Vector2(21, 22)
const GATE = Vector2(100, 650)
const FIRST_TREE = Vector2(430, 430)
const LINKS = [["gate", "junction"], ["junction", "board_access"], ["junction", "tutorial"], ["junction", "yard"], ["junction", "fork"], ["fork", "west_grove"], ["fork", "east_grove"], ["fork", "spring_access"], ["junction", "freight_access"]]

static func grove(id: String, band: Rect2i, start: int) -> Dictionary:
	var parts = {}
	for i in 3: parts["tree" + str(start + i)] = [[Vector2(-109, -61), Vector2(12, -145), Vector2(120, -45)][i], TREE_HALF, Vector2i(12, 7)]
	return {"id": id, "band": band, "parcel": Rect2(-151, -182, 303, 202), "parts": parts}

static func generate(seed_value: int) -> Dictionary:
	var board: Vector2 = HoldRoads.ORDERS.pinewood.p
	var fixed = {"gate": GATE, "junction": Vector2(360, 650), "board_access": board + Vector2(0, -60), "tutorial": FIRST_TREE + Vector2(0, 65), "tree0": FIRST_TREE, "fork": Vector2(1060, 610)}
	var solids = [Rect2(FIRST_TREE - TREE_HALF, TREE_HALF * 2), Rect2(board - Vector2(42, 24), Vector2(84, 48)), Rect2(80, 574, 40, 30)]

	var reserved = []
	for person in HoldRoads.FOLK:
		if person.area == "pinewood" and person.name != "Torvik":
			reserved.append(Rect2(person.a, Vector2.ZERO).expand(person.b).grow(28))
	var yard = {"id": "yard", "band": Rect2i(500, 820, 560, 60), "parcel": Rect2(-161, -101, 322, 117), "parts": {
		"saw": [Vector2(-57, -61), Vector2(35, 16)], "timber_pile": [Vector2(64, -61), Vector2(34, 16)],
		"lamp": [Vector2(-137, -78), Vector2(12, 12)], "worktable": [Vector2(132, -52), Vector2(26, 14)]}}
	if posmod(seed_value, 2) == 1:
		yard.parts.timber_pile[0] = Vector2(76, -8)
		yard.parts.worktable[0] = Vector2(119, -78)
	var spring = Vector2(1140 + posmod(seed_value, 4) * 20, 339)
	fixed.spring = spring;fixed.freight = Vector2(250, 485)
	fixed.spring_access = spring + Vector2(0, 48);fixed.freight_access = fixed.freight + Vector2(0, 46)
	var banks = [Rect2(spring - Vector2(99, 32), Vector2(198, 33)), Rect2(162, 453, 176, 33)]
	reserved.append_array(banks);solids.append_array(banks)
	var sites = [yard, grove("west_grove", Rect2i(570, 480, 440, 200), 1), grove("east_grove", Rect2i(1310, 500, 300, 360), 4)]
	return Layout.compose(seed_value, BOUNDS, fixed, solids, reserved, sites, LINKS)

static func point(plan: Dictionary, id: String) -> Vector2:
	return Layout.xy(plan.marks[id])

static func paths(plan: Dictionary) -> Array:
	var paths_out = []
	for encoded in plan.paths:
		var path = PackedVector2Array()
		for p in encoded: path.append(Layout.xy(p))
		paths_out.append(path)
	return paths_out



static func road_texture(plan: Dictionary) -> Texture2D:
	const SCALE = 3
	const W = 627
	const H = 360
	var coverage = PackedFloat32Array();coverage.resize(W * H)
	var roads = paths(plan)
	roads[0].insert(0, Vector2(0, 650))
	var saw = point(plan, "saw"); var rack = point(plan, "timber_pile"); var yard = point(plan, "yard")
	roads.append(PackedVector2Array([saw + Vector2(0, 36), rack + Vector2(0, 36)]))
	roads.append(PackedVector2Array([yard, (saw + rack) * 0.5 + Vector2(0, 38)]))
	var widths = [35, 21, 17, 30, 32, 20, 20]
	if plan.marks.has("spring_access"): widths.append_array([17, 25])
	widths.append_array([29, 30])
	for i in roads.size():
		for j in roads[i].size() - 1:
			var a: Vector2 = roads[i][j]; var b: Vector2 = roads[i][j + 1]
			var radius: float = widths[i]
			var region = Rect2(a, Vector2.ZERO).expand(b).grow(radius + 8)
			var lo = Vector2i((region.position / SCALE).floor()).max(Vector2i.ZERO)
			var hi = Vector2i((region.end / SCALE).ceil()).min(Vector2i(W - 1, H - 1))
			for y in range(lo.y, hi.y + 1):
				for x in range(lo.x, hi.x + 1):
					var at = Vector2(x, y) * SCALE
					var d = at.distance_to(Geometry2D.get_closest_point_to_segment(at, a, b))
					coverage[y * W + x] = maxf(coverage[y * W + x], radius + 8 - d)
	var im = Image.create(W, H, false, Image.FORMAT_RGBA8)
	var noise = FastNoiseLite.new();noise.seed = int(plan.seed);noise.frequency = 0.034
	for y in H:
		for x in W:
			var depth = coverage[y * W + x]
			if depth <= 0: continue
			var n = noise.get_noise_2d(x * SCALE, y * SCALE); var grain = HoldTerrainView.grain(x, y)
			var color = Color("85704b").lerp(Color("c5a776"), clampf(0.48 + n * 0.42 + grain * 0.17, 0, 1))
			color.a = smoothstep(3, 20, depth + n * 8);im.set_pixel(x, y, color)
	return ImageTexture.create_from_image(im)

static func draw_ground(g, plan: Dictionary):
	var view = Rect2(g.surface.world.view_camera(), Vector2(960, 540)).grow(160)
	var yard = point(plan, "yard")
	if view.has_point(yard):
		g.draw_texture_rect(APRON, Rect2(yard - Vector2(177, 88), Vector2(354, 104)), false)
	for id in ["west_grove", "east_grove"]:
		var center = point(plan, id) - Vector2(0, 87)
		if view.has_point(center): g.draw_texture_rect(DUFF, Rect2(center - Vector2(156, 56), Vector2(312, 112)), false)
	for id in ["saw", "timber_pile", "worktable"]:
		var foot = point(plan, id)
		if view.has_point(foot):
			g.draw_texture_rect(HoldClaimYard.WEAR, Rect2(foot - Vector2(56, 18), Vector2(112, 38)), false, Color(0.62, 0.48, 0.29, 0.8))
	var saw = point(plan, "saw")
	if view.has_point(saw) and g.state.forestry.get("yard_cuts", 0) > 0:
		g.draw_texture_rect(HoldClaimYard.CURLS, Rect2(saw + Vector2(-28, 4), Vector2(49, 20)), false, Color(1, 1, 1, 0.88))
	for i in 7:
		var at = point(plan, "tree" + str(i))
		if not view.has_point(at): continue
		if g.state.road_trees[i] < 8:
			var chips = clampf((8 - g.state.road_trees[i]) * 0.15, 0.22, 1)
			g.draw_texture_rect(HoldClaimYard.CURLS, Rect2(at + Vector2(-32, -3), Vector2(67, 25)), false, Color(1, 1, 1, chips))
		for offset in [Vector2(-34, -7), Vector2(22, 9)]:
			var p = at + offset
			g.draw_texture_rect(HoldClaimYard.GRASS, Rect2(p - Vector2(16, 16), Vector2(32, 25)), false, Color(0.79, 0.87, 0.7, 0.92))
