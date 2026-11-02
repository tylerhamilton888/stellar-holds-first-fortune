extends "res://tests/support/game_fixture.gd"
class Board:
 extends Node2D
 var profile:Dictionary
 var tick=0.0
 func candidate(at:Vector2,d:Vector2,walking:bool,time:float):
  var a=HoldStoryWorld105.descriptor(profile,d,walking,time,"town_walk",0,HoldWholeFrames.metadata)
  draw_set_transform(at)
  draw_texture_rect(HoldWholeFrames.texture(profile,a.sheet,a.index),a.destination,false)
  draw_set_transform(Vector2.ZERO)
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("183138"))
  var dirs=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]
  for view in 4:
   for key in 4:
    candidate(Vector2(110+key*180,105+view*100),dirs[view],true,key*.13+.001)
   candidate(Vector2(840,105+view*100),dirs[view],false,0)
  for view in 4:
   candidate(Vector2(160+view*200,510),dirs[view],true,tick)
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 root.size=Vector2i(960,540)
 var s=HoldState.new();s.reset(7105)
 var p=s.npc("road_folk:1")
 check(p.cast_id=="dagna","Road Dagna retains explicit identity")
 var original=JSON.stringify(p)
 HoldWholeFrames.data()
 # Quarantine must hold at the real rendering entry point for every activity,
 # not just when reading the allowlist. Keep the same identity through work.
 for id in HoldStoryWorld105.CAST:
  if id in HoldStoryWorld105.APPROVED:continue
  var named=HoldStoryArt105.tag(p,id)
  var baseline=named.duplicate(true);baseline.erase("cast_id")
  check(not HoldWholeFrames.metadata.has(HoldStoryWorld105.PREFIX+id+".webp"),"Candidate not loaded by production "+id)
  for action in ["","town_walk","pick","drink","carry_stone","push","hold_hammer","combat_axe"]:
   var same=true
   for d in [Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]:
    for moving in [false,true]:
     for key in 4:
      var actual=HoldWholeFrames.descriptor(named,d,moving,key*.13+.001,action,key*.25)
      var expected=HoldWholeFrames.descriptor(baseline,d,moving,key*.13+.001,action,key*.25)
      same=same and actual==expected
   check(same,"Quarantined identity preserves existing activity "+id+":"+action)
 HoldStoryWorld105.register(HoldWholeFrames.metadata,true)
 var dirs=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1),Vector2.UP]
 for id in HoldStoryWorld105.CAST:
  var named=HoldStoryArt105.tag(p,id)
  check(HoldStoryWorld105.has_profile(named)==(id in HoldStoryWorld105.APPROVED),"Only reviewed gait is active "+id)
  for d in dirs:
   for walking in [false,true]:
    for frame in 4:
     var a=HoldStoryWorld105.descriptor(named,d,walking,frame*.13+.001,"town_walk",0,HoldWholeFrames.metadata)
     check(a.sheet==HoldStoryWorld105.PREFIX+id+".webp","Candidate sheet selection (not gait approval) "+id)
     var tex=HoldWholeFrames.texture(named,a.sheet,a.index)
     check(tex!=null and tex.get_width()>0,"Named frame extracted "+id)
 var altered=p.duplicate();altered.hair_color=5;altered.cloth_color=4
 var a=HoldStoryWorld105.descriptor(p,Vector2.DOWN,false,0,"",0,HoldWholeFrames.metadata)
 check(HoldWholeFrames.texture(p,a.sheet,a.index)==HoldWholeFrames.texture(altered,a.sheet,a.index),"Saved background palettes do not dye named art")
 check(JSON.stringify(p)==original,"Rendering leaves saved appearance intact")
 check(not HoldStoryWorld105.has_profile(s.appearance),"Player stays on shared animation")
 check(not HoldStoryWorld105.has_profile(s.npc("ivar")),"Unreviewed bundles stay inactive")
 HoldWholeFrames.cache.clear();HoldWholeFrames.warm_jobs.clear()
 HoldWholeFrames.queue_story_profile(p,{})
 check(HoldWholeFrames.warm_jobs.size()==24,"Candidate cache helper covers locomotion and all four drink frames")
 for key in 4:
  var drink=HoldStoryWorld105.descriptor(p,Vector2.RIGHT,true,0,"drink",key,HoldWholeFrames.metadata)
  check(drink.index==20+key and drink.view==0 and not drink.walking,"Whole drink action selects authored key "+str(key))
  check(HoldWholeFrames.texture(p,drink.sheet,drink.index)!=null,"Whole drink key extracts "+str(key))
 while HoldWholeFrames.warming():HoldWholeFrames.warm_step()
 var board=Board.new();root.add_child(board)
 for id in HoldStoryWorld105.CAST:
  board.profile=HoldStoryArt105.tag(p,id)
  for key in 4:
   board.tick=key*.13+.001;board.queue_redraw()
   await process_frame;await RenderingServer.frame_post_draw
   root.get_texture().get_image().save_png(output+"/"+id+"-motion-"+str(key)+".png")
 board.queue_free();await process_frame
 HoldWholeFrames.sources.clear();HoldWholeFrames.cache.clear();HoldWholeFrames.order.clear()
 print("STORYWORLD105: ",passed," passed / ",failed," failed")
 quit(1 if failed else 0)
