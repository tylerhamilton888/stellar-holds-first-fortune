extends Node2D
## Painted forest textures use mipmapped filtering without changing dwarf sampling.
var host
func _ready():texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
func _draw():
 if host==null:return
 var offset=-host.camera
 if host.shake_amount>0:offset+=Vector2(sin(host.clock*103),cos(host.clock*137))*host.shake_amount
 offset=offset.round()
 var previous=HoldArt.draw_offset
 HoldArt.draw_offset=offset;draw_set_transform(offset)
 HoldForestry.draw(host,host.clock,host.state,self)
 HoldArt.draw_offset=previous
