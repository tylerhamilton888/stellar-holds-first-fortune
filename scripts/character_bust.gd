class_name HoldCharacterBust
extends RefCounted
# Each sculpt owns a complete painted portrait. Palette changes never move anatomy.
const RESOLUTION=512
static var sources:Dictionary={}
static var palettes:Dictionary={}
static var materials:Dictionary={}
static func source(profile:Dictionary)->Image:
 var id=HoldCharacterDesigns.id(profile)
 if not sources.has(id):
  var img=load("res://assets/portraits-v37/"+id+".png").get_image()
  img.resize(RESOLUTION,RESOLUTION,Image.INTERPOLATE_LANCZOS)
  sources[id]=img
 return sources[id]
static func material_map(profile:Dictionary)->PackedByteArray:
 return FileAccess.get_file_as_bytes("res://assets/portraits-v37/"+HoldCharacterDesigns.id(profile)+".mask")
static func texture(profile:Dictionary)->Texture2D:
 var id=HoldCharacterDesigns.id(profile)
 var key="%s/%d/%d/%d/%d/%d" % [id,profile.hair_color,profile.beard_color,profile.skin,profile.cloth_color,profile.jewelry]
 key+="/cast"+str(profile.get("cast_id",""))
 if palettes.has(key):return palettes[key]
 var img=source(profile).duplicate()
 if not materials.has(id):materials[id]=Image.create_from_data(RESOLUTION,RESOLUTION,false,Image.FORMAT_RGBA8,FileAccess.get_file_as_bytes("res://assets/portraits-v37/"+id+".coverage"))
 var coverage:Image=materials[id]
 var hair=HoldAppearance.hair(profile)
 var skin=HoldAppearance.skin(profile);var cloth=HoldAppearance.cloth(profile)
 for y in RESOLUTION:
  for x in RESOLUTION:
   var c=img.get_pixel(x,y)
   var w=coverage.get_pixel(x,y);var original=c
   if w.r>0:c+=(HoldCharacterArt.recolor_hair(original,hair)-original)*w.r
   if w.g>0 and profile.skin!=0:c+=(HoldCharacterArt.recolor(original,skin,Color(HoldAppearance.SKIN_COLORS[0]))-original)*w.g
   if w.b>0 and profile.cloth_color!=0:c+=(HoldCharacterArt.recolor(original,cloth,Color("407e83"))-original)*w.b
   if w.a>0 and profile.jewelry==1:c+=(Color(original.v*.87,original.v*.95,original.v,original.a)-original)*w.a
   img.set_pixel(x,y,c)
 var tex=ImageTexture.create_from_image(img)
 if palettes.size()>=64:palettes.erase(palettes.keys()[0])
 palettes[key]=tex
 return tex
static func line(n:Node2D,a:Vector2,b:Vector2,dest:Rect2,c:Color,width:float=1):
 n.draw_line(dest.position+a*dest.size,dest.position+b*dest.size,c,width*dest.size.x/192)
static func draw(n:Node2D,profile:Dictionary,dest:Rect2,_blink:bool=false):
 n.draw_texture_rect(texture(profile),dest,false)
 # Portraits are static paintings: no generic eyelid overlay across ten different faces.
 # Small optional details have portrait-specific attachment points.
 var female=profile.gender==1
 var cheek=Vector2(.47,.415) if not female else Vector2(.485,.425)
 var mark=Color("426c7d")
 if profile.tattoo==1:
  line(n,cheek,cheek+Vector2(0,.042),dest,mark,1.5)
  line(n,cheek,cheek+Vector2(.023,.018),dest,mark,1.5)
  line(n,cheek+Vector2(.023,.018),cheek+Vector2(0,.029),dest,mark,1.5)
 elif profile.tattoo==2:
  for offset in [0,.015]:line(n,cheek+Vector2(offset,0),cheek+Vector2(offset+.01,.04),dest,mark,1.5)
 elif profile.tattoo==3:
  var points=[Vector2(0,0),Vector2(.024,.023),Vector2(0,.045),Vector2(0,0),Vector2(.024,.045)]
  for i in points.size()-1:line(n,cheek+points[i],cheek+points[i+1],dest,mark,1.5)
 if profile.jewelry!=3:
  var ear=Vector2(.325,.432) if not female else Vector2(.355,.44)
  n.draw_arc(dest.position+ear*dest.size,.010*dest.size.x,0,TAU,12,HoldAppearance.metal(profile),dest.size.x/192)
 if profile.jewelry==2:
  # Long male beards naturally hide the pendant; don't paint it on top of hair.
  if female or profile.sculpt==0:
   line(n,Vector2(.43,.79),Vector2(.62,.925),dest,HoldAppearance.metal(profile))
   line(n,Vector2(.62,.925),Vector2(.73,.79),dest,HoldAppearance.metal(profile))
   n.draw_circle(dest.position+Vector2(.62,.925)*dest.size,.012*dest.size.x,Color("e9b44d"))
