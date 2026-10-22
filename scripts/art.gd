class_name HoldArt
extends RefCounted
# All silhouettes, ornament, characters and geological marks are authored here.
static var draw_offset=Vector2.ZERO
const ROCK=preload("res://assets/character-parts/terrain.png")
const INK=Color("14222e")
const GOLD=Color("d4a65f")
const LIGHT=Color("f1d7a0")
const TEAL=Color("4e9293")
static func rect(n:Node2D,x:float,y:float,w:float,h:float,c):n.draw_rect(Rect2(x,y,w,h),Color(c))
static func poly(n:Node2D,a:Array,c):n.draw_colored_polygon(PackedVector2Array(a),Color(c))
static func line(n:Node2D,a:Vector2,b:Vector2,c,w:float=1):n.draw_line(a,b,Color(c),w)
static func text(n:Node2D,p:Vector2,s:String,size:int=16,col:Color=LIGHT):
 n.draw_string(ThemeDB.fallback_font,p,s,HORIZONTAL_ALIGNMENT_LEFT,-1,size,col)
static func rune(n:Node2D,p:Vector2,s:float=1.0,c:Color=GOLD):
 line(n,p+Vector2(0,9)*s,p+Vector2(0,-9)*s,c,2)
 line(n,p+Vector2(0,-9)*s,p+Vector2(7,-3)*s,c,2)
 line(n,p+Vector2(7,-3)*s,p,c,2)
 line(n,p,p+Vector2(6,7)*s,c,2)
static func lamp(n:Node2D,p:Vector2,t:float):
 for i in range(4,0,-1):n.draw_circle(p,8+i*5,Color(1,.64,.24,.025))
 rect(n,p.x-5,p.y-8,10,16,"263740")
 rect(n,p.x-3,p.y-5,6,10,"ebb05e")
 rect(n,p.x-2,p.y-4,3,7,Color(1,.88,.56,.8+sin(t*3)*.15))
 rect(n,p.x-6,p.y-9,12,2,"bc8f53")
static func crate(n:Node2D,p:Vector2,s:float=1):
 HoldItemArt.draw(n,Rect2(p+Vector2(0,-26)*s,Vector2(29,26)*s),10)
static func barrel(n:Node2D,p:Vector2):
 HoldItemArt.draw(n,Rect2(p+Vector2(-12,-30),Vector2(25,30)),11)
static func dwarf(n:Node2D,p:Vector2,t:float,walking:bool=false,face:int=1,variant:int=0,working:bool=false,profile:Dictionary={},action:float=-1):
 var appearance=profile if not profile.is_empty() else HoldAppearance.defaults()
 var cycle=action if action>=0 else (fposmod(t,1.2)/1.2 if working else -1.0)
 HoldDrawnAnimation.paint(n,p+draw_offset,appearance,Vector2(face,.45),walking,t,n.character_scale() if n.has_method("character_scale") else 1.0,draw_offset,"pick" if cycle>=0 else "",maxf(0,cycle))
static func bot(n:Node2D,p:Vector2,t:float,working:bool=false):
 n.draw_set_transform(p+draw_offset)
 for x in [-14,8]:
  rect(n,x,-8,8,10,"b28348");rect(n,x-3,-1,12,5,"273b47")
 rect(n,-20,-30,40,24,INK);rect(n,-18,-28,36,20,"a87b43")
 rect(n,-14,-32,28,6,"d6ac65");rect(n,-13,-25,27,11,"294f5d")
 for x in [-8,5]:rect(n,x,-23,5,5,"8fe1ce")
 rect(n,-8,-12,18,5,"e4bd77")
 rect(n,-23,-23,6,15,"627d82");rect(n,18,-23,6,15,"627d82")
 var b=Vector2(36,-17+sin(t*15)*2 if working else -17)
 line(n,Vector2(20,-17),b,"c7c2a2",5)
 poly(n,[b+Vector2(0,-7),b+Vector2(13,0),b+Vector2(0,7)],"a4bfbc")
 for i in 3:line(n,b+Vector2(i*3,-5+i),b+Vector2(i*3,5-i),"486571",1)
 n.draw_set_transform(draw_offset)
static func tree(n:Node2D,p:Vector2,index:int,t:float,stump:bool=false):
 rect(n,p.x-7,p.y-60 if not stump else p.y-12,15,60 if not stump else 12,"705440")
 rect(n,p.x-4,p.y-58 if not stump else p.y-10,4,57 if not stump else 9,"ac8054")
 if stump:return
 var shift=sin(t+index)*2
 for j in range(3):
  var y=p.y-48-j*21
  poly(n,[Vector2(p.x-37+j*5+shift,y),Vector2(p.x+shift,y-52),Vector2(p.x+37-j*5+shift,y)], ["264b50","32645d","437b67"][j])
  line(n,Vector2(p.x-22+j*4+shift,y-14),Vector2(p.x+shift,y-45),"649177",2)
static func building(n:Node2D,x:float,y:float,w:float,h:float,kind:int,t:float):
 # Distinct rooflines, copper roofs, stone blocks, doors, lit interiors.
 rect(n,x-8,y-8,w+16,13,"283d45")
 rect(n,x,y-h,w,h,"364a50")
 for row in range(int(h/15)):
  for col in range(int(w/27)+1):
   var xx=x+col*27+(13 if row%2 else 0)
   if xx+25>x+w:continue
   rect(n,xx+1,y-row*15-14,25,13,["40585c","435d60","3b5359"][(row+col)%3])
   rect(n,xx+2,y-row*15-14,23,1,"5b7270")
 for xx in [x+4,x+w-13]:
  rect(n,xx,y-h,9,h,"957347");rect(n,xx+2,y-h,2,h,"c39958")
 var roof=[Vector2(x-14,y-h+6),Vector2(x+w*.5,y-h-47),Vector2(x+w+14,y-h+6)]
 poly(n,roof,"20343e")
 poly(n,[Vector2(x-8,y-h+2),Vector2(x+w*.5,y-h-40),Vector2(x+w+8,y-h+2)],"437879" if kind!=1 else "8b5d4c")
 for i in range(1,5):
  var yy=y-h+1-i*8
  line(n,Vector2(x+i*15,yy),Vector2(x+w-i*15,yy),"75a09a" if kind!=1 else "ba8563",2)
 line(n,roof[0],roof[1],GOLD,3);line(n,roof[1],roof[2],GOLD,3)
 rect(n,x-15,y-h+4,w+30,6,"a8804d")
 var dx=x+w*.5-15
 rect(n,dx-3,y-47,36,48,"1b2c36");rect(n,dx,y-44,30,44,"805d3f")
 for i in 4:rect(n,dx+3+i*7,y-41,1,38,"ac8555")
 rect(n,dx+22,y-24,3,3,"edce83")
 for xx in [x+23,x+w-46]:
  rect(n,xx-3,y-69,29,30,"20343d");rect(n,xx,y-66,23,24,"e8a85d")
  rect(n,xx+2,y-64,19,19,"f1cc80");rect(n,xx+10,y-66,3,24,"6c654b");rect(n,xx,y-55,23,3,"6c654b")
  lamp(n,Vector2(xx+12,y-52),t)
 rune(n,Vector2(x+w/2,y-h-13),.7)
 if kind in [1,3]:
  rect(n,x+w-35,y-h-40,20,40,"40535a")
  for i in 3:
   var rise=fmod(t*14+i*17,54)
   n.draw_circle(Vector2(x+w-24+sin(t+i)*7,y-h-43-rise),5+rise*.09,Color(.64,.71,.68,.20*(1-rise/60)))
static func ship(n:Node2D,p:Vector2,stage:int,t:float,lift:float=0,gantry:bool=false):
 rect(n,p.x-97,p.y,194,12,"293d49")
 for x in range(-90,91,20):rect(n,p.x+x,p.y,8,3,"cba567")
 for x in ([] if gantry else [-75,68]):
  rect(n,p.x+x,p.y-125,7,125,"556b70")
  for j in 6:line(n,p+Vector2(x,-j*20),p+Vector2(-x,-j*20-15),Color(.4,.5,.52,.2),2)
 if stage==0:
  for x in range(-60,61,20):line(n,p+Vector2(x,-4),p+Vector2(x,-32),"c39960",3)
  return
 var q=p+Vector2(0,-lift)
 poly(n,[q+Vector2(-55,-20),q+Vector2(-36,-62),q+Vector2(36,-62),q+Vector2(55,-20)],"856f52")
 for x in [-36,36]:line(n,q+Vector2(x,-20),q+Vector2(x*.7,-86),"d0a567",5)
 if stage<2:return
 poly(n,[q+Vector2(-43,-24),q+Vector2(-34,-84),q+Vector2(-17,-109),q+Vector2(17,-109),q+Vector2(34,-84),q+Vector2(43,-24)],"547c83")
 poly(n,[q+Vector2(-22,-28),q+Vector2(-22,-84),q+Vector2(-10,-103),q+Vector2(16,-103),q+Vector2(28,-83),q+Vector2(28,-28)],"75a5a3")
 for yy in [-82,-48,-25]:rect(n,q.x-35,q.y+yy,70,5,"c9a469")
 for xx in [-50,29]:
  rect(n,q.x+xx,q.y-61,21,44,"9b774e");rect(n,q.x+xx-3,q.y-23,27,9,"223743")
  if lift>0:
   poly(n,[q+Vector2(xx,-13),q+Vector2(xx+10,20+sin(t*30)*8),q+Vector2(xx+21,-13)],"efbb69")
   poly(n,[q+Vector2(xx+5,-13),q+Vector2(xx+10,9),q+Vector2(xx+16,-13)],"b4f1dc")
 if stage>=3:
  n.draw_circle(q+Vector2(0,-76),13,Color("253d4b"));n.draw_circle(q+Vector2(0,-76),9,Color("8de2d0"))
  rune(n,q+Vector2(0,-44),.65,Color("e9c789"))
static func terrain(n:Node2D,p:Vector2,kind:int,x:int,y:int,damage:float,t:float):
 var index=clampi(kind-1,0,7)
 if kind>=9:index=1
 var tile=Vector2(ROCK.get_width()/4.0,ROCK.get_height()/2.0)
 # Sample one quadrant per world tile; each material spans a 2x2 rock face.
 var quarter=tile/2
 var region=Rect2(Vector2(index%4,index/4)*tile+Vector2(posmod(x,2),posmod(y,2))*quarter,quarter)
 n.draw_texture_rect_region(ROCK,Rect2(p,Vector2(28,28)),region,Color("a7b3bb") if kind==7 else Color.WHITE)
 if kind==9:
  for i in 3:
   var q=p+Vector2(6+i*8,10+(i%2)*4)
   line(n,q+Vector2(0,7),q+Vector2(0,-2),"d8c59d",2)
   n.draw_circle(q,4,Color("415e50"));n.draw_arc(q,4,PI,TAU,8,Color("9eaf75"),3)
   line(n,q+Vector2(-2,-2),q+Vector2(1,-3),"dbdcaa",1)
 elif kind==10:
  poly(n,[p+Vector2(4,6),p+Vector2(13,11),p+Vector2(10,22),p+Vector2(24,25),p+Vector2(16,16),p+Vector2(18,6)],"274d62")
  line(n,p+Vector2(13,11),p+Vector2(10,22),"85c9d0",2)
  n.draw_circle(p+Vector2(17,23),2,Color("b2e3db"))
 if damage>0:
  var r=damage/HoldData.TILES[kind].hp
  line(n,p+Vector2(14,3),p+Vector2(10,13),"1b2935",2)
  line(n,p+Vector2(10,13),p+Vector2(19,20),"1b2935",2)
  if r>.4:line(n,p+Vector2(10,13),p+Vector2(1,21),"1b2935",2)
  if r>.7:line(n,p+Vector2(19,20),p+Vector2(25,27),"1b2935",2)
