extends "res://tests/input_reference54.gd"
func aim_at(p:Vector2):
 g.camera=g.deep.camera_target();root.warp_mouse((p-g.camera)*root.get_visible_rect().size/Vector2(960,540));await frames(2)
func press(pressed:bool):
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=pressed;Input.parse_input_event(e);await process_frame
func run():
 output="res://docs/testing/reference-0.54.0/mining";DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle();g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle()
 var w=g.deep.world;var c=Vector2i(12,8);w.set_cell(c,2);w.layer().damage.erase(Deepworks.key(c));g.player=Deepworks.center(Vector2i(11,8));g.tool=0;var origin=g.player
 await aim_at(Deepworks.center(c));await press(true);await frames(16)
 check(w.at(c)==2 and float(w.layer().damage.get(Deepworks.key(c),0))==0,"Anticipation does not remove stone before the actual impact")
 await snap("01-windup");await frames(9)
 check(w.at(c)==2 and float(w.layer().damage.get(Deepworks.key(c),0))>0,"First contact leaves persistent fractures in ordinary rock")
 await snap("02-contact");await frames(70)
 check(w.at(c)==0,"Held input finishes ordinary stone with two deliberate blows")
 check(g.player==origin,"Held mining does not automatically drag the Dwarf into successive walls")
 var mined=g.state.mined;await frames(100)
 check(g.state.mined==mined and g.player==origin,"Holding at a cleared face does not tunnel beyond tool reach")
 await press(false);await snap("03-open-face")
 var below=Deepworks.cell(g.player)+Vector2i.DOWN;w.set_cell(below,2);w.layer().damage.erase(Deepworks.key(below));g.deep.strike_left=0
 await aim_at(Deepworks.center(below));await press(true);await frames(24);await snap("04-south-contact");await press(false);await frames(30)
 check(w.at(below)==2,"Partial damage is retained when the held button is released")
 var north=Deepworks.cell(g.player)+Vector2i.UP;w.set_cell(north,2);w.layer().damage.erase(Deepworks.key(north));g.deep.strike_left=0
 await aim_at(Deepworks.center(north));await press(true);await frames(24);await snap("05-north-contact");await press(false);await frames(30)
 check(w.at(north)==2 and float(w.layer().damage.get(Deepworks.key(north),0))>0,"North-facing contact fractures the actual wall")
 var damage=w.layer().damage.duplicate(true);g.state.appearance.sculpt=6;g.state.appearance.gender=1;var inventory=g.state.inventory.duplicate(true);g.save_game();g.start_game(true);settle();w=g.deep.world
 check(w.layer().damage==damage and g.state.inventory==inventory,"Reload retains partial mining damage and inventory")
 check(g.state.appearance.sculpt==6 and g.state.appearance.gender==1,"Additional character variants survive save/reload")
 # Demonstrate that preparing new characters cannot swallow gameplay inputs after loading.
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.normalized({"gender":gender,"sculpt":sculpt})
   for d in [Vector2.DOWN,Vector2(1,1),Vector2(1,-1),Vector2.UP]:
    var a=HoldFolk.descriptor(p,d,true,.2,"",0);var h=HoldFolk.head_rect(p,a)
    check(h.index>=0 and h.index<28,"Variant %d/%d has registered view %d" % [gender,sculpt,a.view])
 print("MINING54: ",passed," passed / ",failed," failed");g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
