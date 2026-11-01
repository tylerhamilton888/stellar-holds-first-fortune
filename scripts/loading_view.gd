class_name HoldLoadingView
extends Node2D
# A separate canvas covers HUD, modal panels and the Ivar cutscene together.
const ARTS=[
 preload("res://assets/story105/loading-mine.webp"),
 preload("res://assets/story105/loading-forge.webp"),
 preload("res://assets/story105/loading-home.webp"),
 preload("res://assets/story105/loading-river.webp")]
const FONT=preload("res://assets/HoldRunic.ttf")
const HINTS=[
 ["A mountain is worked, one good seam at a time.","Hold your mining input to keep working the rock."],
 ["Build a worksite worth returning to.","Nearby stockpiles keep recovered material close at hand."],
 ["Know what is in your hands.","Use keys 1–0 to select tools and supplies on your hotbar."],
 ["The Hold has more than one story.","Stairs connect actual places above and below your feet."],
 ["A home grows with its household.","Build from plans or piece by piece, then furnish your rooms."],
 ["Good tools begin at a good forge.","Bring your materials to a workstation to see what you can make."],
 ["Leave room for supper.","Gardens, fishing and cooking help provision your next day's work."]
]
var game:Node
var elapsed=0.0
var fade=0.0
var was_loading=false
var hint=0
var completed=0.0
var art_index=-1
func begin_load():
 elapsed=0;hint=posmod(hint+1,HINTS.size())
 art_index=posmod(art_index+1,ARTS.size())
func _ready():visible=false
func _process(dt:float):
 var busy=HoldWholeFrames.warming()
 if busy:
  if not was_loading:begin_load()
  elapsed+=dt;fade=.22;completed=HoldWholeFrames.progress()
 elif was_loading:completed=1.0
 else:fade=maxf(0,fade-dt)
 was_loading=busy;visible=busy or fade>0
 modulate.a=1.0 if busy else clampf(fade/.22,0,1)
 if visible:queue_redraw()
func _draw():
 draw_rect(Rect2(0,0,960,540),Color("10232a"))
 draw_texture_rect(ARTS[maxi(0,art_index)],Rect2(0,0,960,540),false)
 draw_rect(Rect2(0,0,960,100),Color(.025,.055,.065,.66))
 for i in 24:
  draw_rect(Rect2(0,330+i*3,960,3),Color(.035,.07,.085,float(i)/24*.94))
 draw_rect(Rect2(0,402,960,138),Color(.035,.07,.085,.94))
 draw_string(FONT,Vector2(48,58),"THE STELLAR HOLDS",HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color("f0d49b"))
 var destination=game.transition_label.text if game.playing else "THE FIRST FORTUNE"
 if destination=="":destination="WELCOME TO KELDRATH"
 text_at(Vector2(49,85),destination,14,Color("b4ccc5"))
 var tip=HINTS[posmod(hint+int(elapsed/9),HINTS.size())]
 text_at(Vector2(70,421),tip[0],20,Color("ead3a6"))
 text_at(Vector2(70,447),tip[1],16,Color("b6c7c5"))
 draw_style_box(bar_style(Color("304247")),Rect2(70,459,820,10))
 if completed>0:draw_style_box(bar_style(Color("c5a36a")),Rect2(70,459,820*completed,10))
 text_at(Vector2(70,495),"Preparing the Folk & their animations" if completed<1 else "Ready — welcome in",13,Color("9fb7b6"))
 text_at(Vector2(844,495),str(int(completed*100))+"%",13,Color("e7ce9d"))
func text_at(at:Vector2,value:String,size:int,color:Color):
 draw_string(ThemeDB.fallback_font,at,value,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)
func bar_style(color:Color)->StyleBoxFlat:
 var style=StyleBoxFlat.new();style.bg_color=color;style.set_corner_radius_all(4);return style
