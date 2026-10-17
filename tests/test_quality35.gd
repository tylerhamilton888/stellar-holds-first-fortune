extends SceneTree
class Game extends "res://scripts/main.gd":
 func save_game():pass
var passed=0
var failed=0
func check(ok:bool,message:String):
 if ok:passed+=1
 else:failed+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var s=HoldState.new();s.reset(35)
 for id in HoldNpcPresence.HOMES:
  var count=0
  for room in HoldInteriors.ROOMS:
   if HoldNpcPresence.inside(s,id,room):count+=1
  check(count==1,id+" has exactly one room")
  check(not HoldNpcPresence.inside(s,id,""),id+" is not also outside")
 s.active_site="claim"
 for id in HoldNpcPresence.HOMES:check(not HoldNpcPresence.inside(s,id,HoldNpcPresence.HOMES[id].room),id+" is not duplicated at the claim")
 s.active_site="hold"
 s.resident_visits.borin="training"
 check(HoldNpcPresence.inside(s,"borin","training") and not HoldNpcPresence.inside(s,"borin","forge"),"Borin relocates for training without duplication")
 s.resident_visits.clear()
 var orla=s.npc("orla");check(orla.gender==1 and orla.sculpt==0 and orla.cloth_color==1,"Orla keeps crown braids and blue clothes")
 check(HoldAppearance.hair(orla)==Color("c7622e"),"Orla uses cinematic copper palette")
 for gender in 2:
  for sculpt in 5:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt,"hair_color":5})
   for armed in [false,true]:
    var min_top=112;var max_top=0
    for f in 8:
     var img=HoldPaintedWalk.texture(p,f,armed).get_image();var rect=img.get_used_rect()
     min_top=mini(min_top,rect.position.y);max_top=maxi(max_top,rect.position.y)
     check(rect.end.y in [104,105],"Planted sole remains on baseline: "+HoldPaintedWalk.key(p,f,armed))
     var masks=HoldCharacterMaterials.mask_for("walk35/"+HoldPaintedWalk.key(p,f,armed),112,112)
     check(masks.size()==12544,"Walk material dimensions")
     check(HoldPaintedWalk.sockets(p,f,armed).has("hand"),"Hand/equipment rig retained")
    check(max_top-min_top<=7,"Stable character height: "+HoldCharacterDesigns.id(p))
 var g=Game.new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);g.close_panel();g.grounded=true
 for id in HoldNpcPresence.HOMES:
  g.room_id="";check(not HoldOnboarding.local(g,id),"No outdoor conversation with indoor "+id)
  g.room_id=HoldNpcPresence.HOMES[id].room;check(HoldOnboarding.local(g,id),"Conversation follows resident into "+g.room_id)
 g.room_id="";var opener=HoldOpeningScene.begin(g,"arrival");g.opening_scene=opener;await process_frame
 opener.update_staging(2);var x=opener.player_x;opener.update_staging(20)
 check(opener.player_x==x and not opener.walking,"Arrival is a stable illustrated panel")
 opener.step=4;opener.age=1;opener.advance();check(HoldOnboarding.ensure(g.state).arrival_seen,"Arrival completes onboarding")
 check(g.velocity==Vector2.ZERO and g.grounded,"Arrival hands off without inherited motion")
 g.room_id="";g.zone="hub";g.state.active_site="hold";g.player=Vector2(100,410)
 g.enter_west_gallery()
 check(g.state.hold_travel.get("at")==10 and g.state.hold_travel.get("active",false),"West gallery enters the concourse stair on the hold plan")
 g.enter_hold_destination("concourse")
 check(g.player==Vector2(95,410) and g.camera==Vector2.ZERO,"West gallery returns at the same grounded threshold")
 check(g.state.hold_travel.is_empty(),"Returning from gallery clears map travel")
 g.playing=false;g.sound.stop_all();g.queue_free();await process_frame
 print("QUALITY35: %d passed, %d failed" % [passed,failed]);quit(1 if failed else 0)
