class_name HoldScenery
extends RefCounted
const MAP_TABLE=preload("res://assets/hold-v39/expedition-table.png")
const WEST_GALLERY=preload("res://assets/opening-v35/west-gallery.webp")
const A=preload("res://scripts/art.gd")
const GANTRY=preload("res://assets/industry-v30/freight-gantry.png")
const POWERED=preload("res://assets/industry-v30/powered-workshop.png")
const ENGINEERING=preload("res://assets/industry-v30/engineering-bay.png")
const MACHINERY=preload("res://assets/scenery/pithead-beacon.png")
const COLD_WORKSHOPS=preload("res://assets/scenery/foreground-workshops-cold.png")
const WORKSHOPS=preload("res://assets/scenery/foreground-workshops.png")
static func platform(n:Node2D,outside:bool=false):
 # A worn, bevelled terrace with a heavy retaining wall below it.
 A.rect(n,0,410,2040,90,"202f38")
 for i in 52:
  var x=i*40
  var top=410+posmod(i*7,3)
  A.poly(n,[Vector2(x,top),Vector2(x+37,top-1),Vector2(x+41,422),Vector2(x+3,424)],"7f8580" if i%3 else "92948a")
  A.line(n,Vector2(x+3,top+2),Vector2(x+34,top+1),"b6ae94")
  A.line(n,Vector2(x+3,422),Vector2(x+38,420),"35434a",2)
  A.line(n,Vector2(x+11,top+4),Vector2(x+18,top+3),"616f70")
  if i%4==1:A.line(n,Vector2(x+29,top+1),Vector2(x+26,top+7),"3d4f58")
 A.rect(n,0,424,2040,5,"a1987e");A.rect(n,0,429,2040,5,"475963")
 for row in 3:
  for i in 28:
   var x=i*76-38*(row%2);var y=435+row*24
   A.poly(n,[Vector2(x+2,y+1),Vector2(x+72,y),Vector2(x+75,y+18),Vector2(x+69,y+22),Vector2(x+3,y+21)], [Color("41515a"),Color("394b55"),Color("4d5a60")][posmod(i+row,3)])
   A.line(n,Vector2(x+6,y+2),Vector2(x+68,y+1),"637074")
   A.line(n,Vector2(x+8,y+18),Vector2(x+69,y+18),"283d48")
   for j in 3:A.rect(n,x+10+j*19,y+6+posmod(i+j,7),5,1,"536469")
 for i in 12:
  var x=i*184+24
  A.poly(n,[Vector2(x,430),Vector2(x+18,430),Vector2(x+27,500),Vector2(x-8,500)],"283c47")
  A.rect(n,x+3,433,10,65,"727b77");A.rect(n,x+5,435,2,62,"a99e80")
  if not outside:
   for y in [443,474]:A.rect(n,x+1,y,14,5,"a58a59");A.rect(n,x+7,y+1,2,2,"dbc08a")
 if not outside:
  for i in 85:A.rect(n,i*24,475,6,18,"604a36")
  for y in [477,490]:A.rect(n,0,y,2040,3,"819393");A.rect(n,0,y,2040,1,"bac3b8")
 else:
  for i in 35:
   var x=i*59+11
   A.poly(n,[Vector2(x,410),Vector2(x+2,403),Vector2(x+4,410),Vector2(x+8,405),Vector2(x+7,412)],"6b7d65")
static func facade(n:Node2D,x:float,width:float,kind:int,t:float,lit:bool=true):
 var region=Rect2(1481,10,691,678)
 var size=Vector2(183,180)
 if kind==1 or kind==2:region=Rect2(717,40,751,648);size=Vector2(224,194)
 elif kind==3:region=Rect2(11,10,699,680);size=Vector2(211,205)
 var center=x+width*.5
 # Wide contact shadow under a real foundation, not a floating rectangular kiosk.
 A.poly(n,[Vector2(center-size.x*.58,408),Vector2(center-size.x*.44,398),Vector2(center+size.x*.44,398),Vector2(center+size.x*.60,410)],Color(0.02,.07,.10,.48))
 var tint=Color("c3d4ca") if kind==2 else Color.WHITE
 var texture=COLD_WORKSHOPS if kind==3 and not lit else WORKSHOPS
 var ratio=Vector2(float(texture.get_width())/2172.0,float(texture.get_height())/724.0)
 n.draw_texture_rect_region(texture,Rect2(Vector2(center-size.x*.5,410-size.y),size),Rect2(region.position*ratio,region.size*ratio),tint)
 if kind==3 and lit:
  for i in 4:
   var q=Vector2(center-9+i*7,379)
   A.poly(n,[q, q+Vector2(3,-11-sin(t*10+i)*4),q+Vector2(7,0)],Color(1,.65,.23,.45))
static func west_gallery(n:Node2D,_t:float):
 # The wall closes the concourse; its recessed stair connects to the hold plan.
 n.draw_texture_rect_region(WEST_GALLERY,Rect2(-100,150,280,260),Rect2(20,37,1219,1147))
static func hall(n:Node2D,t:float,s:HoldState):
 west_gallery(n,t)
 facade(n,145,160,0,t)
 facade(n,330,164,1,t)
 facade(n,615,156,2,t)
 if HoldIndustry.tier(s,"hold")==0:facade(n,890,154,3,t,s.opening>=2)
 else:industry_facade(n,967,t,s,"hold")
 facade(n,1145,120,0,t)
 facade(n,1710,140,0,t)
 # A carved portal and winch housing share the workshop material language.
 expedition_table(n,Vector2(1465,410))
 # Low, supported service conduit follows the foundations.
 for x in range(1090,1355,44):
  A.rect(n,x,394,5,16,"4c5f66")
  A.rect(n,x-2,406,9,4,"8d8d7b")
 for y in [395,399]:A.rect(n,1085,y,270,3,"74634b")
 if s.opening>=4:
  for x in range(1090,1350,44):A.rect(n,x+8,396,8,2,"7acbbb")
 pithead(n,1942,410,120,135,t,false)
 powered_gate(n,1942,410,HoldIndustry.tier(s,"hold"),t)
 for x in [270,565,820,1110,1320,1600,1880]:
  A.rect(n,x,349,4,61,"778581");A.lamp(n,Vector2(x+2,345),t)
 for x in [301,790,1345]:A.crate(n,Vector2(x,410),.8)
 for x in [510,840]:A.barrel(n,Vector2(x,410))
 platform(n)
static func road(n:Node2D,t:float,s:HoldState):
 HoldForestry.draw(n,t,s)
static func camp(n:Node2D,t:float,s:HoldState,lift:float=0):
 # Your empty concession grows visibly into a workshop and powered freight stop.
 A.poly(n,[Vector2(65,410),Vector2(145,330),Vector2(230,410)],"6b776d")
 A.poly(n,[Vector2(145,330),Vector2(145,410),Vector2(230,410)],"475b58")
 A.poly(n,[Vector2(130,410),Vector2(145,362),Vector2(165,410)],"152b33")
 if s.camp_stage>=1:
  A.rect(n,855,396,224,14,"77847d")
  for i in 8:A.rect(n,858+i*28,397,25,11,"a4a58b")
 if s.camp_stage>=2:
  if HoldIndustry.tier(s)==0:facade(n,886,162,3,t)
  else:industry_facade(n,967,t,s,"claim")
  A.rect(n,1063,375,24,35,"465d67");A.rune(n,Vector2(1075,389),.65,Color("94d4c4"))
 if s.camp_stage>=3:
  n.draw_texture_rect_region(MACHINERY,Rect2(1151,266,76,144),Rect2(1110,220,400,760))
  A.rune(n,Vector2(1189,315),.4,Color(.6,1,.85,.3+sin(t*2)*.15))
 pithead(n,1465,410,190,180,t,true)
 powered_gate(n,1465,410,HoldIndustry.tier(s),t)
 freight_yard(n,1780,410,HoldIndustry.tier(s),t,not s.queue.is_empty())
 A.ship(n,Vector2(1780,410),s.ship_stage,t,lift,HoldIndustry.tier(s)>0)
 A.crate(n,Vector2(320,410));A.barrel(n,Vector2(350,410))
 platform(n,true)

static func fir(n:Node2D,p:Vector2,seed:int,cut:bool):
 A.rect(n,p.x-5,p.y-14,10,14,"806b4c");A.rect(n,p.x-3,p.y-14,2,14,"b09164")
 if cut:return
 A.rect(n,p.x-4,p.y-119,8,110,"6a5b46")
 for j in range(6):
  var y=p.y-140+j*17
  var w=12+j*5
  A.poly(n,[Vector2(p.x,y-15),Vector2(p.x-w,y+24),Vector2(p.x-w*.35,y+20),Vector2(p.x,y+27),Vector2(p.x+w*.3,y+20),Vector2(p.x+w,y+24)],"243f43")
  A.poly(n,[Vector2(p.x-1,y-12),Vector2(p.x-w+4,y+20),Vector2(p.x-3,y+15),Vector2(p.x+w-5,y+21)],"385853")
  for i in range(-2,3):
   var q=p.x+i*(w/3.0)
   A.line(n,Vector2(q,y+13+abs(i)*2),Vector2(q-4,y+17+abs(i)*2),"668074")
 # A bronze band marks timber the hold permits employees to harvest.
 A.rect(n,p.x-5,p.y-25,10,4,"c6a064")

static func pithead(n:Node2D,x:float,y:float,w:float,h:float,t:float,moving:bool):
 n.draw_texture_rect_region(MACHINERY,Rect2(x-w*.5,y-h,w,h),Rect2(25,20,1075,960))
 if moving:
  var lift_y=y-24-(sin(t*.65)*.5+.5)*h*.32
  var half=w*.085
  A.rect(n,x-half-2,lift_y,half*2+4,6,"263b45")
  A.rect(n,x-half,lift_y,half*2,2,"adb5a5")
  for side in [-1,1]:
   A.rect(n,x+side*half,lift_y-20,2,20,"ac9563")
   A.line(n,Vector2(x+side*half,y-h*.63),Vector2(x+side*half,lift_y-20),"758d91")

static func industry_facade(n:Node2D,x:float,t:float,s,site:String):
 var tier=HoldIndustry.tier(s,site)
 var tex=ENGINEERING if tier==2 else POWERED
 var size=Vector2(247,174) if tier==2 else Vector2(224,185)
 A.poly(n,[Vector2(x-126,410),Vector2(x-111,401),Vector2(x+110,401),Vector2(x+128,410)],Color(.02,.07,.1,.5))
 var source=Rect2(0,23,1447,1008) if tier==2 else Rect2(16,0,1347,1127)
 n.draw_texture_rect_region(tex,Rect2(Vector2(x-size.x*.5,410-size.y),size),source)
 # Productive work alone drives the visible press and indicator.
 var busy=not s.queue.is_empty()
 var y=375+(sin(t*8)*3 if busy else 0)
 if tier==1:
  A.rect(n,x-8,y-10,16,5,"738783");A.rect(n,x-7,y-10,14,1,"d2d6bd")
 else:
  A.rect(n,x-10,398,25,3,"5a6c72")
  if busy:A.rect(n,x-10+fmod(t*18,22),398,3,2,"dbb070")
 if busy:A.rect(n,x+55,365,3,4,Color("97e2c5"))

static func powered_gate(n:Node2D,x:float,y:float,tier:int,t:float):
 if tier==0:return
 # Supported steel pressure frame retrofitted inside the old masonry portal.
 for side in [-1,1]:
  A.rect(n,x+side*33-3,y-80,6,80,"354b56")
  A.rect(n,x+side*33-2,y-78,2,76,"91a09c")
  A.rect(n,x+side*33-7,y-5,14,5,"647679")
  for j in 4:A.rect(n,x+side*33-1,y-65+j*16,2,2,"cfb183")
 A.rect(n,x-37,y-83,74,7,"465c63");A.rect(n,x-36,y-83,72,2,"a0a99b")
 A.rect(n,x-12,y-80,24,4,"243b45")
 for j in 3:A.rect(n,x-9+j*7,y-79,4,2,"81cdb9")
 if tier==2:
  for side in [-1,1]:
   A.rect(n,x+side*38-4,y-61,8,38,"526a70")
   A.rect(n,x+side*38-2,y-59,4,33,"b4afa0")
  A.line(n,Vector2(x-28,y-72),Vector2(x+28,y-72),Color(.5,.95,.85,.3+sin(t*1.2)*.1),1)

static func freight_yard(n:Node2D,x:float,y:float,tier:int,t:float,busy:bool):
 if tier==0:return
 n.draw_texture_rect_region(GANTRY,Rect2(x-145,y-147,290,147),Rect2(26,23,1730,846))
 # Lift cable moves within the painted frame only while the workshop is active.
 var cable=17+(sin(t*.9)*6 if busy else 0)
 A.line(n,Vector2(x,y-106),Vector2(x,y-106+cable),"b6b7a2",1)
 A.rect(n,x-3,y-106+cable,6,3,"ba9764")
 if tier==2:
  A.rect(n,x+124,y-33,3,8,"93dfce")
  A.line(n,Vector2(x+118,y-14),Vector2(x+96,y-14),"a68b5e",2)

static func expedition_table(n:Node2D,p:Vector2):
 n.draw_texture_rect(MAP_TABLE,Rect2(p-Vector2(79,100),Vector2(158,105)),false)
 A.text(n,p+Vector2(-56,-105),"EXPEDITION TABLE",12,Color("ead4a0"))
