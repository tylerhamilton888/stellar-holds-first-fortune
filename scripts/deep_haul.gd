class_name DeepHaul
extends RefCounted
# Cargo uses existing item IDs. Exactly one owner: bucket, equipment, pile or inventory.
# Personal cargo follows the player across sites. Fixed equipment belongs to its mine.
const BUCKET=64
const CART=320
const CART_COST={"wood":6,"iron":2}
const BULK=["rough_block","dressed_stone","stone","iron_ore","copper_ore","coal","iron_slag","copper_slag"]
var s
var w:Deepworks
var data:Dictionary
func _init(state,world:Deepworks):
 s=state;w=world
 if s.hauling.is_empty():s.hauling={"bucket":{},"project":"cart"}
 if not w.data.has("haulage"):w.data.haulage={"cart":{},"piles":{}}
 data=w.data.haulage
static func amount(cargo:Dictionary)->int:
 var n=0
 for k in cargo:n+=int(cargo[k])
 return n
static func transfer(source:Dictionary,dest:Dictionary,capacity:int=2147483647)->int:
 var moved=0;var room=maxi(0,capacity-amount(dest))
 for k in source.keys():
  var n=mini(int(source[k]),room)
  if n<=0:continue
  source[k]=int(source[k])-n;dest[k]=int(dest.get(k,0))+n;room-=n;moved+=n
  if int(source[k])==0:source.erase(k)
 return moved
func bucket()->Dictionary:return s.hauling.bucket
func cart()->Dictionary:return data.cart
func cart_pos()->Vector2:return Vector2(cart().get("x",0),cart().get("y",0))
func near_cart(p:Vector2)->bool:
 return not cart().is_empty() and int(cart().depth)==w.depth() and p.distance_to(cart_pos())<100 and w.visible(p,cart_pos())
func pile_id(c:Vector2i)->String:return w.link_key(c,w.depth())
func pile(c:Vector2i,marked:bool=false)->Dictionary:
 var id=pile_id(c)
 if not data.piles.has(id):data.piles[id]={"x":c.x,"y":c.y,"depth":w.depth(),"cargo":{},"marked":marked}
 if marked:data.piles[id].marked=true
 return data.piles[id]
func collect(item:String,n:int,p:Vector2)->String:
 if n<=0:return ""
 if item not in BULK:s.add(item,n);return "pack"
 var incoming={item:n}
 if near_cart(p):transfer(incoming,cart().cargo,CART)
 transfer(incoming,bucket(),BUCKET)
 if not incoming.is_empty():transfer(incoming,pile(Deepworks.cell(p)).cargo);return "cached at your feet"
 return "wheelbarrow" if near_cart(p) else "bucket"
func build_cart(p:Vector2)->bool:
 if not cart().is_empty() or w.solid(p) or not s.pay(CART_COST):return false
 data.cart={"x":p.x,"y":p.y,"depth":w.depth(),"cargo":{},"hitched":false}
 return true
func toggle_cart(p:Vector2)->String:
 if not near_cart(p):return "Stand beside your wheelbarrow. Build one on the haulage board [H]."
 cart().hitched=not cart().hitched
 return "Wheelbarrow in hand. It follows your path and connected stairs." if cart().hitched else "Wheelbarrow parked. Nearby mining loads it automatically."
func follow(p:Vector2):
 if cart().is_empty() or not cart().hitched:return
 # The cart's collision anchor shares the dwarf's clear footprint; no trailing corner cuts.
 if int(cart().depth)!=w.depth() or cart_pos().distance_to(p)>140:cart().hitched=false;return
 cart().x=p.x;cart().y=p.y
func stairs(p:Vector2,old_depth:int):
 if not cart().is_empty() and cart().hitched and int(cart().depth)==old_depth and cart_pos().distance_to(p)<100:
  cart().depth=w.depth();cart().x=p.x;cart().y=p.y
func park():
 if not cart().is_empty():cart().hitched=false
func scavenge(p:Vector2)->int:
 var moved=0
 for a in data.piles.values():
  if a.marked or int(a.depth)!=w.depth():continue
  var q=Deepworks.center(Vector2i(a.x,a.y))
  if p.distance_to(q)>85 or not w.visible(p,q):continue
  if near_cart(p):moved+=transfer(a.cargo,cart().cargo,CART)
  moved+=transfer(a.cargo,bucket(),BUCKET)
 return moved
func unload(p:Vector2)->String:
 if w.entrance(p):
  var n=transfer(bucket(),s.inventory)
  if near_cart(p):n+=transfer(cart().cargo,s.inventory)
  return "Delivered %d units to the hold stores. Ready for crafting and trade." % n
 if near_cart(p):
  var n=transfer(bucket(),cart().cargo,CART)
  return "Loaded %d units into the wheelbarrow (%d / %d)." % [n,amount(cart().cargo),CART]
 var a=pile(Deepworks.cell(p),true)
 var n=transfer(bucket(),a.cargo)
 return "Cached %d units in this marked stockpile. H opens stockpile loading." % n
func load_pile(p:Vector2)->int:
 var n=0
 for a in data.piles.values():
  if int(a.depth)!=w.depth():continue
  var q=Deepworks.center(Vector2i(a.x,a.y))
  if p.distance_to(q)>85 or not w.visible(p,q):continue
  if near_cart(p):n+=transfer(a.cargo,cart().cargo,CART)
  n+=transfer(a.cargo,bucket(),BUCKET)
 return n
func cache_cart(p:Vector2)->int:
 if not near_cart(p):return 0
 return transfer(cart().cargo,pile(Deepworks.cell(p),true).cargo)
func in_field(item:String)->int:
 var n=int(bucket().get(item,0))
 for site in s.deepworks.values():
  var h=site.get("haulage",{});n+=int(h.get("cart",{}).get("cargo",{}).get(item,0))
  for a in h.get("piles",{}).values():n+=int(a.cargo.get(item,0))
 return n
static func contents(cargo:Dictionary)->String:
 return "empty" if cargo.is_empty() else HoldData.cost_text(cargo)
func project()->Dictionary:
 var chosen=str(s.hauling.get("project","cart"))
 if chosen in ["bench","anvil","rune"]:return {"name":LivingWorks.FURNITURE[chosen].name,"cost":LivingWorks.FURNITURE[chosen].cost,"money":0,"panel":"living"}
 if chosen=="stoneworking":return {"name":"Stoneworking research","cost":HoldData.RESEARCH.stoneworking.cost,"money":15,"panel":"research"}
 match chosen:
  "steel":return {"name":"Tempered steel research"+(" · complete" if s.tech.has("extraction") else ""),"cost":{} if s.tech.has("extraction") else HoldData.RESEARCH.extraction.cost,"money":35,"panel":"research"}
  "iron":return {"name":"Smelt iron ingot","cost":HoldData.RECIPES.iron.cost,"money":0,"panel":"forge"}
  "assembly":return {"name":"Starship drive assembly","cost":HoldData.RECIPES.assembly.cost,"money":0,"panel":"forge"}
 return {"name":"Wheelbarrow"+(" · built" if not cart().is_empty() else ""),"cost":{} if not cart().is_empty() else CART_COST,"money":0,"panel":"haulage"}
