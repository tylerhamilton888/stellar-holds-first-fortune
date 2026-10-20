extends SceneTree
var g
var output="/workspace/scratch/a447fc5d46ab/review431"
func _initialize():call_deferred("run")
func snap(name:String):
 g.notice_time=0;g.update_hud();g.queue_redraw()
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true
 await snap("06-title")
 g.start_game(true);g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
 for page in ["Rooms","Furnish","Finishes","Folk"]:
  g.deep.works.page=page;g.open_panel("living");await snap("menu-"+page.to_lower())
  print(page," bounds ",g.panel.get_global_rect()," scroll ",g.menu_scroll.get_v_scroll_bar().max_value)
  g.close_panel()
 for id in ["forge","inventory","research","haulage","projects"]:
  g.open_panel(id);await snap("menu-"+id);g.close_panel()
 for i in 3:
  g.research_tab=i;g.open_panel("research");await snap("research-"+str(i));g.close_panel()
 g.help_tab=1;g.open_panel("help");await snap("09-field-guide");g.close_panel()
 g.change_zone("hub");g.transition_left=0;g.transition_shade.visible=false;await snap("07-settlement")
 g.change_zone("road");g.transition_left=0;g.transition_shade.visible=false;await snap("08-pinewood")
 g.sound.stop_all();g.queue_free();await process_frame;quit()
