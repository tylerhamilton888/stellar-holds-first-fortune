class_name HoldWardDesign
extends RefCounted
# Authored activity pockets around established doors/routes. No seed-dependent decor.
const DEPTH=preload("res://assets/hold-kit68/works-below.png")
static var paving={}
static var lamp_pool:GradientTexture2D
const STORES={"hearthward":[Vector2(1050,940),Vector2(1110,940)],"forgeward":[Vector2(520,765),Vector2(520,815),Vector2(1510,800),Vector2(1570,800)]}
const TITLES={"crownward":"The Oath Court","hearthward":"The Common Hearth","forgeward":"The Iron Terrace"}
static func roles(area:String)->Array:
 return {"crownward":["Archivist","Court lamplighter","Oath courier","Hall steward","Star-chart apprentice","Gallery warden"],"hearthward":["Stonecarver","Lamplighter","Market courier","Baker","Apprentice","Shift worker"],"forgeward":["Toolmaker","Furnace tender","Freight courier","Armourer","Forge apprentice","Lift keeper"]}[area]
static func furnishings(w,area:String)->Array:
 var result=[]
 if area=="crownward":
  result=[w.furn("oath_stone",970,665),w.furn("orrery",590,800),w.furn("notice_board",750,800),w.furn("lamp",900,505),w.furn("lamp",1020,505),w.furn("stone_pillar",840,815),w.furn("stone_pillar",1100,815)]
 elif area=="hearthward":
  result=[w.furn("tea_table",550,770),w.furn("chair",505,790),w.furn("chair",595,790),w.furn("tea_table",730,770),w.furn("chair",685,790),w.furn("chair",775,790),w.furn("lamp",450,745),w.furn("lamp",825,745),w.furn("notice_board",1090,865),w.furn("chest",1050,940),w.furn("chest",1110,940),w.furn("lamp",280,510)]
 else:
  result=[w.furn("pressure_manifold",970,665),w.furn("worktable",610,770),w.furn("chest",520,765),w.furn("chest",520,815),w.furn("notice_board",720,825),w.furn("training_rack",1330,725),w.furn("training_rack",1330,855),w.furn("pressure_manifold",1540,695),w.furn("chest",1510,800),w.furn("chest",1570,800),w.furn("lamp",1460,850),w.furn("lamp",1720,660),w.furn("notice_board",1300,1540)]
 # Lamps bracket the bridge landings; domestic pockets stay beside, not across, doors.
 for p in [Vector2(800,1180),Vector2(1120,1180)]:result.append(w.furn("lamp",p.x,p.y))
 for i in 3:
  var p=HoldNeighborhood.home_door(i)
  result.append(w.furn("lamp",p.x-84,p.y+20))
  result.append(w.furn("chair",p.x+83,p.y+24))
 result.append_array([w.furn("tea_table",1120,1370),w.furn("chair",1075,1390),w.furn("chair",1165,1390),w.furn("lamp",1120,1300)])
 return result
static func points(area:String)->Array:
 var p={"crownward":Vector2(750,826),"hearthward":Vector2(1090,891),"forgeward":Vector2(720,851)}[area]
 var result=[{"p":p,"name":TITLES[area]+" · public notices","action":"ward_notice:"+area}]
 if area=="crownward":result.append({"p":Vector2(590,833),"name":"Founders’ orrery","action":"ward_notice:stars"})
 if area=="forgeward":result.append({"p":Vector2(1300,1570),"name":"Overlook · the Works Below","action":"ward_notice:works"})
 return result
static func notice(id:String)->String:
 return {"crownward":"THE STONE MUST BEAR. The Lord keeps audience beyond the Oath Court. The memorial honors the prospectors who founded these three hearths; their children still keep the mountain's measures.","hearthward":"THE FOLK MUST FLOURISH. Rest and company at the Copper Kettle; trade on the north street; charters with Ivar by King's Gate. Family hearths stand across the southern bridge. Keep their doorways clear.","forgeward":"THE WORK MUST FLOW. Borin's forge stands on the north street. Freight is marshalled beside the eastern lift; training belongs on the Iron Terrace. The deep pumps and ventilation keep the mountain habitable.","stars":"An ancestral survey instrument: brass orbits preserve the founders’ star bearings. Keldrath began with prospectors, but its measures were inherited from civilizations that learned to navigate far beyond one mountain.","works":"The Works Below: pump galleries, furnace flues and freight bridges disappear into the mountain. These distant levels are scenery in this chapter; the public Great Stair connects the three inhabited wards."}.get(id,"")
static func backdrop(g,area:String):
 HoldGrounding.backdrop(g,area)
static func shaft(w,rect:Rect2):
 var source=Rect2(140,260,1260,540) if w.current_area()!="forgeward" else Rect2(600,260,900,650)
 HoldGrounding.cover(w.g,DEPTH,rect,source,Color(.65,.72,.77))
static func plaza(g,r:Rect2,color:Color,trim:Color):
 var a=r.position;var b=r.end;var c=24.0
 var polygon=PackedVector2Array([a+Vector2(c,0),Vector2(b.x-c,a.y),Vector2(b.x,a.y+c),b-Vector2(0,c),b-Vector2(c,0),Vector2(a.x+c,b.y),Vector2(a.x,b.y-c),a+Vector2(0,c)])
 var key=str(r)+str(color)
 if not paving.has(key):
  var vertices=[];var colors=[];var indices=[];var uv=PackedVector2Array()
  for y in range(int(a.y),int(b.y)+1,30):
   for x in range(int(a.x)-25,int(b.x)+1,50):
    var left=x+(15 if posmod(y-int(a.y),60)==0 else 0)
    var cell=PackedVector2Array([Vector2(left+1,y+1),Vector2(left+49,y+1),Vector2(left+49,y+29),Vector2(left+1,y+29)])
    for clip in Geometry2D.intersect_polygons(cell,polygon):
     var base=vertices.size();var shade=color.lightened(float(posmod(x*17+y*31,13))/160.0)
     for v in clip:
      vertices.append(Vector3(v.x,v.y,0));colors.append(shade);uv.append(v/800.0)
     for index in Geometry2D.triangulate_polygon(clip):indices.append(base+index)
  var arrays=[];arrays.resize(Mesh.ARRAY_MAX);arrays[Mesh.ARRAY_VERTEX]=PackedVector3Array(vertices);arrays[Mesh.ARRAY_COLOR]=PackedColorArray(colors);arrays[Mesh.ARRAY_TEX_UV]=uv;arrays[Mesh.ARRAY_INDEX]=PackedInt32Array(indices)
  var mesh=ArrayMesh.new();mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays);paving[key]=mesh
 g.draw_colored_polygon(polygon,color.darkened(.24))
 g.draw_mesh(paving[key],HoldFloorPattern.texture())
 var outline=polygon.duplicate();outline.append(polygon[0]);g.draw_polyline(outline,trim.darkened(.12),1.5,true)
static func ground(w):
 var g=w.g;var area=w.current_area()
 if area=="crownward":
  plaza(g,Rect2(795,480,350,425),Color("69766b"),Color("ad9b70"))
  for x in [856,1084]:g.draw_line(Vector2(x,490),Vector2(x,890),Color("b49b63"),2)
  plaza(g,Rect2(510,740,290,125),Color("65756c"),Color("8c9b86"))
  # Celestial bearings are inlaid into the load-bearing paving, not floating UI.
  var star=PackedVector2Array()
  for i in 16:star.append(Vector2(970,700)+Vector2.from_angle(i*PI/8.0)*(100 if i%2==0 else 18))
  g.draw_colored_polygon(star,Color("9b8f67"))
  var inset=PackedVector2Array([Vector2(970,678),Vector2(992,700),Vector2(970,722),Vector2(948,700)])
  g.draw_colored_polygon(inset,Color("365753"))
 elif area=="hearthward":
  plaza(g,Rect2(440,700,395,150),Color("85775b"),Color("a99a78"))
  plaza(g,Rect2(855,555,230,165),Color("7b8068"),Color("b4a37a"))
  plaza(g,Rect2(1020,830,130,160),Color("7c7964"),Color("b1a077"))
  plaza(g,Rect2(265,470,170,90),Color("85795f"),Color("b0a27e"))
 else:
  plaza(g,Rect2(460,710,320,165),Color("666d67"),Color("95866a"))
  plaza(g,Rect2(1160,675,220,225),Color("6f6a59"),Color("b19b72"))
  plaza(g,Rect2(1430,630,190,255),Color("596a66"),Color("a48d61"))
  # Flush freight guides and reinforcement straps do not obstruct walking.
  for x in [1480,1590]:
   g.draw_line(Vector2(x,630),Vector2(x,905),Color("384c4e"),5)
   g.draw_line(Vector2(x+1,630),Vector2(x+1,905),Color("93876c"),1)
  for y in [695,765,835,905]:g.draw_line(Vector2(1476,y),Vector2(1594,y),Color("80755d"),2)
 for i in 3:
  var p=HoldNeighborhood.home_door(i)
  plaza(g,Rect2(p+Vector2(-62,4),Vector2(124,61)),[Color("817963"),Color("6d8074"),Color("737b75")][i],Color("b5a17b"))
static func light_pools(w):
 if lamp_pool==null:
  var ramp=Gradient.new();ramp.colors=PackedColorArray([Color(1,.67,.27,.19),Color(1,.67,.27,0)])
  lamp_pool=GradientTexture2D.new();lamp_pool.gradient=ramp;lamp_pool.width=128;lamp_pool.height=64;lamp_pool.fill=GradientTexture2D.FILL_RADIAL;lamp_pool.fill_from=Vector2(.5,.5);lamp_pool.fill_to=Vector2(1,.5)
 for f in furnishings(w,w.current_area()):
  if f.furnishing=="lamp":w.g.draw_texture_rect(lamp_pool,Rect2(f.p-Vector2(70,25),Vector2(140,70)),false)
static func motion(g):
 if g.surface.area!="forgeward":return
 for p in [Vector2(970,665),Vector2(1540,695)]:
  for i in 3:
   var t=fposmod(g.clock*.28+i*.33,1.0)
   var at=p+Vector2(30+sin(t*4+i)*5,-75-t*36)
   g.draw_circle(at,3+t*5,Color(.65,.76,.74,sin(t*PI)*.09))
static func boundary(w):
 var g=w.g
 # Outside the walkable envelope: service conduits follow the real retaining piers.
 for x in [92,1788]:
  g.draw_line(Vector2(x,280),Vector2(x,970),Color("304246"),8)
  g.draw_line(Vector2(x,280),Vector2(x,970),Color("967747"),4)
  for y in [400,640,880]:
   g.draw_rect(Rect2(x-7,y-5,14,10),Color("b99a61"))
   g.draw_line(Vector2(x-4,y),Vector2(x+4,y),Color("4b5b59"),2)
static func mountain(w):
 HoldGrounding.mountain(w)
static func frontage(w,b:Dictionary):
 HoldGrounding.sign(w,b)
