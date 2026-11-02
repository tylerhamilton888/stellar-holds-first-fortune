extends SceneTree
class Board:
 extends Node2D
 var profiles=[]
 var key=0
 var individual=""
 var font=ThemeDB.fallback_font
 func paint(p:Dictionary,at:Vector2,d:Vector2,walk:bool,k:int,action:String="town_walk",zoom:float=1.5):
  var phase=float(k) if action=="drink" else [0.0,.3,.6,.85][k]
  var a=HoldWholeFrames.descriptor(p,d,walk,k*.13+.001,action,phase)
  draw_set_transform(at,0,Vector2.ONE*zoom)
  draw_texture_rect(HoldWholeFrames.texture(p,a.sheet,a.index),a.destination,false)
  draw_set_transform(Vector2.ZERO)
 func _draw():
  draw_rect(Rect2(0,0,1200,1100),Color("183138"))
  if individual!="":
   var p=profiles[0]
   draw_string(font,Vector2(24,32),individual.capitalize()+" · complete work poses · actual game renderer",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
   for col in 4:draw_string(font,Vector2(220+col*255,64),["Ready","Raised","Contact","Recover"][col],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
   for row in 5:
    if individual=="odrin" and row!=1:continue
    draw_string(font,Vector2(20,220+row*190),["Drink","Hammer","Front pick","Side pick","Back pick"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,18)
    for k in 4:
     var action="drink" if row==0 else "hammer" if row==1 else "pick"
     var d=Vector2.DOWN if row in [0,2] else Vector2.UP if row==4 else Vector2.RIGHT
     paint(p,Vector2(230+k*255,235+row*190),d,false,k,action,2.0)
   return
  draw_string(font,Vector2(24,30),"Final named cast · actual game poses at 1.5×",HORIZONTAL_ALIGNMENT_LEFT,-1,22)
  for row in 8:draw_string(font,Vector2(15,155+row*128),["Front","Side","Rear quarter","Back","Rest","Drink","Hammer","Pick"][row],HORIZONTAL_ALIGNMENT_LEFT,-1,15)
  for col in profiles.size():
   var p=profiles[col];var x=210+col*215
   draw_string(font,Vector2(x-35,62),str(p.cast_id).capitalize(),HORIZONTAL_ALIGNMENT_LEFT,-1,20)
   for row in 8:
    if p.cast_id=="odrin" and row in [5,7]:continue
    var action=["town_walk","drink","hammer","pick"][maxi(0,row-4)]
    var d=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP][row%4] if row<5 else Vector2.RIGHT
    paint(p,Vector2(x,180+row*128),d,row<4,key,action)
func _initialize():call_deferred("run")
func run():
 var out=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(out)
 HoldWholeFrames.cache_directory=out+"/cache-"+str(Time.get_ticks_usec());DirAccess.make_dir_recursive_absolute(HoldWholeFrames.cache_directory)
 HoldWholeFrames.data()
 var board=Board.new();var profiles=[]
 for id in ["dagr","odrin","osvik","tovan","kelvar"]:profiles.append(HoldStoryArt105.tag(HoldAppearance.random_profile(7313,0),id))
 board.profiles=profiles
 root.size=Vector2i(1200,1100);root.content_scale_size=root.size;root.add_child(board)
 for key in 4:
  board.key=key;board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/frame-"+str(key)+".png")
 for id in ["dagr","odrin","osvik","tovan","kelvar","yrsa"]:
  board.individual=id;board.profiles=[HoldStoryArt105.tag(HoldAppearance.random_profile(7313,0),id)]
  board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(out+"/"+id+"-actions.png")
 board.queue_free();await process_frame;quit()
