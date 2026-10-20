extends SceneTree
func _initialize():call_deferred("run")
func run():
 var b=Node2D.new();root.add_child(b)
 b.draw.connect(func():b.draw_rect(Rect2(0,0,960,540),Color("152e34")))
 for i in 4:
  var p=HoldPortrait.new();p.profile=HoldAppearance.normalized({"sculpt":i,"hair_color":[1,6,4,3][i]});p.size=Vector2(210,210);p.position=Vector2(22+i*235,28);root.add_child(p)
  var q=HoldPortrait.new();q.profile=HoldAppearance.normalized({"sculpt":i,"hair_color":7,"cloth_color":2});q.size=Vector2(210,210);q.position=Vector2(22+i*235,290);root.add_child(q)
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/testing/portraits60/first-review.png")
 print("PORTRAIT60 FIRST REVIEW COMPLETE")
 quit()
