class_name HoldLoadingView
extends Node2D
# A separate canvas covers HUD, modal panels and the Ivar cutscene together.
const ART=preload("res://assets/scenery/keldrath-hall.png")
const FONT=preload("res://assets/HoldRunic.ttf")
const HINTS=[
 ["A mountain is worked, one good seam at a time.","Hold your mining input to keep working the rock."],
 ["Build a worksite worth returning to.","Nearby stockpiles keep recovered material close at hand."],
 ["Know what is in your hands.","Use keys 1–0 to select tools and supplies on your hotbar."],
 ["The Hold has more than one story.","Stairs connect actual places above and below your feet."],
 ["Your first home is waiting.","Follow Ivar to your quarters, then meet the Folk of Keldrath."]
]
var game:Node
var elapsed=0.0
var fade=0.0
var was_loading=false
var hint=0
var completed=0.0
func _ready():visible=false
func _process(dt:float):
 var busy=HoldWholeFrames.warming()
 if busy:
  if not was_loading:elapsed=0;hint=posmod(hint+1,HINTS.size())
  elapsed+=dt;fade=.22;completed=HoldWholeFrames.progress()
 elif was_loading:completed=1.0
 else:fade=maxf(0,fade-dt)
 was_loading=busy;visible=busy or fade>0
 modulate.a=1.0 if busy else clampf(fade/.22,0,1)
 if visible:queue_redraw()
func _draw():
 draw_rect(Rect2(0,0,960,540),Color("10232a"))
 draw_texture_rect(ART,Rect2(0,-72,960,540),false)
 draw_rect(Rect2(0,0,960,340),Color(0.025,.055,.065,.20))
 for i in 40:
  draw_rect(Rect2(0,250+i*3,960,3),Color(.035,.07,.085,float(i)/40))
 draw_rect(Rect2(0,370,960,170),Color("091216"))
 draw_string(FONT,Vector2(48,58),"THE STELLAR HOLDS",HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color("f0d49b"))
 var destination=game.transition_label.text if game.playing else "THE FIRST FORTUNE"
 if destination=="":destination="WELCOME TO KELDRATH"
 text_at(Vector2(49,85),destination,14,Color("b4ccc5"))
 for i in 12:
  var at=Vector2(110+fposmod(i*79+sin(elapsed+i)*8,760),330-fposmod(elapsed*12+i*31,220))
  draw_circle(at,1.1,Color(1,.75,.4,.25))
 var tip=HINTS[posmod(hint+int(elapsed/9),HINTS.size())]
 text_at(Vector2(70,405),tip[0],20,Color("ead3a6"))
 text_at(Vector2(70,433),tip[1],16,Color("b6c7c5"))
 draw_style_box(bar_style(Color("304247")),Rect2(70,459,820,10))
 if completed>0:draw_style_box(bar_style(Color("c5a36a")),Rect2(70,459,820*completed,10))
 text_at(Vector2(70,495),"Preparing the Folk & their animations" if completed<1 else "Ready — welcome in",13,Color("9fb7b6"))
 text_at(Vector2(844,495),str(int(completed*100))+"%",13,Color("e7ce9d"))
func text_at(at:Vector2,value:String,size:int,color:Color):
 draw_string(ThemeDB.fallback_font,at,value,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)
func bar_style(color:Color)->StyleBoxFlat:
 var style=StyleBoxFlat.new();style.bg_color=color;style.set_corner_radius_all(4);return style
