extends SceneTree
var failures=0
var checks=0
func check(ok:bool,s:String):
 checks+=1
 if not ok:failures+=1;push_error(s)
func _initialize():call_deferred("run")
func run():
 for gender in 2:
  for sculpt in (2 if gender==0 else 1):
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt;p=HoldAppearance.normalized(p)
   check(HoldCharacterArt.base_kind(p)==gender,"Ordinary actor uses complete artwork")
   for mode in ["combat","walk","guard"]:
    for f in 8:
     var info=HoldShieldActor.pose(p,f,mode);var original=HoldShieldActor.texture(p,info).get_image()
     var dark=p.duplicate();dark.hair_color=5;dark.beard_color=5
     var recolored=HoldShieldActor.texture(dark,info).get_image();var palm=Vector2i(info.palm*info.scale)
     check(original.get_pixelv(palm)==recolored.get_pixelv(palm),"Palette preserves gripping hand %s/%d"%[mode,f])
     check(original.get_data()!=recolored.get_data(),"Palette changes integrated hair %s/%d"%[mode,f])
 var female=HoldAppearance.random_profile(40,1);var a=HoldCharacterArt.frame_texture(1,0,female).get_image().get_data();female.beard_color=7
 check(a==HoldCharacterArt.frame_texture(1,0,female).get_image().get_data(),"Female complete sprite ignores beard color")
 print("SCULPT CONTRACT: %d checks / %d failures"%[checks,failures]);quit(1 if failures else 0)
