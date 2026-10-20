extends SceneTree
func _initialize():call_deferred("run")
func run():
 for gender in 2:
  for sculpt in 5:
   for pigment in [0,5,7]:
    var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":pigment})
    HoldCharacterBust.texture(p).get_image().save_png("/workspace/scratch/dc3395c394d3/tools/quality38/"+HoldCharacterDesigns.id(p)+"-"+str(pigment)+".png")
 print("Neck palette captures complete");quit()
