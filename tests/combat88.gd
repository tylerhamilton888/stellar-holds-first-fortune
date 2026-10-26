extends "res://tests/support/game_fixture.gd"
class PoseBoard extends Node2D:
 var profile={}
 var mode="shield"
 var clock=0.0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("203139"))
  draw_string(ThemeDB.fallback_font,Vector2(20,24),HoldWholeFrames.identity(profile)+" · "+mode+" · complete native frames",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("ead4aa"))
  var labels=["Town","Step 1","Step 2","Step 3","Step 4","Windup","Contact","Recover","Guard","Recoil"] if mode=="shield" else ["Town","Hammer held","Ready","Windup","Contact","Recover","Gun S","Gun E","Gun NE","Gun N"]
  for col in 10:draw_string(ThemeDB.fallback_font,Vector2(10+col*95,48),labels[col],HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("bed0cb"))
  var directions=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1).normalized(),Vector2.UP]
  for row in 4:
   for col in 10:
    var at=Vector2(45+col*95,145+row*122);var d:Vector2=directions[row]
    var action="";var phase=0.0;var walking=false;var time=0.0
    if mode=="shield":
     if col in range(1,5):action="hold_combat_axe";walking=true;time=(col-1)*HoldWholeFrames.CYCLE/4+.001
     elif col in range(5,8):action="combat_axe";phase=[.30,.56,.85][col-5]
     elif col==8:action="guard_axe"
     elif col==9:action="parry_axe"
    else:
     if col==1:action="hold_hammer"
     elif col in range(2,6):action="hammer";phase=[0,.30,.56,.85][col-2]
     elif col>=6:action="hold_rifle";d=directions[col-6];walking=true;time=row*HoldWholeFrames.CYCLE/4+.001
    draw_line(at+Vector2(-35,1),at+Vector2(35,1),Color("446068"))
    HoldDrawnAnimation.paint(self,at,profile,d,walking,time,1.0,Vector2.ZERO,action,phase)
class PropBoard extends Node2D:
 var profile={}
 var clock=0.0
 func _draw():
  draw_rect(Rect2(0,0,960,540),Color("233832"))
  draw_string(ThemeDB.fallback_font,Vector2(24,35),"Separate shared props · actual gameplay scale",HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("ead4aa"))
  var index=0
  for kind in HoldLooseProps.CROPS:
   var p=Vector2(170+index%3*280,230+int(index/3)*230)
   HoldDrawnAnimation.paint(self,p-Vector2(65,0),profile,Vector2.DOWN,false,0,.85,Vector2.ZERO)
   HoldFurnishings.draw(self,p,kind)
   draw_rect(HoldFurnishings.footprint(kind,p),Color("87baa7"),false,1)
   draw_string(ThemeDB.fallback_font,p+Vector2(-85,30),HoldFurnishings.ITEMS[kind].title,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("ead4aa"))
   index+=1
func board_snap(board:Node2D,name:String):
 board.queue_redraw()
 for i in 3:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+name+".png")
func contains_piece(object:Dictionary)->bool:
 return g.state.surface.decor.any(func(d):return d.area==object.area and d.kind==object.kind and is_equal_approx(float(d.x),float(object.x)) and is_equal_approx(float(d.y),float(object.y)) and int(d.get("z",0))==int(object.get("z",0)))
func run():
 output=OS.get_cmdline_user_args()[0];DirAccess.make_dir_recursive_absolute(output)
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.hide();var layer=CanvasLayer.new();layer.layer=100;root.add_child(layer)
 var board=PoseBoard.new();layer.add_child(board)
 var views=[Vector2.DOWN,Vector2.RIGHT,Vector2(1,-1).normalized(),Vector2.UP]
 # These original heads extended past old atlas-column crops. Preserve the
 # entire tool silhouette, including its far side, through ready and contact.
 for id in ["male2","male3","female3","female6"]:
  for index in [28,30]:
   var m=HoldWholeFrames.metadata[id+"-core"][index]
   check(float(m.rect[0])+float(m.rect[2])>(224 if index==28 else 667),id+" hammer "+str(index)+" retains the original head beyond the old cropped column")
 for gender in 2:
  for sculpt in 7:
   var p=HoldAppearance.normalized(g.state.appearance.duplicate(true));p.gender=gender;p.sculpt=sculpt
   var id=HoldWholeFrames.identity(p);var sheet=id+"-shield88";var saved=p.duplicate(true)
   check(HoldWholeFrames.metadata.has(sheet) and HoldWholeFrames.metadata[sheet].size()==40,id+" has its own whole combat drawings")
   var correct=true;var sizes=[]
   for d in views:
    for action in ["hold_combat_axe","combat_axe","guard_axe","parry_axe"]:
     for phase in [0.0,.30,.56,.85]:
      var a=HoldWholeFrames.descriptor(p,d,true,phase*HoldWholeFrames.CYCLE,action,phase)
      var m=HoldWholeFrames.metadata[a.sheet][a.index]
      correct=correct and a.sheet==sheet and m.identity==id and m.equipment=="axe_shield" and ResourceLoader.exists(m.source)
      sizes.append(a.scale)
   check(correct,id+" keeps its identity and axe/shield through every facing, step and combat state")
   check(sizes.min()==sizes.max(),id+" does not shrink when the axe rises above its head")
   check(p==saved,id+" rendering preserves the saved appearance and palette")
   board.profile=p;board.mode="shield";await board_snap(board,id+"-shield")
   board.mode="weapons";await board_snap(board,id+"-weapons")
 board.queue_free();await process_frame
 var props=PropBoard.new();props.profile=g.state.appearance;layer.add_child(props);await board_snap(props,"separate-props");layer.queue_free();await process_frame;g.show()
 g.state.opening=4;g.state.claim_id="old_delving";g.state.camp_stage=3;HoldOnboarding.ensure(g.state).fresh=false;HoldOnboarding.ensure(g.state).combat=true
 for item in HoldData.ITEMS:g.state.inventory[item]=10000
 g.surface.enter("room:training");settle();g.combat.armed=true;g.state.combat.weapon="axe"
 var f=g.fight;f.spawn();f.aim=Vector2.RIGHT;f.guard=true;f.parry=.1
 var enemy=f.enemies[0];g.player=enemy.p-Vector2(65,0);var hp=g.state.combat.health
 f.receive(enemy)
 check(f.player_pose()=="parry_axe" and f.shield_recoil>0 and g.state.combat.health==hp,"A live timed block triggers the whole shield recoil pose without damage")
 await snap("practice-recoil")
 f.hit_stop=0;f.shield_recoil=0;f.guard=true;check(f.player_pose()=="guard_axe","Held guard raises the attached shield")
 await snap("practice-guard")
 f.guard=false;f.strike();check(f.player_pose()=="combat_axe","A real strike selects the same equipped character")
 f.swing=g.combat.weapon().time*(1-.56);await snap("practice-contact")
 f.cancel_actions();check(f.player_pose()=="hold_combat_axe" and f.shield_recoil==0,"Cancel clears transient shield recoil and returns to equipped idle")
 g.state.combat.weapon="hammer";check(f.player_pose()=="hold_hammer","Hammer does not acquire a shield")
 g.state.combat.weapon="gun";check(f.player_pose()=="hold_rifle","Carbine remains the held weapon between shots")
 g.combat.armed=false;g.surface.enter("claim",Vector2(2200,1660));settle()
 var kept=[];var serial=0
 for kind in HoldLooseProps.CROPS:
  check(HoldFurnishings.BUILDABLE.has(kind),kind+" is individually available to the player")
  var p=Vector2(2180+serial*100,1600);at(p+Vector2(0,60));var before=g.state.inventory.duplicate(true)
  g.surface.start_placement(kind);check(g.surface.place(p),"Place independent "+kind)
  var object=g.state.surface.decor.back();kept.append(object.duplicate(true));var paid=true
  for item in HoldFurnishings.ITEMS[kind].cost:paid=paid and g.state.count(item)==int(before[item])-int(HoldFurnishings.ITEMS[kind].cost[item])
  check(paid,"Charge only the selected "+kind)
  check(not g.surface.walkable(HoldFurnishings.footprint(kind,Vector2(object.x,object.y)).get_center()),kind+" blocks only its own physical base")
  serial+=1
 await snap("placed-pieces")
 g.save_game();g.start_game(true);settle()
 for object in kept:check(contains_piece(object),object.kind+" survives real save reload independently")
 var first=kept[0];at(Vector2(first.x,first.y+60));var inventory=g.state.inventory.duplicate(true)
 check(g.surface.move_nearby_furnishing() and g.surface.place(Vector2(first.x,first.y+110)),"Move just the rune-stone")
 check(g.state.inventory==inventory,"Moving decor does not charge again")
 for object in kept.slice(1):check(contains_piece(object),"Moving the pillar leaves "+object.kind+" untouched")
 at(Vector2(first.x,first.y+165));check(g.surface.recover_decor(),"Recover just the moved rune-stone")
 for object in kept.slice(1):check(contains_piece(object),"Recovering the pillar leaves "+object.kind+" untouched")
 g.surface.architecture.details_group="Roadside";g.open_panel("architecture_details");await snap("roadside-catalogue")
 check(g.panel_body.size.x<=g.menu_scroll.size.x+1 and g.panel.get_global_rect().end.y<=540,"Five furniture categories and Roadside cards fit the viewport")
 check(g.panel.find_children("*","Button",true,false).filter(func(b):return b.text=="Place").size()==6,"Roadside catalogue offers six separate placement actions")
 g.close_panel();g.surface.enter("trail",Vector2(510,655));settle();await snap("wayfarer-separated")
 var road=g.surface.roads
 for link in road.links("trail"):
  if link.target=="mine" or link.target.begins_with("room:"):continue
  check(g.surface.walkable(link.p-link.normal*25),link.title+" sign leaves the path approach clear")
  var p:Vector2=link.p+Vector2(-link.normal.y,link.normal.x)*62
  check(road.furnishings("trail").any(func(item):return item.furnishing=="signpost" and item.p==p),link.title+" uses an independent depth-sorted sign")
 print("COMBAT88: ",passed," passed / ",failed," failed")
 g.sound.stop_all();g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
