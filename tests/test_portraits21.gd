extends SceneTree
var board:Control
var checks=0
func _initialize():call_deferred("run")
func check(ok:bool,message:String):
 assert(ok,message);checks+=1
func label(text:String,pos:Vector2,size:int=17):
 var l=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",size);l.add_theme_color_override("font_color",Color("e4cca1"));board.add_child(l)
func capture(palette:int,tag:String):
 board=Control.new();root.add_child(board)
 var bg=ColorRect.new();bg.color=Color("0d202b");bg.size=Vector2(1280,720);board.add_child(bg)
 label("THE STELLAR HOLDS  /  PORTRAIT & SPRITE IDENTITIES  /  "+tag.to_upper(),Vector2(20,10),20)
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt;p.hair_color=palette;p.beard_color=(7 if palette==2 else palette);p.jewelry=3
   if palette==2:p.tattoo=1;p.jewelry=1;p.skin=3
   if palette==3:p.cloth_color=(sculpt+2)%8
   p=HoldAppearance.normalized(p)
   var x=sculpt*256;var y=46+gender*330
   var portrait=HoldPortrait.new();portrait.profile=p;portrait.position=Vector2(x+16,y+25);portrait.size=Vector2(208,208);board.add_child(portrait)
   label((HoldAppearance.FEMALE_SCULPTS if gender else HoldAppearance.SCULPTS)[sculpt],Vector2(x+16,y+3),17)
   var sprite=HoldSpritePreview.new();sprite.profile=p;sprite.position=Vector2(x+144,y+214);sprite.size=Vector2(90,102);board.add_child(sprite)
   label(HoldAppearance.HAIR_NAMES[p.hair_color]+(" / "+HoldAppearance.HAIR_NAMES[p.beard_color] if not gender else ""),Vector2(x+16,y+250),15)
   label("Complete design %d" % (sculpt+1),Vector2(x+16,y+274),13)
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(OS.get_environment("STELLAR_CAPTURE_DIR").path_join("portraits21-"+tag+".png"))
 board.queue_free();await process_frame
func run():
 root.content_scale_size=Vector2i(1280,720)
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"jewelry":3})
   var original=HoldCharacterBust.source(p).get_data()
   var baseline=HoldCharacterBust.texture(p).get_image()
   check(HoldCharacterBust.texture(p)==HoldCharacterBust.texture(p),"portrait cache reuses identical profile")
   for color in 8:
    p.hair_color=color;p.beard_color=color
    var result=HoldCharacterBust.texture(p).get_image()
    check(result.get_size()==Vector2i(192,192),"portrait dimensions stay fixed")
    check(result.get_pixel(2,2)==baseline.get_pixel(2,2),"hair color never tints backdrop")
    check(result.get_pixel(112,75)==baseline.get_pixel(112,75),"hair color preserves face skin")
    if sculpt==4 and gender==0:check(result.get_pixel(94,34)==baseline.get_pixel(94,34),"bald crown stays skin")
   p.cloth_color=5
   var clothed=HoldCharacterBust.texture(p).get_image()
   check(clothed.get_pixel(175,110)==baseline.get_pixel(175,110),"clothing palette preserves backdrop beside shoulder")
   check(HoldCharacterBust.source(p).get_data()==original,"palette conversion never changes source painting")
 await capture(1,"honey")
 await capture(5,"raven")
 await capture(7,"snow")
 await capture(2,"mixed-details")
 await capture(3,"npc-palettes")
 print("PORTRAIT21: %d checks passed; all ten identities captured in five palette/details sets" % checks)
 quit()
