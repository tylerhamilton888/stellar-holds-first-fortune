from pathlib import Path
import shutil
root=Path('.')
backup=root/'tools/quality39/before'
backup.mkdir(exist_ok=True)
for f in (root/'scripts').glob('*.gd'):
 if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
# The throne portrait is never a world actor.
p=root/'scripts/royal_hall.gd';s=p.read_text();s=s.replace('const LORD=preload', 'const SPRITE=preload("res://assets/royal-v39/eirik.png")\nconst LORD=preload')
s=s.replace(' # The throne is on the upper dais. Beard tips rest on that same stone plane.\n n.draw_texture_rect_region(LORD,Rect2(555,164,266,240),Rect2(33,14,1265,1141))', ' # A normal-scale world actor, with the painted royal portrait reserved for dialogue.\n n.draw_texture_rect_region(SPRITE,Rect2(590,275,103,135),Rect2(174,79,944,1237))')
s=s.replace('Vector2(652,300)','Vector2(639,410)');p.write_text(s)
# Action drawing, palm, and tool all use the same pose and scale, including mid-air strikes.
p=root/'scripts/character_art.gd';s=p.read_text();s=s.replace('or p.get("air_pose",0)>0:', 'or (p.get("air_pose",0)>0 and not working):')
a=s.index(' if reach<0:return TOOL_GRIPS[kind]');b=s.index('static func tool_transform',a)
s=s[:a]+' # Fixed source-space grip. A nearby target must never move the handle out of the fist.\n return TOOL_GRIPS[kind]\n'+s[b:]
s=s.replace('kind:int,facing:int=1)->Transform2D:', 'kind:int,facing:int=1,zoom:float=1.0)->Transform2D:')
s=s.replace('Vector2(facing,1)*[36.0,40.0,35.0,33.0][kind]/local.length()', 'Vector2(facing,1)*zoom*[36.0,40.0,35.0,33.0][kind]/local.length()')
s=s.replace('facing:int=1,reach:float=-1):', 'facing:int=1,reach:float=-1,zoom:float=1.0):')
s=s.replace('tool_transform(origin,end,kind,facing)', 'tool_transform(origin,end,kind,facing,zoom)')
s=s.replace('pos+work_hand(f,p)*Vector2(facing,1),pos+work_end(f,p,3 if p.outfit==2 else 0)*Vector2(facing,1),3 if p.outfit==2 else 0,reset,facing)', 'pos+work_hand(f,p)*Vector2(facing,1)*zoom,pos+work_end(f,p,3 if p.outfit==2 else 0)*Vector2(facing,1)*zoom,3 if p.outfit==2 else 0,reset,facing,-1,zoom)')
s=s.replace('draw_grip(n,pos,f,p,facing,reset)', 'draw_grip(n,pos,f,p,facing,reset,tint,false,zoom)')
s=s.replace('var original=texture.get_image();var fingers', 'var original=texture.get_image();var materials=HoldCharacterMaterials.mask_for(HoldCharacterDesigns.id(p)+"-normal-"+str(f),original.get_width(),original.get_height());var fingers')
s=s.replace('pixel.a>.45 and pixel.h>.015 and pixel.h<.10 and pixel.s>.22', 'pixel.a>.015 and materials[source.y*original.get_width()+source.x]==3')
p.write_text(s)
p=root/'scripts/main.gd';s=p.read_text()
a=s.index(' var hand=HoldCharacterArt.work_hand(frame,state.appearance)',s.index('func draw_tool():'));b=s.index('\nfunc draw_title():',a)
s=s[:a]+''' var scale=character_scale()
 var hand=HoldCharacterArt.work_hand(frame,state.appearance)*scale
 var origin=player+hand*Vector2(face,1)
 var direction=(HoldCharacterArt.work_end(frame,state.appearance,tool)-HoldCharacterArt.work_hand(frame,state.appearance)).normalized()*Vector2(face,1)
 # Aim by rotating around the grip. Neither tool size nor grip position changes with range.
 var weight=[0.0,0.0,0.0,0.0,1.0,.65,.2,0.0][frame]
 if origin.distance_to(hit_point)>1:
  direction=Vector2.from_angle(lerp_angle(direction.angle(),(hit_point-origin).angle(),weight))
 var end=origin+direction*[36.0,40.0,35.0,33.0][tool]*scale
 HoldCharacterArt.draw_tool(self,origin+A.draw_offset,end+A.draw_offset,tool,A.draw_offset,face,-1,scale)
 HoldCharacterArt.draw_grip(self,player+A.draw_offset,frame,state.appearance,face,A.draw_offset,character_tint(player),false,scale)
''' +s[b:]
s=s.replace('return room_id=="" and state.active_site=="hold" and zone in ["hub","approach","mine"]','return false # Expeditions are connected by the map table, not hidden scene seams.')
s=s.replace('"name":"Lower workings — east through the gate","panel":"mine"','"name":"Expedition map table","panel":"expedition"')
s=s.replace('notify("Follow the trail east into the workings; walk west to Keldrath.");return','open_panel("basin_map");return')
s=s.replace('if state.active_site=="hold":notify("Walk west through the mouth to the mountain trail.");return','if state.active_site=="hold":\n   if can_region_travel():open_panel("basin_map")\n   else:notify("Return to the entrance map board to set out. V builds your way back.")\n   return')
s=s.replace('if closest.panel=="mine":','if closest.panel=="expedition":\n   if can_region_travel():open_panel("basin_map")\n   else:notify(region_travel_hint())\n  elif closest.panel=="mine":')
s=s.replace('elif closest.panel=="travel_claim":','elif closest.panel=="gate" and zone=="hub":\n   if can_region_travel():open_panel("basin_map")\n   else:notify(region_travel_hint())\n  elif closest.panel=="travel_claim":')
s=s.replace('The mine is east, past the survey office.', 'Use the expedition map table to set out for Old Workings.')
s=s.replace('← Return west to Keldrath · ', 'Return to the entrance map board · ')
s=s.replace('HIGH TRAIL: Follow the mountain approach east to the mine mouth. G opens regional travel on solid ground.', 'HIGH TRAIL: A sheltered lookout. G opens the basin map; choose Old Workings to enter the mountain.')
s=s.replace('The foreman', 'The foreman')
p.write_text(s)
p=root/'scripts/character_designs.gd';s=p.read_text().replace('REVISION=38','REVISION=39');p.write_text(s)
