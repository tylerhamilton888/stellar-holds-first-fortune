extends "res://tests/support/game_fixture.gd"

func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.skip_arrival=true;g.start_game(false);settle()
 g.state.add("wood",2);g.state.add("stone",2);g.open_panel("inventory")
 var before=g.state.inventory.duplicate(true)
 var search=g.panel.find_child("PackSearch",true,false)
 var scope=g.panel.find_child("PackScope",true,false)
 var category=g.panel.find_child("PackCategory",true,false)
 search.text="TIMBER";search.text_changed.emit(search.text)
 check(g.pack_selection=="wood","Search selects the first visible result")
 search.text="no match";search.text_changed.emit(search.text)
 check(g.pack_selection=="" and not g.panel.find_child("PackScroll",true,false).visible,"No results clears the inspector")
 search.text="";search.text_changed.emit(search.text);scope.select(1);scope.item_selected.emit(1);category.select(1);category.item_selected.emit(1)
 var grid=g.panel.find_child("PackGrid",true,false)
 check(grid.get_children().filter(func(b):return b.visible).size()==4,"Seed catalogue contains all four seed kinds")
 var icons={}
 for id in HoldData.ITEMS:
  check(HoldPlayerBook.item_group(id)!="Other" and HoldPlayerBook.item_use(id)!="",id+" has a category and a use")
 for id in HoldItemArt.SUPPLIES:
  var art=HoldItemArt.supply_icon(HoldItemArt.SUPPLIES.find(id))
  check(art!=null and not icons.has(art.region),id+" has its own painted tile")
  icons[art.region]=true
 check(g.state.inventory==before,"Filters and catalogue leave inventory unchanged")
 print("CATALOGUE ",passed," passed / ",failed," failed")
 quit(1 if failed else 0)
