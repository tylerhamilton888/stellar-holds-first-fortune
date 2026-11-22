extends RefCounted
# Save slots 5..7 belong to lateral districts. A physical depth is one-based.
const Court=preload("res://court/first_court.gd")
const BOTTOM = 50
const BANDS = ["Iron Beds", "Pillar Limestone", "Crystal Fault", "Buried Foundries", "Pressure Vaults"]
const START = [6, 12, 21, 31, 41]
const TINT = [Color("ffe6c7"), Color("dbecd3"), Color("c4e8ef"), Color("f6c7b2"), Color("d7c8fa")]
# Each site occupies a particular cavern; its tools and salvage tell the same story.
const SITES = {
 10: ["Assayers’ weighing room", "worktable", {"iron":3, "copper":2}],
 16: ["Masons’ abandoned yard", "stone_pillar", {"dressed_basalt":8, "tool_fittings":1}],
 20: ["The bridgewright’s forge", "anvil", {"forged_pickhead":1, "iron":5}],
 27: ["Crystal survey station", "orrery", {"crystal":6, "parts":2}],
 30: ["Memorial of the last survey", "oath_stone", {"crystal":8, "copper":6}],
 36: ["The buried regulator", "pressure_manifold", {"parts":4, "energy_cell":4}],
 40: ["The master founder’s hearth", "royal_brazier", {"assembly":1, "parts":4}],
 45: ["Deep pressure observatory", "orrery", {"assembly":2, "energy_cell":8}],
 50: ["The first hold’s throne room", "royal_throne", {"assembly":3, "crystal":18}]
}
# Each group has deliberate spacing around a usable aisle. The art catalogue
# supplies the silhouettes and physical footprints used for all player furniture.
const DRESSING = {
 10: [["chest",-58,8],["road_lantern",63,-19]],
 16: [["plinth",-66,18],["plinth",66,18]],
 20: [["hearth",-72,-12],["chest",62,12]],
 27: [["desk",-69,20],["runestone",64,-12]],
 30: [["royal_brazier",-89,10],["royal_brazier",89,10]],
 36: [["worktable",-106,10],["road_lantern",82,-17]],
 40: [["anvil",-68,18],["stone_pillar",72,-26]],
 45: [["pressure_manifold",-112,-5],["desk",91,9]],
 50: [["royal_pillar",-105,-32],["royal_pillar",105,-32],["royal_brazier",-103,59],["royal_brazier",103,59]]
}
static func number(z:int)->int:
 if z < 0 or z in [5,6,7]: return 0
 return z + 1 if z < 5 else z - 2

static func slot(n:int)->int:
 if n < 1 or n > BOTTOM: return -1
 return n - 1 if n <= 5 else n + 2

static func band(n:int)->int:
 for i in range(START.size()-1, -1, -1):
  if n >= START[i]: return i
 return 0

static func gate(w,n:int)->String:
 var s = w.state
 if n >= 6 and not s.steel: return "Forge a steel pick to cut the iron beds."
 if n >= 12 and not s.tech.has("stoneworking"): return "Research Stoneworking to brace the pillar limestone."
 if n >= 12 and s.camp_stage < 2: return "Build the workshop at your homestead to supply the braces."
 if n >= 21 and not HoldToolCapabilities.reinforced(s): return "Fit a reinforced pick to cut the crystal fault."
 if n >= 31 and HoldIndustry.tier(s) < 1: return "Commission a powered workshop at your homestead."
 if n >= 41 and HoldIndustry.tier(s) < 2: return "Install a sealed engineering bay at your homestead."
 return ""

static func seam_shift(n:int)->float:
 if n <= 5: return (n-1)*1.2
 # Continue at the same dip as D5, folding back before the far seams leave the map.
 return 4.8 + 5.8*sin((n-5)*.20)

static func seam_axis(vein:int,y:int,n:int,offset:float)->float:
 var axis=13+vein*13+sin(y*.12+vein+offset)*3+seam_shift(n)
 if n<6:return axis
 # Individual seams curve in three dimensions. Their displacement begins at
 # zero at the old boundary, so a shaft can follow a known mineral body.
 var amplitude=clampf((n-5)*.22,0,5.0)
 return axis+amplitude*sin(y*.074+n*.15+vein*1.89+offset)*cos(y*.027-n*.09+vein)

static func make_layer(seed_value:int,n:int)->Dictionary:
 var rng = RandomNumberGenerator.new()
 rng.seed = seed_value
 var offset = rng.randf_range(-2,2)
 var region = band(n)
 var cells:Array = []
 var strata:Array = []
 for y in 64:
  var axes = []
  for vein in 5:
   axes.append(seam_axis(vein,y,n,offset))
  for x in 80:
   var bedding = sin(y*.18+x*.055+n*.30+offset)
   var kind = 7 if bedding < .03+region*.12 else 2
   strata.append(kind)
   for vein in 5:
    if absf(x-axes[vein]) < (1.15+.20*region if vein==4 else 1.25):
     kind = [5,3,4,3,6][vein]
   if x==0 or y==0 or x==79 or y==63: kind=8
   cells.append(kind)
 # Caverns shift around shared axes over successive floors. Each band changes
 # their footprint; the seed controls the local curve and the precise outline.
 # Work the fold itself: a high shelf of iron, a crystal-lined fissure, a
 # driven haulage gallery and a closed geode each invite a different heading.
 var bend_y=30+roundi(4*sin(n*.16+offset))
 for x in range(11,70):
  var dip=bend_y+roundi(3*sin(x*.12+n*.18+offset))
  if region==0 and x in range(24,39):
   for dy in range(-2,3):
    if pow((x-31)/7.,2)+pow(dy/2.8,2)<1.:cells[(dip+dy)*80+x]=3
  elif region==2 and x>19 and x<58:
   cells[dip*80+x]=0
   if posmod(x+n,6)<4:cells[(dip-1)*80+x]=6
   if posmod(x+n,8)<5:cells[(dip+1)*80+x]=0
  elif region==3 and x in range(16,60):
   var haul_row=18+roundi(3*sin(n*.19+offset))
   for dy in range(-1,2):
    cells[(haul_row+dy)*80+x]=7 if dy==-1 and posmod(x,9)==0 else 0
  elif region==4:
   var lens=42+roundi(5*sin(n*.17+offset))
   for dy in range(-6,7):
    var radius=pow((x-lens)/9.,2)+pow(dy/5.,2)
    if radius<.62:cells[(bend_y+dy)*80+x]=0
    elif radius<1.05:cells[(bend_y+dy)*80+x]=6 if posmod(x+dy+n,5)!=0 else 7
 var features = []
 var layer = {"cells":cells,"strata":strata,"damage":{},"seen":{},"features":features,"fixtures":{}}
 for pocket in 4:
  var x = 22+(pocket%2)*35+roundi(9*sin(n*.15+pocket*1.7+offset)+4*cos(n*.26+pocket*2.7-offset))
  var y = 18+floori(pocket/2.)*28+roundi(7*cos(n*.16+pocket*2+offset))
  var size_x = [6.,10.,4.,9.,7.][region]+sin(n*.5+pocket)
  var size_y = [4.,5.,9.,4.,7.][region]
  var site = SITES.has(n) and pocket==posmod(seed_value+n,4)
  if n==50 and site:
   x=clampi(x,12,67);y=clampi(y,5,52)
   var record:Array=SITES[n]
   var seat={"x":x,"y":y,"type":0,"found":false,"name":record[0],"prop":record[1],"salvage":record[2].duplicate()}
   features.append(seat)
   continue
  if not site:
   var swell=sin(n*.21+pocket*1.8+offset)
   if swell<-.78:continue
   size_x*=.89+.29*swell
   size_y*=1.02+.25*cos(n*.24+pocket)
  for cy in range(y-12,y+13):
   for cx in range(x-13,x+14):
    if cx<=0 or cy<=0 or cx>=79 or cy>=63: continue
    var dx = cx-x
    var dy = cy-y
    var outline = Vector2((dx+sin(dy*.36+offset)*1.4+dy*.36*sin(n*.2+pocket+offset))/size_x,dy/size_y).length()
    if site and region>=3: outline=maxf(absf(dx)/size_x,absf(dy)/size_y)
    var wall = 1.+.10*sin(cx*.73+cy*.54+n*.21)
    var index = cy*80+cx
    if outline < wall:
     if region==1 and absi(dx)==5 and absi(dy)<=1: continue
     cells[index]=0
    elif outline < wall+.18 and sin(cx*.7+cy*.35+offset)>.28:
     cells[index]=[3,4,6,3,6][region]
  if site:
   var record:Array=SITES[n]
   features.append({"x":x,"y":y,"type":0,"found":false,"name":record[0],"prop":record[1],"salvage":record[2].duplicate()})
 if not features.is_empty():
  if n==50:Court.install(layer,features[0])
  elif n==36:Court.Regulator.install(layer,features[0])
 return layer
