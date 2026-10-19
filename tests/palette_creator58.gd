extends SceneTree
var game
func _initialize():call_deferred("run")
func snap(tag:String):
 if game.playing:game.update_hud()
 game.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/testing/palette-fix58/creator/"+tag+".png")
func run():
 DirAccess.make_dir_recursive_absolute("res://docs/testing/palette-fix58/creator")
 game=load("res://main.tscn").instantiate();root.add_child(game);game.set_process(false)
 game.open_creator(true);await snap("creator")
 var old=game.creator.portrait.viewport.get_texture().get_image().get_data()
 game.creator.profile.hair_color=5;game.creator.profile.beard_color=5;game.creator.rebuild_options();game.creator.update_preview();await snap("creator-dark")
 assert(game.creator.portrait.viewport.get_texture().get_image().get_data()!=old,"Palette buttons refresh the static portrait viewport")
 game.creator.profile.gender=1;game.creator.profile.sculpt=4;game.creator.profile.hair_color=2;game.creator.rebuild_options();game.creator.update_preview();await snap("creator-female")
 assert(game.creator.portrait.profile.beard_style==5,"Female portrait profile has no facial hair")
 game.creator.option_page=1;game.creator.profile.tattoo=1;game.creator.profile.jewelry=1;game.creator.rebuild_options();game.creator.update_preview();await snap("clothing-details")
 game.creator.queue_free();await process_frame
 game.skip_arrival=true;game.start_game(false);game.state.outpost.erase("onboarding")
 while HoldFolk.warming():HoldFolk.warm_step()
 await snap("opening")
 game.close_panel();game.state.opening=1;game.open_panel("commission");await snap("foreman")
 game.panel_body.get_parent().scroll_vertical=340;await snap("foreman-portrait")
 game.playing=false;game.sound.stop_all();game.queue_free();await process_frame
 print("PALETTE58 CREATOR: live palette refresh, female normalization, opening and foreman captured")
 quit()
