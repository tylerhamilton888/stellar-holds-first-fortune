class_name HoldForestry
extends RefCounted
## Pinewood is a persistent resource site. Old cuts survive migration; no automatic regrowth.
const A=preload("res://scripts/art.gd")
const BACKGROUND=preload("res://assets/pinewood-v40/pinewood.png")
const BOARD=preload("res://assets/hold-v39/expedition-table.png")
const FIR=preload("res://assets/pinewood-v40/silver-fir.png")
const X=[420.0,680.0,940.0,1200.0,1450.0,1680.0,1900.0]
const HEIGHT=[280.0,245.0,300.0,265.0,290.0,250.0,280.0]
const FALL_TIME=1.1
const HELP="3: axe  •  Hold LMB on a nearby marked trunk  •  Chop fallen logs too  •  G: basin map"

static func ensure(s:HoldState):
 while s.road_trees.size()<X.size():s.road_trees.append(8)
 for key in ["logs","fell_at","direction"]:
  if not s.forestry.get(key) is Dictionary:s.forestry[key]={}
 s.forestry["version"]=1

static func logs(s:HoldState,i:int)->int:return int(s.forestry.get("logs",{}).get(str(i),0))
static func direction(s:HoldState,i:int)->int:return int(s.forestry.get("direction",{}).get(str(i),-1 if i==X.size()-1 else 1))
static func fall_age(s:HoldState,i:int)->float:return s.elapsed-float(s.forestry.get("fell_at",{}).get(str(i),-100.0))
static func log_x(s:HoldState,i:int)->float:return X[i]+direction(s,i)*65.0

static func target(n,aim:Vector2)->Dictionary:
 if n.zone!="road" or n.room_id!="" or n.tool!=2 or not n.grounded or absf(n.player.y-410)>3:return {}
 ensure(n.state)
 var best={};var score=95.0
 for i in X.size():
  var standing=n.state.road_trees[i]>0
  if not standing and (logs(n.state,i)<=0 or fall_age(n.state,i)<FALL_TIME):continue
  var x=X[i] if standing else log_x(n.state,i)
  if absf(n.player.x-x)<(48.0 if standing else 18.0):continue
  var facing=1 if x>n.player.x else -1
  var point=Vector2(x-facing*9,379) if standing else Vector2(x,399)
  if not n.contact_reachable(point,facing):continue
  # Aim anywhere on the lower trunk; no harvesting a distant tree by facing it.
  var distance=Vector2(aim.x,clampf(aim.y,standing_y(standing),410)).distance_to(aim)
  distance+=absf(aim.x-x)
  if distance<score:
   score=distance;best={"i":i,"log":not standing,"p":point,"face":facing}
 return best

static func standing_y(standing:bool)->float:return 240.0 if standing else 377.0

static func strike(n,selected:Dictionary)->bool:
 if selected.is_empty() or n.zone!="road" or n.room_id!="" or n.tool!=2 or not n.grounded:return false
 ensure(n.state)
 var i=int(selected.i)
 if i<0 or i>=X.size() or absf(n.player.y-410)>3 or not n.contact_reachable(selected.p,int(selected.face)):return false
 var work_x=log_x(n.state,i) if selected.log else X[i]
 if absf(n.player.x-work_x)<(18.0 if selected.log else 48.0):return false
 if selected.log:
  if logs(n.state,i)<=0 or fall_age(n.state,i)<FALL_TIME:return false
  n.state.forestry.logs[str(i)]=logs(n.state,i)-1
 else:
  if n.state.road_trees[i]<=0:return false
  n.state.road_trees[i]-=1
  if n.state.road_trees[i]==0:
   n.state.forestry.logs[str(i)]=3
   n.state.forestry.fell_at[str(i)]=n.state.elapsed
   n.state.forestry.direction[str(i)]=-1 if i==X.size()-1 else (1 if i==0 else int(selected.face))
   n.notify("Timber! Chop the fallen trunk for 6 more timber. Your cuts are saved.")
 n.state.add("wood",2);HoldOnboarding.fact(n.state,"woodcut",2)
 n.sound.effect("wood",-14);n.impact_pause=.035
 n.burst(selected.p,Color("c4975c"),7)
 n.popups.append({"p":selected.p+Vector2(-24,-30),"text":"+2 TIMBER","life":1.15})
 n.shake_amount=.5 if n.state.shake else 0
 return true

static func update(n,dt:float):
 if n.zone!="road" or (n.get("surface")!=null and n.surface.active()):return
 ensure(n.state)
 for i in X.size():
  var age=fall_age(n.state,i)
  if age>=FALL_TIME and age-dt<FALL_TIME and n.state.road_trees[i]<=0:
   n.sound.effect("wood",-18)
   n.burst(Vector2(log_x(n.state,i),401),Color("9b885a"),12)

static func hint(n)->String:
 ensure(n.state)
 if absf(n.player.x-190)<80:return "E: WOODCUTTER'S BOARD   |   G: BASIN MAP   |   3: AXE"
 if n.combat.armed:return "F: put away weapon to cut timber   |   G: basin map"
 var t=target(n,n.get_global_mouse_position()+n.camera)
 if not t.is_empty():return "HOLD LMB: "+("CHOP FALLEN LOG" if t.log else "FELL MARKED FIR")+"   |   +2 TIMBER PER CUT   |   G: MAP"
 for i in X.size():
  if n.state.road_trees[i]>0 and absf(n.player.x-X[i])<48:return "STEP TO EITHER SIDE OF THE TRUNK TO SWING   |   3: AXE   |   G: MAP"
 return HELP

static func interact(n):
 if absf(n.player.x-190)<85:n.open_panel("pinewood")
 else:n.notify(HELP)

static func panel(n):
 ensure(n.state)
 n.label(n.panel_body,"The hold marks its working firs with brass bands. The old trees on the slopes shelter this cutting ground from the mountain wind.",17)
 n.label(n.panel_body,"Equip axe [3], stand beside a marked tree and hold the left mouse button over its trunk. Each solid cut gives 2 timber. After eight cuts it falls; work the fallen log for another 6 timber.",16)
 n.label(n.panel_body,"Timber builds ladders, stairs and supports, supplies the forge and helps establish your claim. I opens your pack. V shows building costs in the mine.",16)
 var standing=0;var remaining=0
 for i in X.size():
  if n.state.road_trees[i]>0:standing+=1
  remaining+=maxi(0,n.state.road_trees[i])*2+logs(n.state,i)*2+(6 if n.state.road_trees[i]>0 else 0)
 n.label(n.panel_body,"%d standing firs • %d timber left in this coupe\nCuts and fallen logs persist. Cleared trees stay cleared. Orla also sells timber if you exhaust the coupe." % [standing,remaining],16,Color("b8d6be"))
 n.button(n.panel_body,"Plan a journey [G]",func():n.open_panel("basin_map"))
 n.button(n.panel_body,"Back to the wood",func():n.close_panel())

static func draw(n,t:float,s:HoldState,canvas:Node2D=null):
 var c=n if canvas==null else canvas
 ensure(s)
 # Background and interactive plane share one scale and footing, with no sliding terrain.
 # Background surface is at source y=546; 1:1 world placement keeps all roots grounded.
 c.draw_texture_rect(BACKGROUND,Rect2(0,-136,2048,683),false)
 for i in X.size():
  if X[i]<n.camera.x-330 or X[i]>n.camera.x+1250:continue
  if s.road_trees[i]>0:
   var recoil=0.0
   if n.swing>0 and n.swing_done and int(n.forest_target.get("i",-1))==i:
    recoil=sin((1-n.swing/n.swing_duration)*PI*5)*.008
   tree(c,Vector2(X[i],410),HEIGHT[i],recoil,1.0)
   A.rect(c,X[i]-10,377,20,4,"c4a364")
   if s.road_trees[i]<8:
    var depth=(8-s.road_trees[i])*1.2
    A.poly(c,[Vector2(X[i]-10,382),Vector2(X[i]-10+depth,386),Vector2(X[i]-10,389)],"edbc80")
  else:
   stump(c,X[i])
   var age=fall_age(s,i)
   if logs(s,i)>0:
    var k=clampf(age/FALL_TIME,0,1)
    fallen_tree(c,Vector2(X[i],389),HEIGHT[i],direction(s,i)*pow(k,2)*PI*.5)
    if k>=1:log_pile(c,Vector2(log_x(s,i),410),logs(s,i),1.0)
 # A portable version of the hold's map table anchors the timber worksite.
 c.draw_texture_rect(BOARD,Rect2(126,333,128,82),false)
 A.text(c,Vector2(147,314),"PINEWOOD",14,Color("f3dfb7"))
 if absf(n.player.x-190)<85:A.text(c,Vector2(147,330),"E: FIELD BOARD",10,Color("f3dfb7"))
 # Sparse drifting needles, deterministic and bounded rather than physics particles.
 for j in 9:
  var px=fposmod(j*227+t*(6+j%3),2040)
  var py=145+fposmod(j*37+t*(8+j%4),235)
  A.line(c,Vector2(px,py),Vector2(px+3,py-1),Color(.85,.77,.43,.25),1)
 if n.panel_id=="" and not n.combat.armed:
  var selected=n.forest_target if n.swing>0 else target(n,n.get_global_mouse_position()+n.camera)
  if not selected.is_empty():
   var i=int(selected.i);var p:Vector2=selected.p
   c.draw_arc(p,9,0,TAU,24,Color("f5d89b"),1)
   var label="FALLEN LOG" if selected.log else "MARKED FIR"
   var left=logs(s,i) if selected.log else int(s.road_trees[i])
   var maximum=3.0 if selected.log else 8.0
   A.rect(c,p.x-56,298,112,33,Color(.04,.09,.09,.92))
   A.text(c,Vector2(p.x-49,311),label+"  "+str(left),11,Color("e5d4ad"))
   A.rect(c,p.x-49,318,98,4,"35483f");A.rect(c,p.x-49,318,98*left/maximum,4,"bf9b61")

static func tree(n,p:Vector2,height:float,angle:float,opacity:float):
 n.draw_set_transform(p+A.draw_offset,angle)
 # Source root tips at y=1500, trunk center x=530. Alpha exterior is empty.
 n.draw_texture_rect(FIR,Rect2(-height*530/1500,-height,height*1024/1500,height*1536/1500),false,Color(1,1,1,opacity))
 n.draw_set_transform(A.draw_offset)

static func stump(n,x:float):
 n.draw_texture_rect_region(FIR,Rect2(x-22,390,44,21),Rect2(340,1360,370,140))
 n.draw_set_transform(Vector2(x,391)+A.draw_offset,0,Vector2(1,.35))
 n.draw_circle(Vector2.ZERO,12,Color("b28a59"));n.draw_arc(Vector2.ZERO,8,0,TAU,20,Color("775331"),1.4)
 n.draw_set_transform(A.draw_offset)

static func fallen_tree(n,p:Vector2,height:float,angle:float):
 # Rotate around the cut, never resize the tree. Clip the rear cutting strip at
 # the earth surface so branches cannot draw through the solid ground below.
 var corners=[Vector2(-530,-1370),Vector2(494,-1370),Vector2(494,0),Vector2(-530,0)]
 var tex=[Vector2(0,0),Vector2(1,0),Vector2(1,1370.0/1536),Vector2(0,1370.0/1536)]
 var points:Array=[];var uvs:Array=[]
 for i in 4:points.append(p+(corners[i]*height/1500).rotated(angle))
 var clipped:Array=[]
 for i in 4:
  var a:Vector2=points[i];var b:Vector2=points[(i+1)%4]
  var uv_a:Vector2=tex[i];var uv_b:Vector2=tex[(i+1)%4]
  if a.y<=410:clipped.append(a);uvs.append(uv_a)
  if (a.y<=410)!=(b.y<=410):
   var weight=(410-a.y)/(b.y-a.y)
   clipped.append(a.lerp(b,weight));uvs.append(uv_a.lerp(uv_b,weight))
 if clipped.size()>=3:n.draw_polygon(PackedVector2Array(clipped),PackedColorArray([Color.WHITE]),PackedVector2Array(uvs),FIR)

static func log_pile(n,p:Vector2,count:int,opacity:float):
 for j in count:
  var y=p.y-5-j*7;var x=p.x-28+j*4
  n.draw_set_transform(Vector2(x,y+2)+A.draw_offset,PI*.5)
  n.draw_texture_rect_region(FIR,Rect2(-10,-57,10,57),Rect2(455,1130,125,280),Color(1,1,1,opacity))
  n.draw_set_transform(A.draw_offset)
  n.draw_circle(Vector2(x+56,y-3),5,Color(.73,.55,.33,opacity))
  n.draw_arc(Vector2(x+56,y-3),3,0,TAU,16,Color(.37,.25,.15,opacity),1)
