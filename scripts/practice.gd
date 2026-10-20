class_name HoldPractice
extends RefCounted
const A=preload("res://scripts/art.gd")
static func allowed(g)->bool:
 return g.room_id=="training" and HoldOnboarding.ensure(g.state).accepted.has("training")
static func draw_room(n:Node2D,t:float):
 var texture=HoldInteriors.HEARTHS;var scale=800.0/texture.get_width()
 A.rect(n,0,0,960,540,"12232d")
 n.draw_texture_rect_region(texture,Rect2(80,410-422*scale,800,502*scale),Rect2(0,900,texture.get_width(),502))
 HoldScenery.platform(n)
 if HoldNpcPresence.inside(n.state,"borin","training"):A.dwarf(n,Vector2(810,410),t,false,-1,0,false,n.state.npc("borin"))
 A.rect(n,165,218,610,112,Color(.04,.09,.13,.94))
 A.line(n,Vector2(165,218),Vector2(775,218),"9d875e",1)
 A.text(n,Vector2(180,245),"PADDED PRACTICE BAY",20)
 A.text(n,Vector2(180,270),"F: axe & shield   LMB: strike   RMB: guard   Q: dodge",15)
 A.text(n,Vector2(180,292),"No injuries or stamina cost. E at the bench reviews your progress.",14)
 for x in range(460,710,35):A.rect(n,x,407,13,3,"b29a6c")
 var f=HoldOnboarding.ensure(n.state).facts
 A.text(n,Vector2(180,317),"Blows %d/3   Guard %d/1   Dodge %d/1" % [mini(3,int(f.get("practice_hit",0))),mini(1,int(f.get("practice_guard",0))),mini(1,int(f.get("practice_dodge",0)))],16,Color("b4e0c5"))
static func draw_target(g,e:Dictionary):
 var p=e.p;var reset=g.A.draw_offset
 HoldItemArt.draw(g,Rect2(p.x-23,p.y-64,46,64),7,Color("b0a28c"))
 A.rect(g,p.x-28,p.y-8,56,8,"525f60");A.rect(g,p.x-23,p.y-62,46,5,"c7a367")
 g.draw_circle(p+Vector2(0,-42),17,Color("3c3932"));g.draw_circle(p+Vector2(0,-42),13,Color("a57a47"));g.draw_circle(p+Vector2(0,-42),6,Color("d9bb86"))
 A.rune(g,p+Vector2(0,-42),.4,Color("84cdb9"))
 var angle=-1.2*(1-clampf(e.timer/.7,0,1)) if e.state=="windup" else 0.0
 var origin=p+Vector2(0,-46)
 g.draw_set_transform(origin+reset,0,Vector2(e.face,1))
 var tip=Vector2(56,0).rotated(angle)
 A.line(g,Vector2.ZERO,tip,"6e7775",7);A.line(g,Vector2.ZERO,tip,"bb9561",3)
 A.rect(g,tip.x-8,tip.y-11,16,22,"624b39");A.rect(g,tip.x-6,tip.y-9,12,18,"b9aa88")
 for y in [-5,2]:A.line(g,tip+Vector2(-6,y),tip+Vector2(6,y),"e0cfab",1)
 g.draw_set_transform(reset)
 if e.state=="windup":A.text(g,p+Vector2(-8,-87),"!",23,Color("f2cf87"))
