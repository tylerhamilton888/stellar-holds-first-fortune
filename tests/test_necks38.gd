extends SceneTree
var passed=0
var failed=0
func check(ok,message):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var points=[Vector2i(161,243),Vector2i(280,337),Vector2i(161,243),Vector2i(163,239),Vector2i(165,231),Vector2i(178,248),Vector2i(179,250),Vector2i(190,254),Vector2i(250,310),Vector2i(242,305)]
 for g in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":g,"sculpt":sculpt,"hair_color":5})
   var id=HoldCharacterDesigns.id(p);var q=points[g*5+sculpt]
   var dark=HoldCharacterBust.texture(p).get_image()
   p.hair_color=7;p.beard_color=7
   var pale=HoldCharacterBust.texture(p).get_image()
   var a=dark.get_pixelv(q);var b=pale.get_pixelv(q)
   check(maxf(absf(a.r-b.r),maxf(absf(a.g-b.g),absf(a.b-b.b)))<=2.0/255,id+" portrait neck is independent of hair color")
   # Palette changes must still affect real hair.
   var top=Vector2i(180,120) if sculpt==4 and g==0 else Vector2i(245,90)
   check(not dark.get_pixelv(top).is_equal_approx(pale.get_pixelv(top)),id+" actual hair retains color customization")
 # Direct rendered probes in the two previously contaminated neck shadows.
 for entry in [[0,Vector2i(182,69)],[4,Vector2i(179,67)]]:
  var p=HoldAppearance.normalized({"gender":1,"sculpt":entry[0],"hair_color":5})
  var dark=HoldCharacterArt.frame_texture(1,0,p).get_image();p.hair_color=7;p.beard_color=7
  var pale=HoldCharacterArt.frame_texture(1,0,p).get_image()
  check(dark.get_pixelv(entry[1]).is_equal_approx(pale.get_pixelv(entry[1])),"Female idle neck shadow keeps skin color")
  for f in 16:
   var at=(HoldPaintedWalk.ROOT+HoldPaintedWalk.sockets(p,f,false).head+Vector2(7,8)+(Vector2(entry[1])-Vector2(184.96,43.52))*.5)*3
   var q=Vector2i(at.round());p.hair_color=5;p.beard_color=5
   var dark_frame=HoldPaintedWalk.texture(p,f,false).get_image();p.hair_color=7;p.beard_color=7
   var pale_frame=HoldPaintedWalk.texture(p,f,false).get_image()
   check(dark_frame.get_pixelv(q).is_equal_approx(pale_frame.get_pixelv(q)),"Neck shadow remains skin in walking frame "+str(f))
 print("NECK38: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
