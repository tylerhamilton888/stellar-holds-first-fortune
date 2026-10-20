extends "res://tests/mining55.gd"
var elapsed=0.0
var distance=0.0
func frames(n:int):
 for i in n:
  var old=g.player;g._process(1.0/60);elapsed+=1.0/60;distance+=old.distance_to(g.player);await process_frame
func step_to(p:Vector2)->bool:
 for i in 180:
  var delta=p-g.player
  if delta.length()<3:break
  var axis=delta.normalized()
  for name in ["left","right","up","down"]:Input.action_release(name)
  if axis.x<0:Input.action_press("left",-axis.x)
  else:Input.action_press("right",axis.x)
  if axis.y<0:Input.action_press("up",-axis.y)
  else:Input.action_press("down",axis.y)
  await frames(1)
 for name in ["left","right","up","down"]:Input.action_release(name)
 return g.player.distance_to(p)<4
func tunnel_to(dest:Vector2i):
 var w=g.deep.world;var c=Deepworks.cell(g.player)
 while c!=dest:
  var next=c+(Vector2i(signi(dest.x-c.x),0) if c.x!=dest.x else Vector2i(0,signi(dest.y-c.y)))
  if w.at(next)!=0:
   await aim_at(Deepworks.center(next));await mouse(true)
   for i in 500:
    if w.at(next)==0:break
    await frames(1)
   await mouse(false)
   if w.at(next)!=0:check(false,"Natural route target could not be excavated: "+str(next));return
  if not await step_to(Deepworks.center(next)):check(false,"Natural route collision: "+str(next));return
  c=next
func dress_here():
 await shift(true);Input.action_press("interact");await frames(132);Input.action_release("interact");await shift(false)
func run():
 output="res://docs/testing/mining-0.55.0/site";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 # Established commission-stage fixture: basic tools, two iron and enough timber for equipment.
 g.state.seed_value=5755;g.state.deepworks.clear();g.state.add("wood",12);g.state.add("iron",2);g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle()
 var w=g.deep.world;var h=g.handworks;var initial=g.state.mined
 await tunnel_to(Vector2i(11,8));await tunnel_to(Vector2i(14,8))
 check(g.state.mined>initial and not h.data().loose.is_empty(),"Held excavation opens a real natural prospecting tunnel")
 await dress_here();await snap("01-field-dressing")
 await tunnel_to(Vector2i(14,11));await dress_here();await tunnel_to(Vector2i(11,11));await dress_here()
 # Choose actual stone loads, not whichever mineral a random seam placed nearest.
 for attempt in 15:
  if g.state.count("stone")+int(g.deep.haul.bucket().get("stone",0))>=6:break
  var stone={}
  for raw in h.data().loose:
   if h.local(raw) and HoldHandworks.raw_item(raw)=="stone":stone=raw;break
  if not stone.is_empty():
   var route=w.route(Deepworks.cell(g.player),0,"",Deepworks.cell(h.pos(stone)))
   for point in route.get("path",[]):await step_to(point)
   await dress_here()
  else:
   var route=w.route(Deepworks.cell(g.player),0,"stone")
   if route.is_empty():break
   for point in route.path:await step_to(point)
   await tunnel_to(route.target);await dress_here()
 # Return through the excavated tunnel; equipment uses only delivered materials.
 await tunnel_to(Vector2i(8,11));await tunnel_to(Deepworks.ENTRY);g.deep.unload()
 check(g.state.count("stone")>=6,"Small field-dressed prospect supplies the stone for a first worksite")
 await step_to(Vector2(220,260));check(h.build("stone_pile",Vector2(220,260)),"Raw rack built with recovered prospecting materials")
 await step_to(Vector2(220,360));check(h.build("breaker",Vector2(220,360)),"Stonebreaker built in original entrance chamber")
 await step_to(Vector2(420,260));check(h.build("cart",Vector2(420,260)),"Existing handcart provides the next logistical step")
 var cart=h.facility();key(KEY_C);check(cart.hitched,"Actual cart handles engage")
 await tunnel_to(Vector2i(11,8));await tunnel_to(Vector2i(14,8));key(KEY_C);key(KEY_E)
 check(cart.raw.size()>0,"Parked cart gathers remaining physical prospect loads")
 key(KEY_C);await tunnel_to(Vector2i(8,8));await step_to(Vector2(220,300));key(KEY_C);key(KEY_E)
 var rack=h.data().facilities[0];check(rack.raw.size()>0,"Cart unloads into nearby rack without individual shoulder trips")
 await step_to(Vector2(205,390));Input.action_press("interact");await frames(700);Input.action_release("interact")
 check(not w.solid(g.player),"Wall-adjacent breaker selects a collision-safe working stance")
 var breaker=h.data().facilities[1];check(DeepHaul.amount(breaker.cargo)>0,"Held station work processes a rack-fed batch")
 var e=InputEventKey.new();e.keycode=KEY_E;e.pressed=true;e.shift_pressed=true;g._unhandled_input(e)
 await snap("02-first-worksite")
 # Real naturally generated cavern and dipping iron formation; no terrain replacement.
 await tunnel_to(Vector2i(11,8));var feature=w.layer().features[0];await tunnel_to(Vector2i(feature.x,feature.y));w.survey(g.player)
 check(feature.found,"Excavation breaks into the original Hollow Bell cavern")
 await snap("03-breakthrough")
 await tunnel_to(Vector2i(26,28))
 var lodes=w.data.get("prospects",{}).duplicate(true)
 check(not lodes.is_empty() and h.capacity()==2,"Productive development earns Miner handling mastery and lode notes")
 key(KEY_X);await snap("04-survey");key(KEY_X)
 var landing=Deepworks.cell(g.player);w.carve_stairs(landing);g.deep.use_stairs(false);settle()
 check(w.depth()==1 and Deepworks.cell(g.player)==landing,"Prospect stair descends at matching geological coordinates")
 await tunnel_to(Vector2i(28,28));await tunnel_to(Vector2i(28,32));await tunnel_to(Vector2i(25,32))
 var followed=false
 for note in w.data.get("prospects",{}).values():
  if note.depths.size()>=2:followed=true
 check(followed,"Actual held mining recovers a continuous mineral formation across two depths")
 await snap("05-lower-lode")
 await tunnel_to(landing);g.deep.use_stairs(true);settle();await tunnel_to(Vector2i(26,14));await tunnel_to(Vector2i(feature.x,feature.y));await tunnel_to(Vector2i(11,feature.y));await tunnel_to(Vector2i(11,8));await tunnel_to(Deepworks.ENTRY)
 var loads=h.data().loose.size();var stored=h.data().facilities.duplicate(true);var notes=w.data.prospects.duplicate(true);var dug=g.state.mined-initial
 check(dug>=40 and loads>=20,"Development leaves a substantial reusable tunnel and persistent material reserve")
 g.save_game();g.start_game(true);settle();w=g.deep.world;h=g.handworks
 check(same(h.data().facilities,stored) and h.data().loose.size()==loads and same(w.data.prospects,notes),"Established site, loose loads and depth accomplishments survive a real reload")
 g.deep.use_stairs(false);settle();check(g.surface.area=="trail","Developed mine returns naturally to its surface entrance")
 print("SITE55 METRICS: simulated_seconds=",elapsed," walked_units=",distance," faces=",dug," loose_loads=",loads," formations=",notes.size())
 print("SITE55: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
