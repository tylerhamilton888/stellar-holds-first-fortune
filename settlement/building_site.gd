extends RefCounted

const MARGIN = 10.0
# Dry land between the western escarpment, river, and eastern boundary.
const TOWN_BANKS = [Rect2(90,210,1065,750), Rect2(1315,210,475,750)]

static func foundation(building: Dictionary) -> Rect2:
 var body = HoldBuildingArt.footprint(building)
 var face: Rect2 = HoldBuildingArt.facade(building).destination
 # The wall and threshold bear on the ground. A roof may project above the back wall.
 var sill = Rect2(face.position.x, building.p.y - 12, face.size.x, 12)
 return body.merge(sill).grow(MARGIN)

static func covered(rect: Rect2, parcels: Array) -> bool:
 # These terrain parcels have disjoint interiors. A foundation may cross their shared seam.
 var area := 0.0
 for parcel in parcels:
  area += rect.intersection(parcel).get_area()
 return is_equal_approx(area, rect.get_area())

static func fits(building: Dictionary, parcels: Array) -> bool:
 var approach = Rect2(building.p - Vector2(13,0), Vector2(26,55))
 return covered(foundation(building), parcels) and covered(approach, parcels)

static func town(plan: String, door: Vector2) -> bool:
 return fits(HoldBuildingPlans.instance(plan, door), TOWN_BANKS)

static func level_claim_ground(g,rect:Rect2)->bool:
 if not covered(rect,g.surface.CLAIM_GROUNDS):return false
 var bank=preload("res://scripts/claim_cart_bank.gd")
 return not bank.active(g) or not rect.intersects(bank.AREA)
