extends SceneTree
func _initialize():call_deferred("run")
func run():
 var base="res://tools/palette33/raw/"
 DirAccess.make_dir_recursive_absolute(base)
 var meta={}
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.defaults();p.gender=gender;p.sculpt=sculpt;p.hair_color=1;p.beard_color=1;p.skin=0;p.tattoo=0;p.jewelry=0
   var id=HoldCharacterDesigns.id(p)
   HoldCharacterBust.source(p).save_png(base+id+"-portrait.png")
   for f in 16:
    var img=raw_normal(gender,f,p)
    var key=id+"-normal-"+str(f);img.save_png(base+key+".png")
    var eye=HoldCharacterArt.eye_for(p,f)*HoldCharacterArt.SCALE
    var wrist=HoldCharacterArt.carry_palm(p,f)*HoldCharacterArt.SCALE if f<8 else HoldCharacterArt.work_hand(f-8,p)+HoldCharacterArt.root_for(gender,f,p)*HoldCharacterArt.SCALE
    var elbow=HoldAppearanceRig.ELBOWS[gender][f]*HoldCharacterArt.SCALE
    meta[key]={"eye":[eye.x,eye.y],"wrist":[wrist.x,wrist.y],"elbow":[elbow.x,elbow.y]}
   for mode in ["combat","walk","guard"]:
    for f in (8 if mode=="combat" else 4):
     var info=HoldShieldActor.pose(p,f*2 if mode=="walk" else f,mode)
     var img=HoldCharacterDesigns.image_for(p,mode).get_region(info.region)
     img.resize(int(round(info.region.size.x*info.scale)),int(round(info.region.size.y*info.scale)),Image.INTERPOLATE_NEAREST)
     var floor_pixel=int(ceil(info.feet.y*info.scale))+1
     if floor_pixel<img.get_height():img.fill_rect(Rect2i(0,floor_pixel,img.get_width(),img.get_height()-floor_pixel),Color.TRANSPARENT)
     var key=id+"-"+info.id;img.save_png(base+key+".png")
     meta[key]={"eye":[info.eye.x*info.scale,info.eye.y*info.scale],"wrist":[info.palm.x*info.scale,info.palm.y*info.scale],"elbow":[info.elbow.x*info.scale,info.elbow.y*info.scale]}
 var file=FileAccess.open(base+"metadata.json",FileAccess.WRITE);file.store_string(JSON.stringify(meta));file.close()
 print("Exported ",meta.size()," raw animation poses and 10 portraits");quit()

func raw_normal(kind:int,f:int,p:Dictionary)->Image:
 var height=260 if f in [8,9,10,11] else 256
 var design=int(p.get("sculpt",0))
 var source=HoldCharacterDesigns.image_for(p,"normal") if kind<2 else HoldCharacterDesigns.image_for(p,"normal")
 if f<8 and ((kind==0 and design>=2) or (kind==1 and design>=1)):height=248
 var top=f/4*256
 var custom_rows=kind==1 and design in [1,2] and f>=8
 if custom_rows:
  top=(512 if f<12 else 752) if design==1 else (504 if f<12 else 768)
  height=(240 if f<12 else 240) if design==1 else (256 if f<12 else 224)
 var image=source.get_region(Rect2i(f%4*384,top,384,height))
 if f>=12 and not custom_rows:image.fill_rect(Rect2i(0,0,384,12),Color.TRANSPARENT)
 image.resize(131,int(round(height*HoldCharacterArt.SCALE)),Image.INTERPOLATE_NEAREST)
 var floor_pixel=int(ceil(HoldCharacterArt.root_for(kind,f,p).y*HoldCharacterArt.SCALE))+1
 if floor_pixel<image.get_height():image.fill_rect(Rect2i(0,floor_pixel,image.get_width(),image.get_height()-floor_pixel),Color.TRANSPARENT)
 return image
