extends SceneTree
var failures=[]
var count=0
func expect(ok:bool,reason:String):
 count+=1
 if not ok:failures.append(reason)
func key(g,code:int):
 var event=InputEventKey.new();event.keycode=code;event.physical_keycode=code;event.pressed=true
 g._unhandled_input(event)
func _initialize():call_deferred("run")
func run():
 var host=load("res://furrow/start.tscn").instantiate();root.add_child(host)
 var g=host.get_child(0).get_child(0);var frames=load("res://scripts/whole_frames.gd");var story=load("res://scripts/story_world105.gd")
 var folk=load("res://scripts/folk.gd")
 while folk.warming():folk.warm_step()
 g.set_process(false);g.transition_left=0
 var profiles=[]
 var app=load("res://scripts/appearance.gd")
 for sex in 2:
  for sculpt in 7:
   var profile=app.defaults();profile.gender=sex;profile.sculpt=sculpt;profiles.append(profile)
 for id in story.APPROVED:
  var profile=app.defaults();profile.cast_id=id;profiles.append(profile)
 for p in profiles:
  var id=p.get("cast_id",frames.identity(p))
  for dir in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1).normalized(),Vector2.UP]:
   var rest=frames.descriptor(p,dir,false,0,"",0)
   var views={}
   for step in 95:
    var a=frames.descriptor(p,dir,false,step*.067,"town_walk",1)
    views[a.index]=true
    expect(a.destination.position.distance_to(rest.destination.position)<.005 and a.destination.size.distance_to(rest.destination.size)<.005,"root "+id)
   expect(views.size()==12 and rest.sheet.ends_with("/"+id),"idle keys "+id)
   var walk_keys={}
   for k in 4:
    var walk=frames.descriptor(p,dir,true,(k+.1)*.52/4,"",0)
    expect(walk.sheet!=rest.sheet and walk.walking,"walk "+id);walk_keys[walk.index]=true
   expect(walk_keys.size()>=3,"stride "+id)
   var first=frames.texture(p,rest.sheet,rest.index)
   expect(first!=null and first.get_size().x>4 and first.get_size().y>4,"texture "+id)
 # The ceremonial actor has its own atlas and a seated silhouette.
 var king=frames.Hands.poses.eirik
 expect(king.size()==48,"royal standing, seated and scripted poses")
 for slot in [0,2]:
  var pose=king[slot*12]
  var image=frames.Hands.raw(pose.source)
  var r=pose.rect;var last=king[slot*12+7].rect
  var base=image.get_region(Rect2i(r[0],r[1]+r[3]-15,r[2],15))
  var other=image.get_region(Rect2i(last[0],last[1]+last[3]-15,last[2],15))
  # Compression can vary RGB inside a stationary boot. Its alpha outline
  # and position define where the sole meets the floor.
  var same_outline=true
  for y in base.get_height():
   for x in base.get_width():
    if base.get_pixel(x,y).a!=other.get_pixel(x,y).a:same_outline=false
  expect(same_outline,"king floor registration")
 var avatar=g.state.appearance
 for action in ["hold_pick","pick","carry_stone","push","drink","hold_combat_axe"]:
  var a=frames.descriptor(avatar,Vector2.RIGHT,false,.5,action,.4)
  expect(not "hands-rest1" in a.sheet,"equipped "+action)
 key(g,KEY_1);expect(g.hotbar.pose()=="hold_pick","pick selected")
 key(g,KEY_QUOTELEFT);expect(g.hotbar.pose()=="" and g.hotbar.stowed and g.hotbar.blocked_work(),"stow input")
 g.save_game();g.start_game(true);g.set_process(false);g.transition_left=0
 while folk.warming():folk.warm_step()
 expect(g.hotbar.stowed and g.hotbar.pose()=="","restored bare hands")
 key(g,KEY_QUOTELEFT);expect(g.hotbar.pose()=="hold_pick","equip previous slot")
 key(g,KEY_3);key(g,KEY_QUOTELEFT);key(g,KEY_2);expect(g.hotbar.pose()=="hold_shovel" and not g.hotbar.stowed,"switch from stowed")
 key(g,KEY_1);key(g,KEY_QUOTELEFT)
 var view=g.depth_nav.explore
 view.enabled=true;view.sync(.1)
 var before=view.player_sprite.texture;var clock=g.clock;g.clock+=1.5;view.sync(.25)
 expect(before!=null and before!=view.player_sprite.texture,"3D empty-handed animation advances")
 view.enabled=false;view.sync(0);g.clock=clock
 print("EMPTY HANDS: ",profiles.size()," regular models; ",count," assertions; failures ",failures.size()," ",failures.slice(0,6))
 if not failures.is_empty():print("LAST ",failures.slice(maxi(0,failures.size()-10)))
 quit(0 if failures.is_empty() else 1)
