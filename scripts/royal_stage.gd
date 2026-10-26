class_name HoldRoyalStage
extends RefCounted
# A single royal actor, shared by free play and the in-world audience.
const POSES=preload("res://assets/royal79/eirik-poses.png")
const KIT=preload("res://assets/royal79/hall-kit.png")
const THRONE=Vector2(650,405)
const FLOOR=Rect2(160,260,980,820)
const CROPS=[Rect2(150,0,590,715),Rect2(825,0,370,705),Rect2(15,720,890,520),Rect2(916,710,330,525)]
static var frames:Array[Rect2]=[]
static func prepare():
 if not frames.is_empty():return
 var im=POSES.get_image();var xs=[0,303,602,912,1254];var ys=[0,294,588,877,1254]
 for i in 16:
  var origin=Vector2i(xs[i%4],ys[i/4]);var cell=Vector2i(xs[i%4+1],ys[i/4+1])-origin
  var low=origin+cell;var high=origin
  for y in range(origin.y,origin.y+cell.y):
   for x in range(origin.x,origin.x+cell.x):
    if im.get_pixel(x,y).a>.15:low=low.min(Vector2i(x,y));high=high.max(Vector2i(x,y))
  frames.append(Rect2(Vector2(low),Vector2(high-low+Vector2i.ONE)))
static func actor(p:Vector2,pose:int=12,aim:Vector2=Vector2.DOWN,gait:float=0.0,moving:bool=false)->Dictionary:
 return {"p":p,"pose":pose,"aim":aim,"gait":gait,"moving":moving}
static func sample(t:float)->Dictionary:
 var phase=fposmod(t,64.0)
 if phase<22:return actor(THRONE-Vector2(0,17),14)
 if phase<23:return actor(THRONE-Vector2(0,17*(23-phase)),13)
 # Stroll down the aisle, pause to hear petitioners, then return to the throne.
 if phase<29:return actor(THRONE.lerp(Vector2(650,585),(phase-23)/6),12,Vector2.DOWN,(phase-23)*.25,true)
 if phase<42:return actor(Vector2(650,585))
 if phase<48:return actor(Vector2(650,585).lerp(THRONE,(phase-42)/6),12,Vector2.UP,(phase-42)*.25,true)
 if phase<49:return actor(THRONE-Vector2(0,17*(phase-48)),13)
 return actor(THRONE-Vector2(0,17),14)
static func current(g)->Dictionary:
 if is_instance_valid(g.opening_scene) and g.opening_scene.mode=="audience":return g.opening_scene.king
 return sample(g.state.elapsed-float(g.state.surface.facts.get("royal_epoch",0)))
static func draw_actor(g,a:Dictionary):
 prepare()
 var index=int(a.pose)
 if a.moving:
  var row=2 if a.aim.y<-.5 else 1 if absf(a.aim.x)>.5 else 0
  index=row*4+posmod(int(a.gait/.72*4),4)
 var r=frames[index];var scale=.235
 var dest=Rect2(a.p-Vector2(r.size.x*scale*.5,r.size.y*scale),r.size*scale)
 g.draw_texture_rect_region(POSES,dest,r)
static func prop(g,index:int,p:Vector2,width:float,tint:Color=Color.WHITE):
 var r=CROPS[index];var size=r.size*(width/r.size.x)
 g.draw_texture_rect_region(KIT,Rect2(p-Vector2(width*.5,size.y),size),r,tint)
static func objects()->Array:
 var result=[{"p":THRONE,"kind":"royal_prop","art":0,"width":132.0,"sort_y":350.0},{"p":Vector2(650,410),"kind":"royal_prop","art":2,"width":435.0,"sort_y":300.0}]
 for y in [535,755,975]:
  for x in [350,950]:result.append({"p":Vector2(x,y),"kind":"royal_prop","art":1,"width":85.0})
 for y in [440,855]:
  for x in [460,840]:result.append({"p":Vector2(x,y),"kind":"royal_prop","art":3,"width":48.0})
 return result
static func obstacles()->Array:
 var out=[Rect2(596,345,108,65)]
 for y in [535,755,975]:
  for x in [350,950]:out.append(Rect2(x-34,y-22,68,25))
 for y in [440,855]:
  for x in [460,840]:out.append(Rect2(x-19,y-20,38,23))
 return out
static func floor_draw(w,area:String="room:throne"):
 var geometry=HoldBuildingPlans.geometry(area);var floor_area=geometry.floor
 var g=w.g;g.draw_rect(Rect2(Vector2.ZERO,geometry.size),Color("14242b"))
 w.tile(0,floor_area,110,Color("a9b8ba"))
 # Side galleries frame a broad, unobstructed processional aisle.
 for x in [185,865]:
  w.tile(0,Rect2(x,320,245,700),110,Color("79898b"))
  g.draw_rect(Rect2(x,320,245,700),Color("a88e59"),false,3)
 for step in 4:
  var r=Rect2(495+step*10,342-step*14,310-step*20,120)
  g.draw_style_box(w.stone_style(Color("77898c").lightened(step*.06)),r)
  g.draw_line(r.position+Vector2(0,r.size.y),r.end,Color("c6b585"),2)
 HoldRoomLayout.rug(w,Rect2(562,455,176,565),Color("486c6b"))
 for x in [568,732]:g.draw_line(Vector2(x,465),Vector2(x,1015),Color("cba960"),3)
 # An oath-star inlaid in stone at the threshold, repeated in the royal banners.
 var center=Vector2(650,1030)
 for i in 8:
  var angle=i*TAU/8;g.draw_line(center,center+Vector2.from_angle(angle)*30,Color("d0ae65"),3)
 for x in range(150,int(floor_area.end.x),55):w.s.house.material(3,Rect2(x,205,55,75))
 for x in [150,floor_area.end.x-10]:g.draw_style_box(w.stone_style(Color("68766f")),Rect2(x,260,20,floor_area.size.y))
 for r in [Rect2(160,floor_area.end.y-10,450,18),Rect2(690,floor_area.end.y-10,floor_area.end.x-690,18)]:g.draw_style_box(w.stone_style(Color("9ca18c")),r)
 if HoldBuildingPlans.has_stairs(area):HoldNeighborhood.draw_stairs(w,HoldBuildingPlans.stair_position(area),HoldBuildingPlans.floor_number(area)==0,96)
 HoldCivicArt.exit_floor(g,area)
static func draw_prop(g,o:Dictionary,t:float,tint:Color=Color.WHITE):
 prop(g,o.art,o.p,o.width,tint)
 if o.art==3:
  for i in 3:
   var a=fposmod(t*18+i*12,30)
   g.draw_circle(o.p+Vector2(sin(t*2+i)*5,-52-a),1.2,Color(1,.7,.25,(1-a/30)*.7))
