extends SceneTree
var game
var checks=0
func _initialize():call_deferred("run")
func check(ok:bool,message:String):
 if not ok:push_error(message);quit(1)
 checks+=1
func settle():
 await process_frame;await process_frame;await process_frame;await RenderingServer.frame_post_draw
func snap(tag:String):
 game.update_hud();game.queue_redraw();await settle()
 check(game.panel.get_global_rect().end.x<=960.1 and game.panel.get_global_rect().end.y<=540.1,"Menu stays within viewport: "+tag)
 check(game.panel_body.size.x<=game.menu_scroll.size.x+1,"No horizontal clipping: "+tag)
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("ui22-"+tag+".png"))
func run():
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.state.opening=1;game.close_panel()
 for id in ["commission","inventory","equipment","construction","roster","market","research","pause","settings","help"]:
  game.close_panel();game.open_panel(id);await snap(id)
 game.trade_tab="buy";game.close_panel();game.open_panel("market");await snap("market-buy");await settle();game.menu_scroll.scroll_vertical=220;var offset=game.menu_scroll.scroll_vertical
 check(offset>0,"Trade scroll test uses a scrollable view")
 game.refresh_panel();await settle();check(abs(game.menu_scroll.scroll_vertical-offset)<2,"Refresh preserves trade scroll")
 game.open_panel("equipment");await settle();game.back_panel();await settle();check(game.panel_id=="market" and abs(game.menu_scroll.scroll_vertical-offset)<2,"Back restores previous screen and scroll")
 game.trade_tab="contracts";game.open_panel("market",false);await snap("contracts")
 game.help_tab=2;game.open_panel("help");await snap("combat-guide")
 game.close_panel();game.open_panel("roster");await settle()
 var portraits=0
 for child in game.panel_body.find_children("*","Control",true,false):
  if child is HoldPortrait:portraits+=1
 check(portraits==10,"Roster has ten unique cards, without duplicated visitors")
 game.close_panel();game.open_panel("pause");game.open_panel("help");var before=game.clock;game._process(12);check(game.clock==before,"Guide opened from pause keeps world paused")
 game.close_panel();check(not game.menu_paused,"Closing menu resumes world")
 game.state.opening=2;game.room_id="forge";game.state.tech.metallurgy=true
 for key in HoldData.ITEMS:game.state.add(key,30)
 game.open_panel("forge");await snap("forge")
 for i in [1,2]:
  game.forge_tab=i;game.open_panel("forge",false);await snap("forge-"+str(i))
 game.open_panel("equipment");game.gear_tab="armor";game.refresh_panel();await snap("armor")
 var equip_button:Button
 for b in game.panel_body.find_children("*","Button",true,false):
  if b.text=="Forge & equip Riveted holdguard mail":equip_button=b
 check(equip_button!=null and not equip_button.disabled,"Affordable unlocked armor can be forged at workbench")
 equip_button.pressed.emit();await settle();check(game.state.combat.armor=="mail" and "mail" in game.state.combat.owned,"Forge and equip updates ownership and equipped armor")
 game.close_panel();game.open_panel("inventory");var prior=game.tool;var event=InputEventKey.new();event.keycode=KEY_4;event.pressed=true;game._unhandled_input(event);check(game.tool==prior,"Menu key presses do not switch world tools")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame;print("UI22: %d checks passed" % checks);quit()
