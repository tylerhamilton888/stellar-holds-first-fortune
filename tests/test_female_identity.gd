extends SceneTree
var failed=0
var profile=HoldAppearance.defaults()
func check(ok:bool,message:String):
 if not ok:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 for seed_value in 100:
  var p=HoldAppearance.random_profile(seed_value,1)
  check(p.gender==1 and p.beard_style==5,"Random female cannot have facial hair")
 for beard in 6:
  var p=HoldAppearance.normalized({"gender":1,"beard_style":beard,"beard_color":7,"hair_color":2})
  check(p.beard_style==5 and p.beard_color==p.hair_color,"Female normalization discards beard options")
 var state=HoldState.new();state.reset(27419)
 state.appearance=HoldAppearance.random_profile(12,1);state.appearance.beard_style=0
 state.npc_appearances.orla=state.appearance.duplicate(true)
 var geo=Geology.new();geo.generate(27419);state.save_world(geo,"hub",Vector2(150,410))
 var loaded=HoldState.new();loaded.load_world(Geology.new())
 check(loaded.appearance.beard_style==5 and loaded.npc("orla").beard_style==5,"Legacy female player and NPC data are corrected on load")
 if DisplayServer.get_name()!="headless":
  var view=SubViewport.new();view.size=Vector2i(192,96);view.transparent_bg=true;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(view)
  var painter=Node2D.new();view.add_child(painter)
  painter.draw.connect(func():HoldCharacterArt.draw_sprite(painter,Vector2(48,85),.5,false,1,profile))
  var portrait=HoldPortrait.new();portrait.position=Vector2(96,0);portrait.size=Vector2(96,96);portrait.animate=false;view.add_child(portrait)
  for hair in 6:
   var baseline=PackedByteArray()
   for beard in [5,0,1,2,3,4]:
    profile=HoldAppearance.random_profile(12,1);profile.hair_style=hair;profile.beard_style=beard;profile.beard_color=beard
    portrait.apply_profile(profile);painter.queue_redraw()
    await process_frame;await process_frame;await RenderingServer.frame_post_draw
    var pixels=view.get_texture().get_image().get_data()
    if beard==5:baseline=pixels
    else:check(pixels==baseline,"Female portrait and sprite ignore invalid facial hair: %d/%d" % [hair,beard])
  view.queue_free()
 print("FEMALE IDENTITY: %d FAILED" % failed);quit(1 if failed else 0)
