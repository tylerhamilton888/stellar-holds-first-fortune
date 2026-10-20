extends "res://tests/input_handworks49.gd"
func run():
 g=load("res://main.tscn").instantiate();root.add_child(g);g.set_process(false);g.skip_arrival=true;g.start_game(false);settle()
 g.state.opening=4;HoldOnboarding.ensure(g.state).fresh=false;g.state.claim_id="old_delving";g.surface.enter("claim");settle()
 var h=g.handworks
 for k in ["wood","stone","iron"]:g.state.add(k,100)
 at(Vector2(940,650));h.build("stone_pile",Vector2(840,600));h.build("store",Vector2(1040,600))
 at(Vector2(1160,530));h.build("timber_pile",Vector2(1160,480))
 at(Vector2(1060,840));h.build("cart",Vector2(1060,820))
 at(Vector2(1000,610));await snap("07-stock-empty")
 var d=h.data();var stone=d.facilities[0];var pallet=d.facilities[1];var timber=d.facilities[2];var cart=d.facilities[3]
 for count in [6,12]:
  for f in [stone,timber]:
   while f.raw.size()<count:
    h.spawn("stone" if f==stone else "log",g.player,1,"visual-stock")
    d.carry.append(d.loose.pop_back());h.deposit(f)
  pallet.cargo={"stone":count*10,"wood":count*5}
  while cart.raw.size()<mini(count,8):
   h.spawn("stone" if cart.raw.size()%2==0 else "log",g.player,1,"visual-cart")
   d.carry.append(d.loose.pop_back());h.deposit(cart)
  await snap("08-stock-half" if count==6 else "09-stock-full")
 at(Vector2(1060,870));await snap("10-stock-cart-full")
 check(stone.raw.size()==12 and timber.raw.size()==12 and cart.raw.size()==8,"Raw racks and cart contain full advertised capacity")
 h.spawn("stone",g.player,1,"overflow");d.carry.append(d.loose.pop_back())
 check(h.deposit(stone)==0 and d.carry.size()==1 and stone.raw.size()==12,"Full rack leaves thirteenth load on shoulder without loss")
 d.carry.clear();h.withdraw(stone)
 check(stone.raw.size()==11 and d.carry.size()==1,"Withdrawal removes exactly one displayed raw record")
 g.save_game();g.start_game(true);settle();h=g.handworks
 check(h.data().facilities[0].raw.size()==11 and h.data().facilities[2].raw.size()==12 and h.data().facilities[3].raw.size()==8,"Full pile and vehicle quantities survive reload")
 print("STOCK49: ",passed," passed / ",failed," failed")
 g.playing=false;g.queue_free();await process_frame;quit(1 if failed else 0)
