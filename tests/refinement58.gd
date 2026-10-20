extends SceneTree
const OUT="res://docs/testing/refinement58"
class Board extends Node2D:
 var page=0
 var time=0.0
 func figure(at:Vector2,p:Dictionary,d:Vector2,walking:bool,t:float,z:float,action:String,phase:float=0):
  draw_line(at+Vector2(-45,1),at+Vector2(45,1),Color("506363"),1)
  HoldWholeFrames.paint(self,at,p,d,walking,t,z,Vector2.ZERO,action,phase)
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("263b3e"))
  if page==0:
   HoldArt.text(self,Vector2(20,25),"Rear equipment · cropped crown / grand moustache · paired steps",18,Color("ead3a6"))
   for row in 6:
    var tool=["pick","axe","hammer","shovel","supply","rifle"][row]
    HoldArt.text(self,Vector2(24,85+row*85),tool,13,Color("c8c8bb"))
    for col in 4:
     var p=HoldAppearance.normalized({"sculpt":4+col/2,"hair_color":4})
     figure(Vector2(230+col*190,103+row*85),p,Vector2.UP,true,(.05+2*(col%2))*HoldWholeFrames.CYCLE/4,1.05,"hold_"+tool)
  elif page==1:
   HoldArt.text(self,Vector2(20,25),"Bun / bob axe continuity · corrected garden spade",18,Color("ead3a6"))
   for row in 3:
    var p=HoldAppearance.normalized({"gender":1,"sculpt":1 if row==0 else 4,"hair_color":2})
    for col in 4:figure(Vector2(110+col*230,180+row*175),p,Vector2.RIGHT,false,0,2.1,"axe" if row<2 else "shovel",[.05,.3,.6,.9][col])
  elif page==2:
   HoldArt.text(self,Vector2(20,25),"Carry review · stone / log · front and back paired keys",18,Color("ead3a6"))
   for row in 4:
    var p=HoldAppearance.normalized({"gender":row/2,"sculpt":0,"hair_color":4})
    for col in 4:figure(Vector2(125+col*230,145+row*130),p,Vector2.DOWN if col<2 else Vector2.UP,true,(.05+2*(col%2))*HoldWholeFrames.CYCLE/4,1.5,"carry_stone" if row%2==0 else "carry_log")
  elif page==3:
   HoldArt.text(self,Vector2(20,25),"Native motion review · one tool in both hands",18,Color("ead3a6"))
   for row in 3:
    for col in 4:
     var p=HoldAppearance.normalized({"sculpt":4 if col<2 else 5,"hair_color":6 if col%2==0 else 2})
     figure(Vector2(120+col*235,185+row*170),p,Vector2.UP,true,time,1.8,"hold_"+["pick","axe","hammer"][row])
  elif page==4:
   HoldArt.text(self,Vector2(20,25),"Bob · complete rifle poses · front / side / rear quarter / back",18,Color("ead3a6"))
   var p=HoldAppearance.normalized({"gender":1,"sculpt":4,"hair_color":2})
   for row in 2:
    for col in 4:figure(Vector2(110+col*240,245+row*250),p,[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col],true,(.05+row*2)*HoldWholeFrames.CYCLE/4,2.5,"hold_rifle")
  else:
   var p=HoldAppearance.normalized({"sculpt":4,"hair_color":4})
   for row in 6:
    for col in 8:figure(Vector2(55+col*120,85+row*88),p,[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][col/2],true,(.05+2*(col%2))*HoldWholeFrames.CYCLE/4,1.0,"hold_"+["pick","axe","hammer","shovel","supply","rifle"][row])
func _initialize():call_deferred("run")
func run():
 DirAccess.make_dir_recursive_absolute(OUT)
 var board=Board.new();board.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;root.add_child(board)
 for page in [0,1,2,4,5]:
  board.page=page;board.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(OUT+"/review-%d.png"%page)
 board.page=3
 DirAccess.make_dir_recursive_absolute(OUT+"/motion")
 for f in 32:
  board.time=float(f)/30;board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(OUT+"/motion/frame-%03d.png"%f)
 print("REFINEMENT58 NATIVE REVIEW COMPLETE")
 quit()
