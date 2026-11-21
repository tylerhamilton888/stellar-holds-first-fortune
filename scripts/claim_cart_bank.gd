extends RefCounted


const Contour = preload("res://scripts/meadow_contour.gd")
const X = Contour.FIRST
const Y = Contour.Y
const WIDTH = Contour.STRIP
const COUNT = 15
const AREA = Rect2(X, Y - 40, WIDTH * COUNT, 80)
const SPOIL = preload("res://assets/cart_bank/spoil.webp")
const NORTH = preload("res://assets/cart_bank/north.webp")
const SOUTH = preload("res://assets/cart_bank/south.webp")
const EAST = preload("res://assets/cart_bank/east.webp")
const TREE = Vector2(2080, 1415)
const ALDER = preload("res://assets/cart_bank/alder.webp")
const STUMP = preload("res://assets/cart_bank/stump.webp")
const JOBS = {"grade": "Cut the bank", "dress": "Lay wheel stones", "fill": "Return loose spoil"}

static func fresh() -> Dictionary:
	var depth = [];depth.resize(COUNT);depth.fill(0)
	return {"depth": depth, "stone": {}, "spoil": 0, "alder": 3}

static func home(g) -> bool:
	return g.zone == "claim" and HoldTimberWing.seeded(g) and g.surface.house.level() == 0 and not g.surface.house.view.inside()
static func data(g) -> Dictionary: return g.state.forestry.get("cart_bank", {})
static func active(g) -> bool: return home(g) and not data(g).is_empty()
static func col(x: float) -> int: return floori((x - X) / WIDTH)
static func center(i: int) -> Vector2:
	var x = X + (i + 0.5) * WIDTH
	return Vector2(x, Contour.line_y(x))
static func stage(d: Dictionary, i: int) -> int: return int(d.depth[i]) if i >= 0 and i < COUNT else 3

static func can_survey(g) -> bool:
	if not home(g) or not data(g).is_empty(): return false
	var land = AREA.grow(12).expand(TREE + Vector2(0, 18))
	for r in g.surface.obstacles():
		if land.intersects(r): return false
	for k in g.surface.house.tiles():
		if land.intersects(Rect2(Vector2(g.surface.house.coords(k)) * 40, Vector2(40, 40))): return false
	for b in g.fieldwork.data().beds:
		if g.fieldwork.local(b) and land.grow(32).has_point(g.fieldwork.pos(b)): return false
	for k in HoldClaimYard.data(g).paths:
		if land.grow(20).has_point(HoldClaimYard.location(k)): return false
	return not land.grow(38).has_point(g.player)

static func menu(g):
	if not home(g): return
	if data(g).is_empty():
		if can_survey(g): g.button(g.panel_body, "Survey the south meadow for a cart bank", func():
			if can_survey(g): g.state.forestry.cart_bank = fresh();g.save_game();g.open_panel("homestead", false))
		return
	for job in JOBS:
		var title: String = JOBS[job]
		if job == "dress": title += " · 1 stone per strip"
		g.small_button(g.panel_body, title, func(): g.surface.cancel_placement();g.close_panel();g.surface.placing = "bank:" + job;g.notify(title + " · Click the bank south of the porch. Right click to finish."))

static func target(p: Vector2) -> int:
	return col(p.x) if p.x >= X and p.x < AREA.end.x and absf(p.y - Contour.line_y(p.x)) <= 40 else -1

static func blocked(d: Dictionary, p: Vector2, needed: int, half: float) -> bool:
	if d.is_empty() or absf(p.y - Y) > 20 + half * 0.25: return false
	for i in range(maxi(0, col(p.x - half)), mini(COUNT - 1, col(p.x + half)) + 1):
		var lip = center(i).y
		if stage(d, i) < needed and absf(p.y - lip) <= 20 + half * 0.25 - absf(lip - Y): return true
	return false

static func obstacles(g) -> Array:
	var out = []
	if not active(g): return out
	var d = data(g)
	if int(d.get("alder", 3)) > 0: out.append(Rect2(TREE - Vector2(12, 8), Vector2(24, 16)))
	for i in COUNT:
		if stage(d, i) < 2:
			var lip = center(i).y

			var half_height = 17 - absf(lip - Y)
			out.append(Rect2(X + i * WIDTH, lip - half_height, WIDTH, half_height * 2))
	return out

static func clear_for_fill(g, i: int) -> bool:
	var r = Rect2(center(i) - Vector2(WIDTH / 2, 23), Vector2(WIDTH, 46)).grow(9)
	if r.has_point(g.player): return false
	for box in g.surface.obstacles():
		if box.intersects(r) and not obstacles(g).has(box): return false
	for b in g.fieldwork.data().beds:
		if g.fieldwork.local(b) and r.grow(26).has_point(g.fieldwork.pos(b)): return false
	for k in g.surface.house.tiles():
		if r.intersects(Rect2(Vector2(g.surface.house.coords(k)) * 40, Vector2(40, 40))): return false
	return true

static func reason(g, i: int, job: String) -> String:
	if job == "alder":
		if not active(g) or int(data(g).get("alder", 3)) <= 0 or g.player.distance_to(TREE) > 90: return "Stand within axe reach of the alder."
		if not g.handworks.attached().is_empty() or not g.handworks.data().carry.is_empty(): return "Park the cart and free your hands first."
		return ""
	if not active(g) or i < 0 or i >= COUNT or not JOBS.has(job): return "Choose a strip on the south meadow bank."
	if g.surface.house.view.inside() or g.player.distance_to(center(i)) > 104: return "Step within shovel reach of the bank."
	if not g.handworks.attached().is_empty() or not g.handworks.data().carry.is_empty(): return "Park the cart and free your hands first."
	var d = data(g); var depth = stage(d, i)
	if job == "grade" and depth == 3: return "This strip is graded. Cut the adjoining shoulder to widen it."
	if job == "dress":
		if depth < 3: return "Grade this strip before setting wheel stones."
		if d.stone.has(str(i)): return "This strip already has wheel stones."
		if not g.state.afford({"stone": 1}): return "Wheel stones require 1 stone per strip."
	if job == "fill":
		if depth == 0: return "This is intact turf."
		if int(d.spoil) == 0 or not clear_for_fill(g, i): return "Clear the cut before returning spoil."
	return ""

static func apply(g, i: int, job: String) -> bool:
	if reason(g, i, job) != "": return false
	var d = data(g)
	match job:
		"alder":
			d.alder = int(d.get("alder", 3)) - 1;g.sound.effect("wood")
			if d.alder == 0:
				for offset in [Vector2(31, 8), Vector2(51, 1), Vector2(34, -11)]: g.handworks.spawn("log", TREE + offset, 2, "meadow_alder")
		"grade":
			d.depth[i] = stage(d, i) + 1;d.spoil = int(d.spoil) + 1
			g.sound.effect("break_earth" if stage(d, i) == 1 else "earth")
		"dress":
			if not g.state.pay({"stone": 1}): return false
			d.stone[str(i)] = true;g.sound.effect("stone")
		"fill":
			if d.stone.erase(str(i)): g.state.add("stone", 1)
			d.depth[i] = stage(d, i) - 1;d.spoil = int(d.spoil) - 1;g.sound.effect("earth")
	g.save_game();return true

static func elevation(d: Dictionary, p: Vector2) -> float:
	var lip = Contour.line_y(p.x)
	if d.is_empty() or p.y < lip - 130 or p.y > lip + 25: return 0.0
	var flank = smoothstep(X - 26, X + 14, p.x) * (1 - smoothstep(AREA.end.x - 14, AREA.end.x + 26, p.x))
	var progress = 1 - smoothstep(lip - 34, lip + 21, p.y)
	if stage(d, col(p.x)) < 2: progress = 1 - smoothstep(lip - 19, lip - 10, p.y)
	return 13 * flank * smoothstep(lip - 130, lip - 46, p.y) * progress

static func heading(f: Dictionary) -> Vector2:
	var h = f.get("bank_facing", [0, -1])
	return Vector2(h[0], h[1]).normalized()
static func pair(v: Vector2) -> Array: return [v.x, v.y]
static func steer(old: Vector2, axis: Vector2, travel: float) -> Vector2:
	if axis == Vector2.ZERO: return old
	return old.rotated(clampf(old.angle_to(axis), - travel / 24, travel / 24)).normalized()

static func wheels(p: Vector2, dir: Vector2, wagon: bool) -> Array:
	var axle = p + dir * (46 if wagon else 38)
	var offsets = []
	for side in [-1, 1]:
		for end in [-1, 1]: offsets.append(axle + dir * end * (20 if wagon else 15) + dir.orthogonal() * side * (27 if wagon else 20))
	return offsets

static func parked_footprint(cart: Dictionary) -> Rect2:
	var dir = heading(cart)
	var axle = Vector2(cart.x, cart.y) + dir * 5
	var half = Vector2(19 + absf(dir.x) * 3, 9 + absf(dir.y) * 8)
	return Rect2(axle - half, half * 2)

static func hitch_clear(g, cart: Dictionary, dir: Vector2) -> bool:
	var axle = Vector2(cart.x, cart.y)
	var start = axle - dir * 38
	var count = maxi(1, ceili(start.distance_to(g.player) / 5))
	for i in range(1, count + 1):
		if not can_roll(g, start.lerp(g.player, float(i) / count), dir, cart): return false
	return true

static func can_roll(g, p: Vector2, dir: Vector2, cart: Dictionary) -> bool:
	var d = data(g)
	for w in wheels(p, dir, cart.kind == "wagon"):
		if blocked(d, w, 3, 4): return false
	return true

static func cart_art(g, f: Dictionary, p: Vector2):
	var dir = heading(f); var hitch = bool(f.hitched)
	var pos = p + dir * 38 if hitch else p
	var ws = wheels(pos - dir * 38, dir, false); var front = (elevation(data(g), ws[1]) + elevation(data(g), ws[3])) * 0.5
	var back = (elevation(data(g), ws[0]) + elevation(data(g), ws[2])) * 0.5
	var texture = NORTH if dir.y < - 0.52 else SOUTH if dir.y > 0.52 else EAST
	var size = Vector2(49, 66) if texture != EAST else Vector2(82, 47)
	var location = pos - Vector2(0, (front + back) * 0.5 + 9)
	var slope = (front - back) / 32.0
	var cam = g.camera.round()
	g.draw_set_transform(pos - cam, 0, Vector2(1, 0.32));g.draw_circle(Vector2.ZERO, 24, Color(0, 0, 0, 0.23))
	g.draw_set_transform(location - cam, clampf( - dir.x * slope * 0.22, - 0.12, 0.12), Vector2(-1 if texture == EAST and dir.x < 0 else 1, 1 - clampf(dir.y * slope * 0.24, - 0.1, 0.1)))
	var rect = Rect2( - size * 0.5, size);g.draw_texture_rect(texture, rect, false)
	var side_view = texture == EAST
	for j in mini(f.raw.size(), 16):
		var row = j % 4; var tier = j / 4
		var local = Vector2(7 + (row % 2) * 2, -5 + row * 2.4 - tier * 3) if side_view else Vector2(0, -12 + row * 5 - tier * 3 + (9 if texture == SOUTH else 0))
		if f.raw[j].kind != "log": g.handworks.raw_sprite(f.raw[j], local, 18)
		elif side_view: g.handworks.timber_log(local, 34)
		else:

			var seat = Vector2((j % 3 - 1) * 8, 6 if texture == SOUTH else 1) - Vector2(0, (j / 3) * 5)
			g.draw_texture_rect(HoldHandworks.RACKED_LOG, Rect2(seat - Vector2(4, 19), Vector2(12, 19)), false)
	if not f.cargo.is_empty(): g.deep.cargo_art(f.cargo, Vector2(2, -7))
	g.draw_set_transform( - cam)

static func ground(g):
	if not active(g) or not Rect2(g.camera - Vector2(110, 90), Vector2(1180, 720)).intersects(AREA): return
	Contour.earth(g, data(g))

static func bank_face(g):
	Contour.face(g, data(g))

static func chips(g, strip: int, job: String, time_left: float):
	if time_left <= 0 or time_left > 0.27 or job == "alder": return
	var progress = 1 - time_left / 0.27
	var target_point = center(strip)
	var hit = target_point + (g.player - target_point).normalized() * 16
	for n in 5:
		var angle = -2.7 + n * 0.48
		var offset = Vector2(cos(angle) * progress * 23, sin(angle) * progress * 34 + progress * progress * 30)
		g.draw_texture_rect(SPOIL, Rect2(hit + offset, Vector2(5 + n % 3, 3 + n % 2)), false, Color(1, 1, 1, 1 - progress))

static func draw_alder(g, fall: float, swing: float):
	var alive = int(data(g).get("alder", 3)) > 0
	if not alive: HoldClaimYard.sprite(g, STUMP, TREE, 48)
	if not alive and fall <= 0: return
	var t = 1 - clampf(fall / 0.82, 0, 1)
	var angle = 1.22 * t * t if not alive else sin(swing * 43) * 0.025 if swing > 0 and swing < 0.27 else 0.0
	g.draw_set_transform(TREE - g.camera.round(), angle, Vector2.ONE)
	var alpha = 1.0 if alive else 1 - smoothstep(0.64, 1, t)
	HoldClaimYard.sprite(g, ALDER, Vector2.ZERO, 144, Color(1, 1, 1, alpha))
	g.draw_set_transform( - g.camera.round())

static func extra_objects(g) -> Array:
	if not active(g): return []
	var result = [{"kind": "bank_face", "p": Vector2(X + WIDTH * COUNT / 2, Y - 8)}]
	result.append({"kind": "bank_alder", "p": TREE})
	var cart = g.handworks.attached()
	if cart.get("kind", "") == "cart":
		result.append({"kind": "rolling_cart", "p": g.player + heading(cart) * 38, "facility": cart})
	return result
