class_name HoldQuestScene181
extends HoldOpeningScene
# Presentation only. Quest owners commit their transactions before these scenes begin.
const SCENES={
 "borin":{"title":"BORIN · THE COMMUNAL SMITH","end":"Inspect the hearth · J keeps your next lead.","lines":[["borin","Borin wipes a clear patch on the anvil. 'New at the Rise? Borin. If it has an edge, a hinge or a habit of breaking, it usually finds its way here.'"],["borin","'The hearth's cold, but the stonework is sound. Have a look. When the fuel is in, we'll put some warmth back into this place.'"]]},
 "forge":{"title":"THE FIRST FIRING","end":"The forge is open · smelting, crafting and Borin's commissions are available.","lines":[["borin","Borin works the bellows. A thin red line brightens beneath the coal; then the hearth catches. He holds out his hands to the warmth."],["borin","'There she is. Your pay's counted. Bring your work here when you're ready—or ask me to make something. A town ought to have a forge people can use.'"]]},
 "winter":{"title":"SOMETHING SET ASIDE","end":"Winter Stores are open · the community trading counter is inside.","lines":[["","The last provisions are entered in the book. Inside, stocked barrels and crates stand ready for the colder months."],["","There will be tools to mend and more stone to shift tomorrow. For now, Stonebridge has something set aside. The community counter is open."]]},
 "rescue":{"title":"THE MISSING SURVEY CREW","end":"Rescue accepted · J keeps the refuge, support and return-route instructions.","lines":[["ivar","Ivar moves his cup aside and spreads out the survey. 'A fall in Old Workings. Sten's crew reached a refuge on the first depth, but their way out is sealed.'"],["ivar","'Cut a way around it. Give them light and a sound support before you ask them to move. Then keep their route clear all the way back. The stone can wait; they're what matters.'"],["ivar","He folds the survey toward you. 'The details are in your journal. There is no countdown. Take the time to make their way home safe.'"]]}}
static func record(s)->Dictionary:
 if not s.surface.has("quest_scene181"):s.surface.quest_scene181={"version":1,"active":"","beat":0,"seen":{}}
 return s.surface.quest_scene181
static func allowed(g,id:String)->bool:
 if not HoldFrontier103.active(g.state) or g.zone=="mine":return false
 match id:
  "borin":return HoldFrontier103.near(g,"forge") and not HoldLedger137.complete(g.state,"forge")
  "forge":return HoldFrontier103.near(g,"forge") and HoldLedger137.complete(g.state,"forge")
  "winter":return HoldCampaign138.near_site(g) and HoldCampaign138.data(g.state).winter_ready
  "rescue":return HoldFrontier103.near(g,"lodge") and int(HoldAncestralClaim.data(g.state).stage)==1
 return false
static func play(g,id:String)->bool:
 if is_instance_valid(g.opening_scene) or not SCENES.has(id) or not allowed(g,id):return false
 var d=record(g.state)
 if d.seen.get(id,false) or d.active!="":return false
 d.active=id;d.beat=0;g.save_game();resume(g);return true
static func resume(g):
 if is_instance_valid(g.opening_scene) or not g.state.surface.has("quest_scene181"):return
 var d=record(g.state);var id=str(d.active)
 if id=="":return
 if not SCENES.has(id) or not allowed(g,id):d.active="";d.beat=0;g.save_game();return
 var scene=HoldQuestScene181.new();scene.game=g;scene.mode=id;scene.step=int(d.beat)
 g.close_panel();g.sound.stop_voice();g.velocity=Vector2.ZERO;g.walking_pose=false;g.swing=0;g.mining_buffer=0;g.jump_buffer=0
 scene.layer=CanvasLayer.new();scene.layer.layer=30;g.add_child(scene.layer);g.opening_scene=scene;scene.layer.add_child(scene)
func _ready():
 lines=SCENES[mode].lines;step=clampi(step,0,lines.size()-1)
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=false
 game.sync_hud_controls()
 var ui=Control.new();ui.theme=game.ui.theme;add_child(ui)
 var top=ColorRect.new();top.size=Vector2(960,64);top.color=Color("101f2b");ui.add_child(top)
 var title=Label.new();title.position=Vector2(26,12);title.text=SCENES[mode].title;title.modulate=Color("edc98a");ui.add_child(title)
 var bg=ColorRect.new();bg.position=Vector2(0,400);bg.size=Vector2(960,140);bg.color=Color("101f2b");ui.add_child(bg)
 foreman_portrait=HoldPortrait.new();foreman_portrait.position=Vector2(20,418);foreman_portrait.size=Vector2(85,100);ui.add_child(foreman_portrait)
 speaker=Label.new();speaker.position=Vector2(125,411);speaker.modulate=Color("edc98a");speaker.add_theme_font_size_override("font_size",17);ui.add_child(speaker)
 caption=Label.new();caption.position=Vector2(125,439);caption.size=Vector2(620,96);caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;caption.add_theme_font_size_override("font_size",16);ui.add_child(caption)
 next_button=game.button(ui,"Continue · Enter",advance);next_button.position=Vector2(765,461);next_button.size=Vector2(175,48)
 var skip=game.button(ui,"Skip scene · Esc",finish);skip.position=Vector2(775,6);skip.size=Vector2(165,35)
 show_line()
func show_line():
 age=0;var id=str(lines[step][0]);foreman_portrait.visible=id!=""
 if id!="":foreman_portrait.apply_profile(game.state.npc(id))
 speaker.text=game.state.npc(id).name if id!="" else "STONEBRIDGE"
 speaker.position.x=125 if id!="" else 26;caption.position.x=speaker.position.x;caption.size.x=620 if id!="" else 720
 caption.text=lines[step][1];next_button.text="Return to play" if step==lines.size()-1 else "Continue · Enter"
 game.camera=game.surface.camera_target();game.queue_redraw();queue_redraw()
func advance():
 if finished or age<.25:return
 if step==lines.size()-1:finish();return
 step+=1;record(game.state).beat=step;game.save_game();show_line()
func finish():
 if finished:return
 finished=true;var d=record(game.state);d.seen[mode]=true;d.active="";d.beat=0
 game.opening_scene=null;game.velocity=Vector2.ZERO;game.walking_pose=false;game.swing=0;game.mining_buffer=0;game.jump_buffer=0
 for n in [game.hud,game.status,game.objectives,game.footer]:n.visible=true
 game.surface.roads.portal_cooldown=1.0;game.save_game();game.update_hud();game.notify(SCENES[mode].end);game.queue_redraw();layer.queue_free()
func _process(dt):
 if not get_window().has_focus() or HoldFolk.warming():return
 age+=dt;clock+=dt;game.clock+=dt;game.camera=game.surface.camera_target();game.queue_redraw()
func _draw():
 HoldCinematic.progress(self,step,lines.size())
