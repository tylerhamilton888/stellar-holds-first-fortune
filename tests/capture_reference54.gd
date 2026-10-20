extends SceneTree
class Plate extends Node2D:
 var mode="variants"
 var phase=0.0
 func label(p:Vector2,s:String,size:int=16):draw_string(ThemeDB.fallback_font,p,s,HORIZONTAL_ALIGNMENT_LEFT,-1,size,Color("ecd2a1"))
 func _draw():
  draw_rect(Rect2(0,0,1440,1100),Color("14272e"))
  if mode=="variants":
   label(Vector2(30,40),"THE STELLAR HOLDS / REFERENCE-LED FOLK",28)
   label(Vector2(30,72),"Seven male and seven female designs · actual in-game rendering",18)
   for gender in 2:
    for sculpt in 7:
     var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":2 if gender else 3,"cloth_color":0})
     var x=104+sculpt*205;var y=320+gender*480
     HoldFolk.paint(self,Vector2(x,y),p,Vector2.DOWN,false,0,2.6,Vector2.ZERO)
     HoldFolk.paint(self,Vector2(x-40,y+140),p,Vector2(1,-1),false,0,1.6,Vector2.ZERO)
     HoldFolk.paint(self,Vector2(x+40,y+140),p,Vector2.UP,false,0,1.6,Vector2.ZERO)
     label(Vector2(x-92,y+175),(HoldAppearance.FEMALE_SCULPTS if gender else HoldAppearance.SCULPTS)[sculpt],14)
  else:
   label(Vector2(30,40),"DRAWN MOTION / "+mode.to_upper(),28)
   var actions=["","pick","axe","hammer","drink","carry_stone","carry_log","double_stone","double_log","double_mixed","push","water"]
   var dirs=[Vector2.DOWN,Vector2(1,1),Vector2(1,-1),Vector2.UP]
   for gender in 2:
    for i in 12:
     var x=125+(i%6)*235;var y=280+int(i/6)*235+gender*470
     var p=HoldAppearance.normalized({"gender":gender,"sculpt":1 if gender else 3,"hair_color":2,"cloth_color":0})
     var action=actions[i];var d=Vector2.RIGHT
     if mode=="walk":action="";d=dirs[int(i/3)];
     var time=(float(i%6)+.1)/6*HoldFolk.CYCLE if mode=="walk" else phase*HoldFolk.CYCLE
     HoldFolk.paint(self,Vector2(x,y),p,d,mode=="walk" or action.begins_with("carry") or action.begins_with("double") or action=="push",time,2.3,Vector2.ZERO,action,2 if action=="drink" else phase)
     label(Vector2(x-80,y+25),("walk "+str(i) if mode=="walk" else action),16)
func _initialize():call_deferred("run")
func run():
 root.size=Vector2i(1440,1100);root.content_scale_size=root.size
 var p=Plate.new();root.add_child(p)
 for mode in ["variants","walk","work"]:
  p.mode=mode;p.phase=.55;p.queue_redraw()
  for i in 3:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/testing/reference-0.54.0/"+mode+".png")
 p.queue_free();await process_frame;quit()
