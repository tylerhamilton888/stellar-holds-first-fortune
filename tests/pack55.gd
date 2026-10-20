extends SceneTree
var g
var passed=0
var failed=0
var output="user://mining55-pack-review"
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():
 while HoldFolk.warming():HoldFolk.warm_step()
 g.transition_left=0;g.transition_shade.visible=false;g.close_panel();g.notice_time=0
func key(k:int):
 var e=InputEventKey.new();e.keycode=k;e.pressed=true;g._unhandled_input(e)
func frames(n:int):
 for i in n:g._process(1.0/60);await process_frame
func snap(name:String):
 g.camera=g.surface.camera_target() if g.surface.active() else g.deep.camera_target();g.update_hud();g.queue_redraw()
 for i in 8:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func at(p:Vector2):g.player=p;g.camera=g.surface.camera_target();g.notice_time=0
func button(prefix:String):
 for b in g.panel.find_children("*","Button",true,false):
  if b.text.begins_with(prefix) or b.text.trim_prefix("◆  ").trim_prefix("›  ").begins_with(prefix):b.pressed.emit();return
 failed+=1;push_error("Missing button "+prefix)
func run():
 DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true
 g.queue_redraw();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(output+"/00-title.png")
 g.start_game(false);settle();g.state.save_slot=3;g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false
 check(g.surface.area=="hearthward","Pack starts the existing game in Keldrath")
 var orla=g.state.npc("orla");var custom=HoldAppearance.normalized({"gender":1,"sculpt":0,"hair_color":2,"skin":orla.skin});var head=HoldFolk.MAP[1][0]
 check(HoldFolk.texture(orla,"female-heads",head,true).get_image().get_data()!=HoldFolk.texture(custom,"female-heads",head,true).get_image().get_data(),"Orla retains her authored copper independently of player dye cache")
 await snap("01-hearthward");g.player=Vector2(1010,330);check(g.surface.walkable(g.player),"Vault review stands on a real clear street");await snap("02-great-vault")
 g.state.appearance.gender=1;g.state.appearance.sculpt=6;HoldFolk.prepare(g);settle()
 check(HoldFolk.info("female-heads",6).has("rect") and HoldFolk.info("rear-work",6).has("neck"),"Packed frame metadata and additional artwork are available")
 g.surface.enter("trail",Vector2(950,340));settle();key(KEY_E);settle()
 check(g.zone=="mine","Pack uses the real trail mine entrance")
 var w=g.deep.world;var c=Vector2i(12,8);w.set_cell(c,2);g.player=Deepworks.center(Vector2i(11,8));var origin=g.player;g.tool=0;g.camera=g.deep.camera_target()
 root.warp_mouse((Deepworks.center(c)-g.camera)*root.get_visible_rect().size/Vector2(960,540));await frames(2)
 var e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=true;Input.parse_input_event(e);await frames(25)
 check(w.at(c)==2 and float(w.layer().damage.get(Deepworks.key(c),0))>0,"Exported held mining fractures stone before clearing it")
 await snap("03-mining-contact");await frames(145);e=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=false;Input.parse_input_event(e)
 check(w.at(c)==0 and g.player==origin,"Exported mining clears the face without automatic forward tunnelling")
 check(g.handworks.data().loose.size()==1 and int(g.handworks.data().loose[0].units)==4,"Pack releases one substantial raw load")
 var shift=InputEventKey.new();shift.keycode=KEY_SHIFT;shift.physical_keycode=KEY_SHIFT;shift.pressed=true;Input.parse_input_event(shift);await process_frame;Input.action_press("interact");await frames(140);Input.action_release("interact");shift.pressed=false;Input.parse_input_event(shift)
 check(g.handworks.data().loose.is_empty() and int(g.deep.haul.bucket().get("stone",0))==4,"Pack field dressing conserves the full physical yield")
 var stairs=Deepworks.ENTRY+Vector2i.DOWN*2;w.set_cell(stairs,0);g.player=Deepworks.center(stairs);w.carve_stairs(stairs);key(KEY_E);settle()
 check(w.depth()==1,"Pack descends through matching carved stairs")
 var feature=w.layer().features[0];g.player=Deepworks.center(Vector2i(feature.x,feature.y));w.survey(g.player);await snap("04-deeper-cavern")
 check(feature.found,"Pack discovers a generated cavern")
 g.state.add("coal",7);var coal=g.state.count("coal");g.save_game();g.start_game(true);settle();w=g.deep.world
 check(w.depth()==1 and g.state.count("coal")==coal and g.state.appearance.sculpt==6,"Pack saves and reloads depth, resources and new identity")
 g.player=Deepworks.center(stairs);g.deep.use_stairs(true);settle();check(w.depth()==0,"Pack returns through the same XY stair")
 g.player=Deepworks.center(Deepworks.ENTRY);key(KEY_E);settle();check(g.surface.area=="trail","Pack returns naturally to the surface")
 g.surface.enter("room:throne");settle();await snap("05-enthroned-lord")
 print("PACK55: ",passed," passed / ",failed," failed");g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
