extends SceneTree
var failed=0
func _initialize():call_deferred("run")
func run():
 for kind in 4:
  for facing in [-1,1]:
   for endpoint in [Vector2(61,-43),Vector2(48,-10),Vector2(40,-75)]:
    var hand=Vector2(22*facing,-35);var end=endpoint*Vector2(facing,1)
    var t=HoldCharacterArt.tool_transform(hand,end,kind,facing)
    if (t*Vector2.ZERO).distance_to(hand)>.001:failed+=1
    var contact=t*(HoldCharacterArt.TOOL_CONTACTS[kind]-HoldCharacterArt.TOOL_GRIPS[kind])
    # Tools keep their authored length even when the aim point is farther away.
    var expected=hand+(end-hand).normalized()*[36.0,40.0,35.0,33.0][kind]
    if contact.distance_to(expected)>.001:failed+=1
 print("TOOL CONTACTS: 24 poses, %d failures" % failed)
 quit(1 if failed else 0)
