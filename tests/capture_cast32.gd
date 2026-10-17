extends SceneTree
class Board extends Node2D:
 func character_scale()->float:return 2.0
 func _draw():
  HoldArt.rect(self,0,0,960,540,"172833")
  HoldArt.text(self,Vector2(25,35),"KELDRATH • LOCKED CHARACTER REFERENCES",22)
  for i in 2:
   var id=["hedrik","orla"][i];var p=HoldAppearance.npc_profile(id,1)
   HoldCharacterBust.draw(self,p,Rect2(25+i*480,72,275,275))
   HoldArt.dwarf(self,Vector2(370+i*480,347),0,false,-1 if i else 1,0,false,p)
   HoldArt.text(self,Vector2(25+i*480,391),p.name,22)
   HoldArt.text(self,Vector2(25+i*480,424),"Chestnut hair / high knot / forked beard / red coat" if i==0 else "Copper crown braids / blue coat / no facial hair",14)
func _initialize():call_deferred("run")
func run():
 var b=Board.new();root.add_child(b)
 await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/workspace/scratch/dc3395c394d3/tools/stories32/cast-reference.png")
 quit()
