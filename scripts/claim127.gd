class_name HoldClaim127
extends RefCounted
# The closed contest and its journey are additive to the existing household.
const YARD=Vector2(780,800)
const STATIONS=[Vector2(650,825),Vector2(800,825),Vector2(860,825)]
const PARTS=[
 {"name":"Stone footings","cost":{"stone":6},"hint":"The ground slopes toward the river. A load must bear on level stone, not loose soil.","choices":["Level both stone seats","Pack the downhill seat with soil"],"answer":0},
 {"name":"Timber frame","cost":{"wood":4},"hint":"A square frame racks sideways under a hanging load. Triangles keep their shape.","choices":["Fit a decorative crossbar","Fit a diagonal brace"],"answer":1},
 {"name":"Winch and safety catch","cost":{"iron":2},"hint":"The operator must be able to let go without dropping the load. A pawl locks against the ratchet teeth.","choices":["Fit the locking pawl","Oil the drum and leave it free"],"answer":0}]
static func eligible(s)->bool:
 return HoldFrontier103.active(s) and HoldMountain104.data(s).get("authenticated",false)
static func data(s)->Dictionary:
 if not eligible(s):return {}
 if not s.surface.has("claim127"):
  s.surface.claim127={"version":1,"stage":0,"built":0,"scene":"","beat":0,"wards":{},"arrived":false,"welcomed":false}
 return s.surface.claim127
static func closed_score(s)->int:
 var d=HoldMountain104.data(s)
 return int(d.get("work_at_award",0))+int(d.get("allowance",0))
static func stage(s)->int:return int(data(s).get("stage",0))
static func at_yard(g)->bool:
 return eligible(g.state) and g.zone!="mine" and g.surface.area=="trail" and g.player.distance_to(YARD)<280
static func at_part(g,index:int)->bool:
 return at_yard(g) and index>=0 and index<PARTS.size() and g.player.distance_to(STATIONS[index])<70 and g.surface.clear_interaction(g.player,STATIONS[index])
static func points(g)->Array:
 if not eligible(g.state):return []
 var out=[]
 if g.surface.area=="trail" and stage(g.state) in [1,2]:
  for i in PARTS.size():out.append(g.surface.spot(STATIONS[i].x,STATIONS[i].y,PARTS[i].name+" · public lift trial","claim127"))
 return out
static func can_reception(g)->bool:
 return eligible(g.state) and data(g.state).arrived and not data(g.state).welcomed and data(g.state).wards.size()==3 and g.surface.area=="room:throne" and g.player.distance_to(HoldRoyalStage.current(g).p)<160
static func start(g,kind:String)->bool:
 if not eligible(g.state) or is_instance_valid(g.opening_scene):return false
 if g.handworks.busy_hands():g.notify("Set down your load or park your cart before joining the gathering or journey.");return false
 var d=data(g.state)
 if kind=="trial" and (d.stage!=0 or not HoldFrontier103.near(g,"lodge")):return false
 if kind=="verdict" and (d.stage!=2 or not at_yard(g)):return false
 if kind=="journey" and (d.stage<3 or d.arrived or g.surface.area!="trail"):return false
 if kind=="reception" and not can_reception(g):return false
 if kind not in ["trial","verdict","journey","reception"]:return false
 d.scene=kind;d.beat=0;g.save_game();HoldClaimScene127.start_scene(g);return true
static func complete_scene(g,kind:String):
 var d=data(g.state)
 if d.is_empty() or d.scene!=kind:return
 match kind:
  "trial":d.stage=maxi(d.stage,1)
  "verdict":
   d.stage=maxi(d.stage,3);HoldFrontier103.data(g.state).keldrath_open=true
   HoldOutpost.record(g.state,"claim127_victory","The public lift held its proof load. Ivar declared the rightful claimant. Skarrin refused the honorable office of Master of Works. A royal invitation awaits; household tenure is unchanged.")
  "journey":d.arrived=true
  "reception":
   d.welcomed=true
   HoldOutpost.record(g.state,"claim127_reception","High King Eirik received Stonebridge's claimant. The formal investiture still lies ahead. The three wards and the road home remain open.")
 d.scene="";d.beat=0
static func enter(g,area:String):
 if eligible(g.state) and data(g.state).arrived and area in ["hearthward","forgeward","crownward"]:data(g.state).wards[area]=true
static func absent(s,id:String)->bool:
 return eligible(s) and id=="road_folk:8" and stage(s)>=3
static func begin_work(g,index:int,answer:int)->bool:
 var d=data(g.state)
 if d.is_empty() or d.stage!=1 or d.built!=index or not at_part(g,index) or g.handworks.busy_hands() or is_instance_valid(g.opening_scene):return false
 if answer!=int(PARTS[index].answer):g.notify("Ivar: 'Check the load path again. Try it on the drawing before you spend the materials.'");return false
 if not g.state.afford(PARTS[index].cost):g.notify("Bring "+HoldData.cost_text(PARTS[index].cost)+" in your pack.");return false
 g.claim_work127=index;g.claim_time127=0;g.close_panel();g.notify("Hold E here to fit the part · moving away cancels · materials paid on completion");return true
static func tick(g,dt:float,held:bool):
 if g.claim_work127<0:return
 var i=int(g.claim_work127);var d=data(g.state)
 if d.is_empty() or d.stage!=1 or d.built!=i or not at_part(g,i) or g.handworks.busy_hands():cancel(g);return
 if not held:return
 g.claim_time127+=minf(dt,.1);g.surface.direction=Vector2.UP
 if g.claim_time127<2.4:return
 if g.state.pay(PARTS[i].cost):
  d.built=i+1
  if d.built==3:d.stage=2
  g.sound.effect("build");g.notify(PARTS[i].name+" fitted."+(" The proof load is ready. E at the rig to call Ivar." if d.stage==2 else " Walk to the next marked station."))
 cancel(g);g.save_game()
static func cancel(g):g.claim_work127=-1;g.claim_time127=0
static func panel(g):
 if not eligible(g.state):return
 if data(g.state).welcomed:HoldInvasion131.panel(g);return
 var d=data(g.state)
 g.label(g.panel_body,"THE RIGHTFUL CLAIMANT",22,Color("edc98a"))
 var texts=["The contribution round is closed at authentication. Your work and hereditary allowance tie Skarrin's verified total. Meet Ivar at the bunkhouse shift book for the public test.","Build a safe ore lift in the yard south of the communal forge. Read each load-path clue, choose its fitting, then hold E at the marked station. Stone, timber and iron come from your pack. There is no time limit.","All three fittings are sound. Return to the lift yard and call Ivar for the proof load and public verdict.","You won the public trial. Skarrin refused the office of Master of Works. Follow the western road to Keldrath whenever you are ready; your home, belongings and friendships remain yours."]
 if closed_score(g.state)>int(HoldMountain104.data(g.state).rival_at_award):texts[0]="The contribution round is closed. Your work exceeds Skarrin’s verified tally; he still challenges your right to lead. Meet Ivar at the bunkhouse shift book for the public test."
 g.label(g.panel_body,texts[mini(3,int(d.stage))],16)
 if d.stage==0 and HoldFrontier103.near(g,"lodge"):g.button(g.panel_body,"Gather for the public trial",func():start(g,"trial"))
 if d.stage==1:
  var i=int(d.built);var spec=PARTS[i]
  g.label(g.panel_body,"%d / 3 fittings · Next: %s · %s" % [i,spec.name,HoldData.cost_text(spec.cost)],17)
  if at_part(g,i):
   g.label(g.panel_body,spec.hint,16)
   if g.handworks.busy_hands():g.label(g.panel_body,"Set down your load or park your cart before fitting the lift.",15)
   for n in spec.choices.size():
    var answer=n;var b=g.button(g.panel_body,spec.choices[n],func():begin_work(g,i,answer));b.disabled=g.handworks.busy_hands()
  else:g.label(g.panel_body,"Walk to "+spec.name+" in the trial yard, south of the communal forge. E reads the drawing.",15)
 if d.stage==2 and at_yard(g):g.button(g.panel_body,"Call Ivar · test the lift",func():start(g,"verdict"))
 if d.arrived:
  g.label(g.panel_body,"KELDRATH · BEFORE THE INVESTITURE",20,Color("edc98a"))
  g.label(g.panel_body,"Take your time in Hearthward, Forgeward and Crownward. Stairs connect the wards. High King Eirik receives you in the Crownward royal hall after you have seen all three.",16)
  for ward in ["hearthward","forgeward","crownward"]:g.label(g.panel_body,("✓ " if d.wards.has(ward) else "○ ")+ward.capitalize(),16)
  if can_reception(g):g.button(g.panel_body,"Present the Stonebridge invitation",func():start(g,"reception"))
  if d.welcomed:g.label(g.panel_body,"The King has received your claim. This story chapter is complete; keep exploring Keldrath or take King's Gate home to Stonebridge.",16)
static func draw_rig(g,p:Vector2,built:int,lift:float=0):
 # Shared painted materials at character scale; ropes and load travel are live.
 for x in [-42,42]:
  if built>0:HoldFurnishings.draw(g,p+Vector2(x,0),"plinth")
 if built>1:
  var timber=Color("765238");var edge=Color("c49a66")
  for segment in [[Vector2(-42,-18),Vector2(-42,-130)],[Vector2(42,-18),Vector2(42,-130)],[Vector2(-48,-130),Vector2(48,-130)],[Vector2(-42,-30),Vector2(42,-115)]]:
   g.draw_line(p+segment[0],p+segment[1],timber,12,true);g.draw_line(p+segment[0]+Vector2(-2,0),p+segment[1]+Vector2(-2,0),edge,2,true)
 if built>2:
  g.draw_circle(p+Vector2(0,-126),9,Color("515d60"));g.draw_arc(p+Vector2(0,-126),9,0,TAU,20,Color("bdad84"),2,true)
  g.draw_line(p+Vector2(0,-126),p+Vector2(0,-24-lift),Color("cfb78d"),3,true)
 HoldFurnishings.draw(g,p+Vector2(0,-lift),"crate")
static func draw(g):
 if not eligible(g.state) or g.surface.area!="trail" or (stage(g.state)==0 and not g.opening_scene is HoldClaimScene127):return
 var d=data(g.state);var lift=0.0
 if g.opening_scene is HoldClaimScene127:lift=g.opening_scene.load_height
 draw_rig(g,YARD,int(d.built),lift)
 var rival_lift=0.0
 if g.opening_scene is HoldClaimScene127 and g.opening_scene.mode=="verdict" and g.opening_scene.step==1:
  var t=g.opening_scene.age
  rival_lift=52*smoothstep(0,1.2,t)*(1-smoothstep(1.8,2.4,t))
 draw_rig(g,Vector2(550,800),3,rival_lift)
 if g.opening_scene is HoldThaneScene131:return
 g.surface.plaque(Vector2(550,685),"Skarrin's trial lift")
 g.surface.plaque(Vector2(780,650),"Your trial lift")
 for i in 3:
  var color=Color("78b2a2") if i<int(d.built) else Color("e1c285")
  g.draw_arc(STATIONS[i],23,0,TAU,24,color,2,true)
  if not is_instance_valid(g.opening_scene):g.surface.plaque(STATIONS[i]+Vector2(0,44),str(i+1)+" · "+PARTS[i].name)
 if g.claim_work127>=0:
  g.draw_rect(Rect2(g.player+Vector2(-28,15),Vector2(56,5)),Color("172a30"))
  g.draw_rect(Rect2(g.player+Vector2(-28,15),Vector2(56*clampf(g.claim_time127/2.4,0,1),5)),Color("e1c285"))
