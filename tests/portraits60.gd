extends SceneTree
var passed=0
var failed=0
var protected_pixels=0
var output="res://docs/testing/portraits60"
func _initialize():call_deferred("run")
func check(ok:bool,message:String):
 if ok:passed+=1;print("PASS ",message)
 else:failed+=1;push_error(message)
func render(p:HoldPortrait)->Image:
 p.canvas.queue_redraw();p.viewport.render_target_update_mode=SubViewport.UPDATE_ONCE
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 return p.viewport.get_texture().get_image()
func capture(name:String):
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func label(parent:Node,text:String,at:Vector2):
 var l=Label.new();l.text=text;l.position=at;l.add_theme_font_size_override("font_size",14);l.modulate=Color("ead3a6");parent.add_child(l)
func run():
 DirAccess.make_dir_recursive_absolute(output)
 var background=ColorRect.new();background.color=Color("152e34");background.size=Vector2(960,540);root.add_child(background)
 var p=HoldPortrait.new();p.size=Vector2(240,240);p.position=Vector2(20,20);root.add_child(p)
 for gender in 2:
  for sculpt in 7:
   var profile=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":0})
   var id=HoldPaintedPortraits.identity(profile)
   p.apply_profile(profile);await render(p)
   # Classify original texels: filtering hair with skin can hide pale pigment.
   var source=HoldPaintedPortraits.texture(profile).get_image()
   if source.is_compressed():source.decompress()
   var mask=PackedByteArray();mask.resize(384*384)
   var inner=PackedByteArray();inner.resize(384*384)
   for y in 384:
    for x in 384:
     var pixel=Vector2((x-20+.5)/344.0*source.get_width()-.5,(y-20+.5)/344.0*source.get_height()-.5)
     var hair=false
     var pure_hair=x>=20 and x<364 and y>=20 and y<364
     if x>=20 and x<364 and y>=20 and y<364:
      for sy in 2:
       for sx in 2:
        var c=source.get_pixel(clampi(int(floor(pixel.x))+sx,0,source.get_width()-1),clampi(int(floor(pixel.y))+sy,0,source.get_height()-1))
        if c.a>0 and c.r>c.g and c.b>c.g:hair=true
        else:pure_hair=false
     if hair:
      inner[y*384+x]=1 if pure_hair else 0
      for dy in range(-2,3):
       for dx in range(-2,3):
        var xx=clampi(x+dx,0,383);var yy=clampi(y+dy,0,383);mask[yy*384+xx]=1
   var baseline:PackedByteArray
   for colour in 8:
    profile.hair_color=colour;p.apply_profile(profile)
    var shot=await render(p);var pixels=shot.get_data()
    var purple=0;var changed=0;var preserved=0
    if colour==0:baseline=pixels
    for i in range(0,pixels.size(),4):
     if pixels[i+3]<12:continue
     if pixels[i]>pixels[i+1]+3 and pixels[i+2]>pixels[i+1]+3:purple+=1
     if mask[i/4]==0:
      if abs(pixels[i]-baseline[i])+abs(pixels[i+1]-baseline[i+1])+abs(pixels[i+2]-baseline[i+2])>3:changed+=1
      else:preserved+=1
    protected_pixels+=preserved
    check(purple==0 and changed==0,id+" "+HoldAppearance.HAIR_NAMES[colour]+": no source-violet hair or changes outside hair ("+str(purple)+" / "+str(changed)+")")
    if colour in [1,5,6,7]:shot.save_png(output+"/"+id+"-"+str(colour)+".png")
   profile.hair_color=6;p.apply_profile(profile);var grey=(await render(p)).get_data()
   profile.cloth_color=2;p.apply_profile(profile);var heather=(await render(p)).get_data()
   var same_hair=true;var cloth_changes=0
   for y in range(3,381):
    for x in range(3,381):
     var i=(y*384+x)*4
     var difference=abs(grey[i]-heather[i])+abs(grey[i+1]-heather[i+1])+abs(grey[i+2]-heather[i+2])
     if difference>4:cloth_changes+=1
     if inner[y*384+x] and inner[y*384+x-2] and inner[y*384+x+2] and inner[(y-2)*384+x] and inner[(y+2)*384+x] and difference>4:same_hair=false
   check(same_hair and cloth_changes>100,id+": intentional heather clothing changes independently of grey hair")
   var material=p.canvas.material
   for skin in 4:
    profile.skin=skin;p.apply_profile(profile);await render(p)
    check(p.canvas.material==material and p.canvas.material.get_shader_parameter("skin_colour")==HoldAppearance.skin(p.profile),id+": complexion "+str(skin)+" updates the existing material")
 p.queue_free();await process_frame
 for gender in 2:
  for page in 2:
   var board=Control.new();root.add_child(board)
   label(board,"PORTRAITS & WORLD IDENTITIES · "+("WOMEN" if gender else "MEN"),Vector2(22,10))
   for slot in 4:
    var sculpt=page*4+slot
    if sculpt>=7:continue
    var profile=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":[1,6,4,3,2,5,7][sculpt]})
    var face=HoldPortrait.new();face.profile=profile;face.position=Vector2(20+slot*235,48);face.size=Vector2(215,215);board.add_child(face)
    label(board,(HoldAppearance.FEMALE_SCULPTS if gender else HoldAppearance.SCULPTS)[sculpt],Vector2(20+slot*235,280))
    var sprite=HoldSpritePreview.new();sprite.profile=profile;sprite.position=Vector2(68+slot*235,325);sprite.size=Vector2(110,130);board.add_child(sprite)
   await capture("identities-%d-%d"%[gender,page]);board.queue_free();await process_frame
 var cast=Control.new();root.add_child(cast)
 var ids=["ivar","orla","hedrik","borin","eldric","brann","eirik"]
 for i in ids.size():
  var face=HoldRoyalHall.portrait() if ids[i]=="eirik" else HoldPortrait.new()
  face.profile=HoldAppearance.npc_profile(ids[i],2718);face.position=Vector2(22+(i%4)*235,25+(i/4)*265);face.size=Vector2(210,210);cast.add_child(face)
  label(cast,HoldAppearance.NPC_NAMES[ids[i]],face.position+Vector2(0,218))
  check(HoldPaintedPortraits.identity(face.profile)==("eirik" if ids[i]=="eirik" else HoldWholeFrames.identity(face.profile)),ids[i]+": canonical cast identity")
 await capture("named-cast");cast.queue_free();await process_frame
 print("PORTRAITS60: ",passed," passed / ",failed," failed; ",protected_pixels," protected non-hair pixels")
 quit(1 if failed else 0)
