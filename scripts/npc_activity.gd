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
 var action=(frame+.1)/8.0
 var hand=p+HoldDirectional.hand(profile,Vector2(facing,.45),action,zoom)
 var head=contact if frame==4 else contact+Vector2(-14,-32)*absf(.5-action)*2
 HoldCharacterArt.draw_tool(n,hand+offset,head+offset,3,offset,facing,-1,zoom)
 n.draw_circle(hand,2.5*zoom,Color(HoldAppearance.SKIN_COLORS[profile.get("skin",0)]))
 if frame==4:
  var a=fposmod(t,.2)/.2
  for i in 3:
   var q=contact+Vector2((i-1)*9*a,-sin(a*PI)*7)*zoom
   A.line(n,q,q+Vector2(i-1,-2)*zoom,Color(1,.75,.38,(1-a)*.7),zoom)

static func sip_amount(t:float)->float:
 var phase=fposmod(t,22.0)
 if phase<12 or phase>=18:return 0.0
 return smoothstep(12.0,14.0,phase) if phase<14 else (1.0 if phase<16 else 1.0-smoothstep(16.0,18.0,phase))
static func social(n:Node2D,p:Vector2,t:float,facing:int,profile:Dictionary,drinking:bool):
 if not drinking:
  A.dwarf(n,p,t,false,facing,0,false,profile);return
 var sip=sip_amount(t);var angle=sip*2.4
 var zoom=n.character_scale() if n.has_method("character_scale") else 1.0
 var offset=A.draw_offset
 HoldDirectional.draw(n,p+offset,profile,Vector2(facing,.45),false,t,zoom,offset,-1,angle)
 var hand=HoldDirectional.hand(profile,Vector2(1,.45),-1,1.0,angle)
 if tankard_texture==null:
  tankard_texture=AtlasTexture.new();tankard_texture.atlas=TANKARD;tankard_texture.region=TANKARD.get_image().get_used_rect()
 # Grip stays anchored through a dedicated lift, sip pause and gentle lowering.
 var grip=p+hand*Vector2(facing,1)*zoom
 n.draw_set_transform(grip+offset,.12*sip*facing,Vector2(-facing,1)*zoom)
 var width=18.0;var height=width*tankard_texture.get_height()/tankard_texture.get_width()
 n.draw_texture_rect(tankard_texture,Rect2(Vector2(-15,-8),Vector2(width,height)),false)
 n.draw_circle(Vector2.ZERO,2.2,Color(HoldAppearance.SKIN_COLORS[profile.get("skin",0)]))
 n.draw_set_transform(offset)
