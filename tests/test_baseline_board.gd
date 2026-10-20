extends SceneTree
func _initialize():call_deferred("run")
func run():
 var view=SubViewport.new();view.size=Vector2i(1600,900);view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;view.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST;root.add_child(view)
 var background=ColorRect.new();background.color=Color("142331");background.size=Vector2(1600,900);view.add_child(background)
 var atlas=HoldSpriteAtlas.new();root.add_child(atlas)
 var painter=Node2D.new();view.add_child(painter)
 var profiles=[]
 var titles=[]
 for i in 12:
  var p=HoldAppearance.defaults()
  if i==1:p.gender=1;p.hair_style=1;p.beard_style=5
  elif i in [2,3]:p.beard_style=i-1
  elif i in [4,5]:p.hair_style=i-1;p.beard_style=5
  elif i in [6,7]:p.gender=1;p.hair_style=i-6;p.beard_style=5
  elif i in [8,9]:p.gender=i%2;p.hair_style=0 if p.gender==0 else 1;p.beard_style=0 if p.gender==0 else 5
  elif i in [10,11]:p.gender=i%2;p.hair_style=0 if p.gender==0 else 1;p.beard_style=0 if p.gender==0 else 5
  profiles.append(p);atlas.request(p)
  titles.append(["MALE BASELINE","FEMALE COUNTERPART","TWIN BRAIDS","FORKED BEARD","TOPKNOT / CLEAN SHAVEN","CROPPED / CLEAN SHAVEN","FEMALE TWIN BRAIDS","FEMALE CROWN BRAID","MALE STRIKE","FEMALE STRIKE","MALE STRIKE / LEFT","FEMALE STRIKE / LEFT"][i])
 painter.draw.connect(func():
  for i in 12:
   var origin=Vector2(i%4*400,i/4*300)
   HoldSpriteAtlas.paint(painter,origin+Vector2(240 if i>=10 else 160,282),4.1/12.0 if i>=8 else .1,false,-1 if i>=10 else 1,profiles[i],i>=8,Vector2.ZERO,-1,Color.WHITE,3)
 )
 for i in 12:
  var label=Label.new();label.position=Vector2(i%4*400+18,i/4*300+12);label.text=titles[i];label.add_theme_font_size_override("font_size",18);view.add_child(label)
 await create_timer(4).timeout;painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 var path=OS.get_environment("STELLAR_CAPTURE_DIR").path_join("baseline-board.png")
 view.get_texture().get_image().save_png(path);print("BASELINE BOARD: ",path);quit()
