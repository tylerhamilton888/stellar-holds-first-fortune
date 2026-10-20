extends SceneTree
const ACTIONS=["hold_pick","hold_axe","hold_hammer","hold_shovel","hold_supply","hold_rifle","carry_stone","carry_log","double_stone","double_log","double_mixed"]
const VIEWS=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]
class Board extends Node2D:
 var profile={}
 var view=0
 var start=0
 var moving=false
 var clock=0.0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  HoldArt.text(self,Vector2(18,22),"Whole-character movement · "+HoldWholeFrames.identity(profile)+" · "+["front","side","rear quarter","back"][view],17,Color("ead3a6"))
  for row in mini(6,11-start):
   var action=ACTIONS[start+row]
   HoldArt.text(self,Vector2(12,64+row*80),action.trim_prefix("hold_").replace("_"," "),11,Color("c8bc9f"))
   for key in 4:
    var at=Vector2(210+key*215,108+row*80)
    draw_line(at+Vector2(-35,0),at+Vector2(35,0),Color("405656"),1)
    HoldWholeFrames.paint(self,at,profile,VIEWS[view],true,clock if moving else (key+.1)*HoldWholeFrames.CYCLE/4,1.05,Vector2.ZERO,action)
func _initialize():call_deferred("run")
func run():
 var args=OS.get_cmdline_user_args();var out=args[0] if args.size()>0 else "res://docs/testing/motion59/art"
 var ids=args[1].split(",") if args.size()>1 else ["male0"]
 DirAccess.make_dir_recursive_absolute(out);HoldWholeFrames.data()
 var b=Board.new();b.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(b)
 for id in ids:
  b.profile=HoldAppearance.normalized({"gender":1 if id.begins_with("female") else 0,"sculpt":int(id.right(1)),"hair_color":1})
  for view in 4:
   b.view=view
   for start in [0,6]:
    b.start=start;b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png(out+"/%s-%d-%d.png"%[id,view,start])
  if id in ["male0","female0"]:
   b.moving=true;b.view=1;b.start=6;DirAccess.make_dir_recursive_absolute(out+"/"+id+"-motion")
   for frame in 32:
    b.clock=float(frame)/30;b.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png(out+"/%s-motion/frame-%03d.png"%[id,frame])
   b.moving=false
 print("MOTION59 ART COMPLETE: ",ids)
 quit()
