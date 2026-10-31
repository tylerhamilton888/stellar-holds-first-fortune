class_name HoldBuildingArt
extends RefCounted
# Shared architectural components. Original painted silhouettes are preserved;
# extra floors insert a repeated wall course instead of stretching the artwork.
static func descriptor(b:Dictionary)->Dictionary:
 var id=str(b.get("plan",""));var p=HoldBuildingPlans.plan(id)
 if p.is_empty() and not b.has("ward"):
  p=HoldBuildingPlans.plan(HoldBuildingPlans.identify(b,"hearthward" if b.has("id") or b.has("home") else "claim"))
 if p.is_empty():return b
 var d=p.duplicate(true);d.p=b.p
 for key in ["extend_x","extend_y","extra_storeys","owner_id"]:d[key]=b.get(key,0 if key!="owner_id" else "")
 d.style87=HoldArchitectureStyles.resolve(b)
 return d
static func original_footprint(b:Dictionary)->Rect2:
 var d=descriptor(b)
 if d.get("ward",false):
  var visual=HoldWorldZones.building_rect(d)
  var body=Rect2(visual.position+Vector2(8,12),Vector2(visual.size.x-16,d.p.y-18-visual.position.y-12))
  return body.merge(Rect2(d.p-Vector2(310,230),Vector2(620,212))) if d.get("id",-1)==15 else body
 if d.get("key","")=="cottage":return Rect2(d.p+Vector2(-154,-175),Vector2(308,155))
 if d.get("key","")=="workshop":return Rect2(d.p+Vector2(-115,-130),Vector2(230,110))
 var source=HoldWorldZones.BUILD_RECTS[d.art];var anchor=HoldWorldZones.BUILD_ANCHORS[d.art];var scale=d.width/source.size.x
 var top=d.p-(anchor-source.position)*scale
 return Rect2(top+Vector2(10,20),Vector2(d.width-20,d.p.y-18-top.y-20))
static func footprint(b:Dictionary)->Rect2:
 var r=original_footprint(b);var extra=Vector2(float(b.get("extend_x",0))*40,float(b.get("extend_y",0))*40)
 return Rect2(r.position-Vector2(0,extra.y),r.size+extra)
static func facade(b:Dictionary)->Dictionary:
 var d=descriptor(b)
 if d.get("ward",false):
  var art=HoldKeldrathArt.source(d);return {"texture":art.texture,"source":art.rect,"destination":HoldKeldrathArt.rect(d)}
 var source=HoldWorldZones.BUILD_RECTS[d.art];var anchor=HoldWorldZones.BUILD_ANCHORS[d.art];var scale=d.width/source.size.x
 return {"texture":HoldWorldZones.BUILDINGS,"source":source,"destination":Rect2(d.p-(anchor-source.position)*scale,source.size*scale)}
static func visual_bounds(b:Dictionary)->Rect2:
 var d=descriptor(b);var art=facade(d);var r=footprint(b).merge(art.destination)
 var extra=int(d.get("extra_storeys",0))
 if extra>0:r=r.merge(Rect2(art.destination.position-Vector2(0,extra*58+35),Vector2(art.destination.size.x,extra*58+100)))
 return r.grow(14)
static func elevation(g,b:Dictionary,alpha:float=1.0):
 var d=descriptor(b);var art=facade(d);var original=original_footprint(d);var r=footprint(b)
 var style=HoldArchitectureStyles.resolve(d);var tint=Color(1,1,1,alpha)
 var extra=int(d.get("extra_storeys",0))
 # Annexes have real wall heights, continuous roofs and repeated full-size bays.
 # The last wall tile is cropped rather than squeezing a whole forge into 40px.
 if int(d.get("extend_y",0))>0:
  var rear=Rect2(r.position-Vector2(0,10),Vector2(r.size.x,original.position.y-r.position.y+80))
  HoldArchitectureStyles.roof(g,rear,style,tint)
 if int(d.get("extend_x",0))>0:
  var wing=Rect2(original.end.x-30,r.position.y, r.end.x-original.end.x+30,r.size.y)
  g.draw_rect(Rect2(wing.position+Vector2(5,6),wing.size),Color(0,0,0,.22*alpha))
  var wall=Rect2(wing.position.x,wing.end.y-86,wing.size.x,86)
  HoldArchitectureStyles.wall(g,wall,style,true,tint)
  HoldArchitectureStyles.post(g,Vector2(wing.end.x-9,wing.end.y),88,style.trim,tint)
  var roof=Rect2(wing.position-Vector2(7,12),Vector2(wing.size.x+14,maxf(40,wing.size.y-74)))
  HoldArchitectureStyles.roof(g,roof,style,tint)
 # New storeys form a coherent set-back tower. The complete original roof and
 # frontage stay intact in front of it; no arbitrary horizontal image slicing.
 if extra>0:
  var width=clampf(art.destination.size.x*.68,140,290)
  var base=art.destination.position.y+72
  var tower=Rect2(d.p.x-width*.5,base-extra*58,width,extra*58)
  HoldArchitectureStyles.wall(g,tower,style,false,tint)
  for z in extra:
   var course=Rect2(tower.position+Vector2(0,z*58),Vector2(width,58))
   HoldArchitectureStyles.wall(g,course,style,true,tint)
   g.draw_line(course.position+Vector2(0,course.size.y),course.end,HoldArchitectureStyles.FAMILIES[style.wall].accent*tint,3)
  for z in extra:
   for x in [tower.position.x+6,tower.end.x-6]:HoldArchitectureStyles.post(g,Vector2(x,tower.position.y+(z+1)*58),58,style.trim,tint)
  HoldArchitectureStyles.roof(g,Rect2(tower.position-Vector2(8,35),Vector2(width+16,35)),style,tint)
 g.draw_texture_rect_region(art.texture,art.destination,art.source,tint)
static func draw(w,b:Dictionary,alpha:float=1.0):
 var d=descriptor(b);var art=facade(d)
 if not visual_bounds(b).intersects(Rect2(w.view_camera(),Vector2(960,540))):return
 if d.get("ward",false):
  HoldMasonryArt.building_volume(w,d)
  if d.id==15:HoldMasonryArt.wing(w.g,Rect2(d.p-Vector2(310,230),Vector2(620,230)))
 if not d.get("ward",false) and alpha==1.0 and art.destination.has_point(w.g.player) and w.g.player.y<d.p.y-25:alpha=.35
 elevation(w.g,d,alpha)
 if d.get("ward",false):HoldWardDesign.frontage(w,d)
static func room_floor(w,area:String):
 var plan=HoldBuildingPlans.geometry(area);var source=plan.template;var g=w.g
 if source=="room:throne":HoldRoyalStage.floor_draw(w,area);return
 HoldArchitectureStyles.room_shell(w,area)
 if area==HoldWorkerLodge100.ROOM:HoldWorkerLodge100.draw_private_door(w)
 if area=="room:home" and not HoldFirstVisit99.lodge_intro(g.state):HoldWorkerLodge100.draw_private_door(w,560)
 var floor_area=plan.floor
 var room="home" if source.begins_with("home:") else source.trim_prefix("room:")
 HoldRoomLayout.dressing(w,source);HoldHouseholds.dressing(w,source)
 if HoldBuildingPlans.has_stairs(area):
  var p=HoldBuildingPlans.stair_position(area);var up=HoldBuildingPlans.floor_number(area)==0
  HoldNeighborhood.draw_stairs(w,p,up,96)
  if not up:g.draw_style_box(w.stone_style(Color("9ca18c")),Rect2(160,floor_area.end.y-30,floor_area.size.x,30))
 HoldCivicArt.exit_floor(g,area)
 if room=="training":
  w.s.house.material(0,Rect2(305,345,330,185));g.draw_rect(Rect2(315,355,310,165),Color("bda673"),false,3)
 if area.begins_with("home:") and not HoldBuildingPlans.owned_room(area) and int(g.state.surface.homes.get(g.state.claim_id,{}).get("level",0))>0:
  g.draw_style_box(w.stone_style(Color("3f777a")),Rect2(365,420,230,115));g.draw_rect(Rect2(373,428,214,99),Color("c9ac6e"),false,3)
  for x in range(390,580,35):g.draw_polyline(PackedVector2Array([Vector2(x,439),Vector2(x+9,448),Vector2(x,457),Vector2(x-9,448),Vector2(x,439)]),Color("cab785"),2)
static func wall_piece(g,c:Vector2i,tiles:Dictionary):
 var t=tiles.get(str(c.x)+","+str(c.y),{});var kind=t.get("wall","")
 if kind=="":return
 var p=Vector2(c)*40+Vector2(20,20);var rect=Rect2(p-Vector2(20,46),Vector2(40,64))
 g.draw_rect(Rect2(rect.position+Vector2(4,5),rect.size),Color(0,0,0,.22))
 var style=HoldArchitectureStyles.room(g.surface.area)
 HoldArchitectureStyles.wall(g,rect,style,false)
 g.draw_rect(Rect2(rect.position-Vector2(0,3),Vector2(40,7)),Color("a49d83"))
 if kind=="wall":return
 if kind=="window":
  g.draw_texture_rect_region(HoldArchitectureStyles.ATLAS,Rect2(rect.position+Vector2(0,10),Vector2(40,40)),HoldArchitectureStyles.WINDOWS[HoldArchitectureStyles.index(style.wall)]);return
 if kind=="door" and not t.get("open",false):
  var unit=HoldHearthcraft.MATERIALS.get_size()/Vector2(3,2)
  g.draw_texture_rect_region(HoldHearthcraft.MATERIALS,rect,Rect2(Vector2(2,1)*unit,unit));return
 var door=kind=="door";var hole=Rect2(p+Vector2(-14,-37),Vector2(28,51 if door else 26))
 g.draw_rect(hole.grow(3),Color("b69a65"));g.draw_rect(hole,Color("223b40"))
 if door:
  if t.get("open",false):g.draw_rect(Rect2(p+Vector2(11,-36),Vector2(6,49)),Color("976b3c"))
  else:
   g.draw_rect(hole,Color("805937"))
   for x in [-8,0,8]:g.draw_line(p+Vector2(x,-35),p+Vector2(x,13),Color("523e2d"),1)
   for y in [-28,5]:g.draw_line(p+Vector2(-14,y),p+Vector2(14,y),Color("343d3a"),3)
   g.draw_circle(p+Vector2(8,-9),2,Color("e0be70"))
 else:
  g.draw_rect(hole.grow(-2),Color("d5b66f"));g.draw_line(p+Vector2(0,-37),p+Vector2(0,-11),Color("6a5838"),3)
static func wall_panel(g,r:Rect2,tint:Color=Color.WHITE):
 var source=HoldMasonryArt.WALL;var scale=r.size.y/source.size.y;var unit=source.size.x*scale
 var x=r.position.x
 while x<r.end.x:
  var width=minf(unit,r.end.x-x);var crop=source
  crop.size.x=width/scale
  g.draw_texture_rect_region(HoldMasonryArt.ATLAS,Rect2(x,r.position.y,width,r.size.y),crop,tint)
  x+=width
