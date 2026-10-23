class_name HoldHouseholds
extends RefCounted
# Household identity is authored presentation; saved room IDs and residents stay put.
const FIRST_NAMES={"crownward":["Bjarne","Astrid","Halvar"],"hearthward":["Oskar","Freya","Sten"],"forgeward":["Einar","Bodil","Haldor"]}
const LOFT="room:kettle_loft"
const ARCHIVE="room:clan_archive"
const KETTLE_STAIR=Vector2(725,550)
const NOTES=[
 "Bjarne Granitehand keeps the old stonecutters' measures. His family tends the royal masonry; the archive across the north street records every generation that carried the mountain.",
 "Astrid Copperbraid keeps a welcoming table for the court's late shifts. The family cloths are mended here, and a warm meal waits before the household turns in upstairs.",
 "Halvar Deepmantle checks the family freight ledgers by lamplight. The survey office measures a new route; the exchange finds the provisions to walk it.",
 "Oskar Granitehand is proud of work that lasts. His hearth is built from offcuts his family saved, dressed and fitted over many years. Nothing sound is wasted.",
 "Freya Copperbraid's hearth smells of supper. The family gathers around one table after the Copper Kettle closes, with pantry shelves close to the cooking fire.",
 "Sten Deepmantle keeps the road accounts at home. Timber, food and lamp oil keep this hold alive as surely as iron. King's Gate leads to Stonebridge and the farms beyond.",
 "Einar Granitehand hangs his tools clear of the family table. The forge is his workplace; this hearth is where the noise of the Iron Terrace becomes a distant hum.",
 "Bodil Copperbraid keeps the lower gallery warm and well supplied. Thick walls and covered ventilation separate the family's rooms from the working furnaces.",
 "Haldor Deepmantle checks each delivery before it reaches the lift. The family's old manifests record stone carried upward and finished tools sent out through the gate."
]
static func index(area:String)->int:
 var p=HoldNeighborhood.parts(area);return HoldWorldZones.WARDS.find(p[0])*3+int(p[1])
static func name_for(ward:String,i:int)->String:return FIRST_NAMES[ward][i]+" "+HoldNeighborhood.FAMILIES[i]
static func title(area:String)->String:
 var p=HoldNeighborhood.parts(area)
 return name_for(p[0],int(p[1]))+" household · "+("upper rooms" if p[2]=="1" else "family hearth")
static func family_objects(w,area:String)->Array:
 var p=HoldNeighborhood.parts(area);var n=index(area);var i=int(p[1]);var result=[]
 if p[2]=="1":
  var bed=Vector2([300,350,310][i],425)
  result=[w.furn("double_bed",bed.x,bed.y),w.furn("lamp",bed.x-75,360),w.furn("chest",bed.x+100,490),w.furn("desk",[570,575,555][i],355),w.furn("bookcase",[270,620,260][i],560)]
  if n in [0,4,8]:result.append(w.furn("bed",[465,530,470][i],420))
  if n in [1,5,6]:result.append(w.furn("chair",580,420))
  result.append(w.furn("lamp",745,330));return result
 var arrangements=[
  [["hearth",300,345],["desk",605,370],["bookcase",420,335],["bookcase",495,335],["tea_table",405,475],["chair",353,491],["chair",457,491],["bookcase",265,560]],
  [["hearth",650,345],["counter",340,365],["tea_table",355,485],["chair",303,501],["chair",407,501],["worktable",535,380],["bookcase",260,560]],
  [["hearth",660,345],["desk",365,370],["bookcase",260,335],["bookcase",490,335],["tea_table",550,485],["chair",498,501],["chair",602,501]],
  [["hearth",330,345],["worktable",580,365],["bookcase",720,340],["tea_table",380,480],["chair",328,496],["chair",432,496],["desk",270,560]],
  [["hearth",650,345],["counter",345,370],["bookcase",260,335],["tea_table",465,475],["chair",413,491],["chair",517,491],["bookcase",265,560]],
  [["hearth",305,345],["desk",605,370],["bookcase",450,335],["bookcase",725,335],["tea_table",360,485],["chair",308,501],["chair",412,501],["chest",610,490]],
  [["hearth",650,345],["training_rack",290,350],["worktable",440,370],["tea_table",360,480],["chair",308,496],["chair",412,496],["bookcase",260,560]],
  [["hearth",310,345],["counter",580,365],["bookcase",725,335],["tea_table",475,480],["chair",423,496],["chair",527,496],["bookcase",270,560]],
  [["hearth",650,345],["desk",350,370],["bookcase",260,335],["chest",520,370],["tea_table",540,485],["chair",488,501],["chair",592,501],["bookcase",260,560]]
 ]
 for item in arrangements[n]:result.append(w.furn(item[0],item[1],item[2]))
 result.append_array([w.furn("lamp",220,305),w.furn("lamp",745,330)])
 return result
static func special_objects(w,area:String)->Array:
 if area==LOFT:return [w.furn("double_bed",325,425),w.furn("lamp",250,355),w.furn("chest",390,540),w.furn("desk",590,365),w.furn("bookcase",260,555),w.furn("tea_table",500,490),w.furn("chair",448,506),w.furn("chair",552,506),w.furn("lamp",745,330)]
 if area==ARCHIVE:return [w.furn("bookcase",260,345),w.furn("bookcase",335,345),w.furn("bookcase",410,345),w.furn("bookcase",680,345),w.furn("desk",590,390),w.furn("orrery",310,490),w.furn("tea_table",595,520),w.furn("chair",543,536),w.furn("chair",647,536),w.furn("lamp",220,305),w.furn("lamp",745,330)]
 return []
static func points(s)->Array:
 var area=s.area
 if area=="room:tavern":return [{"p":KETTLE_STAIR,"name":"Stair · Hedrik and Orla's quarters","action":LOFT}]
 if area==LOFT:return [{"p":KETTLE_STAIR,"name":"Stair · Copper Kettle","action":"room:tavern"},{"p":Vector2(590,400),"name":"The Copperkettle household","action":"household_note:couple"}]
 if area==ARCHIVE:return [{"p":Vector2(590,425),"name":"Read the hold's household register","action":"household_note:archive"}]
 if HoldNeighborhood.is_home(area) and HoldNeighborhood.parts(area)[2]=="0":return [{"p":Vector2(450,565),"name":"About the "+title(area),"action":"household_note:"+str(index(area))}]
 return []
static func note(id:String)->String:
 if id=="couple":return "Hedrik and Orla Copperkettle share this home above the inn. One broad oak bed, two pillows, and a quiet table together after the shutters close."
 if id=="archive":return "THE HALL OF NAMES. Nine family hearths span the Kin Galleries, each keeping its own history within the Granitehand, Copperbraid and Deepmantle clans. The Crownward court bears the mountain, Hearthward feeds its Folk, and Forgeward keeps its works alive. The Stone Must Bear. The Work Must Flow. The Folk Must Flourish."
 var i=int(id);return NOTES[i] if i>=0 and i<NOTES.size() else ""
static func dressing(w,area:String):
 if HoldNeighborhood.is_home(area):
  var p=HoldNeighborhood.parts(area);var i=int(p[1])
  if p[2]=="1":HoldRoomLayout.rug(w,Rect2(235,350,250,120),Color("526e69"))
  else:
   var table=family_objects(w,area).filter(func(o):return o.furnishing=="tea_table")[0].p
   HoldRoomLayout.rug(w,Rect2(table+Vector2(-85,-48),Vector2(170,100)),Color("8b7153") if p[0]=="hearthward" else Color("526e69"))
 elif area==LOFT:HoldRoomLayout.rug(w,Rect2(245,345,180,130),Color("526e69"));HoldRoomLayout.rug(w,Rect2(415,445,170,95),Color("8b7153"))
 elif area==ARCHIVE:HoldRoomLayout.rug(w,Rect2(510,345,165,240),Color("526e69"))
