class_name HoldThaneScene131
extends HoldClaimScene127
const BATTLE=preload("res://assets/thane131/eirik-battle-return.png")
const RETURN133=preload("res://assets/trolls133/return.png")
const RETURN_BOXES133=[Rect2(86,27,608,429),Rect2(821,27,644,436),Rect2(50,538,662,441),Rect2(787,577,719,382)]
const RETURN_ROOTS133=[Vector2(299,442),Vector2(1036,445),Vector2(275,956),Vector2(993,944)]
const BOXES=[[0, 4, 444, 486], [444, 8, 444, 482], [888, 0, 444, 490], [1332, 0, 441, 490], [0, 490, 444, 397], [444, 490, 444, 397], [888, 490, 444, 397], [1332, 490, 442, 381]]
var royal={}
var foes=[]
var choice_buttons=[]
static func start_scene(g):
 if is_instance_valid(g.opening_scene):return
 var d=HoldInvasion131.data(g.state)
 if d.is_empty() or d.scene=="":return
 if d.scene not in ["ceremony","king","return","trial","investiture","home"]:d.scene="";d.beat=0;g.save_game();return
 var scene=HoldThaneScene131.new();scene.game=g;scene.mode=d.scene;scene.step=int(d.beat)
 g.close_panel();g.sound.stop_voice();g.fight.cancel_actions();g.invasion_work131=false
 g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer);g.opening_scene=scene;scene.layer.add_child(scene)
func _ready():
 game.ui.visible=false
 lines=HoldThaneLines131.lines(game,mode)
 step=clampi(step,0,lines.size()-1)
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=false
 game.sync_hud_controls()
 var ui=Control.new();ui.theme=game.ui.theme;add_child(ui)
 var top=ColorRect.new();top.size=Vector2(960,46);top.color=Color("101f2b");ui.add_child(top)
 scene_title=Label.new();scene_title.position=Vector2(26,10);scene_title.modulate=Color("edc98a");ui.add_child(scene_title)
 var bg=ColorRect.new();bg.position=Vector2(0,398);bg.size=Vector2(960,142);bg.color=Color("101f2b");ui.add_child(bg)
 speaker=Label.new();speaker.position=Vector2(26,409);speaker.modulate=Color("edc98a");speaker.add_theme_font_size_override("font_size",17);ui.add_child(speaker)
 caption=Label.new();caption.position=Vector2(26,437);caption.size=Vector2(716,97);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",16);ui.add_child(caption)
 next_button=game.button(ui,"Continue · Enter",advance);next_button.position=Vector2(765,462);next_button.size=Vector2(175,48)
 var skip=game.button(ui,"Skip scene · Esc",finish);skip.position=Vector2(775,5);skip.size=Vector2(165,35)
 show_line()
func actor(id:String,p:Vector2,target:Vector2)->Dictionary:
 var a=super.actor(id,p,target)
 if not id.begins_with("road_folk:") and not id.begins_with("lodge_folk:"):a.profile=game.state.npc(id);HoldWholeFrames.prepare_profile(a.profile)
 return a
func add_actor(id:String,p:Vector2,to:Vector2):
 var a=HoldInvasion131.point(game,p);var b=HoldInvasion131.point(game,to)
 if not game.fight.clear(a,b):b=a
 cast.append(actor(id,a,b))
func show_line():
 age=0;cast.clear();foes.clear();duration=2.0
 var d=HoldInvasion131.data(game.state);d.beat=step
 speaker.text=lines[step][0];caption.text=lines[step][1]
 if mode=="ceremony" and step==3:caption.text=("You accepted the challenge without surrendering your claim. " if d.duel=="accept" else "You refused to make your neighbors' future a private wager. ")+caption.text
 if mode=="trial" and step==2:caption.text={"justice":"You ask that the grudge be answered lawfully. ","mercy":"You ask whether a life of service could repay any part of the harm. ","lament":"You mourn the good he could have done, without excusing what he chose. "}.get(d.trial,"")+caption.text
 scene_title.text={"ceremony":"THE INTERRUPTED OATH","king":"THE KING HOLDS THE STAIRS","return":"THE KING RETURNS","trial":"JUDGMENT BEFORE THE HOLD","investiture":"THANE OF STONEBRIDGE","home":"THE FIRST FORTUNE"}[mode]+" · "+str(step+1)+" / "+str(lines.size())
 next_button.text="Return to play" if step==lines.size()-1 else "Continue · Enter";next_button.disabled=true
 for b in choice_buttons:b.queue_free()
 choice_buttons.clear()
 if needs_choice():
  var values=["accept","refuse"] if mode=="ceremony" else ["justice","mercy","lament"]
  var labels=["Accept the duel","Refuse the duel"] if mode=="ceremony" else ["Ask for justice","Ask for mercy","Mourn what he wasted"]
  for i in values.size():
   var value=values[i];var b=game.button(next_button.get_parent(),labels[i],func():
    if HoldInvasion131.choose(game,"duel" if mode=="ceremony" else "trial",value):step+=1;show_line())
   b.position=Vector2(30+i*300,345);b.size=Vector2(280,43);choice_buttons.append(b)
 if mode=="ceremony" and step==5:
  locate("hearthward",HoldInvasion131.point(game,Vector2(1430,670)));royal={};duration=3.5;target_camera=Vector2(1090,285)
  add_actor("borin",Vector2(1460,640),Vector2(1435,650))
  for i in 3:
   var p=HoldInvasion131.point(game,Vector2(1540+i*35,460),20)
   var e=game.fight.make_enemy("breach_"+str(i),p,2 if i==2 else 0);e.to=HoldInvasion131.point(game,Vector2(1530+i*45,615+i*15),20);e.dir=Vector2.DOWN;foes.append(e)
 elif mode in ["ceremony","trial","investiture"]:
  locate("room:throne",Vector2(550,730));game.surface.direction=Vector2.UP
  royal={"from":Vector2(650,500),"to":Vector2(650,550),"p":Vector2(650,500)}
  add_actor("ivar",Vector2(530,670),Vector2(530,650));add_actor("borin",Vector2(770,720),Vector2(770,700));add_actor("orla",Vector2(790,735),Vector2(790,715))
  if mode=="ceremony" and step>=2:add_actor("road_folk:8",Vector2(650,900) if step==2 else Vector2(650,680),Vector2(650,680) if step<5 else Vector2(650,1000))
  if mode=="trial" and step<4:add_actor("road_folk:8",Vector2(650,630),Vector2(650,630))
  target_camera=Vector2(170,395)
 elif mode=="king":
  locate("hearthward",HoldInvasion131.point(game,Vector2(390,925)));game.surface.direction=Vector2.RIGHT
  royal={"from":Vector2(450,925) if step==1 else Vector2(520,925),"to":Vector2(520,925),"p":Vector2(520,925)}
  if step==0:royal.p=Vector2(450,925);royal.from=royal.p;royal.to=royal.p
  for i in 5:
   var p=HoldInvasion131.point(game,[Vector2(650,933),Vector2(880,840),Vector2(1160,830),Vector2(820,933),Vector2(960,933)][i],float(HoldEnemyRoster.spec(3).body))
   var e=game.fight.make_enemy("royal_troll_"+str(i),p,3);e.dir=Vector2.LEFT;e.state="windup" if step==2 and i==0 else "idle";e.time=1.0;e.fist133=0;foes.append(e)
  duration=3.0;target_camera=Vector2(320,550)
 elif mode=="return":
  locate("crownward",HoldInvasion131.point(game,Vector2(780,835)))
  royal={"from":Vector2(1040,890) if step==1 else Vector2(870,890),"to":Vector2(870,890),"p":Vector2(870,890)}
  if step==0:royal.p=Vector2(1400,890);royal.from=royal.p;royal.to=royal.p
  add_actor("ivar",Vector2(660,800),Vector2(660,780));add_actor("borin",Vector2(620,720),Vector2(640,720));add_actor("orla",Vector2(900,830),Vector2(890,830))
  duration=3;target_camera=Vector2(350,540)
 else:
  locate("trail",Vector2(760,905));royal={}
  add_actor("ivar",Vector2(650,920),Vector2(690,920));add_actor("road_folk:11",Vector2(850,900),Vector2(850,900));add_actor("lodge_folk:1",Vector2(600,850),Vector2(600,850));add_actor("lodge_folk:2",Vector2(880,970),Vector2(880,970))
  target_camera=Vector2(280,625)
 if not royal.is_empty():
  royal.from=HoldInvasion131.point(game,royal.from);royal.to=HoldInvasion131.point(game,royal.to)
  if not game.fight.clear(royal.from,royal.to):royal.from=royal.to
  royal.p=royal.from
 game.camera=target_camera;game.save_game();game.queue_redraw();queue_redraw()
func needs_choice()->bool:
 var d=HoldInvasion131.data(game.state)
 return (mode=="ceremony" and step==2 and d.duel=="") or (mode=="trial" and step==1 and d.trial=="")
func tick(dt:float):
 if finished or HoldFolk.warming():return
 age+=dt;clock+=dt;game.clock+=dt
 for a in cast:
  var old:Vector2=a.p;a.p=a.from.lerp(a.to,smoothstep(0,duration,age));a.moving=a.p.distance_to(old)>.01
  if a.moving:a.aim=(a.p-old).normalized();a.gait+=HoldDrawnLocomotion.time_for_distance(a.p.distance_to(old))
 if not royal.is_empty():royal.p=royal.from.lerp(royal.to,smoothstep(0,duration,age))
 if mode=="ceremony" and step==5:
  for e in foes:e.p=e.home.lerp(e.to,smoothstep(.3,duration,age));e.walk=age<duration;e.gait=age*.45
 if mode=="king" and step==2 and age>1.2:
  foes[0].state="stun";foes[0].p=foes[0].home+Vector2(45*smoothstep(1.2,2,age),0)
 next_button.disabled=age<duration or needs_choice();game.queue_redraw();queue_redraw()
func advance():
 if finished or age<duration or needs_choice():return
 if step==lines.size()-1:finish();return
 step+=1;show_line()
func finish():
 if finished:return
 # Skip cannot invent a duel or trial response. Stop at its explicit choice.
 var d=HoldInvasion131.data(game.state)
 if mode=="ceremony" and d.duel=="":step=2;show_line();return
 if mode=="trial" and d.trial=="":step=1;show_line();return
 if not HoldInvasion131.complete_scene(game,mode):return
 finished=true;game.ui.visible=true;game.opening_scene=null;game.velocity=Vector2.ZERO;game.walking_pose=false;game.swing=0
 if mode=="ceremony":locate("crownward",Vector2(650,800))
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 game.surface.roads.portal_cooldown=1;game.camera=game.surface.camera_target();game.notify(HoldInvasion131.goal(game));game.save_game();game.update_hud();game.queue_redraw();layer.queue_free()
func objects()->Array:
 var out=[]
 for i in cast.size():out.append({"kind":"thane_actor131","p":cast[i].p,"index":i})
 if not royal.is_empty():out.append({"kind":"thane_king131","p":royal.p})
 if mode=="ceremony" and step==5:out.append({"kind":"thane_gate131","p":Vector2(1570,455)})
 for i in foes.size():out.append({"kind":"thane_troll131","p":foes[i].p,"index":i})
 return out
func draw_royal():
 var p:Vector2=royal.p
 if mode=="return":
  var f=[1,0,2,0][int(age*4)%4] if step==1 and age<duration else 0
  var r:Rect2=RETURN_BOXES133[f];var anchor:Vector2=RETURN_ROOTS133[f]
  game.draw_texture_rect_region(RETURN133,Rect2(p+(r.position-anchor)*.18,r.size*.18),r);return
 if mode not in ["king","return"] and not (mode=="trial" and step==3):
  HoldRoyalStage.draw_actor(game,HoldRoyalStage.actor(p,12,Vector2.DOWN,age*.25,age<duration));return
 var frame=0
 if mode=="return":frame=[4,5,7,5][int(age*4)%4] if step==1 and age<duration else 5
 elif mode=="king" and step==2 or mode=="trial" and step==3:frame=mini(3,int(age/0.45))
 var box=BOXES[frame];var r=Rect2(box[0],box[1],box[2],box[3]);var root=Vector2([210,650,1075,1500,185,625,1065,1505][frame],430 if frame<4 else 840);var scale=.235
 game.draw_texture_rect_region(BATTLE,Rect2(p+(r.position-root)*scale,r.size*scale),r)
func _draw():
 if mode=="trial" and step==3 and age>1.0 and age<1.7:draw_rect(Rect2(0,46,960,352),Color(0.025,0.04,0.05,1))

func draw_gate():
 var p=Vector2(1570,455)+Vector2(115*smoothstep(0,1.8,age),0)
 game.draw_line(p+Vector2(-65,-15),p+Vector2(65,-15),Color("4c3d30"),12,true)
 game.draw_line(p+Vector2(-65,-18),p+Vector2(65,-18),Color("bca177"),2,true)
 for x in [-45,45]:game.draw_rect(Rect2(p+Vector2(x-4,-21),Vector2(8,12)),Color("68777b"))
