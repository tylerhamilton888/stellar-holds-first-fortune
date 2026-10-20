extends SceneTree
const OUT="res://tools/quality36/raw/"
func _initialize():call_deferred("run")
func run():
 DirAccess.make_dir_recursive_absolute(OUT)
 var metadata={}
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt});var id=HoldCharacterDesigns.id(p)
   var portrait=load("res://assets/portraits-v21/"+id+".png").get_image();portrait.resize(384,384,Image.INTERPOLATE_LANCZOS);portrait.save_png(OUT+id+"-portrait.png")
   for f in 16:
    var height=260 if f in [8,9,10,11] else 256
    if f<8 and ((gender==0 and sculpt>=2) or (gender==1 and sculpt>=1)):height=248
    var top=f/4*256;var custom_rows=gender==1 and sculpt in [1,2] and f>=8
    if custom_rows:
     top=(512 if f<12 else 752) if sculpt==1 else (504 if f<12 else 768)
     height=240 if sculpt==1 else (256 if f<12 else 224)
    var img=HoldCharacterDesigns.image_for(p,"normal").get_region(Rect2i(f%4*384,top,384,height))
    if f>=12 and not custom_rows:img.fill_rect(Rect2i(0,0,384,12),Color.TRANSPARENT)
    img.resize(262,int(round(height*.34))*2,Image.INTERPOLATE_LANCZOS)
    var root=HoldCharacterArt.root_for(gender,f,p)*.68
    var floor_pixel=int(ceil(root.y))+2
    if floor_pixel<img.get_height():img.fill_rect(Rect2i(0,floor_pixel,img.get_width(),img.get_height()-floor_pixel),Color.TRANSPARENT)
    var key=id+"-normal-"+str(f);img.save_png(OUT+key+".png")
    var eye=HoldCharacterArt.eye_for(p,f)*.68;var wrist=(HoldCharacterArt.carry_palm(p,f)*.34 if f<8 else HoldCharacterArt.work_hand(f-8,p)+root*.5)*2
    var elbow=HoldAppearanceRig.ELBOWS[gender][f]*.68
    metadata[key]={"eye":[eye.x,eye.y],"wrist":[wrist.x,wrist.y],"elbow":[elbow.x,elbow.y],"root":[root.x,root.y]}
   for mode in ["combat","walk","guard"]:
    for f in (8 if mode=="combat" else 4):
     var info=HoldShieldActor.pose(p,f*2 if mode=="walk" else f,mode);var img=HoldCharacterDesigns.image_for(p,mode).get_region(info.region)
     img.resize(int(round(info.region.size.x*info.scale))*2,int(round(info.region.size.y*info.scale))*2,Image.INTERPOLATE_LANCZOS)
     var floor_pixel=int(ceil(info.feet.y*info.scale))*2+2
     if floor_pixel<img.get_height():img.fill_rect(Rect2i(0,floor_pixel,img.get_width(),img.get_height()-floor_pixel),Color.TRANSPARENT)
     var key=id+"-"+info.id;img.save_png(OUT+key+".png")
     var eye=info.eye*info.scale*2;var wrist=info.palm*info.scale*2;var elbow=info.elbow*info.scale*2;var root=info.feet*info.scale*2
     metadata[key]={"eye":[eye.x,eye.y],"wrist":[wrist.x,wrist.y],"elbow":[elbow.x,elbow.y],"root":[root.x,root.y]}
 var file=FileAccess.open(OUT+"metadata.json",FileAccess.WRITE);file.store_string(JSON.stringify(metadata));print("High-detail sources exported");quit()
