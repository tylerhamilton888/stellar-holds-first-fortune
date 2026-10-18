extends SceneTree
var g
var passed=0
var failed=0
var output="res://docs/testing/hearthcraft-0.47.0"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func snap(name:String):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud();g.queue_redraw()
 for i in 10:
  g.queue_redraw();await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func at(p:Vector2):g.player=p;g.camera=g.surface.camera_target();g.notice_time=0
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.pressed=true;g._unhandled_input(e)
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var h=g.surface.house;at(Vector2(920,500));g.state.add("wood",300);g.state.add("stone",300)
 var old=g.state.surface.homes[g.state.claim_id].duplicate(true)
 check(h.tiles().is_empty() and g.state.surface.chests.size()==1,"Existing cottage/chest survive additive building initialization")
 check(not h.build(Vector2(500,440),"stone_floor"),"Cannot replace the starter cottage or doorway")
 check(not h.build(Vector2(820,380),"wall"),"Walls require a paid floor foundation")
 var initial=g.state.count("stone")
 var floors=0
 for y in range(9,15):
  for x in range(20,26):
   if h.build(h.center(Vector2i(x,y)),"stone_floor"):floors+=1
 check(floors==36 and g.state.count("stone")==initial-36,"Arbitrary 6 by 6 footprint spends exactly one stone per tile")
 check(not h.build(Vector2(820,380),"stone_floor") and g.state.count("stone")==initial-36,"Duplicate foundation cannot double-charge")
 var door=Vector2i(23,14)
 check(h.build(h.center(door),"door"),"A real operable door can be built on its foundation")
 var walls=0
 for y in range(9,15):
  for x in range(20,26):
   if (x in [20,25] or y in [9,14]) and Vector2i(x,y)!=door:
    if h.build(h.center(Vector2i(x,y)),"window" if y==9 and x in [21,24] else "wall"):walls+=1
 check(walls==19,"Freeform walls and windows enclose the chosen footprint")
 check(h.shelter(g.player).enclosed and not h.shelter(g.player).roofed,"Unroofed enclosure is recognized without pretending it is a complete home")
 await snap("01-foundations-walls")
 check(not h.build(g.player,"wall"),"Construction cannot entomb the player")
 check(not g.surface.walkable(Vector2(820,500)),"Built walls physically block normal movement")
 check(g.surface.walkable(h.center(door)),"Open doorway is physically traversable")
 at(Vector2(940,540));key(KEY_E)
 check(not h.tile(door).open and not g.surface.walkable(h.center(door)),"E closes a door and updates collision")
 key(KEY_E);check(h.tile(door).open,"E reopens the same door")
 at(h.center(door));check(not h.toggle(h.key(door)) and h.tile(door).open,"Door cannot close through the player")
 Input.action_press("down");await frames(24);Input.action_release("down")
 check(g.player.y>600,"Real movement crosses the doorway to the yard")
 Input.action_press("up");await frames(24);Input.action_release("up")
 check(g.player.y<585,"Real movement returns through the built door")
 at(Vector2(920,500));var roofs=0
 for y in range(9,15):
  for x in range(20,26):
   if h.build(h.center(Vector2i(x,y)),"roof"):roofs+=1
 check(roofs==36 and h.shelter(g.player).roofed,"Roof tiles cover the actual custom footprint")
 g.surface.placing="bed";check(g.surface.place(Vector2(880,440)),"Bed can be placed in a player-built house")
 g.surface.placing="chest";check(g.surface.place(Vector2(960,440)),"Storage chest can be placed in the new house")
 at(Vector2(880,490));key(KEY_E)
 check(h.data().facts.get("home",false),"Resting in a roofed enclosed house completes the practical lesson")
 await snap("02-inside-custom-home")
 at(Vector2(940,650));await snap("03-roof-exterior")
 at(Vector2(960,490));key(KEY_E);check(g.panel_id=="storage","Built house chest uses the existing physical storage UI")
 var total=g.state.count("stone");check(g.surface.transfer("stone",10,true)==10 and g.state.count("stone")==total-10,"New house storage conserves pack resources")
 g.close_panel();check(h.build(Vector2(960,440),"remove"),"Roof repair above furniture preserves its contents")
 check(not h.build(Vector2(960,440),"remove"),"Foundation demolition protects stored contents and furniture")
 check(h.build(Vector2(960,440),"roof"),"Roof can be replaced above a furnished room")
 at(Vector2(920,500));var wood=g.state.count("wood")
 check(h.build(Vector2(860,500),"remove") and g.state.count("wood")==wood+1,"Roof removal refunds exactly its paid material")
 check(not h.shelter(g.player).roofed,"Removing a roof exposes the actual room")
 check(h.build(Vector2(860,500),"roof"),"Removed roof can be rebuilt")
 at(Vector2(1110,540));g.surface.placing="house:wood_floor"
 var aim=Vector2(1140,580)-g.camera;root.warp_mouse(aim*root.get_visible_rect().size/Vector2(960,540));await frames(2)
 var wood_before=g.state.count("wood");var mouse=InputEventMouseButton.new();mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=true;mouse.position=aim;Input.parse_input_event(mouse);await frames(20)
 mouse=InputEventMouseButton.new();mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=false;mouse.position=aim;Input.parse_input_event(mouse);await frames(2)
 check(h.tile(h.cell(Vector2(1140,580))).get("floor","")=="wood_floor" and g.state.count("wood")==wood_before-1,"Held mouse builds a floor once without repeated spending")
 g.surface.placing="";at(Vector2(920,500))
 var saved=JSON.parse_string(JSON.stringify(g.state.surface));g.save_game();g.start_game(true);settle();h=g.surface.house
 check(JSON.parse_string(JSON.stringify(g.state.surface.homes))==saved.homes and JSON.parse_string(JSON.stringify(g.state.surface.chests))==saved.chests,"Save/reload preserves every built tile, door and chest quantity")
 check(g.surface.walkable(g.player),"Reload returns to a safe walkable location")
 key(KEY_O);g.open_panel("house_build");await snap("04-build-menu")
 check(g.menu_paused and g.panel_id=="house_build","Construction catalog pauses play and retains the bounded menu")
 g.close_panel();at(Vector2(920,500))
 # A wall in place of the only door would seal the room, so route validation must reject it.
 var draft=h.tiles().duplicate(true);draft[h.key(door)].wall="wall"
 check(not h.routes_open(draft),"Route validation rejects sealing the player inside")
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt;p.hair_color=6;p.cloth_color=3
   for row in 4:check(HoldDirectional.texture(p,row).get_height()>50,"Directional variant %d/%d/%d is present" % [gender,sculpt,row])
 # Real multilevel house: roof is the physical upper floor, not a visual-only overlay.
 at(Vector2(920,500));var landing=Vector2i(22,13);var landing_p=h.center(landing)
 check(h.tiles(1).size()==36,"Roof construction creates corresponding walkable Z+1 cells")
 check(h.build(landing_p,"stairs"),"Stair flight creates a same-location vertical link")
 at(landing_p);key(KEY_E)
 check(h.level()==1 and g.player==landing_p,"E climbs to the roof at exactly the same XY landing")
 check(g.surface.points().all(func(p):return p.action not in ["mine","camp","ship","trail"]),"Ground destinations cannot be activated from an upper storey")
 at(Vector2(820,380));Input.action_press("left");await frames(20);Input.action_release("left")
 check(g.player.x>=800,"Roof edge prevents walking into unsupported air")
 at(Vector2(940,500));g.surface.placing="chest"
 check(g.surface.place(Vector2(960,440)),"An upper chest may share XY with a different ground-floor chest")
 var upper_id=""
 for id in g.state.surface.chests:
  if int(g.state.surface.chests[id].get("z",0))==1:upper_id=id
 g.surface.selected_chest=upper_id
 check(g.surface.transfer("wood",5,true)==5,"Roof chest receives its own independent contents")
 at(Vector2(920,500));check(h.build(h.center(Vector2i(20,9)),"window"),"Walls can extend the house upward on a roof floor")
 check(not h.build(landing_p,"wall"),"Upper walls cannot obstruct a vertical landing")
 check(h.build(h.center(Vector2i(23,11)),"roof"),"Upper storey roof creates a Z+2 surface")
 check(h.build(landing_p,"ladder"),"A ladder extends the same shaft to another storey")
 at(landing_p);key(KEY_E);check(h.level()==2 and g.player==landing_p,"E chooses upward travel at a landing with connections both ways")
 check(h.build(h.center(Vector2i(23,13)),"wood_floor"),"Supported upper floor can be expanded beside a landing")
 await snap("06-upper-storey")
 g.save_game();g.start_game(true);settle();h=g.surface.house
 check(h.level()==2 and g.player==landing_p,"Save/reload restores current Z and exact landing")
 var e=InputEventKey.new();e.keycode=KEY_E;e.pressed=true;e.shift_pressed=true;g._unhandled_input(e)
 check(h.level()==1 and g.player==landing_p,"Shift+E descends the ladder to the matching floor")
 await snap("07-walkable-roof")
 g._unhandled_input(e);check(h.level()==0 and g.player==landing_p,"Shift+E descends the original stair to ground level")
 g.surface.selected_chest=upper_id;at(Vector2(960,490))
 check(g.surface.transfer("wood",5,false)==0,"Same XY cannot access a chest on another Z-level")
 check(not h.build(Vector2(960,440),"remove"),"A furnished upper floor prevents removing its supporting roof")
 check(not h.build(landing_p,"remove"),"Upper construction prevents dismantling its access passage")
 check(h.data().facts.get("ascend",false) and h.data().facts.get("descend",false),"Building lesson credits actual ascent and return")
 g.surface.enter("hearthward",Vector2(1180,720));settle()
 for i in 8:
  var d=Vector2.from_angle(i*TAU/8);g.surface.direction=d;g.walking_pose=true;g.gait_clock=.125
  await snap("direction-"+str(i))
 g.surface.direction=Vector2.UP
 for i in 3:
  g.gait_clock=i*.09;await snap("north-gait-"+str(i))
 g.state.appearance.gender=1;g.state.appearance.sculpt=3;g.surface.direction=Vector2.UP;await snap("female-rear")
 g.surface.direction=Vector2.DOWN;await snap("female-front")
 g.state.appearance.gender=0;g.state.appearance.sculpt=0
 g.surface.enter("trail");settle();g.surface.action("mine");settle();g.surface.direction=Vector2.UP;await snap("05-mine-north")
 check(g.zone=="mine","Directional locomotion is integrated into the existing mine")
 print("HEARTHCRAFT47: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
