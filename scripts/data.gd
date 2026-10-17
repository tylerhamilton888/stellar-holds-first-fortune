class_name HoldData
extends RefCounted

const ITEMS = {
 "energy_cell":{"name":"Runic energy cell","price":30,"color":"7fdccd"},
 "iron_slag":{"name":"Iron slag","price":4,"color":"a88870"},
 "copper_slag":{"name":"Copper slag","price":5,"color":"c88963"},
 "ammo":{"name":"Cartridges","price":2,"color":"c0a77b"},
 "scrap":{"name":"Recovered scrap","price":5,"color":"b49377"},
 "shell":{"name":"Iron-rich carapace","price":7,"color":"9cb1ad"},
 "stone": {"name":"Stone", "price":2, "color":"7c8b9c"},
 "iron_ore": {"name":"Iron ore", "price":5, "color":"c59473"},
 "copper_ore": {"name":"Copper ore", "price":6, "color":"e88d55"},
 "coal": {"name":"Coal", "price":4, "color":"62758c"},
 "wood": {"name":"Timber", "price":4, "color":"b48b58"},
 "water": {"name":"Water", "price":2, "color":"7fcddd"},
 "food": {"name":"Provisions", "price":8, "color":"d8b975"},
 "crystal": {"name":"Aether crystal", "price":26, "color":"7ee3d2"},
 "iron": {"name":"Iron ingot", "price":14, "color":"c5d5dc"},
 "copper": {"name":"Copper ingot", "price":16, "color":"eeb278"},
 "parts": {"name":"Machine parts", "price":36, "color":"e0bf83"},
 "assembly": {"name":"Drive assembly", "price":95, "color":"a6dfc7"}
}
const RECIPES = {
 "energy_cell":{"name":"Charge 3 runic cells","cost":{"crystal":1,"copper":1,"coal":2},"out":{"energy_cell":3},"time":6.0,"tech":"thermal"},
 "iron_slag":{"name":"Quench iron slag","cost":{"iron_slag":2,"water":1},"out":{"iron":1},"time":2.0,"tech":"thermal"},
 "copper_slag":{"name":"Quench copper slag","cost":{"copper_slag":2,"water":1},"out":{"copper":1},"time":2.0,"tech":"thermal"},
 "ammo":{"name":"Pack 12 cartridges","cost":{"iron":1,"coal":1},"out":{"ammo":12},"time":3.0,"tech":""},
 "scrap_iron":{"name":"Refine recovered scrap","cost":{"scrap":3,"coal":1},"out":{"iron":3,"copper":1},"time":4.0,"tech":""},
 "shell_iron":{"name":"Smelt carapace iron","cost":{"shell":2,"coal":1},"out":{"iron":3},"time":4.0,"tech":""},
 "iron": {"name":"Smelt iron", "cost":{"iron_ore":2,"coal":1},"out":{"iron":1},"time":3.0,"tech":""},
 "copper": {"name":"Smelt copper", "cost":{"copper_ore":2,"coal":1},"out":{"copper":1},"time":3.0,"tech":""},
 "parts": {"name":"Forge machine parts", "cost":{"iron":2,"copper":1},"out":{"parts":2},"time":4.0,"tech":"metallurgy"},
 "assembly": {"name":"Assemble drive", "cost":{"parts":3,"copper":2,"crystal":1},"out":{"assembly":1},"time":5.0,"tech":"automation"},
 "food": {"name":"Pack provisions", "cost":{"water":2,"wood":1},"out":{"food":2},"time":3.0,"tech":""}
}
const RESEARCH = {
 "thermal":{"name":"Runic thermal extraction","desc":"Powered workshops can fabricate a slagcaster. Craft energy cells and quench recovered metal slag.","cost":{"parts":5,"crystal":2},"money":85,"requires":"automation"},
 "voidcraft":{"name":"Pressure engineering","desc":"After your freight beacon and first keel, install sealed engineering bays: double production, efficient cells and reduced ship material costs.","cost":{"parts":6,"crystal":2,"copper":4},"money":95,"requires":"automation"},
 "extraction": {"name":"Tempered steel", "desc":"Unlock a steel pick. Break hard basalt.","cost":{"iron":4,"wood":3},"money":35,"requires":""},
 "metallurgy": {"name":"Precision forging", "desc":"Make machine parts; expand your hold.","cost":{"copper":3,"stone":12},"money":45,"requires":""},
 "automation": {"name":"Clockwork industry", "desc":"Build a miner, assemble starship drives, and commission powered workshops (+50% production).","cost":{"parts":4,"crystal":1},"money":65,"requires":"metallurgy"}
}
const SHIP = [
 {"name":"Lay the keel", "cost":{"stone":30,"wood":15,"iron":8},"money":75},
 {"name":"Rivet the hull", "cost":{"iron":12,"copper":6,"parts":6},"money":110},
 {"name":"Fit the aether drive", "cost":{"assembly":3,"crystal":3,"water":10},"money":150}
]
const TILES = {
 13:{"name":"Built timber","item":"wood","hp":2.0,"color":"94704c"},
 1:{"name":"Loose earth","item":"stone","hp":2.0,"color":"645247"},
 2:{"name":"Slate","item":"stone","hp":3.0,"color":"526174"},
 3:{"name":"Iron seam","item":"iron_ore","hp":3.5,"color":"677080"},
 4:{"name":"Copper seam","item":"copper_ore","hp":3.0,"color":"686570"},
 5:{"name":"Coal bed","item":"coal","hp":2.5,"color":"43505f"},
 6:{"name":"Aether geode","item":"crystal","hp":5.0,"color":"405f70"},
 7:{"name":"Basalt","item":"stone","hp":6.0,"color":"353f55"},
 9:{"name":"Edible root bed","item":"food","hp":1.5,"color":"6c8062"},
 10:{"name":"Sealed spring","item":"water","hp":2.0,"color":"518b9b"},
 12:{"name":"Flowing water","item":"water","hp":.6,"color":"4d91b1"},
 8:{"name":"Claim boundary","item":"stone","hp":9999.0,"color":"252b3a"}
}
static func cost_text(cost:Dictionary) -> String:
 var a:PackedStringArray=[]
 for k in cost: a.append("%s %s" % [cost[k],ITEMS[k].name])
 return "  /  ".join(a)
