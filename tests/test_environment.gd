extends SceneTree
var failures=0
var checks=0
func check(ok:bool,message:String):
 checks+=1
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var a=HoldWorldStyle.address_seed(981,42,Vector2i(-8,12))
 check(a==HoldWorldStyle.address_seed(981,42,Vector2i(-8,12)),"Address is repeatable")
 check(a!=HoldWorldStyle.address_seed(981,43,Vector2i(-8,12)),"Planets have distinct seeds")
 check(a!=HoldWorldStyle.address_seed(981,42,Vector2i(-8,12),1),"Independent generation channels")
 var g=Geology.new();g.generate_region(981,42,Vector2i(-8,12))
 var saved=g.snapshot();var other=Geology.new();other.restore(saved)
 check(other.world_address==g.world_address and other.cells==g.cells,"World address and excavation survive save")
 other.generate_region(981,42,Vector2i(-8,12))
 check(other.cells==g.cells,"Regional terrain repeats independently of visit order")
 for y in range(35,46):
  for x in range(26,38):g.set_cell(Vector2i(x,y),2)
 var painter=Node2D.new();root.add_child(painter)
 var terrain=HoldTerrainView.new();var camera={"position":Vector2(0,140)}
 painter.draw.connect(func():terrain.draw(painter,g,1,camera.position))
 painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 check(terrain.chunks.size()>0 and terrain.chunks.size()<=24,"Only viewport chunks are materialized")
 var neighbor=terrain.chunks[Vector2i(1,1)].get_instance_id()
 var before=terrain.chunks[Vector2i(1,1)].get_image().get_pixel(0,32)
 g.set_cell(Vector2i(31,40),0)
 painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 check(terrain.chunks[Vector2i(1,1)].get_instance_id()!=neighbor,"Cut invalidates neighbor across chunk boundary")
 var after=terrain.chunks[Vector2i(1,1)].get_image()
 check(after.get_pixel(0,32)!=before,"Newly exposed adjacent face repaints")
 var incremental=after.get_data()
 g.redraw_all=true;painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 check(terrain.chunks[Vector2i(1,1)].get_image().get_data()==incremental,"Incremental rendering equals full rebuild")
 for x in [800,1600,0]:
  camera.position=Vector2(x,650);painter.queue_redraw();await process_frame;await RenderingServer.frame_post_draw
 check(terrain.chunks.size()<=48,"Travel keeps visual cache bounded")
 print("ENVIRONMENT: %d checks / %d failures" % [checks,failures]);quit(1 if failures else 0)
