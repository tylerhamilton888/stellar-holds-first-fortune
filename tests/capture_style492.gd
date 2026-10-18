extends "res://tests/input_readability48.gd"
func run():
 output="res://docs/testing/style-0.49.2";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle();g.open_panel("handworks")
 await snap("05-workshop-catalog")
 var buttons=[]
 for b in g.panel_body.find_children("*","Button",true,false):
  if b.text=="Craft & place":buttons.append(b)
 check(buttons.size()==6,"Six illustrated build choices use existing placement actions")
 check(buttons.back().get_global_rect().end.y<g.menu_scroll.get_global_rect().end.y,"All six craft buttons visible without scrolling")
 g.close_panel();g.surface.enter("trail",Vector2(950,340));settle();g.surface.action("mine");settle();await snap("06-entrance")
 print("STYLEUI492: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
