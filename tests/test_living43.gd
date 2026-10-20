extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
func same(a,b)->bool:return JSON.stringify(JSON.parse_string(JSON.stringify(a)))==JSON.stringify(JSON.parse_string(JSON.stringify(b)))
func dig_to(dest:Vector2i):
 var w=g.deep.world;var c=Deepworks.cell(g.player)
 while c!=dest:
  c+=Vector2i(signi(dest.x-c.x),0) if c.x!=dest.x else Vector2i(0,signi(dest.y-c.y))
  for i in 5:
   if w.at(c)==0:break
   g.deep.contact=Deepworks.center(c);g.deep.hit(c)
  g.player=Deepworks.center(c);w.survey(g.player)
func dig_room(a:Vector2i,b:Vector2i):
 for y in range(a.y,b.y+1):
  for x in range(a.x,b.x+1):dig_to(Vector2i(x,y))
func run():
 g=load("res://scripts/main.gd").new();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.opening=4;g.state.worker=true;g.state.add("food",100)
 g.travel_claim();settle();g.change_zone("mine");settle()
 var w=g.deep.world;var h=g.deep.haul;var m=g.deep.works.model
 check(g.zone=="mine" and g.agents.size()>0,"Existing claimed-mountain entry includes existing hired Brann")
 var terrain=w.layer().cells.duplicate();var old_inventory=g.state.inventory.duplicate()
 m.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 check(m.data.rooms.is_empty() and same(terrain,w.layer().cells),"Room designation rejects unexcavated area without altering terrain")
 var mined=g.state.mined;dig_room(Vector2i(14,6),Vector2i(19,11))
 check(g.state.mined>mined and DeepHaul.amount(h.bucket())>0,"Excavating actual chamber produces physical cargo")
 dig_to(Vector2i(8,12));dig_to(Vector2i(7,12));dig_to(Deepworks.ENTRY);g.deep.unload()
 check(g.state.count("stone")>int(old_inventory.get("stone",0)),"Chamber excavation delivers usable construction stone")
 # Construction budget fixture isolates room costs from early campaign prerequisites.
 for item in {"stone":160,"wood":80,"iron":20,"copper":15,"coal":10}:g.state.add(item,{"stone":160,"wood":80,"iron":20,"copper":15,"coal":10}[item])
 g.state.money=400
 m.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 check(m.data.rooms.size()==1,"Excavated physical rectangle becomes persistent workshop")
 var room=m.data.rooms["1"];check(not room.metrics.active,"Empty designation has no functional bonus")
 m.designate(Vector2i(16,7),Vector2i(20,12),"bedroom");check(m.data.rooms.size()==1,"Overlapping room designation is rejected")
 var cost=g.state.inventory.duplicate();m.place(Vector2i(14,7),"bench")
 check(g.state.inventory==cost,"Solid furniture cannot block the outer access aisle or consume cost on rejection")
 m.place(Vector2i(15,7),"bench");check(not w.walkable(Vector2i(15,7)) and g.state.count("wood")==int(cost.wood)-4,"Bench placement pays existing inventory and creates collision")
 var after=g.state.inventory.duplicate();m.place(Vector2i(15,7),"bench")
 check(g.state.inventory==after,"Duplicate placement cannot charge twice or replace furnishings")
 m.place(Vector2i(17,7),"anvil");m.place(Vector2i(14,6),"lamp")
 check(room.metrics.active and room.metrics.score>=40,"Accessible bench, hearth and lantern activate a functional workshop")
 check(LivingWorks.production(g.state)==1,"Unstaffed rooms do not produce a remote bonus")
 var raw_score=room.metrics.score;m.place(Vector2i(15,9),"bench")
 check(room.metrics.score==raw_score,"Repeated bench adds no room-quality score")
 var paid=g.state.count("wood");m.remove(Vector2i(15,9));check(w.walkable(Vector2i(15,9)) and g.state.count("wood")==paid+4,"Dismantling restores floor access and exact stored materials")
 paid=g.state.count("wood");m.remove(Vector2i(15,9));check(g.state.count("wood")==paid,"Repeated dismantling cannot duplicate a refund")
 var stone=g.state.count("stone");m.finish(Vector2i(14,6),"flags")
 check(g.state.count("stone")==stone and m.data.surfaces.is_empty(),"Unresearched architectural capability stays locked")
 check(g.state.research("stoneworking"),"Stoneworking uses existing research spending and prerequisites")
 for y in range(6,12):
  for x in range(14,20):m.finish(Vector2i(x,y),"flags")
 check(room.metrics.craft>=3 and room.metrics.score>raw_score,"Finished flooring visibly and mechanically raises craftsmanship")
 stone=g.state.count("stone");m.finish(Vector2i(14,6),"flags");check(g.state.count("stone")==stone,"Applying identical finish is idempotent")
 check(g.state.research("fine_masonry") and g.state.research("furnishings"),"Existing tech tree unlocks runic masonry and comfort furniture")
 m.place(Vector2i(17,9),"rune");m.finish(Vector2i(20,8),"masonry")
 m.assign("brann","1")
 for i in 550:g.state.elapsed+=.1;g.deep.agents(.1)
 check(m.data.assignments.brann.present=="1","Existing Brann physically routes into the actual workshop")
 check(m.data.folk.brann.morale>0 and m.data.folk.brann.activity=="Shaping tools","NPC records a positive environmental response and work activity")
 check(LivingWorks.production(g.state)>1 and LivingWorks.production(g.state)<=1.1,"Staffed quality grants a conservatively capped production benefit")
 g.state.craft("iron");var left=g.state.queue[0].left;g.state.tick(1)
 check(left-g.state.queue[0].left>1,"Room quality improves the existing crafting queue, not a parallel economy")
 check(m.data.opportunity=="offered" and m.opportunity_ready(),"Brann's real improved workplace triggers optional craftsmanship opportunity")
 var parts=g.state.count("parts")
 check(m.complete_opportunity() and g.state.tech.has("ancestor_marks") and g.state.count("parts")==parts+2,"Completing opportunity unlocks an original finish and tangible crafted reward")
 check(not m.complete_opportunity() and g.state.count("parts")==parts+2,"Optional opportunity cannot reward twice")
 m.finish(Vector2i(20,8),"ancestor");check(m.data.surfaces[m.id_at(Vector2i(20,8))].kind=="ancestor","Earned Rivethand finish applies to actual chamber wall")
 dig_room(Vector2i(14,15),Vector2i(17,18));m.designate(Vector2i(14,15),Vector2i(17,18),"bedroom")
 m.place(Vector2i(15,16),"bed");m.place(Vector2i(14,15),"lamp");m.place(Vector2i(16,16),"chair");m.assign("brann","2")
 g.state.elapsed=92
 for i in 180:g.state.elapsed+=.1;g.deep.agents(.1)
 check(m.data.assignments.brann.present=="2" and m.data.folk.brann.rested_until>g.state.elapsed,"Assigned Dwarf walks to a real berth and gains lasting rest benefit")
 check(LivingWorks.production(g.state)==1,"Workshop staffing bonus stops while its only worker is away")
 var living=m.data.duplicate(true);var cells=w.layer().cells.duplicate();g.save_game();g.start_game(true);settle();w=g.deep.world;m=g.deep.works.model
 check(same(m.data,living) and same(w.layer().cells,cells),"Actual save/load retains rooms, surfaces, furniture, NPC preferences/opportunity and terrain")
 # Additive compatibility: remove only the newly introduced room field from a real saved world.
 var old_save=JSON.parse_string(FileAccess.get_file_as_string(g.state.save_path()))
 for site in old_save.deepworks:old_save.deepworks[site].erase("living")
 var prior_inventory=g.state.inventory.duplicate();var prior_cells=w.layer().cells.duplicate()
 var file=FileAccess.open(g.state.save_path(),FileAccess.WRITE);file.store_string(JSON.stringify(old_save));file.close()
 g.start_game(true);settle();w=g.deep.world;m=g.deep.works.model
 check(m.data.rooms.is_empty() and same(w.layer().cells,prior_cells),"A 0.42-shaped save gains empty rooms without replacing excavated terrain")
 check(g.state.inventory==prior_inventory,"Additive Living Works initialization preserves previous stored supplies")
 g.deep.works.pending={"mode":"finish"};g.deep.strike_left=.2;g.deep.works.cancel()
 check(g.deep.strike_left==0,"Cancelling pending construction cancels impact rather than mining its target")
 # Physical excavation methods operate through the same yield and cargo boundary.
 var c=Vector2i(12,20);w.set_cell(c,3);w.layer().damage.erase(Deepworks.key(c));var yield_count=w.yield_count(c)
 w.strike(c,-1,false,false,"pick");var result=w.strike(c,-1,false,false,"hammer")
 check(result.get("broken",false) and result.count==yield_count,"Hammer exploits a pick-fractured ore face without fabricating extra yield")
 w.set_cell(c,4);w.layer().damage.erase(Deepworks.key(c));yield_count=w.yield_count(c)
 w.strike(c,-1,false,false,"careful");result=w.strike(c,-1,false,false,"careful")
 check(result.get("broken",false) and result.count==yield_count+1,"Selective extraction yields an extra unit through the existing ore ID")
 # Furniture below may never become an occupied stair landing.
 var landing=Vector2i(15,7);w.data.depth=1;w.set_cell(landing,0);m.data.furniture[w.link_key(landing,1)]={"kind":"bed","x":landing.x,"y":landing.y,"depth":1,"solid":true,"room":"fixture","paid":{}}
 w.data.depth=0;w.set_cell(landing,0);m.data.furniture.erase(w.link_key(landing,0));var msg=w.carve_stairs(landing)
 check(not w.can_descend(landing,0) and "Furniture" in msg,"Stair carving cannot strand a player inside lower-level furniture")
 print("LIVING43: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
