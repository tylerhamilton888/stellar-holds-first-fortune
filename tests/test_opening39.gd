extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var failed=0
var passed=0
func check(ok:bool,label:String):
 if ok:passed+=1
 else:failed+=1;push_error(label)
func press(g,part:String)->bool:
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.contains(part) and not b.disabled:b.pressed.emit();return true
 check(false,"Response not found: "+part);return false
func speak(g,room:String):
 g.close_panel();g.room_id=room;g.player=Vector2(625,410);g.zone="hub";g.state.active_site="hold";g.interact()
func _initialize():call_deferred("run")
func run():
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel()
 var q=HoldOnboarding.ensure(g.state);q.stage=1;q.fresh=true
 speak(g,"commission");check(g.panel_id=="conversation","E at actual host opens dialogue")
 press(g,"I am ready to work");check(q.stage==2,"Employment accepted through response")
 for room in ["forge","market","tavern"]:
  speak(g,room);press(g,"Ivar sent me");press(g,"put that to use")
 check(q.stage==3 and g.state.opening==1,"Three introductions unlock coal shift")
 g.state.add("coal",8);speak(g,"commission");press(g,"Deliver ")
 check(q.stage==4 and g.state.opening==2,"Coal hand-in earns royal audience")
 press(g,"Mark the King's hall");g.enter_hold_destination("throne");g.player=Vector2(530,410);g.interact();press(g,"Step forward")
 check(is_instance_valid(g.opening_scene),"Audience starts from King dialogue")
 if is_instance_valid(g.opening_scene):g.opening_scene.finish()
 check(q.stage==5,"Audience advances to next commission")
 speak(g,"commission");press(g,"What needs doing next")
 check(q.stage==6 and HoldOnboarding.side_stories(g.state),"Ivar unlocks lessons and local requests")
 for id in ["hedrik","orla"]:
  speak(g,"tavern" if id=="hedrik" else "market");press(g,"quiet word");check(g.anniversary_host==id,"Secret belongs to physical host")
  press(g,"Your secret is safe")
  press(g,HoldAnniversary.INSCRIPTIONS[0] if id=="hedrik" else HoldAnniversary.MOTIFS[0])
  for k in HoldAnniversary.cost(0,id):g.state.add(k,HoldAnniversary.cost(0,id)[k])
  g.refresh_panel();press(g,"Fit the parts")
 check(HoldAnniversary.ensure(g.state).inviter=="orla","Second delivery invites from Orla's actual menu")
 press(g,"glad to come along")
 check(is_instance_valid(g.anniversary_scene),"Orla can launch exchange from her own room")
 if is_instance_valid(g.anniversary_scene):g.anniversary_scene.finish()
 check(HoldAnniversary.ensure(g.state).complete,"Exchange installs table and finishes quests")
 check(g.room_id=="" and g.zone=="hub" and g.player==Vector2(475,410),"Exchange returns safely beside furnishing")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("OPENING39: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
