extends SceneTree
var passed=0
var failed=0
const OUT="/workspace/scratch/dc3395c394d3/tools/palette33/"
func check(ok:bool,message:String):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func compare(a:Image,b:Image,key:String):
 var mask=HoldCharacterMaterials.mask_for(key,a.get_width(),a.get_height())
 check(mask.size()==a.get_width()*a.get_height(),key+" mask dimensions")
 var changed=0;var leaked=0
 for y in a.get_height():
  for x in a.get_width():
   if a.get_pixel(x,y)!=b.get_pixel(x,y):
    changed+=1
    if mask[y*a.get_width()+x]!=1:leaked+=1
 check(changed>10,key+" color responds")
 check(leaked==0,key+" preserves all non-hair materials")
func _initialize():call_deferred("run")
func run():
 for gender in 2:
  for sculpt in 5:
   var a=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":0,"beard_color":7})
   var b=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":7,"beard_color":0})
   check(a.beard_color==a.hair_color and b.beard_color==b.hair_color,"Legacy colors linked")
   var id=HoldCharacterDesigns.id(a)
   compare(HoldCharacterBust.texture(a).get_image(),HoldCharacterBust.texture(b).get_image(),id+"-portrait")
   for f in 16:compare(HoldCharacterArt.frame_texture(gender,f,a).get_image(),HoldCharacterArt.frame_texture(gender,f,b).get_image(),id+"-normal-"+str(f))
   for mode in ["combat","walk","guard"]:
    for f in (8 if mode=="combat" else 4):
     var frame=f*2 if mode=="walk" else f
     var info=HoldShieldActor.pose(a,frame,mode)
     compare(HoldShieldActor.texture(a,info).get_image(),HoldShieldActor.texture(b,info).get_image(),id+"-"+info.id)
   # Full palette sheet from the actual game texture code, not a separate renderer.
   var board=Image.create(8*262,390,false,Image.FORMAT_RGBA8);board.fill(Color("172833"))
   for color in 8:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":color})
    var portrait=HoldCharacterBust.texture(p).get_image();portrait.convert(Image.FORMAT_RGBA8)
    board.blit_rect(portrait,Rect2i(0,0,192,192),Vector2i(color*262+35,0))
    for f in [0,10]:
     var img=HoldCharacterArt.frame_texture(gender,f,p).get_image()
     board.blend_rect(img,Rect2i(Vector2i.ZERO,img.get_size()),Vector2i(color*262+(0 if f==0 else 131),200))
    for f in [2,6]:
     var img=HoldShieldActor.texture(p,HoldShieldActor.pose(p,f,"combat")).get_image()
     board.blend_rect(img,Rect2i(Vector2i.ZERO,img.get_size()),Vector2i(color*262+(0 if f==2 else 131),295))
   board.save_png(OUT+id+"-palette.png")
   print("Checked ",id)
 var creator=HoldCreator.new();root.add_child(creator)
 await process_frame
 check(creator.picks.has("hair_color") and not creator.picks.has("beard_color"),"Creator has one pigment control")
 creator.queue_free()
 print("PALETTE33: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
