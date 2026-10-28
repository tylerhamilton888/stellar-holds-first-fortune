class_name HoldCalendar
extends RefCounted
# Saved game time only. Seasons never destroy crops, close services or expire quests.
const MINUTES_PER_SECOND=.6
const SEASONS=["Spring","Summer","Autumn","Winter"]
const WEEK=["Stone","Ember","Iron","Gold","Hearth","Ale","Ancestor"]
const HOLIDAYS=[
 {"id":"first_hearth","name":"First Hearth","season":0,"day":7,"food":"barley_bread","story":"Fresh bread is broken for every household, old and new. Your host raises a tankard: May every returning boot find a warm hearth."},
 {"id":"forgefire","name":"Forgefire","season":1,"day":14,"food":"char_plate","story":"Smiths toast the hands behind every tool, from the youngest apprentice to the oldest master. Your host calls for a tankard to honest work, and another to a sound edge."},
 {"id":"barleywake","name":"Barleywake","season":2,"day":21,"food":"root_hotpot","story":"The harvest tables fill with roots, bread and the new barley brew. Your host toasts the growers, haulers and brewers who keep a hold fed."},
 {"id":"ancestors","name":"Ancestor's Vigil","season":3,"day":26,"food":"fish_chowder","story":"Names of the departed are spoken beside the hearth. A place is kept for those far from home. Your host raises a quiet tankard to those who built the road beneath your feet."}]
static var glow:GradientTexture2D
static func data(s)->Dictionary:
 if not s.surface.has("calendar91"):s.surface.calendar91={"day":0,"minute":480.0,"events":{}}
 return s.surface.calendar91
static func date(day:int)->String:
 return "%s %d · Year %d" % [SEASONS[posmod(day,112)/28],posmod(day,28)+1,day/112+1]
static func clock_text(s)->String:
 var m=int(data(s).minute)
 return "%02d:%02d" % [m/60,m%60]
static func phase(s)->String:
 var m=float(data(s).minute)
 return "Dawn" if m>=300 and m<480 else "Day" if m>=480 and m<1080 else "Dusk" if m>=1080 and m<1260 else "Night"
static func holiday(day:int)->Dictionary:
 for h in HOLIDAYS:
  var start=int(h.season)*28+int(h.day)-1
  if posmod(day,112)>=start and posmod(day,112)<start+3:return h
 return {}
static func key_for(day:int,h:Dictionary)->String:return "%d:%s" % [day/112+1,h.id]
static func record_events(s,first:int,last:int):
 var d=data(s)
 for year in range(first/112,last/112+1):
  for h in HOLIDAYS:
   var start=year*112+int(h.season)*28+int(h.day)-1
   if start+2<first or start>last:continue
   var key=key_for(year*112,h)
   if not d.events.has(key):d.events[key]={"id":h.id,"year":year+1,"joined":false}
static func advance(s,minutes:float):
 if minutes<0:return
 var d=data(s);var before=int(d.day);var total=float(d.minute)+minutes
 d.day=before+int(floor(total/1440));d.minute=fposmod(total,1440)
 record_events(s,before,int(d.day))
static func tick(g,dt:float):
 var before=int(data(g.state).day);advance(g.state,maxf(0,dt)*MINUTES_PER_SECOND)
 if data(g.state).day!=before:
  var h=holiday(data(g.state).day)
  g.notify(date(data(g.state).day)+(" · "+h.name+" · Calendar has the festivities" if not h.is_empty() else " · A new day in the hold"))
static func sleep_minutes(s,nap:bool=false)->float:
 if nap:return 120.0
 var m=float(data(s).minute)
 return 480-m if m<480 else 1920-m
static func pass_time(g,minutes:float):
 # Advance passive timers in small steps so each queued recipe completes once.
 # No actors, attacks, handwork, hazards or movement are simulated during sleep.
 advance(g.state,minutes)
 var left=minutes/MINUTES_PER_SECOND
 while left>0:
  var step=minf(1,left);g.state.tick(step);left-=step
 var reserve=HoldWorkEnergy.data(g.state)
 for key in ["full","drink","comfort","rested"]:reserve[key]=maxf(0,float(reserve[key])-minutes/MINUTES_PER_SECOND)
static func rest(g,nap:bool=false):pass_time(g,sleep_minutes(g.state,nap))
static func rest_notice(s,nap:bool=false)->String:
 var h=holiday(data(s).day)
 return ("Nap complete · " if nap else "Slept well · ")+date(data(s).day)+" · "+clock_text(s)+(" · "+h.name if not h.is_empty() else "")
static func feast_near(g)->bool:
 if not g.surface.active():return false
 var p=Vector2(365,470) if g.surface.area=="room:tavern" else Vector2(400,525)
 return g.surface.area in ["room:tavern","room:wayfarer"] and g.player.distance_to(p)<=85 and g.surface.clear_interaction(g.player,p)
static func definition(id:String)->Dictionary:
 for h in HOLIDAYS:
  if h.id==id:return h
 return {}
static func join(g,key:String)->bool:
 var d=data(g.state)
 if not d.events.has(key) or d.events[key].joined or not feast_near(g):return false
 d.events[key].joined=true
 var reserve=HoldWorkEnergy.data(g.state)
 if reserve.full<=0:
  reserve.energy=minf(100,float(reserve.energy)+30*HoldWorkEnergy.food_factor(g.state));reserve.full=120.0
 reserve.comfort=maxf(float(reserve.comfort),300.0)
 return true
static func pending(s)->int:
 var total=0
 for e in data(s).events.values():
  if not e.joined:total+=1
 return total
static func panel(g):
 var d=data(g.state);advance(g.state,0)
 if g.calendar_page<0:g.calendar_page=int(d.day)/28
 var season=posmod(g.calendar_page,4);var year=g.calendar_page/4+1
 var nav=g.row(g.panel_body)
 var prev=g.small_button(nav,"‹ Previous",func():g.calendar_page=maxi(0,g.calendar_page-1);g.refresh_panel());prev.disabled=g.calendar_page==0
 g.small_button(nav,"Today · "+date(d.day),func():g.calendar_page=int(d.day)/28;g.calendar_selected=int(d.day);g.refresh_panel())
 g.small_button(nav,"Next ›",func():g.calendar_page+=1;g.refresh_panel())
 g.small_button(nav,"Feasts · %d waiting" % pending(g.state),func():g.open_panel("festivals"))
 g.label(g.panel_body,"%s · Year %d    |    Now %s · %s" % [SEASONS[season],year,clock_text(g.state),phase(g.state)],21)
 var grid=GridContainer.new();grid.columns=7;grid.add_theme_constant_override("h_separation",5);grid.add_theme_constant_override("v_separation",4);g.panel_body.add_child(grid)
 for day_name in WEEK:
  var label=g.label(grid,day_name,14,Color("b7cfc6"));label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.custom_minimum_size.x=96
 for day in range(28):
  var absolute=g.calendar_page*28+day;var h=holiday(absolute)
  var b=g.small_button(grid,str(day+1)+("  ★" if not h.is_empty() else "")+(" · today" if absolute==int(d.day) else ""),func():g.calendar_selected=absolute;g.refresh_panel())
  b.alignment=HORIZONTAL_ALIGNMENT_CENTER;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL;b.toggle_mode=true;b.button_pressed=absolute==g.calendar_selected
  b.tooltip_text=date(absolute)+(": "+h.name if not h.is_empty() else "")
  if absolute==int(d.day):b.add_theme_color_override("font_color",Color("355d54"))
 if g.calendar_selected>=0 and g.calendar_selected/28==g.calendar_page:
  var selected=holiday(g.calendar_selected)
  g.label(g.panel_body,date(g.calendar_selected)+(": "+selected.name if not selected.is_empty() else " · A day for your own plans"),17,Color("edc98a"))
  if not selected.is_empty():g.label(g.panel_body,selected.story,15)
 var h=HOLIDAYS[season]
 g.label(g.panel_body,"★ %s · %s %d–%d. Share a toast and feast at the Copper Kettle or Wayfarer's Hearth." % [h.name,SEASONS[season],h.day,h.day+2],16)
 g.label(g.panel_body,"A day lasts 40 active minutes. Menus pause the clock; nothing advances while the game is closed. Sleep until 08:00 or nap for two hours. Crops and queued crafting advance while you sleep; crops never wither. Services stay open, and missed feasts remain available.",15)
static func festivals_panel(g):
 advance(g.state,0);var d=data(g.state);var h=holiday(d.day)
 g.label(g.panel_body,h.name+" · the tables are laid" if not h.is_empty() else "The hold remembers its celebrations",22)
 g.label(g.panel_body,"Approach Hedrik's welcoming table at the Copper Kettle, or the serving counter at Wayfarer's Hearth. Each celebration offers a toast, a commemorative journal entry and a little food and work comfort. There are no entry costs or missed-event penalties.",16)
 if d.events.is_empty():g.label(g.panel_body,"Your first invitation arrives on Spring 7. Open the calendar to see all four annual celebrations.",16)
 var keys=d.events.keys();keys.sort_custom(func(a,b):return int(d.events[a].year)*4+int(definition(d.events[a].id).season)>int(d.events[b].year)*4+int(definition(d.events[b].id).season))
 for key in keys:
  var event=d.events[key];var spec=definition(event.id)
  var card=g.section(g.panel_body,spec.name+" · Year "+str(event.year)+(" · Remembered" if event.joined else " · Invitation kept"))
  if event.joined:g.label(card,spec.story,16)
  else:
   var b=g.button(card,"Share the feast & toast",func():
    if join(g,key):g.save_game();g.refresh_panel())
   b.disabled=not feast_near(g)
   g.label(card,"Available at either host, even after the holiday. A meal restores up to 30 energy (less when tired); ale comfort lasts five minutes and does not stack with Well Rested.",15)
 g.button(g.panel_body,"Open calendar",func():g.open_panel("calendar"))
static func night(s)->float:
 var m=float(data(s).minute)
 return 1-smoothstep(300,480,m) if m<720 else smoothstep(1080,1260,m)
static func sky_color(g)->Color:
 if g.zone=="mine" or not g.surface.active() or g.surface.room() or g.surface.architecture.interior() or g.surface.area in ["hearthward","crownward","forgeward"]:return Color.TRANSPARENT
 var n=night(g.state);var m=float(data(g.state).minute)
 var warm=maxf(0,1-absf(m-390)/90) if m<720 else maxf(0,1-absf(m-1170)/90)
 return Color(.035,.07,.20,.42*n).lerp(Color(.77,.36,.16,.18),warm*.65)
static func light_texture()->GradientTexture2D:
 if glow==null:
  var gradient=Gradient.new();gradient.colors=PackedColorArray([Color(1,.71,.29,.24),Color(1,.63,.21,0)])
  glow=GradientTexture2D.new();glow.gradient=gradient;glow.width=128;glow.height=128;glow.fill=GradientTexture2D.FILL_RADIAL;glow.fill_from=Vector2(.5,.5);glow.fill_to=Vector2(1,.5)
 return glow
static func lighting(g,objects:Array):
 g.draw_set_transform(Vector2.ZERO)
 var sky=sky_color(g)
 if sky.a>0:g.draw_rect(Rect2(0,48,960,450),sky)
 var strength=maxf(night(g.state),.7 if not holiday(data(g.state).day).is_empty() else 0)
 if strength>0:
  for o in objects:
   var kind=str(o.get("furnishing",o.get("kind","")))
   if kind not in ["lamp","road_lantern","hearth"]:continue
   var p:Vector2=o.p-g.camera.round()+Vector2(0,-30 if kind!="road_lantern" else -65)
   if Rect2(-90,48,1140,450).has_point(p):g.draw_texture_rect(light_texture(),Rect2(p-Vector2(65,65),Vector2(130,130)),false,Color(1,1,1,strength))
 g.draw_set_transform(-g.camera.round())
static func decorate(g,o:Dictionary):
 if g.surface.area not in ["room:tavern","room:wayfarer"]:return
 var h=holiday(data(g.state).day)
 if h.is_empty() or str(o.get("furnishing",o.get("kind",""))) not in ["tea_table","hearth_table","serving_counter"]:return
 # Existing, player-available food and tankards on existing tables, in depth order.
 for i in 2:
  var item=h.food if i==0 else "hold_ale"
  HoldItemArt.draw(g,Rect2(o.p+Vector2(-22+i*27,-45),Vector2(19,17)),HoldItemArt.item_index(item))
static func fixture(g,index:int):
 if not g.dev.active():return
 var d=data(g.state);d.day=int(HOLIDAYS[index].season)*28+int(HOLIDAYS[index].day)-1;d.minute=1080.0;d.events={};advance(g.state,0)
 g.save_game();g.close_panel()
