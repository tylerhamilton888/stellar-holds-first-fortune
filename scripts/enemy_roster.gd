class_name HoldEnemyRoster
extends RefCounted
# Stable numeric IDs: 0 and 1 retain old goblin/beetle saves and wounds.
const SPECS=[
 {"name":"Goblin cutthroat","hp":64.0,"damage":16.0,"speed":105.0,"reach":88.0,"windup":.60,"recover":.70,"angle":.9,"body":12.0,"height":58.0,"armor":0.0,"loot":{"scrap":3,"copper_ore":2}},
 {"name":"Ironback beetle","hp":84.0,"damage":16.0,"speed":60.0,"reach":88.0,"windup":1.05,"recover":1.0,"angle":.9,"body":14.0,"height":64.0,"armor":.2,"loot":{"shell":2,"iron_ore":2}},
 {"name":"Orc ironbreaker","hp":112.0,"damage":22.0,"speed":72.0,"reach":104.0,"windup":.95,"recover":1.0,"angle":.85,"body":17.0,"height":80.0,"armor":.25,"loot":{"scrap":4,"iron_ore":3}},
 {"name":"Cave troll","hp":220.0,"damage":34.0,"speed":48.0,"reach":138.0,"windup":1.4,"recover":1.5,"angle":.70,"body":26.0,"height":110.0,"armor":0.0,"loot":{"stone":8,"iron_ore":4,"crystal":1}}
]
const GOBLIN=preload("res://assets/enemies84/goblin.png")
const ORC=preload("res://assets/enemies84/orc.png")
const TROLL=preload("res://assets/enemies84/troll.png")
# Measured whole silhouettes; generated sheets are deliberately not treated as equal cells.
const RECTS={
 0:[
  [Rect2(65,110,151,198),Rect2(302,114,147,197),Rect2(549,111,159,198),Rect2(807,81,169,223),Rect2(1042,148,222,161),Rect2(1292,208,197,106)],
  [Rect2(58,427,144,201),Rect2(306,422,151,206),Rect2(535,426,197,201),Rect2(816,389,159,242),Rect2(1044,470,245,160),Rect2(1304,532,183,105)],
  [Rect2(57,737,181,203),Rect2(310,736,146,209),Rect2(539,737,197,202),Rect2(811,697,151,246),Rect2(1032,768,256,176),Rect2(1306,843,188,103)]
 ],
 2:[
  [Rect2(56,117,182,195),Rect2(309,115,176,203),Rect2(551,115,181,204),Rect2(793,75,148,244),Rect2(1014,139,225,177),Rect2(1288,207,213,111)],
  [Rect2(49,433,191,207),Rect2(288,426,194,212),Rect2(522,425,212,196),Rect2(794,380,147,261),Rect2(998,449,253,190),Rect2(1289,532,214,104)],
  [Rect2(51,744,194,203),Rect2(290,748,202,203),Rect2(546,741,196,209),Rect2(800,688,146,261),Rect2(1011,761,238,189),Rect2(1259,831,240,128)]
 ],
 3:[
  [Rect2(40,130,190,198),Rect2(296,126,195,207),Rect2(545,116,208,218),Rect2(814,66,163,263),Rect2(1044,139,211,192),Rect2(1287,203,214,131)],
  [Rect2(39,449,167,198),Rect2(289,435,204,214),Rect2(548,435,190,213),Rect2(817,376,161,270),Rect2(1058,463,214,186),Rect2(1288,526,219,116)],
  [Rect2(48,767,225,197),Rect2(295,751,220,210),Rect2(539,742,227,221),Rect2(819,688,183,275),Rect2(1051,761,220,201),Rect2(1290,828,223,133)]
 ],
}
# Measured planted-foot anchors; raised weapons never determine the ground position.
const ROOTS={
 0:[
  [Vector2(141.7,297.6),Vector2(374.3,297.8),Vector2(634.9,296.0),Vector2(888.3,291.9),Vector2(1138.4,296.9),Vector2(1380.6,299.0)],
  [Vector2(126.4,616.2),Vector2(380.3,616.3),Vector2(637.6,615.2),Vector2(892.3,619.0),Vector2(1135.6,618.2),Vector2(1392.9,620.8)],
  [Vector2(132.4,927.7),Vector2(383.0,930.9),Vector2(637.5,928.8),Vector2(885.6,930.0),Vector2(1130.7,930.7),Vector2(1399.1,930.2)]
 ],
 2:[
  [Vector2(129.1,301.9),Vector2(386.3,306.2),Vector2(627.0,306.8),Vector2(872.9,308.7),Vector2(1091.7,298.1),Vector2(1389.2,291.5)],
  [Vector2(120.9,627.5),Vector2(379.9,625.2),Vector2(631.4,608.5),Vector2(875.9,629.0),Vector2(1084.8,621.7),Vector2(1393.0,614.5)],
  [Vector2(122.8,934.6),Vector2(384.7,938.0),Vector2(636.2,939.2),Vector2(875.5,935.9),Vector2(1093.1,932.5),Vector2(1378.2,935.3)]
 ],
 3:[
  [Vector2(136.9,318.1),Vector2(385.1,322.1),Vector2(656.5,320.6),Vector2(904.8,315.0),Vector2(1139.0,302.6),Vector2(1398.5,303.7)],
  [Vector2(123.6,631.1),Vector2(373.6,636.5),Vector2(624.8,636.0),Vector2(919.8,633.2),Vector2(1161.1,628.2),Vector2(1393.5,620.5)],
  [Vector2(155.3,950.2),Vector2(381.0,949.7),Vector2(640.8,951.4),Vector2(932.3,947.0),Vector2(1160.1,940.7),Vector2(1403.7,939.6)]
 ],
}
static func spec(kind:int)->Dictionary:return SPECS[clampi(kind,0,SPECS.size()-1)]
static func row(direction:Vector2)->int:
 if absf(direction.x)>absf(direction.y)*1.8:return 1
 return 2 if direction.y<0 else 0
static func frame(e:Dictionary)->int:
 if e.hp<=0:return 5
 if e.state=="windup":return 3
 if e.state=="recover" and e.time>float(spec(e.kind).recover)-.22:return 4
 if e.walk:return [1,0,2,0][int(e.gait*10)%4]
 return 0
static func draw(g,e:Dictionary):
 var kind=int(e.kind);var r=row(e.dir);var f=frame(e)
 var source:Rect2=RECTS[kind][r][f];var anchor:Vector2=ROOTS[kind][r][f]
 var scale=float(spec(kind).height)/[194.0,1.0,191.0,194.0][kind]
 var tint=Color(1.3,1.2,1.1) if e.flash>0 else Color.WHITE
 if e.hp<=0:tint.a=clampf(float(e.get("dead_time",0))/.7,0,1)
 g.draw_set_transform(e.p-g.camera.round(),0,Vector2(-1 if e.dir.x<0 else 1,1))
 g.draw_texture_rect_region(GOBLIN if kind==0 else ORC if kind==2 else TROLL,Rect2((source.position-anchor)*scale,source.size*scale),source,tint)
 g.draw_set_transform(-g.camera.round())
