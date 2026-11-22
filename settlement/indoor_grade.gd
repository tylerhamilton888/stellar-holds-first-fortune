extends RefCounted

const WIDTH=96.0
const HEAD=-92.0
const FOOT=20.0
const SEAM=-36.0
const HALF_LANE=24.0

static func rails(anchor:Vector2)->Array:
 return [Rect2(anchor+Vector2(-48,HEAD),Vector2(14,FOOT-HEAD)),Rect2(anchor+Vector2(34,HEAD),Vector2(14,FOOT-HEAD))]

static func destination(area:String,up:bool)->String:
 var z=HoldBuildingPlans.floor_number(area)+(1 if up else -1)
 if z<0:return ""
 if HoldBuildingPlans.owned_room(area):
  var id=HoldBuildingPlans.room_parts(area)[0]
  var b=HoldArchitecture.current().record(id)
  return HoldBuildingPlans.room_id(id,z) if z<b.rooms.size() else ""
 if z>1:return ""
 if HoldNeighborhood.is_home(area):
  var parts=HoldNeighborhood.parts(area)
  return HoldNeighborhood.home_id(parts[0],int(parts[1]),z)
 if area in ["room:tavern",HoldHouseholds.LOFT]:return HoldHouseholds.LOFT if up else "room:tavern"
 return ""

static func moved(s,before:Vector2)->bool:
 var g=s.g
 if not s.room() or before.y==g.player.y or not HoldBuildingPlans.has_stairs(s.area):return false
 var anchor=HoldBuildingPlans.stair_position(s.area)
 var local=g.player-anchor
 if absf(local.x)>HALF_LANE or local.y<HEAD-8 or local.y>FOOT+8:return false
 # Shorten the longitudinal stride while the dwarf is on the grade.
 var up=g.player.y<before.y
 var next_y=lerpf(before.y,g.player.y,.80 if up else .93)
 if not s.walkable(Vector2(g.player.x,next_y)):return false
 g.player.y=next_y
 var boundary=anchor.y+SEAM
 if not ((up and before.y>=boundary and next_y<boundary) or (not up and before.y<boundary and next_y>=boundary)):return false
 var target=destination(s.area,up)
 if target=="":return false
 if g.handworks.busy_hands():
  g.player.y=before.y;g.velocity=Vector2.ZERO;g.walking_pose=false
  if s.roads.portal_cooldown<=0:g.notify("Set down the load before using the ramp.");s.roads.portal_cooldown=.8
  return true
 var old_area=s.area
 var origin=g.player
 var shift=HoldBuildingPlans.stair_position(target)-anchor
 # Both floors belong to this building and share the active site and exterior return.
 # Probe using the destination's live furniture, chests and player-built walls.
 s.area=target
 var landing=origin+shift
 if not s.walkable(landing):
  s.area=old_area;g.player.y=before.y;g.velocity=Vector2.ZERO;g.walking_pose=false;return true
 s.area=old_area
 blend_rooms(g)
 s.remember()
 s.area=target;g.room_id=target.trim_prefix("room:")
 g.player=landing;g.camera+=shift
 s.world.speech="";s.placing="";s.moving_furnishing={};s.selected_chest=""
 HoldClaim127.enter(g,target)
 if target=="room:home" or (HoldFrontier103.active(g.state) and target==HoldFrontier103.quarters(g.state)):HoldFirstVisit99.room_entered(g)
 s.remember();g.spawn_agents();g.sound.set_context(HoldLivingForges148.sound_context(g))
 HoldStory183.arrive(g)
 # Like the quarry crossing, keep the gait and defer the disk write to normal autosave.
 g.autosave=maxf(g.autosave,42.)
 return true

static func draw(g,anchor:Vector2,lower:bool):
 var area=g.surface.area
 var box=Rect2(anchor+Vector2(-48,HEAD-6),Vector2(WIDTH,FOOT-HEAD+8))
 var floor_area=HoldRoomLayout.floor_rect(area)
 var left=box.position.x-floor_area.position.x
 var right=floor_area.end.x-box.end.x
 var gap=minf(left,right)
 if gap>=0 and gap<=38:
  # Use the room's own floor finish to carry the raised side landing into the wall.
  var apron_x=floor_area.position.x+5 if left<right else box.end.x-4
  var apron=Rect2(apron_x,box.position.y+5,maxf(4,gap),box.size.y-10)
  var style=HoldArchitectureStyles.room(area)
  g.draw_rect(Rect2(apron.position+Vector2(1,3),apron.size),Color("514536"))
  HoldArchitectureStyles.floor_draw(g,apron,style.floor,Color("d0b998"))
 var weight=0.0 if lower else 1.0
 var relative=g.player-anchor
 if absf(relative.x)<=HALF_LANE+1 and absf(relative.y-SEAM)<34:
  weight=1.-smoothstep(SEAM-34,SEAM+34,relative.y)
 preload("res://stair/flight.gd").draw(g,box,weight)

static func blend_rooms(g):
 if DisplayServer.get_name()=="headless":return
 var previous=g.get_node_or_null("IndoorLandingBlend")
 if previous:
  g.remove_child(previous);previous.queue_free()
 var viewport=g.get_viewport()
 var image=viewport.get_texture().get_image()
 if image==null or image.is_empty():return
 var layer=CanvasLayer.new();layer.name="IndoorLandingBlend";layer.layer=1
 var frame=TextureRect.new();frame.texture=ImageTexture.create_from_image(image)
 frame.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;frame.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var material=ShaderMaterial.new();material.shader=preload("res://settlement/landing_blend.gdshader")
 var size=g.get_viewport_rect().size
 material.set_shader_parameter("previous_room",1.)
 material.set_shader_parameter("feet",g.player-g.camera)
 material.set_shader_parameter("viewport_size",size);frame.material=material
 g.add_child(layer);layer.add_child(frame);frame.size=size
 var tween=layer.create_tween()
 tween.tween_method(func(value:float):material.set_shader_parameter("previous_room",value),1.,0.,.20)
 tween.tween_callback(layer.queue_free)

static func fit_public(state,buildings:Array):
 if not HoldFrontier103.active(state):return
 var town=HoldFrontier103.data(state)
 if town.get("ramp_layout",0)>=1 or not town.buildings.has("survey") or not town.buildings.has("lodge"):return
 town.ramp_layout=1
 for b in buildings:
  if not HoldFrontier103.public_building(b) or b.has("stair") or b.get("rooms",[]).size()!=2:continue
  var anchors=[]
  if b.plan=="frontier_office" and b.rooms[1]=="room:records_loft":anchors=[[244,495],[352,495]]
  if b.plan=="frontier_lodge":anchors=[[262,550],[226,550]]
  if anchors.is_empty():continue
  var fits=true
  for z in 2:
   var area=HoldBuildingPlans.room_id(str(b.id),z)
   var p=Vector2(anchors[z][0],anchors[z][1])
   var reserved=Rect2(p+Vector2(-49,HEAD-10),Vector2(98,FOOT-HEAD+24))
   for item in state.surface.decor+state.surface.chests.values():
    if item.area!=area or int(item.get("z",0))!=0:continue
    var base=HoldFurnishings.footprint(item.get("kind","chest"),Vector2(item.x,item.y))
    if reserved.intersects(base):fits=false
   var level=b.get("construction",{}).get(str(z),{})
   if not level.get("tiles",{}).is_empty() or not level.get("links",{}).is_empty():fits=false
  if fits:b.grade_anchors=anchors
