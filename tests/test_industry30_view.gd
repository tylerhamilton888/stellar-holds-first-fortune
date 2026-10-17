extends SceneTree
var g
func _initialize():call_deferred("run")
func snap(name):
 g.update_hud();g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("industry30-"+name+".png"))
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.state.outpost.erase("onboarding");g.close_panel();g.state.opening=4;g.grounded=true
 g.state.money=10000;g.state.buy_charter("old_delving");g.state.camp_stage=3
 for k in HoldData.ITEMS:g.state.add(k,100)
 for id in HoldOutpost.CREW:HoldOutpost.recruit(g.state,id)
 g.state.outpost.name="Fellcopper Anchorage";g.travel_claim();g.transition_left=0;g.transition_shade.visible=false
 g.state.tech={"metallurgy":true,"automation":true,"thermal":true,"voidcraft":true};g.state.ship_stage=1;g.tool=3;g.player=Vector2(1020,410);g.camera=Vector2(540,0)
 for i in 3:
  g.state.outpost.industry_claim=i
  await snap("stage"+str(i))
 g.forge_tab=3;g.open_panel("forge");await snap("menu")
 g.close_panel();g.player=Vector2(1660,410);g.camera=Vector2(1120,0);await snap("yard")
 g.zone="mine";g.player=Vector2(145,392);g.camera=Vector2(0,160);g.face=1
 g.agents.clear();g.state.agents_enabled=false
 g.state.outpost.mining_gun=true;g.state.outpost.gun_charge=20;g.mining_gun.selected=true;g.tool=0
 # Exposed seam at real 7px grain scale; clear only a local QA pocket.
 for y in range(39,57):
  for x in range(10,60):g.geo.set_cell(Vector2i(x,y),3 if x>=39 else 0)
 g.geo.redraw_all=true
 g.get_viewport().warp_mouse(Vector2(330,194));await process_frame;await process_frame
 g.mining_buffer=.16;g.mining_gun.cool=0;g.mining_gun.update()
 assert(g.mining_gun.flash>0 and g.state.outpost.gun_charge==19,"Live input fires and debits one charge")
 var paid=g.state.outpost.gun_charge;g.mining_buffer=.16;g.mining_gun.update()
 assert(g.state.outpost.gun_charge==paid,"Cooldown prevents duplicate input pulses")
 print("GUN INPUT: contact, charge and cooldown verified")
 await snap("gun-right")
 g.mining_gun.flash=0;g.mining_gun.braced=0;await snap("gun-carry")
 g.face=-1;g.player=Vector2(245,392)
 for y in range(39,56):g.geo.set_cell(Vector2i(13,y),2)
 g.get_viewport().warp_mouse(Vector2(91,194));await process_frame;await process_frame
 g.mining_gun.cool=0;g.mining_buffer=.16;g.mining_gun.update()
 assert(g.mining_gun.flash>0 and g.mining_gun.direction.x<0,"Left facing live pulse")
 await snap("gun-left")
 g.state.appearance.gender=1;g.state.appearance.sculpt=1;g.state.appearance=HoldAppearance.normalized(g.state.appearance)
 await snap("gun-female")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame;quit()
