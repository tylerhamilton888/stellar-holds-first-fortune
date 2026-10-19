class_name HoldPortrait
extends Control
# The selected identity is shared with the game; no old-design fallback in the creator.
var profile:Dictionary=HoldAppearance.defaults()
var viewport:SubViewport
var canvas:Node2D
var clock=0.0
var animate=false
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 viewport=SubViewport.new();viewport.size=Vector2i(384,384);viewport.transparent_bg=true;viewport.render_target_update_mode=SubViewport.UPDATE_ONCE
 viewport.canvas_item_default_texture_filter=Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR;add_child(viewport)
 var background=Node2D.new();viewport.add_child(background);background.scale=Vector2(4,4);background.draw.connect(func():
  background.draw_rect(Rect2(0,0,96,96),Color("283f45"))
  for i in 8:background.draw_circle(Vector2(48,47),48-i*5,Color(.32,.44,.43,.07))
 )
 canvas=Node2D.new();viewport.add_child(canvas);canvas.scale=Vector2(4,4)
 canvas.draw.connect(draw_bust)
 var frame=Node2D.new();viewport.add_child(frame);frame.scale=Vector2(4,4);frame.draw.connect(func():
  frame.draw_rect(Rect2(1,1,94,94),Color("b69762"),false,2)
  frame.draw_rect(Rect2(4,4,88,88),Color("677a70"),false,1))
 var picture=TextureRect.new();picture.texture=viewport.get_texture();picture.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);picture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;picture.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;picture.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(picture)
 apply_profile(profile)
func apply_profile(p:Dictionary):
 profile=HoldAppearance.normalized(p)
 if is_instance_valid(canvas):
  canvas.queue_redraw();viewport.render_target_update_mode=SubViewport.UPDATE_ONCE
func draw_bust():
 var pose=HoldFolk.descriptor(profile,Vector2.DOWN,false,0,"",0)
 var head=HoldFolk.head_rect(profile,pose)
 HoldFolk.paint(canvas,Vector2(48,12-head.rect.position.y*2.4),profile,Vector2.DOWN,false,0,2.4,Vector2.ZERO)
