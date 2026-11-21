extends Node
func _ready():
 var example=load("res://dev/junction_preview.tscn").instantiate()
 add_child(example)
 if example.get_child_count()==0:return
 var game=example.get_child(0)
 if not game.fieldwork.has_method("soil"):game.fieldwork=load("res://furrow/field.gd").new(game)
 if not OS.get_cmdline_user_args().has("yard") and not OS.get_cmdline_user_args().has("cottage") and game.zone=="claim" and game.fieldwork.data().kit:
  game.fieldwork.terrain_mode="hoe"
  game.notify("Kitchen plot · Click to hoe. Right click to stop. Choose Hoe or Fill on the fieldwork board.")
