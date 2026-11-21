extends SceneTree
# Uses the mid-introduction save written by contest_opening.gd.
var g

func _initialize():call_deferred("run")

func wait_ui():
 for i in 5:await process_frame

func button(node,label):
 if node is CanvasLayer and not node.visible:return null
 if node is CanvasItem and not node.is_visible_in_tree():return null
 if node is Button and not node.disabled and node.text==label:return node
 for c in node.get_children():
  var result=button(c,label)
  if result!=null:return result
 return null

func run():
 g=load("res://main.tscn").instantiate();root.add_child(g)
 await wait_ui()
 for choice in ["Load Game","Continue"]:
  var item=button(g,choice)
  if item==null:push_error("Missing "+choice);quit(1);return
  item.pressed.emit();await wait_ui()
 var scene=g.opening_scene
 if not is_instance_valid(scene) or scene.step!=3 or scene.speaker.text!="SKARRIN":
  push_error("Expected the saved Skarrin beat");quit(1);return
 var skip=button(g,"Skip scene")
 if skip==null:push_error("Missing skip");quit(1);return
 skip.pressed.emit();await wait_ui()
 if is_instance_valid(g.opening_scene) or g.state.surface.first_visit99.intro_pending or g.state.claim_id!="copper_ridge" or g.state.surface.first_visit99.focus!="forge":
  push_error("Skipped intro lost ownership or tracking");quit(1);return
 print("PASS Load Game resumed Skarrin's saved beat. Skip returned control with the deed and forge lead.")
 quit()
