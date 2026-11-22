extends RefCounted

# All coordinates are relative to the throne on its original saved floor.
const Regulator=preload("res://court/regulator.gd")
const HALL=Rect2i(-5,-3,11,10)
const COMMONS=Rect2i(-11,-1,5,6)
const ARCHIVE=Rect2i(7,-2,5,6)
const GATE=Rect2i(-2,7,5,3)
const CROSSING=Rect2i(-7,1,15,2)
const WATCH_BUNKS=Rect2i(-11,-4,4,3)
const BOUNDS=Rect2i(-11,-4,23,14)
const PIECES=[
 ["frieze",0,-92],["royal_throne",0,-9],
 ["royal_pillar",-167,-35],["royal_pillar",167,-35],
 ["royal_brazier",-96,28],["royal_brazier",96,28],
 ["stone_pillar",-172,180],["fallen",157,207],
 ["gate_left",-72,305],["gate_right",72,305],
 ["mess",-362,110],["chair",-435,111],
 ["crosswall",-377,-141],["bed",-420,-60],["bed",-351,-60],
 ["divider",-301,-34],["archive_wall",365,-79],
 ["pantry",-427,12],["hearth",-297,15],
 ["bookcase",308,-38],["bookcase",371,-38],["desk",351,72],["chair",398,81],
 ["chest_open",428,-13]
]
const CUSTOM={
 "royal_throne":[Vector2(144,108),Rect2(-54,-53,108,57),"throne"],
 "pressure":[Vector2(332,106),Rect2(-154,-13,308,16),"pressure"],
 "frieze":[Vector2(363,120),Rect2(-178,-13,356,17),"frieze"],
 "fallen":[Vector2(135,68),Rect2(-58,-35,116,33),"fallen"],
 "mess":[Vector2(148,74),Rect2(-62,-27,124,29),"mess"],
 "crosswall":[Vector2(155,53),Rect2(-70,-6,140,7),"crosswall"],
 "archive_wall":[Vector2(195,65),Rect2(-89,-6,178,7),"crosswall"],
 "divider":[Vector2(85,30),Rect2(-37,-5,74,6),"crosswall"],
 "gate_left":[Vector2(44,44),Rect2(-18,-12,36,15),"gate_left"],
 "gate_right":[Vector2(44,44),Rect2(-18,-12,36,15),"gate_right"]
}
static var images={}
static func image_art(id:String)->Texture2D:
 if not images.has(id):
  var image=Image.new()
  if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://court/"+id+".webp"))!=OK:return null
  images[id]=ImageTexture.create_from_image(image)
 return images[id]

static func site_cell(f:Dictionary)->Vector2i:
 return Vector2i(int(f.x),int(f.y))

static func chamber(c:Vector2i)->int:
 if HALL.has_point(c):return 1
 if COMMONS.has_point(c):return 2
 if ARCHIVE.has_point(c):return 3
 if WATCH_BUNKS.has_point(c):return 5
 if GATE.has_point(c) or CROSSING.has_point(c):return 4
 return 0

static func install(layer:Dictionary,f:Dictionary):
 if f.get("court_plan",0)==1:return
 var root=site_cell(f)
 for y in range(BOUNDS.position.y,BOUNDS.end.y):
  for x in range(BOUNDS.position.x,BOUNDS.end.x):
   var at=root+Vector2i(x,y)
   if chamber(Vector2i(x,y))==0 or at.x<1 or at.x>=79 or at.y<1 or at.y>=63:continue
   var i=at.y*80+at.x
   if layer.cells[i]!=8 and not layer.damage.has("%d,%d"%[at.x,at.y]):layer.cells[i]=0
 f.court_plan=1

static func footprint(id:String,p:Vector2)->Rect2:
 if CUSTOM.has(id):
  var area:Rect2=CUSTOM[id][1]
  return Rect2(p+area.position,area.size)
 return HoldFurnishings.footprint(id,p)

static func furniture(w,z:int,f:Dictionary,reserved:Array)->Array:
 var origin=w.center(site_cell(f));var result=[]
 for entry in (Regulator.PIECES if f.has("regulator_plan") else PIECES):
  var id=str(entry[0])
  var p=origin+Vector2(entry[1],entry[2])
  var rect=footprint(id,p)
  var part={"kind":"landmark","prop":id,"p":p,"base":rect.get_center(),"radius":rect.size*.5,"width":rect.size.x,"height":rect.size.y,"art":0,"feature":f}
  # Old saves may already use part of the ruin for a station or a stair.
  if not w.landmark_conflict([part],Vector2.ZERO,reserved,z):result.append(part)
 return result

static func light_at(g,p:Vector2,origin:Vector2,f:Dictionary)->Color:
 var light=clampf(1.18-p.distance_to(g.player)/800.,.54,1.)
 var warmth=0.
 for side in [-1,1]:
  if not f.get("west_lit" if side<0 else "east_lit",false):continue
  var glow=clampf(1.-p.distance_to(origin+Vector2(side*96,20))/130.,0.,1.)
  warmth=maxf(warmth,glow*glow)
 return Color(light*(.96+.15*warmth),light*(.98+.04*warmth),light*(1.-.08*warmth))

static func draw_prop(g,actor:Dictionary):
 var p:Vector2=actor.anchor
 var id=str(actor.prop)
 var origin=g.deep.world.center(site_cell(actor.feature))
 var tint=light_at(g,p,origin,actor.feature)
 if id=="royal_brazier" and not actor.feature.get("west_lit" if p.x<origin.x else "east_lit",false):
  var crop=Rect2(916,929,330,306)
  g.draw_texture_rect_region(HoldRoyalStage.KIT,Rect2(p-Vector2(24,44.5),Vector2(48,44.5)),crop,tint)
  var ash=p-Vector2(0,43)
  g.draw_colored_polygon(PackedVector2Array([ash+Vector2(-15,2),ash+Vector2(-11,-3),ash+Vector2(4,-5),ash+Vector2(14,-1),ash+Vector2(12,4),ash+Vector2(-4,5)]),Color("3e3935"))
  g.draw_line(ash+Vector2(-7,0),ash+Vector2(2,2),Color("66605a"),2)
 elif id=="hearth":
  g.draw_texture_rect_region(HoldFurnishings.ATLAS,HoldFurnishings.silhouette(id,p),HoldFurnishings.CROPS[7],tint*Color(.78,.77,.77))
  var mouth=p+Vector2(1,-23)
  g.draw_colored_polygon(PackedVector2Array([mouth+Vector2(-11,4),mouth+Vector2(-9,-5),mouth+Vector2(-4,-9),mouth+Vector2(4,-9),mouth+Vector2(11,-5),mouth+Vector2(12,4)]),Color("302c2a"))
  g.draw_line(mouth+Vector2(-6,2),mouth+Vector2(7,0),Color("635648"),2)
 elif id in ["gate_left","gate_right"]:
  g.draw_texture_rect_region(image_art("crosswall"),Rect2(p-Vector2(20,42),Vector2(40,42)),Rect2(0,0,185,195),tint)
 elif CUSTOM.has(id):
  var size:Vector2=CUSTOM[id][0]
  var silhouette=Rect2(p-Vector2(size.x*.5,size.y),size)
  if g.player.y<actor.base.y and silhouette.intersects(Rect2(g.player-Vector2(15,45),Vector2(30,45))):tint.a=.48
  g.draw_texture_rect(image_art(CUSTOM[id][2]),silhouette,false,tint)
 else:
  tint.a=HoldFurnishings.foreground_alpha(id,p,g.player)
  HoldFurnishings.draw(g,p,id,tint)

static func draw_floor(g,w):
 var layer=w.layer()
 if layer.features.is_empty():return
 var f=layer.features[0]
 if not f.has("court_plan"):return
 var root=site_cell(f)
 var origin=w.center(root)
 var tex=image_art("pavement")
 var camera=Rect2(g.camera-Vector2(60,50),Vector2(1080,650))
 for y in range(BOUNDS.position.y,BOUNDS.end.y):
  for x in range(BOUNDS.position.x,BOUNDS.end.x):
   var local=Vector2i(x,y)
   var room=chamber(local)
   if room==0:continue
   var c=root+local
   var p=w.center(c)
   if not camera.has_point(p) or w.at(c)!=0 or not layer.seen.has(w.key(c)):continue
   var r=Rect2(p-Vector2(20,20),Vector2(40,40))
   var tint=light_at(g,p,origin,f)
   var source:Rect2
   if room==1:
    var ts=tex.get_size()/Vector2(HALL.size)
    source=Rect2(Vector2(local-HALL.position)*ts,ts)
   else:
    var ts=tex.get_size()/Vector2(HALL.size)
    source=Rect2(Vector2(posmod(x,2),posmod(y+2,9))*ts,ts)
    if room in [2,5]:tint*=Color(.95,.83,.70)
    if room==3:tint*=Color(.81,.92,.92)
   # The surviving paving breaks into native dirt at exposed corners.
   var left=chamber(local+Vector2i.LEFT)==0
   var right=chamber(local+Vector2i.RIGHT)==0
   var top=chamber(local+Vector2i.UP)==0
   var bottom=chamber(local+Vector2i.DOWN)==0
   var cut=8+posmod(x*31+y*7,12)
   if (left or right) and (top or bottom):
    var corners=PackedVector2Array([Vector2(0,0),Vector2(40,0),Vector2(40,40),Vector2(0,40)])
    var broken=0 if left and top else 1 if right and top else 2 if right and bottom else 3
    var poly=PackedVector2Array();var uv=PackedVector2Array()
    for k in 4:
     var corner=corners[k]
     var pieces=[corner] if k!=broken else [corner.move_toward(corners[posmod(k-1,4)],cut),corner.lerp(Vector2(19,21),.31),corner.move_toward(corners[(k+1)%4],cut*.78)]
     for v in pieces:
      poly.append(r.position+v);uv.append((source.position+v/40.*source.size)/tex.get_size())
    g.draw_polygon(poly,PackedColorArray([tint]),uv,tex)
   else:
    g.draw_texture_rect_region(tex,r,source,tint)
   if room==1 and Vector2(x-4,y-5).length()<2.4:
    var k=posmod(x*47+y*31,101)
    for j in (3 if x>=3 else 1):
     var q=r.position+Vector2(5+posmod(k*7+j*13,29),6+posmod(k*13+j*9,28))
     var v=Vector2(2+posmod(k+j*3,5),1+posmod(k*2+j,3))
     g.draw_colored_polygon(PackedVector2Array([q+Vector2(-v.x,1),q+Vector2(1,-v.y),q+Vector2(v.x,0),q+Vector2(2,v.y)]),Color("69605b"))
     g.draw_line(q+Vector2(-v.x,0),q+Vector2(1,-v.y),Color("ada08a"),1)
   # Surviving wall courses sit on the rock face. Excavating their backing
   # exposes only a chipped sill along the pavement's historical footprint.
   if chamber(local+Vector2i.UP)==0:
    if w.at(c+Vector2i.UP)!=0:
     g.draw_texture_rect_region(HoldMasonryArt.ATLAS,Rect2(r.position-Vector2(0,21),Vector2(40,29)),Rect2(22+posmod(x,4)*123,880,124,234),tint)
    else:
     g.draw_line(r.position+Vector2(0,3),r.position+Vector2(29+posmod(x,9),3),Color("80786b"),3)
   if (room==2 or room==3) and chamber(local+Vector2i.DOWN)==0:
    g.draw_line(r.position+Vector2(0,39),r.end,Color("534f46"),3)
 # Three worn risers share the frieze's raised footing.
 for i in 3:
  for j in range(-3,4):
   var c=root+Vector2i(j,0)
   if not layer.seen.has(w.key(c)) or w.at(c)!=0:continue
   var x0=origin.x+j*40-20
   var r=Rect2(Vector2(x0,origin.y+4+i*5),Vector2(40,5))
   g.draw_rect(r,Color("645c51").darkened(i*.045))
   g.draw_line(r.position,r.position+Vector2(39,0),Color("ab9a80"),1.5)

static func near_record(w,p:Vector2)->String:
 if w.depth() not in [38,52]:return ""
 for part in w.landmarks():
  if part.prop=="royal_brazier" and part.feature.has("court_plan") and p.distance_to(part.base)<49:
   var side="west_lit" if part.p.x<w.center(site_cell(part.feature)).x else "east_lit"
   if not part.feature.get(side,false) and w.visible(p,part.base,-1,false):return side
  if part.prop=="pressure" and p.distance_to(part.base)<82 and w.visible(p,part.base,-1,false):return "pressure"
  if not part.feature.get("court_plan",0):continue
  if part.prop not in ["desk","mess"]:continue
  if p.distance_to(part.base)<73 and w.visible(p,part.base,-1,false):return str(part.prop)
 return ""

static func note(id:String)->String:
 if id=="pressure":return "A fitter scored a second line into the dial. The needle sits above it. The upper feed is still open."
 if id=="desk":return "The last slate lists twelve gate guards. Beside each name, the clerk marked a bunk and a supper."
 return "A copper tally hangs by the kettle. Twelve bowls went out on the last watch. Eleven came back."
