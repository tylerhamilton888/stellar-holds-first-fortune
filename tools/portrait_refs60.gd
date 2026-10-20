extends SceneTree
func _initialize():
 var out=OS.get_cmdline_user_args()[0]
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":1})
   var id=HoldWholeFrames.identity(p)
   HoldWholeFrames.texture(p,id+"-core",0,true).get_image().save_png(out+"/"+id+".png")
 print("PORTRAIT60 REFERENCES COMPLETE")
 quit()
