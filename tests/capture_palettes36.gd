extends SceneTree
func _initialize():call_deferred("run")
func run():
 var board=Image.create(1500,1650,false,Image.FORMAT_RGBA8);board.fill(Color("172833"))
 for gender in 2:
  for sculpt in 5:
   var cell=Vector2i(gender*750,sculpt*330)
   for c in 3:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":[0,5,7][c]})
    var portrait=HoldCharacterBust.texture(p).get_image();portrait.convert(Image.FORMAT_RGBA8);portrait.resize(238,238,Image.INTERPOLATE_LANCZOS)
    board.blit_rect(portrait,Rect2i(0,0,238,238),cell+Vector2i(c*250+6,0))
    var img=HoldPaintedWalk.texture(p,8,false).get_image();img.resize(112,112,Image.INTERPOLATE_LANCZOS)
    board.blend_rect(img,Rect2i(0,0,112,112),cell+Vector2i(c*250+69,224))
 board.save_png("/workspace/scratch/dc3395c394d3/Stellar-Holds-0.36-Character-Review.png")
 print("Final portraits and walk palettes captured from game code")
 quit()
