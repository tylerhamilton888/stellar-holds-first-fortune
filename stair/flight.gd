extends RefCounted

static var texture:Texture2D

static func treads()->Texture2D:
 if texture==null:
  var image=Image.new()
  if image.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://stair/treads.webp"))==OK:
   texture=ImageTexture.create_from_image(image)
 return texture

# The same seam works from either landing, including an immediate reversal.
static func crossed(before:Vector2,after:Vector2,seam:Vector2,half_width:float)->bool:
 if before.y==after.y or (before.y-seam.y)*(after.y-seam.y)>0 or after.y==seam.y:return false
 var x=lerpf(before.x,after.x,(seam.y-before.y)/(after.y-before.y))
 return absf(x-seam.x)<=half_width

# Sample the painted grain of the original timber landing and the chipped edge
# of a stone tread. UV coordinates are normalized within each source image.
static func board(g,outline:PackedVector2Array,wood:Texture2D,tint:Color):
 var uv=PackedVector2Array([Vector2(.20,.032),Vector2(.80,.032),Vector2(.80,.111),Vector2(.20,.111)])
 g.draw_polygon(outline,PackedColorArray([tint]),uv,wood)

static func quad(a:Vector2,b:Vector2,c:Vector2,d:Vector2)->PackedVector2Array:
 return PackedVector2Array([a,b,c,d])

static func draw(g,box:Rect2,depth:float):
 var stone=treads()
 var wood=preload("res://settlement/ground.gd").texture("ramp_head")
 var x=box.position.x;var y=box.position.y
 var w=box.size.x;var h=box.size.y
 if depth<1:
  var light=Color(.99,.94,.85,1.-depth)
  board(g,quad(Vector2(x+.22*w,y+.06*h),Vector2(x+.78*w,y+.06*h),Vector2(x+.81*w,y+.22*h),Vector2(x+.18*w,y+.22*h)),wood,light)
  g.draw_texture_rect(stone,Rect2(x,y+h*.07,w,h*.93),false,light)
 if depth<=0:return
 var top_left=Vector2(x+w*.15,y+h*.10)
 var top_right=Vector2(x+w*.85,y+h*.10)
 var bottom_left=Vector2(x+w*.05,y+h*.93)
 var bottom_right=Vector2(x+w*.95,y+h*.93)
 var opening=quad(top_left,top_right,bottom_right,bottom_left)
 g.draw_colored_polygon(opening,Color(.105,.085,.068,depth))
 # The tread edges retreat inside the floor opening. The visible masonry ends
 # beneath the near sill, while the cut timber sides remain at floor level.
 var stone_uv=quad(Vector2(.22,.40),Vector2(.76,.40),Vector2(.76,.53),Vector2(.22,.53))
 var inner_left=bottom_left+Vector2(w*.21,0)
 var inner_right=bottom_right-Vector2(w*.21,0)
 for i in 6:
  var start=1.-pow(1.-i/6.,1.45)
  var end=1.-pow(1.-(i+1)/6.,1.45)
  var course=quad(top_left.lerp(inner_left,start),top_right.lerp(inner_right,start),top_right.lerp(inner_right,end),top_left.lerp(inner_left,end))
  var light=lerpf(.96,.23,end)
  g.draw_polygon(course,PackedColorArray([Color(light,light*.97,light*.91,depth)]),stone_uv,stone)
 var timber=Color(.84,.79,.66,depth)
 var edge=w*.055
 board(g,quad(top_left-Vector2(edge,0),bottom_left-Vector2(edge,0),bottom_left,top_left),wood,timber)
 board(g,quad(top_right,bottom_right,bottom_right+Vector2(edge,0),top_right+Vector2(edge,0)),wood,timber)
 var sill=Color(.95,.89,.74,depth)
 board(g,quad(top_left-Vector2(edge,h*.055),top_right+Vector2(edge,-h*.055),top_right+Vector2(edge,0),top_left-Vector2(edge,0)),wood,sill)
 board(g,quad(bottom_left-Vector2(edge,0),bottom_right+Vector2(edge,0),bottom_right+Vector2(edge,h*.065),bottom_left+Vector2(-edge,h*.065)),wood,sill)
