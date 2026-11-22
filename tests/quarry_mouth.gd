extends SceneTree
var g
var w
var out:String
var frames:String
var n=0
var checks=0
var failed=false
var record=false
var stats:FileAccess
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 checks+=1
 if not ok:push_error(label);failed=true
func shot(label:String=""):
 g.queue_redraw()
 await process_frame
 await RenderingServer.frame_post_draw
 var im=root.get_texture().get_image()
 if label!="":im.save_png(out+"/"+label+".png")
 if record:
  im.save_jpg(frames+"/%04d.jpg"%n,.93);stats.store_line("%d,%d"%[n,w.depth()]);n+=1
func freeze():
 g.set_process(false);g.transition_left=0;g.transition_shade.visible=false;g.loading_view._process(1);g.loading_view._process(1);g.ui.hide()
func walk(key:String,target:float):
 var horizontal=key in ["left","right"];var positive=key in ["right","down"]
 var depth=w.depth();var flips=0;var ticks=0
 Input.action_press(key)
 while ticks<550:
  var at=g.player.x if horizontal else g.player.y
  if (positive and at>=target-.3) or (not positive and at<=target+.3):break
  var before:Vector2=g.player;g.clock+=1./48
  g.deep.move(1./48);g.deep.mine(1./48)
  if g.player.distance_to(before)>8:check(false,"feet snapped")
  if depth!=w.depth():
   depth=w.depth();flips+=1;check(g.transition_left<=0,"continuous crossing")
  g.camera=g.camera.lerp(g.player-Vector2(480,318),.055)
  if record and ticks%2==0:await shot()
  ticks+=1
 Input.action_release(key)
 check(ticks<550,"walk "+key+" to "+str(target)+" ended "+str(g.player))
 return flips
func pause_frames(count:int):
 g.walking_pose=false
 for i in count:await shot()
func dig(c:Vector2i):
 var v=w.center(c)-g.camera
 root.warp_mouse(v)
 var motion=InputEventMouseMotion.new();motion.position=v;motion.global_position=v
 root.push_input(motion,true)
 await process_frame
 check(w.at(c)>0 and w.target(g.player,g.world_mouse(),52)==c,"pick targets "+str(c)+" from "+str(g.player))
 if failed:return
 for swing in 10:
  if w.at(c)==0:break
  g.mining_buffer=.12;g.deep.mine(1./48)
  check(g.deep.target==c and g.deep.strike_left>0,"pick swing begins")
  if failed:return
  for tick in 52:
   g.clock+=1./48;g.deep.mine(1./48)
   if tick%2==0 and record:await shot()
 check(w.at(c)==0,"native pick freed "+str(c))
func run():
 var args=OS.get_cmdline_user_args();out=args[1];frames=out.get_base_dir()+"/frames"
 DirAccess.make_dir_recursive_absolute(out);DirAccess.make_dir_recursive_absolute(frames)
 var scene=load("res://furrow/start.tscn").instantiate();root.add_child(scene)
 g=scene.get_child(0).get_child(0)
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 root.size=Vector2i(960,540);root.content_scale_size=root.size
 w=g.deep.world;freeze();g.hotbar.select(0)
 var S=load("res://quarry/quarry_slope.gd");var Q=load("res://quarry/buried_quarry.gd")
 var a=S.anchor(w);var bench=Q.bench(w.data.quarry);var c=S.mouth_cell(w,bench.x,a)
 var apron=w.center(c+Vector2i.DOWN);var entrance=w.center(c)
 var upper_before=w.layer(0).cells.duplicate()
 g.camera=g.player-Vector2(480,318);g.deep.reveal_clock=0;g.deep.move(.2)
 print("START ",g.player," rock ",w.at(c)," deeper ",w.at(c+Vector2i.UP)," adjacent ",w.at(c+Vector2i.RIGHT)," apron ",apron)
 check(w.depth()==1 and not S.mouth_open(w,c.x,a),"starts at uncut face")
 stats=FileAccess.open(frames+"/depth.csv",FileAccess.WRITE);record=true
 await shot("before");await pause_frames(8)
 await dig(c)
 if failed:quit(1);return
 check(S.mouth_open(w,c.x,a) and not S.mouth_open(w,c.x+1,a),"only the mined column opens")
 await walk("left",entrance.x-44)
 for tick in 50:g.deep.mine(1./30)
 await shot("single");await pause_frames(10)
 await walk("right",entrance.x);await walk("up",entrance.y)
 check(w.cell(g.player)==c and w.depth()==1,"entered under upper shelf")
 await dig(c+Vector2i.UP)
 if failed:quit(1);return
 await walk("up",entrance.y-40);await shot("inside")
 var inside=g.player;g.save_game();g.start_game(true);w=g.deep.world;freeze();g.camera=g.player-Vector2(480,318)
 check(w.depth()==1 and g.player.distance_to(inside)<3 and w.at(c+Vector2i.UP)==0 and S.mouth_open(w,c.x,a),"reloaded inside tunnel")
 await walk("down",apron.y+5);await walk("right",entrance.x+40)
 await dig(c+Vector2i.RIGHT)
 if failed:quit(1);return
 check(S.mouth_open(w,c.x,a) and S.mouth_open(w,c.x+1,a),"adjacent cuts join")
 await walk("right",entrance.x+91)
 for tick in 50:g.deep.mine(1./30)
 await shot("double");await pause_frames(12)
 await walk("left",entrance.x+40)
 var e=InputEventKey.new();e.keycode=KEY_E;e.pressed=true
 g.handworks.input(e)
 var cargo=g.handworks.data().carry
 check(not cargo.is_empty(),"picked up stone from face")
 if failed:quit(1);return
 var item=g.handworks.raw_item(cargo[0]);var units=int(cargo[0].units)
 await walk("right",a.x+164);await walk("up",S.road_y(a.x+164,a))
 var crossings=await walk("left",a.x-140)
 check(crossings==1 and w.depth()==0,"climbed onto upper floor")
 await walk("left",w.center(bench).x+50)
 await walk("up",w.center(bench).y-28)
 var f=g.handworks.facility()
 check(not f.is_empty() and f.get("quarry_bench",false),"reached original bench")
 var before=int(g.state.inventory.get(item,0))
 g.handworks.input(e);Input.action_press("interact")
 for t in 150:
  g.clock+=1./48;g.handworks.update(1./48)
  if t==30:await shot("working")
  elif t%2==0:await shot()
 Input.action_release("interact")
 check(int(g.state.inventory.get(item,0))>=before+units,"overhead bench processed the recovered load")
 check(upper_before==w.layer(0).cells,"upper shelf cells preserved")
 await shot("bench")
 g.save_game();g.start_game(true);w=g.deep.world
 check(S.mouth_open(w,c.x+1,a) and w.data.links[w.link_key(w.cell(a),0)].kind=="ramp","widened mouth and ramp saved")
 stats.close()
 print("ADIT ",checks," checks; failed=",failed," item=",item," units=",units," frames=",n)
 quit(1 if failed else 0)
