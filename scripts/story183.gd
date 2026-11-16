class_name HoldStory183
extends RefCounted
# Optional personal work; it never gates tools, commissions or the campaign.
const COST={"shaped_haft":1,"iron":1}
static func data(s)->Dictionary:
 if not s.surface.has("story183"):s.surface.story183={"borin":0,"arrivals":false}
 return s.surface.story183
static func stage(s)->int:return int(s.surface.get("story183",{}).get("borin",0))
static func pay(s)->int:return int(HoldData.ITEMS.shaped_haft.price)+int(HoldData.ITEMS.iron.price)
static func local(g)->bool:return HoldForge147.talking(g) and HoldLedger137.complete(g.state,"forge")
static func accept(g)->bool:
 if not local(g) or stage(g.state)!=0 or is_instance_valid(g.opening_scene):return false
 data(g.state).borin=1;g.save_game();HoldQuestScene181.play(g,"practice_offer");return true
static func deliver(g)->bool:
 if not local(g) or stage(g.state)!=1 or is_instance_valid(g.opening_scene):return false
 if not g.state.pay(COST):return false
 data(g.state).borin=2;g.state.money+=pay(g.state);g.save_game()
 HoldQuestScene181.play(g,"practice_done");return true
static func options(g,id:String):
 if not HoldFrontier103.active(g.state):return
 if id=="borin" and local(g):
  HoldConversation.choose(g,"About the apprentice's practice pick…" if stage(g.state)>0 else "That split handle—can I help?",func():g.talk_topic="practice183";g.refresh_panel(),true)
 var intro={"road_folk:10":"alden183","road_folk:11":"maren183"}.get(id,"")
 if intro!="" and not HoldRidgePair124.paired(g.state) and not g.state.surface.get("quest_scene181",{}).get("seen",{}).get(intro,false) and int(HoldPeople.records(g.state).get(id,{}).get("bond",0))==0:
  HoldConversation.choose(g,"We haven't properly introduced ourselves.",func():HoldQuestScene181.play(g,intro))
static func panel(g):
 var q=stage(g.state)
 HoldConversation.header(g,g.panel_body,"borin","'A training pick is still a pick. This haft has split beneath the collar. It will not go back into anyone’s hands until the fit is sound.'" if q==0 else "'A shaped haft and an iron ingot. Straight grain, no checks. I will inspect the fit and forge the collar. A maker’s name is a promise, whoever paid for the work.'" if q==1 else "'The head sits square. The collar holds. The balance is right. That will serve.'")
 if q<2:
  g.label(g.panel_body,"Optional · 1 shaped haft + 1 iron ingot · reimbursement: %d crowns. Your usual forge work can continue." % pay(g.state),15)
  g.label(g.panel_body,"Shape a haft from 2 timber; smelt an iron ingot at the lit forge. Both can also be bought at the watch stores.",15)
  if q==0:HoldConversation.choose(g,"I'll bring the haft and iron",func():accept(g),true)
  else:
   g.label(g.panel_body,"In your pack: %d shaped haft · %d iron" % [g.state.count("shaped_haft"),g.state.count("iron")],15)
   var b=HoldConversation.choose(g,"Deliver the haft and iron · %d crowns" % pay(g.state),func():deliver(g),true);b.disabled=not g.state.afford(COST)
 HoldConversation.return_choice(g,"borin")
static func journal(g):
 if stage(g.state)!=1:return
 g.label(g.panel_body,"Fit for the work · Borin's training pick",19)
 g.label(g.panel_body,"Optional: bring 1 shaped haft and 1 iron ingot to Borin at the communal forge. Make or buy them; reimbursement is %d crowns." % pay(g.state),15)
static func arrive(g):
 if g.skip_arrival or g.capture_mode!="" or not g.state.surface.get("story183",{}).get("arrivals",false):return
 if is_instance_valid(g.opening_scene):return
 var id="workings183" if g.zone=="mine" and g.state.active_site=="hold" and g.deep.world.depth()==0 else "pinewood183" if g.surface.area=="pinewood" and g.zone!="mine" else ""
 if id!="":HoldQuestScene181.play(g,id)
