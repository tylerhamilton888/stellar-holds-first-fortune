extends RefCounted


const LIMESTONE = preload("res://assets/headworks/limestone.webp")
const RUNNEL = preload("res://assets/headworks/runnel.webp")
const SPRING = preload("res://assets/headworks/spring.webp")
const ARCH = preload("res://assets/headworks/span.webp")
const TURNING_WHEEL = preload("res://assets/headworks/turning_wheel.webp")
const WHEEL = preload("res://assets/headworks/wheel.webp")
const BANK = preload("res://assets/headworks/freight_bank.webp")
const MOUTH = preload("res://assets/headworks/cave_mouth.webp")
const LEDGE = preload("res://assets/headworks/ledge.webp")
const SHELF = preload("res://assets/headworks/shelf.webp")
const STAIR = preload("res://assets/headworks/stair.webp")
const WIDTHS = {"spring": 256, "arch": 460, "wheel": 154, "stair": 124, "bank": 212, "mouth": 126}
const TEXTURES = {"spring": SPRING, "arch": ARCH, "wheel": WHEEL, "stair": STAIR, "bank": BANK, "mouth": MOUTH}
const COST = {"wood": 3}
const JOURNAL = "Pinewood headworks"
const ENTRY = Vector2i(-7, 3)
const BRIDGE = Vector2i(-1, 0)
const MACHINE = Vector2i(4, 0)
const FREIGHT = Vector2i(6, -3)

static func create(seed_value: int) -> Dictionary:
	return {"origin": [38 + posmod(seed_value, 5), 52], "side": 1 if posmod(seed_value, 2) == 0 else -1, "measured": false, "shaft": false, "repaired": false}

static func origin(d: Dictionary) -> Vector2i: return Vector2i(int(d.origin[0]), int(d.origin[1]))
static func foot(d: Dictionary, offset: Vector2i) -> Vector2: return (Vector2(origin(d) + offset) + Vector2(0.5, 0.5)) * 40
static func saved(state) -> Dictionary:
	if not state.forestry.get("pinewood_plan", {}).get("marks", {}).has("spring"): return {}
	return state.forestry.get("headworks", {})
static func data(g) -> Dictionary: return saved(g.state)
static func in_mine(g) -> bool: return g.zone == "mine" and g.state.active_site == "hold" and g.deep.world != null and g.deep.world.depth() == 0 and not data(g).is_empty()
static func surface_point(g, id: String) -> Vector2:
	var p = g.state.forestry.pinewood_plan.marks[id]
	return Vector2(p[0], p[1])

static func chamber(d: Dictionary, c: Vector2i) -> bool:
	var p = c - origin(d)
	if p.x <= -5 and p.y >= -1 and p.y <= 1: return false
	var hall = Vector2((p.x + 0.5) / 8.3, (p.y - 0.15) / 3.6).length_squared() < 1.0
	var entry = (p.x >= -8 and p.x <= -5 and p.y >= 0 and p.y <= 4)
	var gallery = (p.x >= 2 and p.x <= 7 and p.y >= -3 and p.y <= 2)
	var pocket = Vector2((p.x + 2 * int(d.side)) / 2.3, (p.y + 3.3) / 2.7).length_squared() < 1
	return hall or entry or gallery or pocket

static func carve(world_data: Dictionary, d: Dictionary):
	if d.is_empty(): return
	var o = origin(d)
	for y in range(o.y - 7, o.y + 6):
		for x in range(o.x - 9, o.x + 9):
			if chamber(d, Vector2i(x, y)): world_data.layers[0].cells[y * 80 + x] = 0

static func obstacle(d: Dictionary, p: Vector2) -> bool:
	var bridge = foot(d, BRIDGE)
	if absf(p.y - bridge.y) < 19 and absf(absf(p.x - bridge.x) - 95) < 26: return true
	for offset in [MACHINE, ENTRY, FREIGHT]:
		var delta = p - foot(d, offset)
		if absf(delta.x) < (64 if offset == MACHINE else 39) and delta.y >= -34 and delta.y < 6: return true
	return false

static func objects(g) -> Array:
	var d = data(g); var out = []
	if d.is_empty(): return out
	if in_mine(g):
		out.append_array(ledges(g, d))
		for pair in [["mouth", ENTRY], ["arch", BRIDGE], ["wheel", MACHINE], ["stair", FREIGHT]]:
			var p = foot(d, pair[1])
			if g.deep.world.layer().seen.has(g.deep.world.key(g.deep.world.cell(p))): out.append({"kind": "headworks", "art": pair[0], "p": p})
	elif g.surface.active() and g.surface.area == "pinewood":
		out = [{"kind": "headworks", "art": "spring", "p": surface_point(g, "spring")}, {"kind": "headworks", "art": "bank", "p": surface_point(g, "freight")}]
	return out



static func ledges(g, d: Dictionary) -> Array:
	var out = []; var w = g.deep.world; var o = origin(d)
	if g.player.distance_to(foot(d, BRIDGE)) > 900: return out
	for y in range(o.y - 7, o.y + 3):
		var start = -1
		for x in range(o.x - 9, o.x + 10):
			var c = Vector2i(x, y); var face = x < o.x + 9 and w.at(c) != 0 and w.at(c + Vector2i.DOWN) == 0 and w.layer().seen.has(w.key(c + Vector2i.DOWN))
			if face:
				if start < 0: start = x
			elif start >= 0:
				var span = x - start
				if span >= 2:
					var wide = span * 40 + 10
					out.append({"kind": "headworks", "art": "ledge", "width": wide, "height": clampf(wide * 0.28, 26, 74), "high": span >= 3, "p": Vector2((start + x) * 20, (y + 1) * 40 + 2)})
				start = -1
	return out

static func sprite_rect(art: String, _underground: bool) -> Rect2:
	var tex: Texture2D = TEXTURES[art]; var w: float = WIDTHS[art]

	var h = w * tex.get_height() / tex.get_width()
	return Rect2( - w * (0.54 if art == "arch" else 0.5), - h + 5, w, h)

static func paint(g, obj: Dictionary):
	var p: Vector2 = obj.p; var art: String = obj.art; var underground = g.zone == "mine"
	if art == "ledge":
		var texture: Texture2D = LEDGE if obj.high else SHELF
		g.draw_texture_rect(texture, Rect2(p - Vector2(obj.width * 0.5, obj.height - 4), Vector2(obj.width, obj.height)), false, Color("becac4"))
		return
	var r = sprite_rect(art, underground);r.position += p
	if underground and art in ["arch", "wheel"]:
		var feet = [p - Vector2(95, 0), p + Vector2(95, 0)] if art == "arch" else [p]
		for base in feet:
			var shade = PackedVector2Array()
			for i in 20: shade.append(base + Vector2(cos(i * TAU / 20) * (25 if art == "arch" else 65), sin(i * TAU / 20) * 8))
			g.draw_colored_polygon(shade, Color(0.09, 0.11, 0.1, 0.28))
	var tint = Color("dadccc") if underground else Color.WHITE
	var repaired = bool(data(g).repaired)
	if art in ["stair", "bank"] and not repaired: tint = tint.darkened(0.22)
	if art == "wheel" and repaired:
		var frame = posmod(floori(g.clock * 5), 24)
		g.draw_texture_rect_region(TURNING_WHEEL, r, Rect2(frame % 6 * 231, frame / 6 * 164, 231, 164), tint)
	else: g.draw_texture_rect(TEXTURES[art], r, false, tint)
	if art == "arch" and repaired:
		var top = r.position + Vector2(r.size.x * 0.15, r.size.y * 0.145)
		g.draw_line(top, top + Vector2(r.size.x * 0.66, 0), Color(0.35, 0.65, 0.64, 0.72), 2, true)
		for i in 4:
			var at = top + Vector2(fposmod(g.clock * 13 + i * 72, r.size.x * 0.66), 0)
			g.draw_line(at, at + Vector2(4, 0), Color(0.71, 0.87, 0.81, 0.8), 1, true)
		var spout = r.position + r.size * Vector2(0.991, 0.29)
		var drop = PackedVector2Array([spout, spout + Vector2(2, 6), spout + Vector2(3, 14)])
		g.draw_polyline(drop, Color(0.46, 0.72, 0.7, 0.82), 3, true)
	if art in ["stair", "bank"] and not repaired:

		for i in 2:
			var start = p + Vector2(-39, -12 - i * 8)
			g.draw_line(start, start + Vector2(78, 0), Color("553c28"), 5, true)
			g.draw_line(start - Vector2(0, 2), start + Vector2(78, -2), Color("aa8251"), 1, true)
	if art == "wheel" and repaired:
		var axle = r.position + r.size * Vector2(0.6, 0.54)
		g.draw_circle(axle, 6, Color("845320"));g.draw_arc(axle, 6.8, 0, TAU, 24, Color("e3b86d"), 1.5, true)
		var crank = Vector2.from_angle(g.clock * 1.2) * 4.6
		g.draw_line(axle - crank, axle + crank, Color("e8cc91"), 2, true)

static func watercourse(g):
	if data(g).is_empty(): return
	var spring = surface_point(g, "spring")
	var bounds = Rect2(spring + Vector2(-43, -7), Vector2(106, 179))
	g.draw_texture_rect(RUNNEL, bounds, false, Color("eee9d1"))
	if not data(g).repaired: return
	var stream = PackedVector2Array()
	for sample in [Vector2(0.44, 0.03), Vector2(0.54, 0.12), Vector2(0.74, 0.25), Vector2(0.72, 0.38), Vector2(0.5, 0.5), Vector2(0.32, 0.62), Vector2(0.32, 0.75), Vector2(0.44, 0.87), Vector2(0.42, 0.94)]:
		stream.append(bounds.position + bounds.size * sample)
	g.draw_polyline(stream, Color(0.28, 0.48, 0.45, 0.76), 4, true)
	for i in range(1, stream.size() - 1):
		var at = stream[i].lerp(stream[i + 1], fmod(g.clock * 0.5 + i * 0.21, 1))
		g.draw_line(at, at + Vector2(2, 1), Color(0.73, 0.87, 0.77, 0.74), 1.4, true)

static func target(g) -> String:
	var d = data(g)
	if d.is_empty(): return ""
	if in_mine(g):
		for pair in [["out", ENTRY], ["wheel", MACHINE], ["up", FREIGHT]]:
			if g.player.distance_to(foot(d, pair[1]) + Vector2(0, 21)) < 43: return pair[0]
	elif g.surface.active() and g.surface.area == "pinewood":
		for id in ["spring", "freight"]:
			if g.player.distance_to(surface_point(g, id) + Vector2(0, 23)) < 45: return id
	return ""

static func hint(g, id: String) -> String:
	var d = data(g)
	match id:
		"spring": return "E  Enter the dry spring" if not d.repaired else "E  Enter the spring passage"
		"out": return "E  Return to Pinewood"
		"wheel":
			if d.repaired: return "E  Inspect the working lift"
			if d.shaft: return "E  Fit the replacement shaft"
			if d.measured: return "E  Check the shaft measurements"
			return "E  Examine the wheel bearing"
		"freight", "up": return "E  Use the freight stair" if d.repaired else "E  Inspect the closed freight stair"
	return ""

static func act(g, id: String) -> bool:
	if id == "" or id != target(g): return false
	var d = data(g)
	if id == "wheel":
		if d.repaired: g.notify("The oak shaft runs true. The freight stair is open to Pinewood.")
		elif d.shaft:
			d.shaft = false;d.repaired = true;g.sound.effect("build");g.notify("Shaft fitted. Water runs through the trough and the freight gate lifts.")
		elif not d.measured:
			d.measured = true;g.deep.world.data.discoveries.append(JOURNAL)
			g.notify("The oak shaft is missing. Measurements recorded. Shape a replacement at your homestead for 3 timber.")
		else: g.notify("The bearing takes a fitted oak shaft. Open Homestead at home to shape one for 3 timber.")
		g.save_game();return true
	if id in ["up", "freight"] and not d.repaired:
		g.notify("The freight gate is down. Its chain runs back to the wheelhouse.");return true
	if g.zone == "mine" and g.deep.haul.cart().get("hitched", false):
		g.notify("Park the mine wheelbarrow with C. A handcart can cross the open freight stair.");return true
	var cart = g.handworks.attached()
	if id in ["spring", "out"] and not cart.is_empty():
		g.notify("The spring passage is too narrow. Park the cart with C.");return true
	if id in ["spring", "freight"]:
		g.surface.remember()
		g.change_zone("mine", foot(d, ENTRY if id == "spring" else FREIGHT) + Vector2(0, 37))
	else: g.surface.enter("pinewood", surface_point(g, "spring" if id == "out" else "freight") + Vector2(0, 38))
	g.notify("Pinewood headworks" if g.zone == "mine" else "Pinewood");g.save_game()
	return true

static func journal(g) -> String:
	var d = data(g)
	if not d.get("measured", false): return ""
	if d.repaired: return "Pinewood headworks · Freight stair open. Take a handcart between Pinewood and the wheelhouse."
	if d.shaft: return "Pinewood headworks · Bring your fitted oak shaft back to the wheel bearing."
	return "Pinewood headworks · At your homestead, open Homestead [O] and shape the measured shaft for 3 timber."

static func craft(g) -> bool:
	var d = data(g)
	if g.zone != "claim" or not g.surface.active() or g.state.claim_id == "" or not d.get("measured", false) or d.shaft or d.repaired: return false
	if not g.state.pay(COST): g.notify("The shaft needs 3 timber from your pack.");return false
	d.shaft = true;g.sound.effect("wood");g.notify("Oak shaft shaped. Take it to the wheelhouse.");g.save_game();return true

static func bench(g):
	var d = data(g)
	if g.zone != "claim" or g.state.claim_id == "" or not d.get("measured", false) or d.repaired: return
	if d.shaft: g.label(g.panel_body, "Fitted oak shaft ready for the Pinewood wheelhouse.", 16);return
	g.button(g.panel_body, "Shape an oak shaft · 3 timber", func(): craft(g);g.open_panel("homestead", false))
