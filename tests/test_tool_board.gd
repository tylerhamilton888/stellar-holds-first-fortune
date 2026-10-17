extends SceneTree
func _initialize():call_deferred("run")
func run():
 var v=SubViewport.new();v.size=Vector2i(1600,850);v.render_target_update_mode=SubViewport.UPDATE_ALWAYS;v.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST;root.add_child(v)
 var back=ColorRect.new();back.color=Color("142331");back.size=v.size;v.add_child(back)
 # Separate scaled painters preserve the source pixels and actual grip helpers.
 for row in 2:
  for kind in 4:
   var p=HoldAppearance.defaults();p.gender=row;p.hair_style=0 if row==0 else 1;p.beard_style=0 if row==0 else 5
   var facing=1 if row==0 else -1
   var actor=Node2D.new();actor.position=Vector2(kind*400+(180 if row==0 else 220),row*425+350);actor.scale=Vector2.ONE*3;v.add_child(actor)
   actor.draw.connect(func():
    var frame=4
    HoldCharacterArt.draw_sprite(actor,Vector2.ZERO,(frame+.1)/12,false,facing,p,true,Vector2.ZERO,false)
    var hand=HoldCharacterArt.work_hand(frame,p)*Vector2(facing,1)
    var end=Vector2(67*facing,-53)
    HoldCharacterArt.draw_tool(actor,hand,end,kind,Vector2.ZERO,facing)
    HoldCharacterArt.draw_grip(actor,Vector2.ZERO,frame,p,facing)
    actor.draw_circle(end,1,Color("ffce70"))
   )
   var label=Label.new();label.position=Vector2(kind*400+18,row*425+18);label.text=["PICK / POINT","SHOVEL / BLADE","AXE / EDGE","HAMMER / FACE"][kind]+("\nMALE / RIGHT" if row==0 else "\nFEMALE / LEFT");label.add_theme_font_size_override("font_size",19);v.add_child(label)
 await create_timer(2).timeout;await RenderingServer.frame_post_draw
 v.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("tool-contacts.png"));print("TOOL BOARD SAVED");quit()
