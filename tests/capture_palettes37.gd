extends SceneTree
func _initialize():call_deferred("run")
func run():
 var board=Image.create(2048,2560,false,Image.FORMAT_RGBA8);board.fill(Color("172833"))
 for gender in 2:
  for sculpt in 5:
   var cell=Vector2i(gender*1024,sculpt*512)
   for c in 4:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":[0,5,7,5][c],"skin":3 if c==3 else 0,"cloth_color":1 if c==3 else 0})
    var portrait=HoldCharacterBust.texture(p).get_image();portrait.convert(Image.FORMAT_RGBA8)
    portrait.save_png("/workspace/scratch/dc3395c394d3/tools/quality37/"+HoldCharacterDesigns.id(p)+"-palette"+str(c)+".png")
    portrait.resize(256,256,Image.INTERPOLATE_LANCZOS)
    board.blit_rect(portrait,Rect2i(0,0,256,256),cell+Vector2i(c%2*512,c/2*256))
    var img=HoldPaintedWalk.texture(p,8,false).get_image();img.resize(224,224,Image.INTERPOLATE_LANCZOS)
    board.blend_rect(img,Rect2i(0,0,224,224),cell+Vector2i(c%2*512+272,c/2*256+30))
 board.save_png("/workspace/scratch/dc3395c394d3/Stellar-Holds-0.37-Character-Review.png")
 print("Final four-palette review captured")
 quit()
