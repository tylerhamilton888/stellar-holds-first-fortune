class_name HoldQuarters
extends RefCounted
# The starting room uses the existing furnishing catalogue and saved surface records.
const PLANS=["pantry","hearth_table","hearth","chair","lamp","table","tea_table","chest","bookcase","desk","bed"]
static func panel(g):
 g.button(g.panel_body,"Hearth & Homestead · meals and comfort",func():g.open_panel("hearth"))
 var local=g.surface.area=="room:home"
 g.label(g.panel_body,"A hearth to come home to",21,Color("edc98a"))
 var facts=g.state.surface.facts
 var comforts=[]
 for task in [[facts.get("quarters_rest",HoldOnboarding.ensure(g.state).get("settle_bed",false)),"Rest"],[facts.get("quarters_storage",false),"Store supplies"],[HoldLetters.sent(g.state),"Write home"],[facts.get("quarters_build",false),"Furnish"]]:
  comforts.append(("✓ " if task[0] else "○ ")+task[1])
 g.label(g.panel_body,"   ·   ".join(comforts),15,Color("d8d5c6"))
 g.label(g.panel_body,"E uses your bed, chest or writing desk. O opens these plans.",14)
 var actions=g.row(g.panel_body)
 g.small_button(actions,"Wardrobe & name",func():g.open_creator(false))
 g.small_button(actions,"Work journal",func():g.open_panel("commission"))
 if HoldLetters.sent(g.state):g.small_button(actions,"Read your letter",func():g.open_panel("letter"))
 g.label(g.panel_body,"Furnish your quarters",19,Color("edc98a"))
 g.label(g.panel_body,"Green fits · red is blocked · right click cancels. Materials come from your pack.",14)
 if not local:g.label(g.panel_body,"Return to your Keldrath quarters to place or move furnishings here.",14)
 var grid=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",10);grid.add_theme_constant_override("v_separation",8);g.panel_body.add_child(grid)
 for kind in PLANS:
  var id=str(kind);var item=HoldFurnishings.ITEMS[id];var geometry=HoldFurnishings.geometry(id)
  var b=g.small_button(grid,item.title+"\n"+HoldFurnishings.cost_text(id),func():g.surface.start_placement(id))
  var icon=AtlasTexture.new();icon.atlas=HoldFurnishings.ATLAS;icon.region=HoldFurnishings.CROPS[geometry.art]
  b.icon=icon;b.expand_icon=true;b.add_theme_constant_override("icon_max_width",44);b.custom_minimum_size=Vector2(290,66);b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  b.disabled=not local or not g.state.afford(item.cost)
  b.tooltip_text="Craft & place "+item.title+". Materials are spent only after a valid placement."
 var edits=g.row(g.panel_body)
 var move=g.small_button(edits,"Move a furnishing",g.surface.move_nearby_furnishing);move.disabled=not local
 var recover=g.small_button(edits,"Recover a furnishing",g.surface.recover_decor);recover.disabled=not local
 g.label(g.panel_body,"Stand beside something you placed to move it for free or recover its materials. The hold's original furnishings remain in place.",14)

 g.small_button(g.panel_body,"Fill canteens · courtyard pump",func():
  if g.state.count("water")>=30:g.notify("You already have 30 canteens. Plenty for now.")
  else:g.state.add("water",mini(6,30-g.state.count("water")));g.save_game();g.notify("Fresh water drawn from the hold's well.")
  g.refresh_panel())
