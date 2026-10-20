extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1200,720);view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(view)
 var ground=ColorRect.new();ground.color=Color("0c202b");ground.size=Vector2(1200,720);view.add_child(ground)
 var atlas=HoldSpriteAtlas.new();root.add_child(atlas)
 for i in 24:
  var p=HoldAppearance.defaults();var title=""
  if i<6:p.hair_style=i;p.beard_style=5;title=HoldAppearance.MALE_HAIR[i]
  elif i<12:p.beard_style=i-6;title=HoldAppearance.BEARDS[i-6]
  elif i<18:p.gender=1;p.hair_style=i-12;p.beard_style=5;p.hair_color=2;title=HoldAppearance.FEMALE_HAIR[i-12]
  else:p.gender=i%2;p.hair_style=i%6;p.outfit=i%3;p.tattoo=i%4;p.jewelry=i%4;p.cloth_color=i%8;title="Outfit %d / markings %d" % [p.outfit,p.tattoo]
  var origin=Vector2((i%6)*200,(i/6)*180)
  var portrait=HoldPortrait.new();portrait.profile=p;portrait.animate=false;portrait.position=origin+Vector2(6,8);portrait.size=Vector2(116,116);view.add_child(portrait)
  var sprite=HoldSpritePreview.new();sprite.profile=p;sprite.motion="idle";sprite.position=origin+Vector2(119,36);sprite.size=Vector2(80,80);view.add_child(sprite)
  var label=Label.new();label.text=title;label.position=origin+Vector2(8,136);label.add_theme_font_size_override("font_size",13);view.add_child(label)
 await create_timer(3).timeout;await RenderingServer.frame_post_draw
 var out=OS.get_environment("STELLAR_CAPTURE_DIR")
 var result=view.get_texture().get_image().save_png(out.path_join("character-audit.png"))
 print("CHARACTER AUDIT CAPTURE: ",result)
 quit(result)
