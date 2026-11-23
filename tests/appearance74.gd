extends "res://tests/support/game_fixture.gd"
class IdentityBoard extends Node2D:
 var profile:Dictionary
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("243840"))
  for row in 4:
   var action=["town_walk","drink","hold_pick","carry_stone"][row]
   draw_string(ThemeDB.fallback_font,Vector2(14,20+row*130),action,HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("ead3a6"))
   for f in 4:
    HoldWholeFrames.paint(self,Vector2(150+f*200,125+row*130),profile,Vector2.RIGHT,row!=1,HoldWholeFrames.CYCLE*(f+.1)/4,1.55,Vector2.ZERO,action,float(f))
func capture_board(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
# Count visible pixels in a foot-sized region relative to the world-space root.
# Use the final dyed game-size texture so repeated contacts with different
# frame numbers cannot pass, including on a warmed animation cache.
func boot_ink(profile:Dictionary,direction:Vector2,action:String,key:int,area:Rect2i)->int:
 var pose=HoldWholeFrames.descriptor(profile,direction,true,(key+.1)*HoldWholeFrames.CYCLE/8.,action,0)
 var image=HoldWholeFrames.texture(profile,pose.sheet,pose.index).get_image()
 var origin=Vector2i(pose.root)
 var ink=0
 for y in range(area.position.y,area.end.y):
  for x in range(area.position.x,area.end.x):
   var sample=origin+Vector2i(x,y)
   if Rect2i(Vector2i.ZERO,image.get_size()).has_point(sample) and image.get_pixelv(sample).a>.5:ink+=1
 return ink

func check_boot_contacts(profile:Dictionary,action:String):
 var left=Rect2i(-23,0,18,11);var right=Rect2i(5,0,18,11)
 var first=boot_ink(profile,Vector2.DOWN,action,0,left)-boot_ink(profile,Vector2.DOWN,action,0,right)
 var second=boot_ink(profile,Vector2.DOWN,action,4,right)-boot_ink(profile,Vector2.DOWN,action,4,left)
 check(first>40 and second>40,"Left and right soles take distinct front contacts "+action)
 var heel=Rect2i(-29,-6,17,8);var toe=Rect2i(6,-2,18,9)
 var heel_change=boot_ink(profile,Vector2.RIGHT,action,3,heel)-boot_ink(profile,Vector2.RIGHT,action,7,heel)
 var toe_change=boot_ink(profile,Vector2.RIGHT,action,0,toe)-boot_ink(profile,Vector2.RIGHT,action,4,toe)
 check(heel_change>40 and toe_change>40,"Side-view heel and toe change support on the next half-cycle "+action)

func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 HoldWholeFrames.data()
 # An obsolete frame must never win over corrected source art.
 var p=HoldAppearance.defaults();var a=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,0,"",0)
 var old="user://animation-cache/0.66.0/"+HoldWholeFrames.cache_key(p,a.sheet,a.index).sha256_text()+".png"
 DirAccess.make_dir_recursive_absolute(old.get_base_dir())
 var poison=Image.create(1,1,false,Image.FORMAT_RGBA8);poison.fill(Color.MAGENTA);poison.save_png(old)
 check(HoldWholeFrames.texture(p,a.sheet,a.index).get_width()>1,"Obsolete disk frames cannot replace the corrected artwork")
 for action in ["","hold_pick","hold_axe","hold_hammer","hold_shovel","hold_supply","hold_rifle"]:
  check_boot_contacts(p,action)
 var greatbeard=HoldAppearance.normalized({"gender":0,"sculpt":2})
 for f in 4:
  var drinking=HoldWholeFrames.descriptor(greatbeard,Vector2.RIGHT,false,0,"drink",f)
  var frame=HoldWholeFrames.metadata[drinking.sheet][drinking.index]
  check(frame.rect[1]+frame.rect[3]>=737 and frame.root[1]>=735,"Greatbeard drinking crop retains the complete boot baseline: "+str(f))
 var board=IdentityBoard.new();root.add_child(board)
 for gender in 2:
  for sculpt in 7:
   p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":6})
   var low=INF;var high=-INF;var shared=true;var stable=true
   for f in 4:
    var t=HoldWholeFrames.CYCLE*(f+.1)/4
    var actor=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,t,"",0)
    var citizen=HoldWholeFrames.descriptor(p,Vector2.RIGHT,true,t,"town_walk",0)
    shared=shared and actor.sheet==citizen.sheet and actor.index==citizen.index
    var h=actor.destination.size.y;low=minf(low,h);high=maxf(high,h)
    var tx=HoldWholeFrames.texture(p,actor.sheet,actor.index,true)
    var changed=p.duplicate();changed.hair_color=2
    var other=HoldWholeFrames.texture(changed,actor.sheet,actor.index,true)
    stable=stable and tx!=other and tx.get_size()==other.get_size() and HoldWholeFrames.texture(p,actor.sheet,actor.index,true)==tx
   var contact=HoldWholeFrames.metadata[HoldWholeFrames.identity(p)+"-town"][8]
   var canonical=HoldWholeFrames.metadata[HoldWholeFrames.identity(p)+"-core"][8]
   var inherited=contact.get("source","")==canonical.get("source",HoldWholeFrames.identity(p)+"-core")
   check(inherited or sculpt==6,"Town contacts retain corrected canonical hair and beard artwork: "+HoldWholeFrames.identity(p))
   check(shared,"Player and town walks use the same complete identity: "+HoldWholeFrames.identity(p))
   check(high-low<6.0,"Walk crown/sole envelope stays within six world pixels: "+HoldWholeFrames.identity(p))
   check(stable,"Hair selection changes pigment without changing geometry or reusing another palette: "+HoldWholeFrames.identity(p))
   board.profile=p;board.queue_redraw();await capture_board(HoldWholeFrames.identity(p))
 board.queue_free();await process_frame
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.open_creator(false)
 var creator=g.creator;creator.profile=HoldAppearance.normalized({"gender":1,"sculpt":6,"hair_color":2});creator.rebuild_options();creator.update_preview()
 check(creator.sprite.profile==creator.portrait.profile,"Creator portrait and live sprite share the selected identity")
 for mode in ["idle","walk","work","carry"]:
  creator.sprite.motion=mode;creator.sprite.clock=.22;await snap("creator-"+mode)
 creator.cancelled.emit();await process_frame
 g.surface.enter("hearthward");settle();at(Vector2(620,600));await snap("town")
 var routines=g.surface.world.routines;routines.ensure()
 var consistent=true
 for plan in routines.plans:
  var before=routines.sample(plan,10).profile;var after=routines.sample(plan,210).profile
  consistent=consistent and before==after
 check(consistent,"Background residents retain the same saved appearance across their routines")
 g.surface.enter("room:tavern");settle();await snap("tavern")
 g.save_game();var look=g.state.appearance.duplicate();g.start_game(true);settle()
 check(g.state.appearance==look,"Appearance survives save/reload without migrating names, palettes or sculpts")
 print("APPEARANCE74: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
