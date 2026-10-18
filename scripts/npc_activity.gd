class_name HoldNpcActivity
extends RefCounted
const A=preload("res://scripts/art.gd")
const TANKARD=preload("res://assets/tavern-v492/tankard.png")
static var tankard_texture:AtlasTexture
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
 var profile=n.state.npc("borin");var zoom=n.character_scale();var offset=A.draw_offset
 var f=smith_frame(t) if lit else -1
 var phase=(f+.1)/8.0 if f>=0 else 0.0
 var contact=p+Vector2(-47,-8)*zoom
 HoldDrawnAnimation.paint(n,p+offset,profile,Vector2(-1,.45),false,t,zoom,offset,"hammer",phase)
 n.draw_texture_rect(ANVIL,Rect2(contact.x-25*zoom,contact.y,51*zoom,50*zoom),false)
 A.rect(n,contact.x-6*zoom,contact.y-zoom,12*zoom,zoom,"e4a66b" if lit else "909b9a")
 if f==4:
  for i in 3:
   var q=contact+Vector2((i-1)*7,-4)*zoom
   A.line(n,q,q+Vector2(i-1,-3)*zoom,Color("e8ba6f"),zoom)

static func sip_amount(t:float)->float:
 var phase=fposmod(t,22.0)
 if phase<12 or phase>=18:return 0.0
 return smoothstep(12.0,14.0,phase) if phase<14 else (1.0 if phase<16 else 1.0-smoothstep(16.0,18.0,phase))
static func social(n:Node2D,p:Vector2,t:float,facing:int,profile:Dictionary,drinking:bool):
 if not drinking:A.dwarf(n,p,t,false,facing,0,false,profile);return
 var t22=fposmod(t,22.0)
 var frame=0
 if t22>=12 and t22<13:frame=1
 elif t22>=13 and t22<16:frame=2
 elif t22>=16 and t22<17:frame=1
 elif t22>=17 and t22<18:frame=3
 HoldDrawnAnimation.paint(n,p+A.draw_offset,profile,Vector2(facing,.45),false,t,n.character_scale(),A.draw_offset,"drink",frame)
