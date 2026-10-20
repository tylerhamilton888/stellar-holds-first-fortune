extends SceneTree
var passed=0
var failed=0
func check(ok,message):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":5})
   var id=HoldCharacterDesigns.id(p)
   var weights=Image.create_from_data(512,512,false,Image.FORMAT_RGBA8,FileAccess.get_file_as_bytes("res://assets/portraits-v37/"+id+".coverage"))
   check(weights.get_size()==Vector2i(512,512),id+" coverage resolution")
   var excess=0;var soft=0
   for y in 512:
    for x in 512:
     var w=weights.get_pixel(x,y)
     if w.r+w.g+w.b+w.a>1.012:excess+=1
     if w.r>.01 and w.r<.99:soft+=1
   check(excess==0,id+" materials do not double-tint boundaries")
   check(soft>20,id+" continuous edge coverage exists")
   var dark=HoldCharacterBust.texture(p).get_image();p.hair_color=7;p.beard_color=7
   var light=HoldCharacterBust.texture(p).get_image()
   for q in [Vector2(235,145),Vector2(231,102),Vector2(332,273)]:
    var at=Vector2i(q*512.0/384)
    check(dark.get_pixelv(at).is_equal_approx(light.get_pixelv(at)),id+" face and fittings are independent of pigment")
   if gender:
    var at=Vector2i(Vector2(228,247)*512.0/384)
    check(dark.get_pixelv(at).is_equal_approx(light.get_pixelv(at)),id+" neck does not change with hair")
   p.cloth_color=1;p.skin=3
   var changed=HoldCharacterBust.texture(p).get_image()
   var background=Vector2i(Vector2(380,235)*512.0/384)
   check(changed.get_pixelv(background).is_equal_approx(light.get_pixelv(background)),id+" background is never clothing")
   if gender==0 and sculpt==4:
    var scalp=Vector2i(Vector2(200,60)*512.0/384)
    check(not changed.get_pixelv(scalp).is_equal_approx(light.get_pixelv(scalp)),"Exposed scalp follows complexion")
   for armed in [false,true]:
    for f in 16:
     var tex=HoldPaintedWalk.texture(p,f,armed)
     var rect=tex.get_image().get_used_rect()
     check(rect.end.y in [311,312,313,314],id+" sole baseline")
     check(HoldPaintedWalk.sockets(p,f,armed).has("hand"),id+" gear anchors")
 var gait=JSON.parse_string(FileAccess.get_file_as_string("res://assets/walk-v37/gait.json"))
 for id in ["male0","male1","male2","male3","male4","female0","female1","female2","female3","female4"]:
  for armed in ["normal","armed"]:
   var source=gait[id+"-"+armed+"0"].head_source
   for f in 16:
    check(gait[id+"-"+armed+str(f)].head_source==source,"The head and braids do not swap sources")
 for f in 8:check(absf(float(gait["female0-normal"+str(f)].near.foot[0])+f*4-16)<.001,"64-unit stride remains planted")
 print("QUALITY37: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
