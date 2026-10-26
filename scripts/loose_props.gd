class_name HoldLooseProps
extends RefCounted
# Each crop is one object. World dressing and player furniture share these
# drawings; signs, lamps and stonework never travel as an inseparable cluster.
const ATLAS=preload("res://assets/combat88/decorations.png")
const CROPS={
 "runestone":Rect2(59,14,428,559),
 "signpost":Rect2(653,46,360,495),
 "road_lantern":Rect2(1130,43,283,504),
 "barrel":Rect2(105,595,310,377),
 "crate":Rect2(568,581,395,396),
 "plinth":Rect2(1030,624,468,355)
}
static var textures={}
static func draw(n:CanvasItem,destination:Rect2,kind:String,tint:Color=Color.WHITE):
 if not textures.has(kind):
  var img=ATLAS.get_image()
  if img.is_compressed():img.decompress()
  img=img.get_region(Rect2i(CROPS[kind]))
  # Filter fine painted grain before the small gameplay silhouette is sampled.
  # Keep enough detail for the larger catalogue without changing the source.
  var size:Vector2=HoldFurnishings.geometry(kind).size*2.6
  img.resize(int(size.x),int(size.y),Image.INTERPOLATE_LANCZOS)
  textures[kind]=ImageTexture.create_from_image(img)
 n.draw_texture_rect(textures[kind],destination,false,tint)
