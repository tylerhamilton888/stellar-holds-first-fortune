extends SceneTree
# Offline sprite packing: every exported frame is one complete drawing and mask.
const OUT="res://assets/walk-v35/"
var meta={}
func _initialize():call_deferred("run")
func run():
 DirAccess.make_dir_recursive_absolute(OUT)
 var legs=Image.load_from_file("res://tools/quality35/source-legs.png")
 var raw="/workspace/scratch/dc3395c394d3/tools/palette33/raw/"
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt});var id=HoldCharacterDesigns.id(p)
   for mode in ["normal","armed"]:
    for f in 8:
     var old=[1,2,3,0,4,5,6,7][f] if mode=="normal" else f/2
     var key=id+"-normal-"+str(old) if mode=="normal" else id+"-walk"+str(gender*4+old)
     var upper=Image.load_from_file(raw+key+".png")
     var masks=FileAccess.get_file_as_bytes("res://assets/palette-v35/"+key+".mask")
     var root:Vector2;var eye:Vector2;var target:Vector2
     if mode=="normal":
      root=HoldCharacterArt.root_for(gender,old,p)*HoldCharacterArt.SCALE
      eye=HoldCharacterArt.eye_for(p,old)*HoldCharacterArt.SCALE-root
      target=HoldCharacterArt.eye_for(p,0)*HoldCharacterArt.SCALE-HoldCharacterArt.root_for(gender,0,p)*HoldCharacterArt.SCALE
     else:
      var pose=HoldShieldActor.pose(p,old*2,"walk");root=pose.feet*pose.scale;eye=(pose.eye-pose.feet)*pose.scale
      var neutral=HoldShieldActor.pose(p,0,"walk");target=(neutral.eye-neutral.feet)*neutral.scale
     var shift=Vector2(round(target.x-eye.x),round(target.y-eye.y))
     # Body landmarks are stable. One pixel of down-phase gives weight, never scale.
     shift.y+=1 if f in [1,5] else 0
     var frame=Image.create(112,112,false,Image.FORMAT_RGBA8)
     var material=PackedByteArray();material.resize(112*112);material.fill(0)
     var source=legs.get_region(Rect2i(f%4*384,215 if f<4 else 645,384,218))
     source.resize(58,33,Image.INTERPOLATE_NEAREST)
     for y in source.get_height():
      for x in source.get_width():
       var c=source.get_pixel(x,y)
       if c.a>.45:frame.set_pixel(56-30+x,104-32+y,Color(c.r,c.g,c.b,1))
     # The original complete upper drawing overlaps the painted hip, hiding the belt seam.
     var original_sockets=HoldEquipmentRig.sockets(p,old if mode=="normal" else old*2,"normal" if mode=="normal" else "walk")
     var hand=Vector2(56,104)+original_sockets.hand+shift
     var origin=Vector2(56,104)-root+shift
     for y in upper.get_height():
      for x in upper.get_width():
       var dest=Vector2i(origin+Vector2(x,y));var c=upper.get_pixel(x,y)
       if dest.x<0 or dest.x>=112 or dest.y<0 or dest.y>=112 or c.a<.45:continue
       var label=masks[y*upper.get_width()+x]
       if dest.y>=78:
        var keep_hair=label==1 and dest.y<94
        var keep_coat=label==4 and dest.y<88
        var keep_hand=label==3 and Vector2(dest).distance_to(hand)<9
        var axe_delta=Vector2(dest)-hand
        var axe_head=axe_delta.x>9 and axe_delta.x<26 and axe_delta.y>-3 and axe_delta.y<20 and c.s<.23
        var axe_handle=axe_delta.x>0 and axe_delta.x<20 and absf(axe_delta.y)<4
        var keep_gear=mode=="armed" and ((absf(dest.x-56)>28 and dest.y<98) or axe_head or axe_handle)
        if not (keep_hair or keep_coat or keep_hand or keep_gear):continue
       frame.set_pixelv(dest,c);material[dest.y*112+dest.x]=masks[y*upper.get_width()+x]
     # Discard atlas-gutter flecks; keep only the connected character silhouette.
     var visited={};var largest=[]
     for yy in 112:
      for xx in 112:
       var v=Vector2i(xx,yy)
       if visited.has(v) or frame.get_pixelv(v).a<.45:continue
       var component=[v];visited[v]=true;var cursor=0
       while cursor<component.size():
        var q=component[cursor];cursor+=1
        for offset in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
         var next=q+offset
         if next.x<0 or next.y<0 or next.x>=112 or next.y>=112 or visited.has(next) or frame.get_pixelv(next).a<.45:continue
         visited[next]=true;component.append(next)
       if component.size()>largest.size():largest=component
     var keep={}
     for pixel in largest:keep[pixel]=true
     for pixel in visited:
      if not keep.has(pixel):frame.set_pixelv(pixel,Color.TRANSPARENT);material[pixel.y*112+pixel.x]=0
     var name=id+"-"+mode+str(f)
     frame.save_png(OUT+name+".png")
     var file=FileAccess.open(OUT+name+".mask",FileAccess.WRITE);file.store_buffer(material)
     var sockets=HoldEquipmentRig.sockets(p,old if mode=="normal" else old*2,"normal" if mode=="normal" else "walk")
     var data={}
     for socket in sockets:data[socket]=[sockets[socket].x+shift.x,sockets[socket].y+shift.y]
     meta[name]=data
 var file=FileAccess.open(OUT+"sockets.json",FileAccess.WRITE);file.store_string(JSON.stringify(meta))
 print("Baked 160 complete walk frames with material masks and equipment sockets");quit()
