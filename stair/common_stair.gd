extends RefCounted
## The toe is where the stair meets the walkable floor. The same flight fits
## a carved landing underground and the wider, daylit exit to the claim.
var hatch:Texture2D
var treads:Texture2D
var spill:Texture2D
func _init():
 var image=Image.new()
 treads=preload("res://stair/flight.gd").treads()
 if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://stair/landing.webp"))==OK:
  hatch=ImageTexture.create_from_image(image)
 var glow=Image.create(112,80,false,Image.FORMAT_RGBA8)
 for y in 80:
  var along=float(y)/79
  for x in 112:
   var across=absf(x-48-18*along)/(39+12*along)
   var soft=1-smoothstep(.50,1,across)
   var strength=.28*soft*pow(1-along,1.5)
   glow.set_pixel(x,y,Color(1,.84,.50,strength))
 spill=ImageTexture.create_from_image(glow)

func paint(g,world,toe:Vector2,width:float,home:bool):
 if treads==null:return
 var height=width*.60
 var top=toe-Vector2(0,height*.86)
 var lip=width*.32
 var far=top-Vector2(0,width*.065)
 var landing=PackedVector2Array([far+Vector2(-lip+3,0),far+Vector2(lip-3,0),top+Vector2(lip+2,4),top+Vector2(-lip-2,4)])
 g.draw_colored_polygon(landing,Color("a5845b") if home else Color("59615e"))
 if home:
  if hatch!=null:
   var hatch_size=Vector2(width*.86,width*.245)
   g.draw_texture_rect(hatch,Rect2(top-Vector2(hatch_size.x*.5,hatch_size.y-5),hatch_size),false)
  var area=Rect2(toe-Vector2(54,2),Vector2(112,80))
  var lo=world.cell(area.position)
  var hi=world.cell(area.end)
  for y in range(lo.y,hi.y+1):
   for x in range(lo.x,hi.x+1):
    var c=Vector2i(x,y)
    if world.at(c)!=0 or not world.layer().seen.has(world.key(c)):continue
    var part=Rect2(Vector2(c)*40,Vector2(40,40)).intersection(area)
    if part.has_area():g.draw_texture_rect_region(spill,part,Rect2(part.position-area.position,part.size))
 var foot=PackedVector2Array([toe+Vector2(-width*.47,-3),toe+Vector2(width*.46,-3),toe+Vector2(width*.48,1),toe+Vector2(width*.39,3),toe+Vector2(-width*.46,2)])
 g.draw_colored_polygon(foot,Color(.08,.095,.10,.39))
 g.draw_texture_rect(treads,Rect2(toe-Vector2(width*.5,height),Vector2(width,height)),false,Color("ffefd5") if home else Color("bbc5cd"))
