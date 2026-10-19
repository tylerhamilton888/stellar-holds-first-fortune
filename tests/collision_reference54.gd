extends "res://tests/input_reference54.gd"
func reachable(start:Vector2)->Dictionary:
 var origin=Vector2i((start/20).round());var todo=[origin];var visited={origin:origin};var head=0
 while head<todo.size():
  var c=todo[head];head+=1
  for d in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
   var n=c+d
   if visited.has(n) or not g.surface.walkable(Vector2(n)*20):continue
   visited[n]=c;todo.append(n)
 return visited
func close_cell(reached:Dictionary,p:Vector2)->Vector2i:
 var cell=Vector2i((p/20).round())
 for offset in [Vector2i.ZERO,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP]:
  if reached.has(cell+offset):return cell+offset
 return Vector2i(-999,-999)
func walk_route(reached:Dictionary,target:Vector2)->bool:
 var c=close_cell(reached,target);var path=[]
 if c.x==-999:return false
 while reached[c]!=c:path.push_front(Vector2(c)*20);c=reached[c]
 g.player=Vector2(c)*20
 for p in path:
  for i in 20:
   var delta=p-g.player
   if delta.length()<2:break
   for axis in ["left","right","up","down"]:Input.action_release(axis)
   Input.action_press("right" if delta.x>0 else "left") if absf(delta.x)>1 else null
   Input.action_press("down" if delta.y>0 else "up") if absf(delta.y)>1 else null
   g.surface.move(minf(1.0/60,delta.length()/185))
  if g.player.distance_to(p)>3:return false
 for axis in ["left","right","up","down"]:Input.action_release(axis)
 return g.player.distance_to(target)<42
func run():
 output="res://docs/testing/reference-0.54.0/collision";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 for ward in ["hearthward","crownward","forgeward"]:
  g.surface.enter(ward);settle();var reached=reachable(g.player)
  for p in g.surface.points():
   if p.action.begins_with("citizen:"):continue
   check(close_cell(reached,p.p).x!=-999,ward+" has walkable route to "+p.name)
   if p.action.begins_with("room:"):
    check(walk_route(reached,p.p+Vector2(0,20)),"Actual eight-way controller reaches "+p.name)
    g.player=p.p+Vector2(65,20);check(g.surface.nearest().get("action","")!=p.action,"Side wall does not activate "+p.name)
    g.player=p.p+Vector2(0,20);check(g.surface.nearest().get("action","")==p.action,"Visible door center activates "+p.name)
  var safe=true
  for t in range(0,180,2):
   for c in g.surface.world.people(t):
    if not g.surface.walkable(c.p):safe=false;print("BAD CITIZEN ",ward," ",c.p)
  check(safe,"Citizens stay on traversable streets in "+ward)
  for b in g.surface.world.buildings():check(not g.surface.walkable(b.p-Vector2(0,50)),"Solid building base "+str(b.id))
  g.player=Vector2(780,530);await snap(ward+"-threshold")
 for id in ["home","tavern","forge","market","commission","research","throne","practice"]:
  g.surface.enter("room:"+id);settle();var reached=reachable(g.player)
  for p in g.surface.points():check(close_cell(reached,p.p).x!=-999,id+" reachable interaction "+p.name)
  g.player=Vector2(480,600);key(KEY_E);settle();check(not g.surface.room(),id+" actual south doorway exits from inside")
  g.surface.enter("room:"+id);settle()
  for o in g.surface.world.room_objects():
   var r=g.surface.world.furn_footprint(o);check(not g.surface.walkable(r.get_center()),id+" furniture blocks its visible footprint")
  g.player=Vector2(480,540);await snap(id+"-floor")
 g.surface.enter("trail",Vector2(1100,700));settle()
 Input.action_press("right")
 for i in 120:g.surface.move(1.0/60)
 Input.action_release("right");check(g.player.x>1350,"Actual controller crosses the full visible bridge deck")
 g.player=Vector2(1230,700);Input.action_press("up")
 for i in 60:g.surface.move(1.0/60)
 Input.action_release("up");check(g.player.y>=665,"North bridge railing stops movement before water")
 Input.action_press("down")
 for i in 120:g.surface.move(1.0/60)
 Input.action_release("down");check(g.player.y<=735,"South bridge railing stops movement before water")
 check(not g.surface.walkable(Vector2(1150,649)) and not g.surface.walkable(Vector2(1320,751)),"Bridge rail ends block feet outside the water strip too")
 check(not g.surface.walkable(Vector2(1230,500)) and not g.surface.walkable(Vector2(1230,850)),"River is blocked on both sides of crossing")
 g.player=Vector2(1230,700);await snap("bridge-deck")
 var reached=reachable(g.surface.spawn("trail"))
 for p in g.surface.points():check(close_cell(reached,p.p).x!=-999,"Trail route reaches "+p.name)
 g.surface.enter("hearthward",HoldWorldZones.ROYAL+Vector2(0,20));settle();key(KEY_E);settle()
 check(g.surface.area=="crownward" and g.player.distance_to(HoldWorldZones.ROYAL)<40,"Royal stairs share physical X/Y landing across Z levels")
 key(KEY_E);settle();check(g.surface.area=="hearthward","Royal stair return is reciprocal")
 g.surface.enter("hearthward",HoldWorldZones.FORGE+Vector2(0,20));settle();key(KEY_E);settle()
 check(g.surface.area=="forgeward" and g.player.distance_to(HoldWorldZones.FORGE)<40,"Forge stairs share physical X/Y landing across Z levels")
 key(KEY_E);settle();check(g.surface.area=="hearthward","Forge stair return is reciprocal")
 # Inspect actual solid volumes over the painted art, including thresholds.
 var debug=Hitboxes.new();debug.game=g;root.add_child(debug)
 for sample in [["hearthward",Vector2(1230,490),"doors"],["room:tavern",Vector2(480,540),"furniture"],["trail",Vector2(1230,700),"bridge"]]:
  g.surface.enter(sample[0],sample[1]);settle();debug.queue_redraw();await snap("hitboxes-"+sample[2])
 debug.queue_free()
 print("REFERENCE54 COLLISION: ",passed," passed / ",failed," failed");g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)

class Hitboxes extends Node2D:
 var game
 func _draw():
  draw_set_transform(-game.camera.round())
  for r in game.surface.obstacles():draw_rect(r,Color(1,.2,.1,.22));draw_rect(r,Color(1,.4,.2,.8),false,1)
  for p in game.surface.points():
   if not p.action.begins_with("citizen:"):draw_circle(p.p,5,Color("f5d978"))
