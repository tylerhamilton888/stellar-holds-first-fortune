extends "res://scripts/homestead_life.gd"
const Ground=preload("res://furrow/patch.gd")
var patch=Ground.new()
var terrain_mode=""
var stroke=""
var struck=false
var target=Vector2i(-1,-1)

func _init(game):
 super(game)
 patch.load_art("res://furrow/joins.png")

func outdoors()->bool:
 return g.playing and g.zone=="claim" and g.surface.area=="claim" and g.surface.house.level()==0 and not g.surface.house.view.inside()

func soil()->Dictionary:
 var claim=g.state.forestry
 if not claim.has("kitchen_furrows"):claim.kitchen_furrows={}
 var id=str(g.state.claim_id)
 if not claim.kitchen_furrows.has(id):claim.kitchen_furrows[id]={}
 return claim.kitchen_furrows[id]

func choose(mode:String):
 placing=false
 g.close_panel()
 terrain_mode=mode
 g.notify(("Hoe soil" if mode=="hoe" else "Fill soil")+" · Click the meadow southeast of the porch. Right click to finish.")

func panel():
 super.panel()
 if outdoors() and data().kit:
  for mode in ["hoe","fill"]:
   g.small_button(g.panel_body,"Hoe kitchen plot" if mode=="hoe" else "Fill kitchen plot",func():choose(mode))

func valid(c:Vector2i)->bool:
 if not outdoors() or not data().kit or not Ground.contains(c) or g.handworks.busy_hands():return false
 var p=Ground.centre(c)
 if g.player.distance_to(p)>87 or not g.surface.clear_interaction(g.player,p):return false
 var tile=Rect2(p-Ground.STEP*.5,Ground.STEP).grow(-1)
 for rect in g.surface.obstacles():
  if tile.intersects(rect):return false
 return true

func input(e:InputEvent)->bool:
 if terrain_mode!="" and outdoors() and g.panel_id=="" and e is InputEventMouseButton and e.pressed and not g.hotbar.over():
  if e.button_index==MOUSE_BUTTON_RIGHT:
   terrain_mode="";cancel();return true
  if e.button_index==MOUSE_BUTTON_LEFT:
   if stroke!="" or action!="":return true
   var c=Ground.cell(g.world_mouse())
   if not valid(c):g.notify("Stand within hoe reach of clear kitchen plot ground.");return true
   if soil().has(Ground.key(c))==(terrain_mode=="hoe"):return true
   stroke=terrain_mode;target=c;action="hoe";elapsed=0;struck=false;origin=g.player
   g.surface.direction=g.player.direction_to(Ground.centre(c));return true
 return super.input(e)

func cancel():
 super.cancel();stroke=""

func update(dt:float):
 if not outdoors() or g.panel_id!="":terrain_mode=""
 if stroke=="":super.update(dt);return
 if terrain_mode=="" or Input.get_vector("left","right","up","down")!=Vector2.ZERO or not valid(target):cancel();return
 elapsed+=dt
 if elapsed>=.41 and not struck:
  struck=true
  if patch.edit(soil(),target,stroke=="hoe"):
   g.sound.effect("earth");g.save_game()
 if elapsed>=.79:cancel()

func draw_kitchen():
 if not outdoors():return
 patch.paint(g,soil())
 if terrain_mode!="" and g.panel_id=="":
  for x in [0,1]:
   for y in [0,1]:
    var corner=Ground.ORIGIN+Vector2(x,y)*Vector2(Ground.SIZE)*Ground.STEP
    var ink=Color(.88,.78,.48,.78)
    g.draw_line(corner,corner+Vector2(6 if x==0 else -6,0),ink,1.2)
    g.draw_line(corner,corner+Vector2(0,6 if y==0 else -6),ink,1.2)
  var c=Ground.cell(g.world_mouse())
  if Ground.contains(c):
   var box=Rect2(Ground.centre(c)-Ground.STEP*.5,Ground.STEP)
   g.draw_rect(box,Color(.95,.81,.44,.65) if valid(c) else Color(.76,.42,.31,.65),false,1)

func held_label()->String:
 if stroke=="fill":return "Filling soil · Garden hoe"
 return super.held_label()

func prompt()->String:
 if outdoors() and terrain_mode!="":return ("Hoe soil" if terrain_mode=="hoe" else "Fill soil")+" · Click ground · Right click to finish"
 return super.prompt()
