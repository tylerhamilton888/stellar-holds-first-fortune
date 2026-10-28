class_name HoldEquipment93
extends RefCounted
# Stable instances live beside legacy type keys, which still select art/combat roles.
const MATERIALS={"axe":"Iron & oak","hammer":"Iron & brass","gun":"Iron & copper","clothes":"Woven cloth","mail":"Riveted iron","rune":"Iron, copper & crystal"}
const EXTRA={"axe":{"iron":3,"coal":2},"hammer":{"iron":3,"coal":2,"parts":1},"gun":{"iron":2,"copper":2,"parts":1},"mail":{"iron":3,"coal":2},"rune":{"iron":3,"crystal":1,"parts":1}}
static func spec(kind:String)->Dictionary:
 return HoldCombat.WEAPONS.get(kind,HoldCombat.ARMOR.get(kind,{}))
static func slot(kind:String)->String:return "weapon" if HoldCombat.WEAPONS.has(kind) else "armor"
static func ensure(c:Dictionary)->Dictionary:
 var raw=c.get("gear93",{})
 if not raw is Dictionary:raw={}
 var items=[];var ids={};var n=maxi(1,int(raw.get("next",1)))
 var records=raw.get("items",[])
 if records is Array:
  for entry in records:
   if not entry is Dictionary:continue
   var kind=str(entry.get("kind",""));var id=str(entry.get("id",""))
   if spec(kind).is_empty() or id=="" or ids.has(id):continue
   ids[id]=true
   items.append({"id":id,"kind":kind,"grade":1 if int(entry.get("grade",0))==1 and kind!="clothes" else 0})
 # Old saves and existing developer presets retain every owned type exactly once.
 for kind in c.owned:
  if spec(kind).is_empty():continue
  if items.any(func(e):return e.kind==kind):continue
  var id="legacy_"+kind
  while ids.has(id):id+="_"
  items.append({"id":id,"kind":kind,"grade":0});ids[id]=true
 for item in items:
  if not item.kind in c.owned:c.owned.append(item.kind)
 var equipped=raw.get("equipped",{})
 if not equipped is Dictionary:equipped={}
 for key in ["weapon","armor"]:
  var selected=items.filter(func(e):return e.id==str(equipped.get(key,"")) and e.kind==c[key])
  if selected.is_empty():
   var matches=items.filter(func(e):return e.kind==c[key])
   equipped[key]=matches[0].id if not matches.is_empty() else ""
 c.gear93={"items":items,"equipped":equipped,"next":n}
 return c.gear93
static func find(c:Dictionary,id:String)->Dictionary:
 for item in ensure(c).items:
  if item.id==id:return item
 return {}
static func equipped(c:Dictionary,key:String)->Dictionary:
 var d=ensure(c)
 var item=find(c,str(d.equipped[key]))
 return item if not item.is_empty() else {"kind":c[key],"grade":0}
static func stats(item:Dictionary)->Dictionary:
 var result=spec(item.kind).duplicate(true)
 if int(item.grade)==1:
  if slot(item.kind)=="weapon":result.damage=int(result.damage)+6
  else:result.reduction=float(result.reduction)+.08
 return result
static func title(item:Dictionary)->String:
 return ("Tempered " if int(item.grade)==1 else "")+str(spec(item.kind).name)
static func equip(g,id:String)->bool:
 var item=find(g.state.combat,id)
 if item.is_empty():return false
 var key=slot(item.kind);g.state.combat[key]=item.kind;g.state.combat.gear93.equipped[key]=id
 g.combat.reset_actions();g.save_game();return true
static func cost(kind:String,grade:int)->Dictionary:
 var result=spec(kind).get("cost",{}).duplicate(true)
 if kind=="axe":result={"iron":3,"wood":2}
 if grade==1:
  for key in EXTRA.get(kind,{}):result[key]=int(result.get(key,0))+int(EXTRA[kind][key])
 return result
static func reason(g,kind:String,grade:int)->String:
 if spec(kind).is_empty() or kind=="clothes" or grade not in [0,1]:return "No forge recipe"
 if not HoldOnboarding.combat_ready(g.state) and not HoldPractice.allowed(g):return "Complete Borin’s training first"
 if g.room_id!="forge":return "Visit Borin’s workbench"
 if g.state.active_site=="hold" and g.state.opening<2:return "Relight the forge first"
 var tech=str(spec(kind).tech)
 if (grade==1 or tech=="metallurgy") and not g.state.tech.has("metallurgy"):return "Research "+HoldData.RESEARCH.metallurgy.name
 return g.requirements(cost(kind,grade))
static func forge(g,kind:String,grade:int)->String:
 if reason(g,kind,grade)!="Ready":return ""
 var d=ensure(g.state.combat)
 if not g.state.pay(cost(kind,grade)):return ""
 var id="gear_"+str(d.next)
 while d.items.any(func(e):return e.id==id):d.next+=1;id="gear_"+str(d.next)
 d.next+=1;d.items.append({"id":id,"kind":kind,"grade":grade})
 if not kind in g.state.combat.owned:g.state.combat.owned.append(kind)
 equip(g,id);g.sound.effect("build");return id
static func comparison(c:Dictionary,item:Dictionary)->String:
 var key=slot(item.kind);var value=stats(item);var current=stats(equipped(c,key))
 if key=="weapon":return "%d damage (%+d) · %.2fs attack · %d reach" % [value.damage,int(value.damage)-int(current.damage),value.time,value.reach]
 return "%d%% protection (%+d points)" % [roundi(value.reduction*100),roundi((value.reduction-current.reduction)*100)]
static func panel(g):
 var c=g.state.combat;var d=ensure(c)
 if g.gear_tab!="forge":g.label(g.panel_body,"%d owned pieces · Compared with equipped gear · Combat costs no energy" % d.items.size(),14)
 var tabs=g.row(g.panel_body)
 for key in ["weapon","armor","forge"]:
  var b=g.small_button(tabs,{"weapon":"Weapons","armor":"Armor","forge":"Forge gear"}[key],func():g.gear_tab=key;g.open_panel("equipment",false))
  b.toggle_mode=true;b.button_pressed=g.gear_tab==key;b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 if g.gear_tab=="forge":forge_panel(g);return
 var grid=GridContainer.new();grid.columns=2;grid.size_flags_horizontal=Control.SIZE_EXPAND_FILL;grid.add_theme_constant_override("h_separation",12);grid.add_theme_constant_override("v_separation",10);g.panel_body.add_child(grid)
 for item in d.items:
  if slot(item.kind)!=g.gear_tab:continue
  var selected=d.equipped[g.gear_tab]==item.id
  var body=card(g,grid,title(item));body.get_parent().custom_minimum_size.x=390;body.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
  g.label(body,MATERIALS[item.kind]+" · "+("Tempered" if item.grade==1 else "Standard")+" · #"+item.id.trim_prefix("gear_").trim_prefix("legacy_"),14)
  g.label(body,comparison(c,item),15)
  var b=g.small_button(body,"Equipped" if selected else "Equip "+title(item),func():if equip(g,item.id):g.refresh_panel())
  b.disabled=selected;b.tooltip_text=spec(item.kind).get("desc","Protects against unblocked damage. No movement penalty.")
static func forge_panel(g):
 var pick=g.row(g.panel_body)
 for kind in ["axe","hammer","gun","mail","rune"]:
  var b=g.small_button(pick,{"axe":"Axe","hammer":"Hammer","gun":"Carbine","mail":"Mail","rune":"Harness"}[kind],func():g.gear_recipe=kind;g.refresh_panel())
  b.toggle_mode=true;b.button_pressed=g.gear_recipe==kind
 var grid=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",12);g.panel_body.add_child(grid)
 for grade in [0,1]:
  var item={"kind":g.gear_recipe,"grade":grade}
  var body=card(g,grid,"Standard" if grade==0 else "Tempered · Precision forging")
  body.get_parent().custom_minimum_size.x=390;body.get_parent().size_flags_horizontal=Control.SIZE_EXPAND_FILL
  g.label(body,title(item),17);g.label(body,comparison(g.state.combat,item),15)
  g.label(body,"Materials: "+HoldData.cost_text(cost(item.kind,grade)),15)
  var why=reason(g,item.kind,grade);g.label(body,why,15)
  var b=g.small_button(body,"Forge & equip",func():if forge(g,item.kind,grade)!="":g.refresh_panel())
  b.disabled=why!="Ready";b.name="Forge_"+str(grade);b.tooltip_text="Make and equip a new piece; keep your previous gear."
 if g.room_id!="forge":g.small_button(g.panel_body,"Track Borin",func():g.state.tracked_npc="borin";g.save_game();g.open_panel("wayfinding"))

static func card(g,parent:Node,heading:String)->VBoxContainer:
 var body=g.section(parent,"");body.add_theme_constant_override("separation",4)
 var style=body.get_parent().get_theme_stylebox("panel").duplicate();style.set_content_margin_all(8);body.get_parent().add_theme_stylebox_override("panel",style)
 g.label(body,heading,16)
 return body
