class_name HoldRoyalHall
extends RefCounted
const A=preload("res://scripts/art.gd")
const ROOM=preload("res://assets/opening-v31/throne-room.png")
const SPRITE=preload("res://assets/folk-v54/eirik-throne.png")
const LORD=preload("res://assets/opening-v31/lord-eirik.png")
static func draw(n:Node2D,t:float,s,markers:bool=true):
 n.draw_texture_rect(ROOM,Rect2(0,-12,960,540),false)
 # Original seated actor and throne share one grounded silhouette on the dais.
 n.draw_texture_rect(SPRITE,Rect2(566,234,145,174),false)
 for i in 4:
  var h=fposmod(t*10+i*13,35)
  A.rect(n,220+sin(t+i)*3,310-h,1,2,Color(1,.72,.32,(1-h/35)*.5))
 if markers and n.has_method("character_scale"):
  HoldQuestMarkers.draw(n,Vector2(639,410),s,"eirik")
 A.text(n,Vector2(82,390),"EXIT",12,Color("dac399"))
static func portrait()->HoldPortrait:
 var p=HoldPortrait.new();p.profile=HoldAppearance.npc_profile("eirik",0)
 return p
static func panel(g):
 if HoldConversation.local(g,"eirik"):
  g.talk_id="eirik";g.talk_topic="";g.talk_line="";HoldConversation.panel(g)
 else:
  g.label(g.panel_body,"Lord Eirik receives visitors in the King's hall on Crownward.",17)
  HoldConversation.choose(g,"Track the King's hall",func():g.state.tracked_npc="eirik";g.save_game();g.close_panel())
