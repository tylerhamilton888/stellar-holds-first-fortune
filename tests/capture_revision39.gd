extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
class GripBoard extends Node2D:
 var f=0
 var facing=1
 var gender=0
 var all_designs=false
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("21343e"))
  draw_string(ThemeDB.fallback_font,Vector2(26,33),"PICKAXE GRIP / COMPLETE WORK POSES / FIXED HANDLE",HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color("e9cfa1"))
  if all_designs:
   for sex in 2:
    for design in 5:
     var profile=HoldAppearance.normalized({"gender":sex,"sculpt":design,"hair_color":5})
     var p=Vector2(90+design*190,245+sex*250)
     HoldCharacterArt.draw_sprite(self,p,(f+.1)/12,false,facing,profile,true,Vector2.ZERO,true,1.55)
     draw_string(ThemeDB.fallback_font,p+Vector2(-60,27),HoldCharacterDesigns.id(profile),HORIZONTAL_ALIGNMENT_LEFT,-1,15)
  else:
   for sex in 2:
    var profile=HoldAppearance.normalized({"gender":sex,"sculpt":0,"hair_color":5})
    for side in [-1,1]:
     var p=Vector2(250 if side==1 else 710,260 if sex==0 else 505)
     HoldCharacterArt.draw_sprite(self,p,(f+.1)/12,false,side,profile,true,Vector2.ZERO,true,2.2)
func _initialize():call_deferred("run")
func snap(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/stellar-holds/tools/quality39/"+name+".png")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.transition_left=0;g.transition_shade.visible=false
 g.grounded=true;g.zone="hub";g.state.opening=2;g.state.active_site="hold";HoldOnboarding.ensure(g.state).stage=6
 for room in ["throne","commission","market","tavern"]:
  g.room_id=room;g.player=Vector2(510,410);g.camera=Vector2.ZERO;g.update_hud();g.queue_redraw()
  if room=="throne":await snap("king-world")
  HoldConversation.start(g,HoldInteriors.ROOMS[room].host);g.queue_redraw();await snap("talk-"+room);g.close_panel()
 g.room_id="market";g.anniversary_host="orla";g.open_panel("anniversary");g.queue_redraw();await snap("orla-secret")
 HoldAnniversary.accept(g.state,"orla",true);g.refresh_panel();await snap("orla-carving");g.close_panel()
 for id in ["hedrik","orla"]:
  if HoldAnniversary.gift(g.state,id).is_empty():HoldAnniversary.accept(g.state,id,true)
  HoldAnniversary.prepare(g.state,id,1,true)
  for key in HoldAnniversary.cost(0,id):g.state.add(key,HoldAnniversary.cost(0,id)[key])
  HoldAnniversary.deliver(g.state,id,true)
 g.room_id="market";g.anniversary_host="orla";g.open_panel("anniversary");await snap("orla-invites");g.close_panel()
 g.room_id="";g.state.region_travel={};g.state.hold_travel={};g.open_panel("world_map");var m=g.overworld;m.set_process(false)
 for level in 3:
  m.change_floor(level*7+3);m.floor_pos=Vector2(945,670);m.floor_camera=Vector2(465,325);m.update_info();m.queue_redraw();await snap("district"+str(level))
  m.floor_pos=Vector2(570,365);m.floor_camera=Vector2(90,85);m.queue_redraw();await snap("doors"+str(level))
 m.floor_pos=Vector2(1636,878);m.floor_camera=Vector2(920,540);m.level=1;m.queue_redraw();await snap("lift-table")
 m.toggle_view();m.queue_redraw();await snap("whole-hold");g.close_panel()
 g.room_id="";g.zone="hub";g.player=Vector2(1405,410);g.camera=Vector2(930,0);g.update_hud();g.queue_redraw();await snap("concourse-table")
 g.zone="mine";g.player=Vector2(160,392);g.camera=Vector2(0,32);g.update_hud();g.queue_redraw();await snap("mine-arrival")
 # Actual game aiming at close/far contact, mirrored and airborne.
 for sex in 2:
  g.state.appearance=HoldAppearance.normalized({"gender":sex,"hair_color":5});g.grounded=sex==0
  for direction in [-1,1]:
   g.face=direction;g.player=Vector2(280,370);g.camera=Vector2.ZERO;g.hit_point=g.player+Vector2(direction*48,-35);g.swing_duration=.38
   for f in 8:
    g.swing=.38*(1-(f+.1)/8);g.queue_redraw();await snap("game-grip-"+str(sex)+"-"+str(direction)+"-"+str(f))
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 var b=GripBoard.new();root.add_child(b)
 for f in 8:b.f=f;b.queue_redraw();await snap("grip"+str(f))
 b.all_designs=true
 for f in 8:b.f=f;b.queue_redraw();await snap("all-grips"+str(f))
 b.queue_free();await process_frame;quit()
