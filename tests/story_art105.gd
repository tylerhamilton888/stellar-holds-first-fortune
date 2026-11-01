extends "res://tests/support/game_fixture.gd"
class LoadingHost:
 extends Node
 var playing=false
 var transition_label=Label.new()
func shot(name:String):
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 root.size=Vector2i(960,540)
 var s=HoldState.new();s.reset(7105)
 var original=HoldAppearance.normalized({"gender":1,"sculpt":2,"hair_color":3})
 var original_json=JSON.stringify(original)
 var tagged=HoldStoryArt105.tag(original,"road_folk:1")
 check(tagged.cast_id=="dagna" and JSON.stringify(original)==original_json,"Tagging preserves saved appearance dictionary")
 check(HoldStoryArt105.resolve("road_folk:-1")=="" and HoldStoryArt105.resolve("road_folk:xx")=="","Unknown and malformed IDs do not acquire named art")
 check(not HoldStoryArt105.has_portrait(original),"Background and player profiles keep shared art")
 for i in HoldStoryArt105.ROAD.size():
  var id="road_folk:"+str(i)
  s.npc_appearances[id]=original.duplicate(true)
  check(s.npc(id).cast_id==HoldStoryArt105.ROAD[i],"Saved road identity routes by ID "+id)
  check(s.npc_appearances[id]==original,"Reading named portrait leaves saved sculpt and colors unchanged "+id)
 for id in HoldOutpost.CREW:
  check(s.npc(id).get("cast_id","")==id,"Crew identity routes "+id)
 check(HoldWorkplace98.profile().cast_id=="odrin","Workplace uses Odrin portrait")
 check(HoldPaintedPortraits.identity(s.npc("eirik"))=="eirik","Existing Eirik painting retained")
 for page in 2:
  var board=Control.new();root.add_child(board)
  for slot in 12:
   var index=page*12+slot;var id=HoldStoryArt105.CAST[index]
   var p=HoldStoryArt105.tag(original,id)
   var face=HoldPortrait.new();face.profile=p;face.position=Vector2(25+(slot%6)*155,24+int(slot/6)*252);face.size=Vector2(132,132);board.add_child(face)
   var label=Label.new();label.text=id.capitalize();label.position=face.position+Vector2(0,136);board.add_child(label)
   var small=HoldPortrait.new();small.profile=p;small.position=face.position+Vector2(23,160);small.size=Vector2(86,86);board.add_child(small)
   var tex=HoldPaintedPortraits.texture(p)
   check(tex is AtlasTexture and tex.get_size()==Vector2(512,512),"Full portrait crop "+id)
   check(face.canvas.material==null,"Natural named colors bypass generic dye "+id)
  await shot("portraits-"+str(page));board.queue_free();await process_frame
 var face=HoldPortrait.new();root.add_child(face);face.size=Vector2(96,96)
 face.apply_profile(original);check(face.canvas.material is ShaderMaterial,"Shared portrait retains palette shader")
 face.apply_profile(tagged);check(face.canvas.material==null,"Switching to named portrait clears old shader")
 face.apply_profile(original);check(face.canvas.material is ShaderMaterial,"Switching back restores palette shader")
 face.queue_free();await process_frame
 var host=LoadingHost.new();root.add_child(host)
 var loading=HoldLoadingView.new();loading.game=host;root.add_child(loading);loading.set_process(false);loading.visible=true;loading.completed=.63
 for index in 5:
  loading.begin_load();loading.queue_redraw()
  check(loading.art_index==index%4,"Loading art rotates once per load and wraps")
  var fixed=loading.art_index;loading.elapsed=24
  check(loading.art_index==fixed,"Tip time does not swap scene mid-load")
  if index<4:await shot("loading-"+str(index))
 loading.queue_free();host.transition_label.free();host.queue_free()
 for i in 4:await process_frame
 HoldStoryArt105.portraits.clear();HoldPaintedPortraits.sources.clear()
 print("STORYART105: ",passed," passed / ",failed," failed")
 quit(1 if failed else 0)
