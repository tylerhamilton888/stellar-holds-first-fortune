extends SceneTree
var failed=0
func check(ok:bool,message:String):
 if not ok:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var game=load("res://main.tscn").instantiate();root.add_child(game);game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding");game.open_creator(false)
 var c=game.creator
 await process_frame;await process_frame
 check(not c.name_input.get_global_rect().intersects(c.family_input.get_global_rect()),"Given and family fields remain separate")
 check(c.family_input.get_global_rect().end.x<930,"Family field fits within creator")
 check(not c.family_input.editable,"An established family name is protected")
 var family=c.profile.family_name
 for node in c.find_children("*","Button",true,false):
  if node.text=="Randomize look":node.pressed.emit()
 check(c.profile.family_name==family,"Appearance randomization preserves surname")
 check(not c.portrait.get_global_rect().intersects(c.sprite.get_global_rect()),"Portrait and world preview must not overlap")
 for gender in 2:
  c.profile.gender=gender
  var given=c.profile.first_name
  for node in c.find_children("*","Button",true,false):
   if node.text=="Baseline look":node.pressed.emit()
  check(c.profile.family_name==family and c.profile.first_name==given,"Baseline preserves both names")
  check(c.profile.gender==gender and c.profile.hair_color==1,"Baseline preserves gender and restores honey hair")
  check(c.profile.beard_style==(5 if gender==1 else 0),"Baseline respects female facial-hair restriction")
  for page in 2:
   c.page_buttons[page].pressed.emit()
   await process_frame;await process_frame
   check(c.option_page==page,"Tab signal selects the requested options")
   check(c.picks.size()==(6 if gender==0 else 4) if page==0 else c.picks.size()==2,"All page options exist")
   for key in c.picks:
    var r=c.picks[key].get_global_rect()
    check(r.position.y>=170 and r.end.y<448 and r.end.x<930,"Option stays within panel: "+key)
   check(not c.picks.has("outfit") and not c.picks.has("cloth_color"),"Clothing choices deferred to equipment")
 game.playing=false;game.sound.stop_all();await create_timer(.5).timeout;game.queue_free();await process_frame
 print("CREATOR LAYOUT: %d FAILED" % failed);quit(1 if failed else 0)
