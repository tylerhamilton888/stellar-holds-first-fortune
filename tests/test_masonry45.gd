extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred("run")
func check(ok:bool,label:String):
 if ok:passed+=1;print("PASS ",label)
 else:failed+=1;push_error(label)
func settle():g.transition_left=0;g.transition_shade.visible=false;g.close_panel()
func total(item:String)->int:
 var n=g.state.count(item)+g.deep.haul.in_field(item)
 for job in g.deep.works.masonry.data.jobs.values():n+=int(job.cargo.get(item,0))
 return n
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.claim_id="old_delving";g.state.camp_stage=3;g.state.opening=4;g.state.worker=true;g.state.add("food",100)
 g.travel_claim();settle();g.change_zone("mine");settle()
 var w=g.deep.world;var m=g.deep.works.model;var q=g.deep.works.masonry;var h=g.deep.haul
 for item in ["stone","wood","iron","coal"]:g.state.add(item,50)
 for y in range(6,13):
  for x in range(7,21):w.set_cell(Vector2i(x,y),0)
 m.designate(Vector2i(14,6),Vector2i(19,11),"workshop")
 m.place(Vector2i(15,7),"bench");m.place(Vector2i(17,7),"anvil");m.place(Vector2i(14,6),"lamp");m.place(Vector2i(17,9),"mason")
 var bc=Vector2i(17,9);var c=Vector2i(20,9);w.set_cell(c,2);g.player=Deepworks.center(Vector2i(19,9))
 var initial=g.state.count("stone");q.quarry(c);q.quarry(c)
 check(w.at(c)==2 and total("rough_block")==0,"Chisel contacts persist until a whole block is freed")
 g.save_game();g.start_game(true);settle();w=g.deep.world;m=g.deep.works.model;q=g.deep.works.masonry;h=g.deep.haul
 q.quarry(c);check(w.at(c)==0 and total("rough_block")==1 and g.state.count("stone")==initial,"Quarry creates exactly one cargo block, no duplicate ordinary stone")
 q.quarry(c);check(total("rough_block")==1,"Empty terrain cannot be quarried repeatedly")
 w.set_cell(c,3);q.quarry(c);check(w.at(c)==3 and total("rough_block")==1,"Ore cannot be converted into free masonry blocks")
 w.set_cell(c,7);q.quarry(c);check(w.at(c)==7,"Unforged steel gate protects basalt quarrying")
 check(not q.claim(),"Lesson cannot reward before real work")
 var remote=h.pile(Vector2i(25,10),true);remote.cargo={"rough_block":1}
 q.dress(bc);check(total("dressed_stone")==0,"Remote stockpiles cannot feed a bench through unrelated terrain")
 remote.cargo.clear()
 g.deep.works.choose("dress","dressed_stone");g.deep.strike_left=.12;g.deep.works.pending={};g.deep.works.cancel()
 check(g.deep.strike_left==0,"Changing work modes clears the recovery swing before the next job")
 g.player=Deepworks.center(Vector2i(18,10));q.cache();var pile=h.pile(Vector2i(18,10))
 check(int(pile.cargo.get("rough_block",0))==1 and int(h.bucket().get("rough_block",0))==0 and q.has("stockpile"),"Caching transfers existing blocks into marked stockpile once")
 q.cache();check(total("rough_block")==1,"Repeated cache cannot duplicate stone")
 q.dress(bc);q.dress(bc);check(total("rough_block")==1 and total("dressed_stone")==0,"Partial dressing consumes no premature materials")
 q.dress(bc);check(total("rough_block")==0 and int(pile.cargo.get("dressed_stone",0))==2,"Three bench contacts convert one local block to two dressed stone")
 q.dress(bc);check(total("dressed_stone")==2,"Empty supply prevents phantom crafting")
 var score=m.data.rooms["1"].metrics.score
 m.finish(Vector2i(16,10),"ashlar");check(m.data.surfaces.is_empty(),"Field output must be delivered before construction")
 h.load_pile(g.player);g.player=Deepworks.center(Deepworks.ENTRY);h.unload(g.player)
 m.finish(Vector2i(16,10),"ashlar");q.observe()
 check(g.state.count("dressed_stone")==1 and m.data.rooms["1"].metrics.score>score and q.has("build"),"Delivered dressed floor raises actual room craftsmanship")
 var parts=g.state.count("parts");check(q.claim() and g.state.tech.has("masonry_apprentice") and g.state.count("parts")==parts+1,"Useful completed project earns delegation and one part")
 check(not q.claim() and g.state.count("parts")==parts+1,"Lesson reward is once-only")
 g.state.tech.fine_masonry=true;pile.cargo.rough_block=1
 for i in 3:q.dress(bc)
 check(pile.cargo.dressed_stone==3,"Relevant masonry knowledge improves useful output")
 pile.cargo={"rough_block":1}
 for i in 3:q.dress(bc,true)
 check(int(pile.cargo.get("stone",0))==4 and not pile.cargo.has("rough_block"),"Optional reduction produces four ordinary stone")
 pile.cargo={"rough_block":2};var result=q.assign("brann",q.bench(bc));print(result)
 check(q.data.jobs.has("brann"),"Existing recruited miner can take over familiar work")
 for i in 500:
  g.deep.agents(.1)
  if q.data.jobs.brann.phase=="dress":break
 check(q.data.jobs.brann.cargo.get("rough_block",0)==1 and total("rough_block")==2,"Mason physically fetches block without duplication")
 var saved=q.data.duplicate(true);g.save_game();g.start_game(true);settle();w=g.deep.world;m=g.deep.works.model;q=g.deep.works.masonry;h=g.deep.haul
 check(JSON.parse_string(JSON.stringify(q.data))==JSON.parse_string(JSON.stringify(saved)),"Save/reload preserves in-flight worker cargo and quest")
 for i in 500:
  g.deep.agents(.1)
  if q.has("delegate"):break
 check(q.has("delegate") and total("dressed_stone")==4,"Mason dresses and physically returns finished stone to stockpile")
 for i in 500:
  g.deep.agents(.1)
  if q.data.jobs.brann.phase=="dress":break
 var raw=total("rough_block");q.release("brann")
 check(total("rough_block")==raw and not q.data.jobs.has("brann"),"Releasing mason returns carried input safely")
 var old=g.state.deepworks[g.state.active_site].living.duplicate(true);old.erase("masonry");g.state.deepworks[g.state.active_site].living=old
 var inventory=g.state.inventory.duplicate();g.deep.works=LivingPlay.new(g,w)
 check(g.deep.works.masonry.data.jobs.is_empty() and g.state.inventory==inventory and not g.deep.works.model.data.rooms.is_empty(),"Older Living Works save gains additive masonry defaults without resetting rooms or inventory")
 print("MASONRY45: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.queue_free();await process_frame;quit(1 if failed else 0)
