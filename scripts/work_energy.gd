class_name HoldWorkEnergy
extends RefCounted
# Additive per-fortune state; no combat stamina and no offline clock.
const MEALS={"food":30.0,"barley_bread":40.0,"root_hotpot":45.0,"fish_chowder":50.0,"char_plate":55.0}
static func data(s)->Dictionary:
 if not s.surface.has("energy90"):s.surface.energy90={"energy":100.0,"awake":0.0,"full":0.0,"drink":0.0,"comfort":0.0,"rested":0.0}
 return s.surface.energy90
static func status(s)->String:
 var awake=float(data(s).awake)
 return "Exhausted" if awake>=7200 else "Very tired" if awake>=5400 else "Tired" if awake>=3600 else "Rested"
static func food_factor(s)->float:
 return {"Rested":1.0,"Tired":.75,"Very tired":.5,"Exhausted":.25}[status(s)]
static func recovery(s,id:String)->float:
 return minf(100-float(data(s).energy),float(MEALS.get(id,0))*food_factor(s))
static func spend(s,amount:float):
 var d=data(s);d.energy=maxf(0,float(d.energy)-maxf(0,amount)*(.95 if d.comfort>0 or d.rested>0 else 1.0))
static func speed(s)->float:
 return .8 if data(s).energy<=0 else 1.0
static func tick(s,dt:float):
 var d=data(s);d.awake+=dt
 for key in ["full","drink","comfort","rested"]:d[key]=maxf(0,float(d[key])-dt)
static func eat(s,id:String)->bool:
 var d=data(s);var gain=recovery(s,id)
 if not MEALS.has(id) or d.full>0 or gain<=0 or not s.pay({id:1}):return false
 d.energy=minf(100,float(d.energy)+gain);d.full=120.0
 return true
static func ale(s)->bool:
 var d=data(s)
 if d.drink>0 or not s.pay({"hold_ale":1}):return false
 d.drink=300.0;d.comfort=300.0
 return true
static func rest(s,nap:bool=false):
 var d=data(s)
 if nap:
  d.energy=minf(100,float(d.energy)+35);d.awake=maxf(0,float(d.awake)-1800)
 else:
  d.energy=100.0;d.awake=0.0;d.rested=600.0;d.full=0.0;d.drink=0.0;d.comfort=0.0
static func meter()->ProgressBar:
 var bar=ProgressBar.new()
 var back=StyleBoxFlat.new();back.bg_color=Color("263e46")
 var fill=StyleBoxFlat.new();fill.bg_color=Color("cfac68")
 bar.add_theme_stylebox_override("background",back);bar.add_theme_stylebox_override("fill",fill)
 return bar
static func panel(g):
 var d=data(g.state)
 g.label(g.panel_body,"Energy · %d / 100 · %s" % [int(d.energy),status(g.state)],22)
 var bar=meter();bar.value=d.energy;bar.custom_minimum_size=Vector2(0,24);g.panel_body.add_child(bar)
 g.label(g.panel_body,"Food recovery: %d%%. At zero energy, demanding work is 20%% slower. Walking and combat stay unrestricted. Tiredness builds with active time awake; menus pause it." % int(food_factor(g.state)*100),16)
 g.small_button(g.panel_body,"Calendar & celebrations",func():g.open_panel("calendar"))
 var point=g.surface.nearest() if g.surface.active() else {}
 if point.get("action","") in ["rest","house_rest"]:
  g.button(g.panel_body,"Sleep until 08:00 · full recovery",func():g.close_panel();g.surface.start_rest(point))
  g.button(g.panel_body,"Nap for two hours · partial recovery",func():g.close_panel();g.surface.start_rest(point,true))
 else:g.label(g.panel_body,"Approach your bed for sleep or a nap. E at the bedside sleeps.",15)
 if d.full>0:g.label(g.panel_body,"Comfortably full · another meal in %d seconds" % ceili(d.full),15)
 for id in MEALS:
  if g.state.count(id)<=0:continue
  var b=g.button(g.panel_body,"Eat %s · +%.1f energy (%d carried)" % [HoldData.ITEMS[id].name,recovery(g.state,id),g.state.count(id)],func():
   if eat(g.state,id):g.save_game();g.refresh_panel())
  b.disabled=d.full>0 or recovery(g.state,id)<=0
 var drink=g.button(g.panel_body,"Drink hold ale · 5%% less work energy for 5 minutes (%d carried)" % g.state.count("hold_ale"),func():
  if ale(g.state):g.save_game();g.refresh_panel())
 drink.disabled=d.drink>0 or g.state.count("hold_ale")==0
 if d.drink>0:g.label(g.panel_body,"Enjoy your tankard · next drink in %d seconds" % ceili(d.drink),15)
 g.label(g.panel_body,"Meals replenish energy; alcohol provides comfort. Neither removes physical tiredness. Sleep fully restores you; a nap restores 35 energy and eases tiredness.",16)
 if d.rested>0:g.label(g.panel_body,"Well Rested · 5%% less work energy for %d seconds (does not stack with ale)" % ceili(d.rested),15)
