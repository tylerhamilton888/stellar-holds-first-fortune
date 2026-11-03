class_name HoldWorkView132
extends RefCounted
const W=preload("res://scripts/work132.gd")
static func open(g,mode:String="lessons"):
 g.set_meta("work132_mode",mode);g.open_panel("work132")
static func meter(g,parent,label:String,value:int,maximum:int):
 g.label(parent,label+" · %d / %d" % [value,maximum],16)
 var bar=ProgressBar.new();bar.max_value=maximum;bar.value=mini(value,maximum);bar.show_percentage=false;bar.custom_minimum_size=Vector2(0,12);parent.add_child(bar)
static func summary(g):
 var s=g.state
 if not W.active(s):return
 if not HoldFirstVisit99.data(s).get("rewarded",false):
  var q=HoldFirstVisit99.data(s);var box=HoldMenuView.section(g.panel_body,"Your next step")
  if not q.get("ivar_spoken",false):g.label(box,"Speak with Ivar by the bunkhouse hearth. E talks; the stairs lead to your private room.",17)
  elif not q.get("room_seen",false):g.label(box,"Take the bunkhouse stairs to your room. Your bed, chest and desk are upstairs.",17)
  elif not q.get("work_started",false):g.label(box,"Leave into Stonebridge and follow the northern path to Old Workings. The western rack and stonebreaker are on loan.",17)
  else:
   var n=HoldFirstVisit99.step(s)
   if n<HoldFirstVisit99.TASKS.size():g.label(box,HoldFirstVisit99.TASKS[n][0]+" · "+HoldFirstVisit99.TASKS[n][1],17)
  g.label(box,"Your first completed load earns 20 crowns and furnishing materials. Then choose a trade to learn.",15)
 else:
  var plot_ready=W.contributions(s)>=2 and not HoldFrontier103.data(s).permit
  if plot_ready:
   var card=HoldMenuView.section(g.panel_body,"Your next milestone · household plot earned")
   g.label(card,"Two contributions are recorded. Visit Ivar's shift book in the bunkhouse to accept your plot, then follow the eastern road and design your home.",17)
  var id="" if plot_ready else W.tracked(s)
  if id!="":
   var card=HoldMenuView.section(g.panel_body,"Your next step · "+W.LESSONS[id].title)
   g.label(card,W.LESSONS[id].hint,16)
   for p in W.progress(s,id):g.label(card,("✓ " if p[1]>=p[2] else "○ ")+p[0]+" · %d / %d" % [mini(p[1],p[2]),p[2]],15)
   if W.ready(s,id):g.label(card,"Ready to report at the Stonebridge "+W.LESSONS[id].host+" desk.",16,Color("a7dfcb"))
 if not W.closed(s):
  meter(g,g.panel_body,"Contribution marks · rescue milestone",int(HoldGreatClaim102.data(s).points),W.TARGET)
  g.label(g.panel_body,"Home: "+("registered" if HoldFrontier103.data(s).home_reward else "plot ready to build" if HoldFrontier103.data(s).permit else "%d / 2 contributions toward a plot" % mini(2,W.contributions(s)))+" · A registered home and 180 marks unlock Ivar's rescue lead.",15)
 var nav=g.row(g.panel_body)
 g.small_button(nav,"Learn a trade · step by step",func():open(g))
 g.small_button(nav,"Contribute · choose your route",func():open(g,"contribute"))
static func panel(g):
 var s=g.state
 if not W.active(s):g.label(g.panel_body,"These work orders belong to Stonebridge.",17);return
 var mode=str(g.get_meta("work132_mode","lessons"));var nav=g.row(g.panel_body)
 for spec in [["lessons","Learn a trade"],["contribute","Contest contributions"]]:
  var target=str(spec[0]);var b=g.small_button(nav,spec[1],func():g.set_meta("work132_mode",target);g.refresh_panel());b.disabled=mode==target
 if mode=="contribute":contributions(g);return
 g.label(g.panel_body,"USEFUL HANDS · CHOOSE WHAT TO LEARN",21,Color("edc98a"))
 g.label(g.panel_body,"Choose any path. Completed work counts before you select it; you can switch without losing progress. Lessons reward supplies and wages. Contest deliveries are on the next page.",15)
 if not HoldFirstVisit99.data(s).get("rewarded",false):g.label(g.panel_body,"Finish the introductory stone load first. J keeps its steps at the top.",16);return
 var chain=str(g.get_meta("work132_chain","forge"));var row=g.row(g.panel_body)
 for key in W.CHAINS:
  var target=str(key);var b=g.small_button(row,W.CHAINS[key],func():g.set_meta("work132_chain",target);g.refresh_panel());b.disabled=chain==target
 var d=W.data(s);var next="";var completed=0;var total=0
 for id in W.LESSONS:
  if W.LESSONS[id].chain!=chain:continue
  total+=1
  if d.done.has(id):completed+=1
  elif next=="":next=id
 meter(g,g.panel_body,W.CHAINS[chain],completed,total)
 if next=="":g.label(g.panel_body,"Every lesson in this path is complete. Keep practicing it, contribute supplies, or choose another path.",17);return
 var task=W.LESSONS[next];var card=HoldMenuView.section(g.panel_body,task.title)
 g.label(card,task.hint,16)
 for p in W.progress(s,next):g.label(card,("✓ " if p[1]>=p[2] else "○ ")+p[0]+" · %d / %d" % [mini(p[1],p[2]),p[2]],16)
 g.label(card,"Reward: "+HoldData.cost_text(task.reward)+" · %d crowns" % task.crowns,15,Color("a7dfcb"))
 var actions=g.row(card)
 var follow=g.small_button(actions,"Tracking this lesson" if d.track==next else "Track in journal & HUD",func():d.track=next;HoldFirstVisit99.data(s).guided=true;g.save_game();g.refresh_panel());follow.disabled=d.track==next
 g.small_button(actions,"Stop tracking",func():d.track="";g.save_game();g.refresh_panel())
 var b=g.button(card,"Report to "+{"forge":"Borin · communal forge","survey":"Edda · survey desk","lodge":"Ivar · shift book"}[task.host],func():W.claim_lesson(g,next);g.refresh_panel())
 b.disabled=not W.ready(s,next) or not HoldFrontier103.near(g,task.host)
 g.label(card,"Report at the desk in Stonebridge once all steps are complete. Supplies stay yours; reporting a lesson does not consume them.",14)
 if chain=="food":g.button(card,"Open field kit & growing guide",func():g.open_panel("fieldwork"))
 var later=[]
 for id in W.LESSONS:
  if W.LESSONS[id].chain==chain and id!=next and not d.done.has(id):later.append(W.LESSONS[id].title)
 if not later.is_empty():g.label(g.panel_body,"Then: "+" → ".join(later),14)
static func contributions(g):
 var s=g.state;var d=W.data(s)
 if W.closed(s):
  g.label(g.panel_body,"The contest round is closed. Your authenticated tally is preserved. Lessons, home building and town improvements remain available.",17)
 else:
  meter(g,g.panel_body,"Contribution marks",int(HoldGreatClaim102.data(s).points),W.TARGET)
 g.label(g.panel_body,"Trade seals: %d / 3 · 40 marks each · Mix trades or specialize in one." % W.seals(s),16,Color("a7dfcb"))
 var nav=g.row(g.panel_body)
 g.small_button(nav,"Civic projects · improve the town",func():g.open_panel("great_claim102"))
 g.small_button(nav,"Plot, home & storehouse",func():g.open_panel("frontier103"))
 if not d.seals.is_empty():
  var entries=[]
  for record in d.seals:entries.append(W.TRADES[record.trade].kind+" · "+str(record.amount)+" "+HoldData.ITEMS[record.item].name)
  g.label(g.panel_body,"Recorded: "+"; ".join(entries),14,Color("a7dfcb"))
 if W.closed(s) or W.seals(s)>=W.SEAL_LIMIT:return
 var trade=str(g.get_meta("work132_trade","quarry"));var row=g.row(g.panel_body)
 for id in W.TRADES:
  var target=str(id);var b=g.small_button(row,{"quarry":"Mining","timber":"Timber","metal":"Metalwork","table":"Food"}[id],func():g.set_meta("work132_trade",target);g.refresh_panel());b.disabled=trade==id
 var spec=W.TRADES[trade];var card=HoldMenuView.section(g.panel_body,spec.title+" · 40 marks")
 g.label(card,spec.hint,15)
 g.label(card,"Choose ONE option for this seal. Deliver at the Great Claim ledger beside Ivar in the lodge.",15)
 for item in spec.items:
  var key=str(item);var amount=int(spec.items[item]);var credit=W.available(s,item)
  var b=g.button(card,"Deliver %d %s · made/gathered %d/%d · pack %d/%d" % [amount,HoldData.ITEMS[item].name,mini(credit,amount),amount,mini(s.count(item),amount),amount],func():W.deliver(g,trade,key);g.refresh_panel())
  b.disabled=not HoldGreatClaim102.near(g) or not W.can_deliver(s,trade,item)
 g.label(g.panel_body,"Deliver supplies you produced. Three seals are shared across all trades; each spends its supplies and work credit once. Buying finished goods alone earns no seal. No deadlines.",15)
 g.label(g.panel_body,"Your milestones: paid first shift + any two projects or seals → household plot. Register your home → 60 marks. Home + 180 marks → rescue lead. Three seals + home reach 180; civic projects also count toward the goal.",15)
