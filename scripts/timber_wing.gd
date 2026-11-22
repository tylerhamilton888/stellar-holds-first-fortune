class_name HoldTimberWing
extends RefCounted

const COST = {"wood":8, "stone":4}
const STARTER = preload("res://assets/timber_wing/starter.png")
const REPAIRED = preload("res://assets/timber_wing/repaired.png")
const THRESHOLD = Vector2(2300,1120)
const SIDES = {
 "west":{"offset":Vector2(-365,-258),"parts":[preload("res://assets/timber_wing/west-a.png"),preload("res://assets/timber_wing/west-b.png")],
 "slot":Vector2(2060,1140),"bay":Rect2(1945,1055,179,72),"posts":[Rect2(1957,1102,19,11),Rect2(2108,1102,17,11),Rect2(1964,1064,150,10)]},
 "east":{"offset":Vector2(-203,-261),"parts":[preload("res://assets/timber_wing/east-a.png"),preload("res://assets/timber_wing/east-b.png")],
 "slot":Vector2(2660,1120),"bay":Rect2(2530,1055,254,72),"posts":[Rect2(2535,1098,18,12),Rect2(2760,1098,19,12),Rect2(2540,1060,231,10)]}
}

static func seeded(g)->bool:
 return g.state.claim_id=="copper_ridge" and g.surface.area=="claim" and HoldFrontier103.family(g.state) and HoldFrontier103.data(g.state).home169.seeded

static func house(g)->Dictionary:
 return g.state.surface.get("homes",{}).get(g.state.claim_id,{}).get("building",{})

static func side(g)->String:
 return str(house(g).get("timber_wing",""))

static func matches_shell(g,group:Dictionary)->bool:
 if not seeded(g) or group.get("bounds")!=Rect2(2160,880,280,240) or group.cells.size()!=42:return false
 var data=house(g)
 # Legacy or edited rooms keep their tile renderer, including upper storeys.
 for lev in data.get("levels",{}).values():
  for tile in lev.values():
   if tile.get("wall","")!="" or tile.get("roof",false):return false
 for key in group.cells:
  var cell=g.surface.house.coords(key)
  var wall="wall" if cell.x in [54,60] or cell.y in [22,27] else ""
  if key=="57,27":wall="door"
  if key in ["54,24","60,24"]:wall="window"
  var tile=data.tiles[key]
  if tile.get("floor","")!="stone_floor" or not tile.get("roof",false) or tile.get("wall","")!=wall:return false
 return true

static func compatible(g)->bool:
 if not seeded(g) or g.surface.house.level()!=0:return false
 for group in g.surface.house.view.groups():
  if matches_shell(g,group):return true
 return false

static func draw(g,origin:Vector2,layout:String,scale_factor:float=1.0):
 var spec:Dictionary=SIDES[layout]
 var p:Vector2=origin+spec.offset*scale_factor
 for texture in spec.parts:
  var size:Vector2=texture.get_size()*scale_factor
  g.draw_texture_rect(texture,Rect2(p,size),false)
  p.x+=size.x
 var rail_pos=Vector2(-322,-102) if layout=="west" else Vector2(270,-109)
 g.draw_texture_rect(HoldClaimYard.RAIL,Rect2(origin+rail_pos*scale_factor,Vector2(116,51)*scale_factor),false)

static func outside(g)->bool:
 return compatible(g) and not g.surface.house.view.inside()

static func obstacles(g)->Array:
 if not seeded(g) or not SIDES.has(side(g)) or not outside(g):return []
 return SIDES[side(g)].posts

static func reason(g,layout:String)->String:
 if not SIDES.has(layout) or not outside(g):return "Use the original cottage from the grounds."
 if side(g)!="":return "This cottage already has a timber wing."
 var bay:Rect2=SIDES[layout].bay
 for solid in g.surface.obstacles():
  if bay.intersects(solid):return "Move anything occupying this side of the cottage."
 for tile_key in house(g).tiles:
  if bay.intersects(Rect2(Vector2(g.surface.house.coords(tile_key))*40,Vector2(40,40))):return "Existing construction occupies this side."
 for post in SIDES[layout].posts:
  if post.grow(10).has_point(g.player):return "Step away from the new posts."
 if not g.state.afford(COST):return "Requires 8 wood and 4 stone."
 return ""

static func install(g,layout:String)->bool:
 var message=reason(g,layout)
 if message!="":g.notify(message);return false
 if not g.state.pay(COST):return false
 house(g).timber_wing=layout
 g.save_game()
 g.refresh_panel()
 return true

static func dismantle(g)->bool:
 if not seeded(g) or not SIDES.has(side(g)) or g.surface.house.level()!=0 or g.surface.house.view.inside():return false
 house(g).timber_wing=""
 for item in COST:g.state.add(item,COST[item])
 g.save_game()
 g.refresh_panel()
 return true

class Elevation extends Control:
 var layout:String
 func _draw():
  var config:Dictionary=SIDES[layout]
  var width:float=config.parts[0].get_width()+config.parts[1].get_width()
  var scale_factor=minf((size.x-12)/width,(size.y-10)/config.parts[0].get_height())
  var start=Vector2((size.x-width*scale_factor)*.5,5)
  HoldTimberWing.draw(self,start-config.offset*scale_factor,layout,scale_factor)

static func menu(g):
 if not seeded(g) or g.surface.house.level()!=0 or g.surface.house.view.inside():return
 var current=side(g)
 if not compatible(g):
  if SIDES.has(current):g.small_button(g.panel_body,"Recover timber wing · 8 wood and 4 stone",func():dismantle(g))
  return
 g.label(g.panel_body,"Cottage timber wing",19)
 if current=="":
  g.label(g.panel_body,"Repairs the cottage exterior and adds a covered bay. Choose one end of the cottage. 8 wood and 4 stone. Equipment is separate.",14)
  var row=g.row(g.panel_body)
  for key in ["west","east"]:
   var col=VBoxContainer.new();col.size_flags_horizontal=Control.SIZE_EXPAND_FILL;row.add_child(col)
   var view=Elevation.new();view.layout=key;view.custom_minimum_size=Vector2(85,65);col.add_child(view)
   var message=reason(g,key)
   var button=g.small_button(col,"Build "+key+" wing",func():install(g,key))
   button.disabled=message!="";button.tooltip_text=message
 elif SIDES.has(current):
  g.label(g.panel_body,"The "+current+" wing is built. Stand near the bay to fit a sawbench, or choose your own position.",14)
  var slot:Vector2=SIDES[current].slot
  var option=g.small_button(g.panel_body,"Fit sawbench in bay · 5 wood and 2 stone",func():
   if g.handworks.build("saw",slot):g.close_panel())
  option.disabled=not g.handworks.placement_ready("saw",slot)
  g.small_button(g.panel_body,"Place sawbench freely · 5 wood and 2 stone",func():
   g.surface.cancel_placement();g.handworks.placing="saw";g.close_panel())
  var saw=g.handworks.facility()
  if saw.get("kind","")=="saw" and saw.get("owner","")!="hold" and saw.job.is_empty():
   g.small_button(g.panel_body,"Move nearby sawbench",func():
    g.surface.cancel_placement();g.handworks.placing="move_saw/"+str(saw.id);g.close_panel())
  g.small_button(g.panel_body,"Remove wing · return 8 wood and 4 stone",func():dismantle(g))
