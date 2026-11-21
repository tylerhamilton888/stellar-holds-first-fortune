extends SceneTree
var g
var w
var start:Vector2
var failures=[]
var sequence=0
var film=false
var SHOTS=""
func _initialize():call_deferred("run")
func check(ok:bool,message:String):
 if not ok:failures.append(message)
func run():
 SHOTS=OS.get_user_data_dir().path_join("court-captures")+"/"
 DirAccess.make_dir_recursive_absolute(SHOTS+"frames")
 root.size=Vector2i(960,540);root.content_scale_size=root.size
 var scene=load("res://furrow/start.tscn").instantiate();root.add_child(scene)
 g=scene.get_child(0).get_child(0);w=g.deep.world
 film=OS.get_environment("COURT_FILM")=="1"
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.set_process(false);g.transition_left=0;g.transition_shade.hide();g.loading_view._process(1);g.loading_view._process(1)
 g.ui.hide();g.fight.cancel_actions();g.surface.direction=Vector2.UP
 var f=w.layer().features[0];start=w.center(Vector2i(f.x,f.y))
 var props=w.landmarks().map(func(p):return p.prop)
 print("COURT ",start," player ",g.player-start," props ",props)
 for piece in ["mess","frieze","royal_throne","fallen","crosswall","archive_wall","bed","gate_left","gate_right"]:check(piece in props,"missing "+piece)
 w.survey(g.player);check(not f.found,"premature reward")
 var initial=g.state.inventory.get("assembly",0)
 await snap("gate")
 await walk("up",56)
 await snap("audience");check(f.found and g.state.inventory.get("assembly",0)==initial+3,"dais discovery")
 await walk("left",-96)
 check(w.Strata.Court.near_record(w,g.player)=="west_lit","brazier reach")
 g.deep.use_stairs(false)
 check(f.get("west_lit",false) and not f.get("east_lit",false),"independent braziers")
 await snap("kindled")
 await walk("left",-354)
 await snap("supper");inspect("mess")
 await walk("right",301)
 await snap("roll");inspect("desk")
 await walk("left",1)
 await walk("down",108)
 await snap("hall")
 await walk("up",26)
 await snap("seat")
 var old=g.player
 var edge=w.Strata.Court.site_cell(f)+Vector2i(5,6);var dig=Vector2i(-1,-1)
 for y in range(-7,9):
  for x in range(-7,9):
   var c=edge+Vector2i(x,y)
   if w.at(c) in [1,2,3,4,5,6,7] and w.exposed(c)>0:
    dig=c;break
  if dig.x>=0:break
 check(dig.x>=0,"no exposed rock")
 if dig.x>=0:
  for k in 35:
   w.strike(dig,-1,true,false)
   if w.at(dig)==0:break
  check(w.at(dig)==0,"failed excavation")
 g.save_game();g.start_game(true);w=g.deep.world
 check(g.player.distance_to(old)<1,"save/reload")
 check(w.at(dig)==0,"excavation reload")
 check(w.layer().features[0].get("west_lit",false),"brazier save/reload")
 check(w.survey(g.player).is_empty() and g.state.inventory.get("assembly",0)==initial+3,"duplicate discovery")
 print("END frames ",sequence," failures ",failures)
 quit(0 if failures.is_empty() else 1)
func inspect(which:String):
 var target=w.Strata.Court.near_record(w,g.player)
 check(target==which,"inspection range "+which+": "+target)
 g.deep.use_stairs(false)
 check(g.notice==w.Strata.Court.note(which),"E prompt "+which+": "+g.notice)
 print("INSPECT ",which," ",g.notice)
func walk(dir:String,coord:float):
 var horiz=dir in ["right","left"];var pos=dir in ["right","down"]
 Input.action_press(dir)
 for tick in 390:
  var relative=g.player-start
  var value=relative.x if horiz else relative.y
  if (pos and value>=coord-2) or (not pos and value<=coord+2):break
  var old=g.player
  g.clock+=1./48;g.deep.move(1./48)
  if g.player.distance_to(old)<.04:
   failures.append(dir+" blocked at "+str(g.player-start));break
  if film and tick%3==0:await frame()
 Input.action_release(dir);g.walking_pose=false;w.survey(g.player)
 print("MOVE ",dir," ",g.player-start)
func frame():
 g.camera=g.deep.camera_target();g.queue_redraw()
 await process_frame;await RenderingServer.frame_post_draw
 if film:
  root.get_texture().get_image().save_jpg(SHOTS+"frames/%04d.jpg"%sequence,.94);sequence+=1
func snap(id):
 for i in (12 if film else 2):
  g.clock+=1./16;await frame()
 root.get_texture().get_image().save_png(SHOTS+id+".png")
