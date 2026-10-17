class_name HoldMountain
extends RefCounted
# Seeded geological cross-section. Air, overburden and bedrock follow a mountain
# silhouette; connected caves and sinuous lodes are carved into that geology.
static func generate(g:Geology,value:int):
 g.seed_value=value;g.cells.resize(Geology.W*Geology.H);g.damage={};g.grain_bank={};g.active_grains={};g.dirty={};g.structures=[];g.timbers={};g.structure_dirty=true
 var rng=RandomNumberGenerator.new();rng.seed=value
 var noise=FastNoiseLite.new();noise.seed=value;noise.frequency=.037
 var surface=[]
 for x in Geology.W:
  var rise=44.0*smoothstep(10.0,85.0,x)
  var ridge=4*sin(x*.025+value%31)+noise.get_noise_1d(x)*6
  var top=56 if x<12 else clampi(int(round(56-rise+ridge*smoothstep(12.0,60.0,x))),6,56)
  surface.append(top)
  var soil=5+int((noise.get_noise_1d(x+730)+1)*3)
  for y in Geology.H:
   var kind=0
   if y>=top:kind=1 if y<top+soil else (7 if y>158+int(noise.get_noise_2d(x,y)*6) else 2)
   if y>=Geology.H-3 or x>=Geology.W-3:kind=8
   g.cells[y*Geology.W+x]=kind
 # Thin branching veins cut across the host rock; large quiet rock intervals
 # make finding and following a seam meaningful.
 var lodes=[]
 for vein in 22:
  var kind=[3,4,5,3,4,6][vein%6]
  var p=Vector2(rng.randf_range(36,350),rng.randf_range(48 if kind!=6 else 95,155))
  var direction=Vector2(rng.randf_range(-1,1),rng.randf_range(.1,.7)).normalized()
  lodes.append([int(p.x),int(p.y),kind])
  for step in rng.randi_range(24,66):
   paint_disc(g,p,1.0 if kind==6 else rng.randf_range(1.1,2.2),kind,true)
   direction=direction.rotated(rng.randf_range(-.12,.12));p+=direction*1.5
   if p.x<20 or p.x>376 or p.y>169:break
   if step%17==0:
    var branch=p
    for j in 10:
     branch+=direction.rotated(.8)*1.4;paint_disc(g,branch,1.1,kind,true)
 # Natural voids follow two fractured bands, not a grid of platform chambers.
 var caves=[]
 for i in range(5):
  var cx=rng.randi_range(135,350)
  var cy=clampi(int(76+cx*.16+rng.randf_range(-18,18)),80,146)
  var rx=rng.randi_range(12,28);var ry=rng.randi_range(8,15)
  caves.append([cx,cy,rx,ry])
  for y in range(cy-ry-2,cy+ry+3):
   for x in range(cx-rx-2,cx+rx+3):
    if x<5 or x>=Geology.W-4 or y<surface[x]+20 or y>=Geology.H-4:continue
    var distance=pow((x-cx)/float(rx),2)+pow((y-cy)/float(ry),2)
    if distance<.85+noise.get_noise_2d(x,y)*.45:g.cells[y*Geology.W+x]=0
 # One shallow worked haulage adit, gently graded for drainage. Side workings
 # are short blind headings; the player chooses where the next tunnels go.
 for x in range(0,116):
  var floor_y=56+int(maxi(0,x-35)/24)
  for y in range(floor_y-15,floor_y):g.cells[y*Geology.W+x]=0
  for y in range(floor_y,floor_y+3):g.cells[y*Geology.W+x]=2
 for x in range(68,78):
  for y in range(36,57):g.cells[y*Geology.W+x]=0
 # Coal seams are in the working face and side wall, never the floor needed to leave.
 for x in range(45,100):
  for y in range(38,41):
   if g.at(x,y) in [1,2]:g.cells[y*Geology.W+x]=5
 for x in range(116,134):
  for y in range(43,59):g.cells[y*Geology.W+x]=5
 paint_disc(g,Vector2(125,64),6,3,true)
 paint_disc(g,Vector2(155,77),5,4,true)
 # Small floor root beds and closed spring pockets reward cave exploration.
 for cave in caves:
  var floor_y=int(cave[1]+cave[3])
  for x in range(cave[0]-3,cave[0]+4):
   for y in range(floor_y-4,floor_y+4):
    if g.at(x,y) not in [0,8] and g.at(x,y-1)==0:g.cells[y*Geology.W+x]=9;break
 for y in range(91,97):
  for x in range(111,122):
   if g.at(x,y)==2 and pow((x-116)/5.0,2)+pow((y-94)/3.0,2)<1:g.cells[y*Geology.W+x]=10
 # Concealed geodes interrupt the host rock: shell, crystal lining, tiny void.
 # Their crystal is actual mineable material; discovery state persists in mountain.
 var geodes=[]
 for i in 3:
  var cx=160+i*70+rng.randi_range(-8,8);var cy=90+(i%2)*32+rng.randi_range(-5,5);var radius=9+i
  paint_disc(g,Vector2(cx,cy),radius+2,2)
  paint_disc(g,Vector2(cx,cy),radius-1,6)
  paint_disc(g,Vector2(cx,cy),3,0)
  # A narrow mineral trail is a readable clue once the player reaches this bed.
  for j in 20:paint_disc(g,Vector2(cx-radius-j,cy-2-sin(j*.25)*2),.8,6,true)
  geodes.append({"x":cx,"y":cy,"r":radius,"seen":false})
 g.mountain={"version":4,"surface":surface,"caves":caves,"lodes":lodes,"geodes":geodes}
 # Structural posts are behind the walking lane; their roof beam is physical.
 g.structures.append({"x":31,"y":55,"starter":true})
 for x in range(31,43):g.set_cell(Vector2i(x,43),13)
 g.mountain["initial_solid"]=g.cells.count(0)
 g.redraw_all=true;g.physics_clock=0;g.physics_tick=0
static func paint_disc(g:Geology,p:Vector2,r:float,kind:int,rock_only:bool=false):
 for y in range(int(p.y-r)-1,int(p.y+r)+2):
  for x in range(int(p.x-r)-1,int(p.x+r)+2):
   if x<1 or x>=Geology.W-3 or y<1 or y>=Geology.H-3:continue
   if Vector2(x,y).distance_to(p)>r:continue
   if rock_only and g.at(x,y) not in [2,7]:continue
   g.cells[y*Geology.W+x]=kind
static func tunnel(g:Geology,a:Vector2,b:Vector2,r:float,noise:FastNoiseLite):
 var steps=maxi(1,int(a.distance_to(b)))
 for i in range(steps+1):
  var p=a.lerp(b,float(i)/steps);p.y+=noise.get_noise_1d(p.x+170)*2
  paint_disc(g,p,r,0)
static func background(n:Node2D,g:Geology,camera:Vector2):
 if g.mountain.is_empty():return
 var surface=g.mountain.surface
 # Each terrain column has opaque backing. No camera-dependent triangulation
 # of a long concave silhouette, and no sky visible through texture alpha.
 var start=maxi(0,int(floor(camera.x/7))-1)
 var end=mini(Geology.W,int(ceil((camera.x+960)/7))+1)
 var bottom=float(Geology.H*7)
 for x in range(start,end):
  var top=float(surface[x])*7
  var rect=Rect2(Vector2(x*7,top)-camera,Vector2(7,bottom-top))
  n.draw_rect(rect,Color("1c2934"))
  var source=Rect2(1033+475.0*x/Geology.W,28+458.0*top/bottom,475.0/Geology.W,458.0*(bottom-top)/bottom)
  n.draw_texture_rect_region(HoldTerrainView.ATLAS,rect,source,Color("475a68"))
