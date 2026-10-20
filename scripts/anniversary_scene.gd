class_name HoldAnniversaryScene
extends Node2D
const A=preload("res://scripts/art.gd")
const STORY_ART=preload("res://assets/story-v44/anniversary-gifts.png")
const REACTIONS=preload("res://assets/story-v44/anniversary-reactions.png")
const LINES=[
 ["hedrik","Fifty years. We said nothing grand, Orla. So I made you a kettle."],
 ["orla","Hedrik. Is that a pressure regulator?"],
 ["hedrik","Tea should arrive hot. Not explosively. I engraved the inside of the lid, too."],
 ["orla","Then my little table won't seem excessive. Heated shelves. Space for your mugs."],
 ["hedrik","How long have you been carving that?"],
 ["orla","Eight years. On and off. Don't make a thing of it."],
 ["hedrik","Mine appears to be missing a table."],
 ["orla","Mine appears to be missing a kettle."],
 ["orla","You knew about both gifts. And you never said a word."],
 ["hedrik","Good {player:kin}. Kept both secrets. Come on, let's see if the measurements agree."],
 ["hedrik","Perfect fit! A modest triumph of domestic engineering."],
 ["orla","There. Another century of keeping your beard out of the steam."],
 ["hedrik","An ambitious undertaking. Happy anniversary, love."],
 ["brann","Fifty years already? Ah, young love."],
 ["orla","Stay a while. The mountain will still be there after a cup."]
]
var game
var step=0
var age=0.0
var clock=0.0
var layer:CanvasLayer
var controls:Control
var caption:Label
var speaker:Label
var portrait:HoldPortrait
var advance_button:Button
var finished=false

static func begin(g):
 if is_instance_valid(g.anniversary_scene) or not HoldAnniversary.ready(g.state):return null
 var q=HoldAnniversary.ensure(g.state)
 if not q.complete and not HoldAnniversary.local_host(g,str(q.inviter)):return null
 var scene=HoldAnniversaryScene.new();scene.game=g
 g.close_panel();g.sound.stop_voice();g.velocity=Vector2.ZERO;g.swing=0;g.mining_buffer=0
 g.jump_buffer=0;g.walking_pose=false
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer);scene.layer.add_child(scene)
 return scene

func _ready():
 controls=Control.new();controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);controls.theme=game.ui.theme;add_child(controls)
 var shade=ColorRect.new();shade.color=Color("101f2b");shade.position=Vector2(0,418);shade.size=Vector2(960,122);controls.add_child(shade)
 portrait=HoldPortrait.new();portrait.position=Vector2(22,434);portrait.custom_minimum_size=Vector2(80,80);portrait.size=Vector2(80,80);controls.add_child(portrait)
 speaker=Label.new();speaker.position=Vector2(120,430);speaker.add_theme_font_size_override("font_size",18);speaker.modulate=Color("edc98a");controls.add_child(speaker)
 caption=Label.new();caption.position=Vector2(120,458);caption.size=Vector2(650,77);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",17);controls.add_child(caption)
 advance_button=game.button(controls,"Next ›",advance);advance_button.position=Vector2(805,463);advance_button.size=Vector2(135,50)
 var skip=game.button(controls,"Skip exchange",finish);skip.position=Vector2(770,18)
 show_line()

func show_line():
 age=0
 var line=LINES[step];speaker.text=game.state.npc(line[0]).name + (" (from the hall)" if line[0]=="brann" else "")
 caption.text=HoldCulture.render(game.state,line[1]);portrait.apply_profile(game.state.npc(line[0]))
 if step==2:caption.text+=" Inside: “"+HoldAnniversary.INSCRIPTIONS[int(HoldAnniversary.gift(game.state,"hedrik").choice)]+"”"
 if step==5:caption.text+=" The carving: "+HoldAnniversary.MOTIFS[int(HoldAnniversary.gift(game.state,"orla").choice)]+"."
 advance_button.text="Share a cup" if step==LINES.size()-1 else "Next ›"

func advance():
 if age<(.8 if step==10 else .25):return
 if step>=LINES.size()-1:finish();return
 step+=1;show_line()

func finish():
 if finished:return
 finished=true
 var reward=HoldAnniversary.finish(game.state)
 # Return to a safe, predictable place beside the new furnishing, regardless of replay.
 game.room_id="";game.zone="hub";game.state.active_site="hold";game.player=Vector2(475,410);game.camera=Vector2.ZERO
 game.grounded=true;game.velocity=Vector2.ZERO;game.jump_buffer=0;game.movement_remainder=0;game.jump_was_held=Input.is_action_pressed("jump")
 game.sound.set_context("hub");game.save_game();game.anniversary_scene=null
 if reward:game.sound.effect("quest",-10);game.notify("Two secrets kept. +50 crowns, +4 provisions. The tea table is open.")
 layer.queue_free()

func _input(e):
 if e is InputEventKey:
  if e.pressed and not e.echo:
   if e.keycode in [KEY_SPACE,KEY_ENTER,KEY_KP_ENTER]:advance()
   elif e.keycode==KEY_ESCAPE:finish()
  get_viewport().set_input_as_handled()

func _process(dt):
 if not get_window().has_focus():return
 clock+=dt;age+=dt
 # Visual steam puff occurs on this exact beat, with no unrelated mining impact sound.
 queue_redraw()

func _draw():
 A.draw_offset=Vector2.ZERO
 # Complete matched storybook plates keep characters, props and lighting in one illustration.
 A.rect(self,0,77,960,341,Color("17232b"))
 var shot=shot_for_beat(step)
 var size=shot.region.size;var scale=minf(960.0/size.x,341.0/size.y)
 var dest=Rect2(Vector2(480,247.5)-size*scale*.5,size*scale)
 draw_texture_rect_region(shot.texture,dest,shot.region)
 # Subtle page frame; expressions and props carry the story without floating overlays.
 draw_rect(Rect2(10,82,940,330),Color(.84,.66,.35,.35),false,1)
 if (step in [3,6,8,10,11,12] and age<.55) or clock<.65:
  var fade=age if step in [3,6,8,10,11,12] else clock
  A.rect(self,0,77,960,341,Color(.03,.06,.08,1-smoothstep(0.0,.55,fade)))
 A.rect(self,0,0,960,77,Color("101f2b"))
 A.text(self,Vector2(28,33),"A SECRET KEPT TWICE",23)
 A.text(self,Vector2(28,59),"Their fiftieth anniversary • small gifts, properly made",15,Color("b5d2c7"))
 HoldCinematic.progress(self,step,LINES.size())

# Explicit editorial mapping keeps dialogue, expressions and prop state together.
func shot_for_beat(beat:int)->Dictionary:
 if beat in [8,9]:return {"texture":REACTIONS,"region":Rect2(0,2,1254,463),"id":"secrets"}
 if beat==11:return {"texture":REACTIONS,"region":Rect2(0,472,1254,386),"id":"steam"}
 if beat==10:return {"texture":REACTIONS,"region":Rect2(0,866,1254,386),"id":"admiring"}
 var pose=0 if beat<3 else 1 if beat<12 else 2
 return {"texture":STORY_ART,"region":Rect2(0,pose*418+3,1254,412),"id":["kettle","table","toast"][pose]}
