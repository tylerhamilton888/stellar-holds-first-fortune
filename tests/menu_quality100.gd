extends "res://tests/support/game_fixture.gd"

func capture_screen(name:String):
 g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")

func run():
 output=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://menu-quality"
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 check(not g.playing and not g.energy_button.visible and not g.energy_bar.visible and not g.calendar_button.visible,"Gameplay HUD is hidden on initial title")
 check(not g.depth_nav.map_button.visible and not g.depth_nav.view_button.visible and not g.depth_nav.controls_button.visible,"Mine controls are hidden on initial title")
 await capture_screen("01-title")
 g.open_panel("save_slots");await capture_screen("02-save-slots")
 check(not g.energy_button.visible and not g.energy_bar.visible and not g.calendar_button.visible,"Gameplay HUD stays hidden in title panels")
 check(g.menu_shade.visible,"Title panel blocks background controls")
 g.close_panel();g.open_panel("settings");await capture_screen("03-title-settings");g.close_panel()
 for b in g.title_ui.find_children("*","Button",true,false):
  if b.text=="First visit to the hold":b.pressed.emit();break
 check(g.first_visit_pending,"First visit selection is remembered while choosing a slot")
 g.close_panel()
 for b in g.title_ui.find_children("*","Button",true,false):
  if b.text=="Continue / choose a fortune":b.pressed.emit();break
 check(not g.first_visit_pending,"Returning to ordinary fortunes clears the first-visit selection")
 g.close_panel()
 g.open_creator(true);await capture_screen("04-creator")
 g.creator.cancelled.emit();await process_frame
 g.start_game(false);settle();g.update_hud()
 check(g.energy_button.visible and g.energy_bar.visible and g.calendar_button.visible,"Gameplay HUD appears during play")
 for id in ["inventory","equipment","disciplines","commission","calendar","settings","pause"]:
  g.open_panel(id,false);await capture_screen("05-"+id)
  check(not g.energy_button.visible or not g.energy_button.is_visible_in_tree(),id+" hides the energy HUD")
  check(not g.hud.visible and not g.footer.visible and g.menu_shade.visible,id+" hides world HUD and focuses the menu")
  var rect=g.panel.get_global_rect()
  check(rect.position.x>=0 and rect.position.y>=0 and rect.end.x<=960 and rect.end.y<=540,id+" stays in the viewport")
  if id=="calendar":
   var labels=g.panel.find_children("*","Label",true,false)
   check(labels.any(func(l):return l.text.contains("Scroll for more")),"Long pages indicate when content continues below")
   var bar=g.menu_scroll.get_v_scroll_bar();bar.value=bar.max_value-bar.page
   check(labels.any(func(l):return l.text.contains("Scroll up")),"Scroll hint follows the reader to the bottom")
  g.close_panel();g.update_hud()
 g.show_title()
 check(not g.energy_button.visible and not g.energy_bar.visible and not g.calendar_button.visible,"Returning to title immediately hides gameplay HUD")
 check(not g.depth_nav.map_button.visible and not g.depth_nav.view_button.visible and not g.depth_nav.controls_button.visible and not g.menu_shade.visible,"Returning to title clears mine controls and menu shade")
 await capture_screen("06-return-title")
 print("MENUQUALITY100: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
