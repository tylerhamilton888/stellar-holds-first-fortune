extends "res://tests/input_surface49.gd"
class Board extends Node2D:
 var time=0.0
 var chart=false
 var gender=0
 var carry=""
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("24393f"))
  draw_string(ThemeDB.fallback_font,Vector2(20,27),"0.52 · DRAWN GAIT / LOAD REGISTRATION",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ecd3a0"))
  var dirs=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]
  if chart:
   for row in 4:
    for col in 6:
     var p=HoldAppearance.defaults();p.gender=gender;p=HoldAppearance.normalized(p)
     var at=Vector2(80+col*160,145+row*122)
     draw_line(at+Vector2(-55,1),at+Vector2(55,1),Color("638182"),1)
     HoldDrawnAnimation.paint(self,at,p,dirs[row],true,col*HoldDrawnLocomotion.CYCLE/6,1,Vector2.ZERO,carry)
  else:
   for row in 4:
    for col in 4:
     var p=HoldAppearance.defaults();p.gender=row%2;p.sculpt=2 if row>=2 else 0;p=HoldAppearance.normalized(p)
     var at=Vector2(125+col*235,145+row*122)
     draw_line(at+Vector2(-55,1),at+Vector2(55,1),Color("638182"),1)
     HoldDrawnAnimation.paint(self,at,p,dirs[col],true,time,1,Vector2.ZERO,"double_mixed" if row>=2 else "")
func run():
 output="res://docs/testing/animation-0.52.0";DirAccess.make_dir_recursive_absolute(output)
 var movie="res://test-results/motion52";DirAccess.make_dir_recursive_absolute(movie)
 var board=Board.new();root.add_child(board)
 for gender in 2:
  for action in ["","carry_stone","double_mixed"]:
   board.gender=gender;board.carry=action;board.chart=true;board.queue_redraw()
   for i in 3:await process_frame
   await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(output+"/chart-"+str(gender)+"-"+(action if action!="" else "walk")+".png")
 board.chart=false
 for i in 24:
  board.time=float(i)*HoldDrawnLocomotion.CYCLE/24;board.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(movie+"/frame-%03d.png"%i)
 board.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("trail");settle();at(Vector2(700,700));await snap("idle-tool")
 var start=g.player;var clock=g.gait_clock;Input.action_press("right");await frames(30);Input.action_release("right")
 check(absf((g.gait_clock-clock)-g.player.distance_to(start)/185)<.001,"Gait follows actual distance moved")
 await snap("walk-tool");await frames(3);await snap("settled-tool")
 at(Vector2(90,700));clock=g.gait_clock;Input.action_press("left");await frames(12);Input.action_release("left")
 check(g.gait_clock==clock and not g.walking_pose,"Blocked travel plants feet and does not advance gait")
 at(Vector2(900,500));g.handworks.data().skills.mason=8
 g.handworks.spawn("stone",g.player,2);key(KEY_E);await frames(30);g.handworks.spawn("log",g.player,2);key(KEY_E);await frames(30)
 for direction in [Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT]:
  g.surface.direction=direction;await snap("carry-"+str(direction.x)+"-"+str(direction.y))
 check(g.handworks.data().carry.size()==2,"Directional posing preserves both owned loads")
 g.save_game();g.start_game(true);settle();check(g.handworks.data().carry.size()==2,"Pose changes preserve actual save/reload")
 g.handworks.drop()
 check(g.handworks.data().carry.size()==1 and g.handworks.lift==0,"Dropping one shoulder load keeps the other supported")
 g.handworks.drop()
 check(g.handworks.data().carry.is_empty() and not g.handworks.setting_down.is_empty(),"Final load uses the drawn set-down while retaining one resource owner")
 print("MOTION52: ",passed," passed / ",failed," failed");g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
