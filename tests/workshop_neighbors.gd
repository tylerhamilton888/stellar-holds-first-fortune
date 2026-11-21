extends SceneTree
var failures=[]
var checks=0
var g
var play
var w
var L
var base=Vector2i(33,28)
func check(value,description):
 checks+=1
 if not value:failures.append(description);print("FAIL ",description)
func key(code,shift=false):
 var e=InputEventKey.new();e.keycode=code;e.physical_keycode=code;e.pressed=true;e.shift_pressed=shift
 g._unhandled_input(e)
func stand(offset):
 g.player=L.center(base+offset);w.survey(g.player);play.tick()
func walk(target):
 var goal=L.center(base+target)
 for i in 175:
  if g.player.distance_to(goal)<3:return true
  var d=goal-g.player
  var action=("right" if d.x>0 else "left") if abs(d.x)>2 else ("down" if d.y>0 else "up")
  var old=g.player
  Input.action_press(action);g.deep.move(.014);Input.action_release(action);play.tick()
  if g.player.distance_to(old)<.001:return false
 return false
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host);g=host.get_child(0).get_child(0)
 play=g.handworks.workshop;L=play.L;w=g.deep.world
 g.set_process(false);g.transition_left=0;g.transition_shade.hide()
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.loading_view._process(1);g.loading_view._process(1)
 var r=play.room();var forge=L.on_cell(r,base);var table=L.on_cell(r,base+Vector2i(2,0))
 check(r.pieces.size()==9,"Two furnished rooms")
 var n=L.neighbors(forge,r,play.wall)
 check(n.back.size()==2 and n.joints.size()==1,"Backed forge and single joint to table")
 var seat=L.on_cell(r,base+Vector2i(0,-5))
 check(L.neighbors(seat,r,play.wall).seat,"Chair tucked to long side")
 check(w.solid(L.center(base)),"Forge blocks movement")
 stand(Vector2i(1,1))
 var iron=g.state.count("iron");var coal=g.state.count("coal")
 key(KEY_E)
 check(g.state.count("iron")==iron+1 and g.state.count("coal")==coal-1,"E smelts from the working face")
 check(r.wear[L.key(base+Vector2i.UP)].has("soot"),"Heat marked its backing")
 key(KEY_B,true)
 check(g.panel_id!="","Shift+B opens the workshop board")
 g.close_panel()
 var count_before=r.pieces.size()
 play.pick("move");play.click(base+Vector2i(2,0));key(KEY_R)
 play.click(base)
 check(r.pieces.size()==count_before and table.turn==0 and play.moving!="","Occupied destination preserves original furnishing")
 play.click(base+Vector2i(3,0))
 var moved=L.on_cell(r,base+Vector2i(3,1))
 check(moved.get("turn",-1)==1 and L.on_cell(r,base+Vector2i(2,0)).is_empty(),"Rotated footprint moves and releases old cell")
 check(L.neighbors(forge,r,play.wall).joints.is_empty(),"A clear aisle breaks the join")
 check(r.pieces.size()==count_before and g.state.count("iron")==iron+1,"Move preserves count and cost")
 var face=base+Vector2i.UP
 var result={}
 for i in 20:
  result=w.strike(face)
  if result.get("broken",false):break
 check(result.get("broken",false) and not r.facing.has(L.key(face)),"Mining removes masonry facing")
 check(not r.wear[L.key(face)].has("soot") and r.wear[L.key(face+Vector2i.RIGHT)].has("soot"),"Only the mined backing loses its soot")
 check(L.neighbors(forge,r,play.wall).back.size()==1,"Remaining backing updates independently")
 stand(Vector2i(1,1))
 for offset in [Vector2i(2,1),Vector2i(2,2),Vector2i(5,2),Vector2i(5,-3),Vector2i(3,-3)]:
  check(walk(offset),"Walk clear passage to "+str(offset))
 var mess=base+Vector2i(2,-4);var meal=L.on_cell(r,mess)
 check(meal.get("served",false),"Prepared mess table")
 key(KEY_E)
 check(not meal.get("served",false),"E clears dishes")
 var food=g.state.count("food");key(KEY_E)
 check(meal.get("served",false) and g.state.count("food")==food-1,"E serves and charges exactly one food")
 check(not L.on_cell(r,mess+Vector2i(-2,0)).get("served",false),"Neighboring table stays bare")
 var traffic=0
 for tile in r.wear.values():traffic+=int(tile.get("traffic",0))
 check(traffic>0,"Travel through room leaves foot wear")
 play.pick("move");play.click(mess);play.click(base+Vector2i(3,-5))
 var relocated=L.on_cell(r,base+Vector2i(3,-5))
 check(relocated.get("served",false),"Moving a set table preserves dishes")
 stand(Vector2i(6,0));var space=base+Vector2i(5,1)
 for kind in ["forge","table","anvil","chair","flags"]:
  var f=L.record(kind,space,0)
  var before=g.state.count("stone");var placed=play.install(f)
  check(placed=="","Install "+kind+" "+placed)
  if placed=="":check(play.remove(space) and before==g.state.count("stone"),"Lift and refund "+kind)
 var edge=base+Vector2i(7,0);var before=g.state.count("stone")
 check(play.remove(edge),"Lift masonry")
 check(play.install(L.record("flags",edge,0))=="" and r.facing.has(L.key(edge)) and before==g.state.count("stone"),"Dress exposed wall again")
 var z=w.depth();w.data.depth=z+1
 check(play.room().is_empty(),"Other depths keep independent furniture")
 w.data.depth=z
 g.save_game();g.start_game(true);g.set_process(false);play=g.handworks.workshop;r=play.room()
 check(L.on_cell(r,base+Vector2i(3,-5)).get("served",false) and r.facing.has(L.key(edge)),"Save and reload preserves placement and use")
 print("WORKSHOP ",checks," checks. Failures ",failures)
 quit(0 if failures.is_empty() else 1)
