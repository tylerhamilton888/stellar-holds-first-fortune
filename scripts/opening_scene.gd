class_name HoldOpeningScene
extends Node2D
const ARRIVAL=preload("res://assets/opening-v35/arrival.webp")
const A=preload("res://scripts/art.gd")
var game
var mode="arrival"
var step=0
var age=0.0
var clock=0.0
var layer:CanvasLayer
var lines:Array=[]
var caption:Label
var speaker:Label
var next_button:Button
var finished=false
var royal_portrait:TextureRect
var foreman_portrait:HoldPortrait
var player_x=610.0
var ivar_x=240.0
var walking=false
var ivar_walking=false
var shot_age=0.0
static func begin(g,kind:String):
 if is_instance_valid(g.opening_scene):return null
 if kind=="audience" and HoldOnboarding.stage(g.state)!=4:return null
 var scene=HoldOpeningScene.new();scene.game=g;scene.mode=kind
 g.close_panel();g.sound.stop_voice();g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer);scene.layer.add_child(scene)
 return scene
func _ready():
 if mode=="audience":player_x=405.0;game.state.resident_visits.ivar="throne"
 var name=game.state.appearance.first_name;var female=int(game.state.appearance.gender)==1
 if mode=="arrival":
  lines=[
   ["THE ROAD TO KELDRATH","Your coming-of-age feast ended three days ago. The last of your mother's bread is in your pack. Your tools are still wrapped against the rain."],
   ["A NAME OF YOUR OWN",("Your father called you his daughter when he said goodbye. Then he shook your hand as he would another working dwarf." if female else "Your father clasped your shoulder at the gate. 'Earn your supper, son. Write before your mother sends me after you.'")],
   ["BENEATH THE OLD KINGS","Stone kings watch the road. Freight cables whisper overhead. Behind the gates, a thousand hearths share the heat of machines older than your grandparents."],
   ["YOUR FIRST MORNING","No one here knows "+name+" "+game.state.appearance.family_name+" yet. You have forty-five crowns, a borrowed room, and a place to ask for work."],
   ["THE GATE STEWARD","'New for the lower shift? Ivar keeps the office beside the pithead. West along the concourse. Give him your name, and mind the freight cages.'"]]
 else:
  lines=[
   ["IVAR DEEPMEASURE",HoldCulture.render(game.state,"'{player:Subject} brought back sound coal and kept the route clear, my lord. I have counted {player:object} home.'")],
   ["LORD EIRIK GRANITECROWN","'Then come closer, "+name+". I would rather hear a working dwarf than another man explaining why his shipment is late.'"],
   ["LORD EIRIK GRANITECROWN",("'A young woman at the mining face is uncommon in this hold. Ivar tells me you asked for work, not favors. You shall have fair terms.'" if female else "'A young man with a sound pick can find wages here. What he does with them is the more interesting question.'")],
   ["LORD EIRIK GRANITECROWN","'There are ridges beyond our boundary with no household to tend them. Finish Ivar's commissions. Earn his reference. With that, and the charter fee, you may stake a claim of your own.'"],
   ["LORD EIRIK GRANITECROWN","'Do not mistake the parchment for a hold. You will need shelter, tools, people who trust you, and machines that do their work. In time, perhaps even a vessel fit for the dark between stars.'"],
   ["LORD EIRIK GRANITECROWN","'Your family gave you a name. What you build may give it a history. Start with Ivar's lift footings. His miners would appreciate reaching supper on time.'"],
   ["IVAR DEEPMEASURE","'You heard him. Back to my office when you are ready. Stone and timber next. After that, I know a few people with useful work for you.'"]]
 var ui=Control.new();ui.theme=game.ui.theme;add_child(ui)
 var bg=ColorRect.new();bg.position=Vector2(0,414);bg.size=Vector2(960,126);bg.color=Color("101f2b");ui.add_child(bg)
 speaker=Label.new();speaker.position=Vector2(28,426);speaker.add_theme_font_size_override("font_size",18);speaker.modulate=Color("edc98a");ui.add_child(speaker)
 caption=Label.new();caption.position=Vector2(28,454);caption.size=Vector2(735,78);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",17);ui.add_child(caption)
 next_button=game.button(ui,"Continue",advance);next_button.position=Vector2(790,461);next_button.size=Vector2(145,48)
 var skip=game.button(ui,"Skip scene",finish);skip.position=Vector2(810,16)
 if mode=="audience":
  royal_portrait=HoldRoyalHall.portrait();royal_portrait.position=Vector2(20,429);royal_portrait.size=Vector2(85,92);ui.add_child(royal_portrait)
  foreman_portrait=HoldPortrait.new();foreman_portrait.profile=game.state.npc("ivar");foreman_portrait.position=Vector2(20,429);foreman_portrait.size=Vector2(85,85);ui.add_child(foreman_portrait)
  speaker.position.x=125;caption.position.x=125;caption.size.x=635
 show_line()
func show_line():
 game.sound.set_context("road" if mode=="arrival" and step<2 else "throne" if mode=="audience" else "hub")
 if mode=="arrival" and step in [2,3]:shot_age=0
 age=0;speaker.text=lines[step][0];caption.text=lines[step][1]
 if mode=="audience":royal_portrait.visible=step not in [0,6];foreman_portrait.visible=step in [0,6]
 next_button.text="Enter the hold" if mode=="arrival" and step==lines.size()-1 else "Return to work" if step==lines.size()-1 else "Continue"
func advance():
 if age<.25:return
 if step==lines.size()-1:finish();return
 step+=1;show_line()
func finish():
 if finished:return
 finished=true
 game.state.resident_visits.erase("ivar")
 if mode=="arrival":
  HoldOnboarding.arrived(game.state);game.zone="hub";game.room_id="";game.player=Vector2(1840,410);game.camera=Vector2(1360,0)
  game.notify("Find Ivar west of the pithead. A/D: walk. E: enter or speak. J: journal.")
 else:
  HoldOnboarding.audience(game.state);game.room_id="throne";game.player=Vector2(470,410);game.camera=Vector2.ZERO
  game.notify("Return to Ivar. Your next commission will open more work around the hold.")
 game.velocity=Vector2.ZERO;game.grounded=true;game.jump_buffer=0;game.movement_remainder=0;game.jump_was_held=Input.is_action_pressed("jump")
 game.surface.enter("hearthward",Vector2(1580,405)) if mode=="arrival" else game.surface.enter("room:throne",Vector2(480,440))
 game.opening_scene=null;game.sound.set_context("hub");game.save_game();layer.queue_free()
func _input(e):
 if e is InputEventKey:
  if e.pressed and not e.echo:
   if e.keycode in [KEY_SPACE,KEY_ENTER,KEY_KP_ENTER]:advance()
   elif e.keycode==KEY_ESCAPE:finish()
  get_viewport().set_input_as_handled()
func _process(dt):
 if not get_window().has_focus():return
 clock+=dt;age+=dt;shot_age+=dt
 update_staging(dt)
 queue_redraw()
func update_staging(dt:float):
 if mode=="arrival":
  player_x=610.0;walking=false;ivar_walking=false;return
 var target=495.0 if mode=="audience" and step>=1 else 435.0 if mode=="audience" else 470.0
 var old=player_x;player_x=move_toward(player_x,target,48*dt);walking=absf(old-player_x)>.01
 old=ivar_x;ivar_x=move_toward(ivar_x,295,42*dt);ivar_walking=absf(old-ivar_x)>.01
func _draw():
 A.draw_offset=Vector2.ZERO
 if mode=="audience":
  HoldRoyalHall.draw(self,clock,game.state,false)
  HoldCinematic.shadow(self,Vector2(ivar_x,410))
  HoldCinematic.shadow(self,Vector2(player_x,410))
  A.dwarf(self,Vector2(ivar_x,410),clock,ivar_walking,1,0,false,game.state.npc("ivar"))
  A.dwarf(self,Vector2(player_x,410),clock,walking,-1 if step==6 else 1,0,false,game.state.appearance)
  HoldCinematic.focus(self,Vector2(ivar_x,260) if step in [0,6] else Vector2(639,265))
 else:
  var panel=0 if step<2 else 1 if step==2 else 2
  var height=ARRIVAL.get_height()/3.0
  draw_texture_rect_region(ARRIVAL,Rect2(0,74,960,340),Rect2(0,panel*height+2,ARRIVAL.get_width(),height-4))
 if shot_age<.75:A.rect(self,0,74,960,340,Color(.03,.06,.08,1-smoothstep(0.0,.75,shot_age)))
 A.rect(self,0,0,960,74,Color("101f2b"))
 A.text(self,Vector2(28,33),"THE FIRST FORTUNE" if mode=="arrival" else "AN AUDIENCE EARNED",23)
 A.text(self,Vector2(28,59),"Space / Enter: continue   Esc: skip",14,Color("b2d1c4"))
 HoldCinematic.progress(self,step,lines.size())
func character_scale()->float:return 1.5
