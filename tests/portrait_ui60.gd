extends "res://tests/input_reference54.gd"
func snap(name:String):
 if g.playing:
  g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud()
 g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output="res://docs/testing/portraits60/ui";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false)
 await snap("title")
 g.open_creator(true);await snap("creator")
 var c=g.creator
 var old=c.portrait.viewport.get_texture().get_image().get_data()
 c.profile.hair_color=6;c.rebuild_options();c.update_preview();await snap("creator-grey")
 check(old!=c.portrait.viewport.get_texture().get_image().get_data(),"Creator colour change visibly refreshes the portrait")
 check(not c.portrait.get_global_rect().intersects(c.sprite.get_global_rect()),"Portrait and walking preview have separate readable space")
 for gender in 2:
  for sculpt in 7:
   c.profile.gender=gender;c.profile.sculpt=sculpt;c.update_preview()
   check(HoldPaintedPortraits.identity(c.portrait.profile)==("female" if gender else "male")+str(sculpt),"Creator preserves identity "+str(gender)+"/"+str(sculpt))
 c.profile.gender=1;c.profile.sculpt=6;c.profile.hair_color=2;c.rebuild_options();c.update_preview();await snap("creator-female")
 c.queue_free();await process_frame;g.skip_arrival=true;g.start_game(false);settle()
 for entry in [["commission","ivar"],["market","orla"],["forge","borin"],["tavern","hedrik"],["research","eldric"],["throne","eirik"]]:
  if entry[1]=="eirik":HoldOnboarding.ensure(g.state).stage=4;g.state.opening=2
  g.surface.enter("room:"+entry[0]);settle();g.talk_id=entry[1];g.talk_topic="";g.talk_line="";g.open_panel("conversation")
  await snap("dialogue-"+entry[1])
  var faces=g.panel.find_children("*","HoldPortrait",true,false)
  # Script class names are not native ClassDB types: inspect the actual nodes.
  if faces.is_empty():
   for node in g.panel.find_children("*","Control",true,false):
    if node is HoldPortrait:faces.append(node)
  check(faces.size()==1 and faces[0].profile.get("cast_id","")==entry[1],"Local dialogue uses the matching new portrait: "+entry[1])
  g.close_panel()
 g.open_panel("roster");await snap("roster");g.close_panel()
 g.open_panel("inventory");await snap("inventory");g.close_panel()
 var q=HoldOnboarding.ensure(g.state);q.fresh=true;q.stage=4
 g.surface.enter("room:throne");settle();g.opening_scene=HoldOpeningScene.begin(g,"audience")
 check(is_instance_valid(g.opening_scene),"Royal audience opens with updated portrait type")
 if is_instance_valid(g.opening_scene):
  g.opening_scene.step=1;g.opening_scene.show_line();g.opening_scene.shot_age=1;await snap("royal-audience")
  check(g.opening_scene.royal_portrait.visible and HoldPaintedPortraits.identity(g.opening_scene.royal_portrait.profile)=="eirik","Audience uses the painted enthroned Lord")
  g.opening_scene.layer.queue_free();g.opening_scene=null;await process_frame
 var story=HoldAnniversaryScene.new();story.game=g;story.layer=CanvasLayer.new();g.add_child(story.layer);story.layer.add_child(story)
 story.step=11;story.show_line();await snap("story-orla")
 check(story.portrait.profile.get("cast_id","")=="orla","Story captions switch to Orla's new portrait")
 story.layer.queue_free();await process_frame
 g.state.appearance=HoldAppearance.normalized({"gender":1,"sculpt":6,"hair_color":5,"cloth_color":3,"skin":2,"jewelry":1})
 g.save_game();var pack=g.state.inventory.duplicate(true);g.start_game(true);settle();g.open_panel("home");await snap("reloaded-player")
 var player_face:HoldPortrait
 for node in g.panel.find_children("*","Control",true,false):
  if node is HoldPortrait and node.profile.get("cast_id","")=="":player_face=node;break
 check(is_instance_valid(player_face) and HoldPaintedPortraits.identity(player_face.profile)=="female6" and player_face.profile.hair_color==5,"Reloaded player card displays the saved portrait, not a default or NPC")
 check(g.state.appearance.sculpt==6 and g.state.appearance.gender==1 and g.state.appearance.hair_color==5 and g.state.appearance.cloth_color==3,"Reload preserves exact portrait identity and colours")
 check(g.state.inventory==pack,"Portrait update does not alter inventory on save/reload")
 print("PORTRAIT UI60: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
