class_name HoldNpcActivity
extends RefCounted
const A=preload("res://scripts/art.gd")
const ANVIL=preload("res://assets/anniversary-v31/anvil.png")

static func smith_frame(t:float)->int:
 # Two measured blows, followed by a long inspection pause. Contact is frame 4.
 var phase=fposmod(t,12.0)
 if phase>=3.2:return -1
 return clampi(int((fposmod(phase,1.6)+.00001)/.2),0,7)

static func struck_between(before:float,after:float)->bool:
 if after-before>.5:return false
 for cycle in range(int(before/12),int(after/12)+1):
  for beat in [.8,2.4]:
   var contact=cycle*12+beat
   if before<contact and after>=contact:return true
 return false

static func smith(n:Node2D,p:Vector2,t:float,lit:bool):
 var profile=n.state.npc("borin");var facing=-1
 var zoom=n.character_scale() if n.has_method("character_scale") else 1.0
 var offset=A.draw_offset;var frame=smith_frame(t) if lit else -1
 var contact=p+HoldCharacterArt.work_end(4,profile,3)*Vector2(facing,1)*zoom
 # Anvil and billet share the actual hammer contact, including the interior's scale.
 var height=p.y-contact.y;var width=height*563.0/560.0
 n.draw_texture_rect(ANVIL,Rect2(contact.x-width*.70,contact.y,width,height),false)
 A.rect(n,contact.x-6*zoom,contact.y-zoom,12*zoom,zoom,"e4a66b" if lit else "909b9a")
 A.dwarf(n,p,t,false,facing,0,false,profile,(frame+.1)/8.0 if frame>=0 else -1.0)
 if frame<0:return
 var hand=HoldCharacterArt.work_hand(frame,profile)*Vector2(facing,1)
 var end=HoldCharacterArt.work_end(frame,profile,3)*Vector2(facing,1)
 var tr=Transform2D(0,Vector2.ONE*zoom,0,p+offset)*HoldCharacterArt.tool_transform(hand,end,3,facing)
 n.draw_set_transform_matrix(tr)
 n.draw_texture_rect_region(HoldItemArt.SHEET,Rect2(-HoldCharacterArt.TOOL_GRIPS[3],HoldItemArt.REGIONS[3].size),HoldItemArt.REGIONS[3])
 n.draw_set_transform(offset)
 HoldCharacterArt.draw_grip(n,p+offset,frame,profile,facing,offset,Color.WHITE,false,zoom)
 if frame==4:
  var a=fposmod(t,.2)/.2
  for i in 3:
   var q=contact+Vector2((i-1)*9*a,-sin(a*PI)*7)*zoom
   A.line(n,q,q+Vector2(i-1,-2)*zoom,Color(1,.75,.38,(1-a)*.7),zoom)

static func social(n:Node2D,p:Vector2,t:float,facing:int,profile:Dictionary,drinking:bool):
 var phase=fposmod(t,22.0)
 if not drinking:
  A.dwarf(n,p,t,false,facing,0,false,profile);return
 # Existing complete-body raised-hand poses retain the same face, hair and feet.
 # The mug is attached to the palm and the original fingers are drawn over its handle.
 var resting=phase<12 or phase>18
 var frame=1 if phase>13 and phase<16.5 else 0
 A.dwarf(n,p,t,false,facing,0,false,profile,-1.0 if resting else (frame+.1)/8.0)
 var zoom=n.character_scale() if n.has_method("character_scale") else 1.0
 var offset=A.draw_offset
 var hand=HoldCharacterArt.carry_hand(0,profile) if resting else HoldCharacterArt.work_hand(frame,profile)
 n.draw_set_transform(p+offset,0,Vector2(facing,1)*zoom)
 var x=hand.x-17;var y=hand.y-10
 A.rect(n,x-1,y-1,14,17,"332c29");A.rect(n,x,y,12,15,"815331");A.rect(n,x+2,y+2,5,11,"bf8a51");A.rect(n,x+3,y+3,2,9,"d8a76a");A.rect(n,x,y,12,2,"ead1a0")
 n.draw_arc(Vector2(x+15,y+8),3,-PI*.5,PI*.5,8,Color("d7b781"),2)
 A.rect(n,x+3,y+4,3,5,"947447")
 n.draw_set_transform(offset)
 HoldCharacterArt.draw_grip(n,p+offset,frame,profile,facing,offset,Color.WHITE,resting,zoom)
