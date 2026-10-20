class_name HoldSpritePreview
extends Control
var profile:Dictionary=HoldAppearance.defaults()
var clock=0.0
var motion="walk"
var viewport:SubViewport
var canvas:Node2D
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 viewport=SubViewport.new();viewport.size=Vector2i(288,288);viewport.transparent_bg=true;viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS;viewport.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR;add_child(viewport)
 canvas=Node2D.new();canvas.scale=Vector2(3,3);viewport.add_child(canvas);canvas.draw.connect(render)
 var picture=TextureRect.new();picture.texture=viewport.get_texture();picture.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);picture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;picture.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;picture.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(picture)
func _process(dt):clock+=dt;canvas.queue_redraw()
func render():
 canvas.draw_rect(Rect2(2,83,92,7),Color("526c69"))
 canvas.draw_rect(Rect2(2,90,92,6),Color("2b454e"))
 for i in 7:canvas.draw_rect(Rect2(3+i*14,84,12,1),Color("95a080"))
 HoldDrawnAnimation.paint(canvas,Vector2(48,83),profile,Vector2(1,.45),motion=="walk",clock,1.15,Vector2.ZERO,"pick" if motion=="work" else "",fposmod(clock,.64)/.64)
