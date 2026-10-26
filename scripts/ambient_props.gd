class_name HoldAmbientProps
extends RefCounted
# Small, local effects registered to the painted aperture/spouts. They share
# the game's pause clock and the prop's sorted draw call; no per-frame nodes.
static var fire_meshes={}
static var glow:GradientTexture2D
static func glow_texture()->GradientTexture2D:
 if glow==null:
  glow=GradientTexture2D.new();glow.width=96;glow.height=96
  glow.fill=GradientTexture2D.FILL_RADIAL;glow.fill_from=Vector2(.5,.5);glow.fill_to=Vector2(1,.5)
  glow.gradient=Gradient.new();glow.gradient.offsets=PackedFloat32Array([0,.38,1]);glow.gradient.colors=PackedColorArray([Color(1,.52,.14,.19),Color(1,.43,.09,.075),Color(1,.35,.08,0)])
 return glow
static func flame_key(time:float)->int:return posmod(int(time*12),24)
static func hearth_mesh(time:float)->ArrayMesh:
 # Animate only the fire's painted UVs. The masonry, ash bed and iron guard
 # keep their exact source coordinates; no flat replacement flame artwork.
 var key=flame_key(time)
 if fire_meshes.has(key):return fire_meshes[key]
 var vertices=PackedVector3Array();var uvs=PackedVector2Array();var indices=PackedInt32Array()
 var columns=28;var rows=28;var phase=float(key)/24*TAU
 for y in rows+1:
  for x in columns+1:
   var uv=Vector2(float(x)/columns,float(y)/rows)
   vertices.append(Vector3(uv.x*72-36,uv.y*76-76,0))
   var mask=smoothstep(.32,.42,uv.x)*(1-smoothstep(.64,.74,uv.x))*smoothstep(.55,.63,uv.y)*(1-smoothstep(.73,.77,uv.y))
   var flow=Vector2(sin(uv.y*31-phase*2)*.014,sin(uv.x*27+phase*3)*.022)*mask
   uvs.append((Vector2(1180,328)+(uv+flow)*Vector2(323,340))/Vector2(1536,1024))
 for y in rows:
  for x in columns:
   var i=y*(columns+1)+x
   indices.append_array(PackedInt32Array([i,i+1,i+columns+1,i+1,i+columns+2,i+columns+1]))
 var arrays=[];arrays.resize(Mesh.ARRAY_MAX);arrays[Mesh.ARRAY_VERTEX]=vertices;arrays[Mesh.ARRAY_TEX_UV]=uvs;arrays[Mesh.ARRAY_INDEX]=indices
 var mesh=ArrayMesh.new();mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays);fire_meshes[key]=mesh
 return mesh
static func hearth(n:CanvasItem,p:Vector2,time:float,tint:Color):
 var t=time+p.x*.019+p.y*.011;var origin=p+Vector2(2,-13)
 var pulse=.88+.08*sin(t*7)+.04*sin(t*13)
 n.draw_texture_rect(glow_texture(),Rect2(p-Vector2(49,42),Vector2(98,62)),false,Color(tint.r,tint.g,tint.b,tint.a*pulse))
 n.draw_mesh(hearth_mesh(t),HoldFurnishings.ATLAS,Transform2D(0,p),tint)
 for i in 3:
  var age=fposmod(t*.7+i*.37,1.0);var q=origin+Vector2(sin(t*1.3+i)*4,-8-age*14)
  n.draw_circle(q,.6,Color(1,.79,.35,sin(age*PI)*.45*tint.a))
static func fountain(n:Node2D,p:Vector2,time:float,scale:float=1.0,alpha:float=1.0):
 # Positions were measured from the hammer fountain's two outlets and basin.
 # White crests travel down the blue painted streams; ripples stay on water.
 for side in 2:
  var top=Vector2(-29,-104) if side==0 else Vector2(33,-101)
  var length=30.0 if side==0 else 29.0
  for strand in 3:
   var points=PackedVector2Array()
   for j in 7:
    var y=float(j)/6*length
    points.append(p+(top+Vector2((strand-1)*1.6+sin(y*.32-time*5+strand)*.55,y))*scale)
   n.draw_polyline(points,Color(.72,.96,.95,(.22 if strand!=1 else .38)*alpha),.85*scale,true)
  for drop in 4:
   var phase=fposmod(time*1.5+drop*.25+side*.19,1)
   var a=p+(top+Vector2(sin(drop*2.1+time)*1.5,phase*length))*scale
   n.draw_line(a,a+Vector2(0,2.7)*scale,Color(.87,1,1,sin(phase*PI)*.65*alpha),1.0*scale,true)
  for ring in 2:
   var phase=fposmod(time*.95+ring*.5+side*.23,1)
   ripple(n,p+(top+Vector2(0,length+1))*scale,Vector2(3+phase*10,1+phase*3)*scale,(1-phase)*.42*alpha)
 for i in 3:
  var phase=fposmod(time*.34+i*.33,1)
  ripple(n,p+Vector2((i-1)*22,-44+sin(i*2.7)*3)*scale,Vector2(6+phase*9,1+phase*2)*scale,sin(phase*PI)*.22*alpha)
static func ripple(n:Node2D,center:Vector2,radius:Vector2,alpha:float):
 var points=PackedVector2Array()
 # Broken, elliptical glints rather than a ring drawn around the landmark.
 for i in 13:
  var angle=.12+float(i)/12*PI*1.38
  points.append(center+Vector2(cos(angle),sin(angle))*radius)
 n.draw_polyline(points,Color(.76,.96,.94,alpha),.75,true)
