extends SceneTree
var checked=0
var failed=0
var total_pixels=0
var worst=[]
var output="res://docs/testing/palette-fix58"
func _initialize():call_deferred("run")
func scan(p:Dictionary,sheet:String,index:int):
 var texture=HoldWholeFrames.texture(p,sheet,index,true)
 var img=texture.get_image();img.convert(Image.FORMAT_RGBA8)
 var bytes=img.get_data();var count=0
 for offset in range(0,bytes.size(),4):
  if bytes[offset+3]<32:continue
  total_pixels+=1
  # Independent output criterion: a neutral-clothed, naturally colored figure
  # must not retain a red/blue excess over green (the source marker pigment).
  if int(bytes[offset])-int(bytes[offset+1])>2 and int(bytes[offset+2])-int(bytes[offset+1])>2:count+=1
 checked+=1
 if count>0:failed+=1;worst.append({"sheet":sheet,"frame":index,"hair":p.hair_color,"purple_pixels":count})
 HoldWholeFrames.cache.clear();HoldWholeFrames.order.clear()
func run():
 if not OS.get_cmdline_user_args().is_empty():output=OS.get_cmdline_user_args()[0]
 var started=Time.get_ticks_msec();HoldWholeFrames.data()
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":6,"cloth_color":0})
   for kind in ["core","utility","handling","equipped"]:
    var sheet=HoldWholeFrames.identity(p)+"-"+kind
    for index in HoldWholeFrames.metadata[sheet].size():scan(p,sheet,index)
   # All saved natural palettes, including near-black, flaxen and white.
   for color in 8:
    p.hair_color=color;scan(p,HoldWholeFrames.identity(p)+"-core",0)
   HoldWholeFrames.sources.clear()
   print("PALETTE AUDIT identity ",gender,"/",sculpt,"; ",checked," frames; ",failed," failed")
   await process_frame
 # A purple outfit is intentional. Hair selection must leave skin, clothing,
 # leather and tool pixels identical; test actual full-frame texture bytes.
 var controls=0
 for gender in 2:
  for cloth in [0,2,7]:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":0,"hair_color":0,"cloth_color":cloth})
   var sheet=HoldWholeFrames.identity(p)+"-core";var m=HoldWholeFrames.metadata[sheet][22];var r=m.rect
   var original=HoldWholeFrames.source(m.get("source",sheet)).get_region(Rect2i(r[0],r[1],r[2],r[3]));original.convert(Image.FORMAT_RGBA8)
   var a=HoldWholeFrames.texture(p,sheet,22,true).get_image();a.convert(Image.FORMAT_RGBA8);var aa=a.get_data()
   p.hair_color=7
   var b=HoldWholeFrames.texture(p,sheet,22,true).get_image();b.convert(Image.FORMAT_RGBA8);var bb=b.get_data();var raw=original.get_data()
   var changed=0;var violet=0
   for off in range(0,raw.size(),4):
    if raw[off+3]<64 or aa[off+3]<64:continue
    # Clear warm skin/leather, blue/teal cloth and neutral metal controls.
    if int(raw[off+1])>=mini(int(raw[off]),int(raw[off+2])):
     controls+=1
     if aa[off]!=bb[off] or aa[off+1]!=bb[off+1] or aa[off+2]!=bb[off+2]:changed+=1
    if int(aa[off])-int(aa[off+1])>8 and int(aa[off+2])-int(aa[off+1])>8:violet+=1
   if changed>0 or (cloth in [2,7] and violet==0):
    failed+=1;worst.append({"protected_material_failure":true,"gender":gender,"cloth":cloth,"changed":changed,"purple_clothing_pixels":violet})
 var report={"frames_checked":checked,"visible_pixels_checked":total_pixels,"failed":failed,"protected_material_pixels":controls,"elapsed_ms":Time.get_ticks_msec()-started,"failures":worst}
 DirAccess.make_dir_recursive_absolute(output)
 var f=FileAccess.open(output+"/audit.json",FileAccess.WRITE);f.store_string(JSON.stringify(report,"  "));f.close()
 print("PALETTE AUDIT COMPLETE: ",checked," frames; ",failed," failed; ",controls," protected material pixels")
 quit(1 if failed else 0)
