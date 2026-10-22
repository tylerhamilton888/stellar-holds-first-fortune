extends "res://tests/support/game_fixture.gd"
class WalkBoard extends Node2D:
 var profile:Dictionary
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("142c33"))
  for row in 3:
   var action=["","hold_pick","carry_stone"][row]
   draw_string(ThemeDB.fallback_font,Vector2(30,30+row*170),["Free hands","Pickaxe held","Stone carried"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("e4c88c"))
   for frame in 4:
    var p=Vector2(150+frame*220,150+row*170)
    draw_line(p-Vector2(65,0),p+Vector2(65,0),Color("516c6b"),1)
    HoldWholeFrames.paint(self,p,profile,Vector2.RIGHT,true,HoldWholeFrames.CYCLE*(frame+.1)/4,1.8,Vector2.ZERO,action)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 var s=g.surface
 for ward in HoldWorldZones.WARDS:
  s.enter(ward);settle()
  var clear=true
  for b in s.world.buildings():
   var wall=HoldWorldZones.building_footprint(b)
   var approach=Vector2(b.p.x,wall.end.y+s.FOOT_RADIUS+1)
   if not s.walkable(approach):clear=false
   at(approach);Input.action_press("up");s.move(.4);Input.action_release("up")
   if g.player.y<wall.end.y+s.FOOT_RADIUS:clear=false
  check(clear,"All facade approaches stop at their visible solid front: "+ward)
  at(Vector2(350,450));await snap(ward+"-door")
  at(Vector2(540,270));await snap(ward+"-roof")
  at(Vector2(140,810));await snap(ward+"-mountain")
 for area in ["room:home","room:tavern","room:market","room:research","room:commission","room:forge",HoldNeighborhood.home_id("hearthward",0)]:
  s.enter(area);settle();at(s.spawn(area))
  check(s.walkable(g.player),"Room entry remains accessible: "+area)
  await snap(area.replace(":","-"))
 s.enter("room:home");settle()
 for p in [Vector2(342,390),Vector2(735,547),HoldRoomLayout.exit_point(s.area)]:check(s.walkable(p),"Bed, letter and doorway retain clear approaches: "+str(p))
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt
   for frame in 4:
    var t=HoldWholeFrames.CYCLE*(frame+.1)/4
    var a=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,t,"",0)
    var b=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,t,"town_walk",0)
    check(a.sheet==b.sheet and a.index==b.index,"Shared whole walk %d/%d/%d"%[gender,sculpt,frame])
 check(is_equal_approx(HoldDrawnLocomotion.time_for_distance(57.2),HoldWholeFrames.CYCLE),"Footfall cycle covers a body-proportioned stride")
 g.state.add("stone",12);g.open_panel("inventory");await snap("pack")
 var search=g.panel.find_children("*","LineEdit",true,false)[0];search.text="stone";search.text_changed.emit("stone");await snap("pack-search")
 check(search.has_focus()==false and g.state.count("stone")>=12,"Search only filters presentation and preserves materials")
 button("Skills");await snap("skills")
 check(g.panel_id=="disciplines" and g.menu_history.is_empty(),"Peer tab opens skills without back-stack accumulation")
 button("Pack");button("Gear");button("Pack")
 check(g.panel_id=="inventory" and g.menu_history.is_empty(),"Repeated peer switches keep navigation shallow")
 g.open_panel("settings");g.back_panel();check(g.panel_id=="inventory","Nested menus still support Back")
 g.close_panel();g.save_game();var inventory=g.state.inventory.duplicate(true);g.start_game(true);settle()
 check(g.state.inventory==inventory,"Save/reload preserves progress after presentation changes")
 var board=WalkBoard.new();board.profile=HoldAppearance.defaults();board.z_index=100;g.add_child(board)
 g.hud.visible=false;g.footer.visible=false;g.status.visible=false;g.objectives.visible=false;g.hotbar.visible=false
 await snap("whole-gait")
 board.queue_free()
 print("POLISH72: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
