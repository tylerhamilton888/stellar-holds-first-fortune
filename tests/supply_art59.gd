extends "res://tests/input_reference54.gd"
class Board extends Node2D:
 var hotbar
 var state
 var profile={}
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  HoldArt.text(self,Vector2(18,24),"Supported inventory · "+HoldWholeFrames.identity(profile)+" · stone in the actual pack",17,Color("ead3a6"))
  for view in 2:
   for k in 4:
    HoldWholeFrames.paint(self,Vector2(140+k*220,245+view*260),profile,Vector2.DOWN if view==0 else Vector2.RIGHT,true,(k+.1)*HoldWholeFrames.CYCLE/4,2.1,Vector2.ZERO,"hold_supply")
func run():
 var args=OS.get_cmdline_user_args();output=args[0]
 var ids=args[1].split(",") if args.size()>1 else []
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.add("stone",3);g.hotbar.select(6);g.hotbar.set_process(false);g.hotbar.hide()
 var b=Board.new();b.hotbar=g.hotbar;b.state=g.state;b.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(b)
 for gender in 2:
  for sculpt in 7:
   var id=("female" if gender else "male")+str(sculpt)
   if not ids.is_empty() and id not in ids:continue
   b.profile=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":1})
   b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/"+HoldWholeFrames.identity(b.profile)+".png")
 print("MOTION59 SUPPLY ART COMPLETE: requested identities, actual pack contents behind painted hands and rim")
 g.sound.stop_all();g.queue_free();b.queue_free();await process_frame;quit()
