extends SceneTree
class Board extends Node2D:
 var page=0
 var kind="core"
 var time=0.0
 var sculpt=5
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  HoldArt.text(self,Vector2(18,23),"Folk quality review · whole painted characters",17,Color("ead3a6"))
  if page==0:
   for row in 7:
    var p=HoldAppearance.normalized({"sculpt":row,"hair_color":[4,1,2,6,0,3,5][row]})
    for col in 8:
     var action=["","","pick","axe","hammer","drink","carry_stone","hold_rifle"][col]
     HoldWholeFrames.paint(self,Vector2(60+col*118,96+row*72),p,Vector2.DOWN if col==0 else Vector2.RIGHT,false,0,.95,Vector2.ZERO,action,2 if col==5 else .6)
  elif page==1:
   var p=HoldAppearance.normalized({"sculpt":sculpt,"hair_color":3})
   var sheet="male"+str(sculpt)+"-"+kind
   for i in HoldWholeFrames.metadata[sheet].size():
    var m=HoldWholeFrames.metadata[sheet][i];var r=m.rect;var scale=54.0/m.height
    var at=Vector2(54+(i%8)*119,99+(i/8)*62)
    draw_texture_rect(HoldWholeFrames.texture(p,sheet,i),Rect2(at+(Vector2(r[0],r[1])-Vector2(m.root[0],m.root[1]))*scale,Vector2(r[2],r[3])*scale),false)
  elif page in [2,5]:
   for row in 7:
    var p=HoldAppearance.normalized({"gender":1 if page==5 else 0,"sculpt":row,"hair_color":[4,1,2,6,0,3,5][row]})
    for col in 4:HoldWholeFrames.paint(self,Vector2(115+col*235,98+row*72),p,Vector2.RIGHT,false,0,.95,Vector2.ZERO,"axe",[.05,.3,.6,.9][col])
  elif page==3:
   for row in 3:
    for col in 4:
     var p=HoldAppearance.normalized({"sculpt":5,"hair_color":[1,3,6,7][col]})
     HoldWholeFrames.paint(self,Vector2(110+col*240,177+row*175),p,Vector2.RIGHT,true,time,1.8,Vector2.ZERO,["","hold_pick","carry_stone"][row])
  else:
   for row in 3:
    var p=HoldAppearance.normalized({"sculpt":5,"hair_color":3})
    for col in 4:HoldWholeFrames.paint(self,Vector2(110+col*240,177+row*175),p,Vector2.RIGHT,false,0,1.8,Vector2.ZERO,["pick","axe","drink"][row],float(col) if row==2 else [.05,.3,.6,.9][col])
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://docs/testing/quality58/art"
 DirAccess.make_dir_recursive_absolute(out);HoldWholeFrames.data()
 var b=Board.new();b.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(b)
 for page in [0,1,2,4,5]:
  b.page=page
  for kind in (["core","utility","handling","equipped"] if page==1 else ["overview"]):
   for sculpt in ([2,3,4,5] if page==1 else [5]):
    b.sculpt=sculpt;b.kind=kind;b.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png(out+"/%d-%s-%d.png"%[page,kind,sculpt])
 DirAccess.make_dir_recursive_absolute(out+"/motion");b.page=3
 for f in 32:
  b.time=float(f)/30;b.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(out+"/motion/frame-%03d.png"%f)
 print("QUALITY58 ART COMPLETE: male identity, all revised keys, axes, motion")
 quit()
