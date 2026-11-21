extends RefCounted

const FLOOR = Rect2i(-5,-2,11,6)
const BENCH = Rect2i(-8,0,3,4)
const ENTRY = Rect2i(-1,4,4,2)
const PIECES = [
 ["pressure",0,-63],["pressure_manifold",-82,59],["worktable",-245,31],
 ["chest_open",-286,103],["road_lantern",-186,23],["crate",-228,102]]
static func in_room(p:Vector2i)->bool:
 return FLOOR.has_point(p) or BENCH.has_point(p) or ENTRY.has_point(p)

static func install(layer:Dictionary,f:Dictionary):
 if f.get("regulator_plan",0)==1:return
 for y in range(-2,6):
  for x in range(-8,6):
   var c=Vector2i(int(f.x)+x,int(f.y)+y)
   if not in_room(Vector2i(x,y)) or c.x<1 or c.x>=79 or c.y<1 or c.y>=63:continue
   var index=c.y*80+c.x
   if layer.cells[index]!=8 and not layer.damage.has("%d,%d"%[c.x,c.y]):layer.cells[index]=0
 f.regulator_plan=1

static func paint(g,w,f:Dictionary,tex:Texture2D):
 var root=Vector2i(f.x,f.y)
 var l=w.layer()
 for y in range(-2,6):
  for x in range(-8,6):
   var local=Vector2i(x,y);var c=root+local
   if not in_room(local) or w.at(c)!=0 or not l.seen.has(w.key(c)):continue
   var p=w.center(c)-Vector2(20,20)
   var light=clampf(1.06-g.player.distance_to(p)/1060.,.52,.96)
   var dye=Color(.78,.86,.80)*Color(light,light,light)
   # Source each flag from plain margins of the processional pavement.
   var ts=tex.get_size()/Vector2(11.,10.)
   var sx=posmod(x*3+y,2) if posmod(x+2*y,3)!=0 else 10
   var src=Rect2(Vector2(sx,posmod(y*2+x,9))*ts,ts)
   var vertices=PackedVector2Array();var uvs=PackedVector2Array();var colors=PackedColorArray()
   for corner in [Vector2i.ZERO,Vector2i.RIGHT,Vector2i.ONE,Vector2i.DOWN]:
    var v=Vector2(corner)*40
    var q=local+corner;var intact=0
    for neighbor in [Vector2i.ZERO,Vector2i.LEFT,Vector2i.UP,Vector2i(-1,-1)]:
     if in_room(q+neighbor):intact+=1
    var tint=dye
    tint.a=1. if intact==4 else .12+posmod(q.x*27+q.y*17,17)*.016
    vertices.append(p+v);uvs.append((src.position+(v/40.)*src.size)/tex.get_size());colors.append(tint)
   g.draw_polygon(vertices,colors,uvs,tex)
   if x==2 and y>=-2 and y<=3:
    # The outlet empties into a shallow channel under two crosswalk grates.
    var top=clampf(-63.-(y*40.-20.),0,40)
    if top>=40:continue
    var at=p+Vector2(2,top);var h=40.-top
    g.draw_rect(Rect2(at,Vector2(36,h)),Color("292f30"))
    g.draw_rect(Rect2(at+Vector2(3,0),Vector2(29,h)),Color("25454c"))
    g.draw_line(at+Vector2(2,0),at+Vector2(2,h),Color("918065"),2)
    g.draw_line(at+Vector2(34,0),at+Vector2(34,h),Color("665f50"),2)
    if y in [1,3]:
     for i in 6:
      g.draw_line(at+Vector2(2,2+i*7),at+Vector2(34,2+i*7),Color("171e21"),4)
      g.draw_line(at+Vector2(2,1+i*7),at+Vector2(34,1+i*7),Color("8b7961"),2)
    else:
     for i in 3:
      var shift=fposmod(g.clock*14+i*13+x,40)
      if shift>=h:continue
      var q=at+Vector2(8+posmod(i*11+y,14),shift)
      g.draw_line(q,q+Vector2(5,-2),Color(.51,.75,.73,.38),1.25)
