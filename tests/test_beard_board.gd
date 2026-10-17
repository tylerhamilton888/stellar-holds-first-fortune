extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1600,700);view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;view.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST;root.add_child(view)
 var bg=ColorRect.new();bg.color=Color("142331");bg.size=Vector2(1600,700);view.add_child(bg)
 var atlas=HoldSpriteAtlas.new();root.add_child(atlas)
 for i in 10:
  var p=HoldAppearance.defaults();p.beard_style=i;atlas.request(p)
 var painter=Node2D.new();view.add_child(painter)
 painter.draw.connect(func():
  for i in 10:
   var p=HoldAppearance.defaults();p.beard_style=i
   var origin=Vector2(i%5*320,i/5*350)
   HoldCharacterBust.draw(painter,p,Rect2(origin+Vector2(10,44),Vector2(160,160)))
   HoldSpriteAtlas.paint(painter,origin+Vector2(235,295),0,false,1,p,false,Vector2.ZERO,-1,Color.WHITE,2)

 )
 for i in 10:
  var l=Label.new();l.text=HoldAppearance.BEARDS[i];l.position=Vector2(i%5*320+12,i/5*350+14);l.add_theme_font_size_override("font_size",20);view.add_child(l)
 await create_timer(2).timeout;await RenderingServer.frame_post_draw
 view.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("beard-board.png"));quit()
