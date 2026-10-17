class_name HoldNpcPresence
extends RefCounted
# One physical place per resident. Rendering and interaction consult this same registry.
# Future schedules must replace a resident's place here, never add a second drawing.
const HOMES={
 "hedrik":{"room":"tavern","x":410,"label":"Inside the Copper Kettle"},
 "orla":{"room":"market","x":685,"label":"Inside Orla's exchange"},
 "borin":{"room":"forge","x":970,"label":"Inside Borin's forge"},
 "ivar":{"room":"commission","x":1205,"label":"Inside the foreman's office"},
 "eldric":{"room":"research","x":1780,"label":"Inside the survey office"},
 "eirik":{"room":"throne","x":1205,"label":"Inside the King's Hall, Crownward"}}
static func room_for(state:HoldState,id:String)->String:
 if state.resident_visits.has(id):return state.resident_visits[id]
 if HOMES.has(id):return HOMES[id].room
 if id=="brann":return "" if state.worker else "tavern"
 if HoldOutpost.has_member(state,id):return "" if state.outpost.crew.has(id) else "tavern"
 return ""
static func inside(state:HoldState,id:String,room:String)->bool:
 return room!="" and state.active_site=="hold" and room_for(state,id)==room

static func tavern_guests(state:HoldState)->Array:
 HoldOutpost.ensure(state)
 var result=[]
 for id in HoldOutpost.CREW:
  if inside(state,id,"tavern"):result.append(id)
  if result.size()==3:break
 return result
