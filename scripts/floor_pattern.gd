class_name HoldFloorPattern
extends RefCounted
# Original architectural floor drawing. Continuous world-aligned courses,
# staggered joints and restrained grain; cached mesh avoids per-frame tile work.
static var meshes={}
static var surface_texture:NoiseTexture2D
static func texture()->NoiseTexture2D:
 if surface_texture==null:
  var noise=FastNoiseLite.new();noise.seed=650;noise.frequency=.075;noise.fractal_octaves=3
  surface_texture=NoiseTexture2D.new();surface_texture.width=512;surface_texture.height=512;surface_texture.noise=noise
  var ramp=Gradient.new();ramp.colors=PackedColorArray([Color(.79,.8,.78),Color(1,1,1)]);surface_texture.color_ramp=ramp
 return surface_texture
static func quad(v:Array,c:Array,indices:Array,r:Rect2,color:Color):
 if not r.has_area():return
 var n=v.size();v.append_array(PackedVector3Array([Vector3(r.position.x,r.position.y,0),Vector3(r.end.x,r.position.y,0),Vector3(r.end.x,r.end.y,0),Vector3(r.position.x,r.end.y,0)]))
 for i in 4:c.append(color)
 indices.append_array(PackedInt32Array([n,n+1,n+2,n,n+2,n+3]))
static func draw(n:Node2D,rect:Rect2,wood:bool,tint:Color=Color.WHITE):
 var key=str(rect)+str(wood)+str(tint)
 if not meshes.has(key):
  var vertices=[];var colors=[];var indices=[]
  var height=25 if wood else 54;var width=137 if wood else 94
  var base=Color("79604a") if wood else Color("697874")
  quad(vertices,colors,indices,rect,base.darkened(.18)*tint)
  for row in range(int(floor(rect.position.y/height)),int(ceil(rect.end.y/height))):
   var offset=posmod(row,3)*width/3.0 if wood else posmod(row,2)*width/2.0
   for col in range(int(floor((rect.position.x-offset)/width)),int(ceil((rect.end.x-offset)/width))):
    var rng=RandomNumberGenerator.new();rng.seed=abs(row*374761393+col*668265263+int(wood)*19)
    var whole=Rect2(col*width+offset,row*height,width,height)
    var panel=whole.grow(-.65).intersection(rect)
    var color=base.lightened(rng.randf_range(.02,.13))*tint
    quad(vertices,colors,indices,panel,color)
    quad(vertices,colors,indices,Rect2(whole.position+Vector2(1,1),Vector2(width-2,1)).intersection(rect),color.lightened(.065))
    quad(vertices,colors,indices,Rect2(whole.position+Vector2(1,height-2),Vector2(width-2,1)).intersection(rect),color.darkened(.09))
    if wood:
     for line in 3:
      var x=rng.randf_range(8,35);var y=5+line*6+rng.randf_range(-1,1)
      quad(vertices,colors,indices,Rect2(whole.position+Vector2(x,y),Vector2(rng.randf_range(50,90),.5)).intersection(rect),color.darkened(.035))
  var uv=PackedVector2Array()
  for vertex in vertices:uv.append(Vector2(vertex.x/(8192.0 if wood else 2048.0),vertex.y/2048.0))
  var arrays=[];arrays.resize(Mesh.ARRAY_MAX);arrays[Mesh.ARRAY_TEX_UV]=uv;arrays[Mesh.ARRAY_VERTEX]=PackedVector3Array(vertices);arrays[Mesh.ARRAY_COLOR]=PackedColorArray(colors);arrays[Mesh.ARRAY_INDEX]=PackedInt32Array(indices)
  var mesh=ArrayMesh.new();mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays);meshes[key]=mesh
 n.draw_mesh(meshes[key],texture())
